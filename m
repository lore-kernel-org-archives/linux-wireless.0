Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816E341D113
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 15:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785164692; cv=none; b=n7lKHXM5jXdfYWSwGvNttTo39K+OHLZqo3EDBcFlrFPogxWJSODZajg3TFjF0q3rk083Rmc5eun7Gb5j/bYLH3lmynNiuYbMSbJYuySaeq5fqFhEwIBwmxwVnBkBMiycOgqESk6HNme9zHkNMlJs0bxkjsgx/sYdtth1vEYeALU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785164692; c=relaxed/simple;
	bh=ys3+pQw0MDj+ocm+U5nws9zWinfDHF46hY6Po/ekeRk=;
	h=From:To:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i751Q85slG0v5hBbm9ERTKj/eDCP8EkcwTE8uYfVViGSzasGeEfnCiuFXWp3+YMLNGWSn+1r+vTEaB0r7zhTpu8lbsiP5YDrxv6QeUQU1tnCsInhT/odrA5g3XeG0l5HW6eCIECG/VOTEKD/32JKSBTqDfCfEYWHMtj7Mlusklg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=gQW4csKK; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="gQW4csKK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=yHhIgEItBjqygwKq8Ov5CkQ2T5Y/4ufJccKxEIz+yBo=; b=gQW4csKKytlr0iZ55OPWopl+sE
	0kIXj7r+rIfmGIXCR9Rn8mdnpEAidNfl/U6fs8PLonKu/yFuTijCtoch1P6U0J6sDgNy4ejRcoc5I
	aqPPq4I8UUgdXNsabOsxGpjXHzZ2fRqHo5t32huKLBskekQBN3/JoV3wFeEJsGoPwsJA=;
Received: from p200300cadf0126009ebf0dfffe00fa2d.dip0.t-ipconnect.de ([2003:ca:df01:2600:9ebf:dff:fe00:fa2d] helo=max)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1woMsk-008KN0-1Y
	for linux-wireless@vger.kernel.org;
	Mon, 27 Jul 2026 17:04:42 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Subject: [PATCH mt76 07/15] wifi: mt76: mt7996: do not leave state behind after a failed WED attach
Date: Mon, 27 Jul 2026 15:04:26 +0000
Message-ID: <20260727150434.1778520-7-nbd@nbd.name>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260727150434.1778520-1-nbd@nbd.name>
References: <20260727150434.1778520-1-nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mt7996_mmio_wed_init() set dev->mt76.hwrro_mode and rx_token_size while
building the WED configuration, before knowing whether the WED attach
can succeed. A failed attach left the enlarged rx_token_size behind and
reset hwrro_mode to MT76_HWRRO_OFF, clobbering the values that another
RX datapath owner may have configured earlier in probe: on Airoha
platforms with the wed_enable module parameter set, this broke the NPU
offload configuration set up by mt76_npu_init() (NPU offload requires
HW-RRO and a larger rx token space, and the attach always fails there
since no SoC has both an Airoha NPU and MTK WED).

Move both assignments after a successful attach, next to the existing
success-only dma_dev/irq assignments. This is safe for the regular WED
attach case: the first consumer of either field runs after probe
continues (mtk_wed_device_attach() only invokes the init_buf callback;
rx buffers are allocated via init_rx_buf from mtk_wed_start(), long
after mt7996_mmio_wed_init() has returned).

Within the WED configuration the HW-RRO checks were constant: the mode
was assigned unconditionally right before them, and the hif2 path is
only reachable after a successful main attach has set it. Resolve them
to their constant values and drop the dead branches.

Fixes: 377aa17d2aed ("wifi: mt76: mt7996: Add NPU offload support to MT7996 driver")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 .../net/wireless/mediatek/mt76/mt7996/mmio.c  | 53 +++++++------------
 1 file changed, 20 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
index ba064324a7cc..ac81be5fe023 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mmio.c
@@ -493,9 +493,6 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 	if (hif2 && !mtk_wed_device_active(&dev->mt76.mmio.wed))
 		return 0;
 
-	dev->mt76.hwrro_mode = is_mt7996(&dev->mt76) ? MT76_HWRRO_V3
-						     : MT76_HWRRO_V3_1;
-
 	hif1_ofs = dev->hif2 ? MT_WFDMA0_PCIE1(0) - MT_WFDMA0(0) : 0;
 
 	if (hif2)
@@ -520,23 +517,16 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 		wed->wlan.wpdma_tx = wed->wlan.phy_base + hif1_ofs +
 					     MT_TXQ_RING_BASE(0) +
 					     MT7996_TXQ_BAND2 * MT_RING_SIZE;
