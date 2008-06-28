Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ik-out-1112.google.com ([66.249.90.179]:16947 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865AbYF1Sjl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 14:39:41 -0400
Received: by ik-out-1112.google.com with SMTP id c28so379044ika.5
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jun 2008 11:39:40 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Cc: proski@gnu.org, orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>
Subject: [RFC PATCH 16/19] orinoco: Add WE-18 ioctls for WPA
Date: Sat, 28 Jun 2008 19:38:22 +0100
Message-Id: <1214678305-7057-17-git-send-email-kilroyd@gmail.com> (sfid-20080628_210811_514468_63F34A84)
In-Reply-To: <1214678305-7057-16-git-send-email-kilroyd@gmail.com>
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
 <1214678305-7057-14-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-15-git-send-email-kilroyd@gmail.com>
 <1214678305-7057-16-git-send-email-kilroyd@gmail.com>
From: kilroyd@googlemail.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Includes basic plumbing to get the data into firmware, and retrieve it.

SIOCxIWGENIE simply record (and return) the IE, and do not act on it.

SIOCxIWENCODEEXT, SIOCxIWAUTH and SIOCSIWMLME should be as functional as
the driver will support.

Signed-off-by: David Kilroy <kilroyd@gmail.com>
---
 drivers/net/wireless/hermes_rid.h |   16 ++
 drivers/net/wireless/orinoco.c    |  526 ++++++++++++++++++++++++++++++++++++-
 drivers/net/wireless/orinoco.h    |   20 ++
 3 files changed, 554 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/hermes_rid.h b/drivers/net/wireless/hermes_rid.h
index bcd9c82..42eb67d 100644
--- a/drivers/net/wireless/hermes_rid.h
+++ b/drivers/net/wireless/hermes_rid.h
@@ -30,6 +30,7 @@
 #define HERMES_RID_CNFWEPENABLED_AGERE		0xFC20
 #define HERMES_RID_CNFAUTHENTICATION_AGERE	0xFC21
 #define HERMES_RID_CNFMANDATORYBSSID_SYMBOL	0xFC21
+#define HERMES_RID_CNFDROPUNENCRYPTED		0xFC22
 #define HERMES_RID_CNFWEPDEFAULTKEYID		0xFC23
 #define HERMES_RID_CNFDEFAULTKEY0		0xFC24
 #define HERMES_RID_CNFDEFAULTKEY1		0xFC25
@@ -85,7 +86,16 @@
 #define HERMES_RID_CNFSCANSSID_AGERE		0xFCB2
 #define HERMES_RID_CNFBASICRATES		0xFCB3
 #define HERMES_RID_CNFSUPPORTEDRATES		0xFCB4
+#define HERMES_RID_CNFADDDEFAULTTKIPKEY_AGERE	0xFCB4
+#define HERMES_RID_CNFSETWPAAUTHMGMTSUITE_AGERE	0xFCB5
+#define HERMES_RID_CNFREMDEFAULTTKIPKEY_AGERE	0xFCB6
+#define HERMES_RID_CNFADDMAPPEDTKIPKEY_AGERE	0xFCB7
+#define HERMES_RID_CNFREMMAPPEDTKIPKEY_AGERE	0xFCB8
+#define HERMES_RID_CNFSETWPACAPABILITIES_AGERE	0xFCB9
+#define HERMES_RID_CNFCACHEDPMKADDRESS		0xFCBA
+#define HERMES_RID_CNFREMOVEPMKADDRESS		0xFCBB
 #define HERMES_RID_CNFSCANCHANNELS2GHZ		0xFCC2
+#define HERMES_RID_CNFDISASSOCIATE		0xFCC8
 #define HERMES_RID_CNFTICKTIME			0xFCE0
 #define HERMES_RID_CNFSCANREQUEST		0xFCE1
 #define HERMES_RID_CNFJOINREQUEST		0xFCE2
@@ -138,6 +148,12 @@
 #define HERMES_RID_CURRENTTXRATE6		0xFD85
 #define HERMES_RID_OWNMACADDR			0xFD86
 #define HERMES_RID_SCANRESULTSTABLE		0xFD88
+#define HERMES_RID_CURRENT_COUNTRY_INFO		0xFD89
+#define HERMES_RID_CURRENT_WPA_IE		0xFD8A
+#define HERMES_RID_CURRENT_TKIP_IV		0xFD8B
+#define HERMES_RID_CURRENT_ASSOC_REQ_INFO	0xFD8C
+#define HERMES_RID_CURRENT_ASSOC_RESP_INFO	0xFD8D
+#define HERMES_RID_TXQUEUEEMPTY			0xFD91
 #define HERMES_RID_PHYTYPE			0xFDC0
 #define HERMES_RID_CURRENTCHANNEL		0xFDC1
 #define HERMES_RID_CURRENTPOWERSTATE		0xFDC2
diff --git a/drivers/net/wireless/orinoco.c b/drivers/net/wireless/orinoco.c
index 951d0f7..3e3d40e 100644
--- a/drivers/net/wireless/orinoco.c
+++ b/drivers/net/wireless/orinoco.c
@@ -79,6 +79,7 @@
 #include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/delay.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
 #include <linux/ethtool.h>
@@ -2038,7 +2039,7 @@ static int __orinoco_hw_set_wap(struct orinoco_private *priv)
 }
 
 /* Change the WEP keys and/or the current keys.  Can be called
- * either from __orinoco_hw_setup_wep() or directly from
+ * either from __orinoco_hw_setup_enc() or directly from
  * orinoco_ioctl_setiwencode().  In the later case the association
  * with the AP is not broken (if the firmware can handle it),
  * which is needed for 802.1x implementations. */
