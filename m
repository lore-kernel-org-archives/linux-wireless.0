Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:33097 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbbC1Nf5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2015 09:35:57 -0400
Received: by lbcmq2 with SMTP id mq2so80712444lbc.0
        for <linux-wireless@vger.kernel.org>; Sat, 28 Mar 2015 06:35:56 -0700 (PDT)
From: Kristian Evensen <kristian.evensen@gmail.com>
To: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: Kristian Evensen <kristian.evensen@gmail.com>
Subject: [PATCH] ath10k: Add support for Compex WLE900VX 7AA
Date: Sat, 28 Mar 2015 14:35:41 +0100
Message-Id: <1427549741-20669-1-git-send-email-kristian.evensen@gmail.com> (sfid-20150328_143600_945462_2BB0D6F1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kristian Evensen <kristian.evensen@gmail.com>

Add support for the dual-band Compex WLE900VX 7AA card, which uses the ath10k
chipset. According to dmesg output, it is delivered with version 2.0 of qca988x.
All supported modes (a/b/g/n/ac) has worked fine in my quick tests.

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 7681237..8de8349 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -57,12 +57,14 @@ MODULE_PARM_DESC(reset_mode, "0: auto, 1: warm only (default: 0)");
 #define ATH10K_PCI_TARGET_WAIT 3000
 #define ATH10K_PCI_NUM_WARM_RESET_ATTEMPTS 3
 
-#define QCA988X_2_0_DEVICE_ID	(0x003c)
-#define QCA6174_2_1_DEVICE_ID	(0x003e)
+#define QCA988X_2_0_DEVICE_ID		(0x003c)
+#define QCA6174_2_1_DEVICE_ID		(0x003e)
+#define COMPEX_WLE900VX_7AA_DEVICE_ID	(0xabcd)
 
 static const struct pci_device_id ath10k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, QCA988X_2_0_DEVICE_ID) }, /* PCI-E QCA988X V2 */
 	{ PCI_VDEVICE(ATHEROS, QCA6174_2_1_DEVICE_ID) }, /* PCI-E QCA6174 V2.1 */
+	{ PCI_VDEVICE(ATHEROS, COMPEX_WLE900VX_7AA_DEVICE_ID) },
 	{0}
 };
 
-- 
1.9.1

