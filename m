Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:44546 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754593AbdKAP3i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Nov 2017 11:29:38 -0400
Received: by mail-oi0-f67.google.com with SMTP id v132so5036852oie.1
        for <linux-wireless@vger.kernel.org>; Wed, 01 Nov 2017 08:29:37 -0700 (PDT)
From: Larry Finger <Larry.Finger@lwfinger.net>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ping-Ke Shih <pkshih@realtek.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Birming Chiu <birming@realtek.com>,
        Shaofu <shaofu@realtek.com>, Steven Ting <steventing@realtek.com>
Subject: [PATCH 06/11] rtlwifi: rtl_pci: Add ID for 8822BE
Date: Wed,  1 Nov 2017 10:29:21 -0500
Message-Id: <20171101152926.24971-7-Larry.Finger@lwfinger.net> (sfid-20171101_162958_582787_5D3FF648)
In-Reply-To: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
References: <20171101152926.24971-1-Larry.Finger@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

When the driver for the RTL8822BE is added, it will need an ID for
further use.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Yan-Hsuan Chuang <yhchuang@realtek.com>
Cc: Birming Chiu <birming@realtek.com>
Cc: Shaofu <shaofu@realtek.com>
Cc: Steven Ting <steventing@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/pci.c | 5 +++++
 drivers/net/wireless/realtek/rtlwifi/pci.h | 1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 0c30f4bf657b..874e1e593da9 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -1967,6 +1967,11 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 		rtlhal->hw_type = HARDWARE_TYPE_RTL8812AE;
 		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
 			 "Find adapter, Hardware type is 8812AE\n");
+	} else if (deviceid == RTL_PCI_8822BE_DID) {
+		rtlhal->hw_type = HARDWARE_TYPE_RTL8822BE;
+		rtlhal->bandset = BAND_ON_BOTH;
+		RT_TRACE(rtlpriv, COMP_INIT, DBG_LOUD,
+			 "Find adapter, Hardware type is 8822BE\n");
 	} else {
 		RT_TRACE(rtlpriv, COMP_ERR, DBG_WARNING,
 			 "Err: Unknown device - vid/did=%x/%x\n",
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.h b/drivers/net/wireless/realtek/rtlwifi/pci.h
index 6bf346ec4616..ce33fe7bc7c4 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.h
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.h
@@ -109,6 +109,7 @@
 #define RTL_PCI_8192EE_DID	0x818B	/*8192ee*/
 #define RTL_PCI_8821AE_DID	0x8821	/*8821ae*/
 #define RTL_PCI_8812AE_DID	0x8812	/*8812ae*/
+#define RTL_PCI_8822BE_DID	0xB822	/*8822be*/
 
 /*8192 support 16 pages of IO registers*/
 #define RTL_MEM_MAPPED_IO_RANGE_8190PCI		0x1000
-- 
2.14.3
