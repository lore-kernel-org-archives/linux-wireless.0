Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:46256 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844AbZBDXGs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Feb 2009 18:06:48 -0500
Received: by mail-ew0-f21.google.com with SMTP id 14so4024043ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2009 15:06:47 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Cc: David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH v2 11/16] orinoco: Use accessor functions for bitrate tables
Date: Wed,  4 Feb 2009 23:05:53 +0000
Message-Id: <1233788758-9850-12-git-send-email-kilroyd@googlemail.com> (sfid-20090205_000655_157182_52DB8203)
In-Reply-To: <1233788758-9850-11-git-send-email-kilroyd@googlemail.com>
References: <1233788758-9850-1-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-2-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-3-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-4-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-5-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-6-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-7-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-8-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-9-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-10-git-send-email-kilroyd@googlemail.com>
 <1233788758-9850-11-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... when used by the WEXT ioctl functions. This will allow us to
separate the card specific stuff from the WEXT code.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/main.c |  140 ++++++++++++++++++++---------------
 1 files changed, 81 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index e937afd..1617e10 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -282,6 +282,33 @@ static inline void set_port_type(struct orinoco_private *priv)
 	}
 }
 
+static int orinoco_get_bitratemode(int bitrate, int automatic)
+{
+	int ratemode = -1;
+	int i;
+
+	if ((bitrate != 10) && (bitrate != 20) &&
+	    (bitrate != 55) && (bitrate != 110))
+		return ratemode;
+
+	for (i = 0; i < BITRATE_TABLE_SIZE; i++) {
+		if ((bitrate_table[i].bitrate == bitrate) &&
+		    (bitrate_table[i].automatic == automatic)) {
+			ratemode = i;
+			break;
+		}
+	}
+	return ratemode;
+}
+
+static void orinoco_get_ratemode_cfg(int ratemode, int *bitrate, int *automatic)
+{
+	BUG_ON((ratemode < 0) || (ratemode >= BITRATE_TABLE_SIZE));
+
+	*bitrate = bitrate_table[ratemode].bitrate * 100000;
+	*automatic = bitrate_table[ratemode].automatic;
+}
+
 static inline u8 *orinoco_get_ie(u8 *data, size_t len,
 				 enum ieee80211_eid eid)
 {
@@ -1794,6 +1821,50 @@ static int __orinoco_hw_set_bitrate(struct orinoco_private *priv)
 	return err;
 }
 
