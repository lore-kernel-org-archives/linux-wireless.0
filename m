Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC2943E7630
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 21:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791409160; cv=none; b=NNXTDJYgAkFMAG9KHUNCSaHYkQP26qZsHueMcfkIuWhMstd/C71J3rC01BADoTRzpWVUHt1oJB7Ck2DQugrcYtfzuM4yLKmrPP9VyiyPYHao35jSbNCIzNssajrw2/v1rnp2BsoZy7+nqCxswdyiWeu88ZJ1fJjiS/LxbD8ckOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791409160; c=relaxed/simple;
	bh=qv9rxTd0Hc9BHi43iLj6LCNvrEmdLH9xqf5EhgvBuGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8iFnYCa+Mw3GTf3Ig8pjN/2nJDNfkpAaY6HqRpEKqxT0rS6Rxk3tVGhQhUsAmv72l+NQXQg5kcKNpPJvzIxnA5UNVfzRefD7qmki/8qU1Ia3ZoiLuGTxxzTvetbd1OAg7yXCXRib/7N8iAw2wbKU7Zev+Rt9nyfGcYDAOzQFRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JA2nBwfi; arc=none smtp.client-ip=209.85.208.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JA2nBwfi"
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-3a9787a156eso18233671fa.3
        for <linux-wireless@vger.kernel.org>; Wed, 07 Oct 2026 14:39:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791409157; x=1792013957; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HL50aAuTc7iXXkRUx082+O87VcrVi0CqO+VpMmcaNUY=;
        b=JA2nBwfi/H/K7ADaoAkZqU2LjUrJqrRyPR/rh7ziKF4/eeTLKeASp3OSEgbXa5oz+u
         0ewmYHXAA4u7wWU212so66fPxeD/FFFCJMuHDAYBXlNB7+9xaRL87dPOAMrk42Cl+krL
         sa81raBz1Y4Ja/Fv+8vn/Q/58w/EFBgXcg6oTGslvrKn8Qyae5ONutLgjbRCXoGaV1AI
         XKF4fmvBkVNZknOo9Xi6inC1nOoSyTPNIFCOc2nD2u5Pk89PF93S0l6/pLEY139RY0hc
         oz0S2IeLLiAWR5UXwi1GES/9a55d6l3JdefUJmGnfuKbI3xEkZltPV+26dFMR7p7LIOx
         sU/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791409157; x=1792013957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=HL50aAuTc7iXXkRUx082+O87VcrVi0CqO+VpMmcaNUY=;
        b=ZLbBne9pY8cfOU2qdD6JSooRZEfqqOOtSO06DcVz71JmUD4PWA+rLkGZp1CrWZ10Ll
         gH4I493oe29JF80DNHC04aZu0QfzgYZtlVxbQMZd5yvHMiaDWopsGRLs4z0RTKXggajA
         O8XlzeU3VFWevetij1RiCD8838kHNqhAJSSBC8bs2e4b0dH+pbb2zYTz3Xd1nGBfQV4n
         ZkiCfd/rz9/XDo+dyOnDFzaTJbf5BI0kKuaJP/KfDm3Dfg9WaMbyeRXzRN2Y5ox5ibwr
         j0Acv1rNzqChIimFA1EEyxQvdwgbmljHj/WULLEhYXUBBRJABJjgTYOq4tNH8VNKZ2u2
         XvWg==
X-Gm-Message-State: AFq9FYKBdrINwDZHBRlRXdrT2TriYQOYI8962xx7sX5PFf3Q86sJPLza
	33/P6UiRi0axZ6z5eESOFjHILtotoR0WD5BC+V0BA8NuLduMOsCHStym
X-Gm-Gg: AYBFou11p1SY12vfQwlnV6FluYkYAGj2KWiAlG4pHwuNAK68YSxWVp08iTSbLM7c4F4
	v2N01XzeoU+63ZkFRGoG11lCWOXGp5nJcwknR//L0vjrD0HkiUeNZA3uMo4QaaoB9xSrW21G8TD
	rdE6r+1QuUelVIBX8HSUeXNSs1FUMxowADbKHnWS48oQ3yQxk6vKaPrnSVdw5BIJctK/t1c/+7F
	vjkCzaqoo75Id02IDpDp+4ffhdusV2aOSRNO82VKEAHDy8+cXOhkSvUVl/bw3OJgY1t5FQqGGq2
	84xXXdM+0Wu6YDAzRDaHG1v0NgZA8m1ToGHdUyGNUcsHe8UD4bO0OhjIx4ZyPvn0iGOWDu7lIiA
	xsRkEZWTswhuaHUMLLB48Mn6if/1c/I2Mg92W8iM8yg20iT/+9BUKV7+F0SLfXCHm//TuP3K5yp
	r3saogFn4by9BY0Pxr6OD3pmhsBEGFcdyZfmlaz2s/znYPEu+7IROCG0BPFXsxj3W/92EQgnyNn
	Ok=
