Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B7D39FCCC
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 09:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279779; cv=none; b=Buo8NDXgqWEbTR9WTHxk1+r2mJoZyjl/zPKML5jB2ElRZuAt/IfxoqUtRFIJVM1tFVmhshV9cVThejwmFm9qFMscRfXhAI27vIMeOzKF5h5Pn0u99124o1ybThWV+pcQGBYXTZlkYMKoU8Qa/ruBxMzPyrG8A72hFSvT/dizwJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279779; c=relaxed/simple;
	bh=cbkvs+o3ytk+CJwsqpyVkqfrcwA0nlzD05q7zoEq9hA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RB0Pxhq/+Mu6NQi5SRkVbTrxX01Uttd/D4TwWBakjjRacEF4lqjTIl2ifpbcdAqecNeeUdpmIFf9O+xjL+cIDWArT1lQ7W8K+fLM6R8PiySYrfXDtQuk9QzGS4YXWsquBS2+ssj+DaPvIz+lkaKaPDwHoQVA8qwkTpWYwBrbw1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z5GIiE9+; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z5GIiE9+"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c315869241fso209314766b.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 02:42:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279776; x=1791884576; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w1Pwz4NjkdSqfWaloOa4OtuYhXBcLt6Eb4swx56Ymeo=;
        b=Z5GIiE9+aHTFBq1rD8b3Y6VZ0y02eAQ/WK5iENVA1erAJ6PuJkYXrp7h+j8s6k2tFH
         5ZVyMPJ2n6VQFILS7ClXclISm4T+prfR3tjVCuj6ufRbkYdMc7TR5N0YfVuGfxmoYDq7
         grwGiwaTG0UYgSFyiu2yhNICz/KZaVMkCg7zM1F5lBlYgkxC3XZ0C/dANw5V7/WwCHWO
         6qPe8z6L8tVkTrctIWZFLsdWj2xHZXAbdgrqnHg8dkfhPqHWiwlUcdEwU3/MHwyb6iO8
         knhIrSlzc5CnydN6V0IxPjW5TpkE7Oz8+5g9NStLuwASbLepsokm6mE3K2r+23QBPznJ
         wQlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279776; x=1791884576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w1Pwz4NjkdSqfWaloOa4OtuYhXBcLt6Eb4swx56Ymeo=;
        b=OEk15JmMeUpRjKxMEP8gu/snB3Njkmb0PHplc/VZvimWTFBBHJYnjBk9aCmhXkd47E
         zN7wg0FhuxCJBFjf5cSFH+JlPWheb2oAlIsNl4Gdxlu1+REG+jtQsEfJdD91nozOK0Px
         mZ98W9i30V+CJH3+Ec91i2838pkrIRsU/mZI7F7LqE5NNsvzJLGHYJ7unrdbtUjIH0WH
         XhCQGDHoSPvDzmD50664pSBm25etNHMXHE5R9EhN2pgNLKJcm/jk4i2B2jHAdMV73Kjs
         gqWgX3CV3x2U+ck4VpKEWAg3lFpgVuHGb+4IzNMF69RoTSHDrMgjXsB5IabuYDuBuzsp
         DpJg==
X-Gm-Message-State: AFuF++m5s6owwWLZ/dsbfLuLklN2uEy9ErBDMKWh8HRa/okp6eTrAnUX
	Ha6QTlRvZT/QQfFykI5Kx4EebVQvPyq3zjaai+g0+0B4/9ulRc+de9aM
X-Gm-Gg: AYBFou3MFXAjFSUWu7xElqWBSB7hBRGiPCSJ2XMrvNPCkjKq8Tt50gUSeFmWHd8aoiu
	Hm+acI75iJnzt4CaPurxAyYWQlmi5Jv030faxLUd44UZCjR/pV90Jjc/h+w5Wcaf5ZHEkWdCYZh
	+EC3FfyiDSgL8eeoJ27ue7+LpmKWpqlfkUBpTTcSTgfKeMMAt4vI1C4vIGjSsbUo3tYXBgAghgC
	Cv/RLQbJKax5/vjr0DEnXdyeIUW3Awe/QRFUsc6r+HGLtEJLUo0g+XCNfINP9ZTl0DO/wqaQA4b
	UXk0wkBGeiYEHTJAMH0iciFBxUh3pzXQOsFix8LE/GqtqheUabTW3mj9eRcM3UK1mfqajCOEiwS
	NE38QEucy++Nfz1t2TR2XS3/H6Zsf8S0zJup8+Hx3CKbsDWMvrEWPyyFjo/NS8LnnBlGl2VsJRD
	bhY6f6cEhW9lx+Od7ytyzxNCy1MQpgi8xlfmc0+ndDlSwB+JoUqElWDi7kQ0IftAWowFi0awqsi
	uM=
X-Received: by 2002:a17:907:e102:b0:c2e:7df5:cda7 with SMTP id a640c23a62f3a-c2e7df5d380mr445606866b.33.1791279775699;
        Tue, 06 Oct 2026 02:42:55 -0700 (PDT)
Received: from Quarx2k-PC.lan ([92.124.138.168])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31562da31esm183753966b.38.2026.10.06.02.42.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:42:55 -0700 (PDT)
From: Nikolai Semendiaev <agent00791@gmail.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	jjohnson@kernel.org,
	wabsie@gmail.com
Subject: [PATCH 0/2] wifi: ath12k: isolate RXDMA page-fragment caches
Date: Tue,  6 Oct 2026 15:41:45 +0600
Message-ID: <cover.1791233788.git.agent00791@gmail.com>
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

Nikolai Semendiaev (2):
  wifi: ath12k: make external IRQ control idempotent
  wifi: ath12k: use private page-frag caches for RXDMA rings

 drivers/net/wireless/ath/ath12k/ahb.c    |  4 +--
 drivers/net/wireless/ath/ath12k/core.c   |  3 ++
 drivers/net/wireless/ath/ath12k/dp.c     |  3 ++
 drivers/net/wireless/ath/ath12k/dp.h     |  3 ++
 drivers/net/wireless/ath/ath12k/dp_mon.c | 29 +++++++++------
 drivers/net/wireless/ath/ath12k/dp_rx.c  | 45 +++++++++++++++++++++---
 drivers/net/wireless/ath/ath12k/dp_rx.h  |  2 ++
 drivers/net/wireless/ath/ath12k/pci.c    |  6 ++--
 8 files changed, 73 insertions(+), 22 deletions(-)


base-commit: 388d3c42e8aba1cfc3c6d2c52877a46d8cf740db
-- 
2.43.0

