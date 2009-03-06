Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:15908 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbZCFFUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 00:20:04 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2009 21:20:03 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 1/2] cfg80211: Enable passive scan on channels 12-14 for world roaming
Date: Thu, 5 Mar 2009 21:19:21 -0800
Message-ID: <1236316762-10348-1-git-send-email-lrodriguez@atheros.com> (sfid-20090306_062008_344054_F159B427)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index ce66bfd..3f438fb 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -86,15 +86,26 @@ struct reg_beacon {
 
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
-	.n_reg_rules = 3,
+	.n_reg_rules = 5,
 	.alpha2 =  "00",
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..11 */
 		REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
-		/* IEEE 802.11a, channel 36..48 */
-		REG_RULE(5180-10, 5240+10, 40, 6, 23,
+		/* IEEE 802.11b/g, channels 12..13. No HT40
+		 * channel fits here. */
+		REG_RULE(2467-10, 2472+10, 20, 6, 20,
 			NL80211_RRF_PASSIVE_SCAN |
 			NL80211_RRF_NO_IBSS),
+		/* IEEE 802.11 channel 14 - Only JP enables
+		 * this and for 802.11b only */
+		REG_RULE(2484-10, 2484+10, 20, 6, 20,
+			NL80211_RRF_PASSIVE_SCAN |
+			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_NO_OFDM),
+		/* IEEE 802.11a, channel 36..48 */
+		REG_RULE(5180-10, 5240+10, 40, 6, 23,
+                        NL80211_RRF_PASSIVE_SCAN |
+                        NL80211_RRF_NO_IBSS),
 
 		/* NB: 5260 MHz - 5700 MHz requies DFS */
 
-- 
1.6.1.2.253.ga34a

