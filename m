Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84774301719
	for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2026 07:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250802; cv=none; b=OePIUdSe+lPRhbyLWQ26fQKYH0zi49se2VRb1PGdjDQAr3nNkA+XUdoLLewm1AU1aNWrL38qiNJy1zLi0mJGm+XcITuv4LXdjf/HfkLyxs/toXmG0ZuyvteT4YMhugICrD3OSSO9J5cDMFaex6AGFsYxmOj2c/qJSeiYs3e4eKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250802; c=relaxed/simple;
	bh=xD6SDfgX5BFG6Ff/k9w5u9/OKNNl4EoRCguWGOS9POk=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=knMWM0CZW1fEIxYAz1uJkArpFa0Z/VlW9JFBZgJjabioeeNX8by2wLd8PpzN2ep1Kf0cbHLRfpZXLDiYJBewD0F2BB1np2y6zeg8Zywg83nk5KyP99WZKsTIdoKGVovxZPrLcz+jR/ul7G0uwXbapfGJR7phrmXMdKGKRs94jC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=LYCam0Pk; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="LYCam0Pk"
X-UUID: c5026a46663311f18dc8c9802ae25ab1-20260612
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=NWIhTYkD9v1p6Gg3A1HPcrlQrzurfWsOAyChqS+oDik=;
	b=LYCam0PktT3R5PD8EnACMH2/S/T6XqFx5OYEYuL7EmLYXHfG4OjmXEQcbRCy5oI9BMpkNaQPDHqgGuZmJXfHuRu6bcpFbmtB0XjC9MCC4VbiMf7wz6Po9Q5vHOx/6fw3UibLm+TDQTgbEZJVfaoqY0afM4IbFQ9ag9PmY9vEnSE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:983359df-6028-4527-91b2-0332c14d48e0,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:e276073,CLOUDID:fa4cfda4-9ef7-4489-861a-e83b251ece46,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|136|836|865|888|898,TC:-5,Conten
	t:0|15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,O
	SI:0,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c5026a46663311f18dc8c9802ae25ab1-20260612
Received: from mtkmbs09n1.mediatek.inc [(172.21.101.35)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 78216048; Fri, 12 Jun 2026 15:53:15 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 12 Jun 2026 15:53:14 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 12 Jun 2026 15:53:14 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Deren.Wu@mediatek.com>, <Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>,
	<Ryder.Lee@mediatek.com>, <Leon.Yen@mediatek.com>,
	<litien.chang@mediatek.com>, <emery.hsin@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH 11/20] wifi: mt76: connac3: update basic rate table starting index
Date: Fri, 12 Jun 2026 15:53:09 +0800
Message-ID: <20260612075313.2578154-1-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
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

Change MT792x_BASIC_RATES_TBL index from 11 to 14 to match the latest
connac3 firmware rate table layout.

This is a preparation patch before enabling MT7928 PCIe support.

Signed-off-by: Emery Hsin <emery.hsin@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt792x.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt792x.h b/drivers/net/wireless/mediatek/mt76/mt792x.h
index b8dc7ce38c87..7d014de030c4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x.h
+++ b/drivers/net/wireless/mediatek/mt76/mt792x.h
@@ -33,7 +33,7 @@
 #define MT792x_CHIP_CAP_MLO_EML_EN BIT(9)
 
 /* NOTE: used to map mt76_rates. idx may change if firmware expands table */
-#define MT792x_BASIC_RATES_TBL	11
+#define MT792x_BASIC_RATES_TBL	14
 
 #define MT792x_WATCHDOG_TIME	(HZ / 4)
 
-- 
2.45.2

