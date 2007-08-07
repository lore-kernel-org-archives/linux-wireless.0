Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:59049 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758216AbXHGJrb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Aug 2007 05:47:31 -0400
Subject: Re: [RFC] allow device to stop packet mirror behaviour
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev <netdev@vger.kernel.org>
Cc: Andy Green <andy@warmcat.com>, David Miller <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1186475155.4067.17.camel@johannes.berg>
References: <1186475155.4067.17.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 07 Aug 2007 10:27:07 +0200
Message-Id: <1186475227.4067.19.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the corresponding patch to mac80211.

It marks all monitor type interfaces with IFF_NO_MIRROR the reasons for
which I explained in the previous mail; it also marks the master device
with IFF_NO_MIRROR so you don't see *any* packets on the master device
(right now you see outgoing frames with 802.11 header.) We want to get
rid of it anyway so making it a bit more useless yet seems like a good
idea.

johannes

---
 net/mac80211/ieee80211.c       |    1 +
 net/mac80211/ieee80211_iface.c |    2 ++
 2 files changed, 3 insertions(+)

--- wireless-dev.orig/net/mac80211/ieee80211_iface.c	2007-08-06 21:14:37.398164177 +0200
+++ wireless-dev/net/mac80211/ieee80211_iface.c	2007-08-06 21:15:02.078164177 +0200
@@ -158,6 +158,7 @@ void ieee80211_if_set_type(struct net_de
 	int oldtype = sdata->type;
 
 	dev->hard_start_xmit = ieee80211_subif_start_xmit;
+	dev->flags &= ~IFF_NO_MIRROR;
 
 	sdata->type = type;
 	switch (type) {
@@ -216,6 +217,7 @@ void ieee80211_if_set_type(struct net_de
 	case IEEE80211_IF_TYPE_MNTR:
 		dev->type = ARPHRD_IEEE80211_RADIOTAP;
 		dev->hard_start_xmit = ieee80211_monitor_start_xmit;
+		dev->flags |= IFF_NO_MIRROR;
 		break;
 	default:
 		printk(KERN_WARNING "%s: %s: Unknown interface type 0x%x",
--- wireless-dev.orig/net/mac80211/ieee80211.c	2007-08-06 21:15:01.898164177 +0200
+++ wireless-dev/net/mac80211/ieee80211.c	2007-08-06 21:15:02.088164177 +0200
@@ -5138,6 +5138,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	mdev->stop = ieee80211_master_stop;
 	mdev->type = ARPHRD_IEEE80211;
 	mdev->hard_header_parse = header_parse_80211;
+	mdev->flags |= IFF_NO_MIRROR;
 
 	sdata->type = IEEE80211_IF_TYPE_AP;
 	sdata->dev = mdev;


