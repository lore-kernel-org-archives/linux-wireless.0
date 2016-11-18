Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37542 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752301AbcKRVoa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 16:44:30 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 7/7] rtl8xxxu: Fix non static symbol warning
Date: Fri, 18 Nov 2016 16:44:28 -0500
Message-Id: <1479505468-29383-8-git-send-email-Jes.Sorensen@redhat.com> (sfid-20161118_224441_236314_EC268A85)
In-Reply-To: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1479505468-29383-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warning:

drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c:1559:6: warning:
 symbol 'rtl8192eu_power_off' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
index a793fed..a1178c5 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c
@@ -1556,7 +1556,7 @@ static int rtl8192eu_power_on(struct rtl8xxxu_priv *priv)
 	return ret;
 }
 
-void rtl8192eu_power_off(struct rtl8xxxu_priv *priv)
+static void rtl8192eu_power_off(struct rtl8xxxu_priv *priv)
 {
 	u8 val8;
 	u16 val16;
-- 
2.7.4
