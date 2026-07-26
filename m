Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26FE31E820
	for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 22:19:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785104386; cv=none; b=i7Ba6EUWrKebvfEzMZgrCxbSwYQpJCKa/U9sQacLRzqynRZnR2oqgug1/++DnUh656p76xiX14jjyE5gzprp+TFKe5uvFLjllvWBRg5ZaQXBoMyLzhx3EvHnDFEeeE91AYNFVknVAg9fRaomo4hXBvZhkzZvV0ATOG83BASDKHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785104386; c=relaxed/simple;
	bh=pCxvSjqCYkt5Zfgngs+1WWF0RPmNFXqFVeTOns8A0yQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SoOeJrwuHa81t0hPMfxyFeRKDvEnCu4DzdmmG5I3U7zLjmWIFaWapRej9ZF9RBBNNG4jmDfkBtqu/KHoim1STtETT/2JPKa+xwStggDHBFA1E2ZZRBikN9pOU1D/+oX3v8T/fzbSgqB/hSXZ+815JYZM+Tfi0gVf34FEpkIZb5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=jLbWuHPb; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="jLbWuHPb"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c15f47e6297so206074466b.0
        for <linux-wireless@vger.kernel.org>; Sun, 26 Jul 2026 15:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1785104383; x=1785709183; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ge+jXIVUKhk6GV/kwzJHJ1+CtR1D1neebkAxki5LZgA=;
        b=jLbWuHPbSt9gTufCRHCbC/nYGVNYXNkA8vNEXMCXMF2f97ttqTHle28PXE2hFJegN+
         E8yTabojwpO96DFY6wXTWpApXqq15FoHnGHmAk/D/j5c8GpArtiSDfyOUdiGs1kin50d
         BIDKDYJSPdZZJoL4Y3uBxLtOVmNkUszGkepXud3sifL3o1RJXUX8C7H3ncQfkkZNCM3y
         p0SSPXxpECO83l/9kvlNqNzv13zV1SPs1fJtFqL9W3CfPJACeUtK7VEy3JBn1N8V4dbd
         Hajh7auu1sjoUx6yjWXDWkoLaf93+BGYKpSjxe8r2/XRzzxwegOM2IsiCAiIt9ogE59T
         l29g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104383; x=1785709183;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ge+jXIVUKhk6GV/kwzJHJ1+CtR1D1neebkAxki5LZgA=;
        b=RvaLni22T91xMXEOTQFdkhDhuUbT0htngPhSv48rVYoKhwE+jEUBs2Tzllemk8x/MQ
         TIJemvTx6l0yA+wduI+HTQJsinqfHFVNmK6tw7Lu1A4slj8pZrMKBcIxDpFmq+GNKRqL
         2UaVvgwkETKGn+yD9OCjkvV704i4+cbqqF6v9omJbSpk2RbSINZDX565VaM/I+XFQCgD
         wCFDjziZMHjmiD5MwIPY30wAjLiLV8tkYpPqZh2PzdubKjQVfpd6Xoe4m8JJd7BRhORq
         AnRq8iM2jcisTn9HgmF0gEKRArnLkdm/OtWHwQvmaajI93b0KW9VHQUW1bhw/36Akfsq
         F9rw==
X-Forwarded-Encrypted: i=1; AHgh+RrRXiDX+/1oYmPYDM5dB7XdGY8XDvYB15rXhmP/A1DdtMseoNFa5zd2xfDpS5A0Pne+dFT6Gil3AbdEvGvcXw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzTiZetFsYerrnenYfpGCp551v33ugkfGdZofXm63NUoGJe9MTe
	npUEDcl4p3MeTHkraX1twaeqUSZz2YVyRVKr/wXpCmPkJ0AI99wlABeFu78jYUEF1Q==
X-Gm-Gg: AR+sD103AP2+eutrqbFAorxRkwYYBevpjEj/mPtkz3v0jYb/Chs2kmOp2dR/5wR6WAT
	tLGRlUgx52zOLe05vd2her5QMm9Y4UcYocdMFcnbf0B3dccXtMNLDgPpr0Zxa9zz6XUBZimza/T
	hY5CnlIsXeL8CJeLz/h/SR45khQ7h9yhPTWTVE4rjvlylAL6fY0c8avjvAI2kXCcf0iDmIO38oC
	3AheMgZi6DUq/rchinzbJkxKP2Ylvm+XZ5a2RxWCHrhUFc0qhJ1lYC/lFmMj4dj5msuKYVEyfPq
	SD4SCj2v8kb06+1mCAMSRG5CM4UQv7aXOeoC123t2xgMspijGtbbHdzzQdAgNamjnOhKe4TsfSB
	YTjKHzJ4Klz/4fl40fIRVgqX7NJpNyoE0y4xcHAa+WLVwuAiS4kIDe4xhVH+W1gJvqlD/+wO68J
	6P7WH760w+p6ilIxqwPLa/9L9E4W8l1Y//yRkgBwy14woMNMm08bL4hFpGM6+g3F2ckBlPEOpML
	ZO6xRDLRNPLcF15O4wcWM6zc6tJHrNGWkGpRu8KtWsLMTj//FEbhG8j8gWW9KRGg8aNMTqO7g9P
	onGbuiR/gO76PgL0UguS5hkud0TtdklQr9ds0kTRigHLvI8Ue4izpn2b/k8U8L/npiZV5QyagKl
	Z7q9q/0bcsH+P9ehRRSrX9L3xE11AMSc=
X-Received: by 2002:a17:907:6094:b0:c12:9eb4:48bc with SMTP id a640c23a62f3a-c1f1f087285mr244592866b.51.1785104383116;
        Sun, 26 Jul 2026 15:19:43 -0700 (PDT)
Received: from Desktop (p54affe4b.dip0.t-ipconnect.de. [84.175.254.75])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32a76fecsm561599466b.8.2026.07.26.15.19.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 15:19:42 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: jjohnson@kernel.org
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	baochen.qiang@oss.qualcomm.com,
	vasanthakumar.thiagarajan@oss.qualcomm.com,
	rameshkumar.sundaram@oss.qualcomm.com
Subject: [PATCH ath-next v2 1/2] wifi: ath11k: implement CE interrupt enable/disable for AHB
Date: Mon, 27 Jul 2026 00:19:07 +0200
Message-ID: <20260726221908.104873-2-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260726221908.104873-1-julius@bairaktaris.de>
References: <20260726221908.104873-1-julius@bairaktaris.de>
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

