Return-Path: <SRS0=Ta2d=QQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F1C3C282C4
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3692E218D2
	for <linux-wireless@archiver.kernel.org>; Sat,  9 Feb 2019 11:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfBILIx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 9 Feb 2019 06:08:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32885 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbfBILIw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 9 Feb 2019 06:08:52 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AC2B07F6A7;
        Sat,  9 Feb 2019 11:08:52 +0000 (UTC)
Received: from localhost (ovpn-204-22.brq.redhat.com [10.40.204.22])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2464E60C55;
        Sat,  9 Feb 2019 11:08:51 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Subject: [RFC/RFT 6/8] rt2x00: remove last_nostatus_check
Date:   Sat,  9 Feb 2019 12:08:36 +0100
Message-Id: <1549710518-15650-7-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1549710518-15650-1-git-send-email-sgruszka@redhat.com>
References: <1549710518-15650-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Sat, 09 Feb 2019 11:08:52 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

We do not any longer check txstatus timeout from tasklet, so do not need
this optimization.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c   | 9 ---------
 drivers/net/wireless/ralink/rt2x00/rt2x00.h      | 2 --
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 1 -
 3 files changed, 12 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 745f344521ee..6fdf8b58d25c 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1164,15 +1164,6 @@ bool rt2800_txstatus_timeout(struct rt2x00_dev *rt2x00dev)
 	struct data_queue *queue;
 	struct queue_entry *entry;
 
-	if (!test_bit(DEVICE_STATE_FLUSHING, &rt2x00dev->flags)) {
-		unsigned long tout = msecs_to_jiffies(1000);
-
-		if (time_before(jiffies, rt2x00dev->last_nostatus_check + tout))
-			return false;
-	}
-
-	rt2x00dev->last_nostatus_check = jiffies;
-
 	tx_queue_for_each(rt2x00dev, queue) {
 		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 		if (rt2800_entry_txstatus_timeout(rt2x00dev, entry))
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index 88e0dc803227..247b0248b828 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -986,8 +986,6 @@ struct rt2x00_dev {
 	 */
 	DECLARE_KFIFO_PTR(txstatus_fifo, u32);
 
-	unsigned long last_nostatus_check;
-
 	/*
 	 * Timer to ensure tx status reports are read (rt2800usb).
 	 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index 92ddc19e7bf7..6e8beb7ea350 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -1039,7 +1039,6 @@ void rt2x00queue_start_queues(struct rt2x00_dev *rt2x00dev)
 	 */
 	tx_queue_for_each(rt2x00dev, queue)
 		rt2x00queue_start_queue(queue);
-	rt2x00dev->last_nostatus_check = jiffies;
 
 	rt2x00queue_start_queue(rt2x00dev->rx);
 }
-- 
2.7.5

