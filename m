Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:2933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbcB2WGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 107/113] rtl8xxxu: Use define for REG_PWR_DATA bits
Date: Mon, 29 Feb 2016 17:05:45 -0500
Message-Id: <1456783551-28315-108-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232954_374036_6F02309D)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Use the bit define rather than hard code the value for REG_PWR_DATA bits.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c      | 2 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index b5ab899..c7984ab 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -5996,7 +5996,7 @@ static void rtl8723b_enable_rf(struct rtl8xxxu_priv *priv)
 	rtl8xxxu_write8(priv, 0x0067, val8);
 
 	val32 = rtl8xxxu_read32(priv, REG_PWR_DATA);
-	val32 |= BIT(11);
+	val32 |= PWR_DATA_EEPRPAD_RFE_CTRL_EN;
 	rtl8xxxu_write32(priv, REG_PWR_DATA, val32);
 
 	/*
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index a055362..e0b9ea3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -135,7 +135,7 @@
 #define  EFUSE_ACCESS_DISABLE		0x00	/* RTL8723 only */
 
 #define REG_PWR_DATA			0x0038
-#define PWR_DATA_EEPRPAD_RFE_CTRL_EN	BIT(11)
+#define  PWR_DATA_EEPRPAD_RFE_CTRL_EN	BIT(11)
 
 #define REG_CAL_TIMER			0x003c
 #define REG_ACLK_MON			0x003e
-- 
2.5.0

