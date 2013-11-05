Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34304 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750925Ab3KETWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 14:22:39 -0500
Received: by mail-pd0-f176.google.com with SMTP id g10so8995773pdj.35
        for <linux-wireless@vger.kernel.org>; Tue, 05 Nov 2013 11:22:38 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Bob Copeland <me@bobcopeland.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>
Subject: [PATCH 01/17] mac80211: fix off-by-one in llid check.
Date: Tue,  5 Nov 2013 11:16:49 -0800
Message-Id: <1383679025-7150-1-git-send-email-thomas@cozybit.com> (sfid-20131105_202242_325142_1A1F5684)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

According to IEEE 802.11-2012 (8.4.2.104), no peering
management element exists with length 7. This code is checking
to see if llid is present to ignore close frames with different
llid, which would be IEs with length 8.

Signed-off-by: Bob Copeland <bob@cozybit.com>
---
 net/mac80211/mesh_plink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4301aa5..a8c75c1 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -825,7 +825,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata,
 				event = CLS_ACPT;
 			else if (sta->plid != plid)
 				event = CLS_IGNR;
-			else if (ie_len == 7 && sta->llid != llid)
+			else if (ie_len == 8 && sta->llid != llid)
 				event = CLS_IGNR;
 			else
 				event = CLS_ACPT;
-- 
1.8.4.rc3

