Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:54524 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753252AbYF2JoI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2008 05:44:08 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Ester Kummer <ester.kummer@intel.com>
Subject: [PATCH 1/1 V2] cfg80211: adding NONE regdomain
Date: Sun, 29 Jun 2008 12:43:24 +0300
Message-Id: <1214732604-4573-1-git-send-email-tomas.winkler@intel.com> (sfid-20080629_114411_772442_475D0D99)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ester Kummer <ester.kummer@intel.com>

This patch adds an option to enable all the channels by adding a
value of "NONE" to ieee80211_regdom module param. This is useful
for NICs that rely on EEPROM regulatory enforcement and for testing

Signed-off-by: Ester Kummer <ester.kummer@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 net/wireless/reg.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 855bff4..140b931 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -97,6 +97,14 @@ static const struct ieee80211_channel_range ieee80211_EU_channels[] = {
 				     IEEE80211_CHAN_RADAR),
 };
 
+static const struct ieee80211_channel_range ieee80211_NONE_channels[] = {
+	/* IEEE 802.11b/g, channels 1..14 */
+	RANGE_PWR(2412, 2484, 0xFF, 0xFF, 0),
+	/* IEEE 802.11a, channels 36..165 */
+	RANGE_PWR(5180, 6000, 0xFF, 0xFF, 0),
+};
+
+
 #define REGDOM(_code)							\
 	{								\
 		.code = __stringify(_code),				\
@@ -108,6 +116,7 @@ static const struct ieee80211_regdomain ieee80211_regdoms[] = {
 	REGDOM(US),
 	REGDOM(JP),
 	REGDOM(EU),
+	REGDOM(NONE),
 };
 
 
-- 
1.5.4.1

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

