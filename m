Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33761 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750768AbdFNTIp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Jun 2017 15:08:45 -0400
Received: by mail-wr0-f195.google.com with SMTP id x23so1929851wrb.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Jun 2017 12:08:44 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/2] staging: rtl8192e: remove dead private call to _rtl92e_ioctl.
Date: Wed, 14 Jun 2017 20:08:24 +0100
Message-Id: <20170614190825.4125-1-tvboxspy@gmail.com> (sfid-20170614_210849_712648_4CD262DF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A RTL_IOCTL_WPA_SUPPLICANT call is a proprietary version of
wpa supplicant.

All kernel calls use SIOCSIWENCODEEXT call via wireless handlers
already used in this driver.

Remove dead code.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 126 ---------------------------
 drivers/staging/rtl8192e/rtl8192e/rtl_core.h |   2 -
 2 files changed, 128 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index a4d1bac4a844..aca52654825b 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -2275,131 +2275,6 @@ static int _rtl92e_set_mac_adr(struct net_device *dev, void *mac)
 	return 0;
 }
 
-/* based on ipw2200 driver */
-static int _rtl92e_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	struct r8192_priv *priv = rtllib_priv(dev);
-	struct iwreq *wrq = (struct iwreq *)rq;
-	int ret = -1;
-	struct rtllib_device *ieee = priv->rtllib;
-	u32 key[4];
-	const u8 broadcast_addr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
-	struct iw_point *p = &wrq->u.data;
-	struct ieee_param *ipw = NULL;
-
-	mutex_lock(&priv->wx_mutex);
-
-	switch (cmd) {
-	case RTL_IOCTL_WPA_SUPPLICANT:
-		if (p->length < sizeof(struct ieee_param) || !p->pointer) {
-			ret = -EINVAL;
-			goto out;
-		}
-
-		ipw = memdup_user(p->pointer, p->length);
-		if (IS_ERR(ipw)) {
-			ret = PTR_ERR(ipw);
-			goto out;
-		}
-
-		if (ipw->cmd == IEEE_CMD_SET_ENCRYPTION) {
-			if (ipw->u.crypt.set_tx) {
-				if (strcmp(ipw->u.crypt.alg, "CCMP") == 0)
-					ieee->pairwise_key_type = KEY_TYPE_CCMP;
-				else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0)
-					ieee->pairwise_key_type = KEY_TYPE_TKIP;
-				else if (strcmp(ipw->u.crypt.alg, "WEP") == 0) {
-					if (ipw->u.crypt.key_len == 13)
-						ieee->pairwise_key_type =
-							 KEY_TYPE_WEP104;
-					else if (ipw->u.crypt.key_len == 5)
-						ieee->pairwise_key_type =
-							 KEY_TYPE_WEP40;
-				} else {
-					ieee->pairwise_key_type = KEY_TYPE_NA;
-				}
-
-				if (ieee->pairwise_key_type) {
-					if (is_zero_ether_addr(ieee->ap_mac_addr))
-						ieee->iw_mode = IW_MODE_ADHOC;
-					memcpy((u8 *)key, ipw->u.crypt.key, 16);
-					rtl92e_enable_hw_security_config(dev);
-					rtl92e_set_swcam(dev, 4,
-							 ipw->u.crypt.idx,
-							 ieee->pairwise_key_type,
-							 (u8 *)ieee->ap_mac_addr,
-							 0, key, 0);
-					rtl92e_set_key(dev, 4, ipw->u.crypt.idx,
-						       ieee->pairwise_key_type,
-						       (u8 *)ieee->ap_mac_addr,
-						       0, key);
-					if (ieee->iw_mode == IW_MODE_ADHOC) {
-						rtl92e_set_swcam(dev,
-								 ipw->u.crypt.idx,
-								 ipw->u.crypt.idx,
-								 ieee->pairwise_key_type,
-								 (u8 *)ieee->ap_mac_addr,
-								 0, key, 0);
-						rtl92e_set_key(dev,
-							       ipw->u.crypt.idx,
-							       ipw->u.crypt.idx,
-							       ieee->pairwise_key_type,
-							       (u8 *)ieee->ap_mac_addr,
-							       0, key);
-					}
-				}
-				if ((ieee->pairwise_key_type ==
-				     KEY_TYPE_CCMP) &&
-				     ieee->pHTInfo->bCurrentHTSupport) {
-					rtl92e_writeb(dev, 0x173, 1);
-				}
-
-			} else {
-				memcpy((u8 *)key, ipw->u.crypt.key, 16);
-				if (strcmp(ipw->u.crypt.alg, "CCMP") == 0)
-					ieee->group_key_type = KEY_TYPE_CCMP;
-				else if (strcmp(ipw->u.crypt.alg, "TKIP") == 0)
-					ieee->group_key_type = KEY_TYPE_TKIP;
-				else if (strcmp(ipw->u.crypt.alg, "WEP") == 0) {
-					if (ipw->u.crypt.key_len == 13)
-						ieee->group_key_type =
-							 KEY_TYPE_WEP104;
-					else if (ipw->u.crypt.key_len == 5)
-						ieee->group_key_type =
-							 KEY_TYPE_WEP40;
-				} else
-					ieee->group_key_type = KEY_TYPE_NA;
-
-				if (ieee->group_key_type) {
-					rtl92e_set_swcam(dev, ipw->u.crypt.idx,
-							 ipw->u.crypt.idx,
-							 ieee->group_key_type,
-							 broadcast_addr, 0, key,
-							 0);
-					rtl92e_set_key(dev, ipw->u.crypt.idx,
-						       ipw->u.crypt.idx,
-						       ieee->group_key_type,
-						       broadcast_addr, 0, key);
-				}
-			}
-		}
-
-		ret = rtllib_wpa_supplicant_ioctl(priv->rtllib, &wrq->u.data,
-						  0);
-		kfree(ipw);
-		break;
-	default:
-		ret = -EOPNOTSUPP;
-		break;
-	}
-
-out:
-	mutex_unlock(&priv->wx_mutex);
-
-	return ret;
-}
-
-
 static irqreturn_t _rtl92e_irq(int irq, void *netdev)
 {
 	struct net_device *dev = netdev;
@@ -2542,7 +2417,6 @@ static const struct net_device_ops rtl8192_netdev_ops = {
 	.ndo_open = _rtl92e_open,
 	.ndo_stop = _rtl92e_close,
 	.ndo_tx_timeout = _rtl92e_tx_timeout,
-	.ndo_do_ioctl = _rtl92e_ioctl,
 	.ndo_set_rx_mode = _rtl92e_set_multicast,
 	.ndo_set_mac_address = _rtl92e_set_mac_adr,
 	.ndo_validate_addr = eth_validate_addr,
diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
index 0335823e2766..9d3089cb6a5a 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.h
@@ -102,8 +102,6 @@
 
 #define	PHY_RSSI_SLID_WIN_MAX			100
 
-#define RTL_IOCTL_WPA_SUPPLICANT		(SIOCIWFIRSTPRIV + 30)
-
 #define TxBBGainTableLength			37
 #define CCKTxBBGainTableLength			23
 
-- 
2.11.0
