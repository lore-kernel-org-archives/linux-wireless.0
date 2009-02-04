Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46256 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752166AbZBDXGI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:06:08 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so4024043ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:06:07 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 01/16] orinoco: address leading and trailing whitespace
Date: Wed,  4 Feb 2009 23:05:43 +0000
Message-Id: <1233788758-9850-2-git-send-email-kilroyd@googlemail.com> (sfid-20090205_000616_638408_AF0A650E)
In-Reply-To: <1233788758-9850-1-git-send-email-kilroyd@googlemail.com>
References: <1233788758-9850-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the following checkpatch errors from orinoco.c

ERROR: trailing whitespace
ERROR: code indent should use tabs where possible
WARNING: suspect code indent for conditional statements

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/orinoco.c |  106 ++++++++++++++++----------------
 1 files changed, 53 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index e082ef0..0e21eaf 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -798,7 +798,7 @@ static int orinoco_stop(struct net_device *dev)
 static struct net_device_stats *orinoco_get_stats(struct net_device *dev)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
-	
+
 	return &priv->stats;
 }
 
@@ -914,13 +914,13 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 		       dev->name);
 		return NETDEV_TX_BUSY;
 	}
-	
+
 	if (netif_queue_stopped(dev)) {
-		printk(KERN_DEBUG "%s: Tx while transmitter busy!\n", 
+		printk(KERN_DEBUG "%s: Tx while transmitter busy!\n",
 		       dev->name);
 		return NETDEV_TX_BUSY;
 	}
-	
+
 	if (orinoco_lock(priv, &flags) != 0) {
 		printk(KERN_ERR "%s: orinoco_xmit() called while hw_unavailable\n",
 		       dev->name);
@@ -929,8 +929,8 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	if (! netif_carrier_ok(dev) || (priv->iw_mode == IW_MODE_MONITOR)) {
 		/* Oops, the firmware hasn't established a connection,
-                   silently drop the packet (this seems to be the
-                   safest approach). */
+		   silently drop the packet (this seems to be the
+		   safest approach). */
 		goto drop;
 	}
 
@@ -1141,10 +1141,10 @@ static void __orinoco_ev_txexc(struct net_device *dev, hermes_t *hw)
 		       dev->name, fid, err);
 		return;
 	}
-	
+
 	DEBUG(1, "%s: Tx error, err %d (FID=%04X)\n", dev->name,
 	      err, fid);
-    
+
 	/* We produce a TXDROP event only for retry or lifetime
 	 * exceeded, because that's the only status that really mean
 	 * that this particular node went away.
@@ -1334,7 +1334,7 @@ static void orinoco_rx_monitor(struct net_device *dev, u16 rxfid,
 	skb->ip_summed = CHECKSUM_NONE;
 	skb->pkt_type = PACKET_OTHERHOST;
 	skb->protocol = cpu_to_be16(ETH_P_802_2);
-	
+
 	stats->rx_packets++;
 	stats->rx_bytes += skb->len;
 
@@ -1424,8 +1424,8 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 	/* Sanity checks */
 	if (length < 3) { /* No for even an 802.2 LLC header */
 		/* At least on Symbol firmware with PCF we get quite a
-                   lot of these legitimately - Poll frames with no
-                   data. */
+		   lot of these legitimately - Poll frames with no
+		   data. */
 		goto out;
 	}
 	if (length > IEEE80211_MAX_DATA_LEN) {
@@ -1444,7 +1444,7 @@ static void __orinoco_ev_rx(struct net_device *dev, hermes_t *hw)
 	   header, plus 2 bytes so we can align the IP header on a
 	   32bit boundary, plus 1 byte so we can read in odd length
 	   packets from the card, which has an IO granularity of 16
-	   bits */  
+	   bits */
 	skb = dev_alloc_skb(length+ETH_HLEN+2+1);
 	if (!skb) {
 		printk(KERN_WARNING "%s: Can't allocate skb for Rx\n",
@@ -1587,7 +1587,7 @@ static void orinoco_rx(struct net_device *dev,
 	skb->ip_summed = CHECKSUM_NONE;
 	if (fc & IEEE80211_FCTL_TODS)
 		skb->pkt_type = PACKET_OTHERHOST;
-	
+
 	/* Process the wireless stats if needed */
 	orinoco_stat_gather(dev, skb, desc);
 
@@ -1673,7 +1673,7 @@ static void print_linkstatus(struct net_device *dev, u16 status)
 	default:
 		s = "UNKNOWN";
 	}
-	
+
 	printk(KERN_DEBUG "%s: New link status: %s (%04x)\n",
 	       dev->name, s, status);
 }
@@ -2046,7 +2046,7 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		       "Frame dropped.\n", dev->name, err);
 		return;
 	}
