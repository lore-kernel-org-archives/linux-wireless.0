Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:43284 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751650AbZBCUl4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 15:41:56 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so2846565ewy.13
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2009 12:41:55 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 05/17] orinoco: keep line length below 80 characters
Date: Tue,  3 Feb 2009 20:40:27 +0000
Message-Id: <1233693639-8608-6-git-send-email-kilroyd@googlemail.com> (sfid-20090203_214159_176694_DB0B93CF)
In-Reply-To: <1233693639-8608-5-git-send-email-kilroyd@googlemail.com>
References: <1233693639-8608-1-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-2-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-3-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-4-git-send-email-kilroyd@googlemail.com>
 <1233693639-8608-5-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove most checkpatch warnings of the type
WARNING: line over 80 characters

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/orinoco.c |  113 +++++++++++++++++++-------------
 1 files changed, 68 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/orinoco/orinoco.c b/drivers/net/wireless/orinoco/orinoco.c
index 120c9d9..0719ee6 100644
--- a/drivers/net/wireless/orinoco/orinoco.c
+++ b/drivers/net/wireless/orinoco/orinoco.c
@@ -101,8 +101,10 @@
 /* Module information                                               */
 /********************************************************************/
 
-MODULE_AUTHOR("Pavel Roskin <proski@gnu.org> & David Gibson <hermes@gibson.dropbear.id.au>");
-MODULE_DESCRIPTION("Driver for Lucent Orinoco, Prism II based and similar wireless cards");
+MODULE_AUTHOR("Pavel Roskin <proski@gnu.org> & "
+	      "David Gibson <hermes@gibson.dropbear.id.au>");
+MODULE_DESCRIPTION("Driver for Lucent Orinoco, Prism II based "
+		   "and similar wireless cards");
 MODULE_LICENSE("Dual MPL/GPL");
 
 /* Level of debugging. Used in the macros in orinoco.h */
@@ -116,9 +118,11 @@ EXPORT_SYMBOL(orinoco_debug);
 static int suppress_linkstatus; /* = 0 */
 module_param(suppress_linkstatus, bool, 0644);
 MODULE_PARM_DESC(suppress_linkstatus, "Don't log link status changes");
+
 static int ignore_disconnect; /* = 0 */
 module_param(ignore_disconnect, int, 0644);
-MODULE_PARM_DESC(ignore_disconnect, "Don't report lost link to the network layer");
+MODULE_PARM_DESC(ignore_disconnect,
+		 "Don't report lost link to the network layer");
 
 static int force_monitor; /* = 0 */
 module_param(force_monitor, int, 0644);
@@ -840,7 +844,8 @@ static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
 			wstats->qual.qual = priv->spy_data.spy_stat[0].qual;
 			wstats->qual.level = priv->spy_data.spy_stat[0].level;
 			wstats->qual.noise = priv->spy_data.spy_stat[0].noise;
-			wstats->qual.updated = priv->spy_data.spy_stat[0].updated;
+			wstats->qual.updated =
+				priv->spy_data.spy_stat[0].updated;
 		}
 	} else {
 		struct {
@@ -854,7 +859,8 @@ static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
 			wstats->qual.qual = (int)le16_to_cpu(cq.qual);
 			wstats->qual.level = (int)le16_to_cpu(cq.signal) - 0x95;
 			wstats->qual.noise = (int)le16_to_cpu(cq.noise) - 0x95;
-			wstats->qual.updated = IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
+			wstats->qual.updated =
+				IW_QUAL_ALL_UPDATED | IW_QUAL_DBM;
 		}
 	}
 
