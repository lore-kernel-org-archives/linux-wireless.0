Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64D7DC10F00
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:16:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40C2A2086C
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:16:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfBVHPp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:15:45 -0500
Received: from mxhk.zte.com.cn ([63.217.80.70]:25256 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbfBVHPo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 02:15:44 -0500
Received: from mse01.zte.com.cn (unknown [10.30.3.20])
        by Forcepoint Email with ESMTPS id 2CF9DDD809A2863B0878;
        Fri, 22 Feb 2019 15:15:41 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse01.zte.com.cn with ESMTP id x1M7FLSP037220;
        Fri, 22 Feb 2019 15:15:21 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019022215155958-1228853 ;
          Fri, 22 Feb 2019 15:15:59 +0800 
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
Subject: [PATCH 1/5] net: dsa: fix a leaked reference by adding a missing of_node_put
Date:   Fri, 22 Feb 2019 15:15:38 +0800
Message-Id: <1550819742-32155-1-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-02-22 15:15:59,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-02-22 15:15:05,
        Serialize complete at 2019-02-22 15:15:05
X-MAIL: mse01.zte.com.cn x1M7FLSP037220
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The call to of_get_child_by_name returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/net/dsa/rtl8366rb.c:510:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 501, but without a corresponding object release within this function.
./drivers/net/dsa/rtl8366rb.c:518:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 501, but without a corresponding object release within this function.
./drivers/net/dsa/rtl8366rb.c:540:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 501, but without a corresponding object release within this function.
./drivers/net/dsa/rtl8366rb.c:548:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 501, but without a corresponding object release within this function.
./drivers/net/dsa/rtl8366rb.c:556:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 501, but without a corresponding object release within this function.
./drivers/net/dsa/rtl8366rb.c:561:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 501, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: Vivien Didelot <vivien.didelot@gmail.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/dsa/rtl8366rb.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/rtl8366rb.c b/drivers/net/dsa/rtl8366rb.c
index a4d5049..f4b14b6 100644
--- a/drivers/net/dsa/rtl8366rb.c
+++ b/drivers/net/dsa/rtl8366rb.c
@@ -507,7 +507,8 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 	irq = of_irq_get(intc, 0);
 	if (irq <= 0) {
 		dev_err(smi->dev, "failed to get parent IRQ\n");
-		return irq ? irq : -EINVAL;
+		ret = irq ? irq : -EINVAL;
+		goto out_put_node;
 	}
 
 	/* This clears the IRQ status register */
@@ -515,7 +516,7 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 			  &val);
 	if (ret) {
 		dev_err(smi->dev, "can't read interrupt status\n");
-		return ret;
+		goto out_put_node;
 	}
 
 	/* Fetch IRQ edge information from the descriptor */
@@ -537,7 +538,7 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 				 val);
 	if (ret) {
 		dev_err(smi->dev, "could not configure IRQ polarity\n");
-		return ret;
+		goto out_put_node;
 	}
 
 	ret = devm_request_threaded_irq(smi->dev, irq, NULL,
@@ -545,7 +546,7 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 					"RTL8366RB", smi);
 	if (ret) {
 		dev_err(smi->dev, "unable to request irq: %d\n", ret);
-		return ret;
+		goto out_put_node;
 	}
 	smi->irqdomain = irq_domain_add_linear(intc,
 					       RTL8366RB_NUM_INTERRUPT,
@@ -553,12 +554,15 @@ static int rtl8366rb_setup_cascaded_irq(struct realtek_smi *smi)
 					       smi);
 	if (!smi->irqdomain) {
 		dev_err(smi->dev, "failed to create IRQ domain\n");
-		return -EINVAL;
+		ret = -EINVAL;
+		goto out_put_node;
 	}
 	for (i = 0; i < smi->num_ports; i++)
 		irq_set_parent(irq_create_mapping(smi->irqdomain, i), irq);
 
-	return 0;
+out_put_node:
+	of_node_put(intc);
+	return ret;
 }
 
 static int rtl8366rb_set_addr(struct realtek_smi *smi)
-- 
2.9.5

