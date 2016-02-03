Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:43523 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755951AbcBCGKR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 01:10:17 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u1369QdA011926
	for <linux-wireless@vger.kernel.org>; Tue, 2 Feb 2016 22:10:16 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 20svyv7n1p-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 02 Feb 2016 22:10:16 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 6/8] mwifiex: dynamically increase preallocated firmware dump memory size
Date: Tue, 2 Feb 2016 22:05:07 -0800
Message-ID: <1454479509-27129-7-git-send-email-akarwar@marvell.com> (sfid-20160203_071023_436651_68EB514D)
In-Reply-To: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
References: <1454479509-27129-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch increase firmware dump memory 4K each time, until
meet the demand.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/decl.h |  2 ++
 drivers/net/wireless/marvell/mwifiex/pcie.c | 21 ++++++++++++++++-----
 2 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/decl.h b/drivers/net/wireless/marvell/mwifiex/decl.h
index c744a70..a184f9f 100644
--- a/drivers/net/wireless/marvell/mwifiex/decl.h
+++ b/drivers/net/wireless/marvell/mwifiex/decl.h
@@ -122,6 +122,8 @@
 #define BLOCK_NUMBER_OFFSET		15
 #define SDIO_HEADER_OFFSET		28
 
+#define MWIFIEX_SIZE_4K 0x4000
+
 enum mwifiex_bss_type {
 	MWIFIEX_BSS_TYPE_STA = 0,
 	MWIFIEX_BSS_TYPE_UAP = 1,
diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.c b/drivers/net/wireless/marvell/mwifiex/pcie.c
index c94d31e..a62a09b 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.c
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.c
@@ -2402,7 +2402,8 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *creg = card->pcie.reg;
 	unsigned int reg, reg_start, reg_end;
-	u8 *dbg_ptr, *end_ptr, dump_num, idx, i, read_reg, doneflag = 0;
+	u8 *dbg_ptr, *end_ptr, *tmp_ptr, dump_num;
+	u8 idx, i, read_reg, doneflag = 0;
 	enum rdwr_status stat;
 	u32 memory_size;
 	int ret;
@@ -2485,11 +2486,21 @@ static void mwifiex_pcie_fw_dump(struct mwifiex_adapter *adapter)
 				mwifiex_read_reg_byte(adapter, reg, dbg_ptr);
 				if (dbg_ptr < end_ptr) {
 					dbg_ptr++;
-				} else {
-					mwifiex_dbg(adapter, ERROR,
-						    "Allocated buf not enough\n");
-					return;
+					continue;
 				}
+				mwifiex_dbg(adapter, ERROR,
+					    "pre-allocated buf not enough\n");
+				tmp_ptr =
+					vzalloc(memory_size + MWIFIEX_SIZE_4K);
+				if (!tmp_ptr)
+					return;
+				memcpy(tmp_ptr, entry->mem_ptr, memory_size);
+				vfree(entry->mem_ptr);
+				entry->mem_ptr = tmp_ptr;
+				tmp_ptr = NULL;
+				dbg_ptr = entry->mem_ptr + memory_size;
+				memory_size += MWIFIEX_SIZE_4K;
+				end_ptr = entry->mem_ptr + memory_size;
 			}
 
 			if (stat != RDWR_STATUS_DONE)
-- 
1.8.1.4

