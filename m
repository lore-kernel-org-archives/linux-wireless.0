Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f42.google.com ([209.85.210.42]:55003 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934675Ab3DHSH6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 14:07:58 -0400
Received: by mail-da0-f42.google.com with SMTP id n15so2713531dad.15
        for <linux-wireless@vger.kernel.org>; Mon, 08 Apr 2013 11:07:57 -0700 (PDT)
From: Thomas Pedersen <thomas@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wirelss <linux-wireless@vger.kernel.org>,
	open80211s <devel@lists.open80211s.org>,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH 4/6] mac80211: limit mesh forwarding drops
Date: Mon,  8 Apr 2013 11:06:15 -0700
Message-Id: <1365444377-9959-4-git-send-email-thomas@cozybit.com> (sfid-20130408_200801_824515_4ADA84B1)
In-Reply-To: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
References: <1365444377-9959-1-git-send-email-thomas@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case of the HW asking mac80211 to back off, the queues
would be stopped with reason DRIVER.

Limit dropping forwarded mesh data frames by putting them
on the pending queue anyway if the outgoing HW queues
appear to be only momentarily stopped.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---
 net/mac80211/rx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index cb55ef0..8c7f80c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -1997,6 +1997,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
 	__le16 reason = cpu_to_le16(WLAN_REASON_MESH_PATH_NOFORWARD);
 	u16 q, hdrlen;
+	unsigned long qreason;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -2064,7 +2065,9 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 		return RX_CONTINUE;
 
 	q = ieee80211_select_queue_80211(sdata, skb, hdr);
-	if (ieee80211_queue_stopped(&local->hw, q)) {
+	qreason = ieee80211_queue_stopped(&local->hw, q);
+	if (qreason & ~(IEEE80211_QUEUE_STOP_REASON_SKB_ADD |
+			IEEE80211_QUEUE_STOP_REASON_AGGREGATION)) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_congestion);
 		return RX_DROP_MONITOR;
 	}
-- 
1.7.10.4

