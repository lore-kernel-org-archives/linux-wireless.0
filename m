Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B33930E0CC
	for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 14:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784989113; cv=none; b=Srtm3DALpzCn+mCcAXUN/Ee6wIXi/MQBuI3NzF165AnNSvF43GeUChd+3H8SpUicK54uD7tijxaA2xZJyip6+dAdOg04/EYK42FTJR68lltzQ2wz37P5RnYhUPTZj3nvEfTaTwjrIdcMCBW2Ui0yeRNknF4n+jlrafggRnysY70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784989113; c=relaxed/simple;
	bh=pCxvSjqCYkt5Zfgngs+1WWF0RPmNFXqFVeTOns8A0yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bbrxTDA8wy7sgHNF823uUELsMH8TKx1VsBu8yTnjqHmPNAaVRPTVZCnsGAVGgdJQv4DH5YgG11pQeqiks5By0AWrQXAaRq1zWoGkdX4vtf3tV+Wp9AheSHIXHP636jzyN/b+SIRCkHJqWjYW9N6HqNtLv+xWNgtrOLUZ7SD94zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=JYNXSVTW; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="JYNXSVTW"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69e2266b07fso1669729a12.2
        for <linux-wireless@vger.kernel.org>; Sat, 25 Jul 2026 07:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1784989110; x=1785593910; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ge+jXIVUKhk6GV/kwzJHJ1+CtR1D1neebkAxki5LZgA=;
        b=JYNXSVTWabLZ2qTtogsVLDPxXleByFhTCPjwcNdA2IZDlUuuNnl996pX+cgY1C70U+
         9Ir4BUYkNwqWE4OHlR+i+VqFPdlrRz1/4RrOoXQ5SI74kKg4/v/BxV1xMGXpvljm8geB
         8F1ndrF3nOenicghA6z2rBuIElkviBgGIgt+lUmLflfUUNfEkWno1gZlT3D5rbI1fMaB
         Tif6ukDQkXgRlTLFF2j+xFf3xif9hbk318fVNWEG/OyMZpCe7zMcJLgsb5KrR/s0elFL
         Hk+iBjHlhYaWDxC0WjJt/PW+xK9PfkuvF//vfuFk/0Z3eBgOKDOlarB3JxFt4g7CdxTv
         Tarw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784989110; x=1785593910;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ge+jXIVUKhk6GV/kwzJHJ1+CtR1D1neebkAxki5LZgA=;
        b=ZeRBDZi9aixSh14SVWAKFa2ncB6VKxBSeweA1ZmnyPq1RErAa/xIqcc0NaFgHO5Zw0
         lQ6YcLzg7M90iTLRePEuY9xUrp6WTDSahEWbjJEOkZoK8sGmRLmYwrRzDKKcIbuEkY/K
         LKzmATekgCTV8tkq3QUMkW+zCD9CPakNDo7WmLN3xTguG+oRmZj9TlFEsvWd5RzRRbVP
         vooauuJJTjuupETV1y9lyrw+pPQfrbHOVQAuTV1x49SWnmQ2NzrvhWOR10nY+CmvHLYD
         L1wcWfY4YlwBmiZIPSsEgNe06WI3zR0Im4aNH3HXsfnNo4aT7LdEQvka098tM++rV91m
         YybA==
X-Forwarded-Encrypted: i=1; AHgh+RrW0ALuE582idbEKSYUqdcIdZL128RMOFepwtMaNKrnZhaB/2h+qrCqbcdwklu9EgLmaiI9bOndjWFZKNo8EQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2W9zgbtVYmnTrcTJ82OOtoW6CICsqN1OwzX5dKy7X4paUMo+W
	1qC/UbGC6nduYQoUxRnsYdgsx6lNpNIeEqzNlwuw363qB3dnCEqrORwrE7h2PusZDg==
