Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC0C473C89;
	Wed, 22 Jul 2026 09:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784714128; cv=none; b=UcmuSd8qJ/lpKeiTAnjk96HAS/ozi7jVFP10ulruAfAhiza/ujdroy6ikyeSZBfpeqzuptPQFR8nLMKhdtrsszat7kg++O+IPDtPnVq4gZxNH22FY0kjHfTETuUqSsEMoVS/plAEN8aoCLTt8W1Z463s+gQ8+rKcvD/+YIfi4Cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784714128; c=relaxed/simple;
	bh=Vji1V8JpOzdcPu514MX0j/+Im7SlkTT3W8MIYCAX/uU=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=ZU4Db8oe8NuNn+i+yTDi5dmb+59BOiZL/Bb5H1EF6sKpIk5t23kV2MurQAgYRamF8OovRVuI0CzSToLJV28UG05nQNZ/r+PpFGqTJgi1Wqh8mbPL1lx57IPfFVLNHCPP4Qj4yPPzVzz/5rtre59u5aTYO+vkdEB6HnpG6C51EUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com; spf=pass smtp.mailfrom=uniontech.com; dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b=d4oI8DAy; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=uniontech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=uniontech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=uniontech.com header.i=@uniontech.com header.b="d4oI8DAy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uniontech.com;
	s=onoh2408; t=1784714076;
	bh=Ss/nWa/pahTed7gehVQPHqqDpxTkq68vTxA4pvKZoEc=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=d4oI8DAyeKaTRGbCSHOKZesGPSrncThFBTWeM9OIvfy1xXPFZRQP1OaQvP1tKMOSm
	 KcmFteQAX06RUpkbC0od+MWiONnuxnBcAP+KRjfR9oujNifBMkGEtnMkkvcOi+VbtK
	 +CiWIzsZrirpc7nceff1lyWLldhFdFloLJNRHMOw=
X-QQ-mid: esmtpsz20t1784714071t7adea1de
X-QQ-Originating-IP: i1P51o8fmN+VvUAjrLDcP+Jkmu8bvqpj6wwdKGDcflM=
Received: from localhost.localdomain ( [1.202.39.170])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 22 Jul 2026 17:54:23 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 1
X-BIZMAIL-ID: 5174629714768160000
EX-QQ-RecipientCnt: 6
From: ZhaoJinming <zhaojinming@uniontech.com>
To: Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jeff Johnson <jjohnson@kernel.org>
Cc: linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	ZhaoJinming <zhaojinming@uniontech.com>
Subject: [PATCH v4] wifi: ath11k: fix resource leak on error in ext IRQ setup
Date: Wed, 22 Jul 2026 17:54:19 +0800
Message-Id: <20260722095419.1411003-1-zhaojinming@uniontech.com>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: esmtpsz:uniontech.com:qybglogicsvrsz:qybglogicsvrsz4b-0
X-QQ-XMAILINFO: NI6mNDRHoM9VD1c+4JYEnDIaH8eArf7l0st1daqA0RCLpzdNp9bQSrRl
	Fr7ijjzYYDUy0zCyTbuOiq96YqSQscWQY5pNZ8vB7kDXuYw5+ABukb8BKDFY10gCusxzYly
	tVKteHe4YR/ZZFYa7NruR2+cPUo7obOFVAeNIaBw+cGHB1MwRuVsevRY96I91cMhTwrHEJ2
	IxrXQSrsJQTIVg3JjcT5V2AmwCeXMu8yq6EkwE9Ml4ShjaPB6UMpUw877hiUk16iIulaGyU
	B4qUoNu0Wa6drHjp6YLsE4ZKcfVcf4qME9pJP/WoNhxhQEraB16MqNWTdrtjiL+mlOJGNjv
	bxxo9abqkW0BUHybLy9cUVSv6jwe+gFw+8hpGo7DQ+4E5CEjqMazqaYxEzkHxoYEhshHfGJ
	aG/TP/eMYAItkfHqp7+pnuL65m9DweLQTJTplzwQ8XNM9Iuu8PQDQ7k9bzS9nzJnT4KT9Fi
	kgh+kahpK/coG4IO2Bo6tdVybbHha4lqHOFelZjhsWqPkG86tKd/PCSddEaZt6pcaNFchUe
	pnX0Y8Q7iCXi5D2tGK8w4WOGEl4nrxDwitERSuzO4KYrCIFRLV0mA7/l/9gEJC/pzNyQkhy
	DQUApvrnOlq+pXaBYXhQCpzPtMARj3hMiC0aghr1jBsfcp8iOGk+QpsDCWQHCMhKTXEmuI6
	r6oaseflFcj2sAX+SDP2hl7/A3MIqPLjVciLT1ctJhP3JHjrPyPTUJ88iCPDmFDUiQk+FdW
	NhI3OHuxPYX1//syJF7d66wxRWcgtx2624KwbtS7Izs+/N6vW77jmPiq5jRULOJlsZWg27j
	zQ8ZeB7pQp/Jews31I2O6vCyuTFx/RH/c+KYHZUdmlNqQXkYrRjcl/PlYN4+dqqxUSozFCI
	srpTtIhiLv2hYEVAn6et40Y+IHzGSeLNq/Ob2JXwM9Pa9tSSaciYNJcmtwAdGYuNPPXN6lf
	DPXNuH9ieCD1LKYCCoLQXM+Do/+uNC6WccwBHOH+zGAFddbugBe9WbmaPco9XSMd61zAXTB
	ce/VZr259gtPNZ/kbsiSX+sH1Cfx5JtaqgfCmZPg==
X-QQ-XMRINFO: Nq+8W0+stu50tPAe92KXseR0ZZmBTk3gLg==
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
