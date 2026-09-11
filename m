Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFFC7E792
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 00:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789085518; cv=none; b=B0RTDfsGbZaLNIm20x4Cn1aIC1tik/WpEUeUdKdX1Wd2eZZBZE35oiunQvUaAzuD23kw3Vjy4zBaOdmyFsmPHBtO0AysEMlefINMQKGYzLGXeExgfqtsLFfTzN7ZWI5OdKUevCytD5VSryRpYFD/bBBkjz4y0NZh5IhIkC27yyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789085518; c=relaxed/simple;
	bh=9yRqVCfzrThFpGKyi64B1I2+WAjltvBvnqANVP0OPds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=seXQU8Abf5+5N/FyKXHzzE2FnUhWUNcjoUvkPeIzUxxwsrWfSRY0UIrFD2jDs6i1Pcydo860qDg/m8Md5rIq1VDrdPohl8ySyd2e2bB5mXE79hyA/gqS3RwMCovtWi2a1Rrl2IgwVovfPG7S58YU8mZDtduuppZBydk0WEX0Djo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hCZGgYsJ; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hCZGgYsJ"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-48434392b02so212218f8f.3
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 17:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789085514; x=1789690314; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KTJNu1YPX2vLCmrNs6jfWs/CRP8DPC+3PSAyWrgC+k8=;
        b=hCZGgYsJ/V0CpMUr7SzpYeLFR7sHiPLaBi7rM8DZtHzMPQsWhO1ROgZPgYJ90LnCD7
         K+GKN88jW2ywYZXy1bwjL92tx4r+XAQxcCHO7x1rEcGml/rV9GkNUQnTYt9R/4y6ywm2
         2um5letJD+yr4eunmdKF3K+ExeiUV3IVJWXD7z8g8mSQfgtwZ0WiCIO9tl7JLPM1F+N/
         6oAqbu6ZmSv8E7XCJNQzXpBTXOoLVrub12ACwEe7eflqMia5Sjx4vPUvmK00pblKbXag
         IlW80WmsZrUGYPGMacjFxMbwP7Fg568x/UPs88pmjuKx5AOWuUQmmNq+7KdRFOQjmBzP
         8vqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789085514; x=1789690314;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=KTJNu1YPX2vLCmrNs6jfWs/CRP8DPC+3PSAyWrgC+k8=;
        b=H6DkNeI6BnIuM+FfHim1V7mH6EYmRmFyuU+cQpEDCPO4iDmQPi/R5qUvwtmfx1DTlt
         jWbjv0yI0ComjIbvvbUlZ2GeN1DEIRPv4NOmdiP4nhQ5ayIqrZIQMMft7guCxVDNuT/4
         WavkHfZxLD2Dj1U1z41HA1otYvDPO6iW2H3knEG7joBlFn0sKVH072tQcJi37HqgOgHe
         Ab+4OilmazM2q234NhIr9ymbzs5FhM0CZ8RHJh4wziY/aXHrODCTVUU47uvQ0ojDqtDX
         jTaMP2FBX/qz2BG2D/vCrtUqlGDDXdJtRFIX6Xf/J+nlc5AxX1NM4pFXXo333NxkZYMz
         EA2g==
X-Gm-Message-State: AFuF++lo2q0PeNUmrps51v2jLsBRkyEskNdTGkRapOK91xVncIscpo4R
	NNZ0zFSwrBqQvKup5Q9IJoCg2mzQZknF6F9Nh+Ia5YQKOBlJ8hTsULRX
