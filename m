Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C051445AC8
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 15:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785512961; cv=none; b=aBTau/hTjrmBD1uOrygFd9OsU6NiIbL7nuuDpUVSN9hCDUVeom5FR2FJ+aWXOk5c1cvwYfzFqarow2y9rOsIJgvvff8tbl2d2SeomQ5HCCfOObzofrWOHeEQxWOTXvDMcAQSHZdvT6L+paVgE+ifFy4014YC8wckrCZfPWnkL2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785512961; c=relaxed/simple;
	bh=Hdwf42WICGC+EP1O8Z+0XvId2aI97zszyMJuW5ia80Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sl3XBBAlFQhwUdmh3K4TcR5xgNzZUmoP7KBwU/q8Eag684pwiIg9gsv4YWmixVqFYcWagFMISc2tebz0MBEry4pG+7gwJUDpBlt0Ey1YrU/iAJhK8Ws1fyDftpFiy43gRfCg/W+Zf/GDm17q7GEBd/DTrg54hV1SiawuXVA8zmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hu7N43oO; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hu7N43oO"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-38115bbb83dso48195a91.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 08:49:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785512957; x=1786117757; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Yd5GnMV4YHUFaBqZ8HhG5oCdvPmPlqZROl7g2jgvDNU=;
        b=hu7N43oOHywUrYD5V1txp1cXwrIh1KBK3kpKx7sc+mABg+SA7wktTYlCIrfx7G2N7u
         HN7KeDNU9/IJ656K3zcIT6/Zhy0rGglI2BbtpBW4cv5nODURV5gcImsQVenVbUlOxAYj
         ZE1POo4DPYXVAk41ww12RLBeqRaijq6nMhj4U/Sx0GpTsRJii6WtjdYeCcWKxwt8vK49
         E3R7JHk0piJKm0S/1SQWtpXokVWVFtxACktpFDhX5F90m/lXw2Qul8M2Dp5tZ66sGkUn
         41AQUrzwMJSBrEz946fF+wRJI0yffd6N5XpRlNCSERgcRYdYSSWWM06yDViZ6bkXt2dL
         ka0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785512957; x=1786117757;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Yd5GnMV4YHUFaBqZ8HhG5oCdvPmPlqZROl7g2jgvDNU=;
        b=mR78zX3mDwhsytnrS4+Aj2jhaud2DsYSt1zxBavKT9xrRyl5mi7Kvkrj6ZlH1/YcEd
         h3NyWrDMJO1Ks2T7qgn5CwBNQWxGpEinjCbhJfEKAdR1y8Mjna9mH6+iy0Ur5L7HkTEC
         DFuH7UY5ZwipFRYUcwvWjTCDy7v1LqT8ZYL9IkTRQ9tQEe7yjKl3RGTcfaC1WFs/saBc
         uMaG4l+nyw3a6gkhT6q55BCncbrjofSyGzxVncT9JcJknojsuLG/LFuVEP8iQyUGrTOy
         NIsSURJWPYhAbC/Lg/m8dP3+1/GMEh4QsylD+RrfdnPWG4aQvLh27g+7M/GL2Pxr7Evr
         jj/A==
X-Gm-Message-State: AOJu0Yz0tFJ+NHEtQ/K5rRGLXmGrACWkf6sUDzeIhkKg9BtW1AKjZJw9
	ZGGSDRNtNE+HYIS6c5ZHWQQYCHFeBKuEMqGec2VDOmyJuZxz7VTkEJvczX2rgGRHyQg=
X-Gm-Gg: AR+sD10yTc/AQxKFgkJct7Gj+CHCS5MWtDIqjwGVnYFQabFREo2Gr+S2I/cHs2omS9h
	VZ1VhuBMeORNTwZaYMeVymcKajQsV9emKLhLdYl8VX6jC3HaehiZ5hKv2SrXOUmcPqn1QY76Mon
	8QnB+0H9Ubprpyh1q3XFZ7NlO0evXgVQv97Xzg7aGc70f74vv7/CoKM2mELq5UbRjLXx8Kn7Jt0
	VkaDhDAa7NLLSkBoZvXY853E6G1Bbe0mYH+En1IjmCxAHvTGs8mUheHPuWeRLkrDOFB1SwJYZHk
	dmgQLgahQQuVsCN2bX/RDxPEbT8KrzLyri2/zHpM1/eFi09kKRci+QbF61S1EBSIxE0tZCuUF/Z
	03VmDbtNrdFVrWom0KefAi5XAmxe6q2YaXuSp2P/peok/BptXXJDKl2S5+Enp84W9JLz4NC8PGz
	yNGBPlyK/GLDkqJ1rJVzRTFwTPPJVvGF+N/O2NefplqgFEB0Q6VIqjFWdApJlxvIPVvquLXSBJZ
	zo=
X-Received: by 2002:a17:90b:520c:b0:38f:aa76:88b with SMTP id 98e67ed59e1d1-38fbc506f17mr523232a91.4.1785512956784;
        Fri, 31 Jul 2026 08:49:16 -0700 (PDT)
Received: from Potato.tail66a299.ts.net ([171.76.83.76])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153e045016sm11852510eec.19.2026.07.31.08.49.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 08:49:16 -0700 (PDT)
From: Shivesh <chanelshivesh@gmail.com>
X-Google-Original-From: Shivesh <shivesh@example.com>
To: arend.vanspriel@broadcom.com
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Shivesh <chanelshivesh@gmail.com>
Subject: [PATCH v3 2/8] wifi: brcmfmac: sdio: coalesce host locks in rx path
Date: Fri, 31 Jul 2026 15:48:34 +0000
Message-ID: <20260731154901.1822-3-shivesh@example.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731154901.1822-1-shivesh@example.com>
References: <20260731154901.1822-1-shivesh@example.com>
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

