Received: from mta1.migadu.com (out-212.mta1.migadu.com [95.215.58.212])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BDC438038
	for <linux-wireless@vger.kernel.org>; Fri, 14 Aug 2026 10:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.212
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786704878; cv=none; b=GabLFWols3G8+fo8G37Y1E36o5U3LQ3Kybf7JOq4Tf8HOWxinrZTEi6hzy83/qGSmGuSDgNTKhQ5mCNuojAI5evtvh+dcEBVBebqp8XcGWsqXmUO2Pged6CsDGm9lNLQtK3yG4hvlNt/VRysL3R4OQ8k8tS6pArftDftpQLl54c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786704878; c=relaxed/simple;
	bh=L9S47wt5zxwhgn2O1Ux98Q5TcY716GBZIxS+Kxt/JuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dhpNrBX/CvBSMEM3gaB8Iw1tEmobXl+RwYDZ6Jo4lSySF9CU6VNzTl/2fc4NVmxGVTlfFaI/zyuf1B8wC61ukwV1cxDeeAi7HOXup4M4iJhpEsn33tKZR96OK7H2TZkyXB92MgEAcg66YnwOXdzaaZn6Wy7cj1CXsQFHdrz+jXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KI8s8uYn; arc=none smtp.client-ip=95.215.58.212
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KI8s8uYn"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=L9S47wt5zxwhgn2O1Ux98Q5TcY716GBZIxS+Kxt/JuU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786704861; v=1; x=1787309661;
 b=KI8s8uYnutAr3j8/Ir4wjWnjG7JPZ1SoigdwxyYailc70Ta0qi4WTkGHP+NsaKBx4CKp311m
 rD+xi6fcxVUzGexfhfTyqhsNytG/qhdLAyLjYZcjozw+w/5wJTu5yWG2XarPbsT7AYV88jjmjCh
 xPGs7in2JMQieQ5btWh4k83s=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from kali (46.239.4.165)
	by smtp.migadu.com with ESMTPS id 50f879c32b0c2713;
	Fri, 14 Aug 2026 10:54:21 +0000
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
Subject: [PATCH v5 6/6] wifi: rtw88: sdio: add TX back-pressure and retry on page starvation
Date: Fri, 14 Aug 2026 10:53:26 +0000
Message-ID: <20260814105327.6687-7-luka.gejak@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260814105327.6687-1-luka.gejak@linux.dev>
References: <20260814105327.6687-1-luka.gejak@linux.dev>
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
 drivers/net/wireless/realtek/rtw88/sdio.c | 139 ++++++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/sdio.h |   3 +-
 2 files changed, 131 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/sdio.c b/drivers/net/wireless/realtek/rtw88/sdio.c
index eaec776dd943..1de104870572 100644
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
 
@@ -1526,43 +1586,99 @@ static void rtw_sdio_indicate_tx_status(struct rtw_dev *rtwdev,
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
+static void rtw_sdio_reschedule_tx_work(struct rtw_dev *rtwdev,
+					struct rtw_sdio_work_data *work_data,
+					unsigned long delay)
+{
+	struct rtw_sdio *rtwsdio = (struct rtw_sdio *)rtwdev->priv;
+
+	queue_delayed_work(rtwsdio->txwq, &work_data->work, delay);
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
+			if (ret > 0)
+				break;
+
+			if (ret < 0) {
+				/*
+				 * A page or output queue shortage and a failed
+				 * skb expansion are both transient, and the
+				 * frame is still queued, so come back for it.
+				 * That matters once the queue can be stopped:
+				 * a stopped queue is handed no further frames,
+				 * so nothing else would kick this work item and
+				 * the queue would stay stopped for good. The
+				 * remaining errors cannot succeed on a retry
+				 * and each log where they happen.
+				 */
+				if (rtl8723bs &&
+				    (ret == -EBUSY || ret == -ENOMEM)) {
+					rtw_sdio_reschedule_tx_work(rtwdev, work_data,
+								    RTW_SDIO_TX_RETRY_DELAY);
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
+				rtw_sdio_reschedule_tx_work(rtwdev, work_data, 0);
+				return;
+			}
 
 			if (skb_queue_empty(&rtwsdio->tx_queue[queue]))
 				break;
@@ -1589,14 +1705,16 @@ static int rtw_sdio_init_tx(struct rtw_dev *rtwdev)
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
 
@@ -1610,6 +1728,7 @@ static void rtw_sdio_deinit_tx(struct rtw_dev *rtwdev)
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

