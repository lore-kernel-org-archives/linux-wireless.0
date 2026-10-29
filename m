Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793281720;
	b=pDz0bRfOrr+8AWwqC/MbwTmp0TXmZHxHrELSZNGzb5DyWiDjjojUWOXi6D9Ppq3v5YpT
	 vykZwvh7hIomEq+nyRjlpBLlTvHstuHMGJSOu5K4CLOfoUm+wi1wWnDbE6nZCsSeu+pYb
	 NEllI/1EMxvHw39kphacVH+4+Gpg0HdbsSyS4x8lwdN8HVsY6ZiaZ9wnDcHzKZteKrcSo
	 4ZHhGktxVpXA0vuHNF5QYBulzfM9GApW8M6VcfPxxDdOn7d0EnVxum5QYjPVrW+85MBR6
	 kEwRxJYG/8YGVhza/4YWITvYo/5Cv2v6x/gH++SeKM6PpbU3RX71wwPFSgOu0oPw/hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793281720;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=p1UXMC8iozETLjO8muY6LN9n4SNJci1nwFxwSYnCk2k=;
	b=uvllwTXiaeJ8SI6dUAbzcqNR90kVZ+fJRlfV0MXG46qQAAxlWO9adSgg5dq0Hl3Byqmz
	 gzaoZf/oY6/ov89nhjLDDV+QBFmdCwhT88q9PCsLB3dFXTk9zCREkacOi4t2dbc96D3Rk
	 XaSOs237dzoSikHpySe7F2s+RcfV5Vqg4HAJxvw2G6Wun5XGFCQKBwYkEFKFMfgWfC0PM
	 RiJSRwomzLqo3/guTh73DrwDm02bLLlaRukI/X2ZUoUJII+Ev8U1czIRuGmoIWiftWrFU
	 TNwj4jWGCubLVUvc4p+b3hd+KrHfIrMzwjF7xK840nlFLO1XJnS8s7h5h1ypIOzthtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aVu7MLha;
	arc=none smtp.remote-ip=209.85.210.175
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B0F160A380D
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 13:48:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1B0F160A380D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aVu7MLha
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8a052aff9e9so1630183b3a.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 06:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793281719; x=1793886519; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p1UXMC8iozETLjO8muY6LN9n4SNJci1nwFxwSYnCk2k=;
        b=aVu7MLhaeD+SlL+29nLQOApNZMrUBDWEiA48U/EZY8Rt6FSEKTLPVg+N1KCRUh8N+l
         E5e24y0R1vbgWmA8c/l3XVG5w4L5NiBHhnAOVPOS5iBaxC39l5nRoDuUcSX26J44Rdfr
         YhIOSiQ5QETMVnqsOQtJO2Y0Rap5kJq2FKJCsfUZZ1KhfP/39LDbVy2CIXeVDrmgTRth
         jvukkLjqqyvbt7SCLp48KfAKbJgb0oBbMsJjtUYBadle96+kNhZ+oHZ90QAJAGaoqQYh
         QqAKPO8LVwUvlSGzMK0b2H1DnItTgnVru/3Ayp4+U7bsps3nwMkxNvyHgFvUD4mJVFxr
         +grg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793281719; x=1793886519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=p1UXMC8iozETLjO8muY6LN9n4SNJci1nwFxwSYnCk2k=;
        b=vHhWmIcn1zKFutaeJ7t/7NhW9BLTedCpnEPye8GVhSDg8k7Kf5PUn4o2hp4Byrod/t
         DyfjNJ6XJk2I665lLwcP+Mb8VcbVovQfSSBysG+ZMgDEBLR03LhH99+wObQ9llrF3Nt6
         +XsImjEpy32JwleOP0HaGP0V+PTHIrAqwioWczaqwpIw4aZSJai2DMuNdiC1vsO39BgY
         2JvGLuIKpi4YXRx6m7oEFNztlCtCTSLlivn4sFJn0i2BwCQqDpFniIT62PWaQQMdX3cd
         opYFcI0RmMN52EhXNWDr8sg5OVJ10K67FjGI6xFxsYdY6hFVFr237Ar9Kf82HoRPsb6B
         CZaQ==
X-Gm-Message-State: AFq9FYIbbfCFMGclDIn3n7xztEX1fxEWxrSrO7NVV0uBa86KXT0dP1DT
	NgHcdWjzXq9Lr6nl7gX2jSH9ayM3uOcLSzinJ1zm3VN0Oe/1kkRy4QnMOmx74UcZ
