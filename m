Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52414 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764178AbZE0Hlo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 May 2009 03:41:44 -0400
Subject: [PATCH] mac80211: fix transposed min/max CW values
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 27 May 2009 09:41:06 +0200
Message-Id: <1243410066.26933.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I accidentally transposed these in the patch that "fixed" the defaults,
leading to extremely low throughput because of the huge min CW.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/util.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/util.c	2009-05-27
09:37:50.000000000 +0200
+++ wireless-testing/net/mac80211/util.c	2009-05-27 09:38:52.000000000
+0200
@@ -703,15 +703,15 @@ void ieee80211_set_wmm_default(struct ie
 
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


