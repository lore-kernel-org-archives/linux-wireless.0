Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38483 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753505AbZIJTaY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:30:24 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 09/10] ath5k: move ath_common to ath5k_hw
Date: Thu, 10 Sep 2009 15:30:26 -0400
Message-Id: <1252611027-5285-10-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
References: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 ++
 drivers/net/wireless/ath/ath5k/base.c  |   21 +++++++++++++--------
 drivers/net/wireless/ath/ath5k/base.h  |    3 +--
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index f46a92e..fee16fd 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -35,6 +35,7 @@
  * TODO: Make a more generic struct (eg. add more stuff to ath5k_capabilities)
  * and clean up common bits, then introduce set/get functions in eeprom.c */
 #include "eeprom.h"
+#include "../ath.h"
 
 /* PCI IDs */
 #define PCI_DEVICE_ID_ATHEROS_AR5210 		0x0007 /* AR5210 */
@@ -1020,6 +1021,7 @@ struct ath5k_capabilities {
 /* TODO: Clean up and merge with ath5k_softc */
 struct ath5k_hw {
 	u32			ah_magic;
+	struct ath_common       common;
 
 	struct ath5k_softc	*ah_sc;
 	void __iomem		*ah_iobase;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index efee68c..06fc893 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -444,6 +444,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 {
 	void __iomem *mem;
 	struct ath5k_softc *sc;
+	struct ath_common *common;
 	struct ieee80211_hw *hw;
 	int ret;
 	u8 csz;
@@ -547,7 +548,6 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	__set_bit(ATH_STAT_INVALID, sc->status);
 
 	sc->iobase = mem; /* So we can unmap it on detach */
-	sc->common.cachelsz = csz << 2; /* convert to bytes */
 	sc->opmode = NL80211_IFTYPE_STATION;
 	sc->bintval = 1000;
 	mutex_init(&sc->lock);
@@ -572,6 +572,9 @@ ath5k_pci_probe(struct pci_dev *pdev,
 		goto err_irq;
 	}
 
+	common = ath5k_hw_common(sc->ah);
+	common->cachelsz = csz << 2; /* convert to bytes */
+
 	/* set up multi-rate retry capabilities */
 	if (sc->ah->ah_version == AR5K_AR5212) {
 		hw->max_rates = 4;
@@ -718,7 +721,7 @@ static int ath5k_reg_notifier(struct wiphy *wiphy, struct regulatory_request *re
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ath5k_softc *sc = hw->priv;
-	struct ath_regulatory *regulatory = &sc->common.regulatory;
+	struct ath_regulatory *regulatory = ath5k_hw_regulatory(sc->ah);
 
 	return ath_reg_notifier_apply(wiphy, request, regulatory);
 }
@@ -728,7 +731,7 @@ ath5k_attach(struct pci_dev *pdev, struct ieee80211_hw *hw)
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ath5k_hw *ah = sc->ah;
-	struct ath_regulatory *regulatory = &sc->common.regulatory;
+	struct ath_regulatory *regulatory = ath5k_hw_regulatory(ah);
 	u8 mac[ETH_ALEN] = {};
 	int ret;
 
@@ -1153,19 +1156,20 @@ ath5k_hw_to_driver_rix(struct ath5k_softc *sc, int hw_rix)
 static
 struct sk_buff *ath5k_rx_skb_alloc(struct ath5k_softc *sc, dma_addr_t *skb_addr)
 {
+	struct ath_common *common = ath5k_hw_common(sc->ah);
 	struct sk_buff *skb;
 
 	/*
 	 * Allocate buffer with headroom_needed space for the
 	 * fake physical layer header at the start.
 	 */
-	skb = ath_rxbuf_alloc(&sc->common,
-			      sc->rxbufsize + sc->common.cachelsz - 1,
+	skb = ath_rxbuf_alloc(common,
+			      sc->rxbufsize + common->cachelsz - 1,
 			      GFP_ATOMIC);
 
 	if (!skb) {
 		ATH5K_ERR(sc, "can't alloc skbuff of size %u\n",
-				sc->rxbufsize + sc->common.cachelsz - 1);
+				sc->rxbufsize + common->cachelsz - 1);
 		return NULL;
 	}
 
@@ -1606,13 +1610,14 @@ static int
 ath5k_rx_start(struct ath5k_softc *sc)
 {
 	struct ath5k_hw *ah = sc->ah;
+	struct ath_common *common = ath5k_hw_common(ah);
 	struct ath5k_buf *bf;
 	int ret;
 
-	sc->rxbufsize = roundup(IEEE80211_MAX_LEN, sc->common.cachelsz);
+	sc->rxbufsize = roundup(IEEE80211_MAX_LEN, common->cachelsz);
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "cachelsz %u rxbufsize %u\n",
-		sc->common.cachelsz, sc->rxbufsize);
+		common->cachelsz, sc->rxbufsize);
 
 	spin_lock_bh(&sc->rxbuflock);
 	sc->rxlink = NULL;
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index a28c42f..005d25f 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -115,7 +115,6 @@ struct ath5k_rfkill {
  * associated with an instance of a device */
 struct ath5k_softc {
 	struct pci_dev		*pdev;		/* for dma mapping */
-	struct ath_common	common;
 	void __iomem		*iobase;	/* address of the device */
 	struct mutex		lock;		/* dev-level lock */
 	struct ieee80211_tx_queue_stats tx_stats[AR5K_NUM_TX_QUEUES];
@@ -204,7 +203,7 @@ struct ath5k_softc {
 
 static inline struct ath_common *ath5k_hw_common(struct ath5k_hw *ah)
 {
-	return &ah->ah_sc->common;
+	return &ah->common;
 }
 
 static inline struct ath_regulatory *ath5k_hw_regulatory(struct ath5k_hw *ah)
-- 
1.6.3.3

