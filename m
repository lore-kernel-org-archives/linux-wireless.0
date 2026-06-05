Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD49370D7B
	for <linux-wireless@vger.kernel.org>; Fri,  5 Jun 2026 11:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780659203; cv=none; b=ObtxtzoSVFxEIpGpXrzVqYAtI4sx/mbq5tYTK24hGpNLETAht3UHHjmeKbPrmx16xUFMUP6A6LRcsnOaSC7fYo21qaqfWtWekaIcdpbZaMbkDrvkQJvRE9NWlUh/pHj+PWQQyMajzt4xD9sgijpMYCwce9vQLx+9mc6BD6QOG8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780659203; c=relaxed/simple;
	bh=Ca6SeSrIkOK248ci5zAUD8/nfsVQ71O3nCGWK2lJM8w=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Zj4WQbacW4W2AUjSBwiavjVM2UwgkqAh8jRyO3qTwZuZf06VXdMfHXIMH5az33NVE5dgT0buAY5rpsPKelJeBmz6zRHVoejmBkhEo9QZ+7prCELLoEG9x0mfCPFk8pbkJU81n4l1UrOvkiuHXUlpjbHyOXhnV1YD5fv7W2uDs7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ejg5jsJs; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ejg5jsJs"
X-UUID: 55bbddc260d211f1b1788b6acf885367-20260605
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=PAxJwUqHC+sJ1RxYzu8X7M7iz9HDPm2JEn9tEGPQd7k=;
	b=ejg5jsJsY37qzIkU9c9I+IED+aRcmLps/OTlRxIC1a9lsrdlfAUDOPMhnF919z4ntnFkWYOWm1pTotV18FAkTgnJOsjO4lY3PMZjIToHwdGj6U9QmzHJ+G8ZMtvIrhohGXxClfrXJcp4fLgfACXooXhGo/Y2xe3GAuh8gLqcsMk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.15,REQID:b0567cb0-b9a6-4112-8722-8ecee793002e,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:e276073,CLOUDID:cf106820-87a8-421b-982c-f5939dba7cba,B
	ulkID:nil,BulkQuantity:0,Recheck:0,SF:102|836|865|888|898,TC:-5,Content:0|
	15|50,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 55bbddc260d211f1b1788b6acf885367-20260605
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <ryder.lee@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 978662730; Fri, 05 Jun 2026 19:33:12 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 5 Jun 2026 19:33:10 +0800
Received: from mussdccf250.eus.mediatek.inc (10.73.250.250) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 5 Jun 2026 19:33:10 +0800
From: Ryder Lee <ryder.lee@mediatek.com>
To: Felix Fietkau <nbd@nbd.name>
CC: <linux-mediatek@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	Shayne Chen <shayne.chen@mediatek.com>, Ryder Lee <ryder.lee@mediatek.com>
Subject: [PATCH 1/4] wifi: mt76: mt7915: fix potential tx_retries underflow
Date: Fri, 5 Jun 2026 04:33:03 -0700
Message-ID: <20260605113306.3485554-1-ryder.lee@mediatek.com>
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

When FIELD_GET returns 0 for the retry count, subtracting 1 causes
an unsigned integer underflow, resulting in tx_retries becoming a
very large value (0xFFFFFFFF for u32).

Fix by checking if count is non-zero before subtracting 1.

Fixes: 943e4fb96e6f ("wifi: mt76: mt7915: report tx retries/failed counts for non-WED path")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
index cec2c4208..334c19ab2 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mac.c
@@ -912,16 +912,16 @@ mt7915_mac_tx_free(struct mt7915_dev *dev, void *data, int len)
 		}
 
 		if (!mtk_wed_device_active(&mdev->mmio.wed) && wcid) {
-			u32 tx_retries = 0, tx_failed = 0;
+			u32 tx_retries = 0, tx_failed = 0, count;
 
 			if (v3 && (info & MT_TX_FREE_MPDU_HEADER_V3)) {
-				tx_retries =
-					FIELD_GET(MT_TX_FREE_COUNT_V3, info) - 1;
+				count = FIELD_GET(MT_TX_FREE_COUNT_V3, info);
+				tx_retries = count ? count - 1 : 0;
 				tx_failed = tx_retries +
 					!!FIELD_GET(MT_TX_FREE_STAT_V3, info);
 			} else if (!v3 && (info & MT_TX_FREE_MPDU_HEADER)) {
-				tx_retries =
-					FIELD_GET(MT_TX_FREE_COUNT, info) - 1;
+				count = FIELD_GET(MT_TX_FREE_COUNT, info);
+				tx_retries = count ? count - 1 : 0;
 				tx_failed = tx_retries +
 					!!FIELD_GET(MT_TX_FREE_STAT, info);
 			}
-- 
2.45.2

