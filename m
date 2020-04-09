Return-Path: <SRS0=oNpL=5Z=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B93CEC2BA2B
	for <linux-wireless@archiver.kernel.org>; Thu,  9 Apr 2020 16:37:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9023220768
	for <linux-wireless@archiver.kernel.org>; Thu,  9 Apr 2020 16:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586450240;
	bh=VXWkQVuflDvEk6Y7a9MpocTR5irjGN/oKT+CYNqLsws=;
	h=From:To:Cc:Subject:Date:List-ID:From;
	b=jTFdOCnkABVieGplAd0unYQXY56SjgDvMXJ/wv7/d0N4Mds+wwyO7u68HNfd+O3ix
	 xWKf4lWZIPza79Hgu15ioZ/qQYiIcjpIse0GycfPNA9nTivl+twKejj9w9SVE92v06
	 JGERfcauK9GIRWqH5Rm6pjIfywiS749wJYhe4mt0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbgDIQhT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 9 Apr 2020 12:37:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:45756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726857AbgDIQhT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 9 Apr 2020 12:37:19 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.151.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B784206F7;
        Thu,  9 Apr 2020 16:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586450239;
        bh=VXWkQVuflDvEk6Y7a9MpocTR5irjGN/oKT+CYNqLsws=;
        h=From:To:Cc:Subject:Date:From;
        b=bYoKC44OziP3pJgPY+bgI2Pdg1tXXWnBN9KCIAMxlKoBSLaaxO8Jkcdk1ILq3fT+4
         JBbLln73+BBx6gULzvu8erGnndfqvqFS9et/d09FWo7BVebOFw1xIdUPLZDcTJWTKr
         lEKZi3zI1tEjbVZM0ShmyQT/O/8vHO33qpTWvLnY=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com, ryder.lee@mediatek.com,
        soul.huang@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH] mt76: mt7615: enable MSI by default
Date:   Thu,  9 Apr 2020 18:37:04 +0200
Message-Id: <bde07fa0d259b124e1dcf6032ced1b693e4ddc24.1586450155.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Enable MSI/MSI-X PCI interrupts by default. This patch has been tested
using Banana Pi r64 board

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/pci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/pci.c b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
index a12833957d98..53e69dd6ba81 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/pci.c
@@ -33,6 +33,10 @@ static int mt7615_pci_probe(struct pci_dev *pdev,
 
 	pci_set_master(pdev);
 
+	ret = pci_alloc_irq_vectors(pdev, 1, 1, PCI_IRQ_ALL_TYPES);
+	if (ret < 0)
+		return ret;
+
 	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret)
 		return ret;
@@ -48,6 +52,7 @@ static void mt7615_pci_remove(struct pci_dev *pdev)
 	struct mt7615_dev *dev = container_of(mdev, struct mt7615_dev, mt76);
 
 	mt7615_unregister_device(dev);
+	pci_free_irq_vectors(pdev);
 }
 
 static int __maybe_unused mt7615_pci_suspend(struct pci_dev *pdev,
-- 
2.25.2

