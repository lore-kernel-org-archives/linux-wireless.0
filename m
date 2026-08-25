Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D37848F83B
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 23:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787699923; cv=none; b=NMvksz8wBsn42/uZFvg8qHc0DcKEhIXi0br/kptzNei/CmqZ5udPZLkbN/bADp4yk11Ns6aI4UL+gxL45XyewM95AMW+T6yDENi+QXvDzbhTJo6fdNaluQ+PJBOBijQeGWXs/3IcvxrP3MB95AfBzzL199dV3IsH7AsiZPkPpCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787699923; c=relaxed/simple;
	bh=ErR1b5AtCHEKNxWDQFJ1mgI8Ms2qVRSv8VmnA1X6Vak=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MKoUYpKJJvxlVHjmltDVGLuIwz07Osgrfqd7eg1iqV//8beeuNk9pswfcTfhUjFe3X4QT8SucO0Kk18aGwxX4bZ7Q8KuhbRniiRnO44S0JWVRwxococxT5dJhIvjBbhAO3ux81vn7mEMGzuMAJW41t8NiKGKOHVLojW2Ig+5OOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eDJJYEUb; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eDJJYEUb"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so2738955e9.0
        for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 16:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787699920; x=1788304720; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GBczmDlPDOyOE71lusigm64t9wOw32FOsTpylbADhJ8=;
        b=eDJJYEUb9uCReQP5Fz9/8UYQSDSSW8SvMn+Jrrtrfv59ZSY2G+6B+QO5bN9GSDBu9w
         6fVGU3et/EckxJwfa1Wz2we6Ew6CeF3iilpzQVnr09GydmrbAkPTmTX96ztNRvuNzYX3
         PE834/JmO6ig5ll3HYYQo+afKiNb6SuwOmtUfZnGsM6A03nqbdQ/cLYVudwI+4R8fKxo
         /QCRexMYvkwzhGBws844jwNRd+3+Fwp2ZEujSLI/mJlSnYYPYLHWxeCmywdSG1+EmTcF
         51XBNWA/dP4cTYMP6RUvg50DcEoP5GWBklJpXSQUG0Qf9ISqJ/CLAqnz+BhtjtT9yGzB
         M/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787699920; x=1788304720;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=GBczmDlPDOyOE71lusigm64t9wOw32FOsTpylbADhJ8=;
        b=JihHhlAIv34QsX6i3pOzr0MXhen0XB/ZjXBG0fYSv8V4/x4GElLdJhrNyQHfTww0GX
         FVNEUblIuM2K6GNmSlq3oIN8lLvzfl+4M+W4xL3A003ruMmG68PDV5/8EQrqPJWS43qp
         830C7U6nSdn800oomJKfCJpqQbj9mL6mFq7ufNGa6AK8xwrFGrWVe3PYS9TrZGVy2Fvb
         ySu4FTyWGrcnh5VU1pJ18Zv74atY2Fk6kHOWvcPjiSRIV5j3FVwSoi/FyICkQnVusZoQ
         azSHf8JllMdCc9vxB2XKbKZ151nCLpnoOyP1YeSn9EJ+K9sekQV1yW9MNX3bQeot8cmC
         xU8A==
X-Forwarded-Encrypted: i=1; AHgh+RqrPmRErkdSplIhijs4mVKhguPfZfySYwIbB25gzs9tM++cXX6io6U0y8X1PnUR4WgfL8gBehJmrDNFiK6kPA==@vger.kernel.org
X-Gm-Message-State: AFuF++lEdW9wRFd64P4mvd7NujZObSXVp+18rtuTuUG4S5ISylHHZu8A
	OpGScSvY1rUXoE1KKjxVbRLxGMcqDd7kIdkme2zHzaCfqRRJigm5pbDsMmoFQQ==
