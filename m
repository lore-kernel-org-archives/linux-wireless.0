Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:60338 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752409AbaLRJF7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 04:05:59 -0500
Received: by mail-oi0-f44.google.com with SMTP id e131so112532oig.31
        for <linux-wireless@vger.kernel.org>; Thu, 18 Dec 2014 01:05:58 -0800 (PST)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 02/16] rtlwifi: rtl8821ae: Fix typos in power-sequence macro
Date: Thu, 18 Dec 2014 03:05:26 -0600
Message-Id: <1418893540-19944-3-git-send-email-Larry.Finger@lwfinger.net> (sfid-20141218_100608_381012_BDDF733D)
In-Reply-To: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1418893540-19944-1-git-send-email-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two of the macros that control power sequencing have values to be set that
contain bits that are not covered by the associated mask.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---
 drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.h b/drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.h
index bf0b0ce..36b3e91 100644
--- a/drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.h
+++ b/drivers/net/wireless/rtlwifi/rtl8821ae/pwrseq.h
@@ -93,9 +93,9 @@
 
 #define RTL8812_TRANS_CARDEMU_TO_SUS					\
 	{0x0042, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_USB_MSK,\
-	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xF0, 0xcc}, \
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xF0, 0xc0}, \
 	{0x0042, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_PCI_MSK,\
-	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xF0, 0xEC}, \
+	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xF0, 0xE0}, \
 	{0x0043, PWR_CUT_ALL_MSK, PWR_FAB_ALL_MSK, PWR_INTF_ALL_MSK,\
 	PWR_BASEADDR_MAC, PWR_CMD_WRITE, 0xFF, 0x07 \
 	/* gpio11 input mode, gpio10~8 output mode */},	\
-- 
2.1.2

