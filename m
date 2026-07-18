Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 463E71427A
	for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 07:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784360727; cv=none; b=Je+kPMnDiU1urZ81aQB0fp+7p34ivleFyY2XNKj0bu53y2G8AOB2Zhglm0ZbnlKZih+3MrlZY5YcK7BJhegqTeKyAHan+Vc5cScktxrIIrCbbWoiM9WCHekL1mtKKCbH4yOKJ3cjG6iIOMF8RsxeEAU2bE5MNoqOM2SsfzbZ8rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784360727; c=relaxed/simple;
	bh=vLJMBFwSvHTV7ro0RMeZwMqseUJXnE7dHXV5exqOQi4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BfXtYtBzgGu/HuN3k4MzxyGQGkyM80PkCJ8+mrK4psc/rDIk6C79MhQlUTjJwA3HZLhIQfNaGuTEbm72A8Ai+JCol0vpcoaYrbYjAOH6cOTrt1JL+ZOnGn0G2cWwSULEOCJNUW6nmElUPOpBj/dX75267I8uJC4kUXJC+pe+mZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mEwBcpbH; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mEwBcpbH"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2cf52d15d88so155105ad.2
        for <linux-wireless@vger.kernel.org>; Sat, 18 Jul 2026 00:45:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784360726; x=1784965526; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OFyV2Rkgf5HtfQYv0w6PI4pQpZkaJeMYAvZn1zRWRf4=;
        b=mEwBcpbHzGJ0op6afW6hCsjqyO2emHJcv1Ou2P37Y9sDsZYa7on3Sm9w9ma/CsNmsP
         XK4UFaxyhNkcr7LySZTbOwJWdswS0nhliolv3Kq5itrskqI5fzcN6a1agAJISq8N6Vg7
         8JfZS+G7tau+voHG0+o3vMdPxW9PHeoMFMI1yRngIfHVKz3yFJ3vy6wjhuAqrDmPWFYq
         YiDNxQ0l1nxgxYFIdUvuI75XyOsyDGv399G8MU1L/BMQG30qL+wgtwQeoXEKpIgnKOLD
         kEv+AIcaE+AQzs0bH8XSRltCw+1bByZf1HMarNY2qr0QUGw6w2rRrMvsewgYIErSk0fd
         F/mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784360726; x=1784965526;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OFyV2Rkgf5HtfQYv0w6PI4pQpZkaJeMYAvZn1zRWRf4=;
        b=YlEwG/4nqkaDKCNAu3tldNSGd3injSFk/fSlGDipxW7+9wXf0sW5qTwZY4rcN3W3U7
         YsBVIUW5F9hmX2vCZrwXRBZ6BXmu4QGJc5AMGZen4IlhwMGpStFOtHNhBNh/6NnLh3Sd
         Ll5Ht3w8gBA7N31vpR4r18lKnOt09RGAr6MRavRyIZpE6SyzfTmg0r0jFJr1f8to/7ke
         5zCaH3kddLhFSm23o1uMevBmV6A8NYSxWQiSPqMcIIwmV/WOU0CH2bPvAYDQfBiHy9F4
         wd+Tw6FEEuSc0Grti+0eQ89NbF2An6WudZFUse8jGxj7K60cvc80G7MPC9SX3Leket/Q
         PhKw==
X-Forwarded-Encrypted: i=1; AHgh+RrLNvhBGcH/obzb23urbCaek+hfN9SSDWMd+tTOfj5p+Pza/+R2EiJdlaUBmZ0BiFhEXx8KJzzD0ZZt06h7UQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4bBGmS5BkQvAr4nDxr7frvEb5uF1MBaMIRvbTFdVWm4Tf/vNu
	SwKw+3AxYAI6Nsn6ZZNEnCuGL7Nut6JetXTfA03P6v3QsH3eBt5a5xcs
X-Gm-Gg: AfdE7cm7Llm0yAIdHTyFFdJHvZ0npZDIiNdlbXt4Q1euA/bA7FBH38sBKjuwqPgQl+S
	kAecK3z5zcwwkagMpTvRkIFJ96JoaIj3WiNOdAygL7C6xoZkSKLYK/e4RZJXTXtjAyZWdPt/UNl
	r4c1sOSvrn1w4TM9tlKlAmd/J+ZNYs5u244jEf0zH4kTHFXL4VBR2uEL6GX4eGnz3rQk8be/jjc
	trWHQzgu7p6ep4AfJYr/VI+7NA+sp/893AxfkBwA4ouQlKbkL5W2MAUIcZG8sDWr7Pf2NKsUnaq
	Ng7HqPPcrZPzDu7FsXnv6imP0MYxif5ZujD6H5yKypak2gBaQ/t/86L8nzg8xOUYfquqWyFPAeW
	RYYkZ4a/RSGouMKiqLUxumXqBEPq/qXhE3p61V5UCaYm84tlBQsfKB1dV1EYYle8+N6w=
X-Received: by 2002:a17:903:1aeb:b0:2c9:b8b7:5d1c with SMTP id d9443c01a7336-2cf3486ef6emr68540395ad.16.1784360725629;
        Sat, 18 Jul 2026 00:45:25 -0700 (PDT)
Received: from lgs.. ([152.32.188.52])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf346da07csm23399685ad.52.2026.07.18.00.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jul 2026 00:45:25 -0700 (PDT)
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
Subject: [PATCH v3 1/2] wifi: ath11k: release QMI handle on late init failures
Date: Sat, 18 Jul 2026 15:40:25 +0800
Message-ID: <20260718074026.3085688-2-lgs201920130244@gmail.com>
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

ath11k_qmi_init_service() initializes the QMI handle before allocating
the QMI event workqueue and registering the service lookup.

If either of these later initialization steps fails, the function
returns without releasing the initialized QMI handle, leaking its
resources.

Release the QMI handle on the late failure paths.

Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index 410a7ee076a0..6e3f82169d24 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -3329,7 +3329,8 @@ int ath11k_qmi_init_service(struct ath11k_base *ab)
 	ab->qmi.event_wq = alloc_ordered_workqueue("ath11k_qmi_driver_event", 0);
 	if (!ab->qmi.event_wq) {
 		ath11k_err(ab, "failed to allocate workqueue\n");
-		return -EFAULT;
+		ret = -EFAULT;
+		goto err_release_qmi_handle;
 	}
 
 	INIT_LIST_HEAD(&ab->qmi.event_list);
@@ -3342,9 +3343,14 @@ int ath11k_qmi_init_service(struct ath11k_base *ab)
 	if (ret < 0) {
 		ath11k_warn(ab, "failed to add qmi lookup: %d\n", ret);
 		destroy_workqueue(ab->qmi.event_wq);
-		return ret;
+		goto err_release_qmi_handle;
 	}
 
+	return ret;
+
+err_release_qmi_handle:
+	qmi_handle_release(&ab->qmi.handle);
+
 	return ret;
 }
 
-- 
2.43.0

