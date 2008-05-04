Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:39802 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbYEDVcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 17:32:36 -0400
Subject: [RFC v2] mac80211: assign needed_headroom/tailroom for netdevs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1209936253.7304.10.camel@johannes.berg> (sfid-20080504_232356_925288_0C998746)
References: <1209936253.7304.10.camel@johannes.berg>
	 (sfid-20080504_232356_925288_0C998746)
Content-Type: text/plain
Date: Sun, 04 May 2008 23:32:25 +0200
Message-Id: <1209936745.7304.16.camel@johannes.berg> (sfid-20080504_233200_556404_25CC410F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This assigns the netdev's needed_headroom/tailroom members
to take advantage of pre-allocated space for 802.11 headers.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/iface.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- everything.orig/net/mac80211/iface.c	2008-05-04 23:24:17.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-05-04 23:31:46.000000000 +0200
@@ -53,6 +53,15 @@ int ieee80211_if_add(struct net_device *
 	if (!ndev)
 		return -ENOMEM;
 
+	ndev->needed_headroom = local->tx_headroom +
+				4*6 /* four MAC addresses */
+				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
+				+ 6 /* mesh */
+				+ 8 /* rfc1042/bridge tunnel */
+				- ETH_HLEN /* ethernet hard_header_len */
+				+ IEEE80211_ENCRYPT_HEADROOM;
+	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
+
 	ret = dev_alloc_name(ndev, ndev->name);
 	if (ret < 0)
 		goto fail;


