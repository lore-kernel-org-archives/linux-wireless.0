Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792782418;
	b=qnFRbuU37udJs+BfADnFIbp6rNSSmR2TrE4t0nQYm9S7TqSNbF5mTETGbLl+iYKCjoFq
	 3OKJqKEM9Cjjf06g7hHsxTNLfhUKMhdmcFRENkYDBSR1U+1UVnShsUcyGrxOu8x1qE3p5
	 zU2g1CVuPdZzdyzHqMZdTtsVsgmf8lH0g8f3Vne6i8Q8EBGeitd44QmFTa4yIJN9hkpy+
	 benpqK3/qOqllP51oxG9HImj8KZwfbBv0mvQ9w1JAqFzOID7aXYyDofHVxPNtDpH+BjNN
	 y9/LPP9aVwh+ZL1gQdn3EbEt4MrCLIgTDf980vW4FmfqJEGUJwqwviAOPd+tK0aOAMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792782418;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=2+b6Xp2Wz758MZizwri4WwdSM0RQI5RuQjaDSiYF8TY=;
	b=5D5g7SKKrM7214EGWCLwD6rHUGQUkmS7ODSdSIb2LJG9y1beRWtHlCQJd6/77awlZVTV
	 CPZ7I7uGJsuvS4EJLcowKyGt64kZss+0IBI3O5U7xjakIdLN8ZhWEG8sGMgSPxS8QZyjJ
	 jmbgPEbdi8xFwCK0eM5CtIUZe4c0FPj0AWgViVR9Ud/wMwulJIyd9F/vWLy4NJYmDe/8D
	 p8laLsghpkTVH1Rqtyjwrn3m7ftG99HAD8rGgefGNoGDVt6Qv+dfruw0R27IVEahsEM18
	 3Gn58b/BHJQpkoVoJErcyyRi4LveoW19/KIZiKIZ53bbiRxd33EQEollrHVzG/X8CUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AtRBTfcB;
	arc=none smtp.remote-ip=74.125.82.173
