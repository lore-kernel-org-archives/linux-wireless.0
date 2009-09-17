Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZIQRT5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:19:57 -0400
Subject: [PATCH] mac80211: fix DTIM setting
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Wey-Yi W Guy <wey-yi.w.guy@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Sep 2009 10:19:23 -0700
Message-Id: <1253207963.9450.20.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the DTIM setting is read from beacons, mac80211 will
assume it is 1 if the TIM IE is not present or the value
is 0. This sounds fine, but the same function processes
probe responses as well, which don't have a TIM IE. This
leads to overwriting any values previously parsed out of
beacon frames.

Thus, instead of checking for the presence of the TIM IE
when setting the default, simply check whether the DTIM
period value is valid already. If the TIM IE is not there
then the value cannot be valid (it is initialised to 0)
and probe responses received after beacons will not lead
to overwriting an already valid value.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
It's a bug, but probably not severe enough to warrant looking into
putting it into -stable.

 net/mac80211/scan.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2009-09-17 10:14:59.000000000 -0700
+++ wireless-testing/net/mac80211/scan.c	2009-09-17 10:15:18.000000000 -0700
@@ -90,8 +90,8 @@ ieee80211_bss_info_update(struct ieee802
 		bss->dtim_period = tim_ie->dtim_period;
 	}
 
-	/* set default value for buggy APs */
-	if (!elems->tim || bss->dtim_period == 0)
+	/* set default value for buggy AP/no TIM element */
+	if (bss->dtim_period == 0)
 		bss->dtim_period = 1;
 
 	bss->supp_rates_len = 0;


