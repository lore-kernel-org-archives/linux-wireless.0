Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55678 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbZJZOi5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 10:38:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/4] ath9k_hw: move mac name and rf name helpers to hw code
Date: Mon, 26 Oct 2009 10:38:58 -0400
Message-Id: <1256567941-26859-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
References: <1256567941-26859-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These are shared between ath9k and the future ath9k_htc driver.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ahb.c  |    5 ++-
 drivers/net/wireless/ath/ath9k/hw.c   |   62 +++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath9k/hw.h   |    3 ++
 drivers/net/wireless/ath/ath9k/main.c |   58 ------------------------------
 drivers/net/wireless/ath/ath9k/pci.c  |    5 ++-
 5 files changed, 71 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ahb.c b/drivers/net/wireless/ath/ath9k/ahb.c
index 25531f2..41422c4 100644
--- a/drivers/net/wireless/ath/ath9k/ahb.c
+++ b/drivers/net/wireless/ath/ath9k/ahb.c
@@ -137,9 +137,10 @@ static int ath_ahb_probe(struct platform_device *pdev)
 	       "%s: Atheros AR%s MAC/BB Rev:%x, "
 	       "AR%s RF Rev:%x, mem=0x%lx, irq=%d\n",
 	       wiphy_name(hw->wiphy),
-	       ath_mac_bb_name(ah->hw_version.macVersion),
+	       ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
 	       ah->hw_version.macRev,
-	       ath_rf_name((ah->hw_version.analog5GhzRev & AR_RADIO_SREV_MAJOR)),
+	       ath9k_hw_rf_name((ah->hw_version.analog5GhzRev &
+				 AR_RADIO_SREV_MAJOR)),
 	       ah->hw_version.phyRev,
 	       (unsigned long)mem, irq);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index db95876..cf543e3 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -3928,3 +3928,65 @@ void ath_gen_timer_isr(struct ath_hw *ah)
 	}
 }
 EXPORT_SYMBOL(ath_gen_timer_isr);
+
+static struct {
+	u32 version;
+	const char * name;
+} ath_mac_bb_names[] = {
+	/* Devices with external radios */
+	{ AR_SREV_VERSION_5416_PCI,	"5416" },
+	{ AR_SREV_VERSION_5416_PCIE,	"5418" },
+	{ AR_SREV_VERSION_9100,		"9100" },
+	{ AR_SREV_VERSION_9160,		"9160" },
+	/* Single-chip solutions */
+	{ AR_SREV_VERSION_9280,		"9280" },
+	{ AR_SREV_VERSION_9285,		"9285" },
+	{ AR_SREV_VERSION_9287,         "9287" }
+};
+
+/* For devices with external radios */
+static struct {
+	u16 version;
+	const char * name;
+} ath_rf_names[] = {
+	{ 0,				"5133" },
+	{ AR_RAD5133_SREV_MAJOR,	"5133" },
+	{ AR_RAD5122_SREV_MAJOR,	"5122" },
+	{ AR_RAD2133_SREV_MAJOR,	"2133" },
+	{ AR_RAD2122_SREV_MAJOR,	"2122" }
+};
+
+/*
+ * Return the MAC/BB name. "????" is returned if the MAC/BB is unknown.
+ */
+const char *ath9k_hw_mac_bb_name(u32 mac_bb_version)
+{
+	int i;
+
+	for (i=0; i<ARRAY_SIZE(ath_mac_bb_names); i++) {
+		if (ath_mac_bb_names[i].version == mac_bb_version) {
+			return ath_mac_bb_names[i].name;
+		}
+	}
+
+	return "????";
+}
+EXPORT_SYMBOL(ath9k_hw_mac_bb_name);
+
+/*
+ * Return the RF name. "????" is returned if the RF is unknown.
+ * Used for devices with external radios.
+ */
+const char *ath9k_hw_rf_name(u16 rf_version)
+{
+	int i;
+
+	for (i=0; i<ARRAY_SIZE(ath_rf_names); i++) {
+		if (ath_rf_names[i].version == rf_version) {
+			return ath_rf_names[i].name;
+		}
+	}
+
+	return "????";
+}
+EXPORT_SYMBOL(ath9k_hw_rf_name);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 936ef5b..100fcba 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -720,6 +720,9 @@ void ath_gen_timer_free(struct ath_hw *ah, struct ath_gen_timer *timer);
 void ath_gen_timer_isr(struct ath_hw *hw);
 u32 ath9k_hw_gettsf32(struct ath_hw *ah);
 
