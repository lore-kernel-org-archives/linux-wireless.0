Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8BD72236EE
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 02:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791943309; cv=none; b=aToQumv1ywXXk9F55PvbzEF0CG72N4sDCadmBn6yxspfHJSy8senNC2HN0ecK2xBXptssluzE5VKQvbIJcdzotj7O40EDNfQhmtxag1YQdMWCezcZ21o7DuFErsk1es/NMZTtQQ+0DYJWve5Re1QXAhNPLn5s7lMsenunmNG4tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791943309; c=relaxed/simple;
	bh=WvuhMc4oDdugnzqedcrCaNZJabxn4OyUbRFAlnPbzIA=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M8orc/e+ctkwN65hs2ejOcUIDyE9wBaKl9KXedC1U55WIK8YOwjWKHGAmLqcdpqTchp7ZpRvNiPBlyTw3FIfRkauGUuZxN6ibi1qtaZdf79TG3UFfCfSngS9w9Xho/25BrdzmQksg7M/QrqmzCAnVTjwTCeOuuLED20OSgbUrnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=F4TqMNep; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="F4TqMNep"
X-UUID: 2df87f0ec77311f18dc8c9802ae25ab1-20261014
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=xsWq3B7X6MwHQZxXhBaU76isq8mGeDvZAcrXA73QRjg=;
	b=F4TqMNepmy7tE8EGYNcvLm+G7n2PbDPX25+LCsfPXMwUj4t19pVgZ4jMW1dZIEiyFAC0jxCVeqViACrzQmp9vtvbEH/Kqz4rKtX1ECsE0H5N/BbK3iJb0ghvulJCAc61l0UNvSiDkb/isOJaN7K86sbcKjxdgajbIN8Is8LqKS4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.20,REQID:0391a067-20e0-49e1-bad2-c72b9660d0f6,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:291e20b,CLOUDID:0da14eef-fea3-4d35-93bd-64582bb655a8,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,
	OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 2df87f0ec77311f18dc8c9802ae25ab1-20261014
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1745122794; Wed, 14 Oct 2026 10:01:33 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 14 Oct 2026 10:01:32 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 14 Oct 2026 10:01:32 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <jeff.hsu@mediatek.com>,
	<eason.lai@mediatek.com>, Jeff Hsu <Jeff.Hsu@mediatek.com>
Subject: [PATCH v2] wifi: mt76: mt7925: race condition in mt7925e_mac_reset allows compromised WiFi firmware to trigger host sk_buff use-after-free
Date: Wed, 14 Oct 2026 10:01:26 +0800
Message-ID: <20261014020126.1479508-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20261012032657.58631-1-eason.lai@mediatek.com>
References: <20261012032657.58631-1-eason.lai@mediatek.com>
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
v2: Rebase the code, due to code conflict with previous change in d12a54be2604
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
index 18f125bf3df4..bc8f741e9426 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci_mac.c
@@ -71,12 +71,15 @@ void mt7925_tx_token_put(struct mt792x_dev *dev)
 int mt7925e_mac_reset(struct mt792x_dev *dev)
 {
 	const struct mt792x_irq_map *irq_map = dev->irq_map;
+	struct mt76_phy *mphy = &dev->mt76.phy;
 	int i, err;
 
-	err = mt792xe_mcu_drv_pmctrl(dev);
+	err = __mt792xe_mcu_drv_pmctrl(dev);
 	if (err)
 		return err;
 
+	clear_bit(MT76_STATE_PM, &mphy->state);
+
 	mt76_connac_free_pending_tx_skbs(&dev->pm, NULL);
 
 	mt76_wr(dev, dev->irq_map->host_irq_enable, 0);
-- 
2.45.2

