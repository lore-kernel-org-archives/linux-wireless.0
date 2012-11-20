Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42067 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab2KTVot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:44:49 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/10] cfg80211: remove remain-on-channel channel type
Date: Tue, 20 Nov 2012 22:45:07 +0100
Message-Id: <1353447916-17304-2-git-send-email-johannes@sipsolutions.net> (sfid-20121120_224455_512312_7824F0C7)
In-Reply-To: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
References: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As mwifiex (and mac80211 in the software case) are the
only drivers actually implementing remain-on-channel
with channel type, userspace can't be relying on it.
This is the case, as it's used only for P2P operations
right now.

Rather than adding a flag to tell userspace whether or
not it can actually rely on it, simplify all the code
by removing the ability to use different channel types.
Leave only the validation of the attribute, so that if
we extend it again later (with the needed capability
flag), it can't break userspace sending invalid data.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c  |  7 ++--
 drivers/net/wireless/ath/ath6kl/wmi.c       |  5 ++-
 drivers/net/wireless/iwlwifi/dvm/dev.h      |  1 -
 drivers/net/wireless/iwlwifi/dvm/mac80211.c |  2 --
 drivers/net/wireless/mac80211_hwsim.c       |  1 -
 drivers/net/wireless/mwifiex/cfg80211.c     | 16 +++------
 drivers/net/wireless/mwifiex/main.h         |  2 --
 drivers/net/wireless/mwifiex/sta_event.c    |  1 -
 drivers/net/wireless/mwifiex/sta_ioctl.c    |  3 +-
 include/net/cfg80211.h                      | 11 ++----
 include/net/mac80211.h                      |  1 -
 include/uapi/linux/nl80211.h                | 14 ++++----
 net/mac80211/cfg.c                          | 27 +++++----------
 net/mac80211/driver-ops.h                   |  5 ++-
 net/mac80211/ieee80211_i.h                  |  2 --
 net/mac80211/main.c                         |  2 +-
 net/mac80211/offchannel.c                   |  8 ++---
 net/mac80211/trace.h                        |  6 ++--
 net/wireless/core.h                         |  6 ++--
 net/wireless/mlme.c                         | 21 ++++--------
 net/wireless/nl80211.c                      | 36 ++++++++------------
 net/wireless/nl80211.h                      |  4 +--
 net/wireless/rdev-ops.h                     | 20 +++++------
 net/wireless/trace.h                        | 52 ++++++++++-------------------
 24 files changed, 81 insertions(+), 172 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index d615f9f..74091d3 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2976,7 +2976,6 @@ static int ath6kl_change_station(struct wiphy *wiphy, struct net_device *dev,
 static int ath6kl_remain_on_channel(struct wiphy *wiphy,
 				    struct wireless_dev *wdev,
 				    struct ieee80211_channel *chan,
-				    enum nl80211_channel_type channel_type,
 				    unsigned int duration,
 				    u64 *cookie)
 {
@@ -3135,10 +3134,8 @@ static bool ath6kl_is_p2p_go_ssid(const u8 *buf, size_t len)
 
 static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			  struct ieee80211_channel *chan, bool offchan,
-			  enum nl80211_channel_type channel_type,
-			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, bool no_cck,
-			  bool dont_wait_for_ack, u64 *cookie)
+			  unsigned int wait, const u8 *buf, size_t len,
+			  bool no_cck, bool dont_wait_for_ack, u64 *cookie)
 {
 	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(wdev);
 	struct ath6kl *ar = ath6kl_priv(vif->ndev);
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index c30ab4b..0e05c41 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -474,7 +474,7 @@ static int ath6kl_wmi_remain_on_chnl_event_rx(struct wmi *wmi, u8 *datap,
 		return -EINVAL;
 	}
 	id = vif->last_roc_id;
-	cfg80211_ready_on_channel(&vif->wdev, id, chan, NL80211_CHAN_NO_HT,
+	cfg80211_ready_on_channel(&vif->wdev, id, chan,
 				  dur, GFP_ATOMIC);
 
 	return 0;
@@ -513,8 +513,7 @@ static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(struct wmi *wmi,
 	else
 		id = vif->last_roc_id; /* timeout on uncanceled r-o-c */
 	vif->last_cancel_roc_id = 0;
-	cfg80211_remain_on_channel_expired(&vif->wdev, id, chan,
-					   NL80211_CHAN_NO_HT, GFP_ATOMIC);
+	cfg80211_remain_on_channel_expired(&vif->wdev, id, chan, GFP_ATOMIC);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/dvm/dev.h b/drivers/net/wireless/iwlwifi/dvm/dev.h
index 8141f91..29c571a 100644
--- a/drivers/net/wireless/iwlwifi/dvm/dev.h
+++ b/drivers/net/wireless/iwlwifi/dvm/dev.h
@@ -789,7 +789,6 @@ struct iwl_priv {
 	/* remain-on-channel offload support */
 	struct ieee80211_channel *hw_roc_channel;
 	struct delayed_work hw_roc_disable_work;
-	enum nl80211_channel_type hw_roc_chantype;
 	int hw_roc_duration;
 	bool hw_roc_setup, hw_roc_start_notified;
 
diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index e75d803..852edb0 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -1034,7 +1034,6 @@ done:
 static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 				     struct ieee80211_vif *vif,
 				     struct ieee80211_channel *channel,
-				     enum nl80211_channel_type channel_type,
 				     int duration)
 {
 	struct iwl_priv *priv = IWL_MAC80211_GET_DVM(hw);
@@ -1066,7 +1065,6 @@ static int iwlagn_mac_remain_on_channel(struct ieee80211_hw *hw,
 	}
 
 	priv->hw_roc_channel = channel;
-	priv->hw_roc_chantype = channel_type;
 	/* convert from ms to TU */
 	priv->hw_roc_duration = DIV_ROUND_UP(1000 * duration, 1024);
 	priv->hw_roc_start_notified = false;
diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 3baa51f..b033854 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1455,7 +1455,6 @@ static void hw_roc_done(struct work_struct *work)
 static int mac80211_hwsim_roc(struct ieee80211_hw *hw,
 			      struct ieee80211_vif *vif,
 			      struct ieee80211_channel *chan,
-			      enum nl80211_channel_type channel_type,
 			      int duration)
 {
 	struct mac80211_hwsim_data *hwsim = hw->priv;
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 8e829b2..f69190b 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -180,10 +180,8 @@ mwifiex_form_mgmt_frame(struct sk_buff *skb, const u8 *buf, size_t len)
 static int
 mwifiex_cfg80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			 struct ieee80211_channel *chan, bool offchan,
-			 enum nl80211_channel_type channel_type,
-			 bool channel_type_valid, unsigned int wait,
-			 const u8 *buf, size_t len, bool no_cck,
-			 bool dont_wait_for_ack, u64 *cookie)
+			 unsigned int wait, const u8 *buf, size_t len,
+			 bool no_cck, bool dont_wait_for_ack, u64 *cookie)
 {
 	struct sk_buff *skb;
 	u16 pkt_len;
@@ -253,7 +251,6 @@ static int
 mwifiex_cfg80211_remain_on_channel(struct wiphy *wiphy,
 				   struct wireless_dev *wdev,
 				   struct ieee80211_channel *chan,
-				   enum nl80211_channel_type channel_type,
 				   unsigned int duration, u64 *cookie)
 {
 	struct mwifiex_private *priv = mwifiex_netdev_get_priv(wdev->netdev);
@@ -271,15 +268,14 @@ mwifiex_cfg80211_remain_on_channel(struct wiphy *wiphy,
 	}
 
 	ret = mwifiex_remain_on_chan_cfg(priv, HostCmd_ACT_GEN_SET, chan,
-					 &channel_type, duration);
+					 duration);
 
 	if (!ret) {
 		*cookie = random32() | 1;
 		priv->roc_cfg.cookie = *cookie;
 		priv->roc_cfg.chan = *chan;
-		priv->roc_cfg.chan_type = channel_type;
 
-		cfg80211_ready_on_channel(wdev, *cookie, chan, channel_type,
+		cfg80211_ready_on_channel(wdev, *cookie, chan,
 					  duration, GFP_ATOMIC);
 
 		wiphy_dbg(wiphy, "info: ROC, cookie = 0x%llx\n", *cookie);
@@ -302,13 +298,11 @@ mwifiex_cfg80211_cancel_remain_on_channel(struct wiphy *wiphy,
 		return -ENOENT;
 
 	ret = mwifiex_remain_on_chan_cfg(priv, HostCmd_ACT_GEN_REMOVE,
-					 &priv->roc_cfg.chan,
-					 &priv->roc_cfg.chan_type, 0);
+					 &priv->roc_cfg.chan, 0);
 
 	if (!ret) {
 		cfg80211_remain_on_channel_expired(wdev, cookie,
 						   &priv->roc_cfg.chan,
-						   priv->roc_cfg.chan_type,
 						   GFP_ATOMIC);
 
 		memset(&priv->roc_cfg, 0, sizeof(struct mwifiex_roc_cfg));
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 81f8772..771717d 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -371,7 +371,6 @@ struct wps {
 struct mwifiex_roc_cfg {
 	u64 cookie;
 	struct ieee80211_channel chan;
-	enum nl80211_channel_type chan_type;
 };
 
 struct mwifiex_adapter;
@@ -1016,7 +1015,6 @@ int mwifiex_get_ver_ext(struct mwifiex_private *priv);
 
 int mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
 			       struct ieee80211_channel *chan,
-			       enum nl80211_channel_type *channel_type,
 			       unsigned int duration);
 
 int mwifiex_set_bss_role(struct mwifiex_private *priv, u8 bss_role);
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 8132119..78dfa31 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -424,7 +424,6 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 		cfg80211_remain_on_channel_expired(priv->wdev,
 						   priv->roc_cfg.cookie,
 						   &priv->roc_cfg.chan,
-						   priv->roc_cfg.chan_type,
 						   GFP_ATOMIC);
 
 		memset(&priv->roc_cfg, 0x00, sizeof(struct mwifiex_roc_cfg));
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 552d72e..24af6ba 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -1046,7 +1046,6 @@ mwifiex_get_ver_ext(struct mwifiex_private *priv)
 int
 mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
 			   struct ieee80211_channel *chan,
-			   enum nl80211_channel_type *ct,
 			   unsigned int duration)
 {
 	struct host_cmd_ds_remain_on_chan roc_cfg;
@@ -1056,7 +1055,7 @@ mwifiex_remain_on_chan_cfg(struct mwifiex_private *priv, u16 action,
 	roc_cfg.action = cpu_to_le16(action);
 	if (action == HostCmd_ACT_GEN_SET) {
 		roc_cfg.band_cfg = chan->band;
-		sc = mwifiex_chan_type_to_sec_chan_offset(*ct);
+		sc = mwifiex_chan_type_to_sec_chan_offset(NL80211_CHAN_NO_HT);
 		roc_cfg.band_cfg |= (sc << 2);
 
 		roc_cfg.channel =
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 8a1aec5..4e84294 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1791,7 +1791,6 @@ struct cfg80211_ops {
 	int	(*remain_on_channel)(struct wiphy *wiphy,
 				     struct wireless_dev *wdev,
 				     struct ieee80211_channel *chan,
-				     enum nl80211_channel_type channel_type,
 				     unsigned int duration,
 				     u64 *cookie);
 	int	(*cancel_remain_on_channel)(struct wiphy *wiphy,
@@ -1800,10 +1799,8 @@ struct cfg80211_ops {
 
 	int	(*mgmt_tx)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			  struct ieee80211_channel *chan, bool offchan,
-			  enum nl80211_channel_type channel_type,
-			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, bool no_cck,
-			  bool dont_wait_for_ack, u64 *cookie);
+			  unsigned int wait, const u8 *buf, size_t len,
+			  bool no_cck, bool dont_wait_for_ack, u64 *cookie);
 	int	(*mgmt_tx_cancel_wait)(struct wiphy *wiphy,
 				       struct wireless_dev *wdev,
 				       u64 cookie);
@@ -3350,14 +3347,12 @@ void cfg80211_disconnected(struct net_device *dev, u16 reason,
  * @wdev: wireless device
  * @cookie: the request cookie
  * @chan: The current channel (from remain_on_channel request)
- * @channel_type: Channel type
  * @duration: Duration in milliseconds that the driver intents to remain on the
  *	channel
  * @gfp: allocation flags
  */
 void cfg80211_ready_on_channel(struct wireless_dev *wdev, u64 cookie,
 			       struct ieee80211_channel *chan,
-			       enum nl80211_channel_type channel_type,
 			       unsigned int duration, gfp_t gfp);
 
 /**
@@ -3365,12 +3360,10 @@ void cfg80211_ready_on_channel(struct wireless_dev *wdev, u64 cookie,
  * @wdev: wireless device
  * @cookie: the request cookie
  * @chan: The current channel (from remain_on_channel request)
- * @channel_type: Channel type
  * @gfp: allocation flags
  */
 void cfg80211_remain_on_channel_expired(struct wireless_dev *wdev, u64 cookie,
 					struct ieee80211_channel *chan,
-					enum nl80211_channel_type channel_type,
 					gfp_t gfp);
 
 
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index d11037b..7e82e26 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2532,7 +2532,6 @@ struct ieee80211_ops {
 	int (*remain_on_channel)(struct ieee80211_hw *hw,
 				 struct ieee80211_vif *vif,
 				 struct ieee80211_channel *chan,
-				 enum nl80211_channel_type channel_type,
 				 int duration);
 	int (*cancel_remain_on_channel)(struct ieee80211_hw *hw);
 	int (*set_ringparam)(struct ieee80211_hw *hw, u32 tx, u32 rx);
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 1a9a819..43cd6fa 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -401,8 +401,7 @@
  *	a response while being associated to an AP on another channel.
  *	%NL80211_ATTR_IFINDEX is used to specify which interface (and thus
  *	radio) is used. %NL80211_ATTR_WIPHY_FREQ is used to specify the
- *	frequency for the operation and %NL80211_ATTR_WIPHY_CHANNEL_TYPE may be
- *	optionally used to specify additional channel parameters.
+ *	frequency for the operation.
  *	%NL80211_ATTR_DURATION is used to specify the duration in milliseconds
  *	to remain on the channel. This command is also used as an event to
  *	notify when the requested duration starts (it may take a while for the
@@ -440,12 +439,11 @@
  *	as an event indicating reception of a frame that was not processed in
  *	kernel code, but is for us (i.e., which may need to be processed in a
  *	user space application). %NL80211_ATTR_FRAME is used to specify the
- *	frame contents (including header). %NL80211_ATTR_WIPHY_FREQ (and
- *	optionally %NL80211_ATTR_WIPHY_CHANNEL_TYPE) is used to indicate on
- *	which channel the frame is to be transmitted or was received. If this
- *	channel is not the current channel (remain-on-channel or the
- *	operational channel) the device will switch to the given channel and
- *	transmit the frame, optionally waiting for a response for the time
+ *	frame contents (including header). %NL80211_ATTR_WIPHY_FREQ is used
+ *	to indicate on which channel the frame is to be transmitted or was
+ *	received. If this channel is not the current channel (remain-on-channel
+ *	or the operational channel) the device will switch to the given channel
+ *	and transmit the frame, optionally waiting for a response for the time
  *	specified using %NL80211_ATTR_DURATION. When called, this operation
  *	returns a cookie (%NL80211_ATTR_COOKIE) that will be included with the
  *	TX status event pertaining to the TX request.
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 18926ae..ac0241e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2236,7 +2236,6 @@ static int ieee80211_set_bitrate_mask(struct wiphy *wiphy,
 static int ieee80211_start_roc_work(struct ieee80211_local *local,
 				    struct ieee80211_sub_if_data *sdata,
 				    struct ieee80211_channel *channel,
-				    enum nl80211_channel_type channel_type,
 				    unsigned int duration, u64 *cookie,
 				    struct sk_buff *txskb)
 {
@@ -2254,7 +2253,6 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 		return -ENOMEM;
 
 	roc->chan = channel;
-	roc->chan_type = channel_type;
 	roc->duration = duration;
 	roc->req_duration = duration;
 	roc->frame = txskb;
@@ -2287,8 +2285,7 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 	if (!duration)
 		duration = 10;
 
-	ret = drv_remain_on_channel(local, sdata, channel, channel_type,
-				    duration);
+	ret = drv_remain_on_channel(local, sdata, channel, duration);
 	if (ret) {
 		kfree(roc);
 		return ret;
@@ -2299,8 +2296,7 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 
  out_check_combine:
 	list_for_each_entry(tmp, &local->roc_list, list) {
-		if (tmp->chan != channel || tmp->chan_type != channel_type ||
-		    tmp->sdata != sdata)
+		if (tmp->chan != channel || tmp->sdata != sdata)
 			continue;
 
 		/*
@@ -2417,7 +2413,6 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 static int ieee80211_remain_on_channel(struct wiphy *wiphy,
 				       struct wireless_dev *wdev,
 				       struct ieee80211_channel *chan,
-				       enum nl80211_channel_type channel_type,
 				       unsigned int duration,
 				       u64 *cookie)
 {
@@ -2426,7 +2421,7 @@ static int ieee80211_remain_on_channel(struct wiphy *wiphy,
 	int ret;
 
 	mutex_lock(&local->mtx);
-	ret = ieee80211_start_roc_work(local, sdata, chan, channel_type,
+	ret = ieee80211_start_roc_work(local, sdata, chan,
 				       duration, cookie, NULL);
 	mutex_unlock(&local->mtx);
 
@@ -2519,10 +2514,8 @@ static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
 
 static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
-			     enum nl80211_channel_type channel_type,
-			     bool channel_type_valid, unsigned int wait,
-			     const u8 *buf, size_t len, bool no_cck,
-			     bool dont_wait_for_ack, u64 *cookie)
+			     unsigned int wait, const u8 *buf, size_t len,
+			     bool no_cck, bool dont_wait_for_ack, u64 *cookie)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_local *local = sdata->local;
@@ -2591,14 +2584,10 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 		rcu_read_lock();
 		chanctx_conf = rcu_dereference(sdata->vif.chanctx_conf);
 
-		if (chanctx_conf) {
+		if (chanctx_conf)
 			need_offchan = chan != chanctx_conf->channel;
-			if (channel_type_valid &&
-			    channel_type != chanctx_conf->channel_type)
-				need_offchan = true;
-		} else {
+		else
 			need_offchan = true;
-		}
 		rcu_read_unlock();
 	}
 
@@ -2633,7 +2622,7 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			local->hw.offchannel_tx_hw_queue;
 
 	/* This will handle all kinds of coalescing and immediate TX */
-	ret = ieee80211_start_roc_work(local, sdata, chan, channel_type,
+	ret = ieee80211_start_roc_work(local, sdata, chan,
 				       wait, cookie, skb);
 	if (ret)
 		kfree_skb(skb);
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 284dd02..fe76cb5 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -706,16 +706,15 @@ static inline int drv_get_antenna(struct ieee80211_local *local,
 static inline int drv_remain_on_channel(struct ieee80211_local *local,
 					struct ieee80211_sub_if_data *sdata,
 					struct ieee80211_channel *chan,
-					enum nl80211_channel_type chantype,
 					unsigned int duration)
 {
 	int ret;
 
 	might_sleep();
 
-	trace_drv_remain_on_channel(local, sdata, chan, chantype, duration);
+	trace_drv_remain_on_channel(local, sdata, chan, duration);
 	ret = local->ops->remain_on_channel(&local->hw, &sdata->vif,
-					    chan, chantype, duration);
+					    chan, duration);
 	trace_drv_return_int(local, ret);
 
 	return ret;
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index bff82a8..21e1134 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -348,7 +348,6 @@ struct ieee80211_roc_work {
 	struct ieee80211_sub_if_data *sdata;
 
 	struct ieee80211_channel *chan;
-	enum nl80211_channel_type chan_type;
 
 	bool started, abort, hw_begun, notified;
 
@@ -1048,7 +1047,6 @@ struct ieee80211_local {
 
 	/* Temporary remain-on-channel for off-channel operations */
 	struct ieee80211_channel *tmp_channel;
-	enum nl80211_channel_type tmp_channel_type;
 
 	/* channel contexts */
 	struct list_head chanctx_list;
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 70e8760..b229cde 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -115,7 +115,7 @@ static u32 ieee80211_hw_conf_chan(struct ieee80211_local *local)
 			channel_type = NL80211_CHAN_NO_HT;
 	} else if (local->tmp_channel) {
 		chan = local->tmp_channel;
-		channel_type = local->tmp_channel_type;
+		channel_type = NL80211_CHAN_NO_HT;
 	} else {
 		chan = local->_oper_channel;
 		channel_type = local->_oper_channel_type;
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index 7f8a365..5abddfe 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -205,8 +205,8 @@ void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc)
 		}
 	} else {
 		cfg80211_ready_on_channel(&roc->sdata->wdev, roc->cookie,
-					  roc->chan, roc->chan_type,
-					  roc->req_duration, GFP_KERNEL);
+					  roc->chan, roc->req_duration,
+					  GFP_KERNEL);
 	}
 
 	roc->notified = true;
@@ -284,7 +284,6 @@ void ieee80211_start_next_roc(struct ieee80211_local *local)
 			duration = 10;
 
 		ret = drv_remain_on_channel(local, roc->sdata, roc->chan,
-					    roc->chan_type,
 					    duration);
 
 		roc->started = true;
@@ -321,7 +320,7 @@ void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
 	if (!roc->mgmt_tx_cookie)
 		cfg80211_remain_on_channel_expired(&roc->sdata->wdev,
 						   roc->cookie, roc->chan,
-						   roc->chan_type, GFP_KERNEL);
+						   GFP_KERNEL);
 
 	list_for_each_entry_safe(dep, tmp, &roc->dependents, list)
 		ieee80211_roc_notify_destroy(dep);
@@ -359,7 +358,6 @@ void ieee80211_sw_roc_work(struct work_struct *work)
 		ieee80211_recalc_idle(local);
 
 		local->tmp_channel = roc->chan;
-		local->tmp_channel_type = roc->chan_type;
 		ieee80211_hw_config(local, 0);
 
 		/* tell userspace or send frame */
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index e9579b7..bc28346 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -1022,15 +1022,14 @@ TRACE_EVENT(drv_remain_on_channel,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sub_if_data *sdata,
 		 struct ieee80211_channel *chan,
-		 enum nl80211_channel_type chantype, unsigned int duration),
+		 unsigned int duration),
 
-	TP_ARGS(local, sdata, chan, chantype, duration),
+	TP_ARGS(local, sdata, chan, duration),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
 		VIF_ENTRY
 		__field(int, center_freq)
-		__field(int, channel_type)
 		__field(unsigned int, duration)
 	),
 
@@ -1038,7 +1037,6 @@ TRACE_EVENT(drv_remain_on_channel,
 		LOCAL_ASSIGN;
 		VIF_ASSIGN;
 		__entry->center_freq = chan->center_freq;
-		__entry->channel_type = chantype;
 		__entry->duration = duration;
 	),
 
diff --git a/net/wireless/core.h b/net/wireless/core.h
index e53831c..b0a09cf 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -378,10 +378,8 @@ void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev);
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct wireless_dev *wdev,
 			  struct ieee80211_channel *chan, bool offchan,
-			  enum nl80211_channel_type channel_type,
-			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, bool no_cck,
-			  bool dont_wait_for_ack, u64 *cookie);
+			  unsigned int wait, const u8 *buf, size_t len,
+			  bool no_cck, bool dont_wait_for_ack, u64 *cookie);
 void cfg80211_oper_and_ht_capa(struct ieee80211_ht_cap *ht_capa,
 			       const struct ieee80211_ht_cap *ht_capa_mask);
 
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index 4bfd14f..a9646b5 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -579,31 +579,25 @@ void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
 
 void cfg80211_ready_on_channel(struct wireless_dev *wdev, u64 cookie,
 			       struct ieee80211_channel *chan,
-			       enum nl80211_channel_type channel_type,
 			       unsigned int duration, gfp_t gfp)
 {
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	trace_cfg80211_ready_on_channel(wdev, cookie, chan, channel_type,
-					duration);
-	nl80211_send_remain_on_channel(rdev, wdev, cookie, chan, channel_type,
-				       duration, gfp);
+	trace_cfg80211_ready_on_channel(wdev, cookie, chan, duration);
+	nl80211_send_remain_on_channel(rdev, wdev, cookie, chan, duration, gfp);
 }
 EXPORT_SYMBOL(cfg80211_ready_on_channel);
 
 void cfg80211_remain_on_channel_expired(struct wireless_dev *wdev, u64 cookie,
 					struct ieee80211_channel *chan,
-					enum nl80211_channel_type channel_type,
 					gfp_t gfp)
 {
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	trace_cfg80211_ready_on_channel_expired(wdev, cookie, chan,
-						channel_type);
-	nl80211_send_remain_on_channel_cancel(rdev, wdev, cookie, chan,
-					      channel_type, gfp);
+	trace_cfg80211_ready_on_channel_expired(wdev, cookie, chan);
+	nl80211_send_remain_on_channel_cancel(rdev, wdev, cookie, chan, gfp);
 }
 EXPORT_SYMBOL(cfg80211_remain_on_channel_expired);
 
@@ -758,10 +752,8 @@ void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev)
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 			  struct wireless_dev *wdev,
 			  struct ieee80211_channel *chan, bool offchan,
-			  enum nl80211_channel_type channel_type,
-			  bool channel_type_valid, unsigned int wait,
-			  const u8 *buf, size_t len, bool no_cck,
-			  bool dont_wait_for_ack, u64 *cookie)
+			  unsigned int wait, const u8 *buf, size_t len,
+			  bool no_cck, bool dont_wait_for_ack, u64 *cookie)
 {
 	const struct ieee80211_mgmt *mgmt;
 	u16 stype;
@@ -855,7 +847,6 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 
 	/* Transmit the Action frame as requested by user space */
 	return rdev_mgmt_tx(rdev, wdev, chan, offchan,
-			    channel_type, channel_type_valid,
 			    wait, buf, len, no_cck, dont_wait_for_ack,
 			    cookie);
 }
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4c427fa..e880f44 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5952,7 +5952,6 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 	struct sk_buff *msg;
 	void *hdr;
 	u64 cookie;
-	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 	u32 freq, duration;
 	int err;
 
@@ -5975,11 +5974,11 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 		return -EINVAL;
 
 	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
-	    !nl80211_valid_channel_type(info, &channel_type))
+	    !nl80211_valid_channel_type(info, NULL))
 		return -EINVAL;
 
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
-	chan = rdev_freq_to_chan(rdev, freq, channel_type);
+	chan = rdev_freq_to_chan(rdev, freq, NL80211_CHAN_NO_HT);
 	if (chan == NULL)
 		return -EINVAL;
 
@@ -5995,8 +5994,7 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 		goto free_msg;
 	}
 
-	err = rdev_remain_on_channel(rdev, wdev, chan, channel_type, duration,
-				     &cookie);
+	err = rdev_remain_on_channel(rdev, wdev, chan, duration, &cookie);
 
 	if (err)
 		goto free_msg;
@@ -6216,8 +6214,6 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
 	struct ieee80211_channel *chan;
-	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
-	bool channel_type_valid = false;
 	u32 freq;
 	int err;
 	void *hdr = NULL;
@@ -6264,11 +6260,9 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 
 	}
 
-	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE]) {
-		if (!nl80211_valid_channel_type(info, &channel_type))
-			return -EINVAL;
-		channel_type_valid = true;
-	}
+	if (info->attrs[NL80211_ATTR_WIPHY_CHANNEL_TYPE] &&
+	    !nl80211_valid_channel_type(info, NULL))
+		return -EINVAL;
 
 	offchan = info->attrs[NL80211_ATTR_OFFCHANNEL_TX_OK];
 
@@ -6278,7 +6272,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	no_cck = nla_get_flag(info->attrs[NL80211_ATTR_TX_NO_CCK_RATE]);
 
 	freq = nla_get_u32(info->attrs[NL80211_ATTR_WIPHY_FREQ]);
-	chan = rdev_freq_to_chan(rdev, freq, channel_type);
+	chan = rdev_freq_to_chan(rdev, freq, NL80211_CHAN_NO_HT);
 	if (chan == NULL)
 		return -EINVAL;
 
@@ -6296,8 +6290,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	err = cfg80211_mlme_mgmt_tx(rdev, wdev, chan, offchan, channel_type,
-				    channel_type_valid, wait,
+	err = cfg80211_mlme_mgmt_tx(rdev, wdev, chan, offchan, wait,
 				    nla_data(info->attrs[NL80211_ATTR_FRAME]),
 				    nla_len(info->attrs[NL80211_ATTR_FRAME]),
 				    no_cck, dont_wait_for_ack, &cookie);
@@ -8395,7 +8388,6 @@ static void nl80211_send_remain_on_chan_event(
 	int cmd, struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev, u64 cookie,
 	struct ieee80211_channel *chan,
-	enum nl80211_channel_type channel_type,
 	unsigned int duration, gfp_t gfp)
 {
 	struct sk_buff *msg;
@@ -8416,7 +8408,8 @@ static void nl80211_send_remain_on_chan_event(
 					 wdev->netdev->ifindex)) ||
 	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)) ||
 	    nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, chan->center_freq) ||
