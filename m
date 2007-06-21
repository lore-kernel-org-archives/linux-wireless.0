Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:39568 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752583AbXFVIkq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2007 04:40:46 -0400
Message-Id: <20070621221800.797472000@sipsolutions.net>
References: <20070621221603.778432000@sipsolutions.net>
Date: Fri, 22 Jun 2007 00:16:16 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 13/14] mac80211: reorder interface related functions
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch groups a whole bunch of functions together to make
ieee80211.c more maintainable.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/mac80211/ieee80211.c | 1717 +++++++++++++++++++++++------------------------
 1 file changed, 863 insertions(+), 854 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-06-21 23:48:23.248638003 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-06-22 00:00:58.028638003 +0200
@@ -62,94 +62,191 @@ struct ieee80211_tx_status_rtap_hdr {
 } __attribute__ ((packed));
 
 
-static int rate_list_match(const int *rate_list, int rate)
-{
-	int i;
 
-	if (!rate_list)
-		return 0;
+/* common interface routines */
 
-	for (i = 0; rate_list[i] >= 0; i++)
-		if (rate_list[i] == rate)
-			return 1;
+static struct net_device_stats *ieee80211_get_stats(struct net_device *dev)
+{
+	struct ieee80211_sub_if_data *sdata;
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	return &(sdata->stats);
+}
 
-	return 0;
+static int header_parse_80211(struct sk_buff *skb, unsigned char *haddr)
+{
+	memcpy(haddr, skb_mac_header(skb) + 10, ETH_ALEN); /* addr2 */
+	return ETH_ALEN;
 }
 
+/* master interface */
 
-void ieee80211_prepare_rates(struct ieee80211_local *local,
-			     struct ieee80211_hw_mode *mode)
+static int ieee80211_master_open(struct net_device *dev)
 {
-	int i;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata;
+	int res = -EOPNOTSUPP;
 
-	for (i = 0; i < mode->num_rates; i++) {
-		struct ieee80211_rate *rate = &mode->rates[i];
+	read_lock(&local->sub_if_lock);
+	list_for_each_entry(sdata, &local->sub_if_list, list) {
+		if (sdata->dev != dev && netif_running(sdata->dev)) {
+			res = 0;
+			break;
+		}
+	}
+	read_unlock(&local->sub_if_lock);
+	return res;
+}
 
-		rate->flags &= ~(IEEE80211_RATE_SUPPORTED |
-				 IEEE80211_RATE_BASIC);
+static int ieee80211_master_stop(struct net_device *dev)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata;
 
-		if (local->supp_rates[mode->mode]) {
-			if (!rate_list_match(local->supp_rates[mode->mode],
-					     rate->rate))
-				continue;
-		}
+	read_lock(&local->sub_if_lock);
+	list_for_each_entry(sdata, &local->sub_if_list, list)
+		if (sdata->dev != dev && netif_running(sdata->dev))
+			dev_close(sdata->dev);
+	read_unlock(&local->sub_if_lock);
 
-		rate->flags |= IEEE80211_RATE_SUPPORTED;
+	return 0;
+}
 
-		/* Use configured basic rate set if it is available. If not,
-		 * use defaults that are sane for most cases. */
-		if (local->basic_rates[mode->mode]) {
-			if (rate_list_match(local->basic_rates[mode->mode],
-					    rate->rate))
-				rate->flags |= IEEE80211_RATE_BASIC;
-		} else switch (mode->mode) {
+/* management interface */
+
+static void
+ieee80211_fill_frame_info(struct ieee80211_local *local,
+			  struct ieee80211_frame_info *fi,
+			  struct ieee80211_rx_status *status)
+{
+	if (status) {
+		struct timespec ts;
+		struct ieee80211_rate *rate;
+
+		jiffies_to_timespec(jiffies, &ts);
+		fi->hosttime = cpu_to_be64((u64) ts.tv_sec * 1000000 +
+					   ts.tv_nsec / 1000);
+		fi->mactime = cpu_to_be64(status->mactime);
+		switch (status->phymode) {
 		case MODE_IEEE80211A:
-			if (rate->rate == 60 || rate->rate == 120 ||
-			    rate->rate == 240)
-				rate->flags |= IEEE80211_RATE_BASIC;
+			fi->phytype = htonl(ieee80211_phytype_ofdm_dot11_a);
 			break;
 		case MODE_IEEE80211B:
-			if (rate->rate == 10 || rate->rate == 20)
-				rate->flags |= IEEE80211_RATE_BASIC;
-			break;
-		case MODE_ATHEROS_TURBO:
-			if (rate->rate == 120 || rate->rate == 240 ||
-			    rate->rate == 480)
-				rate->flags |= IEEE80211_RATE_BASIC;
+			fi->phytype = htonl(ieee80211_phytype_dsss_dot11_b);
 			break;
 		case MODE_IEEE80211G:
-			if (rate->rate == 10 || rate->rate == 20 ||
-			    rate->rate == 55 || rate->rate == 110)
-				rate->flags |= IEEE80211_RATE_BASIC;
-			break;
-		}
-
-		/* Set ERP and MANDATORY flags based on phymode */
-		switch (mode->mode) {
-		case MODE_IEEE80211A:
-			if (rate->rate == 60 || rate->rate == 120 ||
-			    rate->rate == 240)
-				rate->flags |= IEEE80211_RATE_MANDATORY;
-			break;
-		case MODE_IEEE80211B:
-			if (rate->rate == 10)
-				rate->flags |= IEEE80211_RATE_MANDATORY;
+			fi->phytype = htonl(ieee80211_phytype_pbcc_dot11_g);
 			break;
 		case MODE_ATHEROS_TURBO:
+			fi->phytype =
+				htonl(ieee80211_phytype_dsss_dot11_turbo);
 			break;
-		case MODE_IEEE80211G:
-			if (rate->rate == 10 || rate->rate == 20 ||
-			    rate->rate == 55 || rate->rate == 110 ||
-			    rate->rate == 60 || rate->rate == 120 ||
-			    rate->rate == 240)
-				rate->flags |= IEEE80211_RATE_MANDATORY;
+		default:
+			fi->phytype = htonl(0xAAAAAAAA);
 			break;
 		}
-		if (ieee80211_is_erp_rate(mode->mode, rate->rate))
-			rate->flags |= IEEE80211_RATE_ERP;
+		fi->channel = htonl(status->channel);
+		rate = ieee80211_get_rate(local, status->phymode,
+					  status->rate);
+		if (rate) {
+			fi->datarate = htonl(rate->rate);
+			if (rate->flags & IEEE80211_RATE_PREAMBLE2) {
+				if (status->rate == rate->val)
+					fi->preamble = htonl(2); /* long */
+				else if (status->rate == rate->val2)
+					fi->preamble = htonl(1); /* short */
+			} else
+				fi->preamble = htonl(0);
+		} else {
+			fi->datarate = htonl(0);
+			fi->preamble = htonl(0);
+		}
+
+		fi->antenna = htonl(status->antenna);
+		fi->priority = htonl(0xffffffff); /* no clue */
+		fi->ssi_type = htonl(ieee80211_ssi_raw);
+		fi->ssi_signal = htonl(status->ssi);
+		fi->ssi_noise = 0x00000000;
+		fi->encoding = 0;
+	} else {
+		/* clear everything because we really don't know.
+		 * the msg_type field isn't present on monitor frames
+		 * so we don't know whether it will be present or not,
+		 * but it's ok to not clear it since it'll be assigned
+		 * anyway */
+		memset(fi, 0, sizeof(*fi) - sizeof(fi->msg_type));
+
+		fi->ssi_type = htonl(ieee80211_ssi_none);
+	}
+	fi->version = htonl(IEEE80211_FI_VERSION);
+	fi->length = cpu_to_be32(sizeof(*fi) - sizeof(fi->msg_type));
+}
+
+/* this routine is actually not just for this, but also
+ * for pushing fake 'management' frames into userspace.
+ * it shall be replaced by a netlink-based system. */
+void
+ieee80211_rx_mgmt(struct ieee80211_local *local, struct sk_buff *skb,
+		  struct ieee80211_rx_status *status, u32 msg_type)
+{
+	struct ieee80211_frame_info *fi;
+	const size_t hlen = sizeof(struct ieee80211_frame_info);
+	struct ieee80211_sub_if_data *sdata;
+
+	skb->dev = local->apdev;
+
+	sdata = IEEE80211_DEV_TO_SUB_IF(local->apdev);
+
+	if (skb_headroom(skb) < hlen) {
+		I802_DEBUG_INC(local->rx_expand_skb_head);
+		if (pskb_expand_head(skb, hlen, 0, GFP_ATOMIC)) {
+			dev_kfree_skb(skb);
+			return;
+		}
 	}
+
+	fi = (struct ieee80211_frame_info *) skb_push(skb, hlen);
+
+	ieee80211_fill_frame_info(local, fi, status);
+	fi->msg_type = htonl(msg_type);
+
+	sdata->stats.rx_packets++;
+	sdata->stats.rx_bytes += skb->len;
+
+	skb_set_mac_header(skb, 0);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	skb->pkt_type = PACKET_OTHERHOST;
+	skb->protocol = htons(ETH_P_802_2);
+	memset(skb->cb, 0, sizeof(skb->cb));
+	netif_rx(skb);
 }
 
+int ieee80211_radar_status(struct ieee80211_hw *hw, int channel,
+			   int radar, int radar_type)
+{
+	struct sk_buff *skb;
+	struct ieee80211_radar_info *msg;
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	if (!local->apdev)
+		return 0;
+
+	skb = dev_alloc_skb(sizeof(struct ieee80211_frame_info) +
+			    sizeof(struct ieee80211_radar_info));
+
+	if (!skb)
+		return -ENOMEM;
+	skb_reserve(skb, sizeof(struct ieee80211_frame_info));
+
+	msg = (struct ieee80211_radar_info *)
+		skb_put(skb, sizeof(struct ieee80211_radar_info));
+	msg->channel = channel;
+	msg->radar = radar;
+	msg->radar_type = radar_type;
+
+	ieee80211_rx_mgmt(local, skb, NULL, ieee80211_msg_radar);
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_radar_status);
 
 void ieee80211_key_threshold_notify(struct net_device *dev,
 				    struct ieee80211_key *key,
@@ -186,749 +283,860 @@ void ieee80211_key_threshold_notify(stru
 			  ieee80211_msg_key_threshold_notification);
 }
 
+static int ieee80211_mgmt_open(struct net_device *dev)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
+	if (!netif_running(local->mdev))
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static int ieee80211_mgmt_stop(struct net_device *dev)
 {
-	u16 fc;
+	return 0;
+}
 
-	if (len < 24)
-		return NULL;
+static int ieee80211_change_mtu_apdev(struct net_device *dev, int new_mtu)
+{
+	/* FIX: what would be proper limits for MTU?
+	 * This interface uses 802.11 frames. */
+	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN) {
+		printk(KERN_WARNING "%s: invalid MTU %d\n",
+		       dev->name, new_mtu);
+		return -EINVAL;
+	}
 
-	fc = le16_to_cpu(hdr->frame_control);
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: setting MTU %d\n", dev->name, new_mtu);
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	dev->mtu = new_mtu;
+	return 0;
+}
 
-	switch (fc & IEEE80211_FCTL_FTYPE) {
-	case IEEE80211_FTYPE_DATA:
-		switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
-		case IEEE80211_FCTL_TODS:
-			return hdr->addr1;
-		case (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
-			return NULL;
-		case IEEE80211_FCTL_FROMDS:
-			return hdr->addr2;
-		case 0:
-			return hdr->addr3;
-		}
-		break;
-	case IEEE80211_FTYPE_MGMT:
-		return hdr->addr3;
-	case IEEE80211_FTYPE_CTL:
-		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)
-			return hdr->addr1;
-		else
-			return NULL;
+void ieee80211_if_mgmt_setup(struct net_device *dev)
+{
+	ether_setup(dev);
+	dev->hard_start_xmit = ieee80211_mgmt_start_xmit;
+	dev->change_mtu = ieee80211_change_mtu_apdev;
+	dev->get_stats = ieee80211_get_stats;
+	dev->open = ieee80211_mgmt_open;
+	dev->stop = ieee80211_mgmt_stop;
+	dev->type = ARPHRD_IEEE80211_PRISM;
+	dev->hard_header_parse = header_parse_80211;
+	dev->uninit = ieee80211_if_reinit;
+	dev->destructor = ieee80211_if_free;
+}
+
+
+/* regular interfaces */
+
+static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
+{
+	/* FIX: what would be proper limits for MTU?
+	 * This interface uses 802.3 frames. */
+	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6) {
+		printk(KERN_WARNING "%s: invalid MTU %d\n",
+		       dev->name, new_mtu);
+		return -EINVAL;
 	}
 
-	return NULL;
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "%s: setting MTU %d\n", dev->name, new_mtu);
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	dev->mtu = new_mtu;
+	return 0;
 }
 
