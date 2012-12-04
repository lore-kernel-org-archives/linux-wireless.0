Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f53.google.com ([209.85.216.53]:46050 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab2LDGDN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2012 01:03:13 -0500
Received: by mail-qa0-f53.google.com with SMTP id a19so452006qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 22:03:13 -0800 (PST)
MIME-Version: 1.0
Date: Tue, 4 Dec 2012 01:03:12 -0500
Message-ID: <CAPgLHd-k+RY5m804tBg4uzbWsUhS16coW9cQ62R7mPCjKjGffg@mail.gmail.com> (sfid-20121204_070325_725473_43050791)
Subject: [PATCH -next] ipw2200: return error code on error in ipw_wx_get_auth()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: stas.yakovlev@gmail.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

We have assinged error code to 'ret' when get auth from some
option is not supported but never used it, but we'd better return
the error code.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ipw2x00/ipw2200.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 482f505..1ad72d5 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -6812,7 +6812,6 @@ static int ipw_wx_get_auth(struct net_device *dev,
 	struct libipw_device *ieee = priv->ieee;
 	struct lib80211_crypt_data *crypt;
 	struct iw_param *param = &wrqu->param;
-	int ret = 0;
 
 	switch (param->flags & IW_AUTH_INDEX) {
 	case IW_AUTH_WPA_VERSION:
@@ -6822,7 +6821,7 @@ static int ipw_wx_get_auth(struct net_device *dev,
 		/*
 		 * wpa_supplicant will control these internally
 		 */
-		ret = -EOPNOTSUPP;
+		return -EOPNOTSUPP;
 		break;
 
 	case IW_AUTH_TKIP_COUNTERMEASURES:


