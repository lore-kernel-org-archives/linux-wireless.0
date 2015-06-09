Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:49802 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933205AbbFIPfK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Jun 2015 11:35:10 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id CE8C3A06B60
	for <linux-wireless@vger.kernel.org>; Tue,  9 Jun 2015 17:27:10 +0200 (CEST)
From: Matthias May <matthias.may@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: Matthias May <matthias.may@neratec.com>
Subject: [PATCH] cfg80211: check correct maximum bandwidth for quarter and half rate.
Date: Tue,  9 Jun 2015 17:27:05 +0200
Message-Id: <1433863625-30579-1-git-send-email-matthias.may@neratec.com> (sfid-20150609_173523_482237_45077999)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using quarter and half rates we might want to use self defined
frequencies with self defined country codes closer to the border.
To avoid these frequencies to be disabled, we need to check if
the frequency fits the band with the actual bandwidth.

Signed-off-by: Matthias May <matthias.may@neratec.com>
---
 net/wireless/reg.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index fc2f135..c8fabda 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -1016,6 +1016,7 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 	for (i = 0; i < regd->n_reg_rules; i++) {
 		const struct ieee80211_reg_rule *rr;
 		const struct ieee80211_freq_range *fr = NULL;
+		u32 max_bw = MHZ_TO_KHZ(20);
 
 		rr = &regd->reg_rules[i];
 		fr = &rr->freq_range;
@@ -1028,8 +1028,10 @@ freq_reg_info_regd(struct wiphy *wiphy, u32 center_freq,
 		 */
 		if (!band_rule_found)
 			band_rule_found = freq_in_rule_band(fr, center_freq);
+		if (fr->max_bandwidth_khz < max_bw)
+			max_bw = fr->max_bandwidth_khz;
 
-		bw_fits = reg_does_bw_fit(fr, center_freq, MHZ_TO_KHZ(20));
+		bw_fits = reg_does_bw_fit(fr, center_freq, max_bw);
 
 		if (band_rule_found && bw_fits)
 			return rr;
-- 
2.1.4

