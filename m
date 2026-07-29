Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A29E15B135;
	Wed, 29 Jul 2026 02:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785290487; cv=none; b=OnKueQCNyoKnnTxgIGscYMTiUxkxJ7N7MxlpZ4nV0qTGs/kW4HwatdzWohv3Ph1JAFemaK8+yPQY1KK2L1xD6HcEifqOM/o+gjQk25RjLfvLUAm/lgb8Wl5OvRxw2bkzi40zG42kCTNb7+XW74iOubLW1ujVUWdE/bJWXigQ4D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785290487; c=relaxed/simple;
	bh=8RpnnoGv+tIAGiSIWX+XOwQUaSiFyJLguEoJsJKxToA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=CqrAeIxpOTheztMswyzsa0+9/bIB0e1UhCxoSZf04L2WGJmif/9nta/cogDnGixZEqDsVsQiEqnhVTdxiZlGf1ZaOTgAX8QK5mwyBysU2plRvvVwDLMyLOPBN4/TarSYvXtZriUQnb57+CH77gZtN6h9OJ7lGAvgGIP1qvMpKfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=TnhPCF3h; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="TnhPCF3h"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785290435;
	bh=CrLETh4iSEl/P6eqGC67l43WN4aXXH9eFzGL2XXCsNI=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=TnhPCF3hNn2vNPN+s/aG0JcgE3YLzFbzKiooE84IbSUpJoEL3cQmwmjRKRhUDb4E+
	 Zgga63uMkkqNpJhXb7USlwWL+GS81kQPKyS2b0JnFheVstvFrgDfU7Wldaf2YpqLlE
	 g0oDfABkEJknhp8D3UlzrCuMEOmoDfZiKHYuL490=
X-QQ-mid: zesmtpsz7t1785290431te5a25bea
X-QQ-Originating-IP: m91qHMmZsmOkvposUvkoyf/ytvEWwnp6lqy5qi6adTE=
Received: from localhost.localdomain ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 29 Jul 2026 10:00:09 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 14955744681332169406
EX-QQ-RecipientCnt: 6
From: ZhaoJinming <zhaojinming@uniontech.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ZhaoJinming <zhaojinming@uniontech.com>
Subject: [PATCH v8] wifi: ath11k: fix resource leak on error in ext IRQ setup
Date: Wed, 29 Jul 2026 10:00:05 +0800
Message-Id: <20260729020005.219253-1-zhaojinming@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: OPdvjVtisQSK8sXHbk6V5VvHNSwVgXkB7n6/5XQn3ydsVxXE7oLpj5nm
	FAAFyddEjwWwvk/M3h10x3dnHoxwBJFeT1U/2bZ/3/3S6+cz57WF20eecmumgfiYaiFRbPB
	cgcYMNaKnw8YmxP1dN72xMIrxrXkFlyXJkuFJhexa4DuPZGMshSDzCfis/0bUUPKm12TExy
	O4e4Vwo+PqNNzEsOuliTzie6ESUEiEzF5+A9vbgJrAvG1sUddbCQIYO7vcK5FnZ1eF91Rwq
	DQunLahlyt9SybaoQZsY4PN6BdCMxApSflnVkpuECqLBxUEF8yPc1iMNtDd2iz0O6GbCn2h
	2jBv7v9Jwmc2/h7KJO+9Dm8PsTQ6azjkBqOe/26hkXBMZBD1Sb8ex3EiyIEbY7+xeXtJ3ky
	W2vKgR92+8Txxb3NMrtO9p0GcwIm+mmrs39JQ1oOzZooRiwk8nBxQQzcBKcbKpPnVFu0SeF
	Vh2nb4ldz163MeSu4Y6C20UbimGsYStepvVKt72QCL8Hq+ON1wm1OJaMtX+t3AQZqrrxpdk
	cdZhJOPa3PNrztLLPN6h/Hw+xykAIYml1hyNlDyym8VpifYlO4L2/Ucc56sPbv8wLISTw97
	nxckvW2xcvloqyBGIDHszjEyzoqJl2/b058xXB/LkDAZ+viCr9AEIToZMmrmd5tYYV5J+cW
	aECRyls8O26+4lYBZw4mV9DzMQo6zXWm8ffbkz76LOV1tl0+sJblyhwhYPBPK+uFTp389wq
	WAvOY0QAxZoy7bq5XDlLvMmfklt39uqOuZ1aJKmPctx7BGPKC2NaTUfE2Z0iOKibbKpfG+K
	exFI6bz1CQWaFJUGoqEZYxgE/e05Gn3OlC+unyR0w5QSQOhZncdk4rbGB5vB1bbSBVn1a3w
	LYetDiher2TRvzE70T0ykKmuzZzl08FVGYpFSDAEdS0meoiuyJ926Hia6JX5pN5jfsFB+h0
	G4+bEf257OX3TdasTe0suS0jFNmFMhkH/acSHWrYepImo39L9jhtzMiixpvgWoIjdBh4+wE
	IUBJI0yEKgsKJUUDPcOZKxneDT+wH37WXP+BTPQW+3h3GQ8DScMtTGtaJ9sVg=
X-QQ-XMRINFO: Mp0Kj//9VHAxzExpfF+O8yhSrljjwrznVg==
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

Changes in v8:
- Move Link tag from commit body to changelog per maintainer's request.

Changes in v7:
- Resend in a new thread. No content changes from v6.
  Link: https://lore.kernel.org/all/b6903572-52cc-4c41-b9cf-5845e387c176@oss.qualcomm.com/

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