@@ -2098,7 +2099,7 @@ static int __orinoco_hw_setup_wepkeys(struct orinoco_private *priv)
 	return 0;
 }
 
-static int __orinoco_hw_setup_wep(struct orinoco_private *priv)
+static int __orinoco_hw_setup_enc(struct orinoco_private *priv)
 {
 	hermes_t *hw = &priv->hw;
 	int err = 0;
@@ -2106,7 +2107,8 @@ static int __orinoco_hw_setup_wep(struct orinoco_private *priv)
 	int auth_flag;
 	int enc_flag;
 
-	if (priv->encode_alg == IW_ENCODE_ALG_WEP)
+	/* Setup WEP keys for WEP and WPA */
+	if (priv->encode_alg)
 		__orinoco_hw_setup_wepkeys(priv);
 
 	if (priv->wep_restrict)
@@ -2114,7 +2116,9 @@ static int __orinoco_hw_setup_wep(struct orinoco_private *priv)
 	else
 		auth_flag = HERMES_AUTH_OPEN;
 
-	if (priv->encode_alg == IW_ENCODE_ALG_WEP)
+	if (priv->wpa_enabled)
+		enc_flag = 2;
+	else if (priv->encode_alg == IW_ENCODE_ALG_WEP)
 		enc_flag = 1;
 	else
 		enc_flag = 0;
@@ -2132,6 +2136,16 @@ static int __orinoco_hw_setup_wep(struct orinoco_private *priv)
 					   enc_flag);
 		if (err)
 			return err;
+
+		if (priv->has_wpa) {
+			/* Set WPA key management */
+			err = hermes_write_wordrec(hw, USER_BAP,
+				  HERMES_RID_CNFSETWPAAUTHMGMTSUITE_AGERE,
+				  priv->key_mgmt);
+			if (err)
+				return err;
+		}
+
 		break;
 
 	case FIRMWARE_TYPE_INTERSIL: /* Intersil style WEP */
@@ -2168,6 +2182,84 @@ static int __orinoco_hw_setup_wep(struct orinoco_private *priv)
 	return 0;
 }
 
