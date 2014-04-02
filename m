Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f45.google.com ([209.85.160.45]:35993 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaDBEFY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Apr 2014 00:05:24 -0400
Received: by mail-pb0-f45.google.com with SMTP id uo5so10892802pbc.32
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 21:05:24 -0700 (PDT)
From: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com,
	Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
Subject: [PATCH] mac80211: update last_tx_rate only for data frame
Date: Wed,  2 Apr 2014 12:05:09 +0800
Message-Id: <1396411509-4660-1-git-send-email-yeohchunyeow@gmail.com> (sfid-20140402_060528_176061_8B63D072)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rate controller in firmware may also return the Tx Rate
used for management frame that is usually sent as lowest
Tx Rate (1Mbps in 2.4GHz). So update the last_tx_rate only
if it is data frame.

This patch is tested with ath9k_htc.

Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
---
 net/mac80211/status.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index e6e574a..00ba90b 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -618,6 +618,7 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 					sta, true, acked);
 
 		if ((local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
+		    (ieee80211_is_data(hdr->frame_control)) &&
 		    (rates_idx != -1))
 			sta->last_tx_rate = info->status.rates[rates_idx];
 
-- 
1.7.9.5