-	    nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, channel_type) ||
+	    nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE,
+			NL80211_CHAN_NO_HT) ||
 	    nla_put_u64(msg, NL80211_ATTR_COOKIE, cookie))
 		goto nla_put_failure;
 
@@ -8438,23 +8431,20 @@ static void nl80211_send_remain_on_chan_event(
 void nl80211_send_remain_on_channel(struct cfg80211_registered_device *rdev,
 				    struct wireless_dev *wdev, u64 cookie,
 				    struct ieee80211_channel *chan,
-				    enum nl80211_channel_type channel_type,
 				    unsigned int duration, gfp_t gfp)
 {
 	nl80211_send_remain_on_chan_event(NL80211_CMD_REMAIN_ON_CHANNEL,
 					  rdev, wdev, cookie, chan,
-					  channel_type, duration, gfp);
+					  duration, gfp);
 }
 
 void nl80211_send_remain_on_channel_cancel(
 	struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev,
-	u64 cookie, struct ieee80211_channel *chan,
-	enum nl80211_channel_type channel_type, gfp_t gfp)
+	u64 cookie, struct ieee80211_channel *chan, gfp_t gfp)
 {
 	nl80211_send_remain_on_chan_event(NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL,
-					  rdev, wdev, cookie, chan,
-					  channel_type, 0, gfp);
+					  rdev, wdev, cookie, chan, 0, gfp);
 }
 
 void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index f615351..7adbd76 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -76,13 +76,11 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 void nl80211_send_remain_on_channel(struct cfg80211_registered_device *rdev,
 				    struct wireless_dev *wdev, u64 cookie,
 				    struct ieee80211_channel *chan,
-				    enum nl80211_channel_type channel_type,
 				    unsigned int duration, gfp_t gfp);
 void nl80211_send_remain_on_channel_cancel(
 	struct cfg80211_registered_device *rdev,
 	struct wireless_dev *wdev,
-	u64 cookie, struct ieee80211_channel *chan,
-	enum nl80211_channel_type channel_type, gfp_t gfp);
+	u64 cookie, struct ieee80211_channel *chan, gfp_t gfp);
 
 void nl80211_send_sta_event(struct cfg80211_registered_device *rdev,
 			    struct net_device *dev, const u8 *mac_addr,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 6e5fa65..ee54a5a 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -600,14 +600,12 @@ static inline int
 rdev_remain_on_channel(struct cfg80211_registered_device *rdev,
 		       struct wireless_dev *wdev,
 		       struct ieee80211_channel *chan,
-		       enum nl80211_channel_type channel_type,
 		       unsigned int duration, u64 *cookie)
 {
 	int ret;
-	trace_rdev_remain_on_channel(&rdev->wiphy, wdev, chan, channel_type,
-				     duration);
+	trace_rdev_remain_on_channel(&rdev->wiphy, wdev, chan, duration);
 	ret = rdev->ops->remain_on_channel(&rdev->wiphy, wdev, chan,
-					    channel_type, duration, cookie);
+					   duration, cookie);
 	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
 	return ret;
 }
