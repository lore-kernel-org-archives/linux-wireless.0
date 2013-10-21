Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:57234 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383Ab3JURPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:15:03 -0400
Received: by mail-wi0-f172.google.com with SMTP id ez12so4311871wid.11
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:15:01 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 3/5] ath: rename ath_reg_apply_active_scan_flags() to ath_reg_apply_ir_flags()
Date: Mon, 21 Oct 2013 19:14:49 +0200
Message-Id: <1382375691-25476-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_191507_026126_38EFF1BB)
In-Reply-To: <1382375691-25476-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382375691-25476-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This also applies the no-ibss flag to the channels or clears it.
The idea here is to clarify no initiated radiation should be
allowed on these channels.

Cc: smihir@qti.qualcomm.com
Cc: tushnimb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 48e2368..2188fdd 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -189,6 +189,10 @@ static void ath_force_clear_no_ir_chan(struct wiphy *wiphy,
 	if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 		if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
 			ch->flags &= ~IEEE80211_CHAN_PASSIVE_SCAN;
+
+	if (!(reg_rule->flags & IEEE80211_CHAN_NO_IBSS))
+		if (ch->flags & IEEE80211_CHAN_NO_IBSS)
+			ch->flags &= ~IEEE80211_CHAN_NO_IBSS;
 }
 
 static void ath_force_clear_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
@@ -205,6 +209,7 @@ static void ath_force_clear_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
 static void ath_force_no_ir_chan(struct ieee80211_channel *ch)
 {
 	ch->flags |= IEEE80211_CHAN_PASSIVE_SCAN;
+	ch->flags |= IEEE80211_CHAN_NO_IBSS;
 }
 
 static void ath_force_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
@@ -283,7 +288,7 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 }
 
 /**
- * ath_reg_apply_active_scan_flags()
+ * ath_reg_apply_ir_flags()
  * @wiphy: the wiphy to use
  * @initiator: the regulatory hint initiator
  *
@@ -297,7 +302,7 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
  * custom regulatory domain.
  */
 static void
-ath_reg_apply_active_scan_flags(struct wiphy *wiphy,
+ath_reg_apply_ir_flags(struct wiphy *wiphy,
 				enum nl80211_reg_initiator initiator)
 {
 	struct ieee80211_supported_band *sband;
@@ -364,7 +369,7 @@ static void ath_reg_apply_world_flags(struct wiphy *wiphy,
 		break;
 	case 0x68:
 		ath_reg_apply_beaconing_flags(wiphy, initiator);
-		ath_reg_apply_active_scan_flags(wiphy, initiator);
+		ath_reg_apply_ir_flags(wiphy, initiator);
 		break;
 	}
 }
-- 
1.8.4.rc3

