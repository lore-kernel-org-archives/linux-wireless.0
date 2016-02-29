Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 011/113] rtl8xxxu: Init REG_HIMR[01] for 8192eu parts
Date: Mon, 29 Feb 2016 17:04:09 -0500
Message-Id: <1456783551-28315-12-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230605_293723_AC49735D)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The newer generation chips have different interrupt registers.
Initialize this correct registers on 8192eu.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c      | 3 +++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 4 ++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 9236133..b6c20e3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4366,6 +4366,9 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		val32 = rtl8xxxu_read32(priv, REG_TXDMA_OFFSET_CHK);
 		val32 |= TXDMA_OFFSET_DROP_DATA_EN;
 		rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, val32);
+
+		rtl8xxxu_write32(priv, REG_HIMR0, 0x00);
+		rtl8xxxu_write32(priv, REG_HIMR1, 0x00);
 	}
 
 	ret = rtl8xxxu_init_mac(priv, rtl8723a_mac_init_table);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 226a1fa..3cbb549 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -196,6 +196,10 @@
 #define REG_HMBOX_EXT_1			0x008a
 #define REG_HMBOX_EXT_2			0x008c
 #define REG_HMBOX_EXT_3			0x008e
+/* Interrupt registers for 8192e/8812 */
+#define REG_HIMR0			0x00b0
+#define REG_HIMR1			0x00b8
+
 /*  Host suspend counter on FPGA platform */
 #define REG_HOST_SUSP_CNT		0x00bc
 /*  Efuse access protection for RTL8723 */
-- 
2.5.0

