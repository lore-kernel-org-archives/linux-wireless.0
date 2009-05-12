Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53065 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886AbZELR6m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 May 2009 13:58:42 -0400
Subject: [PATCH] mac80211: respond to beacon loss report only once
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>
Content-Type: text/plain
Date: Tue, 12 May 2009 19:58:12 +0200
Message-Id: <1242151092.11924.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver might keep reporting beacon loss until we
disassociate -- catch that and don't respond to any
subsequent events until the probe is either successful
or we disassociate.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/mlme.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- wireless-testing.orig/net/mac80211/mlme.c	2009-05-12 19:55:05.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-05-12 19:56:32.000000000 +0200
@@ -1182,6 +1182,17 @@ void ieee80211_beacon_loss_work(struct w
 			     u.mgd.beacon_loss_work);
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
+	/*
+	 * The driver has already reported this event and we have
+	 * already sent a probe request. Maybe the AP died and the
+	 * driver keeps reporting until we disassociate... We have
+	 * to ignore that because otherwise we would continually
+	 * reset the timer and never check whether we received a
+	 * probe response!
+	 */
+	if (ifmgd->flags & IEEE80211_STA_PROBEREQ_POLL)
+		return;
+
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	if (net_ratelimit()) {
 		printk(KERN_DEBUG "%s: driver reports beacon loss from AP %pM "


