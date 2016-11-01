Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:35231 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966527AbcKAOsU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 1 Nov 2016 10:48:20 -0400
Received: by mail-pf0-f196.google.com with SMTP id i88so532768pfk.2
        for <linux-wireless@vger.kernel.org>; Tue, 01 Nov 2016 07:48:19 -0700 (PDT)
From: Wei Yongjun <weiyj.lk@gmail.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: Wei Yongjun <weiyongjun1@huawei.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH net-next] rtl8xxxu: Fix non static symbol warning
Date: Tue,  1 Nov 2016 14:48:08 +0000
Message-Id: <1478011688-26698-1-git-send-email-weiyj.lk@gmail.com> (sfid-20161101_154822_963968_D38EDBD5)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <weiyongjun1@huawei.com>

Fixes the following sparse warning:

drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_8192e.c:1559:6: warning:
 symbol 'rtl8192eu_power_off' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
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
