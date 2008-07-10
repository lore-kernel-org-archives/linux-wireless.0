Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:37309 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314AbYGJJ5S (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Jul 2008 05:57:18 -0400
Subject: [PATCH] mac80211 hwsim: fix endianness bug
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 11:56:33 +0200
Message-Id: <1215683793.3483.0.camel@johannes.berg> (sfid-20080710_115721_886523_E534DFC3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Radiotap is entirely little endian. Found with sparse.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/mac80211_hwsim.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- everything.orig/drivers/net/wireless/mac80211_hwsim.c	2008-07-10 11:55:14.000000000 +0200
+++ everything/drivers/net/wireless/mac80211_hwsim.c	2008-07-10 11:55:16.000000000 +0200
@@ -126,7 +126,7 @@ static void mac80211_hwsim_monitor_rx(st
 					  (1 << IEEE80211_RADIOTAP_CHANNEL));
 	hdr->rt_flags = 0;
 	hdr->rt_rate = txrate->bitrate / 5;
-	hdr->rt_channel = data->channel->center_freq;
+	hdr->rt_channel = cpu_to_le16(data->channel->center_freq);
 	flags = IEEE80211_CHAN_2GHZ;
 	if (txrate->flags & IEEE80211_RATE_ERP_G)
 		flags |= IEEE80211_CHAN_OFDM;


