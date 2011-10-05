Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:49843 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932909Ab1JEJ7n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:59:43 -0400
Received: by eya28 with SMTP id 28so1409114eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:59:41 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 15/29] wl12xx: move dev_role_id into wlvif
Date: Wed,  5 Oct 2011 11:55:52 +0200
Message-Id: <1317808566-18857-16-git-send-email-eliad@wizery.com> (sfid-20111005_121655_755211_39BD7FE6)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move dev_role_id into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c    |   10 +++---
 drivers/net/wireless/wl12xx/cmd.h    |    4 +-
 drivers/net/wireless/wl12xx/main.c   |   50 +++++++++++++++++++---------------
 drivers/net/wireless/wl12xx/scan.c   |   10 ++++---
 drivers/net/wireless/wl12xx/tx.c     |    9 +++---
 drivers/net/wireless/wl12xx/wl12xx.h |    4 ++-
 6 files changed, 49 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 961d9b0..5b7b37a 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -464,7 +464,7 @@ static int wl12xx_get_new_session_id(struct wl1271 *wl)
 	return wl->session_counter;
 }
 
-int wl12xx_cmd_role_start_dev(struct wl1271 *wl)
+int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_start *cmd;
 	int ret;
@@ -475,9 +475,9 @@ int wl12xx_cmd_role_start_dev(struct wl1271 *wl)
 		goto out;
 	}
 
-	wl1271_debug(DEBUG_CMD, "cmd role start dev %d", wl->dev_role_id);
+	wl1271_debug(DEBUG_CMD, "cmd role start dev %d", wlvif->dev_role_id);
 
-	cmd->role_id = wl->dev_role_id;
+	cmd->role_id = wlvif->dev_role_id;
 	if (wl->band == IEEE80211_BAND_5GHZ)
 		cmd->band = WL12XX_BAND_5GHZ;
 	cmd->channel = wl->channel;
@@ -514,7 +514,7 @@ out:
 	return ret;
 }
 
-int wl12xx_cmd_role_stop_dev(struct wl1271 *wl)
+int wl12xx_cmd_role_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 {
 	struct wl12xx_cmd_role_stop *cmd;
 	int ret;
@@ -530,7 +530,7 @@ int wl12xx_cmd_role_stop_dev(struct wl1271 *wl)
 
 	wl1271_debug(DEBUG_CMD, "cmd role stop dev");
 
-	cmd->role_id = wl->dev_role_id;
+	cmd->role_id = wlvif->dev_role_id;
 	cmd->disc_type = DISCONNECT_IMMEDIATE;
 	cmd->reason = cpu_to_le16(WLAN_REASON_UNSPECIFIED);
 
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index c17294c..f7c74dc 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -39,8 +39,8 @@ int wl1271_cmd_ext_radio_parms(struct wl1271 *wl);
 int wl12xx_cmd_role_enable(struct wl1271 *wl, u8 *addr, u8 role_type,
 			   u8 *role_id);
 int wl12xx_cmd_role_disable(struct wl1271 *wl, u8 *role_id);
-int wl12xx_cmd_role_start_dev(struct wl1271 *wl);
-int wl12xx_cmd_role_stop_dev(struct wl1271 *wl);
+int wl12xx_cmd_role_start_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif);
+int wl12xx_cmd_role_stop_dev(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_stop_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 int wl12xx_cmd_role_start_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 5c12bf4..9a7c94f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1857,6 +1857,7 @@ static void wl12xx_init_vif_data(struct wl12xx_vif *wlvif)
 {
 	wlvif->bss_type = MAX_BSS_TYPE;
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
+	wlvif->dev_role_id = WL12XX_INVALID_ROLE_ID;
 	wlvif->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
@@ -1958,7 +1959,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 			 */
 			ret = wl12xx_cmd_role_enable(wl, vif->addr,
 							 WL1271_ROLE_DEVICE,
-							 &wl->dev_role_id);
+							 &wlvif->dev_role_id);
 			if (ret < 0)
 				goto irq_disable;
 		}
@@ -2067,7 +2068,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 			goto deinit;
 
 		if (wlvif->bss_type == BSS_TYPE_STA_BSS) {
-			ret = wl12xx_cmd_role_disable(wl, &wl->dev_role_id);
+			ret = wl12xx_cmd_role_disable(wl, &wlvif->dev_role_id);
 			if (ret < 0)
 				goto deinit;
 		}
@@ -2131,7 +2132,7 @@ deinit:
 	wl->ap_ps_map = 0;
 	wl->sched_scanning = false;
 	wlvif->role_id = WL12XX_INVALID_ROLE_ID;
