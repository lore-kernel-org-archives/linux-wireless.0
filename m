Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=210.61.82.184
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793697019;
	b=Y5hjoB3woFnj6eM8yQJuR78WhJX8bAWP2wxL0g8mthYB4tuw8WwH8qSywpS96A8xO/Qd
	 nO1LvOYCxK7nePkcP+iVf76Be0kDFK8Sd8rZONyt2JdW0ucfqpI3UTp6/TFkCcAXl8Zx0
	 saSAuqGdDm2DzZkHEuVv4ItF4/657migtl+Hv0Q7P2oK8etLVPBpxaie3b8jiMtRXoJzh
	 cvjJEzpJ7Y6tviJp/djsaRvv4ok8GeY8cp1dGcjRYBzL95Lwnjc2D8KSeEteNS4IpDJan
	 9qPgQ8CSbuHBrj2jnUoJzlDn2AWiDY4sd3bQZJdw1khmReQNuBGbvp0aBc1vtcBVkPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793697019;
	h=DMARC-Filter:X-UUID:DKIM-Signature:X-CID-P-RULE:X-CID-O-INFO:
	 X-CID-META:X-CID-BVR:X-CID-BAS:X-CID-FACTOR:X-CID-RHF:X-UUID:Received:
	 Received:Received:From:To:CC:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding:
	 Content-Type:X-MTK;
	bh=9RUD3YTp/YFI0eAJDh82LtyEu5ClHunuCI2K3Mb96U8=;
	b=Y64SN4qyDg3Rck32c6ueV3hGL68uwI0zRV0uWRntg4829s7kqbpIrAKTxGn1e44RSkbb
	 Z87VRyWEvT3paaKu2MSSqH0RHeUiJ0RWbOYkvLQ0PU4JTbbtxVeUY+DaTU64oR3uF281Z
	 llXmJxpmsdggVR2fwiIJAjM9p2xXVQ5Ta1ARzNcHc1LcechMm2KAoSZbrLWPRGeHrSu/Y
	 OHJp/agyECAS9hjD34aWuSGdW29Z7l3RXw1wC3wGLbIdMyE1A/0cJ9w7t/fIDQ05zgyE4
	 97OPOSWwSMwToaX8IC4qBFZiltzLKPIRL6mBCGIRDDkkCOM6j2DWuFaOkrn2Bu6KEcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=mediatek.com;
	spf=pass smtp.mailfrom=mediatek.com;
	dkim=pass header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=fsxgm3fE;
	arc=none smtp.remote-ip=210.61.82.184
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB01606A32D
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 09:10:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BAB01606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=mediatek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mediatek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=mediatek.com header.i=@mediatek.com header.a=rsa-sha256 header.s=dk header.b=fsxgm3fE
X-UUID: 60def274d76611f18dc8c9802ae25ab1-20261103
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
	h=Content-Type:Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:CC:To:From; bh=9RUD3YTp/YFI0eAJDh82LtyEu5ClHunuCI2K3Mb96U8=;
	b=fsxgm3fE4gIHsHXfbmPa3I1vRTrmf0gFd3aE4jJ2Ku3eTigWf2GdT9LFCzBzlbwuLmVxJlM7BCbv5HjZQUaeXp6JjotBZfZVC5zsmEtXiA2adMLLri1ZzICnKjBpPJyUJiiYPwkWGabp4LraBTu9/lCz9sfyJfQyI2hcKdoG3f8=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.3.21,REQID:44022344-69eb-4e8a-b7ee-e33498ee748a,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:b0318ac,CLOUDID:1fc5942a-563f-4f7d-9dd8-7157f9c85e30,B
	ulkID:nil,BulkQuantity:0,SF:81|82|102|836|865|888|898,TC:-5,Content:0|15|5
	0|99,EDM:-3,IP:nil,URL:0,File:130,RT:0,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0
	,OSA:0,AV:0,LES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 2,SSN|SDN
