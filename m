Return-Path: <SRS0=sdWG=IF=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3368EC433E9
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Mar 2021 18:21:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3DC5650F2
	for <linux-wireless@archiver.kernel.org>; Sun,  7 Mar 2021 18:21:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbhCGSVL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 7 Mar 2021 13:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230511AbhCGSVG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 7 Mar 2021 13:21:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B5F4650F2;
        Sun,  7 Mar 2021 18:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615141266;
        bh=DhqWAY1+vSlZA1IIHrAkdsnEDqnxIcAXDmgQPMn7F5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKiVEe/Eex1KnkeHn28sEPAVL/YHir4HSYQL45xUaxtO3LMnxzkYK/IV5hZrQoInH
         vYzUwucGE78CKIQuapTdWcyRniIWZwsFPig0kUV4+CHemfgYOSLyixjfsZ+botSPcQ
         lcSX6TrK9H328eVw84fvMubp4mmr9rh4rZjPeFQsUEtw67eLb7lHnSdrv0jbNswrAq
         Dj+mexeAx7VM7yFWbhdvfru8J8a/5Uuo49quZ7y+OteO6y3fEcGVGsLxts7Hx/q5Es
         bmoAVBr1N/mGPzeqZsLB5xegP4clU3rkByQapllAH0jNf/WxR+NsSE8HN5I0jycQZJ
         C7ljNFosARvNQ==
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        sean.wang@mediatek.com
Subject: [PATCH 1/7] mt76: mt7921: reduce mcu timeouts for suspend, offload and hif_ctrl msg
Date:   Sun,  7 Mar 2021 19:20:45 +0100
Message-Id: <4929cef6d4965cc00279747c761917da84df5e0f.1615140875.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1615140875.git.lorenzo@kernel.org>
References: <cover.1615140875.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Reduce mcu timeout for the following uni mcu commands:
- MCU_UNI_CMD_SUSPEND
- MCU_UNI_CMD_OFFLOAD
- MCU_UNI_CMD_HIF_CTRL

This is a preliminary patch to introduce chip reset support

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
index 58de7f32a625..1c686e4abd80 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mcu.c
@@ -222,8 +222,16 @@ mt7921_mcu_send_message(struct mt76_dev *mdev, struct sk_buff *skb,
 	u32 val;
 	u8 seq;
 
-	/* TODO: make dynamic based on msg type */
-	mdev->mcu.timeout = 20 * HZ;
+	switch (cmd) {
+	case MCU_UNI_CMD_HIF_CTRL:
+	case MCU_UNI_CMD_SUSPEND:
+	case MCU_UNI_CMD_OFFLOAD:
+		mdev->mcu.timeout = HZ / 3;
+		break;
+	default:
+		mdev->mcu.timeout = 3 * HZ;
+		break;
+	}
 
 	seq = ++dev->mt76.mcu.msg_seq & 0xf;
 	if (!seq)
-- 
2.29.2

