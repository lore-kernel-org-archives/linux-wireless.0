Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from parez.praha12.net ([78.102.11.253]:40030 "EHLO
	parez.praha12.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759979AbZLOR47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 12:56:59 -0500
From: =?UTF-8?q?Luk=C3=A1=C5=A1=20Turek?= <8an@praha12.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	ath5k-devel@lists.ath5k.org
Subject: [PATCH 5/5] ath5k: Implement mac80211 callback set_coverage_class
Date: Tue, 15 Dec 2009 18:56:52 +0100
Message-Id: <1260899813-17585-6-git-send-email-8an@praha12.net>
In-Reply-To: <1260899813-17585-1-git-send-email-8an@praha12.net>
References: <1260899813-17585-1-git-send-email-8an@praha12.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The callback sets slot time as specified in IEEE 802.11-2007 section
17.3.8.6 (for 20MHz channels only for now) and raises ACK and CTS
timeouts accordingly. The values are persistent, they are restored after
device reset.

Signed-off-by: Lukas Turek <8an@praha12.net>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +
 drivers/net/wireless/ath/ath5k/base.c  |   23 +++++++++++++
 drivers/net/wireless/ath/ath5k/pcu.c   |   55 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath5k/reset.c |    4 ++
 4 files changed, 84 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index ae311d2..66bcb50 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1063,6 +1063,7 @@ struct ath5k_hw {
 	u32			ah_cw_min;
 	u32			ah_cw_max;
 	u32			ah_limit_tx_retries;
+	u8			ah_coverage_class;
 
 	/* Antenna Control */
 	u32			ah_ant_ctl[AR5K_EEPROM_N_MODES][AR5K_ANT_MAX];
@@ -1200,6 +1201,7 @@ extern bool ath5k_eeprom_is_hb63(struct ath5k_hw *ah);
 
 /* Protocol Control Unit Functions */
 extern int ath5k_hw_set_opmode(struct ath5k_hw *ah);
+extern void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class);
 /* BSSID Functions */
 extern int ath5k_hw_set_lladdr(struct ath5k_hw *ah, const u8 *mac);
 extern void ath5k_hw_set_associd(struct ath5k_hw *ah);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a4c086f..203622e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -254,6 +254,8 @@ static void ath5k_bss_info_changed(struct ieee80211_hw *hw,
 		u32 changes);
 static void ath5k_sw_scan_start(struct ieee80211_hw *hw);
 static void ath5k_sw_scan_complete(struct ieee80211_hw *hw);
+static void ath5k_set_coverage_class(struct ieee80211_hw *hw,
+		u8 coverage_class);
 
 static const struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
@@ -274,6 +276,7 @@ static const struct ieee80211_ops ath5k_hw_ops = {
 	.bss_info_changed = ath5k_bss_info_changed,
 	.sw_scan_start	= ath5k_sw_scan_start,
 	.sw_scan_complete = ath5k_sw_scan_complete,
+	.set_coverage_class = ath5k_set_coverage_class,
 };
 
 /*
@@ -3274,3 +3277,23 @@ static void ath5k_sw_scan_complete(struct ieee80211_hw *hw)
 	ath5k_hw_set_ledstate(sc->ah, sc->assoc ?
 		AR5K_LED_ASSOC : AR5K_LED_INIT);
 }
+
+/**
+ * ath5k_set_coverage_class - Set IEEE 802.11 coverage class
+ *
+ * @hw: struct ieee80211_hw pointer
+ * @coverage_class: IEEE 802.11 coverage class number
+ *
+ * Mac80211 callback. Sets slot time, ACK timeout and CTS timeout for given
+ * coverage class. The values are persistent, they are restored after device
+ * reset.
+ */
+static void ath5k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
+{
+	struct ath5k_softc *sc = hw->priv;
+
+	mutex_lock(&sc->lock);
+	ath5k_hw_set_coverage_class(sc->ah, coverage_class);
+	sc->ah->ah_coverage_class = coverage_class;
+	mutex_unlock(&sc->lock);
+}
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 8c72845..88ad112 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -286,6 +286,42 @@ unsigned int ath5k_hw_get_clockrate(struct ath5k_hw *ah)
 }
 
 /**
+ * ath5k_hw_get_default_slottime - Get the default slot time for current mode
+ *
+ * @ah: The &struct ath5k_hw
+ */
+unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
+{
+	struct ieee80211_channel *channel = ah->ah_current_channel;
+
+	if (channel->hw_value & CHANNEL_TURBO)
+		return 6; /* both turbo modes */
+
+	if (channel->hw_value & CHANNEL_CCK)
+		return 20; /* 802.11b */
+
+	return 9; /* 802.11 a/g */
+}
+
+/**
+ * ath5k_hw_get_default_sifs - Get the default SIFS for current mode
+ *
+ * @ah: The &struct ath5k_hw
+ */
+unsigned int ath5k_hw_get_default_sifs(struct ath5k_hw *ah)
+{
+	struct ieee80211_channel *channel = ah->ah_current_channel;
+
+	if (channel->hw_value & CHANNEL_TURBO)
+		return 8; /* both turbo modes */
+
+	if (channel->hw_value & CHANNEL_5GHZ)
+		return 16; /* 802.11a */
+
+	return 10; /* 802.11 b/g */
+}
+
+/**
  * ath5k_hw_set_lladdr - Set station id
  *
  * @ah: The &struct ath5k_hw
@@ -1094,3 +1130,22 @@ int ath5k_hw_set_key_lladdr(struct ath5k_hw *ah, u16 entry, const u8 *mac)
 	return 0;
 }
 
+/**
+ * ath5k_hw_set_coverage_class - Set IEEE 802.11 coverage class
+ *
+ * @ah: The &struct ath5k_hw
+ * @coverage_class: IEEE 802.11 coverage class number
+ *
+ * Sets slot time, ACK timeout and CTS timeout for given coverage class.
+ */
+void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
+{
+	/* As defined by IEEE 802.11-2007 17.3.8.6 */
+	int slot_time = ath5k_hw_get_default_slottime(ah) + 3 * coverage_class;
+	int ack_timeout = ath5k_hw_get_default_sifs(ah) + slot_time;
+	int cts_timeout = ack_timeout;
+
+	ath5k_hw_set_slot_time(ah, slot_time);
+	ath5k_hw_set_ack_timeout(ah, ack_timeout);
+	ath5k_hw_set_cts_timeout(ah, cts_timeout);
+}
diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index f1dc4c8..ec3b357 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -1316,6 +1316,10 @@ int ath5k_hw_reset(struct ath5k_hw *ah, enum nl80211_iftype op_mode,
 	/* Restore antenna mode */
 	ath5k_hw_set_antenna_mode(ah, ah->ah_ant_mode);
 
+	/* Restore slot time and ACK timeouts */
+	if (ah->ah_coverage_class > 0)
+		ath5k_hw_set_coverage_class(ah, ah->ah_coverage_class);
+
 	/*
 	 * Configure QCUs/DCUs
 	 */
-- 
1.6.4.4

