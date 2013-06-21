Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:49777 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161389Ab3FUCmU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jun 2013 22:42:20 -0400
Received: by mail-wg0-f47.google.com with SMTP id l18so5997566wgh.2
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jun 2013 19:42:19 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 21 Jun 2013 10:42:19 +0800
Message-ID: <CAPgLHd8BRGbdCOaoy6E4QBVEbZRnKkHwgrWsodJwYLVs+S=KaQ@mail.gmail.com> (sfid-20130621_044224_273882_AC818743)
Subject: [PATCH] ipw2200: fix error return code in ipw_load()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: stas.yakovlev@gmail.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return -ENOMEM in the ipw_rx_queue_alloc() error handling
case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/ipw2x00/ipw2200.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ipw2x00/ipw2200.c b/drivers/net/wireless/ipw2x00/ipw2200.c
index 4ed5e45..6b823a1 100644
--- a/drivers/net/wireless/ipw2x00/ipw2200.c
+++ b/drivers/net/wireless/ipw2x00/ipw2200.c
@@ -3548,6 +3548,7 @@ static int ipw_load(struct ipw_priv *priv)
 		ipw_rx_queue_reset(priv, priv->rxq);
 	if (!priv->rxq) {
 		IPW_ERROR("Unable to initialize Rx queue\n");
+		rc = -ENOMEM;
 		goto error;
 	}
 