@@ -626,17 +624,15 @@ rdev_cancel_remain_on_channel(struct cfg80211_registered_device *rdev,
 static inline int rdev_mgmt_tx(struct cfg80211_registered_device *rdev,
 			       struct wireless_dev *wdev,
 			       struct ieee80211_channel *chan, bool offchan,
-			       enum nl80211_channel_type channel_type,
-			       bool channel_type_valid, unsigned int wait,
-			       const u8 *buf, size_t len, bool no_cck,
-			       bool dont_wait_for_ack, u64 *cookie)
+			       unsigned int wait, const u8 *buf, size_t len,
+			       bool no_cck, bool dont_wait_for_ack, u64 *cookie)
 {
 	int ret;
-	trace_rdev_mgmt_tx(&rdev->wiphy, wdev, chan, offchan, channel_type,
-			   channel_type_valid, wait, no_cck, dont_wait_for_ack);
+	trace_rdev_mgmt_tx(&rdev->wiphy, wdev, chan, offchan,
+			   wait, no_cck, dont_wait_for_ack);
 	ret = rdev->ops->mgmt_tx(&rdev->wiphy, wdev, chan, offchan,
-				  channel_type, channel_type_valid, wait, buf,
-				  len, no_cck, dont_wait_for_ack, cookie);
+				  wait, buf, len, no_cck,
+				  dont_wait_for_ack, cookie);
 	trace_rdev_return_int_cookie(&rdev->wiphy, ret, *cookie);
 	return ret;
 }
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index f264c20..ed10833 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1573,25 +1573,22 @@ DEFINE_EVENT(rdev_pmksa, rdev_del_pmksa,
 TRACE_EVENT(rdev_remain_on_channel,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
 		 struct ieee80211_channel *chan,
-		 enum nl80211_channel_type channel_type, unsigned int duration),
-	TP_ARGS(wiphy, wdev, chan, channel_type, duration),
+		 unsigned int duration),
+	TP_ARGS(wiphy, wdev, chan, duration),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		WDEV_ENTRY
 		CHAN_ENTRY
