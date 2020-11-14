Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E60C5519F
	for <linux-wireless@archiver.kernel.org>; Sat, 14 Nov 2020 12:31:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 395DC20665
	for <linux-wireless@archiver.kernel.org>; Sat, 14 Nov 2020 12:31:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726625AbgKNMbA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 14 Nov 2020 07:31:00 -0500
Received: from szxga05-in.huawei.com ([45.249.212.191]:8090 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbgKNMa7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Nov 2020 07:30:59 -0500
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4CYF6j258BzLpl0;
        Sat, 14 Nov 2020 20:30:37 +0800 (CST)
Received: from huawei.com (10.175.113.133) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.487.0; Sat, 14 Nov 2020
 20:30:47 +0800
From:   Wang Hai <wanghai38@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>,
        <imitsyanko@quantenna.com>, <geomatsi@gmail.com>,
        <kvalo@codeaurora.org>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH net] qtnfmac: fix error return code in qtnf_pcie_probe()
Date:   Sat, 14 Nov 2020 20:33:47 +0800
Message-ID: <20201114123347.29632-1-wanghai38@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.175.113.133]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix to return a negative error code from the error handling
case instead of 0, as done elsewhere in this function.

Fixes: b7da53cd6cd1 ("qtnfmac_pcie: use single PCIe driver for all platforms")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
index 5337e67092ca..0f328ce47fee 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pcie/pcie.c
@@ -299,19 +299,19 @@ static int qtnf_pcie_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sysctl_bar = qtnf_map_bar(pdev, QTN_SYSCTL_BAR);
 	if (IS_ERR(sysctl_bar)) {
 		pr_err("failed to map BAR%u\n", QTN_SYSCTL_BAR);
-		return ret;
+		return PTR_ERR(sysctl_bar);
 	}
 
 	dmareg_bar = qtnf_map_bar(pdev, QTN_DMA_BAR);
 	if (IS_ERR(dmareg_bar)) {
 		pr_err("failed to map BAR%u\n", QTN_DMA_BAR);
-		return ret;
+		return PTR_ERR(dmareg_bar);
 	}
 
 	epmem_bar = qtnf_map_bar(pdev, QTN_SHMEM_BAR);
 	if (IS_ERR(epmem_bar)) {
 		pr_err("failed to map BAR%u\n", QTN_SHMEM_BAR);
-		return ret;
+		return PTR_ERR(epmem_bar);
 	}
 
 	chipid = qtnf_chip_id_get(sysctl_bar);
-- 
2.17.1

