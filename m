Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [67.231.154.164])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC26D4B8291
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 20:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=67.231.154.164
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789591703; cv=none; b=K+SFTAWQdPLn2np5xXhfUFu+/bcIzcgTeo9Sx42YYwVvET7G7rvHn+F3oo+S/hdzMMSnAxQ+31ajDEqnNrAoWG0vTN8gByR4KLaEEDPgH8rkozVNKZPkXxvk1uxOEM82kDwXiXRYWQiW3dWe6KDnuPWew7w9PdKvws/JA5r759o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789591703; c=relaxed/simple;
	bh=1XfV31CGYhxh2fBu8RXyXQLykvUfiruRiTKzb3TmcPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDyHpkW/CJ0QD4u8Rtzm2RGHhTLe9XGGjoaGWtGTWviZ3kFRuML84j3d4fwDWV65N+47nZQaJMwjXWNvkHYIyKClYQhxolR9nqHtqjTz4rX2wgY7azvgKCPHG6QGMpcMRptbZQa6+YqTVm9ijf15n9ChCGgH2rN+cN/EZyg9A88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com; spf=pass smtp.mailfrom=candelatech.com; dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b=ldReR5ZR; arc=none smtp.client-ip=67.231.154.164
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=candelatech.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=candelatech.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="ldReR5ZR"
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail3.candelatech.com (mail.candelatech.com [208.74.158.173])
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 75E36340080
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 20:47:57 +0000 (UTC)
Received: from ben-dt5.candelatech.com (firewall.candelatech.com [50.251.239.81])
	by mail3.candelatech.com (Postfix) with ESMTP id E691913C2B0;
	Wed, 16 Sep 2026 13:47:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com E691913C2B0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
	s=default; t=1789591677;
	bh=1XfV31CGYhxh2fBu8RXyXQLykvUfiruRiTKzb3TmcPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldReR5ZRY07gCSS0nE4f6DuMhGhLlWqrNwkxMFXNnnitNIU316KUc4eQm4nuiQ8w3
	 eh+0CQyr/6UsP/+PllfZbXTxAhLzy3V5MMjl5F5B8eZan5jnsZud6AQmA6Lu0z+0C1
	 PK9BO69Se5R+zjtNbcKWCWLEhjSd6avKO4H5L/ns=
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [RFC 2/2] wifi: mt76: mt7996: Clean up IRQ on module unload.
Date: Wed, 16 Sep 2026 13:47:50 -0700
Message-ID: <20260916204750.1439984-2-greearb@candelatech.com>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20260916204750.1439984-1-greearb@candelatech.com>
References: <20260916204750.1439984-1-greearb@candelatech.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MDID: 1789591678-GnTl_MlvL9QW
X-PPE-STACK: {"stack":"us5"}
X-MDID-O:
 us5;at1;1789591678;GnTl_MlvL9QW;<greearb@candelatech.com>;f7146c1849a4b08a52804beb1c1cdf45
X-PPE-TRUSTED: V=1;DIR=OUT;

From: Ben Greear <greearb@candelatech.com>

When removing mt7996e module, softirqd would go to 100%
cpu usage.  It appears the problem is lack of cleanup of
the irq objects and proper kill of the irq_tasklet.

Clean these up, similar to how the error cleanup path works
in mt7996_pci_probe.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  Tested in 7.2 + modifications kernel, but applies and compiles
against 7.3 linus tree.  Not tested there at this point.

 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 16 +++++++++++++++-
 .../net/wireless/mediatek/mt76/mt7996/mt7996.h   |  1 +
 drivers/net/wireless/mediatek/mt76/mt7996/pci.c  | 11 +++++++++--
 3 files changed, 25 insertions(+), 3 deletions(-)

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

