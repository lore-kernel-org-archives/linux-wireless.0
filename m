Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f177.google.com ([209.85.223.177]:60738 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3HWNgX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 09:36:23 -0400
Received: by mail-ie0-f177.google.com with SMTP id e14so808664iej.36
        for <linux-wireless@vger.kernel.org>; Fri, 23 Aug 2013 06:36:22 -0700 (PDT)
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211: assign seqnums for group QoS frames
Date: Fri, 23 Aug 2013 09:35:38 -0400
Message-Id: <1377264938-5333-1-git-send-email-me@bobcopeland.com> (sfid-20130823_153625_706246_3F93F802)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to 802.11-2012 9.3.2.10, paragraph 4, QoS
data frames with a group address in the Address 1 field
have sequence numbers allocated from the same counter
as non-QoS data and management frames.  Without this
flag, some drivers may not assign sequence numbers, and
in rare cases frames might get dropped.  Set the control
flag accordingly.

Signed-off-by: Bob Copeland <bob@cozybit.com>

---
I noticed seq=0 on DHCP/mDNS frames with mesh on certain
hardware (since mesh sends all data frames as QoS).
Johannes pointed out this only causes issues if a unicast
frame with seq=0 has retries, and if the receiver caches
seqnums from multicast frames (mac80211 does not).

 net/mac80211/tx.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 098ae85..3456c04 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -781,9 +781,11 @@ ieee80211_tx_h_sequence(struct ieee80211_tx_data *tx)
 	/*
 	 * Anything but QoS data that has a sequence number field
 	 * (is long enough) gets a sequence number from the global
-	 * counter.
+	 * counter.  QoS data frames with a multicast destination
+	 * also use the global counter (802.11-2012 9.3.2.10).
 	 */
-	if (!ieee80211_is_data_qos(hdr->frame_control)) {
+	if (!ieee80211_is_data_qos(hdr->frame_control) ||
+	    is_multicast_ether_addr(hdr->addr1)) {
 		/* driver should assign sequence number */
 		info->flags |= IEEE80211_TX_CTL_ASSIGN_SEQ;
 		/* for pure STA mode without beacons, we can do it */
-- 
1.7.10.4

