Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E85D3CE4B1
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 21:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791409155; cv=none; b=hKCB+vVZQTWWyegDFt/mzMlmclMFIAwJZyy8mHGBhfg+R4KRpZcwgwgRpjSi/ClK7LMWZ9nvVg1vlwddHBB1sVG6/lDAOMws1rfdQ8gSYe7RnMyS8ZpkPZ9VXm69A1AlWR0sMgXHz5gKfcTQVPaGw/y69JnijJXlqEo6WUch/Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791409155; c=relaxed/simple;
	bh=jg0nE0/8qv9inVm5vneqL79dhm6Knkaz76y/tAUD3ak=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=aKNXF4UcPiQdGTHqfamHsJuqF0FY+zUG1fkLLDVAsozik73TT5Qhx+NbG95ZmXMPA3M/Py6RyahUNw745qTwDMYMsBa6iu3A9OPTrCBkXpJvwaUYCCq1EkQwIqT22YQC2ov4BtiHqK0mg4+ByFflI1MPfyz++LRe4wQVxwT1faA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Hons+nf8; arc=none smtp.client-ip=209.85.167.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hons+nf8"
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-5b2b92065ffso4012940e87.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 14:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791409152; x=1792013952; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+Z8CfWUeO+BpA0EWxBPHQDHuoY5+JehiGP0c5OUk/IA=;
        b=Hons+nf83hyaQZWf9f+cuh8t/CExzeZHLKHpVujOuMKbU+T/p9eS44U5K7UHSKrzZ/
         GRFyMuxAQdN9PxPUe8m99Ynn798tuM8iETK7Zn0FNoMy1Bb+eidFd76aXxMClC+dSfE0
         N98CDMiWKrwB/GYDErQf0afD0VAmAWzmmRr6BYFuOQw6+RsyfLRdr7W76yJkmpLzAmkq
         Cm4ak7KDtyUId2fmgEeFkeSJPjpQWs8tA1dfj7AEJK3G9d52FiOnjgvXDXXBcjEAicJd
         oT0rhPgv/P132JCLwUt7aASf9xhrwB3gtR3m0/omisgyO+IGRgNTGzOe0Kz8G7H7qWvG
         apBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791409152; x=1792013952;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=+Z8CfWUeO+BpA0EWxBPHQDHuoY5+JehiGP0c5OUk/IA=;
        b=FdrVDPRYG5X8b4jVThJuFTjrIb4XlDU8QYQjdJ7Dzd62+iAh/v3Il5GlAsVyDlyK2C
         +EENIMhH84g2d4MhDFv/w3eobLYlVy16l1QuQ6IPUyISY6p7fQB8sXgyyNv2N6m3RwTl
         kWwNmMO8PQcOPSjRLR5uEIqRIfts6D1F+eH99JWy7ddu87RD5Gwvah4t0t3uVVUEwSrT
         AKIJuOLaPcdwqa/39jnRZkzDLFGmnBNG6QcLu4NNtg1JpkyCoNR17ajSpnBftOf9hEKP
         j15XVPo1qbRiggNeBLXPyB78XQsJm9r6pb/MTr0z0ma987++rTwMNfas8aFB3EmYXR1l
         V+5g==
X-Gm-Message-State: AFq9FYJCSQlHQ7IMjY3fqPsm2ajxSfqzPCAp7zu5HyFlNbjBU7/0Ol9H
	C86Ce4VzNKkvAdTN9OUTjpC0c9NCwQYZHfTpOjjsNpdUEd/eX6RjjoH/ofWhj+2NLb0rVUCszJU
	=
