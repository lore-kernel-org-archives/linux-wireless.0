Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52631 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab2INMiq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Sep 2012 08:38:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 10/10] mac80211_hwsim: use channel contexts
Date: Fri, 14 Sep 2012 14:37:13 +0200
Message-Id: <1347626233-21916-11-git-send-email-johannes@sipsolutions.net> (sfid-20120914_143850_791899_CD2CD4B0)
In-Reply-To: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
References: <1347626233-21916-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To use mac80211_hwsim for testing channel contexts it
has to support them, and for that it has to support
hw scan and hw-remain-on-channel.

Since it's pure software, the off-channel activities
are really not off-channel but listening and sending
on a second channel. Also, the multi-channel isn't
really doing TDM, it's just on both channels at the
same time.

Note that this breaks wmediumd right now as it doesn't
propagate the channel.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c |  461 ++++++++++++++++++++++++++-------
 1 file changed, 372 insertions(+), 89 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e603adb..383b7a8 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -44,9 +44,9 @@ static int radios = 2;
 module_param(radios, int, 0444);
 MODULE_PARM_DESC(radios, "Number of simulated radios");
 
-static bool fake_hw_scan;
-module_param(fake_hw_scan, bool, 0444);
-MODULE_PARM_DESC(fake_hw_scan, "Install fake (no-op) hw-scan handler");
+static int channels = 1;
+module_param(channels, int, 0444);
+MODULE_PARM_DESC(channels, "Number of concurrent channels");
 
 /**
  * enum hwsim_regtest - the type of regulatory tests we offer
@@ -166,7 +166,9 @@ struct hwsim_vif_priv {
 static inline void hwsim_check_magic(struct ieee80211_vif *vif)
 {
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
-	WARN_ON(vp->magic != HWSIM_VIF_MAGIC);
+	WARN(vp->magic != HWSIM_VIF_MAGIC,
+	     "Invalid VIF (%p) magic %#x, %pM, %d/%d\n",
+	     vif, vp->magic, vif->addr, vif->type, vif->p2p);
 }
 
 static inline void hwsim_set_magic(struct ieee80211_vif *vif)
@@ -185,7 +187,7 @@ struct hwsim_sta_priv {
 	u32 magic;
 };
 
-#define HWSIM_STA_MAGIC	0x6d537748
+#define HWSIM_STA_MAGIC	0x6d537749
 
 static inline void hwsim_check_sta_magic(struct ieee80211_sta *sta)
 {
@@ -205,6 +207,30 @@ static inline void hwsim_clear_sta_magic(struct ieee80211_sta *sta)
 	sp->magic = 0;
 }
 
+struct hwsim_chanctx_priv {
+	u32 magic;
+};
+
+#define HWSIM_CHANCTX_MAGIC 0x6d53774a
+
+static inline void hwsim_check_chanctx_magic(struct ieee80211_chanctx_conf *c)
+{
+	struct hwsim_chanctx_priv *cp = (void *)c->drv_priv;
+	WARN_ON(cp->magic != HWSIM_CHANCTX_MAGIC);
+}
+
+static inline void hwsim_set_chanctx_magic(struct ieee80211_chanctx_conf *c)
+{
+	struct hwsim_chanctx_priv *cp = (void *)c->drv_priv;
+	cp->magic = HWSIM_CHANCTX_MAGIC;
+}
+
+static inline void hwsim_clear_chanctx_magic(struct ieee80211_chanctx_conf *c)
+{
+	struct hwsim_chanctx_priv *cp = (void *)c->drv_priv;
+	cp->magic = 0;
+}
+
 static struct class *hwsim_class;
 
 static struct net_device *hwsim_mon; /* global monitor netdev */
