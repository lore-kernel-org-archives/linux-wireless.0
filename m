Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35323 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751590AbdFNTIq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 15:08:46 -0400
Received: by mail-wr0-f193.google.com with SMTP id z45so2336908wrb.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2017 12:08:45 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/2] staging: rtl8192e: remove dead code rtllib_wpa_supplicant_ioctl
Date: Wed, 14 Jun 2017 20:08:25 +0100
Message-Id: <20170614190825.4125-2-tvboxspy@gmail.com> (sfid-20170614_210850_970638_1E2E8A24)
In-Reply-To: <20170614190825.4125-1-tvboxspy@gmail.com>
References: <20170614190825.4125-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Following removal of _rtl92e_ioctl this function along with associated
macros, structure ieee_param and functions become dead code.

Remove functions rtllib_wpa_enable, rtllib_wpa_assoc_frame, rtllib_wpa_mlme,
rtllib_wpa_set_wpa_ie, rtllib_wpa_set_auth_algs, rtllib_wpa_set_param,
rtllib_wpa_set_encryption and rtllib_wpa_supplicant_ioctl.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/rtl8192e/rtllib.h         |  54 -----
 drivers/staging/rtl8192e/rtllib_softmac.c | 383 ------------------------------
 2 files changed, 437 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib.h b/drivers/staging/rtl8192e/rtllib.h
