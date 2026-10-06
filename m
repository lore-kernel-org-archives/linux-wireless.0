Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA71A39FCCC
	for <linux-wireless@vger.kernel.org>; Tue,  6 Oct 2026 09:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791279793; cv=none; b=PgfkilaiD+c/84F9gytJbC3Xop5zYX5R6kPNyyKkrUEMFHT1m7Vekxx3e2ibZWlbSO8p9N4u03SGabpUKeKJZ36CQLxXdpdQHl8KoFd34HDpbw/TH3XISTh4XdnmhCcQFjTwKx06Ye/zfX2CEpy7RD62Fjjj/piDe0RBg33ri3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791279793; c=relaxed/simple;
	bh=qv9rxTd0Hc9BHi43iLj6LCNvrEmdLH9xqf5EhgvBuGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XREqLTxKPnKxdMkpz10+U73+RZTN8zBBLKomuIF07wiOk42Z6q8hTcNgdmMvvUkbHwzeTbBpf/UTYxTY3SfOwLAVJD5lNNqWbtzBojZCSYj8FpyuOAEV/K2AHwTfTGvPHR4x5eYQeu5/rSe60PLPFC1h1teoW7MI0pcw1tLNk8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XGHZOyKy; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XGHZOyKy"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c2dcbcc546fso47999766b.3
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 02:43:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791279790; x=1791884590; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HL50aAuTc7iXXkRUx082+O87VcrVi0CqO+VpMmcaNUY=;
        b=XGHZOyKyUX65AxdZzRgP+g8/8tWC1SOfrvY3P6QvIlhhXE0Hx65f/ZvRRFRpJfDYA5
         vVjaXnUUp5tEyi4kMd8q4nvOrDHvLa0m3krd2ZvtvyzyLf/aYJR9K3WeiZLK6PUNfk63
         8CAjIY0iK+kAMXGYtg0xfB5eKHk7DptrHBeNa8paTD/41fSyrLV+ToVyX8bsZGYjVXnT
         +5rsprJK12+6QazgywUeP1a9gv2p6kbLzj33kZEm58kOlZpJN6fStLO6Y6nfMK06BaZN
         Tn+H+R53NwRR2YCEwae+Krb+mGRN+c3ZaqbgI1Adh+wjZTg6GhylubJx96veKlKAe5mf
         tnYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791279790; x=1791884590;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HL50aAuTc7iXXkRUx082+O87VcrVi0CqO+VpMmcaNUY=;
        b=GZTVzmcHgHUVuUwxrzL4fndUQ87yrGu2W96GC8MsJPfACO7N+8lLOXGLx71Oe7LLIQ
         17ZT1fPSRoTZLIfZ6YR5zEpCUwLvh0euHZRWKW72JoaC2Bc9RHxoW6Vv9E1aTMlOABkO
         0ORgttfN4+mTUqW0QRUCao7g5KZnqAHnuf9BG4BmAc3pLjXswkHKxCE7+QeWETYl7hQ2
         kJ9Jur7ZSGub118fXsVH1ejQZ3Q/M9WPGeGgSW0pXbOndk/TWHevw/fHSV+WFvTEkwNl
         OwrzyAl9oGLM3q1gfvK5k330ky6asE2xkkkRtdB7qJB0zFgTqRYals/BBb+kXkzFRGNk
         TU4Q==
X-Gm-Message-State: AFq9FYJ7zyiEHpXXZGb9yxvRLZFuazMD3uBSEyWuKHrfezbw+TO0EM6d
	DNgPMA/U4QhtvW0c+wsaEiUQk1RGwNMdhTPa2Pr/UTB9CDftFxB43y7p
