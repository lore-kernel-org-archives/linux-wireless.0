Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:33436 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753663Ab0JTRTG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Oct 2010 13:19:06 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 20 Oct 2010 10:18:56 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>
CC: <easwar.krishnan@atheros.com>, <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>
Subject: [PATCH 2/7] cfg80211: fix allowing country IEs for WIPHY_FLAG_STRICT_REGULATORY
Date: Wed, 20 Oct 2010 10:18:54 -0700
Message-ID: <1287595139-10761-3-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
References: <1287595139-10761-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We should be enabling country IE hints for WIPHY_FLAG_STRICT_REGULATORY
even if we haven't yet recieved regulatory domain hint for the driver
if it needed one. Without this Country IEs are not passed on to drivers
that have set WIPHY_FLAG_STRICT_REGULATORY, today this is just all
Atheros chipset drivers: ath5k, ath9k, ar9170, carl9170.

This was part of the original design, however it was completely
overlooked...

Cc: Easwar Krishnan <easwar.krishnan@atheros.com>
Cc: stable@kernel.org
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 include/net/cfg80211.h |   15 ++++++++-------
 net/wireless/reg.c     |    1 +
 2 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 2a7936d..352ebc5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1321,13 +1321,14 @@ struct cfg80211_ops {
  * 	initiator is %REGDOM_SET_BY_CORE).
  * @WIPHY_FLAG_STRICT_REGULATORY: tells us the driver for this device will
  *	ignore regulatory domain settings until it gets its own regulatory
- *	domain via its regulatory_hint(). After its gets its own regulatory
- *	domain it will only allow further regulatory domain settings to
- *	further enhance compliance. For example if channel 13 and 14 are
- *	disabled by this regulatory domain no user regulatory domain can
- *	enable these channels at a later time. This can be used for devices
- *	which do not have calibration information gauranteed for frequencies
- *	or settings outside of its regulatory domain.
+ *	domain via its regulatory_hint() unless the regulatory hint is
+ *	from a country IE. After its gets its own regulatory domain it will
+ *	only allow further regulatory domain settings to further enhance
+ *	compliance. For example if channel 13 and 14 are disabled by this
+ *	regulatory domain no user regulatory domain can enable these channels
+ *	at a later time. This can be used for devices which do not have
+ *	calibration information gauranteed for frequencies or settings
+ *	outside of its regulatory domain.
  * @WIPHY_FLAG_DISABLE_BEACON_HINTS: enable this if your driver needs to ensure
  *	that passive scan flags and beaconing flags may not be lifted by
  *	cfg80211 due to regulatory beacon hints. For more information on beacon
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b64596f..1bc8131 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -813,6 +813,7 @@ static bool ignore_reg_update(struct wiphy *wiphy,
 	 * desired regulatory domain set
 	 */
 	if (wiphy->flags & WIPHY_FLAG_STRICT_REGULATORY && !wiphy->regd &&
+	    initiator != NL80211_REGDOM_SET_BY_COUNTRY_IE &&
 	    !is_world_regdom(last_request->alpha2))
 		return true;
 	return false;
-- 
1.7.0.4