index 827651b62791..0042a0f6cf79 100644
--- a/drivers/staging/rtl8192e/rtllib.h
+++ b/drivers/staging/rtl8192e/rtllib.h
@@ -335,60 +335,8 @@ enum rt_op_mode {
 
 #define MGMT_QUEUE_NUM 5
 
-#define IEEE_CMD_SET_WPA_PARAM			1
-#define	IEEE_CMD_SET_WPA_IE			2
-#define IEEE_CMD_SET_ENCRYPTION			3
-#define IEEE_CMD_MLME				4
-
-#define IEEE_PARAM_WPA_ENABLED			1
-#define IEEE_PARAM_TKIP_COUNTERMEASURES		2
-#define IEEE_PARAM_DROP_UNENCRYPTED		3
-#define IEEE_PARAM_PRIVACY_INVOKED		4
-#define IEEE_PARAM_AUTH_ALGS			5
-#define IEEE_PARAM_IEEE_802_1X			6
-#define IEEE_PARAM_WPAX_SELECT			7
-
-#define IEEE_MLME_STA_DEAUTH			1
-#define IEEE_MLME_STA_DISASSOC			2
-
-
-#define IEEE_CRYPT_ERR_UNKNOWN_ALG		2
-#define IEEE_CRYPT_ERR_CRYPT_INIT_FAILED	4
-#define IEEE_CRYPT_ERR_KEY_SET_FAILED		5
-#define IEEE_CRYPT_ERR_CARD_CONF_FAILED		7
-#define	IEEE_CRYPT_ALG_NAME_LEN			16
-
 #define MAX_IE_LEN  0xff
 
-struct ieee_param {
-	u32 cmd;
-	u8 sta_addr[ETH_ALEN];
-	union {
-		struct {
-			u8 name;
-			u32 value;
-		} wpa_param;
-		struct {
-			u32 len;
-			u8 reserved[32];
-			u8 data[0];
-		} wpa_ie;
-		struct {
-			int command;
-			int reason_code;
-		} mlme;
-		struct {
-			u8 alg[IEEE_CRYPT_ALG_NAME_LEN];
-			u8 set_tx;
-			u32 err;
-			u8 idx;
-			u8 seq[8]; /* sequence counter (set: RX, get: TX) */
-			u16 key_len;
-			u8 key[0];
-		} crypt;
-	} u;
-};
-
 #define msleep_interruptible_rsl  msleep_interruptible
 
 /* Maximum size for the MA-UNITDATA primitive, 802.11 standard section
@@ -2066,8 +2014,6 @@ void rtllib_stop_all_queues(struct rtllib_device *ieee);
 struct sk_buff *rtllib_get_beacon(struct rtllib_device *ieee);
 void rtllib_start_send_beacons(struct rtllib_device *ieee);
 void rtllib_stop_send_beacons(struct rtllib_device *ieee);
-int rtllib_wpa_supplicant_ioctl(struct rtllib_device *ieee,
-				struct iw_point *p, u8 is_mesh);
 
 void notify_wx_assoc_event(struct rtllib_device *ieee);
 void rtllib_ps_tx_ack(struct rtllib_device *ieee, short success);
diff --git a/drivers/staging/rtl8192e/rtllib_softmac.c b/drivers/staging/rtl8192e/rtllib_softmac.c
index 776e99741431..f629e99956b7 100644
--- a/drivers/staging/rtl8192e/rtllib_softmac.c
+++ b/drivers/staging/rtl8192e/rtllib_softmac.c
@@ -3077,333 +3077,6 @@ void rtllib_softmac_free(struct rtllib_device *ieee)
 	tasklet_kill(&ieee->ps_task);
 }
 
-/********************************************************
- * Start of WPA code.				        *
- * this is stolen from the ipw2200 driver	        *
- ********************************************************/
-
-
-static int rtllib_wpa_enable(struct rtllib_device *ieee, int value)
-{
-	/* This is called when wpa_supplicant loads and closes the driver
-	 * interface.
-	 */
-	netdev_info(ieee->dev, "%s WPA\n", value ? "enabling" : "disabling");
-	ieee->wpa_enabled = value;
-	eth_zero_addr(ieee->ap_mac_addr);
-	return 0;
-}
-
-
-static void rtllib_wpa_assoc_frame(struct rtllib_device *ieee, char *wpa_ie,
-				   int wpa_ie_len)
-{
-	/* make sure WPA is enabled */
-	rtllib_wpa_enable(ieee, 1);
-
-	rtllib_disassociate(ieee);
-}
-
-
-static int rtllib_wpa_mlme(struct rtllib_device *ieee, int command, int reason)
-{
-
-	int ret = 0;
-
-	switch (command) {
-	case IEEE_MLME_STA_DEAUTH:
-		break;
-
-	case IEEE_MLME_STA_DISASSOC:
-		rtllib_disassociate(ieee);
-		break;
-
-	default:
-		netdev_info(ieee->dev, "Unknown MLME request: %d\n", command);
-		ret = -EOPNOTSUPP;
-	}
-
-	return ret;
-}
-
-
-static int rtllib_wpa_set_wpa_ie(struct rtllib_device *ieee,
-			      struct ieee_param *param, int plen)
-{
-	u8 *buf;
-
-	if (param->u.wpa_ie.len > MAX_WPA_IE_LEN ||
-	    (param->u.wpa_ie.len && param->u.wpa_ie.data == NULL))
-		return -EINVAL;
-
-	if (param->u.wpa_ie.len) {
-		buf = kmemdup(param->u.wpa_ie.data, param->u.wpa_ie.len,
-			      GFP_KERNEL);
-		if (buf == NULL)
-			return -ENOMEM;
-
-		kfree(ieee->wpa_ie);
-		ieee->wpa_ie = buf;
-		ieee->wpa_ie_len = param->u.wpa_ie.len;
-	} else {
-		kfree(ieee->wpa_ie);
-		ieee->wpa_ie = NULL;
-		ieee->wpa_ie_len = 0;
-	}
-
-	rtllib_wpa_assoc_frame(ieee, ieee->wpa_ie, ieee->wpa_ie_len);
-	return 0;
-}
-
-#define AUTH_ALG_OPEN_SYSTEM			0x1
-#define AUTH_ALG_SHARED_KEY			0x2
-#define AUTH_ALG_LEAP				0x4
-static int rtllib_wpa_set_auth_algs(struct rtllib_device *ieee, int value)
-{
-
-	struct rtllib_security sec = {
-		.flags = SEC_AUTH_MODE,
-	};
-
-	if (value & AUTH_ALG_SHARED_KEY) {
-		sec.auth_mode = WLAN_AUTH_SHARED_KEY;
-		ieee->open_wep = 0;
-		ieee->auth_mode = 1;
-	} else if (value & AUTH_ALG_OPEN_SYSTEM) {
-		sec.auth_mode = WLAN_AUTH_OPEN;
-		ieee->open_wep = 1;
-		ieee->auth_mode = 0;
-	} else if (value & AUTH_ALG_LEAP) {
-		sec.auth_mode = WLAN_AUTH_LEAP  >> 6;
-		ieee->open_wep = 1;
-		ieee->auth_mode = 2;
-	}
-
-
-	if (ieee->set_security)
-		ieee->set_security(ieee->dev, &sec);
-
-	return 0;
-}
-
-static int rtllib_wpa_set_param(struct rtllib_device *ieee, u8 name, u32 value)
-{
-	int ret = 0;
-	unsigned long flags;
-
-	switch (name) {
-	case IEEE_PARAM_WPA_ENABLED:
-		ret = rtllib_wpa_enable(ieee, value);
-		break;
-
-	case IEEE_PARAM_TKIP_COUNTERMEASURES:
-		ieee->tkip_countermeasures = value;
-		break;
-
-	case IEEE_PARAM_DROP_UNENCRYPTED:
-	{
-		/* HACK:
-		 *
-		 * wpa_supplicant calls set_wpa_enabled when the driver
-		 * is loaded and unloaded, regardless of if WPA is being
-		 * used.  No other calls are made which can be used to
-		 * determine if encryption will be used or not prior to
-		 * association being expected.  If encryption is not being
-		 * used, drop_unencrypted is set to false, else true -- we
-		 * can use this to determine if the CAP_PRIVACY_ON bit should
-		 * be set.
-		 */
-		struct rtllib_security sec = {
-			.flags = SEC_ENABLED,
-			.enabled = value,
-		};
-		ieee->drop_unencrypted = value;
-		/* We only change SEC_LEVEL for open mode. Others
-		 * are set by ipw_wpa_set_encryption.
-		 */
-		if (!value) {
-			sec.flags |= SEC_LEVEL;
-			sec.level = SEC_LEVEL_0;
-		} else {
-			sec.flags |= SEC_LEVEL;
-			sec.level = SEC_LEVEL_1;
-		}
-		if (ieee->set_security)
-			ieee->set_security(ieee->dev, &sec);
-		break;
-	}
-
-	case IEEE_PARAM_PRIVACY_INVOKED:
-		ieee->privacy_invoked = value;
-		break;
-
-	case IEEE_PARAM_AUTH_ALGS:
-		ret = rtllib_wpa_set_auth_algs(ieee, value);
-		break;
-
-	case IEEE_PARAM_IEEE_802_1X:
-		ieee->ieee802_1x = value;
-		break;
-	case IEEE_PARAM_WPAX_SELECT:
-		spin_lock_irqsave(&ieee->wpax_suitlist_lock, flags);
-		spin_unlock_irqrestore(&ieee->wpax_suitlist_lock, flags);
-		break;
-
-	default:
-		netdev_info(ieee->dev, "Unknown WPA param: %d\n", name);
-		ret = -EOPNOTSUPP;
-	}
-
-	return ret;
-}
-
-/* implementation borrowed from hostap driver */
-static int rtllib_wpa_set_encryption(struct rtllib_device *ieee,
-				  struct ieee_param *param, int param_len,
-				  u8 is_mesh)
-{
-	int ret = 0;
-	struct lib80211_crypto_ops *ops;
-	struct lib80211_crypt_data **crypt;
-
-	struct rtllib_security sec = {
-		.flags = 0,
-	};
-
-	param->u.crypt.err = 0;
-	param->u.crypt.alg[IEEE_CRYPT_ALG_NAME_LEN - 1] = '\0';
-
-	if (param_len !=
-	    (int) ((char *) param->u.crypt.key - (char *) param) +
-	    param->u.crypt.key_len) {
-		netdev_info(ieee->dev, "Len mismatch %d, %d\n", param_len,
-			    param->u.crypt.key_len);
-		return -EINVAL;
-	}
-	if (is_broadcast_ether_addr(param->sta_addr)) {
-		if (param->u.crypt.idx >= NUM_WEP_KEYS)
-			return -EINVAL;
-		crypt = &ieee->crypt_info.crypt[param->u.crypt.idx];
-	} else {
-		return -EINVAL;
-	}
-
-	if (strcmp(param->u.crypt.alg, "none") == 0) {
-		if (crypt) {
-			sec.enabled = 0;
-			sec.level = SEC_LEVEL_0;
-			sec.flags |= SEC_ENABLED | SEC_LEVEL;
-			lib80211_crypt_delayed_deinit(&ieee->crypt_info, crypt);
-		}
-		goto done;
-	}
-	sec.enabled = 1;
-	sec.flags |= SEC_ENABLED;
-
-	/* IPW HW cannot build TKIP MIC, host decryption still needed. */
-	if (!(ieee->host_encrypt || ieee->host_decrypt) &&
-	    strcmp(param->u.crypt.alg, "R-TKIP"))
-		goto skip_host_crypt;
-
-	ops = lib80211_get_crypto_ops(param->u.crypt.alg);
-	if (ops == NULL && strcmp(param->u.crypt.alg, "R-WEP") == 0) {
-		request_module("rtllib_crypt_wep");
-		ops = lib80211_get_crypto_ops(param->u.crypt.alg);
-	} else if (ops == NULL && strcmp(param->u.crypt.alg, "R-TKIP") == 0) {
-		request_module("rtllib_crypt_tkip");
-		ops = lib80211_get_crypto_ops(param->u.crypt.alg);
-	} else if (ops == NULL && strcmp(param->u.crypt.alg, "R-CCMP") == 0) {
-		request_module("rtllib_crypt_ccmp");
-		ops = lib80211_get_crypto_ops(param->u.crypt.alg);
-	}
-	if (ops == NULL) {
-		netdev_info(ieee->dev, "unknown crypto alg '%s'\n",
-			    param->u.crypt.alg);
-		param->u.crypt.err = IEEE_CRYPT_ERR_UNKNOWN_ALG;
-		ret = -EINVAL;
-		goto done;
-	}
-	if (*crypt == NULL || (*crypt)->ops != ops) {
-		struct lib80211_crypt_data *new_crypt;
-
-		lib80211_crypt_delayed_deinit(&ieee->crypt_info, crypt);
-
-		new_crypt = kzalloc(sizeof(*new_crypt), GFP_KERNEL);
-		if (new_crypt == NULL) {
-			ret = -ENOMEM;
-			goto done;
-		}
-		new_crypt->ops = ops;
-		if (new_crypt->ops && try_module_get(new_crypt->ops->owner))
-			new_crypt->priv =
-				new_crypt->ops->init(param->u.crypt.idx);
-
-		if (new_crypt->priv == NULL) {
-			kfree(new_crypt);
-			param->u.crypt.err = IEEE_CRYPT_ERR_CRYPT_INIT_FAILED;
-			ret = -EINVAL;
-			goto done;
-		}
-
-		*crypt = new_crypt;
-	}
-
-	if (param->u.crypt.key_len > 0 && (*crypt)->ops->set_key &&
-	    (*crypt)->ops->set_key(param->u.crypt.key,
-	    param->u.crypt.key_len, param->u.crypt.seq,
-	    (*crypt)->priv) < 0) {
-		netdev_info(ieee->dev, "key setting failed\n");
-		param->u.crypt.err = IEEE_CRYPT_ERR_KEY_SET_FAILED;
-		ret = -EINVAL;
-		goto done;
-	}
-
- skip_host_crypt:
-	if (param->u.crypt.set_tx) {
-		ieee->crypt_info.tx_keyidx = param->u.crypt.idx;
-		sec.active_key = param->u.crypt.idx;
-		sec.flags |= SEC_ACTIVE_KEY;
-	} else
-		sec.flags &= ~SEC_ACTIVE_KEY;
-
-	memcpy(sec.keys[param->u.crypt.idx],
-	       param->u.crypt.key,
-	       param->u.crypt.key_len);
-	sec.key_sizes[param->u.crypt.idx] = param->u.crypt.key_len;
-	sec.flags |= (1 << param->u.crypt.idx);
-
-	if (strcmp(param->u.crypt.alg, "R-WEP") == 0) {
-		sec.flags |= SEC_LEVEL;
-		sec.level = SEC_LEVEL_1;
-	} else if (strcmp(param->u.crypt.alg, "R-TKIP") == 0) {
-		sec.flags |= SEC_LEVEL;
-		sec.level = SEC_LEVEL_2;
-	} else if (strcmp(param->u.crypt.alg, "R-CCMP") == 0) {
-		sec.flags |= SEC_LEVEL;
-		sec.level = SEC_LEVEL_3;
-	}
- done:
-	if (ieee->set_security)
-		ieee->set_security(ieee->dev, &sec);
-
-	/* Do not reset port if card is in Managed mode since resetting will
-	 * generate new IEEE 802.11 authentication which may end up in looping
-	 * with IEEE 802.1X.  If your hardware requires a reset after WEP
-	 * configuration (for example... Prism2), implement the reset_port in
-	 * the callbacks structures used to initialize the 802.11 stack.
-	 */
-	if (ieee->reset_on_keychange &&
-	    ieee->iw_mode != IW_MODE_INFRA &&
-	    ieee->reset_port &&
-	    ieee->reset_port(ieee->dev)) {
-		netdev_info(ieee->dev, "reset_port failed\n");
-		param->u.crypt.err = IEEE_CRYPT_ERR_CARD_CONF_FAILED;
-		return -EINVAL;
-	}
-
-	return ret;
-}
-
 static inline struct sk_buff *
 rtllib_disauth_skb(struct rtllib_network *beacon,
 		   struct rtllib_device *ieee, u16 asRsn)
@@ -3502,62 +3175,6 @@ u8 rtllib_ap_sec_type(struct rtllib_device *ieee)
 	}
 }
 
