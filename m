Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:39093 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758508AbdELRWT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 May 2017 13:22:19 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
        Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH] mac80211: strictly check mesh address extension mode
Date: Fri, 12 May 2017 10:21:59 -0700
Message-ID: <1494609719-27936-1-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20170512_192421_750406_7B1753F5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mesh forwarding path checks for address extension mode to fetch
appropriate proxied address and MPP address. Existing condition
that looks for 6 address format is not so strict enough so that
frames with improper values are processed and invalid entries
are added into MPP table. Fix that by adding strick check and
drop those invalid frames.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 35f4c7d7a500..1f75280ba26c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2492,7 +2492,8 @@ static bool ieee80211_frame_allowed(struct ieee80211_rx_data *rx, __le16 fc)
 		if (is_multicast_ether_addr(hdr->addr1)) {
 			mpp_addr = hdr->addr3;
 			proxied_addr = mesh_hdr->eaddr1;
-		} else if (mesh_hdr->flags & MESH_FLAGS_AE_A5_A6) {
+		} else if ((mesh_hdr->flags & MESH_FLAGS_AE) ==
+			    MESH_FLAGS_AE_A5_A6) {
 			/* has_a4 already checked in ieee80211_rx_mesh_check */
 			mpp_addr = hdr->addr4;
 			proxied_addr = mesh_hdr->eaddr2;
-- 
1.9.1
