Return-Path: <SRS0=rH0W=QA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 425F4C282C3
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 15:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A02321872
	for <linux-wireless@archiver.kernel.org>; Thu, 24 Jan 2019 15:44:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbfAXPoZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 24 Jan 2019 10:44:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727649AbfAXPoZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 24 Jan 2019 10:44:25 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B0770C04AC54;
        Thu, 24 Jan 2019 15:44:24 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6A0EC7B523;
        Thu, 24 Jan 2019 15:44:20 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 4/7] mt76x02: minor beaconing init changes
Date:   Thu, 24 Jan 2019 16:44:06 +0100
Message-Id: <1548344649-10404-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
References: <1548344649-10404-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Thu, 24 Jan 2019 15:44:24 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Disable BEACON timer during init and remove interrupt registers
initialization form generic code since they are PCIe specific.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/pci.c      |  7 +++++++
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c    | 11 ++++-------
 drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c |  8 ++++++++
 3 files changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
index 1472c8699b29..cb68af5b7478 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/pci.c
@@ -128,6 +128,13 @@ static int mt76x0e_register_device(struct mt76x02_dev *dev)
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
index 02139dce4800..741ecd723b8e 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x02_util.c
@@ -667,13 +667,10 @@ void mt76x02_init_beacon_config(struct mt76x02_dev *dev)
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
index 0ccaa64d97ec..f86ff035fa7f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/pci_init.c
@@ -121,6 +121,14 @@ static int mt76x2_mac_reset(struct mt76x02_dev *dev, bool hard)
 
 	mt76x02_mac_setaddr(dev, macaddr);
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

