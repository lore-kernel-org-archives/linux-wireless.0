Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63366 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab1LHS35 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 13:29:57 -0500
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH RESEND 3/4] ath9k: Reconfigure tx power on regulatory update
Date: Thu, 8 Dec 2011 23:59:25 +0530
Message-ID: <1323368966-10001-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111208_193002_528303_CB7FCE2C)
In-Reply-To: <1323368966-10001-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1323368966-10001-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever the regulatory got updated by country IE for the world
roaming cards, need to reconfigure the tx power immediately to
increase the power level.

Reviewed-by: Sam Leffler <sleffler@google.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |   17 +++++++++++++++--
 1 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 41b72fa..c5df981 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -297,9 +297,22 @@ static int ath9k_reg_notifier(struct wiphy *wiphy,
 {
 	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
 	struct ath_softc *sc = hw->priv;
-	struct ath_regulatory *reg = ath9k_hw_regulatory(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_regulatory *reg = ath9k_hw_regulatory(ah);
+	int ret;
+
+	ret = ath_reg_notifier_apply(wiphy, request, reg);
+
+	/* Set tx power */
+	if (ah->curchan) {
+		sc->config.txpowlimit = 2 * ah->curchan->chan->max_power;
+		ath9k_ps_wakeup(sc);
+		ath9k_hw_set_txpowerlimit(ah, sc->config.txpowlimit, false);
+		sc->curtxpow = ath9k_hw_regulatory(ah)->power_limit;
+		ath9k_ps_restore(sc);
+	}
 
-	return ath_reg_notifier_apply(wiphy, request, reg);
+	return ret;
 }
 
 /*
-- 
1.7.8