X-Gm-Gg: AR+sD13GkZRQ8vIQBT0Jh3WfnBQP35kV8EwnljPCja/8+opwwYc8rBabwlLPKNqOquQ
	6010V6eId5/QpRBxitPnVBVE5MPED6PVItGkPdCu2gJ2Y7vh8LGRk4CH5zwMzl0tDB8Ghxo6kND
	9ySHdCm+wohBKH0xhZ7/JtSjBjB2W5z/2mG7G5z3MVbiYMNLAPH/OeNU9482ugE4qN/bcjsxdJv
	HFtgtz1g4AJL90V2yzjVdRSYTuVxW/bgO0XEEhxg15YofPN4df85zPhJkY6Nhsp6yKkQeC11w7Z
	HmpYNyp+RQdYhZNAb+6S+kh6SB0QttTVVvSWBNK2iq6Bn1c224zFJWpeh70nxi7lAPixWKj5K9h
	VRaiqC7A0S5swji6WdN1rFHFW/AhYCD/b4TNovzP842D+JA8BlMDEw+KG8BgEhgOgNA/9pmx0D/
	BiCKPJgHcD0q7533cjZaaDgOMqXYFH6lULMygt7OJLGIw9De9GjlPrVU5tJj51DasHi+pGLKrPG
	aUm5KnlzWsz+H6CCgsW8BP1hKtd/1M76h1BoYQ0QGyH9Isw
X-Received: by 2002:a05:600c:c48e:b0:499:9240:9a1c with SMTP id 5b1f17b1804b1-499dc82ced5mr17382165e9.15.1787699920268;
        Tue, 25 Aug 2026 16:18:40 -0700 (PDT)
Received: from dohko.chello.ie (188-141-5-72.dynamic.upc.ie. [188.141.5.72])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482e279e8b7sm864017f8f.7.2026.08.25.16.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Aug 2026 16:18:38 -0700 (PDT)
From: David Carlier <devnexen@gmail.com>
To: Jeff Chen <jeff.chen_1@nxp.com>
Cc: Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	David Carlier <devnexen@gmail.com>
Subject: [PATCH wireless-next 1/2] wifi: nxpwifi: fix inverted check in Tx BA stream entry deletion
Date: Wed, 26 Aug 2026 00:17:09 +0100
Message-ID: <20260825231834.244783-2-devnexen@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825231834.244783-1-devnexen@gmail.com>
References: <20260825231834.244783-1-devnexen@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nxpwifi_is_tx_ba_stream_ptr_valid() returns true when the entry is still
linked, and every caller passes an entry that is on the list, so the early
return always fires and nothing is ever unlinked or freed. Entries leak on
every teardown and, since nxpwifi_space_avail_for_new_ba_stream() counts
them, Tx aggregation stops being negotiated once the stale count reaches
the maximum.

Changing the original dead && test to || to silence a NULL dereference
report inverted the validity test along with it.

Fixes: 00c786a7581e ("wifi: nxpwifi: fix multiple static analysis errors and warnings")
Assisted-by: Claude:claude-opus-5
Signed-off-by: David Carlier <devnexen@gmail.com>
---
 drivers/net/wireless/nxp/nxpwifi/11n.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/nxp/nxpwifi/11n.c b/drivers/net/wireless/nxp/nxpwifi/11n.c
index c2a54d781b42..25b2e430f3f9 100644
--- a/drivers/net/wireless/nxp/nxpwifi/11n.c
+++ b/drivers/net/wireless/nxp/nxpwifi/11n.c
@@ -451,7 +451,7 @@ void
 nxpwifi_11n_delete_tx_ba_stream_tbl_entry(struct nxpwifi_private *priv,
 					  struct nxpwifi_tx_ba_stream_tbl *tbl)
 {
-	if (!tbl || nxpwifi_is_tx_ba_stream_ptr_valid(priv, tbl))
+	if (!tbl || !nxpwifi_is_tx_ba_stream_ptr_valid(priv, tbl))
 		return;
 
 	nxpwifi_dbg(priv->adapter, INFO,
-- 
2.55.0

