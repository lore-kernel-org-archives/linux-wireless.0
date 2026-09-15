Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C6543E063;
	Tue, 15 Sep 2026 05:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451068; cv=pass; b=GsjH78/RoUuShpeCBAeIUX/ff9zGQwUsBEA4WLuqooSASOZzDt7xUfSCFCHCqiUDlfLgYXkp1X7SAw9Qa3KH+4zbQmB2wCjc94LHxbLngAeRka07G6q5uoncXD0cTHc+R8QU+jTgmZCm5nytcBgeJxRQBieCuPr9eBvKs4wVPi0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451068; c=relaxed/simple;
	bh=ePdcpjW/kLvFZnLJetnASTkIonTXjx3cf8nqDnz7rQY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IGcdQk2dBuv3Dmmpr9vOcpjWeD3YuBApK0XZ3bFY9MElAyx087xNdveFKvRliyTbvGWmvPo1NNYanrS6gBQcHlQqekRVe38gelvmrXwo/TvPTE5hwPXRroLpoFQc1yDfyNtoNcAj6etZd4odFpbqxYyCGXsjeygLhxvMpfY4YIk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=ajsiIfNC; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="ajsiIfNC"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hkWDK4krFzySb;
	Tue, 15 Sep 2026 08:44:17 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1789451059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v6GkYk0HZBFKkX376VoqF+8xKuVMeoSo1m24bvpn9Wg=;
	b=ajsiIfNCO9hm2npmFbvhPirjGVcAczP0wbWRAS1dswu6oKlgl9rogZQ+Ryg9EiXtO86E5W
	mB1HiV8QXHvAx9q6ZzTfoMMJ5zBVgS6INmI1WcaK2DVoTwPJFImf56GD+5q0BS+KB+Ow3n
	S0nvyFBbDBDLOyUvdPtSDstiIy+OsgM=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1789451059;
	b=dLmSL19LgGognTGhdycfQ/y3+GiybIa6A1YSWFYVaH/fj/NK0tUUdYmZux4OozCZC36RXr
	rGAn1gxLgAmovx6SNRoxfk9h1U4KJ7MSH4+dNOl0nBjsww5iJ/MuURu7C/bdgg1qvTL8cW
	JxBSze+PknetOz8eMB0py0DeyAXt/IQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1789451059;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=v6GkYk0HZBFKkX376VoqF+8xKuVMeoSo1m24bvpn9Wg=;
	b=v7iPlidOcOVDpHBsQTK+fn5WKR77Z+TyY81OXnhw13khm6VDXfe+1jsQdg5zadFV/QhY97
	l2HgqakrwzOtptFsm2YxdeyO5SMoTsLdyNjT5ZmQsUpBl2YqfslSLO4SloKJama67hYatA
	w53DSa4aBJhXH3pBrn+sMWjapHpjMTo=
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
Subject: [PATCH v7 04/15] net: qrtr: use only low 16 bits of node/port in 32-bit systems
Date: Tue, 15 Sep 2026 08:41:56 +0300
Message-Id: <20260915054207.2513877-5-juha-matti.tilli@iki.fi>
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

The node id is generally a single fixed value hardcoded into device
firmware. If it happens to be larger than 16 bits on a 32-bit system,
using the value modulo 65536 is enough. It is not necessary to check it
for being in range. Evidence of this is a prior implementation that fit
node_id (u32) and port (u32) into unsigned long in 32-bit systems, in a
manner that completely discarded all bits of node_id. Do the same for
port: don't check for it being in range.

This arguably creates a bug where node_id could clash with a node_id
that has the same low-order 16 bits, or a port could clash with a port
that has the same low-order 16 bits. But it's probably better than
discarding all bits of node and using only bits from port. It's probably
also better than failing if either node or port is out-of-range.

Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 net/qrtr/af_qrtr.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index f2edbd2e9dea9..b2cb05f2480e0 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -252,9 +252,9 @@ static int qrtr_tx_resume(struct qrtr_node *node, struct sk_buff *skb)
 	struct qrtr_tx_flow *flow;
 	unsigned long key = 0;
 
-	if (remote_node > QRTR_INDEX_HALF_UNSIGNED_MAX ||
-	    remote_port > QRTR_INDEX_HALF_UNSIGNED_MAX)
-		return -EINVAL;
+	/* Don't check node/port for the valid range, use only low
+	 * 16 bits on 32-bit architectures.
+	 */
 
 	key = ((unsigned long)(remote_node) << QRTR_INDEX_HALF_BITS) |
 	      ((unsigned long)(remote_port) & QRTR_INDEX_HALF_UNSIGNED_MAX);
@@ -295,11 +295,9 @@ static int qrtr_tx_wait(struct qrtr_node *node, int dest_node, int dest_port,
 	int confirm_rx = 0;
 	int ret;
 
-	if (dest_node < QRTR_INDEX_HALF_SIGNED_MIN ||
-	    dest_node > QRTR_INDEX_HALF_SIGNED_MAX ||
-	    dest_port < QRTR_INDEX_HALF_SIGNED_MIN ||
-	    dest_port > QRTR_INDEX_HALF_SIGNED_MAX)
-		return -EINVAL;
+	/* Don't check node/port for the valid range, use only low
+	 * 16 bits on 32-bit architectures.
+	 */
 
 	key = ((unsigned long)(dest_node) << QRTR_INDEX_HALF_BITS) |
 	      ((unsigned long)(dest_port) & QRTR_INDEX_HALF_UNSIGNED_MAX);
@@ -369,11 +367,9 @@ static int qrtr_tx_flow_failed(struct qrtr_node *node, int dest_node,
 	unsigned long key = 0;
 	struct qrtr_tx_flow *flow;
 
-	if (dest_node < QRTR_INDEX_HALF_SIGNED_MIN ||
-	    dest_node > QRTR_INDEX_HALF_SIGNED_MAX ||
-	    dest_port < QRTR_INDEX_HALF_SIGNED_MIN ||
-	    dest_port > QRTR_INDEX_HALF_SIGNED_MAX)
-		return -EINVAL;
+	/* Don't check node/port for the valid range, use only low
+	 * 16 bits on 32-bit architectures.
+	 */
 
 	key = ((unsigned long)(dest_node) << QRTR_INDEX_HALF_BITS) |
 	      ((unsigned long)(dest_port) & QRTR_INDEX_HALF_UNSIGNED_MAX);
-- 
2.34.1

