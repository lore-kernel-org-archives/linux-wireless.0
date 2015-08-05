Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhcavuit01.kulnet.kuleuven.be ([134.58.240.129]:58429 "EHLO
	cavuit01.kulnet.kuleuven.be" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753308AbbHEOCr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2015 10:02:47 -0400
From: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
To: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Cc: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
Subject: [PATCH 4/5] mac80211: Only accept data frames in OCB mode
Date: Wed,  5 Aug 2015 16:02:42 +0200
Message-Id: <1438783362-9140-1-git-send-email-bertold.vandenbergh@esat.kuleuven.be> (sfid-20150805_160251_721011_A675E545)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently OCB mode accepts frames with bssid==broadcast and type!=beacon.
Some non-data frames are sent matching this, for example probe responses.
This results in unnecessary creation of STA entries.

Signed-off-by: Bertold Van den Bergh <bertold.vandenbergh@esat.kuleuven.be>
---
 net/mac80211/rx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index f673304..4d217d3 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3316,7 +3316,7 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 	case NL80211_IFTYPE_OCB:
 		if (!bssid)
 			return false;
-		if (ieee80211_is_beacon(hdr->frame_control))
+		if (!ieee80211_is_data_present(hdr->frame_control))
 			return false;
 		if (!is_broadcast_ether_addr(bssid))
 			return false;
-- 
1.9.1

