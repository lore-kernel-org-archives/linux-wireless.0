Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.21.23.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793537944;
	b=WZLNDVl2dfyMKTtuIHh5YSH8I2yyJvfm+35kQHUm2HYKpqFl+avDau+A+KwWLIxQiZ2E
	 4Nh0GIvFfjrXkGItr3NAP5nx5afmZuBj6ut4C0bu9LeBmH+67elS6POrqc6CTpRfubwto
	 Tk7cCgKQHktOBuE/UhaGnlAnvKO2qQ5fMo59+yP/cLNfJWFCZr7kMVGADftNzWiDZ2lIa
	 snzuuzgxNH490eZAwI/T5RKnR1jsBxi+DuV8vXG1dbjElEK5bXotIYwvxa8S+45pamoAp
	 QZl4wo5Afif/kP1Jv6KK/z6UDf2S1apyWSsuOpYCWaPcifo/XZSzBBqf4eNri/b/q5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793537944;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:From:
	 To:Cc:Subject:Date:Message-ID:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=n6s0PbgjoxExCuhdVbLCqymraLrHLOREUbqNiOJDGAo=;
	b=aMzIk5A6jcM0FWr6a2Sdl5gaFQ5lYIOvEf4sl/bcWAUa9HRU7OvsRnoF0aPfjS6AxjWB
	 jJmmqpjtyg38NxG2xEymFBWuh4Ti+J8n1RwSO7jeNvza26P6/8LZ6oITRFPWLbqK1HGwT
	 DrjNg76EPfgQ9CvvMIXBiNkO7+sCNBNulY0sQyEr1E1+B9IfclJv1m9XvpLOeqQF6HcMT
	 Wk3MGzOJSFo9SfKooagRHnSqQTg5X5ow69mwcGJavRZR+pK/XU56oOhYMsoHgnbfH93OI
	 YjAFIC/jLzSkgPh7PwgegRXMLNx2BVDOgt82+WkZD7x0LKsbpyYHvGoF7BSRJxxHtGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=disroot.org;
	spf=pass smtp.mailfrom=disroot.org;
	dkim=pass header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=Ah3+st6H;
	arc=none smtp.remote-ip=178.21.23.139
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896FD606A32E;
	Sun,  1 Nov 2026 12:59:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 896FD606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=Ah3+st6H
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 91D9F80736;
	Sun, 01 Nov 2026 13:58:56 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id FvKG7l_Ws-ol; Sun,  1 Nov 2026 13:58:55 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1793537935; bh=ZLT1WbLas04zpKBdCe4IEe1IgdHhHJeTD5MXp7RfssU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ah3+st6HlE/ZHo2/14wlrBD1qWmRrCn6eSKK+/vvrff+DIQRbOsJxrLIEZzAp7LF0
	 GvuYJxFteyEEml65xc7hO1lohNFH4HIflS+bVFWYKToRKEB0riECRcHCmIEI0yIN7C
	 rN9vty2aX84kkrUBhIPYtQ9SEdsDhL7eVLcU0mswWc9Cld5UF7Py5+4M3LR0Wl7QtS
	 VEFQTZBAH/Xf5C67BUqDWgXmkfvFt+KbMmjxzQc3kYvYLQOhcIOJ8JV8zZR3vy8W78
	 BVY+TG3RaKMM4kJASmGOhlXnAeWgHbyZos/QA7rijOr+PoNIXFfV5BohXL0AafCQJY
	 MhtMNRyg9kgLg==
From: Florian Maurer <fmaurer@disroot.org>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: Florian Maurer <fmaurer@disroot.org>,
	ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Julius Bairaktaris <julius@bairaktaris.de>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Miaoqing Pan <miaoqing.pan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Subject: [PATCH ath-next 1/3] wifi: ath11k: don't disable ext IRQs twice
Date: Sun,  1 Nov 2026 12:58:01 +0000
Message-ID: <84ffca34cf7f76d6642dfeb9f2b1a34c288d5234.1793531790.git.fmaurer@disroot.org>
In-Reply-To: <cover.1793531790.git.fmaurer@disroot.org>
References: <cover.1793531790.git.fmaurer@disroot.org>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k_core_reconfigure_on_crash() disables the IRQs at the start of
every firmware recovery and ath11k_core_qmi_firmware_ready() enables
them again at its end. If a recovery fails, they stay disabled. The
next recovery disables them again, so the disable depth of the ext
IRQs goes to two and the single enable_irq() leaves them masked. The
DP rings would then not be serviced after an otherwise successful
recovery.

This is the same kind of imbalance as the one fixed for suspend/resume
by commit e56c9d429ba0 ("wifi: ath11k: fix unbalanced IRQ enable/disable
during suspend/resume"), but caused by a failed recovery.

NAPI already handles this: it is only disabled if it is enabled. The
ext IRQs are only enabled together with NAPI, so only disable them if
NAPI is enabled as well. The pcic ext IRQ code has the same pattern, so
change it there too. The PCI CE IRQs (ath11k_pcic_ce_irqs_disable())
can have the same imbalance after a failed recovery; they are not
changed here. The AHB CE IRQs are not affected, as they are enabled
and disabled through register bits without a disable depth.

On IPQ8074 (AHB) this shows up when a failed recovery (forced with a
test patch) is followed by another firmware crash: the recovery reports
success, but TX completions stop, TX fails with "failed to transmit
frame -12" and the firmware asserts again repeatedly. With this change
the same sequence recovered 3 out of 3 times. The pcic change is
compile-tested only.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: f7a74e131d3f ("wifi: ath11k: disable interrupts during firmware crash recovery")
Signed-off-by: Florian Maurer <fmaurer@disroot.org>
---
Hardware-tested on IPQ8074 with [1] backported to backports-6.18.55
(OpenWrt 25.12), build-tested on ath-next with [1].

[1] https://lore.kernel.org/linux-wireless/20261018210153.1925962-1-julius@bairaktaris.de/

 drivers/net/wireless/ath/ath11k/ahb.c  | 4 ++--
 drivers/net/wireless/ath/ath11k/pcic.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 27d01411b6e9..3ff7d5f27f5e 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -235,9 +235,9 @@ static void __ath11k_ahb_ext_irq_disable(struct ath11k_base *ab)
 	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		ath11k_ahb_ext_grp_disable(irq_grp);
-
+		/* The IRQs are only enabled together with NAPI */
 		if (irq_grp->napi_enabled) {
+			ath11k_ahb_ext_grp_disable(irq_grp);
 			napi_synchronize(&irq_grp->napi);
 			napi_disable(&irq_grp->napi);
 			irq_grp->napi_enabled = false;
diff --git a/drivers/net/wireless/ath/ath11k/pcic.c b/drivers/net/wireless/ath/ath11k/pcic.c
index 2259adc3bbdc..2e7dfa8388b0 100644
--- a/drivers/net/wireless/ath/ath11k/pcic.c
+++ b/drivers/net/wireless/ath/ath11k/pcic.c
@@ -455,9 +455,9 @@ static void __ath11k_pcic_ext_irq_disable(struct ath11k_base *ab)
 	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		ath11k_pcic_ext_grp_disable(irq_grp);
-
+		/* The IRQs are only enabled together with NAPI */
 		if (irq_grp->napi_enabled) {
+			ath11k_pcic_ext_grp_disable(irq_grp);
 			napi_synchronize(&irq_grp->napi);
 			napi_disable(&irq_grp->napi);
 			irq_grp->napi_enabled = false;
-- 
2.47.3

