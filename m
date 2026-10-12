Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68BD46FC5
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 03:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791775643; cv=none; b=DPMCo1VqkQxcBF7bJqGANH7He/Yo4poCwns69H96G4FZQuTuFubpveN+H1GXVRO8S7cd18cHFgwV46ozsSbBZPrCbIDcVpsAnr1qeX92FU0WJ4pFSqBQ8pU+3OSHuJNOqFhjm02roFOgvxEA/OtJEZ/5kJqT7mqzLuXPr6gqk1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791775643; c=relaxed/simple;
	bh=9EclqgrIkMiwsM7r/7S06rTmZfXYc17dcSxsN3kX3cw=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rODWXv+b9lMiVSycnqlHpH5qYj3ekPSSB44FxaFpyMkJ3KxQrtM+YEwh858YEuWC6ZhpFR938/t8xlAcp7C5bZa/4ROyvv8zMs0d6OIYWhPvR9NdUJKM02ioB3LruOxEvtlM/ncd/dAt2CDbMVPLy/LvvD9QBFo++aawnB4orOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=GHN1hE4e; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="GHN1hE4e"
X-UUID: c9139678c5ec11f1b1788b6acf885367-20261012
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=j+X2bbuAWMu4UtRzKtDwm0weo+RhlVdQme8SbcEpY1s=;
	b=GHN1hE4eUr829EsJXKTJwDQ6oDJHlfhZyJ0Yh+4lqxvY0/S1taNo4FSGd5AonMYj1mNMCEGCfDrp6Hw/t/k/t9fjCuL3uZ2iv1I67PqM5uq7eRQLqfbtTZw7BfywhfYCQSkRwbjVekfEIwX0daZNrch6JFcMCGah0E8dlt6AGRo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:a3d3c247-b39f-4b98-9f2e-3eb18befd287,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:291e20b,CLOUDID:03cefab8-514b-419b-be8a-53f1868a3ee6,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: c9139678c5ec11f1b1788b6acf885367-20261012
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1257488006; Mon, 12 Oct 2026 11:27:00 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 MTKMBS14N1.mediatek.inc (172.21.101.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 12 Oct 2026 11:26:58 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 12 Oct 2026 11:26:58 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <jeff.hsu@mediatek.com>,
	<eason.lai@mediatek.com>, Jeff Hsu <Jeff.Hsu@mediatek.com>
Subject: [PATCH] SER: mt7925: race condition in mt7925e_mac_reset allows compromised WiFi firmware to trigger host sk_buff use-after-free
Date: Mon, 12 Oct 2026 11:26:57 +0800
Message-ID: <20261012032657.58631-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

From: Jeff Hsu <Jeff.Hsu@mediatek.com>

Fix racing condition in reset handler result sk_buff use-after-free

Signed-off-by: Jeff Hsu <Jeff.Hsu@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index c3db814b2788..555eeb74d023 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -73,9 +73,11 @@ void mt7925_tx_token_put(struct mt792x_dev *dev)
 int mt7925e_mac_reset(struct mt792x_dev *dev)
 {
 	const struct mt792x_irq_map *irq_map = dev->irq_map;
+	struct mt76_phy *mphy = &dev->mt76.phy;
 	int i, err;
 
-	mt792xe_mcu_drv_pmctrl(dev);
+	__mt792xe_mcu_drv_pmctrl(dev);
+	clear_bit(MT76_STATE_PM, &mphy->state);
 
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
-- 
2.45.2

