Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:7358 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756708Ab0ESBdL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:33:11 -0400
Received: from vs3006.wh2.ocn.ne.jp (125.206.180.169)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0971332790
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:33:10 +0900 (JST)
Subject: [PATCH v2 15/20] ath5k: Add support for antenna configuration
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:31:58 +0900
Message-ID: <20100519013158.22206.95448.stgit@tt-desk>
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support setting the antenna configuration via cfg/mac80211. At the moment only
allow the simple pre-defined configurations we already have (fixed antenna A/B
or diversity), but more advanced settings should be possible later.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   34 +++++++++++++++++++++++++++++++++
 1 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index d5d514f..5f24e4a 100644
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
@@ -3483,3 +3487,33 @@ static void ath5k_set_coverage_class(struct ieee80211_hw *hw, u8 coverage_class)
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
+		return -EINVAL;
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

