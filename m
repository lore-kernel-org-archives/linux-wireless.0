Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55801 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab0AQAtN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jan 2010 19:49:13 -0500
Message-Id: <20100117004824.859855359@sipsolutions.net>
Date: Sun, 17 Jan 2010 01:47:56 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/5] mac80211: clear TX control on filtered frames
References: <20100117004754.624627000@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When an skb survived a round-trip through the driver
and needs to be re-used, its control information is
definitely not valid any more, the driver will have
overwritten it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/status.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- wireless-testing.orig/net/mac80211/status.c	2009-12-23 13:11:13.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2009-12-23 13:11:32.000000000 +0100
@@ -69,6 +69,14 @@ static void ieee80211_handle_filtered_fr
 	 */
 	goto drop;
 
+	/*
+	 * This skb 'survived' a round-trip through the driver, and
+	 * hopefully the driver didn't mangle it too badly. However,
+	 * we can definitely not rely on the the control information
+	 * being correct. Clear it so we don't get junk there.
+	 */
+	memset(&info->control, 0, sizeof(info->control));
+
 	sta->tx_filtered_count++;
 
 	/*


