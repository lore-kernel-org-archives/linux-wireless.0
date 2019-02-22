Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D24E0C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:15:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A8E2920818
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:15:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfBVHPr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:15:47 -0500
Received: from mxhk.zte.com.cn ([63.217.80.70]:63546 "EHLO mxhk.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbfBVHPp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 02:15:45 -0500
Received: from mse01.zte.com.cn (unknown [10.30.3.20])
        by Forcepoint Email with ESMTPS id 0775689F7E63BE8FA48E;
        Fri, 22 Feb 2019 15:15:43 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse01.zte.com.cn with ESMTP id x1M7FONF037279;
        Fri, 22 Feb 2019 15:15:24 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019022215160221-1228878 ;
          Fri, 22 Feb 2019 15:16:02 +0800 
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
Subject: [PATCH 2/5] net: mscc: ocelot: fix a leaked reference by adding a missing of_node_put
Date:   Fri, 22 Feb 2019 15:15:39 +0800
Message-Id: <1550819742-32155-2-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1550819742-32155-1-git-send-email-wen.yang99@zte.com.cn>
References: <1550819742-32155-1-git-send-email-wen.yang99@zte.com.cn>
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-02-22 15:16:02,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-02-22 15:15:08,
        Serialize complete at 2019-02-22 15:15:08
X-MAIL: mse01.zte.com.cn x1M7FONF037279
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The call to of_parse_phandle returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/net/ethernet/mscc/ocelot_board.c:293:3-9: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 249, but without a corresponding object release within this function.
./drivers/net/ethernet/mscc/ocelot_board.c:312:3-9: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 249, but without a corresponding object release within this function.
./drivers/net/ethernet/mscc/ocelot_board.c:336:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 249, but without a corresponding object release within this function.
./drivers/net/ethernet/mscc/ocelot_board.c:339:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 249, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/ethernet/mscc/ocelot_board.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_board.c b/drivers/net/ethernet/mscc/ocelot_board.c
index ca3ea2f..f1485a6 100644
--- a/drivers/net/ethernet/mscc/ocelot_board.c
+++ b/drivers/net/ethernet/mscc/ocelot_board.c
@@ -290,7 +290,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 
 		err = ocelot_probe_port(ocelot, port, regs, phy);
 		if (err)
-			return err;
+			goto err_probe_ports;
 
 		err = of_get_phy_mode(portnp);
 		if (err < 0)
@@ -309,7 +309,8 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 			dev_err(ocelot->dev,
 				"invalid phy mode for port%d, (Q)SGMII only\n",
 				port);
-			return -EINVAL;
+			err = -EINVAL;
+			goto err_probe_ports;
 		}
 
 		serdes = devm_of_phy_get(ocelot->dev, portnp, NULL);
@@ -328,6 +329,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 		ocelot->ports[port]->serdes = serdes;
 	}
 
+	of_node_put(ports);
 	register_netdevice_notifier(&ocelot_netdevice_nb);
 	register_switchdev_blocking_notifier(&ocelot_switchdev_blocking_nb);
 
@@ -336,6 +338,7 @@ static int mscc_ocelot_probe(struct platform_device *pdev)
 	return 0;
 
 err_probe_ports:
+	of_node_put(ports);
 	return err;
 }
 
-- 
2.9.5

