Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C345474F
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 17:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788197989; cv=none; b=OvheGNnDC6UneYV2vLz7sgRxqq784AchlLVnFT6HeehVhsUHp3/Rf8LyEKirh2fpYvSjiDwX0e8uHlQGHehsaLvZFh7t5Jl0XOJhXp+p8DHE8mlK7Lzf3rnkdcjuWSDesR1H5G4xTo2k4dXN3DhLbuPebike1SUt8Uw61FIFjwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788197989; c=relaxed/simple;
	bh=9mEPRNORGEsWlSkrt74aGVDx72yctD38G82rJmY7P38=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d1/Sh3sMErt+k22jBOSv7A8AIMHNjEkDDqNPoT/GLyI1D0KKmgGsLFeE8MYVRobFZW156eL5STL05cbuI/o/XfRWG8aDkJwQSh2Y4YbCc271TWE4Lcblu2KQckIf9cTppG5htAHrF8DS7504g+VNPqUgFSvWmPY06xeYQC7P/I4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a/qN/p4X; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a/qN/p4X"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48436668d20so1033450f8f.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 10:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788197986; x=1788802786; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pE5lwOeG+dorblBGAN65Wk3d3m+gua2JMLbC6fc1KiU=;
        b=a/qN/p4XhmyaIzxx2wfBxApGizf3Lqeh/egMoVb/zaoyERM1iU8Z+lfDktmGEuRKtw
         XJYcbq/IMC83Hf2BNs5QnH1pTNrJmEEpAztuoORI9GCPayB2ACnl5ADaIq9XGKg4E+FA
         S7BlDYvRpv+m6+wmRIxq0ZEa4/5uVeXxxqQHYcujob6TljsRmL6OQxZh/o6L4LalnsKX
         GWs+Rp8YIgGJ+IJ9ixp6H9K+U+x+tlWaBWoTgi6epeczuf/XW2ACmD8xHUpVbHSEVWRG
         ShSUSNftTisJVy/dE3tCql45Tiikdq1UoahXePfi51hfu4u+SzlxPV1IxejcflmQJFTC
         Wv2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788197986; x=1788802786;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pE5lwOeG+dorblBGAN65Wk3d3m+gua2JMLbC6fc1KiU=;
        b=MhlevxiKlJs5yWVHtV9a8Emk1/VL8ROVFU/6f21LkJ7tw8J1L8R6tcsQB8UjLfATsP
         tY4bb0SFpl0ut704ijlYP8sKa96/6mDPZm0fnC0ErvqGmqAqw/lX1eF/fFcodHYDkojZ
         LamG6r+GlDmsS1riTyFTvsiuBA+8UZ5Ltn1Rxbv/yy15T8OhKZ3WK/NQqke8vbPkAI2p
         uj/hqoSvTQi4ad+casfRDSASLF1ucm7E23mPx3ipoVAc/q/VJgS2CimfMg4fgrKkwsOD
         XD4+nCDmnqQSycgfEsXEgW8d1EsBD4WqH/kGGaS79e236sZqLXHZxzteR1OK5M/PnWI0
         2ZIA==
X-Gm-Message-State: AFuF++lGXoGpVJqOACZzcigag7q0Hu4+kxagqBr8dUz8bkvdIxEFKz/6
	1dz/u0uj4LhMD+X040i8dmwTCcw5OSDdN010dAGAIwPHJNwT0kLQC1o3
X-Gm-Gg: AYBFou3DxYaI3oR/zbb5/Nup4AAyHweo522D/BUgws8rPzVdfV0mq+0EaCgmc+a2Iv+
	XYoPNR9OObPQZGBJXGWmz/5NxbH0cJX1CqyAj7TaVtGIahe2pN3QlGBFzYJs4KSXkqoo/flZD2N
	4xAuR7pYBN9Pw7r9xkUrIio5jf6jjOMfayiGVwVJMbuSEDDIBs9EyENCv7u8wihSVKJXv4HuZTX
	bYREyyfgXbQRz8uo2HQWwzkpmn5SH3gxX3q7UmTbGyOvevJIuyEEQHvaFOgcaeK940z71Moww53
	eXqil5mW0LVEqZVXKjOOvuDU0iHHqPnAH11dhUACRY5PaenGMR99L3B5XYpVq8NeH/zkOIx0Zm5
	8RSf+x5Dr04e6DhMiMPYexljPBfsfjTAWP9sqJFhF8zNRY7zYgkM7tlJVwIuCCvDZHGJe7soqo9
	+X3zpESZYiWgxP7ovk/cvxx38kAGaQRuKByWCqcp/BrfW1/YrHuXZ7qNJau7u1TNP1wEXWglrHv
	IQMur/NnO4gXFxotF5y
