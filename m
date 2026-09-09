Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C69396D14
	for <linux-wireless@vger.kernel.org>; Wed,  9 Sep 2026 18:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788980381; cv=none; b=O5e++jMIj8F0H3XJhfXUxz3/3HvB7YZ+Wg4KHlE7nQ4RY8FoC243/3r5tK8SERnk3tO8Uwi5avFZwP2Tzm4dN2f1arSpadVUYIGbmAcpJ0C0PKaD1di/eALYv+u/tj6vWCAgga0Vx2alrYYbl6TKd4zchYUE+uQbU8neSfL0ctw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788980381; c=relaxed/simple;
	bh=A3bchGY+kz0lZgkCyyDioMWnheewJPx79xZCrOEZtsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4ocFMvWqdbWwSF1dN2RuV9hnrvkI8F5d6dH5Nyg8FqYdhDNrsBN5PxYmq0u1RY8eJC0tsW+2w1YSSVB7V7ho+QDeO9Cgd4RQ8FNB4JavdzMIxOWN8SSqqgR3BXq6pH+kRbGsfKT5O5rMeTmshwHRMTwJ0TJsMZMkA5WYdln9tQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eWpDceV6; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eWpDceV6"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49b94fce6e8so5228935e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 09 Sep 2026 11:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788980378; x=1789585178; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EW3QQwRMlnzoZrrbBdGZDRMb7oY2hJNihqkm8pyQ76g=;
        b=eWpDceV6uCT7HpUl+xI5a4uSGu5oTiaYbPLR8dRV/RPKbKnlzehrZ4GR9Ul288avwX
         1wiWRbXP9eQI6PZNClThF/nLak5AFnJ2Vjf2pw8nwT09/J+B2xj7FaiLcU9Pns3TKER5
         Dsa8/DFaaKjq1Uzv++n3Hi1bxA4wfVsx5Rsy2ukniR8i0r/fo/SWBNsVtI+1C3tJF3d7
         U9WmGp02X/jXd4vjqf1Op5EA5jKp00SwdxQTBiu/Lq9b9FKrTuLsQ+affGHY2FcwYVBC
         u0GeuWB/KLALqZwY8wzxszsCCQRtIInZXUMfZX0k7i02N+bwgXOndOVQgu2kGU2YZC6x
         US0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788980378; x=1789585178;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=EW3QQwRMlnzoZrrbBdGZDRMb7oY2hJNihqkm8pyQ76g=;
        b=rh+erHm0U9U6oe+du7tqSI+wJHSvNlch8+I7iFhH0+FlXVFu0Yi4JKDgGlLYYqlbEp
         aDGm2euAZtlKp2padqmkd82ttLNtBbPhIbFIMjE2kMwh/78dhTLuPn3lqqqlDfGTfQrW
         RLWwM7GPPho5Y8d/DPcw4oa6jCtDOC7IZq4dDUYD0ckZjE50nDRthAj1sMH+zAK8vuxr
         TBj2DgaelqbWTIXslKHGUpab9d0C0QakziA3Gi8gqWv1jGUTIyp2dS74WSe6SEXZZ8FY
         uyozM2mVYQnxbrU9JD6oIR4NXGW02oXVMS98sttJWOQeMI6pCuDbofQDBq7HG7jJOmdF
         DEIg==
X-Gm-Message-State: AFuF++lTRJmnjI4kkyQ/7kCw/SOGmXg8K9Xx8osP3u1HtTs7PSFC7Flz
	P+Kd1S1EUszQuyhWtkI5ERyh8mO0lyuYDCQH5STMPnjTpTKAgRM0uGop0jcbV4GD
X-Gm-Gg: AYBFou06/xBrDIbJbDYwiBJP50qFmh9Rs2ZYSO4CLEMdGmRZIbqcneSd+euSzPGl5/l
	EGPQ3gCXm9ltu+YmTMChnUB1SYnrPgOX9X3fNRZvWcf8kUzVzh7gmm72DH+geGLpxXdMbOpzR3J
	ywVAR85GUNeWXp1B/D7QqFduZBKt8uCXHNNs1EO7u1lp48RQSP9CllcCve6otQ6gfcGALxP37jO
	RvDhYxsKyoHribia7k4i+HPha+KLg7qtUtwVDwklAj/kpeAI6UkrRcPPB8FALO2FcTxip1tHuq3
	nEIjS8leJYjns9kux3PVyT+Wfc0eso+sSS/zXUvdl020lL6lLbzGCrC/geESgFWdxnFs1CGtJuZ
	7yKDtQ47swQ96xCJYbKyoRm2rU6pNIgILUw/32nBjeYSIass7kcHyuekIpCCWDTCqmvOYPX1BxX
	hzIHmVwVXAy5ndP9umpMn4yxVYSYJenE8LlVZeRSKt5M8u2ruWHf6+rFApc+VYzKdtWaNt2qSsV
	msoM0JxwL0kw9zHRncLXQ59nrw+Kg==
X-Received: by 2002:a05:600c:4f44:b0:49d:e0c:e55e with SMTP id 5b1f17b1804b1-49d25914e45mr27116285e9.23.1788980377829;
        Wed, 09 Sep 2026 11:59:37 -0700 (PDT)
Received: from gkaran.home ([2a02:587:4e00:af00:4405:590b:435f:6c05])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c38e3asm11305025e9.9.2026.09.09.11.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2026 11:59:37 -0700 (PDT)
From: Georgios Karantzas <gck.kara@gmail.com>
To: toke@toke.dk
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Georgios Karantzas <gck.kara@gmail.com>
Subject: [PATCH v2] wifi: ath9k_htc: bound TX aggregation to MAX_TX_BUF_SIZE
Date: Wed,  9 Sep 2026 21:59:21 +0300
Message-ID: <20260909185921.1757-1-gck.kara@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260831173931.1672-1-gck.kara@gmail.com>
References: <20260831173931.1672-1-gck.kara@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Bound the TX batch by cumulative byte length, not just record count.

Fixes: fb9987d0f748c983 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Georgios Karantzas <gck.kara@gmail.com>
---
v2:
- 72-col wrap + Fixes: tag.
- Accounting kept: deferred len += offset never fires on early break.
- (!i) guard dropped per review.

 drivers/net/wireless/ath/ath9k/hif_usb.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 0a3d2190b..533e74565 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -328,11 +328,14 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
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
 
 		buf = tx_buf->buf;
@@ -342,13 +345,8 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 		*hdr++ = cpu_to_le16(ATH_USB_TX_STREAM_MODE_TAG);
 		buf += 4;
 		memcpy(buf, nskb->data, nskb->len);
-		tx_buf->len = nskb->len + 4;
-
-		if (i < (tx_skb_cnt - 1))
-			tx_buf->offset += (((tx_buf->len - 1) / 4) + 1) * 4;
-
-		if (i == (tx_skb_cnt - 1))
-			tx_buf->len += tx_buf->offset;
+		tx_buf->len = tx_buf->offset + nskb->len + 4;
+		tx_buf->offset += (((nskb->len + 3) / 4) + 1) * 4;
 
 		__skb_queue_tail(&tx_buf->skb_queue, nskb);
 		TX_STAT_INC(hif_dev, skb_queued);
-- 
2.47.3

