Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097AbXFUKpy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 06:45:54 -0400
Received: from [131.234.76.190]
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.67)
	(envelope-from <johannes@sipsolutions.net>)
	id 1I1KAi-0000Yr-5T
	for linux-wireless@vger.kernel.org; Thu, 21 Jun 2007 11:45:53 +0100
Subject: [WIP] mac80211: kill mgmt interface
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 21 Jun 2007 11:42:19 +0200
Message-Id: <1182418939.10821.8.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch kills the management interface type now that we can
see transmitted frames on monitor interfaces.

I renamed the req_tx_status to reliable_tx_mntr and the flag
constant as well since that's what they now mean. It is always
set for injected frames so that hostapd can rely on seeing the
frames it sent.

There are a few minor remaining problems:
 * some notifications are now missing
   (radar, key threshold, michael MIC failure, wep unknown key)
   [radar, key threshold aren't used anywhere so can probably
    be left out for now]
 * injected frames aren't sent to AC_VO pending on the radiotap
   definition for access category
 * rate control extra.mgmt_data isn't properly assigned

The biggest problem, however, and I'm not sure how to solve it, is
that hostapd will see either encrypted or unencrypted frames on the
monitor interface depending on whether hardware encryption is used
or not. However, hostapd really needs to see eapol frames to do
whatever it needs to with them. Right now, I don't really have an
idea except maybe to send these packets to hostapd via nl80211,
or to introduce some sort of "decrypted soft monitor" iface.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
[but please don't apply it, just in case
 somebody wants to develop it further]

---
 include/net/mac80211.h          |    8 
 net/mac80211/hostapd_ioctl.h    |    1 
 net/mac80211/ieee80211.c        |  404 ++++------------------------------------
 net/mac80211/ieee80211_common.h |   93 ---------
 net/mac80211/ieee80211_i.h      |   10 
 net/mac80211/ieee80211_iface.c  |   57 -----
 net/mac80211/ieee80211_ioctl.c  |   16 -
 net/mac80211/ieee80211_sta.c    |    1 
 net/mac80211/wme.c              |    4 
 net/mac80211/wpa.c              |   10 
 10 files changed, 55 insertions(+), 549 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-06-21 11:34:18.888645783 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-06-21 11:40:14.208645783 +0200
@@ -26,7 +26,6 @@
 #include <net/cfg80211.h>
 #include <asm/unaligned.h>
 
-#include "ieee80211_common.h"
 #include "ieee80211_i.h"
 #include "ieee80211_rate.h"
 #include "wep.h"
@@ -226,35 +225,10 @@ static void ieee80211_key_threshold_noti
 					   struct ieee80211_key *key,
 					   struct sta_info *sta)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-	struct sk_buff *skb;
-	struct ieee80211_msg_key_notification *msg;
-
-	/* if no one will get it anyway, don't even allocate it.
-	 * unlikely because this is only relevant for APs
-	 * where the device must be open... */
-	if (unlikely(!local->apdev))
-		return;
-
-	skb = dev_alloc_skb(sizeof(struct ieee80211_frame_info) +
-			    sizeof(struct ieee80211_msg_key_notification));
-	if (!skb)
-		return;
-
-	skb_reserve(skb, sizeof(struct ieee80211_frame_info));
-	msg = (struct ieee80211_msg_key_notification *)
-		skb_put(skb, sizeof(struct ieee80211_msg_key_notification));
-	msg->tx_rx_count = key->tx_rx_count;
-	memcpy(msg->ifname, dev->name, IFNAMSIZ);
-	if (sta)
-		memcpy(msg->addr, sta->addr, ETH_ALEN);
-	else
-		memset(msg->addr, 0xff, ETH_ALEN);
-
-	key->tx_rx_count = 0;
-
-	ieee80211_rx_mgmt(local, skb, NULL,
-			  ieee80211_msg_key_threshold_notification);
+	/*
+	 * XXX: notify userspace of the current key->tx_rx_count
+	 * and then set it to 0
+	 */
 }
 
 
