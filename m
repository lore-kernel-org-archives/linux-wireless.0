Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:22790 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304Ab0KXGRL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 01:17:11 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAO6H8ma012808
	for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 08:17:08 +0200
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl1271: Fix setting of the hardware connection monitoring probe-req template
Date: Wed, 24 Nov 2010 08:16:57 +0200
Message-Id: <1290579417-1382-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1290579417-1382-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1290579417-1382-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The probe-request template used in the hardware connection monitoring feature
thus far has been an empty one, without the SSID IE and without supported rate
IEs. This causes problems with some AP's.

Additionally, after connected scans, the template for connection maintenance
would remain to be the one last used for scanning - potentially incorrect.

Fix these by getting a pre-filled directed probe-request template for the
associated-to AP from mac80211.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   28 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/cmd.h    |    2 ++
 drivers/net/wireless/wl12xx/main.c   |   34 +++++++++++++++++++++-------------
 drivers/net/wireless/wl12xx/scan.c   |    4 ++++
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
 5 files changed, 58 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index f3d0541..8e438e2 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -611,6 +611,34 @@ out:
 	return ret;
 }
 
+struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
+					      struct sk_buff *skb)
+{
+	int ret;
+
+	if (!skb)
+		skb = ieee80211_ap_probereq_get(wl->hw, wl->vif);
+	if (!skb)
+		goto out;
+
+	wl1271_dump(DEBUG_SCAN, "AP PROBE REQ: ", skb->data, skb->len);
+
+	if (wl->band == IEEE80211_BAND_2GHZ)
+		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
+					      skb->data, skb->len, 0,
+					      wl->conf.tx.basic_rate);
+	else
+		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
+					      skb->data, skb->len, 0,
+					      wl->conf.tx.basic_rate_5);
+
+	if (ret < 0)
+		wl1271_error("Unable to set ap probe request template.");
+
+out:
+	return skb;
+}
+
 int wl1271_build_qos_null_data(struct wl1271 *wl)
 {
 	struct ieee80211_qos_hdr template;
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 16d1bf8..111d112 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -49,6 +49,8 @@ int wl1271_cmd_build_ps_poll(struct wl1271 *wl, u16 aid);
 int wl1271_cmd_build_probe_req(struct wl1271 *wl,
 			       const u8 *ssid, size_t ssid_len,
 			       const u8 *ie, size_t ie_len, u8 band);
+struct sk_buff *wl1271_cmd_build_ap_probe_req(struct wl1271 *wl,
+					      struct sk_buff *skb);
 int wl1271_build_qos_null_data(struct wl1271 *wl);
 int wl1271_cmd_build_klv_null_data(struct wl1271 *wl);
 int wl1271_cmd_set_default_wep_key(struct wl1271 *wl, u8 id);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 35cfcf6..2b579e0 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1807,21 +1807,21 @@ out:
 	return ret;
 }
 
-static void wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *beacon)
+static void wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
+			    int offset)
 {
-	u8 *ptr = beacon->data +
-		offsetof(struct ieee80211_mgmt, u.beacon.variable);
+	u8 *ptr = skb->data + offset;
 
 	/* find the location of the ssid in the beacon */
-	while (ptr < beacon->data + beacon->len) {
+	while (ptr < skb->data + skb->len) {
 		if (ptr[0] == WLAN_EID_SSID) {
 			wl->ssid_len = ptr[1];
 			memcpy(wl->ssid, ptr+2, wl->ssid_len);
 			return;
 		}
-		ptr += ptr[1];
+		ptr += (ptr[1] + 2);
 	}
-	wl1271_error("ad-hoc beacon template has no SSID!\n");
+	wl1271_error("No SSID in IEs!\n");
 }
 
 static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
@@ -1864,8 +1864,11 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 
 		if (beacon) {
 			struct ieee80211_hdr *hdr;
+			int ieoffset = offsetof(struct ieee80211_mgmt,
+						u.beacon.variable);
+
+			wl1271_ssid_set(wl, beacon, ieoffset);
 
-			wl1271_ssid_set(wl, beacon);
 			ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON,
 						      beacon->data,
 						      beacon->len, 0,
@@ -1945,6 +1948,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
 			u32 rates;
+			int ieoffset;
 			wl->aid = bss_conf->aid;
 			set_assoc = true;
 
@@ -1973,13 +1977,13 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 				goto out_sleep;
 
 			/*
-			 * The SSID is intentionally set to NULL here - the
-			 * firmware will set the probe request with a
-			 * broadcast SSID regardless of what we set in the
-			 * template.
+			 * Get a template for hardware connection maintenance
 			 */
-			ret = wl1271_cmd_build_probe_req(wl, NULL, 0,
-							 NULL, 0, wl->band);
+			dev_kfree_skb(wl->probereq);
+			wl->probereq = wl1271_cmd_build_ap_probe_req(wl, NULL);
+			ieoffset = offsetof(struct ieee80211_mgmt,
+					    u.probe_req.variable);
+			wl1271_ssid_set(wl, wl->probereq, ieoffset);
 
 			/* enable the connection monitoring feature */
 			ret = wl1271_acx_conn_monit_params(wl, true);
@@ -2002,6 +2006,10 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			clear_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 			wl->aid = 0;
 
+			/* free probe-request template */
+			dev_kfree_skb(wl->probereq);
+			wl->probereq = NULL;
+
 			/* re-enable dynamic ps - just in case */
 			ieee80211_enable_dyn_ps(wl->vif);
 
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index f3f2c5b..6f897b9 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -51,6 +51,10 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	wl->scan.req = NULL;
 	ieee80211_scan_completed(wl->hw, false);
 
+	/* restore hardware connection monitoring template */
+	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+		wl1271_cmd_build_ap_probe_req(wl, wl->probereq);
+
 	if (wl->scan.failed) {
 		wl1271_info("Scan completed due to error.");
 		ieee80211_queue_work(wl->hw, &wl->recovery_work);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 3c836e6..9f8aa69 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -431,6 +431,9 @@ struct wl1271 {
 	struct wl1271_scan scan;
 	struct delayed_work scan_complete_work;
 
+	/* probe-req template for the current AP */
+	struct sk_buff *probereq;
+
 	/* Our association ID */
 	u16 aid;
 
-- 
1.7.1

