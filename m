Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:63706 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbATOFM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jan 2015 09:05:12 -0500
Received: by mail-we0-f171.google.com with SMTP id u56so37553847wes.2
        for <linux-wireless@vger.kernel.org>; Tue, 20 Jan 2015 06:05:11 -0800 (PST)
Message-ID: <54BE6094.6010001@gmail.com> (sfid-20150120_150516_389663_9D96EF75)
Date: Tue, 20 Jan 2015 15:05:08 +0100
From: Mathy Vanhoef <vanhoefm@gmail.com>
MIME-Version: 1.0
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: properly set CCK flag in radiotap
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a regression introduced by commit a5e70697d0c4 ("mac80211: add radiotap flag
and handling for 5/10 MHz") where the IEEE80211_CHAN_CCK channel type flag was
incorrectly replaced by the IEEE80211_CHAN_OFDM flag. This commit fixes that by
using the CCK flag again.

Signed-off-by: Mathy Vanhoef <vanhoefm@gmail.com>
---
 net/mac80211/rx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index a37f9af..2d23d33 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -235,7 +235,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	else if (rate && rate->flags & IEEE80211_RATE_ERP_G)
 		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ;
 	else if (rate)
-		channel_flags |= IEEE80211_CHAN_OFDM | IEEE80211_CHAN_2GHZ;
+		channel_flags |= IEEE80211_CHAN_CCK | IEEE80211_CHAN_2GHZ;
 	else
 		channel_flags |= IEEE80211_CHAN_2GHZ;
 	put_unaligned_le16(channel_flags, pos);
-- 
1.7.10.4
