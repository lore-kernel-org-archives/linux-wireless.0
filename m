Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f178.google.com ([209.85.160.178]:36077 "EHLO
	mail-yk0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753307AbbKJQq0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2015 11:46:26 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Stable <stable@vger.kernel.org>
Subject: [PATCH] realtek: rtlwifi: rtl8821ae: Fix lockups on boot
Date: Tue, 10 Nov 2015 10:46:11 -0600
Message-Id: <1447173971-15311-1-git-send-email-Larry.Finger@lwfinger.net> (sfid-20151110_174630_327984_34D75F5F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In commit 54328e64047a5 ("rtlwifi: rtl8821ae: Fix system lockups on boot"),
an attempt was made to fix a regression introduced in commit 1277fa2ab2f9
("rtlwifi: Remove the clear interrupt routine from all drivers").
Unfortunately, there were logic errors in that patch that prevented
affected boxes from booting even after that patch was applied.

The actual cause of the original problem is unknown as none of the
developers have systems that are affected.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Stable <stable@vger.kernel.org> [V4.1+]
---

Kalle,

I hope this patch can be applied to 4.4.

Thanks,

Larry

 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c | 2 +-
 drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
index 6e9418e..bbb789f 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/hw.c
@@ -2272,7 +2272,7 @@ void rtl8821ae_enable_interrupt(struct ieee80211_hw *hw)
 	struct rtl_priv *rtlpriv = rtl_priv(hw);
 	struct rtl_pci *rtlpci = rtl_pcidev(rtl_pcipriv(hw));
 
-	if (!rtlpci->int_clear)
+	if (rtlpci->int_clear)
 		rtl8821ae_clear_interrupt(hw);/*clear it here first*/
 
 	rtl_write_dword(rtlpriv, REG_HIMR, rtlpci->irq_mask[0] & 0xFFFFFFFF);
diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
index 8ee141a..142bdff 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/sw.c
@@ -448,7 +448,7 @@ MODULE_PARM_DESC(fwlps, "Set to 1 to use FW control power save (default 1)\n");
 MODULE_PARM_DESC(msi, "Set to 1 to use MSI interrupts mode (default 1)\n");
 MODULE_PARM_DESC(debug, "Set debug level (0-5) (default 0)");
 MODULE_PARM_DESC(disable_watchdog, "Set to 1 to disable the watchdog (default 0)\n");
-MODULE_PARM_DESC(int_clear, "Set to 1 to disable interrupt clear before set (default 0)\n");
+MODULE_PARM_DESC(int_clear, "Set to 0 to disable interrupt clear before set (default 1)\n");
 
 static SIMPLE_DEV_PM_OPS(rtlwifi_pm_ops, rtl_pci_suspend, rtl_pci_resume);
 
-- 
2.1.4

