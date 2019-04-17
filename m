Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59613C282DA
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B3E32173C
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 09:41:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="CVZuMCWP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731539AbfDQJlk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 05:41:40 -0400
Received: from m50-132.163.com ([123.125.50.132]:35756 "EHLO m50-132.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726237AbfDQJlk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 05:41:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id; bh=FB96HGIvgdVb9qSx9R
        4mbXL9ivfhVDleOfilXfKKmtA=; b=CVZuMCWP6H5TVJJHDhC0LnwI1rCmg/ifhh
        NwudJ194vC6Bl51m/XS5KAYMZroxPPPSFNONEBbL0QEVQUr3a2ypKgKnLjG6VE5z
        ISk2MO4aPT/C5UzYt1gfu45ns/7gsNwgWO6sZsHZMHMjntwRTspAym/8iP0/XvPC
        FV8C766nA=
Received: from bp.localdomain (unknown [218.106.182.174])
        by smtp2 (Coremail) with SMTP id DNGowABHAnHH9LZcRelUAA--.6S3;
        Wed, 17 Apr 2019 17:41:29 +0800 (CST)
From:   Pan Bian <bianpan2016@163.com>
To:     Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
Subject: p54: drop device reference count if fails to enable device
Date:   Wed, 17 Apr 2019 17:41:23 +0800
Message-Id: <1555494083-130833-1-git-send-email-bianpan2016@163.com>
X-Mailer: git-send-email 2.7.4
X-CM-TRANSID: DNGowABHAnHH9LZcRelUAA--.6S3
X-Coremail-Antispam: 1Uf129KBjvdXoWrtF4kCF1xtw1DGryfWFyfZwb_yoWDuFc_GF
        WxZFZ7XryrAr109r1fCr43AFya9FnIqFs5Wrs7t3yFgrWUXFWDGrZ8ZF9rJr95W3y0vryD
        tr1DJr4fWayjgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUjmhFDUUUUU==
X-Originating-IP: [218.106.182.174]
X-CM-SenderInfo: held01tdqsiiqw6rljoofrz/xtbBZACZclQHEeYRlAAAsu
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The function p54p_probe takes an extra reference count of the PCI
device. However, the extra reference count is not dropped when it fails
to enable the PCI device. This patch fixes the bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/net/wireless/intersil/p54/p54pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/p54/p54pci.c b/drivers/net/wireless/intersil/p54/p54pci.c
index 27a4906..57ad564 100644
--- a/drivers/net/wireless/intersil/p54/p54pci.c
+++ b/drivers/net/wireless/intersil/p54/p54pci.c
@@ -554,7 +554,7 @@ static int p54p_probe(struct pci_dev *pdev,
 	err = pci_enable_device(pdev);
 	if (err) {
 		dev_err(&pdev->dev, "Cannot enable new PCI device\n");
-		return err;
+		goto err_put;
 	}
 
 	mem_addr = pci_resource_start(pdev, 0);
@@ -639,6 +639,7 @@ static int p54p_probe(struct pci_dev *pdev,
 	pci_release_regions(pdev);
  err_disable_dev:
 	pci_disable_device(pdev);
+err_put:
 	pci_dev_put(pdev);
 	return err;
 }
-- 
2.7.4


