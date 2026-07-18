Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450A81427A
	for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 07:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784360736; cv=none; b=Ck9PM/Zxl0Y+m19h2eZCSYKxhoWLeWECUfBojZCjtS47C9euDgLZ1jbmHoGKYftpvb0NN5X5Gfh6srsNqgtRKVYxIaFn3CDHT6fT4GaBjHxjbZ58aCYxYDB1smiotVQDOKCkgg41x7Fq6tJTDiULffcNffZjAJx1E3YpduFYF2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784360736; c=relaxed/simple;
	bh=z6yAepMcHqHIO6UCMXqsAEl4y5azk4w8xeHZF5gYDHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOuIXJQQcbRvQt3H11XCZ06bHTxwoWXNuVI8YfQ4KifMI9MoaOlVcxuSVowquuJ/t089CE/Mu858OfP51QM09NLL7hcsU7lSicOIg6+gqdYIJAfxSdSAolJnaexoZt+5+5XOdm+gbsgI/boIpSbVbDTedLdzGrcTai5XvdRERvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iHMpIHlL; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iHMpIHlL"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ceae1ed204so63045065ad.0
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 00:45:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784360735; x=1784965535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o6FMRb6Ton81+XDkPtgEkIQhf4bCKKZGg7F18DbjTnE=;
        b=iHMpIHlLcgDKg6CotKgnsjTFkWmSE0/BVkCqYoa0FHZDaAcVudaFDq3Do8qBUoT2B1
         npWLXkWzIlQZfNHw1TkV0pOmvQ3nQa7TKVJTn42eRSfsvnp4VTEMEUrAuOrSD+ihvSwN
         wCpsepeR3zJJucFv6llTteF875WiSTtzEpuUqqh/odJj8FqYFVhHWuLaNbAmlzHB+vZ0
         I81YKJswtf6WuymJt6iv9+4c2GbbfmViF28m2O7qVitQzM9ChXaQp/nT2O/vzRpN5mw5
         D/C4wOceenS8yrO8R6yBCIz/enUMfOHBicfiGOvf1ekb0UpISf4PPiWFPygVTuLh9hvl
         ToLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784360735; x=1784965535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=o6FMRb6Ton81+XDkPtgEkIQhf4bCKKZGg7F18DbjTnE=;
        b=H1B3mIuc1R+yeM1X8tR2yxe6bmVtcjTYcPHuY9Y9CVm49hahmk3Sg91ff7+Y16kmov
         1tlJ9m0qLTyQRXqDyyvmIsxEjLsYftQdbb/Dy5qFdatkI8FM9igeV6jKzu64CbLewRuT
         1Uv9JFhpgxxhp1U/cnwLkNOsBvY43+NUavEzbqvXYsP1GrE96eg7B1VVlCD5OKjYEujv
         jg4y3Qla877ENpCGwQPqjfKlJFtL+p8WZnli3iXCwnU9p7a8cirk7S6eV+6Iz3K74oY2
         YcTbayNHC6Wmzb5vLu2AyKyqS7BpD1A3sTI2GM+FDrv62ypLVnw3wCd3M8nJA21e46Ir
         QbVw==
X-Forwarded-Encrypted: i=1; AHgh+Rr6Eoj5rRijP/WcXmC5NoYi4G9qVbewl47kCk9aXf11rZEsrg4cCMU4X92/wihhtEAsmPx7YBMFYMXgCPOADw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxbKesmCamJfsDr/RXmeLrT55H8nziEHe8LjGPcjDP/c20nrDS4
	DfqiE2fGvvr3vpxYEzq7LJp8U4pL4yaVEGzYoySAnSL1lO+peHcYCVcl
X-Gm-Gg: AfdE7cmFfC14H91SGMsAFlGROaV1RPboINgd7JnPCPrQKAXYyGiCxQXM0fCgJQjbR7n
	3hIiXUCQEUnQ5czr3ionxwN0noYm2LfIny3XkNe3I1XXjkTrbcigFdtL7ckej2JTPL2PNqePNed
	Q5FUUif7KML1+q9AiVNhRGHAacJFwT/LoTRedWOPODHeQ3WxUgWc+VFkpMRV5U1F0FJpHjZqH+3
	88wvwG+064NqbTOBS/pv8xOJYtVnIOctUns0wtprTithWRGM2p96sGTkdE/idArbfGDqHf69kq4
	WLdtfQWr9GCoRWPjZMvZlHzE4Zr4H16L0Yd/5jHEiZXyaQkvvs2U+slAQJ9RM4JeUHUdOayDE8A
	euUeZCucdxR3sw3IiZBKn6DxAAROhwUFQ9J8gjFcmUEDjGFOfu/ofLiZ7RyKfPf9XmB0=
