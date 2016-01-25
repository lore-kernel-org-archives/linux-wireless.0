Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f41.google.com ([209.85.215.41]:36616 "EHLO
	mail-lf0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755405AbcAYNmn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jan 2016 08:42:43 -0500
Received: by mail-lf0-f41.google.com with SMTP id h129so85432654lfh.3
        for <linux-wireless@vger.kernel.org>; Mon, 25 Jan 2016 05:42:42 -0800 (PST)
From: Michal Kazior <michal.kazior@tieto.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH] mac80211: fix unnecessary frame drops in mesh fwding
Date: Mon, 25 Jan 2016 14:43:24 +0100
Message-Id: <1453729404-26506-1-git-send-email-michal.kazior@tieto.com> (sfid-20160125_144246_965537_DE4B606F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ieee80211_queue_stopped() expects hw queue
number but it was given raw WMM AC number instead.

This could cause frame drops and problems with
traffic in some cases - most notably if driver
doesn't map AC numbers to queue numbers 1:1 and
uses ieee80211_stop_queues() and
ieee80211_wake_queue() only without ever calling
ieee80211_wake_queues().

On ath10k it was possible to hit this problem in
the following case:

  1. wlan0 uses queue 0
     (ath10k maps queues per vif)
  2. offchannel uses queue 15
  3. queues 1-14 are unused
  4. ieee80211_stop_queues()
  5. ieee80211_wake_queue(q=0)
  6. ieee80211_wake_queue(q=15)
     (other queues are not woken up because both
      driver and mac80211 know other queues are
      unused)
  7. ieee80211_rx_h_mesh_fwding()
  8. ieee80211_select_queue_80211() returns 2
  9. ieee80211_queue_stopped(q=2) returns true
 10. frame is dropped (oops!)

Fixes: d3c1597b8d1b ("mac80211: fix forwarded mesh frame queue mapping")
Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 net/mac80211/rx.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index ae993edfdecf..664e8861edbe 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2235,7 +2235,7 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_sub_if_data *sdata = rx->sdata;
 	struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
-	u16 q, hdrlen;
+	u16 ac, q, hdrlen;
 
 	hdr = (struct ieee80211_hdr *) skb->data;
 	hdrlen = ieee80211_hdrlen(hdr->frame_control);
@@ -2304,7 +2304,8 @@ ieee80211_rx_h_mesh_fwding(struct ieee80211_rx_data *rx)
 	    ether_addr_equal(sdata->vif.addr, hdr->addr3))
 		return RX_CONTINUE;
 
-	q = ieee80211_select_queue_80211(sdata, skb, hdr);
+	ac = ieee80211_select_queue_80211(sdata, skb, hdr);
+	q = sdata->vif.hw_queue[ac];
 	if (ieee80211_queue_stopped(&local->hw, q)) {
 		IEEE80211_IFSTA_MESH_CTR_INC(ifmsh, dropped_frames_congestion);
 		return RX_DROP_MONITOR;
-- 
2.1.4

