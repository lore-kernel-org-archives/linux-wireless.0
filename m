Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45366 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaEALhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2014 07:37:25 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] ath9k: Advertise support for AP mode channel width changes
Date: Thu, 1 May 2014 17:07:43 +0530
Message-ID: <1398944263-32280-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140501_133729_573142_536612AE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This will enable AP mode to change channel width dynamically
based on 20/40 intolerance report sent by associated client.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 4243509..c99e50f 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -714,7 +714,8 @@ static void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || ath9k_modparam_nohwcrypt)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
-	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
+	hw->wiphy->features |= (NL80211_FEATURE_ACTIVE_MONITOR |
+				NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE);
 
 	if (!config_enabled(CONFIG_ATH9K_TX99)) {
 		hw->wiphy->interface_modes =
-- 
1.9.2

