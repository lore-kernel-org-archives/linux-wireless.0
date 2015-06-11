Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:46569 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752418AbbFKLGj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 07:06:39 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.neratec.com (Postfix) with ESMTP id CCAC38E4AA1
	for <linux-wireless@vger.kernel.org>; Thu, 11 Jun 2015 13:06:36 +0200 (CEST)
From: Matthias May <matthias.may@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: matthias.may@neratec.com
Subject: [PATCHv2 4/4] rtlwifi: send minimum bandwidth to handle
Date: Thu, 11 Jun 2015 13:06:31 +0200
Message-Id: <1434020791-16291-5-git-send-email-matthias.may@neratec.com> (sfid-20150611_130643_365101_A4F8AED8)
In-Reply-To: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>
References: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

add 20MHz minimum bandwidth to the calls of freq_reg_info()

Signed-off-by: Matthias May <matthias.may@neratec.com>
---
 drivers/net/wireless/rtlwifi/regd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index a62bf0a..bbc3cb9 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -174,7 +174,8 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 				continue;
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
 				reg_rule = freq_reg_info(wiphy,
-							 ch->center_freq);
+							 ch->center_freq,
+							 MHZ_TO_KHZ(20));
 				if (IS_ERR(reg_rule))
 					continue;
 				/*
@@ -236,7 +237,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	 */
 
 	ch = &sband->channels[11];	/* CH 12 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	reg_rule = freq_reg_info(wiphy, ch->center_freq, MHZ_TO_KHZ(20));
 	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
@@ -244,7 +245,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	}
 
 	ch = &sband->channels[12];	/* CH 13 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	reg_rule = freq_reg_info(wiphy, ch->center_freq, MHZ_TO_KHZ(20));
 	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_PASSIVE_SCAN))
 			if (ch->flags & IEEE80211_CHAN_PASSIVE_SCAN)
-- 
2.1.4