-	wl->dev_role_id = WL12XX_INVALID_ROLE_ID;
+	wlvif->dev_role_id = WL12XX_INVALID_ROLE_ID;
 	memset(wl->roles_map, 0, sizeof(wl->roles_map));
 	memset(wl->links_map, 0, sizeof(wl->links_map));
 	memset(wl->roc_map, 0, sizeof(wl->roc_map));
@@ -2284,11 +2285,11 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	if (idle) {
 		/* no need to croc if we weren't busy (e.g. during boot) */
 		if (wl12xx_is_roc(wl)) {
-			ret = wl12xx_croc(wl, wl->dev_role_id);
+			ret = wl12xx_croc(wl, wlvif->dev_role_id);
 			if (ret < 0)
 				goto out;
 
-			ret = wl12xx_cmd_role_stop_dev(wl);
+			ret = wl12xx_cmd_role_stop_dev(wl, wlvif);
 			if (ret < 0)
 				goto out;
 		}
@@ -2310,11 +2311,11 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			ieee80211_sched_scan_stopped(wl->hw);
 		}
 
-		ret = wl12xx_cmd_role_start_dev(wl);
+		ret = wl12xx_cmd_role_start_dev(wl, wlvif);
 		if (ret < 0)
 			goto out;
 
-		ret = wl12xx_roc(wl, wl->dev_role_id);
+		ret = wl12xx_roc(wl, wlvif->dev_role_id);
 		if (ret < 0)
 			goto out;
 		clear_bit(WL1271_FLAG_IDLE, &wl->flags);
@@ -2403,7 +2404,8 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 			if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
 				if (wl12xx_is_roc(wl)) {
 					/* roaming */
-					ret = wl12xx_croc(wl, wl->dev_role_id);
+					ret = wl12xx_croc(wl,
+							  wlvif->dev_role_id);
 					if (ret < 0)
 						goto out_sleep;
 				}
@@ -2419,11 +2421,13 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 				 */
 				if (wl12xx_is_roc(wl) &&
 				    !(conf->flags & IEEE80211_CONF_IDLE)) {
-					ret = wl12xx_croc(wl, wl->dev_role_id);
+					ret = wl12xx_croc(wl,
+							  wlvif->dev_role_id);
 					if (ret < 0)
 						goto out_sleep;
 
-					ret = wl12xx_roc(wl, wl->dev_role_id);
+					ret = wl12xx_roc(wl,
+							 wlvif->dev_role_id);
 					if (ret < 0)
 						wl1271_warning("roc failed %d",
 							       ret);
@@ -2886,6 +2890,8 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 			     struct cfg80211_scan_request *req)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
+
 	int ret;
 	u8 *ssid = NULL;
 	size_t len = 0;
@@ -2920,8 +2926,8 @@ static int wl1271_op_hw_scan(struct ieee80211_hw *hw,
 			ret = -EBUSY;
 			goto out_sleep;
 		}
-		wl12xx_croc(wl, wl->dev_role_id);
-		wl12xx_cmd_role_stop_dev(wl);
+		wl12xx_croc(wl, wlvif->dev_role_id);
+		wl12xx_cmd_role_stop_dev(wl, wlvif);
 	}
 
 	ret = wl1271_scan(hw->priv, vif, ssid, len, req);
@@ -3432,8 +3438,8 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			if (test_and_clear_bit(WL1271_FLAG_IBSS_JOINED,
 					       &wl->flags)) {
 				wl1271_unjoin(wl, wlvif);
-				wl12xx_cmd_role_start_dev(wl);
-				wl12xx_roc(wl, wl->dev_role_id);
+				wl12xx_cmd_role_start_dev(wl, wlvif);
+				wl12xx_roc(wl, wlvif->dev_role_id);
 			}
 		}
 	}
@@ -3600,16 +3606,17 @@ sta_not_found:
 				 * roaming on the same channel. until we will
 				 * have a better flow...)
 				 */
-				if (test_bit(wl->dev_role_id, wl->roc_map)) {
-					ret = wl12xx_croc(wl, wl->dev_role_id);
+				if (test_bit(wlvif->dev_role_id, wl->roc_map)) {
+					ret = wl12xx_croc(wl,
+							  wlvif->dev_role_id);
 					if (ret < 0)
 						goto out;
 				}
 
 				wl1271_unjoin(wl, wlvif);
 				if (!(conf_flags & IEEE80211_CONF_IDLE)) {
-					wl12xx_cmd_role_start_dev(wl);
-					wl12xx_roc(wl, wl->dev_role_id);
+					wl12xx_cmd_role_start_dev(wl, wlvif);
+					wl12xx_roc(wl, wlvif->dev_role_id);
 				}
 			}
 		}
