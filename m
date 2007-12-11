Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:46741 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbXLLRRK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2007 12:17:10 -0500
Subject: [PATCH v2] mac80211: don't use interface indices in drivers
From: Johannes Berg <johannes@sipsolutions.net>
To: Michael Wu <flamingice@sourmilk.net>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Zhu Yi <yi.zhu@intel.com>, Daniel Drake <dsd@gentoo.org>,
	Yanbo Li <dreamfly281@gmail.com>
In-Reply-To: <1196849900.4121.4.camel@johannes.berg> (sfid-20071205_101838_959371_6E84D3F8)
References: <1196782831.10274.12.camel@johannes.berg>
	 <200712050057.19819.flamingice@sourmilk.net>
	 <1196849900.4121.4.camel@johannes.berg>
	 (sfid-20071205_101838_959371_6E84D3F8)
Content-Type: text/plain
Date: Tue, 11 Dec 2007 21:15:04 +0100
Message-Id: <1197404104.6558.3.camel@johannes.berg> (sfid-20071212_171717_712168_8F4F7A5B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch gets rid of the if_id stuff where possible in favour of
a new per-virtual-interface structure "struct ieee80211_vif". This
structure is located at the end of the per-interface structure and
contains a variable length driver-use data area.

This has two advantages:
 * removes the need to look up interfaces by if_id, this is better
   for network namespaces and performance
 * allows drivers to store and retrieve per-interface data without
   having to allocate own lists/hash tables

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/adm8211.c              |    3 -
 drivers/net/wireless/ath5k/base.c           |   15 +++---
 drivers/net/wireless/ath5k/base.h           |    2 
 drivers/net/wireless/ath5k/hw.c             |    2 
 drivers/net/wireless/b43/b43.h              |    5 --
 drivers/net/wireless/b43/main.c             |   13 ++---
 drivers/net/wireless/b43/xmit.c             |    6 +-
 drivers/net/wireless/b43legacy/b43legacy.h  |    5 --
 drivers/net/wireless/b43legacy/main.c       |   13 ++---
 drivers/net/wireless/b43legacy/xmit.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    2 
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    2 
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   28 +++++------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   28 +++++------
 drivers/net/wireless/p54common.c            |    3 -
 drivers/net/wireless/rt2x00/rt2x00.h        |    5 +-
 drivers/net/wireless/rt2x00/rt2x00mac.c     |    5 +-
 drivers/net/wireless/rtl8180.h              |    2 
 drivers/net/wireless/rtl8180_dev.c          |   11 ++--
 drivers/net/wireless/rtl8187.h              |    2 
 drivers/net/wireless/rtl8187_dev.c          |    8 +--
 drivers/net/wireless/zd1211rw/zd_mac.c      |    3 -
 include/net/mac80211.h                      |   70 ++++++++++++++++++----------
 net/mac80211/ieee80211.c                    |   12 ++--
 net/mac80211/ieee80211_i.h                  |    8 +++
 net/mac80211/ieee80211_iface.c              |    2 
 net/mac80211/sta_info.c                     |   10 ++--
 net/mac80211/tx.c                           |   46 ++++++++----------
 net/mac80211/util.c                         |   45 ++++++------------
 29 files changed, 191 insertions(+), 171 deletions(-)

--- everything.orig/include/net/mac80211.h	2007-12-11 20:21:52.141747993 +0100
+++ everything/include/net/mac80211.h	2007-12-11 21:01:38.524519965 +0100
@@ -280,6 +280,7 @@ struct ieee80211_low_level_stats {
  * the hardware to use given values (depending on what is supported). */
 
 struct ieee80211_tx_control {
+	struct ieee80211_vif *vif;
 	int tx_rate; /* Transmit rate, given as the hw specific value for the
 		      * rate (from struct ieee80211_rate) */
 	int rts_cts_rate; /* Transmit rate for RTS/CTS frame, given as the hw
@@ -329,7 +330,6 @@ struct ieee80211_tx_control {
 			     * packet dropping when probing higher rates, if hw
 			     * supports multiple retry rates. -1 = not used */
 	int type;	/* internal */
-	int ifindex;	/* internal */
 };
 
 
@@ -524,13 +524,25 @@ enum ieee80211_if_types {
 };
 
 /**
+ * struct ieee80211_vif - per-interface data
+ *
+ * Data in this structure is continually present for driver
+ * use during the life of a virtual interface.
+ *
+ * @drv_priv: data area for driver use, will always be aligned to
+ *	sizeof(void *).
+ */
+struct ieee80211_vif {
+	/* must be last */
+	u8 drv_priv[0] __attribute__((__aligned__(sizeof(void *))));
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
+ * @vif: pointer to a driver-use per-interface structure. The pointer
+ *	itself is also used for various functions including
+ *	ieee80211_beacon_get() and ieee80211_get_buffered_bc().
  * @type: one of &enum ieee80211_if_types constants. Determines the type of
  *	added/removed interface.
  * @mac_addr: pointer to MAC address of the interface. This pointer is valid
@@ -547,8 +559,8 @@ enum ieee80211_if_types {
  * in pure monitor mode.
  */
 struct ieee80211_if_init_conf {
-	int if_id;
 	enum ieee80211_if_types type;
+	struct ieee80211_vif *vif;
 	void *mac_addr;
 };
 
@@ -754,6 +766,9 @@ enum ieee80211_hw_flags {
  * @rate_control_algorithm: rate control algorithm for this hardware.
  *	If unset (NULL), the default algorithm will be used. Must be
  *	set before calling ieee80211_register_hw().
+ *
+ * @vif_data_size: size (in bytes) of the drv_priv data area
+ *	within &struct ieee80211_vif.
  */
 struct ieee80211_hw {
 	struct ieee80211_conf conf;
@@ -764,6 +779,7 @@ struct ieee80211_hw {
 	u32 flags;
 	unsigned int extra_tx_headroom;
 	int channel_change_time;
+	int vif_data_size;
 	u8 queues;
 	s8 max_rssi;
 	s8 max_signal;
@@ -1055,7 +1071,8 @@ struct ieee80211_ops {
 				 struct ieee80211_if_init_conf *conf);
 	int (*config)(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
 	int (*config_interface)(struct ieee80211_hw *hw,
-				int if_id, struct ieee80211_if_conf *conf);
+				struct ieee80211_vif *vif,
+				struct ieee80211_if_conf *conf);
 	void (*configure_filter)(struct ieee80211_hw *hw,
 				 unsigned int changed_flags,
 				 unsigned int *total_flags,
@@ -1074,7 +1091,7 @@ struct ieee80211_ops {
 	int (*set_frag_threshold)(struct ieee80211_hw *hw, u32 value);
 	int (*set_retry_limit)(struct ieee80211_hw *hw,
 			       u32 short_retry, u32 long_retr);
-	void (*sta_notify)(struct ieee80211_hw *hw, int if_id,
+	void (*sta_notify)(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			enum sta_notify_cmd, const u8 *addr);
 	void (*erp_ie_changed)(struct ieee80211_hw *hw, u8 changes,
 			       int cts_protection, int preamble);
@@ -1257,7 +1274,7 @@ void ieee80211_tx_status_irqsafe(struct 
 /**
  * ieee80211_beacon_get - beacon generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @control: will be filled with information needed to send this beacon.
  *
  * If the beacon frames are generated by the host system (i.e., not in
@@ -1268,13 +1285,13 @@ void ieee80211_tx_status_irqsafe(struct 
  * is responsible of freeing it.
  */
 struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
-				     int if_id,
+				     struct ieee80211_vif *vif,
 				     struct ieee80211_tx_control *control);
 
 /**
  * ieee80211_rts_get - RTS frame generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame: pointer to the frame that is going to be protected by the RTS.
  * @frame_len: the frame length (in octets).
  * @frame_txctl: &struct ieee80211_tx_control of the frame.
@@ -1285,7 +1302,7 @@ struct sk_buff *ieee80211_beacon_get(str
  * the next RTS frame from the 802.11 code. The low-level is responsible
  * for calling this function before and RTS frame is needed.
  */
-void ieee80211_rts_get(struct ieee80211_hw *hw, int if_id,
+void ieee80211_rts_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       const void *frame, size_t frame_len,
 		       const struct ieee80211_tx_control *frame_txctl,
 		       struct ieee80211_rts *rts);
@@ -1293,7 +1310,7 @@ void ieee80211_rts_get(struct ieee80211_
 /**
  * ieee80211_rts_duration - Get the duration field for an RTS frame
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame_len: the length of the frame that is going to be protected by the RTS.
  * @frame_txctl: &struct ieee80211_tx_control of the frame.
  *
@@ -1301,14 +1318,14 @@ void ieee80211_rts_get(struct ieee80211_
  * the duration field, the low-level driver uses this function to receive
  * the duration field value in little-endian byteorder.
  */
-__le16 ieee80211_rts_duration(struct ieee80211_hw *hw, int if_id,
-			      size_t frame_len,
+__le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, size_t frame_len,
 			      const struct ieee80211_tx_control *frame_txctl);
 
 /**
  * ieee80211_ctstoself_get - CTS-to-self frame generation function
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame: pointer to the frame that is going to be protected by the CTS-to-self.
  * @frame_len: the frame length (in octets).
  * @frame_txctl: &struct ieee80211_tx_control of the frame.
@@ -1319,7 +1336,8 @@ __le16 ieee80211_rts_duration(struct iee
  * the next CTS-to-self frame from the 802.11 code. The low-level is responsible
  * for calling this function before and CTS-to-self frame is needed.
  */
-void ieee80211_ctstoself_get(struct ieee80211_hw *hw, int if_id,
+void ieee80211_ctstoself_get(struct ieee80211_hw *hw,
+			     struct ieee80211_vif *vif,
 			     const void *frame, size_t frame_len,
 			     const struct ieee80211_tx_control *frame_txctl,
 			     struct ieee80211_cts *cts);
@@ -1327,7 +1345,7 @@ void ieee80211_ctstoself_get(struct ieee
 /**
  * ieee80211_ctstoself_duration - Get the duration field for a CTS-to-self frame
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame_len: the length of the frame that is going to be protected by the CTS-to-self.
  * @frame_txctl: &struct ieee80211_tx_control of the frame.
  *
@@ -1335,28 +1353,30 @@ void ieee80211_ctstoself_get(struct ieee
  * the duration field, the low-level driver uses this function to receive
  * the duration field value in little-endian byteorder.
  */
-__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw, int if_id,
+__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
+				    struct ieee80211_vif *vif,
 				    size_t frame_len,
 				    const struct ieee80211_tx_control *frame_txctl);
 
 /**
  * ieee80211_generic_frame_duration - Calculate the duration field for a frame
  * @hw: pointer obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @frame_len: the length of the frame.
  * @rate: the rate (in 100kbps) at which the frame is going to be transmitted.
  *
  * Calculate the duration field of some generic frame, given its
  * length and transmission rate (in 100kbps).
  */
-__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw, int if_id,
+__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
 					size_t frame_len,
 					int rate);
 
 /**
  * ieee80211_get_buffered_bc - accessing buffered broadcast and multicast frames
  * @hw: pointer as obtained from ieee80211_alloc_hw().
- * @if_id: interface ID from &struct ieee80211_if_init_conf.
+ * @vif: &struct ieee80211_vif pointer from &struct ieee80211_if_init_conf.
  * @control: will be filled with information needed to send returned frame.
  *
  * Function for accessing buffered broadcast and multicast frames. If
@@ -1375,7 +1395,7 @@ __le16 ieee80211_generic_frame_duration(
  * use common code for all beacons.
  */
 struct sk_buff *
-ieee80211_get_buffered_bc(struct ieee80211_hw *hw, int if_id,
+ieee80211_get_buffered_bc(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			  struct ieee80211_tx_control *control);
 
 /**
@@ -1465,7 +1485,7 @@ void ieee80211_scan_completed(struct iee
  */
 void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
 					 void (*iterator)(void *data, u8 *mac,
-							  int if_id),
+						struct ieee80211_vif *vif),
 					 void *data);
 
 #endif /* MAC80211_H */
--- everything.orig/net/mac80211/ieee80211.c	2007-12-11 20:22:29.941747776 +0100
+++ everything/net/mac80211/ieee80211.c	2007-12-11 21:04:20.494516981 +0100
@@ -259,7 +259,7 @@ static int ieee80211_open(struct net_dev
 		sdata->u.sta.flags &= ~IEEE80211_STA_PREV_BSSID_SET;
 		/* fall through */
 	default:
-		conf.if_id = dev->ifindex;
+		conf.vif = &sdata->vif;
 		conf.type = sdata->type;
 		conf.mac_addr = dev->dev_addr;
 		res = local->ops->add_interface(local_to_hw(local), &conf);
@@ -385,7 +385,7 @@ static int ieee80211_stop(struct net_dev
 		sdata->u.sta.extra_ie_len = 0;
 		/* fall through */
 	default:
-		conf.if_id = dev->ifindex;
+		conf.vif = &sdata->vif;
 		conf.type = sdata->type;
 		conf.mac_addr = dev->dev_addr;
 		/* disable all keys for as long as this netdev is down */
@@ -521,7 +521,7 @@ static int __ieee80211_if_config(struct 
 		conf.beacon_control = control;
 	}
 	return local->ops->config_interface(local_to_hw(local),
-					   dev->ifindex, &conf);
+					    &sdata->vif, &conf);
 }
 
 int ieee80211_if_config(struct net_device *dev)
@@ -533,11 +533,13 @@ int ieee80211_if_config_beacon(struct ne
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_tx_control control;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct sk_buff *skb;
 
 	if (!(local->hw.flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE))
 		return 0;
-	skb = ieee80211_beacon_get(local_to_hw(local), dev->ifindex, &control);
+	skb = ieee80211_beacon_get(local_to_hw(local), &sdata->vif,
+				   &control);
 	if (!skb)
 		return -ENOMEM;
 	return __ieee80211_if_config(dev, skb, &control);
@@ -742,7 +744,7 @@ static void ieee80211_remove_tx_extra(st
 	struct ieee80211_tx_packet_data *pkt_data;
 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
-	pkt_data->ifindex = control->ifindex;
+	pkt_data->ifindex = vif_to_sdata(control->vif)->dev->ifindex;
 	pkt_data->flags = 0;
 	if (control->flags & IEEE80211_TXCTL_REQ_TX_STATUS)
 		pkt_data->flags |= IEEE80211_TXPD_REQ_TX_STATUS;
--- everything.orig/net/mac80211/ieee80211_i.h	2007-12-11 20:21:52.211748046 +0100
+++ everything/net/mac80211/ieee80211_i.h	2007-12-11 21:02:36.564517470 +0100
@@ -390,8 +390,16 @@ struct ieee80211_sub_if_data {
 		struct dentry *default_key;
 	} debugfs;
 #endif
+	/* must be last, dynamically sized area in this! */
+	struct ieee80211_vif vif;
 };
 
+static inline
+struct ieee80211_sub_if_data *vif_to_sdata(struct ieee80211_vif *p)
+{
+	return container_of(p, struct ieee80211_sub_if_data, vif);
+}
+
 #define IEEE80211_DEV_TO_SUB_IF(dev) netdev_priv(dev)
 
 enum {
--- everything.orig/net/mac80211/util.c	2007-12-11 20:21:52.251748807 +0100
+++ everything/net/mac80211/util.c	2007-12-11 21:01:38.444518880 +0100
@@ -301,44 +301,34 @@ int ieee80211_frame_duration(struct ieee
 }
 
 /* Exported duration function for driver use */
-__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw, int if_id,
+__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
 					size_t frame_len, int rate)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct net_device *bdev = dev_get_by_index(&init_net, if_id);
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
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
-			      size_t frame_len,
+__le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
+			      struct ieee80211_vif *vif, size_t frame_len,
 			      const struct ieee80211_tx_control *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	struct net_device *bdev = dev_get_by_index(&init_net, if_id);
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
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
+				    struct ieee80211_vif *vif,
 				    size_t frame_len,
 				    const struct ieee80211_tx_control *frame_txctl)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_rate *rate;
-	struct net_device *bdev = dev_get_by_index(&init_net, if_id);
-	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata = vif_to_sdata(vif);
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
@@ -474,10 +458,11 @@ void ieee80211_wake_queues(struct ieee80
 }
 EXPORT_SYMBOL(ieee80211_wake_queues);
 
-void ieee80211_iterate_active_interfaces(struct ieee80211_hw *hw,
-					 void (*iterator)(void *data, u8 *mac,
-							  int if_id),
-					 void *data)
+void ieee80211_iterate_active_interfaces(
+	struct ieee80211_hw *hw,
+	void (*iterator)(void *data, u8 *mac,
+			 struct ieee80211_vif *vif),
+	void *data)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
@@ -500,7 +485,7 @@ void ieee80211_iterate_active_interfaces
 			continue;
 		if (netif_running(sdata->dev))
 			iterator(data, sdata->dev->dev_addr,
-				 sdata->dev->ifindex);
+				 &sdata->vif);
 	}
 
 	rcu_read_unlock();
--- everything.orig/net/mac80211/tx.c	2007-12-11 20:21:52.321747993 +0100
+++ everything/net/mac80211/tx.c	2007-12-11 21:11:07.374519423 +0100
@@ -997,9 +997,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 	return res;
 }
 
-/* Device in tx->dev has a reference added; use dev_put(tx->dev) when
- * finished with it.
- *
+/*
  * NB: @tx is uninitialised when passed in here
  */
 static int ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
@@ -1020,6 +1018,7 @@ static int ieee80211_tx_prepare(struct i
 		return -ENODEV;
 	/* initialises tx with control */
 	__ieee80211_tx_prepare(tx, skb, dev, control);
+	dev_put(dev);
 	return 0;
 }
 
@@ -1250,7 +1249,7 @@ int ieee80211_master_start_xmit(struct s
 		}
 	}
 
-	control.ifindex = odev->ifindex;
+	control.vif = &osdata->vif;
 	control.type = osdata->type;
 	if (pkt_data->flags & IEEE80211_TXPD_REQ_TX_STATUS)
 		control.flags |= IEEE80211_TXCTL_REQ_TX_STATUS;
@@ -1659,7 +1658,8 @@ static void ieee80211_beacon_add_tim(str
 	read_unlock_bh(&local->sta_lock);
 }
 
-struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw, int if_id,
+struct sk_buff *ieee80211_beacon_get(struct ieee80211_hw *hw,
+				     struct ieee80211_vif *vif,
 				     struct ieee80211_tx_control *control)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -1672,19 +1672,16 @@ struct sk_buff *ieee80211_beacon_get(str
 	u8 *b_head, *b_tail;
 	int bh_len, bt_len;
 
-	bdev = dev_get_by_index(&init_net, if_id);
-	if (bdev) {
-		sdata = IEEE80211_DEV_TO_SUB_IF(bdev);
-		ap = &sdata->u.ap;
-		dev_put(bdev);
-	}
+	sdata = vif_to_sdata(vif);
+	bdev = sdata->dev;
+	ap = &sdata->u.ap;
 
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
@@ -1741,7 +1738,7 @@ struct sk_buff *ieee80211_beacon_get(str
 }
 EXPORT_SYMBOL(ieee80211_beacon_get);
 
-void ieee80211_rts_get(struct ieee80211_hw *hw, int if_id,
+void ieee80211_rts_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 		       const void *frame, size_t frame_len,
 		       const struct ieee80211_tx_control *frame_txctl,
 		       struct ieee80211_rts *rts)
@@ -1751,13 +1748,14 @@ void ieee80211_rts_get(struct ieee80211_
 
 	fctl = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_RTS;
 	rts->frame_control = cpu_to_le16(fctl);
-	rts->duration = ieee80211_rts_duration(hw, if_id, frame_len, frame_txctl);
+	rts->duration = ieee80211_rts_duration(hw, vif, frame_len,
+					       frame_txctl);
 	memcpy(rts->ra, hdr->addr1, sizeof(rts->ra));
 	memcpy(rts->ta, hdr->addr2, sizeof(rts->ta));
 }
 EXPORT_SYMBOL(ieee80211_rts_get);
 
-void ieee80211_ctstoself_get(struct ieee80211_hw *hw, int if_id,
+void ieee80211_ctstoself_get(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			     const void *frame, size_t frame_len,
 			     const struct ieee80211_tx_control *frame_txctl,
 			     struct ieee80211_cts *cts)
@@ -1767,13 +1765,15 @@ void ieee80211_ctstoself_get(struct ieee
 
 	fctl = IEEE80211_FTYPE_CTL | IEEE80211_STYPE_CTS;
 	cts->frame_control = cpu_to_le16(fctl);
-	cts->duration = ieee80211_ctstoself_duration(hw, if_id, frame_len, frame_txctl);
+	cts->duration = ieee80211_ctstoself_duration(hw, vif,
+						     frame_len, frame_txctl);
 	memcpy(cts->ra, hdr->addr1, sizeof(cts->ra));
 }
 EXPORT_SYMBOL(ieee80211_ctstoself_get);
 
 struct sk_buff *
-ieee80211_get_buffered_bc(struct ieee80211_hw *hw, int if_id,
+ieee80211_get_buffered_bc(struct ieee80211_hw *hw,
+			  struct ieee80211_vif *vif,
 			  struct ieee80211_tx_control *control)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -1786,12 +1786,9 @@ ieee80211_get_buffered_bc(struct ieee802
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_if_ap *bss = NULL;
 
-	bdev = dev_get_by_index(&init_net, if_id);
-	if (bdev) {
-		sdata = IEEE80211_DEV_TO_SUB_IF(bdev);
-		bss = &sdata->u.ap;
-		dev_put(bdev);
-	}
+	sdata = vif_to_sdata(vif);
+	bdev = sdata->dev;
+
 	if (!bss || sdata->type != IEEE80211_IF_TYPE_AP || !bss->beacon_head)
 		return NULL;
 
@@ -1827,7 +1824,6 @@ ieee80211_get_buffered_bc(struct ieee802
 		if (res == TXRX_DROP || res == TXRX_QUEUED)
 			break;
 	}
-	dev_put(tx.dev);
 	skb = tx.skb; /* handlers are allowed to change skb */
 
 	if (res == TXRX_DROP) {
--- everything.orig/drivers/net/wireless/b43/b43.h	2007-12-11 20:21:52.451747505 +0100
+++ everything/drivers/net/wireless/b43/b43.h	2007-12-11 21:01:32.094518826 +0100
@@ -614,10 +614,7 @@ struct b43_wl {
 	 * at a time. General information about this interface follows.
 	 */
 
-	/* Opaque ID of the operating interface from the ieee80211
-	 * subsystem. Do not modify.
-	 */
-	int if_id;
+	struct ieee80211_vif *vif;
 	/* The MAC address of the operating interface. */
 	u8 mac_addr[ETH_ALEN];
 	/* Current BSSID */
--- everything.orig/drivers/net/wireless/b43/main.c	2007-12-11 20:21:52.481748046 +0100
+++ everything/drivers/net/wireless/b43/main.c	2007-12-11 21:01:32.044520399 +0100
@@ -1180,7 +1180,7 @@ static void b43_write_probe_resp_plcp(st
 	plcp.data = 0;
 	b43_generate_plcp_hdr(&plcp, size + FCS_LEN, rate);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id, size,
+					       dev->wl->vif, size,
 					       B43_RATE_TO_BASE100KBPS(rate));
 	/* Write PLCP in two parts and timing for packet transfer */
 	tmp = le32_to_cpu(plcp.data);
@@ -1237,7 +1237,7 @@ static u8 *b43_generate_probe_resp(struc
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					 IEEE80211_STYPE_PROBE_RESP);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id, *dest_size,
+					       dev->wl->vif, *dest_size,
 					       B43_RATE_TO_BASE100KBPS(rate));
 	hdr->duration_id = dur;
 
@@ -2958,7 +2958,7 @@ static void b43_op_configure_filter(stru
 }
 
 static int b43_op_config_interface(struct ieee80211_hw *hw,
-				   int if_id,
+				   struct ieee80211_vif *vif,
 				   struct ieee80211_if_conf *conf)
 {
 	struct b43_wl *wl = hw_to_b43_wl(hw);
@@ -2969,7 +2969,7 @@ static int b43_op_config_interface(struc
 		return -ENODEV;
 	mutex_lock(&wl->mutex);
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	B43_WARN_ON(wl->if_id != if_id);
+	B43_WARN_ON(wl->vif != vif);
 	if (conf->bssid)
 		memcpy(wl->bssid, conf->bssid, ETH_ALEN);
 	else
@@ -3472,7 +3472,7 @@ static int b43_op_add_interface(struct i
 
 	dev = wl->current_dev;
 	wl->operating = 1;
-	wl->if_id = conf->if_id;
+	wl->vif = conf->vif;
 	wl->if_type = conf->type;
 	memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
 
@@ -3500,7 +3500,8 @@ static void b43_op_remove_interface(stru
 	mutex_lock(&wl->mutex);
 
 	B43_WARN_ON(!wl->operating);
-	B43_WARN_ON(wl->if_id != conf->if_id);
+	B43_WARN_ON(wl->vif != conf->vif);
+	wl->vif = NULL;
 
 	wl->operating = 0;
 
--- everything.orig/drivers/net/wireless/b43/xmit.c	2007-12-11 20:21:52.531747884 +0100
+++ everything/drivers/net/wireless/b43/xmit.c	2007-12-11 21:01:30.254518826 +0100
@@ -221,7 +221,7 @@ static void generate_txhdr_fw4(struct b4
 	} else {
 		int fbrate_base100kbps = B43_RATE_TO_BASE100KBPS(rate_fb);
 		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
-								 dev->wl->if_id,
+								 txctl->vif,
 								 fragment_len,
 								 fbrate_base100kbps);
 	}
@@ -311,7 +311,7 @@ static void generate_txhdr_fw4(struct b4
 		rts_rate_fb_ofdm = b43_is_ofdm_rate(rts_rate_fb);
 
 		if (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
-			ieee80211_ctstoself_get(dev->wl->hw, dev->wl->if_id,
+			ieee80211_ctstoself_get(dev->wl->hw, txctl->vif,
 						fragment_data, fragment_len,
 						txctl,
 						(struct ieee80211_cts *)(txhdr->
@@ -319,7 +319,7 @@ static void generate_txhdr_fw4(struct b4
 			mac_ctl |= B43_TX4_MAC_SENDCTS;
 			len = sizeof(struct ieee80211_cts);
 		} else {
-			ieee80211_rts_get(dev->wl->hw, dev->wl->if_id,
+			ieee80211_rts_get(dev->wl->hw, txctl->vif,
 					  fragment_data, fragment_len, txctl,
 					  (struct ieee80211_rts *)(txhdr->
 								   rts_frame));
--- everything.orig/drivers/net/wireless/b43legacy/b43legacy.h	2007-12-11 20:21:52.571757866 +0100
+++ everything/drivers/net/wireless/b43legacy/b43legacy.h	2007-12-11 20:22:30.051747667 +0100
@@ -577,10 +577,7 @@ struct b43legacy_wl {
 	 * at a time. General information about this interface follows.
 	 */
 
-	/* Opaque ID of the operating interface from the ieee80211
-	 * subsystem. Do not modify.
-	 */
-	int if_id;
+	struct ieee80211_vif *vif;
 	/* MAC address (can be NULL). */
 	u8 mac_addr[ETH_ALEN];
 	/* Current BSSID (can be NULL). */
--- everything.orig/drivers/net/wireless/b43legacy/main.c	2007-12-11 20:21:52.601770345 +0100
+++ everything/drivers/net/wireless/b43legacy/main.c	2007-12-11 20:22:30.061747776 +0100
@@ -976,7 +976,7 @@ static void b43legacy_write_probe_resp_p
 	plcp.data = 0;
 	b43legacy_generate_plcp_hdr(&plcp, size + FCS_LEN, rate);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id,
+					       dev->wl->vif,
 					       size,
 					       B43legacy_RATE_TO_100KBPS(rate));
 	/* Write PLCP in two parts and timing for packet transfer */
@@ -1042,7 +1042,7 @@ static u8 *b43legacy_generate_probe_resp
 	hdr->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
 					 IEEE80211_STYPE_PROBE_RESP);
 	dur = ieee80211_generic_frame_duration(dev->wl->hw,
-					       dev->wl->if_id,
+					       dev->wl->vif,
 					       *dest_size,
 					       B43legacy_RATE_TO_100KBPS(rate));
 	hdr->duration_id = dur;
@@ -2650,7 +2650,7 @@ static void b43legacy_op_configure_filte
 }
 
 static int b43legacy_op_config_interface(struct ieee80211_hw *hw,
-					 int if_id,
+					 struct ieee80211_vif *vif,
 					 struct ieee80211_if_conf *conf)
 {
 	struct b43legacy_wl *wl = hw_to_b43legacy_wl(hw);
@@ -2661,7 +2661,7 @@ static int b43legacy_op_config_interface
 		return -ENODEV;
 	mutex_lock(&wl->mutex);
 	spin_lock_irqsave(&wl->irq_lock, flags);
-	B43legacy_WARN_ON(wl->if_id != if_id);
+	B43legacy_WARN_ON(wl->vif != vif);
 	if (conf->bssid)
 		memcpy(wl->bssid, conf->bssid, ETH_ALEN);
 	else
@@ -3183,7 +3183,7 @@ static int b43legacy_op_add_interface(st
 
 	dev = wl->current_dev;
 	wl->operating = 1;
-	wl->if_id = conf->if_id;
+	wl->vif = conf->vif;
 	wl->if_type = conf->type;
 	memcpy(wl->mac_addr, conf->mac_addr, ETH_ALEN);
 
@@ -3211,7 +3211,8 @@ static void b43legacy_op_remove_interfac
 	mutex_lock(&wl->mutex);
 
 	B43legacy_WARN_ON(!wl->operating);
-	B43legacy_WARN_ON(wl->if_id != conf->if_id);
+	B43legacy_WARN_ON(wl->vif != conf->vif);
+	wl->vif = NULL;
 
 	wl->operating = 0;
 
--- everything.orig/drivers/net/wireless/b43legacy/xmit.c	2007-12-11 20:21:52.651747667 +0100
+++ everything/drivers/net/wireless/b43legacy/xmit.c	2007-12-11 21:01:30.284519586 +0100
@@ -223,7 +223,7 @@ static void generate_txhdr_fw3(struct b4
 	} else {
 		int fbrate_base100kbps = B43legacy_RATE_TO_100KBPS(rate_fb);
 		txhdr->dur_fb = ieee80211_generic_frame_duration(dev->wl->hw,
-							 dev->wl->if_id,
+							 txctl->vif,
 							 fragment_len,
 							 fbrate_base100kbps);
 	}
@@ -312,7 +312,7 @@ static void generate_txhdr_fw3(struct b4
 
 		if (txctl->flags & IEEE80211_TXCTL_USE_CTS_PROTECT) {
 			ieee80211_ctstoself_get(dev->wl->hw,
-						dev->wl->if_id,
+						txctl->vif,
 						fragment_data,
 						fragment_len, txctl,
 						(struct ieee80211_cts *)
@@ -321,7 +321,7 @@ static void generate_txhdr_fw3(struct b4
 			len = sizeof(struct ieee80211_cts);
 		} else {
 			ieee80211_rts_get(dev->wl->hw,
-					  dev->wl->if_id,
+					  txctl->vif,
 					  fragment_data, fragment_len, txctl,
 					  (struct ieee80211_rts *)
 					  (txhdr->rts_frame));
--- everything.orig/drivers/net/wireless/ath5k/base.c	2007-12-11 20:21:52.681747396 +0100
+++ everything/drivers/net/wireless/ath5k/base.c	2007-12-11 21:01:29.984522407 +0100
@@ -178,7 +178,8 @@ static void ath5k_remove_interface(struc
 		struct ieee80211_if_init_conf *conf);
 static int ath5k_config(struct ieee80211_hw *hw,
 		struct ieee80211_conf *conf);
-static int ath5k_config_interface(struct ieee80211_hw *hw, int if_id,
+static int ath5k_config_interface(struct ieee80211_hw *hw,
+		struct ieee80211_vif *vif,
 		struct ieee80211_if_conf *conf);
 static void ath5k_configure_filter(struct ieee80211_hw *hw,
 		unsigned int changed_flags,
@@ -2518,12 +2519,12 @@ static int ath5k_add_interface(struct ie
 	int ret;
 
 	mutex_lock(&sc->lock);
-	if (sc->iface_id) {
+	if (sc->vif) {
 		ret = 0;
 		goto end;
 	}
 
-	sc->iface_id = conf->if_id;
+	sc->vif = conf->vif;
 
 	switch (conf->type) {
 	case IEEE80211_IF_TYPE_STA:
@@ -2548,10 +2549,10 @@ ath5k_remove_interface(struct ieee80211_
 	struct ath5k_softc *sc = hw->priv;
 
 	mutex_lock(&sc->lock);
-	if (sc->iface_id != conf->if_id)
+	if (sc->vif != conf->vif)
 		goto end;
 
-	sc->iface_id = 0;
+	sc->vif = NULL;
 end:
 	mutex_unlock(&sc->lock);
 }
@@ -2569,7 +2570,7 @@ ath5k_config(struct ieee80211_hw *hw,
 }
 
 static int
-ath5k_config_interface(struct ieee80211_hw *hw, int if_id,
+ath5k_config_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 			struct ieee80211_if_conf *conf)
 {
 	struct ath5k_softc *sc = hw->priv;
@@ -2580,7 +2581,7 @@ ath5k_config_interface(struct ieee80211_
 	 * be set to mac80211's value at ath5k_config(). */
 	sc->bintval = 1000 * 1000 / 1024;
 	mutex_lock(&sc->lock);
-	if (sc->iface_id != if_id) {
+	if (sc->vif != vif) {
 		ret = -EIO;
 		goto unlock;
 	}
--- everything.orig/drivers/net/wireless/ath5k/base.h	2007-12-11 20:21:52.721748373 +0100
+++ everything/drivers/net/wireless/ath5k/base.h	2007-12-11 20:22:30.071748807 +0100
@@ -123,7 +123,7 @@ struct ath5k_softc {
 	unsigned int		curmode;	/* current phy mode */
 	struct ieee80211_channel *curchan;	/* current h/w channel */
 
-	int 			iface_id;	/* add/remove_interface id */
+	struct ieee80211_vif *vif;
 
 	struct {
 		u8	rxflags;	/* radiotap rx flags */
--- everything.orig/drivers/net/wireless/ath5k/hw.c	2007-12-11 20:21:52.771765680 +0100
+++ everything/drivers/net/wireless/ath5k/hw.c	2007-12-11 20:22:30.081748101 +0100
@@ -557,7 +557,7 @@ static inline void ath5k_hw_write_rate_d
 		 * ieee80211_duration() for a brief description of
 		 * what rate we should choose to TX ACKs. */
 		tx_time = ieee80211_generic_frame_duration(sc->hw,
-			sc->iface_id, 10, control_rate->rate_kbps/100);
+			sc->vif, 10, control_rate->rate_kbps/100);
 
 		ath5k_hw_reg_write(ah, tx_time, reg);
 
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-12-11 20:21:52.811748861 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-3945.h	2007-12-11 20:22:30.081748101 +0100
@@ -909,7 +909,7 @@ struct iwl3945_priv {
 	u32 timestamp1;
 	u16 beacon_int;
 	struct iwl3945_driver_hw_info hw_setting;
-	int interface_id;
+	struct ieee80211_vif *vif;
 
 	/* Current association information needed to configure the
 	 * hardware */
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965.h	2007-12-11 20:21:52.851748590 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965.h	2007-12-11 21:01:28.114520237 +0100
@@ -1234,7 +1234,7 @@ struct iwl4965_priv {
 	u32 timestamp1;
 	u16 beacon_int;
 	struct iwl4965_driver_hw_info hw_setting;
-	int interface_id;
+	struct ieee80211_vif *vif;
 
 	/* Current association information needed to configure the
 	 * hardware */
--- everything.orig/drivers/net/wireless/rtl8187.h	2007-12-11 20:21:52.991746908 +0100
+++ everything/drivers/net/wireless/rtl8187.h	2007-12-11 20:22:30.091747396 +0100
@@ -65,8 +65,8 @@ struct rtl8187_priv {
 	/* common between rtl818x drivers */
 	struct rtl818x_csr *map;
 	void (*rf_init)(struct ieee80211_hw *);
+	struct ieee80211_vif *vif;
 	int mode;
-	int if_id;
 
 	/* rtl8187 specific */
 	struct ieee80211_channel channels[14];
--- everything.orig/drivers/net/wireless/rtl8187_dev.c	2007-12-11 20:21:53.011751194 +0100
+++ everything/drivers/net/wireless/rtl8187_dev.c	2007-12-11 21:01:30.344520671 +0100
@@ -150,7 +150,8 @@ static int rtl8187_tx(struct ieee80211_h
 		flags |= RTL8187_TX_FLAG_MORE_FRAG;
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS) {
 		flags |= RTL8187_TX_FLAG_RTS;
-		rts_dur = ieee80211_rts_duration(dev, priv->if_id, skb->len, control);
+		rts_dur = ieee80211_rts_duration(dev, priv->vif,
+						 skb->len, control);
 	}
 	if (control->flags & IEEE80211_TXCTL_USE_CTS_PROTECT)
 		flags |= RTL8187_TX_FLAG_CTS;
@@ -565,14 +566,13 @@ static int rtl8187_config(struct ieee802
 	return 0;
 }
 
-static int rtl8187_config_interface(struct ieee80211_hw *dev, int if_id,
+static int rtl8187_config_interface(struct ieee80211_hw *dev,
+				    struct ieee80211_vif *vif,
 				    struct ieee80211_if_conf *conf)
 {
 	struct rtl8187_priv *priv = dev->priv;
 	int i;
 
-	priv->if_id = if_id;
-
 	for (i = 0; i < ETH_ALEN; i++)
 		rtl818x_iowrite8(priv, &priv->map->BSSID[i], conf->bssid[i]);
 
--- everything.orig/drivers/net/wireless/adm8211.c	2007-12-11 20:21:53.051751085 +0100
+++ everything/drivers/net/wireless/adm8211.c	2007-12-11 20:22:30.091747396 +0100
@@ -1312,7 +1312,8 @@ static int adm8211_config(struct ieee802
 	return 0;
 }
 
-static int adm8211_config_interface(struct ieee80211_hw *dev, int if_id,
+static int adm8211_config_interface(struct ieee80211_hw *dev,
+				    struct ieee80211_vif *vif,
 				    struct ieee80211_if_conf *conf)
 {
 	struct adm8211_priv *priv = dev->priv;
--- everything.orig/drivers/net/wireless/p54common.c	2007-12-11 20:21:53.091749729 +0100
+++ everything/drivers/net/wireless/p54common.c	2007-12-11 21:01:30.224526910 +0100
@@ -853,7 +853,8 @@ static int p54_config(struct ieee80211_h
 	return ret;
 }
 
-static int p54_config_interface(struct ieee80211_hw *dev, int if_id,
+static int p54_config_interface(struct ieee80211_hw *dev,
+				struct ieee80211_vif *vif,
 				struct ieee80211_if_conf *conf)
 {
 	struct p54_common *priv = dev->priv;
--- everything.orig/drivers/net/wireless/rtl8180_dev.c	2007-12-11 20:21:53.131746962 +0100
+++ everything/drivers/net/wireless/rtl8180_dev.c	2007-12-11 21:01:30.304518501 +0100
@@ -235,7 +235,8 @@ static int rtl8180_tx(struct ieee80211_h
 
 	if (control->flags & IEEE80211_TXCTL_USE_RTS_CTS)
 		entry->rts_duration =
-			ieee80211_rts_duration(dev, priv->if_id, skb->len, control);
+			ieee80211_rts_duration(dev, priv->vif, skb->len,
+					       control);
 
 	if (!priv->r8185) {
 		unsigned int remainder;
@@ -624,6 +625,8 @@ static int rtl8180_add_interface(struct 
 		return -EOPNOTSUPP;
 	}
 
+	priv->vif = conf->vif;
+
 	rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
 	rtl818x_iowrite32(priv, (__le32 __iomem *)&priv->map->MAC[0],
 			  cpu_to_le32(*(u32 *)conf->mac_addr));
@@ -639,6 +642,7 @@ static void rtl8180_remove_interface(str
 {
 	struct rtl8180_priv *priv = dev->priv;
 	priv->mode = IEEE80211_IF_TYPE_MNTR;
+	priv->vif = NULL;
 }
 
 static int rtl8180_config(struct ieee80211_hw *dev, struct ieee80211_conf *conf)
@@ -650,14 +654,13 @@ static int rtl8180_config(struct ieee802
 	return 0;
 }
 
-static int rtl8180_config_interface(struct ieee80211_hw *dev, int if_id,
+static int rtl8180_config_interface(struct ieee80211_hw *dev,
+				    struct ieee80211_vif *vif,
 				    struct ieee80211_if_conf *conf)
 {
 	struct rtl8180_priv *priv = dev->priv;
 	int i;
 
-	priv->if_id = if_id;
-
 	for (i = 0; i < ETH_ALEN; i++)
 		rtl818x_iowrite8(priv, &priv->map->BSSID[i], conf->bssid[i]);
 
--- everything.orig/drivers/net/wireless/rtl8180.h	2007-12-11 20:21:53.161746908 +0100
+++ everything/drivers/net/wireless/rtl8180.h	2007-12-11 20:22:30.101746365 +0100
@@ -92,8 +92,8 @@ struct rtl8180_priv {
 	void (*rf_init)(struct ieee80211_hw *);
 	void (*rf_stop)(struct ieee80211_hw *);
 	void (*rf_set_chan)(struct ieee80211_hw *, struct ieee80211_conf *);
+	struct ieee80211_vif *vif;
 	int mode;
-	int if_id;
 
 	/* rtl8180 driver specific */
 	spinlock_t lock;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-12-11 20:21:52.881747233 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl3945-base.c	2007-12-11 20:22:30.111747667 +0100
@@ -2777,8 +2777,8 @@ static int iwl3945_tx_skb(struct iwl3945
 		goto drop_unlock;
 	}
 
-	if (!priv->interface_id) {
-		IWL_DEBUG_DROP("Dropping - !priv->interface_id\n");
+	if (!priv->vif) {
+		IWL_DEBUG_DROP("Dropping - !priv->vif\n");
 		goto drop_unlock;
 	}
 
@@ -3647,7 +3647,7 @@ static void iwl3945_bg_beacon_update(str
 	struct sk_buff *beacon;
 
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
-	beacon = ieee80211_beacon_get(priv->hw, priv->interface_id, NULL);
+	beacon = ieee80211_beacon_get(priv->hw, priv->vif, NULL);
 
 	if (!beacon) {
 		IWL_ERROR("update beacon failed\n");
@@ -6861,7 +6861,7 @@ static void iwl3945_bg_post_associate(st
 
 	mutex_lock(&priv->mutex);
 
-	if (!priv->interface_id || !priv->is_open) {
+	if (!priv->vif || !priv->is_open) {
 		mutex_unlock(&priv->mutex);
 		return;
 	}
@@ -7062,15 +7062,15 @@ static int iwl3945_mac_add_interface(str
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
-	IWL_DEBUG_MAC80211("enter: id %d, type %d\n", conf->if_id, conf->type);
+	IWL_DEBUG_MAC80211("enter: type %d\n", conf->type);
 
-	if (priv->interface_id) {
-		IWL_DEBUG_MAC80211("leave - interface_id != 0\n");
+	if (priv->vif) {
+		IWL_DEBUG_MAC80211("leave - vif != NULL\n");
 		return -EOPNOTSUPP;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->interface_id = conf->if_id;
+	priv->vif = conf->vif;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -7254,7 +7254,8 @@ static void iwl3945_config_ap(struct iwl
 	 * clear sta table, add BCAST sta... */
 }
 
-static int iwl3945_mac_config_interface(struct ieee80211_hw *hw, int if_id,
+static int iwl3945_mac_config_interface(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
 				    struct ieee80211_if_conf *conf)
 {
 	struct iwl3945_priv *priv = hw->priv;
@@ -7276,7 +7277,6 @@ static int iwl3945_mac_config_interface(
 
 	mutex_lock(&priv->mutex);
 
-	IWL_DEBUG_MAC80211("enter: interface id %d\n", if_id);
 	if (conf->bssid)
 		IWL_DEBUG_MAC80211("bssid: %s\n",
 				   print_mac(mac, conf->bssid));
@@ -7293,8 +7293,8 @@ static int iwl3945_mac_config_interface(
 		return 0;
 	}
 
-	if (priv->interface_id != if_id) {
-		IWL_DEBUG_MAC80211("leave - interface_id != if_id\n");
+	if (priv->vif != vif) {
+		IWL_DEBUG_MAC80211("leave - priv->vif != vif\n");
 		mutex_unlock(&priv->mutex);
 		return 0;
 	}
@@ -7392,8 +7392,8 @@ static void iwl3945_mac_remove_interface
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl3945_commit_rxon(priv);
 	}
-	if (priv->interface_id == conf->if_id) {
-		priv->interface_id = 0;
+	if (priv->vif == conf->vif) {
+		priv->vif = NULL;
 		memset(priv->bssid, 0, ETH_ALEN);
 		memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
 		priv->essid_len = 0;
--- everything.orig/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-12-11 20:21:52.931748643 +0100
+++ everything/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-12-11 21:01:28.194520508 +0100
@@ -2898,8 +2898,8 @@ static int iwl4965_tx_skb(struct iwl4965
 		goto drop_unlock;
 	}
 
-	if (!priv->interface_id) {
-		IWL_DEBUG_DROP("Dropping - !priv->interface_id\n");
+	if (!priv->vif) {
+		IWL_DEBUG_DROP("Dropping - !priv->vif\n");
 		goto drop_unlock;
 	}
 
@@ -3981,7 +3981,7 @@ static void iwl4965_bg_beacon_update(str
 	struct sk_buff *beacon;
 
 	/* Pull updated AP beacon from mac80211. will fail if not in AP mode */
-	beacon = ieee80211_beacon_get(priv->hw, priv->interface_id, NULL);
+	beacon = ieee80211_beacon_get(priv->hw, priv->vif, NULL);
 
 	if (!beacon) {
 		IWL_ERROR("update beacon failed\n");
@@ -7294,7 +7294,7 @@ static void iwl4965_bg_post_associate(st
 
 	mutex_lock(&priv->mutex);
 
-	if (!priv->interface_id || !priv->is_open) {
+	if (!priv->vif || !priv->is_open) {
 		mutex_unlock(&priv->mutex);
 		return;
 	}
@@ -7505,15 +7505,15 @@ static int iwl4965_mac_add_interface(str
 	unsigned long flags;
 	DECLARE_MAC_BUF(mac);
 
-	IWL_DEBUG_MAC80211("enter: id %d, type %d\n", conf->if_id, conf->type);
+	IWL_DEBUG_MAC80211("enter: type %d\n", conf->type);
 
-	if (priv->interface_id) {
-		IWL_DEBUG_MAC80211("leave - interface_id != 0\n");
+	if (priv->vif) {
+		IWL_DEBUG_MAC80211("leave - vif != NULL\n");
 		return 0;
 	}
 
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->interface_id = conf->if_id;
+	priv->vif = conf->vif;
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -7713,7 +7713,8 @@ static void iwl4965_config_ap(struct iwl
 	 * clear sta table, add BCAST sta... */
 }
 
-static int iwl4965_mac_config_interface(struct ieee80211_hw *hw, int if_id,
+static int iwl4965_mac_config_interface(struct ieee80211_hw *hw,
+					struct ieee80211_vif *vif,
 				    struct ieee80211_if_conf *conf)
 {
 	struct iwl4965_priv *priv = hw->priv;
@@ -7733,7 +7734,6 @@ static int iwl4965_mac_config_interface(
 
 	mutex_lock(&priv->mutex);
 
-	IWL_DEBUG_MAC80211("enter: interface id %d\n", if_id);
 	if (conf->bssid)
 		IWL_DEBUG_MAC80211("bssid: %s\n",
 				   print_mac(mac, conf->bssid));
@@ -7750,8 +7750,8 @@ static int iwl4965_mac_config_interface(
 		return 0;
 	}
 
-	if (priv->interface_id != if_id) {
-		IWL_DEBUG_MAC80211("leave - interface_id != if_id\n");
+	if (priv->vif != vif) {
+		IWL_DEBUG_MAC80211("leave - priv->vif != vif\n");
 		mutex_unlock(&priv->mutex);
 		return 0;
 	}
@@ -7849,8 +7849,8 @@ static void iwl4965_mac_remove_interface
 		priv->staging_rxon.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 		iwl4965_commit_rxon(priv);
 	}
-	if (priv->interface_id == conf->if_id) {
-		priv->interface_id = 0;
+	if (priv->vif == conf->vif) {
+		priv->vif = NULL;
 		memset(priv->bssid, 0, ETH_ALEN);
 		memset(priv->essid, 0, IW_ESSID_MAX_SIZE);
 		priv->essid_len = 0;
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00.h	2007-12-11 20:21:53.241746528 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2x00.h	2007-12-11 20:22:30.121762262 +0100
@@ -372,7 +372,7 @@ struct interface {
 	 * to us by the 80211 stack, and is used to request
 	 * new beacons.
 	 */
-	int id;
+	struct ieee80211_vif *id;
 
 	/*
 	 * Current working type (IEEE80211_IF_TYPE_*).
@@ -927,7 +927,8 @@ int rt2x00mac_add_interface(struct ieee8
 void rt2x00mac_remove_interface(struct ieee80211_hw *hw,
 				struct ieee80211_if_init_conf *conf);
 int rt2x00mac_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf);
-int rt2x00mac_config_interface(struct ieee80211_hw *hw, int if_id,
+int rt2x00mac_config_interface(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
 			       struct ieee80211_if_conf *conf);
 int rt2x00mac_get_stats(struct ieee80211_hw *hw,
 			struct ieee80211_low_level_stats *stats);
--- everything.orig/drivers/net/wireless/rt2x00/rt2x00mac.c	2007-12-11 20:21:53.271747288 +0100
+++ everything/drivers/net/wireless/rt2x00/rt2x00mac.c	2007-12-11 20:22:30.121762262 +0100
@@ -208,7 +208,7 @@ int rt2x00mac_add_interface(struct ieee8
 	    is_interface_present(intf))
 		return -ENOBUFS;
 
-	intf->id = conf->if_id;
+	intf->id = conf->vif;
 	intf->type = conf->type;
 	if (conf->type == IEEE80211_IF_TYPE_AP)
 		memcpy(&intf->bssid, conf->mac_addr, ETH_ALEN);
@@ -292,7 +292,8 @@ int rt2x00mac_config(struct ieee80211_hw
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_config);
 
-int rt2x00mac_config_interface(struct ieee80211_hw *hw, int if_id,
+int rt2x00mac_config_interface(struct ieee80211_hw *hw,
+			       struct ieee80211_vif *vif,
 			       struct ieee80211_if_conf *conf)
 {
 	struct rt2x00_dev *rt2x00dev = hw->priv;
--- everything.orig/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-11 20:21:53.351747288 +0100
+++ everything/drivers/net/wireless/zd1211rw/zd_mac.c	2007-12-11 20:22:30.121762262 +0100
@@ -718,7 +718,8 @@ static int zd_op_config(struct ieee80211
 	return zd_chip_set_channel(&mac->chip, conf->channel);
 }
 
-static int zd_op_config_interface(struct ieee80211_hw *hw, int if_id,
+static int zd_op_config_interface(struct ieee80211_hw *hw,
+				  struct ieee80211_vif *vif,
 				   struct ieee80211_if_conf *conf)
 {
 	struct zd_mac *mac = zd_hw_mac(hw);
--- everything.orig/net/mac80211/sta_info.c	2007-12-11 20:21:52.361748156 +0100
+++ everything/net/mac80211/sta_info.c	2007-12-11 20:22:30.131747071 +0100
@@ -132,6 +132,7 @@ struct sta_info * sta_info_add(struct ie
 			       struct net_device *dev, u8 *addr, gfp_t gfp)
 {
 	struct sta_info *sta;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	DECLARE_MAC_BUF(mac);
 
 	sta = kzalloc(sizeof(*sta), gfp);
@@ -160,7 +161,7 @@ struct sta_info * sta_info_add(struct ie
 	local->num_sta++;
 	sta_info_hash_add(local, sta);
 	if (local->ops->sta_notify)
-		local->ops->sta_notify(local_to_hw(local), dev->ifindex,
+		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
 					STA_NOTIFY_ADD, addr);
 	write_unlock_bh(&local->sta_lock);
 
@@ -205,6 +206,7 @@ void sta_info_free(struct sta_info *sta)
 {
 	struct sk_buff *skb;
 	struct ieee80211_local *local = sta->local;
+	struct ieee80211_sub_if_data *sdata;
 	DECLARE_MAC_BUF(mac);
 
 	might_sleep();
@@ -229,9 +231,11 @@ void sta_info_free(struct sta_info *sta)
 	ieee80211_key_free(sta->key);
 	sta->key = NULL;
 
-	if (local->ops->sta_notify)
-		local->ops->sta_notify(local_to_hw(local), sta->dev->ifindex,
+	if (local->ops->sta_notify) {
+		sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+		local->ops->sta_notify(local_to_hw(local), &sdata->vif,
 					STA_NOTIFY_REMOVE, sta->addr);
+	}
 
 	rate_control_remove_sta_debugfs(sta);
 	ieee80211_sta_debugfs_remove(sta);
--- everything.orig/net/mac80211/ieee80211_iface.c	2007-12-11 20:21:52.401747776 +0100
+++ everything/net/mac80211/ieee80211_iface.c	2007-12-11 21:01:40.304523166 +0100
@@ -48,7 +48,7 @@ int ieee80211_if_add(struct net_device *
 	int ret;
 
 	ASSERT_RTNL();
-	ndev = alloc_netdev(sizeof(struct ieee80211_sub_if_data),
+	ndev = alloc_netdev(sizeof(*sdata) + local->hw.vif_data_size,
 			    name, ieee80211_if_setup);
 	if (!ndev)
 		return -ENOMEM;


