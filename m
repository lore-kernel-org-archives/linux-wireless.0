Return-Path: <SRS0=OIIa=QG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D73EC282D7
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:02:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4FAAC207E0
	for <linux-wireless@archiver.kernel.org>; Wed, 30 Jan 2019 16:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731799AbfA3QC2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 30 Jan 2019 11:02:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731234AbfA3QC2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Jan 2019 11:02:28 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6CF0CE3DFC;
        Wed, 30 Jan 2019 16:02:28 +0000 (UTC)
Received: from localhost (ovpn-204-66.brq.redhat.com [10.40.204.66])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D912E452C;
        Wed, 30 Jan 2019 16:02:27 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        linux-wireless@vger.kernel.org
Subject: [PATCH v3 4/7] mt76x02: minor beaconing init changes
Date:   Wed, 30 Jan 2019 17:02:16 +0100
Message-Id: <1548864139-27729-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548864139-27729-1-git-send-email-sgruszka@redhat.com>
References: <1548864139-27729-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.38]); Wed, 30 Jan 2019 16:02:28 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Disable BEACON timer during init and configure interrupt registers
only for mmio devices.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v3: do not move code to individual drivers, just mask it in common code

 .../net/wireless/mediatek/mt76/mt76x02_util.c  | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index 1ecd4ef83c82..4bc0520da1c6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -670,13 +670,19 @@ void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
 {
 	int i;
 
-	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
-	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
-		       8 << 4);
-	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
-		       MT_DFS_GP_INTERVAL);
-	mt76_wr(dev, MT_INT_TIMER_EN, 0);
+	if (mt76_is_mmio(dev)) {
+		/* Fire a pre-TBTT interrupt 8 ms before TBTT */
+		mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
+			       8 << 4);
+		mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
+			       MT_DFS_GP_INTERVAL);
+		mt76_wr(dev, MT_INT_TIMER_EN, 0);
+	}
 
+	mt76_clear(dev, MT_BEACON_TIME_CFG, (MT_BEACON_TIME_CFG_TIMER_EN |
+					     MT_BEACON_TIME_CFG_SYNC_MODE |
+					     MT_BEACON_TIME_CFG_TBTT_EN |
+					     MT_BEACON_TIME_CFG_BEACON_TX));
 	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xffff);
 
 	for (i = 0; i < 8; i++)
-- 
2.19.2

