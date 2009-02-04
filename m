Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.188]:34137 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240AbZBDXGO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:06:14 -0500
Received: by mu-out-0910.google.com with SMTP id i10so557967mue.1
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:06:11 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 02/16] orinoco: spaces in parenthesised expressions
Date: Wed,  4 Feb 2009 23:05:44 +0000
Message-Id: <1233788758-9850-3-git-send-email-kilroyd@googlemail.com> (sfid-20090205_000620_816623_6257806E)
In-Reply-To: <1233788758-9850-2-git-send-email-kilroyd@googlemail.com>
References: <1233788758-9850-1-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-2-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove checkpatch warnings of the following type:

ERROR: space prohibited after that open parenthesis '('
ERROR: space prohibited before that close parenthesis ')'
ERROR: space prohibited after that '!' (ctx:BxW)
ERROR: space required before the open parenthesis '('
ERROR: space required before the open brace '{'

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/orinoco.c |  110 ++++++++++++++++----------------
 1 files changed, 55 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 0e21eaf..6ff6c38 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -167,7 +167,7 @@ static const u8 encaps_hdr[] = {0xaa, 0xaa, 0x03, 0x00, 0x00, 0x00};
 #define ORINOCO_INTEN	 	(HERMES_EV_RX | HERMES_EV_ALLOC \
 				 | HERMES_EV_TX | HERMES_EV_TXEXC \
 				 | HERMES_EV_WTERR | HERMES_EV_INFO \
-				 | HERMES_EV_INFDROP )
+				 | HERMES_EV_INFDROP)
 
 #define MAX_RID_LEN 1024
 
@@ -768,7 +768,7 @@ static int orinoco_open(struct net_device *dev)
 
 	err = __orinoco_up(dev);
 
-	if (! err)
+	if (!err)
 		priv->open = 1;
 
 	orinoco_unlock(priv, &flags);
@@ -810,7 +810,7 @@ static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
 	int err;
 	unsigned long flags;
 
