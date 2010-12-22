Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:62245 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab0LVO2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Dec 2010 09:28:20 -0500
Received: by mail-ww0-f44.google.com with SMTP id 36so5334430wwa.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Dec 2010 06:28:19 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v2 09/18] wl1271: Configure AP on BSS info change
Date: Wed, 22 Dec 2010 16:27:28 +0200
Message-Id: <1293028057-6212-10-git-send-email-arik@wizery.com>
In-Reply-To: <1293028057-6212-1-git-send-email-arik@wizery.com>
References: <1293028057-6212-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Configure AP-specific beacon and probe response templates.
Start the AP when beaconing is enabled.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |  129 +++++++++++++++++++++------------
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +
 2 files changed, 85 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 05adde6..59c7fb3 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1872,7 +1872,7 @@ out:
 	return ret;
 }
 
-static void wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
+static int wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
 			    int offset)
 {
 	u8 *ptr = skb->data + offset;
@@ -1882,11 +1882,13 @@ static void wl1271_ssid_set(struct wl1271 *wl, struct sk_buff *skb,
 		if (ptr[0] == WLAN_EID_SSID) {
 			wl->ssid_len = ptr[1];
 			memcpy(wl->ssid, ptr+2, wl->ssid_len);
-			return;
+			return 0;
 		}
 		ptr += (ptr[1] + 2);
 	}
+
 	wl1271_error("No SSID in IEs!\n");
+	return -ENOENT;
 }
 
 static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
@@ -1898,73 +1900,84 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	struct wl1271 *wl = hw->priv;
 	struct ieee80211_sta *sta = ieee80211_find_sta(vif, bss_conf->bssid);
 	bool do_join = false;
-	bool set_assoc = false;
+	bool set_assoc = false, is_ap, is_ibss;
 	int ret;
 
-	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed");
+	wl1271_debug(DEBUG_MAC80211, "mac80211 bss info changed 0x%x",
+		     (int)changed);
 
 	mutex_lock(&wl->mutex);
 
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
+	is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
+	is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
+
 	ret = wl1271_ps_elp_wakeup(wl, false);
 	if (ret < 0)
 		goto out;
 