X-Received: by 2002:a17:903:234d:b0:2cc:f4d4:29a7 with SMTP id d9443c01a7336-2cf3499781cmr65687175ad.24.1784360734636;
        Sat, 18 Jul 2026 00:45:34 -0700 (PDT)
Received: from lgs.. ([152.32.188.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf346da07csm23399685ad.52.2026.07.18.00.45.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 00:45:34 -0700 (PDT)
From: Guangshuo Li <lgs201920130244@gmail.com>
To: Jeff Johnson <jjohnson@kernel.org>,
	Pradeep Kumar Chitrapu <quic_pradeepc@quicinc.com>,
	Vasanthakumar Thiagarajan <quic_vthiagar@quicinc.com>,
	Sathishkumar Muruganandam <quic_murugana@quicinc.com>,
	Anilkumar Kolli <quic_akolli@quicinc.com>,
	Ganesh Sesetti <gseset@codeaurora.org>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ath12k@lists.infradead.org
Cc: Guangshuo Li <lgs201920130244@gmail.com>
Subject: [PATCH v3 2/2] wifi: ath12k: release QMI handle on late init failures
Date: Sat, 18 Jul 2026 15:40:26 +0800
Message-ID: <20260718074026.3085688-3-lgs201920130244@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260718074026.3085688-1-lgs201920130244@gmail.com>
References: <20260718074026.3085688-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath12k_qmi_init_service() initializes the QMI handle before allocating
the QMI event workqueue and registering the service lookup.

If either of these later initialization steps fails, the function
returns without releasing the initialized QMI handle. Since the failed
device is skipped by the hardware group rollback path, the handle is
leaked.

Release the QMI handle on the late failure paths.

ath12k_qmi_deinit_service() uses ab->qmi.ab to determine whether QMI
service initialization completed successfully. Set it only after all
initialization steps succeed.

Fixes: 088a099690e4 ("wifi: ath12k: fix error handling in creating hardware group")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/net/wireless/ath/ath12k/qmi.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/qmi.c b/drivers/net/wireless/ath/ath12k/qmi.c
index fd762b5d7bb5..692f1b2c2031 100644
--- a/drivers/net/wireless/ath/ath12k/qmi.c
+++ b/drivers/net/wireless/ath/ath12k/qmi.c
@@ -4041,7 +4041,6 @@ int ath12k_qmi_init_service(struct ath12k_base *ab)
 
 	memset(&ab->qmi.target, 0, sizeof(struct target_info));
 	memset(&ab->qmi.target_mem, 0, sizeof(struct target_mem_chunk));
-	ab->qmi.ab = ab;
 
 	ab->qmi.target_mem_mode = ab->target_mem_mode;
 	ret = qmi_handle_init(&ab->qmi.handle, ATH12K_QMI_RESP_LEN_MAX,
@@ -4054,7 +4053,8 @@ int ath12k_qmi_init_service(struct ath12k_base *ab)
 	ab->qmi.event_wq = alloc_ordered_workqueue("ath12k_qmi_driver_event", 0);
 	if (!ab->qmi.event_wq) {
 		ath12k_err(ab, "failed to allocate workqueue\n");
-		return -EFAULT;
+		ret = -EFAULT;
+		goto err_release_qmi_handle;
 	}
 
 	INIT_LIST_HEAD(&ab->qmi.event_list);
@@ -4067,9 +4067,16 @@ int ath12k_qmi_init_service(struct ath12k_base *ab)
 	if (ret < 0) {
 		ath12k_warn(ab, "failed to add qmi lookup\n");
 		destroy_workqueue(ab->qmi.event_wq);
-		return ret;
+		goto err_release_qmi_handle;
 	}
 
+	ab->qmi.ab = ab;
+
+	return ret;
+
+err_release_qmi_handle:
+	qmi_handle_release(&ab->qmi.handle);
+
 	return ret;
 }
 
-- 
2.43.0

