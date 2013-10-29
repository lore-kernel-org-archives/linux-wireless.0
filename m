Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:46180 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751105Ab3J2WjQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 18:39:16 -0400
Received: by mail-wi0-f175.google.com with SMTP id hm4so5984322wib.8
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 15:39:15 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/3] ath: fix dynamic user regulatory domain support
Date: Tue, 29 Oct 2013 23:39:06 +0100
Message-Id: <1383086346-2096-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131029_233919_642342_15BE7640)
In-Reply-To: <1383086346-2096-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383086346-2096-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As it stands dynamic user regulatory domain support is
only possible for a few programmed regulatory domains as
a few countries do not allow for this.

The existing code however only would take advantage of
the feature if a custom world regulatory domain is used
though as that's when we clear beconing flags. We need
to lift this restriction as otherwise this feature is
pointless.

Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 5790aa2..b2c5e41 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -296,6 +296,7 @@ static void ath_force_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
 
 static void
 __ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
+				struct ath_regulatory *reg,
 				enum nl80211_reg_initiator initiator,
 				struct ieee80211_channel *ch)
 {
@@ -307,6 +308,9 @@ __ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		ath_force_clear_no_ir_chan(wiphy, ch);
 		break;
+	case NL80211_REGDOM_SET_BY_USER:
+		if (ath_reg_dyn_country_user_allow(reg))
+			ath_force_clear_no_ir_chan(wiphy, ch);
 	default:
 		if (ch->beacon_found)
 			ch->flags &= ~IEEE80211_CHAN_NO_IR;
@@ -322,6 +326,7 @@ __ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
  */
 static void
 ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
+			      struct ath_regulatory *reg,
 			      enum nl80211_reg_initiator initiator)
 {
 	enum ieee80211_band band;
@@ -335,8 +340,8 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 		sband = wiphy->bands[band];
 		for (i = 0; i < sband->n_channels; i++) {
 			ch = &sband->channels[i];
-			__ath_reg_apply_beaconing_flags(wiphy, initiator, ch);
-
+			__ath_reg_apply_beaconing_flags(wiphy, reg,
+							initiator, ch);
 		}
 	}
 }
@@ -357,7 +362,8 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
  */
 static void
 ath_reg_apply_ir_flags(struct wiphy *wiphy,
-				enum nl80211_reg_initiator initiator)
+		       struct ath_regulatory *reg,
+		       enum nl80211_reg_initiator initiator)
 {
 	struct ieee80211_supported_band *sband;
 
@@ -370,6 +376,11 @@ ath_reg_apply_ir_flags(struct wiphy *wiphy,
 		ath_force_clear_no_ir_freq(wiphy, 2467);
 		ath_force_clear_no_ir_freq(wiphy, 2472);
 		break;
+	case NL80211_REGDOM_SET_BY_USER:
+		if (!ath_reg_dyn_country_user_allow(reg))
+			break;
+		ath_force_clear_no_ir_freq(wiphy, 2467);
+		ath_force_clear_no_ir_freq(wiphy, 2472);
 	default:
 		ath_force_no_ir_freq(wiphy, 2467);
 		ath_force_no_ir_freq(wiphy, 2472);
@@ -418,12 +429,15 @@ static void ath_reg_apply_world_flags(struct wiphy *wiphy,
 	case 0x66:
 	case 0x67:
 	case 0x6C:
-		ath_reg_apply_beaconing_flags(wiphy, initiator);
+		ath_reg_apply_beaconing_flags(wiphy, reg, initiator);
 		break;
 	case 0x68:
-		ath_reg_apply_beaconing_flags(wiphy, initiator);
-		ath_reg_apply_ir_flags(wiphy, initiator);
+		ath_reg_apply_beaconing_flags(wiphy, reg, initiator);
+		ath_reg_apply_ir_flags(wiphy, reg, initiator);
 		break;
+	default:
+		if (ath_reg_dyn_country_user_allow(reg))
+			ath_reg_apply_beaconing_flags(wiphy, reg, initiator);
 	}
 }
 
-- 
1.8.4.rc3

