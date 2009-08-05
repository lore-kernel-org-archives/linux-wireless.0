Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:20614 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbZHEUdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 16:33:03 -0400
Received: by ey-out-2122.google.com with SMTP id 9so231055eyd.37
        for <linux-wireless@vger.kernel.org>; Wed, 05 Aug 2009 13:33:03 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 1/4] orinoco: add cfg80211 connect and disconnect
Date: Wed,  5 Aug 2009 21:32:49 +0100
Message-Id: <1249504372-17063-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
References: <1249504372-17063-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Basic station mode support.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/cfg.c |  236 ++++++++++++++++++++++++++++++++++++
 1 files changed, 236 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 1a87d3a..56bd4f1 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -156,7 +156,243 @@ static int orinoco_scan(struct wiphy *wiphy, struct net_device *dev,
 	return err;
 }
 
+/* Helper to ensure all keys are valid for the current encoding
+   algorithm */
+static void orinoco_set_encoding(struct orinoco_private *priv,
+				 enum orinoco_alg encoding)
+{
+	if (priv->encode_alg &&
+	    priv->encode_alg != encoding) {
+		int i;
+
+		for (i = 0; i < ORINOCO_MAX_KEYS; i++) {
+			kfree(priv->keys[i].key);
+			kfree(priv->keys[i].seq);
+			priv->keys[i].key = NULL;
+			priv->keys[i].seq = NULL;
+			priv->keys[i].key_len = 0;
+			priv->keys[i].seq_len = 0;
+			priv->keys[i].cipher = 0;
+		}
+
+		if (priv->encode_alg == ORINOCO_ALG_TKIP &&
+		    priv->has_wpa) {
+			(void) orinoco_clear_tkip_key(priv, i);
+			(void) orinoco_clear_tkip_key(priv, i);
+			(void) orinoco_clear_tkip_key(priv, i);
+			(void) orinoco_clear_tkip_key(priv, i);
+		} else if (priv->encode_alg == ORINOCO_ALG_WEP)
+			__orinoco_hw_setup_wepkeys(priv);
+	}
+	priv->encode_alg = encoding;
+}
+
+/* Helper routine to record keys
+ * Do not call from interrupt context */
+static int orinoco_set_key(struct orinoco_private *priv, int index,
+			   enum orinoco_alg alg, const u8 *key, int key_len,
+			   const u8 *seq, int seq_len)
+{
+	kzfree(priv->keys[index].key);
+	kzfree(priv->keys[index].seq);
+
+	if (key_len) {
+		priv->keys[index].key = kzalloc(key_len, GFP_KERNEL);
+		if (!priv->keys[index].key)
+			goto nomem;
+	} else
+		priv->keys[index].key = NULL;
+
+	if (seq_len) {
+		priv->keys[index].seq = kzalloc(seq_len, GFP_KERNEL);
+		if (!priv->keys[index].seq)
+			goto free_key;
+	} else
+		priv->keys[index].seq = NULL;
+
+	priv->keys[index].key_len = key_len;
+	priv->keys[index].seq_len = seq_len;
+
+	if (key_len)
+		memcpy(priv->keys[index].key, key, key_len);
+	if (seq_len)
+		memcpy(priv->keys[index].seq, seq, seq_len);
+
+
+	switch (alg) {
+	case ORINOCO_ALG_TKIP:
+		priv->keys[index].cipher = WLAN_CIPHER_SUITE_TKIP;
+		break;
+
+	case ORINOCO_ALG_WEP:
+		priv->keys[index].cipher = (key_len > SMALL_KEY_SIZE) ?
+			WLAN_CIPHER_SUITE_WEP104 : WLAN_CIPHER_SUITE_WEP40;
+		break;
+
+	case ORINOCO_ALG_NONE:
+	default:
+		priv->keys[index].cipher = 0;
+		break;
+	}
+
+	return 0;
+
+free_key:
+	kfree(priv->keys[index].key);
+	priv->keys[index].key = NULL;
+
+nomem:
+	priv->keys[index].key_len = 0;
+	priv->keys[index].seq_len = 0;
+	priv->keys[index].cipher = 0;
+
+	return -ENOMEM;
+}
+
+/* Setup channel, SSID and BSSID */
+static int __orinoco_connect(struct wiphy *wiphy,
+			     struct ieee80211_channel *channel,
+			     const u8 *bssid, const u8 *ssid,
+			     u8 ssid_len)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+
+	if (channel) {
+		int chan;
+
+		chan = ieee80211_freq_to_dsss_chan(channel->center_freq);
+
+		if ((chan > 0) && (chan < NUM_CHANNELS) &&
+		    (priv->channel_mask & (1 << chan)))
+			priv->channel = chan;
+	}
+
+	memset(priv->desired_essid, 0, sizeof(priv->desired_essid));
+	if (ssid)
+		memcpy(priv->desired_essid, ssid, ssid_len);
+
+	if (bssid) {
+		memcpy(priv->desired_bssid, bssid, ETH_ALEN);
+
+		/* Intersil firmware hangs if you try to roam manually
+		 * without an ESSID set. */
+		if ((priv->firmware_type == FIRMWARE_TYPE_INTERSIL) &&
+		    (priv->desired_essid[0] == 0)) {
+			printk(KERN_WARNING "%s: Desired SSID must be set for "
+			       "manual roaming\n", wiphy_name(wiphy));
+			return -EOPNOTSUPP;
+		}
+
+		priv->bssid_fixed = 1;
+	} else {
+		memset(priv->desired_bssid, 0, ETH_ALEN);
+		priv->bssid_fixed = 0;
+	}
+
+	return 0;
+}
+
+static int orinoco_connect(struct wiphy *wiphy, struct net_device *dev,
+			   struct cfg80211_connect_params *sme)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	enum orinoco_alg encode_alg;
+	unsigned long lock;
+	int err;
+
+	if (orinoco_lock(priv, &lock) != 0)
+		return -EBUSY;
+
+	/* Setup the requested parameters in priv. If the card is not
+	 * capable, then the driver will just ignore the settings that
+	 * it can't do. */
+	err = __orinoco_connect(wiphy, sme->channel, sme->bssid,
+				sme->ssid, sme->ssid_len);
+	if (err)
+		goto out;
+
+	switch (sme->auth_type) {
+	case NL80211_AUTHTYPE_OPEN_SYSTEM:
+		priv->wep_restrict = 0;
+		break;
+	case NL80211_AUTHTYPE_SHARED_KEY:
+		priv->wep_restrict = 1;
+		break;
+	/* Ignore all other settings */
+	default:
+		break;
+	}
+
+	switch (sme->crypto.cipher_group) {
+	case WLAN_CIPHER_SUITE_TKIP:
+		encode_alg = ORINOCO_ALG_TKIP;
+		break;
+
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		encode_alg = ORINOCO_ALG_WEP;
+		break;
+
+	default:
+		encode_alg = ORINOCO_ALG_NONE;
+	}
+
+	orinoco_set_encoding(priv, encode_alg);
+
+	/* What are we supposed to do with multiple AKM suites? */
+	if (sme->crypto.n_akm_suites > 0)
+		priv->key_mgmt = sme->crypto.akm_suites[0];
+
+	/* Finally, set WEP key */
+	if (encode_alg == ORINOCO_ALG_WEP) {
+		err = orinoco_set_key(priv, sme->key_idx, encode_alg,
+				      &sme->key[0], sme->key_len, NULL, 0);
+		if (err)
+			goto out;
+
+		priv->tx_key = sme->key_idx;
+	}
+
+	err = orinoco_commit(priv);
+
+out:
+	orinoco_unlock(priv, &lock);
+
+	return err;
+}
+
+static int orinoco_disconnect(struct wiphy *wiphy, struct net_device *dev,
+			      u16 reason_code)
+{
+	struct orinoco_private *priv = wiphy_priv(wiphy);
+	unsigned long lock;
+	u8 addr[ETH_ALEN];
+	int err;
+
+	if (orinoco_lock(priv, &lock) != 0)
+		return -EBUSY;
+
+	memset(priv->desired_bssid, 0, ETH_ALEN);
+	memset(priv->desired_essid, 0, sizeof(priv->desired_essid));
+
+	err = orinoco_hw_get_current_bssid(priv, &addr[0]);
+
+	if (!err) {
+		err = orinoco_hw_disassociate(priv, &addr[0],
+					      reason_code);
+	}
+
+	if (err)
+		err = orinoco_commit(priv);
+
+	orinoco_unlock(priv, &lock);
+
+	return err;
+}
+
 const struct cfg80211_ops orinoco_cfg_ops = {
 	.change_virtual_intf = orinoco_change_vif,
 	.scan = orinoco_scan,
+	.connect = orinoco_connect,
+	.disconnect = orinoco_disconnect,
 };
-- 
1.6.3.3

