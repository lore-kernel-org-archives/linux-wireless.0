Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:38688 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751341Ab3JURWr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:22:47 -0400
Received: by mail-wi0-f170.google.com with SMTP id l12so5536625wiv.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:22:46 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 02/14] ath: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:26 +0200
Message-Id: <1382376158-25586-3-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_192251_614526_4F6197D2)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: smihir@qti.qualcomm.com
Cc: tushnimb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 34 +++++++++++-----------------------
 1 file changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 14d3614..a258283 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -37,17 +37,17 @@ static int __ath_regd_init(struct ath_regulatory *reg);
 
 /* We enable active scan on these a case by case basis by regulatory domain */
 #define ATH9K_2GHZ_CH12_13	REG_RULE(2467-10, 2472+10, 40, 0, 20,\
-					NL80211_RRF_PASSIVE_SCAN)
+				NL80211_RRF_NO_IR)
 #define ATH9K_2GHZ_CH14		REG_RULE(2484-10, 2484+10, 40, 0, 20,\
-				NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_OFDM)
+				NL80211_RRF_NO_IR | NL80211_RRF_NO_OFDM)
 
 /* We allow IBSS on these on a case by case basis by regulatory domain */
 #define ATH9K_5GHZ_5150_5350	REG_RULE(5150-10, 5350+10, 80, 0, 30,\
-				NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS)
+				NL80211_RRF_NO_IR)
 #define ATH9K_5GHZ_5470_5850	REG_RULE(5470-10, 5850+10, 80, 0, 30,\
-				NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS)
+				NL80211_RRF_NO_IR)
 #define ATH9K_5GHZ_5725_5850	REG_RULE(5725-10, 5850+10, 80, 0, 30,\
-				NL80211_RRF_PASSIVE_SCAN | NL80211_RRF_NO_IBSS)
+				NL80211_RRF_NO_IR)
 
 #define ATH9K_2GHZ_ALL		ATH9K_2GHZ_CH01_11, \
 				ATH9K_2GHZ_CH12_13, \
@@ -186,13 +186,9 @@ static void ath_force_clear_no_ir_chan(struct wiphy *wiphy,
 	if (IS_ERR(reg_rule))
 		return;
 
-	if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
-		if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
-
-	if (!(reg_rule->flags & IEEE80211_CHAN_NO_IBSS))
-		if (ch->flags & IEEE80211_CHAN_NO_IBSS)
-			ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
+	if (!(reg_rule->flags & NL80211_RRF_NO_IR))
+		if (ch->flags & IEEE80211_CHAN_NO_IR)
+			ch->flags &= ~IEEE80211_CHAN_NO_IR;
 }
 
 static void ath_force_clear_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
@@ -206,12 +202,6 @@ static void ath_force_clear_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
 	ath_force_clear_no_ir_chan(wiphy, ch);
 }
 
-static void ath_force_no_ir_chan(struct ieee80211_channel *ch)
-{
-	ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
-	ch->flags |= IEEE80211_CHAN_NO_IBSS;
-}
-
 static void ath_force_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
 {
 	struct ieee80211_channel *ch;
@@ -220,7 +210,7 @@ static void ath_force_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
 	if (!ch)
 		return;
 
-	ath_force_no_ir_chan(ch);
+	ch->flags |= IEEE80211_CHAN_NO_IR;
 }
 
 static void
@@ -238,8 +228,7 @@ __ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 		break;
 	default:
 		if (ch->beacon_found)
-			ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
-				       IEEE80211_CHAN_PASSIVE_SCAN);
+			ch->flags &= ~IEEE80211_CHAN_NO_IR;
 	}
 }
 
@@ -334,8 +323,7 @@ static void ath_reg_apply_radar_flags(struct wiphy *wiphy)
 		 */
 		if (!(ch->flags & IEEE80211_CHAN_DISABLED))
 			ch->flags |= IEEE80211_CHAN_RADAR |
-				     IEEE80211_CHAN_NO_IBSS |
-				     IEEE80211_CHAN_PASSIVE_SCAN;
+				     IEEE80211_CHAN_NO_IR;
 	}
 }
 
-- 
1.8.4.rc3

