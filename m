Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC6E0ECE560
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B0BC4214DC
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0BC4214DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727390AbeIZQhU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:37:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35386 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbeIZQhU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:37:20 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 745E79B32F;
        Wed, 26 Sep 2018 10:25:04 +0000 (UTC)
Received: from localhost (ovpn-204-192.brq.redhat.com [10.40.204.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F34F76B65F;
        Wed, 26 Sep 2018 10:25:03 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 3/5] rt2x00: do not check for txstatus timeout every time on tasklet
Date:   Wed, 26 Sep 2018 12:24:55 +0200
Message-Id: <1537957497-7790-4-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
References: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.39]); Wed, 26 Sep 2018 10:25:04 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Do not check for tx status timeout everytime we perform txstatus tasklet.
Perform check once per half a second.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c   | 7 +++++++
 drivers/net/wireless/ralink/rt2x00/rt2800mmio.c  | 3 ++-
 drivers/net/wireless/ralink/rt2x00/rt2x00.h      | 2 ++
 drivers/net/wireless/ralink/rt2x00/rt2x00queue.c | 1 +
 4 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 9f2835729016..0c56c7dca55f 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1158,11 +1158,18 @@ bool rt2800_txstatus_timeout(struct rt2x00_dev *rt2x00dev)
 	struct data_queue *queue;
 	struct queue_entry *entry;
 
+	if (time_before(jiffies,
+			rt2x00dev->last_nostatus_check + msecs_to_jiffies(500)))
+		return false;
+
+	rt2x00dev->last_nostatus_check = jiffies;
+
 	tx_queue_for_each(rt2x00dev, queue) {
 		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
 		if (rt2800_entry_txstatus_timeout(entry))
 			return true;
 	}
+
 	return false;
 }
 EXPORT_SYMBOL_GPL(rt2800_txstatus_timeout);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
index aa8449a5e8fe..d0426314c2df 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800mmio.c
@@ -197,7 +197,8 @@ void rt2800mmio_txstatus_tasklet(unsigned long data)
 
 	rt2800_txdone(rt2x00dev);
 
-	rt2800_txdone_nostatus(rt2x00dev);
+	if (rt2800_txstatus_timeout(rt2x00dev))
+		rt2800_txdone_nostatus(rt2x00dev);
 
 	if (test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
 		rt2800mmio_enable_interrupt(rt2x00dev,
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index a279a4363bc1..af062cda4a23 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -980,6 +980,8 @@ struct rt2x00_dev {
 	 */
 	DECLARE_KFIFO_PTR(txstatus_fifo, u32);
 
+	unsigned long last_nostatus_check;
+
 	/*
 	 * Timer to ensure tx status reports are read (rt2800usb).
 	 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
index 6e8beb7ea350..92ddc19e7bf7 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00queue.c
@@ -1039,6 +1039,7 @@ void rt2x00queue_start_queues(struct rt2x00_dev *rt2x00dev)
 	 */
 	tx_queue_for_each(rt2x00dev, queue)
 		rt2x00queue_start_queue(queue);
+	rt2x00dev->last_nostatus_check = jiffies;
 
 	rt2x00queue_start_queue(rt2x00dev->rx);
 }
-- 
2.7.5

