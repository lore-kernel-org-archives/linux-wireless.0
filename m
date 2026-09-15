Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A80B32D7F8;
	Tue, 15 Sep 2026 07:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458340; cv=pass; b=EH8T4f0empi5PpB8xDc/vXwbcQbBC/n5Iq7/WR01hoUux0JFzCuvPyvnDH1RN322sCJt3iRh5DK9MZ0QVfMuQUPbIha39SO+ZQOrpG1vIItNUjC0lOBb3sDKxUTucSjCS2XViEFG2boFSKVy6G99PWeUv4nrTbvV1Byq94hQZNY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458340; c=relaxed/simple;
	bh=on9XxVhWLOh5qBhiXVNTYYMYu4a7lEGjwAwi7dwFPvA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=CWwznPuXZMni1a0ckWv/SVc2YdTuvfaP7Jkxm71y6+CVtAR9q9JJgUpa4CAvlxoqpe9NEs1aiMu3Va9iwu4Ul2j5skcP1Amskc7z1lu/nMQ9Bcjz4TxvGZudI/1OIMWgUf3ZMgITsWxwi7oHPzwNWahgyGgUmMbiStOtV6RzkiU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=GFI9TFNc; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="GFI9TFNc"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkYwD17PFz49Q6x;
	Tue, 15 Sep 2026 10:45:32 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789458332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YLt+l40Q3PpFquTJGHV0pr4yqekDZGuuw51X1SrFTE8=;
	b=GFI9TFNcwhRqA62Hr5qFGhZk+U388b3j0kbMGyCuLGxBhTr/19T/9e+nPa8iNhBawQp2Sc
	MnpEev0653GuSc82GOh5Weg9S4hkbWTxWjNs43k4p7hgFV7+ZC7QiISEFMQey/ShYczJ/G
	maKE7x960QmIF/IPuC5HsbosnokbEvO05AjG3lHSSZ8KWz/XvbuOHKwZb98ltl65R6WdSN
	CVKfmkjxXODe2l6oQ/Q9NjrqZBPcW5R69jn4iztYHuJTGyZvP/ELwjaqLpWzBaChK/pVkC
	juSvSjuv3YE1RPVDTHW3d7yoMXiDshBUUK7woKTUZTaJq42pmNAmdUdcj2tBhg==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789458332;
	b=vGV1q9uOCXnIAbiq6g+n8Fh4+pyPnn4ZVSgSZyj5krs4bh/LxhPnoGuq1nEM8YtU1hydhb
	qzxPR2BJFtWVCxcATV2gWHt34RMIrJYPyosamsMUUfcVuXg7+p51oFFnB0fsMm88IH1xfl
	jTdyl8GrbG5uQy+yq2obKhMMR+NGm2um1A/SImm8dpAVUP+ldxTQpjitxdmTtJGrGD2ce6
	gbhSTzXd5cWgvztLl+Y1FT4H0dKz14TFInNaiRpZQ/KXzRbFHFmcbOM8WF5xDcilhCrEY6
	7hxN5LDLtExhI3SvqoZJ36qyULPaApZ6LSDhU+DpzM7V9l51M5mYIgz+BTDv+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789458332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YLt+l40Q3PpFquTJGHV0pr4yqekDZGuuw51X1SrFTE8=;
	b=HYZo5SK+l0RWK0daZpPhBvo5TCKGKM4SkrIV0W+0vIzM7GSQa7kTwt2jfIWVmLgwUvhTXL
	r2bu/np+f2G2T1YE+HNIF6dnajxYmmGnq6C3xwC/70SWHCVX7ynzXJWQ9u5bd79NCXaqud
	mbVnlSAxR/PrSYuEloCgyaCl0xtTHXRp6uxLf2R457uZTs0IiOPLfcXMLJl8pLp9xT4SC/
	V9sMx2ptlaqATniV27GwpY+UgefB3P6Sm0FDdsOQMrlYTIvVT03zM2A5MG/AQW3Tp6IhHO
	U81xEUTLiP896fOJy9p8VcjHad2iI9CN1UVJFizweYGPkQIOxpgQvyvNTb+Gcw==
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
Subject: [PATCH v4 10/12] wifi: ath12k: add QRTR endpoint ID hif feature
Date: Tue, 15 Sep 2026 10:41:33 +0300
Message-Id: <20260915074135.2567411-11-juha-matti.tilli@iki.fi>
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

