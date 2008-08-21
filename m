Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.185]:58253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759604AbYHUW3N (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Aug 2008 18:29:13 -0400
Received: by nf-out-0910.google.com with SMTP id d3so81281nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 21 Aug 2008 15:29:12 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [PATCH v2 13/19] orinoco: Don't use boolean parameter to record encoding type
Date: Thu, 21 Aug 2008 23:27:59 +0100
Message-Id: <09ee16c27766ca779c63a0e82df7e4aa723f4fdf.1219352676.git.kilroyd@gmail.com> (sfid-20080822_005040_567442_1131BABC)
In-Reply-To: <dc5df8328be19728aec203304d9c265368c2b876.1219352675.git.kilroyd@gmail.com>
References: <1219357685-24731-1-git-send-email-kilroyd@gmail.com>
 <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
 <24148627bbab77e1365aa43c22a7f24ded1bed7a.1219352674.git.kilroyd@gmail.com>
 <6e9e9826934e0256adbe561e587f93212e042bf2.1219352674.git.kilroyd@gmail.com>
 <77df696e5b53b5e4db3b8c8e70b23cf5aaa2aca2.1219352674.git.kilroyd@gmail.com>
 <ac0da2799e97f5256019ad669f5a6c461bd0d82a.1219352674.git.kilroyd@gmail.com>
 <d792f6b1d5853becf1b1488e6572a4c3244eb769.1219352674.git.kilroyd@gmail.com>
 <6c4f63d9cc1bec763719e18ea8282919b6604503.1219352674.git.kilroyd@gmail.com>
 <9a54acb1147a2c0a7c1cf9b07b9ac756366d0877.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <889676c2c8c53b8193620e51d81017ade21e593c.1219352674.git.kilroyd@gmail.com>
 <347f1ce011aaeeb9b4d8f805fdfb6eb58fc467ca.1219352675.git.kilroyd@gmail.com>
 <5e42f22bf794bbefae50fa2a3e5b4ff6e36c7096.1219352675.git.kilroyd@gmail.com>
 <dc5df8328be19728aec203304d9c265368c2b876.1219352675.git.kilroyd@gmail.com>
In-Reply-To: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
References: <3bd1799afef838bfc6eb688b1e0cf6b0f4949f1b.1219352674.git.kilroyd@gmail.com>
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
index 22718e8..b853ba0 100644
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
@@ -3008,7 +3014,7 @@ static int orinoco_init(struct net_device *dev)
 	priv->channel = 0; /* use firmware default */
 
 	priv->promiscuous = 0;
-	priv->wep_on = 0;
+	priv->encode_alg = IW_ENCODE_ALG_NONE;
 	priv->tx_key = 0;
 
 	/* Make the hardware available, as long as it hasn't been
@@ -3497,7 +3503,7 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 	struct orinoco_private *priv = netdev_priv(dev);
 	int index = (erq->flags & IW_ENCODE_INDEX) - 1;
 	int setindex = priv->tx_key;
-	int enable = priv->wep_on;
+	int encode_alg = priv->encode_alg;
 	int restricted = priv->wep_restrict;
 	u16 xlen = 0;
 	int err = -EINPROGRESS;		/* Call commit handler */
@@ -3531,9 +3537,9 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
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
@@ -3555,7 +3561,7 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 	}
 
 	if (erq->flags & IW_ENCODE_DISABLED)
-		enable = 0;
+		encode_alg = IW_ENCODE_ALG_NONE;
 	if (erq->flags & IW_ENCODE_OPEN)
 		restricted = 0;
 	if (erq->flags & IW_ENCODE_RESTRICTED)
@@ -3570,14 +3576,15 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
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
@@ -3606,7 +3613,7 @@ static int orinoco_ioctl_getiwencode(struct net_device *dev,
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
1.5.6.4

