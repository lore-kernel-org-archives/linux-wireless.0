Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39292 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbZFRPZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2009 11:25:49 -0400
Subject: [PATCH -testing] mac80211: fix ieee80211_xmit call context
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 18 Jun 2009 17:25:11 +0200
Message-Id: <1245338711.13790.83.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ieee80211_xmit() cannot be called with tasklets enabled
because it is normally called from within a tasklet.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Fixes a problem with the mdev removal.

 net/mac80211/tx.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- wireless-testing.orig/net/mac80211/tx.c	2009-06-18 17:21:45.000000000 +0200
+++ wireless-testing/net/mac80211/tx.c	2009-06-18 17:23:49.000000000 +0200
@@ -2221,5 +2221,12 @@ void ieee80211_tx_skb(struct ieee80211_s
 	if (!encrypt)
 		info->flags |= IEEE80211_TX_INTFL_DONT_ENCRYPT;
 
+	/*
+	 * The other path calling ieee80211_xmit is from the tasklet,
+	 * and while we can handle concurrent transmissions locking
+	 * requirements are that we do not come into tx with bhs on.
+	 */
+	local_bh_disable();
 	ieee80211_xmit(sdata, skb);
+	local_bh_enable();
 }


