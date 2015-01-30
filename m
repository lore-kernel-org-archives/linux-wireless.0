Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:37192 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbbA3Ncs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 08:32:48 -0500
Received: from [117.207.72.194] (port=10794 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YHBgl-004FiR-Fm
	for linux-wireless@vger.kernel.org; Fri, 30 Jan 2015 08:32:47 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 06/17] ath9k: Fix wow init/deinit
Date: Fri, 30 Jan 2015 19:05:26 +0530
Message-Id: <1422624937-4810-7-git-send-email-sujith@msujith.org> (sfid-20150130_143254_991971_6149F265)
In-Reply-To: <1422624937-4810-1-git-send-email-sujith@msujith.org>
References: <1422624937-4810-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Registering the card as a wakeup source needs to
be done once, during initialization. When the WOW
configuration changes, the card's status as wakeup
source needs to be changed too and this is done
via the set_wakeup() callback. Also, make sure
the device is removed properly using ath9k_deinit_wow().

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  4 ++++
 drivers/net/wireless/ath/ath9k/init.c  |  1 +
 drivers/net/wireless/ath/ath9k/wow.c   | 22 ++++++++++++++++++----
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index e84b576..4209d7b 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -838,6 +838,7 @@ struct ath9k_wow_pattern {
 
 #ifdef CONFIG_ATH9K_WOW
 void ath9k_init_wow(struct ieee80211_hw *hw);
+void ath9k_deinit_wow(struct ieee80211_hw *hw);
 int ath9k_suspend(struct ieee80211_hw *hw,
 		  struct cfg80211_wowlan *wowlan);
 int ath9k_resume(struct ieee80211_hw *hw);
@@ -846,6 +847,9 @@ void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled);
 static inline void ath9k_init_wow(struct ieee80211_hw *hw)
 {
 }
+static inline void ath9k_deinit_wow(struct ieee80211_hw *hw)
+{
+}
 static inline int ath9k_suspend(struct ieee80211_hw *hw,
 				struct cfg80211_wowlan *wowlan)
 {
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 2aef14e..6c6e884 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -996,6 +996,7 @@ void ath9k_deinit_device(struct ath_softc *sc)
 	ath9k_ps_restore(sc);
 
 	ath9k_deinit_debug(sc);
+	ath9k_deinit_wow(hw);
 	ieee80211_unregister_hw(hw);
 	ath_rx_cleanup(sc);
 	ath9k_deinit_softc(sc);
diff --git a/drivers/net/wireless/ath/ath9k/wow.c b/drivers/net/wireless/ath/ath9k/wow.c
index 1b005c6..8bcbaa9 100644
--- a/drivers/net/wireless/ath/ath9k/wow.c
+++ b/drivers/net/wireless/ath/ath9k/wow.c
@@ -336,20 +336,34 @@ int ath9k_resume(struct ieee80211_hw *hw)
 void ath9k_set_wakeup(struct ieee80211_hw *hw, bool enabled)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 
 	mutex_lock(&sc->mutex);
-	device_init_wakeup(sc->dev, 1);
 	device_set_wakeup_enable(sc->dev, enabled);
 	mutex_unlock(&sc->mutex);
+
+	ath_dbg(common, WOW, "WoW wakeup source is %s\n",
+		(enabled) ? "enabled" : "disabled");
 }
 
 void ath9k_init_wow(struct ieee80211_hw *hw)
 {
 	struct ath_softc *sc = hw->priv;
 
-	if ((sc->driver_data & ATH9K_PCI_WOW) && device_can_wakeup(sc->dev))
+	if (sc->driver_data & ATH9K_PCI_WOW) {
 		hw->wiphy->wowlan = &ath9k_wowlan_support;
 
-	atomic_set(&sc->wow_sleep_proc_intr, -1);
-	atomic_set(&sc->wow_got_bmiss_intr, -1);
+		atomic_set(&sc->wow_sleep_proc_intr, -1);
+		atomic_set(&sc->wow_got_bmiss_intr, -1);
+
+		device_init_wakeup(sc->dev, 1);
+	}
+}
+
+void ath9k_deinit_wow(struct ieee80211_hw *hw)
+{
+	struct ath_softc *sc = hw->priv;
+
+	if (sc->driver_data & ATH9K_PCI_WOW)
+		device_init_wakeup(sc->dev, 0);
 }
-- 
2.2.2

