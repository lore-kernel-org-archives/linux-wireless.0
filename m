Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA5064DD3BA
	for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 21:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792357328; cv=none; b=JcBMun1FrpEJOQ0TR2owJHMJjTaRXXgDE748YKB+qbIFhkxZcLpqzic98L1QWluEDoSpHjZMW0+EUOoEGudqI/c0Xl0ZfKnhKyiOGDvgbDtiIjkSf4cl95b/YhFbMYYIrFmTlzIZQUxwux6jKGNiekBYX/fqZKXc3Ek56tknw0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792357328; c=relaxed/simple;
	bh=6R9vF35/R9eECsbDvlUePkmHE6rzhr5u4rMbPcIUnFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhIPCktOf9TxB88heCsiCqcqM04VuNptZWCDKRHsKof/+nXKRJE3y/NIeCWWCwshSUtgkcH9e2qdgnSKOjqJXBbNXa8x4rrcbAEZloaVBq0njp0M6iETNEKXG2y6lQWxAMmg62CekvzUN7kM3SqI4ASaTdnFvUquVHMy24l5DKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de; spf=pass smtp.mailfrom=bairaktaris.de; dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b=0BSfFglh; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bairaktaris.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bairaktaris.de header.i=@bairaktaris.de header.b="0BSfFglh"
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c169ae1cb26so426257366b.1
        for <linux-wireless@vger.kernel.org>; Sun, 18 Oct 2026 14:02:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bairaktaris.de; s=google; t=1792357323; x=1792962123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=aj8L+YVgxbyCy/bomk7t39g1PV2NuQ1DlfD7Gi2csFY=;
        b=0BSfFglhBz4jxj6oaf5YpLumlnlv3NnZuKsJ6C9Tred52tLHP9aMc8oGxo0pTDA8UG
         M6QoAAQUbt55lTHtsw6rq0K0CZKL63dANgcw1yD8F/xqpDYyGwROKIWoWU6vQ9NJw2iy
         s96PWChW4stucuj9KMW8lvBKnEhxsdarGrSXIDANr08TBD2nbmav8ogCxVxRSG4mmWdx
         RIhXwu5Swp3TS1t1QFuC8xJWx9he3CjjioaA8urx90TtS4WM5rtHFlWhALfuDS1C7yZI
         f+1qnm+k2v3oEeV7cM7P5yJU9+hspN8FA1tKQSIfkcyTErRJu/CYPY+xVanDfSZW0Bj3
         8hQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792357323; x=1792962123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=aj8L+YVgxbyCy/bomk7t39g1PV2NuQ1DlfD7Gi2csFY=;
        b=XesMXkwEU8KdE9HcTrecFU/zt4FsN6Qo8mgt9kjF68oosL7BuZqakM6mJyC0rTWObt
         LVCzS9eeeud3WnKxwDXZNa7axEmpswCMMmiItu9bRKonmOCaGOHeThh0SiWZU6KtZUu3
         s+a0qCNJ8uzoJa7W3Oh+RfDgkxx1LHvDpNsrRhitydse3ZZqBKhgRlBDU6cZw8D1RQVB
         eF3FKsHtMjLjZmgwdxLaNk6hidXUScook71Kr52e53SC3N+5MV4Jl7oqOwDPPZ6SdBd8
         0laMHIKJ0tZfOVTg0akmAIXViCxVJ2kcQ7H1CA91vi4ruet4fzyBZH5sjw7Aksy4jMin
         u2qA==
X-Forwarded-Encrypted: i=1; AKwUvBzqPJkaZ18h9/TBqdSOrKRcLIAtopSsGknALY/tP7NGNnTIAsXyrxN2RR49tgxsu0N0VUD7Co7qfcfEi8Frug==@vger.kernel.org
X-Gm-Message-State: AFq9FYJGh6osbRYAJv7FiSMXM7ZaWzkDgtdKNboO9Y9T1bI2191nQN5U
	S9U1n7vp4cGYUAGMDE/J0v1Kmj0X78Wy2bCwqBZCfEyv0k9TsNdJWXj2Jr+iZ+pkAQ==
