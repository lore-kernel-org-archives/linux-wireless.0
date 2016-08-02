Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:61297 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934937AbcHBMfo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:35:44 -0400
From: Baole Ni <baolex.ni@intel.com>
To: m@bues.ch, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
	m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com
Subject: [PATCH 0920/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:58:03 +0800
Message-Id: <20160802115803.11325-1-baolex.ni@intel.com> (sfid-20160802_170528_924089_3E3320B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I find that the developers often just specified the numeric value
when calling a macro which is defined with a parameter for access permission.
As we know, these numeric value for access permission have had the corresponding macro,
and that using macro can improve the robustness and readability of the code,
thus, I suggest replacing the numeric parameter with the macro.

Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Baole Ni <baolex.ni@intel.com>
---
 drivers/ssb/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/pci.c b/drivers/ssb/pci.c
index 0f28c08..84622d2 100644
--- a/drivers/ssb/pci.c
+++ b/drivers/ssb/pci.c
@@ -1155,7 +1155,7 @@ static ssize_t ssb_pci_attr_sprom_store(struct device *pcidev,
 				    sprom_check_crc, sprom_do_write);
 }
 
-static DEVICE_ATTR(ssb_sprom, 0600,
+static DEVICE_ATTR(ssb_sprom, S_IRUSR | S_IWUSR,
 		   ssb_pci_attr_sprom_show,
 		   ssb_pci_attr_sprom_store);
 
-- 
2.9.2

