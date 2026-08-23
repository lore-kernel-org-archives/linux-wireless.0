Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB77A3603FB
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 19:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787515060; cv=none; b=s9GHEXdzuaAeRA+U6ptDzwK5s8xArVbgL5sR7MxK+zrFxNSNH88VnO0t9FQxhRtanU3YptA9tuByJNCcyda66GUtz2+1otwBvnP2NLd9aeQi/f3igxLPfripONEd/Uj3Wdkid7ICryGUHHdaBl1o230uA8LryggUQjnL58z+BW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787515060; c=relaxed/simple;
	bh=szRQI05HgxKaZ6DD6iGBYhm/R7wACl49f6sU49pF69Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D8YbCzHMuTvBiJlSjzAwkKgLMh4L+qBMao5GP7jI3Ikd6mnqf6kuHfyoFegM5Qu8wxz2jUVxTibebwGi7z29mWRzGA4AVfsGSOulVBwdKA6J2r11j4EZ2Hx0ZosqVfM/KBBP77X1sxhJbc0hpzXHbBloGcLiMeQMeg1fsnJewow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=tQJA+7so; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="tQJA+7so"
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-c2022323c37so429100966b.0
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 12:57:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1787515057; x=1788119857; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RRfRf2Fgkto2eylatQTpTDlM8qkBEZ0zYa2j5Lueb1w=;
        b=tQJA+7sooPjYTqQIRJ9hnVbQ5d4rGDS6CQcGMbJPebY5ha6PNAaqPTf3JR9jaJDy9G
         Szf4hrn7It21DWqErRqGoWsVx1iWJdFzo0N4LWe6IettUS2m3fjnTCraQtMI7dRdNHaq
         CbUcpAHv0zOJ+U6143wILwG63fGncwPrHVCjAU0DlTYBf0/A2QWk83vNPfqvIvLLaEcx
         mLy6BBKzmxogu6THIaEBoxSuY92sI60L/DgCvPhPJs3CRzKpxXLLYsqIa7WiOt9bYW4M
         EdROfGx/BNvFWvwZht1ABuxrtcusUKHkNDSx0ffZS0TBzVrww0qog4cGZ5/C7MVqJM7P
         ACCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787515057; x=1788119857;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=RRfRf2Fgkto2eylatQTpTDlM8qkBEZ0zYa2j5Lueb1w=;
        b=F5SQGa6yu5tRgBWxn1QUH3BltH4wLE1TrD8bUgm5ysvRXVCZgL6zzwIeeHqkgKv3db
         uJ6ro5imJoNLUhAuS0lwIUs9QBcBWT9j53TFxaXIkHAHDrGQUhNFVF3gCawWLOJCDyEC
         v7mY8k7SUNBl8/0cU6N7Anu2sd6W0sbQku4npy4DrGTp5PIXD/Xt71AUUCQEn3z066rV
         AoQ56eG7kEZRRDelC7GxlcbWp95kLULnKbi/1R1jVY18bFaRsjpU2OpDshD0cOvs04vC
         htaEwrgz+NEY19YUqeSclsRJni0Brrnyn96ARXIxd7b3OELePFxX5/4nI2l/0DAXtk1f
         /PbA==
X-Gm-Message-State: AFuF++lGhxxeV9pprggpOjMOWCjn0Qq5IucEnRgAKi0iINDLiXhLKEcJ
	TaSUYpFyTlw/4jUU6f3yw/3pJ+99p+meCVOzIFTW2feJOo3GxsGcHt4kFxpNrMqOpQ==
