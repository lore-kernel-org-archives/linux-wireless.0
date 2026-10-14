Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0985549380
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791988359; cv=none; b=NYLsAC3xYZk3U1POi7IT+DMcqEyBFe7Aimz03lRcEh9PrNLusvvct5hOh76zOL1JvPnPOtPr7ktX1M9u7ajBy2juP+Fksv6j7krLkKKRi7HUIhOk9pdU2Kg4a9rmG9O47md3s5xQDDyIxg9eYv/D22AU0muPh8wQo8zLEg0d4eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791988359; c=relaxed/simple;
	bh=CtILBnBlbLG5DcPzhNvrdWpOUja71QbExip57R2GpvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GWkhh1K6X1DzJIdb4S1t0V1+bCFF56an1MMu/RtcxAcOqMw8XUp2CHxhB1yThN915bQZOeSDAZbiDKLvLFoMZGJ6q6wuFESGJhmdl/Jood4IO1T2KsyZpOZ+fyFoOrzA2ryd5a71gV1YFbNaFt+oHnCLasBgZI+ENh0jqja2kL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SW0ntH/A; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SW0ntH/A"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1635f7c89so10766795e9.2
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 07:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791988356; x=1792593156; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=adX1t+A8OPd80tdnZU9sRvJpsh4FeFmYoguppUDGFio=;
        b=SW0ntH/A/1QRctw8Z2I0Z0TyhLE2jdxiiaH6LUxjrAONEGlKWVBtKwqDaO5YLroiiT
         q/3YMj8Q/U4mcYLRyWWpLdMFzU3OBGQuqdbqWTOTAZn2zd4ArDNigizDFl2MTdsPTz4w
         c9Q9TYEsDsUPPYZn9+AYizQkd3PxAX//2bBOJIM+5AVZgwPdzVVr7IeEC2f1hq3l6p4W
         CIM0EigQR6WKdAtZneFtEYfq5QiOKYbDDUFEFdOT3EU1sHf7WLmT7J19JpSCkXvMl4wc
         G0F6kLERMSQdduiGP6HVfqX0Jc/nmw+nkux0cyBYV/ykXm1Rjfp+SuQ7ErSSaERGlLs/
         ojbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791988356; x=1792593156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=adX1t+A8OPd80tdnZU9sRvJpsh4FeFmYoguppUDGFio=;
        b=iG5UTcr3uE5hDeHhYR1Dd7sBVRejrb/D7Ka+QTKVXEf4G+QUBEpH9EiEcWI5FOARj0
         CBe1WGVCn/32fQ++XiCA3vsM32qPU0pq1AlrO5cedkQcdPTy4W0eAdVgMQ6EjWWDPA5y
         ziz57ULLNuK155JIJYmWhmCkGXWvoyis3CixG20rYPMlSGorVkDdxlqJb/Q6PQnAhAF7
         iCBMhOmleUIosQlseKW6hC/lb/vLrJRfQLEk/VSAje+WVkAPP60QtmLbcIQ0EYQHbfVk
         /W0pdSNjZznaqGBqjysNrEREEI3em1nvBnXXYvaCvYfq0wiK9xC+YZaGJ3uKbllSdGDM
         Ct/g==
X-Gm-Message-State: AFq9FYKXDlrSilk6mlvLxGkGDtcp2tzmIb4SwTS3PTVCRVfa7shEuyn5
	6tU057rVSEdru9DSZUGM677+Nd6I2FmmnEONxXvItXjwei7gFWkKAZ1NEnVTOXwH
X-Gm-Gg: AYBFou3YmARLFCqVpUdJHiP+mnYzBmsjSFzBU6/eIpcotywJ3fhWsDhRI1JJ5p3xKlL
	eaJhzUbmOnDFdtrLjjFNH42v/BRy33uuVrwtvW4R3frrcTX7tqSW9N7rTw1/V1eVkl/pph11fH8
	iEwzX7Ziipq+h/KpW0qFBRo9FgOHmHbtnFEgz7kB6dfxCW5dsKUYt5NQCPo+1Bzy9YdxpEImPUV
	bszK4hyG5Ot1G5hQgXLwXNqd8Qg+Jgsoe8fHnLd4W7R156gfKeMfn3M1audHVqF0O5pbautgn1L
	bTAIOHLCkutG0+VRquvr7+pPln3D2SlvWniy4vSoYk8Xz59obuehkHx4KIEoyPSRe70Ox+LrJjS
	jkhltuMPOWAc4a1CbQPwxPE//nVtFGbGmX4YhyA04zVlMipwynuYL9oIHRTmFG3AY5vxJ+rwAIY
	eB4Yl9HCDyH6UuSXCrZXngiPpiJpVkTMSKCQfv2v9xdOUgirH6K1c2akNZWO1vFZNf5+hXXRoXY
	qnk9Q2MwuKxulyWCAWZ1r+fcjK/9E6XRWujCCy9LIMdDkJ+RfCjvf0O1aljxdxjJGoeWuiSoPvG
	DQAZCFXTWZmzy9sctRVTxAyj3XdZTnEKHe7eppOsRtUzZhki+Xj5ow0Z3wQWzkLA