-		__field(enum nl80211_channel_type, channel_type)
 		__field(unsigned int, duration)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		WDEV_ASSIGN;
 		CHAN_ASSIGN(chan);
-		__entry->channel_type = channel_type;
 		__entry->duration = duration;
 	),
-	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT CHAN_PR_FMT ", channel type: %d, duration: %u",
-		  WIPHY_PR_ARG, WDEV_PR_ARG, CHAN_PR_ARG, __entry->channel_type,
-		  __entry->duration)
+	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT CHAN_PR_FMT ", duration: %u",
+		  WIPHY_PR_ARG, WDEV_PR_ARG, CHAN_PR_ARG, __entry->duration)
 );
 
 TRACE_EVENT(rdev_return_int_cookie,
@@ -1631,18 +1628,13 @@ TRACE_EVENT(rdev_cancel_remain_on_channel,
 TRACE_EVENT(rdev_mgmt_tx,
 	TP_PROTO(struct wiphy *wiphy, struct wireless_dev *wdev,
 		 struct ieee80211_channel *chan, bool offchan,
-		 enum nl80211_channel_type channel_type,
-		 bool channel_type_valid, unsigned int wait, bool no_cck,
-		 bool dont_wait_for_ack),
-	TP_ARGS(wiphy, wdev, chan, offchan, channel_type, channel_type_valid,
-		wait, no_cck, dont_wait_for_ack),
+		 unsigned int wait, bool no_cck, bool dont_wait_for_ack),
+	TP_ARGS(wiphy, wdev, chan, offchan, wait, no_cck, dont_wait_for_ack),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		WDEV_ENTRY
 		CHAN_ENTRY
 		__field(bool, offchan)
-		__field(enum nl80211_channel_type, channel_type)
-		__field(bool, channel_type_valid)
 		__field(unsigned int, wait)
 		__field(bool, no_cck)
 		__field(bool, dont_wait_for_ack)
@@ -1652,18 +1644,14 @@ TRACE_EVENT(rdev_mgmt_tx,
 		WDEV_ASSIGN;
 		CHAN_ASSIGN(chan);
 		__entry->offchan = offchan;
-		__entry->channel_type = channel_type;
-		__entry->channel_type_valid = channel_type_valid;
 		__entry->wait = wait;
 		__entry->no_cck = no_cck;
 		__entry->dont_wait_for_ack = dont_wait_for_ack;
 	),
-	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT CHAN_PR_FMT ", offchan: %s, "
-		  "channel type: %d, channel type valid: %s, wait: %u, "
-		  "no cck: %s, dont wait for ack: %s",
+	TP_printk(WIPHY_PR_FMT WDEV_PR_FMT CHAN_PR_FMT ", offchan: %s,"
+		  " wait: %u, no cck: %s, dont wait for ack: %s",
 		  WIPHY_PR_ARG, WDEV_PR_ARG, CHAN_PR_ARG,
-		  BOOL_TO_STR(__entry->offchan), __entry->channel_type,
-		  BOOL_TO_STR(__entry->channel_type_valid), __entry->wait,
+		  BOOL_TO_STR(__entry->offchan), __entry->wait,
 		  BOOL_TO_STR(__entry->no_cck),
 		  BOOL_TO_STR(__entry->dont_wait_for_ack))
 );
@@ -1894,47 +1882,41 @@ TRACE_EVENT(cfg80211_michael_mic_failure,
 TRACE_EVENT(cfg80211_ready_on_channel,
 	TP_PROTO(struct wireless_dev *wdev, u64 cookie,
 		 struct ieee80211_channel *chan,
-		 enum nl80211_channel_type channel_type, unsigned int duration),
-	TP_ARGS(wdev, cookie, chan, channel_type, duration),
+		 unsigned int duration),
+	TP_ARGS(wdev, cookie, chan, duration),
 	TP_STRUCT__entry(
 		WDEV_ENTRY
 		__field(u64, cookie)
 		CHAN_ENTRY
-		__field(enum nl80211_channel_type, channel_type)
 		__field(unsigned int, duration)
 	),
 	TP_fast_assign(
 		WDEV_ASSIGN;
 		__entry->cookie = cookie;
 		CHAN_ASSIGN(chan);
-		__entry->channel_type = channel_type;
 		__entry->duration = duration;
 	),
-	TP_printk(WDEV_PR_FMT ", cookie: %llu, " CHAN_PR_FMT ", channel type: %d, duration: %u",
+	TP_printk(WDEV_PR_FMT ", cookie: %llu, " CHAN_PR_FMT ", duration: %u",
 		  WDEV_PR_ARG, __entry->cookie, CHAN_PR_ARG,
-		  __entry->channel_type, __entry->duration)
+		  __entry->duration)
 );
 
 TRACE_EVENT(cfg80211_ready_on_channel_expired,
 	TP_PROTO(struct wireless_dev *wdev, u64 cookie,
-		 struct ieee80211_channel *chan,
-		 enum nl80211_channel_type channel_type),
-	TP_ARGS(wdev, cookie, chan, channel_type),
+		 struct ieee80211_channel *chan),
+	TP_ARGS(wdev, cookie, chan),
 	TP_STRUCT__entry(
 		WDEV_ENTRY
 		__field(u64, cookie)
 		CHAN_ENTRY
-		__field(enum nl80211_channel_type, channel_type)
 	),
 	TP_fast_assign(
 		WDEV_ASSIGN;
 		__entry->cookie = cookie;
 		CHAN_ASSIGN(chan);
-		__entry->channel_type = channel_type;
 	),
-	TP_printk(WDEV_PR_FMT ", cookie: %llu, " CHAN_PR_FMT ", channel type: %d",
-		  WDEV_PR_ARG, __entry->cookie, CHAN_PR_ARG,
-		  __entry->channel_type)
+	TP_printk(WDEV_PR_FMT ", cookie: %llu, " CHAN_PR_FMT,
+		  WDEV_PR_ARG, __entry->cookie, CHAN_PR_ARG)
 );
 
 TRACE_EVENT(cfg80211_new_sta,
-- 
1.8.0

