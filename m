Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FF653E49F4
	for <linux-wireless@vger.kernel.org>; Tue,  4 Aug 2026 08:26:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785831996; cv=none; b=QgrlOuM/ftjtFa1oGJxZPkNYGI5LMA5yr215arNOj4Z2ToeEy/qRewOJQvpq4UfbL0umVS3XWrjW38Xyyjb/fUhazuDMZULn9a4nDErlr08FSqwzhMIdG+BgIjgVOGr1Y8PlKQm/JU+dF7HYIICfroFZ8wX7VlRCvXa7ybfIL/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785831996; c=relaxed/simple;
	bh=BQFteY2voHYMLFunRJz6Ll4QfFexNagrrLETSu9A++A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=a+oHBrk9WR4tYsqx06C0UszUiYy9K79D0FCUSCRvpsHmmpQY5j7phcs7LHMGpYDOOyrJ59GtKjh59N2GFZ98mB/WK5bxNtsQXYw/YSVetEVKJgpYk0gduKVTjIgnoYV/ncA3smStmgaMB478VSYtqfT6le4yOuLGLhEfjGNmkhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GrQm4wNf; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GrQm4wNf"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4954b3c5cbeso4321325e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 04 Aug 2026 01:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785831991; x=1786436791; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BgISVsIsIFnGhLp1EYAeC2svf5amhtNd1DkilnWeLAo=;
        b=GrQm4wNf8ao6NW+nQP9EpWQfiDuiUEVfVWLGxm3gNqOp4x4BRMxI79Rdt+/WqEf5ST
         E3BP1D4OSoe22NvdGtDwaWDoKzZaYPeeLLYas+dFDuRs9mFRt/lpXziYMoRKr+QA7Vad
         n2upo4qC2xQ1h4YqVWlG452J6dPXvoQrSoH8ZOgBiIHG/4kwz1c4pIpl9XsnwgiaySUb
         9Z7TqJ4AOIYzpvCFwYDBqbr7ceXCV0Mb5efY7WuVmcpUjbNQrn+SxePG4wm2sReoyVAe
         n49X8ld2RFbjlUBrqS59VI20SiaxJM/12tPxbAFC2r61eOROgpNlL6QQdrrZLkmZeDpw
         kuNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785831991; x=1786436791;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BgISVsIsIFnGhLp1EYAeC2svf5amhtNd1DkilnWeLAo=;
        b=cvW+M6ztUm5gv6a7VU5ICkyhRcNa5BTwNpaWcS4TJdNqPdtHXAs2zUmErHw4RwmTCn
         4jyoUnZgVvlBh1jgLhqCzbFsN08+RedO9O3WT8Vvb2dMwmG2yEq++TAsuOhBv27Vwid4
         2vZwrJJpsBzK8IQclq5FQBaN/+KbE4XBy+95+/HiHgVb5BVvw7UwrW41fvSK1M/RZ7YP
         1/t/PWuHPbTxNfo11zbDsuRtKW3nI2Ppu1KDLbSew505ujAtNHn0JzXx/aetJAt27PYz
         UJDEHoP1Bu6WERc13hVm+1b4aNvjuksw+Js0MuBJ+r16N7o/mBhtw5nl2hkTU6Ojfkl0
         xH2g==
X-Forwarded-Encrypted: i=1; AHgh+RqRSaI/NrwgtDUs1oAB6eXU+eN2FZQ3m/0LPXVCqBy3fIoVk90S5Avrflr6W6SBdabuWmjokmi2J+2iyFJ8CQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwdeonOeRlEBMgY4+A/8F48E6iC8QiYJTRRo1yH2N5356XRAu0x
	Zj/nATLxilw/Zg+wgiZq34UwVRNYf13u0NOSgnrRoN/mluX9cHqyCoas
