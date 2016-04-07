Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757312AbcDGSTe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Apr 2016 14:19:34 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net
Subject: [PATCH 13/18] rtl8xxxu: Set REG_USB_HRPWM for 8192eu
Date: Thu,  7 Apr 2016 14:19:28 -0400
Message-Id: <1460053173-8494-14-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160407_201959_466660_0A441255)
In-Reply-To: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1460053173-8494-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

The vendor driver set register 0xfe58 REG_USB_HWPWM in it's init
sequence for 8192eu. Do the same here.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c      | 2 ++
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index eac2a54..e06b25e 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -7225,6 +7225,8 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 			val32 |= FPGA_RF_MODE_CCK;
 			rtl8xxxu_write32(priv, REG_FPGA0_RF_MODE, val32);
 		}
+	} else if (priv->rtl_chip == RTL8192E) {
+		rtl8xxxu_write8(priv, REG_USB_HRPWM, 0x00);
 	}
 
 	val32 = rtl8xxxu_read32(priv, REG_FWHW_TXQ_CTRL);
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index ade42fe..82cbe85 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -1043,6 +1043,7 @@
 #define  USB_HIMR_ROK			BIT(0)	/*  Receive DMA OK Interrupt */
 
 #define REG_USB_SPECIAL_OPTION		0xfe55
+#define REG_USB_HRPWM			0xfe58
 #define REG_USB_DMA_AGG_TO		0xfe5b
 #define REG_USB_AGG_TO			0xfe5c
 #define REG_USB_AGG_TH			0xfe5d
-- 
2.5.5

