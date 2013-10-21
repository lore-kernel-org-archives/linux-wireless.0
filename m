Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:47598 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3JURPE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:15:04 -0400
Received: by mail-wi0-f173.google.com with SMTP id ey11so4321295wid.12
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:15:03 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 4/5] ath: simplify ath_reg_apply_beaconing_flags()
Date: Mon, 21 Oct 2013 19:14:50 +0200
Message-Id: <1382375691-25476-5-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_191510_256518_8A5651AA)
In-Reply-To: <1382375691-25476-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382375691-25476-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simplify ath_reg_apply_beaconing_flags() by making use of
thew new no-ir helper.

Cc: smihir@qti.qualcomm.com
Cc: tushnimb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 37 ++++++++++---------------------------
 1 file changed, 10 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 2188fdd..941e65b 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -224,13 +224,11 @@ static void ath_force_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
 }
 
 /*
- * N.B: These exception rules do not apply radar freqs.
+ * These exception rules do not apply radar frequencies.
  *
- * - We enable adhoc (or beaconing) if allowed by 11d
- * - We enable active scan if the channel is allowed by 11d
+ * - We enable initiating radiation if the country IE says its fine:
  * - If no country IE has been processed and a we determine we have
- *   received a beacon on a channel we can enable active scan and
- *   adhoc (or beaconing).
+ *   received a beacon on a channel we can enable initiating radiation.
  */
 static void
 ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
@@ -238,7 +236,6 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 {
 	enum ieee80211_band band;
 	struct ieee80211_supported_band *sband;
-	const struct ieee80211_reg_rule *reg_rule;
 	struct ieee80211_channel *ch;
 	unsigned int i;
 
@@ -257,27 +254,13 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 			    (ch->flags & IEEE80211_CHAN_RADAR))
 				continue;
 
-			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-				reg_rule = freq_reg_info(wiphy, ch->center_freq);
-				if (IS_ERR(reg_rule))
-					continue;
-				/*
-				 * If 11d had a rule for this channel ensure
-				 * we enable adhoc/beaconing if it allows us to
-				 * use it. Note that we would have disabled it
-				 * by applying our static world regdomain by
-				 * default during init, prior to calling our
-				 * regulatory_hint().
-				 */
-				if (!(reg_rule->flags &
-				    NL80211_RRF_NO_IBSS))
-					ch->flags &=
-					  ~IEEE80211_CHAN_NO_IBSS;
-				if (!(reg_rule->flags &
-				    NL80211_RRF_PASSIVE_SCAN))
-					ch->flags &=
-					  ~IEEE80211_CHAN_PASSIVE_SCAN;
-			} else {
+			/*
+			 * If the country IE says initiating radiation
+			 * is OK we trust that.
+			 */
+			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
+				ath_force_clear_no_ir_chan(wiphy, ch);
+			else {
 				if (ch->beacon_found)
 					ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
 					  IEEE80211_CHAN_PASSIVE_SCAN);
-- 
1.8.4.rc3

