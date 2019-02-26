Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACFD1C43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FCA32147C
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 09:29:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="IJT8f0RH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbfBZJ3y (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 04:29:54 -0500
Received: from nbd.name ([46.4.11.11]:60902 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727580AbfBZJ3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 04:29:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=LrmP3/b/IIFKXDTUB811e1AZ5fks9QEK7v1Qc5WGRYo=; b=IJT8f0RHMWiwPg2Nvn+/v2ygvI
        VZ/GlowW41e7qBpVZqahSBum/y8COwLZrD4AUXYVLJZCH8+qg/X2aEGCPyjutf5RMZbTXcV8hfcQl
        DEJof5E3sfnJnCxqh3pKv6VXog0jp2sfltbsUp5/CXErWzZcTOWBffJ5l5tixqPSpIc8=;
Received: by maeck.lan (Postfix, from userid 501)
        id BE3535047CF9; Tue, 26 Feb 2019 10:29:45 +0100 (CET)
From:   Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Subject: [PATCH 2/8] mt76: mt76x02: fix beacon timer drift adjustment
Date:   Tue, 26 Feb 2019 10:29:39 +0100
Message-Id: <20190226092945.54738-2-nbd@nbd.name>
X-Mailer: git-send-email 2.17.0
In-Reply-To: <20190226092945.54738-1-nbd@nbd.name>
References: <20190226092945.54738-1-nbd@nbd.name>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Check the count before incrementing it to match vendor code behavior.
This defers the adjustment by one more tick, which should improve accuracy

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
index 374bc9d91f12..f0198eea2bb8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
@@ -79,24 +79,24 @@ mt76x02_resync_beacon_timer(struct mt76x02_dev *dev)
 	 * Beacon timer drifts by 1us every tick, the timer is configured
 	 * in 1/16 TU (64us) units.
 	 */
-	if (dev->tbtt_count < 62)
+	if (dev->tbtt_count < 63)
 		return;
 
-	if (dev->tbtt_count >= 64) {
-		dev->tbtt_count = 0;
-		return;
-	}
-
 	/*
 	 * The updated beacon interval takes effect after two TBTT, because
 	 * at this point the original interval has already been loaded into
 	 * the next TBTT_TIMER value
 	 */
-	if (dev->tbtt_count == 62)
+	if (dev->tbtt_count == 63)
 		timer_val -= 1;
 
 	mt76_rmw_field(dev, MT_BEACON_TIME_CFG,
 		       MT_BEACON_TIME_CFG_INTVAL, timer_val);
+
+	if (dev->tbtt_count >= 64) {
+		dev->tbtt_count = 0;
+		return;
+	}
 }
 
 static void mt76x02_pre_tbtt_tasklet(unsigned long arg)
-- 
2.17.0

