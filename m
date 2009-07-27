Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35211 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870AbZG0S3R (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 14:29:17 -0400
Subject: [PATCH] mac80211: disable software retry for now
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>, Pavel Roskin <proski@gnu.org>
Content-Type: text/plain
Date: Mon, 27 Jul 2009 20:28:40 +0200
Message-Id: <1248719320.13118.6.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pavel Roskin reported a problem that seems to be due to
software retry of already transmitted frames. It turns
out that we've never done that correctly, but due to
some recent changes it now crashes in the TX code. I've
added a comment in the patch that explains the problem
better and also points to possible solutions -- which
I can't implement right now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/main.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- wireless-testing.orig/net/mac80211/main.c	2009-07-27 19:44:11.000000000 +0200
+++ wireless-testing/net/mac80211/main.c	2009-07-27 20:26:06.000000000 +0200
@@ -310,6 +310,31 @@ static void ieee80211_handle_filtered_fr
 {
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 
+	/*
+	 * XXX: This is temporary!
+	 *
+	 *	The problem here is that when we get here, the driver will
+	 *	quite likely have pretty much overwritten info->control by
+	 *	using info->driver_data or info->rate_driver_data. Thus,
+	 *	when passing out the frame to the driver again, we would be
+	 *	passing completely bogus data since the driver would then
+	 *	expect a properly filled info->control. In mac80211 itself
+	 *	the same problem occurs, since we need info->control.vif
+	 *	internally.
+	 *
+	 *	To fix this, we should send the frame through TX processing
+	 *	again. However, it's not that simple, since the frame will
+	 *	have been software-encrypted (if applicable) already, and
+	 *	encrypting it again doesn't do much good. So to properly do
+	 *	that, we not only have to skip the actual 'raw' encryption
+	 *	(key selection etc. still has to be done!) but also the
+	 *	sequence number assignment since that impacts the crypto
+	 *	encapsulation, of course.
+	 *
+	 *	Hence, for now, fix the bug by just dropping the frame.
+	 */
+	goto drop;
+
 	sta->tx_filtered_count++;
 
 	/*
@@ -363,6 +388,7 @@ static void ieee80211_handle_filtered_fr
 		return;
 	}
 
+ drop:
 #ifdef CONFIG_MAC80211_VERBOSE_DEBUG
 	if (net_ratelimit())
 		printk(KERN_DEBUG "%s: dropped TX filtered frame, "


