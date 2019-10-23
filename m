Return-Path: <SRS0=XJ3z=YQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECCBCA9EB6
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Oct 2019 07:39:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 606562064A
	for <linux-wireless@archiver.kernel.org>; Wed, 23 Oct 2019 07:39:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389949AbfJWHjO (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 23 Oct 2019 03:39:14 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:39748 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2389224AbfJWHjO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 23 Oct 2019 03:39:14 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0EE469FA3A46F5293FE7;
        Wed, 23 Oct 2019 15:39:04 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS405-HUB.china.huawei.com
 (10.3.19.205) with Microsoft SMTP Server id 14.3.439.0; Wed, 23 Oct 2019
 15:38:55 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <yuehaibing@huawei.com>, <kstewart@linuxfoundation.org>,
        <allison@lohutok.net>, <info@metux.net>, <tglx@linutronix.de>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] adm80211: remove set but not used variables 'mem_addr' and 'io_addr'
Date:   Wed, 23 Oct 2019 15:38:42 +0800
Message-ID: <20191023073842.34512-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/admtek/adm8211.c:1784:16:
 warning: variable mem_addr set but not used [-Wunused-but-set-variable]
drivers/net/wireless/admtek/adm8211.c:1785:15:
 warning: variable io_addr set but not used [-Wunused-but-set-variable]

They are never used, so can be removed.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/admtek/adm8211.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/admtek/adm8211.c b/drivers/net/wireless/admtek/adm8211.c
index 46f1427..ba326f6 100644
--- a/drivers/net/wireless/admtek/adm8211.c
+++ b/drivers/net/wireless/admtek/adm8211.c
@@ -1781,8 +1781,8 @@ static int adm8211_probe(struct pci_dev *pdev,
 {
 	struct ieee80211_hw *dev;
 	struct adm8211_priv *priv;
-	unsigned long mem_addr, mem_len;
-	unsigned int io_addr, io_len;
+	unsigned long mem_len;
+	unsigned int io_len;
 	int err;
 	u32 reg;
 	u8 perm_addr[ETH_ALEN];
@@ -1794,9 +1794,7 @@ static int adm8211_probe(struct pci_dev *pdev,
 		return err;
 	}
 
-	io_addr = pci_resource_start(pdev, 0);
 	io_len = pci_resource_len(pdev, 0);
-	mem_addr = pci_resource_start(pdev, 1);
 	mem_len = pci_resource_len(pdev, 1);
 	if (io_len < 256 || mem_len < 1024) {
 		printk(KERN_ERR "%s (adm8211): Too short PCI resources\n",
-- 
2.7.4