X-Received: by 2002:a05:600c:a01:b0:49f:ce72:e931 with SMTP id 5b1f17b1804b1-4a18e4fe3e1mr336129885e9.35.1791988355730;
        Wed, 14 Oct 2026 07:32:35 -0700 (PDT)
Received: from zitrone ([2a02:810d:a1:6000:62d3:e68c:3175:a538])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1bd068126sm3411345e9.11.2026.10.14.07.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 07:32:35 -0700 (PDT)
From: Andreas Wendleder <gonsolo@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	b43-dev@lists.infradead.org,
	Michael Buesch <m@bues.ch>,
	Alessio Ferri <alessio.ferri@mythread.it>,
	kvalo@kernel.org,
	julian.calaby@gmail.com,
	jpeisach@ubuntu.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH wireless-next 2/2] wifi: b43: handle 64-bit DMA engines whose index registers hold bus addresses
Date: Wed, 14 Oct 2026 16:32:25 +0200
Message-ID: <20261014143225.82149-3-gonsolo@gmail.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261014143225.82149-1-gonsolo@gmail.com>
References: <20261014143225.82149-1-gonsolo@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Newer 64-bit DMA engines (found on the core revisions of the BCM4352 and
BCM4360) accept ring addresses with low bits set and then use bus
addresses, not offsets into the ring, in the index and status registers.
They are detected as brcmsmac does it in _dma_descriptor_align(): write
0xff0 to TXRINGLO and see whether it sticks.

On such an engine keep the ring address in the new ring->ptr_base, add it
when writing TXINDEX and RXINDEX and subtract it when reading RXSTATUS.
The ring address registers have to be written before the control word
enables the engine, and the hardware defaults of burst length,
outstanding reads and prefetch control (the *CTL_KEEP masks) have to be
preserved.

Engines that keep offsets behave as before.

Signed-off-by: Andreas Wendleder <gonsolo@gmail.com>
---
 drivers/net/wireless/broadcom/b43/b43.h |  1 +
 drivers/net/wireless/broadcom/b43/dma.c | 52 +++++++++++++++++++------
 drivers/net/wireless/broadcom/b43/dma.h |  3 ++
 3 files changed, 45 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/broadcom/b43/b43.h b/drivers/net/wireless/broadcom/b43/b43.h
index c0d8fc0..e1e8083 100644
--- a/drivers/net/wireless/broadcom/b43/b43.h
+++ b/drivers/net/wireless/broadcom/b43/b43.h
@@ -668,6 +668,7 @@ struct b43_dma {
 	u32 translation; /* Routing bits */
 	bool translation_in_low; /* Should translation bit go into low addr? */
 	bool parity; /* Check for parity */
+	bool ptr_is_addr;
 };
 
 struct b43_pio_txqueue;
