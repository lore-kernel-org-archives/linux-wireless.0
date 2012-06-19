Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52381 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab2FSOvW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:22 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 10/17] cfg80211: use wdev in some APIs
Date: Tue, 19 Jun 2012 16:50:49 +0200
Message-Id: <1340117456-10154-11-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165148_641294_E8344D48)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The management frame and remain-on-channel APIs will be
needed in the P2P device abstraction, so move them over
to the new wdev-based APIs. Userspace can still use both
the interface index and wdev identifier for them so it's
backward compatible, but for the P2P Device wdev it will
be able to use the wdev identifier only.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |   22 ++---
 drivers/net/wireless/ath/ath6kl/core.h     |    5 ++
 drivers/net/wireless/ath/ath6kl/wmi.c      |   10 +--
 include/net/cfg80211.h                     |   27 +++----
 net/mac80211/cfg.c                         |   19 +++--
 net/mac80211/ieee80211_i.h                 |    6 ++
 net/mac80211/offchannel.c                  |    6 +-
 net/mac80211/rx.c                          |    2 +-
 net/mac80211/status.c                      |    9 ++-
 net/wireless/core.h                        |    2 +-
 net/wireless/mlme.c                        |   34 ++++----
 net/wireless/nl80211.c                     |  119 ++++++++++++++++------------
 net/wireless/nl80211.h                     |   10 +--
 13 files changed, 151 insertions(+), 120 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index f27e973..cb8b06d 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2880,14 +2880,14 @@ static int ath6kl_change_station(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ath6kl_remain_on_channel(struct wiphy *wiphy,
-				    struct net_device *dev,
+				    struct wireless_dev *wdev,
 				    struct ieee80211_channel *chan,
 				    enum nl80211_channel_type channel_type,
 				    unsigned int duration,
 				    u64 *cookie)
 {
-	struct ath6kl *ar = ath6kl_priv(dev);
-	struct ath6kl_vif *vif = netdev_priv(dev);
+	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(wdev);
+	struct ath6kl *ar = ath6kl_priv(vif->ndev);
 	u32 id;
 
 	/* TODO: if already pending or ongoing remain-on-channel,
@@ -2904,11 +2904,11 @@ static int ath6kl_remain_on_channel(struct wiphy *wiphy,
 }
 
 static int ath6kl_cancel_remain_on_channel(struct wiphy *wiphy,
-					   struct net_device *dev,
+					   struct wireless_dev *wdev,
 					   u64 cookie)
 {
-	struct ath6kl *ar = ath6kl_priv(dev);
-	struct ath6kl_vif *vif = netdev_priv(dev);
+	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(wdev);
+	struct ath6kl *ar = ath6kl_priv(vif->ndev);
 
 	if (cookie != vif->last_roc_id)
 		return -ENOENT;
@@ -3039,15 +3039,15 @@ static bool ath6kl_is_p2p_go_ssid(const u8 *buf, size_t len)
 	return false;
 }
 
-static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
+static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
 			  const u8 *buf, size_t len, bool no_cck,
 			  bool dont_wait_for_ack, u64 *cookie)
 {
-	struct ath6kl *ar = ath6kl_priv(dev);
-	struct ath6kl_vif *vif = netdev_priv(dev);
+	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(wdev);
+	struct ath6kl *ar = ath6kl_priv(vif->ndev);
 	u32 id;
 	const struct ieee80211_mgmt *mgmt;
 	bool more_data, queued;
@@ -3092,10 +3092,10 @@ static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static void ath6kl_mgmt_frame_register(struct wiphy *wiphy,
-				       struct net_device *dev,
+				       struct wireless_dev *wdev,
 				       u16 frame_type, bool reg)
 {
-	struct ath6kl_vif *vif = netdev_priv(dev);
+	struct ath6kl_vif *vif = ath6kl_vif_from_wdev(wdev);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s: frame_type=0x%x reg=%d\n",
 		   __func__, frame_type, reg);
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 8443b2a..fdef8f2 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -565,6 +565,11 @@ struct ath6kl_vif {
 	struct list_head mc_filter;
 };
 
+static inline struct ath6kl_vif *ath6kl_vif_from_wdev(struct wireless_dev *wdev)
+{
+	return container_of(wdev, struct ath6kl_vif, wdev);
+}
+
 #define WOW_LIST_ID		0
 #define WOW_HOST_REQ_DELAY	500 /* ms */
 
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index ee8ec23..1096d24 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -474,7 +474,7 @@ static int ath6kl_wmi_remain_on_chnl_event_rx(struct wmi *wmi, u8 *datap,
 		return -EINVAL;
 	}
 	id = vif->last_roc_id;
-	cfg80211_ready_on_channel(vif->ndev, id, chan, NL80211_CHAN_NO_HT,
+	cfg80211_ready_on_channel(&vif->wdev, id, chan, NL80211_CHAN_NO_HT,
 				  dur, GFP_ATOMIC);
 
 	return 0;
@@ -513,7 +513,7 @@ static int ath6kl_wmi_cancel_remain_on_chnl_event_rx(struct wmi *wmi,
 	else
 		id = vif->last_roc_id; /* timeout on uncanceled r-o-c */
 	vif->last_cancel_roc_id = 0;
-	cfg80211_remain_on_channel_expired(vif->ndev, id, chan,
+	cfg80211_remain_on_channel_expired(&vif->wdev, id, chan,
 					   NL80211_CHAN_NO_HT, GFP_ATOMIC);
 
 	return 0;
@@ -533,7 +533,7 @@ static int ath6kl_wmi_tx_status_event_rx(struct wmi *wmi, u8 *datap, int len,
 	ath6kl_dbg(ATH6KL_DBG_WMI, "tx_status: id=%x ack_status=%u\n",
 		   id, ev->ack_status);
 	if (wmi->last_mgmt_tx_frame) {
-		cfg80211_mgmt_tx_status(vif->ndev, id,
+		cfg80211_mgmt_tx_status(&vif->wdev, id,
 					wmi->last_mgmt_tx_frame,
 					wmi->last_mgmt_tx_frame_len,
 					!!ev->ack_status, GFP_ATOMIC);
@@ -568,7 +568,7 @@ static int ath6kl_wmi_rx_probe_req_event_rx(struct wmi *wmi, u8 *datap, int len,
 		   dlen, freq, vif->probe_req_report);
 
 	if (vif->probe_req_report || vif->nw_type == AP_NETWORK)
-		cfg80211_rx_mgmt(vif->ndev, freq, 0,
+		cfg80211_rx_mgmt(&vif->wdev, freq, 0,
 				 ev->data, dlen, GFP_ATOMIC);
 
 	return 0;
@@ -608,7 +608,7 @@ static int ath6kl_wmi_rx_action_event_rx(struct wmi *wmi, u8 *datap, int len,
 		return -EINVAL;
 	}
 	ath6kl_dbg(ATH6KL_DBG_WMI, "rx_action: len=%u freq=%u\n", dlen, freq);
-	cfg80211_rx_mgmt(vif->ndev, freq, 0,
+	cfg80211_rx_mgmt(&vif->wdev, freq, 0,
 			 ev->data, dlen, GFP_ATOMIC);
 
 	return 0;
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f693dfa..2e2c042 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1731,23 +1731,23 @@ struct cfg80211_ops {
 	int	(*flush_pmksa)(struct wiphy *wiphy, struct net_device *netdev);
 
 	int	(*remain_on_channel)(struct wiphy *wiphy,
-				     struct net_device *dev,
+				     struct wireless_dev *wdev,
 				     struct ieee80211_channel *chan,
 				     enum nl80211_channel_type channel_type,
 				     unsigned int duration,
 				     u64 *cookie);
 	int	(*cancel_remain_on_channel)(struct wiphy *wiphy,
-					    struct net_device *dev,
+					    struct wireless_dev *wdev,
 					    u64 cookie);
 
-	int	(*mgmt_tx)(struct wiphy *wiphy, struct net_device *dev,
+	int	(*mgmt_tx)(struct wiphy *wiphy, struct wireless_dev *wdev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
 			  const u8 *buf, size_t len, bool no_cck,
 			  bool dont_wait_for_ack, u64 *cookie);
 	int	(*mgmt_tx_cancel_wait)(struct wiphy *wiphy,
-				       struct net_device *dev,
+				       struct wireless_dev *wdev,
 				       u64 cookie);
 
 	int	(*set_power_mgmt)(struct wiphy *wiphy, struct net_device *dev,
@@ -1758,7 +1758,7 @@ struct cfg80211_ops {
 				       s32 rssi_thold, u32 rssi_hyst);
 
 	void	(*mgmt_frame_register)(struct wiphy *wiphy,
-				       struct net_device *dev,
+				       struct wireless_dev *wdev,
 				       u16 frame_type, bool reg);
 
 	int	(*set_antenna)(struct wiphy *wiphy, u32 tx_ant, u32 rx_ant);
@@ -3251,7 +3251,7 @@ void cfg80211_disconnected(struct net_device *dev, u16 reason,
 
 /**
  * cfg80211_ready_on_channel - notification of remain_on_channel start
- * @dev: network device
+ * @wdev: wireless device
  * @cookie: the request cookie
  * @chan: The current channel (from remain_on_channel request)
  * @channel_type: Channel type
@@ -3259,21 +3259,20 @@ void cfg80211_disconnected(struct net_device *dev, u16 reason,
  *	channel
  * @gfp: allocation flags
  */
-void cfg80211_ready_on_channel(struct net_device *dev, u64 cookie,
+void cfg80211_ready_on_channel(struct wireless_dev *wdev, u64 cookie,
 			       struct ieee80211_channel *chan,
 			       enum nl80211_channel_type channel_type,
 			       unsigned int duration, gfp_t gfp);
 
 /**
  * cfg80211_remain_on_channel_expired - remain_on_channel duration expired
- * @dev: network device
+ * @wdev: wireless device
  * @cookie: the request cookie
  * @chan: The current channel (from remain_on_channel request)
  * @channel_type: Channel type
  * @gfp: allocation flags
  */
-void cfg80211_remain_on_channel_expired(struct net_device *dev,
-					u64 cookie,
+void cfg80211_remain_on_channel_expired(struct wireless_dev *wdev, u64 cookie,
 					struct ieee80211_channel *chan,
 					enum nl80211_channel_type channel_type,
 					gfp_t gfp);
@@ -3301,7 +3300,7 @@ void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp);
 
 /**
  * cfg80211_rx_mgmt - notification of received, unprocessed management frame
- * @dev: network device
+ * @wdev: wireless device receiving the frame
  * @freq: Frequency on which the frame was received in MHz
  * @sig_dbm: signal strength in mBm, or 0 if unknown
  * @buf: Management frame (header + body)
@@ -3316,12 +3315,12 @@ void cfg80211_del_sta(struct net_device *dev, const u8 *mac_addr, gfp_t gfp);
  * This function is called whenever an Action frame is received for a station
  * mode interface, but is not processed in kernel.
  */
-bool cfg80211_rx_mgmt(struct net_device *dev, int freq, int sig_dbm,
+bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_dbm,
 		      const u8 *buf, size_t len, gfp_t gfp);
 
 /**
  * cfg80211_mgmt_tx_status - notification of TX status for management frame
- * @dev: network device
+ * @wdev: wireless device receiving the frame
  * @cookie: Cookie returned by cfg80211_ops::mgmt_tx()
  * @buf: Management frame (header + body)
  * @len: length of the frame data
@@ -3332,7 +3331,7 @@ bool cfg80211_rx_mgmt(struct net_device *dev, int freq, int sig_dbm,
  * transmitted with cfg80211_ops::mgmt_tx() to report the TX status of the
  * transmission attempt.
  */
-void cfg80211_mgmt_tx_status(struct net_device *dev, u64 cookie,
+void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 			     const u8 *buf, size_t len, bool ack, gfp_t gfp);
 
 
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 17162fc..5bea92e 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2289,13 +2289,13 @@ static int ieee80211_start_roc_work(struct ieee80211_local *local,
 }
 
 static int ieee80211_remain_on_channel(struct wiphy *wiphy,
-				       struct net_device *dev,
+				       struct wireless_dev *wdev,
 				       struct ieee80211_channel *chan,
 				       enum nl80211_channel_type channel_type,
 				       unsigned int duration,
 				       u64 *cookie)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_local *local = sdata->local;
 	int ret;
 
@@ -2381,23 +2381,23 @@ static int ieee80211_cancel_roc(struct ieee80211_local *local,
 }
 
 static int ieee80211_cancel_remain_on_channel(struct wiphy *wiphy,
-					      struct net_device *dev,
+					      struct wireless_dev *wdev,
 					      u64 cookie)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_local *local = sdata->local;
 
 	return ieee80211_cancel_roc(local, cookie, false);
 }
 
-static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
+static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct wireless_dev *wdev,
 			     struct ieee80211_channel *chan, bool offchan,
 			     enum nl80211_channel_type channel_type,
 			     bool channel_type_valid, unsigned int wait,
 			     const u8 *buf, size_t len, bool no_cck,
 			     bool dont_wait_for_ack, u64 *cookie)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
 	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb;
 	struct sta_info *sta;
@@ -2502,17 +2502,16 @@ static int ieee80211_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,
 }
 
 static int ieee80211_mgmt_tx_cancel_wait(struct wiphy *wiphy,
-					 struct net_device *dev,
+					 struct wireless_dev *wdev,
 					 u64 cookie)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_local *local = wiphy_priv(wiphy);
 
 	return ieee80211_cancel_roc(local, cookie, true);
 }
 
 static void ieee80211_mgmt_frame_register(struct wiphy *wiphy,
-					  struct net_device *dev,
+					  struct wireless_dev *wdev,
 					  u16 frame_type, bool reg)
 {
 	struct ieee80211_local *local = wiphy_priv(wiphy);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 34af2e5..72654c0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1087,6 +1087,12 @@ IEEE80211_DEV_TO_SUB_IF(struct net_device *dev)
 	return netdev_priv(dev);
 }
 
+static inline struct ieee80211_sub_if_data *
+IEEE80211_WDEV_TO_SUB_IF(struct wireless_dev *wdev)
+{
+	return container_of(wdev, struct ieee80211_sub_if_data, wdev);
+}
+
 /* this struct represents 802.11n's RA/TID combination */
 struct ieee80211_ra_tid {
 	u8 ra[ETH_ALEN];
diff --git a/net/mac80211/offchannel.c b/net/mac80211/offchannel.c
index fcb01ee..3110ebb 100644
--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
@@ -193,7 +193,7 @@ void ieee80211_handle_roc_started(struct ieee80211_roc_work *roc)
 			roc->frame = NULL;
 		}
 	} else {
-		cfg80211_ready_on_channel(roc->sdata->dev, (unsigned long)roc,
+		cfg80211_ready_on_channel(&roc->sdata->wdev, (unsigned long)roc,
 					  roc->chan, roc->chan_type,
 					  roc->req_duration, GFP_KERNEL);
 	}
@@ -298,7 +298,7 @@ void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
 
 	/* was never transmitted */
 	if (roc->frame) {
-		cfg80211_mgmt_tx_status(roc->sdata->dev,
+		cfg80211_mgmt_tx_status(&roc->sdata->wdev,
 					(unsigned long)roc->frame,
 					roc->frame->data, roc->frame->len,
 					false, GFP_KERNEL);
@@ -306,7 +306,7 @@ void ieee80211_roc_notify_destroy(struct ieee80211_roc_work *roc)
 	}
 
 	if (!roc->mgmt_tx_cookie)
-		cfg80211_remain_on_channel_expired(roc->sdata->dev,
+		cfg80211_remain_on_channel_expired(&roc->sdata->wdev,
 						   (unsigned long)roc,
 						   roc->chan, roc->chan_type,
 						   GFP_KERNEL);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 072e8f3..7290c97 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2423,7 +2423,7 @@ ieee80211_rx_h_userspace_mgmt(struct ieee80211_rx_data *rx)
 	if (rx->local->hw.flags & IEEE80211_HW_SIGNAL_DBM)
 		sig = status->signal;
 
-	if (cfg80211_rx_mgmt(rx->sdata->dev, status->freq, sig,
+	if (cfg80211_rx_mgmt(&rx->sdata->wdev, status->freq, sig,
 			     rx->skb->data, rx->skb->len,
 			     GFP_ATOMIC)) {
 		if (rx->sta)
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 6b4f425..975ab03 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -522,14 +522,19 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		u64 cookie = (unsigned long)skb;
 		acked = info->flags & IEEE80211_TX_STAT_ACK;
 
+		/*
+		 * TODO: When we have non-netdev frame TX,
+		 * we cannot use skb->dev->ieee80211_ptr
+		 */
+
 		if (ieee80211_is_nullfunc(hdr->frame_control) ||
 		    ieee80211_is_qos_nullfunc(hdr->frame_control))
 			cfg80211_probe_status(skb->dev, hdr->addr1,
 					      cookie, acked, GFP_ATOMIC);
 		else
 			cfg80211_mgmt_tx_status(
-				skb->dev, cookie, skb->data, skb->len,
-				acked, GFP_ATOMIC);
+				skb->dev->ieee80211_ptr, cookie, skb->data,
+				skb->len, acked, GFP_ATOMIC);
 	}
 
 	if (unlikely(info->ack_frame_id)) {
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 944a8ba..0562c00 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -346,7 +346,7 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_pid,
 void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlpid);
 void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev);
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
-			  struct net_device *dev,
+			  struct wireless_dev *wdev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index da4406f..46e3c387 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -551,29 +551,28 @@ void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
 	}
 }
 
-void cfg80211_ready_on_channel(struct net_device *dev, u64 cookie,
+void cfg80211_ready_on_channel(struct wireless_dev *wdev, u64 cookie,
 			       struct ieee80211_channel *chan,
 			       enum nl80211_channel_type channel_type,
 			       unsigned int duration, gfp_t gfp)
 {
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	nl80211_send_remain_on_channel(rdev, dev, cookie, chan, channel_type,
+	nl80211_send_remain_on_channel(rdev, wdev, cookie, chan, channel_type,
 				       duration, gfp);
 }
 EXPORT_SYMBOL(cfg80211_ready_on_channel);
 
-void cfg80211_remain_on_channel_expired(struct net_device *dev,
-					u64 cookie,
+void cfg80211_remain_on_channel_expired(struct wireless_dev *wdev, u64 cookie,
 					struct ieee80211_channel *chan,
 					enum nl80211_channel_type channel_type,
 					gfp_t gfp)
 {
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
-	nl80211_send_remain_on_channel_cancel(rdev, dev, cookie, chan,
+	nl80211_send_remain_on_channel_cancel(rdev, wdev, cookie, chan,
 					      channel_type, gfp);
 }
 EXPORT_SYMBOL(cfg80211_remain_on_channel_expired);
@@ -662,8 +661,7 @@ int cfg80211_mlme_register_mgmt(struct wireless_dev *wdev, u32 snd_pid,
 	list_add(&nreg->list, &wdev->mgmt_registrations);
 
 	if (rdev->ops->mgmt_frame_register)
-		rdev->ops->mgmt_frame_register(wiphy, wdev->netdev,
-					       frame_type, true);
+		rdev->ops->mgmt_frame_register(wiphy, wdev, frame_type, true);
 
  out:
 	spin_unlock_bh(&wdev->mgmt_registrations_lock);
@@ -686,7 +684,7 @@ void cfg80211_mlme_unregister_socket(struct wireless_dev *wdev, u32 nlpid)
 		if (rdev->ops->mgmt_frame_register) {
 			u16 frame_type = le16_to_cpu(reg->frame_type);
 
-			rdev->ops->mgmt_frame_register(wiphy, wdev->netdev,
+			rdev->ops->mgmt_frame_register(wiphy, wdev,
 						       frame_type, false);
 		}
 
@@ -715,14 +713,14 @@ void cfg80211_mlme_purge_registrations(struct wireless_dev *wdev)
 }
 
 int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
-			  struct net_device *dev,
+			  struct wireless_dev *wdev,
 			  struct ieee80211_channel *chan, bool offchan,
 			  enum nl80211_channel_type channel_type,
 			  bool channel_type_valid, unsigned int wait,
 			  const u8 *buf, size_t len, bool no_cck,
 			  bool dont_wait_for_ack, u64 *cookie)
 {
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct net_device *dev = wdev->netdev;
 	const struct ieee80211_mgmt *mgmt;
 	u16 stype;
 
@@ -809,16 +807,15 @@ int cfg80211_mlme_mgmt_tx(struct cfg80211_registered_device *rdev,
 		return -EINVAL;
 
 	/* Transmit the Action frame as requested by user space */
-	return rdev->ops->mgmt_tx(&rdev->wiphy, dev, chan, offchan,
+	return rdev->ops->mgmt_tx(&rdev->wiphy, wdev, chan, offchan,
 				  channel_type, channel_type_valid,
 				  wait, buf, len, no_cck, dont_wait_for_ack,
 				  cookie);
 }
 
-bool cfg80211_rx_mgmt(struct net_device *dev, int freq, int sig_mbm,
+bool cfg80211_rx_mgmt(struct wireless_dev *wdev, int freq, int sig_mbm,
 		      const u8 *buf, size_t len, gfp_t gfp)
 {
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	struct cfg80211_mgmt_registration *reg;
@@ -855,7 +852,7 @@ bool cfg80211_rx_mgmt(struct net_device *dev, int freq, int sig_mbm,
 		/* found match! */
 
 		/* Indicate the received Action frame to user space */
-		if (nl80211_send_mgmt(rdev, dev, reg->nlpid,
+		if (nl80211_send_mgmt(rdev, wdev, reg->nlpid,
 				      freq, sig_mbm,
 				      buf, len, gfp))
 			continue;
@@ -870,15 +867,14 @@ bool cfg80211_rx_mgmt(struct net_device *dev, int freq, int sig_mbm,
 }
 EXPORT_SYMBOL(cfg80211_rx_mgmt);
 
-void cfg80211_mgmt_tx_status(struct net_device *dev, u64 cookie,
+void cfg80211_mgmt_tx_status(struct wireless_dev *wdev, u64 cookie,
 			     const u8 *buf, size_t len, bool ack, gfp_t gfp)
 {
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 
 	/* Indicate TX status of the Action frame to user space */
-	nl80211_send_mgmt_tx_status(rdev, dev, cookie, buf, len, ack, gfp);
+	nl80211_send_mgmt_tx_status(rdev, wdev, cookie, buf, len, ack, gfp);
 }
 EXPORT_SYMBOL(cfg80211_mgmt_tx_status);
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a6258dc..9a61c86 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1713,6 +1713,11 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	return result;
 }
 
+static inline u64 wdev_id(struct wireless_dev *wdev)
+{
+	return (u64)wdev->identifier |
+	       ((u64)wiphy_to_dev(wdev->wiphy)->wiphy_idx << 32);
+}
 
 static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 			      struct cfg80211_registered_device *rdev,
@@ -1720,8 +1725,6 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 {
 	struct net_device *dev = wdev->netdev;
 	void *hdr;
-	u64 wdev_id = (u64)wdev->identifier |
-		      ((u64)rdev->wiphy_idx << 32);
 
 	hdr = nl80211hdr_put(msg, pid, seq, flags, NL80211_CMD_NEW_INTERFACE);
 	if (!hdr)
@@ -1735,7 +1738,7 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 pid, u32 seq, int flags,
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
 	    nla_put_u32(msg, NL80211_ATTR_IFTYPE, wdev->iftype) ||
-	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id) ||
+	    nla_put_u64(msg, NL80211_ATTR_WDEV, wdev_id(wdev)) ||
 	    nla_put_u32(msg, NL80211_ATTR_GENERATION,
 			rdev->devlist_generation ^
 			(cfg80211_rdev_list_generation << 2)))
@@ -5707,7 +5710,7 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 				     struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = info->user_ptr[1];
 	struct ieee80211_channel *chan;
 	struct sk_buff *msg;
 	void *hdr;
@@ -5755,7 +5758,7 @@ static int nl80211_remain_on_channel(struct sk_buff *skb,
 		goto free_msg;
 	}
 
-	err = rdev->ops->remain_on_channel(&rdev->wiphy, dev, chan,
+	err = rdev->ops->remain_on_channel(&rdev->wiphy, wdev, chan,
 					   channel_type, duration, &cookie);
 
 	if (err)
@@ -5779,7 +5782,7 @@ static int nl80211_cancel_remain_on_channel(struct sk_buff *skb,
 					    struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = info->user_ptr[1];
 	u64 cookie;
 
 	if (!info->attrs[NL80211_ATTR_COOKIE])
@@ -5790,7 +5793,7 @@ static int nl80211_cancel_remain_on_channel(struct sk_buff *skb,
 
 	cookie = nla_get_u64(info->attrs[NL80211_ATTR_COOKIE]);
 
-	return rdev->ops->cancel_remain_on_channel(&rdev->wiphy, dev, cookie);
+	return rdev->ops->cancel_remain_on_channel(&rdev->wiphy, wdev, cookie);
 }
 
 static u32 rateset_to_mask(struct ieee80211_supported_band *sband,
@@ -5939,7 +5942,7 @@ static int nl80211_set_tx_bitrate_mask(struct sk_buff *skb,
 static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = info->user_ptr[1];
 	u16 frame_type = IEEE80211_FTYPE_MGMT | IEEE80211_STYPE_ACTION;
 
 	if (!info->attrs[NL80211_ATTR_FRAME_MATCH])
@@ -5948,21 +5951,24 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 	if (info->attrs[NL80211_ATTR_FRAME_TYPE])
 		frame_type = nla_get_u16(info->attrs[NL80211_ATTR_FRAME_TYPE]);
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_P2P_GO:
+		break;
+	default:
 		return -EOPNOTSUPP;
+	}
 
 	/* not much point in registering if we can't reply */
 	if (!rdev->ops->mgmt_tx)
 		return -EOPNOTSUPP;
 
-	return cfg80211_mlme_register_mgmt(dev->ieee80211_ptr, info->snd_pid,
-			frame_type,
+	return cfg80211_mlme_register_mgmt(wdev, info->snd_pid, frame_type,
 			nla_data(info->attrs[NL80211_ATTR_FRAME_MATCH]),
 			nla_len(info->attrs[NL80211_ATTR_FRAME_MATCH]));
 }
@@ -5970,7 +5976,7 @@ static int nl80211_register_mgmt(struct sk_buff *skb, struct genl_info *info)
 static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = info->user_ptr[1];
 	struct ieee80211_channel *chan;
 	enum nl80211_channel_type channel_type = NL80211_CHAN_NO_HT;
 	bool channel_type_valid = false;
@@ -5991,14 +5997,18 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 	if (!rdev->ops->mgmt_tx)
 		return -EOPNOTSUPP;
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_MESH_POINT:
+	case NL80211_IFTYPE_P2P_GO:
+		break;
+	default:
 		return -EOPNOTSUPP;
+	}
 
 	if (info->attrs[NL80211_ATTR_DURATION]) {
 		if (!(rdev->wiphy.flags & WIPHY_FLAG_OFFCHAN_TX))
@@ -6047,7 +6057,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 		}
 	}
 
-	err = cfg80211_mlme_mgmt_tx(rdev, dev, chan, offchan, channel_type,
+	err = cfg80211_mlme_mgmt_tx(rdev, wdev, chan, offchan, channel_type,
 				    channel_type_valid, wait,
 				    nla_data(info->attrs[NL80211_ATTR_FRAME]),
 				    nla_len(info->attrs[NL80211_ATTR_FRAME]),
@@ -6075,7 +6085,7 @@ static int nl80211_tx_mgmt(struct sk_buff *skb, struct genl_info *info)
 static int nl80211_tx_mgmt_cancel_wait(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
-	struct net_device *dev = info->user_ptr[1];
+	struct wireless_dev *wdev = info->user_ptr[1];
 	u64 cookie;
 
 	if (!info->attrs[NL80211_ATTR_COOKIE])
@@ -6084,17 +6094,21 @@ static int nl80211_tx_mgmt_cancel_wait(struct sk_buff *skb, struct genl_info *in
 	if (!rdev->ops->mgmt_tx_cancel_wait)
 		return -EOPNOTSUPP;
 
-	if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_STATION &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_ADHOC &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_CLIENT &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_AP_VLAN &&
-	    dev->ieee80211_ptr->iftype != NL80211_IFTYPE_P2P_GO)
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_P2P_GO:
+		break;
+	default:
 		return -EOPNOTSUPP;
+	}
 
 	cookie = nla_get_u64(info->attrs[NL80211_ATTR_COOKIE]);
 
-	return rdev->ops->mgmt_tx_cancel_wait(&rdev->wiphy, dev, cookie);
+	return rdev->ops->mgmt_tx_cancel_wait(&rdev->wiphy, wdev, cookie);
 }
 
 static int nl80211_set_power_save(struct sk_buff *skb, struct genl_info *info)
@@ -7125,7 +7139,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_remain_on_channel,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -7133,7 +7147,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_cancel_remain_on_channel,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -7149,7 +7163,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_register_mgmt,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV |
+		.internal_flags = NL80211_FLAG_NEED_WDEV |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -7157,7 +7171,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_tx_mgmt,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -7165,7 +7179,7 @@ static struct genl_ops nl80211_ops[] = {
 		.doit = nl80211_tx_mgmt_cancel_wait,
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
-		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
+		.internal_flags = NL80211_FLAG_NEED_WDEV_UP |
 				  NL80211_FLAG_NEED_RTNL,
 	},
 	{
@@ -7991,7 +8005,7 @@ nla_put_failure:
 
 static void nl80211_send_remain_on_chan_event(
 	int cmd, struct cfg80211_registered_device *rdev,
-	struct net_device *netdev, u64 cookie,
+	struct wireless_dev *wdev, u64 cookie,
 	struct ieee80211_channel *chan,
 	enum nl80211_channel_type channel_type,
 	unsigned int duration, gfp_t gfp)
@@ -8010,7 +8024,9 @@ static void nl80211_send_remain_on_chan_event(
 	}
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
+	    (wdev->netdev && nla_put_u32(msg, NL80211_ATTR_IFINDEX,
+	    				 wdev->netdev->ifindex)) ||
+	    nla_put_u32(msg, NL80211_ATTR_WDEV, wdev_id(wdev)) ||
 	    nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, chan->center_freq) ||
 	    nla_put_u32(msg, NL80211_ATTR_WIPHY_CHANNEL_TYPE, channel_type) ||
 	    nla_put_u64(msg, NL80211_ATTR_COOKIE, cookie))
@@ -8032,23 +8048,24 @@ static void nl80211_send_remain_on_chan_event(
 }
 
 void nl80211_send_remain_on_channel(struct cfg80211_registered_device *rdev,
-				    struct net_device *netdev, u64 cookie,
+				    struct wireless_dev *wdev, u64 cookie,
 				    struct ieee80211_channel *chan,
 				    enum nl80211_channel_type channel_type,
 				    unsigned int duration, gfp_t gfp)
 {
 	nl80211_send_remain_on_chan_event(NL80211_CMD_REMAIN_ON_CHANNEL,
-					  rdev, netdev, cookie, chan,
+					  rdev, wdev, cookie, chan,
 					  channel_type, duration, gfp);
 }
 
 void nl80211_send_remain_on_channel_cancel(
-	struct cfg80211_registered_device *rdev, struct net_device *netdev,
+	struct cfg80211_registered_device *rdev,
+	struct wireless_dev *wdev,
 	u64 cookie, struct ieee80211_channel *chan,
 	enum nl80211_channel_type channel_type, gfp_t gfp)
 {
 	nl80211_send_remain_on_chan_event(NL80211_CMD_CANCEL_REMAIN_ON_CHANNEL,
-					  rdev, netdev, cookie, chan,
+					  rdev, wdev, cookie, chan,
 					  channel_type, 0, gfp);
 }
 
@@ -8162,10 +8179,11 @@ bool nl80211_unexpected_4addr_frame(struct net_device *dev,
 }
 
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
-		      struct net_device *netdev, u32 nlpid,
+		      struct wireless_dev *wdev, u32 nlpid,
 		      int freq, int sig_dbm,
 		      const u8 *buf, size_t len, gfp_t gfp)
 {
+	struct net_device *netdev = wdev->netdev;
 	struct sk_buff *msg;
 	void *hdr;
 
@@ -8180,7 +8198,8 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 	}
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
+	    (netdev && nla_put_u32(msg, NL80211_ATTR_IFINDEX,
+					netdev->ifindex)) ||
 	    nla_put_u32(msg, NL80211_ATTR_WIPHY_FREQ, freq) ||
 	    (sig_dbm &&
 	     nla_put_u32(msg, NL80211_ATTR_RX_SIGNAL_DBM, sig_dbm)) ||
@@ -8198,10 +8217,11 @@ int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
 }
 
 void nl80211_send_mgmt_tx_status(struct cfg80211_registered_device *rdev,
-				 struct net_device *netdev, u64 cookie,
+				 struct wireless_dev *wdev, u64 cookie,
 				 const u8 *buf, size_t len, bool ack,
 				 gfp_t gfp)
 {
+	struct net_device *netdev = wdev->netdev;
 	struct sk_buff *msg;
 	void *hdr;
 
@@ -8216,7 +8236,8 @@ void nl80211_send_mgmt_tx_status(struct cfg80211_registered_device *rdev,
 	}
 
 	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
-	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex) ||
+	    (netdev && nla_put_u32(msg, NL80211_ATTR_IFINDEX,
+	    			   netdev->ifindex)) ||
 	    nla_put(msg, NL80211_ATTR_FRAME, len, buf) ||
 	    nla_put_u64(msg, NL80211_ATTR_COOKIE, cookie) ||
 	    (ack && nla_put_flag(msg, NL80211_ATTR_ACK)))
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 01a1122..0469303 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -74,13 +74,13 @@ void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 			     gfp_t gfp);
 
 void nl80211_send_remain_on_channel(struct cfg80211_registered_device *rdev,
-				    struct net_device *netdev,
-				    u64 cookie,
+				    struct wireless_dev *wdev, u64 cookie,
 				    struct ieee80211_channel *chan,
 				    enum nl80211_channel_type channel_type,
 				    unsigned int duration, gfp_t gfp);
 void nl80211_send_remain_on_channel_cancel(
-	struct cfg80211_registered_device *rdev, struct net_device *netdev,
+	struct cfg80211_registered_device *rdev,
+	struct wireless_dev *wdev,
 	u64 cookie, struct ieee80211_channel *chan,
 	enum nl80211_channel_type channel_type, gfp_t gfp);
 
@@ -92,11 +92,11 @@ void nl80211_send_sta_del_event(struct cfg80211_registered_device *rdev,
 				gfp_t gfp);
 
 int nl80211_send_mgmt(struct cfg80211_registered_device *rdev,
-		      struct net_device *netdev, u32 nlpid,
+		      struct wireless_dev *wdev, u32 nlpid,
 		      int freq, int sig_dbm,
 		      const u8 *buf, size_t len, gfp_t gfp);
 void nl80211_send_mgmt_tx_status(struct cfg80211_registered_device *rdev,
-				 struct net_device *netdev, u64 cookie,
+				 struct wireless_dev *wdev, u64 cookie,
 				 const u8 *buf, size_t len, bool ack,
 				 gfp_t gfp);
 
-- 
1.7.10

