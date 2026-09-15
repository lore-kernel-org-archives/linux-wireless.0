Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734E045D90A;
	Tue, 15 Sep 2026 07:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458265; cv=pass; b=V8QPPlVc6Gu6mekz6hnmzmaTeh5L4PygVCu1cWTPvzGlPIXwhtAvt9orE+Tsz6NNdv8iLbD78THBTMovsT7M/UBhTQQQW3LOLSo7E5NP5crsMokUB1ViMQgVDuk5FG1YvEmBEI14iX7HxOycG/A2XQjZ4xarCxjwlGa90Jb14Gc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458265; c=relaxed/simple;
	bh=Wn4IKjyUqQAeg93wKRRA9smjCbWjQ5UnbHEmDo+F8sU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TRc2by47MGmk1klRApiJgjgdOa7yshUDVWXRui2OMMGCbbRk/a82/nrUktNclSkRLzyAGzRoIgjc6Yjslu183Q6ycUQeMwS8gydwhZ93uTWp2o5OTTpxftXsHeSjXWI+JKiFIq+ZuDiiEJVnH06L9/7UmfxbnrIcp5yPBdA6AQM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=mx9ZOQq6; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="mx9ZOQq6"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hkYtm1MG7zySb;
	Tue, 15 Sep 2026 10:44:16 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1789458256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5udMw/D8l5XFimn7AbO4dlFXaCD2w5J+n7KjzzUgXYM=;
	b=mx9ZOQq6/28oaPH57sk3CDTqlpa0h5SOKNq7X4s1LhPXQNf88X7s2EsHBNe9sOJA6pn+ZJ
	no/v4mZqCUEdxqM0xIZ5l4lFlItw1hKa//TqjVitdBZ1Gzp/9FHgwAhtH+qSua1k2RJi2e
	PmHrGDGDF+XZ1c0h67xiaXnyIdRpKFE=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1789458256;
	b=GG+oXz5+E9gLaBV0zJ15mKV4vkHL2sbX9j8RL9e4mBnSuE5am3UQffI8CP0U0C/ROvAIFj
	vqHcCThi1EwAs2Nu7+ihqnytPK1lgMDNBvaDcyFz+8FQQiAr+Bwdd+7FQi6vjM3hI13a0W
	F8aV4G+2Lb3T0evQYux9vmCb5v/cvYA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1789458256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5udMw/D8l5XFimn7AbO4dlFXaCD2w5J+n7KjzzUgXYM=;
	b=ezuEBHqEi4sUifa1XjGIyNKO+3ckhBSfZSj2o28KOsiRxzyHcQAenUOy4nFpVeU46TzL1g
	U0aQR9r2EFZUtToheuSgZ26LwDtKet3S7IXwvs+AImgKY4KsVpDqL5MfS/VZDDpYBMDn9d
	loYnvYRw/PkRxtKdBuD64izBXF7JA5w=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	Manivannan Sadhasivam <mani@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>
Cc: Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	Mihai Moldovan <ionic@ionic.de>,
	Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v4 07/12] wifi: ath11k: stub QRTR endpoint ID fetching
Date: Tue, 15 Sep 2026 10:41:30 +0300
Message-Id: <20260915074135.2567411-8-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915074135.2567411-1-juha-matti.tilli@iki.fi>
References: <20260915074135.2567411-1-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mihai Moldovan <ionic@ionic.de>

QRTR endpoint ID fetching will currently not be available for AHB.

Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 drivers/net/wireless/ath/ath11k/ahb.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/ahb.c b/drivers/net/wireless/ath/ath11k/ahb.c
index 27d01411b6e9c..1cd81d2ac1201 100644
--- a/drivers/net/wireless/ath/ath11k/ahb.c
+++ b/drivers/net/wireless/ath/ath11k/ahb.c
@@ -798,6 +798,11 @@ static int ath11k_ahb_hif_resume(struct ath11k_base *ab)
 	return 0;
 }
 
+static int ath11k_ahb_set_qrtr_endpoint_id(struct ath11k_base *ab)
+{
+	return -EOPNOTSUPP;
+}
+
 static const struct ath11k_hif_ops ath11k_ahb_hif_ops_ipq8074 = {
 	.start = ath11k_ahb_start,
 	.stop = ath11k_ahb_stop,
@@ -811,6 +816,7 @@ static const struct ath11k_hif_ops ath11k_ahb_hif_ops_ipq8074 = {
 	.power_up = ath11k_ahb_power_up,
 	.ce_irq_enable = ath11k_ahb_ce_irqs_enable,
 	.ce_irq_disable = ath11k_ahb_ce_irq_disable_sync,
+	.set_qrtr_endpoint_id = ath11k_ahb_set_qrtr_endpoint_id,
 };
 
 static const struct ath11k_hif_ops ath11k_ahb_hif_ops_wcn6750 = {
@@ -830,6 +836,7 @@ static const struct ath11k_hif_ops ath11k_ahb_hif_ops_wcn6750 = {
 	.resume = ath11k_ahb_hif_resume,
 	.ce_irq_enable = ath11k_pci_enable_ce_irqs_except_wake_irq,
 	.ce_irq_disable = ath11k_pci_disable_ce_irqs_except_wake_irq,
+	.set_qrtr_endpoint_id = ath11k_ahb_set_qrtr_endpoint_id,
 };
 
 static int ath11k_core_get_rproc(struct ath11k_base *ab)
-- 
2.34.1

