Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40649 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab2LLMOf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 07:14:35 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 1/2] ath9k: use the devres API for allocations/mappings
Date: Wed, 12 Dec 2012 13:14:22 +0100
Message-Id: <1355314463-17742-1-git-send-email-nbd@openwrt.org> (sfid-20121212_131440_972732_EE0BAA9C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ahb.c   |  22 ++------
 drivers/net/wireless/ath/ath9k/ath9k.h |   5 --
 drivers/net/wireless/ath/ath9k/init.c  | 100 ++++++++++-----------------------
 drivers/net/wireless/ath/ath9k/mci.c   |   7 +--
 drivers/net/wireless/ath/ath9k/pci.c   |  39 +++----------
 drivers/net/wireless/ath/ath9k/recv.c  |  11 +---
 drivers/net/wireless/ath/ath9k/xmit.c  |  37 ++----------
 7 files changed, 51 insertions(+), 170 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 3a69804..d1ff3c2 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -86,29 +86,25 @@ static int ath_ahb_probe(struct platform_device *pdev)
 
 	if (!pdev->dev.platform_data) {
 		dev_err(&pdev->dev, "no platform data specified\n");
-		ret = -EINVAL;
-		goto err_out;
+		return -EINVAL;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no memory resource found\n");
-		ret = -ENXIO;
-		goto err_out;
+		return -ENXIO;
 	}
 
-	mem = ioremap_nocache(res->start, resource_size(res));
+	mem = devm_ioremap_nocache(&pdev->dev, res->start, resource_size(res));
 	if (mem == NULL) {
 		dev_err(&pdev->dev, "ioremap failed\n");
-		ret = -ENOMEM;
-		goto err_out;
+		return -ENOMEM;
 	}
 
 	res = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (res == NULL) {
 		dev_err(&pdev->dev, "no IRQ resource found\n");
-		ret = -ENXIO;
-		goto err_iounmap;
+		return -ENXIO;
 	}
 
 	irq = res->start;
@@ -116,8 +112,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
 	if (hw == NULL) {
 		dev_err(&pdev->dev, "no memory for ieee80211_hw\n");
-		ret = -ENOMEM;
-		goto err_iounmap;
+		return -ENOMEM;
 	}
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
@@ -156,9 +151,6 @@ static int ath_ahb_probe(struct platform_device *pdev)
  err_free_hw:
 	ieee80211_free_hw(hw);
 	platform_set_drvdata(pdev, NULL);
- err_iounmap:
-	iounmap(mem);
- err_out:
 	return ret;
 }
 
@@ -168,12 +160,10 @@ static int ath_ahb_remove(struct platform_device *pdev)
 
 	if (hw) {
 		struct ath_softc *sc = hw->priv;
-		void __iomem *mem = sc->mem;
 
 		ath9k_deinit_device(sc);
 		free_irq(sc->irq, sc);
 		ieee80211_free_hw(sc->hw);
-		iounmap(mem);
 		platform_set_drvdata(pdev, NULL);
 	}
 
diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 86e26a1..7250107 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -109,14 +109,11 @@ struct ath_descdma {
 	void *dd_desc;
 	dma_addr_t dd_desc_paddr;
 	u32 dd_desc_len;
-	struct ath_buf *dd_bufptr;
 };
 
 int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		      struct list_head *head, const char *name,
 		      int nbuf, int ndesc, bool is_tx);
-void ath_descdma_cleanup(struct ath_softc *sc, struct ath_descdma *dd,
-			 struct list_head *head);
 
 /***********/
 /* RX / TX */
@@ -320,7 +317,6 @@ struct ath_rx {
 	spinlock_t rxbuflock;
 	struct list_head rxbuf;
 	struct ath_descdma rxdma;
-	struct ath_buf *rx_bufptr;
 	struct ath_rx_edma rx_edma[ATH9K_RX_QUEUE_MAX];
 
 	struct sk_buff *frag;
@@ -345,7 +341,6 @@ void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an);
 void ath_tx_node_cleanup(struct ath_softc *sc, struct ath_node *an);
 void ath_txq_schedule(struct ath_softc *sc, struct ath_txq *txq);
 int ath_tx_init(struct ath_softc *sc, int nbufs);
-void ath_tx_cleanup(struct ath_softc *sc);
 int ath_txq_update(struct ath_softc *sc, int qnum,
 		   struct ath9k_tx_queue_info *q);
 void ath_update_max_aggr_framelen(struct ath_softc *sc, int queue, int txop);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index f69ef5d..0f00a13 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -337,7 +337,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	u8 *ds;
 	struct ath_buf *bf;
