Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:39990 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160AbZAIMZv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Jan 2009 07:25:51 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Christoph Hellwig <hch@infradead.org>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [PATCH v2 03/11] ath9k: introduce bus specific cache size routine
Date: Fri,  9 Jan 2009 13:24:20 +0100
Message-Id: <1231503868-29226-4-git-send-email-juhosg@openwrt.org> (sfid-20090109_132601_516008_45DD1CD5)
In-Reply-To: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
References: <1231503868-29226-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCI specific bus_read_cachesize routine won't work on the AHB bus,
we have to replace it with a suitable one later.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/core.h |   10 ++++++++++
 drivers/net/wireless/ath9k/main.c |    9 +++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 2256ba4..8e93d11 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -693,6 +693,10 @@ enum PROT_MODE {
 #define SC_OP_RFKILL_SW_BLOCKED	BIT(12)
 #define SC_OP_RFKILL_HW_BLOCKED	BIT(13)
 
+struct ath_bus_ops {
+	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
+};
+
 struct ath_softc {
 	struct ieee80211_hw *hw;
 	struct device *dev;
@@ -743,6 +747,7 @@ struct ath_softc {
 #ifdef CONFIG_ATH9K_DEBUG
 	struct ath9k_debug sc_debug;
 #endif
+	struct ath_bus_ops *bus_ops;
 };
 
 int ath_reset(struct ath_softc *sc, bool retry_tx);
@@ -750,4 +755,9 @@ int ath_get_hal_qnum(u16 queue, struct ath_softc *sc);
 int ath_get_mac80211_qnum(u32 queue, struct ath_softc *sc);
 int ath_cabq_update(struct ath_softc *);
 
+static inline void ath_read_cachesize(struct ath_softc *sc, int *csz)
+{
+	sc->bus_ops->read_cachesize(sc, csz);
+}
+
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 9acd968..15824c1 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -42,7 +42,7 @@ static void ath_detach(struct ath_softc *sc);
 
 /* return bus cachesize in 4B word units */
 
-static void bus_read_cachesize(struct ath_softc *sc, int *csz)
+static void ath_pci_read_cachesize(struct ath_softc *sc, int *csz)
 {
 	u8 u8tmp;
 
@@ -1338,7 +1338,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	 * Cache line size is used to size and align various
 	 * structures used to communicate with the hardware.
 	 */
-	bus_read_cachesize(sc, &csz);
+	ath_read_cachesize(sc, &csz);
 	/* XXX assert csz is non-zero */
 	sc->sc_cachelsz = csz << 2;	/* convert to bytes */
 
@@ -2529,6 +2529,10 @@ ath_rf_name(u16 rf_version)
 	return "????";
 }
 
+static struct ath_bus_ops ath_pci_bus_ops = {
+	.read_cachesize = ath_pci_read_cachesize,
+};
+
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
 	void __iomem *mem;
@@ -2617,6 +2621,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->hw = hw;
 	sc->dev = &pdev->dev;
 	sc->mem = mem;
+	sc->bus_ops = &ath_pci_bus_ops;
 
 	if (ath_attach(id->device, sc) != 0) {
 		ret = -ENODEV;
-- 
1.5.3.2