-	
+
 	len = HERMES_RECLEN_TO_BYTES(le16_to_cpu(info.len));
 	type = le16_to_cpu(info.type);
 
@@ -2054,23 +2054,23 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 	case HERMES_INQ_TALLIES: {
 		struct hermes_tallies_frame tallies;
 		struct iw_statistics *wstats = &priv->wstats;
-		
+
 		if (len > sizeof(tallies)) {
 			printk(KERN_WARNING "%s: Tallies frame too long (%d bytes)\n",
 			       dev->name, len);
 			len = sizeof(tallies);
 		}
-		
+
 		err = hermes_bap_pread(hw, IRQ_BAP, &tallies, len,
 				       infofid, sizeof(info));
 		if (err)
 			break;
-		
+
 		/* Increment our various counters */
 		/* wstats->discard.nwid - no wrong BSSID stuff */
 		wstats->discard.code +=
 			le16_to_cpu(tallies.RxWEPUndecryptable);
-		if (len == sizeof(tallies))  
+		if (len == sizeof(tallies))
 			wstats->discard.code +=
 				le16_to_cpu(tallies.RxDiscards_WEPICVError) +
 				le16_to_cpu(tallies.RxDiscards_WEPExcluded);
@@ -2326,7 +2326,7 @@ int __orinoco_down(struct net_device *dev)
 		hermes_set_irqmask(hw, 0);
 		hermes_write_regn(hw, EVACK, 0xffff);
 	}
-	
+
 	/* firmware will have to reassociate */
 	netif_carrier_off(dev);
 	priv->last_linkstatus = 0xffff;
@@ -2346,7 +2346,7 @@ static int orinoco_allocate_fid(struct net_device *dev)
 		printk(KERN_WARNING "%s: firmware ALLOC bug detected "
 		       "(old Symbol firmware?). Trying to work around... ",
 		       dev->name);
-		
+
 		priv->nicbuf_size = TX_NICBUF_SIZE_BUG;
 		err = hermes_allocate(hw, priv->nicbuf_size, &priv->txfid);
 		if (err)
@@ -2467,7 +2467,7 @@ static int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv)
 
 			/* Force uniform key length to work around firmware bugs */
 			keylen = le16_to_cpu(priv->keys[priv->tx_key].len);
-			
+
 			if (keylen > LARGE_KEY_SIZE) {
 				printk(KERN_ERR "%s: BUG: Key %d has oversize length %d.\n",
 				       priv->ndev->name, priv->tx_key, keylen);
@@ -2572,7 +2572,7 @@ static int __orinoco_hw_setup_enc(struct orinoco_private *priv)
 					   HERMES_RID_CNFWEPFLAGS_INTERSIL,
 					   master_wep_flag);
 		if (err)
-			return err;	
+			return err;
 
 		break;
 	}
@@ -2707,7 +2707,7 @@ static int __orinoco_program_rids(struct net_device *dev)
 		} else {
 			createibss = priv->createibss;
 		}
-		
+
 		err = hermes_write_wordrec(hw, USER_BAP,
 					   HERMES_RID_CNFCREATEIBSS,
 					   createibss);
@@ -2866,7 +2866,7 @@ static int __orinoco_program_rids(struct net_device *dev)
 	if (priv->iw_mode == IW_MODE_MONITOR) {
 		/* Enable monitor mode */
 		dev->type = ARPHRD_IEEE80211;
-		err = hermes_docmd_wait(hw, HERMES_CMD_TEST | 
+		err = hermes_docmd_wait(hw, HERMES_CMD_TEST |
 					    HERMES_TEST_MONITOR, 0, NULL);
 	} else {
 		/* Disable monitor mode */
@@ -2914,7 +2914,7 @@ __orinoco_set_multicast_list(struct net_device *dev)
 		if (err) {
 			printk(KERN_ERR "%s: Error %d setting PROMISCUOUSMODE to 1.\n",
 			       dev->name, err);
-		} else 
+		} else
 			priv->promiscuous = promisc;
 	}
 
