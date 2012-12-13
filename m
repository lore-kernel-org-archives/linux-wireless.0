Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54490 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab2LMXTp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 18:19:45 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Felix Bitterli <felixb@qca.qualcomm.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: adjacent 80+80 MHz channel segments are invalid
Date: Fri, 14 Dec 2012 00:20:04 +0100
Message-Id: <1355440804-19655-1-git-send-email-johannes@sipsolutions.net> (sfid-20121214_001948_366263_8E9860D5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In that case, it's really a 160 MHz channel, so disallow
this configuration.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/chan.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 10b3475..9e004a5 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -77,6 +77,10 @@ bool cfg80211_chandef_valid(const struct cfg80211_chan_def *chandef)
 			return false;
 		if (!chandef->center_freq2)
 			return false;
+		/* adjacent is not allowed -- that's a 160 MHz channel */
+		if (chandef->center_freq1 - chandef->center_freq2 == 80 ||
+		    chandef->center_freq2 - chandef->center_freq1 == 80)
+			return false;
 		break;
 	case NL80211_CHAN_WIDTH_80:
 		if (chandef->center_freq1 != control_freq + 30 &&
-- 
1.8.0

