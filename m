Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36837 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab2C0MUT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Mar 2012 08:20:19 -0400
Message-Id: <20120327121921.715465599@sipsolutions.net> (sfid-20120327_142028_274507_F2DAF893)
Date: Tue, 27 Mar 2012 14:18:40 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 5/5] mac80211: use AC constants
References: <20120327121835.299635879@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Use the AC constants instead of hard-coding
the numbers with comments.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/util.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/mac80211/util.c	2012-03-23 17:45:09.000000000 +0100
+++ b/net/mac80211/util.c	2012-03-23 17:45:18.000000000 +0100
@@ -790,20 +790,20 @@ void ieee80211_set_wmm_default(struct ie
 			aCWmin = 15;
 
 		switch (queue) {
-		case 3: /* AC_BK */
+		case IEEE80211_AC_BK:
 			qparam.cw_max = aCWmax;
 			qparam.cw_min = aCWmin;
 			qparam.txop = 0;
 			qparam.aifs = 7;
 			break;
 		default: /* never happens but let's not leave undefined */
-		case 2: /* AC_BE */
+		case IEEE80211_AC_BE:
 			qparam.cw_max = aCWmax;
 			qparam.cw_min = aCWmin;
 			qparam.txop = 0;
 			qparam.aifs = 3;
 			break;
-		case 1: /* AC_VI */
+		case IEEE80211_AC_VI:
 			qparam.cw_max = aCWmin;
 			qparam.cw_min = (aCWmin + 1) / 2 - 1;
 			if (use_11b)
@@ -812,7 +812,7 @@ void ieee80211_set_wmm_default(struct ie
 				qparam.txop = 3008/32;
 			qparam.aifs = 2;
 			break;
-		case 0: /* AC_VO */
+		case IEEE80211_AC_VO:
 			qparam.cw_max = (aCWmin + 1) / 2 - 1;
 			qparam.cw_min = (aCWmin + 1) / 4 - 1;
 			if (use_11b)


