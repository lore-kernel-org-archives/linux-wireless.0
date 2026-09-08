Received: from mta0.migadu.com (out-88.mta0.migadu.com [91.218.175.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87F2545D82
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 13:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.88
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788874220; cv=none; b=GzwoHnghFSsl7u1GwnBofNd/cMUrn6ZdVyPeoylhRrvOhdygAkQd6FjJlGXlkXZK6ehQHYLlxnw8X06eUPFgPvA5jy+v9W+kmho9UAebtvH8nsudWyk6EHMBbDZqs0nTNg6xD8/f7WvgImlcArqwihGTp5uZJK4h75EondRGjUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788874220; c=relaxed/simple;
	bh=rnHNk0j8mlYlKX+OonsPF2QruEr0sMqZuyE7cansdcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8AUKs/5dxBAl5YFEDGotoX/vG1HFY7dVHvidVZCZooKHjBrEjeYnbROOLM6rjQmGDKPA1p4AVlqG27LVpOymoJbQ70CmM5h/S3X8ToSKMunbAmk+xFtt+Dey8lS5G1LE+VXJUVkXtwZdQeEwL1UL7HWULG4+1OHCT3iZo82LBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=CP+coQyh; arc=none smtp.client-ip=91.218.175.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="CP+coQyh"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=rnHNk0j8mlYlKX+OonsPF2QruEr0sMqZuyE7cansdcs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788874196; v=1; x=1789478996;
 b=CP+coQyhEiLq1qG2C9Ti6cqH3d0PseR3ADAOE4h6AZS++70zDwdlFKwbwq6BbgfUXYQGTbOz
 MgXDCGWTHijgIdvfRUK5AXHjs73tROZOMlJ7HL2+epWDhgFMbtXdpe70K4MOxDVLyiW/wM9xaya
 9Z+iQWijHoJ+RmsdW811sJR4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 5f57bb81d17e213f;
	Tue, 08 Sep 2026 13:29:56 +0000
X-Mizu-Trace-ID: 5f57bb81d17e213f
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v10 6/6] wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
Date: Tue,  8 Sep 2026 15:29:26 +0200
Message-ID: <20260908132926.68976-7-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260908132926.68976-1-luka.gejak@linux.dev>
References: <20260908132926.68976-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Luka Gejak <luka.gejak@linux.dev>

Two problems show up on RTL8723BS uplink. The per-AC software FIFO is
unbounded, so mac80211 keeps handing frames down until latency collapses
under load. And when a transfer cannot be completed the queue is simply
abandoned for that pass, which stalls the AC until something else kicks
the worker.

Stop the mac80211 queue once a data AC fills past a high watermark and
wake it from the drain path when it falls back to a low one. Both sides
take the TX queue lock across the length check and the flag update, the
way rtw_pci_tx_write() and rtw_pci_tx_isr() use irq_lock. Without it the
producer could stop a queue on a length the drain path had already
emptied, having seen the flag still clear and so skipped the wake, and
the AC would have stayed stopped with nothing left to wake it.

Convert the TX work item to a delayed work and re-arm it when a transfer
fails for a reason that can clear on its own, so it is retried rather
than the AC abandoned, and cancel the work on teardown.

Retrying matters once the queue can be stopped. A stopped queue is
handed no further frames, so nothing else would kick the worker, and the
AC would stay stopped for good with the link still up and receive
unaffected. The retried case, a transmit page or output queue shortage,
is also the one that fails silently; the rest are logged where they
happen, so they are visible rather than an unexplained hang, and they
keep the existing behaviour rather than being retried indefinitely.

Measured on RTL8723BS hardware, uplink goes from 11.9 Mbit/s with 204
TCP retransmits to 20.1 Mbit/s with 2.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
---

Notes:
    Changes in v10:
      - -ENOMEM is no longer retried. With the padding moved out of patch 4
        nothing on this path can return it, so the case was dead. If the
        padding fix lands in rtw_sdio_write_port() it becomes reachable
        again, for every chip, and this has to come back with it.
      - trimmed the comments here too.
    Changes in v9: none, beyond recording your Acked-by.
    Changes in v8:
      - the stop and the wake take the TX queue lock with
        guard(spinlock_irqsave) across the length check and the flag update,
        following pci.c, which holds irq_lock on both sides and needs no
        barrier because of it. The smp_mb() pair, the READ_ONCE and
        WRITE_ONCE accessors and the re-check that undid a stop all went
        with it.
      - q_map is read later, just before the call that uses it. It cannot move
        past rtw_sdio_indicate_tx_status(), which consumes the skb, so that is
        as far down as it goes.
    Changes in v7:
      - the mac80211 queue index is read before skb_queue_tail() publishes
        the skb to the TX worker, which may process and free it immediately;
        reading it afterwards was a use after free.
      - the stop path re-checks the FIFO after setting the stopped flag and
        undoes the stop if the worker drained it meanwhile. In that window
        the drain side still saw the flag clear, so neither side would have
        woken the queue and the AC stayed stopped for good. The flag is
        accessed with READ_ONCE/WRITE_ONCE and the re-check is ordered
        against the drain path with a barrier pair.
    
    Changes in v6:
      - dropped rtw_sdio_reschedule_tx_work(). It was a thin wrapper around
        queue_delayed_work() and hid the kernel API for no gain.
      - the reschedule conditions moved into rtw_sdio_8723bs_reschedule_tx(),
        so rtw_sdio_tx_handler() no longer explains any chip specific
        condition in the common flow.
      - dropped the unconditional break on a failed transfer. v4 and v5 had
        it, and it quietly changed the other SDIO parts: upstream requeues
        the frame and the loop retries, and breaking gave up after the first
        failure. The two errors this chip needs to retry are handled in the
        helper above, so the rest can keep the existing behaviour and the
        other parts are untouched again.
    Changes in v5:
      - the back-pressure and wake conditions moved into
        rtw_sdio_8723bs_stop_tx_queue() and _wake_tx_queue().
      - rtw_sdio_process_tx_queue() returns 0 on success and 1 for the empty
        queue case, rather than the other way round.
      - queue_stopped[] renamed to tx_queue_stopped[].
      - fixed a transmit stall: the work item was only re-armed on a page
        shortage, so on any other failure a stopped access category would
        stay stopped for good. It now also re-arms on a failed skb
        expansion, which with the page shortage covers both failures that
        produce no log message.
      - RTW_SDIO_TX_RETRY_DELAY is left as msecs_to_jiffies(1): it does not
        become 0 for HZ < 1000, since msecs_to_jiffies() rounds up.

 drivers/net/wireless/realtek/rtw88/sdio.c | 136 ++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/sdio.h |   3 +-
 2 files changed, 128 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 73f81a287a90..b594bd5b75a6 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -22,6 +22,11 @@
 #define RTW_SDIO_INDIRECT_RW_RETRIES			50
 #define RTW_SDIO_OQT_TIMEOUT_MS				1000
 
+/* Bounds the queueing latency of the otherwise unbounded per-AC software FIFO. */
+#define RTW_SDIO_TX_FIFO_HIWATER			16
+#define RTW_SDIO_TX_FIFO_LOWATER			8
+#define RTW_SDIO_TX_RETRY_DELAY			msecs_to_jiffies(1)
+
 static bool rtw_sdio_is_bus_addr(u32 addr)
 {
 	return !!(addr & RTW_SDIO_BUS_MSK);
@@ -1121,7 +1126,11 @@ static void rtw_sdio_tx_kick_off(struct rtw_dev *rtwdev)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 
-	queue_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work);
+	/*
+	 * A retry may already be pending with a delay; re-arm it so a newly
+	 * queued frame is not held back by it.
+	 */
+	mod_delayed_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work, 0);
 }
 
 static void rtw_sdio_link_ps(struct rtw_dev *rtwdev, bool enter)
