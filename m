Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:56169 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933945AbZLFR0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Dec 2009 12:26:46 -0500
From: =?utf-8?q?Luk=C3=A1=C5=A1_Turek?= <8an@praha12.net>
Reply-To: 8an@praha12.net
To: linville@tuxdriver.com
Subject: [PATCH 4/4] ath5k: Implement mac80211 callback set_coverage
Date: Sun, 6 Dec 2009 18:26:52 +0100
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	ath5k-devel@lists.ath5k.org
References: <200912061820.26320.8an@praha12.net>
In-Reply-To: <200912061820.26320.8an@praha12.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200912061826.52394.8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The callback sets slot time as specified in IEEE 802.11-2007 section
17.3.8.6 (for 20MHz channels only for now) and ACK and CTS timeouts
using calculations taken from Madwifi's athctrl. The values are
persistent, they are restored after device reset.

Signed-off-by: Lukas Turek <8an@praha12.net>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 ++
 drivers/net/wireless/ath/ath5k/base.c  |   22 ++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/pcu.c   |   19 +++++++++++++++++++
 drivers/net/wireless/ath/ath5k/reset.c |    4 ++++
 4 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 6a2a967..1b906e6 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1063,6 +1063,7 @@ struct ath5k_hw {
 	u32			ah_cw_min;
 	u32			ah_cw_max;
 	u32			ah_limit_tx_retries;
+	u8			ah_coverage_class;
 
 	/* Antenna Control */
 	u32			ah_ant_ctl[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
@@ -1231,6 +1232,7 @@ extern int ath5k_hw_set_ack_timeout(struct ath5k_hw *ah, unsigned int timeout);
 extern unsigned int ath5k_hw_get_ack_timeout(struct ath5k_hw *ah);
 extern int ath5k_hw_set_cts_timeout(struct ath5k_hw *ah, unsigned int timeout);
 extern unsigned int ath5k_hw_get_cts_timeout(struct ath5k_hw *ah);
+extern void ath5k_hw_set_coverage(struct ath5k_hw *ah, u8 coverage_class);
 /* Key table (WEP) functions */
 extern int ath5k_hw_reset_key(struct ath5k_hw *ah, u16 entry);
 extern int ath5k_hw_is_key_valid(struct ath5k_hw *ah, u16 entry);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a4c086f..27c65b9 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -254,6 +254,7 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 		u32 changes);
 static void ath5k_sw_scan_start(struct ieee80211_hw *hw);
 static void ath5k_sw_scan_complete(struct ieee80211_hw *hw);
+static void ath5k_set_coverage(struct ieee80211_hw *hw, u8 coverage_class);
 
 static const struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
@@ -274,6 +275,7 @@ static const struct ieee80211_ops ath5k_hw_ops = {
 	.bss_info_changed = ath5k_bss_info_changed,
 	.sw_scan_start	= ath5k_sw_scan_start,
 	.sw_scan_complete = ath5k_sw_scan_complete,
+	.set_coverage	= ath5k_set_coverage,
 };
 
 /*
@@ -3274,3 +3276,23 @@ static void ath5k_sw_scan_complete(struct ieee80211_hw *hw)
 	ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
 		AR5K_LED_ASSOC : AR5K_LED_INIT);
 }
+
+/**
+ * ath5k_set_coverage - Set coverage class
+ *
+ * @hw: struct ieee80211_hw pointer
+ * @coverage_class: IEEE 802.11 coverage class
+ *
+ * Mac80211 callback. Sets slot time, ACK timeout and CTS timeout for given
+ * coverage class. The values are persistent, they are set again after device
+ * reset.
+ */
+static void ath5k_set_coverage(struct ieee80211_hw *hw, u8 coverage_class)
+{
+	struct ath5k_softc *sc = hw->priv;
+	
+	mutex_lock(&sc->lock);
+	ath5k_hw_set_coverage(sc->ah, coverage_class);
+	sc->ah->ah_coverage_class = coverage_class; /* Restored on reset */
+	mutex_unlock(&sc->lock);
+}
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 64fc1eb..2383e22 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -1050,3 +1050,22 @@ int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac)
 	return 0;
 }
 
+/**
+ * ath5k_hw_set_coverage - Set coverage class
+ *
+ * @ah: The &struct ath5k_hw
+ * @coverage_class: IEEE 802.11 coverage class
+ *
+ * Sets slot time, ACK timeout and CTS timeout for given coverage class.
+ */
+void ath5k_hw_set_coverage(struct ath5k_hw *ah, u8 coverage_class)
+{
+	/* Calculations taken from Madwifi's athctrl */
+	int slot_time = 9 + 3 * coverage_class;
+	int ack_timeout = slot_time * 2 + 3;
+	int cts_timeout = ack_timeout;
+	
+	ath5k_hw_set_slot_time(ah, slot_time);
+	ath5k_hw_set_ack_timeout(ah, ack_timeout);
+	ath5k_hw_set_cts_timeout(ah, cts_timeout);
+}
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index 62954fc..85aeecf 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1317,6 +1317,10 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	/* Restore antenna mode */
 	ath5k_hw_set_antenna_mode(ah, ah->ah_ant_mode);
 
+	/* Restore slot time and ACK timeouts */
+	if (ah->ah_coverage_class > 0)
+		ath5k_hw_set_coverage(ah, ah->ah_coverage_class);
+
 	/*
 	 * Configure QCUs/DCUs
 	 */
-- 
1.6.4.4
