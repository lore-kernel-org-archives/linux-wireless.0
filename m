Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74433423E9F;
	Tue,  4 Aug 2026 06:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785826525; cv=none; b=I5wXV3Ax4Ic6Vhxysp0Pl+Rms7FzVxFD+lGndf4jp6fDfOX6C1c3opFsK9up9UaiQPNpM2vy4KFf5Ijk9fPmNWdh71TrdFJhM1a/8dUBdtkf8r+XkxlA2kR0UyOTEvQjSOsOO2+XtrOh653OFvS9YhmMrh7YgD7xTf+XHQfq7K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785826525; c=relaxed/simple;
	bh=K5DhDpEvJu90Y04wIBIywmK4wY4b7jgNvyGEKrV5fk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZYgaVduT8TWvmhksW8zrzQ0r3DwPzHNCRrMZLZdWG5xkFC3Q5OWP0hAbOggixD0trPblvIK+ZGT0h5Z8rmkDo2QmycltizAcIkTAhQwNVwP0Sngw2wp7jXXz2pWZVJaNfWq/T3o4wNU/Q1HUd5eoIEywf49xJqTGUZwCywssu1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GO0vjd61; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GO0vjd61"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785826521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AD8gjGRLSA+fVJBpF87ms2XwGjKH4KsmjH943OlVjMY=;
	b=GO0vjd61IOm46pFuBKWMNjyPev4zeJLwI24tT1VGy7hoBGv+en2KJiJKvJ4Iii24zSPp1L
	7b5ZXT3zUhGKMTpMFhN60WVMm6dUCduIrOmT9BEr94rTtBoqEJnzprGlVq9cmwCzNqpSBh
	7dWNqnISeFL1mXVe07IpNgufMSII9XQ=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v3 5/5] wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
Date: Tue,  4 Aug 2026 06:54:25 +0000
Message-ID: <20260804065425.17364-6-luka.gejak@linux.dev>
In-Reply-To: <20260804065425.17364-1-luka.gejak@linux.dev>
References: <20260804065425.17364-1-luka.gejak@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Luka Gejak <luka.gejak@linux.dev>

Two problems show up on RTL8723BS uplink. The per-AC software FIFO is
unbounded, so mac80211 keeps handing frames down until latency collapses
under load. And when the chip runs out of free TX pages the queue is
simply abandoned for that pass, which stalls the AC until something else
kicks the worker.

Stop the mac80211 queue once a data AC fills past a high watermark and
wake it from the drain path when it falls back to a low one. Convert the
TX work item to a delayed work so a temporary page shortage can be
retried shortly afterwards instead of stalling, and cancel it on
teardown.

Measured on RTL8723BS hardware, uplink goes from 11.9 Mbit/s with 204
TCP retransmits to 20.1 Mbit/s with 2.

Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
---
 drivers/net/wireless/realtek/rtw88/sdio.c | 99 ++++++++++++++++++++---
 drivers/net/wireless/realtek/rtw88/sdio.h |  3 +-
 2 files changed, 91 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index e9f0d23113f3..ed1bed8ea144 100644
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
@@ -1053,7 +1063,11 @@ static void rtw_sdio_tx_kick_off(struct rtw_dev *rtwdev)
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
@@ -1177,6 +1191,19 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
 
 	skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
 
+	/*
+	 * Back-pressure on the data ACs (BK/BE/VI/VO): once the FIFO fills past
+	 * the high watermark, stop the corresponding mac80211 queue so it stops
+	 * handing us frames, bounding the queueing latency. Resumed from the TX
+	 * drain path once the FIFO drains below the low watermark.
+	 */
+	if (rtw_is_8723bs(rtwdev) && queue < RTW_TX_QUEUE_BCN &&
+	    !rtwsdio->queue_stopped[queue] &&
+	    skb_queue_len(&rtwsdio->tx_queue[queue]) >= RTW_SDIO_TX_FIFO_HIWATER) {
+		rtwsdio->queue_stopped[queue] = true;
+		ieee80211_stop_queue(rtwdev->hw, skb_get_queue_mapping(skb));
+	}
+
 	return 0;
 }
 
