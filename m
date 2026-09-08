Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6EE4523782;
	Tue,  8 Sep 2026 09:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859977; cv=pass; b=YBARs/4XcriXkco82FKUt2p4j+xgvjNtttJKV0uFpB2snOD/b4gszXhl8x8atAU4G8UysooUHImDsVpdyXH6ALqU6l+mjR9SvN/GrMqn+xa7IOfXBbpXZBuqWS9riGcyBdKIGHLRrGTYvsB9zqMlZEnXUfrMB1VLrEozeMUhR0w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859977; c=relaxed/simple;
	bh=fFVpnQJZzO4PFI4NbxLVE75hxJzqPxs7InUICkJ+M+s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mPRzMf6SrePZMo8AhaZUHgfG1uf3Ub9/GWjfE98JxLP57rrw5lmM6WIYhb/aY+WobvBQhJSu10COrnp/xz9/2TaGpjdnnGUCx2NDJhEBxPNFYOUBCoShwbaUwjzyHYqN3SYbPusSwGcR9IMfGFiFNn3Y7yVFKbEYM/VzsMTRDt0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=ljZX/e+g; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="ljZX/e+g"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hfJdF16ZKz49Q5T;
	Tue, 08 Sep 2026 12:32:49 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1788859969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UskWr+boRdHCKqvgiQhgiQCmhJi2c28VCTFGVe919rE=;
	b=ljZX/e+gAy5wqtt2JXd92XUF51cPmrc8n43j2UYSe9JvsQ/0aYejmN6sTgFOb3qWi/oGnD
	4ojH4CjNah9Nf1Oj+bWbjVwBkLwwlrAkUqwha+MU3d5WxhFQASJNvI1lV6HphRagBJP38z
	2Acs7W4lUjARLJe1Ox3D3rhnr69PESYoXbr1EPGKGmhKFbpKavxjp9enhan2BVwLiRBkGs
	Na60Eqd7FZgAdXKVbUDeTuTY+sEcIV2MXfXdRGkTVMUMH/qZI3GAHMyXMxpwwzLoHfXfw6
	4cEMnmXpY696nvkEafCKU4WHQ8mQpHBQMWiRdoHpH7iKlrbMfeRjl3u8dAzGBQ==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1788859969;
	b=YAxe8mc116ZAbijctVtRdisbycCjvTyKC4zoDBMgKa74VtggXJnyoOIx1Ytv5+UDZsu9Kf
	K187SQUTFw/PVBvEfnQiV/QAi4dlhAeDkBOAcmdKbW41nLLgLjY07RyBa2fWg9Lf5aTKI9
	XxsRph5FlLgNTbiP+vc473I+K+UDHP8Oj8Wcf3aou/W1og34hEjIQmI0IVz5lzsBd5bdmx
	guWaCrqMzHofLLHomvke8V7aeZjzWiqtHRL6sf9svJdC9eWubke3FlALIqWliW4IyHlmB0
	rXQ4fqka10aZulpck3Feu4+O0dMIJFJiiHIC+OFiJ6Qgp1wb9BRCbc14F/7PXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1788859969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=UskWr+boRdHCKqvgiQhgiQCmhJi2c28VCTFGVe919rE=;
	b=mCuMYCZVoyAxCIj24CVKELQe4WxjQ5Bjwu6akEhGPzNsa23TzvTHJOSb2B4U2wuuNovkWF
	bQ5G6Ir3rzvwB6ZKX9kaWq4RtdmsueeNDeqGrnF/ljKwvI8f+dhg0EZONBdSk5gCBm9MP1
	JDZ8hHImIPAPsBfpfJClSKYJ/QYBKLauMmNvCXDMQ2vXn03nC7Ui7AzKoR511sJbLr4AcY
	WGYJ12jDlYAhumQSaP+jqG/34bn838yxpJbu2X4I5TdBNVo3gxytM1jNJr+t0RSmwzZYTh
	4KtFO4GNQUYDyUuMiHmSCiJjDrhngoBVZ2417Pwi5hBOUVAvu/JHNy9LKSVaaQ==
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
Subject: [PATCH v3 05/12] soc: qcom: qmi_helpers: optionally bind to QRTR endpoint ID in qmi_sock_create
Date: Tue,  8 Sep 2026 12:31:38 +0300
Message-Id: <20260908093145.2492666-6-juha-matti.tilli@iki.fi>
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

