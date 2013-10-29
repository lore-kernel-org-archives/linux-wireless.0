Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f176.google.com ([74.125.82.176]:45280 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579Ab3J2XLF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 19:11:05 -0400
Received: by mail-we0-f176.google.com with SMTP id w62so547894wes.35
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 16:11:03 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH v2 3/3] ath: fix dynamic user regulatory domain support
Date: Wed, 30 Oct 2013 00:10:07 +0100
Message-Id: <1383088207-2516-1-git-send-email-mcgrof@do-not-panic.com> (sfid-20131030_001109_235596_5FD9C99E)
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

This fixes the issues spotted by Joe.

 drivers/net/wireless/ath/regd.c | 28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 5790aa2..3480201 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -296,6 +296,7 @@ static void ath_force_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
 
 static void
 __ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
+				struct ath_regulatory *reg,
 				enum nl80211_reg_initiator initiator,
 				struct ieee80211_channel *ch)
 {
@@ -307,6 +308,10 @@ __ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
 		ath_force_clear_no_ir_chan(wiphy, ch);
 		break;
+	case NL80211_REGDOM_SET_BY_USER:
+		if (ath_reg_dyn_country_user_allow(reg))
+			ath_force_clear_no_ir_chan(wiphy, ch);
+		break;
 	default:
 		if (ch->beacon_found)
 			ch->flags &= ~IEEE80211_CHAN_NO_IR;
@@ -322,6 +327,7 @@ __ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
  */
 static void
 ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
+			      struct ath_regulatory *reg,
 			      enum nl80211_reg_initiator initiator)
 {
 	enum ieee80211_band band;
@@ -335,8 +341,8 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
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
@@ -357,7 +363,8 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
  */
 static void
 ath_reg_apply_ir_flags(struct wiphy *wiphy,
-				enum nl80211_reg_initiator initiator)
+		       struct ath_regulatory *reg,
+		       enum nl80211_reg_initiator initiator)
 {
 	struct ieee80211_supported_band *sband;
 
@@ -370,6 +377,12 @@ ath_reg_apply_ir_flags(struct wiphy *wiphy,
 		ath_force_clear_no_ir_freq(wiphy, 2467);
 		ath_force_clear_no_ir_freq(wiphy, 2472);
 		break;
+	case NL80211_REGDOM_SET_BY_USER:
+		if (!ath_reg_dyn_country_user_allow(reg))
+			break;
+		ath_force_clear_no_ir_freq(wiphy, 2467);
+		ath_force_clear_no_ir_freq(wiphy, 2472);
+		break;
 	default:
 		ath_force_no_ir_freq(wiphy, 2467);
 		ath_force_no_ir_freq(wiphy, 2472);
@@ -418,12 +431,15 @@ static void ath_reg_apply_world_flags(struct wiphy *wiphy,
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