X-Gm-Gg: AYBFou0gEV8z+2G4+vU43DBj/hHadpViIeqQoI6xTf1198pxWdWBFnuGWWewmyFr/Sv
	JshuXc1EXQh/C9cVJlRWNbJgR8Dao/hpOXadslrA9qCWkyt2UlohRLayfuhvg585s1En/n72Klp
	b47r80ocxaKs5b/Qv6UKOahpkPUp3YmFytg6LaeYFFugthkENKq9mSQsjJ4/C2uw3az37zmCbgC
	M6tdW1tqzw8j5hJBmedwOV1+6g604X23Cfa/e8lgM2vyWV2FGFSKINeOB3FU1ji/N8FHIc3VBsh
	Tr/WJCwPVB0pnwtC/IecVVX9UYNkpAmfWyV05k5IZGiSqnESJg7NRSMGhgHjO6lQTqxL27v6/a6
	LF7IDWadnici3iRNuY/BcJl6IJTspnxy9G/UVMY4C5HFQ6ZBj6/s0rvDxkOeslfqWOVBLCKrgEH
	GWbqA6jyOlJzdjp/6Nfn0X7UAQE4MGLylddo2e2f2C57dnN7tbaVxmVroBeQ49yJxXy+Pd01EfI
	vEeao2bnbhZcZsqhfsf1JBUoUiZow==
X-Received: by 2002:adf:fe90:0:b0:485:ac96:7272 with SMTP id ffacd0b85a97d-486eb32b0e5mr2462369f8f.19.1789085514192;
        Thu, 10 Sep 2026 17:11:54 -0700 (PDT)
Received: from gkaran.home ([2a02:587:4e00:af00:4405:590b:435f:6c05])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb33fc02sm1779641f8f.16.2026.09.10.17.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 17:11:53 -0700 (PDT)
From: Georgios Karantzas <gck.kara@gmail.com>
To: toke@toke.dk
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Georgios Karantzas <gck.kara@gmail.com>
Subject: [PATCH v3] wifi: ath9k_htc: bound TX aggregation to MAX_TX_BUF_SIZE
Date: Fri, 11 Sep 2026 03:11:43 +0300
Message-ID: <20260911001143.4507-1-gck.kara@gmail.com>
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

__hif_usb_tx() dequeues up to MAX_TX_AGGR_NUM (20) frames into a
single tx_buf of MAX_TX_BUF_SIZE (32768) bytes, limiting the batch
by record count but never by cumulative byte length.

With large frames (MTU 2304), 20 aggregated frames of 2292 bytes
each exceed the allocation (20 * 2296 = 45920 bytes), so the
memcpy() in the loop writes up to 13152 bytes past tx_buf->buf
before usb_submit_urb().

Peek the queue head and stop before copying any record that would
cross MAX_TX_BUF_SIZE, then dispatch the current batch. Leftover
skbs remain queued and are drained on the next URB completion.

The byte bound changes the loop's exit semantics: it can now exit
before i == tx_skb_cnt - 1. Stock only finalized tx_buf->len on
that last index (len += offset), so an early break would submit a
URB holding only the last record's length while every dequeued skb
is freed on completion, silently dropping frames. Make tx_buf->len
a running total and advance tx_buf->offset per record instead; the
stride round_up(nskb->len + 4, 4) is identical to the stock stride
when the loop runs to completion.

Tested on hardware with an MTU 2304 flood: the loop stops at
record 15 (len = 32144, offset = 32144, within 32768), no
oversized URB is submitted, and MTU 1500 pings pass 20/20.

Fixes: fb9987d0f748c983 ("ath9k_htc: Support for AR9271 chipset.")
Signed-off-by: Georgios Karantzas <gck.kara@gmail.com>
---
v3:
- Restore the full v1 commit message, wrapped at 72 columns.
- Explain the per-record len/offset accounting in the commit log.
- Use round_up() for the record stride and include <linux/math.h>.
v2:
- Add Fixes: tag.
- Keep immediate len/offset accounting (stock deferred
  len += offset never executes when the loop breaks early).
- Drop the buf/memcpy reshuffle and the (!i) guard.

 drivers/net/wireless/ath/ath9k/hif_usb.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 0a3d2190b..a398c9b2d 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -14,6 +14,7 @@
  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/math.h>
 #include <linux/unaligned.h>
 #include "htc.h"
 
@@ -328,11 +329,14 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
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
@@ -342,13 +346,8 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
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
+		tx_buf->offset += round_up(nskb->len + 4, 4);
 
 		__skb_queue_tail(&tx_buf->skb_queue, nskb);
 		TX_STAT_INC(hif_dev, skb_queued);
-- 
2.47.3

