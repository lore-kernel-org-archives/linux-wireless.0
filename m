Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f179.google.com ([209.85.192.179]:46956 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3IIPEu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 11:04:50 -0400
Received: by mail-pd0-f179.google.com with SMTP id v10so6282078pde.24
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 08:04:50 -0700 (PDT)
From: Fred Zhou <fred.zy@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Fred Zhou <fred.zy@gmail.com>
Subject: [PATCH] mac80211: improve default WMM parameter setting
Date: Mon,  9 Sep 2013 23:03:41 +0800
Message-Id: <1378739021-3072-1-git-send-email-fred.zy@gmail.com> (sfid-20130909_170453_487471_3B803A00)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move the default setting for WMM parameters outside the for loop
to avoid redundant assignment multiple times.

Signed-off-by: Fred Zhou <fred.zy@gmail.com>
---
 net/mac80211/util.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index e1b34a1..16bdd15 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1007,14 +1007,21 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 	 */
 	enable_qos = (sdata->vif.type != NL80211_IFTYPE_STATION);
 
+	/* Set defaults according to 802.11-2007 Table 7-37 */
+	aCWmax = 1023;
+	if (use_11b)
+		aCWmin = 31;
+	else
+		aCWmin = 15;
+
+	/* Confiure old 802.11b/g medium access rules. */
+	qparam.cw_max = aCWmax;
+	qparam.cw_min = aCWmin;
+	qparam.txop = 0;
+	qparam.aifs = 2;
+
 	for (ac = 0; ac < IEEE80211_NUM_ACS; ac++) {
-		/* Set defaults according to 802.11-2007 Table 7-37 */
-		aCWmax = 1023;
-		if (use_11b)
-			aCWmin = 31;
-		else
-			aCWmin = 15;
-
+		/* Update if QoS is enabled. */
 		if (enable_qos) {
 			switch (ac) {
 			case IEEE80211_AC_BK:
@@ -1050,13 +1057,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata,
 				qparam.aifs = 2;
 				break;
 			}
-		} else {
-			/* Confiure old 802.11b/g medium access rules. */
-			qparam.cw_max = aCWmax;
-			qparam.cw_min = aCWmin;
-			qparam.txop = 0;
-			qparam.aifs = 2;
-		}
+		}
 
 		qparam.uapsd = false;
 
-- 
1.7.9.5

