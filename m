Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25191 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758625AbZC3KDJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Mar 2009 06:03:09 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2009 03:03:08 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18896.38881.717688.543632@gargle.gargle.HOWL> (sfid-20090330_120320_314497_8631A6AE)
Date: Mon, 30 Mar 2009 15:28:57 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 17/17] ath9k: Fix bug in determining HT40 mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes a bug in checking for HT40 mode.
The STA's mode can be determined from the cached HT capabilities,
use that and remove the redundant variable 'rc_phy_mode'.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/rc.c |    6 ++----
 drivers/net/wireless/ath9k/rc.h |    1 -
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index a6933cc..a13668b 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1321,7 +1321,7 @@ static void ath_rc_tx_status(struct ath_softc *sc,
 				 * 40 to 20 => don't update */
 
 				if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
-				    (ath_rc_priv->rc_phy_mode != WLAN_RC_40_FLAG))
+				    !(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG))
 					return;
 
 				rix = ath_rc_get_rateindex(rate_table, &rates[i]);
@@ -1346,9 +1346,8 @@ static void ath_rc_tx_status(struct ath_softc *sc,
 
 	/* If HT40 and we have switched mode from 40 to 20 => don't update */
 	if ((flags & IEEE80211_TX_RC_40_MHZ_WIDTH) &&
-	    (ath_rc_priv->rc_phy_mode != WLAN_RC_40_FLAG)) {
+	    !(ath_rc_priv->ht_cap & WLAN_RC_40_FLAG))
 		return;
-	}
 
 	rix = ath_rc_get_rateindex(rate_table, &rates[i]);
 	ath_rc_update_ht(sc, ath_rc_priv, tx_info_priv, rix,
@@ -1421,7 +1420,6 @@ static void ath_rc_init(struct ath_softc *sc,
 			ath_rc_priv->valid_phy_rateidx[i][j] = 0;
 		ath_rc_priv->valid_phy_ratecnt[i] = 0;
 	}
-	ath_rc_priv->rc_phy_mode = ath_rc_priv->ht_cap & WLAN_RC_40_FLAG;
 
 	if (!rateset->rs_nrates) {
 		/* No working rate, just initialize valid rates */
diff --git a/drivers/net/wireless/ath9k/rc.h b/drivers/net/wireless/ath9k/rc.h
index bdfd205..e3abd76 100644
--- a/drivers/net/wireless/ath9k/rc.h
+++ b/drivers/net/wireless/ath9k/rc.h
@@ -176,7 +176,6 @@ struct ath_rate_priv {
 	u8 ht_cap;
 	u8 valid_phy_ratecnt[WLAN_RC_PHY_MAX];
 	u8 valid_phy_rateidx[WLAN_RC_PHY_MAX][RATE_TABLE_SIZE];
-	u8 rc_phy_mode;
 	u8 rate_max_phy;
 	u32 rssi_time;
 	u32 rssi_down_time;
-- 
1.6.2.1

