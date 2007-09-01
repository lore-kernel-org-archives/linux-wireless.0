Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purr.warmcat.com ([87.106.142.209]:40403 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156AbXIAJCt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 05:02:49 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id A3BE51804B257
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 10:02:48 +0100 (BST)
Received: from meerkat.home.warmcat.com (unknown [192.168.0.242])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id B5304104B2
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 09:03:53 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1])
	by meerkat.home.warmcat.com (Postfix) with ESMTP id 0F10812F34EF
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 10:02:44 +0100 (BST)
From: warmcat <andy@warmcat.com>
Subject: [PATCH] mac80211: get STA after tx radiotap snipped
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 10:02:44 +0100
Message-ID: <20070901090244.7234.51990.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg noticed that in __ieee80211_tx_prepare() we try to get the
STA from addr1 of the ieee80211 header when the radiotap header is actually
still at the front of the packet.  This patch defers doing that until the
radiotap header is gone.

Signed-off-by: Andy Green <andy@warmcat.com>
---

 net/mac80211/tx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 902d5b4..075f982 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -950,8 +950,6 @@ __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 	tx->dev = dev; /* use original interface */
 	tx->local = local;
 	tx->sdata = IEEE80211_DEV_TO_SUB_IF(dev);
-	tx->sta = sta_info_get(local, hdr->addr1);
-	tx->fc = le16_to_cpu(hdr->frame_control);
 
 	/*
 	 * set defaults for things that can be set by
@@ -976,6 +974,8 @@ __ieee80211_tx_prepare(struct ieee80211_txrx_data *tx,
 		res = TXRX_QUEUED; /* indication it was monitor packet */
 	}
 
+	tx->sta = sta_info_get(local, hdr->addr1);
+	tx->fc = le16_to_cpu(hdr->frame_control);
 	tx->u.tx.control = control;
 	if (is_multicast_ether_addr(hdr->addr1)) {
 		tx->flags &= ~IEEE80211_TXRXD_TXUNICAST;

