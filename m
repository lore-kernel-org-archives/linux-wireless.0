Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:11519 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406AbXKAEf0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Nov 2007 00:35:26 -0400
Received: by an-out-0708.google.com with SMTP id b36so57682ana
        for <linux-wireless@vger.kernel.org>; Wed, 31 Oct 2007 21:35:25 -0700 (PDT)
Date: Thu, 1 Nov 2007 00:35:20 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCH 2/7] ath5k: Remove opaque pointers from ath5k_hw_attach()
Message-ID: <20071101043520.GC21987@pogo> (sfid-20071101_043529_197409_4929F0E7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since we don't have a HAL anymore there is no point to use opaque pointers
in ath5k_hw_attach(). This will also give hw.c access to ath5k_softc
structure now when needed. While we're at it, lets also give some ah_sh
a reasonable name, ah_sh --> ah_iobase.

Changes to base.c
Changes-licensed-under: 3-clause-BSD

Changes to ath5k.h, hw.c
Changes-licensed-under: ISC

Signed-off-by: Luis R. Rodriguez <mcgrof@gmail.com>
---
 drivers/net/wireless/ath5k/ath5k.h |   10 +++++-----
 drivers/net/wireless/ath5k/base.c  |    2 +-
 drivers/net/wireless/ath5k/hw.c    |   11 +++++------
 3 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 4122466..20567b1 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -943,8 +943,8 @@ struct ath5k_capabilities {
 struct ath5k_hw {
 	u32			ah_magic;
 
-	void			*ah_sc;
-	void __iomem		*ah_sh;
+	struct ath5k_softc	*ah_sc;
+	void __iomem		*ah_iobase;
 
 	enum ath5k_int		ah_imr;
 
@@ -1042,7 +1042,7 @@ struct ath5k_hw {
 /* General Functions */
 extern int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val, bool is_set);
 /* Attach/Detach Functions */
-extern struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc, void __iomem *sh);
+extern struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version);
 extern const struct ath5k_rate_table *ath5k_hw_get_rate_table(struct ath5k_hw *ah, unsigned int mode);
 extern void ath5k_hw_detach(struct ath5k_hw *ah);
 /* Reset Functions */
@@ -1151,12 +1151,12 @@ extern int ath5k_hw_set_txpower_limit(struct ath5k_hw *ah, unsigned int power);
 
 static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
 {
-	return ioread32(ah->ah_sh + reg);
+	return ioread32(ah->ah_iobase + reg);
 }
 
 static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 {
-	iowrite32(val, ah->ah_sh + reg);
+	iowrite32(val, ah->ah_iobase + reg);
 }
 
 #endif
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index 4b4ddf4..15ae868 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -559,7 +559,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* Initialize device */
-	sc->ah = ath5k_hw_attach(pdev->device, id->driver_data, sc, sc->iobase);
+	sc->ah = ath5k_hw_attach(sc, id->driver_data);
 	if (IS_ERR(sc->ah)) {
 		ret = PTR_ERR(sc->ah);
 		goto err_irq;
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index 8ac88e7..320e32e 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -27,8 +27,8 @@
 #include <linux/pci.h>
 #include <linux/delay.h>
 
-#include "ath5k.h"
 #include "reg.h"
+#include "base.h"
 
 /*Rate tables*/
 static const struct ath5k_rate_table ath5k_rt_11a = AR5K_RATES_11A;
@@ -187,8 +187,7 @@ int ath5k_hw_register_timeout(struct ath5k_hw *ah, u32 reg, u32 flag, u32 val,
 /*
  * Check if the device is supported and initialize the needed structs
  */
-struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
-		void __iomem *sh)
+struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 {
 	struct ath5k_hw *ah;
 	u8 mac[ETH_ALEN];
@@ -204,7 +203,7 @@ struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 	}
 
 	ah->ah_sc = sc;
-	ah->ah_sh = sh;
+	ah->ah_iobase = sc->iobase;
 
 	/*
 	 * HW information
@@ -323,7 +322,7 @@ struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 	ret = ath5k_hw_get_capabilities(ah);
 	if (ret) {
 		AR5K_PRINTF("unable to get device capabilities: 0x%04x\n",
-			device);
+			sc->pdev->device);
 		goto err_free;
 	}
 
@@ -331,7 +330,7 @@ struct ath5k_hw *ath5k_hw_attach(u16 device, u8 mac_version, void *sc,
 	ret = ath5k_eeprom_read_mac(ah, mac);
 	if (ret) {
 		AR5K_PRINTF("unable to read address from EEPROM: 0x%04x\n",
-			device);
+			sc->pdev->device);
 		goto err_free;
 	}
 
-- 
1.5.2.5

