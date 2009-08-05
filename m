Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:42204 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbZHEUYR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 16:24:17 -0400
Received: by mail-ew0-f214.google.com with SMTP id 10so285565ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 13:24:17 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 2/6] orinoco: use local types for auth alg and sequence length
Date: Wed,  5 Aug 2009 21:23:28 +0100
Message-Id: <1249503812-16921-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1249503812-16921-1-git-send-email-kilroyd@googlemail.com>
References: <1249503812-16921-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This helps in the refactorring required to convert the driver to
cfg80211.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/hw.c      |   12 ++++++------
 drivers/net/wireless/orinoco/main.c    |    6 +++---
 drivers/net/wireless/orinoco/orinoco.h |   10 +++++++++-
 drivers/net/wireless/orinoco/wext.c    |   30 +++++++++++++++---------------
 4 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/orinoco/hw.c b/drivers/net/wireless/orinoco/hw.c
index fa508af..d069fe8 100644
--- a/drivers/net/wireless/orinoco/hw.c
+++ b/drivers/net/wireless/orinoco/hw.c
@@ -642,7 +642,7 @@ int orinoco_hw_get_tkip_iv(struct orinoco_private *priv, int key, u8 *tsc)
 {
 	hermes_t *hw = &priv->hw;
 	int err = 0;
-	u8 tsc_arr[4][IW_ENCODE_SEQ_MAX_SIZE];
+	u8 tsc_arr[4][ORINOCO_SEQ_LEN];
 
 	if ((key < 0) || (key > 4))
 		return -EINVAL;
@@ -840,14 +840,14 @@ int __orinoco_hw_setup_enc(struct orinoco_private *priv)
 
 	if (priv->wpa_enabled)
 		enc_flag = 2;
-	else if (priv->encode_alg == IW_ENCODE_ALG_WEP)
+	else if (priv->encode_alg == ORINOCO_ALG_WEP)
 		enc_flag = 1;
 	else
 		enc_flag = 0;
 
 	switch (priv->firmware_type) {
 	case FIRMWARE_TYPE_AGERE: /* Agere style WEP */
-		if (priv->encode_alg == IW_ENCODE_ALG_WEP) {
+		if (priv->encode_alg == ORINOCO_ALG_WEP) {
 			/* Enable the shared-key authentication. */
 			err = hermes_write_wordrec(hw, USER_BAP,
 					HERMES_RID_CNFAUTHENTICATION_AGERE,
@@ -872,7 +872,7 @@ int __orinoco_hw_setup_enc(struct orinoco_private *priv)
 
 	case FIRMWARE_TYPE_INTERSIL: /* Intersil style WEP */
 	case FIRMWARE_TYPE_SYMBOL: /* Symbol style WEP */
-		if (priv->encode_alg == IW_ENCODE_ALG_WEP) {
+		if (priv->encode_alg == ORINOCO_ALG_WEP) {
 			if (priv->wep_restrict ||
 			    (priv->firmware_type == FIRMWARE_TYPE_SYMBOL))
 				master_wep_flag = HERMES_WEP_PRIVACY_INVOKED |
@@ -913,11 +913,11 @@ int __orinoco_hw_set_tkip_key(struct orinoco_private *priv, int key_idx,
 {
 	struct {
 		__le16 idx;
-		u8 rsc[IW_ENCODE_SEQ_MAX_SIZE];
+		u8 rsc[ORINOCO_SEQ_LEN];
 		u8 key[TKIP_KEYLEN];
 		u8 tx_mic[MIC_KEYLEN];
 		u8 rx_mic[MIC_KEYLEN];
-		u8 tsc[IW_ENCODE_SEQ_MAX_SIZE];
+		u8 tsc[ORINOCO_SEQ_LEN];
 	} __attribute__ ((packed)) buf;
 	hermes_t *hw = &priv->hw;
 	int ret;
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index e8c550a..931f7de 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -380,7 +380,7 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 
 	tx_control = HERMES_TXCTRL_TX_OK | HERMES_TXCTRL_TX_EX;
 
-	if (priv->encode_alg == IW_ENCODE_ALG_TKIP)
+	if (priv->encode_alg == ORINOCO_ALG_TKIP)
 		tx_control |= (priv->tx_key << HERMES_MIC_KEY_ID_SHIFT) |
 			HERMES_TXCTRL_MIC;
 
@@ -462,7 +462,7 @@ static int orinoco_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	/* Calculate Michael MIC */
-	if (priv->encode_alg == IW_ENCODE_ALG_TKIP) {
+	if (priv->encode_alg == ORINOCO_ALG_TKIP) {
 		u8 mic_buf[MICHAEL_MIC_LEN + 1];
 		u8 *mic;
 		size_t offset;
@@ -2040,7 +2040,7 @@ int orinoco_init(struct orinoco_private *priv)
 	priv->channel = 0; /* use firmware default */
 
 	priv->promiscuous = 0;
-	priv->encode_alg = IW_ENCODE_ALG_NONE;
+	priv->encode_alg = ORINOCO_ALG_NONE;
 	priv->tx_key = 0;
 	priv->wpa_enabled = 0;
 	priv->tkip_cm_active = 0;
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 2a4eef1..badfc56 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -25,6 +25,7 @@
 
 #define MAX_SCAN_LEN		4096
 
+#define ORINOCO_SEQ_LEN		8
 #define ORINOCO_MAX_KEY_SIZE	14
 #define ORINOCO_MAX_KEYS	4
 
@@ -42,6 +43,12 @@ struct orinoco_tkip_key {
 	u8 rx_mic[MIC_KEYLEN];
 };
 
+enum orinoco_alg {
+	ORINOCO_ALG_NONE,
+	ORINOCO_ALG_WEP,
+	ORINOCO_ALG_TKIP
+};
+
 typedef enum {
 	FIRMWARE_TYPE_AGERE,
 	FIRMWARE_TYPE_INTERSIL,
@@ -111,7 +118,8 @@ struct orinoco_private {
 
 	/* Configuration paramaters */
 	enum nl80211_iftype iw_mode;
-	u16 encode_alg, wep_restrict, tx_key;
+	enum orinoco_alg encode_alg;
+	u16 wep_restrict, tx_key;
 	struct orinoco_key keys[ORINOCO_MAX_KEYS];
 	int bitratemode;
 	char nick[IW_ESSID_MAX_SIZE+1];
diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index b6ff3db..33d81b4 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -180,7 +180,7 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 	struct orinoco_private *priv = ndev_priv(dev);
 	int index = (erq->flags & IW_ENCODE_INDEX) - 1;
 	int setindex = priv->tx_key;
-	int encode_alg = priv->encode_alg;
+	enum orinoco_alg encode_alg = priv->encode_alg;
 	int restricted = priv->wep_restrict;
 	u16 xlen = 0;
 	int err = -EINPROGRESS;		/* Call commit handler */
@@ -202,7 +202,7 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 		return -EBUSY;
 
 	/* Clear any TKIP key we have */
-	if ((priv->has_wpa) && (priv->encode_alg == IW_ENCODE_ALG_TKIP))
+	if ((priv->has_wpa) && (priv->encode_alg == ORINOCO_ALG_TKIP))
 		(void) orinoco_clear_tkip_key(priv, setindex);
 
 	if (erq->length > 0) {
@@ -212,15 +212,13 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 		/* Adjust key length to a supported value */
 		if (erq->length > SMALL_KEY_SIZE)
 			xlen = LARGE_KEY_SIZE;
-		else if (erq->length > 0)
+		else /* (erq->length > 0) */
 			xlen = SMALL_KEY_SIZE;
-		else
-			xlen = 0;
 
 		/* Switch on WEP if off */
-		if ((encode_alg != IW_ENCODE_ALG_WEP) && (xlen > 0)) {
+		if (encode_alg != ORINOCO_ALG_WEP) {
 			setindex = index;
-			encode_alg = IW_ENCODE_ALG_WEP;
+			encode_alg = ORINOCO_ALG_WEP;
 		}
 	} else {
 		/* Important note : if the user do "iwconfig eth0 enc off",
@@ -242,7 +240,7 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 	}
 
 	if (erq->flags & IW_ENCODE_DISABLED)
-		encode_alg = IW_ENCODE_ALG_NONE;
+		encode_alg = ORINOCO_ALG_NONE;
 	if (erq->flags & IW_ENCODE_OPEN)
 		restricted = 0;
 	if (erq->flags & IW_ENCODE_RESTRICTED)
@@ -825,7 +823,7 @@ static int orinoco_ioctl_set_encodeext(struct net_device *dev,
 		/* Set the requested key first */
 		switch (alg) {
 		case IW_ENCODE_ALG_NONE:
-			priv->encode_alg = alg;
+			priv->encode_alg = ORINOCO_ALG_NONE;
 			priv->keys[idx].len = 0;
 			break;
 
@@ -837,7 +835,7 @@ static int orinoco_ioctl_set_encodeext(struct net_device *dev,
 			else
 				goto out;
 
-			priv->encode_alg = alg;
+			priv->encode_alg = ORINOCO_ALG_WEP;
 			priv->keys[idx].len = cpu_to_le16(key_len);
 
 			key_len = min(ext->key_len, key_len);
@@ -854,7 +852,7 @@ static int orinoco_ioctl_set_encodeext(struct net_device *dev,
 			    (ext->key_len > sizeof(priv->tkip_key[0])))
 				goto out;
 
-			priv->encode_alg = alg;
+			priv->encode_alg = ORINOCO_ALG_TKIP;
 			memset(&priv->tkip_key[idx], 0,
 			       sizeof(priv->tkip_key[idx]));
 			memcpy(&priv->tkip_key[idx], ext->key, ext->key_len);
@@ -914,19 +912,21 @@ static int orinoco_ioctl_get_encodeext(struct net_device *dev,
 	encoding->flags = idx + 1;
 	memset(ext, 0, sizeof(*ext));
 
-	ext->alg = priv->encode_alg;
 	switch (priv->encode_alg) {
-	case IW_ENCODE_ALG_NONE:
+	case ORINOCO_ALG_NONE:
+		ext->alg = IW_ENCODE_ALG_NONE;
 		ext->key_len = 0;
 		encoding->flags |= IW_ENCODE_DISABLED;
 		break;
-	case IW_ENCODE_ALG_WEP:
+	case ORINOCO_ALG_WEP:
+		ext->alg = IW_ENCODE_ALG_WEP;
 		ext->key_len = min_t(u16, le16_to_cpu(priv->keys[idx].len),
 				     max_key_len);
 		memcpy(ext->key, priv->keys[idx].data, ext->key_len);
 		encoding->flags |= IW_ENCODE_ENABLED;
 		break;
-	case IW_ENCODE_ALG_TKIP:
+	case ORINOCO_ALG_TKIP:
+		ext->alg = IW_ENCODE_ALG_TKIP;
 		ext->key_len = min_t(u16, sizeof(struct orinoco_tkip_key),
 				     max_key_len);
 		memcpy(ext->key, &priv->tkip_key[idx], ext->key_len);
-- 
1.6.3.3