X-Gm-Gg: AYBFou2J+VUQZHIIWTBfXHYzUwRlwegMqksIsgRqPs6GAJuPXl/E24Jar8ONqpCNeMt
	WUob3HRrbBYURK5VAUiG/GdOr7Pa7Yi4Sqk9zKwdSMTqrdR+N9Yanivg9EUGbwi2QXrUTcmvvcm
	VrgAfAkbKC105E4a19MFtGROl7cOdq27lBpBerlHyz1a9grAhXiNIft1ai2yxfGo2uwz998Usl0
	+DL43BXZcNojY53PSQ9+KcSPeodoc3RauITgoChg7cElbRBJO5/0GEJtR6DyyREhdgBrQ0oUt6T
	A1vqsgEiEBj7bSJM4lY5ViahXnFYXfOnR4nKLcRfYYHHYTmT9tQ8+Acsr0G09hOwjo66Gb0M56t
	nSRDGQEncW2j1RTtnYndbnIfkdawIvY8QnMlpsr0j2w+QvI5EQdPXmVJXqEDOksvbFOAeaAh/pp
	1J/DL7CvItNkNGxTDemnGn/BtreCohJwWbeZIJIELntFnnT5VEM0Xm41xRFIO6cjDnB1Cef0kno
	zmM
X-Received: by 2002:a05:6512:33d3:b0:5b6:1a7c:aa1a with SMTP id 2adb3069b0e04-5bcd07442b0mr1332608e87.50.1791409152110;
        Wed, 07 Oct 2026 14:39:12 -0700 (PDT)
Received: from Quarx2k-PC.lan ([92.124.138.168])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a9ae563df4sm1241411fa.30.2026.10.07.14.39.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 14:39:11 -0700 (PDT)
From: Nikolai Semendiaev <agent00791@gmail.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	jjohnson@kernel.org,
	wabsie@gmail.com
Subject: [PATCH v2 0/2] wifi: ath12k: isolate RXDMA page-fragment caches
Date: Thu,  8 Oct 2026 03:38:27 +0600
Message-ID: <cover.1791408913.git.agent00791@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This series adapts Mark Ruvald Pedersen's ath11k page-fragment cache
changes to ath12k. On QCN9274, sustained WAN traffic
can exhaust memory when Ethernet and Wi-Fi run on the same CPU.
Long-lived RXDMA buffers share per-CPU page-fragment caches with other
network users and can pin mostly unused 32-KiB backing pages.

Patch 1 makes external IRQ transitions follow the NAPI state so that
crash recovery can safely quiesce RXDMA before teardown. Patch 2 gives
regular and monitor RXDMA rings private caches and drains them after
their buffers have been released. It also fixes alignment of empty
skbs and preserves monitor status buffer capacity after alignment.

The series is based on ath.git main at:
388d3c42e8aba1cfc3c6d2c52877a46d8cf740db (Linux 7.3-rc5).
Runtime measurements were made on Linux 6.18.54, with Ethernet and
Wi-Fi IRQs on CPU0:

  Hardware: QCN9274 hw2.0 PCI
  Firmware: WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Two 45-second downloads showed peak order-3 memory growth of 54 and
68 MiB. An earlier unpatched 45-second test grew by 187 MiB, and longer
unpatched downloads reached OOM.

A five-minute download at about 660 Mbps transferred 24.8 GB without
OOM. Peak growth was 105 MiB, falling to 35 MiB above baseline after
one minute idle.

Thanks,
Nikolai

Changes in v2:
- Include linux/bug.h before linux/page_frag_cache.h in dp.c to make
  WARN_ON_ONCE available on Alpha. This fixes the build error reported
  by the kernel test robot:
  https://lore.kernel.org/oe-kbuild-all/202610072103.1v2wWX3z-lkp@intel.com/

Nikolai Semendiaev (2):
  wifi: ath12k: make external IRQ control idempotent
  wifi: ath12k: use private page-frag caches for RXDMA rings

 drivers/net/wireless/ath/ath12k/ahb.c    |  4 +--
 drivers/net/wireless/ath/ath12k/core.c   |  3 ++
 drivers/net/wireless/ath/ath12k/dp.c     |  4 +++
 drivers/net/wireless/ath/ath12k/dp.h     |  3 ++
 drivers/net/wireless/ath/ath12k/dp_mon.c | 29 +++++++++------
 drivers/net/wireless/ath/ath12k/dp_rx.c  | 45 +++++++++++++++++++++---
 drivers/net/wireless/ath/ath12k/dp_rx.h  |  2 ++
 drivers/net/wireless/ath/ath12k/pci.c    |  6 ++--
 8 files changed, 74 insertions(+), 22 deletions(-)


base-commit: 388d3c42e8aba1cfc3c6d2c52877a46d8cf740db
-- 
2.43.0

