Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:42827 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbXIFNqM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Sep 2007 09:46:12 -0400
Message-Id: <20070905234621.224270000@sipsolutions.net>
References: <20070905234209.108005000@sipsolutions.net>
Date: Thu, 06 Sep 2007 01:42:10 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, Andy Green <andy@warmcat.com>
Subject: [PATCH 01/21] mac80211: get STA after tx radiotap snipped
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andy Green <andy@warmcat.com>

Johannes Berg noticed that in __ieee80211_tx_prepare() we try to get the
STA from addr1 of the ieee80211 header when the radiotap header is actually
still at the front of the packet.  This patch defers doing that until the
radiotap header is gone.

Signed-off-by: Andy Green <andy@warmcat.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---

 net/mac80211/tx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- wireless-dev.orig/net/mac80211/tx.c	2007-09-06 01:35:00.444453431 +0200
+++ wireless-dev/net/mac80211/tx.c	2007-09-06 01:35:10.934453431 +0200
@@ -958,8 +958,6 @@ __ieee80211_tx_prepare(struct ieee80211_
 	tx->dev = dev; /* use original interface */
 	tx->local = local;
 	tx->sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	tx->sta = sta_info_get(local, hdr->addr1);
-	tx->fc = le16_to_cpu(hdr->frame_control);
 
 	/*
 	 * set defaults for things that can be set by
@@ -984,6 +982,8 @@ __ieee80211_tx_prepare(struct ieee80211_
 		res = TXRX_QUEUED; /* indication it was monitor packet */
 	}
 
+	tx->sta = sta_info_get(local, hdr->addr1);
+	tx->fc = le16_to_cpu(hdr->frame_control);
 	tx->u.tx.control = control;
 	if (is_multicast_ether_addr(hdr->addr1)) {
 		tx->flags &= ~IEEE80211_TXRXD_TXUNICAST;

-- 

