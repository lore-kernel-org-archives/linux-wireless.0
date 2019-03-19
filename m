Return-Path: <SRS0=Jk3u=RW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B910FC10F03
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95DA62085A
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Mar 2019 10:38:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727676AbfCSKi3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Mar 2019 06:38:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfCSKi3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Mar 2019 06:38:29 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0C051155E0;
        Tue, 19 Mar 2019 10:38:29 +0000 (UTC)
Received: from localhost (unknown [10.43.2.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A95304D717;
        Tue, 19 Mar 2019 10:38:28 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2 10/12] mt76x02u: add mt76_release_buffered_frames
Date:   Tue, 19 Mar 2019 11:37:45 +0100
Message-Id: <1552991867-5087-11-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
References: <1552991867-5087-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 19 Mar 2019 10:38:29 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Create software MT_TXQ_PSD queue for USB and map it to MT_TXQ_VO
since we do not have USB endpoint for PSD. This should make
mt76_release_buffered_frames() work by sending released frames
via MT_TXQ_VO.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c      | 1 +
 drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c | 1 +
 drivers/net/wireless/mediatek/mt76/usb.c             | 7 ++++++-
 3 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
index 0348a1b38d2d..b9b8a1dafbc9 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x0/usb.c
@@ -152,6 +152,7 @@ static void mt76x0u_stop(struct ieee80211_hw *hw)
 	.set_rts_threshold = mt76x02_set_rts_threshold,
 	.wake_tx_queue = mt76_wake_tx_queue,
 	.get_txpower = mt76_get_txpower,
+	.release_buffered_frames = mt76_release_buffered_frames,
 };
 
 static int mt76x0u_init_hardware(struct mt76x02_dev *dev)
diff --git a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
index 1e6856856536..46c6b3764f5a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -129,4 +129,5 @@ static void mt76x2u_stop(struct ieee80211_hw *hw)
 	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.get_txpower = mt76_get_txpower,
+	.release_buffered_frames = mt76_release_buffered_frames,
 };
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 27896a435d6c..7b62bd63d395 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -792,9 +792,14 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 	struct mt76_queue *q;
 	int i, j;
 
-	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+	for (i = 0; i <= MT_TXQ_PSD; i++) {
 		INIT_LIST_HEAD(&dev->q_tx[i].swq);
 
+		if (i >= IEEE80211_NUM_ACS) {
+			dev->q_tx[i].q = dev->q_tx[0].q;
+			continue;
+		}
+
 		q = devm_kzalloc(dev->dev, sizeof(*q), GFP_KERNEL);
 		if (!q)
 			return -ENOMEM;
-- 
1.9.3

