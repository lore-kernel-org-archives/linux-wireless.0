Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:14754 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbZHSAE1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 20:04:27 -0400
Received: by ey-out-2122.google.com with SMTP id 22so862866eye.37
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 17:04:28 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 1/5] orinoco: add cfg80211 connect and disconnect
Date: Wed, 19 Aug 2009 01:04:09 +0100
Message-Id: <1250640253-18434-2-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Basic station mode support.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/net/wireless/orinoco/cfg.c     |  244 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/orinoco/main.c    |  164 ++++++++++++----------
 drivers/net/wireless/orinoco/orinoco.h |    1 +
 3 files changed, 333 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 27f2d33..09b38e9 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -196,8 +196,252 @@ static int orinoco_set_channel(struct wiphy *wiphy,
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
+		/* Intersil firmware hangs if you try to roam manually
+		 * without an SSID set. We should always get one in
+		 * this call, but just check.
+		 */
+		BUG_ON(ssid_len == 0);
+
+		memcpy(priv->desired_bssid, bssid, ETH_ALEN);
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
+	default:
+		/* Can't handle anything else */
+		err = -EINVAL;
+		goto out;
+	}
+
+	switch (sme->crypto.cipher_group) {
+	case WLAN_CIPHER_SUITE_TKIP:
+		encode_alg = ORINOCO_ALG_TKIP;
+		priv->wpa_enabled = 1;
+		break;
+
+	case WLAN_CIPHER_SUITE_WEP40:
+	case WLAN_CIPHER_SUITE_WEP104:
+		encode_alg = ORINOCO_ALG_WEP;
+		priv->wpa_enabled = 0;
+		break;
+
+	default:
+		encode_alg = ORINOCO_ALG_NONE;
+		priv->wpa_enabled = 0;
+	}
+
+	orinoco_set_encoding(priv, encode_alg);
+
+	/* What are we supposed to do with multiple AKM suites? */
+	if (sme->crypto.n_akm_suites > 0)
+		priv->key_mgmt = sme->crypto.akm_suites[0] & 7;
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
+	/* Enable cfg80211 notification */
+	priv->connect_commanded = 1;
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
+	priv->wpa_enabled = 0;
+
+	/* Disable cfg80211 notification */
+	priv->connect_commanded = 0;
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
 	.set_channel = orinoco_set_channel,
 	.scan = orinoco_scan,
+	.connect = orinoco_connect,
+	.disconnect = orinoco_disconnect,
 };
diff --git a/drivers/net/wireless/orinoco/main.c b/drivers/net/wireless/orinoco/main.c
index 2c7dc65..5542173 100644
--- a/drivers/net/wireless/orinoco/main.c
+++ b/drivers/net/wireless/orinoco/main.c
@@ -1188,98 +1188,109 @@ static void orinoco_join_ap(struct work_struct *work)
 	kfree(buf);
 }
 
-/* Send new BSSID to userspace */
-static void orinoco_send_bssid_wevent(struct orinoco_private *priv)
-{
-	struct net_device *dev = priv->ndev;
-	struct hermes *hw = &priv->hw;
-	union iwreq_data wrqu;
-	int err;
-
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENTBSSID,
-			      ETH_ALEN, NULL, wrqu.ap_addr.sa_data);
-	if (err != 0)
-		return;
-
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-
-	/* Send event to user space */
-	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
-}
-
-static void orinoco_send_assocreqie_wevent(struct orinoco_private *priv)
+static void orinoco_send_wevents(struct work_struct *work)
 {
-	struct net_device *dev = priv->ndev;
-	struct hermes *hw = &priv->hw;
-	union iwreq_data wrqu;
+	struct orinoco_private *priv =
+		container_of(work, struct orinoco_private, wevent_work);
+	hermes_t *hw = &priv->hw;
+	unsigned long flags;
+	u8 req_buf[88];
+	u8 resp_buf[88];
+	u8 bssid[ETH_ALEN];
+	size_t req_len = 0;
+	size_t resp_len = 0;
+	u8 *req_ie = NULL;
+	u8 *resp_ie = NULL;
+	enum nl80211_iftype  iw_mode;
+	u16 linkstatus;
 	int err;
-	u8 buf[88];
-	u8 *ie;
 
-	if (!priv->has_wpa)
+	if (orinoco_lock(priv, &flags) != 0)
 		return;
 
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_ASSOC_REQ_INFO,
-			      sizeof(buf), NULL, &buf);
-	if (err != 0)
-		return;
+	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENTBSSID,
+			      ETH_ALEN, NULL, &bssid[0]);
+	if (err)
+		goto out;
 
