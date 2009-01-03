Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:48821 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758357AbZACNoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 08:44:54 -0500
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>,
	Gabor Juhos <juhosg@openwrt.org>,
	Imre Kaloz <kaloz@openwrt.org>
Subject: [RFC 03/12] ath9k: introduce bus specific cache size routine
Date: Sat,  3 Jan 2009 14:44:13 +0100
Message-Id: <1230990262-22923-4-git-send-email-juhosg@openwrt.org> (sfid-20090103_144501_630582_7CCAB4F6)
In-Reply-To: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The PCI specific bus_read_cachesize routine won't work on the AHB bus,
we have to replace it with a suitable one later.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/core.h |    7 +++++++
 drivers/net/wireless/ath9k/main.c |    8 +++++---
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index db7ae4e..0c8064e 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -721,6 +721,8 @@ struct ath_bus_ops {
 
 	u32		(*reg_read)(struct ath_hal *ah, unsigned reg);
 	void		(*reg_write)(struct ath_hal *ah, unsigned reg, u32 val);
+
+	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
 };
 
 struct ath_softc {
@@ -843,4 +845,9 @@ static inline void ath_reg_write(struct ath_hal *ah, unsigned reg, u32 val)
 	sc->bus_ops->reg_write(ah, reg, val);
 }
 
+static inline void ath_read_cachesize(struct ath_softc *sc, int *csz)
+{
+	sc->bus_ops->read_cachesize(sc, csz);
+}
+
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 9ce89b4..f1da1ac 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -41,8 +41,7 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 static void ath_detach(struct ath_softc *sc);
 
 /* return bus cachesize in 4B word units */
-
-static void bus_read_cachesize(struct ath_softc *sc, int *csz)
+static void ath_pci_read_cachesize(struct ath_softc *sc, int *csz)
 {
 	u8 u8tmp;
 
@@ -59,6 +58,7 @@ static void bus_read_cachesize(struct ath_softc *sc, int *csz)
 		*csz = DEFAULT_CACHELINE >> 2;   /* Use the default size */
 }
 
+
 static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
 {
 	sc->cur_rate_table = sc->hw_rate_table[mode];
@@ -1347,7 +1347,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	 * Cache line size is used to size and align various
 	 * structures used to communicate with the hardware.
 	 */
-	bus_read_cachesize(sc, &csz);
+	ath_read_cachesize(sc, &csz);
 	/* XXX assert csz is non-zero */
 	sc->sc_cachelsz = csz << 2;	/* convert to bytes */
 
@@ -2618,6 +2618,8 @@ static struct ath_bus_ops ath_pci_bus_ops  = {
 
 	.reg_read = ath_pci_reg_read,
 	.reg_write = ath_pci_reg_write,
+
+	.read_cachesize = ath_pci_read_cachesize,
 };
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
1.5.3.2

