Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:59230 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033Ab3EPVG6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 May 2013 17:06:58 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, bzhao@marvell.com,
	wireless-regdb@lists.infradead.org,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] regulatory: enable channels 52-64 and 100-144 for world roaming
Date: Thu, 16 May 2013 23:06:52 +0200
Message-Id: <1368738412-7740-1-git-send-email-johannes@sipsolutions.net> (sfid-20130516_230701_952159_6F4C91F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If allowed in a country, these channels typically require DFS
so mark them as such. Channel 144 is a bit special, it's coming
into use now to allow more VHT 80 channels, but world roaming
with passive scanning is acceptable anyway. It seems fairly
unlikely that it'll be used as the control channel for a VHT
AP, but it needs to be present to allow a full VHT connection
to an AP that uses it as one of the secondary channels.

Also enable VHT 160 on these channels, and also for channels
36-48 to be able to use VHT 160 there.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index cc35fba..e713051 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -184,11 +184,21 @@ static const struct ieee80211_regdomain world_regdom = {
 			NL80211_RRF_NO_IBSS |
 			NL80211_RRF_NO_OFDM),
 		/* IEEE 802.11a, channel 36..48 */
-		REG_RULE(5180-10, 5240+10, 80, 6, 20,
+		REG_RULE(5180-10, 5240+10, 160, 6, 20,
                         NL80211_RRF_PASSIVE_SCAN |
                         NL80211_RRF_NO_IBSS),
 
-		/* NB: 5260 MHz - 5700 MHz requires DFS */
+		/* IEEE 802.11a, channel 52..64 - DFS required */
+		REG_RULE(5260-10, 5320+10, 160, 6, 20,
+			NL80211_RRF_PASSIVE_SCAN |
+			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_DFS),
+
+		/* IEEE 802.11a, channel 100..144 - DFS required */
+		REG_RULE(5500-10, 5720+10, 160, 6, 20,
+			NL80211_RRF_PASSIVE_SCAN |
+			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_DFS),
 
 		/* IEEE 802.11a, channel 149..165 */
 		REG_RULE(5745-10, 5825+10, 80, 6, 20,
-- 
1.8.0

