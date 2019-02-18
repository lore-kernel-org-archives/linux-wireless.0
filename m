Return-Path: <SRS0=F8Dj=QZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9156EC4360F
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 07:38:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FFA0218C3
	for <linux-wireless@archiver.kernel.org>; Mon, 18 Feb 2019 07:38:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbfBRHit (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 18 Feb 2019 02:38:49 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:38128 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfBRHis (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 18 Feb 2019 02:38:48 -0500
Received: from DGGEMS406-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id E60F9C714C3F1F855390;
        Mon, 18 Feb 2019 15:38:45 +0800 (CST)
Received: from localhost.localdomain.localdomain (10.175.113.25) by
 DGGEMS406-HUB.china.huawei.com (10.3.19.206) with Microsoft SMTP Server id
 14.3.408.0; Mon, 18 Feb 2019 15:38:38 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Colin Ian King <colin.king@canonical.com>
CC:     YueHaibing <yuehaibing@huawei.com>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: [PATCH] rtl818x_pci: Remove set but not used variables 'io_addr, mem_addr'
Date:   Mon, 18 Feb 2019 07:52:26 +0000
Message-ID: <20190218075226.183964-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type:   text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Originating-IP: [10.175.113.25]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c: In function 'rtl8180_probe':
drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c:1727:15: warning:
 variable 'io_addr' set but not used [-Wunused-but-set-variable]

drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c:1726:16: warning:
 variable 'mem_addr' set but not used [-Wunused-but-set-variable]

They're never used since introduction.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
index e2b1bfbcfbd4..d5f65372356b 100644
--- a/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
+++ b/drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c
@@ -1723,8 +1723,8 @@ static int rtl8180_probe(struct pci_dev *pdev,
 {
 	struct ieee80211_hw *dev;
 	struct rtl8180_priv *priv;
-	unsigned long mem_addr, mem_len;
-	unsigned int io_addr, io_len;
+	unsigned long mem_len;
+	unsigned int io_len;
 	int err;
 	const char *chip_name, *rf_name = NULL;
 	u32 reg;
@@ -1743,9 +1743,7 @@ static int rtl8180_probe(struct pci_dev *pdev,
 		goto err_disable_dev;
 	}
 
-	io_addr = pci_resource_start(pdev, 0);
 	io_len = pci_resource_len(pdev, 0);
-	mem_addr = pci_resource_start(pdev, 1);
 	mem_len = pci_resource_len(pdev, 1);
 
 	if (mem_len < sizeof(struct rtl818x_csr) ||



