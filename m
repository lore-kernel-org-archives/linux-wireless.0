Return-Path: <SRS0=BJpU=RT=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53CE3C43381
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 15:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A0C621900
	for <linux-wireless@archiver.kernel.org>; Sat, 16 Mar 2019 15:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1552751145;
	bh=Hl+H0Dns9SvNPptvU0hmZRfkEGjuFcEUhqka7u1kJSQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=hfy3G89dhaoCxdjMG/Nq3SJcwq458jH+Wtwuc1wD4i8AaHxzf+2TT0QqFpjkSt15R
	 +XV46eVYyV4J9vQU8cjIr8TrT7BaROmXK0QZvMIpLJ920snIKLQ1RU2cyPdgIyuDab
	 EktNET3kimNDRuMViEwGroRM8/QwnhfwcVMmn4lQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbfCPPpo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 16 Mar 2019 11:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:56812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726105AbfCPPpo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 16 Mar 2019 11:45:44 -0400
Received: from localhost.localdomain (unknown [151.66.48.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7B6F2218E0;
        Sat, 16 Mar 2019 15:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1552751143;
        bh=Hl+H0Dns9SvNPptvU0hmZRfkEGjuFcEUhqka7u1kJSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ocnomyFd3HgClro/DJITYwML3lyHqfu5CjSYd84vizpUHQ3Q9IA6qPQ2Jpu/zO5wM
         XpYFoZ9ad3RZsZW43qUQNx87gkCogKcVsreg+D7ckrJLa1zZDYn+LxmzExnt/YvSE8
         Rx/bcjrm3uDscKTw1nAt6DJUksS5RKJYOGJUHaX0=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sgruszka@redhat.com
Subject: [PATCH] mt7603: core: do not use magic numbers in mt7603_reg_map
Date:   Sat, 16 Mar 2019 16:45:36 +0100
Message-Id: <706fb012676ff05b851f3e1fc7246152416ebaa7.1552750760.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1552750760.git.lorenzo@kernel.org>
References: <cover.1552750760.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use register definitions instead of magic numbers in mt7603_reg_map

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/core.c b/drivers/net/wireless/mediatek/mt76/mt7603/core.c
index e32a16f2ebe8..4668c573f74a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/core.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/core.c
@@ -53,8 +53,8 @@ irqreturn_t mt7603_irq_handler(int irq, void *dev_instance)
 
 u32 mt7603_reg_map(struct mt7603_dev *dev, u32 addr)
 {
-	u32 base = addr & GENMASK(31, 19);
-	u32 offset = addr & GENMASK(18, 0);
+	u32 base = addr & MT_MCU_PCIE_REMAP_2_BASE;
+	u32 offset = addr & MT_MCU_PCIE_REMAP_2_OFFSET;
 
 	dev->bus_ops->wr(&dev->mt76, MT_MCU_PCIE_REMAP_2, base);
 
-- 
2.20.1

