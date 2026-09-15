Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D38138F651;
	Tue, 15 Sep 2026 07:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458230; cv=pass; b=I3DBCvBJBG1V7bij2SkN74qIgNsRT/8Iy5hR/T/QVQ6lCSefmxhtW3ZIu04DkUDqtB/L6Q1NAq3qboyr070YLpnH+bE1wcIg93LtGw/RBw60VhfYLjQHoBp6X9rt7gEm0xTlk1ubm/Q2B9tjgta4VN3pZY3PtZQXN6yhGwTj+z8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458230; c=relaxed/simple;
	bh=fFVpnQJZzO4PFI4NbxLVE75hxJzqPxs7InUICkJ+M+s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=X/0VbHPZVYjPWw0RfSn3jTpOFMWaVBfbn2i40iaDZT9314A2lP5fbl13Vfjyyl2z39pvZ628SbjWwwGadjp0NDqGBkiRqbpu4R/GU+96ZU7R3J53sMGa4yGKyCvil/fr+mof6Iie6cH5LJ1JT3VzDyMEqY+0bPfaSDXOEke1k1s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=uF2UudJQ; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="uF2UudJQ"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hkYt63SM6z10gQ;
	Tue, 15 Sep 2026 10:43:42 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1789458222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UskWr+boRdHCKqvgiQhgiQCmhJi2c28VCTFGVe919rE=;
	b=uF2UudJQi1HbWTVWqlG2rGygix9dZkMlXzhFxDVNOWn1GEO1CGNETZL/WFeh/y2rnEciQR
	09BjyeA8nmcs4NRAHgL+zNywuC54OHD8yGBf8QetE6MpRSlKwtdSkhwOFdRMEwwD8SuPJv
	wjs4RE034uc0kWuAhKaCWzpyH8mX4vo=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1789458222;
	b=py988pwZ3T9FKk43ST1Ebl7nq7c/K0VxGb3Cbu06lS7T5CmVcgiq9I4774d7ry3EzjBYWq
	pCtMn+WJCuOKhyjyVmE2YAysF42Yy/jP7y5Xq9fqhwlQVnysCNxz2k9969v7XUuMGDH02x
	Otw+D7Ybps9pU4U1sEP/dajRHI7fyfE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1789458222;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UskWr+boRdHCKqvgiQhgiQCmhJi2c28VCTFGVe919rE=;
	b=BG/gyx31xY1cSmGwyq0CvB/kiH2sNTbQoOTr5eBZ6rrMlZ2vr7R5sdFm0JvTBy3CzaTBC1
	rKrIpaVl8zxdr2ypZin7K29K1L+jgbpQiIOQUveopa65i2WfWjbUsNoU2nF20ht7/V5jsn
	yEX99xQUr1irBsRn4DEXA4/rtA62giU=
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
Subject: [PATCH v4 05/12] soc: qcom: qmi_helpers: optionally bind to QRTR endpoint ID in qmi_sock_create
Date: Tue, 15 Sep 2026 10:41:28 +0300
Message-Id: <20260915074135.2567411-6-juha-matti.tilli@iki.fi>
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

For clients that already know the QRTR endpoint ID before actually
creating the QMI socket and set it in struct qmi_handle, optionally try
to bind to this QRTR endpoint ID when creating the socket.

This can fail, and qmi_sock_create will issue diagnostic messages, but
otherwise ignore the error.

Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 drivers/soc/qcom/qmi_interface.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/soc/qcom/qmi_interface.c b/drivers/soc/qcom/qmi_interface.c
index 16e2e24b60968..1550138a938d2 100644
--- a/drivers/soc/qcom/qmi_interface.c
+++ b/drivers/soc/qcom/qmi_interface.c
@@ -586,6 +586,7 @@ static struct socket *qmi_sock_create(struct qmi_handle *qmi,
 				      struct sockaddr_qrtr *sq)
 {
 	struct socket *sock;
+	const struct proto_ops *ops = NULL;
 	int ret;
 
 	ret = sock_create_kern(&init_net, AF_QIPCRTR, SOCK_DGRAM,
@@ -593,6 +594,33 @@ static struct socket *qmi_sock_create(struct qmi_handle *qmi,
 	if (ret < 0)
 		return ERR_PTR(ret);
 
+	ops = READ_ONCE(sock->ops);
+
+	if (!ops) {
+		pr_warn("sock->ops not available for QMI socket\n");
+		pr_warn("will not be able to bind to endpoint ID.\n");
+		/* N.B.: this error value will not be passed out. */
+		ret = -ENXIO;
+	}
+
+	if (!ret && !ops->setsockopt) {
+		pr_warn("ops->setsockopt not available for QMI socket\n");
+		pr_warn("will not be able to bind to endpoint ID.\n");
+		/* N.B.: this error value will not be passed out. */
+		ret = -ENXIO;
+	}
+
+	/* Only bind to a specific endpoint if a valid one was provided. */
+	if (!ret && qmi->endpoint_id) {
+		ret = ops->setsockopt(sock, SOL_QRTR, QRTR_BIND_ENDPOINT,
+				      KERNEL_SOCKPTR(&qmi->endpoint_id),
+				      sizeof(qmi->endpoint_id));
+
+		if (ret < 0)
+			pr_warn("binding to QRTR endpoint ID failed: %d\n",
+				ret);
+	}
+
 	ret = kernel_getsockname(sock, (struct sockaddr *)sq);
 	if (ret < 0) {
 		sock_release(sock);
-- 
2.34.1