@@ -3688,12 +3695,12 @@ sta_not_found:
 		 * stop device role if started (we might already be in
 		 * STA role). TODO: make it better.
 		 */
-		if (wl->dev_role_id != WL12XX_INVALID_ROLE_ID) {
-			ret = wl12xx_croc(wl, wl->dev_role_id);
+		if (wlvif->dev_role_id != WL12XX_INVALID_ROLE_ID) {
+			ret = wl12xx_croc(wl, wlvif->dev_role_id);
 			if (ret < 0)
 				goto out;
 
-			ret = wl12xx_cmd_role_stop_dev(wl);
+			ret = wl12xx_cmd_role_stop_dev(wl, wlvif);
 			if (ret < 0)
 				goto out;
 		}
@@ -4841,7 +4848,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->tx_spare_blocks = TX_HW_BLOCK_SPARE_DEFAULT;
 	wl->system_hlid = WL12XX_SYSTEM_HLID;
 	wl->sta_hlid = WL12XX_INVALID_LINK_ID;
-	wl->dev_role_id = WL12XX_INVALID_ROLE_ID;
 	wl->dev_hlid = WL12XX_INVALID_LINK_ID;
 	wl->session_counter = 0;
 	wl->ap_bcast_hlid = WL12XX_INVALID_LINK_ID;
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 9d0dfb5..9372136 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -34,6 +34,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 {
 	struct delayed_work *dwork;
 	struct wl1271 *wl;
+	struct ieee80211_vif *vif;
 	struct wl12xx_vif *wlvif;
 	int ret;
 	bool is_sta, is_ibss;
@@ -51,7 +52,8 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	if (wl->scan.state == WL1271_SCAN_STATE_IDLE)
 		goto out;
 
-	wlvif = wl12xx_vif_to_data(wl->scan_vif);
+	vif = wl->scan_vif;
+	wlvif = wl12xx_vif_to_data(vif);
 
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
@@ -72,10 +74,10 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	is_ibss = (wlvif->bss_type == BSS_TYPE_IBSS);
 	if (((is_sta && !test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) ||
 	     (is_ibss && !test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags))) &&
-	    !test_bit(wl->dev_role_id, wl->roc_map)) {
+	    !test_bit(wlvif->dev_role_id, wl->roc_map)) {
 		/* restore remain on channel */
-		wl12xx_cmd_role_start_dev(wl);
-		wl12xx_roc(wl, wl->dev_role_id);
+		wl12xx_cmd_role_start_dev(wl, wlvif);
+		wl12xx_roc(wl, wlvif->dev_role_id);
 	}
 	wl1271_ps_elp_sleep(wl);
 
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 5561ec2..538d861 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -77,7 +77,8 @@ static void wl1271_free_tx_id(struct wl1271 *wl, int id)
 }
 
 static int wl1271_tx_update_filters(struct wl1271 *wl,
-						 struct sk_buff *skb)
+				    struct wl12xx_vif *wlvif,
+				    struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr;
 	int ret;
@@ -97,11 +98,11 @@ static int wl1271_tx_update_filters(struct wl1271 *wl,
 		goto out;
 
 	wl1271_debug(DEBUG_CMD, "starting device role for roaming");
-	ret = wl12xx_cmd_role_start_dev(wl);
+	ret = wl12xx_cmd_role_start_dev(wl, wlvif);
 	if (ret < 0)
 		goto out;
 
-	ret = wl12xx_roc(wl, wl->dev_role_id);
+	ret = wl12xx_roc(wl, wlvif->dev_role_id);
 	if (ret < 0)
 		goto out;
 out:
@@ -192,7 +193,7 @@ static u8 wl1271_tx_get_hlid(struct wl1271 *wl, struct ieee80211_vif *vif,
 	if (wlvif->bss_type == BSS_TYPE_AP_BSS)
 		return wl12xx_tx_get_hlid_ap(wl, skb);
 
-	wl1271_tx_update_filters(wl, skb);
+	wl1271_tx_update_filters(wl, wlvif, skb);
 
 	if ((test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags) ||
 	     test_bit(WL1271_FLAG_IBSS_JOINED, &wl->flags)) &&
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 46258c7..32fecae 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -400,7 +400,6 @@ struct wl1271 {
 
 	u8 mac_addr[ETH_ALEN];
 	int channel;
-	u8 dev_role_id;
 	u8 system_hlid;
 	u8 sta_hlid;
 	u8 dev_hlid;
@@ -621,6 +620,9 @@ struct wl12xx_vif {
 	u8 p2p; /* we are using p2p role */
 	u8 role_id;
 
+	/* sta/ibss specific */
+	u8 dev_role_id;
+
 	u8 ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 ssid_len;
 
-- 
1.7.6.401.g6a319

