Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18585 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbZA1USf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 15:18:35 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 12:18:35 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 1/3] ath9k: replace usage of internal wireless_modes for conf
Date: Wed, 28 Jan 2009 12:17:47 -0800
Message-ID: <1233173869-16512-2-git-send-email-lrodriguez@atheros.com> (sfid-20090128_211844_641911_06F7A300)
In-Reply-To: <1233173869-16512-1-git-send-email-lrodriguez@atheros.com>
References: <1233173869-16512-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to use our internal wireless mode variable when
cfg80211 already has its own.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/regd.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index ec88f78..b84fbe3 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -158,8 +158,6 @@ const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hal *ah)
 static void ath9k_reg_apply_5ghz_adhoc_flags(struct wiphy *wiphy,
 					     enum reg_set_by setby)
 {
-	struct ieee80211_hw *hw = wiphy_to_ieee80211_hw(wiphy);
-	struct ath_softc *sc = hw->priv;
 	struct ieee80211_supported_band *sband;
 	const struct ieee80211_reg_rule *reg_rule;
 	struct ieee80211_channel *ch;
@@ -169,8 +167,7 @@ static void ath9k_reg_apply_5ghz_adhoc_flags(struct wiphy *wiphy,
 
 	if (setby != REGDOM_SET_BY_COUNTRY_IE)
 		return;
-	if (!test_bit(ATH9K_MODE_11A,
-	    sc->sc_ah->ah_caps.wireless_modes))
+	if (!wiphy->bands[IEEE80211_BAND_5GHZ])
 		return;
 
 	sband = wiphy->bands[IEEE80211_BAND_5GHZ];
-- 
1.6.1.rc3.51.g5832d

