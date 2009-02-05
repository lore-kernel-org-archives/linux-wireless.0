Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58654 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863AbZBEX2G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2009 18:28:06 -0500
Subject: [PATCH 2.6.29] mac80211: restrict to AP in outgoing interface
	heuristic
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 06 Feb 2009 00:27:32 +0100
Message-Id: <1233876452.4101.24.camel@johannes.local> (sfid-20090206_002811_575250_339CE35B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We try to find the correct outgoing interface for injected frames
based on the TA, but since this is a hack for hostapd 11w, restrict
the heuristic to AP mode interfaces. At some point we'll add the
ability to give an interface index in radiotap or so and just
remove this heuristic again.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: stable@kernel.org [2.6.28.x]
---
Otherwise we end up passing the monitor vif pointer to drivers, which
may cause them to crash.

 net/mac80211/tx.c |    2 ++
 1 file changed, 2 insertions(+)

--- wireless-testing.orig/net/mac80211/tx.c	2009-02-06 00:16:38.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-02-06 00:22:30.000000000 +0100
@@ -1394,6 +1394,8 @@ int ieee80211_master_start_xmit(struct s
 						list) {
 				if (!netif_running(sdata->dev))
 					continue;
+				if (sdata->vif.type != NL80211_IFTYPE_AP)
+					continue;
 				if (compare_ether_addr(sdata->dev->dev_addr,
 						       hdr->addr2)) {
 					dev_hold(sdata->dev);


