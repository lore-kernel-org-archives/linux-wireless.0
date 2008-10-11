Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59420 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753963AbYJKWj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Oct 2008 18:39:58 -0400
Subject: [PATCH] p54/rtl8187: fix up the seqno patch
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Chr <chunkeey@web.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 12 Oct 2008 00:39:55 +0200
Message-Id: <1223764795.3581.2.camel@johannes.berg> (sfid-20081012_004000_437684_CE51D023)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry about that, for some reason I didn't notice that I'd
left some unused variables in there.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/p54/p54common.c |    1 -
 drivers/net/wireless/rtl8187_dev.c   |    1 -
 2 files changed, 2 deletions(-)

--- everything.orig/drivers/net/wireless/p54/p54common.c	2008-10-12 00:32:06.000000000 +0200
+++ everything/drivers/net/wireless/p54/p54common.c	2008-10-12 00:32:07.000000000 +0200
@@ -810,7 +810,6 @@ static int p54_tx(struct ieee80211_hw *d
 	struct ieee80211_tx_queue_stats *current_queue;
 	struct p54_common *priv = dev->priv;
 	struct p54_control_hdr *hdr;
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	struct p54_tx_control_allocdata *txhdr;
 	size_t padding, len;
 	u8 rate;
--- everything.orig/drivers/net/wireless/rtl8187_dev.c	2008-10-12 00:32:06.000000000 +0200
+++ everything/drivers/net/wireless/rtl8187_dev.c	2008-10-12 00:32:07.000000000 +0200
@@ -172,7 +172,6 @@ static int rtl8187_tx(struct ieee80211_h
 {
 	struct rtl8187_priv *priv = dev->priv;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct ieee80211_hdr *ieee80211hdr = (struct ieee80211_hdr *)skb->data;
 	unsigned int ep;
 	void *buf;
 	struct urb *urb;


