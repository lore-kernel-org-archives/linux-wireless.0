Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:43885 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754425AbdKAP3f (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 11:29:35 -0400
Received: by mail-oi0-f65.google.com with SMTP id c77so5043570oig.0
        for <linux-wireless@vger.kernel.org>; Wed, 01 Nov 2017 08:29:35 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 03/11] rtlwifi: rtl_pci: Simplify some code be eliminating extraneous variables
Date: Wed,  1 Nov 2017 10:29:18 -0500
Message-Id: <20171101152926.24971-4-Larry.Finger@lwfinger.net> (sfid-20171101_162957_646433_F7B17F35)
In-Reply-To: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
References: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In several places, the code assigns a variable inside an "if" or "case"
block, but uses it only once. The code is simplified by eliminating
the extraneous variable. With this change, one level of indenting is
saved.

This patch does not cause any functional changes in the binary code.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Ping-Ke Shih <pkshih@realtek.com>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 35 ++++++++++--------------------
 1 file changed, 11 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 7325806e40a2..01c65c807126 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -143,32 +143,19 @@ static void _rtl_pci_update_default_setting(struct ieee80211_hw *hw)
 
 	/*Set HW definition to determine if it supports ASPM. */
 	switch (rtlpci->const_support_pciaspm) {
-	case 0:{
-			/*Not support ASPM. */
-			bool support_aspm = false;
-			ppsc->support_aspm = support_aspm;
-			break;
-		}
-	case 1:{
-			/*Support ASPM. */
-			bool support_aspm = true;
-			bool support_backdoor = true;
-			ppsc->support_aspm = support_aspm;
-
-			/*if (priv->oem_id == RT_CID_TOSHIBA &&
-			   !priv->ndis_adapter.amd_l1_patch)
-			   support_backdoor = false; */
-
-			ppsc->support_backdoor = support_backdoor;
-
-			break;
-		}
+	case 0:
+		/*Not support ASPM. */
+		ppsc->support_aspm = false;
+		break;
+	case 1:
+		/*Support ASPM. */
+		ppsc->support_aspm = true;
+		ppsc->support_backdoor = true;
+		break;
 	case 2:
 		/*ASPM value set by chipset. */
-		if (pcibridge_vendor == PCI_BRIDGE_VENDOR_INTEL) {
-			bool support_aspm = true;
-			ppsc->support_aspm = support_aspm;
-		}
+		if (pcibridge_vendor == PCI_BRIDGE_VENDOR_INTEL)
+			ppsc->support_aspm = true;
 		break;
 	default:
 		pr_err("switch case %#x not processed\n",
-- 
2.14.3
