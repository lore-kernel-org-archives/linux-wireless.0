Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C0D448CF9
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 16:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785428507; cv=none; b=b45xJJ+M+fIycP0ylLy3noFtB5bPJmJHWQzfgI6WxyvMJrXZ9OhruGKypR/+xTVj3bGjcLjUnGwgijUzTQZ832smvgCoxQuUGkDoFfuFz6TZz70ajxbW+u4d00gOuU6tJfXNcDJ86IAY0fSES7Ls2JHSrb/2DyJAOrx5lz4W608=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785428507; c=relaxed/simple;
	bh=Hdwf42WICGC+EP1O8Z+0XvId2aI97zszyMJuW5ia80Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hl8rkmUT0iVDIH8iGZjyW2nnzwHUbEgClcAhsT2sn6QBEAe25OTMsLT8s2K/iLVRMggs44mh7eoiQ8Dlu2oj0NC99SyqNfQfGCMoqznL4Ip4DzOOUDlezUVAn0OySgHLdzcHPAIv8v5zeOVVhpGuKXmqsExueKwTWVgg1dtCYOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EX66aCNw; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EX66aCNw"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-84e252fbb7bso8682b3a.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 09:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785428505; x=1786033305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yd5GnMV4YHUFaBqZ8HhG5oCdvPmPlqZROl7g2jgvDNU=;
        b=EX66aCNwRqYT6TFJGmBEZp9ZvfTZGKa3fl6cfr3IMViwe2CYvMkywOstQSq8EzY1dJ
         oQXcCMYgdqqGQxV5ILXzyNlXv7zw0Y8uIT4YE7b2X8mq3dxLVpzw0pBEH5H3cJbe0e1y
         BlQW7UPAf8lUYKAytjIpuTKK/dOFEdW4TDXEJc8NDs9U2uuQtid7Rm5bdZ9EMyA+1onx
         shUcqMwFUgiBV6LuyE7GvD0Jtrhp3cdxh33GOL+ToNN24zYnVwr4evWoLowR7wsJM7RQ
         Bj5LAsx98V9yvlpNp3fk5HDT7SHPUm75JETjWPHI5TIwucCTFwFenPg3tbWUCQgzwRxQ
         5GbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785428505; x=1786033305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yd5GnMV4YHUFaBqZ8HhG5oCdvPmPlqZROl7g2jgvDNU=;
        b=DrQqcTI2BRgqEyjWXB5hD04He/Ek1qK2uFIt+0xufzlwhu+lU25hkULPyzknjc21F7
         pK/ptxBYfE/juUYP9iX6ZxdhIwJXULcOfn3rYBrUHz75KmlYW9fIGB9rhVF1swJ47e6E
         oBJS9Blsdcm/XB/lVEfvthFDjMK/SHrWOUxgWPiB8tBiqnY23EFB6BmrcsmLbcP5Qtvu
         QP2ZqtaDr/Y1kkY3R1W6RyhAMlAdj1HBileNbKyeQvntG2Hm6qUPSLGBUlzGhxY5nPFc
         CqZHAXIxm26fHYD8buIcHpQjuQQnKbkfexsPaN3JGfUf1QCWbKAUkDP3NRrPIEX+YnOD
         L2oA==
X-Gm-Message-State: AOJu0YyFEtUnNUTJcF0BRK1JP/BRo+dAHCjfBmZ1WfLaWAZSXhUsQiL3
	UNTiAp1nrCyZUokoWKXtfUVbjg/1+/etR8DQXlKNZm+qX5qpjqAg9R3d
X-Gm-Gg: AR+sD1371487xoLzUb8eubh5vWkF+AfKbZbN0vyyTUkvpIL0KX0cFNksdw4WZM8N4rg
	RLzrvKNiI3LWfVcZ0OJMxaJKxJ2m9GWnpoOELZBtzZPYdkrGnJ7z/taZ2POL01/CT7/50b0/k+G
	DmeabmrvFgVY3WvT47dB+8TDtEwPpja9lsrwmNnFFRM6uFhrUpCut9E+cT4Z4PPG565w4QlhDzC
	nXSVXXT08OLBIYypCvb7aALTBGDQV5D7Fi5uADO5xS/UhxuxZjMhHegLT/876OR+QtKJAukGA7B
	AX4vPJx7tpwoaR23jcESrMQcBwIZKcfBdOotJyYu6SZnBCVLtlz/k0Q25B91vi3O2HVP1Z8jgwJ
	vSbIV7WMi1nrcAqzbflOixTf9OvvzMTSWivruZPf+M2kGnJyb85bDGMbkMFw1f2o86YmEoE8KtO
	sdKqnHQ2XnsXUYeSAgf0wjwnuj/YlCFK1rhgo/V3JpQGLKkQNh1mBLhLDwHkHg+yG6zgrfbHLyG
	sI=
X-Received: by 2002:a17:90b:3c50:b0:38e:549:9e04 with SMTP id 98e67ed59e1d1-38fa7f28d64mr892779a91.1.1785428504732;
        Thu, 30 Jul 2026 09:21:44 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-13e7275973dsm19964269c88.15.2026.07.30.09.21.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 09:21:44 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v2 2/8] wifi: brcmfmac: sdio: coalesce host locks in rx path
Date: Thu, 30 Jul 2026 16:21:05 +0000
Message-ID: <20260730162135.12278-2-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260730162135.12278-1-shivesh@example.com>
References: <20260730162135.12278-1-shivesh@example.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Shivesh <chanelshivesh@gmail.com>

Tightens host claim scope to only cover hdparse calls, avoiding
unnecessary blocking during skb manipulation.

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

