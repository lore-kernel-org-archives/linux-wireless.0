Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54095 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957Ab1HNKRz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:55 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so2967072wyg.19
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:55 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 27/40] wl12xx: support IBSS vif type
Date: Sun, 14 Aug 2011 13:17:26 +0300
Message-Id: <1313317059-16567-28-git-send-email-eliad@wizery.com> (sfid-20110814_121800_232949_E83A3D78)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Start IBSS role when the interface type is IBSS.
As with sta role, use the dev role until the role
is started.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   33 ++++++++++++++++++++++++++++-----
 drivers/net/wireless/wl12xx/scan.c   |    9 ++++++++-
 drivers/net/wireless/wl12xx/tx.c     |    3 ++-
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 4 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9b0df66..de4b6c2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1767,12 +1767,15 @@ static u8 wl12xx_get_role_type(struct wl1271 *wl)
 	case BSS_TYPE_AP_BSS:
 		return WL1271_ROLE_AP;
 
 	case BSS_TYPE_STA_BSS:
 		return WL1271_ROLE_STA;
 
+	case BSS_TYPE_IBSS:
+		return WL1271_ROLE_IBSS;
+
 	default:
 		wl1271_error("invalid bss_type: %d", wl->bss_type);
 	}
 	return WL12XX_INVALID_ROLE_TYPE;
 }
 
@@ -1845,13 +1848,14 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 			goto power_off;
 
 		ret = wl1271_boot(wl);
 		if (ret < 0)
 			goto power_off;
 
-		if (wl->bss_type == BSS_TYPE_STA_BSS) {
+		if (wl->bss_type == BSS_TYPE_STA_BSS ||
+		    wl->bss_type == BSS_TYPE_IBSS) {
 			/*
 			 * The device role is a special role used for
 			 * rx and tx frames prior to association (as
 			 * the STA role can get packets only from
 			 * its associated bssid)
 			 */
@@ -2075,12 +2079,13 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	cancel_work_sync(&wl->recovery_work);
 }
 
 static int wl1271_join(struct wl1271 *wl, bool set_assoc)
 {
 	int ret;
+	bool is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
 
 	/*
 	 * One of the side effects of the JOIN command is that is clears
 	 * WPA/WPA2 keys from the chipset. Performing a JOIN while associated
 	 * to a WPA/WPA2 access point will therefore kill the data-path.
 	 * Currently the only valid scenario for JOIN during association
@@ -2091,13 +2096,16 @@ static int wl1271_join(struct wl1271 *wl, bool set_assoc)
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		wl1271_info("JOIN while associated.");
 
 	if (set_assoc)
 		set_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 
-	ret = wl12xx_cmd_role_start_sta(wl);
+	if (is_ibss)
+		ret = wl12xx_cmd_role_start_ibss(wl);
+	else
+		ret = wl12xx_cmd_role_start_sta(wl);
 	if (ret < 0)
 		goto out;
 
 	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		goto out;
 
@@ -3125,12 +3133,13 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 					struct ieee80211_vif *vif,
 					struct ieee80211_bss_conf *bss_conf,
 					u32 changed)
 {
 	bool do_join = false, set_assoc = false;
 	bool is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
+	bool ibss_joined = false;
 	u32 sta_rate_set = 0;
 	int ret;
 	struct ieee80211_sta *sta;
 	bool sta_exists = false;
 	struct ieee80211_sta_ht_cap sta_ht_cap;
 
@@ -3138,20 +3147,34 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		ret = wl1271_bss_beacon_info_changed(wl, vif, bss_conf,
 						     changed);
 		if (ret < 0)
 			goto out;
 	}
 
-	if ((changed & BSS_CHANGED_BEACON_INT)  && is_ibss)
+	if (changed & BSS_CHANGED_IBSS) {
+		if (bss_conf->ibss_joined) {
+			set_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags);
+			ibss_joined = true;
+		} else {
+			if (test_and_clear_bit(WL1271_FLAG_IBSS_JOINED,
+					       &wl->flags)) {
+				wl1271_unjoin(wl);
+				wl12xx_cmd_role_start_dev(wl);
+				wl12xx_roc(wl, wl->dev_role_id);
+			}
+		}
+	}
+
+	if ((changed & BSS_CHANGED_BEACON_INT) && ibss_joined)
 		do_join = true;
 
 	/* Need to update the SSID (for filtering etc) */
-	if ((changed & BSS_CHANGED_BEACON) && is_ibss)
+	if ((changed & BSS_CHANGED_BEACON) && ibss_joined)
 		do_join = true;
 
-	if ((changed & BSS_CHANGED_BEACON_ENABLED) && is_ibss) {
+	if ((changed & BSS_CHANGED_BEACON_ENABLED) && ibss_joined) {
 		wl1271_debug(DEBUG_ADHOC, "ad-hoc beaconing: %s",
 			     bss_conf->enable_beacon ? "enabled" : "disabled");
 
 		if (bss_conf->enable_beacon)
 			wl->set_bss_type = BSS_TYPE_IBSS;
 		else
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 653091a..7229eaa 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -31,12 +31,13 @@
 
 void wl1271_scan_complete_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct wl1271 *wl;
 	int ret;
+	bool is_sta, is_ibss;
 
 	dwork = container_of(work, struct delayed_work, work);
 	wl = container_of(dwork, struct wl1271, scan_complete_work);
 
 	wl1271_debug(DEBUG_SCAN, "Scanning complete");
 
@@ -56,13 +57,19 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
 		/* restore hardware connection monitoring template */
 		wl1271_cmd_build_ap_probe_req(wl, wl->probereq);
-	} else {
+	}
+
+	/* return to ROC if needed */
+	is_sta = (wl->bss_type == BSS_TYPE_STA_BSS);
+	is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
+	if ((is_sta && !test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) ||
+	    (is_ibss && !test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags))) {
 		/* restore remain on channel */
 		wl12xx_cmd_role_start_dev(wl);
 		wl12xx_roc(wl, wl->dev_role_id);
 	}
 	wl1271_ps_elp_sleep(wl);
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 1240f40..8fdffd0 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -179,13 +179,14 @@ static u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct sk_buff *skb)
 	if (wl12xx_is_dummy_packet(wl, skb))
 		return wl->system_hlid;
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
 		return wl12xx_tx_get_hlid_ap(wl, skb);
 
-	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
+	    test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags))
 		return wl->sta_hlid;
 	else
 		return wl->dev_hlid;
 }
 
 static unsigned int wl12xx_calc_packet_alignment(struct wl1271 *wl,
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 487c3c7..416d68e 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -321,12 +321,13 @@ struct wl1271_ap_key {
 	u32 tx_seq_32;
 	u16 tx_seq_16;
 };
 
 enum wl12xx_flags {
 	WL1271_FLAG_STA_ASSOCIATED,
+	WL1271_FLAG_IBSS_JOINED,
 	WL1271_FLAG_GPIO_POWER,
 	WL1271_FLAG_TX_QUEUE_STOPPED,
 	WL1271_FLAG_TX_PENDING,
 	WL1271_FLAG_IN_ELP,
 	WL1271_FLAG_ELP_REQUESTED,
 	WL1271_FLAG_PSM,
-- 
1.7.6.401.g6a319

