Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55679 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbZJZOi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 10:38:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 2/4] ath9k_hw: distinguish single-chip solutions on initial probe print
Date: Mon, 26 Oct 2009 10:38:59 -0400
Message-Id: <1256567941-26859-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
References: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Devices with external radios have revisions which we can count on.
On single chip solutions these EEPROM values for these radio revision
also exist but are not meaningful as the radios are embedded onto the
same chip. Each single-chip device evolves together as one device.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c |   11 ++++-------
 drivers/net/wireless/ath/ath9k/hw.c  |   27 +++++++++++++++++++++++----
 drivers/net/wireless/ath/ath9k/hw.h  |    3 +--
 drivers/net/wireless/ath/ath9k/pci.c |   11 ++++-------
 4 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 41422c4..925818c 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -69,6 +69,7 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	int irq;
 	int ret = 0;
 	struct ath_hw *ah;
+	char hw_name[1024];
 
 	if (!pdev->dev.platform_data) {
 		dev_err(&pdev->dev, "no platform data specified\n");
@@ -133,15 +134,11 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	}
 
 	ah = sc->sc_ah;
+	ath9k_hw_name(ah, hw_name);
 	printk(KERN_INFO
-	       "%s: Atheros AR%s MAC/BB Rev:%x, "
-	       "AR%s RF Rev:%x, mem=0x%lx, irq=%d\n",
+	       "%s: %s mem=0x%lx, irq=%d\n",
 	       wiphy_name(hw->wiphy),
-	       ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
-	       ah->hw_version.macRev,
-	       ath9k_hw_rf_name((ah->hw_version.analog5GhzRev &
-				 AR_RADIO_SREV_MAJOR)),
-	       ah->hw_version.phyRev,
+	       hw_name,
 	       (unsigned long)mem, irq);
 
 	return 0;
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index cf543e3..f65b591 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3959,7 +3959,7 @@ static struct {
 /*
  * Return the MAC/BB name. "????" is returned if the MAC/BB is unknown.
  */
-const char *ath9k_hw_mac_bb_name(u32 mac_bb_version)
+static const char *ath9k_hw_mac_bb_name(u32 mac_bb_version)
 {
 	int i;
 
@@ -3971,13 +3971,12 @@ const char *ath9k_hw_mac_bb_name(u32 mac_bb_version)
 
 	return "????";
 }
-EXPORT_SYMBOL(ath9k_hw_mac_bb_name);
 
 /*
  * Return the RF name. "????" is returned if the RF is unknown.
  * Used for devices with external radios.
  */
-const char *ath9k_hw_rf_name(u16 rf_version)
+static const char *ath9k_hw_rf_name(u16 rf_version)
 {
 	int i;
 
@@ -3989,4 +3988,24 @@ const char *ath9k_hw_rf_name(u16 rf_version)
 
 	return "????";
 }
-EXPORT_SYMBOL(ath9k_hw_rf_name);
+
+void ath9k_hw_name(struct ath_hw *ah, char *hw_name)
+{
+	/* chipsets >= AR9280 are single-chip */
+	if (AR_SREV_9280_10_OR_LATER(ah)) {
+		sprintf(hw_name,
+			"Atheros single-chip AR%s Rev:%x",
+			ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
+			ah->hw_version.macRev);
+	}
+	else {
+		sprintf(hw_name,
+			"Atheros AR%s MAC/BB Rev:%x AR%s RF Rev:%x: ",
+			ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
+			ah->hw_version.macRev,
+			ath9k_hw_rf_name((ah->hw_version.analog5GhzRev &
+					 AR_RADIO_SREV_MAJOR)),
+			ah->hw_version.phyRev);
+	}
+}
+EXPORT_SYMBOL(ath9k_hw_name);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 100fcba..3ceb4c6 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -720,8 +720,7 @@ void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer);
 void ath_gen_timer_isr(struct ath_hw *hw);
 u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 
-const char *ath9k_hw_mac_bb_name(u32 mac_bb_version);
-const char *ath9k_hw_rf_name(u16 rf_version);
+void ath9k_hw_name(struct ath_hw *ah, char *hw_name);
 
 #define ATH_PCIE_CAP_LINK_CTRL	0x70
 #define ATH_PCIE_CAP_LINK_L0S	1
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 76f3890..963d6fe 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -114,6 +114,7 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	u32 val;
 	int ret = 0;
 	struct ath_hw *ah;
+	char hw_name[1024];
 
 	if (pci_enable_device(pdev))
 		return -EIO;
@@ -218,15 +219,11 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	sc->irq = pdev->irq;
 
 	ah = sc->sc_ah;
+	ath9k_hw_name(ah, hw_name);
 	printk(KERN_INFO
-	       "%s: Atheros AR%s MAC/BB Rev:%x "
-	       "AR%s RF Rev:%x: mem=0x%lx, irq=%d\n",
+	       "%s: %s mem=0x%lx, irq=%d\n",
 	       wiphy_name(hw->wiphy),
-	       ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
-	       ah->hw_version.macRev,
-	       ath9k_hw_rf_name((ah->hw_version.analog5GhzRev &
-				 AR_RADIO_SREV_MAJOR)),
-	       ah->hw_version.phyRev,
+	       hw_name,
 	       (unsigned long)mem, pdev->irq);
 
 	return 0;
-- 
1.6.0.4

