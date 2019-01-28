Return-Path: <SRS0=aQ0V=QE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BABAC282CD
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:22:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1E4E52148E
	for <linux-wireless@archiver.kernel.org>; Mon, 28 Jan 2019 12:22:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726829AbfA1MWI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 28 Jan 2019 07:22:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45924 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726611AbfA1MWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 28 Jan 2019 07:22:07 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D45563C2CF9;
        Mon, 28 Jan 2019 12:22:07 +0000 (UTC)
Received: from localhost (unknown [10.43.2.219])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7279B60BE0;
        Mon, 28 Jan 2019 12:22:07 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH v2 5/7] mt76x02: init beacon config for mt76x2u
Date:   Mon, 28 Jan 2019 13:21:46 +0100
Message-Id: <1548678108-9526-6-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
References: <1548678108-9526-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Mon, 28 Jan 2019 12:22:07 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Initialize beaconing also on mt76x2u.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
index 0be3784f44fb..3737e9fa8295 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_init.c
@@ -207,11 +207,7 @@ int mt76x2u_init_hardware(struct mt76x02_dev *dev)
 			mt76x02_mac_shared_key_setup(dev, i, k, NULL);
 	}
 
-	mt76_clear(dev, MT_BEACON_TIME_CFG,
-		   MT_BEACON_TIME_CFG_TIMER_EN |
-		   MT_BEACON_TIME_CFG_SYNC_MODE |
-		   MT_BEACON_TIME_CFG_TBTT_EN |
-		   MT_BEACON_TIME_CFG_BEACON_TX);
+	mt76x02_init_beacon_config(dev);
 
 	mt76_rmw(dev, MT_US_CYC_CFG, MT_US_CYC_CNT, 0x1e);
 	mt76_wr(dev, MT_TXOP_CTRL_CFG, 0x583f);
-- 
2.19.2

