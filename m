Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41537 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751585Ab0JMRXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Oct 2010 13:23:24 -0400
Subject: [PATCH] mac80211: fix SMPS request
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 19:23:21 +0200
Message-ID: <1286990601.3640.60.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

It looks like I submitted a different patch
than I tested, because clearly the code in
mac80211 is missing actually propagating the
requested SMPS mode. Fix that!

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/ht.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/mac80211/ht.c	2010-10-13 19:19:33.000000000 +0200
+++ wireless-testing/net/mac80211/ht.c	2010-10-13 19:19:41.000000000 +0200
@@ -291,6 +291,8 @@ void ieee80211_request_smps(struct ieee8
 	if (WARN_ON(smps_mode == IEEE80211_SMPS_OFF))
 		smps_mode = IEEE80211_SMPS_AUTOMATIC;
 
+	sdata->u.mgd.driver_smps_mode = smps_mode;
+
 	ieee80211_queue_work(&sdata->local->hw,
 			     &sdata->u.mgd.request_smps_work);
 }


