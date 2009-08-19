Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:14754 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751245AbZHSAEe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 20:04:34 -0400
Received: by ey-out-2122.google.com with SMTP id 22so862866eye.37
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 17:04:35 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 3/5] orinoco: implement cfg80211 key manipulation functions
Date: Wed, 19 Aug 2009 01:04:11 +0100
Message-Id: <1250640253-18434-4-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/cfg.c |  196 ++++++++++++++++++++++++++++++++++++
 1 files changed, 196 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 253cb4e..07775b6 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -493,6 +493,198 @@ static int orinoco_leave_ibss(struct wiphy *wiphy, struct net_device *dev)
 	return err;
 }
 
+static int orinoco_add_key(struct wiphy *wiphy, struct net_device *dev,
+			   u8 key_index, const u8 *mac_addr,
+			   struct key_params *params)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	int err = 0;
+	unsigned long lock;
+	enum orinoco_alg alg = ORINOCO_ALG_NONE;
+	int key_len;
+
+	if (key_index >= ORINOCO_MAX_KEYS)
+		return -EINVAL;
+
+	if (orinoco_lock(priv, &lock) != 0)
+		return -EBUSY;
+
+	switch (params->cipher) {
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		alg = ORINOCO_ALG_WEP;
+
+		if (!priv->has_wep)
+			err = -EOPNOTSUPP;
+
+		if (params->key_len > ORINOCO_MAX_KEY_SIZE)
+			err = -E2BIG;
+		else if (params->key_len > SMALL_KEY_SIZE)
+			key_len = LARGE_KEY_SIZE;
+		else if (params->key_len > 0)
+			key_len = SMALL_KEY_SIZE;
+		else
+			err = -EINVAL;
+
+		break;
+
+	case WLAN_CIPHER_SUITE_TKIP:
+		alg = ORINOCO_ALG_TKIP;
+
+		if (!priv->has_wpa)
+			err = -EOPNOTSUPP;
+		else if (params->key_len < WLAN_KEY_LEN_TKIP)
+			err = -EINVAL;
+
+		key_len = WLAN_KEY_LEN_TKIP;
+		break;
+
+	case WLAN_CIPHER_SUITE_CCMP:
+	case WLAN_CIPHER_SUITE_AES_CMAC:
+	default:
+		err = -EOPNOTSUPP;
+	}
+
+	if (err)
+		goto out;
+
+	/* Ensure existing keys are of the same cipher suite */
+	orinoco_set_encoding(priv, alg);
+
+	err = orinoco_set_key(priv, key_index, alg,
+			      params->key, params->key_len,
+			      params->seq, params->seq_len);
+	if (err)
+		goto out;
+
+	if (alg == ORINOCO_ALG_TKIP) {
+		/* If this is a pairwise key, assume it is the transmit key */
+		int set_tx = 0;
+		if (mac_addr) {
+			priv->tx_key = key_index;
+			set_tx = 1;
+		}
+		err = __orinoco_hw_set_tkip_key(priv, key_index, set_tx,
+						priv->keys[key_index].key,
+						priv->keys[key_index].seq,
+						priv->keys[key_index].seq_len,
+						NULL, 0);
+	}
+
+	err = __orinoco_hw_setup_enc(priv);
+
+ out:
+	orinoco_unlock(priv, &lock);
+
+	return err;
+}
+
+static int orinoco_get_key(struct wiphy *wiphy, struct net_device *dev,
+			   u8 key_index, const u8 *mac_addr, void *cookie,
+			   void (*callback)(void *cookie, struct key_params*))
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	struct key_params params;
+	u8 key[WLAN_KEY_LEN_TKIP];
+	u8 tsc[ORINOCO_SEQ_LEN];
+	unsigned long lock;
+	int err = 0;
+
+	if (key_index >= ORINOCO_MAX_KEYS)
+		return -EINVAL;
+
+	if (orinoco_lock(priv, &lock) != 0)
+		return -EBUSY;
+
+	/* Take a copy of the key info */
+	memcpy(&key, priv->keys[key_index].key, priv->keys[key_index].key_len);
+
+	params.cipher = priv->keys[key_index].cipher;
+	params.key = &key[0];
+	params.key_len = priv->keys[key_index].key_len;
+
+	if (params.cipher == WLAN_CIPHER_SUITE_TKIP) {
+		/* Populate the current TSC */
+		orinoco_hw_get_tkip_iv(priv, key_index, &tsc[0]);
+		params.seq = &tsc[0];
+		params.seq_len = ORINOCO_SEQ_LEN;
+	} else {
+		params.seq = NULL;
+		params.seq_len = 0;
+	}
+
+	orinoco_unlock(priv, &lock);
+
+	callback(cookie, &params);
+
+	return err;
+}
+
+static int orinoco_del_key(struct wiphy *wiphy, struct net_device *dev,
+			   u8 key_index, const u8 *mac_addr)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	int err = 0;
+	unsigned long lock;
+
+	if (key_index >= ORINOCO_MAX_KEYS)
+		return -EINVAL;
+
+	if (orinoco_lock(priv, &lock) != 0)
+		return -EBUSY;
+
+	kzfree(priv->keys[key_index].key);
+	kzfree(priv->keys[key_index].seq);
+	priv->keys[key_index].key = NULL;
+	priv->keys[key_index].seq = NULL;
+	priv->keys[key_index].key_len = 0;
+	priv->keys[key_index].seq_len = 0;
+	priv->keys[key_index].cipher = 0;
+
+	if (priv->has_wpa &&
+	    priv->keys[key_index].cipher == WLAN_CIPHER_SUITE_TKIP)
+		err = orinoco_clear_tkip_key(priv, key_index);
+
+	err = __orinoco_hw_setup_enc(priv);
+
+	orinoco_unlock(priv, &lock);
+
+	return err;
+}
+
+static int orinoco_set_default_key(struct wiphy *wiphy,
+				   struct net_device *netdev,
+				   u8 key_index)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	int err = 0;
+	unsigned long lock;
+
+	if (key_index >= ORINOCO_MAX_KEYS)
+		return -EINVAL;
+
+	if (orinoco_lock(priv, &lock) != 0)
+		return -EBUSY;
+
+	priv->tx_key = key_index;
+
+	if (priv->has_wpa &&
+	    priv->keys[key_index].cipher == WLAN_CIPHER_SUITE_TKIP)
+		err = __orinoco_hw_set_tkip_key(priv, key_index, 1,
+						priv->keys[key_index].key,
+						priv->keys[key_index].seq,
+						priv->keys[key_index].seq_len,
+						NULL, 0);
+	else if (priv->encode_alg == ORINOCO_ALG_WEP)
+		err = __orinoco_hw_setup_wepkeys(priv);
+	else
+		err = -EINVAL;
+
+	orinoco_unlock(priv, &lock);
+
+	return err;
+}
+
 const struct cfg80211_ops orinoco_cfg_ops = {
 	.change_virtual_intf = orinoco_change_vif,
 	.set_channel = orinoco_set_channel,
@@ -501,4 +693,8 @@ const struct cfg80211_ops orinoco_cfg_ops = {
 	.disconnect = orinoco_disconnect,
 	.join_ibss = orinoco_join_ibss,
 	.leave_ibss = orinoco_leave_ibss,
+	.add_key = orinoco_add_key,
+	.get_key = orinoco_get_key,
+	.del_key = orinoco_del_key,
+	.set_default_key = orinoco_set_default_key,
 };
-- 
1.6.3.3

