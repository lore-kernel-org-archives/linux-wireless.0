Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37664 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbZDPWy6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2009 18:54:58 -0400
Subject: [PATCH 2.6.30] mac80211: validate TIM IE length
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Christian Lamparter <chunkeey@web.de>
In-Reply-To: <1239920291.26575.37.camel@johannes.local> (sfid-20090417_001849_051533_DC947D05)
References: <1239920291.26575.37.camel@johannes.local>
	 (sfid-20090417_001849_051533_DC947D05)
Content-Type: text/plain
Date: Fri, 17 Apr 2009 00:54:23 +0200
Message-Id: <1239922463.26575.40.camel@johannes.local> (sfid-20090417_005503_542057_50268234)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TIM IE must not be shorter than 4 bytes, so verify that
when parsing it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Ok the other version doesn't apply to .30 -- only to a tree that already
has my other patches. This is going to create merge conflicts, but they
should be easy to resolve...

 net/mac80211/mlme.c |    3 +++
 1 file changed, 3 insertions(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-17 00:50:23.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-17 00:52:09.000000000 +0200
@@ -528,6 +528,9 @@ static bool ieee80211_check_tim(struct i
 	u8 index, indexn1, indexn2;
 	struct ieee80211_tim_ie *tim = (struct ieee80211_tim_ie *) elems->tim;
 
+	if (unlikely(!tim || elems->tim_len < 4))
+		return false;
+
 	aid &= 0x3fff;
 	index = aid / 8;
 	mask  = 1 << (aid & 7);


