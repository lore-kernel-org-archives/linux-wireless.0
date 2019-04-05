Return-Path: <SRS0=iN42=SH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A49DC282CE
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 21:32:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 02B7721726
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Apr 2019 21:32:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbfDEVcE (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Apr 2019 17:32:04 -0400
Received: from mail.ispras.ru ([83.149.199.45]:34032 "EHLO mail.ispras.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbfDEVcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Apr 2019 17:32:04 -0400
Received: from localhost.localdomain (109-252-62-95.nat.spd-mgts.ru [109.252.62.95])
        by mail.ispras.ru (Postfix) with ESMTPSA id 71E11540093;
        Sat,  6 Apr 2019 00:26:48 +0300 (MSK)
From:   Alexey Khoroshilov <khoroshilov@ispras.ru>
To:     Lennert Buytenhek <buytenh@wantstofly.org>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] mwl8k: fix error handling in mwl8k_post_cmd()
Date:   Sat,  6 Apr 2019 00:26:38 +0300
Message-Id: <1554499598-29351-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 2.7.4
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

If pci_map_single() fails in mwl8k_post_cmd(),
it returns -ENOMEM immediately, while cleanup is required.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/net/wireless/marvell/mwl8k.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwl8k.c b/drivers/net/wireless/marvell/mwl8k.c
index 8e4e9b6919e0..e0df51b62e97 100644
--- a/drivers/net/wireless/marvell/mwl8k.c
+++ b/drivers/net/wireless/marvell/mwl8k.c
@@ -2234,8 +2234,10 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 	dma_size = le16_to_cpu(cmd->length);
 	dma_addr = pci_map_single(priv->pdev, cmd, dma_size,
 				  PCI_DMA_BIDIRECTIONAL);
-	if (pci_dma_mapping_error(priv->pdev, dma_addr))
-		return -ENOMEM;
+	if (pci_dma_mapping_error(priv->pdev, dma_addr)) {
+		rc = -ENOMEM;
+		goto exit;
+	}
 
 	priv->hostcmd_wait = &cmd_wait;
 	iowrite32(dma_addr, regs + MWL8K_HIU_GEN_PTR);
@@ -2275,6 +2277,7 @@ static int mwl8k_post_cmd(struct ieee80211_hw *hw, struct mwl8k_cmd_pkt *cmd)
 				     ms);
 	}
 
+exit:
 	if (bitmap)
 		mwl8k_enable_bsses(hw, true, bitmap);
 
-- 
2.7.4

