Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:43434 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752438AbZINIcB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Sep 2009 04:32:01 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 3/4] ath5k: define ath_common ops
Date: Mon, 14 Sep 2009 04:32:02 -0400
Message-Id: <1252917123-11559-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252917123-11559-1-git-send-email-lrodriguez@atheros.com>
References: <1252917123-11559-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only common ath read/write ops go through the common ops.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   16 ++++++++++------
 drivers/net/wireless/ath/ath5k/base.c  |   17 +++++++++++++++++
 drivers/net/wireless/ath/ath5k/base.h  |   11 -----------
 3 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 29ce868..1416562 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1315,17 +1315,21 @@ static inline unsigned int ath5k_hw_clocktoh(unsigned int clock, bool turbo)
 	return turbo ? (clock / 80) : (clock / 40);
 }
 
-/*
- * Read from a register
- */
+static inline struct ath_common *ath5k_hw_common(struct ath5k_hw *ah)
+{
+        return &ah->common;
+}
+
+static inline struct ath_regulatory *ath5k_hw_regulatory(struct ath5k_hw *ah)
+{
+        return &(ath5k_hw_common(ah)->regulatory);
+}
+
 static inline u32 ath5k_hw_reg_read(struct ath5k_hw *ah, u16 reg)
 {
 	return ioread32(ah->ah_iobase + reg);
 }
 
-/*
- * Write to a register
- */
 static inline void ath5k_hw_reg_write(struct ath5k_hw *ah, u32 val, u16 reg)
 {
 	iowrite32(val, ah->ah_iobase + reg);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3cb0752..c78ad55 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -437,6 +437,22 @@ ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
 
 	return name;
 }
+static unsigned int ath5k_ioread32(void *hw_priv, u32 reg_offset)
+{
+	struct ath5k_hw *ah = (struct ath5k_hw *) hw_priv;
+	return ioread32(ah->ah_iobase + reg_offset);
+}
+
+static void ath5k_iowrite32(void *hw_priv, u32 val, u32 reg_offset)
+{
+	struct ath5k_hw *ah = (struct ath5k_hw *) hw_priv;
+	iowrite32(val, ah->ah_iobase + reg_offset);
+}
+
+const static struct ath_ops ath5k_common_ops = {
+	.read = ath5k_ioread32,
+	.write = ath5k_iowrite32,
+};
 
 static int __devinit
 ath5k_pci_probe(struct pci_dev *pdev,
@@ -576,6 +592,7 @@ ath5k_pci_probe(struct pci_dev *pdev,
 	sc->ah->ah_sc = sc;
 	sc->ah->ah_iobase = sc->iobase;
 	common = ath5k_hw_common(sc->ah);
+	common->ops = &ath5k_common_ops;
 	common->cachelsz = csz << 2; /* convert to bytes */
 
 	/* Initialize device */
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 005d25f..b14ba07 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -201,15 +201,4 @@ struct ath5k_softc {
 #define ath5k_hw_hasveol(_ah) \
 	(ath5k_hw_get_capability(_ah, AR5K_CAP_VEOL, 0, NULL) == 0)
 
-static inline struct ath_common *ath5k_hw_common(struct ath5k_hw *ah)
-{
-	return &ah->common;
-}
-
-static inline struct ath_regulatory *ath5k_hw_regulatory(struct ath5k_hw *ah)
-{
-	return &(ath5k_hw_common(ah)->regulatory);
-
-}
-
 #endif
-- 
1.6.3.3

