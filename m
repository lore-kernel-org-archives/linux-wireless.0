Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:33007 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754820Ab0FNUPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jun 2010 16:15:13 -0400
Received: by mail-wy0-f174.google.com with SMTP id 40so4235810wyb.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jun 2010 13:15:13 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/14] rt2x00: Fix IEEE80211_TX_CTL_MORE_FRAMES handling
Date: Mon, 14 Jun 2010 22:10:09 +0200
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>,
	linux-wireless@vger.kernel.org,
	Gertjan van Wingerde <gwingerde@gmail.com>
References: <201006142208.31736.IvDoorn@gmail.com> <201006142209.09943.IvDoorn@gmail.com> <201006142209.42709.IvDoorn@gmail.com>
In-Reply-To: <201006142209.42709.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006142210.10378.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Helmut Schaa <helmut.schaa@googlemail.com>

IEEE80211_TX_CTL_MORE_FRAMES indicates that more frames are queued for tx
but has nothing to do with fragmentation. Hence, don't set ENTRY_TXD_MORE_FRAG
but only ENTRY_TXD_BURST to not kick the tx queues immediately.

Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 35858b1..f916371 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -353,13 +353,18 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	/*
 	 * Check if more fragments are pending
 	 */
-	if (ieee80211_has_morefrags(hdr->frame_control) ||
-	    (tx_info->flags & IEEE80211_TX_CTL_MORE_FRAMES)) {
+	if (ieee80211_has_morefrags(hdr->frame_control)) {
 		__set_bit(ENTRY_TXD_BURST, &txdesc->flags);
 		__set_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags);
 	}
 
 	/*
+	 * Check if more frames (!= fragments) are pending
+	 */
+	if (tx_info->flags & IEEE80211_TX_CTL_MORE_FRAMES)
+		__set_bit(ENTRY_TXD_BURST, &txdesc->flags);
+
+	/*
 	 * Beacons and probe responses require the tsf timestamp
 	 * to be inserted into the frame, except for a frame that has been injected
 	 * through a monitor interface. This latter is needed for testing a
-- 
1.6.6.1

