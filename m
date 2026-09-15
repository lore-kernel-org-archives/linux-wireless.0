Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55D5743E07E;
	Tue, 15 Sep 2026 05:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451192; cv=pass; b=m00MwDhen5gtpeWaIp10lEXht9VVm3COooo/OisrumwvQOulATFhQNzRhvDuVlb6Aqr1POg5hwToaYvQC/4V/sJEPcdKpv7PuE4fHLjeWjlCnxui6f5ObAKQRl+7yDbFFtTe5JVn22VT29Dz9/JKi1TZTTt5NXHVkSBIsl72YEg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451192; c=relaxed/simple;
	bh=Idzz+qs8f5I+xqu9a7wEtufSLSZ3EedsBKyqg8tf084=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=tI0ArgzH6z5Nadt54v1rsQcikiQ1fO52kJkbxO5KjfHqocQhhNpbHhfU8d4lIObmujVUF+3ARM+nNEcMEGJ5dtVBSXN6qnCcriJWi6vczWKtnG9XnEJmp0+NHlLuNZ/TA09EUfQAR/f2dR0sK3E7ipL7Dkd6r30fpFV8+3JdJ24=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=L886c2Tv; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="L886c2Tv"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkWGn1X1Gz49Q32;
	Tue, 15 Sep 2026 08:46:25 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789451185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3qERqGgzrD2T4aK1iBclz+AkDg1ZG2HnPrGpORQgtc=;
	b=L886c2TvMlIuMg7a7dmCHXKPWL5B5IEX+hfDzxJVKJwv+/LO37JPwb0PnTq3Vy5p+gXi9u
	ctx/1R72RoScgJZ2mkvfGXFTYtz5bqKLmxhekDC7mUxd7ikshyB6vYMoawAob16gM9l26e
	p0FfRHO41/j6RsGLYkFXlg0R/Ts9WNF26taxAoNpkAmY+9Rln3h8ioSLR2iUnTAX4v+LN5
	ytcQqDYLJzLlDg//39ntBtxLN3BiHfol7oUkfHXbX49g1UC0f+Wy11hr4FIq0DrAaHd59A
	YtiM6h7tRIAxElgNX1TWBn+5bmDM8X96SbKqs27yVvc6DSbITAy9lrlYRC1qZg==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789451185;
	b=eJkRRfc2jdgz9gfZv3fKKtxGBolN4wY2oAswvrOgKGGh4R1ajbxfRR5GL6fOqGRURh1YwX
	sEFmq0Xme8unHOKHfoTmIxeQvxii2msQ6yEtjFqfykuwUePTSDmHYHDzMQIRVcRVAvMKUP
	OwRkmLlLasT/rJBVLGU9N/SNpeUuIhXGsZHoq5Qfbzo7vlBl6LLlnOnKj6LiGs4hRyAP6+
	dgo6/ZvDMgCz6GBvgyBHvLjunanGM/KxO1RN39e/Nz2VvktPRqqZl+2DIqvoYuCHesDXyy
	wGei7J6O2XWE9fhWfJuQXBCjVhKR3TTNwi0gVkTA5DM0+oYXWuA/GgYQg/BaSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789451185;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=b3qERqGgzrD2T4aK1iBclz+AkDg1ZG2HnPrGpORQgtc=;
	b=UQv6m/WtJ2T0Fcb77OBZkn7GOJLESp/+1FzWbyJHxzltCa2wJcVKtKnaJamqzkVU57m+TR
	87TWlr0ETZHv8wDbxAYueD8sAvVz+1BsK9KCJjMxX6XKgz/j7UBj9NB9FCq8xZizNMll9U
	7aSl52sH78GCgxlcNyfUXo36uEH04WJrl0Mqc4I48RlNdjHbqMsKw4/5rNpo/atukRJyAX
	NeJL3Cz5i3XXqTP5ttYM50pxw1hg65Nw0twyXomUHPiHJ9msBb/d6otaj8kz1QiagipCuo
	IJaJZhhIrm5TmQm9t1XXJpj46QCfMJV/YXmFGEr3gdYEuWJr46//vFHPwmDLHw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
From: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
To: Manivannan Sadhasivam <mani@kernel.org>,
	linux-arm-msm@vger.kernel.org
Cc: Juha-Matti Tilli <juha-matti.tilli@iki.fi>,
	Jeff Hugo <jeff.hugo@oss.qualcomm.com>,
	Jeff Johnson <jjohnson@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Mihai Moldovan <ionic@ionic.de>,
	Denis Kenzior <denkenz@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	Andy Gross <agross@kernel.org>,
	linux-kernel@vger.kernel.org,
	mhi@lists.linux.dev,
	linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org,
	netdev@vger.kernel.org
Subject: [PATCH v7 10/15] net: qrtr: Drop remote {NEW|DEL}_LOOKUP messages
Date: Tue, 15 Sep 2026 08:42:02 +0300
Message-Id: <20260915054207.2513877-11-juha-matti.tilli@iki.fi>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Denis Kenzior <denkenz@gmail.com>

These messages are explicitly filtered out by the in-kernel name
service (ns.c).  Filter them out even earlier to save some CPU cycles.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Reviewed-by: Marcel Holtmann <marcel@holtmann.org>
Reviewed-by: Andy Gross <agross@kernel.org>
Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 net/qrtr/af_qrtr.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index ccfa3ed33a996..c139786c56f39 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -621,6 +621,11 @@ int qrtr_endpoint_post(struct qrtr_endpoint *ep, const void *data, size_t len)
 	if (!size || size > len || len != ALIGN(size, 4) + hdrlen)
 		goto err;
 
+	/* Don't allow remote lookups */
+	if (cb->type == QRTR_TYPE_NEW_LOOKUP ||
+	    cb->type == QRTR_TYPE_DEL_LOOKUP)
+		goto err;
+
 	if ((cb->type == QRTR_TYPE_NEW_SERVER ||
 	     cb->type == QRTR_TYPE_RESUME_TX) &&
 	    size < sizeof(struct qrtr_ctrl_pkt))
-- 
2.34.1

