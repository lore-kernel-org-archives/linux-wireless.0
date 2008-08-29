Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39172 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754460AbYH2RSF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Aug 2008 13:18:05 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <johannes@sipsolutions.net>,
	<linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/4] cfg80211: a few fixes to regulatory alpha2 helpers
Date: Fri, 29 Aug 2008 10:17:56 -0700
Message-ID: <1220030278-6088-3-git-send-email-lrodriguez@atheros.com> (sfid-20080829_191812_490306_C9B06054)
In-Reply-To: <1220030278-6088-2-git-send-email-lrodriguez@atheros.com>
References: <1220030278-6088-1-git-send-email-lrodriguez@atheros.com>
 <1220030278-6088-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 net/wireless/reg.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index f825b6d..8838a6f 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -53,6 +53,8 @@ static u32 supported_bandwidths[] = {
 
 static int is_world_regdom(char *alpha2)
 {
+	if (!alpha2)
+		return 0;
 	/* ASCII 0 */
 	if (alpha2[0] == 48 && alpha2[1] == 48)
 		return 1;
@@ -61,6 +63,8 @@ static int is_world_regdom(char *alpha2)
 
 static int is_alpha2_set(char *alpha2)
 {
+	if (!alpha2)
+		return 0;
 	if (alpha2[0] != 0 && alpha2[1] != 0)
 		return 1;
 	return 0;
@@ -76,6 +80,8 @@ static int is_alpha_upper(char letter)
 
 static int is_an_alpha2(char *alpha2)
 {
+	if (!alpha2)
+		return 0;
 	if (is_alpha_upper(alpha2[0]) && is_alpha_upper(alpha2[1]))
 		return 1;
 	return 0;
@@ -83,6 +89,8 @@ static int is_an_alpha2(char *alpha2)
 
 static int alpha2_equal(char *alpha2_x, char *alpha2_y)
 {
+	if (!alpha2_x || !alpha2_y)
+		return 0;
 	if (alpha2_x[0] == alpha2_y[0] &&
 		alpha2_x[1] == alpha2_y[1])
 		return 1;
@@ -91,6 +99,8 @@ static int alpha2_equal(char *alpha2_x, char *alpha2_y)
 
 static int regdom_changed(char *alpha2)
 {
+	if (!cfg80211_regdomain)
+		return 1;
 	if (alpha2_equal(cfg80211_regdomain->alpha2, alpha2))
 		return 0;
 	return 1;
@@ -253,6 +263,9 @@ static int freq_reg_info(u32 center_freq, u32 *bandwidth,
 	int i;
 	u32 max_bandwidth = 0;
 
+	if (!cfg80211_regdomain)
+		return -EINVAL;
+
 	for (i = 0; i < cfg80211_regdomain->n_reg_rules; i++) {
 		const struct ieee80211_reg_rule *rr;
 		const struct ieee80211_freq_range *fr = NULL;
-- 
1.5.6.4

