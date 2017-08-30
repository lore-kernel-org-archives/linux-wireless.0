Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35043 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751242AbdH3Jnh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 05:43:37 -0400
Received: by mail-pg0-f66.google.com with SMTP id r133so4718789pgr.2
        for <linux-wireless@vger.kernel.org>; Wed, 30 Aug 2017 02:43:37 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH 3/8] rsi: add support for p2p listen
Date: Wed, 30 Aug 2017 15:08:23 +0530
Message-Id: <1504085908-2163-4-git-send-email-amitkarwar@gmail.com> (sfid-20170830_114412_026073_39FCA4CD)
In-Reply-To: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
References: <1504085908-2163-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

Remain-on-channel and cancel-remain-on-channel are implemented
to support p2p listen phase.

Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_core.c     |  15 +++
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 188 +++++++++++++++++++++++++---
 drivers/net/wireless/rsi/rsi_91x_main.c     |   9 +-
 drivers/net/wireless/rsi/rsi_91x_mgmt.c     |   4 +-
 drivers/net/wireless/rsi/rsi_common.h       |   4 +-
 drivers/net/wireless/rsi/rsi_main.h         |   2 +
 drivers/net/wireless/rsi/rsi_mgmt.h         |   2 +-
 7 files changed, 199 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 2b0516d..d212196 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -334,6 +334,21 @@ struct rsi_sta *rsi_find_sta(struct rsi_common *common, u8 *mac_addr)
 	return NULL;
 }
 
+struct ieee80211_vif *rsi_get_vif(struct rsi_hw *adapter, u8 *mac)
+{
+	struct ieee80211_vif *vif;
+	int i;
+
+	for (i = 0; i < RSI_MAX_VIFS; i++) {
+		vif = adapter->vifs[i];
+		if (!vif)
+			continue;
+		if (!memcmp(vif->addr, mac, ETH_ALEN))
+			return vif;
+	}
+	return NULL;
+}
+
 /**
  * rsi_core_xmit() - This function transmits the packets received from mac80211
  * @common: Pointer to the driver private structure.
diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index db69d87..6780c1c 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -503,35 +503,44 @@ static int rsi_channel_change(struct ieee80211_hw *hw)
 	int status = -EOPNOTSUPP;
 	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
 	u16 channel = curchan->hw_value;
-	struct ieee80211_bss_conf *bss = &adapter->vifs[0]->bss_conf;
+	struct ieee80211_vif *vif;
+	struct ieee80211_bss_conf *bss;
+	bool assoc = false;
+	int i;
 
 	rsi_dbg(INFO_ZONE,
 		"%s: Set channel: %d MHz type: %d channel_no %d\n",
 		__func__, curchan->center_freq,
 		curchan->flags, channel);
 
-	if (bss->assoc) {
+	for (i = 0; i < RSI_MAX_VIFS; i++) {
+		vif = adapter->vifs[i];
+		if (!vif)
+			continue;
+		if (vif->type == NL80211_IFTYPE_STATION) {
+			bss = &vif->bss_conf;
+			if (bss->assoc) {
+				assoc = true;
+				break;
+			}
+		}
+	}
+	if (assoc) {
 		if (!common->hw_data_qs_blocked &&
-		    (rsi_get_connected_channel(adapter) != channel)) {
+		    (rsi_get_connected_channel(vif) != channel)) {
 			rsi_dbg(INFO_ZONE, "blk data q %d\n", channel);
 			if (!rsi_send_block_unblock_frame(common, true))
 				common->hw_data_qs_blocked = true;
 		}
 	}
 
-	status = rsi_band_check(common);
+	status = rsi_band_check(common, curchan);
 	if (!status)
 		status = rsi_set_channel(adapter->priv, curchan);
 
-	if (bss->assoc) {
+	if (assoc) {
 		if (common->hw_data_qs_blocked &&
-		    (rsi_get_connected_channel(adapter) == channel)) {
-			rsi_dbg(INFO_ZONE, "unblk data q %d\n", channel);
-			if (!rsi_send_block_unblock_frame(common, false))
-				common->hw_data_qs_blocked = false;
-		}
-	} else {
-		if (common->hw_data_qs_blocked) {
+		    (rsi_get_connected_channel(vif) == channel)) {
 			rsi_dbg(INFO_ZONE, "unblk data q %d\n", channel);
 			if (!rsi_send_block_unblock_frame(common, false))
 				common->hw_data_qs_blocked = false;
@@ -632,16 +641,42 @@ static int rsi_mac80211_config(struct ieee80211_hw *hw,
  *
  * Return: Current connected AP's channel number is returned.
  */
