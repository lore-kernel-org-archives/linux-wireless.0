Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:45180 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751963Ab2AZMjn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 07:39:43 -0500
Received: by ghrr18 with SMTP id r18so230683ghr.39
        for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 04:39:38 -0800 (PST)
From: Victor Goldenshtein <victorg@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: <kgiori@qca.qualcomm.com>, <mcgrof@frijolero.org>,
	<zefir.kurtisi@neratec.com>, <adrian.chadd@gmail.com>, <j@w1.fi>,
	<johannes@sipsolutions.net>, <coelho@ti.com>, <assaf@ti.com>,
	<yoni.divinsky@ti.com>, <igalc@ti.com>, <adrian@freebsd.org>,
	<nbd@nbd.name>
Subject: [RFC 6/9] mac80211: add ap channel switch command/event
Date: Thu, 26 Jan 2012 14:38:01 +0200
Message-Id: <1327581484-22047-7-git-send-email-victorg@ti.com> (sfid-20120126_133953_381597_9794A966)
In-Reply-To: <1327581484-22047-1-git-send-email-victorg@ti.com>
References: <1327581484-22047-1-git-send-email-victorg@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

New ieee80211_ap_process_chanswitch(), to handle a channel switch
request for AP/GO.

New 'post_switch_block_tx' parameter in 'ieee80211_channel_switch'
structure, which indicates whether transmission must be blocked after
the scheduled channel switch, it should be set if the target channel
is DFS channel.

New ieee80211_ap_ch_switch_complete_notify() which notifies upper
layers about channel switch complete event.

Signed-off-by: Victor Goldenshtein <victorg@ti.com>
---
 include/net/mac80211.h |   15 +++++++++++++++
 net/mac80211/cfg.c     |   34 ++++++++++++++++++++++++++++++++++
 net/mac80211/mlme.c    |    9 +++++++++
 3 files changed, 58 insertions(+), 0 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d08b808..b0f4e67 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -841,12 +841,16 @@ struct ieee80211_conf {
  *	the driver passed into mac80211.
  * @block_tx: Indicates whether transmission must be blocked before the
  *	scheduled channel switch, as indicated by the AP.
+ * @post_switch_block_tx: Indicates whether transmission must be blocked after
+ *	the scheduled channel switch, this should be set if the target channel
+ *	is DFS channel.
  * @channel: the new channel to switch to
  * @count: the number of TBTT's until the channel switch event
  */
 struct ieee80211_channel_switch {
 	u64 timestamp;
 	bool block_tx;
+	bool post_switch_block_tx;
 	struct ieee80211_channel *channel;
 	u8 count;
 };
@@ -3421,6 +3425,17 @@ void ieee80211_radar_detected_notify(struct ieee80211_vif *vif,
 				     u16 freq, gfp_t gfp);
 
 /**
+ * ieee80211_ap_ch_switch_complete_notify - inform a configured connection that
+ * channel switch is complete
+ *
+ * @vif: &struct ieee80211_vif pointer from the add_interface callback.
+ * @gfp: context flags
+ *
+ */
+void ieee80211_ap_ch_switch_complete_notify(struct ieee80211_vif *vif,
+					    u16 freq, gfp_t gfp);
+
+/**
  * ieee80211_get_operstate - get the operstate of the vif
  *
  * @vif: &struct ieee80211_vif pointer from the add_interface callback.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 2d85a97..89393c8 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2044,6 +2044,39 @@ static int ieee80211_dfs_en_tx(struct wiphy *wiphy, struct net_device *dev)
 	return ret;
 }
 
+static int ieee80211_ap_process_chanswitch(struct wiphy *wiphy,
+					   struct net_device *dev,
+					   u32 count, bool block_tx,
+					   bool post_switch_block_tx,
+					   u32 new_freq)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_channel *new_ch;
+	struct ieee80211_channel_switch ch_switch;
+
+	new_ch = ieee80211_get_channel(sdata->local->hw.wiphy, new_freq);
+	if (!new_ch || new_ch->flags & IEEE80211_CHAN_DISABLED) {
+		wiphy_debug(local->hw.wiphy,
+			    "failed channel switch on freq: %d\n", new_freq);
+		return -EINVAL;
+	}
+
+	if (!local->ops->channel_switch)
+		return -EOPNOTSUPP;
+
+	memset(&ch_switch, 0, sizeof(ch_switch));
+	ch_switch.channel = new_ch;
+	ch_switch.count = count;
+	ch_switch.block_tx = block_tx;
+	ch_switch.post_switch_block_tx = post_switch_block_tx;
+
+	mutex_lock(&local->mtx);
+	drv_channel_switch(local, &ch_switch);
+	mutex_unlock(&local->mtx);
+	return 0;
+}
+
 static enum work_done_result
 ieee80211_offchan_tx_done(struct ieee80211_work *wk, struct sk_buff *skb)
 {
@@ -2793,4 +2826,5 @@ struct cfg80211_ops mac80211_config_ops = {
 	.set_noack_map = ieee80211_set_noack_map,
 	.dfs_start_radar_detection = ieee80211_dfs_start_radar_detection,
 	.dfs_en_tx = ieee80211_dfs_en_tx,
+	.ap_channel_switch = ieee80211_ap_process_chanswitch,
 };
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 57aeb84..a39b8ed 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2878,6 +2878,15 @@ void ieee80211_radar_detected_notify(struct ieee80211_vif *vif,
 }
 EXPORT_SYMBOL(ieee80211_radar_detected_notify);
 
+void ieee80211_ap_ch_switch_complete_notify(struct ieee80211_vif *vif,
+					    u16 freq, gfp_t gfp)
+{
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
+
+	cfg80211_ap_ch_switch_complete_notify(sdata->dev, freq, gfp);
+}
+EXPORT_SYMBOL(ieee80211_ap_ch_switch_complete_notify);
+
 unsigned char ieee80211_get_operstate(struct ieee80211_vif *vif)
 {
 	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
-- 
1.7.5.4