@@ -2931,11 +2931,11 @@ __orinoco_set_multicast_list(struct net_device *dev)
 			BUG_ON(! p);
 			/* paranoia: bad address size in list? */
 			BUG_ON(p->dmi_addrlen != ETH_ALEN);
-			
+
 			memcpy(mclist.addr[i], p->dmi_addr, ETH_ALEN);
 			p = p->next;
 		}
-		
+
 		if (p)
 			printk(KERN_WARNING "%s: Multicast list is "
 			       "longer than mc_count\n", dev->name);
@@ -2982,7 +2982,7 @@ static void orinoco_reset(struct work_struct *work)
 
 	orinoco_unlock(priv, &flags);
 
- 	/* Scanning support: Cleanup of driver struct */
+	/* Scanning support: Cleanup of driver struct */
 	orinoco_clear_scan_results(priv, 0);
 	priv->scan_inprogress = 0;
 
@@ -3070,7 +3070,7 @@ irqreturn_t orinoco_interrupt(int irq, void *dev_id)
 		orinoco_unlock(priv, &flags);
 		return IRQ_NONE;
 	}
-	
+
 	if (jiffies != last_irq_jiffy)
 		loops_this_jiffy = 0;
 	last_irq_jiffy = jiffies;
@@ -3107,7 +3107,7 @@ irqreturn_t orinoco_interrupt(int irq, void *dev_id)
 			__orinoco_ev_tx(dev, hw);
 		if (events & HERMES_EV_ALLOC)
 			__orinoco_ev_alloc(dev, hw);
-		
+
 		hermes_write_regn(hw, EVACK, evstat);
 
 		evstat = hermes_read_regn(hw, EVSTAT);
@@ -3315,7 +3315,7 @@ static int determine_firmware(struct net_device *dev)
 		priv->has_ibss = (firmver >= 0x20000);
 		priv->has_wep = (firmver >= 0x15012);
 		priv->has_big_wep = (firmver >= 0x20000);
-		priv->has_pm = (firmver >= 0x20000 && firmver < 0x22000) || 
+		priv->has_pm = (firmver >= 0x20000 && firmver < 0x22000) ||
 			       (firmver >= 0x29000 && firmver < 0x30000) ||
 			       firmver >= 0x31000;
 		priv->has_preamble = (firmver >= 0x20000);
@@ -3335,8 +3335,8 @@ static int determine_firmware(struct net_device *dev)
 		 */
 		priv->do_fw_download = (priv->stop_fw != NULL);
 
- 		priv->broken_disableport = (firmver == 0x25013) ||
- 					   (firmver >= 0x30000 && firmver <= 0x31000);
+		priv->broken_disableport = (firmver == 0x25013) ||
+					   (firmver >= 0x30000 && firmver <= 0x31000);
 		priv->has_hostscan = (firmver >= 0x31001) ||
 				     (firmver >= 0x29057 && firmver < 0x30000);
 		/* Tested with Intel firmware : 0x20015 => Jean II */
@@ -3554,7 +3554,7 @@ static int orinoco_init(struct net_device *dev)
 		if (err)
 			goto out;
 	}
-		
+
 	/* Set up the default configuration */
 	priv->iw_mode = IW_MODE_INFRA;
 	/* By default use IEEE/IBSS ad-hoc mode if we have it */
