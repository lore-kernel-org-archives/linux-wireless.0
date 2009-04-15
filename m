Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47576 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbZDOTdt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Apr 2009 15:33:49 -0400
Subject: [PATCH] mac80211: avoid crashing when no scan sdata
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <Kalle.Valo@nokia.com>
Content-Type: text/plain
Date: Wed, 15 Apr 2009 21:33:15 +0200
Message-Id: <1239823995.20927.3.camel@johannes.local> (sfid-20090415_213352_755626_11195F2E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Using the scan_sdata variable here is terribly wrong,
if there has never been a scan then we fail. However,
we need a bandaid...

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org [2.6.29]
---
John, for 2.6.29 and 2.6.30 we need this bandaid -- my new work to
properly fix this can only go into 2.6.31.

 net/mac80211/mlme.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-15 20:48:57.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-15 21:31:13.000000000 +0200
@@ -2197,12 +2197,13 @@ void ieee80211_dynamic_ps_enable_work(st
 	struct ieee80211_local *local =
 		container_of(work, struct ieee80211_local,
 			     dynamic_ps_enable_work);
+	/* XXX: using scan_sdata is completely broken! */
 	struct ieee80211_sub_if_data *sdata = local->scan_sdata;
 
 	if (local->hw.conf.flags & IEEE80211_CONF_PS)
 		return;
 
-	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)
+	if (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK && sdata)
 		ieee80211_send_nullfunc(local, sdata, 1);
 
 	local->hw.conf.flags |= IEEE80211_CONF_PS;


