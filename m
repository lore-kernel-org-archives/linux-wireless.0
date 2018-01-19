Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18602 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755654AbeASPhL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Jan 2018 10:37:11 -0500
From: Maya Erez <merez@codeaurora.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Maya Erez <merez@codeaurora.org>, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, Maya Erez <merez@codaurora.org>
Subject: [PATCH 1/8] wil6210: add Talyn PCIe device ID
Date: Fri, 19 Jan 2018 17:36:57 +0200
Message-Id: <1516376224-13976-2-git-send-email-merez@codeaurora.org> (sfid-20180119_163719_744971_B220A832)
In-Reply-To: <1516376224-13976-1-git-send-email-merez@codeaurora.org>
References: <1516376224-13976-1-git-send-email-merez@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

PCIe device ID has changed in Talyn.
Add this ID to wil6210_pcie_ids list to allow
recognition of Talyn device.

Signed-off-by: Maya Erez <merez@codeaurora.org>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index 0c401bf..f8c7a6b 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2012-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -378,6 +379,7 @@ static void wil_pcie_remove(struct pci_dev *pdev)
 static const struct pci_device_id wil6210_pcie_ids[] = {
 	{ PCI_DEVICE(0x1ae9, 0x0310) },
 	{ PCI_DEVICE(0x1ae9, 0x0302) }, /* same as above, firmware broken */
+	{ PCI_DEVICE(0x17cb, 0x1201) }, /* Talyn */
 	{ /* end: all zeroes */	},
 };
 MODULE_DEVICE_TABLE(pci, wil6210_pcie_ids);
-- 
1.9.1