-	if ((changed & BSS_CHANGED_BEACON_INT) &&
-	    (wl->bss_type == BSS_TYPE_IBSS)) {
-		wl1271_debug(DEBUG_ADHOC, "ad-hoc beacon interval updated: %d",
+	if ((changed & BSS_CHANGED_BEACON_INT) && (is_ap || is_ibss)) {
+		wl1271_debug(DEBUG_MASTER, "beacon interval updated: %d",
 			bss_conf->beacon_int);
 
 		wl->beacon_int = bss_conf->beacon_int;
-		do_join = true;
+
+		if (!is_ap)
+			do_join = true;
 	}
 
-	if ((changed & BSS_CHANGED_BEACON) &&
-	    (wl->bss_type == BSS_TYPE_IBSS)) {
+	if ((changed & BSS_CHANGED_BEACON) && (is_ap || is_ibss)) {
+		struct ieee80211_hdr *hdr;
+		int ieoffset = offsetof(struct ieee80211_mgmt, u.beacon.variable);
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
+		u16 tmpl_id;
 
-		wl1271_debug(DEBUG_ADHOC, "ad-hoc beacon updated");
-
-		if (beacon) {
-			struct ieee80211_hdr *hdr;
-			int ieoffset = offsetof(struct ieee80211_mgmt,
-						u.beacon.variable);
-
-			wl1271_ssid_set(wl, beacon, ieoffset);
-
-			ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON,
-						      beacon->data,
-						      beacon->len, 0,
-						      wl1271_min_rate_get(wl));
-
-			if (ret < 0) {
-				dev_kfree_skb(beacon);
-				goto out_sleep;
-			}
+		if (!beacon)
+			goto end_changed_bcn;
 
-			hdr = (struct ieee80211_hdr *) beacon->data;
-			hdr->frame_control = cpu_to_le16(
-				IEEE80211_FTYPE_MGMT |
-				IEEE80211_STYPE_PROBE_RESP);
+		wl1271_debug(DEBUG_MASTER, "beacon updated");
 
-			ret = wl1271_cmd_template_set(wl,
-						      CMD_TEMPL_PROBE_RESPONSE,
-						      beacon->data,
-						      beacon->len, 0,
-						      wl1271_min_rate_get(wl));
+		ret = wl1271_ssid_set(wl, beacon, ieoffset);
+		if (ret < 0) {
 			dev_kfree_skb(beacon);
-			if (ret < 0)
-				goto out_sleep;
+			goto out_sleep;
+		}
+		tmpl_id = is_ap ? CMD_TEMPL_AP_BEACON :
+				  CMD_TEMPL_BEACON;
+		ret = wl1271_cmd_template_set(wl, tmpl_id,
+					      beacon->data,
+					      beacon->len, 0,
+					      wl1271_min_rate_get(wl));
+		if (ret < 0) {
+			dev_kfree_skb(beacon);
+			goto out_sleep;
+		}
 
-			/* Need to update the SSID (for filtering etc) */
+		hdr = (struct ieee80211_hdr *) beacon->data;
+		hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+						 IEEE80211_STYPE_PROBE_RESP);
+
+		tmpl_id = is_ap ? CMD_TEMPL_AP_PROBE_RESPONSE :
+				  CMD_TEMPL_PROBE_RESPONSE;
+		ret = wl1271_cmd_template_set(wl,
+					      tmpl_id,
+					      beacon->data,
+					      beacon->len, 0,
+					      wl1271_min_rate_get(wl));
+		dev_kfree_skb(beacon);
+		if (ret < 0)
+			goto out_sleep;
+
+		/* Need to update the SSID (for filtering etc) */
+		if (!is_ap)
 			do_join = true;
-		}
 	}
 
-	if ((changed & BSS_CHANGED_BEACON_ENABLED) &&
-	    (wl->bss_type == BSS_TYPE_IBSS)) {
+end_changed_bcn:
+
+	if ((changed & BSS_CHANGED_BEACON_ENABLED) && is_ibss) {
 		wl1271_debug(DEBUG_ADHOC, "ad-hoc beaconing: %s",
 			     bss_conf->enable_beacon ? "enabled" : "disabled");
 
@@ -1975,7 +1988,29 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 		do_join = true;
 	}
 
-	if (changed & BSS_CHANGED_CQM) {
+	if ((changed & BSS_CHANGED_BEACON_ENABLED) && is_ap) {
+		if (bss_conf->enable_beacon) {
+			if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
+				ret = wl1271_cmd_start_bss(wl);
+				if (ret < 0)
+					goto out_sleep;
+
+				set_bit(WL1271_FLAG_AP_STARTED, &wl->flags);
+				wl1271_debug(DEBUG_AP, "started AP");
+			}
+		} else {
+			if (test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
+				ret = wl1271_cmd_stop_bss(wl);
+				if (ret < 0)
+					goto out_sleep;
+
+				clear_bit(WL1271_FLAG_AP_STARTED, &wl->flags);
+				wl1271_debug(DEBUG_AP, "stopped AP");
+			}
+		}
+	}
+
+	if ((changed & BSS_CHANGED_CQM) && !is_ap) {
 		bool enable = false;
 		if (bss_conf->cqm_rssi_thold)
 			enable = true;
@@ -1983,11 +2018,11 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 						  bss_conf->cqm_rssi_thold,
 						  bss_conf->cqm_rssi_hyst);
 		if (ret < 0)
-			goto out;
+			goto out_sleep;
 		wl->rssi_thold = bss_conf->cqm_rssi_thold;
 	}
 
-	if ((changed & BSS_CHANGED_BSSID) &&
+	if ((changed & BSS_CHANGED_BSSID) && !is_ap &&
 	    /*
 	     * Now we know the correct bssid, so we send a new join command
 	     * and enable the BSSID filter
@@ -2010,7 +2045,7 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			do_join = true;
 	}
 
-	if (changed & BSS_CHANGED_ASSOC) {
+	if ((changed & BSS_CHANGED_ASSOC) && !is_ap) {
 		if (bss_conf->assoc) {
 			u32 rates;
 			int ieoffset;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index ebb4a4d..a378d52 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -57,6 +57,8 @@ enum {
 	DEBUG_SDIO	= BIT(14),
 	DEBUG_FILTERS   = BIT(15),
 	DEBUG_ADHOC     = BIT(16),
+	DEBUG_AP	= BIT(17),
+	DEBUG_MASTER	= (DEBUG_ADHOC | DEBUG_AP),
 	DEBUG_ALL	= ~0,
 };
 
@@ -284,6 +286,7 @@ struct wl1271 {
 #define WL1271_FLAG_PSPOLL_FAILURE    (12)
 #define WL1271_FLAG_STA_STATE_SENT    (13)
 #define WL1271_FLAG_FW_TX_BUSY        (14)
+#define WL1271_FLAG_AP_STARTED        (15)
 	unsigned long flags;
 
 	struct wl1271_partition_set part;
-- 
1.7.1

