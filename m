Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:35868 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab2IWHuJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Sep 2012 03:50:09 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v3] cfg80211: Fix regulatory check for 60GHz band frequencies
Date: Sun, 23 Sep 2012 09:49:54 +0200
Message-ID: <1348386594-6067-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120923_095058_453470_4AE52433)
In-Reply-To: <1348386594-6067-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1348386594-6067-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current regulatory code on cfg80211 performs a check to
see if a regulatory rule belongs to an IEEE band so that if
a Country IE is received and no rules are specified for a
band (which is allowed by IEEE) those bands are left intact.
The current band check assumes a rule is bound to a band
if the rule's start or end frequency is less than 2 GHz
apart from the center of frequency being inspected.

In order to support 60 GHz for 802.11ad we need to increase
this to account for the channel spacing of 2160 MHz whereby
a channel somewhere in the middle of a regulatory rule may
be more than 2 MHz apart from either the beginning or
end of the frequency rule.

Without a fix for this even though channels 1-3 are allowed world
wide on the rule (57240 - 63720 @ 2160), channel 2 at 60480 MHz
will end up getting disabled given that it is 3240 MHz from
both the frequency rule start and end frequency. Fix this by
using 2 GHz separation assumption for the 2.4 and 5 GHz bands
but for 60 GHz use a 10 GHz separation before assuming a rule
is not part of the band.

Since we have no 802.11ad drivers yet merged this change has
no impact to existing Linux upstream device drivers.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 net/wireless/reg.c |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4de18ae..7ceb8c5 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -510,9 +510,11 @@ static bool reg_does_bw_fit(const struct ieee80211_freq_range *freq_range,
  *
  * This lets us know if a specific frequency rule is or is not relevant to
  * a specific frequency's band. Bands are device specific and artificial
- * definitions (the "2.4 GHz band" and the "5 GHz band"), however it is
- * safe for now to assume that a frequency rule should not be part of a
- * frequency's band if the start freq or end freq are off by more than 2 GHz.
+ * definitions (the "2.4 GHz band", the "5 GHz band" and the "60GHz band"),
+ * however it is safe for now to assume that a frequency rule should not be
+ * part of a frequency's band if the start freq or end freq are off by more
+ * than 2 GHz for the 2.4 and 5 GHz bands, and by more then 10 GHz for the
+ * 60 GHz band.
  * This resolution can be lowered and should be considered as we add
  * regulatory rule support for other "bands".
  **/
@@ -520,9 +522,16 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
 	u32 freq_khz)
 {
 #define ONE_GHZ_IN_KHZ	1000000
-	if (abs(freq_khz - freq_range->start_freq_khz) <= (2 * ONE_GHZ_IN_KHZ))
+	/*
+	 * From 802.11ad: directional multi-gigabit (DMG):
+	 * Pertaining to operation in a frequency band containing a channel
+	 * with the Channel starting frequency above 45 GHz.
+	 */
+	u32 limit = freq_khz > 45 * ONE_GHZ_IN_KHZ ?
+			10 * ONE_GHZ_IN_KHZ : 2 * ONE_GHZ_IN_KHZ;
+	if (abs(freq_khz - freq_range->start_freq_khz) <= limit)
 		return true;
-	if (abs(freq_khz - freq_range->end_freq_khz) <= (2 * ONE_GHZ_IN_KHZ))
+	if (abs(freq_khz - freq_range->end_freq_khz) <= limit)
 		return true;
 	return false;
 #undef ONE_GHZ_IN_KHZ
-- 
1.7.9.5

