Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:35125 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZHEUdQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 16:33:16 -0400
Received: by mail-ew0-f214.google.com with SMTP id 10so291644ewy.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 13:33:16 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 4/4] orinoco: do WE via cfg80211
Date: Wed,  5 Aug 2009 21:32:52 +0100
Message-Id: <1249504372-17063-5-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
References: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Now that the driver supports both station and ad-hoc modes in cfg80211,
we can point the WE handlers at the cfg80211 versions.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/wext.c |  726 +----------------------------------
 1 files changed, 11 insertions(+), 715 deletions(-)

diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 3e56f76..e72b6b1 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -22,67 +22,6 @@
 
 #define MAX_RID_LEN 1024
 
-/* Helper routine to record keys
- * Do not call from interrupt context */
-static int orinoco_set_key(struct orinoco_private *priv, int index,
-			   enum orinoco_alg alg, const u8 *key, int key_len,
-			   const u8 *seq, int seq_len)
-{
-	kzfree(priv->keys[index].key);
-	kzfree(priv->keys[index].seq);
-
-	if (key_len) {
-		priv->keys[index].key = kzalloc(key_len, GFP_KERNEL);
-		if (!priv->keys[index].key)
-			goto nomem;
-	} else
-		priv->keys[index].key = NULL;
-
-	if (seq_len) {
-		priv->keys[index].seq = kzalloc(seq_len, GFP_KERNEL);
-		if (!priv->keys[index].seq)
-			goto free_key;
-	} else
-		priv->keys[index].seq = NULL;
-
-	priv->keys[index].key_len = key_len;
-	priv->keys[index].seq_len = seq_len;
-
-	if (key_len)
-		memcpy(priv->keys[index].key, key, key_len);
-	if (seq_len)
-		memcpy(priv->keys[index].seq, seq, seq_len);
-
-	switch (alg) {
-	case ORINOCO_ALG_TKIP:
-		priv->keys[index].cipher = WLAN_CIPHER_SUITE_TKIP;
-		break;
-
-	case ORINOCO_ALG_WEP:
-		priv->keys[index].cipher = (key_len > SMALL_KEY_SIZE) ?
-			WLAN_CIPHER_SUITE_WEP104 : WLAN_CIPHER_SUITE_WEP40;
-		break;
-
-	case ORINOCO_ALG_NONE:
-	default:
-		priv->keys[index].cipher = 0;
-		break;
-	}
-
-	return 0;
-
-free_key:
-	kfree(priv->keys[index].key);
-	priv->keys[index].key = NULL;
-
-nomem:
-	priv->keys[index].key_len = 0;
-	priv->keys[index].seq_len = 0;
-	priv->keys[index].cipher = 0;
-
-	return -ENOMEM;
-}
-
 static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
 {
 	struct orinoco_private *priv = ndev_priv(dev);
@@ -149,274 +88,6 @@ static struct iw_statistics *orinoco_get_wireless_stats(struct net_device *dev)
 /* Wireless extensions                                              */
 /********************************************************************/
 
-static int orinoco_ioctl_setwap(struct net_device *dev,
-				struct iw_request_info *info,
-				struct sockaddr *ap_addr,
-				char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	int err = -EINPROGRESS;		/* Call commit handler */
-	unsigned long flags;
-	static const u8 off_addr[] = { 0x00, 0x00, 0x00, 0x00, 0x00, 0x00 };
-	static const u8 any_addr[] = { 0xff, 0xff, 0xff, 0xff, 0xff, 0xff };
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	/* Enable automatic roaming - no sanity checks are needed */
-	if (memcmp(&ap_addr->sa_data, off_addr, ETH_ALEN) == 0 ||
-	    memcmp(&ap_addr->sa_data, any_addr, ETH_ALEN) == 0) {
-		priv->bssid_fixed = 0;
-		memset(priv->desired_bssid, 0, ETH_ALEN);
-
-		/* "off" means keep existing connection */
-		if (ap_addr->sa_data[0] == 0) {
-			__orinoco_hw_set_wap(priv);
-			err = 0;
-		}
-		goto out;
-	}
-
-	if (priv->firmware_type == FIRMWARE_TYPE_AGERE) {
-		printk(KERN_WARNING "%s: Lucent/Agere firmware doesn't "
-		       "support manual roaming\n",
-		       dev->name);
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	if (priv->iw_mode != NL80211_IFTYPE_STATION) {
-		printk(KERN_WARNING "%s: Manual roaming supported only in "
-		       "managed mode\n", dev->name);
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	/* Intersil firmware hangs without Desired ESSID */
-	if (priv->firmware_type == FIRMWARE_TYPE_INTERSIL &&
-	    strlen(priv->desired_essid) == 0) {
-		printk(KERN_WARNING "%s: Desired ESSID must be set for "
-		       "manual roaming\n", dev->name);
-		err = -EOPNOTSUPP;
-		goto out;
-	}
-
-	/* Finally, enable manual roaming */
-	priv->bssid_fixed = 1;
-	memcpy(priv->desired_bssid, &ap_addr->sa_data, ETH_ALEN);
-
- out:
-	orinoco_unlock(priv, &flags);
-	return err;
-}
-
-static int orinoco_ioctl_getwap(struct net_device *dev,
-				struct iw_request_info *info,
-				struct sockaddr *ap_addr,
-				char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-
-	int err = 0;
-	unsigned long flags;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	ap_addr->sa_family = ARPHRD_ETHER;
-	err = orinoco_hw_get_current_bssid(priv, ap_addr->sa_data);
-
-	orinoco_unlock(priv, &flags);
-
-	return err;
-}
-
-static int orinoco_ioctl_setiwencode(struct net_device *dev,
-				     struct iw_request_info *info,
-				     struct iw_point *erq,
-				     char *keybuf)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	int index = (erq->flags & IW_ENCODE_INDEX) - 1;
-	int setindex = priv->tx_key;
-	enum orinoco_alg encode_alg = priv->encode_alg;
-	int restricted = priv->wep_restrict;
-	int err = -EINPROGRESS;		/* Call commit handler */
-	unsigned long flags;
-
-	if (!priv->has_wep)
-		return -EOPNOTSUPP;
-
-	if (erq->pointer) {
-		/* We actually have a key to set - check its length */
-		if (erq->length > LARGE_KEY_SIZE)
-			return -E2BIG;
-
-		if ((erq->length > SMALL_KEY_SIZE) && !priv->has_big_wep)
-			return -E2BIG;
-	}
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	/* Clear any TKIP key we have */
-	if ((priv->has_wpa) && (priv->encode_alg == ORINOCO_ALG_TKIP))
-		(void) orinoco_clear_tkip_key(priv, setindex);
-
-	if (erq->length > 0) {
-		if ((index < 0) || (index >= ORINOCO_MAX_KEYS))
-			index = priv->tx_key;
-
-		/* Switch on WEP if off */
-		if (encode_alg != ORINOCO_ALG_WEP) {
-			setindex = index;
-			encode_alg = ORINOCO_ALG_WEP;
-		}
-	} else {
-		/* Important note : if the user do "iwconfig eth0 enc off",
-		 * we will arrive there with an index of -1. This is valid
-		 * but need to be taken care off... Jean II */
-		if ((index < 0) || (index >= ORINOCO_MAX_KEYS)) {
-			if ((index != -1) || (erq->flags == 0)) {
-				err = -EINVAL;
-				goto out;
-			}
-		} else {
-			/* Set the index : Check that the key is valid */
-			if (priv->keys[index].key_len == 0) {
-				err = -EINVAL;
-				goto out;
-			}
-			setindex = index;
-		}
-	}
-
-	if (erq->flags & IW_ENCODE_DISABLED)
-		encode_alg = ORINOCO_ALG_NONE;
-	if (erq->flags & IW_ENCODE_OPEN)
-		restricted = 0;
-	if (erq->flags & IW_ENCODE_RESTRICTED)
-		restricted = 1;
-
-	if (erq->pointer && erq->length > 0) {
-		err = orinoco_set_key(priv, index, ORINOCO_ALG_WEP, keybuf,
-				      erq->length, NULL, 0);
-	}
-	priv->tx_key = setindex;
-
-	/* Try fast key change if connected and only keys are changed */
-	if ((priv->encode_alg == encode_alg) &&
-	    (priv->wep_restrict == restricted) &&
-	    netif_carrier_ok(dev)) {
-		err = __orinoco_hw_setup_wepkeys(priv);
-		/* No need to commit if successful */
-		goto out;
-	}
-
-	priv->encode_alg = encode_alg;
-	priv->wep_restrict = restricted;
-
- out:
-	orinoco_unlock(priv, &flags);
-
-	return err;
-}
-
-static int orinoco_ioctl_getiwencode(struct net_device *dev,
-				     struct iw_request_info *info,
-				     struct iw_point *erq,
-				     char *keybuf)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	int index = (erq->flags & IW_ENCODE_INDEX) - 1;
-	unsigned long flags;
-
-	if (!priv->has_wep)
-		return -EOPNOTSUPP;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	if ((index < 0) || (index >= ORINOCO_MAX_KEYS))
-		index = priv->tx_key;
-
-	erq->flags = 0;
-	if (!priv->encode_alg)
-		erq->flags |= IW_ENCODE_DISABLED;
-	erq->flags |= index + 1;
-
-	if (priv->wep_restrict)
-		erq->flags |= IW_ENCODE_RESTRICTED;
-	else
-		erq->flags |= IW_ENCODE_OPEN;
-
-	erq->length = priv->keys[index].key_len;
-
-	memcpy(keybuf, priv->keys[index].key, erq->length);
-
-	orinoco_unlock(priv, &flags);
-	return 0;
-}
-
-static int orinoco_ioctl_setessid(struct net_device *dev,
-				  struct iw_request_info *info,
-				  struct iw_point *erq,
-				  char *essidbuf)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	unsigned long flags;
-
-	/* Note : ESSID is ignored in Ad-Hoc demo mode, but we can set it
-	 * anyway... - Jean II */
-
-	/* Hum... Should not use Wireless Extension constant (may change),
-	 * should use our own... - Jean II */
-	if (erq->length > IW_ESSID_MAX_SIZE)
-		return -E2BIG;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	/* NULL the string (for NULL termination & ESSID = ANY) - Jean II */
-	memset(priv->desired_essid, 0, sizeof(priv->desired_essid));
-
-	/* If not ANY, get the new ESSID */
-	if (erq->flags)
-		memcpy(priv->desired_essid, essidbuf, erq->length);
-
-	orinoco_unlock(priv, &flags);
-
-	return -EINPROGRESS;		/* Call commit handler */
-}
-
-static int orinoco_ioctl_getessid(struct net_device *dev,
-				  struct iw_request_info *info,
-				  struct iw_point *erq,
-				  char *essidbuf)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	int active;
-	int err = 0;
-	unsigned long flags;
-
-	if (netif_running(dev)) {
-		err = orinoco_hw_get_essid(priv, &active, essidbuf);
-		if (err < 0)
-			return err;
-		erq->length = err;
-	} else {
-		if (orinoco_lock(priv, &flags) != 0)
-			return -EBUSY;
-		memcpy(essidbuf, priv->desired_essid, IW_ESSID_MAX_SIZE);
-		erq->length = strlen(priv->desired_essid);
-		orinoco_unlock(priv, &flags);
-	}
-
-	erq->flags = 1;
-
-	return 0;
-}
-
 static int orinoco_ioctl_setfreq(struct net_device *dev,
 				 struct iw_request_info *info,
 				 struct iw_freq *frq,
@@ -827,379 +498,6 @@ static int orinoco_ioctl_getpower(struct net_device *dev,
 	return err;
 }
 
-static int orinoco_ioctl_set_encodeext(struct net_device *dev,
-				       struct iw_request_info *info,
-				       union iwreq_data *wrqu,
-				       char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	struct iw_point *encoding = &wrqu->encoding;
-	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	int idx, alg = ext->alg, set_key = 1;
-	unsigned long flags;
-	int err = -EINVAL;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	/* Determine and validate the key index */
-	idx = encoding->flags & IW_ENCODE_INDEX;
-	if (idx) {
-		if ((idx < 1) || (idx > 4))
-			goto out;
-		idx--;
-	} else
-		idx = priv->tx_key;
-
-	if (encoding->flags & IW_ENCODE_DISABLED)
-		alg = IW_ENCODE_ALG_NONE;
-
-	if (priv->has_wpa && (alg != IW_ENCODE_ALG_TKIP)) {
-		/* Clear any TKIP TX key we had */
-		(void) orinoco_clear_tkip_key(priv, priv->tx_key);
-	}
-
-	if (ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
-		priv->tx_key = idx;
-		set_key = ((alg == IW_ENCODE_ALG_TKIP) ||
-			   (ext->key_len > 0)) ? 1 : 0;
-	}
-
-	if (set_key) {
-		/* Set the requested key first */
-		switch (alg) {
-		case IW_ENCODE_ALG_NONE:
-			priv->encode_alg = ORINOCO_ALG_NONE;
-			err = orinoco_set_key(priv, idx, ORINOCO_ALG_NONE,
-					      NULL, 0, NULL, 0);
-			break;
-
-		case IW_ENCODE_ALG_WEP:
-			if (ext->key_len <= 0)
-				goto out;
-
-			priv->encode_alg = ORINOCO_ALG_WEP;
-			err = orinoco_set_key(priv, idx, ORINOCO_ALG_WEP,
-					      ext->key, ext->key_len, NULL, 0);
-			break;
-
-		case IW_ENCODE_ALG_TKIP:
-		{
-			u8 *tkip_iv = NULL;
-
-			if (!priv->has_wpa ||
-			    (ext->key_len > sizeof(struct orinoco_tkip_key)))
-				goto out;
-
-			priv->encode_alg = ORINOCO_ALG_TKIP;
-
-			if (ext->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID)
-				tkip_iv = &ext->rx_seq[0];
-
-			err = orinoco_set_key(priv, idx, ORINOCO_ALG_TKIP,
-					      ext->key, ext->key_len, tkip_iv,
-					      ORINOCO_SEQ_LEN);
-
-			err = __orinoco_hw_set_tkip_key(priv, idx,
-				 ext->ext_flags & IW_ENCODE_EXT_SET_TX_KEY,
-				 priv->keys[idx].key,
-				 tkip_iv, ORINOCO_SEQ_LEN, NULL, 0);
-			if (err)
-				printk(KERN_ERR "%s: Error %d setting TKIP key"
-				       "\n", dev->name, err);
-
-			goto out;
-		}
-		default:
-			goto out;
-		}
-	}
-	err = -EINPROGRESS;
- out:
-	orinoco_unlock(priv, &flags);
-
-	return err;
-}
-
-static int orinoco_ioctl_get_encodeext(struct net_device *dev,
-				       struct iw_request_info *info,
-				       union iwreq_data *wrqu,
-				       char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	struct iw_point *encoding = &wrqu->encoding;
-	struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
-	int idx, max_key_len;
-	unsigned long flags;
-	int err;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	err = -EINVAL;
-	max_key_len = encoding->length - sizeof(*ext);
-	if (max_key_len < 0)
-		goto out;
-
-	idx = encoding->flags & IW_ENCODE_INDEX;
-	if (idx) {
-		if ((idx < 1) || (idx > 4))
-			goto out;
-		idx--;
-	} else
-		idx = priv->tx_key;
-
-	encoding->flags = idx + 1;
-	memset(ext, 0, sizeof(*ext));
-
-	switch (priv->encode_alg) {
-	case ORINOCO_ALG_NONE:
-		ext->alg = IW_ENCODE_ALG_NONE;
-		ext->key_len = 0;
-		encoding->flags |= IW_ENCODE_DISABLED;
-		break;
-	case ORINOCO_ALG_WEP:
-		ext->alg = IW_ENCODE_ALG_WEP;
-		ext->key_len = min(priv->keys[idx].key_len, max_key_len);
-		memcpy(ext->key, priv->keys[idx].key, ext->key_len);
-		encoding->flags |= IW_ENCODE_ENABLED;
-		break;
-	case ORINOCO_ALG_TKIP:
-		ext->alg = IW_ENCODE_ALG_TKIP;
-		ext->key_len = min(priv->keys[idx].key_len, max_key_len);
-		memcpy(ext->key, priv->keys[idx].key, ext->key_len);
-		encoding->flags |= IW_ENCODE_ENABLED;
-		break;
-	}
-
-	err = 0;
- out:
-	orinoco_unlock(priv, &flags);
-
-	return err;
-}
-
-static int orinoco_ioctl_set_auth(struct net_device *dev,
-				  struct iw_request_info *info,
-				  union iwreq_data *wrqu, char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	hermes_t *hw = &priv->hw;
-	struct iw_param *param = &wrqu->param;
-	unsigned long flags;
-	int ret = -EINPROGRESS;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	switch (param->flags & IW_AUTH_INDEX) {
-	case IW_AUTH_WPA_VERSION:
-	case IW_AUTH_CIPHER_PAIRWISE:
-	case IW_AUTH_CIPHER_GROUP:
-	case IW_AUTH_RX_UNENCRYPTED_EAPOL:
-	case IW_AUTH_PRIVACY_INVOKED:
-	case IW_AUTH_DROP_UNENCRYPTED:
-		/*
-		 * orinoco does not use these parameters
-		 */
-		break;
-
-	case IW_AUTH_KEY_MGMT:
-		/* wl_lkm implies value 2 == PSK for Hermes I
-		 * which ties in with WEXT
-		 * no other hints tho :(
-		 */
-		priv->key_mgmt = param->value;
-		break;
-
-	case IW_AUTH_TKIP_COUNTERMEASURES:
-		/* When countermeasures are enabled, shut down the
-		 * card; when disabled, re-enable the card. This must
-		 * take effect immediately.
-		 *
-		 * TODO: Make sure that the EAPOL message is getting
-		 *       out before card disabled
-		 */
-		if (param->value) {
-			priv->tkip_cm_active = 1;
-			ret = hermes_enable_port(hw, 0);
-		} else {
-			priv->tkip_cm_active = 0;
-			ret = hermes_disable_port(hw, 0);
-		}
-		break;
-
-	case IW_AUTH_80211_AUTH_ALG:
-		if (param->value & IW_AUTH_ALG_SHARED_KEY)
-			priv->wep_restrict = 1;
-		else if (param->value & IW_AUTH_ALG_OPEN_SYSTEM)
-			priv->wep_restrict = 0;
-		else
-			ret = -EINVAL;
-		break;
-
-	case IW_AUTH_WPA_ENABLED:
-		if (priv->has_wpa) {
-			priv->wpa_enabled = param->value ? 1 : 0;
-		} else {
-			if (param->value)
-				ret = -EOPNOTSUPP;
-			/* else silently accept disable of WPA */
-			priv->wpa_enabled = 0;
-		}
-		break;
-
-	default:
-		ret = -EOPNOTSUPP;
-	}
-
-	orinoco_unlock(priv, &flags);
-	return ret;
-}
-
-static int orinoco_ioctl_get_auth(struct net_device *dev,
-				  struct iw_request_info *info,
-				  union iwreq_data *wrqu, char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	struct iw_param *param = &wrqu->param;
-	unsigned long flags;
-	int ret = 0;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	switch (param->flags & IW_AUTH_INDEX) {
-	case IW_AUTH_KEY_MGMT:
-		param->value = priv->key_mgmt;
-		break;
-
-	case IW_AUTH_TKIP_COUNTERMEASURES:
-		param->value = priv->tkip_cm_active;
-		break;
-
-	case IW_AUTH_80211_AUTH_ALG:
-		if (priv->wep_restrict)
-			param->value = IW_AUTH_ALG_SHARED_KEY;
-		else
-			param->value = IW_AUTH_ALG_OPEN_SYSTEM;
-		break;
-
-	case IW_AUTH_WPA_ENABLED:
-		param->value = priv->wpa_enabled;
-		break;
-
-	default:
-		ret = -EOPNOTSUPP;
-	}
-
-	orinoco_unlock(priv, &flags);
-	return ret;
-}
-
-static int orinoco_ioctl_set_genie(struct net_device *dev,
-				   struct iw_request_info *info,
-				   union iwreq_data *wrqu, char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	u8 *buf;
-	unsigned long flags;
-
-	/* cut off at IEEE80211_MAX_DATA_LEN */
-	if ((wrqu->data.length > IEEE80211_MAX_DATA_LEN) ||
-	    (wrqu->data.length && (extra == NULL)))
-		return -EINVAL;
-
-	if (wrqu->data.length) {
-		buf = kmalloc(wrqu->data.length, GFP_KERNEL);
-		if (buf == NULL)
-			return -ENOMEM;
-
-		memcpy(buf, extra, wrqu->data.length);
-	} else
-		buf = NULL;
-
-	if (orinoco_lock(priv, &flags) != 0) {
-		kfree(buf);
-		return -EBUSY;
-	}
-
-	kfree(priv->wpa_ie);
-	priv->wpa_ie = buf;
-	priv->wpa_ie_len = wrqu->data.length;
-
-	if (priv->wpa_ie) {
-		/* Looks like wl_lkm wants to check the auth alg, and
-		 * somehow pass it to the firmware.
-		 * Instead it just calls the key mgmt rid
-		 *   - we do this in set auth.
-		 */
-	}
-
-	orinoco_unlock(priv, &flags);
-	return 0;
-}
-
-static int orinoco_ioctl_get_genie(struct net_device *dev,
-				   struct iw_request_info *info,
-				   union iwreq_data *wrqu, char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	unsigned long flags;
-	int err = 0;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	if ((priv->wpa_ie_len == 0) || (priv->wpa_ie == NULL)) {
-		wrqu->data.length = 0;
-		goto out;
-	}
-
-	if (wrqu->data.length < priv->wpa_ie_len) {
-		err = -E2BIG;
-		goto out;
-	}
-
-	wrqu->data.length = priv->wpa_ie_len;
-	memcpy(extra, priv->wpa_ie, priv->wpa_ie_len);
-
-out:
-	orinoco_unlock(priv, &flags);
-	return err;
-}
-
-static int orinoco_ioctl_set_mlme(struct net_device *dev,
-				  struct iw_request_info *info,
-				  union iwreq_data *wrqu, char *extra)
-{
-	struct orinoco_private *priv = ndev_priv(dev);
-	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-	unsigned long flags;
-	int ret = 0;
-
-	if (orinoco_lock(priv, &flags) != 0)
-		return -EBUSY;
-
-	switch (mlme->cmd) {
-	case IW_MLME_DEAUTH:
-		/* silently ignore */
-		break;
-
-	case IW_MLME_DISASSOC:
-
-		ret = orinoco_hw_disassociate(priv, mlme->addr.sa_data,
-					      mlme->reason_code);
-		break;
-
-	default:
-		ret = -EOPNOTSUPP;
-	}
-
-	orinoco_unlock(priv, &flags);
-	return ret;
-}
-
 static int orinoco_ioctl_getretry(struct net_device *dev,
 				  struct iw_request_info *info,
 				  struct iw_param *rrq,
@@ -1521,12 +819,12 @@ static const iw_handler	orinoco_handler[] = {
 	STD_IW_HANDLER(SIOCGIWSPY,	iw_handler_get_spy),
 	STD_IW_HANDLER(SIOCSIWTHRSPY,	iw_handler_set_thrspy),
 	STD_IW_HANDLER(SIOCGIWTHRSPY,	iw_handler_get_thrspy),
-	STD_IW_HANDLER(SIOCSIWAP,	orinoco_ioctl_setwap),
-	STD_IW_HANDLER(SIOCGIWAP,	orinoco_ioctl_getwap),
+	STD_IW_HANDLER(SIOCSIWAP,	cfg80211_wext_siwap),
+	STD_IW_HANDLER(SIOCGIWAP,	cfg80211_wext_giwap),
 	STD_IW_HANDLER(SIOCSIWSCAN,	cfg80211_wext_siwscan),
 	STD_IW_HANDLER(SIOCGIWSCAN,	cfg80211_wext_giwscan),
-	STD_IW_HANDLER(SIOCSIWESSID,	orinoco_ioctl_setessid),
-	STD_IW_HANDLER(SIOCGIWESSID,	orinoco_ioctl_getessid),
+	STD_IW_HANDLER(SIOCSIWESSID,	cfg80211_wext_siwessid),
+	STD_IW_HANDLER(SIOCGIWESSID,	cfg80211_wext_giwessid),
 	STD_IW_HANDLER(SIOCSIWRATE,	orinoco_ioctl_setrate),
 	STD_IW_HANDLER(SIOCGIWRATE,	orinoco_ioctl_getrate),
 	STD_IW_HANDLER(SIOCSIWRTS,	orinoco_ioctl_setrts),
@@ -1534,17 +832,15 @@ static const iw_handler	orinoco_handler[] = {
 	STD_IW_HANDLER(SIOCSIWFRAG,	orinoco_ioctl_setfrag),
 	STD_IW_HANDLER(SIOCGIWFRAG,	orinoco_ioctl_getfrag),
 	STD_IW_HANDLER(SIOCGIWRETRY,	orinoco_ioctl_getretry),
-	STD_IW_HANDLER(SIOCSIWENCODE,	orinoco_ioctl_setiwencode),
-	STD_IW_HANDLER(SIOCGIWENCODE,	orinoco_ioctl_getiwencode),
+	STD_IW_HANDLER(SIOCSIWENCODE,	cfg80211_wext_siwencode),
+	STD_IW_HANDLER(SIOCGIWENCODE,	cfg80211_wext_giwencode),
 	STD_IW_HANDLER(SIOCSIWPOWER,	orinoco_ioctl_setpower),
 	STD_IW_HANDLER(SIOCGIWPOWER,	orinoco_ioctl_getpower),
-	STD_IW_HANDLER(SIOCSIWGENIE,	orinoco_ioctl_set_genie),
-	STD_IW_HANDLER(SIOCGIWGENIE,	orinoco_ioctl_get_genie),
-	STD_IW_HANDLER(SIOCSIWMLME,	orinoco_ioctl_set_mlme),
-	STD_IW_HANDLER(SIOCSIWAUTH,	orinoco_ioctl_set_auth),
-	STD_IW_HANDLER(SIOCGIWAUTH,	orinoco_ioctl_get_auth),
-	STD_IW_HANDLER(SIOCSIWENCODEEXT, orinoco_ioctl_set_encodeext),
-	STD_IW_HANDLER(SIOCGIWENCODEEXT, orinoco_ioctl_get_encodeext),
+	STD_IW_HANDLER(SIOCSIWGENIE,	cfg80211_wext_siwgenie),
+	STD_IW_HANDLER(SIOCSIWMLME,	cfg80211_wext_siwmlme),
+	STD_IW_HANDLER(SIOCSIWAUTH,	cfg80211_wext_siwauth),
+	STD_IW_HANDLER(SIOCGIWAUTH,	cfg80211_wext_giwauth),
+	STD_IW_HANDLER(SIOCSIWENCODEEXT, cfg80211_wext_siwencodeext),
 };
 
 
-- 
1.6.3.3

