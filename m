Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344AbcFISiw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2016 14:38:52 -0400
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 1/4] rtl8xxxu: Add bit definitions for REG_USB_SPECIAL_OPTION
Date: Thu,  9 Jun 2016 14:38:47 -0400
Message-Id: <1465497530-18510-2-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160609_203858_264597_D24C4523)
In-Reply-To: <1465497530-18510-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1465497530-18510-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Documentation for enabling USB aggregation and whether to select
interrupt or bulk delivery of interrupt events.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index b0e0c64..bff883c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -1052,6 +1052,10 @@
 #define  USB_HIMR_ROK			BIT(0)	/*  Receive DMA OK Interrupt */
 
 #define REG_USB_SPECIAL_OPTION		0xfe55
+#define  USB_SPEC_USB_AGG_ENABLE	BIT(3)	/* Enable USB aggregation */
+#define  USB_SPEC_INT_BULK_SELECT	BIT(4)	/* Use interrupt endpoint to
+						   deliver interrupt packet.
+						   0: Use int, 1: use bulk */
 #define REG_USB_HRPWM			0xfe58
 #define REG_USB_DMA_AGG_TO		0xfe5b
 #define REG_USB_AGG_TO			0xfe5c
-- 
2.5.5

