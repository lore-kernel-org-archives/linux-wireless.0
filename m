Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36979 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbbCaPAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2015 11:00:18 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] mac80211: reduce log spam from ieee80211_handle_pwr_constr
Date: Tue, 31 Mar 2015 10:49:14 -0400
Message-Id: <1427813354-7983-1-git-send-email-linville@tuxdriver.com> (sfid-20150331_170023_147566_6DCB0A56)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes a couple of messages from sdata_info to sdata_dbg.
This should reduce some log spam, as reported here:

	https://bugzilla.redhat.com/show_bug.cgi?id=1206468

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/mac80211/mlme.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 00103f36dcbf..26053bf2faa8 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1348,15 +1348,15 @@ static u32 ieee80211_handle_pwr_constr(struct ieee80211_sub_if_data *sdata,
 	 */
 	if (has_80211h_pwr &&
 	    (!has_cisco_pwr || pwr_level_80211h <= pwr_level_cisco)) {
-		sdata_info(sdata,
-			   "Limiting TX power to %d (%d - %d) dBm as advertised by %pM\n",
-			   pwr_level_80211h, chan_pwr, pwr_reduction_80211h,
-			   sdata->u.mgd.bssid);
+		sdata_dbg(sdata,
+			  "Limiting TX power to %d (%d - %d) dBm as advertised by %pM\n",
+			  pwr_level_80211h, chan_pwr, pwr_reduction_80211h,
+			  sdata->u.mgd.bssid);
 		new_ap_level = pwr_level_80211h;
 	} else {  /* has_cisco_pwr is always true here. */
-		sdata_info(sdata,
-			   "Limiting TX power to %d dBm as advertised by %pM\n",
-			   pwr_level_cisco, sdata->u.mgd.bssid);
+		sdata_dbg(sdata,
+			  "Limiting TX power to %d dBm as advertised by %pM\n",
+			  pwr_level_cisco, sdata->u.mgd.bssid);
 		new_ap_level = pwr_level_cisco;
 	}
 
-- 
2.1.0

