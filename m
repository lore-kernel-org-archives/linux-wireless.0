Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:50427 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3JURXF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:23:05 -0400
Received: by mail-wi0-f176.google.com with SMTP id l12so4327465wiv.15
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:23:04 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 09/14] rtlwifi: consolidate no-ibss and passive scan to no-ir
Date: Mon, 21 Oct 2013 19:22:33 +0200
Message-Id: <1382376158-25586-10-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_193807_685627_4D2F34BD)
In-Reply-To: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382376158-25586-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Cc: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/rtlwifi/regd.c | 48 ++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index d7d0d49..2e1642c 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -59,30 +59,27 @@ static struct country_code_to_enum_rd allCountries[] = {
  */
 #define RTL819x_2GHZ_CH12_13	\
 	REG_RULE(2467-10, 2472+10, 40, 0, 20,\
-	NL80211_RRF_PASSIVE_SCAN)
+	NL80211_RRF_NO_IR)
 
 #define RTL819x_2GHZ_CH14	\
 	REG_RULE(2484-10, 2484+10, 40, 0, 20, \
-	NL80211_RRF_PASSIVE_SCAN | \
+	NL80211_RRF_NO_IR | \
 	NL80211_RRF_NO_OFDM)
 
 /* 5G chan 36 - chan 64*/
 #define RTL819x_5GHZ_5150_5350	\
 	REG_RULE(5150-10, 5350+10, 40, 0, 30, \
-	NL80211_RRF_PASSIVE_SCAN | \
-	NL80211_RRF_NO_IBSS)
+	NL80211_RRF_NO_IR)
 
 /* 5G chan 100 - chan 165*/
 #define RTL819x_5GHZ_5470_5850	\
 	REG_RULE(5470-10, 5850+10, 40, 0, 30, \
-	NL80211_RRF_PASSIVE_SCAN | \
-	NL80211_RRF_NO_IBSS)
+	NL80211_RRF_NO_IR)
 
 /* 5G chan 149 - chan 165*/
 #define RTL819x_5GHZ_5725_5850	\
 	REG_RULE(5725-10, 5850+10, 40, 0, 30, \
-	NL80211_RRF_PASSIVE_SCAN | \
-	NL80211_RRF_NO_IBSS)
+	NL80211_RRF_NO_IR)
 
 #define RTL819x_5GHZ_ALL	\
 	(RTL819x_5GHZ_5150_5350, RTL819x_5GHZ_5470_5850)
@@ -185,16 +182,12 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 				 *regulatory_hint().
 				 */
 
-				if (!(reg_rule->flags & NL80211_RRF_NO_IBSS))
-					ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
-				if (!(reg_rule->
-				     flags & NL80211_RRF_PASSIVE_SCAN))
-					ch->flags &=
-					    ~IEEE80211_CHAN_PASSIVE_SCAN;
+				if (!(reg_rule->flags & NL80211_RRF_NO_IR))
+					ch->flags &= ~IEEE80211_CHAN_NO_IR;
 			} else {
 				if (ch->beacon_found)
-					ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
-						  IEEE80211_CHAN_PASSIVE_SCAN);
+					ch->flags &= ~(IEEE80211_CHAN_NO_IR |
+						  IEEE80211_CHAN_NO_IR);
 			}
 		}
 	}
@@ -219,11 +212,11 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	 */
 	if (initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 		ch = &sband->channels[11];	/* CH 12 */
-		if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+		if (ch->flags & IEEE80211_CHAN_NO_IR)
+			ch->flags &= ~IEEE80211_CHAN_NO_IR;
 		ch = &sband->channels[12];	/* CH 13 */
-		if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+		if (ch->flags & IEEE80211_CHAN_NO_IR)
+			ch->flags &= ~IEEE80211_CHAN_NO_IR;
 		return;
 	}
 
@@ -237,17 +230,17 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	ch = &sband->channels[11];	/* CH 12 */
 	reg_rule = freq_reg_info(wiphy, ch->center_freq);
 	if (!IS_ERR(reg_rule)) {
-		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
-			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-				ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+		if (!(reg_rule->flags & NL80211_RRF_NO_IR))
+			if (ch->flags & IEEE80211_CHAN_NO_IR)
+				ch->flags &= ~IEEE80211_CHAN_NO_IR;
 	}
 
 	ch = &sband->channels[12];	/* CH 13 */
 	reg_rule = freq_reg_info(wiphy, ch->center_freq);
 	if (!IS_ERR(reg_rule)) {
-		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
-			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-				ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+		if (!(reg_rule->flags & NL80211_RRF_NO_IR))
+			if (ch->flags & IEEE80211_CHAN_NO_IR)
+				ch->flags &= ~IEEE80211_CHAN_NO_IR;
 	}
 }
 
@@ -284,8 +277,7 @@ static void _rtl_reg_apply_radar_flags(struct wiphy *wiphy)
 		 */
 		if (!(ch->flags & IEEE80211_CHAN_DISABLED))
 			ch->flags |= IEEE80211_CHAN_RADAR |
-			    IEEE80211_CHAN_NO_IBSS |
-			    IEEE80211_CHAN_PASSIVE_SCAN;
+			    IEEE80211_CHAN_NO_IR;
 	}
 }
 
-- 
1.8.4.rc3