-		if (mt7996_has_hwrro(dev)) {
-			if (is_mt7996(&dev->mt76)) {
-				wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_EXT) - 1;
-				wed->wlan.wpdma_txfree = wed->wlan.phy_base + hif1_ofs +
-							 MT_RXQ_RING_BASE(0) +
-							 MT7996_RXQ_TXFREE2 * MT_RING_SIZE;
-			} else {
-				wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_BAND1_EXT) - 1;
-				wed->wlan.wpdma_txfree = wed->wlan.phy_base + hif1_ofs +
-							 MT_RXQ_RING_BASE(0) +
-							 MT7996_RXQ_MCU_WA_EXT * MT_RING_SIZE;
-			}
-		} else {
+		if (is_mt7996(&dev->mt76)) {
+			wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_EXT) - 1;
 			wed->wlan.wpdma_txfree = wed->wlan.phy_base + hif1_ofs +
 						 MT_RXQ_RING_BASE(0) +
-						 MT7996_RXQ_MCU_WA_TRI * MT_RING_SIZE;
-			wed->wlan.txfree_tbit = ffs(MT_INT_RX_DONE_WA_TRI) - 1;
+						 MT7996_RXQ_TXFREE2 * MT_RING_SIZE;
+		} else {
+			wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_BAND1_EXT) - 1;
+			wed->wlan.wpdma_txfree = wed->wlan.phy_base + hif1_ofs +
+						 MT_RXQ_RING_BASE(0) +
+						 MT7996_RXQ_MCU_WA_EXT * MT_RING_SIZE;
 		}
 
 		wed->wlan.wpdma_rx_glo = wed->wlan.phy_base + hif1_ofs + MT_WFDMA0_GLO_CFG;
@@ -547,7 +537,7 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 		wed->wlan.id = MT7996_DEVICE_ID_2;
 		wed->wlan.tx_tbit[0] = ffs(MT_INT_TX_DONE_BAND2) - 1;
 	} else {
-		wed->wlan.hw_rro = mt7996_has_hwrro(dev);
+		wed->wlan.hw_rro = true;
 		wed->wlan.wpdma_int = wed->wlan.phy_base + MT_INT_SOURCE_CSR;
 		wed->wlan.wpdma_mask = wed->wlan.phy_base + MT_INT_MASK_CSR;
 		wed->wlan.wpdma_tx = wed->wlan.phy_base + MT_TXQ_RING_BASE(0) +
@@ -600,23 +590,15 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 		wed->wlan.tx_tbit[0] = ffs(MT_INT_TX_DONE_BAND0) - 1;
 		wed->wlan.tx_tbit[1] = ffs(MT_INT_TX_DONE_BAND1) - 1;
 		if (is_mt7996(&dev->mt76)) {
-			if (mt7996_has_hwrro(dev)) {
-				wed->wlan.wpdma_txfree = wed->wlan.phy_base +
-							 MT_RXQ_RING_BASE(0) +
-							 MT7996_RXQ_TXFREE0 * MT_RING_SIZE;
-				wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_MAIN) - 1;
-			} else {
-				wed->wlan.wpdma_txfree = wed->wlan.phy_base +
-							 MT_RXQ_RING_BASE(0) +
-							 MT7996_RXQ_MCU_WA_MAIN * MT_RING_SIZE;
-				wed->wlan.txfree_tbit = ffs(MT_INT_RX_DONE_WA_MAIN) - 1;
-			}
+			wed->wlan.wpdma_txfree = wed->wlan.phy_base +
+						 MT_RXQ_RING_BASE(0) +
+						 MT7996_RXQ_TXFREE0 * MT_RING_SIZE;
+			wed->wlan.txfree_tbit = ffs(MT_INT_RX_TXFREE_MAIN) - 1;
 		} else {
 			wed->wlan.txfree_tbit = ffs(MT_INT_RX_DONE_WA_MAIN) - 1;
 			wed->wlan.wpdma_txfree = wed->wlan.phy_base + MT_RXQ_RING_BASE(0) +
 						  MT7996_RXQ_MCU_WA_MAIN * MT_RING_SIZE;
 		}
-		dev->mt76.rx_token_size = MT7996_TOKEN_SIZE + wed->wlan.rx_npkt;
 
 		if (dev->hif2 && is_mt7992(&dev->mt76))
 			wed->wlan.id = 0x7992;
@@ -639,9 +621,14 @@ int mt7996_mmio_wed_init(struct mt7996_dev *dev, void *pdev_ptr,
 		wed->wlan.reset_complete = mt76_wed_reset_complete;
 	}
 
-	if (mtk_wed_device_attach(wed)) {
-		dev->mt76.hwrro_mode = MT76_HWRRO_OFF;
+	if (mtk_wed_device_attach(wed))
 		return 0;
+
+	if (!hif2) {
+		dev->mt76.hwrro_mode = is_mt7996(&dev->mt76) ? MT76_HWRRO_V3
+							     : MT76_HWRRO_V3_1;
+		dev->mt76.rx_token_size = MT7996_TOKEN_SIZE +
+					  wed->wlan.rx_npkt;
 	}
 
 	*irq = wed->irq;
-- 
2.53.0

