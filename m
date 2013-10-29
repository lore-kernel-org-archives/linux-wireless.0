Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:50870 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3J2Sen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Oct 2013 14:34:43 -0400
Received: by mail-we0-f180.google.com with SMTP id q59so254735wes.39
        for <linux-wireless@vger.kernel.org>; Tue, 29 Oct 2013 11:34:42 -0700 (PDT)
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Peter Senna Tschudin <peter.senna@gmail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: [PATCH 3/3] rtlwifi: fix usage of freq_reg_info()
Date: Tue, 29 Oct 2013 19:34:26 +0100
Message-Id: <1383071666-26817-4-git-send-email-mcgrof@do-not-panic.com> (sfid-20131029_193446_222643_5B8F04A5)
In-Reply-To: <1383071666-26817-1-git-send-email-mcgrof@do-not-panic.com>
References: <1383071666-26817-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

freq_reg_info() expects KHz and not MHz, fix this. In
this case we'll now be getting the no-ir flags cleared
on channels for any channel when the country IE trusts
that channel.

@@
struct ieee80211_channel *ch;
struct wiphy *wiphy;
const struct ieee80211_reg_rule *rule;
@@

-rule = freq_reg_info(wiphy, ch->center_freq);
+rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));

Generated-by: Coccinelle SmPL
Cc: Julia Lawall <julia.lawall@lip6.fr>
Cc: Peter Senna Tschudin <peter.senna@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Reported-by: Mihir Shete <smihir@qti.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@do-not-panic.com>
---
 drivers/net/wireless/rtlwifi/regd.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/regd.c b/drivers/net/wireless/rtlwifi/regd.c
index 2e1642c..29d2813 100644
--- a/drivers/net/wireless/rtlwifi/regd.c
+++ b/drivers/net/wireless/rtlwifi/regd.c
@@ -169,7 +169,8 @@ static void _rtl_reg_apply_beaconing_flags(struct wiphy *wiphy,
 			    (ch->flags & IEEE80211_CHAN_RADAR))
 				continue;
 			if (initiator == NL80211_REGDOM_SET_BY_COUNTRY_IE) {
-				reg_rule = freq_reg_info(wiphy, ch->center_freq);
+				reg_rule = freq_reg_info(wiphy,
+							 MHZ_TO_KHZ(ch->center_freq));
 				if (IS_ERR(reg_rule))
 					continue;
 
@@ -228,7 +229,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	 */
 
 	ch = &sband->channels[11];	/* CH 12 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));
 	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_NO_IR))
 			if (ch->flags & IEEE80211_CHAN_NO_IR)
@@ -236,7 +237,7 @@ static void _rtl_reg_apply_active_scan_flags(struct wiphy *wiphy,
 	}
 
 	ch = &sband->channels[12];	/* CH 13 */
-	reg_rule = freq_reg_info(wiphy, ch->center_freq);
+	reg_rule = freq_reg_info(wiphy, MHZ_TO_KHZ(ch->center_freq));
 	if (!IS_ERR(reg_rule)) {
 		if (!(reg_rule->flags & NL80211_RRF_NO_IR))
 			if (ch->flags & IEEE80211_CHAN_NO_IR)
-- 
1.8.4.rc3