-int ieee80211_get_hdrlen(u16 fc)
+static inline int identical_mac_addr_allowed(int type1, int type2)
 {
-	int hdrlen = 24;
+	return (type1 == IEEE80211_IF_TYPE_MNTR ||
+		type2 == IEEE80211_IF_TYPE_MNTR ||
+		(type1 == IEEE80211_IF_TYPE_AP &&
+		 type2 == IEEE80211_IF_TYPE_WDS) ||
+		(type1 == IEEE80211_IF_TYPE_WDS &&
+		 (type2 == IEEE80211_IF_TYPE_WDS ||
+		  type2 == IEEE80211_IF_TYPE_AP)) ||
+		(type1 == IEEE80211_IF_TYPE_AP &&
+		 type2 == IEEE80211_IF_TYPE_VLAN) ||
+		(type1 == IEEE80211_IF_TYPE_VLAN &&
+		 (type2 == IEEE80211_IF_TYPE_AP ||
+		  type2 == IEEE80211_IF_TYPE_VLAN)));
+}
 
-	switch (fc & IEEE80211_FCTL_FTYPE) {
-	case IEEE80211_FTYPE_DATA:
-		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
-			hdrlen = 30; /* Addr4 */
-		/*
-		 * The QoS Control field is two bytes and its presence is
-		 * indicated by the IEEE80211_STYPE_QOS_DATA bit. Add 2 to
-		 * hdrlen if that bit is set.
-		 * This works by masking out the bit and shifting it to
-		 * bit position 1 so the result has the value 0 or 2.
-		 */
-		hdrlen += (fc & IEEE80211_STYPE_QOS_DATA)
-				>> (ilog2(IEEE80211_STYPE_QOS_DATA)-1);
-		break;
-	case IEEE80211_FTYPE_CTL:
-		/*
-		 * ACK and CTS are 10 bytes, all others 16. To see how
-		 * to get this condition consider
-		 *   subtype mask:   0b0000000011110000 (0x00F0)
-		 *   ACK subtype:    0b0000000011010000 (0x00D0)
-		 *   CTS subtype:    0b0000000011000000 (0x00C0)
-		 *   bits that matter:         ^^^      (0x00E0)
-		 *   value of those: 0b0000000011000000 (0x00C0)
-		 */
-		if ((fc & 0xE0) == 0xC0)
-			hdrlen = 10;
-		else
-			hdrlen = 16;
-		break;
-	}
+/* Check if running monitor interfaces should go to a "soft monitor" mode
+ * and switch them if necessary. */
+static void ieee80211_start_soft_monitor(struct ieee80211_local *local)
+{
+	struct ieee80211_if_init_conf conf;
 
-	return hdrlen;
+	if (local->open_count && local->open_count == local->monitors &&
+	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER) &&
+	    local->ops->remove_interface) {
+		conf.if_id = -1;
+		conf.type = IEEE80211_IF_TYPE_MNTR;
+		conf.mac_addr = NULL;
+		local->ops->remove_interface(local_to_hw(local), &conf);
+	}
 }
-EXPORT_SYMBOL(ieee80211_get_hdrlen);
 
-int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
+/* Check if running monitor interfaces should go to a "hard monitor" mode
+ * and switch them if necessary. */
+static void ieee80211_start_hard_monitor(struct ieee80211_local *local)
 {
-	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *) skb->data;
-	int hdrlen;
+	struct ieee80211_if_init_conf conf;
 
-	if (unlikely(skb->len < 10))
-		return 0;
-	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
-	if (unlikely(hdrlen > skb->len))
-		return 0;
-	return hdrlen;
+	if (local->open_count && local->open_count == local->monitors &&
+	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
+		conf.if_id = -1;
+		conf.type = IEEE80211_IF_TYPE_MNTR;
+		conf.mac_addr = NULL;
+		local->ops->add_interface(local_to_hw(local), &conf);
+	}
 }
-EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
-
-int ieee80211_is_eapol(const struct sk_buff *skb)
+static int ieee80211_open(struct net_device *dev)
 {
-	const struct ieee80211_hdr *hdr;
-	u16 fc;
-	int hdrlen;
+	struct ieee80211_sub_if_data *sdata, *nsdata;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_if_init_conf conf;
+	int res;
 
-	if (unlikely(skb->len < 10))
-		return 0;
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	read_lock(&local->sub_if_lock);
+	list_for_each_entry(nsdata, &local->sub_if_list, list) {
+		struct net_device *ndev = nsdata->dev;
 
-	hdr = (const struct ieee80211_hdr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
+		if (ndev != dev && ndev != local->mdev && netif_running(ndev) &&
+		    compare_ether_addr(dev->dev_addr, ndev->dev_addr) == 0 &&
+		    !identical_mac_addr_allowed(sdata->type, nsdata->type)) {
+			read_unlock(&local->sub_if_lock);
+			return -ENOTUNIQ;
+		}
+	}
+	read_unlock(&local->sub_if_lock);
 
-	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
+	if (sdata->type == IEEE80211_IF_TYPE_WDS &&
+	    is_zero_ether_addr(sdata->u.wds.remote_addr))
+		return -ENOLINK;
+
+	if (sdata->type == IEEE80211_IF_TYPE_MNTR && local->open_count &&
+	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
+		/* run the interface in a "soft monitor" mode */
+		local->monitors++;
+		local->open_count++;
+		local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
 		return 0;
+	}
+	ieee80211_start_soft_monitor(local);
 
-	hdrlen = ieee80211_get_hdrlen(fc);
+	conf.if_id = dev->ifindex;
+	conf.type = sdata->type;
+	conf.mac_addr = dev->dev_addr;
+	res = local->ops->add_interface(local_to_hw(local), &conf);
+	if (res) {
+		if (sdata->type == IEEE80211_IF_TYPE_MNTR)
+			ieee80211_start_hard_monitor(local);
+		return res;
+	}
 
-	if (unlikely(skb->len >= hdrlen + sizeof(eapol_header) &&
-		     memcmp(skb->data + hdrlen, eapol_header,
-			    sizeof(eapol_header)) == 0))
-		return 1;
+	if (local->open_count == 0) {
+		res = 0;
+		tasklet_enable(&local->tx_pending_tasklet);
+		tasklet_enable(&local->tasklet);
+		if (local->ops->open)
+			res = local->ops->open(local_to_hw(local));
+		if (res == 0) {
+			res = dev_open(local->mdev);
+			if (res) {
+				if (local->ops->stop)
+					local->ops->stop(local_to_hw(local));
+			} else {
+				res = ieee80211_hw_config(local);
+				if (res && local->ops->stop)
+					local->ops->stop(local_to_hw(local));
+				else if (!res && local->apdev)
+					dev_open(local->apdev);
+			}
+		}
+		if (res) {
+			if (local->ops->remove_interface)
+				local->ops->remove_interface(local_to_hw(local),
+							    &conf);
+			return res;
+		}
+	}
+	local->open_count++;
+
+	if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
+		local->monitors++;
+		local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
+	} else
+		ieee80211_if_config(dev);
+
+	if (sdata->type == IEEE80211_IF_TYPE_STA &&
+	    !local->user_space_mlme)
+		netif_carrier_off(dev);
+	else
+		netif_carrier_on(dev);
 
+	netif_start_queue(dev);
 	return 0;
 }
 
-
-void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx)
+static void ieee80211_if_shutdown(struct net_device *dev)
 {
-	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
-	if (tx->u.tx.extra_frag) {
-		struct ieee80211_hdr *fhdr;
-		int i;
-		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
-			fhdr = (struct ieee80211_hdr *)
-				tx->u.tx.extra_frag[i]->data;
-			fhdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+	ASSERT_RTNL();
+	switch (sdata->type) {
+	case IEEE80211_IF_TYPE_STA:
+	case IEEE80211_IF_TYPE_IBSS:
+		sdata->u.sta.state = IEEE80211_DISABLED;
+		del_timer_sync(&sdata->u.sta.timer);
+		del_timer_sync(&sdata->u.sta.admit_timer);
+		skb_queue_purge(&sdata->u.sta.skb_queue);
+		if (!local->ops->hw_scan &&
+		    local->scan_dev == sdata->dev) {
+			local->sta_scanning = 0;
+			cancel_delayed_work(&local->scan_work);
 		}
+		flush_workqueue(local->hw.workqueue);
+		break;
 	}
 }
 
-
-int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
-			     int rate, int erp, int short_preamble)
+static int ieee80211_stop(struct net_device *dev)
 {
-	int dur;
+	struct ieee80211_sub_if_data *sdata;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 
-	/* calculate duration (in microseconds, rounded up to next higher
-	 * integer if it includes a fractional microsecond) to send frame of
-	 * len bytes (does not include FCS) at the given rate. Duration will
-	 * also include SIFS.
-	 *
-	 * rate is in 100 kbps, so divident is multiplied by 10 in the
-	 * DIV_ROUND_UP() operations.
-	 */
+	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	if (local->hw.conf.phymode == MODE_IEEE80211A || erp ||
-	    local->hw.conf.phymode == MODE_ATHEROS_TURBO) {
-		/*
-		 * OFDM:
-		 *
-		 * N_DBPS = DATARATE x 4
-		 * N_SYM = Ceiling((16+8xLENGTH+6) / N_DBPS)
-		 *	(16 = SIGNAL time, 6 = tail bits)
-		 * TXTIME = T_PREAMBLE + T_SIGNAL + T_SYM x N_SYM + Signal Ext
-		 *
-		 * T_SYM = 4 usec
-		 * 802.11a - 17.5.2: aSIFSTime = 16 usec
-		 * 802.11g - 19.8.4: aSIFSTime = 10 usec +
-		 *	signal ext = 6 usec
-		 */
-		/* FIX: Atheros Turbo may have different (shorter) duration? */
-		dur = 16; /* SIFS + signal ext */
-		dur += 16; /* 17.3.2.3: T_PREAMBLE = 16 usec */
-		dur += 4; /* 17.3.2.3: T_SIGNAL = 4 usec */
-		dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
-					4 * rate); /* T_SYM x N_SYM */
-	} else {
-		/*
-		 * 802.11b or 802.11g with 802.11b compatibility:
-		 * 18.3.4: TXTIME = PreambleLength + PLCPHeaderTime +
-		 * Ceiling(((LENGTH+PBCC)x8)/DATARATE). PBCC=0.
-		 *
-		 * 802.11 (DS): 15.3.3, 802.11b: 18.3.4
-		 * aSIFSTime = 10 usec
-		 * aPreambleLength = 144 usec or 72 usec with short preamble
-		 * aPLCPHeaderLength = 48 usec or 24 usec with short preamble
-		 */
-		dur = 10; /* aSIFSTime = 10 usec */
-		dur += short_preamble ? (72 + 24) : (144 + 48);
+	if (sdata->type == IEEE80211_IF_TYPE_MNTR &&
+	    local->open_count > 1 &&
+	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
+		/* remove "soft monitor" interface */
+		local->open_count--;
+		local->monitors--;
+		if (!local->monitors)
+			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
+		return 0;
+	}
 
-		dur += DIV_ROUND_UP(8 * (len + 4) * 10, rate);
+	netif_stop_queue(dev);
+	ieee80211_if_shutdown(dev);
+
+	if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
+		local->monitors--;
+		if (!local->monitors)
+			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
 	}
 
-	return dur;
+	local->open_count--;
+	if (local->open_count == 0) {
+		if (netif_running(local->mdev))
+			dev_close(local->mdev);
+		if (local->apdev)
+			dev_close(local->apdev);
+		if (local->ops->stop)
+			local->ops->stop(local_to_hw(local));
+		tasklet_disable(&local->tx_pending_tasklet);
+		tasklet_disable(&local->tasklet);
+	}
+	if (local->ops->remove_interface) {
+		struct ieee80211_if_init_conf conf;
+
+		conf.if_id = dev->ifindex;
+		conf.type = sdata->type;
+		conf.mac_addr = dev->dev_addr;
+		local->ops->remove_interface(local_to_hw(local), &conf);
+	}
+
+	ieee80211_start_hard_monitor(local);
+
+	return 0;
 }
 
+enum netif_tx_lock_class {
+	TX_LOCK_NORMAL,
+	TX_LOCK_MASTER,
+};
 
-/* Exported duration function for driver use */
-__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
-					size_t frame_len, int rate)
+static inline void netif_tx_lock_nested(struct net_device *dev, int subclass)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	u16 dur;
-	int erp;
+	spin_lock_nested(&dev->_xmit_lock, subclass);
+	dev->xmit_lock_owner = smp_processor_id();
+}
 
-	erp = ieee80211_is_erp_rate(hw->conf.phymode, rate);
-	dur = ieee80211_frame_duration(local, frame_len, rate,
-				       erp, local->short_preamble);
+static void ieee80211_set_multicast_list(struct net_device *dev)
+{
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	unsigned short flags;
 
-	return cpu_to_le16(dur);
+	netif_tx_lock_nested(local->mdev, TX_LOCK_MASTER);
+	if (((dev->flags & IFF_ALLMULTI) != 0) ^ (sdata->allmulti != 0)) {
+		if (sdata->allmulti) {
+			sdata->allmulti = 0;
+			local->iff_allmultis--;
+		} else {
+			sdata->allmulti = 1;
+			local->iff_allmultis++;
+		}
+	}
+	if (((dev->flags & IFF_PROMISC) != 0) ^ (sdata->promisc != 0)) {
+		if (sdata->promisc) {
+			sdata->promisc = 0;
+			local->iff_promiscs--;
+		} else {
+			sdata->promisc = 1;
+			local->iff_promiscs++;
+		}
+	}
+	if (dev->mc_count != sdata->mc_count) {
+		local->mc_count = local->mc_count - sdata->mc_count +
+				  dev->mc_count;
+		sdata->mc_count = dev->mc_count;
+	}
+	if (local->ops->set_multicast_list) {
+		flags = local->mdev->flags;
+		if (local->iff_allmultis)
+			flags |= IFF_ALLMULTI;
+		if (local->iff_promiscs)
+			flags |= IFF_PROMISC;
+		read_lock(&local->sub_if_lock);
+		local->ops->set_multicast_list(local_to_hw(local), flags,
+					      local->mc_count);
+		read_unlock(&local->sub_if_lock);
+	}
+	netif_tx_unlock(local->mdev);
 }
