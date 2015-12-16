Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:30620 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933377AbbLPMYP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 07:24:15 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tBGCKBeJ025961
	for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 04:24:14 -0800
Received: from sc-exch03.marvell.com ([199.233.58.183])
	by mx0a-0016f401.pphosted.com with ESMTP id 1yu76x83kh-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 04:24:14 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Shengzhen Li <szli@marvell.com>
Subject: [PATCH 2/4] mwifiex: fix PCIe register information for 8997 chipset
Date: Wed, 16 Dec 2015 04:21:43 -0800
Message-ID: <1450268505-2682-2-git-send-email-akarwar@marvell.com> (sfid-20151216_132419_006528_036B23AA)
In-Reply-To: <1450268505-2682-1-git-send-email-akarwar@marvell.com>
References: <1450268505-2682-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch corrects some information in mwifiex_pcie_card_reg()
structure for 8997 chipset

Fixes: 6d85ef00d9dfe ("mwifiex: add support for 8997 chipset")
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Shengzhen Li <szli@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/pcie.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/pcie.h b/drivers/net/wireless/marvell/mwifiex/pcie.h
index 48e549c..7db46ee 100644
--- a/drivers/net/wireless/marvell/mwifiex/pcie.h
+++ b/drivers/net/wireless/marvell/mwifiex/pcie.h
@@ -210,17 +210,17 @@ static const struct mwifiex_pcie_card_reg mwifiex_reg_8997 = {
 	.cmdrsp_addr_lo = PCIE_SCRATCH_4_REG,
 	.cmdrsp_addr_hi = PCIE_SCRATCH_5_REG,
 	.tx_rdptr = 0xC1A4,
-	.tx_wrptr = 0xC1A8,
-	.rx_rdptr = 0xC1A8,
+	.tx_wrptr = 0xC174,
+	.rx_rdptr = 0xC174,
 	.rx_wrptr = 0xC1A4,
 	.evt_rdptr = PCIE_SCRATCH_10_REG,
 	.evt_wrptr = PCIE_SCRATCH_11_REG,
 	.drv_rdy = PCIE_SCRATCH_12_REG,
 	.tx_start_ptr = 16,
 	.tx_mask = 0x0FFF0000,
-	.tx_wrap_mask = 0x01FF0000,
+	.tx_wrap_mask = 0x1FFF0000,
 	.rx_mask = 0x00000FFF,
-	.rx_wrap_mask = 0x000001FF,
+	.rx_wrap_mask = 0x00001FFF,
 	.tx_rollover_ind = BIT(28),
 	.rx_rollover_ind = BIT(12),
 	.evt_rollover_ind = MWIFIEX_BD_FLAG_EVT_ROLLOVER_IND,
-- 
1.8.1.4