@@ -1230,12 +1239,61 @@ static int rtw_sdio_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 	return rtw_sdio_write_data(rtwdev, &pkt_info, skb, RTW_TX_QUEUE_H2C);
 }
 
+/*
+ * Both this and the wake below hold the TX queue lock across the length check
+ * and the flag update, so a queue is only ever stopped while it really is
+ * above the watermark, and the drain path always sees the flag the producer
+ * set.
+ */
+static void rtw_sdio_8723bs_stop_tx_queue(struct rtw_dev *rtwdev,
+					  enum rtw_tx_queue_type queue,
+					  u16 q_map)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	if (!rtw_is_8723bs(rtwdev) || queue >= RTW_TX_QUEUE_BCN)
+		return;
+
+	guard(spinlock_irqsave)(&rtwsdio->tx_queue[queue].lock);
+
+	if (rtwsdio->tx_queue_stopped[queue])
+		return;
+
+	if (skb_queue_len(&rtwsdio->tx_queue[queue]) < RTW_SDIO_TX_FIFO_HIWATER)
+		return;
+
+	rtwsdio->tx_queue_stopped[queue] = true;
+	ieee80211_stop_queue(rtwdev->hw, q_map);
+}
+
+static void rtw_sdio_8723bs_wake_tx_queue(struct rtw_dev *rtwdev,
+					  enum rtw_tx_queue_type queue,
+					  u16 q_map)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	if (!rtw_is_8723bs(rtwdev) || queue >= RTW_TX_QUEUE_BCN)
+		return;
+
+	guard(spinlock_irqsave)(&rtwsdio->tx_queue[queue].lock);
+
+	if (!rtwsdio->tx_queue_stopped[queue])
+		return;
+
+	if (skb_queue_len(&rtwsdio->tx_queue[queue]) > RTW_SDIO_TX_FIFO_LOWATER)
+		return;
+
+	rtwsdio->tx_queue_stopped[queue] = false;
+	ieee80211_wake_queue(rtwdev->hw, q_map);
+}
+
 static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
 			     struct rtw_tx_pkt_info *pkt_info,
 			     struct sk_buff *skb)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	enum rtw_tx_queue_type queue = rtw_tx_queue_mapping(skb);