+const char *ath9k_hw_mac_bb_name(u32 mac_bb_version);
+const char *ath9k_hw_rf_name(u16 rf_version);
+
 #define ATH_PCIE_CAP_LINK_CTRL	0x70
 #define ATH_PCIE_CAP_LINK_L0S	1
 #define ATH_PCIE_CAP_LINK_L1	2
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 69cf702..9fefc51 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -3191,64 +3191,6 @@ struct ieee80211_ops ath9k_ops = {
 	.rfkill_poll        = ath9k_rfkill_poll_state,
 };
 
-static struct {
-	u32 version;
-	const char * name;
-} ath_mac_bb_names[] = {
-	{ AR_SREV_VERSION_5416_PCI,	"5416" },
-	{ AR_SREV_VERSION_5416_PCIE,	"5418" },
-	{ AR_SREV_VERSION_9100,		"9100" },
-	{ AR_SREV_VERSION_9160,		"9160" },
-	{ AR_SREV_VERSION_9280,		"9280" },
-	{ AR_SREV_VERSION_9285,		"9285" },
-	{ AR_SREV_VERSION_9287,         "9287" }
-};
-
-static struct {
-	u16 version;
-	const char * name;
-} ath_rf_names[] = {
-	{ 0,				"5133" },
-	{ AR_RAD5133_SREV_MAJOR,	"5133" },
-	{ AR_RAD5122_SREV_MAJOR,	"5122" },
-	{ AR_RAD2133_SREV_MAJOR,	"2133" },
-	{ AR_RAD2122_SREV_MAJOR,	"2122" }
-};
-
-/*
- * Return the MAC/BB name. "????" is returned if the MAC/BB is unknown.
- */
-const char *
-ath_mac_bb_name(u32 mac_bb_version)
-{
-	int i;
-
-	for (i=0; i<ARRAY_SIZE(ath_mac_bb_names); i++) {
-		if (ath_mac_bb_names[i].version == mac_bb_version) {
-			return ath_mac_bb_names[i].name;
-		}
-	}
-
-	return "????";
-}
-
-/*
- * Return the RF name. "????" is returned if the RF is unknown.
- */
-const char *
-ath_rf_name(u16 rf_version)
-{
-	int i;
-
-	for (i=0; i<ARRAY_SIZE(ath_rf_names); i++) {
-		if (ath_rf_names[i].version == rf_version) {
-			return ath_rf_names[i].name;
-		}
-	}
-
-	return "????";
-}
-
 static int __init ath9k_init(void)
 {
 	int error;
diff --git a/drivers/net/wireless/ath/ath9k/pci.c b/drivers/net/wireless/ath/ath9k/pci.c
index 63059b6..76f3890 100644
--- a/drivers/net/wireless/ath/ath9k/pci.c
+++ b/drivers/net/wireless/ath/ath9k/pci.c
@@ -222,9 +222,10 @@ static int ath_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	       "%s: Atheros AR%s MAC/BB Rev:%x "
 	       "AR%s RF Rev:%x: mem=0x%lx, irq=%d\n",
 	       wiphy_name(hw->wiphy),
-	       ath_mac_bb_name(ah->hw_version.macVersion),
+	       ath9k_hw_mac_bb_name(ah->hw_version.macVersion),
 	       ah->hw_version.macRev,
-	       ath_rf_name((ah->hw_version.analog5GhzRev & AR_RADIO_SREV_MAJOR)),
+	       ath9k_hw_rf_name((ah->hw_version.analog5GhzRev &
+				 AR_RADIO_SREV_MAJOR)),
 	       ah->hw_version.phyRev,
 	       (unsigned long)mem, pdev->irq);
 
-- 
1.6.0.4

