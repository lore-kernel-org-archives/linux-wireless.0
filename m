Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60002 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286AbXK3Lsa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2007 06:48:30 -0500
Subject: [RFC] mac80211: don't use if_id, use if_priv
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: Michael Wu <flamingice@sourmilk.net>
Content-Type: text/plain
Date: Fri, 30 Nov 2007 12:48:21 +0100
Message-Id: <1196423301.6058.187.camel@johannes.berg> (sfid-20071130_114839_820471_B1A2470F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here's a non-functioning (except for b43/b43legacy) patch that gets rid
of the if_id stuff all over in favour of a new if_priv pointer.

This has two advantages:
 * no more looking up interfaces by if_id, this is better for network
   namespaces and performance
 * allows drivers to store and retrieve per-interface data without
   having to allocate own lists/hash tables

and a small disadvantage:
 * storage size can increase by four bytes on 64-bit machines.

Comments welcome. I'll be improving this and making it at least compile
with all other drivers. Maybe "struct if_priv" should be renamed?

johannes
---
 drivers/net/wireless/ath5k/base.c           |   15 +++---
 drivers/net/wireless/ath5k/base.h           |    2 
 drivers/net/wireless/ath5k/hw.c             |    2 
 drivers/net/wireless/b43/b43.h              |    5 --
 drivers/net/wireless/b43/main.c             |   13 +++--
 drivers/net/wireless/b43/xmit.c             |    6 +-
 drivers/net/wireless/b43legacy/b43legacy.h  |    5 --
 drivers/net/wireless/b43legacy/main.c       |   13 +++--
 drivers/net/wireless/b43legacy/xmit.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    2 
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   23 +++++-----
 drivers/net/wireless/rtl8187.h              |    2 
 drivers/net/wireless/rtl8187_dev.c          |    8 +--
 include/net/mac80211.h                      |   61 ++++++++++++++++------------
 net/mac80211/ieee80211.c                    |   12 +++--
 net/mac80211/ieee80211_i.h                  |    8 +++
 net/mac80211/ieee80211_sta.c                |    2 
 net/mac80211/tx.c                           |   50 +++++++++++-----------
 net/mac80211/util.c                         |   36 ++++------------
 20 files changed, 137 insertions(+), 136 deletions(-)

--- everything.orig/include/net/mac80211.h	2007-11-30 11:03:03.158538792 +0100
+++ everything/include/net/mac80211.h	2007-11-30 11:15:36.578536784 +0100
@@ -242,6 +242,7 @@ struct ieee80211_low_level_stats {
  * the hardware to use given values (depending on what is supported). */
 
 struct ieee80211_tx_control {
+	struct if_priv *if_priv;
 	int tx_rate; /* Transmit rate, given as the hw specific value for the
 		      * rate (from struct ieee80211_rate) */
 	int rts_cts_rate; /* Transmit rate for RTS/CTS frame, given as the hw
@@ -291,7 +292,6 @@ struct ieee80211_tx_control {
 			     * packet dropping when probing higher rates, if hw
 			     * supports multiple retry rates. -1 = not used */
 	int type;	/* internal */
-	int ifindex;	/* internal */
 };
 
 
@@ -480,13 +480,23 @@ enum ieee80211_if_types {
 };
 
 /**
+ * struct if_priv - driver per-interface data
+ *
+ * The only purpose of this structure is to provide type
+ * warnings for the if_priv pointers used elsewhere.
+ *
+ * @p: pointer for driver use
+ */
+struct if_priv {
+	void *p;
+};
+
+/**
  * struct ieee80211_if_init_conf - initial configuration of an interface
  *
- * @if_id: internal interface ID. This number has no particular meaning to
- *	drivers and the only allowed usage is to pass it to
- *	ieee80211_beacon_get() and ieee80211_get_buffered_bc() functions.
- *	This field is not valid for monitor interfaces
- *	(interfaces of %IEEE80211_IF_TYPE_MNTR type).
+ * @if_priv: pointer to a driver-use per-interface structure. The pointer
+ *	itself is also used for various functions including
+ *	ieee80211_beacon_get() and ieee80211_get_buffered_bc().
  * @type: one of &enum ieee80211_if_types constants. Determines the type of
  *	added/removed interface.
  * @mac_addr: pointer to MAC address of the interface. This pointer is valid
@@ -503,8 +513,8 @@ enum ieee80211_if_types {
  * in pure monitor mode.
  */
 struct ieee80211_if_init_conf {
-	int if_id;
 	enum ieee80211_if_types type;
+	struct if_priv *if_priv;
 	void *mac_addr;
 };
 
@@ -1009,7 +1019,8 @@ struct ieee80211_ops {
 				 struct ieee80211_if_init_conf *conf);
 	int (*config)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
 	int (*config_interface)(struct ieee80211_hw *hw,
-				int if_id, struct ieee80211_if_conf *conf);
+				struct if_priv *if_priv,
+				struct ieee80211_if_conf *conf);
 	void (*configure_filter)(struct ieee80211_hw *hw,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
@@ -1028,7 +1039,7 @@ struct ieee80211_ops {
 	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*set_retry_limit)(struct ieee80211_hw *hw,
 			       u32 short_retry, u32 long_retr);
-	void (*sta_notify)(struct ieee80211_hw *hw, int if_id,
+	void (*sta_notify)(struct ieee80211_hw *hw, struct if_priv *if_priv,
 			enum sta_notify_cmd, const u8 *addr);
 	void (*erp_ie_changed)(struct ieee80211_hw *hw, u8 changes,
 			       int cts_protection, int preamble);
@@ -1210,7 +1221,7 @@ void ieee80211_tx_status_irqsafe(struct 
 /**
  * ieee80211_beacon_get - beacon generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @if_priv: &struct if_priv pointer from &struct ieee80211_if_init_conf.
  * @control: will be filled with information needed to send this beacon.
  *
  * If the beacon frames are generated by the host system (i.e., not in
@@ -1221,13 +1232,13 @@ void ieee80211_tx_status_irqsafe(struct 
  * is responsible of freeing it.
  */
 struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
-				     int if_id,
+				     struct if_priv *if_priv,
 				     struct ieee80211_tx_control *control);
 
 /**
  * ieee80211_rts_get - RTS frame generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @if_priv: &struct if_priv pointer from &struct ieee80211_if_init_conf.
  * @frame: pointer to the frame that is going to be protected by the RTS.
  * @frame_len: the frame length (in octets).
  * @frame_txctl: &struct ieee80211_tx_control of the frame.
@@ -1238,7 +1249,7 @@ struct sk_buff *ieee80211_beacon_get(str
  * the next RTS frame from the 802.11 code. The low-level is responsible
  * for calling this function before and RTS frame is needed.
  */
-void ieee80211_rts_get(struct ieee80211_hw *hw, int if_id,
+void ieee80211_rts_get(struct ieee80211_hw *hw, struct if_priv *if_priv,
 		       const void *frame, size_t frame_len,
 		       const struct ieee80211_tx_control *frame_txctl,
 		       struct ieee80211_rts *rts);
@@ -1246,7 +1257,7 @@ void ieee80211_rts_get(struct ieee80211_
 /**
  * ieee80211_rts_duration - Get the duration field for an RTS frame
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @if_priv: &struct if_priv pointer from &struct ieee80211_if_init_conf.
  * @frame_len: the length of the frame that is going to be protected by the RTS.
  * @frame_txctl: &struct ieee80211_tx_control of the frame.
  *
@@ -1254,14 +1265,14 @@ void ieee80211_rts_get(struct ieee80211_
  * the duration field, the low-level driver uses this function to receive
  * the duration field value in little-endian byteorder.
  */
-__le16 ieee80211_rts_duration(struct ieee80211_hw *hw, int if_id,
+__le16 ieee80211_rts_duration(struct ieee80211_hw *hw, struct if_priv *if_priv,
 			      size_t frame_len,
 			      const struct ieee80211_tx_control *frame_txctl);
 
 /**
  * ieee80211_ctstoself_get - CTS-to-self frame generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @if_priv: &struct if_priv pointer from &struct ieee80211_if_init_conf.
  * @frame: pointer to the frame that is going to be protected by the CTS-to-self.
  * @frame_len: the frame length (in octets).
  * @frame_txctl: &struct ieee80211_tx_control of the frame.
@@ -1272,7 +1283,7 @@ __le16 ieee80211_rts_duration(struct iee
  * the next CTS-to-self frame from the 802.11 code. The low-level is responsible
  * for calling this function before and CTS-to-self frame is needed.
  */
-void ieee80211_ctstoself_get(struct ieee80211_hw *hw, int if_id,
+void ieee80211_ctstoself_get(struct ieee80211_hw *hw, struct if_priv *if_priv,
 			     const void *frame, size_t frame_len,
 			     const struct ieee80211_tx_control *frame_txctl,
 			     struct ieee80211_cts *cts);
@@ -1280,7 +1291,7 @@ void ieee80211_ctstoself_get(struct ieee
 /**
  * ieee80211_ctstoself_duration - Get the duration field for a CTS-to-self frame
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @if_priv: &struct if_priv pointer from &struct ieee80211_if_init_conf.
  * @frame_len: the length of the frame that is going to be protected by the CTS-to-self.
  * @frame_txctl: &struct ieee80211_tx_control of the frame.
  *
@@ -1288,28 +1299,30 @@ void ieee80211_ctstoself_get(struct ieee
  * the duration field, the low-level driver uses this function to receive
  * the duration field value in little-endian byteorder.
  */
-__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw, int if_id,
+__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
+				    struct if_priv *if_priv,
 				    size_t frame_len,
 				    const struct ieee80211_tx_control *frame_txctl);
 
 /**
  * ieee80211_generic_frame_duration - Calculate the duration field for a frame
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @if_priv: &struct if_priv pointer from &struct ieee80211_if_init_conf.
  * @frame_len: the length of the frame.
  * @rate: the rate (in 100kbps) at which the frame is going to be transmitted.
  *
  * Calculate the duration field of some generic frame, given its
  * length and transmission rate (in 100kbps).
  */
-__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw, int if_id,
+__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
+					struct if_priv *if_priv,
 					size_t frame_len,
 					int rate);
 
 /**
  * ieee80211_get_buffered_bc - accessing buffered broadcast and multicast frames
  * @hw: pointer as obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @if_priv: &struct if_priv pointer from &struct ieee80211_if_init_conf.
  * @control: will be filled with information needed to send returned frame.
  *
  * Function for accessing buffered broadcast and multicast frames. If
@@ -1328,7 +1341,7 @@ __le16 ieee80211_generic_frame_duration(
  * use common code for all beacons.
  */
 struct sk_buff *
-ieee80211_get_buffered_bc(struct ieee80211_hw *hw, int if_id,
+ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct if_priv *if_priv,
 			  struct ieee80211_tx_control *control);
 
 /**
@@ -1419,7 +1432,7 @@ void ieee80211_scan_completed(struct iee
  */
 void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
 					 void (*iterator)(void *data, u8 *mac,
-							  int if_id),
+							  struct if_priv *p),
 					 void *data);
 
 #endif /* MAC80211_H */
--- everything.orig/net/mac80211/ieee80211.c	2007-11-30 11:12:56.658539388 +0100
+++ everything/net/mac80211/ieee80211.c	2007-11-30 11:18:56.208536025 +0100
@@ -257,7 +257,7 @@ static int ieee80211_open(struct net_dev
 		sdata->u.sta.flags &= ~IEEE80211_STA_PREV_BSSID_SET;
 		/* fall through */
 	default:
-		conf.if_id = dev->ifindex;
+		conf.if_priv = &sdata->if_priv;
 		conf.type = sdata->type;
 		conf.mac_addr = dev->dev_addr;
 		res = local->ops->add_interface(local_to_hw(local), &conf);
@@ -376,7 +376,7 @@ static int ieee80211_stop(struct net_dev
 		flush_workqueue(local->hw.workqueue);
 		/* fall through */
 	default:
-		conf.if_id = dev->ifindex;
+		conf.if_priv = &sdata->if_priv;
 		conf.type = sdata->type;
 		conf.mac_addr = dev->dev_addr;
 		/* disable all keys for as long as this netdev is down */
@@ -512,7 +512,7 @@ static int __ieee80211_if_config(struct 
 		conf.beacon_control = control;
 	}
 	return local->ops->config_interface(local_to_hw(local),
-					   dev->ifindex, &conf);
+					    &sdata->if_priv, &conf);
 }
 
 int ieee80211_if_config(struct net_device *dev)
@@ -524,11 +524,13 @@ int ieee80211_if_config_beacon(struct ne
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_tx_control control;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sk_buff *skb;
 
 	if (!(local->hw.flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE))
 		return 0;
-	skb = ieee80211_beacon_get(local_to_hw(local), dev->ifindex, &control);
+	skb = ieee80211_beacon_get(local_to_hw(local), &sdata->if_priv,
+				   &control);
 	if (!skb)
 		return -ENOMEM;
 	return __ieee80211_if_config(dev, skb, &control);
@@ -684,7 +686,7 @@ static void ieee80211_remove_tx_extra(st
 	struct ieee80211_tx_packet_data *pkt_data;
 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
-	pkt_data->ifindex = control->ifindex;
+	pkt_data->sdata = if_priv_to_sdata(control->if_priv);
 	pkt_data->flags = 0;
 	if (control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)
 		pkt_data->flags |= IEEE80211_TXPD_REQ_TX_STATUS;
--- everything.orig/net/mac80211/ieee80211_i.h	2007-11-30 11:12:32.588579156 +0100
+++ everything/net/mac80211/ieee80211_i.h	2007-11-30 11:18:30.998538032 +0100
@@ -163,7 +163,7 @@ struct ieee80211_txrx_data {
 #define IEEE80211_TXPD_REQUEUE		BIT(2)
 /* Stored in sk_buff->cb */
 struct ieee80211_tx_packet_data {
-	int ifindex;
+	struct ieee80211_sub_if_data *sdata;
 	unsigned long jiffies;
 	unsigned int flags;
 	u8 queue;
@@ -299,6 +299,7 @@ struct ieee80211_sub_if_data {
 
 	struct net_device *dev;
 	struct ieee80211_local *local;
+	struct if_priv if_priv;
 
 	unsigned int flags;
 
@@ -389,6 +390,11 @@ struct ieee80211_sub_if_data {
 #endif
 };
 
+static inline struct ieee80211_sub_if_data *if_priv_to_sdata(struct if_priv *p)
+{
+	return container_of(p, struct ieee80211_sub_if_data, if_priv);
+}
+
 #define IEEE80211_DEV_TO_SUB_IF(dev) netdev_priv(dev)
 
 enum {
--- everything.orig/net/mac80211/util.c	2007-11-30 11:13:26.898562446 +0100
+++ everything/net/mac80211/util.c	2007-11-30 11:28:39.118538032 +0100
@@ -301,44 +301,34 @@ int ieee80211_frame_duration(struct ieee
 }
 
 /* Exported duration function for driver use */
-__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw, int if_id,
+__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
+					struct if_priv *if_priv,
 					size_t frame_len, int rate)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct net_device *bdev = dev_get_by_index(&init_net, if_id);
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = if_priv_to_sdata(if_priv);
 	u16 dur;
 	int erp;
 
-	if (unlikely(!bdev))
-		return 0;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(bdev);
 	erp = ieee80211_is_erp_rate(hw->conf.phymode, rate);
 	dur = ieee80211_frame_duration(local, frame_len, rate,
 		       erp, sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE);
 
-	dev_put(bdev);
 	return cpu_to_le16(dur);
 }
 EXPORT_SYMBOL(ieee80211_generic_frame_duration);
 
-__le16 ieee80211_rts_duration(struct ieee80211_hw *hw, int if_id,
+__le16 ieee80211_rts_duration(struct ieee80211_hw *hw, struct if_priv *if_priv,
 			      size_t frame_len,
 			      const struct ieee80211_tx_control *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	struct net_device *bdev = dev_get_by_index(&init_net, if_id);
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = if_priv_to_sdata(if_priv);
 	int short_preamble;
 	int erp;
 	u16 dur;
 
-	if (unlikely(!bdev))
-		return 0;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(bdev);
 	short_preamble = sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE;
 
 	rate = frame_txctl->rts_rate;
@@ -354,27 +344,22 @@ __le16 ieee80211_rts_duration(struct iee
 	dur += ieee80211_frame_duration(local, 10, rate->rate,
 					erp, short_preamble);
 
-	dev_put(bdev);
 	return cpu_to_le16(dur);
 }
 EXPORT_SYMBOL(ieee80211_rts_duration);
 
-__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw, int if_id,
+__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
+				    struct if_priv *if_priv,
 				    size_t frame_len,
 				    const struct ieee80211_tx_control *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	struct net_device *bdev = dev_get_by_index(&init_net, if_id);
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = if_priv_to_sdata(if_priv);
 	int short_preamble;
 	int erp;
 	u16 dur;
 
-	if (unlikely(!bdev))
-		return 0;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(bdev);
 	short_preamble = sdata->flags & IEEE80211_SDATA_SHORT_PREAMBLE;
 
 	rate = frame_txctl->rts_rate;
@@ -389,7 +374,6 @@ __le16 ieee80211_ctstoself_duration(stru
 						erp, short_preamble);
 	}
 
-	dev_put(bdev);
 	return cpu_to_le16(dur);
 }
 EXPORT_SYMBOL(ieee80211_ctstoself_duration);
@@ -476,7 +460,7 @@ EXPORT_SYMBOL(ieee80211_wake_queues);
 
 void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
 					 void (*iterator)(void *data, u8 *mac,
-							  int if_id),
+							  struct if_priv *p),
 					 void *data)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -501,7 +485,7 @@ void ieee80211_iterate_active_interfaces
 			continue;
 		if (netif_running(sdata->dev))
 			iterator(data, sdata->dev->dev_addr,
-				 sdata->dev->ifindex);
+				 &sdata->if_priv);
 	}
 }
 EXPORT_SYMBOL_GPL(ieee80211_iterate_active_interfaces);
--- everything.orig/net/mac80211/ieee80211_sta.c	2007-11-30 11:19:24.008538520 +0100
+++ everything/net/mac80211/ieee80211_sta.c	2007-11-30 11:19:33.788541938 +0100
@@ -454,7 +454,7 @@ static void ieee80211_sta_tx(struct net_
 
 	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
-	pkt_data->ifindex = sdata->dev->ifindex;
+	pkt_data->sdata = sdata;
 	if (!encrypt)
 		pkt_data->flags |= IEEE80211_TXPD_DO_NOT_ENCRYPT;
 
--- everything.orig/net/mac80211/tx.c	2007-11-30 11:20:08.138537869 +0100
+++ everything/net/mac80211/tx.c	2007-11-30 11:25:44.908538575 +0100
@@ -1011,7 +1011,7 @@ static int ieee80211_tx_prepare(struct i
 	struct net_device *dev;
 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
-	dev = dev_get_by_index(&init_net, pkt_data->ifindex);
+	dev = pkt_data->sdata->dev;
 	if (unlikely(dev && !is_ieee80211_device(dev, mdev))) {
 		dev_put(dev);
 		dev = NULL;
@@ -1225,8 +1225,9 @@ int ieee80211_master_start_xmit(struct s
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(&control, 0, sizeof(struct ieee80211_tx_control));
 
-	if (pkt_data->ifindex)
-		odev = dev_get_by_index(&init_net, pkt_data->ifindex);
+	if (pkt_data->sdata)
+		odev = pkt_data->sdata->dev;
+
 	if (unlikely(odev && !is_ieee80211_device(odev, dev))) {
 		dev_put(odev);
 		odev = NULL;
@@ -1250,7 +1251,7 @@ int ieee80211_master_start_xmit(struct s
 		}
 	}
 
-	control.ifindex = odev->ifindex;
+	control.if_priv = &osdata->if_priv;
 	control.type = osdata->type;
 	if (pkt_data->flags & IEEE80211_TXPD_REQ_TX_STATUS)
 		control.flags |= IEEE80211_TXCTL_REQ_TX_STATUS;
@@ -1295,7 +1296,7 @@ int ieee80211_monitor_start_xmit(struct 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(pkt_data, 0, sizeof(*pkt_data));
 	/* needed because we set skb device to master */
-	pkt_data->ifindex = dev->ifindex;
+	pkt_data->sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	pkt_data->flags |= IEEE80211_TXPD_DO_NOT_ENCRYPT;
 
@@ -1504,7 +1505,7 @@ int ieee80211_subif_start_xmit(struct sk
 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
-	pkt_data->ifindex = dev->ifindex;
+	pkt_data->sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	skb->dev = local->mdev;
 	dev->stats.tx_packets++;
@@ -1659,7 +1660,8 @@ static void ieee80211_beacon_add_tim(str
 	read_unlock_bh(&local->sta_lock);
 }
 
-struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw, int if_id,
+struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
+				     struct if_priv *if_priv,
 				     struct ieee80211_tx_control *control)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -1672,19 +1674,15 @@ struct sk_buff *ieee80211_beacon_get(str
 	u8 *b_head, *b_tail;
 	int bh_len, bt_len;
 
-	bdev = dev_get_by_index(&init_net, if_id);
-	if (bdev) {
-		sdata = IEEE80211_DEV_TO_SUB_IF(bdev);
-		ap = &sdata->u.ap;
-		dev_put(bdev);
-	}
+	sdata = if_priv_to_sdata(if_priv);
+	bdev = sdata->dev;
 
 	if (!ap || sdata->type != IEEE80211_IF_TYPE_AP ||
 	    !ap->beacon_head) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		if (net_ratelimit())
-			printk(KERN_DEBUG "no beacon data avail for idx=%d "
-			       "(%s)\n", if_id, bdev ? bdev->name : "N/A");
+			printk(KERN_DEBUG "no beacon data avail for %s\n",
+			       bdev->name);
 #endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 		return NULL;
 	}
@@ -1741,7 +1739,7 @@ struct sk_buff *ieee80211_beacon_get(str
 }
 EXPORT_SYMBOL(ieee80211_beacon_get);
 
-void ieee80211_rts_get(struct ieee80211_hw *hw, int if_id,
+void ieee80211_rts_get(struct ieee80211_hw *hw, struct if_priv *if_priv,
 		       const void *frame, size_t frame_len,
 		       const struct ieee80211_tx_control *frame_txctl,
 		       struct ieee80211_rts *rts)
@@ -1751,13 +1749,14 @@ void ieee80211_rts_get(struct ieee80211_
 
 	fctl = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS;
 	rts->frame_control = cpu_to_le16(fctl);
-	rts->duration = ieee80211_rts_duration(hw, if_id, frame_len, frame_txctl);
+	rts->duration = ieee80211_rts_duration(hw, if_priv, frame_len,
+					       frame_txctl);
 	memcpy(rts->ra, hdr->addr1, sizeof(rts->ra));
 	memcpy(rts->ta, hdr->addr2, sizeof(rts->ta));
 }
 EXPORT_SYMBOL(ieee80211_rts_get);
 
-void ieee80211_ctstoself_get(struct ieee80211_hw *hw, int if_id,
+void ieee80211_ctstoself_get(struct ieee80211_hw *hw, struct if_priv *if_priv,
 			     const void *frame, size_t frame_len,
 			     const struct ieee80211_tx_control *frame_txctl,
 			     struct ieee80211_cts *cts)
@@ -1767,13 +1766,15 @@ void ieee80211_ctstoself_get(struct ieee
 
 	fctl = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS;
 	cts->frame_control = cpu_to_le16(fctl);
-	cts->duration = ieee80211_ctstoself_duration(hw, if_id, frame_len, frame_txctl);
+	cts->duration = ieee80211_ctstoself_duration(hw, if_priv,
+						     frame_len, frame_txctl);
 	memcpy(cts->ra, hdr->addr1, sizeof(cts->ra));
 }
 EXPORT_SYMBOL(ieee80211_ctstoself_get);
 
 struct sk_buff *
-ieee80211_get_buffered_bc(struct ieee80211_hw *hw, int if_id,
+ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
+			  struct if_priv *if_priv,
 			  struct ieee80211_tx_control *control)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -1786,12 +1787,9 @@ ieee80211_get_buffered_bc(struct ieee802
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_ap *bss = NULL;
 
-	bdev = dev_get_by_index(&init_net, if_id);
-	if (bdev) {
-		sdata = IEEE80211_DEV_TO_SUB_IF(bdev);
-		bss = &sdata->u.ap;
-		dev_put(bdev);
-	}
+	sdata = if_priv_to_sdata(if_priv);
+	bdev = sdata->dev;
+
 	if (!bss || sdata->type != IEEE80211_IF_TYPE_AP || !bss->beacon_head)
 		return NULL;
 
--- everything.orig/drivers/net/wireless/b43/b43.h	2007-11-30 11:29:34.198540039 +0100
+++ everything/drivers/net/wireless/b43/b43.h	2007-11-30 11:29:57.998536893 +0100
@@ -609,10 +609,7 @@ struct b43_wl {
 	 * at a time. General information about this interface follows.
 	 */
 
-	/* Opaque ID of the operating interface from the ieee80211
-	 * subsystem. Do not modify.
-	 */
-	int if_id;
+	struct if_priv *if_priv;
 	/* The MAC address of the operating interface. */
 	u8 mac_addr[ETH_ALEN];
 	/* Current BSSID */
--- everything.orig/drivers/net/wireless/b43/main.c	2007-11-30 11:30:23.688538520 +0100
+++ everything/drivers/net/wireless/b43/main.c	2007-11-30 11:34:01.798537164 +0100
@@ -1179,7 +1179,7 @@ static void b43_write_probe_resp_plcp(st
 	plcp.data = 0;
 	b43_generate_plcp_hdr(&plcp, size + FCS_LEN, rate);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id, size,
+					       dev->wl->if_priv, size,
 					       B43_RATE_TO_BASE100KBPS(rate));
 	/* Write PLCP in two parts and timing for packet transfer */
 	tmp = le32_to_cpu(plcp.data);
@@ -1236,7 +1236,7 @@ static u8 *b43_generate_probe_resp(struc
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					 IEEE80211_STYPE_PROBE_RESP);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id, *dest_size,
+					       dev->wl->if_priv, *dest_size,
 					       B43_RATE_TO_BASE100KBPS(rate));
 	hdr->duration_id = dur;
 
@@ -2940,7 +2940,7 @@ static void b43_op_configure_filter(stru
 }
 
 static int b43_op_config_interface(struct ieee80211_hw *hw,
-				   int if_id,
+				   struct if_priv *if_priv,
 				   struct ieee80211_if_conf *conf)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
@@ -2951,7 +2951,7 @@ static int b43_op_config_interface(struc
 		return -ENODEV;
 	mutex_lock(&wl->mutex);
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	B43_WARN_ON(wl->if_id != if_id);
+	B43_WARN_ON(wl->if_priv != if_priv);
 	if (conf->bssid)
 		memcpy(wl->bssid, conf->bssid, ETH_ALEN);
 	else
@@ -3454,7 +3454,7 @@ static int b43_op_add_interface(struct i
 
 	dev = wl->current_dev;
 	wl->operating = 1;
-	wl->if_id = conf->if_id;
+	wl->if_priv = conf->if_priv;
 	wl->if_type = conf->type;
 	memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
 
@@ -3482,7 +3482,8 @@ static void b43_op_remove_interface(stru
 	mutex_lock(&wl->mutex);
 
 	B43_WARN_ON(!wl->operating);
-	B43_WARN_ON(wl->if_id != conf->if_id);
+	B43_WARN_ON(wl->if_priv != conf->if_priv);
+	wl->if_priv = NULL;
 
 	wl->operating = 0;
 
--- everything.orig/drivers/net/wireless/b43/xmit.c	2007-11-30 11:31:28.438538683 +0100
+++ everything/drivers/net/wireless/b43/xmit.c	2007-11-30 11:32:00.958536187 +0100
@@ -221,7 +221,7 @@ static void generate_txhdr_fw4(struct b4
 	} else {
 		int fbrate_base100kbps = B43_RATE_TO_BASE100KBPS(rate_fb);
 		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
-								 dev->wl->if_id,
+								 txctl->if_priv,
 								 fragment_len,
 								 fbrate_base100kbps);
 	}
@@ -311,7 +311,7 @@ static void generate_txhdr_fw4(struct b4
 		rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);
 
 		if (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
-			ieee80211_ctstoself_get(dev->wl->hw, dev->wl->if_id,
+			ieee80211_ctstoself_get(dev->wl->hw, txctl->if_priv,
 						fragment_data, fragment_len,
 						txctl,
 						(struct ieee80211_cts *)(txhdr->
@@ -319,7 +319,7 @@ static void generate_txhdr_fw4(struct b4
 			mac_ctl |= B43_TX4_MAC_SENDCTS;
 			len = sizeof(struct ieee80211_cts);
 		} else {
-			ieee80211_rts_get(dev->wl->hw, dev->wl->if_id,
+			ieee80211_rts_get(dev->wl->hw, txctl->if_priv,
 					  fragment_data, fragment_len, txctl,
 					  (struct ieee80211_rts *)(txhdr->
 								   rts_frame));
--- everything.orig/drivers/net/wireless/b43legacy/b43legacy.h	2007-11-30 11:32:24.778539063 +0100
+++ everything/drivers/net/wireless/b43legacy/b43legacy.h	2007-11-30 11:32:35.298535157 +0100
@@ -572,10 +572,7 @@ struct b43legacy_wl {
 	 * at a time. General information about this interface follows.
 	 */
 
-	/* Opaque ID of the operating interface from the ieee80211
-	 * subsystem. Do not modify.
-	 */
-	int if_id;
+	struct if_priv *if_priv;
 	/* MAC address (can be NULL). */
 	u8 mac_addr[ETH_ALEN];
 	/* Current BSSID (can be NULL). */
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2007-11-30 11:32:49.548551650 +0100
+++ everything/drivers/net/wireless/b43legacy/main.c	2007-11-30 11:33:22.078535536 +0100
@@ -976,7 +976,7 @@ static void b43legacy_write_probe_resp_p
 	plcp.data = 0;
 	b43legacy_generate_plcp_hdr(&plcp, size + FCS_LEN, rate);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id,
+					       dev->wl->if_priv,
 					       size,
 					       B43legacy_RATE_TO_100KBPS(rate));
 	/* Write PLCP in two parts and timing for packet transfer */
@@ -1042,7 +1042,7 @@ static u8 *b43legacy_generate_probe_resp
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					 IEEE80211_STYPE_PROBE_RESP);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id,
+					       dev->wl->if_priv,
 					       *dest_size,
 					       B43legacy_RATE_TO_100KBPS(rate));
 	hdr->duration_id = dur;
@@ -2635,7 +2635,7 @@ static void b43legacy_op_configure_filte
 }
 
 static int b43legacy_op_config_interface(struct ieee80211_hw *hw,
-					 int if_id,
+					 struct if_priv *if_priv,
 					 struct ieee80211_if_conf *conf)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
@@ -2646,7 +2646,7 @@ static int b43legacy_op_config_interface
 		return -ENODEV;
 	mutex_lock(&wl->mutex);
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	B43legacy_WARN_ON(wl->if_id != if_id);
+	B43legacy_WARN_ON(wl->if_priv != if_priv);
 	if (conf->bssid)
 		memcpy(wl->bssid, conf->bssid, ETH_ALEN);
 	else
@@ -3168,7 +3168,7 @@ static int b43legacy_op_add_interface(st
 
 	dev = wl->current_dev;
 	wl->operating = 1;
-	wl->if_id = conf->if_id;
+	wl->if_priv = conf->if_priv;
 	wl->if_type = conf->type;
 	memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
 
@@ -3196,7 +3196,8 @@ static void b43legacy_op_remove_interfac
 	mutex_lock(&wl->mutex);
 
 	B43legacy_WARN_ON(!wl->operating);
-	B43legacy_WARN_ON(wl->if_id != conf->if_id);
+	B43legacy_WARN_ON(wl->if_priv != conf->if_priv);
+	wl->if_priv = NULL;
 
 	wl->operating = 0;
 
--- everything.orig/drivers/net/wireless/b43legacy/xmit.c	2007-11-30 11:33:26.808540311 +0100
+++ everything/drivers/net/wireless/b43legacy/xmit.c	2007-11-30 11:33:42.158537978 +0100
@@ -223,7 +223,7 @@ static void generate_txhdr_fw3(struct b4
 	} else {
 		int fbrate_base100kbps = B43legacy_RATE_TO_100KBPS(rate_fb);
 		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
-							 dev->wl->if_id,
+							 txctl->if_priv,
 							 fragment_len,
 							 fbrate_base100kbps);
 	}
@@ -312,7 +312,7 @@ static void generate_txhdr_fw3(struct b4
 
 		if (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
 			ieee80211_ctstoself_get(dev->wl->hw,
-						dev->wl->if_id,
+						txctl->if_priv,
 						fragment_data,
 						fragment_len, txctl,
 						(struct ieee80211_cts *)
@@ -321,7 +321,7 @@ static void generate_txhdr_fw3(struct b4
 			len = sizeof(struct ieee80211_cts);
 		} else {
 			ieee80211_rts_get(dev->wl->hw,
-					  dev->wl->if_id,
+					  txctl->if_priv,
 					  fragment_data, fragment_len, txctl,
 					  (struct ieee80211_rts *)
 					  (txhdr->rts_frame));
--- everything.orig/drivers/net/wireless/ath5k/base.c	2007-11-30 11:34:32.348539660 +0100
+++ everything/drivers/net/wireless/ath5k/base.c	2007-11-30 11:36:12.348536621 +0100
@@ -273,7 +273,8 @@ static void ath5k_remove_interface(struc
 		struct ieee80211_if_init_conf *conf);
 static int ath5k_config(struct ieee80211_hw *hw,
 		struct ieee80211_conf *conf);
-static int ath5k_config_interface(struct ieee80211_hw *hw, int if_id,
+static int ath5k_config_interface(struct ieee80211_hw *hw,
+		struct if_priv *if_priv,
 		struct ieee80211_if_conf *conf);
 static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		unsigned int changed_flags,
@@ -2618,12 +2619,12 @@ static int ath5k_add_interface(struct ie
 	int ret;
 
 	mutex_lock(&sc->lock);
-	if (sc->iface_id) {
+	if (sc->if_priv) {
 		ret = 0;
 		goto end;
 	}
 
-	sc->iface_id = conf->if_id;
+	sc->if_priv = conf->if_priv;
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
@@ -2648,10 +2649,10 @@ ath5k_remove_interface(struct ieee80211_
 	struct ath5k_softc *sc = hw->priv;
 
 	mutex_lock(&sc->lock);
-	if (sc->iface_id != conf->if_id)
+	if (sc->if_priv != conf->if_priv)
 		goto end;
 
-	sc->iface_id = 0;
+	sc->if_priv = NULL;
 end:
 	mutex_unlock(&sc->lock);
 }
@@ -2669,7 +2670,7 @@ ath5k_config(struct ieee80211_hw *hw,
 }
 
 static int
-ath5k_config_interface(struct ieee80211_hw *hw, int if_id,
+ath5k_config_interface(struct ieee80211_hw *hw, struct if_priv *if_priv,
 			struct ieee80211_if_conf *conf)
 {
 	struct ath5k_softc *sc = hw->priv;
@@ -2680,7 +2681,7 @@ ath5k_config_interface(struct ieee80211_
 	 * be set to mac80211's value at ath5k_config(). */
 	sc->bintval = 1000 * 1000 / 1024;
 	mutex_lock(&sc->lock);
-	if (sc->iface_id != if_id) {
+	if (sc->if_priv != if_priv) {
 		ret = -EIO;
 		goto unlock;
 	}
--- everything.orig/drivers/net/wireless/ath5k/base.h	2007-11-30 11:35:24.698538737 +0100
+++ everything/drivers/net/wireless/ath5k/base.h	2007-11-30 11:35:50.268536676 +0100
@@ -120,7 +120,7 @@ struct ath5k_softc {
 	unsigned int		curmode;	/* current phy mode */
 	struct ieee80211_channel *curchan;	/* current h/w channel */
 
-	int 			iface_id;	/* add/remove_interface id */
+	struct if_priv *if_priv;
 
 	struct {
 		u8	rxflags;	/* radiotap rx flags */
--- everything.orig/drivers/net/wireless/ath5k/hw.c	2007-11-30 11:36:38.318548286 +0100
+++ everything/drivers/net/wireless/ath5k/hw.c	2007-11-30 11:36:45.108537707 +0100
@@ -556,7 +556,7 @@ static inline void ath5k_hw_write_rate_d
 		 * ieee80211_duration() for a brief description of
 		 * what rate we should choose to TX ACKs. */
 		tx_time = ieee80211_generic_frame_duration(sc->hw,
-			sc->iface_id, 10, control_rate->rate_kbps/100);
+			sc->if_priv, 10, control_rate->rate_kbps/100);
 
 		ath5k_hw_reg_write(ah, tx_time, reg);
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-11-30 11:38:08.108538846 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-11-30 11:38:16.858537706 +0100
@@ -896,7 +896,7 @@ struct iwl3945_priv {
 	u32 timestamp1;
 	u16 beacon_int;
 	struct iwl3945_driver_hw_info hw_setting;
-	int interface_id;
+	struct if_priv *if_priv;
 
 	/* Current association information needed to configure the
 	 * hardware */
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965.h	2007-11-30 11:38:20.618538303 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965.h	2007-11-30 11:38:26.248535482 +0100
@@ -1243,7 +1243,7 @@ struct iwl4965_priv {
 	u32 timestamp1;
 	u16 beacon_int;
 	struct iwl4965_driver_hw_info hw_setting;
-	int interface_id;
+	struct if_priv *if_priv;
 
 	/* Current association information needed to configure the
 	 * hardware */
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-11-30 11:37:43.148538195 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-11-30 11:40:42.908537924 +0100
@@ -2732,8 +2732,8 @@ static int iwl3945_tx_skb(struct iwl3945
 		goto drop_unlock;
 	}
 
-	if (!priv->interface_id) {
-		IWL_DEBUG_DROP("Dropping - !priv->interface_id\n");
+	if (!priv->if_priv) {
+		IWL_DEBUG_DROP("Dropping - !priv->if_priv\n");
 		goto drop_unlock;
 	}
 
@@ -3561,7 +3561,7 @@ static void iwl3945_bg_beacon_update(str
 	struct sk_buff *beacon;
 
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
-	beacon = ieee80211_beacon_get(priv->hw, priv->interface_id, NULL);
+	beacon = ieee80211_beacon_get(priv->hw, priv->if_priv, NULL);
 
 	if (!beacon) {
 		IWL_ERROR("update beacon failed\n");
@@ -6728,7 +6728,7 @@ static void iwl3945_bg_post_associate(st
 
 	mutex_lock(&priv->mutex);
 
-	if (!priv->interface_id || !priv->is_open) {
+	if (!priv->if_priv || !priv->is_open) {
 		mutex_unlock(&priv->mutex);
 		return;
 	}
@@ -6921,13 +6921,13 @@ static int iwl3945_mac_add_interface(str
 		IWL_DEBUG_MAC80211("enter: MAC %s\n",
 				   print_mac(mac, conf->mac_addr));
 
-	if (priv->interface_id) {
-		IWL_DEBUG_MAC80211("leave - interface_id != 0\n");
+	if (priv->if_priv) {
+		IWL_DEBUG_MAC80211("leave - have interface\n");
 		return 0;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->interface_id = conf->if_id;
+	priv->if_priv = conf->if_priv;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -7088,7 +7088,8 @@ static void iwl3945_config_ap(struct iwl
 	 * clear sta table, add BCAST sta... */
 }
 
-static int iwl3945_mac_config_interface(struct ieee80211_hw *hw, int if_id,
+static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
+					struct if_priv *if_priv,
 				    struct ieee80211_if_conf *conf)
 {
 	struct iwl3945_priv *priv = hw->priv;
@@ -7127,7 +7128,7 @@ static int iwl3945_mac_config_interface(
 		return 0;
 	}
 
-	if (priv->interface_id != if_id) {
+	if (priv->if_priv != if_id) {
 		IWL_DEBUG_MAC80211("leave - interface_id != if_id\n");
 		mutex_unlock(&priv->mutex);
 		return 0;
@@ -7221,8 +7222,8 @@ static void iwl3945_mac_remove_interface
 	priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 	iwl3945_commit_rxon(priv);
 
-	if (priv->interface_id == conf->if_id) {
-		priv->interface_id = 0;
+	if (priv->if_priv == conf->if_priv) {
+		priv->if_priv = NULL;
 		memset(priv->bssid, 0, ETH_ALEN);
 		memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
 		priv->essid_len = 0;
--- everything.orig/drivers/net/wireless/rtl8187.h	2007-11-30 11:41:18.378538303 +0100
+++ everything/drivers/net/wireless/rtl8187.h	2007-11-30 11:41:26.008538195 +0100
@@ -65,8 +65,8 @@ struct rtl8187_priv {
 	/* common between rtl818x drivers */
 	struct rtl818x_csr *map;
 	void (*rf_init)(struct ieee80211_hw *);
+	struct if_priv *if_priv;
 	int mode;
-	int if_id;
 
 	/* rtl8187 specific */
 	struct ieee80211_channel channels[14];
--- everything.orig/drivers/net/wireless/rtl8187_dev.c	2007-11-30 11:41:02.538539117 +0100
+++ everything/drivers/net/wireless/rtl8187_dev.c	2007-11-30 11:41:49.978535157 +0100
@@ -148,7 +148,8 @@ static int rtl8187_tx(struct ieee80211_h
 		flags |= RTL8187_TX_FLAG_MORE_FRAG;
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
 		flags |= RTL8187_TX_FLAG_RTS;
-		rts_dur = ieee80211_rts_duration(dev, priv->if_id, skb->len, control);
+		rts_dur = ieee80211_rts_duration(dev, priv->if_priv,
+						 skb->len, control);
 	}
 	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		flags |= RTL8187_TX_FLAG_CTS;
@@ -563,14 +564,13 @@ static int rtl8187_config(struct ieee802
 	return 0;
 }
 
-static int rtl8187_config_interface(struct ieee80211_hw *dev, int if_id,
+static int rtl8187_config_interface(struct ieee80211_hw *dev,
+				    struct if_priv *if_priv,
 				    struct ieee80211_if_conf *conf)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
 
-	priv->if_id = if_id;
-
 	for (i = 0; i < ETH_ALEN; i++)
 		rtl818x_iowrite8(priv, &priv->map->BSSID[i], conf->bssid[i]);
 