-EXPORT_SYMBOL(ieee80211_generic_frame_duration);
 
+/* Must not be called for mdev and apdev */
+void ieee80211_if_setup(struct net_device *dev)
+{
+	ether_setup(dev);
+	dev->hard_start_xmit = ieee80211_subif_start_xmit;
+	dev->wireless_handlers = &ieee80211_iw_handler_def;
+	dev->do_ioctl = ieee80211_ioctl;
+	dev->set_multicast_list = ieee80211_set_multicast_list;
+	dev->change_mtu = ieee80211_change_mtu;
+	dev->get_stats = ieee80211_get_stats;
+	dev->open = ieee80211_open;
+	dev->stop = ieee80211_stop;
+	dev->uninit = ieee80211_if_reinit;
+	dev->destructor = ieee80211_if_free;
+}
 
-__le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
-			      size_t frame_len,
-			      const struct ieee80211_tx_control *frame_txctl)
+
+/* WDS specialties */
+int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_rate *rate;
-	int short_preamble = local->short_preamble;
-	int erp;
-	u16 dur;
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct sta_info *sta;
 
-	rate = frame_txctl->rts_rate;
-	erp = !!(rate->flags & IEEE80211_RATE_ERP);
+	if (compare_ether_addr(remote_addr, sdata->u.wds.remote_addr) == 0)
+		return 0;
 
-	/* CTS duration */
-	dur = ieee80211_frame_duration(local, 10, rate->rate,
-				       erp, short_preamble);
-	/* Data frame duration */
-	dur += ieee80211_frame_duration(local, frame_len, rate->rate,
-					erp, short_preamble);
-	/* ACK duration */
-	dur += ieee80211_frame_duration(local, 10, rate->rate,
-					erp, short_preamble);
+	/* Create STA entry for the new peer */
+	sta = sta_info_add(local, dev, remote_addr, GFP_KERNEL);
+	if (!sta)
+		return -ENOMEM;
+	sta_info_put(sta);
 
-	return cpu_to_le16(dur);
+	/* Remove STA entry for the old peer */
+	sta = sta_info_get(local, sdata->u.wds.remote_addr);
+	if (sta) {
+		sta_info_put(sta);
+		sta_info_free(sta, 0);
+	} else {
+		printk(KERN_DEBUG "%s: could not find STA entry for WDS link "
+		       "peer " MAC_FMT "\n",
+		       dev->name, MAC_ARG(sdata->u.wds.remote_addr));
+	}
+
+	/* Update WDS link data */
+	memcpy(&sdata->u.wds.remote_addr, remote_addr, ETH_ALEN);
+
+	return 0;
 }
-EXPORT_SYMBOL(ieee80211_rts_duration);
 
 
-__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
-				    size_t frame_len,
-				    const struct ieee80211_tx_control *frame_txctl)
+/* everything else */
+
+static int rate_list_match(const int *rate_list, int rate)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_rate *rate;
-	int short_preamble = local->short_preamble;
-	int erp;
-	u16 dur;
+	int i;
 
-	rate = frame_txctl->rts_rate;
-	erp = !!(rate->flags & IEEE80211_RATE_ERP);
+	if (!rate_list)
+		return 0;
 
-	/* Data frame duration */
-	dur = ieee80211_frame_duration(local, frame_len, rate->rate,
-				       erp, short_preamble);
-	if (!(frame_txctl->flags & IEEE80211_TXCTL_NO_ACK)) {
-		/* ACK duration */
-		dur += ieee80211_frame_duration(local, 10, rate->rate,
-						erp, short_preamble);
-	}
+	for (i = 0; rate_list[i] >= 0; i++)
+		if (rate_list[i] == rate)
+			return 1;
 
-	return cpu_to_le16(dur);
+	return 0;
 }
