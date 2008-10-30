Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:61064 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753264AbYJ3PIN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Oct 2008 11:08:13 -0400
From: Tomas Winkler <tomas.winkler@intel.com>
To: linville@tuxdriver.com, johannes@sipsolutions.net, yi.zhu@intel.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 1/1] mac80211: fix basic rates setting from association response
Date: Thu, 30 Oct 2008 17:08:08 +0200
Message-Id: <1225379288-7482-1-git-send-email-tomas.winkler@intel.com> (sfid-20081030_160817_895745_857450A9)
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In previous code all the rates were marked as basic.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index d5006b2..9ea7b28 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1302,29 +1302,35 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 
 	for (i = 0; i < elems.supp_rates_len; i++) {
 		int rate = (elems.supp_rates[i] & 0x7f) * 5;
+		bool is_basic = !!(elems.supp_rates[i] & 0x80);
 
 		if (rate > 110)
 			have_higher_than_11mbit = true;
 
 		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate)
+			if (sband->bitrates[j].bitrate == rate) {
 				rates |= BIT(j);
-			if (elems.supp_rates[i] & 0x80)
-				basic_rates |= BIT(j);
+				if (is_basic)
+					basic_rates |= BIT(j);
+				break;
+			}
 		}
 	}
 
 	for (i = 0; i < elems.ext_supp_rates_len; i++) {
 		int rate = (elems.ext_supp_rates[i] & 0x7f) * 5;
+		bool is_basic = !!(elems.supp_rates[i] & 0x80);
 
 		if (rate > 110)
 			have_higher_than_11mbit = true;
 
 		for (j = 0; j < sband->n_bitrates; j++) {
-			if (sband->bitrates[j].bitrate == rate)
+			if (sband->bitrates[j].bitrate == rate) {
 				rates |= BIT(j);
-			if (elems.ext_supp_rates[i] & 0x80)
-				basic_rates |= BIT(j);
+				if (is_basic)
+					basic_rates |= BIT(j);
+				break;
+			}
 		}
 	}
 
-- 
1.5.4.3

---------------------------------------------------------------------
Intel Israel (74) Limited

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

