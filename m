Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59251 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932132AbXB0LI0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Feb 2007 06:08:26 -0500
Subject: [PATCH] mac80211: fix more whitespace damage
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 27 Feb 2007 12:08:01 +0100
Message-Id: <1172574481.3870.248.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This replaces all occurrences of 8 spaces with a tab. Without doubt
we'll find more problems, but this at least lets us edit the files
sanely again.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Just figured while we're at it...

---
 include/net/mac80211.h          |   92 +++++------
 net/mac80211/hostapd_ioctl.h    |   90 +++++------
 net/mac80211/ieee80211.c        |  310 ++++++++++++++++++++--------------------
 net/mac80211/ieee80211_common.h |   28 +--
 net/mac80211/ieee80211_i.h      |   90 +++++------
 net/mac80211/ieee80211_ioctl.c  |  216 +++++++++++++--------------
 net/mac80211/ieee80211_scan.c   |    6 
 net/mac80211/ieee80211_sta.c    |    2 
 net/mac80211/rc80211_simple.c   |   26 +--
 net/mac80211/sta_info.c         |   14 -
 net/mac80211/sta_info.h         |    8 -
 11 files changed, 441 insertions(+), 441 deletions(-)

--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-02-27 11:59:16.045643616 +0100
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-02-27 11:59:50.065643616 +0100
@@ -67,10 +67,10 @@ enum {
 	PRISM2_PARAM_RADIO_ENABLED = 1010,
 	PRISM2_PARAM_ANTENNA_SEL = 1011,
 	PRISM2_PARAM_CALIB_INT = 1012,
-        PRISM2_PARAM_ANTENNA_MODE = 1013,
+	PRISM2_PARAM_ANTENNA_MODE = 1013,
 	PRISM2_PARAM_PRIVACY_INVOKED = 1014,
 	PRISM2_PARAM_BROADCAST_SSID = 1015,
-        PRISM2_PARAM_STAT_TIME = 1016,
+	PRISM2_PARAM_STAT_TIME = 1016,
 	PRISM2_PARAM_STA_ANTENNA_SEL = 1017,
 	PRISM2_PARAM_FORCE_UNICAST_RATE = 1018,
 	PRISM2_PARAM_RATE_CTRL_NUM_UP = 1019,
@@ -118,15 +118,15 @@ enum {
 
 	/* Instant802 additions */
 	PRISM2_HOSTAPD_SET_BEACON = 1001,
-        PRISM2_HOSTAPD_GET_HW_FEATURES = 1002,
-        PRISM2_HOSTAPD_SCAN = 1003,
+	PRISM2_HOSTAPD_GET_HW_FEATURES = 1002,
+	PRISM2_HOSTAPD_SCAN = 1003,
 	PRISM2_HOSTAPD_WPA_TRIGGER = 1004,
 	PRISM2_HOSTAPD_SET_RATE_SETS = 1005,
-        PRISM2_HOSTAPD_ADD_IF = 1006,
-        PRISM2_HOSTAPD_REMOVE_IF = 1007,
-        PRISM2_HOSTAPD_GET_DOT11COUNTERSTABLE = 1008,
-        PRISM2_HOSTAPD_GET_LOAD_STATS = 1009,
-        PRISM2_HOSTAPD_SET_STA_VLAN = 1010,
+	PRISM2_HOSTAPD_ADD_IF = 1006,
+	PRISM2_HOSTAPD_REMOVE_IF = 1007,
+	PRISM2_HOSTAPD_GET_DOT11COUNTERSTABLE = 1008,
+	PRISM2_HOSTAPD_GET_LOAD_STATS = 1009,
+	PRISM2_HOSTAPD_SET_STA_VLAN = 1010,
 	PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM = 1011,
 	PRISM2_HOSTAPD_SET_CHANNEL_FLAG = 1012,
 	PRISM2_HOSTAPD_SET_REGULATORY_DOMAIN = 1013,
@@ -194,8 +194,8 @@ struct prism2_hostapd_param {
 			u32 rx_bytes;
 			u32 tx_bytes;
 			u32 current_tx_rate; /* in 100 kbps */
-                        u32 channel_use;
-                        u32 flags;
+			u32 channel_use;
+			u32 flags;
 			u32 num_ps_buf_frames;
 			u32 tx_retry_failed;
 			u32 tx_retry_count;
@@ -230,15 +230,15 @@ struct prism2_hostapd_param {
 			u16 num_modes;
 			u16 flags;
 			u8 data[0] ALIGNED; /* num_modes * feature data */
-                } hw_features;
-                struct {
-                        u8  now;
-                        s8  our_mode_only;
-                        s16 last_rx;
-                        u16 channel;
-                        s16 interval; /* seconds */
-                        s32 listen;   /* microseconds */
-                } scan;
+		} hw_features;
+		struct {
+			u8  now;
+			s8  our_mode_only;
+			s16 last_rx;
+			u16 channel;
+			s16 interval; /* seconds */
+			s32 listen;   /* microseconds */
+		} scan;
 		struct {
 #define WPA_TRIGGER_FAIL_TX_MIC BIT(0)
 #define WPA_TRIGGER_FAIL_TX_ICV BIT(1)
@@ -254,35 +254,35 @@ struct prism2_hostapd_param {
 			u16 num_supported_rates;
 			u16 num_basic_rates;
 			u8 data[0] ALIGNED; /* num_supported_rates * u16 +
-				             * num_basic_rates * u16 */
-                } set_rate_sets;
-                struct {
+					     * num_basic_rates * u16 */
+		} set_rate_sets;
+		struct {
 			u8 type; /* WDS, VLAN, etc */
 			u8 name[IFNAMSIZ];
-                        u8 data[0] ALIGNED;
-                } if_info;
-                struct dot11_counters {
-                        u32 dot11TransmittedFragmentCount;
-                        u32 dot11MulticastTransmittedFrameCount;
-                        u32 dot11FailedCount;
-                        u32 dot11ReceivedFragmentCount;
-                        u32 dot11MulticastReceivedFrameCount;
-                        u32 dot11FCSErrorCount;
-                        u32 dot11TransmittedFrameCount;
-                        u32 dot11WEPUndecryptableCount;
+			u8 data[0] ALIGNED;
+		} if_info;
+		struct dot11_counters {
+			u32 dot11TransmittedFragmentCount;
+			u32 dot11MulticastTransmittedFrameCount;
+			u32 dot11FailedCount;
+			u32 dot11ReceivedFragmentCount;
+			u32 dot11MulticastReceivedFrameCount;
+			u32 dot11FCSErrorCount;
+			u32 dot11TransmittedFrameCount;
+			u32 dot11WEPUndecryptableCount;
 			u32 dot11ACKFailureCount;
 			u32 dot11RTSFailureCount;
 			u32 dot11RTSSuccessCount;
-                } dot11CountersTable;
+		} dot11CountersTable;
 		struct {
 #define LOAD_STATS_CLEAR BIT(1)
 			u32 flags;
 			u32 channel_use;
-                } get_load_stats;
-                struct {
-                        char vlan_name[IFNAMSIZ];
+		} get_load_stats;
+		struct {
+			char vlan_name[IFNAMSIZ];
 			int vlan_id;
-                } set_sta_vlan;
+		} set_sta_vlan;
 		struct {
 			u8 len;
 			u8 data[0] ALIGNED;
@@ -294,9 +294,9 @@ struct prism2_hostapd_param {
 			u8 power_level; /* regulatory limit in dBm */
 			u8 antenna_max;
 		} set_channel_flag;
-                struct {
-                        u32 rd;
-                } set_regulatory_domain;
+		struct {
+			u32 rd;
+		} set_regulatory_domain;
 		struct {
 			u32 queue;
 			s32 aifs;
@@ -417,15 +417,15 @@ enum {
 };
 
 struct hostapd_if_wds {
-        u8 remote_addr[ETH_ALEN];
+	u8 remote_addr[ETH_ALEN];
 };
 
 struct hostapd_if_vlan {
-        u8 id;
+	u8 id;
 };
 
 struct hostapd_if_bss {
-        u8 bssid[ETH_ALEN];
+	u8 bssid[ETH_ALEN];
 };
 
 struct hostapd_if_sta {
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-02-27 11:59:14.335643616 +0100
+++ wireless-dev/net/mac80211/ieee80211.c	2007-02-27 11:59:49.865643616 +0100
@@ -445,7 +445,7 @@ ieee80211_tx_h_fragment(struct ieee80211
 	size_t hdrlen, per_fragm, num_fragm, payload_len, left;
 	struct sk_buff **frags, *first, *frag;
 	int i;
-        u8 *pos;
+	u8 *pos;
 	int frag_threshold = tx->local->fragmentation_threshold;
 
 	if (!tx->fragmented)
@@ -529,7 +529,7 @@ static int wep_encrypt_skb(struct ieee80
 			    NULL)
 				return -1;
 		}
-        }
+	}
 	return 0;
 }
 
@@ -557,7 +557,7 @@ ieee80211_tx_h_wep_encrypt(struct ieee80
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
 	u16 fc;
 
-        fc = le16_to_cpu(hdr->frame_control);
+	fc = le16_to_cpu(hdr->frame_control);
 
 	if (!tx->key || tx->key->alg != ALG_WEP ||
 	    ((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA &&
@@ -577,10 +577,10 @@ ieee80211_tx_h_wep_encrypt(struct ieee80
 	if (tx->u.tx.extra_frag) {
 		int i;
 		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
-                        if (wep_encrypt_skb(tx, tx->u.tx.extra_frag[i]) < 0) {
+			if (wep_encrypt_skb(tx, tx->u.tx.extra_frag[i]) < 0) {
 				I802_DEBUG_INC(tx->local->
 					       tx_handlers_drop_wep);
-                                return TXRX_DROP;
+				return TXRX_DROP;
 			}
 		}
 	}
@@ -740,7 +740,7 @@ static u16 ieee80211_duration(struct iee
 	 * to closest integer */
 
 	dur = ieee80211_frame_duration(local, 10, rate, erp,
-                                       local->short_preamble);
+				       local->short_preamble);
 
 	if (next_frag_len) {
 		/* Frame is fragmented: duration increases with time needed to
@@ -752,7 +752,7 @@ static u16 ieee80211_duration(struct iee
 						local->short_preamble);
 	}
 
-        return dur;
+	return dur;
 }
 
 
@@ -832,7 +832,7 @@ ieee80211_tx_h_misc(struct ieee80211_txr
 					tx->u.tx.extra_frag[i]->len;
 			}
 		}
-        }
+	}
 	tx->local->scan.txrx_count++;
 
 	return TXRX_CONTINUE;
@@ -967,9 +967,9 @@ ieee80211_tx_h_multicast_ps_buf(struct i
 			dev_kfree_skb(skb_dequeue(&tx->sdata->bss->ps_bc_buf));
 		} else
 			tx->local->total_ps_buffered++;
-                skb_queue_tail(&tx->sdata->bss->ps_bc_buf, tx->skb);
+		skb_queue_tail(&tx->sdata->bss->ps_bc_buf, tx->skb);
 		return TXRX_QUEUED;
-        }
+	}
 
 	return TXRX_CONTINUE;
 }
@@ -1016,7 +1016,7 @@ ieee80211_tx_h_unicast_ps_buf(struct iee
 		}
 		pkt_data = (struct ieee80211_tx_packet_data *)tx->skb->cb;
 		pkt_data->jiffies = jiffies;
-                skb_queue_tail(&sta->ps_tx_buf, tx->skb);
+		skb_queue_tail(&sta->ps_tx_buf, tx->skb);
 		return TXRX_QUEUED;
 	}
 #ifdef CONFIG_MAC80211_VERBOSE_PS_DEBUG
@@ -1062,9 +1062,9 @@ __ieee80211_tx_prepare(struct ieee80211_
 	tx->sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	tx->sta = sta_info_get(local, hdr->addr1);
 	tx->fc = le16_to_cpu(hdr->frame_control);
-        control->power_level = local->hw.conf.power_level;
+	control->power_level = local->hw.conf.power_level;
 	tx->u.tx.control = control;
-        tx->u.tx.unicast = !is_multicast_ether_addr(hdr->addr1);
+	tx->u.tx.unicast = !is_multicast_ether_addr(hdr->addr1);
 	if (is_multicast_ether_addr(hdr->addr1))
 		control->flags |= IEEE80211_TXCTL_NO_ACK;
 	else
@@ -1197,7 +1197,7 @@ static int ieee80211_tx(struct net_devic
 	ieee80211_tx_handler *handler;
 	struct ieee80211_txrx_data tx;
 	ieee80211_txrx_result res = TXRX_DROP;
-        int ret, i;
+	int ret, i;
 
 	WARN_ON(__ieee80211_queue_pending(local, control->queue));
 
@@ -1292,7 +1292,7 @@ retry:
 	for (i = 0; i < tx.u.tx.num_extra_frag; i++)
 		if (tx.u.tx.extra_frag[i])
 			dev_kfree_skb(tx.u.tx.extra_frag[i]);
-        kfree(tx.u.tx.extra_frag);
+	kfree(tx.u.tx.extra_frag);
 	return 0;
 }
 
@@ -1406,7 +1406,7 @@ static int ieee80211_master_start_xmit(s
 			   control.type == IEEE80211_IF_TYPE_MGMT);
 	dev_put(odev);
 
-        return ret;
+	return ret;
 }
 
 
@@ -1430,16 +1430,16 @@ static int ieee80211_subif_start_xmit(st
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_tx_packet_data *pkt_data;
-        struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata;
 	int ret = 1, head_need;
 	u16 ethertype, hdrlen, fc;
 	struct ieee80211_hdr hdr;
 	const u8 *encaps_data;
-        int encaps_len, skip_header_bytes;
+	int encaps_len, skip_header_bytes;
 	int nh_pos, h_pos, no_encrypt = 0;
 	struct sta_info *sta;
 
-        sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (unlikely(skb->len < ETH_HLEN)) {
 		printk(KERN_DEBUG "%s: short skb (len=%d)\n",
 		       dev->name, skb->len);
@@ -1463,16 +1463,16 @@ static int ieee80211_subif_start_xmit(st
 		memcpy(hdr.addr1, skb->data, ETH_ALEN);
 		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
 		memcpy(hdr.addr3, skb->data + ETH_ALEN, ETH_ALEN);
-                hdrlen = 24;
-        } else if (sdata->type == IEEE80211_IF_TYPE_WDS) {
+		hdrlen = 24;
+	} else if (sdata->type == IEEE80211_IF_TYPE_WDS) {
 		fc |= IEEE80211_FCTL_FROMDS | IEEE80211_FCTL_TODS;
 		/* RA TA DA SA */
-                memcpy(hdr.addr1, sdata->u.wds.remote_addr, ETH_ALEN);
-                memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
-                memcpy(hdr.addr3, skb->data, ETH_ALEN);
-                memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
-                hdrlen = 30;
-        } else if (sdata->type == IEEE80211_IF_TYPE_STA) {
+		memcpy(hdr.addr1, sdata->u.wds.remote_addr, ETH_ALEN);
+		memcpy(hdr.addr2, dev->dev_addr, ETH_ALEN);
+		memcpy(hdr.addr3, skb->data, ETH_ALEN);
+		memcpy(hdr.addr4, skb->data + ETH_ALEN, ETH_ALEN);
+		hdrlen = 30;
+	} else if (sdata->type == IEEE80211_IF_TYPE_STA) {
 		fc |= IEEE80211_FCTL_TODS;
 		/* BSSID SA DA */
 		memcpy(hdr.addr1, sdata->u.sta.bssid, ETH_ALEN);
@@ -1485,10 +1485,10 @@ static int ieee80211_subif_start_xmit(st
 		memcpy(hdr.addr2, skb->data + ETH_ALEN, ETH_ALEN);
 		memcpy(hdr.addr3, sdata->u.sta.bssid, ETH_ALEN);
 		hdrlen = 24;
-        } else {
-                ret = 0;
-                goto fail;
-        }
+	} else {
+		ret = 0;
+		goto fail;
+	}
 
 	/* receiver is QoS enabled, use a QoS type frame */
 	sta = sta_info_get(local, hdr.addr1);
@@ -1595,7 +1595,7 @@ static int ieee80211_subif_start_xmit(st
 
  fail:
 	if (!ret)
-                dev_kfree_skb(skb);
+		dev_kfree_skb(skb);
 
 	return ret;
 }
@@ -1634,7 +1634,7 @@ ieee80211_mgmt_start_xmit(struct sk_buff
 
 	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
-        pkt_data->ifindex = sdata->dev->ifindex;
+	pkt_data->ifindex = sdata->dev->ifindex;
 	pkt_data->mgmt_iface = (sdata->type == IEEE80211_IF_TYPE_MGMT);
 
 	skb->priority = 20; /* use hardcoded priority for mgmt TX queue */
@@ -1653,9 +1653,9 @@ ieee80211_mgmt_start_xmit(struct sk_buff
 	pkt_data->do_not_encrypt = !(fc & IEEE80211_FCTL_PROTECTED);
 
 	sdata->stats.tx_packets++;
-        sdata->stats.tx_bytes += skb->len;
+	sdata->stats.tx_bytes += skb->len;
 
-        dev_queue_xmit(skb);
+	dev_queue_xmit(skb);
 
 	return 0;
 }
@@ -2110,7 +2110,7 @@ static int ieee80211_set_mac_address(str
 static void ieee80211_set_multicast_list(struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-        struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	unsigned short flags;
 
 	if (((dev->flags & IFF_ALLMULTI) != 0) ^ (sdata->allmulti != 0)) {
@@ -2350,7 +2350,7 @@ static int ieee80211_open(struct net_dev
 			return -ENOBUFS;
 	}
 
-        if (local->open_count == 0) {
+	if (local->open_count == 0) {
 		res = 0;
 		if (local->ops->open)
 			res = local->ops->open(local_to_hw(local));
@@ -2375,7 +2375,7 @@ static int ieee80211_open(struct net_dev
 		}
 		ieee80211_init_scan(local);
 	}
-        local->open_count++;
+	local->open_count++;
 
 	if (sdata->type == IEEE80211_IF_TYPE_MNTR)
 		local->monitors++;
@@ -2403,20 +2403,20 @@ static int ieee80211_stop(struct net_dev
 		return 0;
 	}
 
-        netif_stop_queue(dev);
+	netif_stop_queue(dev);
 
 	if (sdata->type == IEEE80211_IF_TYPE_MNTR)
 		local->monitors--;
 
 	local->open_count--;
-        if (local->open_count == 0) {
+	if (local->open_count == 0) {
 		ieee80211_stop_scan(local);
 		dev_close(local->mdev);
 		if (local->apdev)
 			dev_close(local->apdev);
 		if (local->ops->stop)
 			local->ops->stop(local_to_hw(local));
-        }
+	}
 	if (local->ops->remove_interface) {
 		struct ieee80211_if_init_conf conf;
 
@@ -2451,13 +2451,13 @@ ieee80211_rx_h_data(struct ieee80211_txr
 {
 	struct net_device *dev = rx->dev;
 	struct ieee80211_local *local = rx->local;
-        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
 	u16 fc, hdrlen, ethertype;
 	u8 *payload;
 	u8 dst[ETH_ALEN];
 	u8 src[ETH_ALEN];
-        struct sk_buff *skb = rx->skb, *skb2;
-        struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sk_buff *skb = rx->skb, *skb2;
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	fc = rx->fc;
 	if (unlikely((fc & IEEE80211_FCTL_FTYPE) != IEEE80211_FTYPE_DATA))
@@ -2564,11 +2564,11 @@ ieee80211_rx_h_data(struct ieee80211_txr
 		ehdr = (struct ethhdr *) skb_push(skb, sizeof(struct ethhdr));
 		memcpy(ehdr->h_dest, dst, ETH_ALEN);
 		memcpy(ehdr->h_source, src, ETH_ALEN);
-                ehdr->h_proto = len;
+		ehdr->h_proto = len;
 	}
 	skb->dev = dev;
 
-        skb2 = NULL;
+	skb2 = NULL;
 
 	sdata->stats.rx_packets++;
 	sdata->stats.rx_bytes += skb->len;
@@ -2584,15 +2584,15 @@ ieee80211_rx_h_data(struct ieee80211_txr
 				       "multicast frame\n", dev->name);
 		} else {
 			struct sta_info *dsta;
-                        dsta = sta_info_get(local, skb->data);
+			dsta = sta_info_get(local, skb->data);
 			if (dsta && !dsta->dev) {
-                                printk(KERN_DEBUG "Station with null dev "
+				printk(KERN_DEBUG "Station with null dev "
 				       "structure!\n");
-                        } else if (dsta && dsta->dev == dev) {
+			} else if (dsta && dsta->dev == dev) {
 				/* Destination station is associated to this
 				 * AP, so send the frame directly to it and
 				 * do not pass the frame to local net stack.
-                                 */
+				 */
 				skb2 = skb;
 				skb = NULL;
 			}
@@ -2613,7 +2613,7 @@ ieee80211_rx_h_data(struct ieee80211_txr
 		skb2->protocol = __constant_htons(ETH_P_802_3);
 		skb2->mac.raw = skb2->nh.raw = skb2->data;
 		dev_queue_xmit(skb2);
-        }
+	}
 
 	return TXRX_QUEUED;
 }
@@ -2645,8 +2645,8 @@ ieee80211_fill_frame_info(struct ieee802
 			  struct ieee80211_frame_info *fi,
 			  struct ieee80211_rx_status *status)
 {
-        if (status) {
-                struct timespec ts;
+	if (status) {
+		struct timespec ts;
 		struct ieee80211_rate *rate;
 
 		jiffies_to_timespec(jiffies, &ts);
@@ -2654,24 +2654,24 @@ ieee80211_fill_frame_info(struct ieee802
 					   ts.tv_nsec / 1000);
 		fi->mactime = cpu_to_be64(status->mactime);
 		switch (status->phymode) {
-                case MODE_IEEE80211A:
-                        fi->phytype = htonl(ieee80211_phytype_ofdm_dot11_a);
-                        break;
-                case MODE_IEEE80211B:
-                        fi->phytype = htonl(ieee80211_phytype_dsss_dot11_b);
-                        break;
-                case MODE_IEEE80211G:
-                        fi->phytype = htonl(ieee80211_phytype_pbcc_dot11_g);
-                        break;
-                case MODE_ATHEROS_TURBO:
+		case MODE_IEEE80211A:
+			fi->phytype = htonl(ieee80211_phytype_ofdm_dot11_a);
+			break;
+		case MODE_IEEE80211B:
+			fi->phytype = htonl(ieee80211_phytype_dsss_dot11_b);
+			break;
+		case MODE_IEEE80211G:
+			fi->phytype = htonl(ieee80211_phytype_pbcc_dot11_g);
+			break;
+		case MODE_ATHEROS_TURBO:
 			fi->phytype =
 				htonl(ieee80211_phytype_dsss_dot11_turbo);
-                        break;
-                default:
-                        fi->phytype = 0xAAAAAAAA;
 			break;
-                }
-                fi->channel = htonl(status->channel);
+		default:
+			fi->phytype = 0xAAAAAAAA;
+			break;
+		}
+		fi->channel = htonl(status->channel);
 		rate = ieee80211_get_rate(local, status->phymode,
 					  status->rate);
 		if (rate) {
@@ -2688,12 +2688,12 @@ ieee80211_fill_frame_info(struct ieee802
 			fi->preamble = htonl(0);
 		}
 
-                fi->antenna = htonl(status->antenna);
-                fi->priority = 0xffffffff; /* no clue */
-                fi->ssi_type = htonl(ieee80211_ssi_raw);
-                fi->ssi_signal = htonl(status->ssi);
-                fi->ssi_noise = 0x00000000;
-                fi->encoding = 0;
+		fi->antenna = htonl(status->antenna);
+		fi->priority = 0xffffffff; /* no clue */
+		fi->ssi_type = htonl(ieee80211_ssi_raw);
+		fi->ssi_signal = htonl(status->ssi);
+		fi->ssi_noise = 0x00000000;
+		fi->encoding = 0;
 	} else {
 		/* clear everything because we really don't know.
 		 * the msg_type field isn't present on monitor frames
@@ -2702,8 +2702,8 @@ ieee80211_fill_frame_info(struct ieee802
 		 * anyway */
 		memset(fi, 0, sizeof(*fi) - sizeof(fi->msg_type));
 
-                fi->ssi_type = htonl(ieee80211_ssi_none);
-        }
+		fi->ssi_type = htonl(ieee80211_ssi_none);
+	}
 	fi->version = htonl(IEEE80211_FI_VERSION);
 	fi->length = cpu_to_be32(sizeof(*fi) - sizeof(fi->msg_type));
 }
@@ -2727,7 +2727,7 @@ ieee80211_rx_mgmt(struct ieee80211_local
 		I802_DEBUG_INC(local->rx_expand_skb_head);
 		if (pskb_expand_head(skb, hlen, 0, GFP_ATOMIC)) {
 			dev_kfree_skb(skb);
-                        return;
+			return;
 		}
 	}
 
@@ -2765,7 +2765,7 @@ ieee80211_rx_monitor(struct net_device *
 		I802_DEBUG_INC(local->rx_expand_skb_head);
 		if (pskb_expand_head(skb, hlen, 0, GFP_ATOMIC)) {
 			dev_kfree_skb(skb);
-                        return;
+			return;
 		}
 	}
 
@@ -2967,7 +2967,7 @@ ieee80211_rx_h_ps_poll(struct ieee80211_
 
 	/* Free PS Poll skb here instead of returning TXRX_DROP that would
 	 * count as an dropped frame. */
-        dev_kfree_skb(rx->skb);
+	dev_kfree_skb(rx->skb);
 
 	return TXRX_QUEUED;
 }
@@ -2978,7 +2978,7 @@ ieee80211_reassemble_add(struct ieee8021
 			 unsigned int frag, unsigned int seq, int rx_queue,
 			 struct sk_buff **skb)
 {
-        struct ieee80211_fragment_entry *entry;
+	struct ieee80211_fragment_entry *entry;
 	int idx;
 
 	idx = sdata->fragment_next;
@@ -3006,7 +3006,7 @@ ieee80211_reassemble_add(struct ieee8021
 	entry->first_frag_time = jiffies;
 	entry->seq = seq;
 	entry->rx_queue = rx_queue;
-        entry->last_frag = frag;
+	entry->last_frag = frag;
 	entry->ccmp = 0;
 	entry->extra_len = 0;
 
@@ -3020,7 +3020,7 @@ ieee80211_reassemble_find(struct ieee802
 			  int rx_queue, struct ieee80211_hdr *hdr)
 {
 	struct ieee80211_fragment_entry *entry;
-        int i, idx;
+	int i, idx;
 
 	idx = sdata->fragment_next;
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++) {
@@ -3050,7 +3050,7 @@ ieee80211_reassemble_find(struct ieee802
 			continue;
 		}
 		return entry;
-        }
+	}
 
 	return NULL;
 }
@@ -3161,7 +3161,7 @@ ieee80211_rx_h_defragment(struct ieee802
 		rx->sta->rx_packets++;
 	if (is_multicast_ether_addr(hdr->addr1))
 		rx->local->dot11MulticastReceivedFrameCount++;
-        else
+	else
 		ieee80211_led_rx(rx->local);
 	return TXRX_CONTINUE;
 }
@@ -3258,7 +3258,7 @@ ieee80211_rx_h_check(struct ieee80211_tx
 
 	if (rx->sta && rx->sta->key && always_sta_key) {
 		rx->key = rx->sta->key;
-        } else {
+	} else {
 		if (rx->sta && rx->sta->key)
 			rx->key = rx->sta->key;
 		else
@@ -3290,7 +3290,7 @@ ieee80211_rx_h_check(struct ieee80211_tx
 				return TXRX_QUEUED;
 			}
 		}
-        }
+	}
 
 	if (rx->fc & IEEE80211_FCTL_PROTECTED && rx->key && rx->u.rx.ra_match) {
 		rx->key->tx_rx_count++;
@@ -3439,7 +3439,7 @@ ieee80211_rx_h_802_1x_pae(struct ieee802
 		if (!rx->local->apdev)
 			return TXRX_DROP;
 		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-                                  ieee80211_msg_normal);
+				  ieee80211_msg_normal);
 		return TXRX_QUEUED;
 	}
 
@@ -3487,7 +3487,7 @@ ieee80211_rx_h_drop_unencrypted(struct i
 static ieee80211_txrx_result
 ieee80211_rx_h_mgmt(struct ieee80211_txrx_data *rx)
 {
-        struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata;
 
 	if (!rx->u.rx.ra_match)
 		return TXRX_DROP;
@@ -3512,7 +3512,7 @@ static ieee80211_txrx_result
 ieee80211_rx_h_passive_scan(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
-        struct sk_buff *skb = rx->skb;
+	struct sk_buff *skb = rx->skb;
 
 	if (unlikely(local->sta_scanning != 0)) {
 		ieee80211_sta_rx_scan(rx->dev, skb, rx->u.rx.status);
@@ -3521,15 +3521,15 @@ ieee80211_rx_h_passive_scan(struct ieee8
 
 	if ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)
 		local->scan.txrx_count++;
-        if (unlikely(local->scan.in_scan != 0 &&
+	if (unlikely(local->scan.in_scan != 0 &&
 		     rx->u.rx.status->freq == local->scan.freq)) {
-                struct ieee80211_hdr *hdr;
-                u16 fc;
+		struct ieee80211_hdr *hdr;
+		u16 fc;
 
-                local->scan.rx_packets++;
+		local->scan.rx_packets++;
 
-                hdr = (struct ieee80211_hdr *) skb->data;
-                fc = le16_to_cpu(hdr->frame_control);
+		hdr = (struct ieee80211_hdr *) skb->data;
+		fc = le16_to_cpu(hdr->frame_control);
 
 		if ((fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_MGMT &&
 		    (fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_BEACON &&
@@ -3545,13 +3545,13 @@ ieee80211_rx_h_passive_scan(struct ieee8
 				return TXRX_DROP;
 			ieee80211_rx_mgmt(rx->local, rx->skb,
 					  rx->u.rx.status,
-                                          ieee80211_msg_passive_scan);
-                        return TXRX_QUEUED;
-                } else {
+					  ieee80211_msg_passive_scan);
+			return TXRX_QUEUED;
+		} else {
 			I802_DEBUG_INC(local->rx_handlers_drop_passive_scan);
-                        return TXRX_DROP;
-                }
-        }
+			return TXRX_DROP;
+		}
+	}
 
 	if (unlikely(rx->u.rx.in_scan)) {
 		/* scanning finished during invoking of handlers */
@@ -3559,7 +3559,7 @@ ieee80211_rx_h_passive_scan(struct ieee8
 		return TXRX_DROP;
 	}
 
-        return TXRX_CONTINUE;
+	return TXRX_CONTINUE;
 }
 
 
@@ -3696,7 +3696,7 @@ static inline ieee80211_txrx_result __ie
 				struct sta_info *sta)
 {
 	ieee80211_rx_handler *handler;
-        ieee80211_txrx_result res = TXRX_DROP;
+	ieee80211_txrx_result res = TXRX_DROP;
 
 	for (handler = handlers; *handler != NULL; handler++) {
 		res = (*handler)(rx);
@@ -3765,10 +3765,10 @@ void __ieee80211_rx(struct ieee80211_hw 
 		rx.sdata = IEEE80211_DEV_TO_SUB_IF(rx.dev);
 	}
 
-        if ((status->flag & RX_FLAG_MMIC_ERROR)) {
+	if ((status->flag & RX_FLAG_MMIC_ERROR)) {
 		ieee80211_rx_michael_mic_report(local->mdev, hdr, sta, &rx);
 		goto end;
-        }
+	}
 
 	if (unlikely(local->sta_scanning || local->scan.in_scan))
 		rx.u.rx.in_scan = 1;
@@ -3892,7 +3892,7 @@ EXPORT_SYMBOL(__ieee80211_rx);
 static ieee80211_txrx_result
 ieee80211_tx_h_load_stats(struct ieee80211_txrx_data *tx)
 {
-        struct ieee80211_local *local = tx->local;
+	struct ieee80211_local *local = tx->local;
 	struct sk_buff *skb = tx->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u32 load = 0, hdrtime;
@@ -3908,7 +3908,7 @@ ieee80211_tx_h_load_stats(struct ieee802
 
 	if (local->hw.conf.phymode == MODE_IEEE80211A ||
 	    local->hw.conf.phymode == MODE_ATHEROS_TURBO ||
-            local->hw.conf.phymode == MODE_ATHEROS_TURBOG ||
+	    local->hw.conf.phymode == MODE_ATHEROS_TURBOG ||
 	    (local->hw.conf.phymode == MODE_IEEE80211G &&
 	     tx->u.tx.rate->flags & IEEE80211_RATE_ERP))
 		hdrtime = CHAN_UTIL_HDR_SHORT;
@@ -3936,11 +3936,11 @@ ieee80211_tx_h_load_stats(struct ieee802
 	}
 
 	/* Divide channel_use by 8 to avoid wrapping around the counter */
-        load >>= CHAN_UTIL_SHIFT;
-        local->channel_use_raw += load;
+	load >>= CHAN_UTIL_SHIFT;
+	local->channel_use_raw += load;
 	if (tx->sta)
 		tx->sta->channel_use_raw += load;
-        tx->sdata->channel_use_raw += load;
+	tx->sdata->channel_use_raw += load;
 
 	return TXRX_CONTINUE;
 }
@@ -3949,7 +3949,7 @@ ieee80211_tx_h_load_stats(struct ieee802
 static ieee80211_txrx_result
 ieee80211_rx_h_load_stats(struct ieee80211_txrx_data *rx)
 {
-        struct ieee80211_local *local = rx->local;
+	struct ieee80211_local *local = rx->local;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u32 load = 0, hdrtime;
@@ -3974,7 +3974,7 @@ ieee80211_rx_h_load_stats(struct ieee802
 
 	if (local->hw.conf.phymode == MODE_IEEE80211A ||
 	    local->hw.conf.phymode == MODE_ATHEROS_TURBO ||
-            local->hw.conf.phymode == MODE_ATHEROS_TURBOG ||
+	    local->hw.conf.phymode == MODE_ATHEROS_TURBOG ||
 	    (local->hw.conf.phymode == MODE_IEEE80211G &&
 	     rate->flags & IEEE80211_RATE_ERP))
 		hdrtime = CHAN_UTIL_HDR_SHORT;
@@ -3988,8 +3988,8 @@ ieee80211_rx_h_load_stats(struct ieee802
 	load += skb->len * rate->rate_inv;
 
 	/* Divide channel_use by 8 to avoid wrapping around the counter */
-        load >>= CHAN_UTIL_SHIFT;
-        local->channel_use_raw += load;
+	load >>= CHAN_UTIL_SHIFT;
+	local->channel_use_raw += load;
 	if (rx->sta)
 		rx->sta->channel_use_raw += load;
 	rx->u.rx.load = load;
@@ -4024,9 +4024,9 @@ static void ieee80211_stat_refresh(unsig
 
 	/* go through all subinterfaces */
 	list_for_each_entry(sdata, &local->sub_if_list, list) {
-                sdata->channel_use = (sdata->channel_use_raw /
+		sdata->channel_use = (sdata->channel_use_raw /
 				      local->stat_time) / CHAN_UTIL_PER_10MS;
-                sdata->channel_use_raw = 0;
+		sdata->channel_use_raw = 0;
 	}
 
 	/* hardware interface */
@@ -4094,20 +4094,20 @@ void ieee80211_tx_status_irqsafe(struct 
 		tmp--;
 		I802_DEBUG_INC(local->tx_status_drop);
 	}
-        tasklet_schedule(&local->tasklet);
+	tasklet_schedule(&local->tasklet);
 }
 EXPORT_SYMBOL(ieee80211_tx_status_irqsafe);
 
 static void ieee80211_tasklet_handler(unsigned long data)
 {
-        struct ieee80211_local *local = (struct ieee80211_local *) data;
-        struct sk_buff *skb;
+	struct ieee80211_local *local = (struct ieee80211_local *) data;
+	struct sk_buff *skb;
 	struct ieee80211_rx_status rx_status;
 	struct ieee80211_tx_status *tx_status;
 
 	while ((skb = skb_dequeue(&local->skb_queue)) ||
 	       (skb = skb_dequeue(&local->skb_queue_unreliable))) {
-                switch (skb->pkt_type) {
+		switch (skb->pkt_type) {
 		case ieee80211_rx_msg:
 			/* status is in skb->cb */
 			memcpy(&rx_status, skb->cb, sizeof(rx_status));
@@ -4129,8 +4129,8 @@ static void ieee80211_tasklet_handler(un
 			       local->mdev->name, skb->pkt_type);
 			dev_kfree_skb(skb);
 			break;
-                }
-        }
+		}
+	}
 }
 
 
@@ -4201,13 +4201,13 @@ void ieee80211_tx_status(struct ieee8021
 			 struct ieee80211_tx_status *status)
 {
 	struct sk_buff *skb2;
-        struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = hw_to_local(hw);
 	u16 frag, type;
 	u32 msg_type;
 
 	if (!status) {
-                printk(KERN_ERR
+		printk(KERN_ERR
 		       "%s: ieee80211_tx_status called with NULL status\n",
 		       local->mdev->name);
 		dev_kfree_skb(skb);
@@ -4284,7 +4284,7 @@ void ieee80211_tx_status(struct ieee8021
 
 	ieee80211_led_tx(local, 0);
 
-        /* SNMP counters
+	/* SNMP counters
 	 * Fragments are passed to low-level drivers as separate skbs, so these
 	 * are actually fragments, not frames. Update frame counters only for
 	 * the first fragment of the frame. */
@@ -4292,7 +4292,7 @@ void ieee80211_tx_status(struct ieee8021
 	frag = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG;
 	type = le16_to_cpu(hdr->frame_control) & IEEE80211_FCTL_FTYPE;
 
-        if (status->flags & IEEE80211_TX_STATUS_ACK) {
+	if (status->flags & IEEE80211_TX_STATUS_ACK) {
 		if (frag == 0) {
 			local->dot11TransmittedFrameCount++;
 			if (is_multicast_ether_addr(hdr->addr1))
@@ -4311,13 +4311,13 @@ void ieee80211_tx_status(struct ieee8021
 		    type == IEEE80211_FTYPE_DATA ||
 		    type == IEEE80211_FTYPE_MGMT)
 			local->dot11TransmittedFragmentCount++;
-        } else {
+	} else {
 		if (frag == 0)
 			local->dot11FailedCount++;
-        }
+	}
 
-        if (!(status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS)
-            || unlikely(!local->apdev)) {
+	if (!(status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS)
+	    || unlikely(!local->apdev)) {
 		dev_kfree_skb(skb);
 		return;
 	}
@@ -4328,15 +4328,15 @@ void ieee80211_tx_status(struct ieee8021
 	/* skb was the original skb used for TX. Clone it and give the clone
 	 * to netif_rx(). Free original skb. */
 	skb2 = skb_copy(skb, GFP_ATOMIC);
-        if (!skb2) {
+	if (!skb2) {
 		dev_kfree_skb(skb);
 		return;
 	}
 	dev_kfree_skb(skb);
 	skb = skb2;
 
-        /* Send frame to hostapd */
-        ieee80211_rx_mgmt(local, skb, NULL, msg_type);
+	/* Send frame to hostapd */
+	ieee80211_rx_mgmt(local, skb, NULL, msg_type);
 }
 EXPORT_SYMBOL(ieee80211_tx_status);
 
@@ -4507,8 +4507,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 					const struct ieee80211_ops *ops)
 {
 	struct net_device *mdev;
-        struct ieee80211_local *local;
-        struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local;
+	struct ieee80211_sub_if_data *sdata;
 	int priv_size;
 	struct wiphy *wiphy;
 
@@ -4519,7 +4519,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	 * In memory it'll be like this:
 	 *
 	 * +-------------------------+
-	 * | struct wiphy            |
+	 * | struct wiphy	    |
 	 * +-------------------------+
 	 * | struct ieee80211_local  |
 	 * +-------------------------+
@@ -4561,8 +4561,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	local->mdev = mdev;
 	local->rx_pre_handlers = ieee80211_rx_pre_handlers;
-        local->rx_handlers = ieee80211_rx_handlers;
-        local->tx_handlers = ieee80211_tx_handlers;
+	local->rx_handlers = ieee80211_rx_handlers;
+	local->tx_handlers = ieee80211_tx_handlers;
 
 	local->bridge_packets = 1;
 
@@ -4574,10 +4574,10 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->rate_ctrl_num_up = RATE_CONTROL_NUM_UP;
 	local->rate_ctrl_num_down = RATE_CONTROL_NUM_DOWN;
 
-        local->scan.in_scan = 0;
+	local->scan.in_scan = 0;
 	local->enabled_modes = (unsigned int) -1;
 
-        init_timer(&local->scan.timer); /* clear it out */
+	init_timer(&local->scan.timer); /* clear it out */
 
 	INIT_LIST_HEAD(&local->modes_list);
 
@@ -4590,36 +4590,36 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	local->stat_timer.data = (unsigned long) local;
 	ieee80211_rx_bss_list_init(mdev);
 
-        sta_info_init(local);
+	sta_info_init(local);
 
 	mdev->hard_start_xmit = ieee80211_master_start_xmit;
 	mdev->wireless_handlers = &ieee80211_iw_master_handler_def;
-        mdev->do_ioctl = ieee80211_ioctl;
+	mdev->do_ioctl = ieee80211_ioctl;
 	mdev->change_mtu = ieee80211_change_mtu;
-        mdev->tx_timeout = ieee80211_tx_timeout;
-        mdev->get_stats = ieee80211_get_stats;
+	mdev->tx_timeout = ieee80211_tx_timeout;
+	mdev->get_stats = ieee80211_get_stats;
 	mdev->open = ieee80211_master_open;
 	mdev->stop = ieee80211_master_stop;
 	mdev->type = ARPHRD_IEEE80211;
-        mdev->hard_header_parse = header_parse_80211;
+	mdev->hard_header_parse = header_parse_80211;
 
 	sdata->type = IEEE80211_IF_TYPE_AP;
-        sdata->dev = mdev;
-        sdata->local = local;
+	sdata->dev = mdev;
+	sdata->local = local;
 	sdata->u.ap.force_unicast_rateidx = -1;
 	sdata->u.ap.max_ratectrl_rateidx = -1;
 	ieee80211_if_sdata_init(sdata);
-        list_add_tail(&sdata->list, &local->sub_if_list);
+	list_add_tail(&sdata->list, &local->sub_if_list);
 
 	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
 		     (unsigned long)local);
 	tasklet_disable(&local->tx_pending_tasklet);
 
-        tasklet_init(&local->tasklet,
+	tasklet_init(&local->tasklet,
 		     ieee80211_tasklet_handler,
 		     (unsigned long) local);
-        skb_queue_head_init(&local->skb_queue);
-        skb_queue_head_init(&local->skb_queue_unreliable);
+	skb_queue_head_init(&local->skb_queue);
+	skb_queue_head_init(&local->skb_queue_unreliable);
 
 	return local_to_hw(local);
 }
@@ -4761,8 +4761,8 @@ void ieee80211_unregister_hw(struct ieee
 	struct ieee80211_sub_if_data *sdata, *tmp;
 	int i;
 
-        tasklet_disable(&local->tasklet);
-        /* TODO: skb_queue should be empty here, no need to do anything? */
+	tasklet_disable(&local->tasklet);
+	/* TODO: skb_queue should be empty here, no need to do anything? */
 
 	rtnl_lock();
 	local->reg_state = IEEE80211_DEV_UNREGISTERED;
@@ -4795,7 +4795,7 @@ void ieee80211_unregister_hw(struct ieee
 	for (i = 0; i < NUM_IEEE80211_MODES; i++) {
 		kfree(local->supp_rates[i]);
 		kfree(local->basic_rates[i]);
-        }
+	}
 
 	if (skb_queue_len(&local->skb_queue)
 			|| skb_queue_len(&local->skb_queue_unreliable))
@@ -4855,7 +4855,7 @@ int ieee80211_netif_oper(struct ieee8021
 		break;
 	}
 
-        return 0;
+	return 0;
 }
 EXPORT_SYMBOL(ieee80211_netif_oper);
 
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-02-27 11:59:16.195643616 +0100
+++ wireless-dev/net/mac80211/ieee80211_common.h	2007-02-27 11:59:50.105643616 +0100
@@ -70,23 +70,23 @@ struct ieee80211_msg_key_notification {
 
 
 enum ieee80211_phytype {
-        ieee80211_phytype_fhss_dot11_97  = 1,
-        ieee80211_phytype_dsss_dot11_97  = 2,
-        ieee80211_phytype_irbaseband     = 3,
-        ieee80211_phytype_dsss_dot11_b   = 4,
-        ieee80211_phytype_pbcc_dot11_b   = 5,
-        ieee80211_phytype_ofdm_dot11_g   = 6,
-        ieee80211_phytype_pbcc_dot11_g   = 7,
-        ieee80211_phytype_ofdm_dot11_a   = 8,
-        ieee80211_phytype_dsss_dot11_turbog = 255,
-        ieee80211_phytype_dsss_dot11_turbo = 256,
+	ieee80211_phytype_fhss_dot11_97  = 1,
+	ieee80211_phytype_dsss_dot11_97  = 2,
+	ieee80211_phytype_irbaseband     = 3,
+	ieee80211_phytype_dsss_dot11_b   = 4,
+	ieee80211_phytype_pbcc_dot11_b   = 5,
+	ieee80211_phytype_ofdm_dot11_g   = 6,
+	ieee80211_phytype_pbcc_dot11_g   = 7,
+	ieee80211_phytype_ofdm_dot11_a   = 8,
+	ieee80211_phytype_dsss_dot11_turbog = 255,
+	ieee80211_phytype_dsss_dot11_turbo = 256,
 };
 
 enum ieee80211_ssi_type {
-        ieee80211_ssi_none = 0,
-        ieee80211_ssi_norm = 1, /* normalized, 0-1000 */
-        ieee80211_ssi_dbm = 2,
-        ieee80211_ssi_raw = 3, /* raw SSI */
+	ieee80211_ssi_none = 0,
+	ieee80211_ssi_norm = 1, /* normalized, 0-1000 */
+	ieee80211_ssi_dbm = 2,
+	ieee80211_ssi_raw = 3, /* raw SSI */
 };
 
 struct ieee80211_radar_info {
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-02-27 11:59:16.265643616 +0100
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-02-27 11:59:50.115643616 +0100
@@ -110,8 +110,8 @@ typedef enum {
 struct ieee80211_txrx_data {
 	struct sk_buff *skb;
 	struct net_device *dev;
-        struct ieee80211_local *local;
-        struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local;
+	struct ieee80211_sub_if_data *sdata;
 	struct sta_info *sta;
 	u16 fc, ethertype;
 	struct ieee80211_key *key;
@@ -175,28 +175,28 @@ struct ieee80211_tx_stored_packet {
 };
 
 struct ieee80211_passive_scan {
-        unsigned int in_scan:1; /* this must be cleared before calling
+	unsigned int in_scan:1; /* this must be cleared before calling
 				 * netif_oper(WAKEUP) */
-        unsigned int our_mode_only:1; /* only scan our physical mode a/b/g/etc
+	unsigned int our_mode_only:1; /* only scan our physical mode a/b/g/etc
 				       */
-        int interval; /* time in seconds between scans */
-        int time; /* time in microseconds to scan for */
+	int interval; /* time in seconds between scans */
+	int time; /* time in microseconds to scan for */
 	int channel; /* channel to be scanned */
-        int tries;
+	int tries;
 
 	struct ieee80211_hw_mode *mode;
-        int chan_idx;
+	int chan_idx;
 
 	int freq;
-        int rx_packets;
-        int rx_beacon;
+	int rx_packets;
+	int rx_beacon;
 	int txrx_count;
 
-        struct timer_list timer;
+	struct timer_list timer;
 
-        struct sk_buff *skb; /* skb to transmit before changing channels,
+	struct sk_buff *skb; /* skb to transmit before changing channels,
 			      * maybe null for none */
-        struct ieee80211_tx_control tx_control;
+	struct ieee80211_tx_control tx_control;
 
 	unsigned int num_scans;
 };
@@ -229,12 +229,12 @@ struct ieee80211_if_ap {
 };
 
 struct ieee80211_if_wds {
-        u8 remote_addr[ETH_ALEN];
-        struct sta_info *sta;
+	u8 remote_addr[ETH_ALEN];
+	struct sta_info *sta;
 };
 
 struct ieee80211_if_vlan {
-        u8 id;
+	u8 id;
 };
 
 struct ieee80211_if_sta {
@@ -297,19 +297,19 @@ struct ieee80211_if_sta {
 
 
 struct ieee80211_sub_if_data {
-        struct list_head list;
-        unsigned int type;
+	struct list_head list;
+	unsigned int type;
 
-        struct wireless_dev wdev;
+	struct wireless_dev wdev;
 
-        struct net_device *dev;
-        struct ieee80211_local *local;
+	struct net_device *dev;
+	struct ieee80211_local *local;
 
 	int mc_count;
 	unsigned int allmulti:1;
 	unsigned int promisc:1;
 
-        struct net_device_stats stats;
+	struct net_device_stats stats;
 	int drop_unencrypted;
 	int eapol; /* 0 = process EAPOL frames as normal data frames,
 		    * 1 = send EAPOL frames through wlan#ap to hostapd
@@ -322,20 +322,20 @@ struct ieee80211_sub_if_data {
 	unsigned int fragment_next;
 
 #define NUM_DEFAULT_KEYS 4
-        struct ieee80211_key *keys[NUM_DEFAULT_KEYS];
-        struct ieee80211_key *default_key;
+	struct ieee80211_key *keys[NUM_DEFAULT_KEYS];
+	struct ieee80211_key *default_key;
 	struct kset key_kset;
 
 	struct ieee80211_if_ap *bss; /* BSS that this device belongs to */
 
-        union {
+	union {
 		struct ieee80211_if_ap ap;
-                struct ieee80211_if_wds wds;
-                struct ieee80211_if_vlan vlan;
-                struct ieee80211_if_sta sta;
-        } u;
-        int channel_use;
-        int channel_use_raw;
+		struct ieee80211_if_wds wds;
+		struct ieee80211_if_vlan vlan;
+		struct ieee80211_if_sta sta;
+	} u;
+	int channel_use;
+	int channel_use_raw;
 
 	struct attribute_group *sysfs_group;
 };
@@ -435,10 +435,10 @@ struct ieee80211_local {
 
 	ieee80211_rx_handler *rx_pre_handlers;
 	ieee80211_rx_handler *rx_handlers;
-        ieee80211_tx_handler *tx_handlers;
+	ieee80211_tx_handler *tx_handlers;
 
-        spinlock_t sub_if_lock; /* mutex for STA data structures */
-        struct list_head sub_if_list;
+	spinlock_t sub_if_lock; /* mutex for STA data structures */
+	struct list_head sub_if_list;
 	int sta_scanning;
 	int scan_channel_idx;
 	enum { SCAN_SET_CHANNEL, SCAN_SEND_PROBE } scan_state;
@@ -460,18 +460,18 @@ struct ieee80211_local {
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
 	u32 wpa_trigger;
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
-        /* SNMP counters */
-        /* dot11CountersTable */
-        u32 dot11TransmittedFragmentCount;
-        u32 dot11MulticastTransmittedFrameCount;
-        u32 dot11FailedCount;
+	/* SNMP counters */
+	/* dot11CountersTable */
+	u32 dot11TransmittedFragmentCount;
+	u32 dot11MulticastTransmittedFrameCount;
+	u32 dot11FailedCount;
 	u32 dot11RetryCount;
 	u32 dot11MultipleRetryCount;
 	u32 dot11FrameDuplicateCount;
-        u32 dot11ReceivedFragmentCount;
-        u32 dot11MulticastReceivedFrameCount;
-        u32 dot11TransmittedFrameCount;
-        u32 dot11WEPUndecryptableCount;
+	u32 dot11ReceivedFragmentCount;
+	u32 dot11MulticastReceivedFrameCount;
+	u32 dot11TransmittedFrameCount;
+	u32 dot11WEPUndecryptableCount;
 
 #ifdef CONFIG_MAC80211_LEDS
 	int tx_led_counter, rx_led_counter;
@@ -481,8 +481,8 @@ struct ieee80211_local {
 
 	u32 channel_use;
 	u32 channel_use_raw;
-        u32 stat_time;
-        struct timer_list stat_timer;
+	u32 stat_time;
+	struct timer_list stat_timer;
 
 	struct work_struct sta_proc_add;
 
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-02-27 11:59:14.675643616 +0100
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-02-27 11:59:49.905643616 +0100
@@ -167,7 +167,7 @@ static int ieee80211_ioctl_get_hw_featur
 
 
 static int ieee80211_ioctl_scan(struct net_device *dev,
-                                struct prism2_hostapd_param *param)
+				struct prism2_hostapd_param *param)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
@@ -177,22 +177,22 @@ static int ieee80211_ioctl_scan(struct n
 	if ((param->u.scan.now == 1) && (local->scan.in_scan == 1))
 		return -EBUSY;
 
-        if (param->u.scan.our_mode_only >= 0)
-                local->scan.our_mode_only = param->u.scan.our_mode_only;
-        if (param->u.scan.interval >= 0)
-                local->scan.interval = param->u.scan.interval;
-        if (param->u.scan.listen >= 0)
-                local->scan.time = param->u.scan.listen;
+	if (param->u.scan.our_mode_only >= 0)
+		local->scan.our_mode_only = param->u.scan.our_mode_only;
+	if (param->u.scan.interval >= 0)
+		local->scan.interval = param->u.scan.interval;
+	if (param->u.scan.listen >= 0)
+		local->scan.time = param->u.scan.listen;
 		if (param->u.scan.channel > 0)
 			local->scan.channel = param->u.scan.channel;
-        if (param->u.scan.now == 1) {
-                local->scan.in_scan = 0;
-                mod_timer(&local->scan.timer, jiffies);
-        }
-
-        param->u.scan.our_mode_only = local->scan.our_mode_only;
-        param->u.scan.interval = local->scan.interval;
-        param->u.scan.listen = local->scan.time;
+	if (param->u.scan.now == 1) {
+		local->scan.in_scan = 0;
+		mod_timer(&local->scan.timer, jiffies);
+	}
+
+	param->u.scan.our_mode_only = local->scan.our_mode_only;
+	param->u.scan.interval = local->scan.interval;
+	param->u.scan.listen = local->scan.time;
 	if (local->scan.in_scan == 1)
 		param->u.scan.last_rx = -1;
 	else {
@@ -268,7 +268,7 @@ static int ieee80211_ioctl_add_sta(struc
 	struct sta_info *sta;
 	u32 rates;
 	int i, j;
-        struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata;
 	int add_key_entry = 1;
 
 	/* Prevent a race with changing the rate control algorithm */
@@ -281,7 +281,7 @@ static int ieee80211_ioctl_add_sta(struc
 		sta = sta_info_add(local, dev, param->sta_addr, GFP_KERNEL);
 		if (!sta)
 			return -ENOMEM;
-        }
+	}
 
 	if (sta->dev != dev) {
 		/* Binding STA to a new interface, so remove all references to
@@ -291,13 +291,13 @@ static int ieee80211_ioctl_add_sta(struc
 		spin_unlock_bh(&local->sta_lock);
 	}
 
-        /* TODO
-         * We "steal" the device in case someone owns it
-         * This will hurt WDS links and such when we have a
-         * WDS link and a client associating from the same station
-         */
-        sta->dev = dev;
-        sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	/* TODO
+	 * We "steal" the device in case someone owns it
+	 * This will hurt WDS links and such when we have a
+	 * WDS link and a client associating from the same station
+	 */
+	sta->dev = dev;
+	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 
 	sta->flags |= WLAN_STA_AUTH | WLAN_STA_ASSOC;
 	sta->aid = param->u.add_sta.aid;
@@ -373,31 +373,31 @@ static int ieee80211_ioctl_get_dot11coun
 					struct prism2_hostapd_param *param)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-        struct ieee80211_low_level_stats stats;
+	struct ieee80211_low_level_stats stats;
 
 	memset(&stats, 0, sizeof(stats));
 	if (local->ops->get_stats)
 		local->ops->get_stats(local_to_hw(local), &stats);
-        param->u.dot11CountersTable.dot11TransmittedFragmentCount =
-                local->dot11TransmittedFragmentCount;
-        param->u.dot11CountersTable.dot11MulticastTransmittedFrameCount =
-                local->dot11MulticastTransmittedFrameCount;
-        param->u.dot11CountersTable.dot11ReceivedFragmentCount =
-                local->dot11ReceivedFragmentCount;
-        param->u.dot11CountersTable.dot11MulticastReceivedFrameCount =
-                local->dot11MulticastReceivedFrameCount;
-        param->u.dot11CountersTable.dot11TransmittedFrameCount =
-                local->dot11TransmittedFrameCount;
-        param->u.dot11CountersTable.dot11FCSErrorCount =
-                stats.dot11FCSErrorCount;
-        param->u.dot11CountersTable.dot11ACKFailureCount =
-                stats.dot11ACKFailureCount;
-        param->u.dot11CountersTable.dot11RTSFailureCount =
-                stats.dot11RTSFailureCount;
-        param->u.dot11CountersTable.dot11RTSSuccessCount =
-                stats.dot11RTSSuccessCount;
+	param->u.dot11CountersTable.dot11TransmittedFragmentCount =
+		local->dot11TransmittedFragmentCount;
+	param->u.dot11CountersTable.dot11MulticastTransmittedFrameCount =
+		local->dot11MulticastTransmittedFrameCount;
+	param->u.dot11CountersTable.dot11ReceivedFragmentCount =
+		local->dot11ReceivedFragmentCount;
+	param->u.dot11CountersTable.dot11MulticastReceivedFrameCount =
+		local->dot11MulticastReceivedFrameCount;
+	param->u.dot11CountersTable.dot11TransmittedFrameCount =
+		local->dot11TransmittedFrameCount;
+	param->u.dot11CountersTable.dot11FCSErrorCount =
+		stats.dot11FCSErrorCount;
+	param->u.dot11CountersTable.dot11ACKFailureCount =
+		stats.dot11ACKFailureCount;
+	param->u.dot11CountersTable.dot11RTSFailureCount =
+		stats.dot11RTSFailureCount;
+	param->u.dot11CountersTable.dot11RTSSuccessCount =
+		stats.dot11RTSSuccessCount;
 
-        return 0;
+	return 0;
 }
 
 
@@ -433,7 +433,7 @@ static int ieee80211_ioctl_get_info_sta(
 	param->u.get_info_sta.rx_bytes = sta->rx_bytes;
 	param->u.get_info_sta.tx_bytes = sta->tx_bytes;
 	param->u.get_info_sta.channel_use = sta->channel_use;
-        param->u.get_info_sta.flags = sta->flags;
+	param->u.get_info_sta.flags = sta->flags;
 	if (sta->txrate >= 0 && sta->txrate < local->num_curr_rates)
 		param->u.get_info_sta.current_tx_rate =
 			local->curr_rates[sta->txrate].rate;
@@ -522,10 +522,10 @@ static int ieee80211_set_encryption(stru
 	struct sta_info *sta;
 	struct ieee80211_key *key, *old_key;
 	int try_hwaccel = 1;
-        struct ieee80211_key_conf *keyconf;
-        struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_key_conf *keyconf;
+	struct ieee80211_sub_if_data *sdata;
 
-        sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	if (sta_addr[0] == 0xff && sta_addr[1] == 0xff &&
 	    sta_addr[2] == 0xff && sta_addr[3] == 0xff &&
@@ -743,7 +743,7 @@ static int ieee80211_ioctl_set_encryptio
 		printk(KERN_DEBUG "%s: set_encrypt - invalid param_lem\n",
 		       dev->name);
 		return -EINVAL;
-        }
+	}
 
 	if (strcmp(param->u.crypt.alg, "none") == 0)
 		alg = ALG_NONE;
@@ -790,10 +790,10 @@ static int ieee80211_ioctl_get_encryptio
 	struct sta_info *sta;
 	struct ieee80211_key **key;
 	int max_key_len;
-        struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata;
 	u8 *pos;
 
-        sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
 	param->u.crypt.err = 0;
 
@@ -999,7 +999,7 @@ static int ieee80211_ioctl_add_if(struct
 				  int param_len)
 {
 	u8 *pos = param->u.if_info.data;
-        int left = param_len - ((u8 *) pos - (u8 *) param);
+	int left = param_len - ((u8 *) pos - (u8 *) param);
 	struct net_device *new_dev;
 	int res;
 	struct hostapd_if_wds *wds;
@@ -1010,8 +1010,8 @@ static int ieee80211_ioctl_add_if(struct
 	case HOSTAP_IF_WDS:
 		wds = (struct hostapd_if_wds *) param->u.if_info.data;
 
-                if (left < sizeof(struct hostapd_if_wds))
-                        return -EPROTO;
+		if (left < sizeof(struct hostapd_if_wds))
+			return -EPROTO;
 
 		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
 		if (res)
@@ -1040,8 +1040,8 @@ static int ieee80211_ioctl_add_if(struct
 	case HOSTAP_IF_BSS:
 		bss = (struct hostapd_if_bss *) param->u.if_info.data;
 
-                if (left < sizeof(struct hostapd_if_bss))
-                        return -EPROTO;
+		if (left < sizeof(struct hostapd_if_bss))
+			return -EPROTO;
 
 		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
 		if (res)
@@ -1050,8 +1050,8 @@ static int ieee80211_ioctl_add_if(struct
 		memcpy(new_dev->dev_addr, bss->bssid, ETH_ALEN);
 		return 0;
 	case HOSTAP_IF_STA:
-                if (left < sizeof(struct hostapd_if_sta))
-                        return -EPROTO;
+		if (left < sizeof(struct hostapd_if_sta))
+			return -EPROTO;
 
 		res = ieee80211_if_add(dev, param->u.if_info.name, 0, &new_dev);
 		if (res)
@@ -1095,7 +1095,7 @@ static int ieee80211_ioctl_update_if(str
 				     int param_len)
 {
 	u8 *pos = param->u.if_info.data;
-        int left = param_len - ((u8 *) pos - (u8 *) param);
+	int left = param_len - ((u8 *) pos - (u8 *) param);
 
 	if (param->u.if_info.type == HOSTAP_IF_WDS) {
 		struct hostapd_if_wds *wds =
@@ -1206,30 +1206,30 @@ static int ieee80211_ioctl_get_load_stat
 
 
 static int ieee80211_ioctl_set_sta_vlan(struct net_device *dev,
-                                        struct prism2_hostapd_param *param)
+					struct prism2_hostapd_param *param)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-        struct sta_info *sta;
+	struct sta_info *sta;
 
-        sta = sta_info_get(local, param->sta_addr);
-        if (sta) {
-                struct net_device *new_vlan_dev;
-                new_vlan_dev =
+	sta = sta_info_get(local, param->sta_addr);
+	if (sta) {
+		struct net_device *new_vlan_dev;
+		new_vlan_dev =
 			dev_get_by_name(param->u.set_sta_vlan.vlan_name);
-                if (new_vlan_dev) {
+		if (new_vlan_dev) {
 #if 0
 			printk("%s: Station " MAC_FMT " moved to vlan: %s\n",
 			       dev->name, MAC_ARG(param->sta_addr),
-                               new_vlan_dev->name);
+			       new_vlan_dev->name);
 #endif
 			if (sta->dev != new_vlan_dev) {
 				ieee80211_send_layer2_update(new_vlan_dev,
 							     sta->addr);
 			}
-                        sta->dev = new_vlan_dev;
+			sta->dev = new_vlan_dev;
 			sta->vlan_id = param->u.set_sta_vlan.vlan_id;
-                        dev_put(new_vlan_dev);
-                }
+			dev_put(new_vlan_dev);
+		}
 		sta_info_put(sta);
 	}
 
@@ -1275,7 +1275,7 @@ ieee80211_ioctl_set_generic_info_elem(st
 				      int param_len)
 {
 	u8 *pos = param->u.set_generic_info_elem.data;
-        int left = param_len - ((u8 *) pos - (u8 *) param);
+	int left = param_len - ((u8 *) pos - (u8 *) param);
 	int len = param->u.set_generic_info_elem.len;
 
 	if (left < len)
@@ -1290,8 +1290,8 @@ static int ieee80211_ioctl_set_regulator
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_conf *conf = &local->hw.conf;
-        conf->regulatory_domain = param->u.set_regulatory_domain.rd;
-        return 0;
+	conf->regulatory_domain = param->u.set_regulatory_domain.rd;
+	return 0;
 }
 
 
@@ -1381,8 +1381,8 @@ found:
 		return -ENOENT;
 
 	chan->flag = param->u.set_channel_flag.flag;
-        chan->power_level = param->u.set_channel_flag.power_level;
-        chan->antenna_max = param->u.set_channel_flag.antenna_max;
+	chan->power_level = param->u.set_channel_flag.power_level;
+	chan->antenna_max = param->u.set_channel_flag.antenna_max;
 
 	return 0;
 }
@@ -1468,40 +1468,40 @@ static int ieee80211_ioctl_priv_hostapd(
 	case PRISM2_HOSTAPD_GET_HW_FEATURES:
 		ret = ieee80211_ioctl_get_hw_features(dev, param, p->length);
 		break;
-        case PRISM2_HOSTAPD_SCAN:
+	case PRISM2_HOSTAPD_SCAN:
 		ret = ieee80211_ioctl_scan(dev, param);
 		break;
 #ifdef CONFIG_HOSTAPD_WPA_TESTING
-        case PRISM2_HOSTAPD_WPA_TRIGGER:
+	case PRISM2_HOSTAPD_WPA_TRIGGER:
 		ret = ieee80211_ioctl_wpa_trigger(dev, param);
 		break;
 #endif /* CONFIG_HOSTAPD_WPA_TESTING */
-        case PRISM2_HOSTAPD_SET_RATE_SETS:
+	case PRISM2_HOSTAPD_SET_RATE_SETS:
 		ret = ieee80211_ioctl_set_rate_sets(dev, param, p->length);
 		break;
 	case PRISM2_HOSTAPD_ADD_IF:
-                ret = ieee80211_ioctl_add_if(dev, param, p->length);
-                break;
+		ret = ieee80211_ioctl_add_if(dev, param, p->length);
+		break;
 	case PRISM2_HOSTAPD_REMOVE_IF:
-                ret = ieee80211_ioctl_remove_if(dev, param);
-                break;
+		ret = ieee80211_ioctl_remove_if(dev, param);
+		break;
 	case PRISM2_HOSTAPD_GET_DOT11COUNTERSTABLE:
 		ret = ieee80211_ioctl_get_dot11counterstable(dev, param);
 		break;
-        case PRISM2_HOSTAPD_GET_LOAD_STATS:
+	case PRISM2_HOSTAPD_GET_LOAD_STATS:
 		ret = ieee80211_ioctl_get_load_stats(dev, param);
 		break;
-        case PRISM2_HOSTAPD_SET_STA_VLAN:
-                ret = ieee80211_ioctl_set_sta_vlan(dev, param);
+	case PRISM2_HOSTAPD_SET_STA_VLAN:
+		ret = ieee80211_ioctl_set_sta_vlan(dev, param);
 		break;
-        case PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM:
-                ret = ieee80211_ioctl_set_generic_info_elem(dev, param,
+	case PRISM2_HOSTAPD_SET_GENERIC_INFO_ELEM:
+		ret = ieee80211_ioctl_set_generic_info_elem(dev, param,
 							    p->length);
 		break;
-        case PRISM2_HOSTAPD_SET_CHANNEL_FLAG:
+	case PRISM2_HOSTAPD_SET_CHANNEL_FLAG:
 		ret = ieee80211_ioctl_set_channel_flag(dev, param);
 		break;
-        case PRISM2_HOSTAPD_SET_REGULATORY_DOMAIN:
+	case PRISM2_HOSTAPD_SET_REGULATORY_DOMAIN:
 		ret = ieee80211_ioctl_set_regulatory_domain(dev, param);
 		break;
 	case PRISM2_HOSTAPD_SET_TX_QUEUE_PARAMS:
@@ -1511,11 +1511,11 @@ static int ieee80211_ioctl_priv_hostapd(
 		ret = ieee80211_ioctl_get_tx_stats(dev, param);
 		break;
 	case PRISM2_HOSTAPD_UPDATE_IF:
-                ret = ieee80211_ioctl_update_if(dev, param, p->length);
-                break;
+		ret = ieee80211_ioctl_update_if(dev, param, p->length);
+		break;
 	case PRISM2_HOSTAPD_SCAN_REQ:
-                ret = ieee80211_ioctl_scan_req(dev, param, p->length);
-                break;
+		ret = ieee80211_ioctl_scan_req(dev, param, p->length);
+		break;
 	case PRISM2_STA_GET_STATE:
 		ret = ieee80211_ioctl_sta_get_state(dev, param);
 		break;
@@ -1887,7 +1887,7 @@ static int ieee80211_ioctl_siwessid(stru
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata;
-        size_t len = data->length;
+	size_t len = data->length;
 
 	/* iwconfig uses nul termination in SSID.. */
 	if (len > 0 && ssid[len - 1] == '\0')
@@ -1998,7 +1998,7 @@ static int ieee80211_ioctl_giwap(struct 
 				 struct iw_request_info *info,
 				 struct sockaddr *ap_addr, char *extra)
 {
-        struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata;
 
 	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	if (sdata->type == IEEE80211_IF_TYPE_STA ||
@@ -2504,15 +2504,15 @@ static int ieee80211_ioctl_prism2_param(
 		local->short_preamble = value;
 		break;
 
-        case PRISM2_PARAM_STAT_TIME:
-                if (!local->stat_time && value) {
-                        local->stat_timer.expires = jiffies + HZ * value / 100;
-                        add_timer(&local->stat_timer);
-                } else if (local->stat_time && !value) {
-                        del_timer_sync(&local->stat_timer);
-                }
-                local->stat_time = value;
-                break;
+	case PRISM2_PARAM_STAT_TIME:
+		if (!local->stat_time && value) {
+			local->stat_timer.expires = jiffies + HZ * value / 100;
+			add_timer(&local->stat_timer);
+		} else if (local->stat_time && !value) {
+			del_timer_sync(&local->stat_timer);
+		}
+		local->stat_time = value;
+		break;
 	case PRISM2_PARAM_SHORT_SLOT_TIME:
 		if (value)
 			local->hw.conf.flags |= IEEE80211_CONF_SHORT_SLOT_TIME;
@@ -2522,7 +2522,7 @@ static int ieee80211_ioctl_prism2_param(
 			ret = -EINVAL;
 		break;
 
-        case PRISM2_PARAM_PRIVACY_INVOKED:
+	case PRISM2_PARAM_PRIVACY_INVOKED:
 		if (local->ops->set_privacy_invoked)
 			ret = local->ops->set_privacy_invoked(
 					local_to_hw(local), value);
@@ -2738,9 +2738,9 @@ static int ieee80211_ioctl_get_prism2_pa
 		*param = local->short_preamble;
 		break;
 
-        case PRISM2_PARAM_STAT_TIME:
-                *param = local->stat_time;
-                break;
+	case PRISM2_PARAM_STAT_TIME:
+		*param = local->stat_time;
+		break;
 	case PRISM2_PARAM_SHORT_SLOT_TIME:
 		*param = !!(local->hw.conf.flags & IEEE80211_CONF_SHORT_SLOT_TIME);
 		break;
--- wireless-dev.orig/net/mac80211/ieee80211_scan.c	2007-02-27 11:59:14.985643616 +0100
+++ wireless-dev/net/mac80211/ieee80211_scan.c	2007-02-27 11:59:49.925643616 +0100
@@ -264,10 +264,10 @@ static void ieee80211_scan_handler(unsig
 	memset(&conf, 0, sizeof(struct ieee80211_scan_conf));
 	conf.running_freq = local->hw.conf.freq;
 	conf.running_channel = local->hw.conf.channel;
-        conf.running_phymode = local->hw.conf.phymode;
+	conf.running_phymode = local->hw.conf.phymode;
 	conf.running_channel_val = local->hw.conf.channel_val;
-        conf.running_power_level = local->hw.conf.power_level;
-        conf.running_antenna_max = local->hw.conf.antenna_max;
+	conf.running_power_level = local->hw.conf.power_level;
+	conf.running_antenna_max = local->hw.conf.antenna_max;
 
 	if (local->scan.in_scan == 0)
 		ieee80211_scan_start(local, &conf);
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-02-27 11:59:15.095643616 +0100
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-02-27 11:59:49.945643616 +0100
@@ -2546,7 +2546,7 @@ void ieee80211_sta_scan_work(struct work
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local, scan_work.work);
 	struct net_device *dev = local->scan_dev;
-        struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_hw_mode *mode;
 	struct ieee80211_channel *chan;
 	int skip;
--- wireless-dev.orig/net/mac80211/rc80211_simple.c	2007-02-27 11:59:15.515643616 +0100
+++ wireless-dev/net/mac80211/rc80211_simple.c	2007-02-27 11:59:49.985643616 +0100
@@ -33,11 +33,11 @@ MODULE_ALIAS("rc80211_default");
 static void rate_control_rate_inc(struct ieee80211_local *local,
 				  struct sta_info *sta)
 {
-        struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata;
 	int i = sta->txrate;
 	int maxrate;
 
-        sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
 		/* forced unicast rate - do not change STA rate */
 		return;
@@ -63,10 +63,10 @@ static void rate_control_rate_inc(struct
 static void rate_control_rate_dec(struct ieee80211_local *local,
 				  struct sta_info *sta)
 {
-        struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_sub_if_data *sdata;
 	int i = sta->txrate;
 
-        sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
+	sdata = IEEE80211_DEV_TO_SUB_IF(sta->dev);
 	if (sdata->bss && sdata->bss->force_unicast_rateidx > -1) {
 		/* forced unicast rate - do not change STA rate */
 		return;
@@ -110,13 +110,13 @@ struct global_rate_control {
 };
 
 struct sta_rate_control {
-        unsigned long last_rate_change;
-        u32 tx_num_failures;
-        u32 tx_num_xmit;
-
-        unsigned long avg_rate_update;
-        u32 tx_avg_rate_sum;
-        u32 tx_avg_rate_num;
+	unsigned long last_rate_change;
+	u32 tx_num_failures;
+	u32 tx_num_xmit;
+
+	unsigned long avg_rate_update;
+	u32 tx_avg_rate_sum;
+	u32 tx_avg_rate_num;
 };
 
 
@@ -129,10 +129,10 @@ static void rate_control_simple_tx_statu
 	struct sta_info *sta;
 	struct sta_rate_control *srctrl;
 
-        sta = sta_info_get(local, hdr->addr1);
+	sta = sta_info_get(local, hdr->addr1);
 
 	if (!sta)
-            return;
+	    return;
 
 	srctrl = sta->rate_ctrl_priv;
 	srctrl->tx_num_xmit++;
--- wireless-dev.orig/net/mac80211/sta_info.c	2007-02-27 11:59:15.595643616 +0100
+++ wireless-dev/net/mac80211/sta_info.c	2007-02-27 11:59:49.995643616 +0100
@@ -80,8 +80,8 @@ EXPORT_SYMBOL(sta_info_get);
 int sta_info_min_txrate_get(struct ieee80211_local *local)
 {
 	struct sta_info *sta;
-        int min_txrate = 9999999;
-        int i;
+	int min_txrate = 9999999;
+	int i;
 
 	spin_lock_bh(&local->sta_lock);
 	for (i = 0; i < STA_HASH_SIZE; i++) {
@@ -154,9 +154,9 @@ struct sta_info * sta_info_add(struct ie
 		return NULL;
 	}
 
-        memcpy(sta->addr, addr, ETH_ALEN);
+	memcpy(sta->addr, addr, ETH_ALEN);
 	sta->local = local;
-        sta->dev = dev;
+	sta->dev = dev;
 	skb_queue_head_init(&sta->ps_tx_buf);
 	skb_queue_head_init(&sta->tx_filtered);
 	__sta_info_get(sta);	/* sta used by caller, decremented by
@@ -164,7 +164,7 @@ struct sta_info * sta_info_add(struct ie
 	spin_lock_bh(&local->sta_lock);
 	list_add(&sta->list, &local->sta_list);
 	local->num_sta++;
-        sta_info_hash_add(local, sta);
+	sta_info_hash_add(local, sta);
 	spin_unlock_bh(&local->sta_lock);
 	if (local->ops->sta_table_notification)
 		local->ops->sta_table_notification(local_to_hw(local),
@@ -276,13 +276,13 @@ static inline int sta_info_buffer_expire
 					  struct sta_info *sta,
 					  struct sk_buff *skb)
 {
-        struct ieee80211_tx_packet_data *pkt_data;
+	struct ieee80211_tx_packet_data *pkt_data;
 	int timeout;
 
 	if (!skb)
 		return 0;
 
-        pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
+	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
 
 	/* Timeout: (2 * listen_interval * beacon_int * 1024 / 1000000) sec */
 	timeout = (sta->listen_interval * local->hw.conf.beacon_int * 32 /
--- wireless-dev.orig/net/mac80211/sta_info.h	2007-02-27 11:59:16.715643616 +0100
+++ wireless-dev/net/mac80211/sta_info.h	2007-02-27 11:59:50.175643616 +0100
@@ -57,11 +57,11 @@ struct sta_info {
 
 	unsigned long last_rx;
 	u32 supp_rates; /* bitmap of supported rates in local->curr_rates */
-        int txrate; /* index in local->curr_rates */
+	int txrate; /* index in local->curr_rates */
 	int last_txrate; /* last rate used to send a frame to this STA */
 	int last_nonerp_idx;
 
-        struct net_device *dev; /* which net device is this station associated
+	struct net_device *dev; /* which net device is this station associated
 				 * to */
 
 	struct ieee80211_key *key;
@@ -86,8 +86,8 @@ struct sta_info {
 	int last_noise; /* noise of last received frame from this STA */
 	int last_ack_rssi[3]; /* RSSI of last received ACKs from this STA */
 	unsigned long last_ack;
-        int channel_use;
-        int channel_use_raw;
+	int channel_use;
+	int channel_use_raw;
 
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
--- wireless-dev.orig/include/net/mac80211.h	2007-02-27 12:07:01.205643616 +0100
+++ wireless-dev/include/net/mac80211.h	2007-02-27 12:07:15.925643616 +0100
@@ -62,8 +62,8 @@ struct ieee80211_channel {
 	short freq; /* frequency in MHz */
 	int val; /* hw specific value for the channel */
 	int flag; /* flag for hostapd use (IEEE80211_CHAN_*) */
-        unsigned char power_level;
-        unsigned char antenna_max;
+	unsigned char power_level;
+	unsigned char antenna_max;
 };
 
 #define IEEE80211_RATE_ERP 0x00000001
@@ -114,7 +114,7 @@ struct ieee80211_hw_mode {
 	int num_channels; /* Number of channels (below) */
 	struct ieee80211_channel *channels; /* Array of supported channels */
 	int num_rates; /* Number of rates (below) */
-        struct ieee80211_rate *rates; /* Array of supported rates */
+	struct ieee80211_rate *rates; /* Array of supported rates */
 
 	struct list_head list; /* Internal, don't touch */
 };
@@ -160,7 +160,7 @@ enum {
 struct ieee80211_low_level_stats {
 	unsigned int dot11ACKFailureCount;
 	unsigned int dot11RTSFailureCount;
-        unsigned int dot11FCSErrorCount;
+	unsigned int dot11FCSErrorCount;
 	unsigned int dot11RTSSuccessCount;
 };
 
@@ -221,22 +221,22 @@ struct ieee80211_tx_control {
 };
 
 #define RX_FLAG_MMIC_ERROR       0x1
-#define RX_FLAG_DECRYPTED        0x2
+#define RX_FLAG_DECRYPTED	0x2
 
 /* Receive status. The low-level driver should provide this information
  * (the subset supported by hardware) to the 802.11 code with each received
  * frame. */
 struct ieee80211_rx_status {
 	u64 mactime;
-        int freq; /* receive frequency in Mhz */
-        int channel;
-        int phymode;
-        int ssi;
+	int freq; /* receive frequency in Mhz */
+	int channel;
+	int phymode;
+	int ssi;
 	int signal; /* used as qual in statistics reporting */
 	int noise;
-        int antenna;
-        int rate;
-        int flag;
+	int antenna;
+	int rate;
+	int flag;
 };
 
 /* Transmit status. The low-level driver should provide this information
@@ -272,27 +272,27 @@ struct ieee80211_conf {
 	int channel_val;		/* hw specific value for the channel */
 
 	int phymode;			/* MODE_IEEE80211A, .. */
-        unsigned int regulatory_domain;
+	unsigned int regulatory_domain;
 	int radio_enabled;
 
-        int beacon_int;
+	int beacon_int;
 
 #define IEEE80211_CONF_SHORT_SLOT_TIME	(1<<0) /* use IEEE 802.11g Short Slot
 						* Time */
 #define IEEE80211_CONF_SSID_HIDDEN	(1<<1) /* do not broadcast the ssid */
 	u32 flags;			/* configuration flags defined above */
 
-        u8 power_level;			/* transmit power limit for current
+	u8 power_level;			/* transmit power limit for current
 					 * regulatory domain; in dBm */
-        u8 antenna_max;			/* maximum antenna gain */
+	u8 antenna_max;			/* maximum antenna gain */
 	short tx_power_reduction; /* in 0.1 dBm */
 
 	/* 0 = default/diversity, 1 = Ant0, 2 = Ant1 */
 	u8 antenna_sel_tx;
 	u8 antenna_sel_rx;
 
-        int antenna_def;
-        int antenna_mode;
+	int antenna_def;
+	int antenna_mode;
 
 	/* Following five fields are used for IEEE 802.11H */
 	unsigned int radar_detect;
@@ -414,37 +414,37 @@ struct ieee80211_key_conf {
 	u32 flags; /* key configuration flags defined above */
 
 	s8 keyidx;			/* WEP key index */
-        u8 key[0];
+	u8 key[0];
 };
 
 #define IEEE80211_SCAN_START 1
 #define IEEE80211_SCAN_END   2
 
 struct ieee80211_scan_conf {
-        int scan_channel;     /* IEEE 802.11 channel number to do passive scan
+	int scan_channel;     /* IEEE 802.11 channel number to do passive scan
 			       * on */
-        int scan_freq;        /* new freq in MHz to switch to for passive scan
+	int scan_freq;	/* new freq in MHz to switch to for passive scan
 			       */
 	int scan_channel_val; /* hw specific value for the channel */
-        int scan_phymode;     /* MODE_IEEE80211A, .. */
-        unsigned char scan_power_level;
-        unsigned char scan_antenna_max;
+	int scan_phymode;     /* MODE_IEEE80211A, .. */
+	unsigned char scan_power_level;
+	unsigned char scan_antenna_max;
 
 
-        int running_channel; /* IEEE 802.11 channel number we operate on
+	int running_channel; /* IEEE 802.11 channel number we operate on
 			      * normally */
-        int running_freq;    /* freq in MHz we're operating on normally */
+	int running_freq;    /* freq in MHz we're operating on normally */
 	int running_channel_val; /* hw specific value for the channel */
-        int running_phymode;
-        unsigned char running_power_level;
-        unsigned char running_antenna_max;
+	int running_phymode;
+	unsigned char running_power_level;
+	unsigned char running_antenna_max;
 
-        int scan_time;       /* time a scan will take in us */
-        int tries;
+	int scan_time;       /* time a scan will take in us */
+	int tries;
 
-        struct sk_buff *skb; /* skb to transmit before changing channels, maybe
+	struct sk_buff *skb; /* skb to transmit before changing channels, maybe
 			      * NULL for none */
-        struct ieee80211_tx_control *tx_control;
+	struct ieee80211_tx_control *tx_control;
 
 };
 
@@ -536,9 +536,9 @@ struct ieee80211_hw {
 	/* Set to the size of a needed device specific skb headroom for TX skbs. */
 	unsigned int extra_tx_headroom;
 
-        /* This is the time in us to change channels
-         */
-        int channel_change_time;
+	/* This is the time in us to change channels
+	 */
+	int channel_change_time;
 	/* Maximum values for various statistics.
 	 * Leave at 0 to indicate no support. Use negative numbers for dBm. */
 	s8 max_rssi;
@@ -658,36 +658,36 @@ struct ieee80211_ops {
 	int (*set_port_auth)(struct ieee80211_hw *hw, u8 *addr,
 			     int authorized);
 
-        /* Ask the hardware to do a passive scan on a new channel. The hardware
-         * will do what ever is required to nicely leave the current channel
-         * including transmit any CTS packets, etc. */
+	/* Ask the hardware to do a passive scan on a new channel. The hardware
+	 * will do what ever is required to nicely leave the current channel
+	 * including transmit any CTS packets, etc. */
 	int (*passive_scan)(struct ieee80211_hw *hw, int state,
-                            struct ieee80211_scan_conf *conf);
+			    struct ieee80211_scan_conf *conf);
 
 	/* Ask the hardware to service the scan request, no need to start
 	 * the scan state machine in stack. */
 	int (*hw_scan)(struct ieee80211_hw *hw, u8 *ssid, size_t len);
 
-        /* return low-level statistics */
+	/* return low-level statistics */
 	int (*get_stats)(struct ieee80211_hw *hw,
 			 struct ieee80211_low_level_stats *stats);
 
-        /* Enable/disable test modes; mode = IEEE80211_TEST_* */
+	/* Enable/disable test modes; mode = IEEE80211_TEST_* */
 	int (*test_mode)(struct ieee80211_hw *hw, int mode);
 
 	/* Configuration of test parameters */
 	int (*test_param)(struct ieee80211_hw *hw, int param, int value);
 
-        /* For devices that generate their own beacons and probe response
-         * or association responses this updates the state of privacy_invoked
-         * returns 0 for success or an error number */
+	/* For devices that generate their own beacons and probe response
+	 * or association responses this updates the state of privacy_invoked
+	 * returns 0 for success or an error number */
 	int (*set_privacy_invoked)(struct ieee80211_hw *hw,
 				   int privacy_invoked);
 
 	/* For devices that have internal sequence counters, allow 802.11
 	 * code to access the current value of a counter */
 	int (*get_sequence_counter)(struct ieee80211_hw *hw,
-	                            u8* addr, u8 keyidx, u8 txrx,
+				    u8* addr, u8 keyidx, u8 txrx,
 				    u32* iv32, u16* iv16);
 
 	/* Configuration of RTS threshold (if device needs it) */