-	int i, bsize, error, desc_len;
+	int i, bsize, desc_len;
 
 	ath_dbg(common, CONFIG, "%s DMA: %u buffers %u desc/buf\n",
 		name, nbuf, ndesc);
@@ -353,8 +353,7 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	if ((desc_len % 4) != 0) {
 		ath_err(common, "ath_desc not DWORD aligned\n");
 		BUG_ON((desc_len % 4) != 0);
-		error = -ENOMEM;
-		goto fail;
+		return -ENOMEM;
 	}
 
 	dd->dd_desc_len = desc_len * nbuf * ndesc;
@@ -378,12 +377,11 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 	}
 
 	/* allocate descriptors */
-	dd->dd_desc = dma_alloc_coherent(sc->dev, dd->dd_desc_len,
-					 &dd->dd_desc_paddr, GFP_KERNEL);
-	if (dd->dd_desc == NULL) {
-		error = -ENOMEM;
-		goto fail;
-	}
+	dd->dd_desc = dmam_alloc_coherent(sc->dev, dd->dd_desc_len,
+					  &dd->dd_desc_paddr, GFP_KERNEL);
+	if (!dd->dd_desc)
+		return -ENOMEM;
+
 	ds = (u8 *) dd->dd_desc;
 	ath_dbg(common, CONFIG, "%s DMA map: %p (%u) -> %llx (%u)\n",
 		name, ds, (u32) dd->dd_desc_len,
@@ -391,12 +389,9 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 
 	/* allocate buffers */
 	bsize = sizeof(struct ath_buf) * nbuf;
-	bf = kzalloc(bsize, GFP_KERNEL);
-	if (bf == NULL) {
-		error = -ENOMEM;
-		goto fail2;
-	}
-	dd->dd_bufptr = bf;
+	bf = devm_kzalloc(sc->dev, bsize, GFP_KERNEL);
+	if (!bf)
+		return -ENOMEM;
 
 	for (i = 0; i < nbuf; i++, bf++, ds += (desc_len * ndesc)) {
 		bf->bf_desc = ds;
@@ -422,12 +417,6 @@ int ath_descdma_setup(struct ath_softc *sc, struct ath_descdma *dd,
 		list_add_tail(&bf->list, head);
 	}
 	return 0;
-fail2:
-	dma_free_coherent(sc->dev, dd->dd_desc_len, dd->dd_desc,
-			  dd->dd_desc_paddr);
-fail:
-	memset(dd, 0, sizeof(*dd));
-	return error;
 }
 
 static int ath9k_init_queues(struct ath_softc *sc)
@@ -457,11 +446,13 @@ static int ath9k_init_channels_rates(struct ath_softc *sc)
 		     ATH9K_NUM_CHANNELS);
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_2GHZ) {
-		channels = kmemdup(ath9k_2ghz_chantable,
+		channels = devm_kzalloc(sc->dev,
 			sizeof(ath9k_2ghz_chantable), GFP_KERNEL);
 		if (!channels)
 		    return -ENOMEM;
 
+		memcpy(channels, ath9k_2ghz_chantable,
+		       sizeof(ath9k_2ghz_chantable));
 		sc->sbands[IEEE80211_BAND_2GHZ].channels = channels;
 		sc->sbands[IEEE80211_BAND_2GHZ].band = IEEE80211_BAND_2GHZ;
 		sc->sbands[IEEE80211_BAND_2GHZ].n_channels =
@@ -472,14 +463,13 @@ static int ath9k_init_channels_rates(struct ath_softc *sc)
 	}
 
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_5GHZ) {
-		channels = kmemdup(ath9k_5ghz_chantable,
+		channels = devm_kzalloc(sc->dev,
 			sizeof(ath9k_5ghz_chantable), GFP_KERNEL);
-		if (!channels) {
-			if (sc->sbands[IEEE80211_BAND_2GHZ].channels)
-				kfree(sc->sbands[IEEE80211_BAND_2GHZ].channels);
+		if (!channels)
 			return -ENOMEM;
-		}
 
+		memcpy(channels, ath9k_5ghz_chantable,
+		       sizeof(ath9k_5ghz_chantable));
 		sc->sbands[IEEE80211_BAND_5GHZ].channels = channels;
 		sc->sbands[IEEE80211_BAND_5GHZ].band = IEEE80211_BAND_5GHZ;
 		sc->sbands[IEEE80211_BAND_5GHZ].n_channels =
@@ -565,7 +555,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	int ret = 0, i;
 	int csz = 0;
 
-	ah = kzalloc(sizeof(struct ath_hw), GFP_KERNEL);
+	ah = devm_kzalloc(sc->dev, sizeof(struct ath_hw), GFP_KERNEL);
 	if (!ah)
 		return -ENOMEM;
 
@@ -636,7 +626,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	if (pdata && pdata->eeprom_name) {
 		ret = ath9k_eeprom_request(sc, pdata->eeprom_name);
 		if (ret)
-			goto err_eeprom;
+			return ret;
 	}
 
 	/* Initializes the hardware for all supported chipsets */
@@ -676,10 +666,6 @@ err_queues:
 	ath9k_hw_deinit(ah);
 err_hw:
 	ath9k_eeprom_release(sc);
-err_eeprom:
-	kfree(ah);
-	sc->sc_ah = NULL;
-
 	return ret;
 }
 
@@ -844,8 +830,8 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 
 	/* Bring up device */
 	error = ath9k_init_softc(devid, sc, bus_ops);
-	if (error != 0)
-		goto error_init;
+	if (error)
+		return error;
 
 	ah = sc->sc_ah;
 	common = ath9k_hw_common(ah);
@@ -855,19 +841,19 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 	error = ath_regd_init(&common->regulatory, sc->hw->wiphy,
 			      ath9k_reg_notifier);
 	if (error)
-		goto error_regd;
+		goto deinit;
 
 	reg = &common->regulatory;
 
 	/* Setup TX DMA */
 	error = ath_tx_init(sc, ATH_TXBUF);
 	if (error != 0)
-		goto error_tx;
+		goto deinit;
 
 	/* Setup RX DMA */
 	error = ath_rx_init(sc, ATH_RXBUF);
 	if (error != 0)
-		goto error_rx;
+		goto deinit;
 
 	ath9k_init_txpower_limits(sc);
 
@@ -881,19 +867,19 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 	/* Register with mac80211 */
 	error = ieee80211_register_hw(hw);
 	if (error)
-		goto error_register;
+		goto rx_cleanup;
 
 	error = ath9k_init_debug(ah);
 	if (error) {
 		ath_err(common, "Unable to create debugfs files\n");
-		goto error_world;
+		goto unregister;
 	}
 
 	/* Handle world regulatory */
 	if (!ath_is_world_regd(reg)) {
 		error = regulatory_hint(hw->wiphy, reg->alpha2);
 		if (error)
-			goto error_world;
+			goto unregister;
 	}
 
 	ath_init_leds(sc);
@@ -901,17 +887,12 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 
 	return 0;
 
-error_world:
+unregister:
 	ieee80211_unregister_hw(hw);
-error_register:
+rx_cleanup:
 	ath_rx_cleanup(sc);
-error_rx:
-	ath_tx_cleanup(sc);
-error_tx:
-	/* Nothing */
-error_regd:
+deinit:
 	ath9k_deinit_softc(sc);
-error_init:
 	return error;
 }
 
