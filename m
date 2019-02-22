Return-Path: <SRS0=FR9J=Q5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DCC7C4360F
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7B792086C
	for <linux-wireless@archiver.kernel.org>; Fri, 22 Feb 2019 07:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbfBVHPv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 22 Feb 2019 02:15:51 -0500
Received: from out1.zte.com.cn ([202.103.147.172]:34840 "EHLO mxct.zte.com.cn"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726360AbfBVHPu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Feb 2019 02:15:50 -0500
Received: from mse01.zte.com.cn (unknown [10.30.3.20])
        by Forcepoint Email with ESMTPS id 35B44732F508B31BCDC5;
        Fri, 22 Feb 2019 15:15:44 +0800 (CST)
Received: from notes_smtp.zte.com.cn ([10.30.1.239])
        by mse01.zte.com.cn with ESMTP id x1M7FTGm037387;
        Fri, 22 Feb 2019 15:15:29 +0800 (GMT-8)
        (envelope-from wen.yang99@zte.com.cn)
Received: from fox-host8.localdomain ([10.74.120.8])
          by szsmtp06.zte.com.cn (Lotus Domino Release 8.5.3FP6)
          with ESMTP id 2019022215160783-1228925 ;
          Fri, 22 Feb 2019 15:16:07 +0800 
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
Subject: [PATCH 3/5] mt76: fix a leaked reference by adding a missing of_node_put
Date:   Fri, 22 Feb 2019 15:15:40 +0800
Message-Id: <1550819742-32155-3-git-send-email-wen.yang99@zte.com.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1550819742-32155-1-git-send-email-wen.yang99@zte.com.cn>
References: <1550819742-32155-1-git-send-email-wen.yang99@zte.com.cn>
X-MIMETrack: Itemize by SMTP Server on SZSMTP06/server/zte_ltd(Release 8.5.3FP6|November
 21, 2013) at 2019-02-22 15:16:08,
        Serialize by Router on notes_smtp/zte_ltd(Release 9.0.1FP7|August  17, 2016) at
 2019-02-22 15:15:14,
        Serialize complete at 2019-02-22 15:15:14
X-MAIL: mse01.zte.com.cn x1M7FTGm037387
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

The call to of_find_node_by_phandle returns a node pointer with refcount
incremented thus it must be explicitly decremented after the last
usage.

Detected by coccinelle with the following warnings:
./drivers/net/wireless/mediatek/mt76/eeprom.c:58:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
./drivers/net/wireless/mediatek/mt76/eeprom.c:61:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
./drivers/net/wireless/mediatek/mt76/eeprom.c:67:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
./drivers/net/wireless/mediatek/mt76/eeprom.c:70:2-8: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.
./drivers/net/wireless/mediatek/mt76/eeprom.c:72:1-7: ERROR: missing of_node_put; acquired a node pointer with refcount incremented on line 48, but without a corresponding object release within this function.

Signed-off-by: Wen Yang <wen.yang99@zte.com.cn>
Cc: Felix Fietkau <nbd@nbd.name>
Cc: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Matthias Brugger <matthias.bgg@gmail.com>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-mediatek@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/net/wireless/mediatek/mt76/eeprom.c | 24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index 530e559..a1529920d 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -54,22 +54,30 @@ mt76_get_of_eeprom(struct mt76_dev *dev, int len)
 		part = np->name;
 
 	mtd = get_mtd_device_nm(part);
-	if (IS_ERR(mtd))
-		return PTR_ERR(mtd);
+	if (IS_ERR(mtd)) {
+		ret =  PTR_ERR(mtd);
+		goto out_put_node;
+	}
 
-	if (size <= sizeof(*list))
-		return -EINVAL;
+	if (size <= sizeof(*list)) {
+		ret = -EINVAL;
+		goto out_put_node;
+	}
 
 	offset = be32_to_cpup(list);
 	ret = mtd_read(mtd, offset, len, &retlen, dev->eeprom.data);
 	put_mtd_device(mtd);
 	if (ret)
-		return ret;
+		goto out_put_node;
 
-	if (retlen < len)
-		return -EINVAL;
+	if (retlen < len) {
+		ret = -EINVAL;
+		goto out_put_node;
+	}
 
-	return 0;
+out_put_node:
+	of_node_put(np);
+	return ret;
 #else
 	return -ENOENT;
 #endif
-- 
2.9.5