-EXPORT_SYMBOL(ieee80211_ctstoself_duration);
 
 
-static int __ieee80211_if_config(struct net_device *dev,
-				 struct sk_buff *beacon,
-				 struct ieee80211_tx_control *control)
+void ieee80211_prepare_rates(struct ieee80211_local *local,
+			     struct ieee80211_hw_mode *mode)
 {
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_if_conf conf;
-	static u8 scan_bssid[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+	int i;
 
-	if (!local->ops->config_interface || !netif_running(dev))
-		return 0;
+	for (i = 0; i < mode->num_rates; i++) {
+		struct ieee80211_rate *rate = &mode->rates[i];
 
-	memset(&conf, 0, sizeof(conf));
-	conf.type = sdata->type;
-	if (sdata->type == IEEE80211_IF_TYPE_STA ||
-	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
-		if (local->sta_scanning &&
-		    local->scan_dev == dev)
-			conf.bssid = scan_bssid;
-		else
-			conf.bssid = sdata->u.sta.bssid;
-		conf.ssid = sdata->u.sta.ssid;
-		conf.ssid_len = sdata->u.sta.ssid_len;
-		conf.generic_elem = sdata->u.sta.extra_ie;
-		conf.generic_elem_len = sdata->u.sta.extra_ie_len;
-	} else if (sdata->type == IEEE80211_IF_TYPE_AP) {
-		conf.ssid = sdata->u.ap.ssid;
-		conf.ssid_len = sdata->u.ap.ssid_len;
-		conf.generic_elem = sdata->u.ap.generic_elem;
-		conf.generic_elem_len = sdata->u.ap.generic_elem_len;
-		conf.beacon = beacon;
-		conf.beacon_control = control;
-	}
-	return local->ops->config_interface(local_to_hw(local),
-					   dev->ifindex, &conf);
-}
+		rate->flags &= ~(IEEE80211_RATE_SUPPORTED |
+				 IEEE80211_RATE_BASIC);
 
-int ieee80211_if_config(struct net_device *dev)
-{
-	return __ieee80211_if_config(dev, NULL, NULL);
-}
+		if (local->supp_rates[mode->mode]) {
+			if (!rate_list_match(local->supp_rates[mode->mode],
+					     rate->rate))
+				continue;
+		}
 
-int ieee80211_if_config_beacon(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_tx_control control;
-	struct sk_buff *skb;
+		rate->flags |= IEEE80211_RATE_SUPPORTED;
 
-	if (!(local->hw.flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE))
-		return 0;
-	skb = ieee80211_beacon_get(local_to_hw(local), dev->ifindex, &control);
-	if (!skb)
-		return -ENOMEM;
-	return __ieee80211_if_config(dev, skb, &control);
+		/* Use configured basic rate set if it is available. If not,
+		 * use defaults that are sane for most cases. */
+		if (local->basic_rates[mode->mode]) {
+			if (rate_list_match(local->basic_rates[mode->mode],
+					    rate->rate))
+				rate->flags |= IEEE80211_RATE_BASIC;
+		} else switch (mode->mode) {
+		case MODE_IEEE80211A:
+			if (rate->rate == 60 || rate->rate == 120 ||
+			    rate->rate == 240)
+				rate->flags |= IEEE80211_RATE_BASIC;
+			break;
+		case MODE_IEEE80211B:
+			if (rate->rate == 10 || rate->rate == 20)
+				rate->flags |= IEEE80211_RATE_BASIC;
+			break;
+		case MODE_ATHEROS_TURBO:
+			if (rate->rate == 120 || rate->rate == 240 ||
+			    rate->rate == 480)
+				rate->flags |= IEEE80211_RATE_BASIC;
+			break;
+		case MODE_IEEE80211G:
+			if (rate->rate == 10 || rate->rate == 20 ||
+			    rate->rate == 55 || rate->rate == 110)
+				rate->flags |= IEEE80211_RATE_BASIC;
+			break;
+		}
+
+		/* Set ERP and MANDATORY flags based on phymode */
+		switch (mode->mode) {
+		case MODE_IEEE80211A:
+			if (rate->rate == 60 || rate->rate == 120 ||
+			    rate->rate == 240)
+				rate->flags |= IEEE80211_RATE_MANDATORY;
+			break;
+		case MODE_IEEE80211B:
+			if (rate->rate == 10)
+				rate->flags |= IEEE80211_RATE_MANDATORY;
+			break;
+		case MODE_ATHEROS_TURBO:
+			break;
+		case MODE_IEEE80211G:
+			if (rate->rate == 10 || rate->rate == 20 ||
+			    rate->rate == 55 || rate->rate == 110 ||
+			    rate->rate == 60 || rate->rate == 120 ||
+			    rate->rate == 240)
+				rate->flags |= IEEE80211_RATE_MANDATORY;
+			break;
+		}
+		if (ieee80211_is_erp_rate(mode->mode, rate->rate))
+			rate->flags |= IEEE80211_RATE_ERP;
+	}
 }
 
-int ieee80211_hw_config(struct ieee80211_local *local)
-{
-	struct ieee80211_hw_mode *mode;
-	struct ieee80211_channel *chan;
-	int ret = 0;
 
-	if (local->sta_scanning) {
-		chan = local->scan_channel;
-		mode = local->scan_hw_mode;
-	} else {
-		chan = local->oper_channel;
-		mode = local->oper_hw_mode;
-	}
+u8 *ieee80211_get_bssid(struct ieee80211_hdr *hdr, size_t len)
+{
+	u16 fc;
 
-	local->hw.conf.channel = chan->chan;
-	local->hw.conf.channel_val = chan->val;
-	local->hw.conf.power_level = chan->power_level;
-	local->hw.conf.freq = chan->freq;
-	local->hw.conf.phymode = mode->mode;
-	local->hw.conf.antenna_max = chan->antenna_max;
-	local->hw.conf.chan = chan;
-	local->hw.conf.mode = mode;
+	if (len < 24)
+		return NULL;
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "HW CONFIG: channel=%d freq=%d "
-	       "phymode=%d\n", local->hw.conf.channel, local->hw.conf.freq,
-	       local->hw.conf.phymode);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
+	fc = le16_to_cpu(hdr->frame_control);
 
-	if (local->ops->config)
-		ret = local->ops->config(local_to_hw(local), &local->hw.conf);
+	switch (fc & IEEE80211_FCTL_FTYPE) {
+	case IEEE80211_FTYPE_DATA:
+		switch (fc & (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS)) {
+		case IEEE80211_FCTL_TODS:
+			return hdr->addr1;
+		case (IEEE80211_FCTL_TODS | IEEE80211_FCTL_FROMDS):
+			return NULL;
+		case IEEE80211_FCTL_FROMDS:
+			return hdr->addr2;
+		case 0:
+			return hdr->addr3;
+		}
+		break;
+	case IEEE80211_FTYPE_MGMT:
+		return hdr->addr3;
+	case IEEE80211_FTYPE_CTL:
+		if ((fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)
+			return hdr->addr1;
+		else
+			return NULL;
+	}
 
-	return ret;
+	return NULL;
 }
 
-
-static int ieee80211_change_mtu(struct net_device *dev, int new_mtu)
+int ieee80211_get_hdrlen(u16 fc)
 {
-	/* FIX: what would be proper limits for MTU?
-	 * This interface uses 802.3 frames. */
-	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN - 24 - 6) {
-		printk(KERN_WARNING "%s: invalid MTU %d\n",
-		       dev->name, new_mtu);
-		return -EINVAL;
+	int hdrlen = 24;
+
+	switch (fc & IEEE80211_FCTL_FTYPE) {
+	case IEEE80211_FTYPE_DATA:
+		if ((fc & IEEE80211_FCTL_FROMDS) && (fc & IEEE80211_FCTL_TODS))
+			hdrlen = 30; /* Addr4 */
+		/*
+		 * The QoS Control field is two bytes and its presence is
+		 * indicated by the IEEE80211_STYPE_QOS_DATA bit. Add 2 to
+		 * hdrlen if that bit is set.
+		 * This works by masking out the bit and shifting it to
+		 * bit position 1 so the result has the value 0 or 2.
+		 */
+		hdrlen += (fc & IEEE80211_STYPE_QOS_DATA)
+				>> (ilog2(IEEE80211_STYPE_QOS_DATA)-1);
+		break;
+	case IEEE80211_FTYPE_CTL:
+		/*
+		 * ACK and CTS are 10 bytes, all others 16. To see how
+		 * to get this condition consider
+		 *   subtype mask:   0b0000000011110000 (0x00F0)
+		 *   ACK subtype:    0b0000000011010000 (0x00D0)
+		 *   CTS subtype:    0b0000000011000000 (0x00C0)
+		 *   bits that matter:         ^^^      (0x00E0)
+		 *   value of those: 0b0000000011000000 (0x00C0)
+		 */
+		if ((fc & 0xE0) == 0xC0)
+			hdrlen = 10;
+		else
+			hdrlen = 16;
+		break;
 	}
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: setting MTU %d\n", dev->name, new_mtu);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-	dev->mtu = new_mtu;
-	return 0;
+	return hdrlen;
 }
+EXPORT_SYMBOL(ieee80211_get_hdrlen);
 
-
-static int ieee80211_change_mtu_apdev(struct net_device *dev, int new_mtu)
+int ieee80211_get_hdrlen_from_skb(const struct sk_buff *skb)
 {
-	/* FIX: what would be proper limits for MTU?
-	 * This interface uses 802.11 frames. */
-	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN) {
-		printk(KERN_WARNING "%s: invalid MTU %d\n",
-		       dev->name, new_mtu);
-		return -EINVAL;
-	}
+	const struct ieee80211_hdr *hdr = (const struct ieee80211_hdr *) skb->data;
+	int hdrlen;
 
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: setting MTU %d\n", dev->name, new_mtu);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-	dev->mtu = new_mtu;
-	return 0;
+	if (unlikely(skb->len < 10))
+		return 0;
+	hdrlen = ieee80211_get_hdrlen(le16_to_cpu(hdr->frame_control));
+	if (unlikely(hdrlen > skb->len))
+		return 0;
+	return hdrlen;
 }
+EXPORT_SYMBOL(ieee80211_get_hdrlen_from_skb);
 
-enum netif_tx_lock_class {
-	TX_LOCK_NORMAL,
-	TX_LOCK_MASTER,
-};
 
-static inline void netif_tx_lock_nested(struct net_device *dev, int subclass)
+int ieee80211_is_eapol(const struct sk_buff *skb)
 {
-	spin_lock_nested(&dev->_xmit_lock, subclass);
-	dev->xmit_lock_owner = smp_processor_id();
-}
+	const struct ieee80211_hdr *hdr;
+	u16 fc;
+	int hdrlen;
 
-static void ieee80211_set_multicast_list(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	unsigned short flags;
+	if (unlikely(skb->len < 10))
+		return 0;
 
-	netif_tx_lock_nested(local->mdev, TX_LOCK_MASTER);
-	if (((dev->flags & IFF_ALLMULTI) != 0) ^ (sdata->allmulti != 0)) {
-		if (sdata->allmulti) {
-			sdata->allmulti = 0;
-			local->iff_allmultis--;
-		} else {
-			sdata->allmulti = 1;
-			local->iff_allmultis++;
-		}
-	}
-	if (((dev->flags & IFF_PROMISC) != 0) ^ (sdata->promisc != 0)) {
-		if (sdata->promisc) {
-			sdata->promisc = 0;
-			local->iff_promiscs--;
-		} else {
-			sdata->promisc = 1;
-			local->iff_promiscs++;
-		}
-	}
-	if (dev->mc_count != sdata->mc_count) {
-		local->mc_count = local->mc_count - sdata->mc_count +
-				  dev->mc_count;
-		sdata->mc_count = dev->mc_count;
-	}
-	if (local->ops->set_multicast_list) {
-		flags = local->mdev->flags;
-		if (local->iff_allmultis)
-			flags |= IFF_ALLMULTI;
-		if (local->iff_promiscs)
-			flags |= IFF_PROMISC;
-		read_lock(&local->sub_if_lock);
-		local->ops->set_multicast_list(local_to_hw(local), flags,
-					      local->mc_count);
-		read_unlock(&local->sub_if_lock);
-	}
-	netif_tx_unlock(local->mdev);
-}
+	hdr = (const struct ieee80211_hdr *) skb->data;
+	fc = le16_to_cpu(hdr->frame_control);
 
-struct dev_mc_list *ieee80211_get_mc_list_item(struct ieee80211_hw *hw,
-					       struct dev_mc_list *prev,
-					       void **ptr)
-{
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_sub_if_data *sdata = *ptr;
-	struct dev_mc_list *mc;
+	if (unlikely(!WLAN_FC_DATA_PRESENT(fc)))
+		return 0;
 
-	if (!prev) {
-		WARN_ON(sdata);
-		sdata = NULL;
-	}
-	if (!prev || !prev->next) {
-		if (sdata)
-			sdata = list_entry(sdata->list.next,
-					   struct ieee80211_sub_if_data, list);
-		else
-			sdata = list_entry(local->sub_if_list.next,
-					   struct ieee80211_sub_if_data, list);
-		if (&sdata->list != &local->sub_if_list)
-			mc = sdata->dev->mc_list;
-		else
-			mc = NULL;
-	} else
-		mc = prev->next;
+	hdrlen = ieee80211_get_hdrlen(fc);
 
-	*ptr = sdata;
-	return mc;
-}
-EXPORT_SYMBOL(ieee80211_get_mc_list_item);
+	if (unlikely(skb->len >= hdrlen + sizeof(eapol_header) &&
+		     memcmp(skb->data + hdrlen, eapol_header,
+			    sizeof(eapol_header)) == 0))
+		return 1;
 
-static struct net_device_stats *ieee80211_get_stats(struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata;
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	return &(sdata->stats);
+	return 0;
 }
 
-static void ieee80211_if_shutdown(struct net_device *dev)
+
+void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) tx->skb->data;
 
