Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36104 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbcB2W30 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:29:26 -0500
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Fix Public Action frame RX in AP mode
Date: Tue, 1 Mar 2016 00:29:00 +0200
Message-ID: <1456784940-32328-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20160229_232931_764929_4378A85E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Public Action frames use special rules for how the BSSID field (Address
3) is set. A wildcard BSSID is used in cases where the transmitter and
recipient are not members of the same BSS. As such, we need to accept
Public Action frames with wildcard BSSID.

Commit db8e17324553 ("mac80211: ignore frames between TDLS peers when
operating as AP") added a rule that drops Action frames to TDLS-peers
based on an Action frame having different DA (Address 1) and BSSID
(Address 3) values. This is not correct since it misses the possibility
of BSSID being a wildcard BSSID in which case the Address 1 would not
necessarily match.

Fix this by allowing mac80211 to accept wildcard BSSID in an Action
frame when in AP mode.

Fixes: db8e17324553 ("mac80211: ignore frames between TDLS peers when operating as AP")
Cc: stable@vger.kernel.org
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/mac80211/rx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 9127957..25803e7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3473,6 +3473,7 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 				return false;
 			/* ignore action frames to TDLS-peers */
 			if (ieee80211_is_action(hdr->frame_control) &&
+			    !is_broadcast_ether_addr(bssid) &&
 			    !ether_addr_equal(bssid, hdr->addr1))
 				return false;
 		}
-- 
1.9.1