@@ -1571,7 +1577,8 @@ static void orinoco_rx(struct net_device *dev,
 		/* These indicate a SNAP within 802.2 LLC within
 		   802.11 frame which we'll need to de-encapsulate to
 		   the original EthernetII frame. */
-		hdr = (struct ethhdr *)skb_push(skb, ETH_HLEN - ENCAPS_OVERHEAD);
+		hdr = (struct ethhdr *)skb_push(skb,
+						ETH_HLEN - ENCAPS_OVERHEAD);
 	} else {
 		/* 802.3 frame - prepend 802.3 header as is */
 		hdr = (struct ethhdr *)skb_push(skb, ETH_HLEN);
@@ -2379,25 +2386,26 @@ int orinoco_reinit_firmware(struct net_device *dev)
 static int __orinoco_hw_set_bitrate(struct orinoco_private *priv)
 {
 	hermes_t *hw = &priv->hw;
+	int ratemode = priv->bitratemode;
 	int err = 0;
 
-	if (priv->bitratemode >= BITRATE_TABLE_SIZE) {
+	if (ratemode >= BITRATE_TABLE_SIZE) {
 		printk(KERN_ERR "%s: BUG: Invalid bitrate mode %d\n",
-		       priv->ndev->name, priv->bitratemode);
+		       priv->ndev->name, ratemode);
 		return -EINVAL;
 	}
 
 	switch (priv->firmware_type) {
 	case FIRMWARE_TYPE_AGERE:
 		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFTXRATECONTROL,
-					   bitrate_table[priv->bitratemode].agere_txratectrl);
+				HERMES_RID_CNFTXRATECONTROL,
+				bitrate_table[ratemode].agere_txratectrl);
 		break;
 	case FIRMWARE_TYPE_INTERSIL:
 	case FIRMWARE_TYPE_SYMBOL:
 		err = hermes_write_wordrec(hw, USER_BAP,
-					   HERMES_RID_CNFTXRATECONTROL,
-					   bitrate_table[priv->bitratemode].intersil_txratectrl);
+				HERMES_RID_CNFTXRATECONTROL,
+				bitrate_table[ratemode].intersil_txratectrl);
 		break;
 	default:
 		BUG();
@@ -2465,7 +2473,8 @@ static int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv)
 			int keylen;
 			int i;
 
-			/* Force uniform key length to work around firmware bugs */
+			/* Force uniform key length to work around
+			 * firmware bugs */
 			keylen = le16_to_cpu(priv->keys[priv->tx_key].len);
 
 			if (keylen > LARGE_KEY_SIZE) {
@@ -2477,17 +2486,17 @@ static int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv)
 			/* Write all 4 keys */
 			for (i = 0; i < ORINOCO_MAX_KEYS; i++) {
 				err = hermes_write_ltv(hw, USER_BAP,
-						       HERMES_RID_CNFDEFAULTKEY0 + i,
-						       HERMES_BYTES_TO_RECLEN(keylen),
-						       priv->keys[i].data);
+						HERMES_RID_CNFDEFAULTKEY0 + i,
+						HERMES_BYTES_TO_RECLEN(keylen),
+						priv->keys[i].data);
 				if (err)
 					return err;
 			}
 
 			/* Write the index of the key used in transmission */
 			err = hermes_write_wordrec(hw, USER_BAP,
-						   HERMES_RID_CNFWEPDEFAULTKEYID,
-						   priv->tx_key);
+						HERMES_RID_CNFWEPDEFAULTKEYID,
+						priv->tx_key);
 			if (err)
 				return err;
 		}
