Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6520E4A2626
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 19:20:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790104818; cv=none; b=PZJW+F/FgJLojd64CrUSTLEhpsAUCKsqiRynk0Vs7n4ByOVoN4dlToCYnharrNnVt0++EkPGQuzTZ9SOgKmJvL/s5+GWQmaI1J2M83UBRXUc9HAXLGK19ThspWLA8xHZDvSfyZcj0tp0FDWVQkk+YcXHW58YW+2hi06aLjuMCCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790104818; c=relaxed/simple;
	bh=Ybc2OUJ240JMllCkkEXop1D0Gmz2viRJBCg9r8mScUo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=V59lh/BWR4AZ9XVBWopjIzAwiIfuLapyovxwEVK+BdXS9ebIiDEhiuCSabsDZ3SqoBlPnCDLa6PYJqyAjFJkRFL6PUxQ6wBVxqsYhNW/qydh2xsdRsSdUnJ/2np22vgvzi0/FhvicqIxsRYNk4FiEzNFjVECS0fc0b1hUQzmE2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=QSIMPkCy; arc=none smtp.client-ip=148.163.129.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="QSIMPkCy"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0B0F0400068
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 19:20:11 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id 64EB813C2B0;
	Tue, 22 Sep 2026 12:20:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com 64EB813C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1790104811;
	bh=Ybc2OUJ240JMllCkkEXop1D0Gmz2viRJBCg9r8mScUo=;
	h=From:To:Cc:Subject:Date:From;
	b=QSIMPkCy95q+ti0yXcR0PlAnZ5Fs5+Te9AY7UgdwSnFj9g7jYNBeqoLNriGAH1PKC
	 oHifa2vKK69/tl3s3ZkptT4MY6Yoqaokn8/qnJ2ev/gPnRB+CIHKj1G82kZWsKBzj9
	 FJCzmHgAySQxOPK5yaS74qxRjEPQYmADZtgHAojs=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC-v2] wifi: mt76: mt7996: disable NAPI before deleting in dma_cleanup
Date: Tue, 22 Sep 2026 12:20:05 -0700
Message-ID: <20260922192005.676962-1-greearb@candelatech.com>
X-Mailer: git-send-email 2.42.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1790104812-QIG-6_jO639R
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;ut7;1790104812;QIG-6_jO639R;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

NAPI should be disabled before deleted, this stops
a warning seen when trying to rmmod mt7996e.

When removing mt7996e module, softirqd would go to 100%
cpu usage.  It appears the problem is lack of cleanup of
the irq objects and proper kill of the irq_tasklet.

NAPI was started on rx queues that had zero ndesc,
so be sure to start/stop NAPI on those other queues
by adding a new iterator.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mediatek/mt76/dma.c      | 18 ++++++++++------
 drivers/net/wireless/mediatek/mt76/mt76.h     |  7 +++++++
 .../net/wireless/mediatek/mt76/mt7996/dma.c   | 10 +++++++++
 .../net/wireless/mediatek/mt76/mt7996/init.c  | 16 +++++++++++++-
 .../net/wireless/mediatek/mt76/mt7996/mac.c   | 21 ++++++++-----------
 .../wireless/mediatek/mt76/mt7996/mt7996.h    |  1 +
 .../net/wireless/mediatek/mt76/mt7996/pci.c   | 11 ++++++++--
 7 files changed, 63 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/dma.c b/drivers/net/wireless/mediatek/mt76/dma.c
index a67880a9281c..468d36299567 100644
--- a/drivers/net/wireless/mediatek/mt76/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/dma.c
@@ -1127,8 +1127,10 @@ static void
 mt76_dma_rx_queue_init(struct mt76_dev *dev, enum mt76_rxq_id qid,
 		       int (*poll)(struct napi_struct *napi, int budget))
 {
-	netif_napi_add(dev->napi_dev, &dev->napi[qid], poll);
+	/* This may or may not assign ndesc > 0, add NAPI regardless. */
 	mt76_dma_rx_fill_buf(dev, &dev->q_rx[qid], false);
+	dev->q_rx[qid].napified = true;
+	netif_napi_add(dev->napi_dev, &dev->napi[qid], poll);
 	napi_enable(&dev->napi[qid]);
 }
 
@@ -1214,13 +1216,17 @@ void mt76_dma_cleanup(struct mt76_dev *dev)
 	for (i = 0; i < ARRAY_SIZE(dev->q_mcu); i++)
 		mt76_dma_tx_cleanup(dev, dev->q_mcu[i], true);
 
