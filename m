Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33640 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933203AbZLOUKe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 15:10:34 -0500
Message-Id: <20091215200738.860691325@sipsolutions.net>
Date: Tue, 15 Dec 2009 21:06:20 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Pavel Roskin <proski@gnu.org>
Subject: [RFC/RFT 2/5] mac80211: clear TX control on filtered frames
References: <20091215200618.253970634@sipsolutions.net>
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

--- wireless-testing.orig/net/mac80211/status.c	2009-12-15 20:09:33.000000000 +0100
+++ wireless-testing/net/mac80211/status.c	2009-12-15 20:13:51.000000000 +0100
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


