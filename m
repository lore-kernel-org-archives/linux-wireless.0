Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A3D43E9F9;
	Tue, 15 Sep 2026 05:48:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789451305; cv=pass; b=I/oQfP7wlG2TZ9ZRhMehFBYWzfO3rKq+lValZHQpEvxYBRBSPAS3N6VwvIuqeoVia9xQy7z8LFc3OKDVyXLNOrcXCuBnfBHcOFYG0eA3qIUxtKe73Dv7t0LYiNSUr1oqSrDzR5PJ0aDhxP3W6hML4c7CMayZNltlEfjlOW0IGg4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789451305; c=relaxed/simple;
	bh=9/6M3/7gt0JLWQuczN0WgWo8dNZ1el0eF+EvhihOWSc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ibbd5iraWN4I36oyaAvSnieVwhcAbCiEmCR0iVoKHCxQS/xRTROaE4A3hT+l8aFDEFh5izeHH0qYZTUVltcOamRXm3NSfoYJOnt7m7NBkQ3zBA/u6vSnwo8T3f+mcjyQ37x7brfBxwxJNr68aYYt/WE2Fs/ydktg4d5tkF7F8/E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=KytI+jpD; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="KytI+jpD"
Received: from mandelbrot.. (xdsl-83-150-90-33.nebulazone.fi [83.150.90.33])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hkWJx68B7z49Q32;
	Tue, 15 Sep 2026 08:48:17 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789451298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9DZArNhvvAzVfrl1dfODQGqES9F9P7LrpHsacGtJDNA=;
	b=KytI+jpDm+VXWaQlWntDClP3mbKkyfu1BZqP5+8YViWP6GcQ+jEBiJYGWheGr7YSVU02uV
	2B+le+nK7RE1yv46v+ZVgAf6YZ3LVGt9qU1EG1In5hbh+6FPavx06oFfX5Y1TNFtsezMHy
	gLcFplWlo/zi8RL44aoBXePHjnflHp9Kw4PYifw78NpLwHC7JWV6583nU6JSMo4GSJsLzo
	Wq3EydeOW8l167pJDLweH8KG+EHfqZzH0o8WlDltqqjWtzpbbU/RdiUOTt4b1IgoEiazOG
	o2OZ0xAL3TQTvsKCF18t35NccQlma4OQYoAFpVI4GWozRX1DNVe0gEC9QCeX4Q==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789451298;
	b=llhd1Iwj/4wL6tuosk4gk5cMohP+ItEoAbTQ94C43a6NFJ46FeeXMVrMmkUIlfvT9cBWjr
	MUTlerohnrQj47ElH2yeoth8q7PZw9+EeLPJuQlH9o7Omxj/JKT2JtO7a2ZdL9JlI3EDkx
	zrFmsiUo3I6fMn8sfJOzL3LjfM0xLnEE7zjbSfySwqpEDx3iM8X1C7iv17nMO3IVdOBtnJ
	CsUtUz95/zVqdQVdZOrPO2nnUQRvRCWsJ/JQTiPle+jYtR2y1vrs6diAsG8JG/GO60REux
	YyKDeTFvssSm8kV8cne1eiuqmMNecnPRqi7Ed+WGQWKpAvcYen2caU+nhC3WDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789451298;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9DZArNhvvAzVfrl1dfODQGqES9F9P7LrpHsacGtJDNA=;
	b=a8WmTcRpsY9kpaR00zL9DxydUHYqNRde+lPVpjgQzZd7sFxDEpqhlrUvo8fpdM+xsL0KFb
	hh1I4daH4KXIfH8u4kb9TGXyHuPhyIdCKETV5csylmWECVuibwL/iC1MDP2i4+BpNxk0sR
	UwM+s60LGcV6d69Jmuk/gU3vpWUEHGCHpyztZCmfdilRfq0PGapizIcpQORagprJ2ndhlR
	lLTB1cAVZ72ALHt714L7zV2UVlbO6eRkdBUEpvRTQrGKWoEJt7Oz+yPuYRhxY+BoKXVMtm
	D9GznDgel530LlZmUKtfw157NTk3oykcRqHaWWe4AwGjA5h8OrVuhne0vpGgjA==
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
Subject: [PATCH v7 14/15] net: qrtr: use nid modulo 65536 in 32-bit lookups
Date: Tue, 15 Sep 2026 08:42:06 +0300
Message-Id: <20260915054207.2513877-15-juha-matti.tilli@iki.fi>
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

The node id is chosen by the device firmware, and is generally a small
single number. However, there's nothing to prevent the device from
choosing a large node id. Use node id modulo 65536 in 32-bit systems to
allow it to work in cases where the node id is large.

NOTE: this commit is a candidate for squashing with the previous and
next commit, if we want to have the "radix tree of trees" approach. This
note should probably be removed before committing. If we don't want
"radix tree of trees", this commit needs careful decision of whether we
may want to drop it.

Signed-off-by: Juha-Matti Tilli <juha-matti.tilli@iki.fi>
---
 net/qrtr/af_qrtr.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/qrtr/af_qrtr.c b/net/qrtr/af_qrtr.c
index 3c84da3059a80..87eb7363c4a9f 100644
--- a/net/qrtr/af_qrtr.c
+++ b/net/qrtr/af_qrtr.c
@@ -497,8 +497,11 @@ static struct qrtr_node *qrtr_node_lookup(unsigned int endpoint_id,
 	unsigned long flags;
 	unsigned long key = 0;
 
-	if (endpoint_id > QRTR_INDEX_HALF_UNSIGNED_MAX ||
-	    nid > QRTR_INDEX_HALF_UNSIGNED_MAX)
+	/* nid is chosen by device firmware and is generally a single
+	 * and small number. If firmware chooses otherwise, use it
+	 * modulo 65536 in 32-bit systems.
+	 */
+	if (endpoint_id > QRTR_INDEX_HALF_UNSIGNED_MAX)
 		return node;
 
 	key = ((unsigned long)(endpoint_id) << QRTR_INDEX_HALF_BITS) |
@@ -529,8 +532,11 @@ static int qrtr_node_assign(struct qrtr_node *node, unsigned int nid)
 	if (nid == QRTR_EP_NID_AUTO)
 		return 0;
 
-	if (node->ep->id > QRTR_INDEX_HALF_UNSIGNED_MAX ||
-	    nid > QRTR_INDEX_HALF_UNSIGNED_MAX)
+	/* nid is chosen by device firmware and is generally a single
+	 * and small number. If firmware chooses otherwise, use it
+	 * modulo 65536 in 32-bit systems.
+	 */
+	if (node->ep->id > QRTR_INDEX_HALF_UNSIGNED_MAX)
 		return -EINVAL;
 
 	spin_lock_irqsave(&qrtr_nodes_lock, flags);
-- 
2.34.1

