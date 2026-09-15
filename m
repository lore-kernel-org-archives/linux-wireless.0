Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23464457C6;
	Tue, 15 Sep 2026 07:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789458213; cv=pass; b=de/DqklpPJW/vlaWXP4pTCUOdFi0cVo/M0ITQm2X9ZrDq0EZRh5mmnfJt3hfJXExuDoRWGmgIf/zLs+ieE1ZuZRfh1HT4jhCCiUVuofNHTcqlTmL5mTD9XGIzmNxo2giGYKEbiZguRvpnEw6V6YE2eQveS/pzv/G2TXcXKUD0Ns=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789458213; c=relaxed/simple;
	bh=abrrbXf+C9yT3jDSTjifMWlBVf4KJoVMvnOKyh+KQj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iUU/HMKNgYZPOjek/Tjv0HJXR1jFHURihs8DYmko9TECLeVxA3BWaeMMLyx08v0kZsm33L6QuCwlr9/D6elwVwQM8FiDFZMy2BRFlcbXluYUGVSG9dBDLxv9h4s+1mnG0/fLHvdJaXDubcdOhhj0TEl0PeaGOpUxzmiAkOdTqWo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=sQZTsgij; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="sQZTsgij"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hkYsm0xH2z10gQ;
	Tue, 15 Sep 2026 10:43:23 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1789458205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPA7RZq69BQzFDIgq2/jKxXiYvSrAjNW2sfY7vkWUj8=;
	b=sQZTsgijT5BJPzxeZO6a9ZD4L3yEQZfcJc+delxOjkxJtlJvP/ZaJVNl+U4yimEaa9scc+
	AlXqhZlE4t5Bc97/t4/F0D8Z9Uf+TIFtCqe45o7sdOPTpsrfjzQNXnNCjONqxSIXVsbTql
	BuCvONLnSnl/rDE7CehWZFKJG7QJSRM=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1789458205;
	b=Np7ktd9E+ATajFhlNmOegyVEOIRnF+yuzqOt7VjvpA4ON23pYgN8MjulJh9qcuZ94rSz47
	BK+RiFQ7f1CflCLZXg8xtQ9e9LxqiS1b3lslbYoJwxNMlvA4pwWMJROKCzTFu0SqSFknwn
	DmcvlTvnJoUH+t8XRwupXETtyZFFwaU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1789458205;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bPA7RZq69BQzFDIgq2/jKxXiYvSrAjNW2sfY7vkWUj8=;
	b=bxUEYZTBusqXVe4YFqWSk95FDQRd8s+cctXMDt7lUJy5Xl1m2HPVF/sWn4AhitzBuPY3aj
	q1qyNZC+2R93bwJwS2/pdXjL1E6i6F55wnNarF6UUlP0jYhcNzokR4HTFlzT8JLYV9Y40T
	T4Ves6Q913O+2mDxm3cWC0QOCdwv35E=
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
Subject: [PATCH v4 04/12] soc: qcom: qmi_helpers: add QRTR endpoint ID to qmi_handle
Date: Tue, 15 Sep 2026 10:41:27 +0300
Message-Id: <20260915074135.2567411-5-juha-matti.tilli@iki.fi>
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

