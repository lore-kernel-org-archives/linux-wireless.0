Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BEA53D5C06
	for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2026 07:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787124473; cv=none; b=RRYYwMUKI/X3M0kUr+Pn2ZcBASvMCgBBgu4VXZANhDgVHY6IaAosngKEBxE33NZCdacymrWCQScjJs8xbLDJb+BWCAXoX3qDt7bQJ4MtYhAPkjbwcy5/JSFjqGIMFMeiSpgJHsJS6hu+F2a9cTWtBch2hYqD9twXG62otelonDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787124473; c=relaxed/simple;
	bh=4aSCasSp7EzSpDVbiajVEEOWfX/iwq0sHNpkiTnn5H0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kAr6yFo3mGOKW8LTWTJh68ughh539Cg4S9ngQJwrEPBYpYlQLXdb+DU/fzryjSbF7jcR7Mhg4hWvuwAjzzmljWw2SsjGePUqN1rr74KDaMTEiMX3D5UuvB7NgkQtpGMYMqy23KjGrp+c8ube5fHAAjiaymlarPQ3f+6g2SyDnWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=EXPeSJSy; arc=none smtp.client-ip=91.218.175.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="EXPeSJSy"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=4aSCasSp7EzSpDVbiajVEEOWfX/iwq0sHNpkiTnn5H0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787124469; v=1; x=1787729269;
 b=EXPeSJSyKxHF3XrduvwLVOx4XAloKf8xMBxHkWvntli+34exUYB//rKjacaCDouG7vJh3MLI
 sC0bVxErDQiTlNW6zFHC91JE5oFKw7cEfcVDbeD9t0H+H3gaqAyuQ/lCMfmhoeUrzabGh5Y8tHH
 VFtM0M7XBzhqTWZcIdgPHVP4=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (2a06:63c5:9b00:3900:e1b3:d7a6:6110:4f65)
	by smtp.migadu.com with ESMTPS id 5d3f48bd80449399;
	Wed, 19 Aug 2026 07:27:49 +0000
X-Migadu-Flow: FLOW_OUT
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v6 6/6] wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
Date: Wed, 19 Aug 2026 07:27:17 +0000
Message-ID: <20260819072717.22648-7-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260819072717.22648-1-luka.gejak@linux.dev>
References: <20260819072717.22648-1-luka.gejak@linux.dev>
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
wake it from the drain path when it falls back to a low one. Convert the
TX work item to a delayed work and re-arm it when a transfer fails for a
reason that can clear on its own, so it is retried rather than the AC
abandoned, and cancel the work on teardown.

Retrying matters once the queue can be stopped. A stopped queue is
handed no further frames, so nothing else would kick the worker, and the
AC would stay stopped for good with the link still up and receive
unaffected. The two retried cases, a transmit page or output queue
shortage and a failed skb expansion, are also the two that fail
silently; the rest are logged where they happen, so they are visible
rather than an unexplained hang, and they keep the existing behaviour
rather than being retried indefinitely.

Measured on RTL8723BS hardware, uplink goes from 11.9 Mbit/s with 204
TCP retransmits to 20.1 Mbit/s with 2.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---

Notes:
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

 drivers/net/wireless/realtek/rtw88/sdio.c | 137 ++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/sdio.h |   3 +-
 2 files changed, 129 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index eaec776dd943..e5bf9cba071e 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -22,6 +22,16 @@
 #define RTW_SDIO_INDIRECT_RW_RETRIES			50
 #define RTW_SDIO_OQT_TIMEOUT_MS				1000
 
+/*
+ * 8723BS SDIO TX FIFO back-pressure watermarks: stop the mac80211 queue once
+ * the per-AC software FIFO fills past the high watermark, and wake it from the
+ * TX drain path once it falls back to the low one. Bounds the queueing latency
+ * that otherwise causes uplink bufferbloat / congestion collapse.
+ */
+#define RTW_SDIO_TX_FIFO_HIWATER			16
+#define RTW_SDIO_TX_FIFO_LOWATER			8
+#define RTW_SDIO_TX_RETRY_DELAY			msecs_to_jiffies(1)
+
 static bool rtw_sdio_is_bus_addr(u32 addr)
 {
 	return !!(addr & RTW_SDIO_BUS_MSK);
@@ -1100,7 +1110,11 @@ static void rtw_sdio_tx_kick_off(struct rtw_dev *rtwdev)
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
@@ -1209,6 +1223,50 @@ static int rtw_sdio_write_data_h2c(struct rtw_dev *rtwdev, u8 *buf, u32 size)
 	return rtw_sdio_write_data(rtwdev, &pkt_info, skb, RTW_TX_QUEUE_H2C);
 }
 
+/*
+ * Back-pressure on the data ACs (BK/BE/VI/VO): once the software FIFO fills
+ * past the high watermark, stop the corresponding mac80211 queue so it stops
+ * handing frames down, which bounds the queueing latency. The queue is woken
+ * again from the TX drain path once the FIFO falls back to the low watermark.
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
@@ -1224,6 +1282,8 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
 
 	skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
 
+	rtw_sdio_8723bs_stop_tx_queue(rtwdev, queue, skb_get_queue_mapping(skb));
+
 	return 0;
 }
 
@@ -1526,33 +1586,81 @@ static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
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
 
+	q_map = skb_get_queue_mapping(skb);
 	ret = rtw_sdio_write_port(rtwdev, skb, queue);
 	if (ret) {
 		skb_queue_head(&rtwsdio->tx_queue[queue], skb);
-		return;
+		return ret;
 	}
 
 	rtw_sdio_indicate_tx_status(rtwdev, skb);
+
+	rtw_sdio_8723bs_wake_tx_queue(rtwdev, queue, q_map);
+
+	return 0;
+}
+
+/*
+ * Decide whether the RTL8723BS wants the TX work to run again, and if so
+ * arrange it and tell the caller to stop draining. Two cases need it.
+ *
+ * A transmit page or output queue shortage and a failed skb expansion are
+ * transient and leave the frame queued, so come back for it shortly. That
+ * matters once the mac80211 queue can be stopped: a stopped queue is handed
+ * no further frames, so nothing else would kick this work item and the access
+ * category would stay stopped for good. The remaining errors are logged where
+ * they happen and are not retried.
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
+	if (ret == -EBUSY || ret == -ENOMEM)
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
@@ -1562,7 +1670,13 @@ static void rtw_sdio_tx_handler(struct work_struct *work)
 
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
@@ -1589,14 +1703,16 @@ static int rtw_sdio_init_tx(struct rtw_dev *rtwdev)
 		return -ENOMEM;
 	}
 
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
 
@@ -1610,6 +1726,7 @@ static void rtw_sdio_deinit_tx(struct rtw_dev *rtwdev)
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	int i;
 
+	cancel_delayed_work_sync(&rtwsdio->tx_handler_data->work);
 	destroy_workqueue(rtwsdio->txwq);
 	kfree(rtwsdio->tx_handler_data);
 
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 7474a7511811..cec3dd1c4b2e 100644
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
2.53.0

