Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B00352122E;
	Tue,  8 Sep 2026 09:32:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788859969; cv=pass; b=AkO5PqlQayqn1+IjFxbyEGfTSzJs0B2lwtah/QbmLmj3rla04t/Uv2TI/onzq4cCgyLfnKXWdj4HaU9+NfKvtX8fnUN4XzhrHDKBhJrJiub8Ro1R+wjPSuV3lUX2TUVCAoJx9cs4wuCb5eaDJ8gVRIRJMklh13cdZ2jpGHGXbj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788859969; c=relaxed/simple;
	bh=abrrbXf+C9yT3jDSTjifMWlBVf4KJoVMvnOKyh+KQj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W5io9Zog2ucGD3nMvroGJYp123qcZN/NLKsxQDLwifiwRqgAY1U4VkjtpQPxmzGd5RkP3lCMlJVGYWu6Ni8aOw8xS3rC1TJegbjdS6k0v8iMrK76sHN1eXJ6MoHTM4PmEAdNz8uUGeTpVe4CN6bWsWICywvPIW3EsN5vht8/MCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=GDFvosVQ; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="GDFvosVQ"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hfJd61d3kz49QFh;
	Tue, 08 Sep 2026 12:32:42 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1788859962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPA7RZq69BQzFDIgq2/jKxXiYvSrAjNW2sfY7vkWUj8=;
	b=GDFvosVQwFpz2usimAFdYNa/rQFAovzLdeUu9VV/g1d7bGTu0waN7IL5GAnWddgfUoURD2
	vrbsu1mlHExaZN8yiHgnqWJd3DvTatgGsURpSMz25dSER6SNo7hKyBwHan83sJEBN5Ru2h
	otQRVok3uF5Gw4jPdX0tLS1F2o2YJ6vx298EsjZUZWhWgOFJc+SNbqP5+yaeuYsZVH4TIb
	TtIxMyyYmjJulqB38IL8qg3IDk2GwOVZh5YpqmYp7EjlQpmx8HECyvy6VNQpQ9sD36L+Fi
	kUTThOiLuAY6QR9OcsIZ8GhkWt+2grVJedoOXierqzw4q9y9KYVwpPOds3v8GA==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1788859962;
	b=NLgnrOeoDJpVgYSEYU8v8YmQx8sQXOoaWImMRa2axAzDmwIdpxs4bPB7DFo9t6ibMBub4Q
	H+49bVvlW6CTIUWaFkIy2bK7DYJEdyKHBg0WwM9xRrFSA1yD2KYY649rqwkmRipaP611Wh
	Bl0PytgTOz2IqpvhXpOrzwgmHfS3VXJdSpTWFi9Te3/wMLLzNSPaAvr1AAHRjMTp8rzGS9
	fS6vvIqjXMZYtqxFZhKZhiwxS2pc64tqWAgmvwvAOub9ieSKz9+2MuUZTzG1FMyQRIcg+U
	Pq9HuxLWD2tafHvQ8dS072KrBY2qOSnHjIeBfNxUWp1nPwloKeTVFQrIdOi02Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1788859962;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPA7RZq69BQzFDIgq2/jKxXiYvSrAjNW2sfY7vkWUj8=;
	b=HoFS9EwbSdJUQMmFbT/OfPafoLTbPvoEWzqKRVA2SssR3h/P5gM5Zc7b+TARFC4SBZAPKz
	Sre+m/xRtLQutYf28q0uVIXWaNGje4TZBrurWUdWXyyhAEadcB0GK+XsF4Y5OQKL9ofS61
	vkBwok2pNHVGMus5TT2Jiy1D2jtFgMcqucE/CBHpnWd4hOn/Z9nWXviuyzdPK6IwI6yi8K
	93dd2dIZKDNTr1HijayJUbvIc0cXUNw5g4Lg6DrTe861drYesoPTIthVlF+pN50SP69+Cd
	g+s9qYmYTycDJbfHqfHJ8B9NTN7WoS/bQHoo0rVRJMTOR45nfKCkAVHs1cVbVw==
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
Subject: [PATCH v3 04/12] soc: qcom: qmi_helpers: add QRTR endpoint ID to qmi_handle
Date: Tue,  8 Sep 2026 12:31:37 +0300
Message-Id: <20260908093145.2492666-5-juha-matti.tilli@iki.fi>
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

Adding this allows us to easily supply an endpoint ID to bind on later
on when creating the socket.

Signed-off-by: Mihai Moldovan <ionic@ionic.de>
Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 include/linux/soc/qcom/qmi.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/soc/qcom/qmi.h b/include/linux/soc/qcom/qmi.h
index b9dcb437a0be5..c675d095df778 100644
--- a/include/linux/soc/qcom/qmi.h
+++ b/include/linux/soc/qcom/qmi.h
@@ -224,6 +224,7 @@ struct qmi_msg_handler {
  * @txns:	outstanding transactions
  * @txn_lock:	lock for modifications of @txns
  * @handlers:	list of handlers for incoming messages
+ * @endpoint_id: QRTR endpoint ID to bind on
  */
 struct qmi_handle {
 	struct socket *sock;
@@ -247,6 +248,8 @@ struct qmi_handle {
 	struct mutex txn_lock;
 
 	const struct qmi_msg_handler *handlers;
+
+	u32 endpoint_id;
 };
 
 int qmi_add_lookup(struct qmi_handle *qmi, unsigned int service,
-- 
2.34.1

