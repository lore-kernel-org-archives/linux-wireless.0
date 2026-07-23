Received: from smtpbguseast3.qq.com (smtpbguseast3.qq.com [54.243.244.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44BC7304BA3;
	Thu, 23 Jul 2026 01:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.243.244.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784770767; cv=none; b=hlQSegS2WQ2VZ1x/6wtSjSY08Wqjrf9+aX6BeAy9IvWSmdPB55md4O0A2YsY+/hPSMm5TRdcJfWZsO31USgXfEurZ9jiJm6yniznb1o+j0yWDuYPzqTWrKHDQXoa4YYuAD52v/EF+azgUrRLIPAQQpW8nMp3TSWGUhKBwAGzRjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784770767; c=relaxed/simple;
	bh=BOqqBFnPpVANiD8OON81zfenD+3YnZ5x7wsLOPv25zs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pQ4AffF3ObQC0bbTr95FocnJO1N9oNd9wIA2SrlDQu6Ah73AyZdYiFSjYR/Gj7DTSdAPa8NlRjN/NkwdzzOkitb1YTDuy4U9gz9QfEf91oy6g0D7yvPC8CQCAssN9tRQci8rGJ7RJ1HWCbOLRnKy6NkkjiOWkPJAzGjf+8K/IR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=EyWYNLBV; arc=none smtp.client-ip=54.243.244.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="EyWYNLBV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784770713;
	bh=BZZCMgTc6Qpm90dVS5kUlCRBNWLrsac5twh5hXLhuJ8=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=EyWYNLBVyZN/tHM4lM+AQz+Kq6rHYeKcbmMG1oA7Cjd5S4EHtdHhDikzNzy5C65PC
	 r2u3+9Tp0P4vcdiuNY2XYGpRiC5NjRmSSPAVGFVLvEHJD5NR8CSkcMWy/BfOV+DeK4
	 ADm6GgdkUxmDR1Zev1pQuQIOEOzjZaY7H0gXSvNo=
X-QQ-mid: esmtpgz14t1784770708ta189610b
X-QQ-Originating-IP: A6DQINafxgQzSQyXQu+pza8+iljXGTqtrScNmwKObvY=
Received: from localhost.localdomain ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Thu, 23 Jul 2026 09:38:21 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 18330324833723850564
EX-QQ-RecipientCnt: 6
From: ZhaoJinming <zhaojinming@uniontech.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ZhaoJinming <zhaojinming@uniontech.com>
Subject: [PATCH v5] wifi: ath11k: fix resource leak on error in ext IRQ setup
Date: Thu, 23 Jul 2026 09:38:18 +0800
Message-Id: <20260723013818.393470-1-zhaojinming@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpgz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OGYfdWl7iR1yuPssp9Zj6CgFvXNk12OhlBepBYU2f1Ib5JzMeHaNC4Ck
	pMU0xJgCL/cAJsc2E4DlGxYjtjFtQWnE2VJiO4Wpcf00Lvq21qf3hC0q5QkNKPFlgT5y8x2
	/bq2+CRz0XB9OwghecMzf5KhS0XZE7Dc8FiYvX3qcpQtqi8Ie41tAlKrJNB/DE7PDcuzelO
	Wqs4qf3vxIRYEKYkZecTR5b2qaE7+7IXgv8raNvmuBuMglPLR6aMdb8yrfIDlEPtndhyNP7
	LgXtG5r4LmN2pCgNpLzP08A16fhVak8K9aXYulLwiP94T69V6Vk11V/aLP+uoyZS9OjFIWX
	nrXC02WswP56uE0P/2wK5VRXi4u25uhwjbEelP6bwjgDDkGD0MPfWXUpgqFPcZNENzD9i6K
	ktf4hzPR6LF2/1j6Kdf19ne3KHZ66JkcjCFgrBhzWUODQGKJhnwK7Rr/FYiqy3w1MiQA1qX
	Nfx6e/6Qrk5Sqo4aSITY/n8EjzYMzs9EW6aXLZwH4JjyXjydMGMtxAJXyLONRw0c6gGAzvn
	SgoIoJ/l3CYZ1sBi7umDJz+lskNmIGJMZAzqa8TFxYrztyRb30AQB1TiAOzhXumKoSqfVWb
	5dzrkKJBeARCTyAmrzWNQUMP0l3jDYwao4M5pYCINhkzDrQNaUy7LL9k47JwZkCKcNfts+W
	TcdOlslS/39FYO1hrPkARCizSqStkc30qpQa38/suMLvUw0uvjwa1BV5cuhz6a/caDqQbY4
	fz3C/iA/3/MJasojH8QbzIcMfkweyiR1wpOE1A6AHsxjhBE8p6tNmz2l9AQOS3N4tZRSqjt
	LKGFhgiz2MBk5g3yR1IGpc4RXzh79YShGKALuBYROwscTaBky1x8pGUkJPBA48pi+TGc08L
	Ut/V2/yFWoVvxRajbEbntqcxT2f0VXtsmYEmMyNgbrO4cC+8WhPjqzc22IRFpVaF3QrCxRo
	6vnbXXe1dUud7N0ftZxWBTyFruslq5OGgHLoMMmhj4bS84SLSoBmSE7N76457EYbDyaoQAO
	uOiEbBYKSmyr8exvWXbjcTVxzvg0yjjerHPO74U1+hEIpy1WzjVWVpHUnGDHDiVx80SHf5u
	3vyXNGq40Q/lT1qvRw9ft1huB3Ea8X6Mg==
X-QQ-XMRINFO: NS+P29fieYNwqS3WCnRCOn9D1NpZuCnCRA==
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

Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---

Changes in v5:
- Version bump only. Same content as v4, resent as a fresh thread per
  maintainer request to avoid subject collision with the v4 reply.
- Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>

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
index f566d699d074..bdf53aa7ddf1 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -431,36 +431,44 @@ static void ath11k_ahb_init_qmi_ce_config(struct ath11k_base *ab)
 	ab->qmi.service_ins_id = ab->hw_params.qmi_service_ins_id;
 }
 
-static void ath11k_ahb_free_ext_irq(struct ath11k_base *ab)
+static void ath11k_ahb_free_ext_irq_grp(struct ath11k_base *ab,
+				      struct ath11k_ext_irq_grp *irq_grp)
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
@@ -585,9 +598,7 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
 				}
 			}
 		}
-		irq_grp->num_irq = num_irq;
-
-		for (j = 0; j < irq_grp->num_irq; j++) {
+		for (j = 0; j < num_irq; j++) {
 			int irq_idx = irq_grp->irqs[j];
 
 			irq = platform_get_irq_byname(ab->pdev,
@@ -600,11 +611,23 @@ static int ath11k_ahb_config_ext_irq(struct ath11k_base *ab)
 			if (ret) {
 				ath11k_err(ab, "failed request_irq for %d\n",
 					   irq);
+				irq_grp->num_irq = j;
+				ath11k_ahb_free_ext_irq_grp(ab, irq_grp);
+				goto err_request_irq;
 			}
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
