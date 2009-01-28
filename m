Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:18592 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZA1USk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 15:18:40 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 12:18:40 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 3/3] ath9k: remove passive scan on 5 GHz if country IE knows better
Date: Wed, 28 Jan 2009 12:17:49 -0800
Message-ID: <1233173869-16512-4-git-send-email-lrodriguez@atheros.com> (sfid-20090128_211846_700818_6EBAEBBF)
In-Reply-To: <1233173869-16512-3-git-send-email-lrodriguez@atheros.com>
References: <1233173869-16512-1-git-send-email-lrodriguez@atheros.com>
 <1233173869-16512-2-git-send-email-lrodriguez@atheros.com>
 <1233173869-16512-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If we have new found information about our location and the
current country regulatory domain does not have passive scan
flag requirements we should be able to actively scan now on those
channels.

Since AP functionality is not allowed where passive scan flags are
set this means if you have a world regulatory domain and you get a
country IE that allows that channel (with active scan) then we lift
the passive-scan requirement so you can then use AP mode.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/regd.c |   16 ++++++++++++----
 1 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/regd.c b/drivers/net/wireless/ath9k/regd.c
index cccec40..dfcc3b5 100644
--- a/drivers/net/wireless/ath9k/regd.c
+++ b/drivers/net/wireless/ath9k/regd.c
@@ -160,8 +160,12 @@ static bool ath9k_is_radar_freq(u16 center_freq)
 	return (center_freq >= 5260 && center_freq <= 5700);
 }
 
-/* Enable adhoc on 5 GHz if allowed by 11d */
-static void ath9k_reg_apply_5ghz_adhoc_flags(struct wiphy *wiphy,
+/*
+ * Enable adhoc on 5 GHz if allowed by 11d.
+ * Remove passive scan if channel is allowed by 11d,
+ * except when on radar frequencies.
+ */
+static void ath9k_reg_apply_5ghz_beaconing_flags(struct wiphy *wiphy,
 					     enum reg_set_by setby)
 {
 	struct ieee80211_supported_band *sband;
@@ -189,6 +193,10 @@ static void ath9k_reg_apply_5ghz_adhoc_flags(struct wiphy *wiphy,
 		 * probe */
 		if (!(reg_rule->flags & NL80211_RRF_NO_IBSS))
 			ch->flags &= ~NL80211_RRF_NO_IBSS;
+		if (!ath9k_is_radar_freq(ch->center_freq))
+			continue;
+		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
+			ch->flags &= ~NL80211_RRF_PASSIVE_SCAN;
 	}
 }
 
@@ -283,10 +291,10 @@ void ath9k_reg_apply_world_flags(struct wiphy *wiphy, enum reg_set_by setby)
 	case 0x63:
 	case 0x66:
 	case 0x67:
-		ath9k_reg_apply_5ghz_adhoc_flags(wiphy, setby);
+		ath9k_reg_apply_5ghz_beaconing_flags(wiphy, setby);
 		break;
 	case 0x68:
-		ath9k_reg_apply_5ghz_adhoc_flags(wiphy, setby);
+		ath9k_reg_apply_5ghz_beaconing_flags(wiphy, setby);
 		ath9k_reg_apply_active_scan_flags(wiphy, setby);
 		break;
 	}
-- 
1.6.1.rc3.51.g5832d

