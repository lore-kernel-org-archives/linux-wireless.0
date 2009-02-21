Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54060 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbZBUFUr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Feb 2009 00:20:47 -0500
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 2/5] cfg80211: enable 5 GHz world roaming channels
Date: Sat, 21 Feb 2009 00:20:38 -0500
Message-Id: <1235193641-17993-3-git-send-email-lrodriguez@atheros.com> (sfid-20090221_062057_208748_B18D2032)
In-Reply-To: <1235193641-17993-1-git-send-email-lrodriguez@atheros.com>
References: <1235193641-17993-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current static world regulatory domain is too restrictive,
we can use some 5 GHz channels world wide so long as they do not
touch frequencies which require DFS. The compromise is we must
also enforce passive scanning and disallow usage of a mode of
operation that beacons: (AP | IBSS | Mesh)

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   13 ++++++++++++-
 1 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 85c2c31..da2a8ac 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -73,11 +73,22 @@ static spinlock_t reg_requests_lock;
 
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
-	.n_reg_rules = 1,
+	.n_reg_rules = 3,
 	.alpha2 =  "00",
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..11 */
 		REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
+		/* IEEE 802.11a, channel 36..48 */
+		REG_RULE(5180-10, 5240+10, 40, 6, 23,
+			NL80211_RRF_PASSIVE_SCAN |
+			NL80211_RRF_NO_IBSS),
+
+		/* NB: 5260 MHz - 5700 MHz requies DFS */
+
+		/* IEEE 802.11a, channel 149..165 */
+		REG_RULE(5745-10, 5825+10, 40, 6, 23,
+			NL80211_RRF_PASSIVE_SCAN |
+			NL80211_RRF_NO_IBSS),
 	}
 };
 
-- 
1.6.0.3

