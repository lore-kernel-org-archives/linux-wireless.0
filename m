Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D56E4A3410
	for <linux-wireless@vger.kernel.org>; Fri,  5 Jun 2026 11:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780659206; cv=none; b=YyCCWz8wLjzXYOqCC16r1N1OQ3/IqRrHm1zVGYe6PQPQdtVIBYTXk1cb0GmnnP74uQe/pRSwQ2STw+M4q5SbQW0DMYhDmMLmWrsyiuRhylkBtGFIW64/lThG1ILO1AJM5uHn92it7Y6RcZLESbYN+R7ZuoUKRah46R764BQwgdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780659206; c=relaxed/simple;
	bh=eRwyXUHRBAbE3fEJvYA2VJjkLz5I32YOVdBWHpLrIjQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dDiELl/TsYUhUU20UE6UHVJsZDoAMrRrNOEuNO1tWI4vF+l++rZ+3o74M3bLwCrTe3v8jJUomvT4cFB+f+8v2ErRa+r7MZNr/ZPXV7gU2+Ikl4aVCLyhNXrbXKzovyfQjsCvgV2C1uwF5tgSY1UBZ8n9pFjFtXXzSDegcwKLk88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=QGF03WSZ; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="QGF03WSZ"
X-UUID: 5a723a2860d211f18dc8c9802ae25ab1-20260605
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=kVfZZFzUPlA1ML0K+6cPCDB3mhjRNDsilzZV8Yr+ce4=;
	b=QGF03WSZFAazQUTw3JTAhLCfSIUQkS+uE6bFabL7oBZH0ufvPWHOg+7xF1GPssWFD08wLZFqY7J2/20xns1v/bPTjv2dJRXur0/UtXw8IuxUrARPPxbr8mJ+O74dt3ezNPZhKKMK1Uz0nigQex4XPRyH2yAL5cPybXQct7hRIVY=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:7a55722f-df16-4615-a482-279a4589d529,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:26116820-87a8-421b-982c-f5939dba7cba,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|865|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 5a723a2860d211f18dc8c9802ae25ab1-20260605
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <ryder.lee@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1822243437; Fri, 05 Jun 2026 19:33:20 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 5 Jun 2026 19:33:18 +0800
Received: from mussdccf250.eus.mediatek.inc (10.73.250.250) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 5 Jun 2026 19:33:17 +0800
From: Ryder Lee <ryder.lee@mediatek.com>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-mediatek@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Shayne Chen <shayne.chen@mediatek.com>, Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 4/4] wifi: mt76: mt7996: fix potential tx_retries underflow
Date: Fri, 5 Jun 2026 04:33:06 -0700
Message-ID: <20260605113306.3485554-4-ryder.lee@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260605113306.3485554-1-ryder.lee@mediatek.com>
References: <20260605113306.3485554-1-ryder.lee@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

When FIELD_GET returns 0 for the retry count, subtracting 1 causes
an unsigned integer underflow, resulting in tx_retries becoming a
very large value (0xFFFFFFFF for u32).

Fix by checking if count is non-zero before subtracting 1.

Fixes: 2461599f835e ("wifi: mt76: mt7996: get tx_retries and tx_failed from txfree")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index a59c14c8f..3fad977ba 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -1361,13 +1361,13 @@ mt7996_mac_tx_free(struct mt7996_dev *dev, void *data, int len)
 				cur_info++;
 			continue;
 		} else if (info & MT_TXFREE_INFO_HEADER) {
-			u32 tx_retries = 0, tx_failed = 0;
+			u32 tx_retries = 0, tx_failed = 0, count;
 
 			if (!wcid)
 				continue;
 
-			tx_retries =
-				FIELD_GET(MT_TXFREE_INFO_COUNT, info) - 1;
+			count = FIELD_GET(MT_TXFREE_INFO_COUNT, info);
+			tx_retries = count ? count - 1 : 0;
 			tx_failed = tx_retries +
 				!!FIELD_GET(MT_TXFREE_INFO_STAT, info);
 
-- 
2.45.2

