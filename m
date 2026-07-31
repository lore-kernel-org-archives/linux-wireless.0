Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF594483A6
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 16:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785514020; cv=none; b=fL5a57PdW3IwZeIoVUmpszlgbpXYihf2YV/UNps6Gt4haELEe6jLakJJ1t7bYToahr9k2swfPh5sQpqTUeHYJUW8uvZUfJT0n8kqxjAn4kpDhKcTcq9q0xaWwvc1c8JVEL62XcOeHdvNAY5yLlKAbH4Xccbz1wxLHd/ArtXpbDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785514020; c=relaxed/simple;
	bh=4FmlVouAtetaruhEeiTx3rFln8aYqYjfQLfKSbIJZ0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OXFcJlIHYVP/c0zQY0U3YTWiza78hZj0qv1MO4W9WC2yEiismLoUc/E/3n4EiFi6MyeCc4zsp9v8UkWiFchruvrU6gfrXRbnY+QdOqkSpFNpqpC2Vz7gpNXWOeOeyX4tx9onmVZHu8/jRvXAEuEXOXkr7N+ZmZOXfXEhqdc5k0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WiqA4vVN; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WiqA4vVN"
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2cf110997efso1864945ad.2
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:06:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785514018; x=1786118818; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n3oPX3E5KdsQaVYxU5lL3g8H/Q6QDbI99g6kazkV/Ds=;
        b=WiqA4vVNqe2GY9QYH0zJGVeTsOQ+yjEs7w87vp6h8mAW+PUvW9bG8cYJ3nUZ7QltNA
         28RK2rHWwpcuggGRA4ALFXsPoKPaJubH2hDxAbsqVAEmGuEYU8ziYwRAnXis+B4hJgWk
         I2qfgLbxN03MFjIkMP4BZr89rj2N1kNTqCovvVKVFG2cPFY3Y7BlCw/OPFeEnuxPN+m2
         gFhBcA7aZWOhsU91WT9b7LNRO684QoM2XJR/IwafuAe7I9lyK4j+wpTetqrisU6IAp3v
         0bqIoluUQeCiFriM7FHubUf8Ycr9XOxs2mAlGM3uKr4XyvV+nGLrzaXLJTgkYyvbIEYp
         Kzrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785514018; x=1786118818;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n3oPX3E5KdsQaVYxU5lL3g8H/Q6QDbI99g6kazkV/Ds=;
        b=g/LWrbSstCmqjeAcqu3oxNgFIeVrZ4RbKF7Eawb4f9gdJh8SAAuFaRGnW+BhpS5SGZ
         kJCqULpgqsqRMuSUeVRh4ruPQ/z071o9Ep43jRUBkdzOIZ6peKUmqmtzMQuEIFXa3Au/
         SRLHASbYYJtLeR1d34nCCSHz6lRGd3Jlo1D5sjB3PvjymiMia6e2EEGJLRpIrG9IlxMx
         xQbWahe/tmSXhWkjT1HHlI5gUbBfAVQdHoMxABoUmBVe0V2nkTa7I6hwIeLwhe/EsXUC
         JucSlD3310aSPye3x7va8Ta9NwjbIIRZHVWMYJ5tyDSY8IoQdKTIM/VW/PXT4BKwy1N2
         OYDQ==
X-Gm-Message-State: AOJu0Ywz13BGc1FwjtsEeCjR/8KmhVydoLGtDoTuYD9Tdgzdk3z8g1Sy
	eH00Q6XM381o/SxN2uWWGgP4bzUhuh5qMj/3nzVRgA+39+93VT+50bI8
X-Gm-Gg: AR+sD128GqZKzQox1Ra4nu45eVRhWhP6I2Ak37t8WLr7+VCsDOM8wN7qzQacbGyPnG3
	8/vuHhKRhEzqoXgtJywT9QSDtB3T7GpUPHT+y/dr0wH7bIBzw2rN3y6WjRwq88BQg1GyeDby7EN
	48R+ACcandUF+VxJ+jheZqWoPZZwj9/azgZq3MCnabQyM0SFR3T/USxiRN2g2i2XGrVeWIW6zP+
	8CLVzI5eXX2TXq9XhzvEEdHiBonPzNVVnFBdU6VwYEYSIJOuaCzu41+V0rkP6cTCD5EIJ6pntjK
	D04yaitIHctJphXy1KbJJrpJxKqTAvVqrjk+1sbHaB0rFd1vnEIR7qaBhMUIoZVSf+3u+mzSLJ4
	FNsgcCzRjmVWEbWCa8sb1kWnRG6mN8OVsQHZOWCl3YlTbiQzgNkjKuoVDK+hZnvQhIv25jp5QtK
	eAoPxNBldpfuiQ8Ujy0s96/l7Dr9dQ/2KIryveDn6YKqOliBI6Hi9r6YnQt7wHUdgB0bdJRxRAn
	+wf0ZhQ