@@ -299,6 +325,13 @@ struct mac80211_hwsim_data {
 
 	struct mac_address addresses[2];
 
+	struct ieee80211_channel *tmp_chan;
+	struct delayed_work roc_done;
+	struct delayed_work hw_scan;
+	struct cfg80211_scan_request *hw_scan_request;
+	struct ieee80211_vif *hw_scan_vif;
+	int scan_chan_idx;
+
 	struct ieee80211_channel *channel;
 	unsigned long beacon_int; /* in jiffies unit */
 	unsigned int rx_filter;
@@ -396,7 +429,8 @@ static void mac80211_hwsim_set_tsf(struct ieee80211_hw *hw,
 }
 
 static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
-				      struct sk_buff *tx_skb)
+				      struct sk_buff *tx_skb,
+				      struct ieee80211_channel *chan)
 {
 	struct mac80211_hwsim_data *data = hw->priv;
 	struct sk_buff *skb;
@@ -423,7 +457,7 @@ static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 	hdr->rt_tsft = __mac80211_hwsim_get_tsf(data);
 	hdr->rt_flags = 0;
 	hdr->rt_rate = txrate->bitrate / 5;
-	hdr->rt_channel = cpu_to_le16(data->channel->center_freq);
+	hdr->rt_channel = cpu_to_le16(chan->center_freq);
 	flags = IEEE80211_CHAN_2GHZ;
 	if (txrate->flags & IEEE80211_RATE_ERP_G)
 		flags |= IEEE80211_CHAN_OFDM;
@@ -441,9 +475,9 @@ static void mac80211_hwsim_monitor_rx(struct ieee80211_hw *hw,
 }
 
 
-static void mac80211_hwsim_monitor_ack(struct ieee80211_hw *hw, const u8 *addr)
+static void mac80211_hwsim_monitor_ack(struct ieee80211_channel *chan,
+				       const u8 *addr)
 {
-	struct mac80211_hwsim_data *data = hw->priv;
 	struct sk_buff *skb;
 	struct hwsim_radiotap_hdr *hdr;
 	u16 flags;
@@ -464,7 +498,7 @@ static void mac80211_hwsim_monitor_ack(struct ieee80211_hw *hw, const u8 *addr)
 					  (1 << IEEE80211_RADIOTAP_CHANNEL));
 	hdr->rt_flags = 0;
 	hdr->rt_rate = 0;
-	hdr->rt_channel = cpu_to_le16(data->channel->center_freq);
+	hdr->rt_channel = cpu_to_le16(chan->center_freq);
 	flags = IEEE80211_CHAN_2GHZ;
 	hdr->rt_chbitmask = cpu_to_le16(flags);
 
@@ -629,8 +663,38 @@ nla_put_failure:
 	printk(KERN_DEBUG "mac80211_hwsim: error occurred in %s\n", __func__);
 }
 
+static bool hwsim_chans_compat(struct ieee80211_channel *c1,
+			       struct ieee80211_channel *c2)
+{
+	if (!c1 || !c2)
+		return false;
+
+	return c1->center_freq == c2->center_freq;
+}
+
+struct tx_iter_data {
+	struct ieee80211_channel *channel;
+	bool receive;
+};
+
+static void mac80211_hwsim_tx_iter(void *_data, u8 *addr,
+				   struct ieee80211_vif *vif)
+{
+	struct tx_iter_data *data = _data;
+
+	if (!vif->chanctx_conf)
+		return;
+
+	if (!hwsim_chans_compat(data->channel,
+				rcu_dereference(vif->chanctx_conf)->channel))
+		return;
+
+	data->receive = true;
+}
+
 static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
