Return-Path: <SRS0=yJNj=RD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C72E7C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9D8942184A
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Feb 2019 08:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731910AbfB1IEe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Feb 2019 03:04:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56950 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730969AbfB1IEe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Feb 2019 03:04:34 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 54A14524F;
        Thu, 28 Feb 2019 08:04:34 +0000 (UTC)
Received: from localhost (unknown [10.40.205.30])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CF5CC5D732;
        Thu, 28 Feb 2019 08:04:31 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless@vger.kernel.org,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Subject: [RFC 10/12] mt76x02u: add mt76_release_buffered_frames
Date:   Thu, 28 Feb 2019 09:03:31 +0100
Message-Id: <1551341013-24519-11-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
References: <1551341013-24519-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.27]); Thu, 28 Feb 2019 08:04:34 +0000 (UTC)
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
 drivers/net/wireless/mediatek/mt76/mt76x0/usb.c     |  1 +
 .../net/wireless/mediatek/mt76/mt76x2/usb_main.c    |  1 +
 drivers/net/wireless/mediatek/mt76/usb.c            | 13 ++++++++-----
 3 files changed, 10 insertions(+), 5 deletions(-)

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
index 2ac78e4dc41a..653b8df29ca3 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76x2/usb_main.c
@@ -125,4 +125,5 @@ const struct ieee80211_ops mt76x2u_ops = {
 	.sw_scan_complete = mt76x02_sw_scan_complete,
 	.sta_rate_tbl_update = mt76x02_sta_rate_tbl_update,
 	.get_txpower = mt76_get_txpower,
+	.release_buffered_frames = mt76_release_buffered_frames,
 };
diff --git a/drivers/net/wireless/mediatek/mt76/usb.c b/drivers/net/wireless/mediatek/mt76/usb.c
index ae6ada370597..f181200c05cb 100644
--- a/drivers/net/wireless/mediatek/mt76/usb.c
+++ b/drivers/net/wireless/mediatek/mt76/usb.c
@@ -632,7 +632,7 @@ static void mt76u_tx_tasklet(unsigned long data)
 	bool wake;
 	int i;
 
-	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+	for (i = 0; i <= MT_TXQ_PSD; i++) {
 		q = &dev->q_tx[i];
 
 		spin_lock_bh(&q->lock);
@@ -785,11 +785,14 @@ static int mt76u_alloc_tx(struct mt76_dev *dev)
 	struct mt76_queue *q;
 	int i, j;
 
-	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+	for (i = 0; i <= MT_TXQ_PSD; i++) {
 		q = &dev->q_tx[i];
 		spin_lock_init(&q->lock);
 		INIT_LIST_HEAD(&q->swq);
-		q->hw_idx = mt76_ac_to_hwq(i);
+		if (i < IEEE80211_NUM_ACS)
+			q->hw_idx = mt76_ac_to_hwq(i);
+		else
+			q->hw_idx = 0;
 
 		q->entry = devm_kcalloc(dev->dev,
 					MT_NUM_TX_ENTRIES, sizeof(*q->entry),
@@ -825,7 +828,7 @@ static void mt76u_free_tx(struct mt76_dev *dev)
 	struct mt76_queue *q;
 	int i, j;
 
-	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+	for (i = 0; i <= MT_TXQ_PSD; i++) {
 		q = &dev->q_tx[i];
 		for (j = 0; j < q->ndesc; j++)
 			usb_free_urb(q->entry[j].ubuf.urb);
@@ -837,7 +840,7 @@ static void mt76u_stop_tx(struct mt76_dev *dev)
 	struct mt76_queue *q;
 	int i, j;
 
-	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+	for (i = 0; i <= MT_TXQ_PSD; i++) {
 		q = &dev->q_tx[i];
 		for (j = 0; j < q->ndesc; j++)
 			usb_kill_urb(q->entry[j].ubuf.urb);
-- 
2.20.1