X-Gm-Gg: AYBFou0wqx8vn6Zn46IEighVDc7ffTx6RcYk0Hjvx2UK2yU7r9ZRmFNuYTeCSjgd5eN
	l2QSWmhi4hmZ4vqv2aNRMpyx513icWHze395XgXjT4OdsGbIvq2NR9k4FmK6L9yg9ChEVuH5v9d
	J9y2DU49en5fgOIYI4BvE8Y88F7c6qxyRc5OJBMcvaLTMeO1ZT8zrBC1OcUuHxFDqn0jRax0W76
	NIW2omhID9vVQHbW5doFMfqwZe91v9SfEEYWoQl2HYs05XNsI3oQPKdkZtgVunSWkJB4HJtY2Uj
	Mttywb6CaXvdQ5JWrV0NQwZmSht65BlcNH696XUvuTHzlBTCWMZCVj+4k4d+uR1Hm5MEcwvOa/t
	oBoM24m4rz21IOdwiINFGpcJJze2AxLLkPFoKQJwUL6nn7yt7WeBZFBP4r9JxW9E1hc1ar9Okq1
	vtWlmbGWxPfHKn/DpMekTN8m53GoUo82TGxaPNxJ5C8PBuwwORSgcExbpV8LmqtQpUnEkFdkFoS
	2w=
X-Received: by 2002:a17:907:971d:b0:c29:53ba:a4cd with SMTP id a640c23a62f3a-c3169fc69b9mr80144466b.11.1791279789844;
        Tue, 06 Oct 2026 02:43:09 -0700 (PDT)
Received: from Quarx2k-PC.lan ([92.124.138.168])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31562da31esm183753966b.38.2026.10.06.02.43.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 02:43:08 -0700 (PDT)
From: Nikolai Semendiaev <agent00791@gmail.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	jjohnson@kernel.org,
	wabsie@gmail.com
Subject: [PATCH 1/2] wifi: ath12k: make external IRQ control idempotent
Date: Tue,  6 Oct 2026 15:41:46 +0600
Message-ID: <ccca0d5d087b862c3b41ab4d3c5849ca0dc2d32b.1791279304.git.agent00791@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791233788.git.agent00791@gmail.com>
References: <cover.1791233788.git.agent00791@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The AHB external IRQ helpers change the hardware IRQ state even when
NAPI is already in the requested state. PCI has a device-wide enabled
bit guard, but also changes each group's IRQ state outside its NAPI
state check.

Tie each group's hardware IRQ transition to its NAPI state transition.
Mask IRQs before disabling NAPI and enable NAPI before unmasking IRQs.
This permits an extra IRQ disable before crash-recovery RXDMA teardown
without increasing the IRQ disable depth.

Based on Mark Ruvald Pedersen's ath11k IRQ lifecycle fix.

Link: https://lore.kernel.org/linux-wireless/20260719215817.2468580-3-wabsie@gmail.com/
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Nikolai Semendiaev <agent00791@gmail.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 4 ++--
 drivers/net/wireless/ath/ath12k/pci.c | 6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 85360365a..a5eaf5bf5 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -182,8 +182,8 @@ static void __ath12k_ahb_ext_irq_disable(struct ath12k_base *ab)
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		ath12k_ahb_ext_grp_disable(irq_grp);
 		if (irq_grp->napi_enabled) {
+			ath12k_ahb_ext_grp_disable(irq_grp);
 			napi_synchronize(&irq_grp->napi);
 			napi_disable(&irq_grp->napi);
 			irq_grp->napi_enabled = false;
@@ -326,8 +326,8 @@ static void ath12k_ahb_ext_irq_enable(struct ath12k_base *ab)
 		if (!irq_grp->napi_enabled) {
 			napi_enable(&irq_grp->napi);
 			irq_grp->napi_enabled = true;
+			ath12k_ahb_ext_grp_enable(irq_grp);
 		}
-		ath12k_ahb_ext_grp_enable(irq_grp);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index af0e882fd..d2a7b6719 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -458,9 +458,8 @@ static void __ath12k_pci_ext_irq_disable(struct ath12k_base *ab)
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		ath12k_pci_ext_grp_disable(irq_grp);
-
 		if (irq_grp->napi_enabled) {
+			ath12k_pci_ext_grp_disable(irq_grp);
 			napi_synchronize(&irq_grp->napi);
 			napi_disable(&irq_grp->napi);
 			irq_grp->napi_enabled = false;
@@ -1108,9 +1107,8 @@ void ath12k_pci_ext_irq_enable(struct ath12k_base *ab)
 		if (!irq_grp->napi_enabled) {
 			napi_enable(&irq_grp->napi);
 			irq_grp->napi_enabled = true;
+			ath12k_pci_ext_grp_enable(irq_grp);
 		}
-
-		ath12k_pci_ext_grp_enable(irq_grp);
 	}
 
 	set_bit(ATH12K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags);
-- 
2.43.0

