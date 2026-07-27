Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF323DAAB7;
	Mon, 27 Jul 2026 06:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785135382; cv=none; b=Y1xu8Pc3FTdFwbK+kCxKJwYyUlYD5LIMM3P41nUVgk92iVb0eq5O3dojhPtNc7XbYCnAwduiQ+/k2rvOAIa+S0YSlINgVk9H+nqoOnKqQ+gJ6YZpirf+aJYrWU74Ce8amU2GsRawUExt7gYpeeSfrIW/lnM1acC8aUAqFMar9nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785135382; c=relaxed/simple;
	bh=NxU8e+bPov3rtcSWUmRjNtEoxnmc4Hw1555us7rmVTA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=L/5NPhaL/rUCPUSbESPOf2JJzyV/ocIdgFrTV6oM45EJPIBAwT9weDw7sAuO0OxkNsT7zSDq7YJpGWpV9oRGp+mjFgd6vJ6gxGTS3i2hFJYVvjcVtCZmJL7XCcx2LIwrc6udrtpZhgwEqW9fqULW5ZqrZ4oFSQCO/32JX1cpmIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=dBLcnyiK; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="dBLcnyiK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785135329;
	bh=Rosy1wCktcS98FwRDjqxeO5XxPGL8VLdM4pItsVHI1M=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=dBLcnyiKPtk6+KLv5pfHY7dys1AisJXQ4LElwm3GluKeBdm7Fzm5w6XNfo4cSFa3g
	 MO9yX3yJlaJJCqG4jHhfRpFcMIEEPgY0PyBZjakht/i4N1e9UXazB+UuhCvVj8N+Rs
	 Ugn0fzwIObiQPC3RD+gzBoufn7tmzQ8jJ5CU7Lw8=
X-QQ-mid: zesmtpgz4t1785135312tb82a62d2
X-QQ-Originating-IP: GqdLyO/vAIsqHGj9nNGTsUj7QmJopR3NXpfXnDHWlBc=
Received: from localhost.localdomain ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Mon, 27 Jul 2026 14:55:05 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 2773040718902600654
EX-QQ-RecipientCnt: 7
From: ZhaoJinming <zhaojinming@uniontech.com>
To: jeff.johnson@oss.qualcomm.com,
	baochen.qiang@oss.qualcomm.com
Cc: ath11k@lists.infradead.org,
	jjohnson@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	zhaojinming@uniontech.com
Subject: [PATCH v6] wifi: ath11k: fix resource leak on error in ext IRQ setup
Date: Mon, 27 Jul 2026 14:55:00 +0800
Message-Id: <20260727065500.3827035-1-zhaojinming@uniontech.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <b6903572-52cc-4c41-b9cf-5845e387c176@oss.qualcomm.com>
References: <b6903572-52cc-4c41-b9cf-5845e387c176@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: MGxrRyrvqqSAGwWtLqyUyH0Iw3Nu7kl/ExU8J52ak5QlpPH++fQDLlAf
	BHQA2QdtOSplqFsjLcIn+WQa2KNMJajLeiUC+flSmC8SBr4IS+4blR7j7TwntnSe75TgTYd
	K7SI8iqCjefB/xu6HJdrllnVj9ujnAmpbIBKEOUW0YxzrnIifyTBHxK5vdPc76p7hPti5uw
	Q448LBWDhjt8GtcPKPr0F9n1+q4oWVMEUy9IksWH7ZCUIQ7wNx83X1l1EKZwu+x2vTSGNSu
	fDsfZCfNfJGdv6bIZR8Edp+Vx2TIkZvHqceI9r50tkk4OLAzjT4zUg8pymKJRg9G+M1Hj5o
	ZEwWSYNN1fKeXjQn04gWQWm2cw7c5rEBz4utt7YYoAQBfj5GFfUbc4LyIx8Cd0v+95qZ2k7
	CMdrHbk5PByrt/rSfDGF56y6yet2zTAtW1SvQh9+TF1eqLx/q931tYoDGtZjGPSenitSKrH
	WmGRgVQDx3+BlE5cQ68wSaPzNWxhSLywYyWWtB8KkEWKbaHAG7KNaLPBRKMNLtLiMIUx6mM
	5bg6OZpeVlHRujRdgNKccfXSpJKULWTi2f8Pnwec2KJ9zSFKhb0qLTjQygteu1sKj+jeLCS
	brCtu7sNwHzfJnZfGwofux6hx/hWqxx1duzuvNy46+ApC6nVirFvpshJlp0MoJJ7GiBD/xG
	1svkXNIwp4UfYFi5O33mzvgm/MdXCsTvU7IBjhlUj84cOKQ+mFF/SBJb850nbwDwDCVTRCI
	SuF/hPWabpULJs4uBmvIZAPfex1Aavg/6Uzmv+4c9JGqwurt5RgkBqi5aYhIsDKuYvPzKWa
	aKsKDd7D0WyQyzeYOJFwlnpoOoqyz6HujjZQkBQErcVRUW0VNzY3Otn3a2qg+CLGNZXUAbz
	roprvOW/ziaxjG0aH/K4BHBAWotlDhkx/v+KwouJTwtdlWQfJjYN6jne6HeoY19XZsetiOr
	p8801vlsOvXqN3DBlU1V85iw9o40MQIHEQN9w1WNWtRSuQ2/Zt/Edn1iHOgvLl+vQEk0M3S
	qexiVzjQiDaLOxLzeleKlh18jWtZ/fC5QtasSHbmP97Kz7uJ1lUnBQFxG7000=
