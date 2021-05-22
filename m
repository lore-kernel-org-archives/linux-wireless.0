Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 108C1C4707E
	for <linux-wireless@archiver.kernel.org>; Sat, 22 May 2021 10:54:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E7A2C6135B
	for <linux-wireless@archiver.kernel.org>; Sat, 22 May 2021 10:54:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbhEVKzY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 May 2021 06:55:24 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:5740 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230236AbhEVKzU (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 May 2021 06:55:20 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FnKxn682HzqV7g;
        Sat, 22 May 2021 18:50:21 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Sat, 22 May 2021 18:53:54 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Sat, 22 May
 2021 18:53:54 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
CC:     <kvalo@codeaurora.org>
Subject: [PATCH -next 2/2] ath10k: add missing error return code in ath10k_pci_probe()
Date:   Sat, 22 May 2021 18:58:22 +0800
Message-ID: <20210522105822.1091848-3-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210522105822.1091848-1-yangyingliang@huawei.com>
References: <20210522105822.1091848-1-yangyingliang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

When chip_id is not supported, the resources will be freed
on path err_unsupported, these resources will also be freed
when calling ath10k_pci_remove(), it will cause double free,
so return -ENODEV when it doesn't support the device with wrong
chip_id.

Fixes: c0c378f9907c ("ath10k: remove target soc ps code")
Fixes: 7505f7c3ec1d ("ath10k: create a chip revision whitelist")
Fixes: f8914a14623a ("ath10k: restore QCA9880-AR1A (v1) detection")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 463cf3f8f8a5..71878ab35b93 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3685,8 +3685,10 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 			ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
 		if (bus_params.chip_id != 0xffffffff) {
 			if (!ath10k_pci_chip_is_supported(pdev->device,
-							  bus_params.chip_id))
+							  bus_params.chip_id)) {
+				ret = -ENODEV;
 				goto err_unsupported;
+			}
 		}
 	}
 
@@ -3697,11 +3699,15 @@ static int ath10k_pci_probe(struct pci_dev *pdev,
 	}
 
 	bus_params.chip_id = ath10k_pci_soc_read32(ar, SOC_CHIP_ID_ADDRESS);
-	if (bus_params.chip_id == 0xffffffff)
+	if (bus_params.chip_id == 0xffffffff) {
+		ret = -ENODEV;
 		goto err_unsupported;
+	}
 
-	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id))
+	if (!ath10k_pci_chip_is_supported(pdev->device, bus_params.chip_id)) {
+		ret = -ENODEV;
 		goto err_unsupported;
+	}
 
 	ret = ath10k_core_register(ar, &bus_params);
 	if (ret) {
-- 
2.25.1