@@ -1479,43 +1506,92 @@ static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
 	ieee80211_tx_status_irqsafe(hw, skb);
 }
 
-static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
-				      enum rtw_tx_queue_type queue)
+/*
+ * Send one frame from @queue. Returns 1 when a frame was written, 0 when the
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
+		return 0;
 
+	q_map = skb_get_queue_mapping(skb);
 	ret = rtw_sdio_write_port(rtwdev, skb, queue);
 	if (ret) {
 		skb_queue_head(&rtwsdio->tx_queue[queue], skb);
-		return;
+		return ret;
 	}
 
 	rtw_sdio_indicate_tx_status(rtwdev, skb);
+
+	if (rtw_is_8723bs(rtwdev) && queue < RTW_TX_QUEUE_BCN &&
+	    rtwsdio->queue_stopped[queue] &&
+	    skb_queue_len(&rtwsdio->tx_queue[queue]) <=
+	    RTW_SDIO_TX_FIFO_LOWATER) {
+		rtwsdio->queue_stopped[queue] = false;
+		ieee80211_wake_queue(rtwdev->hw, q_map);
+	}
+
+	return 1;
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
+	bool rtl8723bs;
 
 	rtwdev = work_data->rtwdev;
 	rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+	rtl8723bs = rtw_is_8723bs(rtwdev);
 
 	if (!rtw_fw_feature_check(&rtwdev->fw, FW_FEATURE_TX_WAKE))
 		rtw_sdio_deep_ps_leave(rtwdev);
 
 	for (queue = RTK_MAX_TX_QUEUE_NUM - 1; queue >= 0; queue--) {
 		for (limit = 0; limit < 1000; limit++) {
-			rtw_sdio_process_tx_queue(rtwdev, queue);
+			ret = rtw_sdio_process_tx_queue(rtwdev, queue);
+			if (ret == 0)
+				break;
+
+			if (ret < 0) {
+				/*
+				 * A page shortage is transient: leave the
+				 * frame queued and come back shortly instead
+				 * of stalling this AC until something else
+				 * kicks the worker.
+				 */
+				if (rtl8723bs && ret == -EBUSY) {
+					queue_delayed_work(rtwsdio->txwq,
+							   &work_data->work,
+							   RTW_SDIO_TX_RETRY_DELAY);
+					return;
+				}
+				break;
+			}
+
+			/*
+			 * Restart from the highest priority queue after every
+			 * management frame so the join sequence is not held up
+			 * behind a data backlog.
+			 */
+			if (rtl8723bs && queue == RTW_TX_QUEUE_MGMT) {
+				queue_delayed_work(rtwsdio->txwq,
+						   &work_data->work, 0);
+				return;
+			}
 
 			if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
 				break;
@@ -1542,14 +1618,16 @@ static int rtw_sdio_init_tx(struct rtw_dev *rtwdev)
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++)
+	for (i = 0; i < RTK_MAX_TX_QUEUE_NUM; i++) {
 		skb_queue_head_init(&rtwsdio->tx_queue[i]);
+		rtwsdio->queue_stopped[i] = false;
+	}
 	rtwsdio->tx_handler_data = kmalloc_obj(*rtwsdio->tx_handler_data);
 	if (!rtwsdio->tx_handler_data)
 		goto err_destroy_wq;
 
 	rtwsdio->tx_handler_data->rtwdev = rtwdev;
-	INIT_WORK(&rtwsdio->tx_handler_data->work, rtw_sdio_tx_handler);
+	INIT_DELAYED_WORK(&rtwsdio->tx_handler_data->work, rtw_sdio_tx_handler);
 
 	return 0;
 
@@ -1563,6 +1641,7 @@ static void rtw_sdio_deinit_tx(struct rtw_dev *rtwdev)
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	int i;
 
+	cancel_delayed_work_sync(&rtwsdio->tx_handler_data->work);
 	destroy_workqueue(rtwsdio->txwq);
 	kfree(rtwsdio->tx_handler_data);
 
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 7474a7511811..2f1b67f4bbc7 100644
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
+	bool queue_stopped[RTK_MAX_TX_QUEUE_NUM];
 
 	atomic_t free_pg_high;
 	atomic_t free_pg_normal;
-- 
2.53.0

