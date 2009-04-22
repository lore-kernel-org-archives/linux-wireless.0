Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46683 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbZDVVDZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Apr 2009 17:03:25 -0400
Subject: [PATCH] mac80211: fix PS vs. scan race
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Kalle Valo <kalle.valo@iki.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 22 Apr 2009 23:02:51 +0200
Message-Id: <1240434171.30082.21.camel@johannes.local> (sfid-20090422_230332_838939_0838D463)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When somebody changes the PS parameters while scanning
is in progress, we enable PS -- during the scan. This
is clearly not desirable, and we can just abort enabling
PS when scanning since when the scan finishes it will
be taken care of.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-04-22 22:57:45.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-04-22 22:58:56.000000000 +0200
@@ -487,6 +487,13 @@ static void ieee80211_enable_ps(struct i
 {
 	struct ieee80211_conf *conf = &local->hw.conf;
 
+	/*
+	 * If we are scanning right now then the parameters will
+	 * take effect when scan finishes.
+	 */
+	if (local->hw_scanning || local->sw_scanning)
+		return;
+
 	if (conf->dynamic_ps_timeout > 0 &&
 	    !(local->hw.flags & IEEE80211_HW_SUPPORTS_DYNAMIC_PS)) {
 		mod_timer(&local->dynamic_ps_timer, jiffies +


