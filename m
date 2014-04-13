Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:42497 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaDMNQF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 09:16:05 -0400
Received: by mail-wg0-f43.google.com with SMTP id x13so7058852wgg.26
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 06:16:03 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] regulatory: don't rule out some valid rules
Date: Sun, 13 Apr 2014 16:15:58 +0300
Message-Id: <1397394958-6827-1-git-send-email-eliad@wizery.com> (sfid-20140413_151611_012875_834BBCD3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 6d87df6 ("regdb: allow 40 MHz on world roaming
channels 12/13") in wireless-regdb did the following
change:

-        # Channel 12 - 13. No HT40 channel fits here
-        (2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS
+        # Channel 12 - 13.
+        (2457 - 2482 @ 40), (3, 20), PASSIVE-SCAN, NO-IBSS

in order to allow HT40+ on lower channels (such as 9).

However, the current regulatory rules verification forbids
such rules, as 2482 - 2457 < 40.
Remove this requirement from the rules verification function.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/wireless/reg.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 6c4b507..c8a5c34 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -610,8 +610,7 @@ static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 
 	freq_diff = freq_range->end_freq_khz - freq_range->start_freq_khz;
 
-	if (freq_range->end_freq_khz <= freq_range->start_freq_khz ||
-	    freq_range->max_bandwidth_khz > freq_diff)
+	if (freq_range->end_freq_khz <= freq_range->start_freq_khz)
 		return false;
 
 	return true;
-- 
1.8.5.2.229.g4448466.dirty