-u16 rsi_get_connected_channel(struct rsi_hw *adapter)
+u16 rsi_get_connected_channel(struct ieee80211_vif *vif)
 {
-	struct ieee80211_vif *vif = adapter->vifs[0];
-	if (vif) {
-		struct ieee80211_bss_conf *bss = &vif->bss_conf;
-		struct ieee80211_channel *channel = bss->chandef.chan;
-		return channel->hw_value;
-	}
+	struct ieee80211_bss_conf *bss;
+	struct ieee80211_channel *channel;
 
-	return 0;
+	if (!vif)
+		return 0;
+
+	bss = &vif->bss_conf;
+	channel = bss->chandef.chan;
+
+	if (!channel)
+		return 0;
+
+	return channel->hw_value;
+}
+
+static void rsi_switch_channel(struct rsi_hw *adapter,
+			       struct ieee80211_vif *vif)
+{
+	struct rsi_common *common = adapter->priv;
+	struct ieee80211_channel *channel;
+
+	if (common->iface_down)
+		return;
+	if (!vif)
+		return;
+
+	channel = vif->bss_conf.chandef.chan;
+
+	if (!channel)
+		return;
+
+	rsi_band_check(common, channel);
+	rsi_set_channel(common, channel);
+	rsi_dbg(INFO_ZONE, "Switched to channel - %d\n", channel->hw_value);
 }
 
 /**
@@ -1561,6 +1596,114 @@ static void rsi_mac80211_rfkill_poll(struct ieee80211_hw *hw)
 	mutex_unlock(&common->mutex);
 }
 
+static void rsi_resume_conn_channel(struct rsi_common *common)
+{
+	struct rsi_hw *adapter = common->priv;
+	struct ieee80211_vif *vif;
+	int cnt;
+
+	for (cnt = 0; cnt < RSI_MAX_VIFS; cnt++) {
+		vif = adapter->vifs[cnt];
+		if (!vif)
+			continue;
+
+		if ((vif->type == NL80211_IFTYPE_AP) ||
+		    (vif->type == NL80211_IFTYPE_P2P_GO)) {
+			rsi_switch_channel(adapter, vif);
+			break;
+		}
+		if (((vif->type == NL80211_IFTYPE_STATION) ||
+		     (vif->type == NL80211_IFTYPE_P2P_CLIENT)) &&
+		    vif->bss_conf.assoc) {
+			rsi_switch_channel(adapter, vif);
+			break;
+		}
+	}
+}
+
+void rsi_roc_timeout(unsigned long data)
+{
+	struct rsi_common *common = (struct rsi_common *)data;
+
+	rsi_dbg(INFO_ZONE, "Remain on channel expired\n");
+
+	mutex_lock(&common->mutex);
+	ieee80211_remain_on_channel_expired(common->priv->hw);
+
+	if (timer_pending(&common->roc_timer))
+		del_timer(&common->roc_timer);
+
+	rsi_resume_conn_channel(common);
+	mutex_unlock(&common->mutex);
+}
+
+static int rsi_mac80211_roc(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
+			    struct ieee80211_channel *chan, int duration,
+			    enum ieee80211_roc_type type)
+{
+	struct rsi_hw *adapter = (struct rsi_hw *)hw->priv;
+	struct rsi_common *common = (struct rsi_common *)adapter->priv;
+	int status = 0;
+
+	rsi_dbg(INFO_ZONE, "***** Remain on channel *****\n");
+
+	mutex_lock(&common->mutex);
+	rsi_dbg(INFO_ZONE, "%s: channel: %d duration: %dms\n",
+		__func__, chan->hw_value, duration);
+
+	if (timer_pending(&common->roc_timer)) {
+		rsi_dbg(INFO_ZONE, "Stop on-going ROC\n");
+		del_timer(&common->roc_timer);
+	}
+	common->roc_timer.expires = msecs_to_jiffies(duration) + jiffies;
+	add_timer(&common->roc_timer);
+
+	/* Configure band */
+	if (rsi_band_check(common, chan)) {
+		rsi_dbg(ERR_ZONE, "Failed to set band\n");
+		status = -EINVAL;
+		goto out;
+	}
+
+	/* Configure channel */
+	if (rsi_set_channel(common, chan)) {
+		rsi_dbg(ERR_ZONE, "Failed to set the channel\n");
+		status = -EINVAL;
+		goto out;
+	}
+
+	common->roc_vif = vif;
+	ieee80211_ready_on_channel(hw);
+	rsi_dbg(INFO_ZONE, "%s: Ready on channel :%d\n",
+		__func__, chan->hw_value);
+
+out:
+	mutex_unlock(&common->mutex);
+
+	return status;
+}
+
+static int rsi_mac80211_cancel_roc(struct ieee80211_hw *hw)
+{
+	struct rsi_hw *adapter = hw->priv;
+	struct rsi_common *common = adapter->priv;
+
+	rsi_dbg(INFO_ZONE, "Cancel remain on channel\n");
+
+	mutex_lock(&common->mutex);
+	if (!timer_pending(&common->roc_timer)) {
+		mutex_unlock(&common->mutex);
+		return 0;
+	}
+
+	del_timer(&common->roc_timer);
+
+	rsi_resume_conn_channel(common);
+	mutex_unlock(&common->mutex);
+
+	return 0;
+}
+
 static const struct ieee80211_ops mac80211_ops = {
 	.tx = rsi_mac80211_tx,
 	.start = rsi_mac80211_start,
@@ -1580,6 +1723,8 @@ static const struct ieee80211_ops mac80211_ops = {
 	.set_antenna = rsi_mac80211_set_antenna,
 	.get_antenna = rsi_mac80211_get_antenna,
 	.rfkill_poll = rsi_mac80211_rfkill_poll,
+	.remain_on_channel = rsi_mac80211_roc,
+	.cancel_remain_on_channel = rsi_mac80211_cancel_roc,
 };
 
 /**
@@ -1666,6 +1811,9 @@ int rsi_mac80211_attach(struct rsi_common *common)
 	wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
 
 	/* Wi-Fi direct parameters */
+	wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+	wiphy->flags |= WIPHY_FLAG_OFFCHAN_TX;
+	wiphy->max_remain_on_channel_duration = 10000;
 	hw->max_listen_interval = 10;
 	wiphy->iface_combinations = rsi_iface_combinations;
 	wiphy->n_iface_combinations = ARRAY_SIZE(rsi_iface_combinations);
diff --git a/drivers/net/wireless/rsi/rsi_91x_main.c b/drivers/net/wireless/rsi/rsi_91x_main.c
index 3e1e808..b57bfdc 100644
--- a/drivers/net/wireless/rsi/rsi_91x_main.c
+++ b/drivers/net/wireless/rsi/rsi_91x_main.c
@@ -74,6 +74,8 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
 	struct skb_info *rx_params;
 	struct sk_buff *skb = NULL;
 	u8 payload_offset;
+	struct ieee80211_vif *vif;
+	struct ieee80211_hdr *wh;
 
 	if (WARN(!pkt_len, "%s: Dummy pkt received", __func__))
 		return NULL;
@@ -92,11 +94,13 @@ static struct sk_buff *rsi_prepare_skb(struct rsi_common *common,
 	payload_offset = (extended_desc + FRAME_DESC_SZ);
 	skb_put(skb, pkt_len);
 	memcpy((skb->data), (buffer + payload_offset), skb->len);
+	wh = (struct ieee80211_hdr *)skb->data;
+	vif = rsi_get_vif(common->priv, wh->addr1);
 
 	info = IEEE80211_SKB_CB(skb);
 	rx_params = (struct skb_info *)info->driver_data;
 	rx_params->rssi = rsi_get_rssi(buffer);
-	rx_params->channel = rsi_get_connected_channel(common->priv);
+	rx_params->channel = rsi_get_connected_channel(vif);
 
 	return skb;
 }
@@ -233,6 +237,9 @@ struct rsi_hw *rsi_91x_init(void)
 
 	rsi_default_ps_params(adapter);
 	spin_lock_init(&adapter->ps_lock);
+	common->roc_timer.data = (unsigned long)common;
+	common->roc_timer.function = (void *)&rsi_roc_timeout;
+	init_timer(&common->roc_timer);
 	common->init_done = true;
 	return adapter;
 
diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 082329d..aaf5f32 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -926,13 +926,13 @@ static int rsi_send_reset_mac(struct rsi_common *common)
  *
  * Return: 0 on success, corresponding error code on failure.
  */
-int rsi_band_check(struct rsi_common *common)
+int rsi_band_check(struct rsi_common *common,
+		   struct ieee80211_channel *curchan)
 {
 	struct rsi_hw *adapter = common->priv;
 	struct ieee80211_hw *hw = adapter->hw;
 	u8 prev_bw = common->channel_width;
 	u8 prev_ep = common->endpoint;
-	struct ieee80211_channel *curchan = hw->conf.chandef.chan;
 	int status = 0;
 
 	if (common->band != curchan->band) {
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index e579d69..272e18d 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -79,9 +79,11 @@ static inline int rsi_kill_thread(struct rsi_thread *handle)
 }
 
 void rsi_mac80211_detach(struct rsi_hw *hw);
-u16 rsi_get_connected_channel(struct rsi_hw *adapter);
+u16 rsi_get_connected_channel(struct ieee80211_vif *vif);
 struct rsi_hw *rsi_91x_init(void);
 void rsi_91x_deinit(struct rsi_hw *adapter);
 int rsi_read_pkt(struct rsi_common *common, s32 rcv_pkt_len);
 struct rsi_sta *rsi_find_sta(struct rsi_common *common, u8 *mac_addr);
+struct ieee80211_vif *rsi_get_vif(struct rsi_hw *adapter, u8 *mac);
+void rsi_roc_timeout(unsigned long data);
 #endif
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index a4837fa..fd07b37 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -274,6 +274,8 @@ struct rsi_common {
 
 	/* Wi-Fi direct mode related */
 	bool p2p_enabled;
+	struct timer_list roc_timer;
+	struct ieee80211_vif *roc_vif;
 };
 
 enum host_intf {
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 8bd7dfa..08e3b43 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -633,7 +633,7 @@ void rsi_core_qos_processor(struct rsi_common *common);
 void rsi_core_xmit(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_mgmt_pkt(struct rsi_common *common, struct sk_buff *skb);
 int rsi_send_data_pkt(struct rsi_common *common, struct sk_buff *skb);
-int rsi_band_check(struct rsi_common *common);
+int rsi_band_check(struct rsi_common *common, struct ieee80211_channel *chan);
 int rsi_send_rx_filter_frame(struct rsi_common *common, u16 rx_filter_word);
 int rsi_send_radio_params_update(struct rsi_common *common);
 int rsi_set_antenna(struct rsi_common *common, u8 antenna);
-- 
2.7.4