X-Gm-Gg: AR+sD13+Sg5lzZTsSJTBDxZq+duKXvNbVXG7qv8HDsPxhRd8fXkpYXG7W7A6g55rIGe
	pjIPYyUlK1vaatZeDR3RhcYB0qCBpkEZOem+l+1bZhbjlZbe4bUvwXq10YCG8bIro0SVo0pAwZD
	n4hxgTkoRitjQVAwdazIOxrLjR3Ta8NGzp30cWdPq9gHwOA5k4Fafuqjhih3F7gpUlvjfuIqRaV
	/BJsNTgCtJ+IfjwydC+AbUrbwq2UpG3F7h7kWPWP7T0BCOQI23JqlXZWrycdsAjAGuMNXNTTfT9
	GMlF69RKiju9aFFdkK2dIwz5KMz3o22mmr2a6TUFSWsyAhoBQk91tHIrUeL/O96VH3YghovVkLy
	r6v51UugOb0Z8d75h4l4HxajEhCIUkTWCUrk5EhVXfBmpjufocM6/K4Z8wIaSk3s6k1qHf5XwYJ
	R2A0zvf86z4CEZiNL+IOqAdt5abrd/SgW300bKBFqa45ePRuKyj9i6dcewqWhIvRrbITZHlIMVw
	AWhlHg6LihCfXDR7PRDrNiA70GfT+rIiwdUyYZaQFlgDk9ZpeFAmfPCezj0gMQjYwjC9+dsDMFL
	212cC5ShmBs4HdadpqxuEPlu4OweQhlQV/EVyaWUkNvUVEKJU8Q4NLNmE2Fqta69R7AhIHMaAaH
	uH3TF+KiqSTYi0XBAMUq1fOjBXg3kZmY=
X-Received: by 2002:a05:6402:1f4d:b0:697:564c:9095 with SMTP id 4fb4d7f45d1cf-69fc115f3a7mr1011176a12.21.1784989110217;
        Sat, 25 Jul 2026 07:18:30 -0700 (PDT)
Received: from Desktop (p54aff063.dip0.t-ipconnect.de. [84.175.240.99])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-69fb594622asm894010a12.26.2026.07.25.07.18.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2026 07:18:29 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Subject: [PATCH ath-next 1/2] wifi: ath11k: implement CE interrupt enable/disable for AHB
Date: Sat, 25 Jul 2026 16:17:56 +0200
Message-ID: <20260725141757.1316877-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260725141757.1316877-1-julius@bairaktaris.de>
References: <20260725141757.1316877-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k_core_reset() calls ath11k_hif_ce_irq_disable() right before it
powers the target down, but ath11k_ahb_hif_ops_ipq8074 never set the
ce_irq_enable/ce_irq_disable pair, and ath11k_hif_ce_irq_disable() does
nothing when the op is NULL. On AHB the copy engine interrupts and their
tasklets therefore stay live across rproc_shutdown(), where the register
space they touch is no longer accessible.

Wire the ops up. The sequence is the one ath11k_ahb_stop() already runs,
factored into a helper and reused, so behaviour on the stop path is
unchanged. wcn6750 is not affected: it uses the pcic ops, which
implement the pair already.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index f566d699d074..72da6919c277 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -391,12 +391,17 @@ static void ath11k_ahb_ext_irq_disable(struct ath11k_base *ab)
 	ath11k_ahb_sync_ext_irqs(ab);
 }
 
-static void ath11k_ahb_stop(struct ath11k_base *ab)
+static void ath11k_ahb_ce_irq_disable_sync(struct ath11k_base *ab)
 {
 	if (!test_bit(ATH11K_FLAG_CRASH_FLUSH, &ab->dev_flags))
 		ath11k_ahb_ce_irqs_disable(ab);
 	ath11k_ahb_sync_ce_irqs(ab);
 	ath11k_ahb_kill_tasklets(ab);
+}
+
+static void ath11k_ahb_stop(struct ath11k_base *ab)
+{
+	ath11k_ahb_ce_irq_disable_sync(ab);
 	timer_delete_sync(&ab->rx_replenish_retry);
 	ath11k_ce_cleanup_pipes(ab);
 }
@@ -773,6 +778,8 @@ static const struct ath11k_hif_ops ath11k_ahb_hif_ops_ipq8074 = {
 	.map_service_to_pipe = ath11k_ahb_map_service_to_pipe,
 	.power_down = ath11k_ahb_power_down,
 	.power_up = ath11k_ahb_power_up,
+	.ce_irq_enable = ath11k_ahb_ce_irqs_enable,
+	.ce_irq_disable = ath11k_ahb_ce_irq_disable_sync,
 };
 
 static const struct ath11k_hif_ops ath11k_ahb_hif_ops_wcn6750 = {
-- 
2.53.0

