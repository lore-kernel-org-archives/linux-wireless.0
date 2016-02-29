Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52257 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752803AbcB2WFy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:54 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 034/113] rtl8xxxu: Use correct formatting type to print sizeof()
Date: Mon, 29 Feb 2016 17:04:32 -0500
Message-Id: <1456783551-28315-35-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230616_931359_AC745D82)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Usual gcc i386 issue reported by kbuildbot

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index ac47b77..9d8b69a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5129,7 +5129,7 @@ static void rtl8xxxu_update_rate_mask(struct rtl8xxxu_priv *priv,
 	if (sgi)
 		h2c.ramask.arg |= 0x20;
 
-	dev_dbg(&priv->udev->dev, "%s: rate mask %08x, arg %02x, size %li\n",
+	dev_dbg(&priv->udev->dev, "%s: rate mask %08x, arg %02x, size %zi\n",
 		__func__, ramask, h2c.ramask.arg, sizeof(h2c.ramask));
 	rtl8723a_h2c_cmd(priv, &h2c, sizeof(h2c.ramask));
 }
-- 
2.5.0