X-Gm-Gg: AYBFou2hkdHGcrZDV7TxFr0lXAhMTisRhZO/iKkyrqVK1W/EvaKH8wNIBpOcCMdwvsi
	tT6xmaw2RqCtWZpBAYwDx93OT3ANeik/LtQ8Sw1X+F8d0vSr9XBEFIoBpAqzQNtaZj4rPz0X4VC
	ta6vbvz2mgINpdeyVAEpNuePgVtRmdWuCOjme7MPK+biVTPUL83+l5lCIxdL9lZbUAWGMgqbhpG
	GVqQ2vTMWUjQWnZzRbwENok7LoCNuQASaHJBmeS/bcpz3mum/t7p12XW6GyOOGNgGArFFkRHJae
	ryPYYwjw54FXNTlOKDxxA7fm+TpLbMB93bw/FXVCkp83jghqrjeNBWI7dI2Ta3ih9Bq0WQuQERF
	6Or9orCZthC03ACWB/2gRWGtaocVMJGNTTdukyn062yCBsUF1OZ2P++jYIbel4ZZ36TYwGBYrNl
	LveAQ2Hhui2B6qPcj6YpM2swDueXcyFpjCiLDGsg6K5KwXqXjSXF0YDAHCYDkhucAVPQ8cHFGER
	gXtTEL0JDAWbWWtjagViJYB75+MTzTBYdyb7XP7BzRVPazCmcz2B8x82SPYO3PLU1GY+qJVi978
	DrQtQAxwjoXAsYgtTS9FhyHD3ZG0hivWwCJZ+SyG+bXAoIsvh/Bpj9QrawRqNgoh1nOy8KEKCN0
	aa06PjQrljywzOq+bFSbnlW7ZCCZ6fIY6f1yZ8bzxykm/YbTy8HCx0sbnzQMRsso5lJDda9ajhS
	1862Yxvj2o
X-Received: by 2002:a17:907:c510:b0:c2d:cdc6:8271 with SMTP id a640c23a62f3a-c4020cf900amr786044966b.13.1792357322673;
        Sun, 18 Oct 2026 14:02:02 -0700 (PDT)
Received: from Desktop.fritz.box ([185.181.130.213])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40912cefd4sm291618666b.35.2026.10.18.14.02.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 14:02:01 -0700 (PDT)
From: Julius Bairaktaris <julius@bairaktaris.de>
To: Jeff Johnson <jjohnson@kernel.org>
Cc: ath11k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	P Praneesh <praneesh.p@oss.qualcomm.com>,
	Kalle Valo <kvalo@kernel.org>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	John Crispin <john@phrozen.org>,
	Sriram R <sriram.ramachandran@oss.qualcomm.com>
Subject: [PATCH ath-next v2 3/5] wifi: ath11k: keep the srng allocations when a firmware recovery fails
Date: Sun, 18 Oct 2026 23:01:51 +0200
Message-ID: <20261018210153.1925962-4-julius@bairaktaris.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261018210153.1925962-1-julius@bairaktaris.de>
References: <20261018210153.1925962-1-julius@bairaktaris.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since commit 32be3ca4cf78 ("wifi: ath11k: HAL SRNG: don't deinitialize
and re-initialize again") recovery zeroes the hal state instead of
freeing and reallocating it, but a failed recovery still calls
ath11k_hal_srng_deinit(). This frees the ring pointer buffers and the
ring configuration, which only probe allocates, while the rings still
point into them. Driver removal then walks the copy engine rings through
the freed buffers:

  ath11k c000000.wifi: failed to reconfigure driver on crash recovery
  ...
  Unable to handle kernel paging request at virtual address
  ffffffc080ee5090
  pc : ath11k_hal_srng_access_begin+0xc/0x60 [ath11k]
  Call trace:
   ath11k_hal_srng_access_begin+0xc/0x60 [ath11k] (P)
   ath11k_ce_cleanup_pipes+0x16c/0x4cc [ath11k]
   ath11k_ahb_stop+0x2c/0x3c [ath11k_ahb]
   ath11k_core_deinit+0xec/0x168 [ath11k]
   ath11k_ahb_remove+0x30/0x90 [ath11k_ahb]

Return the error and keep the allocations for ath11k_ahb_remove() and
ath11k_pci_remove() to free.

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1

Fixes: 32be3ca4cf78 ("wifi: ath11k: HAL SRNG: don't deinitialize and re-initialize again")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: Julius Bairaktaris <julius@bairaktaris.de>
---
 drivers/net/wireless/ath/ath11k/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/core.c b/drivers/net/wireless/ath/ath11k/core.c
index dd256853bab57..daa3751d75233 100644
--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -2352,15 +2352,11 @@ static int ath11k_core_reconfigure_on_crash(struct ath11k_base *ab)
 
 	ret = ath11k_core_qmi_firmware_ready(ab);
 	if (ret)
-		goto err_hal_srng_deinit;
+		return ret;
 
 	clear_bit(ATH11K_FLAG_RECOVERY, &ab->dev_flags);
 
 	return 0;
-
-err_hal_srng_deinit:
-	ath11k_hal_srng_deinit(ab);
-	return ret;
 }
 
 void ath11k_core_halt(struct ath11k *ar)
-- 
2.53.0