X-Received: by 2002:a2e:bc0c:0:b0:3a6:55fa:a63 with SMTP id 38308e7fff4ca-3a9a2cf9a53mr8216851fa.16.1791409156559;
        Wed, 07 Oct 2026 14:39:16 -0700 (PDT)
Received: from Quarx2k-PC.lan ([92.124.138.168])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a9ae563df4sm1241411fa.30.2026.10.07.14.39.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 14:39:16 -0700 (PDT)
From: Nikolai Semendiaev <agent00791@gmail.com>
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	jjohnson@kernel.org,
	wabsie@gmail.com
Subject: [PATCH v2 1/2] wifi: ath12k: make external IRQ control idempotent
Date: Thu,  8 Oct 2026 03:38:28 +0600
Message-ID: <ccca0d5d087b862c3b41ab4d3c5849ca0dc2d32b.1791408913.git.agent00791@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1791408913.git.agent00791@gmail.com>
References: <cover.1791408913.git.agent00791@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The AHB external IRQ helpers change the hardware IRQ state even when
NAPI is already in the requested state. PCI has a device-wide enabled
bit guard, but also changes each group's IRQ state outside its NAPI
state check.

Tie each group's hardware IRQ transition to its NAPI state transition.
Mask IRQs before disabling NAPI and enable NAPI before unmasking IRQs.
This permits an extra IRQ disable before crash-recovery RXDMA teardown
without increasing the IRQ disable depth.

Based on Mark Ruvald Pedersen's ath11k IRQ lifecycle fix.

Link: https://lore.kernel.org/linux-wireless/20260719215817.2468580-3-wabsie@gmail.com/
Tested-on: QCN9274 hw2.0 PCI WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1

Signed-off-by: Nikolai Semendiaev <agent00791@gmail.com>
---
 drivers/net/wireless/ath/ath12k/ahb.c | 4 ++--
 drivers/net/wireless/ath/ath12k/pci.c | 6 ++----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath12k/ahb.c b/drivers/net/wireless/ath/ath12k/ahb.c
index 85360365a..a5eaf5bf5 100644
--- a/drivers/net/wireless/ath/ath12k/ahb.c
+++ b/drivers/net/wireless/ath/ath12k/ahb.c
@@ -182,8 +182,8 @@ static void __ath12k_ahb_ext_irq_disable(struct ath12k_base *ab)
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		ath12k_ahb_ext_grp_disable(irq_grp);
 		if (irq_grp->napi_enabled) {
+			ath12k_ahb_ext_grp_disable(irq_grp);
 			napi_synchronize(&irq_grp->napi);
 			napi_disable(&irq_grp->napi);
 			irq_grp->napi_enabled = false;
@@ -326,8 +326,8 @@ static void ath12k_ahb_ext_irq_enable(struct ath12k_base *ab)
 		if (!irq_grp->napi_enabled) {
 			napi_enable(&irq_grp->napi);
 			irq_grp->napi_enabled = true;
+			ath12k_ahb_ext_grp_enable(irq_grp);
 		}
-		ath12k_ahb_ext_grp_enable(irq_grp);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath12k/pci.c b/drivers/net/wireless/ath/ath12k/pci.c
index af0e882fd..d2a7b6719 100644
--- a/drivers/net/wireless/ath/ath12k/pci.c
+++ b/drivers/net/wireless/ath/ath12k/pci.c
@@ -458,9 +458,8 @@ static void __ath12k_pci_ext_irq_disable(struct ath12k_base *ab)
 	for (i = 0; i < ATH12K_EXT_IRQ_GRP_NUM_MAX; i++) {
 		struct ath12k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 
-		ath12k_pci_ext_grp_disable(irq_grp);
-
 		if (irq_grp->napi_enabled) {
+			ath12k_pci_ext_grp_disable(irq_grp);
 			napi_synchronize(&irq_grp->napi);
 			napi_disable(&irq_grp->napi);
 			irq_grp->napi_enabled = false;
@@ -1108,9 +1107,8 @@ void ath12k_pci_ext_irq_enable(struct ath12k_base *ab)
 		if (!irq_grp->napi_enabled) {
 			napi_enable(&irq_grp->napi);
 			irq_grp->napi_enabled = true;
+			ath12k_pci_ext_grp_enable(irq_grp);
 		}
-
-		ath12k_pci_ext_grp_enable(irq_grp);
 	}
 
 	set_bit(ATH12K_FLAG_EXT_IRQ_ENABLED, &ab->dev_flags);
-- 
2.43.0