-	ASSERT_RTNL();
-	switch (sdata->type) {
-	case IEEE80211_IF_TYPE_STA:
-	case IEEE80211_IF_TYPE_IBSS:
-		sdata->u.sta.state = IEEE80211_DISABLED;
-		del_timer_sync(&sdata->u.sta.timer);
-		del_timer_sync(&sdata->u.sta.admit_timer);
-		skb_queue_purge(&sdata->u.sta.skb_queue);
-		if (!local->ops->hw_scan &&
-		    local->scan_dev == sdata->dev) {
-			local->sta_scanning = 0;
-			cancel_delayed_work(&local->scan_work);
+	hdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
+	if (tx->u.tx.extra_frag) {
+		struct ieee80211_hdr *fhdr;
+		int i;
+		for (i = 0; i < tx->u.tx.num_extra_frag; i++) {
+			fhdr = (struct ieee80211_hdr *)
+				tx->u.tx.extra_frag[i]->data;
+			fhdr->frame_control |= cpu_to_le16(IEEE80211_FCTL_PROTECTED);
 		}
-		flush_workqueue(local->hw.workqueue);
-		break;
 	}
 }
 
-static inline int identical_mac_addr_allowed(int type1, int type2)
-{
-	return (type1 == IEEE80211_IF_TYPE_MNTR ||
-		type2 == IEEE80211_IF_TYPE_MNTR ||
-		(type1 == IEEE80211_IF_TYPE_AP &&
-		 type2 == IEEE80211_IF_TYPE_WDS) ||
-		(type1 == IEEE80211_IF_TYPE_WDS &&
-		 (type2 == IEEE80211_IF_TYPE_WDS ||
-		  type2 == IEEE80211_IF_TYPE_AP)) ||
-		(type1 == IEEE80211_IF_TYPE_AP &&
-		 type2 == IEEE80211_IF_TYPE_VLAN) ||
-		(type1 == IEEE80211_IF_TYPE_VLAN &&
-		 (type2 == IEEE80211_IF_TYPE_AP ||
-		  type2 == IEEE80211_IF_TYPE_VLAN)));
-}
 
-static int ieee80211_master_open(struct net_device *dev)
+int ieee80211_frame_duration(struct ieee80211_local *local, size_t len,
+			     int rate, int erp, int short_preamble)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata;
-	int res = -EOPNOTSUPP;
+	int dur;
 
-	read_lock(&local->sub_if_lock);
-	list_for_each_entry(sdata, &local->sub_if_list, list) {
-		if (sdata->dev != dev && netif_running(sdata->dev)) {
-			res = 0;
-			break;
-		}
-	}
-	read_unlock(&local->sub_if_lock);
-	return res;
-}
+	/* calculate duration (in microseconds, rounded up to next higher
+	 * integer if it includes a fractional microsecond) to send frame of
+	 * len bytes (does not include FCS) at the given rate. Duration will
+	 * also include SIFS.
+	 *
+	 * rate is in 100 kbps, so divident is multiplied by 10 in the
+	 * DIV_ROUND_UP() operations.
+	 */
 
-static int ieee80211_master_stop(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata;
+	if (local->hw.conf.phymode == MODE_IEEE80211A || erp ||
+	    local->hw.conf.phymode == MODE_ATHEROS_TURBO) {
+		/*
+		 * OFDM:
+		 *
+		 * N_DBPS = DATARATE x 4
+		 * N_SYM = Ceiling((16+8xLENGTH+6) / N_DBPS)
+		 *	(16 = SIGNAL time, 6 = tail bits)
+		 * TXTIME = T_PREAMBLE + T_SIGNAL + T_SYM x N_SYM + Signal Ext
+		 *
+		 * T_SYM = 4 usec
+		 * 802.11a - 17.5.2: aSIFSTime = 16 usec
+		 * 802.11g - 19.8.4: aSIFSTime = 10 usec +
+		 *	signal ext = 6 usec
+		 */
+		/* FIX: Atheros Turbo may have different (shorter) duration? */
+		dur = 16; /* SIFS + signal ext */
+		dur += 16; /* 17.3.2.3: T_PREAMBLE = 16 usec */
+		dur += 4; /* 17.3.2.3: T_SIGNAL = 4 usec */
+		dur += 4 * DIV_ROUND_UP((16 + 8 * (len + 4) + 6) * 10,
+					4 * rate); /* T_SYM x N_SYM */
+	} else {
+		/*
+		 * 802.11b or 802.11g with 802.11b compatibility:
+		 * 18.3.4: TXTIME = PreambleLength + PLCPHeaderTime +
+		 * Ceiling(((LENGTH+PBCC)x8)/DATARATE). PBCC=0.
+		 *
+		 * 802.11 (DS): 15.3.3, 802.11b: 18.3.4
+		 * aSIFSTime = 10 usec
+		 * aPreambleLength = 144 usec or 72 usec with short preamble
+		 * aPLCPHeaderLength = 48 usec or 24 usec with short preamble
+		 */
+		dur = 10; /* aSIFSTime = 10 usec */
+		dur += short_preamble ? (72 + 24) : (144 + 48);
 
-	read_lock(&local->sub_if_lock);
-	list_for_each_entry(sdata, &local->sub_if_list, list)
-		if (sdata->dev != dev && netif_running(sdata->dev))
-			dev_close(sdata->dev);
-	read_unlock(&local->sub_if_lock);
+		dur += DIV_ROUND_UP(8 * (len + 4) * 10, rate);
+	}
 
-	return 0;
+	return dur;
 }
 
-static int ieee80211_mgmt_open(struct net_device *dev)
+
+/* Exported duration function for driver use */
+__le16 ieee80211_generic_frame_duration(struct ieee80211_hw *hw,
+					size_t frame_len, int rate)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_local *local = hw_to_local(hw);
+	u16 dur;
+	int erp;
 
-	if (!netif_running(local->mdev))
-		return -EOPNOTSUPP;
-	return 0;
-}
+	erp = ieee80211_is_erp_rate(hw->conf.phymode, rate);
+	dur = ieee80211_frame_duration(local, frame_len, rate,
+				       erp, local->short_preamble);
 
-static int ieee80211_mgmt_stop(struct net_device *dev)
-{
-	return 0;
+	return cpu_to_le16(dur);
 }
+EXPORT_SYMBOL(ieee80211_generic_frame_duration);
 
-/* Check if running monitor interfaces should go to a "soft monitor" mode
- * and switch them if necessary. */
-static inline void ieee80211_start_soft_monitor(struct ieee80211_local *local)
+
+__le16 ieee80211_rts_duration(struct ieee80211_hw *hw,
+			      size_t frame_len,
+			      const struct ieee80211_tx_control *frame_txctl)
 {
-	struct ieee80211_if_init_conf conf;
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_rate *rate;
+	int short_preamble = local->short_preamble;
+	int erp;
+	u16 dur;
 
-	if (local->open_count && local->open_count == local->monitors &&
-	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER) &&
-	    local->ops->remove_interface) {
-		conf.if_id = -1;
-		conf.type = IEEE80211_IF_TYPE_MNTR;
-		conf.mac_addr = NULL;
-		local->ops->remove_interface(local_to_hw(local), &conf);
-	}
-}
+	rate = frame_txctl->rts_rate;
+	erp = !!(rate->flags & IEEE80211_RATE_ERP);
 
-/* Check if running monitor interfaces should go to a "hard monitor" mode
- * and switch them if necessary. */
-static void ieee80211_start_hard_monitor(struct ieee80211_local *local)
-{
-	struct ieee80211_if_init_conf conf;
+	/* CTS duration */
+	dur = ieee80211_frame_duration(local, 10, rate->rate,
+				       erp, short_preamble);
+	/* Data frame duration */
+	dur += ieee80211_frame_duration(local, frame_len, rate->rate,
+					erp, short_preamble);
+	/* ACK duration */
+	dur += ieee80211_frame_duration(local, 10, rate->rate,
+					erp, short_preamble);
 
-	if (local->open_count && local->open_count == local->monitors &&
-	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
-		conf.if_id = -1;
-		conf.type = IEEE80211_IF_TYPE_MNTR;
-		conf.mac_addr = NULL;
-		local->ops->add_interface(local_to_hw(local), &conf);
-	}
+	return cpu_to_le16(dur);
 }
+EXPORT_SYMBOL(ieee80211_rts_duration);
 
