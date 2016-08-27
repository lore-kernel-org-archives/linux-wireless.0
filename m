Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:33651 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753872AbcH0QPK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Aug 2016 12:15:10 -0400
Received: by mail-pf0-f174.google.com with SMTP id y134so37965226pfg.0
        for <linux-wireless@vger.kernel.org>; Sat, 27 Aug 2016 09:15:10 -0700 (PDT)
From: Baoyou Xie <baoyou.xie@linaro.org>
To: Jes.Sorensen@redhat.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@linaro.org,
        baoyou.xie@linaro.org, xie.baoyou@zte.com.cn
Subject: [PATCH] fix:rtl8xxxu_core: mark symbols static where possible
Date: Sun, 28 Aug 2016 00:14:36 +0800
Message-Id: <1472314476-23351-1-git-send-email-baoyou.xie@linaro.org> (sfid-20160827_181531_811767_85931DEA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We get 1 warning about global functions without a declaration
in the rtl8xxxu rtl8xxxu_core.c when building with W=1:
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:898:1: warning: no previous prototype for 'rtl8xxxu_gen1_h2c_cmd' [-Wmissing-prototypes]

In fact, this function is only used in the file in which it is declared
and don't need a declaration, but can be made static.
so this patch marks it 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 77048db..95b54b8 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -894,7 +894,7 @@ int rtl8xxxu_write_rfreg(struct rtl8xxxu_priv *priv,
 	return retval;
 }
 
-int
+static int
 rtl8xxxu_gen1_h2c_cmd(struct rtl8xxxu_priv *priv, struct h2c_cmd *h2c, int len)
 {
 	struct device *dev = &priv->udev->dev;
-- 
2.7.4
