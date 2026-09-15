Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EF2043BDC8;
	Tue, 15 Sep 2026 05:47:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451267; cv=pass; b=GhXtTa+2cxekohCAuzxyEeEBvXU8YpyVpjAO94ISy7mTCfsmIGBNGZp+WluByrpMBaM4yYIx64R2XcczIR99eJ2teOx7exZ+13VKhFpT9Z+T/ydaO5Jj68EJ6OdP7EGd3W5FFIbdx065lq4VxGka02s5AllFLcomNxjb5p7nAXI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451267; c=relaxed/simple;
	bh=lmfXVdhj4XKXkltUcw+u085d9Gv1YopwSSRwYiRt+mI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uw2nLmdvansgXTnYKcWzW2jpIGkD6yYGvLG1GMKEQd6ESYe+BXgcONLgAJXvCpgZo4lHv3/u9ocr1Nw9VDpIjC0QuhNgrcSVPoJ5EofcxN7yxLCtgt+qP3wrHPD2C0LHq3Rx2yoHzlfalGHsm//UyR8jWmNeAglQEiooIZjPf3Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=RRpAzP0r; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="RRpAzP0r"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkWJD46Dxz49Q6x;
	Tue, 15 Sep 2026 08:47:40 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789451260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZL4TqLJCUHMypohzoaU3V9T/82qT11Mw0FniRBnY4gk=;
	b=RRpAzP0rct1htzJzzS0BWkkX4BAeYSFLpHT9GeN58Iij5peky4BObPmkaIMrdy68+/ml8j
	Fm4GHfJhjXn3W6X2HTAtQanFSOAZ3l5Aa6fqa4gO36dNo7AkwWJ9nOcmsgW89Y+nlAOIDT
	8mUQf8Mrf5VPGaeCcWhNz9ArltdSBSpr6WRh9F17FMbdov2O+yjAefc9XJPlKEsg/KP8Rm
	L/hKAXvSl5xc3guYI33deKPMKY6gw7olVfHC992GX4+h7iWHkQktz9hg16OnMNFNnOZdJW
	79MN4wNo6wzlaHq6e6NmIp1iJlqD5oDaiO7G+sAGOC5Z7ydRO5UaUWKR0QWQhg==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789451260;
	b=t89+cva3wNzd0ZHDUSo2MFdt1cs3SzleXZ+hyhjgGP6W11OaO5zlz5RzlkeBjzh8h0/Dvq
	QN0zGUoUfISenyXCH9OOYZhC5JaptTRB9AlIARZKcWBumGA4RX8md1jFznTKMbjScR4q6h
	FnCn2k4lLQ63fUkqkhFL7vGKtRX0Ggvgse9ZMowZGAXYAlBFTTeOQCMlUEwb5uLl5U+Hbq
	ia/Ce62fcavKxMO/TD1JGMwXwXYusxDCg7dlvvsoCqnBaaHU5ECNSlJZ5dXHHcpJvI0obO
	8cxuqntEQnt9UwMe2JBhYI5UG/76jGhKZeSJzQv2quMf4BTycnXkPQ+H1ckjSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789451260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZL4TqLJCUHMypohzoaU3V9T/82qT11Mw0FniRBnY4gk=;
	b=UZzsRLN/oAXl3bHpS2GGg+HFNscL5SpoyYxwW30FasIzdT+QQK5+CZ4jnDYX4kU3Ix2pO3
	rpQFWZ8ji8rmPuwP0pJRAmDugYdyYfhaZpTSKqh9uoB2tlkid52+BFffQxvsNBX+aLRrrV
	q/Ze2FAInpVuEEK2fMa/FYS0HnLaB3akjJNK4ypVDj84CiOqXPY57gJhSp7qwIaSr4vNmw
	Ae8w7Rpl7HCHwj92qeaGXhnOtt955YAYithupAuT4fgmKpq27jxFARJvZmFMz86xYo+kjz
	lTiKJ+0I+UYoLiL5U4HjSF4MUCdlfM6sLNVJCzFk8WTH0dCqDltVM25i3rtczg==
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
Subject: [PATCH v7 13/15] net: qrtr: limit endpoint range to 16 bits on 32-bit machines
Date: Tue, 15 Sep 2026 08:42:05 +0300
Message-Id: <20260915054207.2513877-14-juha-matti.tilli@iki.fi>
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

On 64-bit machines, use the full range for endpoint ids, but on 32-bit
machines, use only 16 bits. This gives plenty of endpoints, 65534 to
be specific, apart from the invalid zero value and the local endpoint.

This should fix any issues where a long-running system with lots of
allocations might allocate an endpoint id bigger than 65535 on a 32-bit
system. The node id, the secondary part, is already combined with port
id into a value that is potentially 32 bits in existing old code.

NOTE: this commit is a candidate for squashing with the two next
commits, if we want to have the "radix tree of trees" approach. This
note should probably be removed before committing. If we don't want
"radix tree of trees", this commit needs careful decision of whether we
may want to drop it.

Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 net/qrtr/af_qrtr.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index b27c5a659795d..3c84da3059a80 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -22,7 +22,11 @@
 #define QRTR_MAX_EPH_SOCKET 0x7fff
 #define QRTR_EPH_PORT_RANGE \
 		XA_LIMIT(QRTR_MIN_EPH_SOCKET, QRTR_MAX_EPH_SOCKET)
+#if BITS_PER_LONG >= 64
 #define QRTR_ENDPOINT_RANGE XA_LIMIT(qrtr_local_nid + 1, INT_MAX)
+#else
+#define QRTR_ENDPOINT_RANGE XA_LIMIT(qrtr_local_nid + 1, USHRT_MAX)
+#endif
 
 #define QRTR_PORT_CTRL_LEGACY 0xffff
 
-- 
2.34.1