-static int ieee80211_open(struct net_device *dev)
+
+__le16 ieee80211_ctstoself_duration(struct ieee80211_hw *hw,
+				    size_t frame_len,
+				    const struct ieee80211_tx_control *frame_txctl)
 {
-	struct ieee80211_sub_if_data *sdata, *nsdata;
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_if_init_conf conf;
-	int res;
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_rate *rate;
+	int short_preamble = local->short_preamble;
+	int erp;
+	u16 dur;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	read_lock(&local->sub_if_lock);
-	list_for_each_entry(nsdata, &local->sub_if_list, list) {
-		struct net_device *ndev = nsdata->dev;
+	rate = frame_txctl->rts_rate;
+	erp = !!(rate->flags & IEEE80211_RATE_ERP);
 
-		if (ndev != dev && ndev != local->mdev && netif_running(ndev) &&
-		    compare_ether_addr(dev->dev_addr, ndev->dev_addr) == 0 &&
-		    !identical_mac_addr_allowed(sdata->type, nsdata->type)) {
-			read_unlock(&local->sub_if_lock);
-			return -ENOTUNIQ;
-		}
+	/* Data frame duration */
+	dur = ieee80211_frame_duration(local, frame_len, rate->rate,
+				       erp, short_preamble);
+	if (!(frame_txctl->flags & IEEE80211_TXCTL_NO_ACK)) {
+		/* ACK duration */
+		dur += ieee80211_frame_duration(local, 10, rate->rate,
+						erp, short_preamble);
 	}
-	read_unlock(&local->sub_if_lock);
 
-	if (sdata->type == IEEE80211_IF_TYPE_WDS &&
-	    is_zero_ether_addr(sdata->u.wds.remote_addr))
-		return -ENOLINK;
+	return cpu_to_le16(dur);
+}
+EXPORT_SYMBOL(ieee80211_ctstoself_duration);
 
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR && local->open_count &&
-	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
-		/* run the interface in a "soft monitor" mode */
-		local->monitors++;
-		local->open_count++;
-		local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
+
+static int __ieee80211_if_config(struct net_device *dev,
+				 struct sk_buff *beacon,
+				 struct ieee80211_tx_control *control)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
+	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_if_conf conf;
+	static u8 scan_bssid[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
+
+	if (!local->ops->config_interface || !netif_running(dev))
 		return 0;
-	}
-	ieee80211_start_soft_monitor(local);
 
-	conf.if_id = dev->ifindex;
+	memset(&conf, 0, sizeof(conf));
 	conf.type = sdata->type;
-	conf.mac_addr = dev->dev_addr;
-	res = local->ops->add_interface(local_to_hw(local), &conf);
-	if (res) {
-		if (sdata->type == IEEE80211_IF_TYPE_MNTR)
-			ieee80211_start_hard_monitor(local);
-		return res;
-	}
-
-	if (local->open_count == 0) {
-		res = 0;
-		tasklet_enable(&local->tx_pending_tasklet);
-		tasklet_enable(&local->tasklet);
-		if (local->ops->open)
-			res = local->ops->open(local_to_hw(local));
-		if (res == 0) {
-			res = dev_open(local->mdev);
-			if (res) {
-				if (local->ops->stop)
-					local->ops->stop(local_to_hw(local));
-			} else {
-				res = ieee80211_hw_config(local);
-				if (res && local->ops->stop)
-					local->ops->stop(local_to_hw(local));
-				else if (!res && local->apdev)
-					dev_open(local->apdev);
-			}
-		}
-		if (res) {
-			if (local->ops->remove_interface)
-				local->ops->remove_interface(local_to_hw(local),
-							    &conf);
-			return res;
-		}
+	if (sdata->type == IEEE80211_IF_TYPE_STA ||
+	    sdata->type == IEEE80211_IF_TYPE_IBSS) {
+		if (local->sta_scanning &&
+		    local->scan_dev == dev)
+			conf.bssid = scan_bssid;
+		else
+			conf.bssid = sdata->u.sta.bssid;
+		conf.ssid = sdata->u.sta.ssid;
+		conf.ssid_len = sdata->u.sta.ssid_len;
+		conf.generic_elem = sdata->u.sta.extra_ie;
+		conf.generic_elem_len = sdata->u.sta.extra_ie_len;
+	} else if (sdata->type == IEEE80211_IF_TYPE_AP) {
+		conf.ssid = sdata->u.ap.ssid;
+		conf.ssid_len = sdata->u.ap.ssid_len;
+		conf.generic_elem = sdata->u.ap.generic_elem;
+		conf.generic_elem_len = sdata->u.ap.generic_elem_len;
+		conf.beacon = beacon;
+		conf.beacon_control = control;
 	}
-	local->open_count++;
-
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
-		local->monitors++;
-		local->hw.conf.flags |= IEEE80211_CONF_RADIOTAP;
-	} else
-		ieee80211_if_config(dev);
-
-	if (sdata->type == IEEE80211_IF_TYPE_STA &&
-	    !local->user_space_mlme)
-		netif_carrier_off(dev);
-	else
-		netif_carrier_on(dev);
-
-	netif_start_queue(dev);
-	return 0;
+	return local->ops->config_interface(local_to_hw(local),
+					   dev->ifindex, &conf);
 }
 
+int ieee80211_if_config(struct net_device *dev)
+{
+	return __ieee80211_if_config(dev, NULL, NULL);
+}
 
-static int ieee80211_stop(struct net_device *dev)
+int ieee80211_if_config_beacon(struct net_device *dev)
 {
-	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_tx_control control;
+	struct sk_buff *skb;
 
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR &&
-	    local->open_count > 1 &&
-	    !(local->hw.flags & IEEE80211_HW_MONITOR_DURING_OPER)) {
-		/* remove "soft monitor" interface */
-		local->open_count--;
-		local->monitors--;
-		if (!local->monitors)
-			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
+	if (!(local->hw.flags & IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE))
 		return 0;
-	}
-
-	netif_stop_queue(dev);
-	ieee80211_if_shutdown(dev);
+	skb = ieee80211_beacon_get(local_to_hw(local), dev->ifindex, &control);
+	if (!skb)
+		return -ENOMEM;
+	return __ieee80211_if_config(dev, skb, &control);
+}
 
