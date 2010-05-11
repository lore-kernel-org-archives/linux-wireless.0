Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:24885 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756740Ab0EKIix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 04:38:53 -0400
Received: from vs3005.wh2.ocn.ne.jp (125.206.180.233)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0663587131
	for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 17:38:52 +0900 (JST)
Subject: [RFC PATCH 2/2] ath5k: Add support for cfg80211 antenna setting
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, holgerschurig@gmail.com
Date: Tue, 11 May 2010 17:39:11 +0900
Message-ID: <20100511083910.28289.71188.stgit@tt-desk>
In-Reply-To: <20100511083121.28289.96180.stgit@tt-desk>
References: <20100511083121.28289.96180.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support setting the antenna configuration via cfg80211. At the moment only
allow the simple pre-defined configurations we already have (fixed antenna A/B
or diversity), but more advanced settings should be possible later.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   34 +++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a99f310..fbf3d45 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -256,6 +256,8 @@ static void ath5k_sw_scan_start(struct ieee80211_hw *hw);
 static void ath5k_sw_scan_complete(struct ieee80211_hw *hw);
 static void ath5k_set_coverage_class(struct ieee80211_hw *hw,
 		u8 coverage_class);
+static int ath5k_set_antenna(struct ieee80211_hw *hw, u8 tx_ant, u8 rx_ant);
+static int ath5k_get_antenna(struct ieee80211_hw *hw, u8 *tx_ant, u8 *rx_ant);
 
 static const struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
@@ -277,6 +279,8 @@ static const struct ieee80211_ops ath5k_hw_ops = {
 	.sw_scan_start	= ath5k_sw_scan_start,
 	.sw_scan_complete = ath5k_sw_scan_complete,
 	.set_coverage_class = ath5k_set_coverage_class,
+	.set_antenna	= ath5k_set_antenna,
+	.get_antenna	= ath5k_get_antenna,
 };
 
 /*
@@ -3482,3 +3486,33 @@ static void ath5k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
 	ath5k_hw_set_coverage_class(sc->ah, coverage_class);
 	mutex_unlock(&sc->lock);
 }
+
+static int ath5k_set_antenna(struct ieee80211_hw *hw, u8 tx_ant, u8 rx_ant)
+{
+	struct ath5k_softc *sc = hw->priv;
+
+	if (tx_ant == 1 && rx_ant == 1)
+		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_A);
+	else if (tx_ant == 2 && rx_ant == 2)
+		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_B);
+	else if (tx_ant == 3 && rx_ant == 3)
+		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_DEFAULT);
+	else
+		return -EOPNOTSUPP;
+	return 0;
+}
+
+static int ath5k_get_antenna(struct ieee80211_hw *hw, u8 *tx_ant, u8 *rx_ant)
+{
+	struct ath5k_softc *sc = hw->priv;
+
+	switch (sc->ah->ah_ant_mode) {
+	case AR5K_ANTMODE_FIXED_A:
+		*tx_ant = 1; *rx_ant = 1; break;
+	case AR5K_ANTMODE_FIXED_B:
+		*tx_ant = 2; *rx_ant = 2; break;
+	case AR5K_ANTMODE_DEFAULT:
+		*tx_ant = 3; *rx_ant = 3; break;
+	}
+	return 0;
+}

