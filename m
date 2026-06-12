Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F6A305684
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 07:53:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250802; cv=none; b=GTcTh/SO3AB+XZ4Qm3h80cyxe7NDZq1dGdoRAccsv/H+q9p6tsu+YsB0DPwntxaF09NB6LxZDzlKdpRO6FgkBxa8S1q8x9CIyzYzy9eusKVTxOjV2+q9DpBoCDYbahlknK6EsP4HmQz3ZYf108GviTMl+9VFX9RA+SGnurLitFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250802; c=relaxed/simple;
	bh=7ghBR7Bxj9Yv913nyaOAi1BptCsMQ/aO4yNJlvGUAto=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sqgYEO8slWmB7Xz/GZF54W9zqUjQPNsM+45vq0vRjj791D6pNA1Ob9SziSj6Kf+4DdZnV+e/Fi5feyFw2FBaQZeRl55I2mocCqrZSOTKqTiAgJrvJCA3XksxXPxL/ibhGIByjKSV7JDt63jO9kv5RnwcjxBHb6QKhWr5caeLVKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=fY/oVNpI; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="fY/oVNpI"
X-UUID: c5a2b2a8663311f1b1788b6acf885367-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=3Y4CUlwlvL4fOQJkw5ldpd7DIfcKaIFymbpJ/o7pCb0=;
	b=fY/oVNpIW9dfyp2Yr+16ezxEoPsOjYTYjpXEi6zquduZCRP76tu80r0dy8V3+bHBg/V5bz+OspsOkAvLOwGc280PECaAvp1CIrdiTrniXXQHTwPTIoRRW7woq90XiOVgNeoPxs2UQOlwBLSOWrSwFpM/TZPiAFqi/Ou/7bweBX8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:373a748e-7c2a-40dd-858a-dd246e7fea44,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:f4516397-22d1-4176-b420-d0d82ac3f01a,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:81|82|102|836|865|888|898,TC:-5,Cont
	ent:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0
	,OSI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c5a2b2a8663311f1b1788b6acf885367-20260612
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 201829315; Fri, 12 Jun 2026 15:53:17 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 15:53:15 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 15:53:15 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Deren.Wu@mediatek.com>, <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
	<litien.chang@mediatek.com>, <emery.hsin@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH 12/20] wifi: mt76: mt7925: fix MMIO dynamic remap window size
Date: Fri, 12 Jun 2026 15:53:10 +0800
Message-ID: <20260612075313.2578154-2-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260612075313.2578154-1-jb.tsai@mediatek.com>
References: <20260612075313.2578154-1-jb.tsai@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Emery Hsin <emery.hsin@mediatek.com>

Fix the 0x7c500000 remap entry window size from 0x2000000 (32MB) to
0x200000 (2MB) to match the actual addressable range.

This is a preparation patch before enabling MT7928 PCIe support.

Signed-off-by: Emery Hsin <emery.hsin@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 61349c260b12..e181cd0b6403 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -161,7 +161,7 @@ static u32 __mt7925_reg_addr(struct mt792x_dev *dev, u32 addr)
 		{ 0x7c060000, 0x0e0000, 0x0010000 }, /* CONN_INFRA, conn_host_csr_top */
 		{ 0x7c000000, 0x0f0000, 0x0010000 }, /* CONN_INFRA */
 		{ 0x70020000, 0x1f0000, 0x0010000 }, /* Reserved for CBTOP, can't switch */
-		{ 0x7c500000, 0x060000, 0x2000000 }, /* remap */
+		{ 0x7c500000, 0x060000, 0x200000 },  /* remap */
 		{ 0x0, 0x0, 0x0 } /* End */
 	};
 	int i;
-- 
2.45.2

