Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35821 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752203AbdEMQlh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 May 2017 12:41:37 -0400
Received: by mail-wr0-f195.google.com with SMTP id g12so10240221wrg.2
        for <linux-wireless@vger.kernel.org>; Sat, 13 May 2017 09:41:37 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 2/5] staging: rtl8192e: print alg name as debug.
Date: Sat, 13 May 2017 17:41:18 +0100
Message-Id: <20170513164121.14373-2-tvboxspy@gmail.com> (sfid-20170513_184150_115340_77AEB4D7)
In-Reply-To: <20170513164121.14373-1-tvboxspy@gmail.com>
References: <20170513164121.14373-1-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

alg name will be printed a number times during a connection it
is only really useful as a debug message.

Change to netdev_dbg.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/rtl8192e/rtllib_wx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8192e/rtllib_wx.c b/drivers/staging/rtl8192e/rtllib_wx.c
index c5c0d9676dc8..f7eba01b5d15 100644
--- a/drivers/staging/rtl8192e/rtllib_wx.c
+++ b/drivers/staging/rtl8192e/rtllib_wx.c
@@ -595,7 +595,7 @@ int rtllib_wx_set_encode_ext(struct rtllib_device *ieee,
 		ret = -EINVAL;
 		goto done;
 	}
-	netdev_info(dev, "alg name:%s\n", alg);
+	netdev_dbg(dev, "alg name:%s\n", alg);
 
 	ops = lib80211_get_crypto_ops(alg);
 	if (ops == NULL) {
-- 
2.11.0
