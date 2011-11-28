Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53749 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753955Ab1K1WXS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Nov 2011 17:23:18 -0500
Received: by mail-vw0-f46.google.com with SMTP id fc26so4223399vbb.19
        for <linux-wireless@vger.kernel.org>; Mon, 28 Nov 2011 14:23:18 -0800 (PST)
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
To: linux-wireless@vger.kernel.org
Cc: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	compat@orbit-lab.org, Paul Stewart <pstew@google.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>
Subject: [RFC v2 1/2] cfg80211: allow following country IE power for custom regdom cards
Date: Mon, 28 Nov 2011 17:23:10 -0500
Message-Id: <1322518991-7040-2-git-send-email-mcgrof@qca.qualcomm.com> (sfid-20111128_232322_083083_3021B599)
In-Reply-To: <1322518991-7040-1-git-send-email-mcgrof@qca.qualcomm.com>
References: <1322518991-7040-1-git-send-email-mcgrof@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

By definition WIPHY_FLAG_STRICT_REGULATORY was intended to allow the
wiphy to adjust itself to the country IE power information if the
card had no regulatory data but we had no way to tell cfg80211 that if
the card also had its own custom regulatory domain (these are typically
custom world regulatory domains) that we want to follow the country IE's
noted values for power for each channel. We add support for this and
document it.

This is not a critical fix but a performance optimization for cards
with custom regulatory domains that associate to an AP with sends
out country IEs with a higher EIRP than the one on the custom
regulatory domain. In practice the only driver affected right now
are the Atheros drivers as they are the only drivers using both
WIPHY_FLAG_STRICT_REGULATORY and WIPHY_FLAG_CUSTOM_REGULATORY --
used on cards that have an Atheros world regulatory domain. Cards
that have been programmed to follow a country specifically will not
follow the country IE power. So although not a stable fix distributions
should consider cherry picking this.

Cc: compat@orbit-lab.org
Cc: Paul Stewart <pstew@google.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: Senthilkumar Balasubramanian <senthilb@qca.qualcomm.com>
Reported-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
---
 include/net/cfg80211.h |    4 +++-
 net/wireless/reg.c     |   20 ++++++++++++++++----
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a992782..d21d764 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1684,7 +1684,9 @@ struct cfg80211_ops {
  *	regulatory domain no user regulatory domain can enable these channels
  *	at a later time. This can be used for devices which do not have
  *	calibration information guaranteed for frequencies or settings
- *	outside of its regulatory domain.
+ *	outside of its regulatory domain. If used in combination with
+ *	WIPHY_FLAG_CUSTOM_REGULATORY the inspected country IE power settings
+ *	will be followed.
  * @WIPHY_FLAG_DISABLE_BEACON_HINTS: enable this if your driver needs to ensure
  *	that passive scan flags and beaconing flags may not be lifted by
  *	cfg80211 due to regulatory beacon hints. For more information on beacon
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index d9ba091..4fe396a 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -873,10 +873,22 @@ static void handle_channel(struct wiphy *wiphy,
 	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
 	chan->max_antenna_gain = min(chan->orig_mag,
 		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
-	if (chan->orig_mpwr)
-		chan->max_power = min(chan->orig_mpwr,
-			(int) MBM_TO_DBM(power_rule->max_eirp));
-	else
+	if (chan->orig_mpwr) {
+		/*
+		 * Devices that have their own custom regulatory domain
+		 * but also use WIPHY_FLAG_STRICT_REGULATORY will follow the
+		 * passed country IE power settings.
+		 */
+		if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE &&
+		    wiphy->flags & WIPHY_FLAG_CUSTOM_REGULATORY &&
+		    wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY) {
+			chan->max_power =
+				MBM_TO_DBM(power_rule->max_eirp);
+		} else {
+			chan->max_power = min(chan->orig_mpwr,
+				(int) MBM_TO_DBM(power_rule->max_eirp));
+		}
+	} else
 		chan->max_power = (int) MBM_TO_DBM(power_rule->max_eirp);
 }
 
-- 
1.7.4.15.g7811d

