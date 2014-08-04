Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:41535 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756AbaHDIWe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Aug 2014 04:22:34 -0400
From: Dedy Lansky <qca_dlansky@qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>
CC: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <wil6210@qca.qualcomm.com>
Subject: [PATCH 07/14] wil6210: Workaround for Sparrow with bad device id
Date: Mon, 4 Aug 2014 11:20:47 +0300
Message-ID: <1407140454-31639-8-git-send-email-qca_dlansky@qca.qualcomm.com> (sfid-20140804_102238_473961_470552E0)
In-Reply-To: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
References: <1407140454-31639-1-git-send-email-qca_dlansky@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>

If firmware broken on the boot time, Sparrow card enumerates as
device 0x302 instead of 0x310. Allow using this ID

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 drivers/net/wireless/ath/wil6210/pcie_bus.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/wil6210/pcie_bus.c b/drivers/net/wireless/ath/wil6210/pcie_bus.c
index a6af2bb..cf0b219 100644
--- a/drivers/net/wireless/ath/wil6210/pcie_bus.c
+++ b/drivers/net/wireless/ath/wil6210/pcie_bus.c
@@ -243,6 +243,8 @@ static const struct pci_device_id wil6210_pcie_ids[] = {
 	  .driver_data = (kernel_ulong_t)&wil_board_marlon },
 	{ PCI_DEVICE(0x1ae9, 0x0310),
 	  .driver_data = (kernel_ulong_t)&wil_board_sparrow },
+	{ PCI_DEVICE(0x1ae9, 0x0302), /* same as above, firmware broken */
+	  .driver_data = (kernel_ulong_t)&wil_board_sparrow },
 	{ /* end: all zeroes */	},
 };
 MODULE_DEVICE_TABLE(pci, wil6210_pcie_ids);
-- 
1.8.5.2

