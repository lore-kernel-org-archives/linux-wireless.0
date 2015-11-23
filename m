Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from max.feld.cvut.cz ([147.32.192.36]:54730 "EHLO max.feld.cvut.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbbKWS1y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2015 13:27:54 -0500
From: Michal Sojka <sojkam1@fel.cvut.cz>
To: linux-wireless@vger.kernel.org
Cc: bernd.lehmann@volkswagen.de, s.sander@nordsys.de,
	wireless-regdb@lists.infradead.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com,
	=?UTF-8?q?Jan=20Kaisrl=C3=ADk?= <kaisrja1@fel.cvut.cz>,
	Michal Sojka <sojkam1@fel.cvut.cz>
Subject: [PATCH v2 1/8] cfg80211: reg: Remove unused function parameter
Date: Mon, 23 Nov 2015 19:27:14 +0100
Message-Id: <1448303241-27747-2-git-send-email-sojkam1@fel.cvut.cz> (sfid-20151123_192759_041502_E152FF6C)
In-Reply-To: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
References: <1448303241-27747-1-git-send-email-sojkam1@fel.cvut.cz>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michal Sojka <sojkam1@fel.cvut.cz>
---
 net/wireless/reg.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 2e8d6f3..43b3e57 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1052,7 +1052,7 @@ static u32 map_regdom_flags(u32 rd_flags)
 }
 
 static const struct ieee80211_reg_rule *
-freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
+freq_reg_info_regd(u32 center_freq,
 		   const struct ieee80211_regdomain *regd, u32 bw)
 {
 	int i;
@@ -1097,7 +1097,7 @@ __freq_reg_info(struct wiphy *wiphy, u32 center_freq, u32 min_bw)
 	u32 bw;
 
 	for (bw = MHZ_TO_KHZ(20); bw >= min_bw; bw = bw / 2) {
-		reg_rule = freq_reg_info_regd(wiphy, center_freq, regd, bw);
+		reg_rule = freq_reg_info_regd(center_freq, regd, bw);
 		if (!IS_ERR(reg_rule))
 			return reg_rule;
 	}
@@ -1765,8 +1765,7 @@ static void handle_channel_custom(struct wiphy *wiphy,
 	u32 bw;
 
 	for (bw = MHZ_TO_KHZ(20); bw >= MHZ_TO_KHZ(5); bw = bw / 2) {
-		reg_rule = freq_reg_info_regd(wiphy,
-					      MHZ_TO_KHZ(chan->center_freq),
+		reg_rule = freq_reg_info_regd(MHZ_TO_KHZ(chan->center_freq),
 					      regd, bw);
 		if (!IS_ERR(reg_rule))
 			break;
-- 
2.5.3

