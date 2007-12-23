Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:35433 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbXLWJMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 04:12:00 -0500
Subject: [PATCH] mac80211: remove misleading 'res' variable
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 23 Dec 2007 10:11:55 +0100
Message-Id: <1198401115.4116.4.camel@johannes.berg> (sfid-20071223_091218_398053_302E7965)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When this function returns != CONTINUE, it needs to put the
station struct it has acquired. Hence, having this unused
variable is not just superfluous but also misleading.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/tx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- everything.orig/net/mac80211/tx.c	2007-12-23 10:09:52.148939344 +0100
+++ everything/net/mac80211/tx.c	2007-12-23 10:09:57.548937012 +0100
@@ -932,7 +932,6 @@ __ieee80211_tx_prepare(struct ieee80211_
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
 	struct ieee80211_hdr *hdr;
 	struct ieee80211_sub_if_data *sdata;
-	ieee80211_txrx_result res = TXRX_CONTINUE;
 
 	int hdrlen;
 
@@ -997,7 +996,7 @@ __ieee80211_tx_prepare(struct ieee80211_
 	}
 	control->flags |= IEEE80211_TXCTL_FIRST_FRAGMENT;
 
-	return res;
+	return TXRX_CONTINUE;
 }
 
 /*


