Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF38230594F
	for <linux-wireless@vger.kernel.org>; Fri, 21 Aug 2026 01:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787275932; cv=none; b=XDZw1lMYBoRuKCde+IzWWSJ9CyeazqHvsgBkZQKfaNzADOiRKCljY+Oy1Yq2GdwUvLQFWvULa48zbmHt0+Og8zg1Pw6MN2lxM2B5U0/BbRGaCqNWlohghhKo+P4Zxt35OxDlvXNlXhwKS0grbRkBLwVoZ9rvuaXBcg2r/WsPNiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787275932; c=relaxed/simple;
	bh=1XUJn31tbChfNVBeTZRWFNloZqGc1lr8f2eYrdD61l8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DVuOjJEr+WsoW1112/FESeHda2tPowROJDZOH7vvP0nZLRRPMX0p9K+848eybqRNpxN8dovFGu5CvMh3sMM5nGn+gyp14/oN9eGqIZouvgC35aW9C2B7bqfv1uu2PZ7pzkhuydxXThmX/L3mBFDNNLyLlKsqiXo9jRuP/zrrW4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=J3Cs6BxE; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="J3Cs6BxE"
X-UUID: 1cabdca29d0011f18dc8c9802ae25ab1-20260821
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=354JcDU9Jelb8ADCx+z6e/idANWaE/u2ne5K9BaSXcg=;
	b=J3Cs6BxEF+nwBE3u/JAxWJcENA0YQNNKZCXkPabcN46vtOuld/Wq0aGMY2Wi69JgkClS/2d95/T56JzmP8BxUi78F+cRa5m2mDOZ8my63vSQ9BbXDXJMVDTKcqjqEc1gOiJw1JKPbOZ+SaKFmABwzlLM5NGkEo6jBb5euAKfg5s=;
X-CID-CACHE: Type:Local,Time:202608210932+08,HitQuantity:1
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:abaf7ccc-2295-4a00-ae1b-2bbbfb7d18d5,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:7db8b62,CLOUDID:7b75495e-4843-4d87-9105-fd688b4769cd,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 1cabdca29d0011f18dc8c9802ae25ab1-20260821
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
	(envelope-from <anthony.liu@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 923014195; Fri, 21 Aug 2026 09:32:03 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 21 Aug 2026 09:32:01 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 21 Aug 2026 09:32:02 +0800
From: Anthony Liu <anthony.liu@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <Sean.Wang@mediatek.com>, <Leon.Yen@mediatek.com>,
	<Quan.Zhou@mediatek.com>, <Ryder.lee@mediatek.com>,
	<litien.chang@mediatek.com>, <kun.wu@mediatek.com>, <jb.tsai@mediatek.com>,
	<emery.hsin@mediatek.com>, <linux-wireless@vger.kernel.org>,
	<linux-mediatek@lists.infradead.org>, Anthony Liu <anthony.liu@mediatek.com>
Subject: [PATCH v3] [PATCH 03/05] wifi: mt76: add ACPI MTFG option for bus configuration
Date: Fri, 21 Aug 2026 09:31:57 +0800
Message-ID: <20260821013159.2263479-3-anthony.liu@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20260821013159.2263479-1-anthony.liu@mediatek.com>
References: <20260821013159.2263479-1-anthony.liu@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

Extend ACPI MTFG table parsing to support an additional MTFG bus
configuration option.

Signed-off-by: Anthony Liu <anthony.liu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
index 946dd7956e4a..227a6960f135 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_acpi_sar.c
@@ -355,6 +355,7 @@ u8 mt792x_acpi_get_flags(struct mt792x_phy *phy)
 	} map[] = {
 		{ 1, 1 },
 		{ 4, 2 },
+		{ 13, 3 },
 	};
 	u8 flags = BIT(0);
 	int i, j;
-- 
2.45.2