+/* key must be 32 bytes, including the tx and rx MIC keys.
+ * rsc must be 8 bytes
+ * tsc must be 8 bytes or NULL
+ */
+static int __orinoco_hw_set_tkip_key(hermes_t *hw, int key_idx, int set_tx,
+				     u8 *key, u8 *rsc, u8 *tsc)
+{
+	struct {
+		__le16 idx;
+		u8 rsc[IW_ENCODE_SEQ_MAX_SIZE];
+		u8 key[TKIP_KEYLEN];
+		u8 tx_mic[MIC_KEYLEN];
+		u8 rx_mic[MIC_KEYLEN];
+		u8 tsc[IW_ENCODE_SEQ_MAX_SIZE];
+	} __attribute__ ((packed)) buf;
+	int ret;
+	int err;
+	int k;
+	u16 xmitting;
+
+	key_idx &= 0x3;
+
+	if (set_tx)
+		key_idx |= 0x8000;
+
+	buf.idx = cpu_to_le16(key_idx);
+	memcpy(buf.key, key,
+	       sizeof(buf.key) + sizeof(buf.tx_mic) + sizeof(buf.rx_mic));
+
+	if (rsc == NULL)
+		memset(buf.rsc, 0, sizeof(buf.rsc));
+	else
+		memcpy(buf.rsc, rsc, sizeof(buf.rsc));
+
+	if (tsc == NULL) {
+		memset(buf.tsc, 0, sizeof(buf.tsc));
+		buf.tsc[4] = 0x10;
+	} else {
+		memcpy(buf.tsc, tsc, sizeof(buf.tsc));
+	}
+
+	/* Wait upto 100ms for tx queue to empty */
+	k = 100;
+	do {
+		k--;
+		udelay(1000);
+		ret = hermes_read_wordrec(hw, USER_BAP, HERMES_RID_TXQUEUEEMPTY,
+					  &xmitting);
+		if (ret)
+			break;
+	} while ((k > 0) && xmitting);
+
+	if (k == 0)
+		ret = -ETIMEDOUT;
+
+	err = HERMES_WRITE_RECORD(hw, USER_BAP,
+				  HERMES_RID_CNFADDDEFAULTTKIPKEY_AGERE,
+				  &buf);
+
+	return ret ? ret : err;
+}
+
+static int orinoco_clear_tkip_key(struct orinoco_private *priv,
+				  int key_idx)
+{
+	hermes_t *hw = &priv->hw;
+	int err;
+
+	memset(&priv->tkip_key[key_idx], 0, sizeof(priv->tkip_key[key_idx]));
+	err = hermes_write_wordrec(hw, USER_BAP,
+				   HERMES_RID_CNFREMDEFAULTTKIPKEY_AGERE,
+				   key_idx);
+	if (err)
+		printk(KERN_WARNING "%s: Error %d clearing TKIP key %d\n",
+		       priv->ndev->name, err, key_idx);
+	return err;
+}
+
 static int __orinoco_program_rids(struct net_device *dev)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
@@ -2364,10 +2456,10 @@ static int __orinoco_program_rids(struct net_device *dev)
 	}
 
 	/* Set up encryption */
