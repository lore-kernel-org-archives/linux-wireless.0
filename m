Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4213C1985
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 09:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786957244; cv=none; b=bdRtbUSLLbQ8c8dGFrjbmTjGIiM5dGdhWQlDvh5LKJKrkdUTPHNLW81/c7d8uq7aIynvkP+Vo5JBJiTAwwQns30gcFPF5S0Mv7qhkrfMTdO+k2OWfTQGc6Z46ST+zI2dQVSE8PlcbVmp6A2Kp11tAI47V5FqhJP7S0E+YE9iL5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786957244; c=relaxed/simple;
	bh=0qGIr0XxYUfgc5m7XxbrueWKO9o2wTVndRVZ3YJQiDo=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=hkDMtAOUqjdOf/Qrm2nrXdBsiEeD0YfFyjCI1zjbx+GlacxasG/2Lqs6xbPUUGKg8zKplGJqm9uA/9Y9tr0xLPNTLiXiDdg5RlDek2ZpKqgbCfX29Fq4Ve+my4pW4ys/8bNq9un/EyXtPRVUQJPipIK8Oh61YgtBUPDS6iU57o8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=GGfpq8ES; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GGfpq8ES"
X-UUID: 1b6a4bdc9a1a11f18dc8c9802ae25ab1-20260817
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=NZIevUDAFp93Glr3goDhS++tqmNblnJbtjd9gQvJZ5o=;
	b=GGfpq8ESikoWiYkhiD+b72RLIkyIYTWhh604xrpyAjqWU3ExrIXcFMGhIFrhyILkLVjPsCy30vyuf3KSRcjgTDdCVdk2eLaZEaWRHZUZHTlK8/IJ2P1T73O0D1QTz2LowYWVS5vdem6zbelBSOqZbKycNBucU40YQVlpjR4apgo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:d1ab08da-10e3-4988-9d28-dfde6e48066b,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:7db8b62,CLOUDID:d6fa6101-0be7-4d29-848b-f75bedecbc73,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1b6a4bdc9a1a11f18dc8c9802ae25ab1-20260817
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1406881880; Mon, 17 Aug 2026 17:00:34 +0800
Received: from mtkmbs13n2.mediatek.inc (172.21.101.108) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 17 Aug 2026 17:00:33 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 17 Aug 2026 17:00:33 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>,
	<eason.lai@mediatek.com>, Devin Wittmayer <lucid_duck@justthetip.ca>
Subject: [PATCH v1] wifi: mt76: mt792x: fix UAF in SDIO TX path when out of memory
Date: Mon, 17 Aug 2026 17:00:29 +0800
Message-ID: <20260817090029.167552-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Using __skb_pad() instead of skb_pad() in mt76_skb_adjust_pad()
to prevent double-free, as the caller handles cleanup.

Fixes: 808f2767d421 ("wifi: mt76: mt792x: Fix memory leak in SDIO TX path")

Co-developed-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Eason Lai <eason.lai@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/tx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/tx.c b/drivers/net/wireless/mediatek/mt76/tx.c
index 3707ee19e4ae..ec503521ae63 100644
--- a/drivers/net/wireless/mediatek/mt76/tx.c
+++ b/drivers/net/wireless/mediatek/mt76/tx.c
@@ -879,7 +879,7 @@ int mt76_skb_adjust_pad(struct sk_buff *skb, int pad)
 		}
 	}
 
-	if (skb_pad(last, pad))
+	if (__skb_pad(last, pad, false))
 		return -ENOMEM;
 
 	__skb_put(last, pad);
-- 
2.45.2

