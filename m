Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 121A8C10F0B
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA1B32147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="Xl48y7Ns"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfBZJ3s (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:29:48 -0500
Received: from nbd.name ([46.4.11.11]:60892 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727488AbfBZJ3r (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:29:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=W4+ESE+vTlLSmLsRs7FMkAuHy0dJ9guD1OWBFqtLego=; b=Xl48y7NsGHq4hb5r1fW7ElVr5U
        3UcjSfARvETeK+sMf4DqXoKC/aj4TuZSsbHzXaIibW0LJFqNk05uAV7tQnXX8HSMCU8poCeaZnjiO
        2jxg7qb2vPVY/dXXzvS0B7H6HQWNSq1u8LfXUGpB1tyWkqHUNIoLMykYw4x3/H3ytb9c=;
Received: by maeck.lan (Postfix, from userid 501)
        id BD84D5047CF7; Tue, 26 Feb 2019 10:29:45 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 8/8] mt76: mt76x02: set MT_TXOP_HLDR_TX40M_BLK_EN for mt76x2
Date:   Tue, 26 Feb 2019 10:29:45 +0100
Message-Id: <20190226092945.54738-8-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190226092945.54738-1-nbd@nbd.name>
References: <20190226092945.54738-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

It needs to be always enabled for 76x2 and conditionally enabled/disabled
for 76x0. Since mt76x2_mac_stop clears this bit, ensure that it is enabled
in mt76x02_edcca_init

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
index 82b178fa83bb..91ff6598eccf 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mac.c
@@ -905,14 +905,14 @@ void mt76x02_edcca_init(struct mt76x02_dev *dev, bool enable)
 		mt76_set(dev, MT_TXOP_CTRL_CFG, MT_TXOP_ED_CCA_EN);
 		mt76_rmw(dev, MT_BBP(AGC, 2), GENMASK(15, 0),
 			 ed_th << 8 | ed_th);
-		if (!is_mt76x2(dev))
-			mt76_set(dev, MT_TXOP_HLDR_ET,
-				 MT_TXOP_HLDR_TX40M_BLK_EN);
+		mt76_set(dev, MT_TXOP_HLDR_ET, MT_TXOP_HLDR_TX40M_BLK_EN);
 	} else {
 		mt76_set(dev, MT_TX_LINK_CFG, MT_TX_CFACK_EN);
 		mt76_clear(dev, MT_TXOP_CTRL_CFG, MT_TXOP_ED_CCA_EN);
 		if (is_mt76x2(dev)) {
 			mt76_wr(dev, MT_BBP(AGC, 2), 0x00007070);
+			mt76_set(dev, MT_TXOP_HLDR_ET,
+				 MT_TXOP_HLDR_TX40M_BLK_EN);
 		} else {
 			mt76_wr(dev, MT_BBP(AGC, 2), 0x003a6464);
 			mt76_clear(dev, MT_TXOP_HLDR_ET,
-- 
2.17.0

