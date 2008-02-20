Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:60416 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754646AbYBTScS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Feb 2008 13:32:18 -0500
Subject: [PATCH] p54: fix sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Michael Wu <flamingice@sourmilk.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Wed, 20 Feb 2008 12:08:12 +0100
Message-Id: <1203505692.17534.28.camel@johannes.berg> (sfid-20080220_183222_315117_37370D12)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a few sparse warnings in p54.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/p54common.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- everything.orig/drivers/net/wireless/p54common.c	2008-02-20 11:57:04.000000000 +0100
+++ everything/drivers/net/wireless/p54common.c	2008-02-20 11:58:04.000000000 +0100
@@ -59,7 +59,7 @@ static struct ieee80211_channel p54_chan
 	{ .center_freq = 2484, .hw_value = 14, },
 };
 
-struct ieee80211_supported_band band_2GHz = {
+static struct ieee80211_supported_band band_2GHz = {
 	.channels = p54_channels,
 	.n_channels = ARRAY_SIZE(p54_channels),
 	.bitrates = p54_rates,
@@ -389,7 +389,7 @@ static void p54_rx_frame_sent(struct iee
 	while (entry != (struct sk_buff *)&priv->tx_queue) {
 		range = (struct memrecord *)&entry->cb;
 		if (range->start_addr == addr) {
-			struct ieee80211_tx_status status = {{0}};
+			struct ieee80211_tx_status status;
 			struct p54_control_hdr *entry_hdr;
 			struct p54_tx_control_allocdata *entry_data;
 			int pad = 0;
@@ -405,6 +405,7 @@ static void p54_rx_frame_sent(struct iee
 				kfree_skb(entry);
 				break;
 			}
+			memset(&status, 0, sizeof(status));
 			memcpy(&status.control, range->control,
 			       sizeof(status.control));
 			kfree(range->control);


