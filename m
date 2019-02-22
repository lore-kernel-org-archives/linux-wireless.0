Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5A52C43381
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:15:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B88752086C
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:15:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726537AbfBVHPu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:15:50 -0500
Received: from out1.zte.com.cn ([202.103.147.172]:34964 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726413AbfBVHPt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 02:15:49 -0500
Received: from mse01.zte.com.cn (unknown [10.30.3.20])
        by Forcepoint Email with ESMTPS id 53DAB817848C31868EFA;
        Fri, 22 Feb 2019 15:15:47 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse01.zte.com.cn with ESMTP id x1M7FWwV037449;
        Fri, 22 Feb 2019 15:15:32 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019022215161040-1228945 ;
          Fri, 22 Feb 2019 15:16:10 +0800 
From:   Wen Yang <wen.yang99@zte.com.cn>
To:     linus.walleij@linaro.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, f.fainelli@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, kvalo@codeaurora.org,
        matthias.bgg@gmail.com, linux-wireless@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, anirudh@xilinx.com,
        John.Linn@xilinx.com, michal.simek@xilinx.com,
        wang.yi59@zte.com.cn, Wen Yang <wen.yang99@zte.com.cn>
Subject: [PATCH 4/5] net: xilinx: fix a leaked reference by adding missing of_node_put
Date:   Fri, 22 Feb 2019 15:15:41 +0800
Message-Id: <1550819742-32155-4-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1550819742-32155-1-git-send-email-wen.yang99@zte.com.cn>
References: <1550819742-32155-1-git-send-email-wen.yang99@zte.com.cn>
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-02-22 15:16:10,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-02-22 15:15:16,
        Serialize complete at 2019-02-22 15:15:16
X-MAIL: mse01.zte.com.cn x1M7FWwV037449
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The call to of_parse_phandle returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warning:
./drivers/net/ethernet/xilinx/xilinx_axienet_main.c:1624:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 1569, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Anirudha Sarangi <anirudh@xilinx.com>
Cc: John Linn <John.Linn@xilinx.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Michal Simek <michal.simek@xilinx.com>
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 0789d8a..8335390 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1575,11 +1575,13 @@ static int axienet_probe(struct platform_device *pdev)
 	ret = of_address_to_resource(np, 0, &dmares);
 	if (ret) {
 		dev_err(&pdev->dev, "unable to get DMA resource\n");
+		of_node_put(np);
 		goto free_netdev;
 	}
 	lp->dma_regs = devm_ioremap_resource(&pdev->dev, &dmares);
 	if (IS_ERR(lp->dma_regs)) {
 		dev_err(&pdev->dev, "could not map DMA regs\n");
+		of_node_put(np);
 		ret = PTR_ERR(lp->dma_regs);
 		goto free_netdev;
 	}
-- 
2.9.5

