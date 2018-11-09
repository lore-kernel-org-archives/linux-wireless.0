Return-Path: <SRS0=rx5y=NU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BF5C43441
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C41A020827
	for <linux-wireless@archiver.kernel.org>; Fri,  9 Nov 2018 10:20:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C41A020827
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbeKIUAt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 9 Nov 2018 15:00:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728143AbeKIUAs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Nov 2018 15:00:48 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DEF8180516;
        Fri,  9 Nov 2018 10:20:52 +0000 (UTC)
Received: from localhost (unknown [10.43.2.84])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42343600CD;
        Fri,  9 Nov 2018 10:20:48 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 4/5] mt76x02: minor beaconing init changes
Date:   Fri,  9 Nov 2018 11:20:13 +0100
Message-Id: <1541758814-2046-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
References: <1541758814-2046-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Fri, 09 Nov 2018 10:20:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Disable BEACON timer during init and remove interrupt registers
initalization form generic conde since they are PCIe specific.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      |  7 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c    | 11 ++++-------
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c |  8 ++++++++
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 757816d2b1ab..d1d3c5706c4d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -129,6 +129,13 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
 	if (err < 0)
 		return err;
 
+	/* Beaconing: fire a pre-TBTT interrupt 8 ms before TBTT */
+	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
+		       8 << 4);
+	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
+		       MT_DFS_GP_INTERVAL);
+	mt76_wr(dev, MT_INT_TIMER_EN, 0);
+
 	if (mt76_chip(&dev->mt76) == 0x7610) {
 		u16 val;
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
index dbf9d89dd328..2bb79c6eb54b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -633,13 +633,10 @@ void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
 {
 	int i;
 
-	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
-	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
-		       8 << 4);
-	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
-		       MT_DFS_GP_INTERVAL);
-	mt76_wr(dev, MT_INT_TIMER_EN, 0);
-
+	mt76_clear(dev, MT_BEACON_TIME_CFG, (MT_BEACON_TIME_CFG_TIMER_EN |
+					     MT_BEACON_TIME_CFG_SYNC_MODE |
+					     MT_BEACON_TIME_CFG_TBTT_EN |
+					     MT_BEACON_TIME_CFG_BEACON_TX));
 	mt76_wr(dev, MT_BCN_BYPASS_MASK, 0xffff);
 
 	for (i = 0; i < 8; i++)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
index d2ef68c48ea5..89941aea8a88 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -121,6 +121,14 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 
 	mt76x02_mac_init_mbss(dev, macaddr);
 	mt76x02_init_beacon_config(dev);
+
+	/* Fire a pre-TBTT interrupt 8 ms before TBTT */
+	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_PRE_TBTT,
+		       8 << 4);
+	mt76_rmw_field(dev, MT_INT_TIMER_CFG, MT_INT_TIMER_CFG_GP_TIMER,
+		       MT_DFS_GP_INTERVAL);
+	mt76_wr(dev, MT_INT_TIMER_EN, 0);
+
 	if (!hard)
 		return 0;
 
-- 
1.9.3

