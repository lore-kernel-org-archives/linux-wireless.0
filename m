Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:35137 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S940192AbcIYJWg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 25 Sep 2016 05:22:36 -0400
Received: by mail-pf0-f182.google.com with SMTP id s13so21242961pfd.2
        for <linux-wireless@vger.kernel.org>; Sun, 25 Sep 2016 02:22:36 -0700 (PDT)
From: Baoyou Xie <baoyou.xie@linaro.org>
To: Jes.Sorensen@redhat.com, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, arnd@arndb.de, baoyou.xie@linaro.org,
        xie.baoyou@zte.com.cn, han.fei@zte.com.cn, tang.qiang007@zte.com.cn
Subject: [PATCH] rtl8xxxu: mark rtl8192eu_power_off() static
Date: Sun, 25 Sep 2016 17:22:23 +0800
Message-Id: <1474795343-25808-1-git-send-email-baoyou.xie@linaro.org> (sfid-20160925_112258_117839_E070A782)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We get 1 warning when building kernel with W=1:
drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c:1557:6: warning: no previous prototype for 'rtl8192eu_power_off' [-Wmissing-prototypes]

In fact, this function is only used in the file in which it is
declared and don't need a declaration, but can be made static.
so this patch marks this function with 'static'.

Signed-off-by: Baoyou Xie <baoyou.xie@linaro.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index df54d27..7b5128a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1554,7 +1554,7 @@ static int rtl8192eu_power_on(struct rtl8xxxu_priv *priv)
 	return ret;
 }
 
-void rtl8192eu_power_off(struct rtl8xxxu_priv *priv)
+static void rtl8192eu_power_off(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
 	u16 val16;
-- 
2.7.4
