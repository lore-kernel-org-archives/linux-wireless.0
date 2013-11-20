Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab3KTKbK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 Nov 2013 05:31:10 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: blaise@suitabletech.com, Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3.13] mac80211: don't attempt to reorder multicast frames
Date: Wed, 20 Nov 2013 11:31:01 +0100
Message-Id: <1384943461-23259-1-git-send-email-johannes@sipsolutions.net> (sfid-20131120_113121_481440_F628A794)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Multicast frames can't be transmitted as part of an aggregation
session (such a session couldn't even be set up) so don't try to
reorder them. Trying to do so would cause the reorder to stop
working correctly since multicast QoS frames (as transmitted by
the Aruba APs this was found with) would cause sequence number
confusion in the buffer.

Cc: stable@vger.kernel.org
Reported-by: Blaise Gassend <blaise@suitabletech.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 674eac1..1e5bd0d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -911,7 +911,8 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 	u16 sc;
 	u8 tid, ack_policy;
 
-	if (!ieee80211_is_data_qos(hdr->frame_control))
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1))
 		goto dont_reorder;
 
 	/*
-- 
1.8.4.rc3