-	ie = orinoco_get_wpa_ie(buf, sizeof(buf));
-	if (ie) {
-		int rem = sizeof(buf) - (ie - &buf[0]);
-		wrqu.data.length = ie[1] + 2;
-		if (wrqu.data.length > rem)
-			wrqu.data.length = rem;
+	if (priv->has_wpa) {
+		err = hermes_read_ltv(hw, USER_BAP,
+				      HERMES_RID_CURRENT_ASSOC_REQ_INFO,
+				      sizeof(req_buf), NULL, &req_buf);
+		if (!err) {
+			req_ie = orinoco_get_wpa_ie(req_buf,
+						    sizeof(req_buf));
+			if (req_ie) {
+				int rem = sizeof(req_buf) -
+					(req_ie - &req_buf[0]);
+				req_len = req_ie[1] + 2;
+				if (req_len > rem)
+					req_len = rem;
+			}
+		}
 
-		if (wrqu.data.length)
-			/* Send event to user space */
-			wireless_send_event(dev, IWEVASSOCREQIE, &wrqu, ie);
+		err = hermes_read_ltv(hw, USER_BAP,
+				      HERMES_RID_CURRENT_ASSOC_RESP_INFO,
+				      sizeof(resp_buf), NULL, &resp_buf);
+		if (!err) {
+			resp_ie = orinoco_get_wpa_ie(resp_buf,
+						     sizeof(resp_buf));
+			if (resp_ie) {
+				int rem = sizeof(resp_buf) -
+					(resp_ie - &resp_buf[0]);
+				resp_len = resp_ie[1] + 2;
+				if (resp_len > rem)
+					resp_len = rem;
+			}
+		}
 	}
-}
-
-static void orinoco_send_assocrespie_wevent(struct orinoco_private *priv)
-{
-	struct net_device *dev = priv->ndev;
-	struct hermes *hw = &priv->hw;
-	union iwreq_data wrqu;
-	int err;
-	u8 buf[88]; /* TODO: verify max size or IW_GENERIC_IE_MAX */
-	u8 *ie;
 
-	if (!priv->has_wpa)
-		return;
+	iw_mode = priv->iw_mode;
+	linkstatus = priv->last_linkstatus;
 
-	err = hermes_read_ltv(hw, USER_BAP, HERMES_RID_CURRENT_ASSOC_RESP_INFO,
-			      sizeof(buf), NULL, &buf);
-	if (err != 0)
-		return;
+	if (!priv->connect_commanded)
+		goto out;
 
-	ie = orinoco_get_wpa_ie(buf, sizeof(buf));
-	if (ie) {
-		int rem = sizeof(buf) - (ie - &buf[0]);
-		wrqu.data.length = ie[1] + 2;
-		if (wrqu.data.length > rem)
-			wrqu.data.length = rem;
+	orinoco_unlock(priv, &flags);
 
-		if (wrqu.data.length)
-			/* Send event to user space */
-			wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, ie);
-	}
-}
+	switch (iw_mode) {
+	case NL80211_IFTYPE_STATION:
 
-static void orinoco_send_wevents(struct work_struct *work)
-{
-	struct orinoco_private *priv =
-		container_of(work, struct orinoco_private, wevent_work);
-	unsigned long flags;
+		switch (linkstatus) {
+		case HERMES_LINKSTATUS_CONNECTED:
+		case HERMES_LINKSTATUS_AP_IN_RANGE:
+			cfg80211_connect_result(priv->ndev, bssid,
+						req_ie, req_len,
+						resp_ie, resp_len,
+						WLAN_STATUS_SUCCESS,
+						GFP_KERNEL);
+			break;
 
-	if (orinoco_lock(priv, &flags) != 0)
-		return;
+		case HERMES_LINKSTATUS_DISCONNECTED:
+		case HERMES_LINKSTATUS_NOT_CONNECTED:
+		case HERMES_LINKSTATUS_AP_OUT_OF_RANGE:
+		case HERMES_LINKSTATUS_AP_CHANGE:
+			cfg80211_roamed(priv->ndev, bssid, req_ie, req_len,
+					resp_ie, resp_len, GFP_KERNEL);
+			break;
 
-	orinoco_send_assocreqie_wevent(priv);
-	orinoco_send_assocrespie_wevent(priv);
-	orinoco_send_bssid_wevent(priv);
+		case HERMES_LINKSTATUS_ASSOC_FAILED:
+			cfg80211_connect_result(priv->ndev, bssid,
+						req_ie, req_len,
+						resp_ie, resp_len,
+						WLAN_STATUS_ASSOC_DENIED_UNSPEC,
+						GFP_KERNEL);
+			break;
+		}
+		break;
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_MONITOR:
+	default:
+		break;
+	}
 
+	return;
+ out:
 	orinoco_unlock(priv, &flags);
 }
 
@@ -2050,6 +2061,7 @@ int orinoco_init(struct orinoco_private *priv)
 	set_port_type(priv);
 	priv->channel = 0; /* use firmware default */
 
+	priv->connect_commanded = 0;
 	priv->promiscuous = 0;
 	priv->encode_alg = ORINOCO_ALG_NONE;
 	priv->tx_key = 0;
diff --git a/drivers/net/wireless/orinoco/orinoco.h b/drivers/net/wireless/orinoco/orinoco.h
index 9ac6f1d..57ce581 100644
--- a/drivers/net/wireless/orinoco/orinoco.h
+++ b/drivers/net/wireless/orinoco/orinoco.h
@@ -78,6 +78,7 @@ struct orinoco_private {
 
 	/* driver state */
 	int open;
+	int connect_commanded;
 	u16 last_linkstatus;
 	struct work_struct join_work;
 	struct work_struct wevent_work;
-- 
1.6.3.3

