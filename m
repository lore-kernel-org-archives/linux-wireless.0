Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41933 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754848AbZLWMVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 07:21:48 -0500
Message-Id: <20091223121416.137161680@sipsolutions.net>
Date: Wed, 23 Dec 2009 13:12:03 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, stable@kernel.org ("2.6.31+")
Subject: [PATCH 2.6.33 1/3] mac80211: fix WMM AP settings application
References: <20091223121202.581948600@sipsolutions.net>
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
Cc: stable@kernel.org (2.6.31+)
---
 net/mac80211/mlme.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-12-23 13:10:16.000000000 +0100
+++ wireless-testing/net/mac80211/mlme.c	2009-12-23 13:11:05.000000000 +0100
@@ -981,6 +981,14 @@ static void ieee80211_set_associated(str
 	 */
 	sdata->u.mgd.wmm_last_param_set = -1;
 
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