-	if (sdata->type == IEEE80211_IF_TYPE_MNTR) {
-		local->monitors--;
-		if (!local->monitors)
-			local->hw.conf.flags &= ~IEEE80211_CONF_RADIOTAP;
-	}
+int ieee80211_hw_config(struct ieee80211_local *local)
+{
+	struct ieee80211_hw_mode *mode;
+	struct ieee80211_channel *chan;
+	int ret = 0;
 
-	local->open_count--;
-	if (local->open_count == 0) {
-		if (netif_running(local->mdev))
-			dev_close(local->mdev);
-		if (local->apdev)
-			dev_close(local->apdev);
-		if (local->ops->stop)
-			local->ops->stop(local_to_hw(local));
-		tasklet_disable(&local->tx_pending_tasklet);
-		tasklet_disable(&local->tasklet);
+	if (local->sta_scanning) {
+		chan = local->scan_channel;
+		mode = local->scan_hw_mode;
+	} else {
+		chan = local->oper_channel;
+		mode = local->oper_hw_mode;
 	}
-	if (local->ops->remove_interface) {
-		struct ieee80211_if_init_conf conf;
 
-		conf.if_id = dev->ifindex;
-		conf.type = sdata->type;
-		conf.mac_addr = dev->dev_addr;
-		local->ops->remove_interface(local_to_hw(local), &conf);
-	}
+	local->hw.conf.channel = chan->chan;
+	local->hw.conf.channel_val = chan->val;
+	local->hw.conf.power_level = chan->power_level;
+	local->hw.conf.freq = chan->freq;
+	local->hw.conf.phymode = mode->mode;
+	local->hw.conf.antenna_max = chan->antenna_max;
+	local->hw.conf.chan = chan;
+	local->hw.conf.mode = mode;
 
-	ieee80211_start_hard_monitor(local);
+#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
+	printk(KERN_DEBUG "HW CONFIG: channel=%d freq=%d "
+	       "phymode=%d\n", local->hw.conf.channel, local->hw.conf.freq,
+	       local->hw.conf.phymode);
+#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
 
-	return 0;
+	if (local->ops->config)
+		ret = local->ops->config(local_to_hw(local), &local->hw.conf);
+
+	return ret;
 }
 
 
-static int header_parse_80211(struct sk_buff *skb, unsigned char *haddr)
+struct dev_mc_list *ieee80211_get_mc_list_item(struct ieee80211_hw *hw,
+					       struct dev_mc_list *prev,
+					       void **ptr)
 {
-	memcpy(haddr, skb_mac_header(skb) + 10, ETH_ALEN); /* addr2 */
-	return ETH_ALEN;
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_sub_if_data *sdata = *ptr;
+	struct dev_mc_list *mc;
+
+	if (!prev) {
+		WARN_ON(sdata);
+		sdata = NULL;
+	}
+	if (!prev || !prev->next) {
+		if (sdata)
+			sdata = list_entry(sdata->list.next,
+					   struct ieee80211_sub_if_data, list);
+		else
+			sdata = list_entry(local->sub_if_list.next,
+					   struct ieee80211_sub_if_data, list);
+		if (&sdata->list != &local->sub_if_list)
+			mc = sdata->dev->mc_list;
+		else
+			mc = NULL;
+	} else
+		mc = prev->next;
+
+	*ptr = sdata;
+	return mc;
 }
+EXPORT_SYMBOL(ieee80211_get_mc_list_item);
 
 struct ieee80211_rate *
 ieee80211_get_rate(struct ieee80211_local *local, int phymode, int hw_rate)
@@ -951,142 +1159,6 @@ ieee80211_get_rate(struct ieee80211_loca
 	return NULL;
 }
 
-static void
-ieee80211_fill_frame_info(struct ieee80211_local *local,
-			  struct ieee80211_frame_info *fi,
-			  struct ieee80211_rx_status *status)
-{
-	if (status) {
-		struct timespec ts;
-		struct ieee80211_rate *rate;
-
-		jiffies_to_timespec(jiffies, &ts);
-		fi->hosttime = cpu_to_be64((u64) ts.tv_sec * 1000000 +
-					   ts.tv_nsec / 1000);
-		fi->mactime = cpu_to_be64(status->mactime);
-		switch (status->phymode) {
-		case MODE_IEEE80211A:
-			fi->phytype = htonl(ieee80211_phytype_ofdm_dot11_a);
-			break;
-		case MODE_IEEE80211B:
-			fi->phytype = htonl(ieee80211_phytype_dsss_dot11_b);
-			break;
-		case MODE_IEEE80211G:
-			fi->phytype = htonl(ieee80211_phytype_pbcc_dot11_g);
-			break;
-		case MODE_ATHEROS_TURBO:
-			fi->phytype =
-				htonl(ieee80211_phytype_dsss_dot11_turbo);
-			break;
-		default:
-			fi->phytype = htonl(0xAAAAAAAA);
-			break;
-		}
-		fi->channel = htonl(status->channel);
-		rate = ieee80211_get_rate(local, status->phymode,
-					  status->rate);
-		if (rate) {
-			fi->datarate = htonl(rate->rate);
-			if (rate->flags & IEEE80211_RATE_PREAMBLE2) {
-				if (status->rate == rate->val)
-					fi->preamble = htonl(2); /* long */
-				else if (status->rate == rate->val2)
-					fi->preamble = htonl(1); /* short */
-			} else
-				fi->preamble = htonl(0);
-		} else {
-			fi->datarate = htonl(0);
-			fi->preamble = htonl(0);
-		}
-
-		fi->antenna = htonl(status->antenna);
-		fi->priority = htonl(0xffffffff); /* no clue */
-		fi->ssi_type = htonl(ieee80211_ssi_raw);
-		fi->ssi_signal = htonl(status->ssi);
-		fi->ssi_noise = 0x00000000;
-		fi->encoding = 0;
-	} else {
-		/* clear everything because we really don't know.
-		 * the msg_type field isn't present on monitor frames
-		 * so we don't know whether it will be present or not,
-		 * but it's ok to not clear it since it'll be assigned
-		 * anyway */
-		memset(fi, 0, sizeof(*fi) - sizeof(fi->msg_type));
-
-		fi->ssi_type = htonl(ieee80211_ssi_none);
-	}
-	fi->version = htonl(IEEE80211_FI_VERSION);
-	fi->length = cpu_to_be32(sizeof(*fi) - sizeof(fi->msg_type));
-}
-
-/* this routine is actually not just for this, but also
- * for pushing fake 'management' frames into userspace.
- * it shall be replaced by a netlink-based system. */
-void
-ieee80211_rx_mgmt(struct ieee80211_local *local, struct sk_buff *skb,
-		  struct ieee80211_rx_status *status, u32 msg_type)
-{
-	struct ieee80211_frame_info *fi;
-	const size_t hlen = sizeof(struct ieee80211_frame_info);
-	struct ieee80211_sub_if_data *sdata;
-
-	skb->dev = local->apdev;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(local->apdev);
-
-	if (skb_headroom(skb) < hlen) {
-		I802_DEBUG_INC(local->rx_expand_skb_head);
-		if (pskb_expand_head(skb, hlen, 0, GFP_ATOMIC)) {
-			dev_kfree_skb(skb);
-			return;
-		}
-	}
-
-	fi = (struct ieee80211_frame_info *) skb_push(skb, hlen);
-
-	ieee80211_fill_frame_info(local, fi, status);
-	fi->msg_type = htonl(msg_type);
-
-	sdata->stats.rx_packets++;
-	sdata->stats.rx_bytes += skb->len;
-
-	skb_set_mac_header(skb, 0);
-	skb->ip_summed = CHECKSUM_UNNECESSARY;
-	skb->pkt_type = PACKET_OTHERHOST;
-	skb->protocol = htons(ETH_P_802_2);
-	memset(skb->cb, 0, sizeof(skb->cb));
-	netif_rx(skb);
-}
-
-int ieee80211_radar_status(struct ieee80211_hw *hw, int channel,
-			   int radar, int radar_type)
-{
-	struct sk_buff *skb;
-	struct ieee80211_radar_info *msg;
-	struct ieee80211_local *local = hw_to_local(hw);
-
-	if (!local->apdev)
-		return 0;
-
-	skb = dev_alloc_skb(sizeof(struct ieee80211_frame_info) +
-			    sizeof(struct ieee80211_radar_info));
-
-	if (!skb)
-		return -ENOMEM;
-	skb_reserve(skb, sizeof(struct ieee80211_frame_info));
-
-	msg = (struct ieee80211_radar_info *)
-		skb_put(skb, sizeof(struct ieee80211_radar_info));
-	msg->channel = channel;
-	msg->radar = radar;
-	msg->radar_type = radar_type;
-
-	ieee80211_rx_mgmt(local, skb, NULL, ieee80211_msg_radar);
-	return 0;
-}
-EXPORT_SYMBOL(ieee80211_radar_status);
-
-
 static void ieee80211_stat_refresh(unsigned long data)
 {
 	struct ieee80211_local *local = (struct ieee80211_local *) data;
@@ -1484,69 +1556,6 @@ void ieee80211_tx_status(struct ieee8021
 EXPORT_SYMBOL(ieee80211_tx_status);
 
 
-int ieee80211_if_update_wds(struct net_device *dev, u8 *remote_addr)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	struct sta_info *sta;
-
-	if (compare_ether_addr(remote_addr, sdata->u.wds.remote_addr) == 0)
-		return 0;
-
-	/* Create STA entry for the new peer */
-	sta = sta_info_add(local, dev, remote_addr, GFP_KERNEL);
-	if (!sta)
-		return -ENOMEM;
-	sta_info_put(sta);
-
-	/* Remove STA entry for the old peer */
-	sta = sta_info_get(local, sdata->u.wds.remote_addr);
-	if (sta) {
-		sta_info_put(sta);
-		sta_info_free(sta, 0);
-	} else {
-		printk(KERN_DEBUG "%s: could not find STA entry for WDS link "
-		       "peer " MAC_FMT "\n",
-		       dev->name, MAC_ARG(sdata->u.wds.remote_addr));
-	}
-
-	/* Update WDS link data */
-	memcpy(&sdata->u.wds.remote_addr, remote_addr, ETH_ALEN);
-
-	return 0;
-}
-
-/* Must not be called for mdev and apdev */
-void ieee80211_if_setup(struct net_device *dev)
-{
-	ether_setup(dev);
-	dev->hard_start_xmit = ieee80211_subif_start_xmit;
-	dev->wireless_handlers = &ieee80211_iw_handler_def;
-	dev->do_ioctl = ieee80211_ioctl;
-	dev->set_multicast_list = ieee80211_set_multicast_list;
-	dev->change_mtu = ieee80211_change_mtu;
-	dev->get_stats = ieee80211_get_stats;
-	dev->open = ieee80211_open;
-	dev->stop = ieee80211_stop;
-	dev->uninit = ieee80211_if_reinit;
-	dev->destructor = ieee80211_if_free;
-}
-
-void ieee80211_if_mgmt_setup(struct net_device *dev)
-{
-	ether_setup(dev);
-	dev->hard_start_xmit = ieee80211_mgmt_start_xmit;
-	dev->change_mtu = ieee80211_change_mtu_apdev;
-	dev->get_stats = ieee80211_get_stats;
-	dev->open = ieee80211_mgmt_open;
-	dev->stop = ieee80211_mgmt_stop;
-	dev->type = ARPHRD_IEEE80211_PRISM;
-	dev->hard_header_parse = header_parse_80211;
-	dev->uninit = ieee80211_if_reinit;
-	dev->destructor = ieee80211_if_free;
-}
-
-
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {

-- 