X-QQ-XMRINFO: M/715EihBoGS47X28/vv4NpnfpeBLnr4Qg==
X-QQ-RECHKSPAM: 0

In ath11k_ahb_config_irq(), when a CE request_irq() fails, the function
returns the error immediately without freeing the CE IRQs that were
successfully registered in previous loop iterations. The probe error
path does not call ath11k_ahb_free_irq() either, so the previously
registered CE IRQ handlers remain attached to the interrupt lines and
are never released.

In ath11k_ahb_config_ext_irq(), when an external request_irq() fails,
the error is only logged and the loop continues. The function then
returns 0 indicating success, leaving the device in a partially
configured state where some external IRQs are not registered. This
causes enable_irq()/disable_irq()/free_irq() to be called on
unregistered IRQs during runtime and remove/shutdown, triggering
WARN_ON(!desc->action), and missing interrupt handlers lead to data
loss.

Additionally, if alloc_netdev_dummy() fails for a later IRQ group, the
function returns -ENOMEM without freeing the ext IRQs and napi_ndev
that were successfully set up for earlier groups.

Fix all three issues: propagate the error up to the caller and unwind
all successfully registered IRQs and allocated resources on failure.
Also move ab->irq_num[irq_idx] assignment after request_irq() succeeds
in the ext IRQ path to match the CE IRQ path and avoid storing a stale
IRQ number on failure.

Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---

Changes in v6:
- Move ab->irq_num[irq_idx] = irq after request_irq() succeeds in the
  ext IRQ path to match the CE IRQ logic and avoid storing a stale IRQ
  number on failure.

Changes in v5:
- Resend as a fresh thread. No content changes from v4.

Changes in v4:
- Drop the napi_ndev NULL guard in ath11k_ahb_free_ext_irq_grp() as it
  is unreachable in all existing call paths. A silent guard against an
  impossible condition hides bugs instead of exposing them.

Changes in v3:
- Extract ath11k_ahb_free_ext_irq_grp() to handle per-group ext IRQ
  cleanup and refactor ath11k_ahb_free_ext_irq() to use it.
- On request_irq() failure in ath11k_ahb_config_ext_irq(), immediately
  clean up the current group via ath11k_ahb_free_ext_irq_grp() before
  jumping to the error label to unwind earlier groups.
- Move u32 num_irq declaration before the irq_grp assignment to follow
  declaration-before-statement ordering.
- Extract ath11k_ahb_free_ce_irqs() to handle partial/full CE IRQ cleanup
  and refactor ath11k_ahb_free_irq() to use it, replacing the duplicated
  err_ce_irq cleanup loop in ath11k_ahb_config_irq().

Changes in v2:
- Move `irq_grp` declaration from for-loop body to function scope to fix
  compile error in err_request_irq error path.
- Set ret = -ENOMEM before goto err_request_irq on alloc_netdev_dummy()
  failure to avoid returning uninitialized value.
- When ath11k_ahb_config_ext_irq() fails, unwind the already-registered
  CE IRQs via a shared err_ce_irq cleanup path to avoid leaking them.

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 1e1dea485760..ec5bf5c9fd79 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -431,36 +431,44 @@ static void ath11k_ahb_init_qmi_ce_config(struct ath11k_base *ab)
 	ab->qmi.service_ins_id = ab->hw_params.qmi_service_ins_id;
 }
 
-static void ath11k_ahb_free_ext_irq(struct ath11k_base *ab)
+static void ath11k_ahb_free_ext_irq_grp(struct ath11k_base *ab,
+					struct ath11k_ext_irq_grp *irq_grp)
 {
-	int i, j;
-
-	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
-		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
+	int j;
 
-		for (j = 0; j < irq_grp->num_irq; j++)
-			free_irq(ab->irq_num[irq_grp->irqs[j]], irq_grp);
+	for (j = 0; j < irq_grp->num_irq; j++)
+		free_irq(ab->irq_num[irq_grp->irqs[j]], irq_grp);
 
-		netif_napi_del(&irq_grp->napi);
-		free_netdev(irq_grp->napi_ndev);
-	}
+	netif_napi_del(&irq_grp->napi);
+	free_netdev(irq_grp->napi_ndev);
 }
 