@@ -923,12 +904,6 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 {
 	int i = 0;
 
-	if (sc->sbands[IEEE80211_BAND_2GHZ].channels)
-		kfree(sc->sbands[IEEE80211_BAND_2GHZ].channels);
-
-	if (sc->sbands[IEEE80211_BAND_5GHZ].channels)
-		kfree(sc->sbands[IEEE80211_BAND_5GHZ].channels);
-
 	ath9k_deinit_btcoex(sc);
 
 	for (i = 0; i < ATH9K_NUM_TX_QUEUES; i++)
@@ -940,8 +915,6 @@ static void ath9k_deinit_softc(struct ath_softc *sc)
 		sc->dfs_detector->exit(sc->dfs_detector);
 
 	ath9k_eeprom_release(sc);
-	kfree(sc->sc_ah);
-	sc->sc_ah = NULL;
 }
 
 void ath9k_deinit_device(struct ath_softc *sc)
@@ -957,22 +930,9 @@ void ath9k_deinit_device(struct ath_softc *sc)
 
 	ieee80211_unregister_hw(hw);
 	ath_rx_cleanup(sc);
-	ath_tx_cleanup(sc);
 	ath9k_deinit_softc(sc);
 }
 
-void ath_descdma_cleanup(struct ath_softc *sc,
-			 struct ath_descdma *dd,
-			 struct list_head *head)
-{
-	dma_free_coherent(sc->dev, dd->dd_desc_len, dd->dd_desc,
-			  dd->dd_desc_paddr);
-
-	INIT_LIST_HEAD(head);
-	kfree(dd->dd_bufptr);
-	memset(dd, 0, sizeof(*dd));
-}
-
 /************************/
 /*     Module Hooks     */
 /************************/
diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 5c02702..d207433 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -438,7 +438,7 @@ int ath_mci_setup(struct ath_softc *sc)
 	struct ath_mci_buf *buf = &mci->sched_buf;
 	int ret;
 
-	buf->bf_addr = dma_alloc_coherent(sc->dev,
+	buf->bf_addr = dmam_alloc_coherent(sc->dev,
 				  ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE,
 				  &buf->bf_paddr, GFP_KERNEL);
 
@@ -477,11 +477,6 @@ void ath_mci_cleanup(struct ath_softc *sc)
 	struct ath_mci_coex *mci = &sc->mci_coex;
 	struct ath_mci_buf *buf = &mci->sched_buf;
 
-	if (buf->bf_addr)
-		dma_free_coherent(sc->dev,
-				  ATH_MCI_SCHED_BUF_SIZE + ATH_MCI_GPM_BUF_SIZE,
-				  buf->bf_addr, buf->bf_paddr);
-
 	ar9003_mci_cleanup(ah);
 
 	ath_dbg(common, MCI, "MCI De-Initialized\n");
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 8e9b826..ac14c90 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -147,7 +147,6 @@ static const struct ath_bus_ops ath_pci_bus_ops = {
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	void __iomem *mem;
 	struct ath_softc *sc;
 	struct ieee80211_hw *hw;
 	u8 csz;
@@ -155,19 +154,19 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	int ret = 0;
 	char hw_name[64];
 
-	if (pci_enable_device(pdev))
+	if (pcim_enable_device(pdev))
 		return -EIO;
 
 	ret =  pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
 		pr_err("32-bit DMA not available\n");
-		goto err_dma;
+		return ret;
 	}
 
 	ret = pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK(32));
 	if (ret) {
 		pr_err("32-bit DMA consistent DMA enable failed\n");
-		goto err_dma;
+		return ret;
 	}
 
 	/*
@@ -203,25 +202,16 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
-	ret = pci_request_region(pdev, 0, "ath9k");
+	ret = pcim_iomap_regions(pdev, BIT(0), "ath9k");
 	if (ret) {
 		dev_err(&pdev->dev, "PCI memory region reserve error\n");
-		ret = -ENODEV;
-		goto err_region;
-	}
-
-	mem = pci_iomap(pdev, 0, 0);
-	if (!mem) {
-		pr_err("PCI memory map error\n") ;
-		ret = -EIO;
-		goto err_iomap;
+		return -ENODEV;
 	}
 
 	hw = ieee80211_alloc_hw(sizeof(struct ath_softc), &ath9k_ops);
 	if (!hw) {
 		dev_err(&pdev->dev, "No memory for ieee80211_hw\n");
-		ret = -ENOMEM;
-		goto err_alloc_hw;
+		return -ENOMEM;
 	}
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
@@ -230,7 +220,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc = hw->priv;
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
-	sc->mem = mem;
+	sc->mem = pcim_iomap_table(pdev)[0];
 
 	/* Will be cleared in ath9k_start() */
 	set_bit(SC_OP_INVALID, &sc->sc_flags);
@@ -251,7 +241,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	ath9k_hw_name(sc->sc_ah, hw_name, sizeof(hw_name));
 	wiphy_info(hw->wiphy, "%s mem=0x%lx, irq=%d\n",
-		   hw_name, (unsigned long)mem, pdev->irq);
+		   hw_name, (unsigned long)sc->mem, pdev->irq);
 
 	return 0;
 
@@ -259,14 +249,6 @@ err_init:
 	free_irq(sc->irq, sc);
 err_irq:
 	ieee80211_free_hw(hw);
-err_alloc_hw:
-	pci_iounmap(pdev, mem);
-err_iomap:
-	pci_release_region(pdev, 0);
-err_region:
-	/* Nothing */
-err_dma:
-	pci_disable_device(pdev);
 	return ret;
 }
 
@@ -274,17 +256,12 @@ static void ath_pci_remove(struct pci_dev *pdev)
 {
 	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 	struct ath_softc *sc = hw->priv;
-	void __iomem *mem = sc->mem;
 
 	if (!is_ath9k_unloaded)
 		sc->sc_ah->ah_flags |= AH_UNPLUGGED;
 	ath9k_deinit_device(sc);
 	free_irq(sc->irq, sc);
 	ieee80211_free_hw(sc->hw);
-
-	pci_iounmap(pdev, mem);
-	pci_disable_device(pdev);
-	pci_release_region(pdev, 0);
 }
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index d4df98a..3d236ae 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -180,11 +180,6 @@ static void ath_rx_edma_cleanup(struct ath_softc *sc)
 			bf->bf_mpdu = NULL;
 		}
 	}
