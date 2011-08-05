Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60754 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754370Ab1HELLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 07:11:20 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	<lrodriguez@atheros.com>
Subject: [PATCH -next 1/8] ath9k: remove ->config_pci_powersave() redundant argument
Date: Fri,  5 Aug 2011 13:10:32 +0200
Message-Id: <1312542639-4274-2-git-send-email-sgruszka@redhat.com> (sfid-20110805_131122_643270_4024A988)
In-Reply-To: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
References: <1312542639-4274-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We always call ->config_pci_powersave() with both restore and power_off
arguments equal to 0 or both equal to 1, so merge them into one
argument.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ath/ath9k/ar9002_hw.c |    5 ++---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    5 ++---
 drivers/net/wireless/ath/ath9k/hw-ops.h    |    5 ++---
 drivers/net/wireless/ath/ath9k/hw.h        |    3 +--
 drivers/net/wireless/ath/ath9k/main.c      |    6 +++---
 drivers/net/wireless/ath/ath9k/pci.c       |    3 ++-
 6 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_hw.c b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
index 44d9d8d..70a18d1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_hw.c
@@ -303,8 +303,7 @@ static void ar9002_hw_init_mode_gain_regs(struct ath_hw *ah)
  * register as the other analog registers.  Hence the 9 writes.
  */
 static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
-					 int restore,
-					 int power_off)
+					 bool power_off)
 {
 	u8 i;
 	u32 val;
@@ -313,7 +312,7 @@ static void ar9002_hw_configpcipowersave(struct ath_hw *ah,
 		return;
 
 	/* Nothing to do on restore for 11N */
-	if (!restore) {
+	if (!power_off /* !restore */) {
 		if (AR_SREV_9280_20_OR_LATER(ah)) {
 			/*
 			 * AR9280 2.0 or later chips use SerDes values from the
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index ad2bb2b..e3d58bd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -516,14 +516,13 @@ static void ar9003_hw_init_mode_gain_regs(struct ath_hw *ah)
  * register as the other analog registers.  Hence the 9 writes.
  */
 static void ar9003_hw_configpcipowersave(struct ath_hw *ah,
-					 int restore,
-					 int power_off)
+					 bool power_off)
 {
 	if (ah->is_pciexpress != true || ah->aspm_enabled != true)
 		return;
 
 	/* Nothing to do on restore for 11N */
-	if (!restore) {
+	if (!power_off /* !restore */) {
 		/* set bit 19 to allow forcing of pcie core into L1 state */
 		REG_SET_BIT(ah, AR_PCIE_PM_CTRL, AR_PCIE_PM_CTRL_ENA);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw-ops.h b/drivers/net/wireless/ath/ath9k/hw-ops.h
index cb29e88..8c12385 100644
--- a/drivers/net/wireless/ath/ath9k/hw-ops.h
+++ b/drivers/net/wireless/ath/ath9k/hw-ops.h
@@ -22,10 +22,9 @@
 /* Hardware core and driver accessible callbacks */
 
 static inline void ath9k_hw_configpcipowersave(struct ath_hw *ah,
-					       int restore,
-					       int power_off)
+					       bool power_off)
 {
-	ath9k_hw_ops(ah)->config_pci_powersave(ah, restore, power_off);
+	ath9k_hw_ops(ah)->config_pci_powersave(ah, power_off);
 }
 
 static inline void ath9k_hw_rxena(struct ath_hw *ah)
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index c798890..a26a8c5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -601,8 +601,7 @@ struct ath_hw_private_ops {
  */
 struct ath_hw_ops {
 	void (*config_pci_powersave)(struct ath_hw *ah,
-				     int restore,
-				     int power_off);
+				     bool power_off);
 	void (*rx_enable)(struct ath_hw *ah);
 	void (*set_desc_link)(void *ds, u32 link);
 	bool (*calibrate)(struct ath_hw *ah,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9098aaa..651f633 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -887,7 +887,7 @@ static void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 	ath9k_ps_wakeup(sc);
 	spin_lock_bh(&sc->sc_pcu_lock);
 
-	ath9k_hw_configpcipowersave(ah, 0, 0);
+	ath9k_hw_configpcipowersave(ah, false);
 
 	if (!ah->curchan)
 		ah->curchan = ath9k_cmn_get_curchannel(sc->hw, ah);
@@ -967,7 +967,7 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	ath9k_hw_phy_disable(ah);
 
-	ath9k_hw_configpcipowersave(ah, 1, 1);
+	ath9k_hw_configpcipowersave(ah, true);
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 	ath9k_ps_restore(sc);
@@ -1066,7 +1066,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	init_channel = ath9k_cmn_get_curchannel(hw, ah);
 
 	/* Reset SERDES registers */
-	ath9k_hw_configpcipowersave(ah, 0, 0);
+	ath9k_hw_configpcipowersave(ah, false);
 
 	/*
 	 * The basic interface to setting the hardware in a good
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index be4ea13..8256e97 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -35,6 +35,7 @@ static DEFINE_PCI_DEVICE_TABLE(ath_pci_id_table) = {
 	{ 0 }
 };
 
+
 /* return bus cachesize in 4B word units */
 static void ath_pci_read_cachesize(struct ath_common *common, int *csz)
 {
@@ -137,7 +138,7 @@ static void ath_pci_aspm_init(struct ath_common *common)
 	if (aspm & (PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1)) {
 		ah->aspm_enabled = true;
 		/* Initialize PCIe PM and SERDES registers. */
-		ath9k_hw_configpcipowersave(ah, 0, 0);
+		ath9k_hw_configpcipowersave(ah, false);
 	}
 }
 
-- 
1.7.1

