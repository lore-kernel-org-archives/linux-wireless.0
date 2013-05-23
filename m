Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45922 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758251Ab3EWNGA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 09:06:00 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH 3.10] cfg80211: fix reporting 64-bit station info tx bytes
Date: Thu, 23 May 2013 15:05:59 +0200
Message-Id: <1369314359-99291-1-git-send-email-nbd@openwrt.org> (sfid-20130523_150604_845058_208FB262)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Copy & paste mistake - STATION_INFO_TX_BYTES64 is the name of the flag,
not NL80211_STA_INFO_TX_BYTES64.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 net/wireless/nl80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index dfdb5e6..d5aed3b 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3411,7 +3411,7 @@ static int nl80211_send_station(struct sk_buff *msg, u32 portid, u32 seq,
 			(u32)sinfo->rx_bytes))
 		goto nla_put_failure;
 	if ((sinfo->filled & (STATION_INFO_TX_BYTES |
-			      NL80211_STA_INFO_TX_BYTES64)) &&
+			      STATION_INFO_TX_BYTES64)) &&
 	    nla_put_u32(msg, NL80211_STA_INFO_TX_BYTES,
 			(u32)sinfo->tx_bytes))
 		goto nla_put_failure;
-- 
1.8.0.2

