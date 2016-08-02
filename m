Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:30444 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934867AbcHBMgC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 08:36:02 -0400
From: Baole Ni <baolex.ni@intel.com>
To: m@bues.ch, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
	m.chehab@samsung.com, pawel@osciak.com, m.szyprowski@samsung.com,
	kyungmin.park@samsung.com, k.kozlowski@samsung.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	chuansheng.liu@intel.com, baolex.ni@intel.com
Subject: [PATCH 0921/1285] Replace numeric parameter like 0444 with macro
Date: Tue,  2 Aug 2016 19:58:07 +0800
Message-Id: <20160802115807.11392-1-baolex.ni@intel.com> (sfid-20160802_170241_313741_1B261108)
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
 drivers/ssb/pcmcia.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ssb/pcmcia.c b/drivers/ssb/pcmcia.c
index f03422b..e69296a 100644
--- a/drivers/ssb/pcmcia.c
+++ b/drivers/ssb/pcmcia.c
@@ -764,7 +764,7 @@ static ssize_t ssb_pcmcia_attr_sprom_store(struct device *pcmciadev,
 				    ssb_pcmcia_sprom_write_all);
 }
 
-static DEVICE_ATTR(ssb_sprom, 0600,
+static DEVICE_ATTR(ssb_sprom, S_IRUSR | S_IWUSR,
 		   ssb_pcmcia_attr_sprom_show,
 		   ssb_pcmcia_attr_sprom_store);
 
-- 
2.9.2

