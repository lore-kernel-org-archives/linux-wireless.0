Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D21E2D3EEB
	for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 21:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784498312; cv=none; b=ehelUFkf51q2hlpAM1cX+becgGJPrUaNbjsCtKLf5kKVrgR0GgVmWknmhr9KpRqdWsJQMIHfpcohr91hi6MF8E+l/yWeN7GVsDJe7AaDODUtOWujz0LbnbOk0gGQ0W/aO+7o81MkgqGi46/hscDVBrCe3vgDSYecoeM6OfNuhOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784498312; c=relaxed/simple;
	bh=1B6rqbxNuM0TmUWsekqFMBdCRmCHOivnfMvlfy3CedY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GpmbKHlN+aycuOt6u6Olp8awFfL+NwzDT0BPbRxurCNuWbQ+e13/DvnVlmIN2kM9DDqLIdRMT5Jr0/VhNfcs0KzW3+zG479beTf5hX+0oIk9KRwMYZsQsmtVsGirfDs4x49rtiJscIKrfKS+i8hRnFDFSMkHB0rqiq6dS5XJBMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ana3rDMy; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ana3rDMy"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-69c5f6f7a40so8070396a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2026 14:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784498309; x=1785103109; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/sGXqOXERG0g5LCnDxjc6HxcIh4ePUmjqAzBWTaTJ4M=;
        b=Ana3rDMy90OAwpwn3GtY62AENXOVTbD6Pdn4US6f5R12hJ5a3O2clsELb508+EuYo5
         nvoMAv+N8BwY23jbi6O6BXnkGRwXtFXPKxsK6G6jCOJpA600/1CDgI1ybeeUdvFUx6Cf
         chKyAJ6I8wWENZDWE2C36WylEdrn9xQb04FkIbM8zU0tid0gYSDHkeyeXzHTpKMW2qrh
         WMr8aqMVaDglfV5Px+E2XnbyxkKob9zdC6v4UyMjUyuGOHNg+NWklV2hm0j0IxMo3caQ
         uUxtDfvsxKf9sZMemhID77xMU6sx0ML8IxZOSdnl83/7/AGW7EoS9ll217lkCerJ4U+s
         V22Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784498309; x=1785103109;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/sGXqOXERG0g5LCnDxjc6HxcIh4ePUmjqAzBWTaTJ4M=;
        b=ESkEzxGzxkjL2n9Hr1Sf1PYCNXKAq5lM/k/BnmDlga4LXkWjTp1fmxRuoVNAYahmDb
         pbuggNDTkGn2HZOBEAQCvVPUio886yHkmXr482JixqpsyV7iZbTlVjd5UDmr/INYkrs4
         ubyH5iKrNtEMpvmIQMLGGDaCbBfSue4r4wnK75gRkLcfAup4JkSup+ULK9AMTSIh2ckN
         EuIqjMv3gVDbtYc+rc0DGHrO9sxfTyai1us7Q+aqkhoEBfdFnhTIDgZ3JKWdFa+lwkbY
         y7aaDN+4/GEIrTUqMOFsRGkaR1nRcmOGyk55qlrutShmGHvxwCYp8Xrc8nEOPPWGIbk3
         Zf6A==
X-Gm-Message-State: AOJu0Yw+72lm0GwKcory9SIhT0Yv97AclrsjmY+4QLnqd7LAeLL5AcFI
	Mx3jIYxWN5dDK22wKMefBzh0dB12IEy7mJcs1OxVhqAug71/PWs3FX4Ap0B7lGJB
X-Gm-Gg: AfdE7ckfG3KA8n58pDPjlJM+cAZlGupXewqy4P+MqZoZVL0Zyg0EaAX3bgwn0+ir8hL
	t8gYscIRi4gvkKrwLRJA0Xz3Ut4eKDpUjtNTX1K9pGEwTr/WBacYK1RmpIpN9GK4Y8E5QIK6fkN
	O3YFnzAO/EN2VWfAMaz0Y2FgM14EGlr9EFfgq/QAKixfdlHxFscuWz998A7JOl6GN3IHd6CFbSC
	K/3Nbsig6pLn2v9D30LRGvjWS3I6hzJC9AE4Xcsaar+SvMO+DzyJSnpczA6AKE/EeZ8gIzAKivW
	i3zpZICumcDDjiAxxME6vPyYT3Jlcwcb11ns5LfvP9aRZjfMMJWHmhbvguvi3wjNgfW9UzWluYR
	1fmf2o5beEvM5IZvEOf77CJdHSYQr7T7EkjFuMCBsJ8bAq2I9T/PTF8ldSVIHXJdkSC8ZQFNL9Z
	QJcbNVmWSJyF7RAPft5uE1cQsU
