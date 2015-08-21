Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:40953 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752237AbbHUMNp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2015 08:13:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wireless: make __freq_reg_info static
Date: Fri, 21 Aug 2015 14:13:42 +0200
Message-Id: <1440159222-21729-1-git-send-email-johannes@sipsolutions.net> (sfid-20150821_141348_162661_7E23F447)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As pointed out by sparse, this symbol should be static, make it so.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/reg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b144485946f2..70aef72c4ca2 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1040,8 +1040,8 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 	return ERR_PTR(-EINVAL);
 }
 
-const struct ieee80211_reg_rule *__freq_reg_info(struct wiphy *wiphy,
-						 u32 center_freq, u32 min_bw)
+static const struct ieee80211_reg_rule *
+__freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 min_bw)
 {
 	const struct ieee80211_regdomain *regd = reg_get_regdomain(wiphy);
 	const struct ieee80211_reg_rule *reg_rule = NULL;
-- 
2.1.4