-static void ath11k_ahb_free_irq(struct ath11k_base *ab)
+static void ath11k_ahb_free_ext_irq(struct ath11k_base *ab)
 {
-	int irq_idx;
 	int i;
 
-	if (ab->hw_params.hybrid_bus_type)
-		return ath11k_pcic_free_irq(ab);
+	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++)
+		ath11k_ahb_free_ext_irq_grp(ab, &ab->ext_irq_grp[i]);
+}
 
-	for (i = 0; i < ab->hw_params.ce_count; i++) {
+static void ath11k_ahb_free_ce_irqs(struct ath11k_base *ab, int max_idx)
+{
+	int irq_idx, i;
+
+	for (i = 0; i < max_idx; i++) {
 		if (ath11k_ce_get_attr_flags(ab, i) & CE_ATTR_DIS_INTR)
 			continue;
 		irq_idx = ATH11K_IRQ_CE0_OFFSET + i;
 		free_irq(ab->irq_num[irq_idx], &ab->ce.ce_pipe[i]);
 	}
+}
+
+static void ath11k_ahb_free_irq(struct ath11k_base *ab)
+{
+	if (ab->hw_params.hybrid_bus_type)
+		return ath11k_pcic_free_irq(ab);
 
+	ath11k_ahb_free_ce_irqs(ab, ab->hw_params.ce_count);
 	ath11k_ahb_free_ext_irq(ab);
 }
 
@@ -524,20 +532,25 @@ static irqreturn_t ath11k_ahb_ext_interrupt_handler(int irq, void *arg)
 static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
 {
 	struct ath11k_hw_params *hw = &ab->hw_params;
+	struct ath11k_ext_irq_grp *irq_grp;
 	int i, j;
 	int irq;
 	int ret;
 
 	for (i = 0; i < ATH11K_EXT_IRQ_GRP_NUM_MAX; i++) {
-		struct ath11k_ext_irq_grp *irq_grp = &ab->ext_irq_grp[i];
 		u32 num_irq = 0;
 
+		irq_grp = &ab->ext_irq_grp[i];
+
 		irq_grp->ab = ab;
 		irq_grp->grp_id = i;
 
 		irq_grp->napi_ndev = alloc_netdev_dummy(0);
-		if (!irq_grp->napi_ndev)
-			return -ENOMEM;
+		if (!irq_grp->napi_ndev) {
+			ret = -ENOMEM;
+			irq_grp->num_irq = 0;
+			goto err_request_irq;
+		}
 
 		netif_napi_add(irq_grp->napi_ndev, &irq_grp->napi,
 			       ath11k_ahb_ext_grp_napi_poll);
@@ -585,14 +598,11 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
 				}
 			}
 		}
-		irq_grp->num_irq = num_irq;
-
-		for (j = 0; j < irq_grp->num_irq; j++) {
+		for (j = 0; j < num_irq; j++) {
 			int irq_idx = irq_grp->irqs[j];
 
 			irq = platform_get_irq_byname(ab->pdev,
 						      irq_name[irq_idx]);
-			ab->irq_num[irq_idx] = irq;
 			irq_set_status_flags(irq, IRQ_NOAUTOEN | IRQ_DISABLE_UNLAZY);
 			ret = request_irq(irq, ath11k_ahb_ext_interrupt_handler,
 					  IRQF_TRIGGER_RISING,
@@ -600,11 +610,24 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
 			if (ret) {
 				ath11k_err(ab, "failed request_irq for %d\n",
 					   irq);
+				irq_grp->num_irq = j;
+				ath11k_ahb_free_ext_irq_grp(ab, irq_grp);
+				goto err_request_irq;
 			}
+			ab->irq_num[irq_idx] = irq;
 		}
+
+		irq_grp->num_irq = num_irq;
 	}
 
 	return 0;
+
+err_request_irq:
+	for (i--; i >= 0; i--) {
+		irq_grp = &ab->ext_irq_grp[i];
+		ath11k_ahb_free_ext_irq_grp(ab, irq_grp);
+	}
+	return ret;
 }
 
 static int ath11k_ahb_config_irq(struct ath11k_base *ab)
@@ -629,16 +652,24 @@ static int ath11k_ahb_config_irq(struct ath11k_base *ab)
 		ret = request_irq(irq, ath11k_ahb_ce_interrupt_handler,
 				  IRQF_TRIGGER_RISING, irq_name[irq_idx],
 				  ce_pipe);
-		if (ret)
+		if (ret) {
+			ath11k_err(ab, "failed request_irq for %d\n", irq);
+			ath11k_ahb_free_ce_irqs(ab, i);
 			return ret;
+		}
 
 		ab->irq_num[irq_idx] = irq;
 	}
 
 	/* Configure external interrupts */
 	ret = ath11k_ahb_config_ext_irq(ab);
+	if (ret) {
+		ath11k_err(ab, "failed to configure ext irq: %d\n", ret);
+		ath11k_ahb_free_ce_irqs(ab, ab->hw_params.ce_count);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int ath11k_ahb_map_service_to_pipe(struct ath11k_base *ab, u16 service_id,
