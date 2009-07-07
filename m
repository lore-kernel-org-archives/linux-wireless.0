Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:44098 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbZGGBm6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 21:42:58 -0400
Subject: [PATCH] mac80211_hwsim: avoid NULL access
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 07 Jul 2009 03:43:02 +0200
Message-Id: <1246930982.26030.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's a race condition -- started can be set to true
before channel is set due to the way mac80211 callbacks
currently work (->start should probably pass the channel
we would like to have initially). For now simply add a
check to hwsim to avoid dereferencing the NULL channel
pointer.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-07-07 03:29:38.000000000 +0200
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-07-07 03:37:02.000000000 +0200
@@ -427,6 +427,7 @@ static bool mac80211_hwsim_tx_frame(stru
 			continue;
 
 		if (!data2->started || !hwsim_ps_rx_ok(data2, skb) ||
+		    !data->channel || !data2->channel ||
 		    data->channel->center_freq != data2->channel->center_freq ||
 		    !(data->group & data2->group))
 			continue;


