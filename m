Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46722 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695AbZE0FsK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 01:48:10 -0400
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1M9Bzn-00013y-0G
	for linux-wireless@vger.kernel.org; Wed, 27 May 2009 01:48:11 -0400
Received: from linville-t400.local (linville-t400.local [127.0.0.1])
	by linville-t400.local (8.14.3/8.14.3) with ESMTP id n4R5jCHE007456
	for <linux-wireless@vger.kernel.org>; Wed, 27 May 2009 07:45:12 +0200
Received: (from linville@localhost)
	by linville-t400.local (8.14.3/8.14.3/Submit) id n4R5jCIS007455
	for linux-wireless@vger.kernel.org; Wed, 27 May 2009 07:45:12 +0200
From: Jeff Hansen <x@jeffhansen.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jouni.malinen@atheros.com>,
	ath9k-devel@lists.ath9k.org, Jeff Hansen <x@jeffhansen.com>
Date: Wed, 27 May 2009 05:05:15 +0000
Message-Id: <1243400715-13561-4-git-send-email-x@jeffhansen.com>
In-Reply-To: <1243400715-13561-1-git-send-email-x@jeffhansen.com>
References: <1243400715-13561-1-git-send-email-x@jeffhansen.com>
Subject: [PATCH 4/4] mac80211: Fix typos in "set default QoS values according to spec"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the acwmin and acwmax values were backwards in the original patch,
which cut TX performance (on my device at least) down from ~25-30Mbps to
2Mbps.  Performance is back up after this commit.

Signed-off-by: Jeff Hansen <x@jeffhansen.com>
---
 net/mac80211/util.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 949d857..d096528 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -657,20 +657,20 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 
 		switch (queue) {
 		case 3: /* AC_BK */
-			qparam.cw_max = aCWmin;
-			qparam.cw_min = aCWmax;
+			qparam.cw_max = aCWmax;
+			qparam.cw_min = aCWmin;
 			qparam.txop = 0;
 			qparam.aifs = 7;
 			break;
 		default: /* never happens but let's not leave undefined */
 		case 2: /* AC_BE */
-			qparam.cw_max = aCWmin;
-			qparam.cw_min = aCWmax;
+			qparam.cw_max = aCWmax;
+			qparam.cw_min = aCWmin;
 			qparam.txop = 0;
 			qparam.aifs = 3;
 			break;
 		case 1: /* AC_VI */
-			qparam.cw_max = aCWmin;
+			qparam.cw_max = aCWmax;
 			qparam.cw_min = (aCWmin + 1) / 2 - 1;
 			if (use_11b)
 				qparam.txop = 6016/32;
@@ -679,7 +679,7 @@ void ieee80211_set_wmm_default(struct ieee80211_sub_if_data *sdata)
 			qparam.aifs = 2;
 			break;
 		case 0: /* AC_VO */
-			qparam.cw_max = (aCWmin + 1) / 2 - 1;
+			qparam.cw_max = (aCWmax + 1) / 2 - 1;
 			qparam.cw_min = (aCWmin + 1) / 4 - 1;
 			if (use_11b)
 				qparam.txop = 3264/32;
-- 
1.6.0.4


