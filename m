Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD3A43E5EF3
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2026 09:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=60.244.123.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782810393; cv=none; b=L3cf90kIXu/KjnbTdRA2WmmWpREk97NRhAGL9pchpUNnHSYqKsMjyoCWFydsKwvozwmNu60FbUlBG6mFgv2QHzyJQ+DddJWIy0zhNXffZIRu8GGqA5F+Jt6GUiVsqS2lQITBT5UBZ/xWFpoftMsvNfd6Z4JruNfkMySpywY+0MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782810393; c=relaxed/simple;
	bh=a0ErbBtE8IxB8j4vZOvMTf8AikU7gy1ZGQOsVUCnm8c=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=JuRTDpevkobKdCWNK3biRTFaFu7hANMKc4WS6HY5yC2CXil3s/fItpWvg1uir7gZ//y1T8oStrTaw+89Smuf0E46yFk3kd6DCV5VkfrWmkDuLNAQlh6LuSlaYs35qw3LcWsPcqCBWwxLJAy5R3giEX7HuCyoMlqlYWBsB9tuu8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com; spf=pass smtp.mailfrom=mediatek.com; dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b=izJw3li/; arc=none smtp.client-ip=60.244.123.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mediatek.com header.i=@mediatek.com header.b="izJw3li/"
X-UUID: f1847a04746211f1b1788b6acf885367-20260630
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:Message-ID:Date:Subject:CC:To:From; bh=0dnQUkhF2LjQWBb+flN8YyRx63my+YdvbjN3wxg/4n8=;
	b=izJw3li/e8gMiv1ecTchohZZfDpwVk3vcrDzPynKwkMFXxB4UX3dG33KK8GxlA5vqSrFTOSFtYs0lCBF9bTMXGnFRrhO9brBKbZrcl5GrmX+DgHr+XzPH+QrWWZ3ODEOZt8Xm7Sjv1n8wo71nLPKe4ECjDwiScJND4g9bZ/qLxo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.17,REQID:13b92285-4a2b-4399-9f4b-4588b216999b,IP:0,U
	RL:0,TC:0,Content:-5,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION
	:release,TS:-5
X-CID-META: VersionHash:d497b38,CLOUDID:3b911f04-3795-4a90-800e-68e9393a343e,B
	ulkID:nil,BulkQuantity:0,SF:102|836|865|888|898,TC:-5,Content:0|15|50|99,E
	DM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:-1,COL:0,OSI:0,OSA:0,
	AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: f1847a04746211f1b1788b6acf885367-20260630
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 835295397; Tue, 30 Jun 2026 17:06:13 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 30 Jun 2026 17:06:12 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 30 Jun 2026 17:06:12 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Quan.Zhou@mediatek.com>, <Ryder.Lee@mediatek.com>,
	<Leon.Yen@mediatek.com>, <litien.chang@mediatek.com>, <jb.tsai@mediatek.com>,
	Fei Shao <fshao@google.com>
Subject: [PATCH] wifi: mt76: mt7925: Fix unregister deadlock
Date: Tue, 30 Jun 2026 17:06:10 +0800
Message-ID: <20260630090610.586954-1-jb.tsai@mediatek.com>
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

During device shutdown or removal, a deadlock can occur between the
PCIe remove path and the driver's asynchronous reset work.

The unregistration path calls napi_disable() before cancelling the
reset work. If the reset work runs concurrently, it may re-enable NAPI
and schedule it. Because the device is being unregistered, this can
lead to NAPI state corruption where NAPI is marked as scheduled but
never polled, causing subsequent napi_disable() calls to hang forever.

Fix this by:
1. Moving cancel_work_sync(&dev->reset_work) to the very start of
   mt7925e_unregister_device(), ensuring it is stopped before NAPI
   is disabled.
2. Setting the MT76_REMOVED flag early in the PCI remove path to
   prevent new reset work from being queued.
3. Checking MT76_REMOVED in mt7925_mac_reset_work() and aborting the
   reset early if the device is being removed.

Co-developed-by: Fei Shao <fshao@google.com>
Signed-off-by: JB Tsai <jb.tsai@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mac.c | 7 +++++++
 drivers/net/wireless/mediatek/mt76/mt7925/pci.c | 4 ++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
index 0641a7131d7c..1c6d43b162c0 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mac.c
@@ -1319,6 +1319,9 @@ void mt7925_mac_reset_work(struct work_struct *work)
 	cancel_work_sync(&pm->wake_work);
 
 	for (i = 0; i < 10; i++) {
+		if (test_bit(MT76_REMOVED, &dev->mt76.phy.state))
+			goto out;
+
 		mutex_lock(&dev->mt76.mutex);
 		ret = mt792x_dev_reset(dev);
 		mutex_unlock(&dev->mt76.mutex);
@@ -1338,8 +1341,12 @@ void mt7925_mac_reset_work(struct work_struct *work)
 		ieee80211_scan_completed(dev->mphy.hw, &info);
 	}
 
+out:
 	dev->hw_full_reset = false;
 	pm->suspended = false;
+	if (test_bit(MT76_REMOVED, &dev->mt76.phy.state))
+		return;
+
 	ieee80211_wake_queues(hw);
 	ieee80211_iterate_active_interfaces(hw,
 					    IEEE80211_IFACE_ITER_RESUME_ALL,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
index ea64303283ed..978a3f08e080 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/pci.c
@@ -43,13 +43,13 @@ static void mt7925e_unregister_device(struct mt792x_dev *dev)
 	if (dev->phy.chip_cap & MT792x_CHIP_CAP_WF_RF_PIN_CTRL_EVT_EN)
 		wiphy_rfkill_stop_polling(hw->wiphy);
 
+	cancel_work_sync(&dev->reset_work);
 	cancel_work_sync(&dev->init_work);
 	mt76_unregister_device(&dev->mt76);
 	mt76_for_each_q_rx(&dev->mt76, i)
 		napi_disable(&dev->mt76.napi[i]);
 	cancel_delayed_work_sync(&pm->ps_work);
 	cancel_work_sync(&pm->wake_work);
-	cancel_work_sync(&dev->reset_work);
 
 	mt7925_tx_token_put(dev);
 	__mt792x_mcu_drv_pmctrl(dev);
@@ -498,8 +498,8 @@ static void mt7925_pci_remove(struct pci_dev *pdev)
 	struct mt76_dev *mdev = pci_get_drvdata(pdev);
 	struct mt792x_dev *dev = container_of(mdev, struct mt792x_dev, mt76);
 
-	mt7925e_unregister_device(dev);
 	set_bit(MT76_REMOVED, &mdev->phy.state);
+	mt7925e_unregister_device(dev);
 	devm_free_irq(&pdev->dev, pdev->irq, dev);
 	mt76_free_device(&dev->mt76);
 	pci_free_irq_vectors(pdev);
-- 
2.45.2