+	u16 q_map = skb_get_queue_mapping(skb);
 	struct rtw_sdio_tx_data *tx_data;
 
 	rtw_sdio_tx_skb_prepare(rtwdev, pkt_info, skb, queue);
@@ -1243,8 +1301,11 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
 	tx_data = rtw_sdio_get_tx_data(skb);
 	tx_data->sn = pkt_info->sn;
 
+	/* The TX worker may already have freed the skb, so do not touch it. */
 	skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
 
+	rtw_sdio_8723bs_stop_tx_queue(rtwdev, queue, q_map);
+
 	return 0;
 }
 
@@ -1547,33 +1608,79 @@ static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
 	ieee80211_tx_status_irqsafe(hw, skb);
 }
 
-static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
-				      enum rtw_tx_queue_type queue)
+/*
+ * Send one frame from @queue. Returns 0 when a frame was written, 1 when the
+ * queue was empty and a negative errno when the write failed, in which case
+ * the frame is put back at the head of the queue.
+ */
+static int rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
+				     enum rtw_tx_queue_type queue)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	struct sk_buff *skb;
+	u16 q_map;
 	int ret;
 
 	skb = skb_dequeue(&rtwsdio->tx_queue[queue]);
 	if (!skb)
-		return;
+		return 1;
 
 	ret = rtw_sdio_write_port(rtwdev, skb, queue);
 	if (ret) {
 		skb_queue_head(&rtwsdio->tx_queue[queue], skb);
-		return;
+		return ret;
 	}
 
+	/* rtw_sdio_indicate_tx_status() consumes the skb, so read this first */
+	q_map = skb_get_queue_mapping(skb);
+
 	rtw_sdio_indicate_tx_status(rtwdev, skb);
