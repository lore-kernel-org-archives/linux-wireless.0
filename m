Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:51439 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751586AbcFUJO4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 05:14:56 -0400
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Nishant Sarmukadam <nishants@marvell.com>,
	Wei-Ning Huang <wnhuang@chromium.org>,
	Cathy Luo <cluo@marvell.com>, Shengzhen Li <szli@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH] mwifiex: disable MSIx interrupt for 8997 chipset
Date: Tue, 21 Jun 2016 14:32:32 +0530
Message-ID: <1466499752-1818-1-git-send-email-akarwar@marvell.com> (sfid-20160621_111505_222350_97DCB5DE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shengzhen Li <szli@marvell.com>

Sometimes MSIx interrupts are received out of order on multi-core
system. This creates a problem when there is a race between data
packet and SLEEP event from firmware. We will disable MSIx interrupt
mode to solve the problem and go with MSI mode.

Signed-off-by: Shengzhen Li <szli@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 2592e63..9c00c7e 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -258,7 +258,7 @@ static const struct mwifiex_pcie_card_reg mwifiex_reg_8997 = {
 	.fw_dump_end = 0xcff,
 	.fw_dump_host_ready = 0xcc,
 	.fw_dump_read_done = 0xdd,
-	.msix_support = 1,
+	.msix_support = 0,
 };
 
 static struct memory_type_mapping mem_type_mapping_tbl_w8897[] = {
-- 
1.9.1

