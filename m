Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47286 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476Ab0AYSHo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2010 13:07:44 -0500
Subject: [PATCH] mac80211: fill jiffies/vif on filtered frames
From: Johannes Berg <johannes@sipsolutions.net>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jan 2010 19:07:39 +0100
Message-ID: <1264442860.23766.44.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Filtered frames not only need their control information
cleared to avoid wrong checks, but also need to have
jiffies and vif assigned so they can be processed or
expired.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/status.c |    3 +++
 1 file changed, 3 insertions(+)

--- wireless-testing.orig/net/mac80211/status.c	2010-01-24 12:20:50.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2010-01-24 12:22:03.000000000 +0100
@@ -53,6 +53,9 @@ static void ieee80211_handle_filtered_fr
 	 * modified/encrypted again.
 	 */
 	memset(&info->control, 0, sizeof(info->control));
+
+	info->control.jiffies = jiffies;
+	info->control.vif = &sta->sdata->vif;
 	info->flags |= IEEE80211_TX_INTFL_NEED_TXPROCESSING |
 		       IEEE80211_TX_INTFL_RETRANSMISSION;
 