X-Gm-Gg: AR+sD13JUpxu4MbhSFuVv5S4ts2RBP/DuAmIHlhasB340rOYtcW7YJP6faacZ8W79TO
	Zg/207GT/C8Tndj2Rsq9VWel3HT8KjWqxzDcpe6N7XGPqyrGfSd/WliH6k00D5DRJWn53xJd+dZ
	PdD5A6wZMCoQpvA2MTQK2VDjqM6J7uz8Ez1VpOMwzihc1Ohhf/a7L9jd8UELn6OlEPj5jnJDZQQ
	Wo4VaUmGGM51Mj6PxVfnvk4VV8xrkh+CWyOKwDLdUz9a0J7ssOpttAd1JN7a/x4KaScV6DjZaCj
	8FXve4qeFwW/ueD6JEFAPtABBl6M/nWnwkZ6kjwKfoajr8vd2l18H6jvQRuTLevNRsmjaq8rVgS
	zHIbmw1Nqf0+LNC+2KIKHtCmBKXLpZP9vylAoHYTBtFVax+yj/xVM1/DmMYcidmmNKFHBaB+N3G
	bdQrY+IVz+cbwzJrXL2s4Dmjp0AhIgggXN9EaDXz2AGG40/v1MPrRV0gTQqi3oK18P9pkVSdpN1
	huTFas+to57f7wGjD9dQFMKBSQy9WwnfX5PXdRWk7qJytjMczw3ZC3LXQQkW2Y+CUrtdCJ6XBMu
	Pxew01rlVa3wQd2a70vmGNIX2Bt6mofUxnZZIk3lKIsiuqT/G+dXAsQHFuyUyFUjnr7JA+U3VCf
	tXtg0HzDVGNwPySLuFQQnnt3GZGoGZMMSAsYVJKsyCkogl/WMh/123fes5hCQgytgCMgAG5FaxY
	t5ybtC5uSn1b/o
X-Received: by 2002:a17:906:ee8b:b0:c20:f6d9:d8c7 with SMTP id a640c23a62f3a-c246a6b0db6mr2450731666b.24.1787515057030;
        Sun, 23 Aug 2026 12:57:37 -0700 (PDT)
Received: from Desktop (pd9513a95.dip0.t-ipconnect.de. [217.81.58.149])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c249606a8edsm889532666b.6.2026.08.23.12.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 12:57:36 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [PATCH v1 3/4] wifi: ath11k: report the pending tx MSDU count in soc_dp_stats
Date: Sun, 23 Aug 2026 21:57:02 +0200
Message-ID: <20260823195703.49198-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260823195703.49198-1-julius@bairaktaris.de>
References: <20260823195703.49198-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ar->dp.num_tx_pending counts the MSDUs the hardware has not completed
yet, and is used to wait for the transmit path to drain. It is never
shown.

soc_dp_stats can therefore say when the transmit path overflowed - TCL
ring full, misc transmit failures - and not how deep it is at this
instant. The bound those counters report against is the tx descriptor
idr, DP_TX_IDR_SIZE entries per ring, which is large enough that
occupancy rather than exhaustion is what characterises the path under
load.

Print it per radio, beside the failure counters it complements.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Assisted-by: Claude:claude-opus-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/debugfs.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/debugfs.c b/drivers/net/wireless/ath/ath11k/debugfs.c
index 70922612d3fb..9dc586b68136 100644
--- a/drivers/net/wireless/ath/ath11k/debugfs.c
+++ b/drivers/net/wireless/ath/ath11k/debugfs.c
@@ -714,6 +714,18 @@ static ssize_t ath11k_debugfs_dump_soc_dp_stats(struct file *file,
 			 "\nMisc Transmit Failures: %d\n",
 			 atomic_read(&soc_stats->tx_err.misc_fail));
 
+	/* What the hardware still owes a completion for. The counters above say
+	 * when the transmit path overflowed; none of them says how deep it is.
+	 */
+	len += scnprintf(buf + len, size - len, "\nPending Tx MSDUs:\n");
+	for (i = 0; i < ab->num_radios; i++) {
+		struct ath11k *ar = ab->pdevs[i].ar;
+
+		if (ar)
+			len += scnprintf(buf + len, size - len, "radio%d: %d\n",
+					 i, atomic_read(&ar->dp.num_tx_pending));
+	}
+
 	len += ath11k_debugfs_dump_soc_ring_bp_stats(ab, buf + len, size - len);
 
 	if (len > size)
-- 
2.53.0