@@ -2526,8 +2535,8 @@ static int __orinoco_hw_setup_enc(struct orinoco_private *priv)
 		if (priv->encode_alg == IW_ENCODE_ALG_WEP) {
 			/* Enable the shared-key authentication. */
 			err = hermes_write_wordrec(hw, USER_BAP,
-						   HERMES_RID_CNFAUTHENTICATION_AGERE,
-						   auth_flag);
+					HERMES_RID_CNFAUTHENTICATION_AGERE,
+					auth_flag);
 		}
 		err = hermes_write_wordrec(hw, USER_BAP,
 					   HERMES_RID_CNFWEPENABLED_AGERE,
@@ -2730,16 +2739,16 @@ static int __orinoco_program_rids(struct net_device *dev)
 	memcpy(&idbuf.val, priv->desired_essid, sizeof(idbuf.val));
 	/* WinXP wants partner to configure OWNSSID even in IBSS mode. (jimc) */
 	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFOWNSSID,
-			       HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
-			       &idbuf);
+			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
+			&idbuf);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d setting OWNSSID\n",
 		       dev->name, err);
 		return err;
 	}
 	err = hermes_write_ltv(hw, USER_BAP, HERMES_RID_CNFDESIREDSSID,
-			       HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
-			       &idbuf);
+			HERMES_BYTES_TO_RECLEN(strlen(priv->desired_essid)+2),
+			&idbuf);
 	if (err) {
 		printk(KERN_ERR "%s: Error %d setting DESIREDSSID\n",
 		       dev->name, err);
@@ -2764,7 +2773,7 @@ static int __orinoco_program_rids(struct net_device *dev)
 					   HERMES_RID_CNFSYSTEMSCALE,
 					   priv->ap_density);
 		if (err) {
-			printk(KERN_WARNING "%s: Error %d setting SYSTEMSCALE.  "
+			printk(KERN_WARNING "%s: Error %d setting SYSTEMSCALE. "
 			       "Disabling sensitivity control\n",
 			       dev->name, err);
 
@@ -3002,7 +3011,8 @@ static void orinoco_reset(struct work_struct *work)
 		goto disable;
 	}
 
-	spin_lock_irq(&priv->lock); /* This has to be called from user context */
+	/* This has to be called from user context */
+	spin_lock_irq(&priv->lock);
 
 	priv->hw_unavailable--;
 
@@ -3293,7 +3303,8 @@ static int determine_firmware(struct net_device *dev)
 				      SYMBOL_MAX_VER_LEN, NULL, &tmp);
 		if (err) {
 			printk(KERN_WARNING
-			       "%s: Error %d reading Symbol firmware info. Wildly guessing capabilities...\n",
+			       "%s: Error %d reading Symbol firmware info. "
+			       "Wildly guessing capabilities...\n",
 			       dev->name, err);
 			firmver = 0;
 			tmp[0] = '\0';
@@ -3302,8 +3313,10 @@ static int determine_firmware(struct net_device *dev)
 			 * something like : "V2.20-01".
 			 * Quick and dirty parsing... - Jean II
 			 */
-			firmver = ((tmp[1] - '0') << 16) | ((tmp[3] - '0') << 12)
-				| ((tmp[4] - '0') << 8) | ((tmp[6] - '0') << 4)
+			firmver = ((tmp[1] - '0') << 16)
+				| ((tmp[3] - '0') << 12)
+				| ((tmp[4] - '0') << 8)
+				| ((tmp[6] - '0') << 4)
 				| (tmp[7] - '0');
 
 			tmp[SYMBOL_MAX_VER_LEN] = '\0';
@@ -3336,7 +3349,7 @@ static int determine_firmware(struct net_device *dev)
 		priv->do_fw_download = (priv->stop_fw != NULL);
 
 		priv->broken_disableport = (firmver == 0x25013) ||
-					   (firmver >= 0x30000 && firmver <= 0x31000);
+				(firmver >= 0x30000 && firmver <= 0x31000);
 		priv->has_hostscan = (firmver >= 0x31001) ||
 				     (firmver >= 0x29057 && firmver < 0x30000);
 		/* Tested with Intel firmware : 0x20015 => Jean II */
@@ -3423,7 +3436,8 @@ static int orinoco_init(struct net_device *dev)
 	}
 
 	if (priv->has_port3)
-		printk(KERN_DEBUG "%s: Ad-hoc demo mode supported\n", dev->name);
+		printk(KERN_DEBUG "%s: Ad-hoc demo mode supported\n",
+		       dev->name);
 	if (priv->has_ibss)
 		printk(KERN_DEBUG "%s: IEEE standard IBSS ad-hoc mode supported\n",
 		       dev->name);
@@ -3515,7 +3529,8 @@ static int orinoco_init(struct net_device *dev)
 					  HERMES_RID_CNFMWOROBUST_AGERE,
 					  &priv->mwo_robust);
 	else
-		err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFFRAGMENTATIONTHRESHOLD,
+		err = hermes_read_wordrec(hw, USER_BAP,
+					  HERMES_RID_CNFFRAGMENTATIONTHRESHOLD,
 					  &priv->frag_thresh);
 	if (err) {
 		printk(KERN_ERR "%s: failed to read fragmentation settings!\n",
@@ -3758,7 +3773,8 @@ static int orinoco_hw_get_freq(struct orinoco_private *priv)
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
 
-	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CURRENTCHANNEL, &channel);
+	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CURRENTCHANNEL,
+				  &channel);
 	if (err)
 		goto out;
 
