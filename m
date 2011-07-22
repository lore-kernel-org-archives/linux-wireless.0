Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab1GVNbF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 09:31:05 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: ath9k-devel@venema.h4ckr.net, camilo@mesias.co.uk,
	Jonathan Nieder <jrnieder@gmail.com>,
	Tony Houghton <h@realh.co.uk>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	ath9k-devel@venema.h4ckr.net, Adrian Chadd <adrian@freebsd.org>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [RFC/RFT 2/6] ath9k: remove ->config_pci_powersave() redundant argument
Date: Fri, 22 Jul 2011 15:31:48 +0200
Message-Id: <1311341512-2882-3-git-send-email-sgruszka@redhat.com> (sfid-20110722_153111_932422_216FD9E8)
In-Reply-To: <1311341512-2882-1-git-send-email-sgruszka@redhat.com>
References: <1311341512-2882-1-git-send-email-sgruszka@redhat.com>
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
 drivers/net/wireless/ath/ath9k/hw.c        |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h        |    3 +--
 drivers/net/wireless/ath/ath9k/main.c      |    6 +++---
 6 files changed, 11 insertions(+), 15 deletions(-)

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
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6bda08e..4ef7313 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -597,7 +597,7 @@ static int __ath9k_hw_init(struct ath_hw *ah)
 
 
 	if (ah->is_pciexpress)
-		ath9k_hw_configpcipowersave(ah, 0, 0);
+		ath9k_hw_configpcipowersave(ah, false);
 	else
 		ath9k_hw_disablepcie(ah);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 7dd78e7..2f25577 100644
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
-- 
1.7.1

