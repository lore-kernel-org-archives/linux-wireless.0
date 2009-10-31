Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:45059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752825AbZJaPhD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 11:37:03 -0400
Subject: [PATCH] cfg80211: remove dead variable
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Oct 2009 16:15:39 +0100
Message-ID: <1257002139.3555.135.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  commit 211a4d12abf86fe0df4cd68fc6327cbb58f56f81
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Tue Oct 20 15:08:53 2009 +0900

      cfg80211: sme: deauthenticate on assoc failure

accidentally introduced a dead variable, I had
changed the code to not need it while creating
the patch and it looks like I forgot to remove
the variable (and nobody else noticed either).

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/mlme.c |    2 --
 1 file changed, 2 deletions(-)

--- wireless-testing.orig/net/wireless/mlme.c	2009-10-31 16:13:12.000000000 +0100
+++ wireless-testing/net/wireless/mlme.c	2009-10-31 16:13:16.000000000 +0100
@@ -62,7 +62,6 @@ void cfg80211_send_rx_assoc(struct net_d
 	u8 *ie = mgmt->u.assoc_resp.variable;
 	int i, ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
 	struct cfg80211_internal_bss *bss = NULL;
-	bool need_connect_result = true;
 
 	wdev_lock(wdev);
 
@@ -97,7 +96,6 @@ void cfg80211_send_rx_assoc(struct net_d
 		WARN_ON(!bss);
 	} else if (wdev->conn) {
 		cfg80211_sme_failed_assoc(wdev);
-		need_connect_result = false;
 		/*
 		 * do not call connect_result() now because the
 		 * sme will schedule work that does it later.