X-Received: by 2002:a5d:5e8d:0:b0:484:3317:a16 with SMTP id ffacd0b85a97d-48433170baamr30663815f8f.23.1788197986040;
        Mon, 31 Aug 2026 10:39:46 -0700 (PDT)
Received: from gkaran.home ([2a02:587:4e00:af00:4405:590b:435f:6c05])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482fbab3f3asm24281056f8f.3.2026.08.31.10.39.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 10:39:45 -0700 (PDT)
From: Georgios Karantzas <gck.kara@gmail.com>
To: toke@toke.dk
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Georgios Karantzas <gck.kara@gmail.com>
Subject: [PATCH] wifi: ath9k_htc: bound TX aggregation to MAX_TX_BUF_SIZE
Date: Mon, 31 Aug 2026 20:39:31 +0300
Message-ID: <20260831173931.1672-1-gck.kara@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

__hif_usb_tx() dequeues up to MAX_TX_AGGR_NUM (20) frames into a single tx_buf of MAX_TX_BUF_SIZE (32768) bytes, limiting the batch by record count but never by cumulative byte length.

With large frames (MTU 2304), 20 aggregated frames of 2292 bytes each exceed the allocation (20 * 2296 = 45920 bytes), so the memcpy() in the loop writes up to 13152 bytes past tx_buf->buf before usb_submit_urb().

Peek the queue head and stop before copying any record that would cross MAX_TX_BUF_SIZE, then dispatch the current batch. Leftover skbs remain queued and are drained on the next URB completion.

Signed-off-by: Georgios Karantzas <gck.kara@gmail.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c | 29 +++++++++++++-----------
 1 file changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 0a3d2190b..3e9d0c59b 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -328,32 +328,35 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 	tx_skb_cnt = min_t(u16, hif_dev->tx.tx_skb_cnt, MAX_TX_AGGR_NUM);
 
 	for (i = 0; i < tx_skb_cnt; i++) {
-		nskb = __skb_dequeue(&hif_dev->tx.tx_skb_queue);
+		nskb = skb_peek(&hif_dev->tx.tx_skb_queue);
+		if (!nskb)
+			break;
 
-		/* Should never be NULL */
-		BUG_ON(!nskb);
+		if (tx_buf->offset + nskb->len + 4 > MAX_TX_BUF_SIZE)
+			break;
 
+		nskb = __skb_dequeue(&hif_dev->tx.tx_skb_queue);
 		hif_dev->tx.tx_skb_cnt--;
 
-		buf = tx_buf->buf;
-		buf += tx_buf->offset;
+		buf = tx_buf->buf + tx_buf->offset;
 		hdr = (__le16 *)buf;
 		*hdr++ = cpu_to_le16(nskb->len);
 		*hdr++ = cpu_to_le16(ATH_USB_TX_STREAM_MODE_TAG);
-		buf += 4;
-		memcpy(buf, nskb->data, nskb->len);
-		tx_buf->len = nskb->len + 4;
-
-		if (i < (tx_skb_cnt - 1))
-			tx_buf->offset += (((tx_buf->len - 1) / 4) + 1) * 4;
+		memcpy(buf + 4, nskb->data, nskb->len);
 
-		if (i == (tx_skb_cnt - 1))
-			tx_buf->len += tx_buf->offset;
+		tx_buf->len = tx_buf->offset + nskb->len + 4;
+		tx_buf->offset += (((tx_buf->len - 1) / 4) + 1) * 4;
 
 		__skb_queue_tail(&tx_buf->skb_queue, nskb);
 		TX_STAT_INC(hif_dev, skb_queued);
 	}
 
+	if (!i) {
+		list_move_tail(&tx_buf->list, &hif_dev->tx.tx_buf);
+		hif_dev->tx.tx_buf_cnt++;
+		return 0;
+	}
+
 	usb_fill_bulk_urb(tx_buf->urb, hif_dev->udev,
 			  usb_sndbulkpipe(hif_dev->udev, USB_WLAN_TX_PIPE),
 			  tx_buf->buf, tx_buf->len,
-- 
2.47.3

