Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:43543 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726570AbeGKHPF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Jul 2018 03:15:05 -0400
From: Colin King <colin.king@canonical.com>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH] ipw2x00: remove redundant variables len, ret, reason and crypt
Date: Wed, 11 Jul 2018 08:12:12 +0100
Message-Id: <20180711071212.3018-1-colin.king@canonical.com> (sfid-20180711_091227_407022_A501FC92)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Variables len, ret, reason and crypt are assigned values that
are never read, hence they are redundant and can be removed.

Note: For the variable ret, a return code is being assigned, but
this is not returned and 0 is currently being returned, I believe
this is OK.

Cleans up clang warnings:
warning: variable 'len' set but not used [-Wunused-but-set-variable]
variable 'ret' set but not used [-Wunused-but-set-variable]
warning: variable 'reason' set but not used [-Wunused-but-set-variable]
warning: variable 'crypt' set but not used [-Wunused-but-set-variable]

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/intel/ipw2x00/ipw2100.c   | 7 -------
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c | 2 --
 2 files changed, 9 deletions(-)

diff --git a/drivers/net/wireless/intel/ipw2x00/ipw2100.c b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
index 1ad83ef5f202..910db46db6a1 100644
--- a/drivers/net/wireless/intel/ipw2x00/ipw2100.c
+++ b/drivers/net/wireless/intel/ipw2x00/ipw2100.c
@@ -5112,11 +5112,9 @@ static int ipw2100_disassociate_bssid(struct ipw2100_priv *priv)
 		.host_command_length = ETH_ALEN
 	};
 	int err;
-	int len;
 
 	IPW_DEBUG_HC("DISASSOCIATION_BSSID\n");
 
-	len = ETH_ALEN;
 	/* The Firmware currently ignores the BSSID and just disassociates from
 	 * the currently associated AP -- but in the off chance that a future
 	 * firmware does use the BSSID provided here, we go ahead and try and
@@ -7723,7 +7721,6 @@ static int ipw2100_wx_get_auth(struct net_device *dev,
 	struct libipw_device *ieee = priv->ieee;
 	struct lib80211_crypt_data *crypt;
 	struct iw_param *param = &wrqu->param;
-	int ret = 0;
 
 	switch (param->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
@@ -7733,7 +7730,6 @@ static int ipw2100_wx_get_auth(struct net_device *dev,
 		/*
 		 * wpa_supplicant will control these internally
 		 */
-		ret = -EOPNOTSUPP;
 		break;
 
 	case IW_AUTH_TKIP_COUNTERMEASURES:
@@ -7801,9 +7797,6 @@ static int ipw2100_wx_set_mlme(struct net_device *dev,
 {
 	struct ipw2100_priv *priv = libipw_priv(dev);
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
-	__le16 reason;
-
-	reason = cpu_to_le16(mlme->reason_code);
 
 	switch (mlme->cmd) {
 	case IW_MLME_DEAUTH:
diff --git a/drivers/net/wireless/intel/ipw2x00/libipw_wx.c b/drivers/net/wireless/intel/ipw2x00/libipw_wx.c
index dd29f46d086b..d32d39fa2686 100644
--- a/drivers/net/wireless/intel/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/intel/ipw2x00/libipw_wx.c
@@ -479,7 +479,6 @@ int libipw_wx_get_encode(struct libipw_device *ieee,
 {
 	struct iw_point *erq = &(wrqu->encoding);
 	int len, key;
-	struct lib80211_crypt_data *crypt;
 	struct libipw_security *sec = &ieee->sec;
 
 	LIBIPW_DEBUG_WX("GET_ENCODE\n");
@@ -492,7 +491,6 @@ int libipw_wx_get_encode(struct libipw_device *ieee,
 	} else
 		key = ieee->crypt_info.tx_keyidx;
 
-	crypt = ieee->crypt_info.crypt[key];
 	erq->flags = key + 1;
 
 	if (!sec->enabled) {
-- 
2.17.1
