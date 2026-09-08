Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014A639B978;
	Tue,  8 Sep 2026 09:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859984; cv=pass; b=MPG0RnLcXa8Fm7FbpSPmLJCzVdjbDp03htrWburGQ4bFEXEjXFXEfwpYm0VABdo5lX0TM7fHAtaIJYYnij9gP4DbKWfobcsdf1ygfpQwkV4OIstQ03lHLQOuruDt4/c4r6RWRCZnVKwpJsJ72lVy0l2WWLpCKGq/NshVQ07CPEs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859984; c=relaxed/simple;
	bh=0588P4/PihnaRq2ZOR9XGRYAUXqqFmCkvE8jbwLnQx8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Kixf1MgL+JEVauO+3GIUWnIXzg8Pev3lntasrwHQS6OeeXVKK6YzhmOhFq6oW+rpwhLR6EEw5k1yvgembNEh3aNAvwm1trvnBjNc61zQhmjHW03ctfMszj5Qw3R3lHLfvU9jZgcvGCe48VkSLvcsSJYbgkjsOjsRRSWpKI67swo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=TxRK/zqr; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="TxRK/zqr"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hfJdN2ysyz49QLK;
	Tue, 08 Sep 2026 12:32:56 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1788859976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C+g3+5hKe1GDXl2AMiPOwBq2BGyQhQR5x73/iaY9V3w=;
	b=TxRK/zqrn0zOt/gYgpWk+C56V0b5l4GI5RMZQ3gzAuMIIc1kPO7Zef7B2/BTyhfSXDLZ1/
	+cgRjhZ9oI9i1vWNsNXI2/MovLQukFPCFh9o8O5nePguEV13TfxqvKyGBm4XO+hXfeR/ra
	4+h9P0pE0HV7uarfgSGY/DpoWP/anp3yvdkK2J1m9pvh6vckNq2BkE6vUYFW6vVVUyMJsK
	WufzJr45QPX4RIJofZFWUtR0LhwC7Uu+Yc5pjLMy7cFbj8eXtqyI0VuDsAUUTL0B/ca/2Y
	4q17vQ3cT48pssDa+3qmYXzsz7ybjxzaF96Bkl3X2Sg3TV2Vxubd7K25sEuEFQ==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1788859976;
	b=qK2ohW4UcoOmYfde+v6ybKYPYHamoy+Gsrje9eW0dMIZpvbJ5cRI8Q9sAhHagLfMIxzBgb
	7pitTtUOwysYfUjdYT+KVmwLTcnK3LVURtHt6PrYgwCDklZvTPX04gAIVGPlGmL4MWmPkA
	csF9e4SPpUD0OMExceMmR+giR2I/QMKbciua6sW7Qp5HLMe3c1oETWK92KA63c0dwcDGj9
	VqCgabGja46F6bYR68QLfRogzqsqaMwUuzXOsJYPmivG4LZf4EjalPnQncjAYbtpTNO3Cu
	DRDkZV2kis477qySDP50pUOVUG4Rm+lQATHuFKsEruD0t6qamlRYcqTv71ZDlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1788859976;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C+g3+5hKe1GDXl2AMiPOwBq2BGyQhQR5x73/iaY9V3w=;
	b=HSECU6D8Xz/4TS2C85Redu9WOUmB34fXnfz34FaZo+Ab0k1xpK7/stKdniranTKHsDuXDL
	rJt9S8k4mOJeA69VbvwGe2gwC+qeoMQo+GGQ26W3LGFqCvXUulRM6y9bXzNIBWRyhzsQLG
	2d4Fa63Evr1tTSb+IECKIj27QfkYO/Xwp4c9y5eYCDsGt4ufifktFHMa6IsAbGt7lqg/Rq
	BdqUVP/UV5QAXKxXbyFe5x3lvW6gmkBB/UhtDyWYb2I8A8cb/p8UaLIBYX0ygW/a7lcJLb
	R8G8zGLBfoiTLutfIeRZAEGUOUZocPGkl4OV6RJK+08q/D5eLBP7QfmhHl2KqA==
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
Subject: [PATCH v3 06/12] wifi: ath11k: add QRTR endpoint ID hif feature
Date: Tue,  8 Sep 2026 12:31:39 +0300
Message-Id: <20260908093145.2492666-7-juha-matti.tilli@iki.fi>
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

This will allow fetching the QRTR endpoint ID via hardware-specific
means.

Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 drivers/net/wireless/ath/ath11k/hif.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/ath/ath11k/hif.h b/drivers/net/wireless/ath/ath11k/hif.h
index 017fed1b4bd15..2f1634bb9b181 100644
--- a/drivers/net/wireless/ath/ath11k/hif.h
+++ b/drivers/net/wireless/ath/ath11k/hif.h
@@ -32,6 +32,7 @@ struct ath11k_hif_ops {
 	void (*ce_irq_disable)(struct ath11k_base *ab);
 	void (*get_ce_msi_idx)(struct ath11k_base *ab, u32 ce_id, u32 *msi_idx);
 	void (*coredump_download)(struct ath11k_base *ab);
+	int (*set_qrtr_endpoint_id)(struct ath11k_base *ab);
 };
 
 static inline void ath11k_hif_ce_irq_enable(struct ath11k_base *ab)
@@ -159,4 +160,12 @@ static inline void ath11k_hif_coredump_download(struct ath11k_base *ab)
 		ab->hif.ops->coredump_download(ab);
 }
 
+static inline int ath11k_set_qrtr_endpoint_id(struct ath11k_base *ab)
+{
+	if (!ab->hif.ops->set_qrtr_endpoint_id)
+		return -EOPNOTSUPP;
+	else
+		return ab->hif.ops->set_qrtr_endpoint_id(ab);
+}
+
 #endif /* _HIF_H_ */
-- 
2.34.1

