Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4753F8251
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 10:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785149744; cv=none; b=EPIJE+zlRUiOnla87aWgKTtJY7lbrA4zsPcigaclKc32hy1g6zAXiBuKtfBMgW9dcV1wmZ2ybCf/zBGB0A3qMQrTyen1X/VkoGtO/zZGxUX6ffzBG7LvLS6r9vuFQS1ePDNcKCvnySkyrAPYKmJtP9alC6xGJ/IG7+Z1m0vXcbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785149744; c=relaxed/simple;
	bh=UDRY1N2PPIKwNokluhbRES57rm0lFb8oYBzjdWwo7gE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=OfIWwP+TEhKZlZWJGwqCsYMKVHe8jhT4+f4SrG5wuTcBwV+8iG9adEs3o1ruNijXfDaISJeDyuRgQ3nRPtwOGj91sqsQHTpi71ULfANHUlcxlBlCL4uY7ne4tkN3+gu+p+jRLkaGNl4gdtjs+5wqOo5O+HTWSRuQYK1fs2A+xnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in; spf=pass smtp.mailfrom=cse.iitm.ac.in; dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b=gxUfYtQR; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cse.iitm.ac.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cse-iitm-ac-in.20251104.gappssmtp.com header.i=@cse-iitm-ac-in.20251104.gappssmtp.com header.b="gxUfYtQR"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca2fad0ae38so1781513a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 03:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cse-iitm-ac-in.20251104.gappssmtp.com; s=20251104; t=1785149740; x=1785754540; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=s0XKAIuEGEIxxI3CPghYnt+GMKDGWSIvJZSgiwQRsPY=;
        b=gxUfYtQRtNh5b9w12P7V5Ii7cIRjSHaVrdyVQTV7dsAWbP6PUAOlgiNP5lXBHlyCB5
         nC390XiK9V+zddnO4J/aT4/SgiH9kfprBLrZFDVG7ejU1WrtweJHwSinvalLb+XLvx4K
         74uaoWZE9cXomijw/QpNb4oLjDb+gjMHsOUd0VB1VWNNz11VSyrOn1oUMpcv+y3qpvFs
         M18vZ/2ObhaP5kR5z/b+rfSD3ogV0A0Yv7fkyUTHDHTncDlBCa6prAjGwadT7XFKwqa7
         ihRGRC4QKwXFrQy/MEoMSgnQnRD55v3x4eicFaAWERV2LPlfLw6MBLpcm8XGuMmSWgs+
         u7lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785149740; x=1785754540;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=s0XKAIuEGEIxxI3CPghYnt+GMKDGWSIvJZSgiwQRsPY=;
        b=gAKR9BObZixIi30S9FtlDLvt4BD5WkfxNoWQ81oELpXLfkaSZEurvydST6Km/2QCpn
         CQByo442WAEobOf6tCXZC2M56JpJspDZEOIbed9FOG9ylmQjK+KQHRyV05bAICi1sRUs
         IzvS3/9ObHgOLXhGImKFNOj+IN7loGZpUYZqeDa6OyPzL8Xg15+iXzHLZqGyTaF7dWV7
         3/9CC/tJgfdQt2RjbSsgkeJavLBJRgyzJLralx+38At02K0z8AGBh+HgGyklBLUrD+++
         ZkaSlo25QkGM9rctFfS/G0TPsBPiHXL6HKO8qjbLcAy7rE8CdR2CkgzJaNevwlOdmP2a
         jIEg==
X-Forwarded-Encrypted: i=1; AHgh+Rq6MOu7S1J7MurG2rPaNZ2dBHC+HrY8p47nG/C3Cdokf28o3qqfXzSWUfKIlVPi+kZ7PcRSUYTVjLrkJLATGg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6H4nwl1/7GffSEjXo4l9mUY0Umk77mD09r2HMWmnB30RTUBaZ
	zbdFVTvGm1pX8JkZIo/1MPQiS6pzQA5n9gw2eEcDILSIsn0qLe/3NZv1ojwsNyIr10k=
X-Gm-Gg: AR+sD13H24B/EezDEQIw8dAVwKEQfvkLX6kOzccXVANZmgXhwIDg+ZPqyt6HtNvqkBG
	hYaebiX9jaTEF2O98+3GMRl6321fvJrLLms4wIdxCvZO/CmdDQrjTpl/D6G8ZZUlX14lkzSWMHx
	AgL75dEaZ5ykyedHGdyTl0FT8KvL7D8wEGm5gX4MzGnljugfD7UTn7dDqc9tCAfH8Xm+UmWdw5p
	I7ZfEC2KuQ8qKk1TodEOV3g5aWeZsLpe034wA5Oa+rzGhn3qF4RmS4fOrFCkR6UqEfzi0Z6vQD3
	5ZjD9h+Uo5WAmHJ/yxuI5xCZ5k0G/rWjfgCsaqGcyr7p4En5nvG9vHCssBaTks4k0atOa983Fvr
	LZHGAEKTo38+zVdwb0wV05ukruIPA7GHQEVdp6siqWCDSVTOZOp1eyEm5kkaGGCP9GCi+pa0QLa
	KI1/6z5RJTFED4lSSUPOH6+7cIFX9264hjymmbXUfQTfmhzww2j7CceaQmIHBjvCPP/U8sDypu8
	y4Z38csXDofTC6dzpLrAWa9zx2jHZVO
X-Received: by 2002:a05:6a21:a45:b0:3b2:a809:1000 with SMTP id adf61e73a8af0-3c67dae40f1mr8265553637.3.1785149740172;
        Mon, 27 Jul 2026 03:55:40 -0700 (PDT)
Received: from Metius.iitm.ac.in ([103.158.43.43])
        by smtp.googlemail.com with ESMTPSA id a92af1059eb24-13d130f55c6sm85269877c88.15.2026.07.27.03.55.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 03:55:39 -0700 (PDT)
From: Abdun Nihaal <nihaal@cse.iitm.ac.in>
To: jjohnson@kernel.org
Cc: Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH] wifi: ath11k: Fix possible memory leak in ath11k_dp_srng_setup()
Date: Mon, 27 Jul 2026 16:25:31 +0530
Message-ID: <20260727105532.118164-1-nihaal@cse.iitm.ac.in>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ath11k_dp_srng_setup(), the memory allocated for
ring->vaddr_unaligned is not freed when ath11k_hal_srng_setup() fails.
Fix that by calling ath11k_dp_srng_cleanup() in that error path.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Cc: stable@vger.kernel.org
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
---
Compile tested only. Issue found using static analysis.

 drivers/net/wireless/ath/ath11k/dp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
index f389b97acbdd..c3a16da1cba7 100644
--- a/drivers/net/wireless/ath/ath11k/dp.c
+++ b/drivers/net/wireless/ath/ath11k/dp.c
@@ -324,6 +324,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
 
 	ret = ath11k_hal_srng_setup(ab, type, ring_num, mac_id, &params);
 	if (ret < 0) {
+		ath11k_dp_srng_cleanup(ab, ring);
 		ath11k_warn(ab, "failed to setup srng: %d ring_id %d\n",
 			    ret, ring_num);
 		return ret;
-- 
2.43.0