X-Received: by 2002:a17:907:78e:b0:c12:cacc:92c6 with SMTP id a640c23a62f3a-c16b48890abmr432532666b.59.1784498308387;
        Sun, 19 Jul 2026 14:58:28 -0700 (PDT)
Received: from nv-msd-x1c.mtdk.labs.mlnx ([212.60.125.8])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c16eb80bbf8sm379116766b.0.2026.07.19.14.58.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 14:58:27 -0700 (PDT)
From: Mark Ruvald Pedersen <wabsie@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Jeff Johnson <jjohnson@kernel.org>,
	ath11k@lists.infradead.org
Subject: [RFC PATCH 2/3] wifi: ath11k: make external IRQ control idempotent
Date: Sun, 19 Jul 2026 23:58:16 +0200
Message-ID: <20260719215817.2468580-3-wabsie@gmail.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260719215817.2468580-1-wabsie@gmail.com>
References: <20260719215817.2468580-1-wabsie@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ath11k tracks each external IRQ group's NAPI lifecycle with napi_enabled,
but calls the physical IRQ enable and disable helpers outside the state
guards. Repeating a lifecycle disable therefore increments Linux's IRQ
disable depth on AHB and multi-MSI PCI even when NAPI is already
disabled. One later enable leaves the IRQ masked.

Move each physical group transition inside the matching NAPI state
transition. Preserve the ordering: mask IRQs before synchronizing and
disabling NAPI, then enable NAPI before unmasking IRQs. The outer
synchronize_irq() calls remain unchanged.

This makes sequential lifecycle transitions idempotent. It does not
change the temporary disable/enable pairing in interrupt handlers and
NAPI poll completion.

Fixes: d943fdad7589 ("ath11k: Fix napi related hang")
Fixes: bbfdc5a751a6 ("ath11k: Refactor PCI code to support WCN6750")
Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.9.0.1-02146-QCAHKSWPL_SILICONZ-1
Signed-off-by: Mark Ruvald Pedersen <wabsie@gmail.com>
---
diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 1e1dea485..1f1562ff3 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -235,9 +235,9 @@ static void __ath11k_ahb_ext_irq_disable(struct ath11k_base *ab)
 	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		ath11k_ahb_ext_grp_disable(irq_grp);
-
 		if (irq_grp->napi_enabled) {
+			ath11k_ahb_ext_grp_disable(irq_grp);
+
 			napi_synchronize(&irq_grp->napi);
 			napi_disable(&irq_grp->napi);
 			irq_grp->napi_enabled = false;
@@ -380,8 +380,8 @@ static void ath11k_ahb_ext_irq_enable(struct ath11k_base *ab)
 		if (!irq_grp->napi_enabled) {
 			napi_enable(&irq_grp->napi);
 			irq_grp->napi_enabled = true;
+			ath11k_ahb_ext_grp_enable(irq_grp);
 		}
-		ath11k_ahb_ext_grp_enable(irq_grp);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath11k/pcic.c b/drivers/net/wireless/ath/ath11k/pcic.c
index 2259adc3b..bf367f60b 100644
--- a/drivers/net/wireless/ath/ath11k/pcic.c
+++ b/drivers/net/wireless/ath/ath11k/pcic.c
@@ -455,9 +455,9 @@ static void __ath11k_pcic_ext_irq_disable(struct ath11k_base *ab)
 	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		ath11k_pcic_ext_grp_disable(irq_grp);
-
 		if (irq_grp->napi_enabled) {
+			ath11k_pcic_ext_grp_disable(irq_grp);
+
 			napi_synchronize(&irq_grp->napi);
 			napi_disable(&irq_grp->napi);
 			irq_grp->napi_enabled = false;
@@ -490,8 +490,8 @@ void ath11k_pcic_ext_irq_enable(struct ath11k_base *ab)
 		if (!irq_grp->napi_enabled) {
 			napi_enable(&irq_grp->napi);
 			irq_grp->napi_enabled = true;
+			ath11k_pcic_ext_grp_enable(irq_grp);
 		}
-		ath11k_pcic_ext_grp_enable(irq_grp);
 	}
 
 	set_bit(ATH11K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags);
