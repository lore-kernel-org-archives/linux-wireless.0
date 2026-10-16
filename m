Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 839E53A16B2
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 06:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792132644; cv=none; b=EpR4afnH/ExihMq6iCLilbbAaoH4M4+2CtZI6UqZ8gFWuCuT0nZYru8jhic/XhS0aZDB3+e7G7kuZuvLlcgK1uoIhCFq0dRw92tcEgecPNmQFGa1VonEfRIVKcxIBtHF39HzINLo0mf+I2xXK2zodSLYqCNFBcENS+b8co51/cU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792132644; c=relaxed/simple;
	bh=he7Ob0yldHHB5tgKeYvRmK1xaRkN0NUmpN4xTog9gZM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=HeoflVV/evoHBQZr6edXcHBKQfVUcOP+vUhvr/mgAGJ0Zi2zZ2FhyCXCxAXYZQJqD4zq5pq1Bj7/fLPnRtnIMPFdM/SX0zLTXmBLC0B+3k0PJ/bEiKo9TGWNpHif+EQtB/IQQ7wGfkinTeDN6q7lDCnm7naHseRkr2h2dHrOoOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=ohGd6icl; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="ohGd6icl"
X-UUID: e9a7469cc92911f1b1788b6acf885367-20261016
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=xFMag8xVDPiZFWvybg4JyD4iFYZjQt69JfgVeLcuZPo=;
	b=ohGd6icljzZ7b7KEX/sRbBaXG7JS6iu2ECYF1B5m1QMNYyGwWsSWgQfXuzp8TxJLTYiJga+lklEOtXA6nbD21GhO8ZVe+gYyvlVOmZjDjDY9mfy7ljIEZa4JUDgDBqYK8S6lYhv6sO3r4p9LntdQAxvhbun41JaQ0KKdRLDaIqQ=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:d0ee906b-d7a4-4c6b-a571-04e2532d5616,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:291e20b,CLOUDID:2468dceb-1c79-41b3-9b50-0f1de15434fd,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: e9a7469cc92911f1b1788b6acf885367-20261016
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 189902503; Fri, 16 Oct 2026 14:22:07 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS09N2.mediatek.inc (172.21.101.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Fri, 16 Oct 2026 14:22:06 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Fri, 16 Oct 2026 14:22:06 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<litien.chang@mediatek.com>, <Yung-lun.Chien@mediatek.com>,
	<jb.tsai@mediatek.com>, allen.chien <yung-lun.chien@mediatek.com>
Subject: [PATCH] wifi: mt76: mt7925: skip WoW START when unassociated
Date: Fri, 16 Oct 2026 14:22:03 +0800
Message-ID: <20261016062203.2452822-1-jb.tsai@mediatek.com>
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

From: "allen.chien" <yung-lun.chien@mediatek.com>

Modify the suspend condition when not connected, to resolve the issue
of Wi-Fi failing to enter low power mode.

Signed-off-by: allen.chien <yung-lun.chien@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
index 26cdb3f0a98a..924b650fcb2b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -305,6 +305,15 @@ void mt7925_mcu_set_suspend_iter(void *priv, u8 *mac,
 	for (i = 0; i < wowlan->n_patterns; i++)
 		mt7925_mcu_set_wow_pattern(phy->dev, vif, i, suspend,
 					   &wowlan->patterns[i]);
+	/*
+	 * An unassociated STA has no link to sleep from or wake to, so
+	 * skip the WoW ctrl for it on both suspend and resume, unless a
+	 * Net Detect schedule is configured (ND needs WoW to keep
+	 * scanning while disconnected).
+	 */
+	if (vif->type == NL80211_IFTYPE_STATION &&
+	    !vif->cfg.assoc && !wowlan->nd_config)
+		return;
 	mt7925_connac_mcu_set_wow_ctrl(phy, vif, suspend, wowlan);
 }
 
-- 
2.45.2