-					  struct sk_buff *skb)
+					  struct sk_buff *skb,
+					  struct ieee80211_channel *chan)
 {
 	struct mac80211_hwsim_data *data = hw->priv, *data2;
 	bool ack = false;
@@ -646,8 +710,8 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 
 	memset(&rx_status, 0, sizeof(rx_status));
 	rx_status.flag |= RX_FLAG_MACTIME_MPDU;
-	rx_status.freq = data->channel->center_freq;
-	rx_status.band = data->channel->band;
+	rx_status.freq = chan->center_freq;
+	rx_status.band = chan->band;
 	rx_status.rate_idx = info->control.rates[0].idx;
 	if (info->control.rates[0].flags & IEEE80211_TX_RC_MCS)
 		rx_status.flag |= RX_FLAG_HT;
@@ -673,16 +737,30 @@ static bool mac80211_hwsim_tx_frame_no_nl(struct ieee80211_hw *hw,
 	list_for_each_entry(data2, &hwsim_radios, list) {
 		struct sk_buff *nskb;
 		struct ieee80211_mgmt *mgmt;
+		struct tx_iter_data tx_iter_data = {
+			.receive = false,
+			.channel = chan,
+		};
 
 		if (data == data2)
 			continue;
 
-		if (data2->idle || !data2->started ||
-		    !hwsim_ps_rx_ok(data2, skb) || !data2->channel ||
-		    data->channel->center_freq != data2->channel->center_freq ||
-		    !(data->group & data2->group))
+		if (!data2->started || (data2->idle && !data2->tmp_chan) ||
+		    !hwsim_ps_rx_ok(data2, skb))
 			continue;
 
+		if (!(data->group & data2->group))
+			continue;
+
+		if (!hwsim_chans_compat(chan, data2->tmp_chan) &&
+		    !hwsim_chans_compat(chan, data2->channel)) {
+			ieee80211_iterate_active_interfaces_atomic(
+				data2->hw, mac80211_hwsim_tx_iter,
+				&tx_iter_data);
+			if (!tx_iter_data.receive)
+				continue;
+		}
+
 		nskb = skb_copy(skb, GFP_ATOMIC);
 		if (nskb == NULL)
 			continue;
@@ -713,18 +791,43 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 			      struct ieee80211_tx_control *control,
 			      struct sk_buff *skb)
 {
+	struct mac80211_hwsim_data *data = hw->priv;
+	struct ieee80211_tx_info *txi = IEEE80211_SKB_CB(skb);
+	struct ieee80211_chanctx_conf *chanctx_conf;
+	struct ieee80211_channel *channel;
 	bool ack;
-	struct ieee80211_tx_info *txi;
 	u32 _pid;
 
-	mac80211_hwsim_monitor_rx(hw, skb);
-
-	if (skb->len < 10) {
+	if (WARN_ON(skb->len < 10)) {
 		/* Should not happen; just a sanity check for addr1 use */
 		dev_kfree_skb(skb);
 		return;
 	}
 
+	if (txi->hw_queue == 4) {
+		channel = data->tmp_chan;
+	} else {
+		chanctx_conf = rcu_dereference(txi->control.vif->chanctx_conf);
+		if (chanctx_conf)
+			channel = chanctx_conf->channel;
+		else
+			channel = NULL;
+	}
+
+	if (WARN(!channel, "TX w/o channel - queue = %d\n", txi->hw_queue)) {
+		dev_kfree_skb(skb);
+		return;
+	}
+
+	if (txi->control.vif)
+		hwsim_check_magic(txi->control.vif);
+	if (control->sta)
+		hwsim_check_sta_magic(control->sta);
+
+	txi->rate_driver_data[0] = channel;
+
+	mac80211_hwsim_monitor_rx(hw, skb, channel);
+
 	/* wmediumd mode check */
 	_pid = ACCESS_ONCE(wmediumd_pid);
 
@@ -732,15 +835,13 @@ static void mac80211_hwsim_tx(struct ieee80211_hw *hw,
 		return mac80211_hwsim_tx_frame_nl(hw, skb, _pid);
 
 	/* NO wmediumd detected, perfect medium simulation */
-	ack = mac80211_hwsim_tx_frame_no_nl(hw, skb);
+	ack = mac80211_hwsim_tx_frame_no_nl(hw, skb, channel);
 
 	if (ack && skb->len >= 16) {
 		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-		mac80211_hwsim_monitor_ack(hw, hdr->addr2);
+		mac80211_hwsim_monitor_ack(channel, hdr->addr2);
 	}
 
-	txi = IEEE80211_SKB_CB(skb);
-
 	ieee80211_tx_info_clear_status(txi);
 
 	/* frame was transmitted at most favorable rate at first attempt */
@@ -778,6 +879,13 @@ static int mac80211_hwsim_add_interface(struct ieee80211_hw *hw,
 		    __func__, ieee80211_vif_type_p2p(vif),
 		    vif->addr);
 	hwsim_set_magic(vif);
+
+	vif->cab_queue = 0;
+	vif->hw_queue[IEEE80211_AC_VO] = 0;
+	vif->hw_queue[IEEE80211_AC_VI] = 1;
+	vif->hw_queue[IEEE80211_AC_BE] = 2;
+	vif->hw_queue[IEEE80211_AC_BK] = 3;
+
 	return 0;
 }
 
@@ -807,14 +915,26 @@ static void mac80211_hwsim_remove_interface(
 	hwsim_clear_magic(vif);
 }
 
+static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
+				    struct sk_buff *skb,
+				    struct ieee80211_channel *chan)
+{
+	u32 _pid = ACCESS_ONCE(wmediumd_pid);
+
+	mac80211_hwsim_monitor_rx(hw, skb, chan);
+
+	if (_pid)
+		return mac80211_hwsim_tx_frame_nl(hw, skb, _pid);
+
+	mac80211_hwsim_tx_frame_no_nl(hw, skb, chan);
+	dev_kfree_skb(skb);
+}
 
 static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 				     struct ieee80211_vif *vif)
 {
 	struct ieee80211_hw *hw = arg;
 	struct sk_buff *skb;
-	struct ieee80211_tx_info *info;
-	u32 _pid;
 
 	hwsim_check_magic(vif);
 
@@ -826,18 +946,9 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 	skb = ieee80211_beacon_get(hw, vif);
 	if (skb == NULL)
 		return;
-	info = IEEE80211_SKB_CB(skb);
 
-	mac80211_hwsim_monitor_rx(hw, skb);
-
-	/* wmediumd mode check */
-	_pid = ACCESS_ONCE(wmediumd_pid);
-
-	if (_pid)
-		return mac80211_hwsim_tx_frame_nl(hw, skb, _pid);
-
-	mac80211_hwsim_tx_frame_no_nl(hw, skb);
-	dev_kfree_skb(skb);
+	mac80211_hwsim_tx_frame(hw, skb,
+				rcu_dereference(vif->chanctx_conf)->channel);
 }
 
 
@@ -877,7 +988,7 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	wiphy_debug(hw->wiphy,
 		    "%s (freq=%d/%s idle=%d ps=%d smps=%s)\n",
 		    __func__,
-		    conf->channel->center_freq,
+		    conf->channel ? conf->channel->center_freq : 0,
 		    hwsim_chantypes[conf->channel_type],
 		    !!(conf->flags & IEEE80211_CONF_IDLE),
 		    !!(conf->flags & IEEE80211_CONF_PS),
@@ -886,6 +997,9 @@ static int mac80211_hwsim_config(struct ieee80211_hw *hw, u32 changed)
 	data->idle = !!(conf->flags & IEEE80211_CONF_IDLE);
 
 	data->channel = conf->channel;
+
+	WARN_ON(data->channel && channels > 1);
+
 	data->power_level = conf->power_level;
 	if (!data->started || !data->beacon_int)
 		del_timer(&data->beacon_timer);
@@ -1166,45 +1280,102 @@ static void mac80211_hwsim_flush(struct ieee80211_hw *hw, bool drop)
 	/* Not implemented, queues only on kernel side */
 }
 
-struct hw_scan_done {
-	struct delayed_work w;
-	struct ieee80211_hw *hw;
-};
-
-static void hw_scan_done(struct work_struct *work)
+static void hw_scan_work(struct work_struct *work)
 {
-	struct hw_scan_done *hsd =
-		container_of(work, struct hw_scan_done, w.work);
+	struct mac80211_hwsim_data *hwsim =
+		container_of(work, struct mac80211_hwsim_data, hw_scan.work);
+	struct cfg80211_scan_request *req = hwsim->hw_scan_request;
+	int dwell, i;
+
+	mutex_lock(&hwsim->mutex);
+	if (hwsim->scan_chan_idx >= req->n_channels) {
+		wiphy_debug(hwsim->hw->wiphy, "hw scan complete\n");
+		ieee80211_scan_completed(hwsim->hw, false);
+		hwsim->hw_scan_request = NULL;
+		hwsim->hw_scan_vif = NULL;
+		hwsim->tmp_chan = NULL;
+		mutex_unlock(&hwsim->mutex);
+		return;
+	}
 
-	ieee80211_scan_completed(hsd->hw, false);
-	kfree(hsd);
+	wiphy_debug(hwsim->hw->wiphy, "hw scan %d MHz\n",
+		    req->channels[hwsim->scan_chan_idx]->center_freq);
+
+	hwsim->tmp_chan = req->channels[hwsim->scan_chan_idx];
+	if (hwsim->tmp_chan->flags & IEEE80211_CHAN_PASSIVE_SCAN ||
+	    !req->n_ssids) {
+		dwell = 120;
+	} else {
+		dwell = 30;
+		/* send probes */
+		for (i = 0; i < req->n_ssids; i++) {
+			struct sk_buff *probe;
+
+			probe = ieee80211_probereq_get(hwsim->hw,
+						       hwsim->hw_scan_vif,
+						       req->ssids[i].ssid,
+						       req->ssids[i].ssid_len,
+						       req->ie, req->ie_len);
+			if (!probe)
+				continue;
+			local_bh_disable();
+			mac80211_hwsim_tx_frame(hwsim->hw, probe,
+						hwsim->tmp_chan);
+			local_bh_enable();
+		}
+	}
+	ieee80211_queue_delayed_work(hwsim->hw, &hwsim->hw_scan,
+				     msecs_to_jiffies(dwell));
+	hwsim->scan_chan_idx++;
+	mutex_unlock(&hwsim->mutex);
 }
 
 static int mac80211_hwsim_hw_scan(struct ieee80211_hw *hw,
 				  struct ieee80211_vif *vif,
 				  struct cfg80211_scan_request *req)
 {
-	struct hw_scan_done *hsd = kzalloc(sizeof(*hsd), GFP_KERNEL);
+	struct mac80211_hwsim_data *hwsim = hw->priv;
 	int i;
 
-	if (!hsd)
-		return -ENOMEM;
-
-	hsd->hw = hw;
-	INIT_DELAYED_WORK(&hsd->w, hw_scan_done);
+	mutex_lock(&hwsim->mutex);
+	if (WARN_ON(hwsim->tmp_chan || hwsim->hw_scan_request)) {
+		mutex_unlock(&hwsim->mutex);
+		return -EBUSY;
+	}
+	hwsim->hw_scan_request = req;
+	hwsim->hw_scan_vif = vif;
+	hwsim->scan_chan_idx = 0;
+	mutex_unlock(&hwsim->mutex);
 
-	printk(KERN_DEBUG "hwsim hw_scan request\n");
+	wiphy_debug(hw->wiphy, "hwsim hw_scan request\n");
 	for (i = 0; i < req->n_channels; i++)
 		printk(KERN_DEBUG "hwsim hw_scan freq %d\n",
 			req->channels[i]->center_freq);
 	print_hex_dump(KERN_DEBUG, "scan IEs: ", DUMP_PREFIX_OFFSET,
 			16, 1, req->ie, req->ie_len, 1);
 
-	ieee80211_queue_delayed_work(hw, &hsd->w, 2 * HZ);
+	ieee80211_queue_delayed_work(hwsim->hw, &hwsim->hw_scan, 0);
 
 	return 0;
 }
 
+static void mac80211_hwsim_cancel_hw_scan(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif)
+{
+	struct mac80211_hwsim_data *hwsim = hw->priv;
+
+	wiphy_debug(hw->wiphy, "hwsim cancel_hw_scan\n");
+
+	cancel_delayed_work_sync(&hwsim->hw_scan);
+
+	mutex_lock(&hwsim->mutex);
+	ieee80211_scan_completed(hwsim->hw, true);
+	hwsim->tmp_chan = NULL;
+	hwsim->hw_scan_request = NULL;
+	hwsim->hw_scan_vif = NULL;
+	mutex_unlock(&hwsim->mutex);
+}
+
 static void mac80211_hwsim_sw_scan(struct ieee80211_hw *hw)
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
@@ -1235,6 +1406,103 @@ static void mac80211_hwsim_sw_scan_complete(struct ieee80211_hw *hw)
 	mutex_unlock(&hwsim->mutex);
 }
 
+static void hw_roc_done(struct work_struct *work)
+{
+	struct mac80211_hwsim_data *hwsim =
+		container_of(work, struct mac80211_hwsim_data, roc_done.work);
+
+	mutex_lock(&hwsim->mutex);
+	ieee80211_remain_on_channel_expired(hwsim->hw);
+	hwsim->tmp_chan = NULL;
+	mutex_unlock(&hwsim->mutex);
+
+	wiphy_debug(hwsim->hw->wiphy, "hwsim ROC expired\n");
+}
+
+static int mac80211_hwsim_roc(struct ieee80211_hw *hw,
+			      struct ieee80211_channel *chan,
+			      enum nl80211_channel_type channel_type,
+			      int duration)
+{
+	struct mac80211_hwsim_data *hwsim = hw->priv;
+
+	mutex_lock(&hwsim->mutex);
+	if (WARN_ON(hwsim->tmp_chan || hwsim->hw_scan_request)) {
+		mutex_unlock(&hwsim->mutex);
+		return -EBUSY;
+	}
+
+	hwsim->tmp_chan = chan;
+	mutex_unlock(&hwsim->mutex);
+
+	wiphy_debug(hw->wiphy, "hwsim ROC (%d MHz, %d ms)\n",
+		    chan->center_freq, duration);
+
+	ieee80211_queue_delayed_work(hw, &hwsim->roc_done,
+				     jiffies + msecs_to_jiffies(duration));
+	return 0;
+}
+
+static int mac80211_hwsim_croc(struct ieee80211_hw *hw)
+{
+	struct mac80211_hwsim_data *hwsim = hw->priv;
+
+	cancel_delayed_work_sync(&hwsim->roc_done);
+
+	mutex_lock(&hwsim->mutex);
+	hwsim->tmp_chan = NULL;
+	mutex_unlock(&hwsim->mutex);
+
+	wiphy_debug(hw->wiphy, "hwsim ROC canceled\n");
+
+	return 0;
+}
+
+static int mac80211_hwsim_add_chanctx(struct ieee80211_hw *hw,
+				      struct ieee80211_chanctx_conf *ctx)
+{
+	hwsim_set_chanctx_magic(ctx);
+	wiphy_debug(hw->wiphy, "add channel context %d MHz/%d\n",
+		    ctx->channel->center_freq, ctx->channel_type);
+	return 0;
+}
+
+static void mac80211_hwsim_remove_chanctx(struct ieee80211_hw *hw,
+					  struct ieee80211_chanctx_conf *ctx)
+{
+	wiphy_debug(hw->wiphy, "remove channel context %d MHz/%d\n",
+		    ctx->channel->center_freq, ctx->channel_type);
+	hwsim_check_chanctx_magic(ctx);
+	hwsim_clear_chanctx_magic(ctx);
+}
+
+static void mac80211_hwsim_change_chanctx(struct ieee80211_hw *hw,
+					  struct ieee80211_chanctx_conf *ctx,
+					  u32 changed)
+{
+	hwsim_check_chanctx_magic(ctx);
+	wiphy_debug(hw->wiphy, "change channel context %#x (%d MHz/%d)\n",
+		    changed, ctx->channel->center_freq, ctx->channel_type);
+}
+
+static int mac80211_hwsim_assign_vif_chanctx(struct ieee80211_hw *hw,
+					     struct ieee80211_vif *vif,
+					     struct ieee80211_chanctx_conf *ctx)
+{
+	hwsim_check_magic(vif);
+	hwsim_check_chanctx_magic(ctx);
+
+	return 0;
+}
+
+static void mac80211_hwsim_unassign_vif_chanctx(struct ieee80211_hw *hw,
+						struct ieee80211_vif *vif,
+						struct ieee80211_chanctx_conf *ctx)
+{
+	hwsim_check_magic(vif);
+	hwsim_check_chanctx_magic(ctx);
+}
+
 static struct ieee80211_ops mac80211_hwsim_ops =
 {
 	.tx = mac80211_hwsim_tx,
@@ -1315,7 +1583,6 @@ static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 	struct ieee80211_pspoll *pspoll;
-	u32 _pid;
 
 	if (!vp->assoc)
 		return;
@@ -1335,25 +1602,18 @@ static void hwsim_send_ps_poll(void *dat, u8 *mac, struct ieee80211_vif *vif)
 	memcpy(pspoll->bssid, vp->bssid, ETH_ALEN);
 	memcpy(pspoll->ta, mac, ETH_ALEN);
 
-	/* wmediumd mode check */
-	_pid = ACCESS_ONCE(wmediumd_pid);
-
-	if (_pid)
-		return mac80211_hwsim_tx_frame_nl(data->hw, skb, _pid);
-
-	if (!mac80211_hwsim_tx_frame_no_nl(data->hw, skb))
-		printk(KERN_DEBUG "%s: PS-poll frame not ack'ed\n", __func__);
-	dev_kfree_skb(skb);
+	rcu_read_lock();
+	mac80211_hwsim_tx_frame(data->hw, skb,
+				rcu_dereference(vif->chanctx_conf)->channel);
+	rcu_read_unlock();
 }
 
-
 static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 				struct ieee80211_vif *vif, int ps)
 {
 	struct hwsim_vif_priv *vp = (void *)vif->drv_priv;
 	struct sk_buff *skb;
 	struct ieee80211_hdr *hdr;
-	u32 _pid;
 
 	if (!vp->assoc)
 		return;
@@ -1374,15 +1634,10 @@ static void hwsim_send_nullfunc(struct mac80211_hwsim_data *data, u8 *mac,
 	memcpy(hdr->addr2, mac, ETH_ALEN);
 	memcpy(hdr->addr3, vp->bssid, ETH_ALEN);
 
-	/* wmediumd mode check */
-	_pid = ACCESS_ONCE(wmediumd_pid);
-
-	if (_pid)
-		return mac80211_hwsim_tx_frame_nl(data->hw, skb, _pid);
-
-	if (!mac80211_hwsim_tx_frame_no_nl(data->hw, skb))
-		printk(KERN_DEBUG "%s: nullfunc frame not ack'ed\n", __func__);
-	dev_kfree_skb(skb);
+	rcu_read_lock();
+	mac80211_hwsim_tx_frame(data->hw, skb,
+				rcu_dereference(vif->chanctx_conf)->channel);
+	rcu_read_unlock();
 }
 
 
@@ -1551,7 +1806,8 @@ static int hwsim_tx_info_frame_received_nl(struct sk_buff *skb_2,
 	   (hwsim_flags & HWSIM_TX_STAT_ACK)) {
 		if (skb->len >= 16) {
 			hdr = (struct ieee80211_hdr *) skb->data;
-			mac80211_hwsim_monitor_ack(data2->hw, hdr->addr2);
+			mac80211_hwsim_monitor_ack(txi->rate_driver_data[0],
+						   hdr->addr2);
 		}
 		txi->flags |= IEEE80211_TX_STAT_ACK;
 	}
@@ -1566,7 +1822,7 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 					  struct genl_info *info)
 {
 
-	struct mac80211_hwsim_data  *data2;
+	struct mac80211_hwsim_data *data2;
 	struct ieee80211_rx_status rx_status;
 	struct mac_address *dst;
 	int frame_data_len;
@@ -1574,9 +1830,9 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 	struct sk_buff *skb = NULL;
 
 	if (!info->attrs[HWSIM_ATTR_ADDR_RECEIVER] ||
-	   !info->attrs[HWSIM_ATTR_FRAME] ||
-	   !info->attrs[HWSIM_ATTR_RX_RATE] ||
-	   !info->attrs[HWSIM_ATTR_SIGNAL])
+	    !info->attrs[HWSIM_ATTR_FRAME] ||
+	    !info->attrs[HWSIM_ATTR_RX_RATE] ||
+	    !info->attrs[HWSIM_ATTR_SIGNAL])
 		goto out;
 
 	dst = (struct mac_address *)nla_data(
@@ -1604,13 +1860,15 @@ static int hwsim_cloned_frame_received_nl(struct sk_buff *skb_2,
 
 	/* check if radio is configured properly */
 
-	if (data2->idle || !data2->started || !data2->channel)
+	if (data2->idle || !data2->started)
 		goto out;
 
 	/*A frame is received from user space*/
 	memset(&rx_status, 0, sizeof(rx_status));
+#if 0
 	rx_status.freq = data2->channel->center_freq;
 	rx_status.band = data2->channel->band;
+#endif
 	rx_status.rate_idx = nla_get_u32(info->attrs[HWSIM_ATTR_RX_RATE]);
 	rx_status.signal = nla_get_u32(info->attrs[HWSIM_ATTR_SIGNAL]);
 
@@ -1732,7 +1990,7 @@ static const struct ieee80211_iface_limit hwsim_if_limits[] = {
 	{ .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) },
 };
 
-static const struct ieee80211_iface_combination hwsim_if_comb = {
+static struct ieee80211_iface_combination hwsim_if_comb = {
 	.limits = hwsim_if_limits,
 	.n_limits = ARRAY_SIZE(hwsim_if_limits),
 	.max_interfaces = 2048,
@@ -1750,10 +2008,30 @@ static int __init init_mac80211_hwsim(void)
 	if (radios < 1 || radios > 100)
 		return -EINVAL;
 
-	if (fake_hw_scan) {
+	if (channels < 1)
+		return -EINVAL;
+
+	if (channels > 1) {
+		hwsim_if_comb.num_different_channels = channels;
 		mac80211_hwsim_ops.hw_scan = mac80211_hwsim_hw_scan;
+		mac80211_hwsim_ops.cancel_hw_scan =
+			mac80211_hwsim_cancel_hw_scan;
 		mac80211_hwsim_ops.sw_scan_start = NULL;
 		mac80211_hwsim_ops.sw_scan_complete = NULL;
+		mac80211_hwsim_ops.remain_on_channel =
+			mac80211_hwsim_roc;
+		mac80211_hwsim_ops.cancel_remain_on_channel =
+			mac80211_hwsim_croc;
+		mac80211_hwsim_ops.add_chanctx =
+			mac80211_hwsim_add_chanctx;
+		mac80211_hwsim_ops.remove_chanctx =
+			mac80211_hwsim_remove_chanctx;
+		mac80211_hwsim_ops.change_chanctx =
+			mac80211_hwsim_change_chanctx;
+		mac80211_hwsim_ops.assign_vif_chanctx =
+			mac80211_hwsim_assign_vif_chanctx;
+		mac80211_hwsim_ops.unassign_vif_chanctx =
+			mac80211_hwsim_unassign_vif_chanctx;
 	}
 
 	spin_lock_init(&hwsim_radio_lock);
@@ -1803,13 +2081,17 @@ static int __init init_mac80211_hwsim(void)
 		hw->wiphy->iface_combinations = &hwsim_if_comb;
 		hw->wiphy->n_iface_combinations = 1;
 
-		if (fake_hw_scan) {
+		if (channels > 1) {
 			hw->wiphy->max_scan_ssids = 255;
 			hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 		}
 
+		INIT_DELAYED_WORK(&data->roc_done, hw_roc_done);
+		INIT_DELAYED_WORK(&data->hw_scan, hw_scan_work);
+
 		hw->channel_change_time = 1;
-		hw->queues = 4;
+		hw->queues = 5;
+		hw->offchannel_tx_hw_queue = 4;
 		hw->wiphy->interface_modes =
 			BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_AP) |
@@ -1824,7 +2106,8 @@ static int __init init_mac80211_hwsim(void)
 			    IEEE80211_HW_SUPPORTS_STATIC_SMPS |
 			    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 			    IEEE80211_HW_AMPDU_AGGREGATION |
-			    IEEE80211_HW_WANT_MONITOR_VIF;
+			    IEEE80211_HW_WANT_MONITOR_VIF |
+			    IEEE80211_HW_QUEUE_CONTROL;
 
 		hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 				    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
-- 
1.7.10.4