-
-	INIT_LIST_HEAD(&sc->rx.rxbuf);
-
-	kfree(sc->rx.rx_bufptr);
-	sc->rx.rx_bufptr = NULL;
 }
 
 static void ath_rx_edma_init_queue(struct ath_rx_edma *rx_edma, int size)
@@ -211,12 +206,11 @@ static int ath_rx_edma_init(struct ath_softc *sc, int nbufs)
 			       ah->caps.rx_hp_qdepth);
 
 	size = sizeof(struct ath_buf) * nbufs;
-	bf = kzalloc(size, GFP_KERNEL);
+	bf = devm_kzalloc(sc->dev, size, GFP_KERNEL);
 	if (!bf)
 		return -ENOMEM;
 
 	INIT_LIST_HEAD(&sc->rx.rxbuf);
-	sc->rx.rx_bufptr = bf;
 
 	for (i = 0; i < nbufs; i++, bf++) {
 		skb = ath_rxbuf_alloc(common, common->rx_bufsize, GFP_KERNEL);
@@ -363,9 +357,6 @@ void ath_rx_cleanup(struct ath_softc *sc)
 				bf->bf_mpdu = NULL;
 			}
 		}
-
-		if (sc->rx.rxdma.dd_desc_len != 0)
-			ath_descdma_cleanup(sc, &sc->rx.rxdma, &sc->rx.rxbuf);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 90e48a0..ca4a034 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2361,8 +2361,8 @@ static int ath_txstatus_setup(struct ath_softc *sc, int size)
 	u8 txs_len = sc->sc_ah->caps.txs_len;
 
 	dd->dd_desc_len = size * txs_len;
-	dd->dd_desc = dma_alloc_coherent(sc->dev, dd->dd_desc_len,
-					 &dd->dd_desc_paddr, GFP_KERNEL);
+	dd->dd_desc = dmam_alloc_coherent(sc->dev, dd->dd_desc_len,
+					  &dd->dd_desc_paddr, GFP_KERNEL);
 	if (!dd->dd_desc)
 		return -ENOMEM;
 
@@ -2382,14 +2382,6 @@ static int ath_tx_edma_init(struct ath_softc *sc)
 	return err;
 }
 
-static void ath_tx_edma_cleanup(struct ath_softc *sc)
-{
-	struct ath_descdma *dd = &sc->txsdma;
-
-	dma_free_coherent(sc->dev, dd->dd_desc_len, dd->dd_desc,
-			  dd->dd_desc_paddr);
-}
-
 int ath_tx_init(struct ath_softc *sc, int nbufs)
 {
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
@@ -2402,7 +2394,7 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 	if (error != 0) {
 		ath_err(common,
 			"Failed to allocate tx descriptors: %d\n", error);
-		goto err;
+		return error;
 	}
 
 	error = ath_descdma_setup(sc, &sc->beacon.bdma, &sc->beacon.bbuf,
@@ -2410,36 +2402,17 @@ int ath_tx_init(struct ath_softc *sc, int nbufs)
 	if (error != 0) {
 		ath_err(common,
 			"Failed to allocate beacon descriptors: %d\n", error);
-		goto err;
+		return error;
 	}
 
 	INIT_DELAYED_WORK(&sc->tx_complete_work, ath_tx_complete_poll_work);
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA) {
+	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
 		error = ath_tx_edma_init(sc);
-		if (error)
-			goto err;
-	}
-
-err:
-	if (error != 0)
-		ath_tx_cleanup(sc);
 
 	return error;
 }
 
-void ath_tx_cleanup(struct ath_softc *sc)
-{
-	if (sc->beacon.bdma.dd_desc_len != 0)
-		ath_descdma_cleanup(sc, &sc->beacon.bdma, &sc->beacon.bbuf);
-
-	if (sc->tx.txdma.dd_desc_len != 0)
-		ath_descdma_cleanup(sc, &sc->tx.txdma, &sc->tx.txbuf);
-
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_EDMA)
-		ath_tx_edma_cleanup(sc);
-}
-
 void ath_tx_node_init(struct ath_softc *sc, struct ath_node *an)
 {
 	struct ath_atx_tid *tid;
-- 
1.7.12.2