-	mt76_for_each_q_rx(dev, i) {
+	mt76_for_each_q_rx_napi(dev, i) {
 		struct mt76_queue *q = &dev->q_rx[i];
 
-		netif_napi_del(&dev->napi[i]);
-		mt76_dma_rx_cleanup(dev, q);
-
-		page_pool_destroy(q->page_pool);
+		if (q->napified) {
+			netif_napi_del(&dev->napi[i]);
+			q->napified = false;
+		}
+		if (q->ndesc) {
+			mt76_dma_rx_cleanup(dev, q);
+			page_pool_destroy(q->page_pool);
+		}
 	}
 
 	if (mtk_wed_device_active(&dev->mmio.wed))
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 62b41c8bb7c0..827c49ef3edd 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -251,6 +251,7 @@ struct mt76_queue {
 	int buf_size;
 	bool stopped;
 	bool blocked;
+	bool napified;
 
 	u8 buf_offset;
 	u16 flags;
@@ -1286,10 +1287,16 @@ static inline int mt76_wed_dma_setup(struct mt76_dev *dev, struct mt76_queue *q,
 #define mt76_queue_kick(dev, ...)	(dev)->mt76.queue_ops->kick(&((dev)->mt76), __VA_ARGS__)
 #define mt76_queue_reset(dev, ...)	(dev)->mt76.queue_ops->reset_q(&((dev)->mt76), __VA_ARGS__)
 
+/* For all rx queues that have ndesc > 0 */
 #define mt76_for_each_q_rx(dev, i)	\
 	for (i = 0; i < ARRAY_SIZE((dev)->q_rx); i++)	\
 		if ((dev)->q_rx[i].ndesc)
 
+/* For all rx queues that have ndesc or NAPI enabled */
+#define mt76_for_each_q_rx_napi(dev, i)			\
+	for (i = 0; i < ARRAY_SIZE((dev)->q_rx); i++)	\
+		if ((dev)->q_rx[i].napified || (dev)->q_rx[i].ndesc)
+
 
 #define mt76_dereference(p, dev) \
 	rcu_dereference_protected(p, lockdep_is_held(&(dev)->mutex))
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/dma.c b/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
index 3d9353811a02..48bdbbb7c78f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/dma.c
@@ -1051,7 +1051,17 @@ void mt7996_dma_reset(struct mt7996_dev *dev, bool force)
 
 void mt7996_dma_cleanup(struct mt7996_dev *dev)
 {
+	int i;
+
 	mt7996_dma_disable(dev, true);
 
+	/* mt76_dma_cleanup will delete the napi and clean up rx-queues,
+	 * we just need to disable it here to match whatever mt7921 is doing.
+	 */
+	mt76_for_each_q_rx_napi(&dev->mt76, i) {
+		if (dev->mt76.q_rx[i].napified)
+			napi_disable(&dev->mt76.napi[i]);
+	}
+
 	mt76_dma_cleanup(&dev->mt76);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index fb635a092584..45fc76cecd04 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1807,6 +1807,18 @@ int mt7996_register_device(struct mt7996_dev *dev)
 	return ret;
 }
 
+static void mt7996_cleanup_irqs(struct mt7996_dev *dev)
+{
+	struct mt76_dev *mdev = &dev->mt76;
+	struct pci_dev *pdev = to_pci_dev(mdev->dev);
+
+	mt7996_put_hif2(dev, dev->hif2); /* frees hif2 irq */
+
+	devm_free_irq(mdev->dev, pdev->irq, dev);
+	if (!mtk_wed_device_active(&dev->mt76.mmio.wed))
+		pci_free_irq_vectors(pdev);
+}
+
 void mt7996_unregister_device(struct mt7996_dev *dev)
 {
 	cancel_work_sync(&dev->dump_work);
@@ -1825,7 +1837,9 @@ void mt7996_unregister_device(struct mt7996_dev *dev)
 	if (mt7996_has_hwrro(dev) &&
 	    !mtk_wed_device_active(&dev->mt76.mmio.wed))
 		mt7996_rro_msdu_page_map_free(dev);
-	tasklet_disable(&dev->mt76.irq_tasklet);
+	tasklet_kill(&dev->mt76.irq_tasklet);
+
+	mt7996_cleanup_irqs(dev);
 
 	mt76_free_device(&dev->mt76);
 }
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 1cba381a78b8..396024acd645 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2311,13 +2311,12 @@ mt7996_mac_restart(struct mt7996_dev *dev)
 
 	/* disable all tx/rx napi */
 	mt76_worker_disable(&dev->mt76.tx_worker);
-	mt76_for_each_q_rx(mdev, i) {
+	mt76_for_each_q_rx_napi(mdev, i) {
 		if (mtk_wed_device_active(&dev->mt76.mmio.wed) &&
 		    mt76_queue_is_wed_rro(&mdev->q_rx[i]))
 			continue;
 
-		if (mdev->q_rx[i].ndesc)
-			napi_disable(&dev->mt76.napi[i]);
+		napi_disable(&dev->mt76.napi[i]);
 	}
 	napi_disable(&dev->mt76.tx_napi);
 
@@ -2327,17 +2326,15 @@ mt7996_mac_restart(struct mt7996_dev *dev)
 
 	mt7996_dma_reset(dev, true);
 
-	mt76_for_each_q_rx(mdev, i) {
+	mt76_for_each_q_rx_napi(mdev, i) {
 		if (mtk_wed_device_active(&dev->mt76.mmio.wed) &&
 		    mt76_queue_is_wed_rro(&mdev->q_rx[i]))
 			continue;
 
-		if (mdev->q_rx[i].ndesc) {
-			napi_enable(&dev->mt76.napi[i]);
-			local_bh_disable();
-			napi_schedule(&dev->mt76.napi[i]);
-			local_bh_enable();
-		}
+		napi_enable(&dev->mt76.napi[i]);
+		local_bh_disable();
+		napi_schedule(&dev->mt76.napi[i]);
+		local_bh_enable();
 	}
 	clear_bit(MT76_MCU_RESET, &dev->mphy.state);
 	clear_bit(MT76_STATE_MCU_RUNNING, &dev->mphy.state);
@@ -2585,7 +2582,7 @@ void mt7996_mac_reset_work(struct work_struct *work)
 	mutex_lock(&dev->mt76.mutex);
 
 	mt76_worker_disable(&dev->mt76.tx_worker);
-	mt76_for_each_q_rx(&dev->mt76, i) {
+	mt76_for_each_q_rx_napi(&dev->mt76, i) {
 		if (mtk_wed_device_active(&dev->mt76.mmio.wed) &&
 		    mt76_queue_is_wed_rro(&dev->mt76.q_rx[i]))
 			continue;
@@ -2645,7 +2642,7 @@ void mt7996_mac_reset_work(struct work_struct *work)
 	mt7996_for_each_phy(dev, phy)
 		clear_bit(MT76_RESET, &phy->mt76->state);
 
-	mt76_for_each_q_rx(&dev->mt76, i) {
+	mt76_for_each_q_rx_napi(&dev->mt76, i) {
 		if (mtk_wed_device_active(&dev->mt76.mmio.wed) &&
 		    mt76_queue_is_wed_rro(&dev->mt76.q_rx[i]))
 			continue;
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
index 2a0cdb56f822..79c57e88e107 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mt7996.h
@@ -678,6 +678,7 @@ irqreturn_t mt7996_irq_handler(int irq, void *dev_instance);
 u64 __mt7996_get_tsf(struct ieee80211_hw *hw, struct mt7996_vif_link *link);
 int mt7996_register_device(struct mt7996_dev *dev);
 void mt7996_unregister_device(struct mt7996_dev *dev);
+void mt7996_put_hif2(struct mt7996_dev *dev, struct mt7996_hif *hif);
 int mt7996_vif_link_add(struct mt76_phy *mphy, struct ieee80211_vif *vif,
 			struct ieee80211_bss_conf *link_conf,
 			struct mt76_vif_link *mlink);
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
index b7d9193e042f..5c686cf66d0a 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/pci.c
@@ -53,11 +53,19 @@ static struct mt7996_hif *mt7996_pci_get_hif2(u32 idx)
 	return hif;
 }
 
-static void mt7996_put_hif2(struct mt7996_hif *hif)
+void mt7996_put_hif2(struct mt7996_dev *dev, struct mt7996_hif *hif)
 {
+	struct pci_dev *hif2_dev;
+
 	if (!hif)
 		return;
 
+	hif2_dev = container_of(hif->dev, struct pci_dev, dev);
+
+	devm_free_irq(dev->mt76.dev, hif->irq, dev);
+	if (!mtk_wed_device_active(&dev->mt76.mmio.wed_hif2))
+		pci_free_irq_vectors(hif2_dev);
+
 	put_device(hif->dev);
 }
 
@@ -237,7 +245,6 @@ static void mt7996_pci_remove(struct pci_dev *pdev)
 
 	mdev = pci_get_drvdata(pdev);
 	dev = container_of(mdev, struct mt7996_dev, mt76);
-	mt7996_put_hif2(dev->hif2);
 	mt7996_unregister_device(dev);
 }
 
-- 
2.42.0

