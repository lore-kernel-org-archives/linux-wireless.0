Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541474FC8DC;
	Tue,  8 Sep 2026 09:35:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860118; cv=pass; b=fZHqEDSf05yym/3uMsMa3fIPJWEzUTkIoxyRv+4z/1jhLdwiMUt2bQMY5GRgsHO1H3dKfGNde9/tJai4La+UsxmHTrlmx9PR8TSpo5Ts5G7Li0YVCHagII8dhtRcuhRNLVtfEQqzXUuueESaLZ1ISdoLaFHeK1MpShlphO0KiUs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860118; c=relaxed/simple;
	bh=on9XxVhWLOh5qBhiXVNTYYMYu4a7lEGjwAwi7dwFPvA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IHTi4XletO5unGjY3DqxnfQ+XsoDJ1jW2dBM7A07fedNc0LcgbNzXhSyz2LXwUKwv46elEXWwo1qR0PAz16TpX1KDFcNi3SzILEnnOVWmI4vqOUR0ePCb+oSFoSrFQ5fMQlZSvUmVDVLdB/9TDTlk6Dx6gs3PAlcdaRRs5EYmUw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=Wij3vA3q; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="Wij3vA3q"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hfJgx3rgNz49QLK;
	Tue, 08 Sep 2026 12:35:09 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1788860109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YLt+l40Q3PpFquTJGHV0pr4yqekDZGuuw51X1SrFTE8=;
	b=Wij3vA3qHeTLjvCPJ7WOj7KKQLl8UOkTVXcWFwM5Bj6O4Ywtv4LWYCD2O3H/jX0G34kLbs
	gPSOaYjgE51N0i1i+O6WxqisSICPOho6i5ro6Gnzp1TamGWKxgU/WGXrmPtPHv5wjSz5Rc
	AczuUtIaYDSx9A5LO30cImk1Hdu5v+qPf9PdPW58mgzii8bRAjlgb3cjVb5V97bNJFmGSR
	gLUbJf1l1Ms9XyRg7wigFto4N3uZ6b2w/cyWg9jIca6Bj0NrZk9JlgWNQdxKUmmz8oWilI
	XiWeiP9RqwlkHJGt4pQz7dVX/ZsfaMeCbeThXhZP0k44MfSBjgucKQTPYbdz5w==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1788860109;
	b=tZr2OKxyO1DVcdaxUVrByxW+mf8K5jLP0VM5Ziykng45zL65zqg/2WtB0eAi5DU0d0lBCr
	PEdcGJpisWJxc0aRT9685X5i4zImTKPxPqcwJ/4jvB73d6e0ce8UwjKmZH0yskd+S1GurB
	eVJc5F8AwKlAysj4w5SSTc0ld6jbIxy3PgPwRVJ3bW3k3pDsROperWl/6Sz4odixXw/dvA
	ZCazhGHAyM2NvXyzDT8aGKncs9+o3osBiqAaGhLMQ6F44S44aL01hRQwnMdfgeDPNFu37a
	O8eA2f7sgxGPKX1kCXO2mlG/NqxHyJHo2R6nEQIwjqRDY+cZG+vBz4VnnU8U1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1788860109;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YLt+l40Q3PpFquTJGHV0pr4yqekDZGuuw51X1SrFTE8=;
	b=kQvZO3LWmNSU2n17qYJ1c3iFq4+3bAGHJg+jiYCW0mrfWh+jZ3dWv9ndXqs5NNMltoldaS
	vjVv8wiUMm2DqbQmKiuf0AwMZJbXpQyvfpZ2qsr69mpItxygmfzBQ0/0cyyF63ODAkKvDG
	D5msWJhgfd5EhOxRtX63Anb1dH8j8M1EOI8cLy5cF8aldcMzsXN1UgEy7kw/LCLwzPFGRt
	em0jZ7VPLy39XShfilSeNF70PB7TR1p/cA7OtNVc6Mye03YbSBq3/Ckf0JurKz7SGXqh9l
	Ep63WSwkDZiLYc32U6nX2rxv4bFpXivJc4jnnu+9qttjk2/i/CKmhhTheX0BKw==
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
Subject: [PATCH v3 10/12] wifi: ath12k: add QRTR endpoint ID hif feature
Date: Tue,  8 Sep 2026 12:34:35 +0300
Message-Id: <20260908093437.2493698-3-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260908093437.2493698-1-juha-matti.tilli@iki.fi>
References: <20260908093437.2493698-1-juha-matti.tilli@iki.fi>
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
 drivers/net/wireless/ath/ath12k/hif.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/wireless/ath/ath12k/hif.h b/drivers/net/wireless/ath/ath12k/hif.h
index 4de8667690e91..4591660519efb 100644
--- a/drivers/net/wireless/ath/ath12k/hif.h
+++ b/drivers/net/wireless/ath/ath12k/hif.h
@@ -32,6 +32,7 @@ struct ath12k_hif_ops {
 	void (*get_ce_msi_idx)(struct ath12k_base *ab, u32 ce_id, u32 *msi_idx);
 	int (*panic_handler)(struct ath12k_base *ab);
 	void (*coredump_download)(struct ath12k_base *ab);
+	int (*set_qrtr_endpoint_id)(struct ath12k_base *ab);
 };
 
 static inline int ath12k_hif_map_service_to_pipe(struct ath12k_base *ab, u16 service_id,
@@ -162,4 +163,13 @@ static inline void ath12k_hif_coredump_download(struct ath12k_base *ab)
 	if (ab->hif.ops->coredump_download)
 		ab->hif.ops->coredump_download(ab);
 }
+
+static inline int ath12k_hif_set_qrtr_endpoint_id(struct ath12k_base *ab)
+{
+	if (!ab->hif.ops->set_qrtr_endpoint_id)
+		return -EOPNOTSUPP;
+	else
+		return ab->hif.ops->set_qrtr_endpoint_id(ab);
+}
+
 #endif /* ATH12K_HIF_H */
-- 
2.34.1

