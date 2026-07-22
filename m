Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 866A5432BD3
	for <linux-wireless@vger.kernel.org>; Wed, 22 Jul 2026 08:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784708784; cv=none; b=XUTDwmaYXlMcG+4C6oUBZLJ2PI6/E9iJ9jk/9fFj+S9xkwEOPv3em2x3L9H7nCCYv4P+rhA8dRJfERUPtwWnuxnh4zhs8EO6xQ0jAjY9FBQZCxZcs3/x6DR3/JGauToPS5wpYtZvAIZYZSWe8tqXHED1wqIhFOtKs9XCRcbBrGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784708784; c=relaxed/simple;
	bh=94Gg71vG5DZerEA0EMKVlbTejDFQIvHSBM7uj8UdSAY=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ug44bH5wiI3ETRoY+n6Z7ygP4qI+auI1bFLW/OFLD/AAefJlfp/TmXv2wmtRz/3JKM/EYGFC3YXHdf8poxgUn299I7/haskVL4qg2FF25mEv5oVfbna2+aVHQcbcLsQJJLHOLClfftaSyapKALj+WiDV3TwYXeZqfg/2RmaV3j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=pH9FOIBz; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="pH9FOIBz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=vm4n0mvrHXw6Ut1R3RMwxZjtZADw0QDtVfCUAPIhwc8=; b=pH9FOIBztfcuWG8KA2Mj0IvuRc
	pjypHZAldUDqMnF1kXnm6DgzIJ6lH3tBHgqPbrmAOL2ymj5iU4VSJ1eXyowRZPDwWKS8v65kM4UYV
	zqM0fEJ/uvxes7ZChVRapTgl8RmxR+rWnGaTDOuYCk1BIMQsqhWiFVL4wajpa89Aq3qU=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1wmSHR-005AHx-2A
	for linux-wireless@vger.kernel.org;
	Wed, 22 Jul 2026 10:26:17 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 17/18] wifi: mt76: fix RXDMAD_C buffer recycling race
Date: Wed, 22 Jul 2026 08:26:09 +0000
Message-ID: <20260722082610.2699628-17-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260722082610.2699628-1-nbd@nbd.name>
References: <20260722082610.2699628-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RXDMAD_C buffers come from the RRO data queues' page pools, which are
bound to a different NAPI, so the direct page-pool recycle used here could
race the owning NAPI; take the non-direct path as is already done for WED
RX queues.

Fixes: e50d4d710efd ("wifi: mt76: Add mt76_dma_get_rxdmad_c_buf utility routione")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 drivers/net/wireless/mediatek/mt76/dma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index ec0acd3ce774..6d8b598bdb6f 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -1000,7 +1000,8 @@ mt76_dma_rx_process(struct mt76_dev *dev, struct mt76_queue *q, int budget)
 	struct sk_buff *skb;
 	unsigned char *data;
 	bool check_ddone = false;
-	bool allow_direct = !mt76_queue_is_wed_rx(q);
+	bool allow_direct = !mt76_queue_is_wed_rx(q) &&
+			    !mt76_queue_is_wed_rro_rxdmad_c(q);
 	bool more;
 
 	if ((q->flags & MT_QFLAG_WED_RRO_EN) ||
-- 
2.53.0

