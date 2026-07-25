Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682B334BA24
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 15:05:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784991912; cv=none; b=WnFHkEV3cqwaOPqkomDTK7AZZtZONrJ9trMhE9hIZzuhHk8YIvQn03UCowBI2eKctmoz7iwB1TP13M5aiPt2ltzh1arf5r5pSMDTaEDQPjzupGqSgwpEc1fJV9tqwmJlEOqOjyDR0gOBwq4Tnd1qcLPFrbvjCKfqr38t9/89dg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784991912; c=relaxed/simple;
	bh=rd9PyvCDA4OWZcc3lrvWXGszH9miiesNeuHPbpD1CFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7/kWExfmUOcL0KUosrX+9MzxWtysDyawFqgrm8A/EePF4XmgIhvj8mx6OthvkxBtQg4xePqLfJj/fklg/6gv+rLI3W+pCLOdpaPgjOHkXgPWktBqJNs7Gugb4Ule2Hu6gnNt2Z9XtdCjnAGXKC3RKCW9orCMcXDuN8BXPJpRCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=pbu80ZGs; arc=none smtp.client-ip=95.215.58.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="pbu80ZGs"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784991906;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RaeNP1b8NOMPmZI1QPBDrBl3/Kwy569jgvlI60Ia8lA=;
	b=pbu80ZGsstEqACEoMKjBSgFH6aSBZpZql1TMPKbJ1VC4Jofgy05fSkouyK0IHfoGAUeZCn
	FbJvAGXAr7+3A4Km4L43t68H5eQJXwEk8zy/XgQhn4cldRsJFwq9vLHWBD25BoMAHYa8vN
	PJmtLy6iDgcOxfSbMeYkUXyHmrKdHq4=
From: luka.gejak@linux.dev
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Michael Straube <straube.linux@gmail.com>,
	Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	Luka Gejak <luka.gejak@linux.dev>
Subject: [PATCH v2 09/11] wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
Date: Sat, 25 Jul 2026 17:04:25 +0200
Message-ID: <20260725150427.93887-10-luka.gejak@linux.dev>
In-Reply-To: <20260725150427.93887-1-luka.gejak@linux.dev>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
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
 drivers/net/wireless/realtek/rtw88/sdio.c | 75 ++++++++++++++++++++---
 drivers/net/wireless/realtek/rtw88/sdio.h |  3 +-
 2 files changed, 68 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index 37d1d58fa55e..572b791249ed 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.c
+++ b/drivers/net/wireless/realtek/rtw88/sdio.c
@@ -22,6 +22,15 @@
 #define RTW_SDIO_INDIRECT_RW_RETRIES			50
 #define RTW_SDIO_OQT_TIMEOUT_MS				1000
 
+/* 8723BS SDIO TX FIFO back-pressure watermarks: stop the mac80211 queue once
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
@@ -1030,7 +1039,7 @@ static void rtw_sdio_tx_kick_off(struct rtw_dev *rtwdev)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 
-	queue_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work);
+	mod_delayed_work(rtwsdio->txwq, &rtwsdio->tx_handler_data->work, 0);
 }
 
 static void rtw_sdio_link_ps(struct rtw_dev *rtwdev, bool enter)
@@ -1154,6 +1163,18 @@ static int rtw_sdio_tx_write(struct rtw_dev *rtwdev,
 
 	skb_queue_tail(&rtwsdio->tx_queue[queue], skb);
 
+	/* Back-pressure on the data ACs (BK/BE/VI/VO): once the FIFO fills past
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
 
@@ -1455,32 +1476,48 @@ static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
 	ieee80211_tx_status_irqsafe(hw, skb);
 }
 
-static void rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
-				      enum rtw_tx_queue_type queue)
+static int rtw_sdio_process_tx_queue(struct rtw_dev *rtwdev,
+				     enum rtw_tx_queue_type queue,
+				     bool *processed)
 {
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	struct sk_buff *skb;
+	u16 q_map;
 	int ret;
 
+	*processed = false;
 	skb = skb_dequeue(&rtwsdio->tx_queue[queue]);
 	if (!skb)
-		return;
+		return 0;
 
+	*processed = true;
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
+	    skb_queue_len(&rtwsdio->tx_queue[queue]) <= RTW_SDIO_TX_FIFO_LOWATER) {
+		rtwsdio->queue_stopped[queue] = false;
+		ieee80211_wake_queue(rtwdev->hw, q_map);
+	}
+
+	return 0;
 }
 
 static void rtw_sdio_tx_handler(struct work_struct *work)
 {
 	struct rtw_sdio_work_data *work_data =
-		container_of(work, struct rtw_sdio_work_data, work);
+		container_of(to_delayed_work(work), struct rtw_sdio_work_data,
+			     work);
 	struct rtw_sdio *rtwsdio;
 	struct rtw_dev *rtwdev;
+	bool processed;
 	int limit, queue;
 
 	rtwdev = work_data->rtwdev;
@@ -1491,7 +1528,24 @@ static void rtw_sdio_tx_handler(struct work_struct *work)
 
 	for (queue = RTK_MAX_TX_QUEUE_NUM - 1; queue >= 0; queue--) {
 		for (limit = 0; limit < 1000; limit++) {
-			rtw_sdio_process_tx_queue(rtwdev, queue);
+			int ret;
+
+			ret = rtw_sdio_process_tx_queue(rtwdev, queue, &processed);
+			if (ret) {
+				if (rtw_is_8723bs(rtwdev) && ret == -EBUSY) {
+					mod_delayed_work(rtwsdio->txwq,
+							 &work_data->work,
+							 RTW_SDIO_TX_RETRY_DELAY);
+					return;
+				}
+				break;
+			}
+
+			if (rtw_is_8723bs(rtwdev) &&
+			    queue == RTW_TX_QUEUE_MGMT && processed) {
+				mod_delayed_work(rtwsdio->txwq, &work_data->work, 0);
+				return;
+			}
 
 			if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
 				break;
@@ -1518,14 +1572,16 @@ static int rtw_sdio_init_tx(struct rtw_dev *rtwdev)
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
 
@@ -1539,6 +1595,7 @@ static void rtw_sdio_deinit_tx(struct rtw_dev *rtwdev)
 	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
 	int i;
 
+	cancel_delayed_work_sync(&rtwsdio->tx_handler_data->work);
 	destroy_workqueue(rtwsdio->txwq);
 	kfree(rtwsdio->tx_handler_data);
 
diff --git a/drivers/net/wireless/realtek/rtw88/sdio.h b/drivers/net/wireless/realtek/rtw88/sdio.h
index 541d4302ec6b..f1f59f8301b8 100644
--- a/drivers/net/wireless/realtek/rtw88/sdio.h
+++ b/drivers/net/wireless/realtek/rtw88/sdio.h
@@ -152,7 +152,7 @@ struct rtw_sdio_tx_data {
 };
 
 struct rtw_sdio_work_data {
-	struct work_struct work;
+	struct delayed_work work;
 	struct rtw_dev *rtwdev;
 };
 
@@ -168,6 +168,7 @@ struct rtw_sdio {
 	struct workqueue_struct *txwq;
 	struct rtw_sdio_work_data *tx_handler_data;
 	struct sk_buff_head tx_queue[RTK_MAX_TX_QUEUE_NUM];
+	bool queue_stopped[RTK_MAX_TX_QUEUE_NUM];
 
 	atomic_t free_pg_high;
 	atomic_t free_pg_normal;
-- 
2.55.0

