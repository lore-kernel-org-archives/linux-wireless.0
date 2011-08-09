Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52328 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752790Ab1HIJOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:14:22 -0400
Received: by mail-wy0-f174.google.com with SMTP id 24so210690wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:14:21 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 27/40] wl12xx: support IBSS vif type
Date: Tue,  9 Aug 2011 12:13:40 +0300
Message-Id: <1312881233-9366-28-git-send-email-eliad@wizery.com> (sfid-20110809_111429_437899_A0E5B2A7)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
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
index 6a87086..d81a735 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1760,12 +1760,15 @@ static u8 wl1271_get_role_type(struct wl1271 *wl)
 	case BSS_TYPE_AP_BSS:
 		return WL1271_ROLE_AP;
 
 	case BSS_TYPE_STA_BSS:
 		return WL1271_ROLE_STA;
 
+	case BSS_TYPE_IBSS:
+		return WL1271_ROLE_IBSS;
+
 	default:
 		wl1271_info("invalid bss_type: %d", wl->bss_type);
 	}
 	return 0xff;
 }
 
@@ -1832,13 +1835,14 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 			goto power_off;
 
 		ret = wl1271_boot(wl);
 		if (ret < 0)
 			goto power_off;
 
-		if (wl->bss_type == BSS_TYPE_STA_BSS) {
+		if (wl->bss_type == BSS_TYPE_STA_BSS ||
+		    wl->bss_type == BSS_TYPE_IBSS) {
 			ret = wl1271_cmd_role_enable(wl,
 							 WL1271_ROLE_DEVICE,
 							 &wl->dev_role_id);
 			if (ret < 0)
 				goto irq_disable;
 		}
@@ -2055,12 +2059,13 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
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
@@ -2071,13 +2076,16 @@ static int wl1271_join(struct wl1271 *wl, bool set_assoc)
 	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		wl1271_info("JOIN while associated.");
 
 	if (set_assoc)
 		set_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags);
 
-	ret = wl1271_cmd_role_start_sta(wl);
+	if (is_ibss)
+		ret = wl1271_cmd_role_start_ibss(wl);
+	else
+		ret = wl1271_cmd_role_start_sta(wl);
 	if (ret < 0)
 		goto out;
 
 	if (!test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
 		goto out;
 
@@ -3093,12 +3101,13 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
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
 
@@ -3106,20 +3115,34 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
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
+				wl1271_cmd_role_start_dev(wl);
+				wl1271_roc(wl, wl->dev_role_id);
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
index 52f2b6b..bb90002 100644
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
 		wl1271_cmd_role_start_dev(wl);
 		wl1271_roc(wl, wl->dev_role_id);
 	}
 	wl1271_ps_elp_sleep(wl);
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index d99922c..52a9ae9 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -384,13 +384,14 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 
 	if (wl12xx_is_dummy_packet(wl, skb))
 		hlid = wl->system_hlid;
 	else if (wl->bss_type == BSS_TYPE_AP_BSS)
 		hlid = wl1271_tx_get_hlid(wl, skb);
 	else
-		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
+		if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
+		    test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags))
 			hlid = wl->sta_hlid;
 		else
 			hlid = wl->dev_hlid;
 
 	if (hlid == WL1271_INVALID_LINK_ID) {
 		wl1271_error("invalid hlid. dropping skb 0x%p", skb);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 97a40c3..dfe08e5 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -321,12 +321,13 @@ struct wl1271_ap_key {
 	u32 tx_seq_32;
 	u16 tx_seq_16;
 };
 
 enum wl12xx_flags {
 	WL1271_FLAG_STA_ASSOCIATED,
+	WL1271_FLAG_IBSS_JOINED,
 	WL1271_FLAG_ROC,
 	WL1271_FLAG_GPIO_POWER,
 	WL1271_FLAG_TX_QUEUE_STOPPED,
 	WL1271_FLAG_TX_PENDING,
 	WL1271_FLAG_IN_ELP,
 	WL1271_FLAG_ELP_REQUESTED,
-- 
1.7.6.401.g6a319

