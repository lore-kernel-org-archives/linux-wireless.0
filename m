Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44394 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750903AbeBWJGI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 23 Feb 2018 04:06:08 -0500
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 1/4] mac80211: drop frames with unexpected DS bits from fast-rx to slow path
Date: Fri, 23 Feb 2018 10:06:03 +0100
Message-Id: <20180223090606.55726-1-nbd@nbd.name> (sfid-20180223_100632_523821_3E981083)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixes rx for 4-addr packets in AP mode

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 3dc162ddc3a6..1c947e005434 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3937,7 +3937,7 @@ static bool ieee80211_invoke_fast_rx(struct ieee80211_rx_data *rx,
 	if ((hdr->frame_control & cpu_to_le16(IEEE80211_FCTL_FROMDS |
 					      IEEE80211_FCTL_TODS)) !=
 	    fast_rx->expected_ds_bits)
-		goto drop;
+		return false;
 
 	/* assign the key to drop unencrypted frames (later)
 	 * and strip the IV/MIC if necessary
-- 
2.14.2