X-Gm-Gg: AYBFou0eGMrv2ukaVdChyAWZWAM5scbTsgf76+CaH2mpenViSt1amRGebToKQhSuTOk
	C9PRJEW+mFK9WmTbrY+cyNN5f5BM9k8Swh224f38uoE+f7azYzGculEkslKqZ062WFJR+c8VhnT
	Ckb6j5Fy8aD8gk+MLITmEF6BHq+uXE7CdaUJyN4fmGsBqvy1rfD2sSLsf9qMEd5bt6xgLt2pi7g
	xPX0etwvQvleYGiu73u/jrmd/Uq3yQhITmYnC0c/2QGdqmZx4J6hjqaNs8myRifbxY50tV1Hmzk
	YnWUwhX+1c0aiIbCNTcCjZr+NAnP4qgqyPC8eN3v9rLrjD6o7Y9GNyzVGo+7DMHrLpR9G8R2oND
	XWZTfOOHEIv6KD8CPMshQYE5EGoUlEXKns6WgGrSKwVs+68dZQOw0YpJzAYjq2Qy3BvvXBZpJUO
	emY7lgh+kIMq5YPL9MQMtZtBWafMDYkQ/Uw03GQmudvX/LG0TdHmblMQwyrr8iskB1U7YwNK0fV
	v0V4mq2nAN2ebdtDYkCHJ7hDubunjCJtIVJXPbKhjNQU/mMBPc7JaaS1JrNn+j6g0zYOMSqO+BT
	Fjj+LhbYONlMvKhNjDfegiZWcej4Z6kNoc285aoTUA8qAzysLCX2kEHPCDQmMFE1c7unYBjPp5o
	UeSd1zjGX
X-Received: by 2002:a05:6a00:288d:b0:886:31d3:51a2 with SMTP id d2e1a72fcca58-8a6e78cfe4cmr4714194b3a.39.1793281719386;
        Thu, 29 Oct 2026 06:48:39 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:ab4c:c3be:c4b6:67cd])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a6a3d5baf4sm2455023b3a.1.2026.10.29.06.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 06:48:39 -0700 (PDT)
From: Ho Jie Feng <hjf3108@gmail.com>
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org,
	Ho Jie Feng <hjf3108@gmail.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 7/8] wifi: rt2800usb: enable RX bulk aggregation
Date: Thu, 29 Oct 2026 21:47:48 +0800
Message-ID: <20261029134752.1299130-8-hjf3108@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261029134752.1299130-1-hjf3108@gmail.com>
References: <20261029134752.1299130-1-hjf3108@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Enable RX bulk aggregation on high speed USB, to receive more
frames per URB.

RX buffers are now 24KB, so reduce it to 16 buffers instead of 128,
so that they take 512 KB in total instead of 4 MB.

Test results:
   before after
TX 30.5   30.5
RX 67.8   80.9

This code references the mt7601u driver.

Signed-off-by: Ho Jie Feng <hjf3108@gmail.com>
---
 .../net/wireless/ralink/rt2x00/rt2800usb.c    | 32 +++++--
 .../net/wireless/ralink/rt2x00/rt2800usb.h    |  6 ++
 drivers/net/wireless/ralink/rt2x00/rt2x00.h   |  3 +-
 .../net/wireless/ralink/rt2x00/rt2x00dev.c    | 84 +++++++++++++------
 .../net/wireless/ralink/rt2x00/rt2x00mmio.c   |  2 +-
 .../net/wireless/ralink/rt2x00/rt2x00usb.c    |  5 +-
 6 files changed, 100 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
index 387c07e2251b7..2e4277b1e5d1b 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.c
@@ -301,15 +301,15 @@ static int rt2800usb_enable_radio(struct rt2x00_dev *rt2x00dev)
 		return -EIO;
 
 	rt2x00_set_field32(&reg, USB_DMA_CFG_PHY_CLEAR, 0);
-	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN, 0);
+	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_EN,
+			   rt2x00dev->rx->usb_maxpacket == 512);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_TIMEOUT, 128);
 	/*
 	 * Total room for RX frames in kilobytes, PBF might still exceed
 	 * this limit so reduce the number to prevent errors.
 	 */
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_AGG_LIMIT,
-			   ((rt2x00dev->rx->limit * DATA_FRAME_SIZE)
-			    / 1024) - 3);
+			   (rt2x00dev->rx->data_size / 1024) - 4);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_RX_BULK_EN, 1);
 	rt2x00_set_field32(&reg, USB_DMA_CFG_TX_BULK_EN, 1);
 	rt2x00usb_register_write(rt2x00dev, USB_DMA_CFG, reg);
