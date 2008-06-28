Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:16947 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792AbYF1Sj2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 14:39:28 -0400
Received: by ik-out-1112.google.com with SMTP id c28so379044ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 11:39:28 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [RFC PATCH 13/19] orinoco: Don't use boolean parameter to record encoding type
Date: Sat, 28 Jun 2008 19:38:19 +0100
Message-Id: <1214678305-7057-14-git-send-email-kilroyd@gmail.com> (sfid-20080628_210813_580973_14563FC6)
In-Reply-To: <1214678305-7057-13-git-send-email-kilroyd@gmail.com>
References: <1214678305-7057-1-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-2-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-3-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-4-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-5-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-6-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-7-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-8-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-9-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-10-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-11-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-12-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-13-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For WPA support we need to encode NONE, WEP and TKIP in the encoding
parameter. In anticipation of this we need to change the usage away from
the current boolean usage.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/orinoco.c |   31 +++++++++++++++++++------------
 drivers/net/wireless/orinoco.h |    2 +-
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index b31e485..2cd144e 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -2100,8 +2100,9 @@ static int __orinoco_hw_setup_wep(struct orinoco_private *priv)
 	int err = 0;
 	int master_wep_flag;
 	int auth_flag;
+	int enc_flag;
 
-	if (priv->wep_on)
+	if (priv->encode_alg == IW_ENCODE_ALG_WEP)
 		__orinoco_hw_setup_wepkeys(priv);
 
 	if (priv->wep_restrict)
@@ -2109,9 +2110,14 @@ static int __orinoco_hw_setup_wep(struct orinoco_private *priv)
 	else
 		auth_flag = HERMES_AUTH_OPEN;
 
+	if (priv->encode_alg == IW_ENCODE_ALG_WEP)
+		enc_flag = 1;
+	else
+		enc_flag = 0;
+
 	switch (priv->firmware_type) {
 	case FIRMWARE_TYPE_AGERE: /* Agere style WEP */
-		if (priv->wep_on) {
+		if (priv->encode_alg == IW_ENCODE_ALG_WEP) {
 			/* Enable the shared-key authentication. */
 			err = hermes_write_wordrec(hw, USER_BAP,
 						   HERMES_RID_CNFAUTHENTICATION_AGERE,
@@ -2119,14 +2125,14 @@ static int __orinoco_hw_setup_wep(struct orinoco_private *priv)
 		}
 		err = hermes_write_wordrec(hw, USER_BAP,
 					   HERMES_RID_CNFWEPENABLED_AGERE,
-					   priv->wep_on);
+					   enc_flag);
 		if (err)
 			return err;
 		break;
 
 	case FIRMWARE_TYPE_INTERSIL: /* Intersil style WEP */
 	case FIRMWARE_TYPE_SYMBOL: /* Symbol style WEP */
-		if (priv->wep_on) {
+		if (priv->encode_alg == IW_ENCODE_ALG_WEP) {
 			if (priv->wep_restrict ||
 			    (priv->firmware_type == FIRMWARE_TYPE_SYMBOL))
 				master_wep_flag = HERMES_WEP_PRIVACY_INVOKED |
@@ -3001,7 +3007,7 @@ static int orinoco_init(struct net_device *dev)
 	priv->channel = 0; /* use firmware default */
 
 	priv->promiscuous = 0;
-	priv->wep_on = 0;
+	priv->encode_alg = IW_ENCODE_ALG_NONE;
 	priv->tx_key = 0;
 
 	/* Make the hardware available, as long as it hasn't been
@@ -3490,7 +3496,7 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 	struct orinoco_private *priv = netdev_priv(dev);
 	int index = (erq->flags & IW_ENCODE_INDEX) - 1;
 	int setindex = priv->tx_key;
-	int enable = priv->wep_on;
+	int encode_alg = priv->encode_alg;
 	int restricted = priv->wep_restrict;
 	u16 xlen = 0;
 	int err = -EINPROGRESS;		/* Call commit handler */
@@ -3524,9 +3530,9 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 			xlen = 0;
 
 		/* Switch on WEP if off */
-		if ((!enable) && (xlen > 0)) {
+		if ((encode_alg != IW_ENCODE_ALG_WEP) && (xlen > 0)) {
 			setindex = index;
-			enable = 1;
+			encode_alg = IW_ENCODE_ALG_WEP;
 		}
 	} else {
 		/* Important note : if the user do "iwconfig eth0 enc off",
@@ -3548,7 +3554,7 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 	}
 
 	if (erq->flags & IW_ENCODE_DISABLED)
-		enable = 0;
+		encode_alg = IW_ENCODE_ALG_NONE;
 	if (erq->flags & IW_ENCODE_OPEN)
 		restricted = 0;
 	if (erq->flags & IW_ENCODE_RESTRICTED)
@@ -3563,14 +3569,15 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 	priv->tx_key = setindex;
 
 	/* Try fast key change if connected and only keys are changed */
-	if (priv->wep_on && enable && (priv->wep_restrict == restricted) &&
+	if ((priv->encode_alg == encode_alg) &&
+	    (priv->wep_restrict == restricted) &&
 	    netif_carrier_ok(dev)) {
 		err = __orinoco_hw_setup_wepkeys(priv);
 		/* No need to commit if successful */
 		goto out;
 	}
 
-	priv->wep_on = enable;
+	priv->encode_alg = encode_alg;
 	priv->wep_restrict = restricted;
 
  out:
@@ -3599,7 +3606,7 @@ static int orinoco_ioctl_getiwencode(struct net_device *dev,
 		index = priv->tx_key;
 
 	erq->flags = 0;
-	if (! priv->wep_on)
+	if (!priv->encode_alg)
 		erq->flags |= IW_ENCODE_DISABLED;
 	erq->flags |= index + 1;
 
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index f510994..5605fd3 100644
--- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -100,7 +100,7 @@ struct orinoco_private {
 	/* Configuration paramaters */
 	u32 iw_mode;
 	int prefer_port3;
-	u16 wep_on, wep_restrict, tx_key;
+	u16 encode_alg, wep_restrict, tx_key;
 	struct orinoco_key keys[ORINOCO_MAX_KEYS];
 	int bitratemode;
  	char nick[IW_ESSID_MAX_SIZE+1];
-- 
1.5.4.5

