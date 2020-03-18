Return-Path: <SRS0=7roA=5D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FED1C10DCE
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 12:41:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D89F20772
	for <linux-wireless@archiver.kernel.org>; Wed, 18 Mar 2020 12:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584535300;
	bh=z71jGjL1m9KrTtjlItnXbj/IEW/7YEgbritM5qt4bys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=awCmdp9sAodjvDEjz2dM33liKhnmDSIQErQuPL+CnzjOxyMpzLbnYUpJK4s5ESnt/
	 PXWKRqeHHqir6aITaG1hGXp9C23uzM6LDuCxZ+5h8GyPrjC8XeodsWu+PeDdpzWhvc
	 zIkQtLHpBJxmTugMI7yKeC4Wg6TxNK1x9SJ8dXiE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgCRMlj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 18 Mar 2020 08:41:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:51864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726546AbgCRMlj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 18 Mar 2020 08:41:39 -0400
Received: from lore-desk-wlan.redhat.com (unknown [151.48.128.122])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9620120768;
        Wed, 18 Mar 2020 12:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584535299;
        bh=z71jGjL1m9KrTtjlItnXbj/IEW/7YEgbritM5qt4bys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nZ7EWbKsBEAVtjmww42Biz3rYKcXIchCsy1t0R01XAfnblnXu7qH9MOZ9BDUtKhBM
         F2SIO9KX4j7sf0MTQZucB6D66sWo3iwk7zNwnX5w5fot/Y6PHRcYRPOvauCdMhtVxl
         Ckup6ZciY1atAJ3Bnyr1AxJonUIDVuQbLV3dF2dE=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     kvalo@codeaurora.org
Cc:     linux-wireless@vger.kernel.org, nbd@nbd.name,
        lorenzo.bianconi@redhat.com, sean.wang@mediatek.com,
        ryder.lee@mediatek.com, linux-mediatek@lists.infradead.org
Subject: [PATCH 2/3] mt76: mt7615: fix endianness in unified command
Date:   Wed, 18 Mar 2020 13:41:04 +0100
Message-Id: <2447b399d3c63885d43f65ba988c057fa96f5236.1584534454.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1584534454.git.lorenzo@kernel.org>
References: <cover.1584534454.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Fix cid field endianness in unified mt7615_uni_txd header

Reported-by: kbuild test robot <lkp@intel.com>
Fixes: 323d7daad363 ("mt76: mt7615: introduce uni cmd command types")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
index 9978f6bb22ab..610cfa918c7b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/mcu.c
@@ -120,9 +120,9 @@ void mt7615_mcu_fill_msg(struct mt7615_dev *dev, struct sk_buff *skb,
 		uni_txd = (struct mt7615_uni_txd *)txd;
 		uni_txd->len = cpu_to_le16(skb->len - sizeof(uni_txd->txd));
 		uni_txd->option = MCU_CMD_UNI_EXT_ACK;
+		uni_txd->cid = cpu_to_le16(mcu_cmd);
 		uni_txd->s2d_index = MCU_S2D_H2N;
 		uni_txd->pkt_type = MCU_PKT_ID;
-		uni_txd->cid = mcu_cmd;
 		uni_txd->seq = seq;
 
 		return;
-- 
2.25.1

