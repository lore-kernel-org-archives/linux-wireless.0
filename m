Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70AC4A4986;
	Tue,  8 Sep 2026 09:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859990; cv=pass; b=ftSLD8O68QKIi+6U+yx9ar2YqUQvCWS1FGYj4pweLlFjRiyF9Xhn6WM3ijO7Qffv3RHwaRVhs3gswkI8fNGof1ZAjxNa+ZvqDzk58jNWBiADqNgwYC4aVHdyi/xwT5GukPMxA4zjjM2SUqD6ttfvO6DvRZiCKzAYamsgfMfR338=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859990; c=relaxed/simple;
	bh=Wn4IKjyUqQAeg93wKRRA9smjCbWjQ5UnbHEmDo+F8sU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EpsAMyz1Vc9Xvn6N4dUFenngyc8vLeqPbpN7hT+sXE6QkD4jy3SQWQOQaeslouqSaQDTj7yXZdiqhfpTENvoXl7bzh/PqbBLezJo57am0/t5hAC2QGU0rMWnL/YWA0TdOFxL2ZTABDXA5Qu5lXDbbR8X/miX4j4BDWjf+gSFl6o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=vW7tD3wI; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="vW7tD3wI"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hfJdV69cMz49Q5T;
	Tue, 08 Sep 2026 12:33:02 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1788859982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5udMw/D8l5XFimn7AbO4dlFXaCD2w5J+n7KjzzUgXYM=;
	b=vW7tD3wIIVgCQQrTmPaMwzUOGCYk77EF3NVVkeyl+PtT59V0f4nxvf1vfTyBJ4yhHjs8sn
	CvJPMjO3KG6jRdtcNK9GFQp0QLeR0NqSjh+fUgRZf7vhwPoScc7jtjMIrbUECN38glbMZ0
	jgRS55tIuKJCdKbYeMUcv4Tyr7v9qHmvTteYTrm9eJCgQuucfbO41kId4FtqaMTnkJoSAR
	NOSQkIkdPpPHlT4MgbxP3DROiOFaaPLPYLuk6NvlnWOJy/A0uJFkJFNej2dHAhjj8H69u9
	ZXl+nf7hrLHzCjsx2G4VypEsxXFEC5bhklk5GIGCMvNiEuEdN+28RDwWKStkzw==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1788859982;
	b=J5Pfce0uqTTKFI3fcHbJfSLnSLf34lImwqmRun5dFCu6SmX4L6JbZQ4srrJJhv53LDm4Sj
	x3awGT5tsuyEXHn1DYR8da39YisJ497i4GgH8aQvvzjr+9FXO0iHfiKwmeUKWOVIAPtpcj
	xX6LprZnfOuOEa1k+DGrFyMG+3AYWclkff+/pLcRtr+d0LeFwrREsxNJ4kVao6PsdPJdle
	ediNSg1zfR4doXUdLwtsjYsXMjmrmyZ308Kkb6nP4b5E8WAKzeLh7A2cYcqXyMo+RyZGp9
	jHuQo+EhyLiRyBkFNKwh0b7OZ5ZhQpdINePNZAk3x03D8Fn0zQ1NCyDGWmEeSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1788859982;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5udMw/D8l5XFimn7AbO4dlFXaCD2w5J+n7KjzzUgXYM=;
	b=ti+olMMG7KD8wtFkqqj1n6zEHfsKA3VDlBeI7rBdrAnMw0ufwND4lgEagunynsCIMJJpdR
	tjCjc02j1fpKVqqiMib8k910eWjCYQEXn8tCeRDq6Te59dRKcJnRM2m23Z/A7QPepmDyjH
	q0B9588D4uav37g/KGSm1gCxNZKCT0ZAZJrhRLuXxmgx+xjZlcTBRB0GkU2/Hi8fLSzuSg
	5rh+7buJ9gns5W2nuJ8CiYoX/KEe+b9a74MEjQOW//IOetrDj2pYq79Zo476jfyCBcRTI6
	EzIHq93wUnes4VmrePKcjhdQtAlOYyKgJHKUyM2xuXCeT65CV0M2u14QN4oDZA==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	Kalle Valo <kvalo@kernel.org>,
	Jeff Johnson <jjohnson@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Mihai Moldovan <ionic@ionic.de>,
	Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	linux-wireless@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 07/12] wifi: ath11k: stub QRTR endpoint ID fetching
Date: Tue,  8 Sep 2026 12:31:40 +0300
Message-Id: <20260908093145.2492666-8-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908093145.2492666-1-juha-matti.tilli@iki.fi>
References: <20260908093145.2492666-1-juha-matti.tilli@iki.fi>
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

