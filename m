Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757315AbcDGSTf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:35 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 15/18] rtl8xxxu: Implement 8192eu device specific quirks
Date: Thu,  7 Apr 2016 14:19:30 -0400
Message-Id: <1460053173-8494-16-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_201952_681413_FC36F6B1)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Set REG_QUEUE_CTRL and REG_ACLK_MON for 8192eu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c      | 14 ++++++++++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h |  1 +
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index c800882..5a2eb0a 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7197,6 +7197,20 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 	if (priv->fops->init_statistics)
 		priv->fops->init_statistics(priv);
 
+	if (priv->rtl_chip == RTL8192E) {
+		/*
+		 * 0x4c6[3] 1: RTS BW = Data BW
+		 * 0: RTS BW depends on CCA / secondary CCA result.
+		 */
+		val8 = rtl8xxxu_read8(priv, REG_QUEUE_CTRL);
+		val8 &= ~BIT(3);
+		rtl8xxxu_write8(priv, REG_QUEUE_CTRL, val8);
+		/*
+		 * Reset USB mode switch setting
+		 */
+		rtl8xxxu_write8(priv, REG_ACLK_MON, 0x00);
+	}
+
 	rtl8723a_phy_lc_calibrate(priv);
 
 	priv->fops->phy_iq_calibrate(priv);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 82cbe85..c19f234 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -512,6 +512,7 @@
 #define REG_PKT_VO_VI_LIFE_TIME		0x04c0
 #define REG_PKT_BE_BK_LIFE_TIME		0x04c2
 #define REG_STBC_SETTING		0x04c4
+#define REG_QUEUE_CTRL			0x04c6
 #define REG_HT_SINGLE_AMPDU_8723B	0x04c7
 #define REG_PROT_MODE_CTRL		0x04c8
 #define REG_MAX_AGGR_NUM		0x04ca
-- 
2.5.5

