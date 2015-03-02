Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:43385 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbbCBTaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2015 14:30:16 -0500
Received: by iebtr6 with SMTP id tr6so50745067ieb.10
        for <linux-wireless@vger.kernel.org>; Mon, 02 Mar 2015 11:30:15 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Bob Copeland <me@bobcopeland.com>, stable@vger.kernel.org
Subject: [PATCH] mac80211: drop unencrypted frames in mesh fwding
Date: Mon,  2 Mar 2015 14:28:52 -0500
Message-Id: <1425324532-11849-1-git-send-email-me@bobcopeland.com> (sfid-20150302_203026_117736_3CD7388B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mesh forwarding path was not checking that data
frames were protected when running an encrypted network;
add the necessary check.

Cc: stable@vger.kernel.org
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 net/mac80211/rx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ed38d83..f0f4241 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2214,6 +2214,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	hdr = (struct ieee80211_hdr *) skb->data;
 	mesh_hdr = (struct ieee80211s_hdr *) (skb->data + hdrlen);
 
+	if (ieee80211_drop_unencrypted(rx, hdr->frame_control))
+		return RX_DROP_MONITOR;
+
 	/* frame is in RMC, don't forward */
 	if (ieee80211_is_data(hdr->frame_control) &&
 	    is_multicast_ether_addr(hdr->addr1) &&
-- 
2.1.4

