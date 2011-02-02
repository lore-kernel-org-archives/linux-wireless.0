Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39736 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753511Ab1BBH7v (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Feb 2011 02:59:51 -0500
Received: by mail-wy0-f174.google.com with SMTP id 28so7584286wyb.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Feb 2011 23:59:51 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 4/4] wl12xx: set supported_rates after association
Date: Wed,  2 Feb 2011 09:59:37 +0200
Message-Id: <1296633577-15199-5-git-send-email-eliad@wizery.com>
In-Reply-To: <1296633577-15199-1-git-send-email-eliad@wizery.com>
References: <1296633577-15199-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of looking for supported_rates change on every tx packet,
just extract the supported_rates after association completes (station only).

Remove wl1271.sta_rate_set and WL1271_FLAG_STA_RATES_CHANGED which are
not used anymore.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v1->v2:
	1. consider mcs rates when setting sta_rate_set
	2. remove unused flags/members
v2->v3:
	add a check for ht_cap.ht_supported

 drivers/net/wireless/wl12xx/acx.c    |    4 +
 drivers/net/wireless/wl12xx/cmd.c    |   11 +--
 drivers/net/wireless/wl12xx/main.c   |  116 ++++++++++++++--------------------
 drivers/net/wireless/wl12xx/tx.c     |   22 -------
 drivers/net/wireless/wl12xx/wl12xx.h |   35 +++++-----
 5 files changed, 73 insertions(+), 115 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index 6ea19d7..33840d9 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -783,6 +783,10 @@ int wl1271_acx_sta_rate_policies(struct wl1271 *wl)
 
 	acx->rate_class_cnt = cpu_to_le32(ACX_TX_RATE_POLICY_CNT);
 
