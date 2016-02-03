Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933796AbcBCSkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:04 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 14/28] rtl8xxxu: Remove unused clutter for handling recursive calls to rtl8xxxu_init_device()
Date: Wed,  3 Feb 2016 13:39:48 -0500
Message-Id: <1454524802-26763-15-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194137_235272_F561E33A)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This was a leftover from the vendor driver that was never utilized.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c | 12 +-----------
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h |  1 -
 2 files changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 7a571ef..4a6939f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4289,17 +4289,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 
 	rtl8xxxu_write16(priv, REG_FAST_EDCA_CTRL, 0);
 
-	/*
-	 * Not sure if we should get into this at all
-	 */
-	if (priv->iqk_initialized) {
-		rtl8xxxu_restore_regs(priv, rtl8723au_iqk_phy_iq_bb_reg,
-				      priv->bb_recovery_backup,
-				      RTL8XXXU_BB_REGS);
-	} else {
-		rtl8723a_phy_iq_calibrate(priv);
-		priv->iqk_initialized = true;
-	}
+	rtl8723a_phy_iq_calibrate(priv);
 
 	/*
 	 * This should enable thermal meter
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index f2a1bac..f71fb8d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -652,7 +652,6 @@ struct rtl8xxxu_priv {
 	u32 bb_recovery_backup[RTL8XXXU_BB_REGS];
 	u32 rtlchip;
 	u8 pi_enabled:1;
-	u8 iqk_initialized:1;
 	u8 int_buf[USB_INTR_CONTENT_LENGTH];
 };
 
-- 
2.5.0

