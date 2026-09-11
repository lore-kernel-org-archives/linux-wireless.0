Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921993B42D7
	for <linux-wireless@vger.kernel.org>; Fri, 11 Sep 2026 01:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789091326; cv=none; b=EmhVC6D0mcZCsQ5WW3T8vwus2DmkctJEgsTheCAeWMZthhSkT3t7/RHKgAlz4NuniqjcMlm0aKcgzotFyeqk3kSVbrqzgjuePc6JJ+lp7Yb791seqvrtcQ/a8moWe/uloovZcBJ65cyqPFNH73TRypciKHMXsKfkX9Oy6zLpCuE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789091326; c=relaxed/simple;
	bh=+Hq6yCndvk+xNMtgXUSDWp7midRlZI5LvFk7k938tpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MsYDpM+Z6EHfkEdfYFlmTXyGP+YezpflMJpxV2eLTJFo6cukJjo3Caea7uaIRdYH4eIt2mfC0AuymKec6Rf1XXjOxrrKU//pnKn2WkpVeGPTTa3Xtss4eG3D8SWqxla1NwKgq+34rbFomADo67ggDA/iU8KdZdx5zWN2aDM03BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hMfOlxbp; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hMfOlxbp"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c25b661d37dso68893266b.0
        for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 18:48:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789091321; x=1789696121; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Wl0Xht5utq/aA2gpsKqp71wsx5z8mSCgYWNC6eA+7n0=;
        b=hMfOlxbpdZiEd7GUlLMuVA4T81nfl8RGvgxH1HbQ2irbUi83YICCUgLNbmViZ0jTWq
         6ENcD/3zA6koiyZaHuSmJcO9I1LKEK72XsgTUv1FwyhTDQMQXgfWBAh7vm0RULvLD+dY
         YqjZ4AOf+/ULSZT8qGdku4U65owpV04O4bNOyw4zafUgVR1q0TKcup/Gah5EXijA3k10
         OlLRUI1amJnslb7Vtj4U1t+zXOsTGHKc4VnkX4oBlPhfxww3aGC2MvL8JbdOGWLoQNfl
         62d9H/64MnsYe2BNN4+c2/wXl593ac31A0kmvVaFDNXE2Ou556K+dAESmQoDSg/W1EKY
         Gu0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789091321; x=1789696121;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:sender:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Wl0Xht5utq/aA2gpsKqp71wsx5z8mSCgYWNC6eA+7n0=;
        b=PLiBXgsKkCaoyrdtjIKE0qUZAGhdiWsBGLFbx7dEJZ/LscnnwakNNSv77ImWcH3g/W
         NOndkdq7E5piyd9/XiSr9J8ImMAPkMj8DzrGcEebufJ0XamKm3oBJXxjd+f4N6AihU4p
         qzbv51auFf6FLYbdKj5HDBHZ2u2J2VUxCHWINDPi7KmMwhwsmPs6/FzlKiCp8fWa1WA8
         2dIMkTuuhOqR+GW+mwxlqaWY180WbhEPbZxR/s8P3/Ky8zgJRixWZ6zFn/KaXHZCAZPT
         SpN59/Ju/mI8Q5XP5Ze+mQNGcJ5mcRc9OvIBFCxEzyUUD6ysmJTFA0QFWrg7nKX6O3a4
         E4jg==
X-Gm-Message-State: AFuF++lPYuy4afJ/IAHI4x+uno++gZmscPdsIJI1QI35708pSWi49pEf
	nfwhP2yW/e01OlETF+4MvFVM9t/Zx4b7LRziXjcDgq3BGkXmazAm3qi5+COH
X-Gm-Gg: AYBFou2gwqbEW8xRnbsCZBfNCNIxbkUNTdlIKhVH6hGLunkRw0gvRXDnfn7NJDG2x5N
	lrLK9zfOooMRYbEb/xEH34PAp0hHOez9Mh0oISJ8edPthmDl11nuYXfJvzQkqCJgZznl3egZ0rr
	A/YhMrdBBjgoBr3dvfwfjpTHjAuCIlnVgz3eoxhDqTIjdOwqX2D4kTGruXPua+KjDOZk/k48zRz
	Axib2aIHLRBowdyGxcioH3qw/UoOLj8Hs/APgdTXHX9pmHOQc1hmV99JGcMroxZs9mQp9C42c2O
	CHWVo7rj5RsWaH2qJglSK/dRKR+YqmcNKCBQekpL7VjPF9B+WiAdrv9AJcpw3RNTST1+9rIK4+x
	UClYuqJt0blYsNAUsIJDcGwRwixC96OssfzDw01RFtLsKBy6N9s7FlwYxvo347nDejoJXI5pUzL
	Lo6e2E+q3LO4EuRv+uMGrLZGcePAzkH4WJmS+w+7FfdKFgthLbHrtWboB0fDjjG/ZBigLkSiK5n
	+LJmlu8yrxjmtElCQoUSRUOZhDCII3dv0Jwr+vCV3vGBFN/0yyTwpeGFM/xIfs3gtOGU98xnsru
	XC5dtd6ioJJeVQc=
