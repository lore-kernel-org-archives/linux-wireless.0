Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933478AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 23/28] rtl8xxxu: Set correct bit to reset MCU IO wrapper
Date: Wed,  3 Feb 2016 13:39:57 -0500
Message-Id: <1454524802-26763-24-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194806_731248_850819F2)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

All chips, except for 8812 require BIT(0) for resetting the MCU IO
wrapper. 8723b requires a more complicated reset sequence, so it will
need a custom reset function.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index c8ba698..460145c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -2052,13 +2052,13 @@ static void rtl8xxxu_reset_8051(struct rtl8xxxu_priv *priv)
 	u16 sys_func;
 
 	val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
-	val8 &= ~BIT(3);
+	val8 &= ~BIT(0);
 	rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
 	sys_func = rtl8xxxu_read16(priv, REG_SYS_FUNC);
 	sys_func &= ~SYS_FUNC_CPU_ENABLE;
 	rtl8xxxu_write16(priv, REG_SYS_FUNC, sys_func);
 	val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
-	val8 |= BIT(3);
+	val8 |= BIT(0);
 	rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);
 	sys_func |= SYS_FUNC_CPU_ENABLE;
 	rtl8xxxu_write16(priv, REG_SYS_FUNC, sys_func);
-- 
2.5.0