+static int orinoco_hw_get_act_bitrate(struct orinoco_private *priv,
+				      int *bitrate)
+{
+	hermes_t *hw = &priv->hw;
+	int i;
+	int err = 0;
+	u16 val;
+
+	err = hermes_read_wordrec(hw, USER_BAP,
+				  HERMES_RID_CURRENTTXRATE, &val);
+	if (err)
+		return err;
+
+	switch (priv->firmware_type) {
+	case FIRMWARE_TYPE_AGERE: /* Lucent style rate */
+		/* Note : in Lucent firmware, the return value of
+		 * HERMES_RID_CURRENTTXRATE is the bitrate in Mb/s,
+		 * and therefore is totally different from the
+		 * encoding of HERMES_RID_CNFTXRATECONTROL.
+		 * Don't forget that 6Mb/s is really 5.5Mb/s */
+		if (val == 6)
+			*bitrate = 5500000;
+		else
+			*bitrate = val * 1000000;
+		break;
+	case FIRMWARE_TYPE_INTERSIL: /* Intersil style rate */
+	case FIRMWARE_TYPE_SYMBOL: /* Symbol style rate */
+		for (i = 0; i < BITRATE_TABLE_SIZE; i++)
+			if (bitrate_table[i].intersil_txratectrl == val)
+				break;
+
+		if (i >= BITRATE_TABLE_SIZE)
+			printk(KERN_INFO "%s: Unable to determine current bitrate (0x%04hx)\n",
+			       priv->ndev->name, val);
+
+		*bitrate = bitrate_table[i].bitrate * 100000;
+		break;
+	default:
+		BUG();
+	}
+
+	return err;
+}
+
 /* Set fixed AP address */
 static int __orinoco_hw_set_wap(struct orinoco_private *priv)
 {
@@ -3975,9 +4046,8 @@ static int orinoco_ioctl_setrate(struct net_device *dev,
 				 char *extra)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
-	int ratemode = -1;
+	int ratemode;
 	int bitrate; /* 100s of kilobits */
-	int i;
 	unsigned long flags;
 
 	/* As the user space doesn't know our highest rate, it uses -1
@@ -3991,16 +4061,7 @@ static int orinoco_ioctl_setrate(struct net_device *dev,
 		bitrate = rrq->value / 100000;
 	}
 
-	if ((bitrate != 10) && (bitrate != 20) &&
-	    (bitrate != 55) && (bitrate != 110))
-		return -EINVAL;
-
-	for (i = 0; i < BITRATE_TABLE_SIZE; i++)
-		if ((bitrate_table[i].bitrate == bitrate) &&
-		    (bitrate_table[i].automatic == !rrq->fixed)) {
-			ratemode = i;
-			break;
-		}
+	ratemode = orinoco_get_bitratemode(bitrate, !rrq->fixed);
 
 	if (ratemode == -1)
 		return -EINVAL;
@@ -4019,65 +4080,26 @@ static int orinoco_ioctl_getrate(struct net_device *dev,
 				 char *extra)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
-	hermes_t *hw = &priv->hw;
 	int err = 0;
-	int ratemode;
-	int i;
-	u16 val;
+	int bitrate, automatic;
 	unsigned long flags;
 
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
 
-	ratemode = priv->bitratemode;
-
-	BUG_ON((ratemode < 0) || (ratemode >= BITRATE_TABLE_SIZE));
-
-	rrq->value = bitrate_table[ratemode].bitrate * 100000;
-	rrq->fixed = !bitrate_table[ratemode].automatic;
-	rrq->disabled = 0;
+	orinoco_get_ratemode_cfg(priv->bitratemode, &bitrate, &automatic);
 
 	/* If the interface is running we try to find more about the
 	   current mode */
-	if (netif_running(dev)) {
-		err = hermes_read_wordrec(hw, USER_BAP,
-					  HERMES_RID_CURRENTTXRATE, &val);
-		if (err)
-			goto out;
+	if (netif_running(dev))
+		err = orinoco_hw_get_act_bitrate(priv, &bitrate);
 
-		switch (priv->firmware_type) {
-		case FIRMWARE_TYPE_AGERE: /* Lucent style rate */
-			/* Note : in Lucent firmware, the return value of
-			 * HERMES_RID_CURRENTTXRATE is the bitrate in Mb/s,
-			 * and therefore is totally different from the
-			 * encoding of HERMES_RID_CNFTXRATECONTROL.
-			 * Don't forget that 6Mb/s is really 5.5Mb/s */
-			if (val == 6)
-				rrq->value = 5500000;
-			else
-				rrq->value = val * 1000000;
-			break;
-		case FIRMWARE_TYPE_INTERSIL: /* Intersil style rate */
-		case FIRMWARE_TYPE_SYMBOL: /* Symbol style rate */
-			for (i = 0; i < BITRATE_TABLE_SIZE; i++)
-				if (bitrate_table[i].intersil_txratectrl == val) {
-					ratemode = i;
-					break;
-				}
-			if (i >= BITRATE_TABLE_SIZE)
-				printk(KERN_INFO "%s: Unable to determine current bitrate (0x%04hx)\n",
-				       dev->name, val);
-
-			rrq->value = bitrate_table[ratemode].bitrate * 100000;
-			break;
-		default:
-			BUG();
-		}
-	}
-
- out:
 	orinoco_unlock(priv, &flags);
 
+	rrq->value = bitrate;
+	rrq->fixed = !automatic;
+	rrq->disabled = 0;
+
 	return err;
 }
 
-- 
1.6.0.6

