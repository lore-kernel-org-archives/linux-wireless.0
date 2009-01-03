Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix.szarvasnet.hu ([87.101.127.3]:48807 "EHLO
	phoenix.szarvas.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757832AbZACNoy (ORCPT
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
Subject: [RFC 02/12] ath9k: introduce bus specific register access routines
Date: Sat,  3 Jan 2009 14:44:12 +0100
Message-Id: <1230990262-22923-3-git-send-email-juhosg@openwrt.org> (sfid-20090103_144459_792446_76BD06E3)
In-Reply-To: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
References: <1230990262-22923-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The AHB bus will require different code for register access, so we make
them replaceable as well.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
---
 drivers/net/wireless/ath9k/ath9k.h |    4 ++--
 drivers/net/wireless/ath9k/core.h  |   17 +++++++++++++++++
 drivers/net/wireless/ath9k/main.c  |   13 +++++++++++++
 3 files changed, 32 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index d278135..dc9b260 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -587,8 +587,8 @@ struct ath9k_country_entry {
 	u8 iso[3];
 };
 
-#define REG_WRITE(_ah, _reg, _val) iowrite32(_val, _ah->ah_sh + _reg)
-#define REG_READ(_ah, _reg) ioread32(_ah->ah_sh + _reg)
+#define REG_WRITE(_ah, _reg, _val) 	ath_reg_write(_ah, _reg, _val)
+#define REG_READ(_ah, _reg) 		ath_reg_read(_ah, _reg)
 
 #define SM(_v, _f)  (((_v) << _f##_S) & _f)
 #define MS(_v, _f)  (((_v) & _f) >> _f##_S)
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index de50e47..db7ae4e 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -718,6 +718,9 @@ struct ath_bus_ops {
 				    size_t size,
 				    void *p,
 				    dma_addr_t da);
+
+	u32		(*reg_read)(struct ath_hal *ah, unsigned reg);
+	void		(*reg_write)(struct ath_hal *ah, unsigned reg, u32 val);
 };
 
 struct ath_softc {
@@ -826,4 +829,18 @@ static inline void ath_dma_free(struct ath_softc *sc, size_t size,
 	sc->bus_ops->dma_free(sc, size, p, da);
 }
 
+static inline u32 ath_reg_read(struct ath_hal *ah, unsigned reg)
+{
+	struct ath_softc *sc = ah->ah_sc;
+
+	return sc->bus_ops->reg_read(ah, reg);
+}
+
+static inline void ath_reg_write(struct ath_hal *ah, unsigned reg, u32 val)
+{
+	struct ath_softc *sc = ah->ah_sc;
+
+	sc->bus_ops->reg_write(ah, reg, val);
+}
+
 #endif /* CORE_H */
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 62a0a5b..9ce89b4 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -2595,6 +2595,16 @@ static void ath_pci_dma_free(struct ath_softc *sc, size_t size,
 	pci_free_consistent(sc->pdev, size, p, da);
 }
 
+static u32 ath_pci_reg_read(struct ath_hal *ah, unsigned reg)
+{
+	return ioread32(ah->ah_sh + reg);
+}
+
+static void ath_pci_reg_write(struct ath_hal *ah, unsigned reg, u32 val)
+{
+	iowrite32(val, ah->ah_sh + reg);
+}
+
 static struct ath_bus_ops ath_pci_bus_ops  = {
 	.dma_map_single_to_device = ath_pci_map_single_to_device,
 	.dma_unmap_single_to_device = ath_pci_unmap_single_to_device,
@@ -2605,6 +2615,9 @@ static struct ath_bus_ops ath_pci_bus_ops  = {
 	.dma_sync_single_for_cpu = ath_pci_sync_single_for_cpu,
 	.dma_alloc = ath_pci_dma_alloc,
 	.dma_free = ath_pci_dma_free,
+
+	.reg_read = ath_pci_reg_read,
+	.reg_write = ath_pci_reg_write,
 };
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
1.5.3.2

