Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:18215 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752337Ab0KEGxM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Nov 2010 02:53:12 -0400
Received: from vs3011.wh2.ocn.ne.jp (125.206.180.239)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0533409990
	for <linux-wireless@vger.kernel.org>; Fri,  5 Nov 2010 15:53:10 +0900 (JST)
Subject: [PATCH v6 3/3] ath5k: Add support for antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, mcgrof@gmail.com, linux-wireless@vger.kernel.org
Date: Fri, 05 Nov 2010 15:53:22 +0900
Message-ID: <20101105065322.8122.85352.stgit@localhost6.localdomain6>
In-Reply-To: <20101105064851.8122.57278.stgit@localhost6.localdomain6>
References: <20101105064851.8122.57278.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Support setting the antenna configuration via cfg/mac80211. At the moment only
allow the simple pre-defined configurations we already have (fixed antenna A/B
or diversity), but more advanced settings are possible to implement.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 8251946..ba50a0b 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3395,6 +3395,36 @@ static int ath5k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return ret;
 }
 
+static int ath5k_set_antenna(struct ieee80211_hw *hw, u8 tx_ant, u8 rx_ant)
+{
+	struct ath5k_softc *sc = hw->priv;
+
+	if (tx_ant == 1 && rx_ant == 1)
+		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_A);
+	else if (tx_ant == 2 && rx_ant == 2)
+		ath5k_hw_set_antenna_mode(sc->ah, AR5K_ANTMODE_FIXED_B);
+	else if ((tx_ant & 3) == 3 && (rx_ant & 3) == 3)
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
+
 static const struct ieee80211_ops ath5k_hw_ops = {
 	.tx 		= ath5k_tx,
 	.start 		= ath5k_start,
@@ -3415,6 +3445,8 @@ static const struct ieee80211_ops ath5k_hw_ops = {
 	.sw_scan_start	= ath5k_sw_scan_start,
 	.sw_scan_complete = ath5k_sw_scan_complete,
 	.set_coverage_class = ath5k_set_coverage_class,
+	.set_antenna	= ath5k_set_antenna,
+	.get_antenna	= ath5k_get_antenna,
 };
 
 /********************\

