Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53276 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760454Ab3BMXsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 18:48:00 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, green@qca.qualcomm.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 1/3] regulatory: allow VHT channels in world roaming
Date: Thu, 14 Feb 2013 00:47:52 +0100
Message-Id: <1360799274-16088-2-git-send-email-johannes@sipsolutions.net> (sfid-20130214_004810_651220_97A30DEF)
In-Reply-To: <1360799274-16088-1-git-send-email-johannes@sipsolutions.net>
References: <1360799274-16088-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For VHT, the wider bandwidths (up to 160 MHz) need
to be allowed. Since world roaming only covers the
case of connecting to an AP, it can be opened up
there, we will rely on the AP to know the local
regulations.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index e97d5b0..bf35e1f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -184,14 +184,14 @@ static const struct ieee80211_regdomain world_regdom = {
 			NL80211_RRF_NO_IBSS |
 			NL80211_RRF_NO_OFDM),
 		/* IEEE 802.11a, channel 36..48 */
-		REG_RULE(5180-10, 5240+10, 40, 6, 20,
+		REG_RULE(5180-10, 5240+10, 80, 6, 20,
                         NL80211_RRF_PASSIVE_SCAN |
                         NL80211_RRF_NO_IBSS),
 
-		/* NB: 5260 MHz - 5700 MHz requies DFS */
+		/* NB: 5260 MHz - 5700 MHz requires DFS */
 
 		/* IEEE 802.11a, channel 149..165 */
-		REG_RULE(5745-10, 5825+10, 40, 6, 20,
+		REG_RULE(5745-10, 5825+10, 80, 6, 20,
 			NL80211_RRF_PASSIVE_SCAN |
 			NL80211_RRF_NO_IBSS),
 
-- 
1.8.0

