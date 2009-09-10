Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:38513 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753556AbZIJTa3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 15:30:29 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Stephen Chen <stephen.chen@atheros.com>,
	Zhifeng Cai <zhifeng.cai@atheros.com>
Subject: [PATCH 10/10] ath9k: Define bus agnostic bluetooth coex prep helper
Date: Thu, 10 Sep 2009 15:30:27 -0400
Message-Id: <1252611027-5285-11-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
References: <1252611027-5285-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We disable ASPM when enabling bluetooth coexistance. Disabling
ASPM is a bus specific operation. In the future other buses may
support bluetooth coexistance, an example is USB. To this end
move the current routine which disables ASPM into pci.c, and declare
it the PCI bt_coex_prep() helper. Additionally, since ASPM is
a PCI-Express primitive ensure we don't ever try to muck with ASPM
registers on non PCI-express devices.

This also cleans up hw.c to not include bus specific headers or
utilities.

Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Stephen Chen <stephen.chen@atheros.com>
Cc: Zhifeng Cai <zhifeng.cai@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c    |   14 --------------
 drivers/net/wireless/ath/ath9k/hw.h    |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |    3 ++-
 drivers/net/wireless/ath/ath9k/pci.c   |   17 +++++++++++++++++
 5 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0c64c80..0962505 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -545,6 +545,7 @@ struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
 	void		(*cleanup)(struct ath_softc *sc);
 	bool		(*eeprom_read)(struct ath_hw *ah, u32 off, u16 *data);
+	void		(*bt_coex_prep)(struct ath_softc *sc);
 };
 
 struct ath_wiphy;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 234decc..5436244 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -16,7 +16,6 @@
 
 #include <linux/io.h>
 #include <asm/unaligned.h>
-#include <linux/pci.h>
 
 #include "hw.h"
 #include "ath9k.h"
@@ -4254,16 +4253,3 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 		timer->trigger(timer->arg);
 	}
 }
-
-/*
- * Primitive to disable ASPM
- */
-void ath_pcie_aspm_disable(struct ath_softc *sc)
-{
-	struct pci_dev *pdev = to_pci_dev(sc->dev);
-	u8 aspm;
-
-	pci_read_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, &aspm);
-	aspm &= ~(ATH_PCIE_CAP_LINK_L0S | ATH_PCIE_CAP_LINK_L1);
-	pci_write_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, aspm);
-}
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4f58908..84deae4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -679,5 +679,4 @@ u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 #define ATH_PCIE_CAP_LINK_L0S	1
 #define ATH_PCIE_CAP_LINK_L1	2
 
-void ath_pcie_aspm_disable(struct ath_softc *sc);
 #endif
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2423cdc..b530e47 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2245,7 +2245,8 @@ static int ath9k_start(struct ieee80211_hw *hw)
 					   AR_STOMP_LOW_WLAN_WGHT);
 		ath9k_hw_btcoex_enable(ah);
 
-		ath_pcie_aspm_disable(sc);
+		if (sc->bus_ops->bt_coex_prep)
+			sc->bus_ops->bt_coex_prep(sc);
 		if (ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 			ath9k_btcoex_timer_resume(sc);
 	}
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 903dd8a..f59d224 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -75,10 +75,27 @@ static bool ath_pci_eeprom_read(struct ath_hw *ah, u32 off, u16 *data)
 	return true;
 }
 
+/*
+ * Bluetooth coexistance requires disabling ASPM.
+ */
+static void ath_pci_bt_coex_prep(struct ath_softc *sc)
+{
+	struct pci_dev *pdev = to_pci_dev(sc->dev);
+	u8 aspm;
+
+	if (!pdev->is_pcie)
+		return;
+
+	pci_read_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, &aspm);
+	aspm &= ~(ATH_PCIE_CAP_LINK_L0S | ATH_PCIE_CAP_LINK_L1);
+	pci_write_config_byte(pdev, ATH_PCIE_CAP_LINK_CTRL, aspm);
+}
+
 static struct ath_bus_ops ath_pci_bus_ops = {
 	.read_cachesize = ath_pci_read_cachesize,
 	.cleanup = ath_pci_cleanup,
 	.eeprom_read = ath_pci_eeprom_read,
+	.bt_coex_prep = ath_pci_bt_coex_prep,
 };
 
 static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
-- 
1.6.3.3

