Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34726 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753485AbYJ3BUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 21:20:04 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 18:20:04 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 6/6] cfg80211: enable 5 GHz band for world regulatory domain
Date: Wed, 29 Oct 2008 18:19:54 -0700
Message-ID: <1225329594-21704-7-git-send-email-lrodriguez@atheros.com> (sfid-20081030_022013_367470_5A2A7AD7)
In-Reply-To: <1225329594-21704-6-git-send-email-lrodriguez@atheros.com>
References: <1225329594-21704-1-git-send-email-lrodriguez@atheros.com>
 <1225329594-21704-2-git-send-email-lrodriguez@atheros.com>
 <1225329594-21704-3-git-send-email-lrodriguez@atheros.com>
 <1225329594-21704-4-git-send-email-lrodriguez@atheros.com>
 <1225329594-21704-5-git-send-email-lrodriguez@atheros.com>
 <1225329594-21704-6-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Technically speaking since some countries do not support
some channels in 5 GHz the world regulatory domain should not
use them however APs should *not* be shipped in those countries
which don't allow 5 GHz operation. Because of this we can
safely assume we operate correctly in STA mode by forcing
passive scan and disabling ad-hoc in 5 GHz. We leave out
all DFS channels as we don't support DFS yet.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   12 +++++++++++-
 1 files changed, 11 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index dd1020b..ce0c730 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -85,7 +85,11 @@ static u32 supported_bandwidths[] = {
  * information to give us an alpha2 */
 static const struct ieee80211_regdomain *cfg80211_regdomain;
 
-/* We keep a static world regulatory domain in case of the absence of CRDA */
+/* We keep a static world regulatory domain in case of the absence of CRDA.
+ * Although some countries disable 5 GHz completely it is up to the APs
+ * sold in those countries to not beacon, we can safely passive scan though
+ * on non DFS channels. We don't support yet DFS so don't include DFS
+ * channels yet (5260 MHz - 5700 MHz) */
 static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 1,
 	.alpha2 =  "00",
@@ -93,6 +97,12 @@ static const struct ieee80211_regdomain world_regdom = {
 		REG_RULE(2412-10, 2462+10, 40, 6, 20,
 			NL80211_RRF_PASSIVE_SCAN |
 			NL80211_RRF_NO_IBSS),
+		REG_RULE(5170, 5260, 40, 6, 20,
+			NL80211_RRF_PASSIVE_SCAN |
+			NL80211_RRF_NO_IBSS),
+		REG_RULE(5700, 5835, 40, 6, 20,
+			NL80211_RRF_PASSIVE_SCAN |
+			NL80211_RRF_NO_IBSS),
 	}
 };
 
-- 
1.5.6.3

