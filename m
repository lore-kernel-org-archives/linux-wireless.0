Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:34090 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbbGNMcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2015 08:32:14 -0400
Received: by iebmu5 with SMTP id mu5so9947450ieb.1
        for <linux-wireless@vger.kernel.org>; Tue, 14 Jul 2015 05:32:13 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH v3 1/5] mac80211: correct aid location in peering frames
Date: Tue, 14 Jul 2015 08:31:55 -0400
Message-Id: <1436877119-17577-2-git-send-email-me@bobcopeland.com> (sfid-20150714_143217_907124_B20035E5)
In-Reply-To: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
References: <1436877119-17577-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to 802.11-2012 8.5.16.3.2 AID comes directly after the
capability bytes in mesh peering confirm frames.  The existing
code, however, was adding a 2 byte offset to this location,
resulting in garbage data going out over the air.  Remove the
offset to fix it.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/mesh_plink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

v3: split out from patch 4

diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 1a7d98398626..956384087e12 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -306,7 +306,7 @@ static int mesh_plink_frame_tx(struct ieee80211_sub_if_data *sdata,
 		if (action == WLAN_SP_MESH_PEERING_CONFIRM) {
 			/* AID */
 			pos = skb_put(skb, 2);
-			put_unaligned_le16(plid, pos + 2);
+			put_unaligned_le16(plid, pos);
 		}
 		if (ieee80211_add_srates_ie(sdata, skb, true, band) ||
 		    ieee80211_add_ext_srates_ie(sdata, skb, true, band) ||
-- 
2.1.4

