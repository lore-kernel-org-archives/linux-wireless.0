Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45636 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790Ab3JURPG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Oct 2013 13:15:06 -0400
Received: by mail-wg0-f47.google.com with SMTP id c11so6771197wgh.26
        for <linux-wireless@vger.kernel.org>; Mon, 21 Oct 2013 10:15:05 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, janusz.dziedzic@tieto.com,
	smihir@qti.qualcomm.com, tushnimb@qca.qualcomm.com,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Subject: [PATCH 5/5] ath: move the channel for ath_reg_apply_beaconing_flags() into helper
Date: Mon, 21 Oct 2013 19:14:51 +0200
Message-Id: <1382375691-25476-6-git-send-email-mcgrof@do-not-panic.com> (sfid-20131021_191514_063631_1644D417)
In-Reply-To: <1382375691-25476-1-git-send-email-mcgrof@do-not-panic.com>
References: <1382375691-25476-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While at it convert this into a switch statement, this
makes it easier and manage.

Cc: smihir@qti.qualcomm.com
Cc: tushnimb@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/ath/regd.c | 41 +++++++++++++++++++++--------------------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/regd.c b/drivers/net/wireless/ath/regd.c
index 941e65b..14d3614 100644
--- a/drivers/net/wireless/ath/regd.c
+++ b/drivers/net/wireless/ath/regd.c
@@ -223,6 +223,26 @@ static void ath_force_no_ir_freq(struct wiphy *wiphy, u16 center_freq)
 	ath_force_no_ir_chan(ch);
 }
 
+static void
+__ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
+				enum nl80211_reg_initiator initiator,
+				struct ieee80211_channel *ch)
+{
+	if (ath_is_radar_freq(ch->center_freq) ||
+	    (ch->flags & IEEE80211_CHAN_RADAR))
+		return;
+
+	switch (initiator) {
+	case NL80211_REGDOM_SET_BY_COUNTRY_IE:
+		ath_force_clear_no_ir_chan(wiphy, ch);
+		break;
+	default:
+		if (ch->beacon_found)
+			ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
+				       IEEE80211_CHAN_PASSIVE_SCAN);
+	}
+}
+
 /*
  * These exception rules do not apply radar frequencies.
  *
@@ -240,34 +260,15 @@ ath_reg_apply_beaconing_flags(struct wiphy *wiphy,
 	unsigned int i;
 
 	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
-
 		if (!wiphy->bands[band])
 			continue;
-
 		sband = wiphy->bands[band];
-
 		for (i = 0; i < sband->n_channels; i++) {
-
 			ch = &sband->channels[i];
+			__ath_reg_apply_beaconing_flags(wiphy, initiator, ch);
 
-			if (ath_is_radar_freq(ch->center_freq) ||
-			    (ch->flags & IEEE80211_CHAN_RADAR))
-				continue;
-
-			/*
-			 * If the country IE says initiating radiation
-			 * is OK we trust that.
-			 */
-			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE)
-				ath_force_clear_no_ir_chan(wiphy, ch);
-			else {
-				if (ch->beacon_found)
-					ch->flags &= ~(IEEE80211_CHAN_NO_IBSS |
-					  IEEE80211_CHAN_PASSIVE_SCAN);
-			}
 		}
 	}
-
 }
 
 /**
-- 
1.8.4.rc3

