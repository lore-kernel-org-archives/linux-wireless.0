Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0E77C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 643F9214DC
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 10:25:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 643F9214DC
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727405AbeIZQhV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 12:37:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23426 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726602AbeIZQhV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 12:37:21 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1932A30026B0;
        Wed, 26 Sep 2018 10:25:06 +0000 (UTC)
Received: from localhost (ovpn-204-192.brq.redhat.com [10.40.204.192])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9AA0E6013B;
        Wed, 26 Sep 2018 10:25:05 +0000 (UTC)
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     linux-wireless@vger.kernel.org
Cc:     Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 4/5] rt2x00: use different txstatus timeouts when flushing
Date:   Wed, 26 Sep 2018 12:24:56 +0200
Message-Id: <1537957497-7790-5-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
References: <1537957497-7790-1-git-send-email-sgruszka@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.47]); Wed, 26 Sep 2018 10:25:06 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Use different tx status timeouts for normal operation and when flushing.
This increase timeout to 2s for normal operation as when there are bad
radio conditions and frames are reposted many times device can not provide
the status for quite long. With new timeout we can still get valid status
on such bad conditions.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 31 +++++++++++++++++---------
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |  1 +
 drivers/net/wireless/ralink/rt2x00/rt2x00mac.c |  4 ++++
 3 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 0c56c7dca55f..595cb9c90b81 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1137,36 +1137,47 @@ void rt2800_txdone(struct rt2x00_dev *rt2x00dev)
 }
 EXPORT_SYMBOL_GPL(rt2800_txdone);
 
-static inline bool rt2800_entry_txstatus_timeout(struct queue_entry *entry)
+static inline bool rt2800_entry_txstatus_timeout(struct rt2x00_dev *rt2x00dev,
+						 struct queue_entry *entry)
 {
-	bool tout;
+	bool ret;
+	unsigned long tout;
 
 	if (!test_bit(ENTRY_DATA_STATUS_PENDING, &entry->flags))
 		return false;
 
-	tout = time_after(jiffies, entry->last_action + msecs_to_jiffies(500));
-	if (unlikely(tout))
+	if (test_bit(DEVICE_STATE_FLUSHING, &rt2x00dev->flags))
+		tout = msecs_to_jiffies(100);
+	else
+		tout = msecs_to_jiffies(2000);
+
+	ret = time_after(jiffies, entry->last_action + tout);
+	if (unlikely(ret))
 		rt2x00_dbg(entry->queue->rt2x00dev,
 			   "TX status timeout for entry %d in queue %d\n",
 			   entry->entry_idx, entry->queue->qid);
-	return tout;
-
+	return ret;
 }
 
 bool rt2800_txstatus_timeout(struct rt2x00_dev *rt2x00dev)
 {
 	struct data_queue *queue;
 	struct queue_entry *entry;
+	unsigned long tout;
+
+	if (test_bit(DEVICE_STATE_FLUSHING, &rt2x00dev->flags))
+		tout = msecs_to_jiffies(50);
+	else
+		tout = msecs_to_jiffies(1000);
 
-	if (time_before(jiffies,
-			rt2x00dev->last_nostatus_check + msecs_to_jiffies(500)))
+	if (time_before(jiffies, rt2x00dev->last_nostatus_check + tout))
 		return false;
 
 	rt2x00dev->last_nostatus_check = jiffies;
 
 	tx_queue_for_each(rt2x00dev, queue) {
 		entry = rt2x00queue_get_entry(queue, Q_INDEX_DONE);
-		if (rt2800_entry_txstatus_timeout(entry))
+		if (rt2800_entry_txstatus_timeout(rt2x00dev, entry))
 			return true;
 	}
 
@@ -1195,7 +1206,7 @@ void rt2800_txdone_nostatus(struct rt2x00_dev *rt2x00dev)
 				break;
 
 			if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags) ||
-			    rt2800_entry_txstatus_timeout(entry))
+			    rt2800_entry_txstatus_timeout(rt2x00dev, entry))
 				rt2x00lib_txdone_noinfo(entry, TXDONE_FAILURE);
 			else
 				break;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index af062cda4a23..4b1744e9fb78 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -665,6 +665,7 @@ enum rt2x00_state_flags {
 	DEVICE_STATE_STARTED,
 	DEVICE_STATE_ENABLED_RADIO,
 	DEVICE_STATE_SCANNING,
+	DEVICE_STATE_FLUSHING,
 
 	/*
 	 * Driver configuration
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
index fa2fd64084ac..2825560e2424 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mac.c
@@ -720,8 +720,12 @@ void rt2x00mac_flush(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
 	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags))
 		return;
 
+	set_bit(DEVICE_STATE_FLUSHING, &rt2x00dev->flags);
+
 	tx_queue_for_each(rt2x00dev, queue)
 		rt2x00queue_flush_queue(queue, drop);
+
+	clear_bit(DEVICE_STATE_FLUSHING, &rt2x00dev->flags);
 }
 EXPORT_SYMBOL_GPL(rt2x00mac_flush);
 
-- 
2.7.5

