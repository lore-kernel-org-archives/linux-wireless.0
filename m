Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56184C8FE6
	for <linux-wireless@vger.kernel.org>; Fri,  5 Jun 2026 11:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780659206; cv=none; b=jGrt9Y70RGsyGFQCQHyqDE+6dqNcWnzVYtNtqgQ0giXe6bPRA08EBHL+5TnJ+WEGOKfBp+Op9M2h/rrDigjLKwfiJ9VlRgUopCqL7CpOb4b71qKU8hMm4gvMdfonMzO5fDGkxBFqYQn7AbDoDnsCMXfBbOuaMmhQTz1bezYlsI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780659206; c=relaxed/simple;
	bh=T81jHuJzoMNcrQ6BipL0yZszuLKNABdlbeDA06QOqPk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PTTCi4zz2Ru1o0p41ZIGC0HS9ev+1s6AaJuEWnla7Eo6bns6etzhTmqKx8+7WdTCfPQ5TEvb2UJgcltZ1ZKS4Eo+7qLB10MUnXQ+/NGHlOCyeGCFvSfyf9rb/CyfCfxH6BgWyWkAoUUeqHsYXYTIjkRCwHQzCZOGJtzPjv3FWzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=CPZmng+r; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="CPZmng+r"
X-UUID: 591df4be60d211f18dc8c9802ae25ab1-20260605
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=AZuPNLh7boHniF51Mw9u8u+3YAMr1QxUy2t3oNZDymA=;
	b=CPZmng+rZ/e8yam7n5RDte/sM8qEjnopyggJE5fvW7KzZ1BPmzCY7vHQF7T1VSJKG9OZ29/gnb5kgnH4+SbkoHHqbfbVI06fqtPmGDfyqWuQkG3369bS/lGtkdnXPdF4fMu0++SZODoD3OkvDIjJITc+55fEn8skhY+lrEHLh6Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:6eb1fdfa-36f7-4d8e-ad99-bf2f82e7a366,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:02116820-87a8-421b-982c-f5939dba7cba,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|865|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 591df4be60d211f18dc8c9802ae25ab1-20260605
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <ryder.lee@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1780724630; Fri, 05 Jun 2026 19:33:17 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 5 Jun 2026 19:33:16 +0800
Received: from mussdccf250.eus.mediatek.inc (10.73.250.250) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 5 Jun 2026 19:33:15 +0800
From: Ryder Lee <ryder.lee@mediatek.com>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-mediatek@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Shayne Chen <shayne.chen@mediatek.com>, Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 3/4] wifi: mt76: mt7925: fix potential tx_retries underflow
Date: Fri, 5 Jun 2026 04:33:05 -0700
Message-ID: <20260605113306.3485554-3-ryder.lee@mediatek.com>
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

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index c47bd812b..c56a9e530 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1141,8 +1141,9 @@ mt7925_mac_tx_free(struct mt792x_dev *dev, void *data, int len)
 
 		if (info & MT_TXFREE_INFO_HEADER) {
 			if (wcid) {
-				wcid->stats.tx_retries +=
-					FIELD_GET(MT_TXFREE_INFO_COUNT, info) - 1;
+				u32 count = FIELD_GET(MT_TXFREE_INFO_COUNT, info);
+
+				wcid->stats.tx_retries += count ? count - 1 : 0;
 				wcid->stats.tx_failed +=
 					!!FIELD_GET(MT_TXFREE_INFO_STAT, info);
 			}
-- 
2.45.2

