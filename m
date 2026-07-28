Received: from smtpbgeu2.qq.com (smtpbgeu2.qq.com [18.194.254.142])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 833FD30C361;
	Tue, 28 Jul 2026 03:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.194.254.142
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785208472; cv=none; b=jcvNTzx6xAR7LwDP6EK/swM0g+1CkLcPgMzmoaCIbxZIOktyk3V5GKax8lm4obkL1dn4rhuc7QPJ+CcO9uTKNFcFNA6aNrNl4nd+ucq2o5z8lTcbR8zcGompBjxXQgqJQk73oc5ihxDus+5L89vWYkbbg5gpNgJ0FgO4HU0/sQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785208472; c=relaxed/simple;
	bh=azQHKNuS6ku6bkm7EXvA8HpvVOYrkTHwl2I5y01zzQs=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=G4BVS9ODLhHpM+yVEyGyvmg3T6Dl832MJMP92c4pRQpaIfrDBfoVE0wComZ/7RcoOxPcUWTaIG4FAIvnotwpE0HMGd6+y0BZOI5AeYYmBnPJd1NEc7Wqeprr3XIZCOQ37yl2uDh4Evd3Mr3Zro+LhE9Z6PDm83MY+ixeSyFnHq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=IlgjRfzP; arc=none smtp.client-ip=18.194.254.142
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="IlgjRfzP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1785208429;
	bh=GaK/swTdhyI/6LrewRxUFJ1977ZkE5zBR3cK4E0kQtg=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=IlgjRfzPSGgQ5jC9/aNHNV+ReXQF83Id3Z9Yx1BFBNWVhl1LK8BSF9GSVjd3UTFgG
	 pCJyXn/MJavzma5xC5tE3OUIu+CbZi1Hc3Qoj/cs2KjOOE0udZeWt5fbPzQx7NaRSX
	 lUW0qtCua4xDXqhPmYwxj/KW11XMr9eqCQU7Ys5U=
X-QQ-mid: esmtpgz10t1785208424t03ad27e5
X-QQ-Originating-IP: 0AF0p5TNFXsE4hBeoKcV0Xbsd6vfkthVbb1fqbQhQrc=
Received: from localhost.localdomain ( [124.126.19.250])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 28 Jul 2026 11:13:37 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 15182359398812608971
EX-QQ-RecipientCnt: 6
From: ZhaoJinming <zhaojinming@uniontech.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ZhaoJinming <zhaojinming@uniontech.com>
Subject: [PATCH v7] wifi: ath11k: fix resource leak on error in ext IRQ setup
Date: Tue, 28 Jul 2026 11:13:35 +0800
Message-Id: <20260728031335.3818736-1-zhaojinming@uniontech.com>
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
X-QQ-XMAILINFO: MTOSPYkX0VHSsEen1yqBcIart/nCsb0f6P+sQcyip2Pc2mi9orz2FCit
	lto/YMbP8B7/CrBlj5uJ7/8mHDN8Iq51y3dbzssTVMOmR591pdWZykuICnOz0Bzhmtdh6J+
	X9DEuaqazuYxc/PfSetx0lUN0CTwjz2hr8KkxrSDryy9W8J7t+Ps08rtk5Ls6cKuA1vPyFb
	92mbc2wwHkn4MH8jeTypJ7zraM1LttWC/z+pqnzAZh3ek+62tm63rJ1w423jZGzoBqH68SU
	5pTKkIUEIWQxRHLE1joMdrKBZePRsOObP6dCLuiQ5K9Eyybx1tAiRSruZ1Z/1FT9pz4toWy
	Jo16gO7XRLpo8bEVXlNLG3SnTOi4dt68o9dQdPAYJHWf6hKN1OSf4sGIRZo3Tc5GgtMwgeJ
	ZzEdPsmlFIL/GY/lPUPJal7o/dgswEmSutIm5ZOXo+cc1mZIpgWMi7RbeFI5RF+o9syQAsd
	choJq8K3C9OQpdmprsCiAsGsfpqwCX2SRVVc1NjA0nE5upEVyI0o69e28YJScv8d0tWIgsx
	Qq5zlYxsRDqWwvQ1keLms3ifFx63NLd/bFJEMy0DX/LhvjYH2eO0RxN4aMt0tbyoYF9BpDh
	VGoPtiKZ/BYQJVm7iXmfIpOaHjMSz6SV2KtgqApjAd2ORjVOgD5f0U0TtwkU4gqQTiZ31h1
	dm/lszsObr3w1f8LvQyYl1f8YhYKutZfM+EGFGfYJaJTm3toskMxNvhFyTfqc+C/UMIpjmA
	wQc7iIB8m6XFiTswIcyCdF5chQf20PG+dys17ju57mf2Q8L0LbQ2F6MsovYlTwF5dw2p7Mg
	AFr3hCQM+xvpmhb8m01mN3k0jYCoAAuCPBLx6NeCe/VoeY3u5S/YeAWaE7tSPHqbb40l0YJ
	+EAinZ1kwSm5EQxK15z6Q+0a50t69t0FUxgNdoeFdneQ/u52J+LQHs83qKKGw8XANtUgusN
	0bH4skNFC8is4/crWFFpEqNH8qPuaoluFtauKR83qO8JsXybxMokv4KAaaeEfD+RozCQ6P4
	8AKYGhZ8HcMu1INEv90jcjmVLpl9a6Ff1XUP0MxpdwjLePFiBQSFk2LTsgRz7oq0rAFus7b
	yaG/ByuQ+o0
X-QQ-XMRINFO: NI4Ajvh11aEjEMj13RCX7UuhPEoou2bs1g==
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

Link: https://lore.kernel.org/all/b6903572-52cc-4c41-b9cf-5845e387c176@oss.qualcomm.com/
Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
---

Changes in v7:
- Resend in a new thread. No content changes from v6.

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
