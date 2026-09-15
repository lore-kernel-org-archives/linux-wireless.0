Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BE845D935;
	Tue, 15 Sep 2026 07:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458247; cv=pass; b=jxwmlVKXL5WebeEiOBPYxUU7pcavo3iua5mNr8znHIi2w0ixLACBfyinRav283GQVT8xsFsnze8mWHvk4WOYte3/Pu8LdDQpzSvW0Q6JA1G+0LUbEbqBTJIyh0yzIhzc5g4/tjPYrG/poI3Fx9ht0/P0ixYmUNTAqgLOqliXIe8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458247; c=relaxed/simple;
	bh=0588P4/PihnaRq2ZOR9XGRYAUXqqFmCkvE8jbwLnQx8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=lnx2mEy6zRQsuVaA04de2g7ji9F1MnCFepjlM6NgZj1dq4ncYRPmdpOjn5pNg2Qox4ioU+bWRZ92ATxAkny47uibtMJ+ohvnWnIFAjNvZKQmtQGWpU2OnU/eqmUJVVNQ/tECXR5zmVIW5eWLScDxVjwwqEE2kOyng++qSSzYKKI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=pUFqNekw; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="pUFqNekw"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hkYtR32ZhzySb;
	Tue, 15 Sep 2026 10:43:59 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1789458239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C+g3+5hKe1GDXl2AMiPOwBq2BGyQhQR5x73/iaY9V3w=;
	b=pUFqNekweAdzIq4YSdBxeOrQYwOYPxD0TYoIHnqbn0ic2Xd8R66/xvWu4FIQdu5bnQiTxZ
	uXO9Euq6n5lJxSXameNOZEH1vL9dkGTAQ6OdmeiGeM2UzN5HvZEXJVRrlFraVVxDKIiKxb
	HCtL9P4aM5yyUiJhJIf3kMJOvP+cuf0=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1789458239;
	b=k1P6w3mJu//26d+8AgghmkqRaZg+tHLoO/fh55XKuCTRSDeiz2YuMls7FL/ikVj6Y7+M0G
	/rcf2oX9LMbKeV53/kRVhyJkoKHTcO7hLRnDGJsBKHDPPhojiPvgSilyCcfp0TEAReu40O
	upAXe3oy3oeZEloKPpmod/OXOqSu0M0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1789458239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=C+g3+5hKe1GDXl2AMiPOwBq2BGyQhQR5x73/iaY9V3w=;
	b=YkghHMm6nd43qa8lgOwAbme70nsTz9pJVxwjgoX7Yo04P2i3gtMvqAg/vpGzgGbzHrLODN
	HPW33Io6jo6913AJrhQGSBSPh5boPMYKGzY3kgk26CEcgezHVBTezIMsrzwLBlkxzz+bQL
	pF2rfIzQJLwhwW72CBsgQgPJA2nWrz0=
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
Subject: [PATCH v4 06/12] wifi: ath11k: add QRTR endpoint ID hif feature
Date: Tue, 15 Sep 2026 10:41:29 +0300
Message-Id: <20260915074135.2567411-7-juha-matti.tilli@iki.fi>
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

