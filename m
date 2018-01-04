Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:52292 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753092AbeADOx6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Jan 2018 09:53:58 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211: mesh: drop frames appearing to be from us
Date: Thu,  4 Jan 2018 15:53:54 +0100
Message-Id: <20180104145354.7943-1-johannes@sipsolutions.net> (sfid-20180104_155402_555989_B128464C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If there are multiple mesh stations with the same MAC address,
they will both get confused and start throwing warnings.

Obviously in this case nothing can actually work anyway, so just
drop frames that look like they're from ourselves early on.

Reported-by: Gui Iribarren <gui@altermundi.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 70e9d2ca8bbe..4daafb07602f 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3632,6 +3632,8 @@ static bool ieee80211_accept_frame(struct ieee80211_rx_data *rx)
 		}
 		return true;
 	case NL80211_IFTYPE_MESH_POINT:
+		if (ether_addr_equal(sdata->vif.addr, hdr->addr2))
+			return false;
 		if (multicast)
 			return true;
 		return ether_addr_equal(sdata->vif.addr, hdr->addr1);
-- 
2.15.1