diff --git a/drivers/net/wireless/broadcom/b43/dma.c b/drivers/net/wireless/broadcom/b43/dma.c
index 05da698..20d910a 100644
--- a/drivers/net/wireless/broadcom/b43/dma.c
+++ b/drivers/net/wireless/broadcom/b43/dma.c
@@ -212,7 +212,7 @@ static void op64_fill_descriptor(struct b43_dmaring *ring,
 
 static void op64_poke_tx(struct b43_dmaring *ring, int slot)
 {
-	b43_dma_write(ring, B43_DMA64_TXINDEX,
+	b43_dma_write(ring, B43_DMA64_TXINDEX, ring->ptr_base +
 		      (u32) (slot * sizeof(struct b43_dmadesc64)));
 }
 
@@ -233,14 +233,15 @@ static int op64_get_current_rxslot(struct b43_dmaring *ring)
 	u32 val;
 
 	val = b43_dma_read(ring, B43_DMA64_RXSTATUS);
-	val &= B43_DMA64_RXSTATDPTR;
+	val = ((val & B43_DMA64_RXSTATDPTR) - ring->ptr_base) &
+	      B43_DMA64_RXSTATDPTR;
 
 	return (val / sizeof(struct b43_dmadesc64));
 }
 
 static void op64_set_current_rxslot(struct b43_dmaring *ring, int slot)
 {
-	b43_dma_write(ring, B43_DMA64_RXINDEX,
+	b43_dma_write(ring, B43_DMA64_RXINDEX, ring->ptr_base +
 		      (u32) (slot * sizeof(struct b43_dmadesc64)));
 }
 
@@ -690,9 +691,19 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			    & B43_DMA64_TXADDREXT_MASK;
 			if (!parity)
 				value |= B43_DMA64_TXPARITYDISABLE;
-			b43_dma_write(ring, B43_DMA64_TXCTL, value);
-			b43_dma_write(ring, B43_DMA64_TXRINGLO, addrlo);
-			b43_dma_write(ring, B43_DMA64_TXRINGHI, addrhi);
+			if (ring->dev->dma.ptr_is_addr) {
+				ring->ptr_base = lower_32_bits(ring->dmabase);
+				value |= b43_dma_read(ring, B43_DMA64_TXCTL) &
+					 B43_DMA64_TXCTL_KEEP;
+				b43_dma_write(ring, B43_DMA64_TXRINGLO, addrlo);
+				b43_dma_write(ring, B43_DMA64_TXRINGHI, addrhi);
+				b43_dma_write(ring, B43_DMA64_TXCTL, value);
+			} else {
+				ring->ptr_base = 0;
+				b43_dma_write(ring, B43_DMA64_TXCTL, value);
+				b43_dma_write(ring, B43_DMA64_TXRINGLO, addrlo);
+				b43_dma_write(ring, B43_DMA64_TXRINGHI, addrhi);
+			}
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 			addrext = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_EXT);
@@ -722,11 +733,21 @@ static int dmacontroller_setup(struct b43_dmaring *ring)
 			    & B43_DMA64_RXADDREXT_MASK;
 			if (!parity)
 				value |= B43_DMA64_RXPARITYDISABLE;
-			b43_dma_write(ring, B43_DMA64_RXCTL, value);
-			b43_dma_write(ring, B43_DMA64_RXRINGLO, addrlo);
-			b43_dma_write(ring, B43_DMA64_RXRINGHI, addrhi);
-			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->nr_slots *
-				      sizeof(struct b43_dmadesc64));
+			if (ring->dev->dma.ptr_is_addr) {
+				ring->ptr_base = lower_32_bits(ring->dmabase);
+				value |= b43_dma_read(ring, B43_DMA64_RXCTL) &
+					 B43_DMA64_RXCTL_KEEP;
+				b43_dma_write(ring, B43_DMA64_RXRINGLO, addrlo);
+				b43_dma_write(ring, B43_DMA64_RXRINGHI, addrhi);
+				b43_dma_write(ring, B43_DMA64_RXCTL, value);
+			} else {
+				ring->ptr_base = 0;
+				b43_dma_write(ring, B43_DMA64_RXCTL, value);
+				b43_dma_write(ring, B43_DMA64_RXRINGLO, addrlo);
+				b43_dma_write(ring, B43_DMA64_RXRINGHI, addrhi);
+			}
+			b43_dma_write(ring, B43_DMA64_RXINDEX, ring->ptr_base +
+				      ring->nr_slots * sizeof(struct b43_dmadesc64));
 		} else {
 			u32 ringbase = (u32) (ring->dmabase);
 			addrext = b43_dma_address(&ring->dev->dma, ringbase, B43_DMA_ADDR_EXT);
@@ -1080,6 +1101,15 @@ int b43_dma_init(struct b43_wldev *dev)
 		dma->parity = false;
 #endif
 
+	dma->ptr_is_addr = false;
+	if (type == B43_DMA_64BIT) {
+		u16 ringlo = b43_dmacontroller_base(type, 0) + B43_DMA64_TXRINGLO;
+
+		b43_write32(dev, ringlo, 0xff0);
+		dma->ptr_is_addr = b43_read32(dev, ringlo) != 0;
+		b43_write32(dev, ringlo, 0);
+	}
+
 	err = -ENOMEM;
 	/* setup TX DMA channels. */
 	dma->tx_ring_AC_BK = b43_setup_dmaring(dev, 0, 1, type);
diff --git a/drivers/net/wireless/broadcom/b43/dma.h b/drivers/net/wireless/broadcom/b43/dma.h
index f9f65bb..eddc882 100644
--- a/drivers/net/wireless/broadcom/b43/dma.h
+++ b/drivers/net/wireless/broadcom/b43/dma.h
@@ -90,6 +90,7 @@ struct b43_dmadesc32 {
 #define		B43_DMA64_TXPARITYDISABLE		0x00000800
 #define		B43_DMA64_TXADDREXT_MASK		0x00030000
 #define		B43_DMA64_TXADDREXT_SHIFT		16
+#define B43_DMA64_TXCTL_KEEP				0x03FC00C0
 #define B43_DMA64_TXINDEX				0x04
 #define B43_DMA64_TXRINGLO				0x08
 #define B43_DMA64_TXRINGHI				0x0C
@@ -118,6 +119,7 @@ struct b43_dmadesc32 {
 #define		B43_DMA64_RXPARITYDISABLE		0x00000800
 #define		B43_DMA64_RXADDREXT_MASK		0x00030000
 #define		B43_DMA64_RXADDREXT_SHIFT		16
+#define B43_DMA64_RXCTL_KEEP				0x03FC0000
 #define B43_DMA64_RXINDEX				0x24
 #define B43_DMA64_RXRINGLO				0x28
 #define B43_DMA64_RXRINGHI				0x2C
@@ -235,6 +237,7 @@ struct b43_dmaring {
 	u8 *txhdr_cache;
 	/* (Unadjusted) DMA base bus-address of the ring memory. */
 	dma_addr_t dmabase;
+	u32 ptr_base;
 	/* Number of descriptor slots in the ring. */
 	int nr_slots;
 	/* Number of used descriptor slots. */
