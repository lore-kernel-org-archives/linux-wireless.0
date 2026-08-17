Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E16E331EB0
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 05:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786944295; cv=none; b=glaYoQMGUGZKW+jYITXLWXEwgZ9cl5J7bTzLDlkMUWpALXXeCH+49WnI2vvv/VG7mbLA+Nldyeu2e8wt4kQck5fXI4N7Um3Y2Ot+asEWiAp5TpiGFW+cYPK8vpLBiGJHPRTaUkaFduUbGUh+rqsJM96zefsiwXoi9JhU/VEONoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786944295; c=relaxed/simple;
	bh=mV+vDVO9lyFwg2NbGjsnX9+gvUOaW+x1/WV/CqoTJrM=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BZ2edaQbrlUmcQptm2Xz5suegYLEwAKvT/la3ALs4E1r/H7k1i386wGvkHcD6nBGszyk+nufwz4aAQLas/Z2PtAlJc6atFJKomM+riCb5OZsIfKlpi5BSc6uLDGSnXVHtLJ5f2F4mUdNXO8GIXGgfmSiSYRvcr5tt0cxFROoRDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=Gi91jdrY; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="Gi91jdrY"
X-UUID: f51a5b3499fb11f1b1788b6acf885367-20260817
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=+9BEdN+oKon82OOvmxvzkddGKzqq/p8uVD8l9wP6g04=;
	b=Gi91jdrYaKYtMyz6gtavKwOV1agQVdAufZfaEe5brs9ED1P+uAX9n4oubMRZO+U/Tkh9ffWwIefcobPn8CrhrHILV28p4Yzns/6dbi1pAGX9QzU4PxPw13pk0D05vuQo8zPWvvC2htyW12UmDekS5T6ETcJvDrKBKKFYdzvIlwo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.19,REQID:86478e9d-e03f-49b4-bf1c-ac9ae270c506,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:7db8b62,CLOUDID:1c8c8ce2-71f1-405e-92eb-6802d6af74fd,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f51a5b3499fb11f1b1788b6acf885367-20260817
Received: from mtkmbs09n2.mediatek.inc [(172.21.101.94)] by mailgw01.mediatek.com
	(envelope-from <eason.lai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 1976534886; Mon, 17 Aug 2026 13:24:45 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Mon, 17 Aug 2026 13:24:44 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Mon, 17 Aug 2026 13:24:44 +0800
From: Eason Lai <eason.lai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<kun.wu@mediatek.com>, <deren.wu@mediatek.com>, <sean.wang@mediatek.com>,
	<quan.zhou@mediatek.com>, <ryder.lee@mediatek.com>, <leon.yen@mediatek.com>,
	<litien.chang@mediatek.com>, <jb.tsai@mediatek.com>,
	<eason.lai@mediatek.com>, Devin Wittmayer <lucid_duck@justthetip.ca>
Subject: [PATCH v2] wifi: mt76: mt7925: Fix MCU command timeouts during module unload
Date: Mon, 17 Aug 2026 13:24:42 +0800
Message-ID: <20260817052442.98447-1-eason.lai@mediatek.com>
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

With nothing associated it still costs 9 to 10 seconds, so a bare rmmod
does reach this, just small enough there to read as normal teardown.

Fixes: 896f4dfd68e1 ("wifi: mt76: mt7925: Fix unregister deadlock")

Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
Signed-off-by: Eason Lai <eason.lai@mediatek.com>
---
v2: Update correct SHA in "Fixes" tag; reword commit message as
    suggested by Devin Wittmayer.
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

