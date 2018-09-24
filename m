Return-Path: <SRS0=DN1r=MG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9211AC43382
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4EBE7204EC
	for <linux-wireless@archiver.kernel.org>; Mon, 24 Sep 2018 22:15:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4EBE7204EC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=quantenna.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbeIYETs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 00:19:48 -0400
Received: from [12.131.200.82] ([12.131.200.82]:46855 "EHLO
        fm-smtp01.quantenna.com" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1728642AbeIYETr (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 00:19:47 -0400
Received: from dodo-dell.quantenna.com ([10.10.23.208])
        by fm-smtp01.quantenna.com (8.14.4/8.14.4) with ESMTP id w8OMFNOL012852;
        Mon, 24 Sep 2018 15:15:23 -0700
From:   Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
To:     linux-wireless@vger.kernel.org
Cc:     sergey.matyukevich.os@quantenna.com, ashevchenko@quantenna.com,
        Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
Subject: [PATCH V2 11/11] qtnfmac_pcie: check for correct CHIP ID at pcie probe
Date:   Mon, 24 Sep 2018 15:15:14 -0700
Message-Id: <20180924221514.4273-12-igor.mitsyanko.os@quantenna.com>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
References: <20180924221514.4273-1-igor.mitsyanko.os@quantenna.com>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Make sure that wifi device is of supported variant by checking it's CHIP ID
before completing a probe sequence.

Signed-off-by: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>
---
 .../wireless/quantenna/qtnfmac/pcie/pearl_pcie.c   | 24 ++++++++++++++++++++++
 .../net/wireless/quantenna/qtnfmac/qtn_hw_ids.h    | 14 +++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
index 6d72a9d..5aca12a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pearl_pcie.c
@@ -1090,6 +1090,26 @@ static void qtnf_pearl_reclaim_tasklet_fn(unsigned long data)
 	qtnf_en_txdone_irq(ps);
 }
 
+static int qtnf_pearl_check_chip_id(struct qtnf_pcie_pearl_state *ps)
+{
+	unsigned int chipid;
+
+	chipid = qtnf_chip_id_get(ps->base.sysctl_bar);
+
+	switch (chipid) {
+	case QTN_CHIP_ID_PEARL:
+	case QTN_CHIP_ID_PEARL_B:
+	case QTN_CHIP_ID_PEARL_C:
+		pr_info("chip ID is 0x%x\n", chipid);
+		break;
+	default:
+		pr_err("incorrect chip ID 0x%x\n", chipid);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int qtnf_pcie_pearl_probe(struct pci_dev *pdev,
 				 const struct pci_device_id *id)
 {
@@ -1130,6 +1150,10 @@ static int qtnf_pcie_pearl_probe(struct pci_dev *pdev,
 	qtnf_pcie_init_shm_ipc(&ps->base, &ps->bda->bda_shm_reg1,
 			       &ps->bda->bda_shm_reg2, &ipc_int);
 
+	ret = qtnf_pearl_check_chip_id(ps);
+	if (ret)
+		goto error;
+
 	ret = qtnf_pcie_pearl_init_xfer(ps);
 	if (ret) {
 		pr_err("PCIE xfer init failed\n");
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h b/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
index c4ad40d..1fe798a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qtn_hw_ids.h
@@ -25,8 +25,22 @@
 
 #define	PCIE_DEVICE_ID_QTN_PEARL	(0x0008)
 
+#define QTN_REG_SYS_CTRL_CSR		0x14
+#define QTN_CHIP_ID_MASK		0xF0
+#define QTN_CHIP_ID_TOPAZ		0x40
+#define QTN_CHIP_ID_PEARL		0x50
+#define QTN_CHIP_ID_PEARL_B		0x60
+#define QTN_CHIP_ID_PEARL_C		0x70
+
 /* FW names */
 
 #define QTN_PCI_PEARL_FW_NAME		"qtn/fmac_qsr10g.img"
 
+static inline unsigned int qtnf_chip_id_get(const void __iomem *regs_base)
+{
+	u32 board_rev = readl(regs_base + QTN_REG_SYS_CTRL_CSR);
+
+	return board_rev & QTN_CHIP_ID_MASK;
+}
+
 #endif	/* _QTN_HW_IDS_H_ */
-- 
2.9.5

