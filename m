Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:42016 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355AbZKSW0q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Nov 2009 17:26:46 -0500
Subject: [PATCH] mac80211: remove dead struct member
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Nov 2009 22:42:16 +0100
Message-ID: <1258666936.7094.23.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_local.wstats is a remnant from the
days when we still had to worry about wireless
extensions in mac80211 -- it can be removed.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    1 -
 1 file changed, 1 deletion(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-19 22:40:23.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-19 22:40:36.000000000 +0100
@@ -582,7 +582,6 @@ struct ieee80211_local {
 	/* number of interfaces with corresponding FIF_ flags */
 	int fif_fcsfail, fif_plcpfail, fif_control, fif_other_bss, fif_pspoll;
 	unsigned int filter_flags; /* FIF_* */
-	struct iw_statistics wstats;
 
 	/* protects the aggregated multicast list and filter calls */
 	spinlock_t filter_lock;


