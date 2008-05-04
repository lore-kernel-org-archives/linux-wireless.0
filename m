Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321AbYEDVY3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 17:24:29 -0400
Subject: [RFC] mac80211: assign needed_headroom/tailroom for netdevs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: "David S. Miller" <davem@davemloft.net>,
	netdev <netdev@vger.kernel.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 04 May 2008 23:24:13 +0200
Message-Id: <1209936253.7304.10.camel@johannes.berg> (sfid-20080504_232356_925288_0C998746)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This assigns the netdev's needed_headroom/tailroom members
to take advantage of pre-allocated space for 802.11 headers.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Builds on my other patch to add those fields, of course!

 net/mac80211/iface.c |    8 ++++++++
 net/mac80211/tx.c    |   14 +++++++++-----
 2 files changed, 17 insertions(+), 5 deletions(-)

--- everything.orig/net/mac80211/iface.c	2008-05-04 15:40:53.000000000 +0200
+++ everything/net/mac80211/iface.c	2008-05-04 16:08:45.000000000 +0200
@@ -53,6 +53,14 @@ int ieee80211_if_add(struct net_device *
 	if (!ndev)
 		return -ENOMEM;
 
+	ndev->needed_headroom = local->tx_headroom +
+				4*6 /* four MAC addresses */
+				+ 2 + 2 + 2 + 2 /* ctl, dur, seq, qos */
+				+ 6 /* mesh */
+				- ETH_HLEN /* ethernet hard_header_len */
+				+ IEEE80211_ENCRYPT_HEADROOM;
+	ndev->needed_tailroom = IEEE80211_ENCRYPT_TAILROOM;
+
 	ret = dev_alloc_name(ndev, ndev->name);
 	if (ret < 0)
 		goto fail;


