Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35307 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936336AbZLQPRi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2009 10:17:38 -0500
Subject: [PATCH 2.6.33] mac80211: fix WMM AP settings application
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Dec 2009 16:16:53 +0100
Message-ID: <1261063014.10356.120.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My
  commit 77fdaa12cea26c204cc12c312fe40bc0f3dcdfd8
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Tue Jul 7 03:45:17 2009 +0200

      mac80211: rework MLME for multiple authentications

inadvertedly broke WMM because it removed, along with
a bunch of other now useless initialisations, the line
initialising sdata->u.mgd.wmm_last_param_set to -1
which would make it adopt any WMM parameter set. If,
as is usually the case, the AP uses WMM parameter set
sequence number zero, we'd never update it until the
AP changes the sequence number.

Add the missing initialisation back to get the WMM
settings from the AP applied locally.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org [2.6.31+]
---
 net/mac80211/mlme.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-12-17 15:34:32.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-12-17 15:51:18.000000000 +0100
@@ -695,6 +695,14 @@ static void ieee80211_set_associated(str
 	sdata->u.mgd.flags &= ~(IEEE80211_STA_CONNECTION_POLL |
 				IEEE80211_STA_BEACON_POLL);
 
+	/*
+	 * Always handle WMM once after association regardless
+	 * of the first value the AP uses. Setting -1 here has
+	 * that effect because the AP values is an unsigned
+	 * 4-bit value.
+	 */
+	sdata->u.mgd.wmm_last_param_set = -1;
+
 	ieee80211_led_assoc(local, 1);
 
 	sdata->vif.bss_conf.assoc = 1;