X-Gm-Gg: AR+sD13dmuG+Rl3j+w9hcBmhmYLlN9flZ1WSV0SnWrCO2Jwr0b1m3R/tc6ptoLpsr7H
	br2uqaKvRtc/MeL1r8IQ1zN81O3a7QaDOJZnDk/0vy/gbCWCdT0txN+O9H2Df5oBzx3uYBI5tMN
	orLDy7rN5c4+Mvv8EmBriMW1+DPsrDoiR8QChe5bOl8CwSw3kt9bS1ALgsT/bI4G+MgDT2C4lOL
	bqHAipHfg/eLv01pnhs/zK6flSKfAshclcy+qvK5apPiPX4fodNe3aJwoYO0EG6mE2HhewgC780
	DYDZESnYTZLFtMkS9ExJS43kR5Btoh7+Re804jz3MJft0joTvw3ry+0U4dBX+TqG6WhkwegxipQ
	4Q+ZLxKBP9nrSaje6yHYfOMjOKsSKKtcGy8wmAoQ0+sShiIMFEwxcWYlWKCBa8Dl2ZQQpe9/EQC
	+B8lYya+Nhoi6Wwws0K5mjJIaUIrsCRgcQ/tPWopTHePXIZ0hxSYmvvG89Jh3nGwN9kQO4VdxGs
	AI/aBllFrztMqfMNZhlHUxeaOQzU44us/rcr1ksdRKyokx+Z2Fjir92Xg==
X-Received: by 2002:a05:600c:5252:b0:493:f42e:1b3f with SMTP id 5b1f17b1804b1-4980c6a4284mr152228175e9.3.1785831990958;
        Tue, 04 Aug 2026 01:26:30 -0700 (PDT)
Received: from thomas-precision3591.paris.inria.fr (wifi-pro-82-131.paris.inria.fr. [128.93.82.131])
        by smtp.googlemail.com with ESMTPSA id 5b1f17b1804b1-49807b9441csm300528555e9.4.2026.08.04.01.26.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Aug 2026 01:26:30 -0700 (PDT)
From: Thomas Fourier <fourier.thomas@gmail.com>
To: 
Cc: Thomas Fourier <fourier.thomas@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <kvalo@kernel.org>,
	linux-wireless@vger.kernel.org (open list:QUALCOMM ATHEROS ATH9K WIRELESS DRIVER),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net] wifi: ath9k: Fix potential spin_lock() before spin_lock_init()
Date: Tue,  4 Aug 2026 10:09:08 +0200
Message-ID: <20260804080913.67985-2-fourier.thomas@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The function ath9k_init_wmi() initializes wmi->wmi_lock. It is called in
ath9k_htc_probe_device(), and the priv->initialized flag is set.
However, the ath9k_wmi_event_tasklet takes the lock before checking the
priv->initialized flag, so the lock may not be initialized before
being taken.  This could be the case, for example, if the spin_lock_init()
is reordered with tasklet_setup() in ath9k_init_wmi() by the compiler or
CPU.

There is a write memory barrier before setting the priv->initialized,
but no corresponding read memory barrier is used after checking the
flag.

Move priv->initialized at the start of ath9k_wmi_event_tasklet() and
add a corresponding read memory barrier.

Fixes: 24355fcb0d4c ("wifi: ath9k: delay all of ath9k_wmi_event_tasklet() until init is complete")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
---
 drivers/net/wireless/ath/ath9k/wmi.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/wmi.c b/drivers/net/wireless/ath/ath9k/wmi.c
index 284e8c13b043..df4a3a625536 100644
--- a/drivers/net/wireless/ath/ath9k/wmi.c
+++ b/drivers/net/wireless/ath/ath9k/wmi.c
@@ -146,6 +146,15 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 	unsigned long flags;
 	u16 cmd_id;
 
+	/* Check if ath9k_htc_probe_device() completed. */
+	if (!data_race(priv->initialized))
+		return;
+	/*
+	 * Make sure ath9k_htc_probe_device() initialization is
+	 * committed to memory before processing skb.
+	 */
+	smp_rmb();
+
 	do {
 		spin_lock_irqsave(&wmi->wmi_lock, flags);
 		skb = __skb_dequeue(&wmi->wmi_event_queue);
@@ -155,12 +164,6 @@ void ath9k_wmi_event_tasklet(struct tasklet_struct *t)
 		}
 		spin_unlock_irqrestore(&wmi->wmi_lock, flags);
 
-		/* Check if ath9k_htc_probe_device() completed. */
-		if (!data_race(priv->initialized)) {
-			kfree_skb(skb);
-			continue;
-		}
-
 		hdr = (struct wmi_cmd_hdr *) skb->data;
 		cmd_id = be16_to_cpu(hdr->command_id);
 		wmi_event = skb_pull(skb, sizeof(struct wmi_cmd_hdr));
-- 
2.43.0