@@ -478,6 +478,27 @@ static void rt2800usb_work_txdone(struct work_struct *work)
 /*
  * RX control handlers
  */
+static unsigned int rt2800usb_get_rx_seg_len(void *data, unsigned int len)
+{
+	unsigned int min_seg_len = RXINFO_DESC_SIZE + RXWI_DESC_SIZE_4WORDS +
+				   RXD_DESC_SIZE;
+	unsigned int rx_pkt_len;
+	u32 word;
+
+	if (len < min_seg_len)
+		return 0;
+
+	word = rt2x00_desc_read(data, 0);
+	rx_pkt_len = rt2x00_get_field32(word, RXINFO_W0_USB_DMA_RX_PKT_LEN);
+
+	if (!rx_pkt_len ||
+	    RXINFO_DESC_SIZE + rx_pkt_len + RXD_DESC_SIZE > len ||
+	    rx_pkt_len & 0x3)
+		return 0;
+
+	return RXINFO_DESC_SIZE + rx_pkt_len + RXD_DESC_SIZE;
+}
+
 static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 				  struct rxdone_entry_desc *rxdesc)
 {
@@ -706,6 +727,7 @@ static const struct rt2x00lib_ops rt2800usb_rt2x00_ops = {
 	.clear_beacon		= rt2800_clear_beacon,
 	.get_tx_data_len	= rt2800usb_get_tx_data_len,
 	.fill_rxdone		= rt2800usb_fill_rxdone,
+	.get_rx_seg_len		= rt2800usb_get_rx_seg_len,
 	.config_shared_key	= rt2800_config_shared_key,
 	.config_pairwise_key	= rt2800_config_pairwise_key,
 	.config_filter		= rt2800_config_filter,
@@ -725,8 +747,8 @@ static void rt2800usb_queue_init(struct data_queue *queue)
 
 	switch (queue->qid) {
 	case QID_RX:
-		queue->limit = 128;
-		queue->data_size = AGGREGATION_SIZE;
+		queue->limit = 16;
+		queue->data_size = MAX_RXBULK_SIZE;
 		queue->desc_size = RXINFO_DESC_SIZE;
 		queue->winfo_size = rxwi_size;
 		queue->priv_size = sizeof(struct queue_entry_priv_usb);
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800usb.h b/drivers/net/wireless/ralink/rt2x00/rt2800usb.h
index 9e180e9e41d92..2fae79072fd58 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800usb.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800usb.h
@@ -29,6 +29,12 @@
  */
 #define TXINFO_DESC_SIZE		(1 * sizeof(__le32))
 #define RXINFO_DESC_SIZE		(1 * sizeof(__le32))
+#define RXD_DESC_SIZE			(1 * sizeof(__le32))
+
+/*
+ * RX buffer size
+ */
+#define MAX_RXBULK_SIZE			24576
 
 /*
  * TX Info structure
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index a80508db32d9c..5bc077fce9cbf 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -593,6 +593,7 @@ struct rt2x00lib_ops {
 	 */
 	void (*fill_rxdone) (struct queue_entry *entry,
 			     struct rxdone_entry_desc *rxdesc);
+	unsigned int (*get_rx_seg_len) (void *data, unsigned int len);
 
 	/*
 	 * Configuration handlers.
@@ -1448,7 +1449,7 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 void rt2x00lib_txdone_nomatch(struct queue_entry *entry,
 			      struct txdone_entry_desc *txdesc);
 void rt2x00lib_txdone_noinfo(struct queue_entry *entry, u32 status);
-void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp);
+void rt2x00lib_rxdone(struct queue_entry *entry, unsigned int len, gfp_t gfp);
 
 /*
  * mac80211 handlers.
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
index 66094da07325f..351e7da178279 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00dev.c
@@ -745,35 +745,14 @@ static int rt2x00lib_rxdone_read_signal(struct rt2x00_dev *rt2x00dev,
 	return 0;
 }
 
-void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
+static void rt2x00lib_rxdone_skb(struct queue_entry *entry)
 {
 	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
 	struct rxdone_entry_desc rxdesc;
-	struct sk_buff *skb;
 	struct ieee80211_rx_status *rx_status;
 	unsigned int header_length;
 	int rate_idx;
 
-	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
-	    !test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
-		goto submit_entry;
-
-	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
-		goto submit_entry;
-
-	/*
-	 * Allocate a new sk_buffer. If no new buffer available, drop the
-	 * received frame and reuse the existing buffer.
-	 */
-	skb = rt2x00queue_alloc_rxskb(entry, gfp);
-	if (!skb)
-		goto submit_entry;
-
-	/*
-	 * Unmap the skb.
-	 */
-	rt2x00queue_unmap_skb(entry);
-
 	/*
 	 * Extract the RXD details.
 	 */
@@ -789,7 +768,7 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 		rt2x00_err(rt2x00dev, "Wrong frame size %d max %d\n",
 			   rxdesc.size, entry->queue->data_size);
 		dev_kfree_skb(entry->skb);
-		goto renew_skb;
+		return;
 	}
 
 	/*
@@ -868,8 +847,65 @@ void rt2x00lib_rxdone(struct queue_entry *entry, gfp_t gfp)
 	rx_status->antenna = rt2x00dev->link.ant.active.rx;
 
 	ieee80211_rx_ni(rt2x00dev->hw, entry->skb);
+}
+
+void rt2x00lib_rxdone(struct queue_entry *entry, unsigned int len, gfp_t gfp)
+{
+	struct rt2x00_dev *rt2x00dev = entry->queue->rt2x00dev;
+	struct skb_frame_desc *skbdesc, *frame_skbdesc;
+	struct sk_buff *skb;
+	unsigned int seg_len;
+	u8 *data;
+
+	if (!test_bit(DEVICE_STATE_PRESENT, &rt2x00dev->flags) ||
+	    !test_bit(DEVICE_STATE_ENABLED_RADIO, &rt2x00dev->flags))
+		goto submit_entry;
+
+	if (test_bit(ENTRY_DATA_IO_FAILED, &entry->flags))
+		goto submit_entry;
+
+	if (rt2x00dev->ops->lib->get_rx_seg_len) {
+		skb = entry->skb;
+		skbdesc = get_skb_frame_desc(skb);
+		data = skb->data;
+
+		while ((seg_len = rt2x00dev->ops->lib->get_rx_seg_len(data, len))) {
+			entry->skb = __dev_alloc_skb(seg_len, gfp);
+			if (!entry->skb)
+				break;
+
+			skb_put_data(entry->skb, data, seg_len);
+
+			frame_skbdesc = get_skb_frame_desc(entry->skb);
+			memset(frame_skbdesc, 0, sizeof(*frame_skbdesc));
+			frame_skbdesc->desc = skbdesc->desc;
+			frame_skbdesc->desc_len = skbdesc->desc_len;
+
+			rt2x00lib_rxdone_skb(entry);
+
+			data += seg_len;
+			len -= seg_len;
+		}
+
+		entry->skb = skb;
+		goto submit_entry;
+	}
+
+	/*
+	 * Allocate a new sk_buffer. If no new buffer available, drop the
+	 * received frame and reuse the existing buffer.
+	 */
+	skb = rt2x00queue_alloc_rxskb(entry, gfp);
+	if (!skb)
+		goto submit_entry;
+
+	/*
+	 * Unmap the skb.
+	 */
+	rt2x00queue_unmap_skb(entry);
+
+	rt2x00lib_rxdone_skb(entry);
 
-renew_skb:
 	/*
 	 * Replace the skb with the freshly allocated one.
 	 */
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.c b/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.c
index 93f76acf3dc7d..a1d8b8d13daca 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00mmio.c
@@ -78,7 +78,7 @@ bool rt2x00mmio_rxdone(struct rt2x00_dev *rt2x00dev)
 		/*
 		 * Send the frame to rt2x00lib for further processing.
 		 */
-		rt2x00lib_rxdone(entry, GFP_ATOMIC);
+		rt2x00lib_rxdone(entry, entry->skb->len, GFP_ATOMIC);
 	}
 
 	return !max_rx;
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index c9fbc3710fd8d..4519a20a7f4bc 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -345,6 +345,7 @@ static void rt2x00usb_work_rxdone(struct work_struct *work)
 {
 	struct rt2x00_dev *rt2x00dev =
 	    container_of(work, struct rt2x00_dev, rxdone_work);
+	struct queue_entry_priv_usb *entry_priv;
 	struct queue_entry *entry;
 	struct skb_frame_desc *skbdesc;
 	u8 rxd[32];
@@ -365,7 +366,9 @@ static void rt2x00usb_work_rxdone(struct work_struct *work)
 		/*
 		 * Send the frame to rt2x00lib for further processing.
 		 */
-		rt2x00lib_rxdone(entry, GFP_KERNEL);
+		entry_priv = entry->priv_data;
+		rt2x00lib_rxdone(entry, entry_priv->urb->actual_length,
+				 GFP_KERNEL);
 	}
 }
 
-- 
2.53.0

