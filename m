Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42478 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755458AbcHSVrZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Aug 2016 17:47:25 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 19/20] rtl8xxxu: gen1: Fix non static symbol warning
Date: Fri, 19 Aug 2016 17:46:41 -0400
Message-Id: <1471643202-26250-20-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160819_234745_226044_BDB091C5)
In-Reply-To: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1471643202-26250-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:898:1: warning:
 symbol 'rtl8xxxu_gen1_h2c_cmd' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index e02fab0..508d46f 100644
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
