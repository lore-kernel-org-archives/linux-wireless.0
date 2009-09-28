Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:48678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751707AbZI1Gyi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 02:54:38 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, devel@linuxdriverproject.org,
	ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH] atheros: define a common priv struct
Date: Mon, 28 Sep 2009 02:54:40 -0400
Message-Id: <1254120880-12415-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hw code should never use private driver data, but
sometimes we need a backpointer so just stuff it on
the common ath struct.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---

With this and some changes to ath9k_htc we can now start
talking to the target on ar9271. I'll synch up ath9k_htc
git tree with these changes, if you compile your kernel
with all pending patches + this one you should be able
to start playing with ath9k_htc -- oh and a new firmware
was needed, seems I had a dud firmware file. I'll update
that soon also on the athfw2lnx.git tree:

git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/athfw2lnx.git

 drivers/net/wireless/ath/ath.h         |    1 +
 drivers/net/wireless/ath/ath9k/debug.c |    7 +++--
 drivers/net/wireless/ath/ath9k/hw.h    |    1 -
 drivers/net/wireless/ath/ath9k/main.c  |   37 +++++++++++++++++++------------
 drivers/net/wireless/ath/ath9k/pci.c   |    9 ++-----
 5 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index e0341fe..b6cd752 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -56,6 +56,7 @@ struct ath_bus_ops {
 
 struct ath_common {
 	void *ah;
+	void *priv;
 	struct ieee80211_hw *hw;
 	int debug_mask;
 
diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 352914c..25ae88e 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -562,8 +562,8 @@ static const struct file_operations fops_xmit = {
 
 int ath9k_init_debug(struct ath_hw *ah)
 {
-	struct ath_softc *sc = ah->ah_sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
 
 	common->debug_mask = ath9k_debug;
 
@@ -620,7 +620,8 @@ err:
 
 void ath9k_exit_debug(struct ath_hw *ah)
 {
-	struct ath_softc *sc = ah->ah_sc;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
 
 	debugfs_remove(sc->debug.debugfs_xmit);
 	debugfs_remove(sc->debug.debugfs_wiphy);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index f782c1a..cdaec52 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -450,7 +450,6 @@ struct ath_gen_timer_table {
 
 struct ath_hw {
 	struct ieee80211_hw *hw;
-	struct ath_softc *ah_sc;
 	struct ath_common common;
 	struct ath9k_hw_version hw_version;
 	struct ath9k_ops_config config;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2278dcb..86374ad 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1438,17 +1438,22 @@ static void ath9k_gen_timer_start(struct ath_hw *ah,
 				  u32 timer_next,
 				  u32 timer_period)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
+
 	ath9k_hw_gen_timer_start(ah, timer, timer_next, timer_period);
 
-	if ((ah->ah_sc->imask & ATH9K_INT_GENTIMER) == 0) {
+	if ((sc->imask & ATH9K_INT_GENTIMER) == 0) {
 		ath9k_hw_set_interrupts(ah, 0);
-		ah->ah_sc->imask |= ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah, ah->ah_sc->imask);
+		sc->imask |= ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah, sc->imask);
 	}
 }
 
 static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
 	struct ath_gen_timer_table *timer_table = &ah->hw_gen_timers;
 
 	ath9k_hw_gen_timer_stop(ah, timer);
@@ -1456,8 +1461,8 @@ static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 	/* if no timer is enabled, turn off interrupt mask */
 	if (timer_table->timer_mask.val == 0) {
 		ath9k_hw_set_interrupts(ah, 0);
-		ah->ah_sc->imask &= ~ATH9K_INT_GENTIMER;
-		ath9k_hw_set_interrupts(ah, ah->ah_sc->imask);
+		sc->imask &= ~ATH9K_INT_GENTIMER;
+		ath9k_hw_set_interrupts(ah, sc->imask);
 	}
 }
 
@@ -1554,28 +1559,32 @@ static int ath_init_btcoex_timer(struct ath_softc *sc)
 static void ath9k_iowrite32(void *hw_priv, u32 val, u32 reg_offset)
 {
 	struct ath_hw *ah = (struct ath_hw *) hw_priv;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
 
 	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
 		unsigned long flags;
-		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
-		iowrite32(val, ah->ah_sc->mem + reg_offset);
-		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
+		spin_lock_irqsave(&sc->sc_serial_rw, flags);
+		iowrite32(val, sc->mem + reg_offset);
+		spin_unlock_irqrestore(&sc->sc_serial_rw, flags);
 	} else
-		iowrite32(val, ah->ah_sc->mem + reg_offset);
+		iowrite32(val, sc->mem + reg_offset);
 }
 
 static unsigned int ath9k_ioread32(void *hw_priv, u32 reg_offset)
 {
 	struct ath_hw *ah = (struct ath_hw *) hw_priv;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
 	u32 val;
 
 	if (ah->config.serialize_regmode == SER_REG_MODE_ON) {
 		unsigned long flags;
-		spin_lock_irqsave(&ah->ah_sc->sc_serial_rw, flags);
-		val = ioread32(ah->ah_sc->mem + reg_offset);
-		spin_unlock_irqrestore(&ah->ah_sc->sc_serial_rw, flags);
+		spin_lock_irqsave(&sc->sc_serial_rw, flags);
+		val = ioread32(sc->mem + reg_offset);
+		spin_unlock_irqrestore(&sc->sc_serial_rw, flags);
 	} else
-		val = ioread32(ah->ah_sc->mem + reg_offset);
+		val = ioread32(sc->mem + reg_offset);
 	return val;
 }
 
@@ -1618,7 +1627,6 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 		goto bad_no_ah;
 	}
 
-	ah->ah_sc = sc;
 	ah->hw_version.devid = devid;
 	ah->hw_version.subsysid = subsysid;
 	sc->sc_ah = ah;
@@ -1628,6 +1636,7 @@ static int ath_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	common->bus_ops = bus_ops;
 	common->ah = ah;
 	common->hw = sc->hw;
+	common->priv = sc;
 
 	/*
 	 * Cache line size is used to size and align various
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index b2a45ce..63059b6 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -33,8 +33,7 @@ static struct pci_device_id ath_pci_id_table[] __devinitdata = {
 /* return bus cachesize in 4B word units */
 static void ath_pci_read_cachesize(struct ath_common *common, int *csz)
 {
-	struct ath_hw *ah = (struct ath_hw *) common->ah;
-	struct ath_softc *sc = ah->ah_sc;
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
 	u8 u8tmp;
 
 	pci_read_config_byte(to_pci_dev(sc->dev), PCI_CACHE_LINE_SIZE, &u8tmp);
@@ -52,8 +51,7 @@ static void ath_pci_read_cachesize(struct ath_common *common, int *csz)
 
 static void ath_pci_cleanup(struct ath_common *common)
 {
-	struct ath_hw *ah = (struct ath_hw *) common->ah;
-	struct ath_softc *sc = ah->ah_sc;
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
 
 	pci_iounmap(pdev, sc->mem);
@@ -86,8 +84,7 @@ static bool ath_pci_eeprom_read(struct ath_common *common, u32 off, u16 *data)
  */
 static void ath_pci_bt_coex_prep(struct ath_common *common)
 {
-	struct ath_hw *ah = (struct ath_hw *) common->ah;
-	struct ath_softc *sc = ah->ah_sc;
+	struct ath_softc *sc = (struct ath_softc *) common->priv;
 	struct pci_dev *pdev = to_pci_dev(sc->dev);
 	u8 aspm;
 
-- 
1.6.3.3

