Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631583E3DA2
	for <linux-wireless@vger.kernel.org>; Wed,  5 Aug 2026 07:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=210.61.82.184
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785914941; cv=none; b=qgNNX46IEUU4bkXC8Di40tMY6YTadetZH6awkWwy/SV/Lu6hdK2WetHJrUmPD0A8hHxMcy2IUXSq1EEJnsBMA1GIMfig4I800dfZti9nwofByzygbq2lk+eZ0wpBDiN+tYHgLh+J9XUMiqiZpFcVhEtwGGoT9YzRSnbgyB0EYxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785914941; c=relaxed/simple;
	bh=PdwbAMhU5cAbrN1feux6XH2nH+DuY0dUVM7YGcky02M=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=c+ewVgOG8j2mOuGCF65ozbN0bPdeQe/rohNWgf7oxeW/3k0Jhej53MTNAbt2EtEwmUpW4NSuCiF4cP7tLoWXLqKSPX6lCQiKCuj/2BLFxYqcLpkg+ETGZkbDwvvVyetNVBflf2ATfk8ZHS3720Ye8xSLeNjKytGgVFf3iOEqTTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=C8Kvc85A; arc=none smtp.client-ip=210.61.82.184
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="C8Kvc85A"
X-UUID: 4c978a6e909f11f18dc8c9802ae25ab1-20260805
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=jb9IMGHKa0qKlFCrdN1lAvSnRHELMc3mbyx/KloVe8U=;
	b=C8Kvc85AVFFrcIlWmYdBXHgM7HX3Gm3SfhpdEh1maiC5sRop12T+ZC17vNTFaupE7gsWcSHbUz2T3rxqA3kK41osk6S87G3MGULJ0bgcTsH/kI8msr6OL9honDKRb2uHhz0InjaHXbb+FI4dPxKcdhjA+F7/6UFTIc+BZnNI7HE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:dff6c7e4-c6da-471d-8a43-76c8b6e97217,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:676226e2-71f1-405e-92eb-6802d6af74fd,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 4c978a6e909f11f18dc8c9802ae25ab1-20260805
Received: from mtkmbs14n1.mediatek.inc [(172.21.101.75)] by mailgw02.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1817108085; Wed, 05 Aug 2026 15:28:48 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Wed, 5 Aug 2026 15:28:47 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Wed, 5 Aug 2026 15:28:47 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>, <eason.lai@mediatek.com>
Subject: [PATCH v1] wifi: mt76: mt7925: Fix MCU command timeouts during module unload
Date: Wed, 5 Aug 2026 15:28:45 +0800
Message-ID: <20260805072846.1428148-1-eason.lai@mediatek.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Move MT76_REMOVED flag setting from mt7925_pci_remove() to after
mt76_unregister_device() completes. Setting it too early causes
mt792x_irq_handler() to drop MCU completion interrupts, timing out
teardown commands (scan abort, BSS_INFO_UPDATE, etc).

The flag must still be set before napi_disable() to prevent reset_work
from re-enabling NAPI and causing deadlock. Also guard mt792x_reset()
to skip queuing work when device is removed.

Fixes: 896f4dfd68e1 ("wifi: mt76: mt7925: Fix unregister deadlock")

Signed-off-by: Eason Lai <eason.lai@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 4 ++--
 drivers/net/wireless/mediatek/mt76/mt792x_mac.c | 3 +++
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index 02ef09dd797d..93c823eb7501 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -47,9 +47,10 @@ static void mt7925e_unregister_device(struct mt792x_dev *dev)
 	if (dev->phy.chip_cap & MT792x_CHIP_CAP_WF_RF_PIN_CTRL_EVT_EN)
 		wiphy_rfkill_stop_polling(hw->wiphy);
 
-	cancel_work_sync(&dev->reset_work);
 	cancel_work_sync(&dev->init_work);
 	mt76_unregister_device(&dev->mt76);
+	set_bit(MT76_REMOVED, &dev->mphy.state);
+	cancel_work_sync(&dev->reset_work);
 	mt76_for_each_q_rx(&dev->mt76, i)
 		napi_disable(&dev->mt76.napi[i]);
 	cancel_delayed_work_sync(&pm->ps_work);
@@ -725,7 +726,6 @@ static void mt7925_pci_remove(struct pci_dev *pdev)
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
 	struct mt792x_dev *dev = container_of(mdev, struct mt792x_dev, mt76);
 
-	set_bit(MT76_REMOVED, &mdev->phy.state);
 	mt7925e_unregister_device(dev);
 	devm_free_irq(&pdev->dev, pdev->irq, dev);
 	mt76_free_device(&dev->mt76);
diff --git a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
index 888e5a505673..1e20b333cc61 100644
--- a/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt792x_mac.c
@@ -278,6 +278,9 @@ void mt792x_reset(struct mt76_dev *mdev)
 	if (pm->suspended)
 		return;
 
+	if (test_bit(MT76_REMOVED, &mdev->phy.state))
+		return;
+
 	queue_work(dev->mt76.wq, &dev->reset_work);
 }
 EXPORT_SYMBOL_GPL(mt792x_reset);
-- 
2.45.2