@@ -3720,7 +3720,7 @@ static int orinoco_hw_get_essid(struct orinoco_private *priv, int *active,
 
 		rid = (priv->port_type == 3) ? HERMES_RID_CNFOWNSSID :
 			HERMES_RID_CNFDESIREDSSID;
-		
+
 		err = hermes_read_ltv(hw, USER_BAP, rid, sizeof(essidbuf),
 				      NULL, &essidbuf);
 		if (err)
@@ -3744,12 +3744,12 @@ static int orinoco_hw_get_essid(struct orinoco_private *priv, int *active,
  fail_unlock:
 	orinoco_unlock(priv, &flags);
 
-	return err;       
+	return err;
 }
 
 static int orinoco_hw_get_freq(struct orinoco_private *priv)
 {
-	
+
 	hermes_t *hw = &priv->hw;
 	int err = 0;
 	u16 channel;
@@ -3758,7 +3758,7 @@ static int orinoco_hw_get_freq(struct orinoco_private *priv)
 
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
-	
+
 	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CURRENTCHANNEL, &channel);
 	if (err)
 		goto out;
@@ -3806,7 +3806,7 @@ static int orinoco_hw_get_bitratelist(struct orinoco_private *priv,
 
 	if (err)
 		return err;
-	
+
 	num = le16_to_cpu(list.len);
 	*numrates = num;
 	num = min(num, max);
@@ -4008,7 +4008,7 @@ static int orinoco_ioctl_getiwrange(struct net_device *dev,
 			range->freq[k].e = 1;
 			k++;
 		}
-		
+
 		if (k >= IW_MAX_FREQUENCIES)
 			break;
 	}
@@ -4446,7 +4446,7 @@ static int orinoco_ioctl_setsens(struct net_device *dev,
 
 	if ((val < 1) || (val > 3))
 		return -EINVAL;
-	
+
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
 	priv->ap_density = val;
@@ -4544,7 +4544,7 @@ static int orinoco_ioctl_getfrag(struct net_device *dev,
 
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
-	
+
 	if (priv->has_mwo) {
 		err = hermes_read_wordrec(hw, USER_BAP,
 					  HERMES_RID_CNFMWOROBUST_AGERE,
@@ -4567,7 +4567,7 @@ static int orinoco_ioctl_getfrag(struct net_device *dev,
 	}
 
 	orinoco_unlock(priv, &flags);
-	
+
 	return err;
 }
 
@@ -4581,7 +4581,7 @@ static int orinoco_ioctl_setrate(struct net_device *dev,
 	int bitrate; /* 100s of kilobits */
 	int i;
 	unsigned long flags;
-	
+
 	/* As the user space doesn't know our highest rate, it uses -1
 	 * to ask us to set the highest rate.  Test it using "iwconfig
 	 * ethX rate auto" - Jean II */
@@ -4603,7 +4603,7 @@ static int orinoco_ioctl_setrate(struct net_device *dev,
 			ratemode = i;
 			break;
 		}
-	
+
 	if (ratemode == -1)
 		return -EINVAL;
 
@@ -4646,7 +4646,7 @@ static int orinoco_ioctl_getrate(struct net_device *dev,
 					  HERMES_RID_CURRENTTXRATE, &val);
 		if (err)
 			goto out;
-		
+
 		switch (priv->firmware_type) {
 		case FIRMWARE_TYPE_AGERE: /* Lucent style rate */
 			/* Note : in Lucent firmware, the return value of
@@ -4714,7 +4714,7 @@ static int orinoco_ioctl_setpower(struct net_device *dev,
 			err = -EINVAL;
 			goto out;
 		}
-		
+
 		if (prq->flags & IW_POWER_TIMEOUT) {
 			priv->pm_on = 1;
 			priv->pm_timeout = prq->value / 1000;
@@ -4728,7 +4728,7 @@ static int orinoco_ioctl_setpower(struct net_device *dev,
 		if(!priv->pm_on) {
 			err = -EINVAL;
 			goto out;
-		}			
+		}
 	}
 
  out:
@@ -4750,7 +4750,7 @@ static int orinoco_ioctl_getpower(struct net_device *dev,
 
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
-	
+
 	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFPMENABLED, &enable);
 	if (err)
 		goto out;
@@ -4814,7 +4814,7 @@ static int orinoco_ioctl_set_encodeext(struct net_device *dev,
 		idx = priv->tx_key;
 
 	if (encoding->flags & IW_ENCODE_DISABLED)
-	    alg = IW_ENCODE_ALG_NONE;
+		alg = IW_ENCODE_ALG_NONE;
 
 	if (priv->has_wpa && (alg != IW_ENCODE_ALG_TKIP)) {
 		/* Clear any TKIP TX key we had */
@@ -5191,7 +5191,7 @@ static int orinoco_ioctl_getretry(struct net_device *dev,
 
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
-	
+
 	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_SHORTRETRYLIMIT,
 				  &short_limit);
 	if (err)
@@ -5310,7 +5310,7 @@ static int orinoco_ioctl_setport3(struct net_device *dev,
 			break;
 		}
 		priv->prefer_port3 = 0;
-			
+
 		break;
 
 	case 1: /* Try to do Lucent proprietary ad-hoc mode */
-- 
1.6.0.6

