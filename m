Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab3CDU0k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 15:26:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: mcgrof@do-not-panic.com, bzhao@marvell.com,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2] regulatory: enable channels 52-144 for world roaming
Date: Mon,  4 Mar 2013 21:26:35 +0100
Message-Id: <1362428795-7457-1-git-send-email-johannes@sipsolutions.net> (sfid-20130304_212643_730443_5FAF26DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If allowed in a country, these channels typically require
DFS so mark them as such. Channel 144 is a bit special,
it's coming in use now to allow more VHT 80 channels, but
world roaming/passive scanning is acceptable anyway. It
seems fairly unlikely that it'll be used as the control
channel for a VHT AP, but it needs to be present to allow
a full VHT connection to an AP that uses it as one of the
secondary channels.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index dee9ab4..706cfa7 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -188,7 +188,11 @@ static const struct ieee80211_regdomain world_regdom = {
                         NL80211_RRF_PASSIVE_SCAN |
                         NL80211_RRF_NO_IBSS),
 
-		/* NB: 5260 MHz - 5700 MHz requires DFS */
+		/* IEEE 802.11a, channel 52..144 - DFS required */
+		REG_RULE(5260-10, 5720+10, 80, 6, 20,
+			NL80211_RRF_PASSIVE_SCAN |
+			NL80211_RRF_NO_IBSS |
+			NL80211_RRF_DFS),
 
 		/* IEEE 802.11a, channel 149..165 */
 		REG_RULE(5745-10, 5825+10, 80, 6, 20,
-- 
1.8.0

