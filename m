Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42594 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753254AbcINHan (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Sep 2016 03:30:43 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: fix possible out-of-bounds access
Date: Wed, 14 Sep 2016 09:30:39 +0200
Message-Id: <1473838239-23847-1-git-send-email-johannes@sipsolutions.net> (sfid-20160914_093057_083719_0D75FCCB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In the unlikely situation that the supplicant has negotiated
admission for the background AC (which it has no reason to as
it's not supposed to be requiring admission control to start
with, and we'd ignore such a requirement anyway), the loop
here may terminate with non_acm_ac == 4, which leads to an
array overrun.

Check this explicitly just for completeness.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8d426f637f58..7486f2dab4ba 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1672,11 +1672,15 @@ __ieee80211_sta_handle_tspec_ac_params(struct ieee80211_sub_if_data *sdata)
 			     non_acm_ac++)
 				if (!(sdata->wmm_acm & BIT(7 - 2 * non_acm_ac)))
 					break;
-			/* The loop will result in using BK even if it requires
-			 * admission control, such configuration makes no sense
-			 * and we have to transmit somehow - the AC selection
-			 * does the same thing.
+			/* Usually the loop will result in using BK even if it
+			 * requires admission control, but such a configuration
+			 * makes no sense and we have to transmit somehow - the
+			 * AC selection does the same thing.
+			 * If we started out trying to downgrade from BK, then
+			 * the extra condition here might be needed.
 			 */
+			if (non_acm_ac >= IEEE80211_NUM_ACS)
+				non_acm_ac = IEEE80211_AC_BK;
 			if (drv_conf_tx(local, sdata, ac,
 					&sdata->tx_conf[non_acm_ac]))
 				sdata_err(sdata,
-- 
2.8.1
