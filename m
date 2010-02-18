Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:24713 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754843Ab0BRL2R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Feb 2010 06:28:17 -0500
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 03/22] wl1271: Add SSID configuration for JOIN in ad-hoc
Date: Thu, 18 Feb 2010 13:25:38 +0200
Message-Id: <1266492357-462-4-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1266492357-462-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds code to extract the SSID from the beacon template used for
ad-hoc. The mac80211 currently does not provide the SSID, so this is a
workaround for that, for now.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |   10 +++-
 drivers/net/wireless/wl12xx/wl1271_main.c  |   69 +++++++++++++++++----------
 2 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index cecbae2..2803e70 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -92,7 +92,12 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 						 true);
 		} else {
 			wl1271_error("PSM entry failed, giving up.\n");
-			/* make sure the firmware goes into active mode */
+			/* FIXME: this may need to be reconsidered. for now it
+			   is not possible to indicate to the mac80211
+			   afterwards that PSM entry failed. To maximize
+			   functionality (receiving data and remaining
+			   associated) make sure that we are in sync with the
+			   AP in regard of PSM mode. */
 			ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
 						 false);
 			wl->psm_entry_retry = 0;
@@ -124,7 +129,8 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 			break;
 		}
 
-		/* make sure the firmware goes to active mode */
+		/* make sure the firmware goes to active mode - the frame to
+		   be sent next will indicate to the AP, that we are active. */
 		ret = wl1271_ps_set_mode(wl, STATION_ACTIVE_MODE,
 					 false);
 		break;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 8b46b70..a3742c8 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1549,6 +1549,23 @@ out:
 	return ret;
 }
 
+static void wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *beacon)
+{
+	u8 *ptr = beacon->data +
+		offsetof(struct ieee80211_mgmt, u.beacon.variable);
+
+	/* find the location of the ssid in the beacon */
+	while (ptr < beacon->data + beacon->len) {
+		if (ptr[0] == WLAN_EID_SSID) {
+			wl->ssid_len = ptr[1];
+			memcpy(wl->ssid, ptr+2, wl->ssid_len);
+			return;
+		}
+		ptr += ptr[1];
+	}
+	wl1271_error("ad-hoc beacon template has no SSID!\n");
+}
+
 static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif,
 				       struct ieee80211_bss_conf *bss_conf,
@@ -1566,40 +1583,17 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	if ((changed & BSS_CHANGED_BSSID) &&
-	    /*
-	     * Now we know the correct bssid, so we send a new join command
-	     * and enable the BSSID filter
-	     */
-	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
-			wl->rx_config |= CFG_BSSID_FILTER_EN;
-			memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
-			ret = wl1271_cmd_build_null_data(wl);
-			if (ret < 0) {
-				wl1271_warning("cmd buld null data failed %d",
-					       ret);
-				goto out_sleep;
-			}
-			ret = wl1271_cmd_join(wl);
-			if (ret < 0) {
-				wl1271_warning("cmd join failed %d", ret);
-				goto out_sleep;
-			}
-			set_bit(WL1271_FLAG_JOINED, &wl->flags);
-	}
-
 	if (wl->bss_type == BSS_TYPE_IBSS) {
 		/* FIXME: This implements rudimentary ad-hoc support -
 		   proper templates are on the wish list and notification
 		   on when they change. This patch will update the templates
-		   on every call to this function. Also, the firmware will not
-		   answer to probe-requests as it does not have the proper
-		   SSID set in the JOIN command. The probe-response template
-		   is set nevertheless, as the FW will ASSERT without it */
+		   on every call to this function. */
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
 
 		if (beacon) {
 			struct ieee80211_hdr *hdr;
+
+			wl1271_ssid_set(wl, beacon);
 			ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON,
 						      beacon->data,
 						      beacon->len);
@@ -1624,6 +1618,29 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		}
 	}
 
+	if ((changed & BSS_CHANGED_BSSID) &&
+	    /*
+	     * Now we know the correct bssid, so we send a new join command
+	     * and enable the BSSID filter
+	     */
+	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
+			wl->rx_config |= CFG_BSSID_FILTER_EN;
+			memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
+			ret = wl1271_cmd_build_null_data(wl);
+			if (ret < 0) {
+				wl1271_warning("cmd buld null data failed %d",
+					       ret);
+				goto out_sleep;
+			}
+
+			ret = wl1271_cmd_join(wl);
+			if (ret < 0) {
+				wl1271_warning("cmd join failed %d", ret);
+				goto out_sleep;
+			}
+			set_bit(WL1271_FLAG_JOINED, &wl->flags);
+	}
+
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			wl->aid = bss_conf->aid;
-- 
1.6.3.3