+
+	rtw_sdio_8723bs_wake_tx_queue(rtwdev, queue, q_map);
+
+	return 0;
+}
+
+/*
+ * A page or output queue shortage is transient and leaves the frame queued, so
+ * come back for it shortly. That matters once the mac80211 queue can be
+ * stopped: a stopped queue is handed no further frames, so nothing else would
+ * kick this work item and the access category would stay stopped for good.
+ * The remaining errors are logged where they happen and are not retried.
+ *
+ * After a management frame, restart from the highest priority queue so the
+ * join sequence is not held up behind a data backlog.
+ */
+static bool rtw_sdio_8723bs_reschedule_tx(struct rtw_dev *rtwdev,
+					  struct rtw_sdio_work_data *work_data,
+					  enum rtw_tx_queue_type queue, int ret)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	unsigned long delay;
+
+	if (!rtw_is_8723bs(rtwdev))
+		return false;
+
+	if (ret == -EBUSY)
+		delay = RTW_SDIO_TX_RETRY_DELAY;
+	else if (ret == 0 && queue == RTW_TX_QUEUE_MGMT)
+		delay = 0;
+	else
+		return false;
+
+	queue_delayed_work(rtwsdio->txwq, &work_data->work, delay);
+
+	return true;
 }
 
 static void rtw_sdio_tx_handler(struct work_struct *work)
 {
 	struct rtw_sdio_work_data *work_data =
-		container_of(work, struct rtw_sdio_work_data, work);
+		container_of(to_delayed_work(work), struct rtw_sdio_work_data,
+			     work);
 	struct rtw_sdio *rtwsdio;
 	struct rtw_dev *rtwdev;
-	int limit, queue;
+	int limit, queue, ret;
 
 	rtwdev = work_data->rtwdev;
 	rtwsdio = (struct rtw_sdio *)rtwdev->priv;
@@ -1583,7 +1690,13 @@ static void rtw_sdio_tx_handler(struct work_struct *work)
 
 	for (queue = RTK_MAX_TX_QUEUE_NUM - 1; queue >= 0; queue--) {
 		for (limit = 0; limit < 1000; limit++) {
-			rtw_sdio_process_tx_queue(rtwdev, queue);
+			ret = rtw_sdio_process_tx_queue(rtwdev, queue);
+			if (ret > 0)
+				break;
+
+			if (rtw_sdio_8723bs_reschedule_tx(rtwdev, work_data,
+							  queue, ret))
+				return;
 
 			if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
 				break;
@@ -1612,14 +1725,16 @@ static int rtw_sdio_init_tx(struct rtw_dev *rtwdev)
 
 	mutex_init(&rtwsdio->tx_credit_lock);
 
-	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++)
+	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++) {
 		skb_queue_head_init(&rtwsdio->tx_queue[i]);
+		rtwsdio->tx_queue_stopped[i] = false;
+	}
 	rtwsdio->tx_handler_data = kmalloc_obj(*rtwsdio->tx_handler_data);
 	if (!rtwsdio->tx_handler_data)
 		goto err_destroy_wq;
 
 	rtwsdio->tx_handler_data->rtwdev = rtwdev;
-	INIT_WORK(&rtwsdio->tx_handler_data->work, rtw_sdio_tx_handler);
+	INIT_DELAYED_WORK(&rtwsdio->tx_handler_data->work, rtw_sdio_tx_handler);
 
 	return 0;
 
@@ -1634,6 +1749,7 @@ static void rtw_sdio_deinit_tx(struct rtw_dev *rtwdev)
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	int i;
 
+	cancel_delayed_work_sync(&rtwsdio->tx_handler_data->work);
 	destroy_workqueue(rtwsdio->txwq);
 	kfree(rtwsdio->tx_handler_data);
 
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 634c0b1339bb..6e7e6009744b 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.h
+++ b/drivers/net/wireless/realtek/rtw88/sdio.h
@@ -156,7 +156,7 @@ struct rtw_sdio_tx_data {
 };
 
 struct rtw_sdio_work_data {
-	struct work_struct work;
+	struct delayed_work work;
 	struct rtw_dev *rtwdev;
 };
 
@@ -172,6 +172,7 @@ struct rtw_sdio {
 	struct workqueue_struct *txwq;
 	struct rtw_sdio_work_data *tx_handler_data;
 	struct sk_buff_head tx_queue[RTK_MAX_TX_QUEUE_NUM];
+	bool tx_queue_stopped[RTK_MAX_TX_QUEUE_NUM];
 
 	atomic_t free_pg_high;
 	atomic_t free_pg_normal;
-- 
2.55.0

