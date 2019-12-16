Return-Path: <SRS0=mHGl=2G=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE120C43603
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Dec 2019 13:20:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C035320684
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Dec 2019 13:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1576502410;
	bh=zE/2x70Wdpb8y0YeflXFDaaVLOt4BBxgfSeGFFsop7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:List-ID:From;
	b=SWIuuUhAYXu6NbsX4/t8Y28VNdCZP0ggkxXfjT7oRalbwly4ga3Fk6OFcF8xax2x/
	 8LAidPCvAqFT9zFhT+0xG53pXRRA/yRPolqUR6Usq/NKwmMpNJsTlDfWZjsn29iYB0
	 Moo4ZGoVoQW7jS/PNqmJAn3jNyjydjlmoX+TO3Uk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727875AbfLPNUK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 16 Dec 2019 08:20:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:41246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727653AbfLPNUK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Dec 2019 08:20:10 -0500
Received: from localhost.localdomain.com (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D59920717;
        Mon, 16 Dec 2019 13:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576502409;
        bh=zE/2x70Wdpb8y0YeflXFDaaVLOt4BBxgfSeGFFsop7c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eA7+c9K0/QNBD8qRFar7b/KrL+4YayJG/WBF9dS9Tg5aSMk8FXZyy7GYTplDsOdbV
         0Ie7B67e1o/joFtBU1d3x3q0T2rvSvNyEfK2v/ZCzS9zXT1HUqOOGuHLgCSFn1n7Dt
         thNHwYu7uuObalJy+P4f1lMa90xwLCaqBsRJDaVI=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     nbd@nbd.name
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: [PATCH v2 2/2] mt76: mt7603: simplify led reg definitions
Date:   Mon, 16 Dec 2019 14:19:59 +0100
Message-Id: <d03382f4bba0492093100e0acb7bcb849d8be530.1576502217.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1576502217.git.lorenzo@kernel.org>
References: <cover.1576502217.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Rely on FIELD_PREP macro for led register definitions and
remove open coding

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/init.c |  6 +++---
 drivers/net/wireless/mediatek/mt76/mt7603/regs.h | 15 +++------------
 2 files changed, 6 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/init.c b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
index af346d479258..32fdb81b2bb0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/init.c
@@ -363,9 +363,9 @@ static void mt7603_led_set_config(struct mt76_dev *mt76, u8 delay_on,
 					      mt76);
 	u32 val, addr;
 
-	val = MT_LED_STATUS_DURATION(0xffff) |
-	      MT_LED_STATUS_OFF(delay_off) |
-	      MT_LED_STATUS_ON(delay_on);
+	val = FIELD_PREP(MT_LED_STATUS_DURATION, 0xffff) |
+	      FIELD_PREP(MT_LED_STATUS_OFF, delay_off) |
+	      FIELD_PREP(MT_LED_STATUS_ON, delay_on);
 
 	addr = mt7603_reg_map(dev, MT_LED_STATUS_0(mt76->led_pin));
 	mt76_wr(dev, addr, val);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/regs.h b/drivers/net/wireless/mediatek/mt76/mt7603/regs.h
index 6e23ed3dfdff..6741e6907194 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/regs.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/regs.h
@@ -585,18 +585,9 @@ enum {
 
 #define MT_LED_STATUS_0(_n)		MT_LED_PHYS(0x10 + ((_n) * 8))
 #define MT_LED_STATUS_1(_n)		MT_LED_PHYS(0x14 + ((_n) * 8))
-#define MT_LED_STATUS_OFF_MASK		GENMASK(31, 24)
-#define MT_LED_STATUS_OFF(_v)		(((_v) << \
-					  __ffs(MT_LED_STATUS_OFF_MASK)) & \
-					 MT_LED_STATUS_OFF_MASK)
-#define MT_LED_STATUS_ON_MASK		GENMASK(23, 16)
-#define MT_LED_STATUS_ON(_v)		(((_v) << \
-					  __ffs(MT_LED_STATUS_ON_MASK)) & \
-					 MT_LED_STATUS_ON_MASK)
-#define MT_LED_STATUS_DURATION_MASK	GENMASK(15, 0)
-#define MT_LED_STATUS_DURATION(_v)	(((_v) << \
-					  __ffs(MT_LED_STATUS_DURATION_MASK)) &\
-					 MT_LED_STATUS_DURATION_MASK)
+#define MT_LED_STATUS_OFF		GENMASK(31, 24)
+#define MT_LED_STATUS_ON		GENMASK(23, 16)
+#define MT_LED_STATUS_DURATION		GENMASK(15, 0)
 
 #define MT_CLIENT_BASE_PHYS_ADDR	0x800c0000
 
-- 
2.21.0