X-Received: by 2002:a17:903:3c23:b0:2d0:2741:f31b with SMTP id d9443c01a7336-2d0523fc4ecmr8448685ad.4.1785514017961;
        Fri, 31 Jul 2026 09:06:57 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9c93dsm7881425eec.8.2026.07.31.09.06.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 09:06:57 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v4 2/8] wifi: brcmfmac: sdio: coalesce sdio_claim_host calls in rxglom path
Date: Fri, 31 Jul 2026 16:06:19 +0000
Message-ID: <20260731160646.3812-3-chanelshivesh@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731160646.3812-1-chanelshivesh@gmail.com>
References: <20260731160646.3812-1-chanelshivesh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

brcmf_sdio_rxglom() performs one sdio_claim_host()/sdio_release_host()
pair for the superframe header parse and then one additional pair for
every subframe header parse. For a superframe containing N subframes
this means N+1 mutex lock/unlock round-trips on the hot RX path.

Group all header parse calls — superframe and all subframes — under a
single claim/release pair. The host is still released before the
subsequent pure host-memory processing (skb_pull, len_nxtfrm update),
keeping the hold time as short as possible. The error path (rxfail)
also executes while the host is claimed, which is required because
brcmf_sdio_rxfail() writes SDIO Func1 registers.

Signed-off-by: Shivesh <chanelshivesh@gmail.com>
---
 .../broadcom/brcm80211/brcmfmac/sdio.c        | 62 ++++++++++++-------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index b725c64e5b5c..4e414403d747 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -1645,37 +1645,43 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 
 		rd_new.seq_num = rxseq;
 		rd_new.len = dlen;
+
+		/*
+		 * Claim the host once for the entire header-parsing phase.
+		 *
+		 * brcmf_sdio_hdparse() operates on data already in host
+		 * memory, but may call brcmf_sdio_rxfail() on error, which
+		 * writes SDIO Func1 registers and therefore requires the
+		 * host to be claimed.
+		 *
+		 * skb_pull() and the num counter are pure host-memory
+		 * operations; keep them outside the lock to minimise the
+		 * hold time.  Both hdparse calls (superframe header and
+		 * each subframe header) are grouped under a single claim/
+		 * release, replacing the original N+1 separate pairs.
+		 */
 		sdio_claim_host(bus->sdiodev->func1);
 		errcode = brcmf_sdio_hdparse(bus, pfirst->data, &rd_new,
 					     BRCMF_SDIO_FT_SUPER);
-		sdio_release_host(bus->sdiodev->func1);
-		bus->cur_read.len = rd_new.len_nxtfrm << 4;
-
-		/* Remove superframe header, remember offset */
-		skb_pull(pfirst, rd_new.dat_offset);
-		num = 0;
-
-		/* Validate all the subframe headers */
-		skb_queue_walk(&bus->glom, pnext) {
-			/* leave when invalid subframe is found */
-			if (errcode)
-				break;
 
-			rd_new.len = pnext->len;
-			rd_new.seq_num = rxseq++;
-			sdio_claim_host(bus->sdiodev->func1);
-			errcode = brcmf_sdio_hdparse(bus, pnext->data, &rd_new,
-						     BRCMF_SDIO_FT_SUB);
-			sdio_release_host(bus->sdiodev->func1);
-			brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
-					   pnext->data, 32, "subframe:\n");
-
-			num++;
+		/* Validate all the subframe headers while host is claimed */
+		if (!errcode) {
+			skb_queue_walk(&bus->glom, pnext) {
+				rd_new.len = pnext->len;
+				rd_new.seq_num = rxseq++;
+				errcode = brcmf_sdio_hdparse(bus, pnext->data,
+							     &rd_new,
+							     BRCMF_SDIO_FT_SUB);
+				brcmf_dbg_hex_dump(BRCMF_GLOM_ON(),
+						   pnext->data, 32,
+						   "subframe:\n");
+				if (errcode)
+					break;
+			}
 		}
 
 		if (errcode) {
-			/* Terminate frame on error */
-			sdio_claim_host(bus->sdiodev->func1);
+			/* Terminate frame on error, still holding the host */
 			brcmf_sdio_rxfail(bus, true, false);
 			bus->sdcnt.rxglomfail++;
 			brcmf_sdio_free_glom(bus);
@@ -1683,6 +1689,14 @@ static u8 brcmf_sdio_rxglom(struct brcmf_sdio *bus, u8 rxseq)
 			bus->cur_read.len = 0;
 			return 0;
 		}
+		sdio_release_host(bus->sdiodev->func1);
+
+		/* Host released; now do the pure-memory bookkeeping */
+		bus->cur_read.len = rd_new.len_nxtfrm << 4;
+
+		/* Remove superframe header, remember offset */
+		skb_pull(pfirst, rd_new.dat_offset);
+		num = 0;
 
 		/* Basic SD framing looks ok - process each packet (header) */
 
-- 
2.53.0