+	wl1271_debug(DEBUG_ACX, "basic_rate: 0x%x, full_rate: 0x%x",
+		acx->rate_class[ACX_TX_BASIC_RATE].enabled_rates,
+		acx->rate_class[ACX_TX_AP_FULL_RATE].enabled_rates);
+
 	ret = wl1271_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
 	if (ret < 0) {
 		wl1271_warning("Setting of rate policies failed: %d", ret);
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 66d15e7..97ffd7a 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -286,13 +286,7 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 	join->rx_filter_options = cpu_to_le32(wl->rx_filter);
 	join->bss_type = bss_type;
 	join->basic_rate_set = cpu_to_le32(wl->basic_rate_set);
-	/*
-	 * for supported_rate_set, we should use wl->rate_set. however,
-	 * it seems that acx_rate_policies doesn't affect full_rate, and
-	 * since we want to avoid additional join, we'll use a 0xffffffff value,
-	 * and let the fw find the actual supported rates
-	 */
-	join->supported_rate_set = cpu_to_le32(0xffffffff);
+	join->supported_rate_set = cpu_to_le32(wl->rate_set);
 
 	if (wl->band == IEEE80211_BAND_5GHZ)
 		join->bss_type |= WL1271_JOIN_CMD_BSS_TYPE_5GHZ;
@@ -310,6 +304,9 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 	wl->tx_security_last_seq = 0;
 	wl->tx_security_seq = 0;
 
+	wl1271_debug(DEBUG_CMD, "cmd join: basic_rate_set=0x%x, rate_set=0x%x",
+		join->basic_rate_set, join->supported_rate_set);
+
 	ret = wl1271_cmd_send(wl, CMD_START_JOIN, join, sizeof(*join), 0);
 	if (ret < 0) {
 		wl1271_error("failed to initiate cmd join");
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 0f6786d..6ef69a4 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -978,39 +978,10 @@ int wl1271_plt_stop(struct wl1271 *wl)
 static int wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1271 *wl = hw->priv;
-	struct ieee80211_conf *conf = &hw->conf;
-	struct ieee80211_tx_info *txinfo = IEEE80211_SKB_CB(skb);
-	struct ieee80211_sta *sta = txinfo->control.sta;
 	unsigned long flags;
 	int q;
 
-	/*
-	 * peek into the rates configured in the STA entry.
-	 * The rates set after connection stage, The first block only BG sets:
-	 * the compare is for bit 0-16 of sta_rate_set. The second block add
-	 * HT rates in case of HT supported.
-	 */
 	spin_lock_irqsave(&wl->wl_lock, flags);
-	if (sta &&
-	    (sta->supp_rates[conf->channel->band] !=
-	    (wl->sta_rate_set & HW_BG_RATES_MASK)) &&
-		wl->bss_type != BSS_TYPE_AP_BSS) {
-		wl->sta_rate_set = sta->supp_rates[conf->channel->band];
-		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
-	}
-
-#ifdef CONFIG_WL12XX_HT
-	if (sta &&
-	    sta->ht_cap.ht_supported &&
-	    ((wl->sta_rate_set >> HW_HT_RATES_OFFSET) !=
-	      sta->ht_cap.mcs.rx_mask[0])) {
-		/* Clean MCS bits before setting them */
-		wl->sta_rate_set &= HW_BG_RATES_MASK;
-		wl->sta_rate_set |=
-			(sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
-		set_bit(WL1271_FLAG_STA_RATES_CHANGED, &wl->flags);
-	}
-#endif
 	wl->tx_queue_count++;
 	spin_unlock_irqrestore(&wl->wl_lock, flags);
 
@@ -1245,7 +1216,6 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 	wl->time_offset = 0;
 	wl->session_counter = 0;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
-	wl->sta_rate_set = 0;
 	wl->flags = 0;
 	wl->vif = NULL;
 	wl->filters = 0;
@@ -1432,7 +1402,6 @@ static int wl1271_sta_handle_idle(struct wl1271 *wl, bool idle)
 				goto out;
 		}
 		wl->rate_set = wl1271_tx_min_rate_get(wl);
-		wl->sta_rate_set = 0;
 		ret = wl1271_acx_sta_rate_policies(wl);
 		if (ret < 0)
 			goto out;
@@ -2246,6 +2215,7 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 {
 	bool do_join = false, set_assoc = false;
 	bool is_ibss = (wl->bss_type == BSS_TYPE_IBSS);
+	u32 sta_rate_set = 0;
 	int ret;
 	struct ieee80211_sta *sta;
 
@@ -2311,6 +2281,49 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 		}
 	}
 
+	rcu_read_lock();
+	sta = ieee80211_find_sta(vif, bss_conf->bssid);
+	if (sta)  {
+		/* save the supp_rates of the ap */
+		sta_rate_set = sta->supp_rates[wl->hw->conf.channel->band];
+		if (sta->ht_cap.ht_supported)
+			sta_rate_set |=
+			    (sta->ht_cap.mcs.rx_mask[0] << HW_HT_RATES_OFFSET);
+
+		/* handle new association with HT and HT information change */
+		if ((changed & BSS_CHANGED_HT) &&
+		    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
+			ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap,
+							     true);
+			if (ret < 0) {
+				wl1271_warning("Set ht cap true failed %d",
+					       ret);
+				rcu_read_unlock();
+				goto out;
+			}
+			ret = wl1271_acx_set_ht_information(wl,
+						bss_conf->ht_operation_mode);
+			if (ret < 0) {
+				wl1271_warning("Set ht information failed %d",
+					       ret);
+				rcu_read_unlock();
+				goto out;
+			}
+		}
+		/* handle new association without HT and disassociation */
+		else if (changed & BSS_CHANGED_ASSOC) {
+			ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap,
+							     false);
+			if (ret < 0) {
+				wl1271_warning("Set ht cap false failed %d",
+					       ret);
+				rcu_read_unlock();
+				goto out;
+			}
+		}
+	}
+	rcu_read_unlock();
+
 	if ((changed & BSS_CHANGED_ASSOC)) {
 		if (bss_conf->assoc) {
 			u32 rates;
@@ -2328,6 +2341,9 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 			wl->basic_rate_set = wl1271_tx_enabled_rates_get(wl,
 									 rates);
 			wl->basic_rate = wl1271_tx_min_rate_get(wl);
+			if (sta_rate_set)
+				wl->rate_set = wl1271_tx_enabled_rates_get(wl,
+								sta_rate_set);
 			ret = wl1271_acx_sta_rate_policies(wl);
 			if (ret < 0)
 				goto out;
@@ -2406,43 +2422,6 @@ static void wl1271_bss_info_changed_sta(struct wl1271 *wl,
 	if (ret < 0)
 		goto out;
 
-	rcu_read_lock();
-	sta = ieee80211_find_sta(vif, bss_conf->bssid);
-	if (sta)  {
-		/* handle new association with HT and HT information change */
-		if ((changed & BSS_CHANGED_HT) &&
-		    (bss_conf->channel_type != NL80211_CHAN_NO_HT)) {
-			ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap,
-							     true);
-			if (ret < 0) {
-				wl1271_warning("Set ht cap true failed %d",
-					       ret);
-				rcu_read_unlock();
-				goto out;
-			}
-			ret = wl1271_acx_set_ht_information(wl,
-						bss_conf->ht_operation_mode);
-			if (ret < 0) {
-				wl1271_warning("Set ht information failed %d",
-					       ret);
-				rcu_read_unlock();
-				goto out;
-			}
-		}
-		/* handle new association without HT and disassociation */
-		else if (changed & BSS_CHANGED_ASSOC) {
-			ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap,
-							     false);
-			if (ret < 0) {
-				wl1271_warning("Set ht cap false failed %d",
-					       ret);
-				rcu_read_unlock();
-				goto out;
-			}
-		}
-	}
-	rcu_read_unlock();
-
 	if (changed & BSS_CHANGED_ARP_FILTER) {
 		__be32 addr = bss_conf->arp_addr_list[0];
 		WARN_ON(wl->bss_type != BSS_TYPE_STA_BSS);
@@ -3329,7 +3308,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->basic_rate_set = CONF_TX_RATE_MASK_BASIC;
 	wl->basic_rate = CONF_TX_RATE_MASK_BASIC;
 	wl->rate_set = CONF_TX_RATE_MASK_BASIC;
-	wl->sta_rate_set = 0;
 	wl->band = IEEE80211_BAND_2GHZ;
 	wl->vif = NULL;
 	wl->flags = 0;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 3507c81..67a0094 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -334,35 +334,13 @@ void wl1271_tx_work_locked(struct wl1271 *wl)
 {
 	struct sk_buff *skb;
 	bool woken_up = false;
-	u32 sta_rates = 0;
 	u32 buf_offset = 0;
 	bool sent_packets = false;
 	int ret;
 
-	/* check if the rates supported by the AP have changed */
-	if (unlikely(test_and_clear_bit(WL1271_FLAG_STA_RATES_CHANGED,
-					&wl->flags))) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&wl->wl_lock, flags);
-		sta_rates = wl->sta_rate_set;
-		spin_unlock_irqrestore(&wl->wl_lock, flags);
-	}
-
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
-	/* if rates have changed, re-configure the rate policy */
-	if (unlikely(sta_rates)) {
-		ret = wl1271_ps_elp_wakeup(wl, false);
-		if (ret < 0)
-			goto out;
-		woken_up = true;
-
-		wl->rate_set = wl1271_tx_enabled_rates_get(wl, sta_rates);
-		wl1271_acx_sta_rate_policies(wl);
-	}
-
 	while ((skb = wl1271_skb_dequeue(wl))) {
 		if (!woken_up) {
 			ret = wl1271_ps_elp_wakeup(wl, false);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 39adcdf..15d9e9e 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -301,6 +301,24 @@ struct wl1271_ap_key {
 	u16 tx_seq_16;
 };
 
+enum wl12xx_flags {
+	WL1271_FLAG_STA_ASSOCIATED,
+	WL1271_FLAG_JOINED,
+	WL1271_FLAG_GPIO_POWER,
+	WL1271_FLAG_TX_QUEUE_STOPPED,
+	WL1271_FLAG_IN_ELP,
+	WL1271_FLAG_PSM,
+	WL1271_FLAG_PSM_REQUESTED,
+	WL1271_FLAG_IRQ_PENDING,
+	WL1271_FLAG_IRQ_RUNNING,
+	WL1271_FLAG_IDLE,
+	WL1271_FLAG_IDLE_REQUESTED,
+	WL1271_FLAG_PSPOLL_FAILURE,
+	WL1271_FLAG_STA_STATE_SENT,
+	WL1271_FLAG_FW_TX_BUSY,
+	WL1271_FLAG_AP_STARTED
+};
+
 struct wl1271 {
 	struct platform_device *plat_dev;
 	struct ieee80211_hw *hw;
@@ -319,22 +337,6 @@ struct wl1271 {
 	enum wl1271_state state;
 	struct mutex mutex;
 
-#define WL1271_FLAG_STA_RATES_CHANGED  (0)
-#define WL1271_FLAG_STA_ASSOCIATED     (1)
-#define WL1271_FLAG_JOINED             (2)
-#define WL1271_FLAG_GPIO_POWER         (3)
-#define WL1271_FLAG_TX_QUEUE_STOPPED   (4)
-#define WL1271_FLAG_IN_ELP             (5)
-#define WL1271_FLAG_PSM                (6)
-#define WL1271_FLAG_PSM_REQUESTED      (7)
-#define WL1271_FLAG_IRQ_PENDING        (8)
-#define WL1271_FLAG_IRQ_RUNNING        (9)
-#define WL1271_FLAG_IDLE              (10)
-#define WL1271_FLAG_IDLE_REQUESTED    (11)
-#define WL1271_FLAG_PSPOLL_FAILURE    (12)
-#define WL1271_FLAG_STA_STATE_SENT    (13)
-#define WL1271_FLAG_FW_TX_BUSY        (14)
-#define WL1271_FLAG_AP_STARTED        (15)
 	unsigned long flags;
 
 	struct wl1271_partition_set part;
@@ -428,7 +430,6 @@ struct wl1271 {
 	 *	bits 16-23 - 802.11n   MCS index mask
 	 * support only 1 stream, thus only 8 bits for the MCS rates (0-7).
 	 */
-	u32 sta_rate_set;
 	u32 basic_rate_set;
 	u32 basic_rate;
 	u32 rate_set;
-- 
1.7.0.4