-	if (! netif_device_present(dev)) {
+	if (!netif_device_present(dev)) {
 		printk(KERN_WARNING "%s: get_wireless_stats() called while device not present\n",
 		       dev->name);
 		return NULL; /* FIXME: Can we do better than this? */
@@ -881,12 +881,12 @@ static int orinoco_change_mtu(struct net_device *dev, int new_mtu)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
 
-	if ( (new_mtu < ORINOCO_MIN_MTU) || (new_mtu > ORINOCO_MAX_MTU) )
+	if ((new_mtu < ORINOCO_MIN_MTU) || (new_mtu > ORINOCO_MAX_MTU))
 		return -EINVAL;
 
 	/* MTU + encapsulation + header length */
-	if ( (new_mtu + ENCAPS_OVERHEAD + sizeof(struct ieee80211_hdr)) >
-	     (priv->nicbuf_size - ETH_HLEN) )
+	if ((new_mtu + ENCAPS_OVERHEAD + sizeof(struct ieee80211_hdr)) >
+	     (priv->nicbuf_size - ETH_HLEN))
 		return -EINVAL;
 
 	dev->mtu = new_mtu;
@@ -909,7 +909,7 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 	int tx_control;
 	unsigned long flags;
 
-	if (! netif_running(dev)) {
+	if (!netif_running(dev)) {
 		printk(KERN_ERR "%s: Tx on stopped device!\n",
 		       dev->name);
 		return NETDEV_TX_BUSY;
@@ -927,7 +927,7 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_BUSY;
 	}
 
-	if (! netif_carrier_ok(dev) || (priv->iw_mode == IW_MODE_MONITOR)) {
+	if (!netif_carrier_ok(dev) || (priv->iw_mode == IW_MODE_MONITOR)) {
 		/* Oops, the firmware hasn't established a connection,
 		   silently drop the packet (this seems to be the
 		   safest approach). */
@@ -1203,7 +1203,7 @@ static inline int is_ethersnap(void *_hdr)
 	 * 00:00:f8 - we need both because different APs appear to use
 	 * different OUIs for some reason */
 	return (memcmp(hdr, &encaps_hdr, 5) == 0)
-		&& ( (hdr[5] == 0x00) || (hdr[5] == 0xf8) );
+		&& ((hdr[5] == 0x00) || (hdr[5] == 0xf8));
 }
 
 static inline void orinoco_spy_gather(struct net_device *dev, u_char *mac,
@@ -1700,14 +1700,14 @@ static void orinoco_join_ap(struct work_struct *work)
 
 	/* Allocate buffer for scan results */
 	buf = kmalloc(MAX_SCAN_LEN, GFP_KERNEL);
-	if (! buf)
+	if (!buf)
 		return;
 
 	if (orinoco_lock(priv, &flags) != 0)
 		goto fail_lock;
 
 	/* Sanity checks in case user changed something in the meantime */
-	if (! priv->bssid_fixed)
+	if (!priv->bssid_fixed)
 		goto out;
 
 	if (strlen(priv->desired_essid) == 0)
@@ -1735,7 +1735,7 @@ static void orinoco_join_ap(struct work_struct *work)
 		}
 	}
 
-	if (! found) {
+	if (!found) {
 		DEBUG(1, "%s: Requested AP not found in scan results\n",
 		      dev->name);
 		goto out;
@@ -2174,7 +2174,7 @@ static void __orinoco_ev_info(struct net_device *dev, hermes_t *hw)
 		{
 			int	i;
 			printk(KERN_DEBUG "Scan result [%02X", buf[0]);
-			for(i = 1; i < (len * 2); i++)
+			for (i = 1; i < (len * 2); i++)
 				printk(":%02X", buf[i]);
 			printk("]\n");
 		}
@@ -2311,8 +2311,8 @@ int __orinoco_down(struct net_device *dev)
 
 	netif_stop_queue(dev);
 
-	if (! priv->hw_unavailable) {
-		if (! priv->broken_disableport) {
+	if (!priv->hw_unavailable) {
+		if (!priv->broken_disableport) {
 			err = hermes_disable_port(hw, 0);
 			if (err) {
 				/* Some firmwares (e.g. Intersil 1.3.x) seem
@@ -2475,7 +2475,7 @@ static int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv)
 			}
 
 			/* Write all 4 keys */
-			for(i = 0; i < ORINOCO_MAX_KEYS; i++) {
+			for (i = 0; i < ORINOCO_MAX_KEYS; i++) {
 				err = hermes_write_ltv(hw, USER_BAP,
 						       HERMES_RID_CNFDEFAULTKEY0 + i,
 						       HERMES_BYTES_TO_RECLEN(keylen),
@@ -2898,8 +2898,8 @@ __orinoco_set_multicast_list(struct net_device *dev)
 
 	/* The Hermes doesn't seem to have an allmulti mode, so we go
 	 * into promiscuous mode and let the upper levels deal. */
-	if ( (dev->flags & IFF_PROMISC) || (dev->flags & IFF_ALLMULTI) ||
-	     (dev->mc_count > MAX_MULTICAST(priv)) ) {
+	if ((dev->flags & IFF_PROMISC) || (dev->flags & IFF_ALLMULTI) ||
+	     (dev->mc_count > MAX_MULTICAST(priv))) {
 		promisc = 1;
 		mc_count = 0;
 	} else {
@@ -2921,14 +2921,14 @@ __orinoco_set_multicast_list(struct net_device *dev)
 	/* If we're not in promiscuous mode, then we need to set the
 	 * group address if either we want to multicast, or if we were
 	 * multicasting and want to stop */
-	if (! promisc && (mc_count || priv->mc_count) ) {
+	if (!promisc && (mc_count || priv->mc_count)) {
 		struct dev_mc_list *p = dev->mc_list;
 		struct hermes_multicast mclist;
 		int i;
 
 		for (i = 0; i < mc_count; i++) {
 			/* paranoia: is list shorter than mc_count? */
-			BUG_ON(! p);
+			BUG_ON(!p);
 			/* paranoia: bad address size in list? */
 			BUG_ON(p->dmi_addrlen != ETH_ALEN);
 
@@ -3008,7 +3008,7 @@ static void orinoco_reset(struct work_struct *work)
 
 	/* priv->open or priv->hw_unavailable might have changed while
 	 * we dropped the lock */
-	if (priv->open && (! priv->hw_unavailable)) {
+	if (priv->open && (!priv->hw_unavailable)) {
 		err = __orinoco_up(dev);
 		if (err) {
 			printk(KERN_ERR "%s: orinoco_reset: Error %d reenabling card\n",
@@ -3066,7 +3066,7 @@ irqreturn_t orinoco_interrupt(int irq, void *dev_id)
 
 	evstat = hermes_read_regn(hw, EVSTAT);
 	events = evstat & hw->inten;
-	if (! events) {
+	if (!events) {
 		orinoco_unlock(priv, &flags);
 		return IRQ_NONE;
 	}
@@ -3086,7 +3086,7 @@ irqreturn_t orinoco_interrupt(int irq, void *dev_id)
 		}
 
 		/* Check the card hasn't been removed */
-		if (! hermes_present(hw)) {
+		if (!hermes_present(hw)) {
 			DEBUG(0, "orinoco_interrupt(): card removed\n");
 			break;
 		}
@@ -3558,7 +3558,7 @@ static int orinoco_init(struct net_device *dev)
 	/* Set up the default configuration */
 	priv->iw_mode = IW_MODE_INFRA;
 	/* By default use IEEE/IBSS ad-hoc mode if we have it */
-	priv->prefer_port3 = priv->has_port3 && (! priv->has_ibss);
+	priv->prefer_port3 = priv->has_port3 && (!priv->has_ibss);
 	set_port_type(priv);
 	priv->channel = 0; /* use firmware default */
 
@@ -3769,7 +3769,7 @@ static int orinoco_hw_get_freq(struct orinoco_private *priv)
 		goto out;
 	}
 
-	if ( (channel < 1) || (channel > NUM_CHANNELS) ) {
+	if ((channel < 1) || (channel > NUM_CHANNELS)) {
 		printk(KERN_WARNING "%s: Channel out of range (%d)!\n",
 		       priv->ndev->name, channel);
 		err = -EBUSY;
@@ -4029,7 +4029,7 @@ static int orinoco_ioctl_getiwrange(struct net_device *dev,
 	if (priv->has_wpa)
 		range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_CIPHER_TKIP;
 
-	if ((priv->iw_mode == IW_MODE_ADHOC) && (!SPY_NUMBER(priv))){
+	if ((priv->iw_mode == IW_MODE_ADHOC) && (!SPY_NUMBER(priv))) {
 		/* Quality stats meaningless in ad-hoc mode */
 	} else {
 		range->max_qual.qual = 0x8b - 0x2f;
@@ -4106,7 +4106,7 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 	int err = -EINPROGRESS;		/* Call commit handler */
 	unsigned long flags;
 
-	if (! priv->has_wep)
+	if (!priv->has_wep)
 		return -EOPNOTSUPP;
 
 	if (erq->pointer) {
@@ -4114,7 +4114,7 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 		if (erq->length > LARGE_KEY_SIZE)
 			return -E2BIG;
 
-		if ( (erq->length > SMALL_KEY_SIZE) && !priv->has_big_wep )
+		if ((erq->length > SMALL_KEY_SIZE) && !priv->has_big_wep)
 			return -E2BIG;
 	}
 
@@ -4147,13 +4147,13 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 		 * we will arrive there with an index of -1. This is valid
 		 * but need to be taken care off... Jean II */
 		if ((index < 0) || (index >= ORINOCO_MAX_KEYS)) {
-			if((index != -1) || (erq->flags == 0)) {
+			if ((index != -1) || (erq->flags == 0)) {
 				err = -EINVAL;
 				goto out;
 			}
 		} else {
 			/* Set the index : Check that the key is valid */
-			if(priv->keys[index].len == 0) {
+			if (priv->keys[index].len == 0) {
 				err = -EINVAL;
 				goto out;
 			}
@@ -4204,7 +4204,7 @@ static int orinoco_ioctl_getiwencode(struct net_device *dev,
 	u16 xlen = 0;
 	unsigned long flags;
 
-	if (! priv->has_wep)
+	if (!priv->has_wep)
 		return -EOPNOTSUPP;
 
 	if (orinoco_lock(priv, &flags) != 0)
@@ -4348,7 +4348,7 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
 	if (priv->iw_mode == IW_MODE_INFRA)
 		return -EBUSY;
 
-	if ( (frq->e == 0) && (frq->m <= 1000) ) {
+	if ((frq->e == 0) && (frq->m <= 1000)) {
 		/* Setting by channel number */
 		chan = frq->m;
 	} else {
@@ -4363,8 +4363,8 @@ static int orinoco_ioctl_setfreq(struct net_device *dev,
 		chan = ieee80211_freq_to_dsss_chan(frq->m / denom);
 	}
 
-	if ( (chan < 1) || (chan > NUM_CHANNELS) ||
-	     ! (priv->channel_mask & (1 << (chan-1)) ) )
+	if ((chan < 1) || (chan > NUM_CHANNELS) ||
+	     !(priv->channel_mask & (1 << (chan-1))))
 		return -EINVAL;
 
 	if (orinoco_lock(priv, &flags) != 0)
@@ -4467,7 +4467,7 @@ static int orinoco_ioctl_setrts(struct net_device *dev,
 	if (rrq->disabled)
 		val = 2347;
 
-	if ( (val < 0) || (val > 2347) )
+	if ((val < 0) || (val > 2347))
 		return -EINVAL;
 
 	if (orinoco_lock(priv, &flags) != 0)
@@ -4519,7 +4519,7 @@ static int orinoco_ioctl_setfrag(struct net_device *dev,
 		if (frq->disabled)
 			priv->frag_thresh = 2346;
 		else {
-			if ( (frq->value < 256) || (frq->value > 2346) )
+			if ((frq->value < 256) || (frq->value > 2346))
 				err = -EINVAL;
 			else
 				priv->frag_thresh = frq->value & ~0x1; /* must be even */
@@ -4553,7 +4553,7 @@ static int orinoco_ioctl_getfrag(struct net_device *dev,
 			val = 0;
 
 		frq->value = val ? 2347 : 0;
-		frq->disabled = ! val;
+		frq->disabled = !val;
 		frq->fixed = 0;
 	} else {
 		err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFFRAGMENTATIONTHRESHOLD,
@@ -4593,13 +4593,13 @@ static int orinoco_ioctl_setrate(struct net_device *dev,
 		bitrate = rrq->value / 100000;
 	}
 
-	if ( (bitrate != 10) && (bitrate != 20) &&
-	     (bitrate != 55) && (bitrate != 110) )
+	if ((bitrate != 10) && (bitrate != 20) &&
+	    (bitrate != 55) && (bitrate != 110))
 		return -EINVAL;
 
 	for (i = 0; i < BITRATE_TABLE_SIZE; i++)
-		if ( (bitrate_table[i].bitrate == bitrate) &&
-		     (bitrate_table[i].automatic == ! rrq->fixed) ) {
+		if ((bitrate_table[i].bitrate == bitrate) &&
+		    (bitrate_table[i].automatic == !rrq->fixed)) {
 			ratemode = i;
 			break;
 		}
@@ -4636,7 +4636,7 @@ static int orinoco_ioctl_getrate(struct net_device *dev,
 	BUG_ON((ratemode < 0) || (ratemode >= BITRATE_TABLE_SIZE));
 
 	rrq->value = bitrate_table[ratemode].bitrate * 100000;
-	rrq->fixed = ! bitrate_table[ratemode].automatic;
+	rrq->fixed = !bitrate_table[ratemode].automatic;
 	rrq->disabled = 0;
 
 	/* If the interface is running we try to find more about the
@@ -4725,7 +4725,7 @@ static int orinoco_ioctl_setpower(struct net_device *dev,
 		}
 		/* It's valid to not have a value if we are just toggling
 		 * the flags... Jean II */
-		if(!priv->pm_on) {
+		if (!priv->pm_on) {
 			err = -EINVAL;
 			goto out;
 		}
@@ -5221,7 +5221,7 @@ static int orinoco_ioctl_getretry(struct net_device *dev,
 		} else {
 			rrq->flags = IW_RETRY_LIMIT;
 			rrq->value = short_limit;
-			if(short_limit != long_limit)
+			if (short_limit != long_limit)
 				rrq->flags |= IW_RETRY_SHORT;
 		}
 	}
@@ -5239,7 +5239,7 @@ static int orinoco_ioctl_reset(struct net_device *dev,
 {
 	struct orinoco_private *priv = netdev_priv(dev);
 
-	if (! capable(CAP_NET_ADMIN))
+	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
 	if (info->cmd == (SIOCIWFIRSTPRIV + 0x1)) {
@@ -5263,7 +5263,7 @@ static int orinoco_ioctl_setibssport(struct net_device *dev,
 
 {
 	struct orinoco_private *priv = netdev_priv(dev);
-	int val = *( (int *) extra );
+	int val = *((int *) extra);
 	unsigned long flags;
 
 	if (orinoco_lock(priv, &flags) != 0)
@@ -5296,7 +5296,7 @@ static int orinoco_ioctl_setport3(struct net_device *dev,
 				  char *extra)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
-	int val = *( (int *) extra );
+	int val = *((int *) extra);
 	int err = 0;
 	unsigned long flags;
 
@@ -5305,7 +5305,7 @@ static int orinoco_ioctl_setport3(struct net_device *dev,
 
 	switch (val) {
 	case 0: /* Try to do IEEE ad-hoc mode */
-		if (! priv->has_ibss) {
+		if (!priv->has_ibss) {
 			err = -EINVAL;
 			break;
 		}
@@ -5314,7 +5314,7 @@ static int orinoco_ioctl_setport3(struct net_device *dev,
 		break;
 
 	case 1: /* Try to do Lucent proprietary ad-hoc mode */
-		if (! priv->has_port3) {
+		if (!priv->has_port3) {
 			err = -EINVAL;
 			break;
 		}
@@ -5325,7 +5325,7 @@ static int orinoco_ioctl_setport3(struct net_device *dev,
 		err = -EINVAL;
 	}
 
-	if (! err) {
+	if (!err) {
 		/* Actually update the mode we are using */
 		set_port_type(priv);
 		err = -EINPROGRESS;
@@ -5357,7 +5357,7 @@ static int orinoco_ioctl_setpreamble(struct net_device *dev,
 	unsigned long flags;
 	int val;
 
-	if (! priv->has_preamble)
+	if (!priv->has_preamble)
 		return -EOPNOTSUPP;
 
 	/* 802.11b has recently defined some short preamble.
@@ -5365,7 +5365,7 @@ static int orinoco_ioctl_setpreamble(struct net_device *dev,
 	 * This increase performance, especially at high rates
 	 * (the preamble is transmitted at 1Mb/s), unfortunately
 	 * this give compatibility troubles... - Jean II */
-	val = *( (int *) extra );
+	val = *((int *) extra);
 
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
@@ -5388,7 +5388,7 @@ static int orinoco_ioctl_getpreamble(struct net_device *dev,
 	struct orinoco_private *priv = netdev_priv(dev);
 	int *val = (int *) extra;
 
-	if (! priv->has_preamble)
+	if (!priv->has_preamble)
 		return -EOPNOTSUPP;
 
 	*val = priv->preamble;
@@ -5414,7 +5414,7 @@ static int orinoco_ioctl_getrid(struct net_device *dev,
 
 	/* It's a "get" function, but we don't want users to access the
 	 * WEP key and other raw firmware data */
-	if (! capable(CAP_NET_ADMIN))
+	if (!capable(CAP_NET_ADMIN))
 		return -EPERM;
 
 	if (rid < 0xfc00 || rid > 0xffff)
@@ -5548,7 +5548,7 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 		err = hermes_inquire(hw, HERMES_INQ_SCAN);
 
 	/* One more client */
-	if (! err)
+	if (!err)
 		priv->scan_inprogress = 1;
 
  out:
-- 
1.6.0.6

