Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:43763 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752885Ab0KJDur (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Nov 2010 22:50:47 -0500
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0343481046
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 12:50:46 +0900 (JST)
Subject: [PATCH v7 3/3] ath5k: Add support for antenna configuration
To: johannes@sipsolutions.net, linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, mcgrof@gmail.com, linux-wireless@vger.kernel.org
Date: Wed, 10 Nov 2010 12:51:01 +0900
Message-ID: <20101110035101.23721.54524.stgit@localhost6.localdomain6>
In-Reply-To: <20101110035050.23721.15617.stgit@localhost6.localdomain6>
References: <20101110035050.23721.15617.stgit@localhost6.localdomain6>
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
index b9f93fb..fe116de 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3413,6 +3413,36 @@ static int ath5k_conf_tx(struct ieee80211_hw *hw, u16 queue,
 	return ret;
 }
 
+static int ath5k_set_antenna(struct ieee80211_hw *hw, u32 tx_ant, u32 rx_ant)
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
+static int ath5k_get_antenna(struct ieee80211_hw *hw, u32 *tx_ant, u32 *rx_ant)
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
@@ -3433,6 +3463,8 @@ static const struct ieee80211_ops ath5k_hw_ops = {
 	.sw_scan_start	= ath5k_sw_scan_start,
 	.sw_scan_complete = ath5k_sw_scan_complete,
 	.set_coverage_class = ath5k_set_coverage_class,
+	.set_antenna	= ath5k_set_antenna,
+	.get_antenna	= ath5k_get_antenna,
 };
 
 /********************\