@@ -425,8 +399,11 @@ ieee80211_tx_h_rate_ctrl(struct ieee8021
 
 	memset(&extra, 0, sizeof(extra));
 	extra.mode = tx->u.tx.mode;
-	extra.mgmt_data = tx->sdata &&
-		tx->sdata->type == IEEE80211_IF_TYPE_MGMT;
+	/*
+	 * XXX: need to set this again based on radiotap injection, but
+	 * current rate control algorithms don't use it.
+	 */
+	extra.mgmt_data = 0;
 	extra.ethertype = tx->ethertype;
 
 	tx->u.tx.rate = rate_control_get_rate(tx->local, tx->dev, tx->skb,
@@ -961,7 +938,7 @@ ieee80211_tx_h_check_assoc(struct ieee80
 		return TXRX_CONTINUE;
 	}
 
-	if (unlikely(!tx->u.tx.mgmt_interface && tx->sdata->ieee802_1x &&
+	if (unlikely(tx->sdata->ieee802_1x &&
 		     !(sta_flags & WLAN_STA_AUTHORIZED))) {
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 		printk(KERN_DEBUG "%s: dropped frame to " MAC_FMT
@@ -1158,7 +1135,8 @@ static int __ieee80211_parse_tx_radiotap
 	 */
 	control->flags &= ~(IEEE80211_TXCTL_USE_RTS_CTS |
 			    IEEE80211_TXCTL_USE_CTS_PROTECT);
-	control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
+	control->flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT |
+			  IEEE80211_TXCTL_RELIABLE_TX_MONITOR;
 
 	/*
 	 * for every radiotap entry that is present
@@ -1435,7 +1413,7 @@ static int __ieee80211_tx(struct ieee802
 }
 
 static int ieee80211_tx(struct net_device *dev, struct sk_buff *skb,
-			struct ieee80211_tx_control *control, int mgmt)
+			struct ieee80211_tx_control *control)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct sta_info *sta;
@@ -1457,7 +1435,6 @@ static int ieee80211_tx(struct net_devic
 	}
 
 	sta = tx.sta;
-	tx.u.tx.mgmt_interface = mgmt;
 	tx.u.tx.mode = local->hw.conf.mode;
 
 	for (handler = local->tx_handlers; *handler != NULL; handler++) {
@@ -1648,16 +1625,15 @@ static int ieee80211_master_start_xmit(s
 
 	control.ifindex = odev->ifindex;
 	control.type = osdata->type;
-	if (pkt_data->req_tx_status)
-		control.flags |= IEEE80211_TXCTL_REQ_TX_STATUS;
+	if (pkt_data->reliable_tx_mntr)
+		control.flags |= IEEE80211_TXCTL_RELIABLE_TX_MONITOR;
 	if (pkt_data->do_not_encrypt)
 		control.flags |= IEEE80211_TXCTL_DO_NOT_ENCRYPT;
 	if (pkt_data->requeue)
 		control.flags |= IEEE80211_TXCTL_REQUEUE;
 	control.queue = pkt_data->queue;
 
-	ret = ieee80211_tx(odev, skb, &control,
-			   control.type == IEEE80211_IF_TYPE_MGMT);
+	ret = ieee80211_tx(odev, skb, &control);
 	dev_put(odev);
 
 	return ret;
@@ -1688,7 +1664,6 @@ int ieee80211_monitor_start_xmit(struct 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(pkt_data, 0, sizeof(*pkt_data));
 	pkt_data->ifindex = dev->ifindex;
-	pkt_data->mgmt_iface = 0;
 	pkt_data->do_not_encrypt = 1;
 
 	/* above needed because we set skb device to master */
@@ -1886,7 +1861,6 @@ int ieee80211_subif_start_xmit(struct sk
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
 	pkt_data->ifindex = dev->ifindex;
-	pkt_data->mgmt_iface = (sdata->type == IEEE80211_IF_TYPE_MGMT);
 	pkt_data->do_not_encrypt = no_encrypt;
 
 	skb->dev = local->mdev;
@@ -1913,66 +1887,6 @@ int ieee80211_subif_start_xmit(struct sk
 }
 
 
-/*
- * This is the transmit routine for the 802.11 type interfaces
- * called by upper layers of the linux networking
- * stack when it has a frame to transmit
- */
-static int
-ieee80211_mgmt_start_xmit(struct sk_buff *skb, struct net_device *dev)
-{
-	struct ieee80211_sub_if_data *sdata;
-	struct ieee80211_tx_packet_data *pkt_data;
-	struct ieee80211_hdr *hdr;
-	u16 fc;
-
-	sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-
-	if (skb->len < 10) {
-		dev_kfree_skb(skb);
-		return 0;
-	}
-
-	if (skb_headroom(skb) < sdata->local->tx_headroom) {
-		if (pskb_expand_head(skb, sdata->local->tx_headroom,
-				     0, GFP_ATOMIC)) {
-			dev_kfree_skb(skb);
-			return 0;
-		}
-	}
-
-	hdr = (struct ieee80211_hdr *) skb->data;
-	fc = le16_to_cpu(hdr->frame_control);
-
-	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
-	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
-	pkt_data->ifindex = sdata->dev->ifindex;
-	pkt_data->mgmt_iface = (sdata->type == IEEE80211_IF_TYPE_MGMT);
-
-	skb->priority = 20; /* use hardcoded priority for mgmt TX queue */
-	skb->dev = sdata->local->mdev;
-
-	/*
-	 * We're using the protocol field of the the frame control header
-	 * to request TX callback for hostapd. BIT(1) is checked.
-	 */
-	if ((fc & BIT(1)) == BIT(1)) {
-		pkt_data->req_tx_status = 1;
-		fc &= ~BIT(1);
-		hdr->frame_control = cpu_to_le16(fc);
-	}
-
-	pkt_data->do_not_encrypt = !(fc & IEEE80211_FCTL_PROTECTED);
-
-	sdata->stats.tx_packets++;
-	sdata->stats.tx_bytes += skb->len;
-
-	dev_queue_xmit(skb);
-
-	return 0;
-}
-
-
 static void ieee80211_beacon_add_tim(struct ieee80211_local *local,
 				     struct ieee80211_if_ap *bss,
 				     struct sk_buff *skb)
@@ -2387,23 +2301,6 @@ static int ieee80211_change_mtu(struct n
 }
 
 
-static int ieee80211_change_mtu_apdev(struct net_device *dev, int new_mtu)
-{
-	/* FIX: what would be proper limits for MTU?
-	 * This interface uses 802.11 frames. */
-	if (new_mtu < 256 || new_mtu > IEEE80211_MAX_DATA_LEN) {
-		printk(KERN_WARNING "%s: invalid MTU %d\n",
-		       dev->name, new_mtu);
-		return -EINVAL;
-	}
-
-#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
-	printk(KERN_DEBUG "%s: setting MTU %d\n", dev->name, new_mtu);
-#endif /* CONFIG_MAC80211_VERBOSE_DEBUG */
-	dev->mtu = new_mtu;
-	return 0;
-}
-
 enum netif_tx_lock_class {
 	TX_LOCK_NORMAL,
 	TX_LOCK_MASTER,
@@ -2567,20 +2464,6 @@ static int ieee80211_master_stop(struct 
 	return 0;
 }
 
-static int ieee80211_mgmt_open(struct net_device *dev)
-{
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
-
-	if (!netif_running(local->mdev))
-		return -EOPNOTSUPP;
-	return 0;
-}
-
-static int ieee80211_mgmt_stop(struct net_device *dev)
-{
-	return 0;
-}
-
 /* Check if running monitor interfaces should go to a "soft monitor" mode
  * and switch them if necessary. */
 static inline void ieee80211_start_soft_monitor(struct ieee80211_local *local)
@@ -2672,8 +2555,6 @@ static int ieee80211_open(struct net_dev
 				res = ieee80211_hw_config(local);
 				if (res && local->ops->stop)
 					local->ops->stop(local_to_hw(local));
-				else if (!res && local->apdev)
-					dev_open(local->apdev);
 			}
 		}
 		if (res) {
@@ -2733,8 +2614,6 @@ static int ieee80211_stop(struct net_dev
 	if (local->open_count == 0) {
 		if (netif_running(local->mdev))
 			dev_close(local->mdev);
-		if (local->apdev)
-			dev_close(local->apdev);
 		if (local->ops->stop)
 			local->ops->stop(local_to_hw(local));
 		tasklet_disable(&local->tx_pending_tasklet);
@@ -3098,112 +2977,6 @@ ieee80211_get_rate(struct ieee80211_loca
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
 
 static void
 ieee80211_rx_monitor(struct net_device *dev, struct sk_buff *skb,
@@ -3271,27 +3044,7 @@ ieee80211_rx_monitor(struct net_device *
 int ieee80211_radar_status(struct ieee80211_hw *hw, int channel,
 			   int radar, int radar_type)
 {
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
+	/* XXX: notify userspace of radar */
 	return 0;
 }
 EXPORT_SYMBOL(ieee80211_radar_status);
@@ -3683,34 +3436,25 @@ ieee80211_rx_h_check(struct ieee80211_tx
 	} else
 		rx->skb->pkt_type = PACKET_OTHERHOST;
 
-	/* Drop disallowed frame classes based on STA auth/assoc state;
+	/*
+	 * Drop disallowed frame classes based on STA auth/assoc state;
 	 * IEEE 802.11, Chap 5.5.
 	 *
-	 * 80211.o does filtering only based on association state, i.e., it
-	 * drops Class 3 frames from not associated stations. hostapd sends
-	 * deauth/disassoc frames when needed. In addition, hostapd is
-	 * responsible for filtering on both auth and assoc states.
+	 * We do filtering only based on association state, i.e., we
+	 * drop Class 3 frames from not associated stations. hostapd sends
+	 * deauth/disassoc frames when needed, filtering on both auth and
+	 * assoc states.
 	 */
 	if (unlikely(((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA ||
 		      ((rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_CTL &&
 		       (rx->fc & IEEE80211_FCTL_STYPE) == IEEE80211_STYPE_PSPOLL)) &&
 		     rx->sdata->type != IEEE80211_IF_TYPE_IBSS &&
 		     (!rx->sta || !(rx->sta->flags & WLAN_STA_ASSOC)))) {
-		if ((!(rx->fc & IEEE80211_FCTL_FROMDS) &&
-		     !(rx->fc & IEEE80211_FCTL_TODS) &&
-		     (rx->fc & IEEE80211_FCTL_FTYPE) == IEEE80211_FTYPE_DATA)
-		    || !rx->u.rx.ra_match) {
-			/* Drop IBSS frames and frames for other hosts
-			 * silently. */
-			return TXRX_DROP;
-		}
-
-		if (!rx->local->apdev)
-			return TXRX_DROP;
-
-		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-				  ieee80211_msg_sta_not_assoc);
-		return TXRX_QUEUED;
+		/*
+		 * hostapd will see the frame on the monitor iface and
+		 * be able to take action, on this interface drop it.
+		 */
+		return TXRX_DROP;
 	}
 
 	if (rx->sdata->type == IEEE80211_IF_TYPE_STA)
@@ -3744,12 +3488,8 @@ ieee80211_rx_h_check(struct ieee80211_tx
 				       MAC_ARG(hdr->addr1),
 				       MAC_ARG(hdr->addr2),
 				       MAC_ARG(hdr->addr3));
-				if (!rx->local->apdev)
-					return TXRX_DROP;
-				ieee80211_rx_mgmt(
-					rx->local, rx->skb, rx->u.rx.status,
-					ieee80211_msg_wep_frame_unknown_key);
-				return TXRX_QUEUED;
+				/* XXX: notify userspace of this frame? */
+				return TXRX_DROP;
 			}
 		}
 	}
@@ -3896,13 +3636,8 @@ ieee80211_rx_h_802_1x_pae(struct ieee802
 {
 	if (rx->sdata->eapol && ieee80211_is_eapol(rx->skb) &&
 	    rx->sdata->type != IEEE80211_IF_TYPE_STA && rx->u.rx.ra_match) {
-		/* Pass both encrypted and unencrypted EAPOL frames to user
-		 * space for processing. */
-		if (!rx->local->apdev)
-			return TXRX_DROP;
-		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-				  ieee80211_msg_normal);
-		return TXRX_QUEUED;
+		/* hostapd sees them on monitor iface */
+		return TXRX_DROP;
 	}
 
 	if (unlikely(rx->sdata->ieee802_1x &&
@@ -3959,13 +3694,8 @@ ieee80211_rx_h_mgmt(struct ieee80211_txr
 	     sdata->type == IEEE80211_IF_TYPE_IBSS) &&
 	    !rx->local->user_space_mlme) {
 		ieee80211_sta_rx_mgmt(rx->dev, rx->skb, rx->u.rx.status);
-	} else {
-		/* Management frames are sent to hostapd for processing */
-		if (!rx->local->apdev)
-			return TXRX_DROP;
-		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-				  ieee80211_msg_normal);
-	}
+	} else
+		return TXRX_DROP;
 	return TXRX_QUEUED;
 }
 
@@ -4072,12 +3802,8 @@ static void ieee80211_rx_michael_mic_rep
 	/* TODO: consider verifying the MIC error report with software
 	 * implementation if we get too many spurious reports from the
 	 * hardware. */
-	if (!rx->local->apdev)
-		goto ignore;
-	ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-			  ieee80211_msg_michael_mic_failure);
-	return;
 
+	/* XXX: notify hostapd */
  ignore:
 	dev_kfree_skb(rx->skb);
 	rx->skb = NULL;
@@ -4488,8 +4214,12 @@ void ieee80211_tx_status_irqsafe(struct 
 	memcpy(skb->cb, &saved, sizeof(saved));
 
 	skb->pkt_type = IEEE80211_TX_STATUS_MSG;
-	skb_queue_tail(status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS ?
-		       &local->skb_queue : &local->skb_queue_unreliable, skb);
+
+	if (status->control.flags & IEEE80211_TXCTL_RELIABLE_TX_MONITOR)
+		skb_queue_tail(&local->skb_queue, skb);
+	else
+		skb_queue_tail(&local->skb_queue_unreliable, skb);
+
 	tmp = skb_queue_len(&local->skb_queue) +
 		skb_queue_len(&local->skb_queue_unreliable);
 	while (tmp > IEEE80211_IRQSAFE_QUEUE_LIMIT &&
@@ -4554,8 +4284,8 @@ static void ieee80211_remove_tx_extra(st
 
 	pkt_data = (struct ieee80211_tx_packet_data *)skb->cb;
 	pkt_data->ifindex = control->ifindex;
-	pkt_data->mgmt_iface = (control->type == IEEE80211_IF_TYPE_MGMT);
-	pkt_data->req_tx_status = !!(control->flags & IEEE80211_TXCTL_REQ_TX_STATUS);
+	pkt_data->reliable_tx_mntr = !!(control->flags &
+					IEEE80211_TXCTL_RELIABLE_TX_MONITOR);
 	pkt_data->do_not_encrypt = !!(control->flags & IEEE80211_TXCTL_DO_NOT_ENCRYPT);
 	pkt_data->requeue = !!(control->flags & IEEE80211_TXCTL_REQUEUE);
 	pkt_data->queue = control->queue;
@@ -4610,7 +4340,6 @@ void ieee80211_tx_status(struct ieee8021
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = hw_to_local(hw);
 	u16 frag, type;
-	u32 msg_type;
 	struct ieee80211_tx_status_rtap_hdr *rthdr;
 	struct ieee80211_sub_if_data *sdata;
 	int monitors;
@@ -4725,34 +4454,14 @@ void ieee80211_tx_status(struct ieee8021
 			local->dot11FailedCount++;
 	}
 
-	msg_type = (status->flags & IEEE80211_TX_STATUS_ACK) ?
-		ieee80211_msg_tx_callback_ack : ieee80211_msg_tx_callback_fail;
-
-	/* this was a transmitted frame, but now we want to reuse it */
-	skb_orphan(skb);
-
-	if ((status->control.flags & IEEE80211_TXCTL_REQ_TX_STATUS) &&
-	    local->apdev) {
-		if (local->monitors) {
-			skb2 = skb_clone(skb, GFP_ATOMIC);
-		} else {
-			skb2 = skb;
-			skb = NULL;
-		}
-
-		if (skb2)
-			/* Send frame to hostapd */
-			ieee80211_rx_mgmt(local, skb2, NULL, msg_type);
-
-		if (!skb)
-			return;
-	}
-
 	if (!local->monitors) {
 		dev_kfree_skb(skb);
 		return;
 	}
 
+	/* this was a transmitted frame, but now we want to reuse it */
+	skb_orphan(skb);
+
 	/* send frame to monitor interfaces now */
 
 	if (skb_headroom(skb) < sizeof(*rthdr)) {
@@ -4911,7 +4620,7 @@ int ieee80211_if_update_wds(struct net_d
 	return 0;
 }
 
-/* Must not be called for mdev and apdev */
+/* Must not be called for mdev */
 void ieee80211_if_setup(struct net_device *dev)
 {
 	ether_setup(dev);
@@ -4927,28 +4636,13 @@ void ieee80211_if_setup(struct net_devic
 	dev->destructor = ieee80211_if_free;
 }
 
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
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name)
 {
 	struct rate_control_ref *ref, *old;
 
 	ASSERT_RTNL();
-	if (local->open_count || netif_running(local->mdev) ||
-	    (local->apdev && netif_running(local->apdev)))
+	if (local->open_count || netif_running(local->mdev))
 		return -EBUSY;
 
 	ref = rate_control_alloc(name, local);
@@ -5255,8 +4949,6 @@ void ieee80211_unregister_hw(struct ieee
 	BUG_ON(local->reg_state != IEEE80211_DEV_REGISTERED);
 
 	local->reg_state = IEEE80211_DEV_UNREGISTERED;
-	if (local->apdev)
-		ieee80211_if_del_mgmt(local);
 
 	write_lock_bh(&local->sub_if_lock);
 	list_replace_init(&local->sub_if_list, &tmp_list);
--- wireless-dev.orig/net/mac80211/hostapd_ioctl.h	2007-06-21 11:34:18.908645783 +0200
+++ wireless-dev/net/mac80211/hostapd_ioctl.h	2007-06-21 11:35:20.768645783 +0200
@@ -68,7 +68,6 @@ enum {
 	PRISM2_PARAM_RADAR_DETECT = 1043,
 	PRISM2_PARAM_SPECTRUM_MGMT = 1044,
 	PRISM2_PARAM_USER_SPACE_MLME = 1045,
-	PRISM2_PARAM_MGMT_IF = 1046,
 };
 
 /* PRISM2_IOCTL_HOSTAPD ioctl() cmd:
--- wireless-dev.orig/net/mac80211/ieee80211_i.h	2007-06-21 11:34:18.998645783 +0200
+++ wireless-dev/net/mac80211/ieee80211_i.h	2007-06-21 11:39:58.038645783 +0200
@@ -135,7 +135,6 @@ struct ieee80211_txrx_data {
 			 * when using CTS protection with IEEE 802.11g. */
 			struct ieee80211_rate *last_frag_rate;
 			int last_frag_hwrate;
-			int mgmt_interface;
 
 			/* Extra fragments (in addition to the first fragment
 			 * in skb) */
@@ -164,10 +163,9 @@ struct ieee80211_txrx_data {
 struct ieee80211_tx_packet_data {
 	int ifindex;
 	unsigned long jiffies;
-	unsigned int req_tx_status:1;
+	unsigned int reliable_tx_mntr:1;
 	unsigned int do_not_encrypt:1;
 	unsigned int requeue:1;
-	unsigned int mgmt_iface:1;
 	unsigned int queue:4;
 };
 
@@ -457,7 +455,6 @@ struct ieee80211_local {
 	struct list_head modes_list;
 
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
-	struct net_device *apdev; /* wlan#ap - management frames (hostapd) */
 	int open_count;
 	int monitors;
 	struct iw_statistics wstats;
@@ -793,8 +790,6 @@ ieee80211_key_data2conf(struct ieee80211
 struct ieee80211_key *ieee80211_key_alloc(struct ieee80211_sub_if_data *sdata,
 					  int idx, size_t key_len, gfp_t flags);
 void ieee80211_key_free(struct ieee80211_key *key);
-void ieee80211_rx_mgmt(struct ieee80211_local *local, struct sk_buff *skb,
-		       struct ieee80211_rx_status *status, u32 msg_type);
 void ieee80211_prepare_rates(struct ieee80211_local *local,
 			     struct ieee80211_hw_mode *mode);
 void ieee80211_tx_set_iswep(struct ieee80211_txrx_data *tx);
@@ -802,7 +797,6 @@ int ieee80211_if_update_wds(struct net_d
 int ieee80211_monitor_start_xmit(struct sk_buff *skb, struct net_device *dev);
 int ieee80211_subif_start_xmit(struct sk_buff *skb, struct net_device *dev);
 void ieee80211_if_setup(struct net_device *dev);
-void ieee80211_if_mgmt_setup(struct net_device *dev);
 int ieee80211_init_rate_ctrl_alg(struct ieee80211_local *local,
 				 const char *name);
 struct net_device_stats *ieee80211_dev_stats(struct net_device *dev);
@@ -898,8 +892,6 @@ void __ieee80211_if_del(struct ieee80211
 int ieee80211_if_remove(struct net_device *dev, const char *name, int id);
 void ieee80211_if_free(struct net_device *dev);
 void ieee80211_if_sdata_init(struct ieee80211_sub_if_data *sdata);
-int ieee80211_if_add_mgmt(struct ieee80211_local *local);
-void ieee80211_if_del_mgmt(struct ieee80211_local *local);
 
 /* regdomain.c */
 void ieee80211_regdomain_init(void);
--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-06-21 11:34:19.028645783 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-06-21 11:35:20.768645783 +0200
@@ -97,60 +97,6 @@ fail:
 	return ret;
 }
 
-int ieee80211_if_add_mgmt(struct ieee80211_local *local)
-{
-	struct net_device *ndev;
-	struct ieee80211_sub_if_data *nsdata;
-	int ret;
-
-	ASSERT_RTNL();
-
-	ndev = alloc_netdev(sizeof(struct ieee80211_sub_if_data), "wmgmt%d",
-			    ieee80211_if_mgmt_setup);
-	if (!ndev)
-		return -ENOMEM;
-	ret = dev_alloc_name(ndev, ndev->name);
-	if (ret < 0)
-		goto fail;
-
-	memcpy(ndev->dev_addr, local->hw.wiphy->perm_addr, ETH_ALEN);
-	SET_NETDEV_DEV(ndev, wiphy_dev(local->hw.wiphy));
-
-	nsdata = IEEE80211_DEV_TO_SUB_IF(ndev);
-	ndev->ieee80211_ptr = &nsdata->wdev;
-	nsdata->wdev.wiphy = local->hw.wiphy;
-	nsdata->type = IEEE80211_IF_TYPE_MGMT;
-	nsdata->dev = ndev;
-	nsdata->local = local;
-	ieee80211_if_sdata_init(nsdata);
-
-	ret = register_netdevice(ndev);
-	if (ret)
-		goto fail;
-
-	ieee80211_debugfs_add_netdev(nsdata);
-
-	if (local->open_count > 0)
-		dev_open(ndev);
-	local->apdev = ndev;
-	return 0;
-
-fail:
-	free_netdev(ndev);
-	return ret;
-}
-
-void ieee80211_if_del_mgmt(struct ieee80211_local *local)
-{
-	struct net_device *apdev;
-
-	ASSERT_RTNL();
-	apdev = local->apdev;
-	ieee80211_debugfs_remove_netdev(IEEE80211_DEV_TO_SUB_IF(apdev));
-	local->apdev = NULL;
-	unregister_netdevice(apdev);
-}
-
 void ieee80211_if_set_type(struct net_device *dev, int type)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
@@ -362,11 +308,8 @@ int ieee80211_if_remove(struct net_devic
 
 void ieee80211_if_free(struct net_device *dev)
 {
-	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 
-	/* local->apdev must be NULL when freeing management interface */
-	BUG_ON(dev == local->apdev);
 	ieee80211_if_sdata_deinit(sdata);
 	free_netdev(dev);
 }
--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-06-21 11:34:19.088645783 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-06-21 11:35:20.768645783 +0200
@@ -2476,16 +2476,6 @@ static int ieee80211_ioctl_prism2_param(
 	case PRISM2_PARAM_SPECTRUM_MGMT:
 		local->hw.conf.spect_mgmt = value;
 		break;
-	case PRISM2_PARAM_MGMT_IF:
-		if (value == 1) {
-			if (!local->apdev)
-				ret = ieee80211_if_add_mgmt(local);
-		} else if (value == 0) {
-			if (local->apdev)
-				ieee80211_if_del_mgmt(local);
-		} else
-			ret = -EINVAL;
-		break;
 	case PRISM2_PARAM_USER_SPACE_MLME:
 		local->user_space_mlme = value;
 		break;
@@ -2663,12 +2653,6 @@ static int ieee80211_ioctl_get_prism2_pa
 		else
 			*param = !!sdata->u.sta.wmm_enabled;
 		break;
-	case PRISM2_PARAM_MGMT_IF:
-		if (local->apdev)
-			*param = local->apdev->ifindex;
-		else
-			ret = -ENOENT;
-		break;
 	case PRISM2_PARAM_USER_SPACE_MLME:
 		*param = local->user_space_mlme;
 		break;
--- wireless-dev.orig/net/mac80211/wpa.c	2007-06-21 11:34:19.108645783 +0200
+++ wireless-dev/net/mac80211/wpa.c	2007-06-21 11:35:20.768645783 +0200
@@ -14,7 +14,6 @@
 #include <net/iw_handler.h>
 
 #include <net/mac80211.h>
-#include "ieee80211_common.h"
 #include "ieee80211_i.h"
 #include "michael.h"
 #include "tkip.h"
@@ -265,13 +264,8 @@ ieee80211_rx_h_michael_mic_verify(struct
 			kfree(buf);
 		} while (0);
 
-		if (!rx->local->apdev)
-			return TXRX_DROP;
-
-		ieee80211_rx_mgmt(rx->local, rx->skb, rx->u.rx.status,
-				  ieee80211_msg_michael_mic_failure);
-
-		return TXRX_QUEUED;
+		/* XXX: notify userspace of mic failure */
+		return TXRX_DROP;
 	}
 
  remove_mic:
--- wireless-dev.orig/include/net/mac80211.h	2007-06-21 11:34:19.338645783 +0200
+++ wireless-dev/include/net/mac80211.h	2007-06-21 11:39:35.808645783 +0200
@@ -174,8 +174,9 @@ struct ieee80211_tx_control {
 			   * specific value for the rate (from
 			   * struct ieee80211_rate) */
 
-#define IEEE80211_TXCTL_REQ_TX_STATUS	(1<<0)/* request TX status callback for
-						* this frame */
+#define IEEE80211_TXCTL_RELIABLE_TX_MONITOR (1<<0) /* reliable TX monitor for
+						    * for this frame (internal)
+						    */
 #define IEEE80211_TXCTL_DO_NOT_ENCRYPT	(1<<1) /* send this frame without
 						* encryption; e.g., for EAPOL
 						* frames */
@@ -315,8 +316,6 @@ struct ieee80211_conf {
  * enum ieee80211_if_types - types of 802.11 network interfaces
  *
  * @IEEE80211_IF_TYPE_AP: interface in AP mode.
- * @IEEE80211_IF_TYPE_MGMT: special interface for communication with hostap
- *	daemon. Drivers should never see this type.
  * @IEEE80211_IF_TYPE_STA: interface in STA (client) mode.
  * @IEEE80211_IF_TYPE_IBSS: interface in IBSS (ad-hoc) mode.
  * @IEEE80211_IF_TYPE_MNTR: interface in monitor (rfmon) mode.
@@ -325,7 +324,6 @@ struct ieee80211_conf {
  */
 enum ieee80211_if_types {
 	IEEE80211_IF_TYPE_AP = 0x00000000,
-	IEEE80211_IF_TYPE_MGMT = 0x00000001,
 	IEEE80211_IF_TYPE_STA = 0x00000002,
 	IEEE80211_IF_TYPE_IBSS = 0x00000003,
 	IEEE80211_IF_TYPE_MNTR = 0x00000004,
--- wireless-dev.orig/net/mac80211/ieee80211_sta.c	2007-06-21 11:34:19.178645783 +0200
+++ wireless-dev/net/mac80211/ieee80211_sta.c	2007-06-21 11:35:20.778645783 +0200
@@ -459,7 +459,6 @@ static void ieee80211_sta_tx(struct net_
 	pkt_data = (struct ieee80211_tx_packet_data *) skb->cb;
 	memset(pkt_data, 0, sizeof(struct ieee80211_tx_packet_data));
 	pkt_data->ifindex = sdata->dev->ifindex;
-	pkt_data->mgmt_iface = (sdata->type == IEEE80211_IF_TYPE_MGMT);
 	pkt_data->do_not_encrypt = !encrypt;
 
 	dev_queue_xmit(skb);
--- wireless-dev.orig/net/mac80211/wme.c	2007-06-21 11:34:19.198645783 +0200
+++ wireless-dev/net/mac80211/wme.c	2007-06-21 11:35:20.838645783 +0200
@@ -168,8 +168,6 @@ static inline int classify80211(struct s
 	struct ieee80211_local *local = wdev_priv(qd->dev->ieee80211_ptr);
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(qd->dev);
 	struct ieee80211_if_sta *ifsta = &sdata->u.sta;
-	struct ieee80211_tx_packet_data *pkt_data =
-		(struct ieee80211_tx_packet_data *) skb->cb;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	unsigned short fc = le16_to_cpu(hdr->frame_control);
 	int qos, tsid, dir;
@@ -182,7 +180,7 @@ static inline int classify80211(struct s
 		return IEEE80211_TX_QUEUE_DATA0;
 	}
 
-	if (unlikely(pkt_data->mgmt_iface)) {
+	if (0 /* XXX: inject flag? */) {
 		/* Data frames from hostapd (mainly, EAPOL) use AC_VO
 		* and they will include QoS control fields if
 		* the target STA is using WME. */
--- wireless-dev.orig/net/mac80211/ieee80211_common.h	2007-06-21 11:34:19.268645783 +0200
+++ /dev/null	1970-01-01 00:00:00.000000000 +0000
@@ -1,93 +0,0 @@
-/*
- * IEEE 802.11 driver (80211.o) -- hostapd interface
- * Copyright 2002-2004, Instant802 Networks, Inc.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License version 2 as
- * published by the Free Software Foundation.
- */
-
-#ifndef IEEE80211_COMMON_H
-#define IEEE80211_COMMON_H
-
-#include <linux/types.h>
-
-/*
- * This is common header information with user space. It is used on all
- * frames sent to wlan#ap interface.
- */
-
-#define IEEE80211_FI_VERSION 0x80211001
-
-struct ieee80211_frame_info {
-	__be32 version;
-	__be32 length;
-	__be64 mactime;
-	__be64 hosttime;
-	__be32 phytype;
-	__be32 channel;
-	__be32 datarate;
-	__be32 antenna;
-	__be32 priority;
-	__be32 ssi_type;
-	__be32 ssi_signal;
-	__be32 ssi_noise;
-	__be32 preamble;
-	__be32 encoding;
-
-	/* Note: this structure is otherwise identical to capture format used
-	 * in linux-wlan-ng, but this additional field is used to provide meta
-	 * data about the frame to hostapd. This was the easiest method for
-	 * providing this information, but this might change in the future. */
-	__be32 msg_type;
-} __attribute__ ((packed));
-
-
-enum ieee80211_msg_type {
-	ieee80211_msg_normal = 0,
-	ieee80211_msg_tx_callback_ack = 1,
-	ieee80211_msg_tx_callback_fail = 2,
-	/* hole at 3, was ieee80211_msg_passive_scan but unused */
-	ieee80211_msg_wep_frame_unknown_key = 4,
-	ieee80211_msg_michael_mic_failure = 5,
-	/* hole at 6, was monitor but never sent to userspace */
-	ieee80211_msg_sta_not_assoc = 7,
-	/* 8 was ieee80211_msg_set_aid_for_sta */
-	ieee80211_msg_key_threshold_notification = 9,
-	ieee80211_msg_radar = 11,
-};
-
-struct ieee80211_msg_key_notification {
-	int tx_rx_count;
-	char ifname[IFNAMSIZ];
-	u8 addr[ETH_ALEN]; /* ff:ff:ff:ff:ff:ff for broadcast keys */
-};
-
-
-enum ieee80211_phytype {
-	ieee80211_phytype_fhss_dot11_97  = 1,
-	ieee80211_phytype_dsss_dot11_97  = 2,
-	ieee80211_phytype_irbaseband     = 3,
-	ieee80211_phytype_dsss_dot11_b   = 4,
-	ieee80211_phytype_pbcc_dot11_b   = 5,
-	ieee80211_phytype_ofdm_dot11_g   = 6,
-	ieee80211_phytype_pbcc_dot11_g   = 7,
-	ieee80211_phytype_ofdm_dot11_a   = 8,
-	ieee80211_phytype_dsss_dot11_turbog = 255,
-	ieee80211_phytype_dsss_dot11_turbo = 256,
-};
-
-enum ieee80211_ssi_type {
-	ieee80211_ssi_none = 0,
-	ieee80211_ssi_norm = 1, /* normalized, 0-1000 */
-	ieee80211_ssi_dbm = 2,
-	ieee80211_ssi_raw = 3, /* raw SSI */
-};
-
-struct ieee80211_radar_info {
-		int channel;
-		int radar;
-		int radar_type;
-};
-
-#endif /* IEEE80211_COMMON_H */


