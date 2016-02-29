Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054AbcB2WFx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:53 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 010/113] rtl8xxxu: Kludge to drop incorrect USB OUT EP for 8192EU
Date: Mon, 29 Feb 2016 17:04:08 -0500
Message-Id: <1456783551-28315-11-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232951_239480_F10EA8B1)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The 8192eu (and some other parts) will report an incorrect USB OUT
EP. This tells the chip to drop it - as per the vendor driver.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c      | 6 ++++++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 45f787c..9236133 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -4362,6 +4362,12 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		}
 	}
 
+	if (priv->rtlchip == 0x8192e) {
+		val32 = rtl8xxxu_read32(priv, REG_TXDMA_OFFSET_CHK);
+		val32 |= TXDMA_OFFSET_DROP_DATA_EN;
+		rtl8xxxu_write32(priv, REG_TXDMA_OFFSET_CHK, val32);
+	}
+
 	ret = rtl8xxxu_init_mac(priv, rtl8723a_mac_init_table);
 	dev_dbg(dev, "%s: init_mac %i\n", __func__, ret);
 	if (ret)
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index b83bd34..226a1fa 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -367,6 +367,7 @@
 #define REG_FIFOPAGE			0x0204
 #define REG_TDECTRL			0x0208
 #define REG_TXDMA_OFFSET_CHK		0x020c
+#define  TXDMA_OFFSET_DROP_DATA_EN	BIT(9)
 #define REG_TXDMA_STATUS		0x0210
 #define REG_RQPN_NPQ			0x0214
 #define  RQPN_NPQ_SHIFT			0
-- 
2.5.0

