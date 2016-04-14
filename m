Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753490AbcDNS7J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 14:59:09 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 15/26] rtl8xxxu: Use descriptive bits for setting RX paths for 1T2R parts
Date: Thu, 14 Apr 2016 14:58:56 -0400
Message-Id: <1460660347-26299-16-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160414_205944_970252_4E230EE0)
In-Reply-To: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460660347-26299-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This reduce the use of magic values a little.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c      | 4 +++-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 4 ++++
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index d0330a8..3c45ad0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -3814,8 +3814,10 @@ static int rtl8xxxu_init_phy_bb(struct rtl8xxxu_priv *priv)
 		rtl8xxxu_write32(priv, REG_FPGA1_TX_INFO, val32);
 
 		val32 = rtl8xxxu_read32(priv, REG_CCK0_AFE_SETTING);
+		val32 &= ~CCK0_AFE_RX_MASK;
 		val32 &= 0x00ffffff;
-		val32 |= 0x45000000;
+		val32 |= 0x40000000;
+		val32 |= CCK0_AFE_RX_ANT_B;
 		rtl8xxxu_write32(priv, REG_CCK0_AFE_SETTING, val32);
 
 		val32 = rtl8xxxu_read32(priv, REG_OFDM0_TRX_PATH_ENABLE);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index a2cff22..e7709a5 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -882,6 +882,10 @@
 #define  CCK0_SIDEBAND			BIT(4)
 
 #define REG_CCK0_AFE_SETTING		0x0a04
+#define  CCK0_AFE_RX_MASK		0x0f000000
+#define  CCK0_AFE_RX_ANT_AB		BIT(24)
+#define  CCK0_AFE_RX_ANT_A		0
+#define  CCK0_AFE_RX_ANT_B		(BIT(24) | BIT(26))
 
 #define REG_CONFIG_ANT_A		0x0b68
 #define REG_CONFIG_ANT_B		0x0b6c
-- 
2.5.5