@@ -4064,7 +4080,8 @@ static int orinoco_ioctl_getiwrange(struct net_device *dev,
 	range->max_pmt = 65535 * 1000;	/* ??? */
 	range->pmp_flags = IW_POWER_PERIOD;
 	range->pmt_flags = IW_POWER_TIMEOUT;
-	range->pm_capa = IW_POWER_PERIOD | IW_POWER_TIMEOUT | IW_POWER_UNICAST_R;
+	range->pm_capa = (IW_POWER_PERIOD | IW_POWER_TIMEOUT |
+			  IW_POWER_UNICAST_R);
 
 	range->retry_capa = IW_RETRY_LIMIT | IW_RETRY_LIFETIME;
 	range->retry_flags = IW_RETRY_LIMIT;
@@ -4506,9 +4523,10 @@ static int orinoco_ioctl_setfrag(struct net_device *dev,
 			priv->mwo_robust = 0;
 		else {
 			if (frq->fixed)
-				printk(KERN_WARNING "%s: Fixed fragmentation is "
-				       "not supported on this firmware. "
-				       "Using MWO robust instead.\n", dev->name);
+				printk(KERN_WARNING "%s: Fixed fragmentation "
+				       "is not supported on this firmware. "
+				       "Using MWO robust instead.\n",
+				       dev->name);
 			priv->mwo_robust = 1;
 		}
 	} else {
@@ -4518,7 +4536,8 @@ static int orinoco_ioctl_setfrag(struct net_device *dev,
 			if ((frq->value < 256) || (frq->value > 2346))
 				err = -EINVAL;
 			else
-				priv->frag_thresh = frq->value & ~0x1; /* must be even */
+				/* must be even */
+				priv->frag_thresh = frq->value & ~0x1;
 		}
 	}
 
@@ -4552,7 +4571,8 @@ static int orinoco_ioctl_getfrag(struct net_device *dev,
 		frq->disabled = !val;
 		frq->fixed = 0;
 	} else {
-		err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFFRAGMENTATIONTHRESHOLD,
+		err = hermes_read_wordrec(hw, USER_BAP,
+					  HERMES_RID_CNFFRAGMENTATIONTHRESHOLD,
 					  &val);
 		if (err)
 			val = 0;
@@ -4747,7 +4767,8 @@ static int orinoco_ioctl_getpower(struct net_device *dev,
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
 
-	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFPMENABLED, &enable);
+	err = hermes_read_wordrec(hw, USER_BAP,
+				  HERMES_RID_CNFPMENABLED, &enable);
 	if (err)
 		goto out;
 
@@ -4756,11 +4777,13 @@ static int orinoco_ioctl_getpower(struct net_device *dev,
 	if (err)
 		goto out;
 
-	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFPMHOLDOVERDURATION, &timeout);
+	err = hermes_read_wordrec(hw, USER_BAP,
+				  HERMES_RID_CNFPMHOLDOVERDURATION, &timeout);
 	if (err)
 		goto out;
 
-	err = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_CNFMULTICASTRECEIVE, &mcast);
+	err = hermes_read_wordrec(hw, USER_BAP,
+				  HERMES_RID_CNFMULTICASTRECEIVE, &mcast);
 	if (err)
 		goto out;
 
@@ -5486,9 +5509,9 @@ static int orinoco_ioctl_setscan(struct net_device *dev,
 		switch (priv->firmware_type) {
 		case FIRMWARE_TYPE_SYMBOL:
 			err = hermes_write_wordrec(hw, USER_BAP,
-						   HERMES_RID_CNFHOSTSCAN_SYMBOL,
-						   HERMES_HOSTSCAN_SYMBOL_ONCE |
-						   HERMES_HOSTSCAN_SYMBOL_BCAST);
+						HERMES_RID_CNFHOSTSCAN_SYMBOL,
+						HERMES_HOSTSCAN_SYMBOL_ONCE |
+						HERMES_HOSTSCAN_SYMBOL_BCAST);
 			break;
 		case FIRMWARE_TYPE_INTERSIL: {
 			__le16 req[3];
-- 
1.6.0.6

