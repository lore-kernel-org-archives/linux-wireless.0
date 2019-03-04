Return-Path: <SRS0=K+dv=RH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57EDAC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 09:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 31CBE20836
	for <linux-wireless@archiver.kernel.org>; Mon,  4 Mar 2019 09:49:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbfCDJtA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 4 Mar 2019 04:49:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57450 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726455AbfCDJtA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 4 Mar 2019 04:49:00 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 0BB4E307D963;
        Mon,  4 Mar 2019 09:49:00 +0000 (UTC)
Received: from localhost (unknown [10.40.205.1])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 984761018A2B;
        Mon,  4 Mar 2019 09:48:59 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Felix Fietkau <nbd@nbd.name>, linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [PATCH 09/11] mt76x02u: add mt76_release_buffered_frames
Date:   Mon,  4 Mar 2019 10:48:14 +0100
Message-Id: <1551692896-7062-10-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
References: <1551692896-7062-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Mon, 04 Mar 2019 09:49:00 +0000 (UTC)
To:     unlisted-recipients:; (no To-header on input)
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
@@ -152,6 +152,7 @@ static const struct ieee80211_ops mt76x0u_ops = {
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
@@ -129,4 +129,5 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.get_txpower = mt76_get_txpower,
+	.release_buffered_frames = mt76_release_buffered_frames,
 };
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index 65b0c244307f..c5f3b2cdd9b1 100644
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
2.20.1

