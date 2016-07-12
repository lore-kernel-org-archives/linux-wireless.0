Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:55494 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932537AbcGLOd4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2016 10:33:56 -0400
From: weiyj_lk@163.com
To: Jes Sorensen <Jes.Sorensen@redhat.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
	linux-wireless@vger.kernel.org
Subject: [PATCH -next] rtl8xxxu: gen1: Fix non static symbol warning
Date: Tue, 12 Jul 2016 14:33:34 +0000
Message-Id: <1468334014-9098-1-git-send-email-weiyj_lk@163.com> (sfid-20160712_163401_221069_15B4CDEA)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fixes the following sparse warning:

drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c:898:1: warning:
 symbol 'rtl8xxxu_gen1_h2c_cmd' was not declared. Should it be static?

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
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




