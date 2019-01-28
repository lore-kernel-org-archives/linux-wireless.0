Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA194C282C8
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:48:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B278020880
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 15:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1548690497;
	bh=eE4c5dOgS9MNmyAwIcEd3190nYdxetfOVKxOC1YEm8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=dY+5qhOhXB1X1/W6oU7xi1mCMg1x4VKsSIXiZLwh/5yApEf1TgoP9swFSNc3NrqvB
	 2EgxEbMPd6Y375mkCV+FL0oLYA5zyYw2avBP+Qkv2TUb/vgf809Wgt+w5NgyqBR3p0
	 7hijZG1+UMpBOGGxbaANG9TKD/rD+iychfAoBaIo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728468AbfA1PsL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 10:48:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:33574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbfA1PsL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 10:48:11 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F032E2147A;
        Mon, 28 Jan 2019 15:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1548690490;
        bh=eE4c5dOgS9MNmyAwIcEd3190nYdxetfOVKxOC1YEm8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F/MZk0bV4252DazKwyNuq4e7eIJXLVgPg8IdQ6z2rq+iSj8dSvyp5a0Wi12I6aZ6x
         KYWVxLlp7nnESAGQDzeVE8FEhQbjRnPGIFuefaJL7+6UnqYs1xwQtUY3tTy7L752DW
         9NEM0jk8JLhg2oBm6VXzbZQEoLXF6Dngc6oZzELA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Felix Fietkau <nbd@nbd.name>, Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.20 104/304] mt76x0: dfs: fix IBI_R11 configuration on non-radar channels
Date:   Mon, 28 Jan 2019 10:40:21 -0500
Message-Id: <20190128154341.47195-104-sashal@kernel.org>
X-Mailer: git-send-email 2.19.1
In-Reply-To: <20190128154341.47195-1-sashal@kernel.org>
References: <20190128154341.47195-1-sashal@kernel.org>
MIME-Version: 1.0
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>

[ Upstream commit 6bf4a8e902aad7df55d7f2b10b850cfa3f880996 ]

Fix IBI_R11 configuration on non-radar channels for mt76x0e
driver. This patch improve system stability under heavy load.
Moreover use IBI_R11 name and remove magic numbers for
0x212c register

Fixes: 0c3b3abc9251 ("mt76x0: pci: add DFS support")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
index b56febae8945..764528c9f48a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_dfs.c
@@ -800,7 +800,7 @@ static void mt76x2_dfs_set_bbp_params(struct mt76x02_dev *dev)
 
 	/* enable detection*/
 	mt76_wr(dev, MT_BBP(DFS, 0), MT_DFS_CH_EN << 16);
-	mt76_wr(dev, 0x212c, 0x0c350001);
+	mt76_wr(dev, MT_BBP(IBI, 11), 0x0c350001);
 }
 
 void mt76x2_dfs_adjust_agc(struct mt76x02_dev *dev)
@@ -843,7 +843,11 @@ void mt76x2_dfs_init_params(struct mt76x02_dev *dev)
 		mt76_wr(dev, MT_BBP(DFS, 0), 0);
 		/* clear detector status */
 		mt76_wr(dev, MT_BBP(DFS, 1), 0xf);
-		mt76_wr(dev, 0x212c, 0);
+		if (mt76_chip(&dev->mt76) == 0x7610 ||
+		    mt76_chip(&dev->mt76) == 0x7630)
+			mt76_wr(dev, MT_BBP(IBI, 11), 0xfde8081);
+		else
+			mt76_wr(dev, MT_BBP(IBI, 11), 0);
 
 		mt76x02_irq_disable(dev, MT_INT_GPTIMER);
 		mt76_rmw_field(dev, MT_INT_TIMER_EN,
-- 
2.19.1

