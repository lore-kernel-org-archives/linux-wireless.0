Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:39576 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbaGTMbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Jul 2014 08:31:38 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so6398266wes.20
        for <linux-wireless@vger.kernel.org>; Sun, 20 Jul 2014 05:31:37 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@lists.ath9k.org, linville@tuxdriver.com,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCH 09/10] ath9k: add ath9k_enable_dynack() method
Date: Sun, 20 Jul 2014 14:31:25 +0200
Message-Id: <1405859486-31414-10-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140720_143142_706007_C1C1BA2C)
In-Reply-To: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1405859486-31414-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add ath9k_enable_dynack() method to enable ack timeout estimation algorithm.
Moreover disable dynack if the coverage class has been configured

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e6ac8d2..52ca884 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1970,6 +1970,14 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 	mutex_lock(&sc->mutex);
 	ah->coverage_class = coverage_class;
 
+	if (ah->dynack.enabled) {
+		u32 rfilt;
+
+		ah->dynack.enabled = false;
+		rfilt = ath_calcrxfilter(sc);
+		ath9k_hw_setrxfilter(ah, rfilt);
+	}
+
 	ath9k_ps_wakeup(sc);
 	ath9k_hw_init_global_settings(ah);
 	ath9k_ps_restore(sc);
@@ -1977,6 +1985,28 @@ static void ath9k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 	mutex_unlock(&sc->mutex);
 }
 
+#ifdef CONFIG_ATH9K_DYNACK
+static int ath9k_enable_dynack(struct ieee80211_hw *hw)
+{
+	u32 rfilt;
+	struct ath_softc *sc = hw->priv;
+	struct ath_hw *ah = sc->sc_ah;
+
+	if (config_enabled(CONFIG_ATH9K_TX99))
+		return -EOPNOTSUPP;
+
+	if (!ah->dynack.enabled) {
+		ath_dynack_reset(ah);
+
+		ah->dynack.enabled = true;
+		rfilt = ath_calcrxfilter(sc);
+		ath9k_hw_setrxfilter(ah, rfilt);
+	}
+
+	return 0;
+}
+#endif
+
 static bool ath9k_has_tx_pending(struct ath_softc *sc)
 {
 	int i, npend = 0;
@@ -2651,4 +2681,8 @@ struct ieee80211_ops ath9k_ops = {
 #endif
 	.sw_scan_start	    = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
+
+#ifdef CONFIG_ATH9K_DYNACK
+	.enable_dynack      = ath9k_enable_dynack,
+#endif
 };
-- 
1.9.1

