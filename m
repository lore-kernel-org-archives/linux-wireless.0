Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A1744DB61
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427477; cv=none; b=cGzEdvrPzb7csJGpBTZ4x7r6g3aaYnIHYcXsezyEhNyyKKTnvDC4oBVM6fHbS0Zrp0jo/NSF7Y7aJtZA/LRIwvBEGpZG6iznaME2FYSScY4Vo7ZRweg5LcU3aToxJtxrY8F4Y0rnZ0KM4dFILNFrMY6Z6TiMv/gIWeHV9UAZQsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427477; c=relaxed/simple;
	bh=uVNCm45C3XC07WQGOTZjv70HxvVG+1BMzGP4bpvZu7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAkKaduhJGYAqMHvn+nQiTbo8k/1NkeS25+RqCeAmKkqHraPvt6ye1PNKEc7/zYtkt9Uj6HMRCAjTMavJtzQtDu5jEvxUoJecm9qksCngZ88xx5W+KFulq/TmC5+uwWHAnZ9vB7bo5JFCwaegrqxbQmMA74qjGR3uryMa0zCx4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=agxZKEzL; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="agxZKEzL"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-381f03d7be0so5180a91.1
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:04:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785427475; x=1786032275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TERzNlpS66WxjkUnYI6cB5mJn+bQoDdEk70EG74DgeM=;
        b=agxZKEzLquu4KYN/9u43ywzNKUwpBQhUaWZCxvJKf6VImeX5g3gZwd4dhRxSJDX4Ip
         b3E3Eup5TQMurRRHxMsqox51RBEIf3VcPuUhAyul5MXhnA83nCvE2KJQLi8YBtEnLGCW
         OZ5ZWW8qLBC6tI683NDuqMa09Otd1GceDkWSM43GuzP6+7ihJnmkdaUk70l/wEZNjpvs
         GtxkqMX2p/a1j/4JXDgK76mGm+rc7Yw433OYJcL1vWVMLT/xk6vaLY1R5EAI5ltn8gV3
         NxxK+Qy8+ZYhpa0uWPw6hEy6J/Y5ioRArq/EKL/lh5Zz9nTBoUYKClAeZXh8sE6lLadD
         x1aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785427475; x=1786032275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TERzNlpS66WxjkUnYI6cB5mJn+bQoDdEk70EG74DgeM=;
        b=cQfFEOGNZ/z/FnDqCirDdDQN407EYHl7ps8uqbKyszARZ6ggl0c4af+6xnYeJIGpvJ
         q8oG590XLFY+gYRMdWG7ovD48ZpqQt6CyEm4suX8QWjxeChEvoq3C75DXbjREj4cb+WI
         4IyNuxhKPRYQ2CG4N4mLadxKAtObH8kKy3HQvbn2V/ZNzcFTfqrLjMXMXmfME5B/y4tF
         AT0+ySzc4P8wxkrGVAgwC0/Buni1SyGGrrqCxqvusaQLGZxHVYkPn/HUYu5qpPVSC5xh
         LVXsHiRoVCCL3SqAGOUqPbUypmCBFH8gDiyA5CqcyzoiVa3CxWV8hKQ41FbzSuXHRMGh
         JmwA==
X-Gm-Message-State: AOJu0Yw15aIspU+b7GRonibgtDEozhry2zyMjuoCdxYLXX/rUbyNo81X
	2Z8/jonm7b+1MiAtWm6MmgQT5kEKu6zK3bIkJo7yqmzZ1y+ful5kwcheU7RtX8+apuM=
X-Gm-Gg: AR+sD10lNyynpGiimDrkoz2wGk2h5BNbSTa1fyJopR089lMBsyyaNYcSCCo68erBgEY
	9IC/hGRiYII6Bp52bfUn50SClJ6laRAOMJGVSVGyjXURh/oppgFZ/19kElhnBCrv0Bs/ofnhnw4
	PMrPQKl/ksQi9TyEOTKHM6jI3H+Bu5gA8drvJvB7xq/vrP0LmqM9ji2gSWQ+h0QjcTeeTpYXhnN
	wXLnt+9hlMg5WTcdDfS4SXt/yWxJ+KFn9v7RRipcpWLlS4OE3broHaPvJscdSxSvZpuN1YdZPNT
	WvtM44OYh5OJdeBThHjk2BCnMANnVGZ103VTmgv55YyM3glO/VzdBIdOBsxOWTOFoaZgKytPy3F
	t4b9P4MQbnnc+Q88fUDwb/QwvVhLuAI4x83sXQ7nseJehMAdzlHFuHHFOrzCjT9PVzLB3mqRvFi
	r5m3CjxZDWUwW2BsBOmvAQth4i2g2I2q9K9ZtUehpXft4kw9mHvvkmLYt1DJvyZz5oLu9yIsXKt
	Ns=
X-Received: by 2002:a17:90b:274d:b0:37f:eda5:516f with SMTP id 98e67ed59e1d1-38fa7c68cf5mr872384a91.0.1785427474684;
        Thu, 30 Jul 2026 09:04:34 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e72643a12sm35012783c88.5.2026.07.30.09.04.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:04:34 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <shivesh@example.com>
Subject: [PATCH 2/8] wifi: brcmfmac: sdio: coalesce host locks in rx path
Date: Thu, 30 Jul 2026 16:03:50 +0000
Message-ID: <20260730160425.11933-2-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730160425.11933-1-shivesh@example.com>
References: <20260730160425.11933-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Tightens host claim scope to only cover hdparse calls, avoiding
unnecessary blocking during skb manipulation.

Signed-off-by: Shivesh <shivesh@example.com>
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

