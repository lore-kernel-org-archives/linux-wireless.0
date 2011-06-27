Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:53864 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab1F0SDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 14:03:49 -0400
Received: by pwj7 with SMTP id 7so3094382pwj.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jun 2011 11:03:49 -0700 (PDT)
From: Jon Mason <jdmason@kudzu.us>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Chaoming Li <chaoming_li@realsil.com.cn>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 3/5] rtlwifi: use PCI_VENDOR_ID_*
Date: Mon, 27 Jun 2011 13:03:44 -0500
Message-Id: <1309197824-16848-1-git-send-email-jdmason@kudzu.us> (sfid-20110627_200402_150540_62B34EE2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use PCI_VENDOR_ID_* from pci_ids.h instead of creating #define locally.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
---
 drivers/net/wireless/rtlwifi/pci.c |    8 ++++----
 drivers/net/wireless/rtlwifi/pci.h |    6 ------
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/pci.c b/drivers/net/wireless/rtlwifi/pci.c
index 63501a1..fcdff1b 100644
--- a/drivers/net/wireless/rtlwifi/pci.c
+++ b/drivers/net/wireless/rtlwifi/pci.c
@@ -35,10 +35,10 @@
 #include "efuse.h"
 
 static const u16 pcibridge_vendors[PCI_BRIDGE_VENDOR_MAX] = {
-	INTEL_VENDOR_ID,
-	ATI_VENDOR_ID,
-	AMD_VENDOR_ID,
-	SIS_VENDOR_ID
+	PCI_VENDOR_ID_INTEL,
+	PCI_VENDOR_ID_ATI,
+	PCI_VENDOR_ID_AMD,
+	PCI_VENDOR_ID_SI
 };
 
 static const u8 ac_to_hwq[] = {
diff --git a/drivers/net/wireless/rtlwifi/pci.h b/drivers/net/wireless/rtlwifi/pci.h
index 76f4200..a50e551 100644
--- a/drivers/net/wireless/rtlwifi/pci.h
+++ b/drivers/net/wireless/rtlwifi/pci.h
@@ -62,12 +62,6 @@
 	.subdevice = PCI_ANY_ID,\
 	.driver_data = (kernel_ulong_t)&(cfg)
 
-#define INTEL_VENDOR_ID				0x8086
-#define SIS_VENDOR_ID				0x1039
-#define ATI_VENDOR_ID				0x1002
-#define ATI_DEVICE_ID				0x7914
-#define AMD_VENDOR_ID				0x1022
-
 #define PCI_MAX_BRIDGE_NUMBER			255
 #define PCI_MAX_DEVICES				32
 #define PCI_MAX_FUNCTION			8
-- 
1.7.5.4

