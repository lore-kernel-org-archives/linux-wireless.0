Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47566 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2ISHWh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2012 03:22:37 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2] cfg80211: Fix regulatory check for 60GHz band frequencies
Date: Wed, 19 Sep 2012 10:22:19 +0300
Message-ID: <1348039339-22246-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120919_092240_467170_36DF6ADC)
In-Reply-To: <1348039339-22246-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1348039339-22246-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adjust check in the freq_in_rule_band for the 60GHz band,
where channel spacing is 2.160GHz.

Issue exposed in the following way: 60g band defines 3 channels supported wold-wide:
channels 1..3 or 58320, 60480, 62640 MHz, and channel 4, or 64800 MHz,
in the most of the world, with 2160 MHz spacing.
Corresponded regulatory rule for channels 1..3 would be
(57240 - 63720 @ 2160)

And, when regulatory applies to the channel 2 (60480), it get disabled since it is
more then 2GHz from either frequency boundary and freq_in_rule_band fails

Expanding frequency limit from 2GHz to 10GHz fixes the problem

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 net/wireless/reg.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 4de18ae..b7c094c 100644
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
+ * than 2 GHz for the 2.4 and 5 GHz bands, and by more then 4 GHz for the
+ * 60 GHz band.
  * This resolution can be lowered and should be considered as we add
  * regulatory rule support for other "bands".
  **/
@@ -520,9 +522,12 @@ static bool freq_in_rule_band(const struct ieee80211_freq_range *freq_range,
 	u32 freq_khz)
 {
 #define ONE_GHZ_IN_KHZ	1000000
-	if (abs(freq_khz - freq_range->start_freq_khz) <= (2 * ONE_GHZ_IN_KHZ))
+	/* DMG frequencies starts from 45 GHz, see 802.11ad */
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

