Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7152E738F
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 02:16:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785896182; cv=none; b=Bp1SXsWwMvk8qQEoeZMDHCZMOpsjtqU/5qVVpdyC4GEeKOynkK83KFR+m5ZmwmPN5THe9yTaufDse8FjGa7AwH/DxZIAZARW/c/KrGFMhjszjiWGj70cFcUft67t8TvWRR27MgSuW8+JVXwM+pxT7JwRecE0c+Oc6tULkOOFSSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785896182; c=relaxed/simple;
	bh=a8ORZ6USVLUlntNA5qrQkprKYEwCZsejhz5+nLQ8nJA=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=R2Juh7hn7o7pNfe9tQFGrvt3aP2bhRyuZNlq4kmClSFceEVaMwa/ozQiW9PzkEF6Q0yjsbrPmYoqZlbYvI+lv84JZ2moeztqMNUbiXk8zXM1a1tBDTUc+UcyWhPPN3AQMVa/6oXWhb1P30pFHX6mZqN5vOqaAv/oVupIziwGCOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=SGxB3Adj; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="SGxB3Adj"
X-UUID: 9f53675e907311f1b1788b6acf885367-20260805
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=YY1AYiBRL8HDgw6XZy/C5mmkSBsBiFuSegMY6LTHl6g=;
	b=SGxB3AdjBHdbQ1QrAEh0SYfJQRyWRVza19ScoGN14vWQFfHx9yIPQvWYcRULXvgb1nagzPH4k1wlCm43HVd0XKKEcAC4hZXG020e23nG431fVlIytvVMj7D9Y7y8Wpf5gbBx3Szjnb9vl+0HZUOTQOd7zUdcivk8oq90KxP8aEA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:358a6402-68f4-4c6c-8a2a-410baed056f4,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:be0cc3d7-e107-40d7-b872-324d3a651dba,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 9f53675e907311f1b1788b6acf885367-20260805
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 2020516778; Wed, 05 Aug 2026 10:16:09 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 5 Aug 2026 10:16:08 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 5 Aug 2026 10:16:08 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <vick.cheng@mediatek.com>,
	<jb.tsai@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7925: fix REG_ACCESS command size for register type
Date: Wed, 5 Aug 2026 10:16:06 +0800
Message-ID: <20260805021606.1253882-1-jb.tsai@mediatek.com>
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

From: Vick Cheng <vick.cheng@mediatek.com>

mt7925_mcu_regval() always sent sizeof(req) - the full union - regardless of which member (basic reg or RF reg) was active. The two members differ in size, so the firmware received trailing zero bytes which it parsed as extra TLV entries, causing a dead loop.

Pass the size of the active member instead of the union size.

Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Vick Cheng <vick.cheng@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 5532e1722d17..64bba015f5f8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -90,6 +90,7 @@ int mt7925_mcu_regval(struct mt792x_dev *dev, u32 regidx, u32 *val, bool set)
 		};
 	} __packed * res, req;
 	struct sk_buff *skb;
+	int cmd_len;
 	int ret;
 
 	if (u32_get_bits(regidx, MT_RF_REG_HDR) == RF_REG_PREFIX) {
@@ -98,20 +99,22 @@ int mt7925_mcu_regval(struct mt792x_dev *dev, u32 regidx, u32 *val, bool set)
 		req.rf_reg.ant = cpu_to_le16(u32_get_bits(regidx, MT_RF_REG_ANT));
 		req.rf_reg.idx = cpu_to_le32(regidx);
 		req.rf_reg.data = set ? cpu_to_le32(*val) : 0;
+		cmd_len = sizeof(req.__rsv) + sizeof(req.rf_reg);
 	} else {
 		req.reg.tag = cpu_to_le16(UNI_CMD_ACCESS_REG_BASIC);
 		req.reg.len = cpu_to_le16(sizeof(req.reg));
 		req.reg.idx = cpu_to_le32(regidx);
 		req.reg.data = set ? cpu_to_le32(*val) : 0;
+		cmd_len = sizeof(req.__rsv) + sizeof(req.reg);
 	}
 
 	if (set)
 		return mt76_mcu_send_msg(&dev->mt76, MCU_WM_UNI_CMD(REG_ACCESS),
-					 &req, sizeof(req), true);
+					 &req, cmd_len, true);
 
 	ret = mt76_mcu_send_and_get_msg(&dev->mt76,
 					MCU_WM_UNI_CMD_QUERY(REG_ACCESS),
-					&req, sizeof(req), true, &skb);
+					&req, cmd_len, true, &skb);
 	if (ret)
 		return ret;
 
-- 
2.45.2