-int rtllib_wpa_supplicant_ioctl(struct rtllib_device *ieee, struct iw_point *p,
-				u8 is_mesh)
-{
-	struct ieee_param *param;
-	int ret = 0;
-
-	mutex_lock(&ieee->wx_mutex);
-
-	if (p->length < sizeof(struct ieee_param) || !p->pointer) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	param = memdup_user(p->pointer, p->length);
-	if (IS_ERR(param)) {
-		ret = PTR_ERR(param);
-		goto out;
-	}
-
-	switch (param->cmd) {
-	case IEEE_CMD_SET_WPA_PARAM:
-		ret = rtllib_wpa_set_param(ieee, param->u.wpa_param.name,
-					param->u.wpa_param.value);
-		break;
-
-	case IEEE_CMD_SET_WPA_IE:
-		ret = rtllib_wpa_set_wpa_ie(ieee, param, p->length);
-		break;
-
-	case IEEE_CMD_SET_ENCRYPTION:
-		ret = rtllib_wpa_set_encryption(ieee, param, p->length, 0);
-		break;
-
-	case IEEE_CMD_MLME:
-		ret = rtllib_wpa_mlme(ieee, param->u.mlme.command,
-				   param->u.mlme.reason_code);
-		break;
-
-	default:
-		netdev_info(ieee->dev, "Unknown WPA supplicant request: %d\n",
-			    param->cmd);
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-	if (ret == 0 && copy_to_user(p->pointer, param, p->length))
-		ret = -EFAULT;
-
-	kfree(param);
-out:
-	mutex_unlock(&ieee->wx_mutex);
-
-	return ret;
-}
-EXPORT_SYMBOL(rtllib_wpa_supplicant_ioctl);
-
 static void rtllib_MgntDisconnectIBSS(struct rtllib_device *rtllib)
 {
 	u8	OpMode;
-- 
2.11.0
