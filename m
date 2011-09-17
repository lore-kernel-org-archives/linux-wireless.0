Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39582 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448Ab1IQOJt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Sep 2011 10:09:49 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 3/4] ath: remove ath_regulatory::current_rd_ext
Date: Sat, 17 Sep 2011 16:09:36 +0200
Message-Id: <1316268577-45651-3-git-send-email-nbd@openwrt.org> (sfid-20110917_161014_870526_00F0D083)
In-Reply-To: <1316268577-45651-2-git-send-email-nbd@openwrt.org>
References: <1316268577-45651-1-git-send-email-nbd@openwrt.org>
 <1316268577-45651-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath.h           |    1 -
 drivers/net/wireless/ath/ath9k/hw.c      |    5 -----
 drivers/net/wireless/ath/carl9170/main.c |    1 -
 3 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath.h b/drivers/net/wireless/ath/ath.h
index bb71b4f..908fdbc 100644
--- a/drivers/net/wireless/ath/ath.h
+++ b/drivers/net/wireless/ath/ath.h
@@ -72,7 +72,6 @@ struct ath_regulatory {
 	u16 country_code;
 	u16 max_power_level;
 	u16 current_rd;
-	u16 current_rd_ext;
 	int16_t power_limit;
 	struct reg_dmn_pair_mapping *regpair;
 };
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 67b75d7..88a3888 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2067,11 +2067,6 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_0);
 	regulatory->current_rd = eeval;
 
-	eeval = ah->eep_ops->get_eeprom(ah, EEP_REG_1);
-	if (AR_SREV_9285_12_OR_LATER(ah))
-		eeval |= AR9285_RDEXT_DEFAULT;
-	regulatory->current_rd_ext = eeval;
-
 	if (ah->opmode != NL80211_IFTYPE_AP &&
 	    ah->hw_version.subvendorid == AR_SUBVENDOR_ID_NEW_A) {
 		if (regulatory->current_rd == 0x64 ||
diff --git a/drivers/net/wireless/ath/carl9170/main.c b/drivers/net/wireless/ath/carl9170/main.c
index af351ec..6786124 100644
--- a/drivers/net/wireless/ath/carl9170/main.c
+++ b/drivers/net/wireless/ath/carl9170/main.c
@@ -1894,7 +1894,6 @@ static int carl9170_parse_eeprom(struct ar9170 *ar)
 		ar->hw->channel_change_time = 80 * 1000;
 
 	regulatory->current_rd = le16_to_cpu(ar->eeprom.reg_domain[0]);
-	regulatory->current_rd_ext = le16_to_cpu(ar->eeprom.reg_domain[1]);
 
 	/* second part of wiphy init */
 	SET_IEEE80211_PERM_ADDR(ar->hw, ar->eeprom.mac_address);
-- 
1.7.3.2

