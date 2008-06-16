Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:52943 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYFPS4I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2008 14:56:08 -0400
Subject: [PATCH] mac80211: remove shared key todo
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 16 Jun 2008 20:55:29 +0200
Message-Id: <1213642529.3803.47.camel@johannes.berg> (sfid-20080616_205612_010607_A5108F31)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding shared key authentication is not going to happen anyway.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- everything.orig/net/mac80211/mlme.c	2008-06-16 09:30:45.000000000 +0200
+++ everything/net/mac80211/mlme.c	2008-06-16 09:31:01.000000000 +0200
@@ -1753,11 +1753,12 @@ static void ieee80211_rx_mgmt_auth(struc
 	       auth_transaction, status_code);
 
 	if (sdata->vif.type == IEEE80211_IF_TYPE_IBSS) {
-		/* IEEE 802.11 standard does not require authentication in IBSS
+		/*
+		 * IEEE 802.11 standard does not require authentication in IBSS
 		 * networks and most implementations do not seem to use it.
 		 * However, try to reply to authentication attempts if someone
 		 * has actually implemented this.
-		 * TODO: Could implement shared key authentication. */
+		 */
 		if (auth_alg != WLAN_AUTH_OPEN || auth_transaction != 1) {
 			printk(KERN_DEBUG "%s: unexpected IBSS authentication "
 			       "frame (alg=%d transaction=%d)\n",