-	if (priv->has_wep) {
-		err = __orinoco_hw_setup_wep(priv);
+	if (priv->has_wep || priv->has_wpa) {
+		err = __orinoco_hw_setup_enc(priv);
 		if (err) {
-			printk(KERN_ERR "%s: Error %d activating WEP\n",
+			printk(KERN_ERR "%s: Error %d activating encryption\n",
 			       dev->name, err);
 			return err;
 		}
@@ -2727,6 +2819,7 @@ static int determine_firmware(struct net_device *dev)
 	priv->has_big_wep = 0;
 	priv->has_alt_txcntl = 0;
 	priv->has_ext_scan = 0;
+	priv->has_wpa = 0;
 	priv->do_fw_download = 0;
 
 	/* Determine capabilities from the firmware version */
@@ -2751,6 +2844,7 @@ static int determine_firmware(struct net_device *dev)
 		priv->broken_monitor = (firmver >= 0x80000);
 		priv->has_alt_txcntl = (firmver >= 0x90000); /* All 9.x ? */
 		priv->has_ext_scan = (firmver >= 0x90000); /* All 9.x ? */
+		priv->has_wpa = (firmver >= 0x9002a);
 		/* Tested with Agere firmware :
 		 *	1.16 ; 4.08 ; 4.52 ; 6.04 ; 6.16 ; 7.28 => Jean II
 		 * Tested CableTron firmware : 4.32 => Anton */
@@ -2890,6 +2984,8 @@ static int orinoco_init(struct net_device *dev)
 		else
 			printk("40-bit key\n");
 	}
+	if (priv->has_wpa)
+		printk(KERN_DEBUG "%s: WPA-PSK supported\n", dev->name);
 
 	/* Now we have the firmware capabilities, allocate appropiate
 	 * sized scan buffers */
@@ -3013,6 +3109,11 @@ static int orinoco_init(struct net_device *dev)
 	priv->promiscuous = 0;
 	priv->encode_alg = IW_ENCODE_ALG_NONE;
 	priv->tx_key = 0;
+	priv->wpa_enabled = 0;
+	priv->tkip_cm_active = 0;
+	priv->key_mgmt = 0;
+	priv->wpa_ie_len = 0;
+	priv->wpa_ie = NULL;
 
 	/* Make the hardware available, as long as it hasn't been
 	 * removed elsewhere (e.g. by PCMCIA hot unplug) */
@@ -3088,6 +3189,8 @@ void free_orinocodev(struct net_device *dev)
 {
 	struct orinoco_private *priv = netdev_priv(dev);
 
+	priv->wpa_ie_len = 0;
+	kfree(priv->wpa_ie);
 	orinoco_bss_data_free(priv);
 	free_netdev(dev);
 }
@@ -3399,7 +3502,7 @@ static int orinoco_ioctl_getiwrange(struct net_device *dev,
 	memset(range, 0, sizeof(struct iw_range));
 
 	range->we_version_compiled = WIRELESS_EXT;
-	range->we_version_source = 14;
+	range->we_version_source = 22;
 
 	/* Set available channels/frequencies */
 	range->num_channels = NUM_CHANNELS;
@@ -3429,6 +3532,9 @@ static int orinoco_ioctl_getiwrange(struct net_device *dev,
 		}
 	}
 
+	if (priv->has_wpa)
+		range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_CIPHER_TKIP;
+
 	if ((priv->iw_mode == IW_MODE_ADHOC) && (!SPY_NUMBER(priv))){
 		/* Quality stats meaningless in ad-hoc mode */
 	} else {
@@ -3521,6 +3627,10 @@ static int orinoco_ioctl_setiwencode(struct net_device *dev,
 	if (orinoco_lock(priv, &flags) != 0)
 		return -EBUSY;
 
+	/* Clear any TKIP key we have */
+	if ((priv->has_wpa) && (priv->encode_alg == IW_ENCODE_ALG_TKIP))
+		(void) orinoco_clear_tkip_key(priv, setindex);
+
 	if (erq->length > 0) {
 		if ((index < 0) || (index >= ORINOCO_MAX_KEYS))
 			index = priv->tx_key;
@@ -4185,6 +4295,399 @@ static int orinoco_ioctl_getpower(struct net_device *dev,
 	return err;
 }
 
+static int orinoco_ioctl_set_encodeext(struct net_device *dev,
+				       struct iw_request_info *info,
+				       union iwreq_data *wrqu,
+				       char *extra)
+{
+	struct orinoco_private *priv = netdev_priv(dev);
+	struct iw_point *encoding = &wrqu->encoding;
+	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
+	int idx, alg = ext->alg, set_key = 1;
+	unsigned long flags;
+	int err = -EINVAL;
+	u16 key_len;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	/* Determine and validate the key index */
+	idx = encoding->flags & IW_ENCODE_INDEX;
+	if (idx) {
+		if ((idx < 1) || (idx > WEP_KEYS))
+			goto out;
+		idx--;
+	} else
+		idx = priv->tx_key;
+
+	if (encoding->flags & IW_ENCODE_DISABLED)
+	    alg = IW_ENCODE_ALG_NONE;
+
+	if (priv->has_wpa && (alg != IW_ENCODE_ALG_TKIP)) {
+		/* Clear any TKIP TX key we had */
+		(void) orinoco_clear_tkip_key(priv, priv->tx_key);
+	}
+
+	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
+		priv->tx_key = idx;
+		set_key = ((alg == IW_ENCODE_ALG_TKIP) ||
+			   (ext->key_len > 0)) ? 1 : 0;
+	}
+
+	if (set_key) {
+		/* Set the requested key first */
+		switch (alg) {
+		case IW_ENCODE_ALG_NONE:
+			priv->encode_alg = alg;
+			priv->keys[idx].len = 0;
+			break;
+
+		case IW_ENCODE_ALG_WEP:
+			if (ext->key_len > SMALL_KEY_SIZE)
+				key_len = LARGE_KEY_SIZE;
+			else if (ext->key_len > 0)
+				key_len = SMALL_KEY_SIZE;
+			else
+				goto out;
+
+			priv->encode_alg = alg;
+			priv->keys[idx].len = cpu_to_le16(key_len);
+
+			key_len = min(ext->key_len, key_len);
+
+			memset(priv->keys[idx].data, 0, ORINOCO_MAX_KEY_SIZE);
+			memcpy(priv->keys[idx].data, ext->key, key_len);
+			break;
+
+		case IW_ENCODE_ALG_TKIP:
+		{
+			hermes_t *hw = &priv->hw;
+			u8 *tkip_iv = NULL;
+
+			if (!priv->has_wpa ||
+			    (ext->key_len > sizeof(priv->tkip_key[0])))
+				goto out;
+
+			priv->encode_alg = alg;
+			memset(&priv->tkip_key[idx], 0,
+			       sizeof(priv->tkip_key[idx]));
+			memcpy(&priv->tkip_key[idx], ext->key, ext->key_len);
+
+			if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID)
+				tkip_iv = &ext->rx_seq[0];
+
+			err = __orinoco_hw_set_tkip_key(hw, idx,
+				 ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY,
+				 (u8 *) &priv->tkip_key[idx],
+				 tkip_iv, NULL);
+			if (err)
+				printk(KERN_ERR "%s: Error %d setting TKIP key"
+				       "\n", dev->name, err);
+
+			goto out;
+		}
+		default:
+			goto out;
+		}
+	}
+	err = -EINPROGRESS;
+ out:
+	orinoco_unlock(priv, &flags);
+
+	return err;
+}
+
+static int orinoco_ioctl_get_encodeext(struct net_device *dev,
+				       struct iw_request_info *info,
+				       union iwreq_data *wrqu,
+				       char *extra)
+{
+	struct orinoco_private *priv = netdev_priv(dev);
+	struct iw_point *encoding = &wrqu->encoding;
+	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
+	int idx, max_key_len;
+	unsigned long flags;
+	int err;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	err = -EINVAL;
+	max_key_len = encoding->length - sizeof(*ext);
+	if (max_key_len < 0)
+		goto out;
+
+	idx = encoding->flags & IW_ENCODE_INDEX;
+	if (idx) {
+		if ((idx < 1) || (idx > WEP_KEYS))
+			goto out;
+		idx--;
+	} else
+		idx = priv->tx_key;
+
+	encoding->flags = idx + 1;
+	memset(ext, 0, sizeof(*ext));
+
+	ext->alg = priv->encode_alg;
+	switch (priv->encode_alg) {
+	case IW_ENCODE_ALG_NONE:
+		ext->key_len = 0;
+		encoding->flags |= IW_ENCODE_DISABLED;
+		break;
+	case IW_ENCODE_ALG_WEP:
+		ext->key_len = min(le16_to_cpu(priv->keys[idx].len),
+				   (u16) max_key_len);
+		memcpy(ext->key, priv->keys[idx].data, ext->key_len);
+		encoding->flags |= IW_ENCODE_ENABLED;
+		break;
+	case IW_ENCODE_ALG_TKIP:
+		ext->key_len = min((u16) sizeof(struct orinoco_tkip_key),
+				   (u16) max_key_len);
+		memcpy(ext->key, &priv->tkip_key[idx], ext->key_len);
+		encoding->flags |= IW_ENCODE_ENABLED;
+		break;
+	}
+
+	err = 0;
+ out:
+	orinoco_unlock(priv, &flags);
+
+	return err;
+}
+
+static int orinoco_ioctl_set_auth(struct net_device *dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *wrqu, char *extra)
+{
+	struct orinoco_private *priv = netdev_priv(dev);
+	hermes_t *hw = &priv->hw;
+	struct iw_param *param = &wrqu->param;
+	unsigned long flags;
+	int ret = -EINPROGRESS;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	switch (param->flags & IW_AUTH_INDEX) {
+	case IW_AUTH_WPA_VERSION:
+	case IW_AUTH_CIPHER_PAIRWISE:
+	case IW_AUTH_CIPHER_GROUP:
+	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
+	case IW_AUTH_PRIVACY_INVOKED:
+	case IW_AUTH_DROP_UNENCRYPTED:
+		/*
+		 * orinoco does not use these parameters
+		 */
+		break;
+
+	case IW_AUTH_KEY_MGMT:
+		/* wl_lkm implies value 2 == PSK for Hermes I
+		 * which ties in with WEXT
+		 * no other hints tho :(
+		 */
+		priv->key_mgmt = param->value;
+		break;
+
+	case IW_AUTH_TKIP_COUNTERMEASURES:
+		/* When countermeasures are enabled, shut down the
+		 * card; when disabled, re-enable the card. This must
+		 * take effect immediately.
+		 *
+		 * TODO: Make sure that the EAPOL message is getting
+		 *       out before card disabled
+		 */
+		if (param->value) {
+			priv->tkip_cm_active = 1;
+			ret = hermes_enable_port(hw, 0);
+		} else {
+			priv->tkip_cm_active = 0;
+			ret = hermes_disable_port(hw, 0);
+		}
+		break;
+
+	case IW_AUTH_80211_AUTH_ALG:
+		if (param->value & IW_AUTH_ALG_SHARED_KEY)
+			priv->wep_restrict = 1;
+		else if (param->value & IW_AUTH_ALG_OPEN_SYSTEM)
+			priv->wep_restrict = 0;
+		else
+			ret = -EINVAL;
+		break;
+
+	case IW_AUTH_WPA_ENABLED:
+		if (priv->has_wpa) {
+			priv->wpa_enabled = param->value ? 1 : 0;
+		} else {
+			if (param->value)
+				ret = -EOPNOTSUPP;
+			/* else silently accept disable of WPA */
+			priv->wpa_enabled = 0;
+		}
+		break;
+
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	orinoco_unlock(priv, &flags);
+	return ret;
+}
+
+static int orinoco_ioctl_get_auth(struct net_device *dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *wrqu, char *extra)
+{
+	struct orinoco_private *priv = netdev_priv(dev);
+	struct iw_param *param = &wrqu->param;
+	unsigned long flags;
+	int ret = 0;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	switch (param->flags & IW_AUTH_INDEX) {
+	case IW_AUTH_KEY_MGMT:
+		param->value = priv->key_mgmt;
+		break;
+
+	case IW_AUTH_TKIP_COUNTERMEASURES:
+		param->value = priv->tkip_cm_active;
+		break;
+
+	case IW_AUTH_80211_AUTH_ALG:
+		if (priv->wep_restrict)
+			param->value = IW_AUTH_ALG_SHARED_KEY;
+		else
+			param->value = IW_AUTH_ALG_OPEN_SYSTEM;
+		break;
+
+	case IW_AUTH_WPA_ENABLED:
+		param->value = priv->wpa_enabled;
+		break;
+
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	orinoco_unlock(priv, &flags);
+	return ret;
+}
+
+static int orinoco_ioctl_set_genie(struct net_device *dev,
+				   struct iw_request_info *info,
+				   union iwreq_data *wrqu, char *extra)
+{
+	struct orinoco_private *priv = netdev_priv(dev);
+	u8 *buf;
+	unsigned long flags;
+	int err = 0;
+
+	if ((wrqu->data.length > MAX_WPA_IE_LEN) ||
+	    (wrqu->data.length && (extra == NULL)))
+		return -EINVAL;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	if (wrqu->data.length) {
+		buf = kmalloc(wrqu->data.length, GFP_KERNEL);
+		if (buf == NULL) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		memcpy(buf, extra, wrqu->data.length);
+		kfree(priv->wpa_ie);
+		priv->wpa_ie = buf;
+		priv->wpa_ie_len = wrqu->data.length;
+	} else {
+		kfree(priv->wpa_ie);
+		priv->wpa_ie = NULL;
+		priv->wpa_ie_len = 0;
+	}
+
+	if (priv->wpa_ie) {
+		/* Looks like wl_lkm wants to check the auth alg, and
+		 * somehow pass it to the firmware.
+		 * Instead it just calls the key mgmt rid
+		 *   - we do this in set auth.
+		 */
+	}
+
+out:
+	orinoco_unlock(priv, &flags);
+	return err;
+}
+
+static int orinoco_ioctl_get_genie(struct net_device *dev,
+				   struct iw_request_info *info,
+				   union iwreq_data *wrqu, char *extra)
+{
+	struct orinoco_private *priv = netdev_priv(dev);
+	unsigned long flags;
+	int err = 0;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	if ((priv->wpa_ie_len == 0) || (priv->wpa_ie == NULL)) {
+		wrqu->data.length = 0;
+		goto out;
+	}
+
+	if (wrqu->data.length < priv->wpa_ie_len) {
+		err = -E2BIG;
+		goto out;
+	}
+
+	wrqu->data.length = priv->wpa_ie_len;
+	memcpy(extra, priv->wpa_ie, priv->wpa_ie_len);
+
+out:
+	orinoco_unlock(priv, &flags);
+	return err;
+}
+
+static int orinoco_ioctl_set_mlme(struct net_device *dev,
+				  struct iw_request_info *info,
+				  union iwreq_data *wrqu, char *extra)
+{
+	struct orinoco_private *priv = netdev_priv(dev);
+	hermes_t *hw = &priv->hw;
+	struct iw_mlme *mlme = (struct iw_mlme *)extra;
+	unsigned long flags;
+	int ret = 0;
+
+	if (orinoco_lock(priv, &flags) != 0)
+		return -EBUSY;
+
+	switch (mlme->cmd) {
+	case IW_MLME_DEAUTH:
+		/* silently ignore */
+		break;
+
+	case IW_MLME_DISASSOC:
+	{
+		struct {
+			u8 addr[ETH_ALEN];
+			__le16 reason_code;
+		} __attribute__ ((packed)) buf;
+
+		memcpy(buf.addr, mlme->addr.sa_data, ETH_ALEN);
+		buf.reason_code = cpu_to_le16(mlme->reason_code);
+		ret = HERMES_WRITE_RECORD(hw, USER_BAP,
+					  HERMES_RID_CNFDISASSOCIATE,
+					  &buf);
+		break;
+	}
+	default:
+		ret = -EOPNOTSUPP;
+	}
+
+	orinoco_unlock(priv, &flags);
+	return ret;
+}
+
 static int orinoco_ioctl_getretry(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_param *rrq,
@@ -5071,6 +5574,13 @@ static const iw_handler	orinoco_handler[] = {
 	STD_IW_HANDLER(SIOCGIWENCODE,	orinoco_ioctl_getiwencode),
 	STD_IW_HANDLER(SIOCSIWPOWER,	orinoco_ioctl_setpower),
 	STD_IW_HANDLER(SIOCGIWPOWER,	orinoco_ioctl_getpower),
+	STD_IW_HANDLER(SIOCSIWGENIE,	orinoco_ioctl_set_genie),
+	STD_IW_HANDLER(SIOCGIWGENIE,	orinoco_ioctl_get_genie),
+	STD_IW_HANDLER(SIOCSIWMLME,	orinoco_ioctl_set_mlme),
+	STD_IW_HANDLER(SIOCSIWAUTH,	orinoco_ioctl_set_auth),
+	STD_IW_HANDLER(SIOCGIWAUTH,	orinoco_ioctl_get_auth),
+	STD_IW_HANDLER(SIOCSIWENCODEEXT, orinoco_ioctl_set_encodeext),
+	STD_IW_HANDLER(SIOCGIWENCODEEXT, orinoco_ioctl_get_encodeext),
 };
 
 
diff --git a/drivers/net/wireless/orinoco.h b/drivers/net/wireless/orinoco.h
index 5605fd3..bfab88f 100644
--- a/drivers/net/wireless/orinoco.h
+++ b/drivers/net/wireless/orinoco.h
@@ -30,6 +30,15 @@ struct orinoco_key {
 	char data[ORINOCO_MAX_KEY_SIZE];
 } __attribute__ ((packed));
 
+#define TKIP_KEYLEN	16
+#define MIC_KEYLEN	8
+
+struct orinoco_tkip_key {
+	u8 tkip[TKIP_KEYLEN];
+	u8 tx_mic[MIC_KEYLEN];
+	u8 rx_mic[MIC_KEYLEN];
+};
+
 typedef enum {
 	FIRMWARE_TYPE_AGERE,
 	FIRMWARE_TYPE_INTERSIL,
@@ -93,6 +102,7 @@ struct orinoco_private {
 	unsigned int has_hostscan:1;
 	unsigned int has_alt_txcntl:1;
 	unsigned int has_ext_scan:1;
+	unsigned int has_wpa:1;
 	unsigned int do_fw_download:1;
 	unsigned int broken_disableport:1;
 	unsigned int broken_monitor:1;
@@ -128,6 +138,16 @@ struct orinoco_private {
 
 	int	scan_inprogress;	/* Scan pending... */
 	u32	scan_mode;		/* Type of scan done */
+
+	/* WPA support */
+	u8 *wpa_ie;
+	int wpa_ie_len;
+
+	struct orinoco_tkip_key tkip_key[ORINOCO_MAX_KEYS];
+
+	unsigned int wpa_enabled:1;
+	unsigned int tkip_cm_active:1;
+	unsigned int key_mgmt:3;
 };
 
 #ifdef ORINOCO_DEBUG
-- 
1.5.4.5

