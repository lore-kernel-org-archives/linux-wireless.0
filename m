Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2869 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758772AbZBLSjJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 13:39:09 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 4/6] ath9k: remove ath9k_regd_get_rd()
Date: Thu, 12 Feb 2009 13:38:56 -0500
Message-Id: <1234463938-1350-5-git-send-email-me@bobcopeland.com> (sfid-20090212_193916_412464_CB3CE57C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The function ath9k_regd_get_rd() is unused.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath9k/regd.c |    5 -----
 drivers/net/wireless/ath9k/regd.h |    1 -
 2 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index 9793515..eb0d1b7 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -117,11 +117,6 @@ static u16 ath9k_regd_get_eepromRD(struct ath_hw *ah)
 	return ah->regulatory.current_rd & ~WORLDWIDE_ROAMING_FLAG;
 }
 
-u16 ath9k_regd_get_rd(struct ath_hw *ah)
-{
-	return ath9k_regd_get_eepromRD(ah);
-}
-
 bool ath9k_is_world_regd(struct ath_hw *ah)
 {
 	return is_wwr_sku(ath9k_regd_get_eepromRD(ah));
diff --git a/drivers/net/wireless/ath9k/regd.h b/drivers/net/wireless/ath9k/regd.h
index 8f0bfcc..f74f8ff 100644
--- a/drivers/net/wireless/ath9k/regd.h
+++ b/drivers/net/wireless/ath9k/regd.h
@@ -233,7 +233,6 @@ enum CountryCode {
 	CTRY_BELGIUM2 = 5002
 };
 
-u16 ath9k_regd_get_rd(struct ath_hw *ah);
 bool ath9k_is_world_regd(struct ath_hw *ah);
 const struct ieee80211_regdomain *ath9k_world_regdomain(struct ath_hw *ah);
 const struct ieee80211_regdomain *ath9k_default_world_regdomain(void);
-- 
1.6.0.6


