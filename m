Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52250 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 009/113] rtl8xxxu: Fix incorrect test for auto LLT failure
Date: Mon, 29 Feb 2016 17:04:07 -0500
Message-Id: <1456783551-28315-10-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232950_620982_60E58D68)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The logic for testing auto load failure in rtl8xxxu_auto_llt_table()
was inverted.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index a817208..45f787c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2781,7 +2781,6 @@ static int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page)
 	int i;
 
 	val32 = rtl8xxxu_read32(priv, REG_AUTO_LLT);
-	pr_info("AUTO_LLT = %08x\n", val32);
 	val32 |= AUTO_LLT_INIT_LLT;
 	rtl8xxxu_write32(priv, REG_AUTO_LLT, val32);
 
@@ -2792,12 +2791,10 @@ static int rtl8xxxu_auto_llt_table(struct rtl8xxxu_priv *priv, u8 last_tx_page)
 		usleep_range(2, 4);
 	}
 
-	if (i) {
+	if (!i) {
 		ret = -EBUSY;
 		dev_warn(&priv->udev->dev, "LLT table init failed\n");
 	}
-	else
-		dev_warn(&priv->udev->dev, "LLT table init success\n");
 
 	return ret;
 }
-- 
2.5.0