X-CID-BAS: 2,SSN|SDN,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-CID-RHF: D41D8CD98F00B204E9800998ECF8427E
X-UUID: 60def274d76611f18dc8c9802ae25ab1-20261103
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
	(envelope-from <jb.tsai@mediatek.com>)
	(Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
	with ESMTP id 5076398; Tue, 03 Nov 2026 17:10:13 +0800
Received: from mtkmbs13n1.mediatek.inc (172.21.101.193) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.29; Tue, 3 Nov 2026 17:10:13 +0800
Received: from mtksitap99.mediatek.inc (10.233.130.16) by
 mtkmbs13n1.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.2562.29 via Frontend Transport; Tue, 3 Nov 2026 17:10:13 +0800
From: JB Tsai <jb.tsai@mediatek.com>
To: <nbd@nbd.name>, <lorenzo@kernel.org>
CC: <linux-wireless@vger.kernel.org>, <linux-mediatek@lists.infradead.org>,
	<Sean.Wang@mediatek.com>, <Evan-ym.Li@mediatek.com>, <jb.tsai@mediatek.com>,
	Yin-Ming Li <evan-ym.li@mediatek.com>, Sean Wang <sean.wang@mediatek.com>
Subject: [PATCH 3/3] wifi: mt76: mt7921: disable SDIO work before bus teardown
Date: Tue, 3 Nov 2026 17:10:10 +0800
Message-ID: <20261103091010.1148974-3-jb.tsai@mediatek.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20261103091010.1148974-1-jb.tsai@mediatek.com>
References: <20261103091010.1148974-1-jb.tsai@mediatek.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-MTK: N

From: Yin-Ming Li <evan-ym.li@mediatek.com>

Use the common unregister helper to synchronize unsolicited events
and disable reset, MAC and PM work before mac80211 destroys its workqueue.
The existing ordered cancellation cannot permanently reject a late wake
request from the SDIO TX/RX worker before mt76s_deinit() stops it.

Keep the SDIO command transport available through mac80211 teardown and
publish REMOVED afterward. Stop all SDIO workers and release the bus IRQ
before cancelling coredump work and purging scan and coredump queues.
Skip wake requests when the TX/RX worker observes REMOVED. Permanent PM
work disabling also rejects requests already past that check while the
bus workers are being stopped.

Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Yin-Ming Li <evan-ym.li@mediatek.com>
---
 drivers/net/wireless/mediatek/mt76/mt7921/sdio.c | 38 +++++++-----------------
 1 file changed, 10 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
index 1c074913b3fe35707c7186358b9713916356a3b5..012e706a6eda413045136d7c01a56990e3f74b9b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/sdio.c
@@ -34,7 +34,9 @@ static void mt7921s_txrx_worker(struct mt76_worker *w)
 	if (!mt76_connac_pm_ref(&dev->mphy, &dev->pm)) {
 		/* CR6593480 debug trace (NOT for upstream) */
 		mt76_trc(MT76_TRC_WORKER_PM_BAIL, 0, 0);
-		queue_work(mdev->wq, &dev->pm.wake_work);
+		/* The bus worker can run until mt76s_deinit(). */
+		if (!test_bit(MT76_REMOVED, &dev->mphy.state))
+			queue_work(mdev->wq, &dev->pm.wake_work);
 		return;
 	}
 
@@ -44,37 +46,18 @@ static void mt7921s_txrx_worker(struct mt76_worker *w)
 
 static void mt7921s_unregister_device(struct mt792x_dev *dev)
 {
-	struct mt76_connac_pm *pm = &dev->pm;
-
-	cancel_work_sync(&dev->init_work);
-	mt76_unregister_device(&dev->mt76);
-
-	/* mac80211 is gone, so no driver callback can re-arm the work items
-	 * below anymore. Turn mt76_connac_power_save_sched() and mt792x_reset()
-	 * into no-ops for the rest of the removal path, so that the RX and MCU
-	 * paths cannot re-arm them either. Do not set this before
-	 * mt76_unregister_device(): it would also stop mt76_connac_pm_wake()
-	 * from waking the chip up for the MCU commands the mac80211 teardown
-	 * still has to send.
-	 */
-	pm->suspended = true;
-
-	/* The order matters: mt7921_mac_reset_work() re-arms mac_work and
-	 * ps_work, and ps_work putting the chip back to sleep makes
-	 * mt7921s_txrx_worker() re-arm wake_work, which in turn re-arms
-	 * mac_work. Cancel each work item only once nothing that can re-arm it
-	 * is left running.
-	 */
-	cancel_work_sync(&dev->reset_work);
-	cancel_delayed_work_sync(&pm->ps_work);
-	cancel_work_sync(&pm->wake_work);
-	cancel_delayed_work_sync(&dev->mphy.mac_work);
-	cancel_delayed_work_sync(&dev->phy.scan_work);
+	mt7921_unregister_device(dev);
+	set_bit(MT76_REMOVED, &dev->mphy.state);
 
 	mt76s_deinit(&dev->mt76);
 	mt7921s_wfsys_reset(dev);
 	skb_queue_purge(&dev->mt76.mcu.res_q);
 
+	/* Event producers and scan_work are stopped before purging queues. */
+	skb_queue_purge(&dev->phy.scan_event_list);
+	cancel_delayed_work_sync(&dev->coredump.work);
+	skb_queue_purge(&dev->coredump.msg_list);
+
 	mt76_free_device(&dev->mt76);
 }
 
@@ -225,7 +208,6 @@ static void mt7921s_remove(struct sdio_func *func)
 {
 	struct mt792x_dev *dev = sdio_get_drvdata(func);
 
-	set_bit(MT76_REMOVED, &dev->mphy.state);
 	mt7921s_unregister_device(dev);
 }
 
-- 
2.43.0