X-Received: by 2002:a17:907:3cc3:b0:c12:e178:9e68 with SMTP id a640c23a62f3a-c2966668eb3mr59295066b.19.1789091320753;
        Thu, 10 Sep 2026 18:48:40 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2966021ae8sm28097866b.22.2026.09.10.18.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Sep 2026 18:48:39 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: toke@toke.dk
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [PATCH v3 2/2] wifi: ath9k: clear the PHY error filter when a spectral scan is disabled
Date: Fri, 11 Sep 2026 04:46:53 +0300
Message-ID: <20260911014653.1566388-3-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260911014653.1566388-1-nerijus.bendziunas@gmail.com>
References: <20260911014653.1566388-1-nerijus.bendziunas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Triggering a spectral scan sets the PHY error bits in AR_RX_FILTER and
AR_PHY_ERR and sets AR_RXCFG_ZLFDMA. Disabling it clears none of them,
and ath9k_htc carries the hardware bits into every later filter update.
An idle AR9271 in monitor mode then keeps forwarding every PHY error
as a zero-length frame.

Clear all three on SPECTRAL_DISABLED unless radar detection is enabled,
which needs the same bits. AR_RXCFG_ZLFDMA must go too: with it set the
frames keep coming after the PHY error mask is cleared. As with the
enable path, firmware older than 1.4 still reads from the host.

Fixes: e93d083f42a1 ("ath9k: add spectral scan feature")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Nerijus Bendžiūnas <nerijus.bendziunas@gmail.com>
---
 .../net/wireless/ath/ath9k/common-spectral.c  |  6 +++++
 drivers/net/wireless/ath/ath9k/hw.c           | 23 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h           |  1 +
 3 files changed, 30 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/common-spectral.c b/drivers/net/wireless/ath/ath9k/common-spectral.c
index 73c1eb4ebe0e..841075d904f8 100644
--- a/drivers/net/wireless/ath/ath9k/common-spectral.c
+++ b/drivers/net/wireless/ath/ath9k/common-spectral.c
@@ -776,6 +776,12 @@ int ath9k_cmn_spectral_scan_config(struct ath_common *common,
 
 	ath_ps_ops(common)->wakeup(common);
 	ath9k_hw_ops(ah)->spectral_scan_config(ah, &spec_priv->spec_config);
+
+	/* Radar detection needs the same bits. */
+	if (spectral_mode == SPECTRAL_DISABLED &&
+	    !common->hw->conf.radar_enabled)
+		ath9k_hw_disable_rxfilter(ah, ATH9K_RX_FILTER_PHYRADAR |
+					      ATH9K_RX_FILTER_PHYERR);
 	ath_ps_ops(common)->restore(common);
 
 	spec_priv->spectral_mode = spectral_mode;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index d62b6ff00d41..6f86a8967548 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2928,6 +2928,29 @@ void ath9k_hw_enable_rxfilter(struct ath_hw *ah, u32 bits)
 }
 EXPORT_SYMBOL(ath9k_hw_enable_rxfilter);
 
+/*
+ * Counterpart of ath9k_hw_enable_rxfilter(). AR_RXCFG_ZLFDMA goes with the
+ * PHY error mask or the frames keep coming; callers clear all the PHY error
+ * bits together, as checking for a remaining one would need a read.
+ */
+void ath9k_hw_disable_rxfilter(struct ath_hw *ah, u32 bits)
+{
+	u32 phybits = 0;
+
+	if (bits & ATH9K_RX_FILTER_PHYRADAR)
+		phybits |= AR_PHY_ERR_RADAR;
+	if (bits & ATH9K_RX_FILTER_PHYERR)
+		phybits |= AR_PHY_ERR_OFDM_TIMING | AR_PHY_ERR_CCK_TIMING;
+
+	REG_CLR_BIT(ah, AR_RX_FILTER, bits);
+
+	if (phybits) {
+		REG_CLR_BIT(ah, AR_PHY_ERR, phybits);
+		REG_CLR_BIT(ah, AR_RXCFG, AR_RXCFG_ZLFDMA);
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_disable_rxfilter);
+
 bool ath9k_hw_phy_disable(struct ath_hw *ah)
 {
 	if (ath9k_hw_mci_is_enabled(ah))
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f102f73a0114..983146208f26 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -1056,6 +1056,7 @@ void ath9k_hw_get_channel_centers(struct ath_hw *ah,
 u32 ath9k_hw_getrxfilter(struct ath_hw *ah);
 void ath9k_hw_setrxfilter(struct ath_hw *ah, u32 bits);
 void ath9k_hw_enable_rxfilter(struct ath_hw *ah, u32 bits);
+void ath9k_hw_disable_rxfilter(struct ath_hw *ah, u32 bits);
 bool ath9k_hw_phy_disable(struct ath_hw *ah);
 bool ath9k_hw_disable(struct ath_hw *ah);
 void ath9k_hw_set_txpowerlimit(struct ath_hw *ah, u32 limit, bool test);
-- 
2.55.0