Received: from mail-dy1-f173.google.com (mail-dy1-f173.google.com [74.125.82.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB03B606A31E
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 19:06:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB03B606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=AtRBTfcB
Received: by mail-dy1-f173.google.com with SMTP id 5a478bee46e88-3645f0f3fcdso2279153eec.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 12:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792782416; x=1793387216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2+b6Xp2Wz758MZizwri4WwdSM0RQI5RuQjaDSiYF8TY=;
        b=AtRBTfcBpGQKTHhI+7yJwLms5MHrNAf6xryGSXVZTgD8jxQB+9Ocoa+dVHY3vDnqTB
         0bUdU94gxHU07oU/rlwUMP/6/ybzvYgp/kqmxt5CLk4gbHLzXIFaiGywlVWAwnaWU2fk
         jZKaf2pZQuV195uqumrruJJ/UDfF9XYsvcWCYNBATVVfZ1ybMWOCAOUklDR+fS4YzV7R
         Cj7hSlHhc4GfWsyNqTUCaYQ2Xg8l9gFRBvYpxmZ/44agRx+2BC0oqdQOK2L0pXeF5K7h
         IVnw/9v+dB90P3JZfEea5110VUpEZ1gcMGRXomox5msJZEuDgxhZayl06Wh4geuOJJr6
         36ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792782416; x=1793387216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2+b6Xp2Wz758MZizwri4WwdSM0RQI5RuQjaDSiYF8TY=;
        b=HZ8ZrzOD9gUFp7fBA9Uc0MUUZjuF42eyr8FRmladYi421d3GMnmW2cxJ7N6o0T/xS9
         MnTRAhuoFSnMwkmyxD+XwryeePfwJN91FUX9SjmsZ2GJQluJhm5/FrsV2y3EHQeAF/xt
         iCCCyP1QessM7xIhYUx53v3OG71ReUpUI7+cE1lOLd1M9VYXY+hvJMLxfeJ7jjHkuhMN
         akjHRNmHLu8btEXhvuqZWE9/uRjHCNgIN8P75dkhJw8/nSAGmLeHKNl5fEtwcmLLyRIv
         VnpCIfLILKH2sZsopud+B1msPHY9R/CCvGjnUXL+9DmcdHaZy4HEBGA+B3GsWyQwUS7g
         nSJA==
X-Gm-Message-State: AFq9FYKXN7l8UcIa3O9sOwqBdwgw/S8x83P6ACChKRvVGqekhAepaV1W
	glWg5VSgAASFF9m/tKh/QvJYyatsGjlePLMQ87Vtm28AK1ODYfsaivZtjghpFnfD
X-Gm-Gg: AYBFou2NbTJEkbHTIHlsNWtJrA81A++e9La8zzjoT14tA8aolKSNd1tvcCrpJQxjrrq
	MyhhRQrc6AyWurq0Q12kjl9ykzDNUuZqa+Xric9N45woT33IMCF1pUWkJTz7jr1EKGdhqcDdh9G
	DbR5Y+2r/Fm/llQJ54/FCTkO80N6N+D9rug6PoGFqe0ocl7/qPCVLK/TFTyUp/Dplk2Wk5YwL9B
	Bn/OuhFsJvqDkdF8iMF4orkDVp1AWYakJkxzluUnpP8EDu7wghweS0cJL36zAW1y7GaDv55+e2Z
	e5hXt/I6ztzOFf/lD3L+miGzRIz0F9yZkpAJfGZ156JLJiXjVyXfZ5bfpaqSse6Zal0FBtSAyAn
	hOc7HxnDeYzt18KdCtkPhClOG6Sn5jdlikNIFrgm0GuvwbiWxZSJ458rEa91n2jiA+MW6Vj+ffz
	8HRn0yKAtabBHgNXMYlgrjjevSFIypFl7M981Id2FsAxRAu4cTuiUsFP1SC2UijJ5idi3YUMiAA
	pFbI7bjak+JU/vGPI4ypwIah/p64ivhg4Kv4bvmNs5k5E/bKBw3xxJU9FTV1hrts6FwGoNEYIE/
	UZORntfHDNdcKpj+OxZptAMwk+leL0qVf1c04UWCMByA3SnZD9X/R3nyb54iHw3CzOH5mC5mfQz
	v4CrZ06xQxCFXLTuhf+o7StROgoRc
X-Received: by 2002:a05:7300:8812:b0:368:8d1d:2a81 with SMTP id 5a478bee46e88-369e861b306mr278846eec.24.1792782415889;
        Fri, 23 Oct 2026 12:06:55 -0700 (PDT)
Received: from ryzen.lan ([2601:644:8000:37f::e34])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-369e8ec50bcsm209607eec.23.2026.10.23.12.06.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2026 12:06:55 -0700 (PDT)
From: Rosen Penev <rosenp@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>,
	b43-dev@lists.infradead.org (open list:B43 WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH wireless] wifi: b43: map the RX buffers DMA_BIDIRECTIONAL
Date: Fri, 23 Oct 2026 12:06:53 -0700
Message-ID: <20261023190653.70741-1-rosenp@gmail.com>
X-Mailer: git-send-email 2.56.0
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

b43 poisons each RX buffer before it hands it to the device, and drops
a buffer that still carries the poison, as the device sometimes skips
one. The RX buffers are mapped and synced DMA_FROM_DEVICE. On a
non-coherent CPU like the BCM4716 or the BCM4708, the map and the sync
for the device then only invalidate the cache, so the poison written
just before never reaches memory. A skipped buffer is read as whatever
the memory held before, for a recycled buffer the data of its previous
use: garbage frames, or a length that sends dma_rx() into its path for
frames spanning several buffers.

Map, sync and unmap the RX buffers DMA_BIDIRECTIONAL, so that the
poison is written back before the device gets the buffer.

Reported on a Netgear R6400 (BCM4708, BCM4331).

Fixes: cf68636a9773 ("b43: Refresh RX poison on buffer recycling")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
---
 drivers/net/wireless/broadcom/b43/dma.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wireless/broadcom/b43/dma.c
index 05da6987a845..c8585c6dff37 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -353,8 +353,14 @@ static inline
 		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
 					 buf, len, DMA_TO_DEVICE);
 	} else {
+		/*
+		 * Not DMA_FROM_DEVICE: on a non-coherent CPU, the map and
+		 * the sync for the device would then only invalidate the
+		 * cache, and the poison of b43_poison_rx_buffer() would
+		 * never reach memory.
+		 */
 		dmaaddr = dma_map_single(ring->dev->dev->dma_dev,
-					 buf, len, DMA_FROM_DEVICE);
+					 buf, len, DMA_BIDIRECTIONAL);
 	}
 
 	return dmaaddr;
@@ -369,7 +375,7 @@ static inline
 				 addr, len, DMA_TO_DEVICE);
 	} else {
 		dma_unmap_single(ring->dev->dev->dma_dev,
-				 addr, len, DMA_FROM_DEVICE);
+				 addr, len, DMA_BIDIRECTIONAL);
 	}
 }
 
@@ -379,7 +385,7 @@ static inline
 {
 	B43_WARN_ON(ring->tx);
 	dma_sync_single_for_cpu(ring->dev->dev->dma_dev,
-				    addr, len, DMA_FROM_DEVICE);
+				    addr, len, DMA_BIDIRECTIONAL);
 }
 
 static inline
@@ -388,7 +394,7 @@ static inline
 {
 	B43_WARN_ON(ring->tx);
 	dma_sync_single_for_device(ring->dev->dev->dma_dev,
-				   addr, len, DMA_FROM_DEVICE);
+				   addr, len, DMA_BIDIRECTIONAL);
 }
 
 static inline
-- 
2.56.0

