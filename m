Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:47646 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbZHHV4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 17:56:10 -0400
Received: by ey-out-2122.google.com with SMTP id 9so695183eyd.37
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 14:56:10 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 2/7] rt2x00: Use IEEE80211_TX_CTL_MORE_FRAMES flag
Date: Sat, 8 Aug 2009 23:53:26 +0200
Cc: users@rt2x00.serialmonkey.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200908082353.04274.IvDoorn@gmail.com>
In-Reply-To: <200908082353.04274.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908082353.26986.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Check the IEEE80211_TX_CTL_MORE_FRAMES flag to help determining
if the DMA queue should be kicked. At the moment this is combined
with the ieee80211_has_morefrags() but we might remove that later.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 44e5b32..65435c9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -324,7 +324,8 @@ static void rt2x00queue_create_tx_descriptor(struct queue_entry *entry,
 	/*
 	 * Check if more fragments are pending
 	 */
-	if (ieee80211_has_morefrags(hdr->frame_control)) {
+	if (ieee80211_has_morefrags(hdr->frame_control) ||
+	    (tx_info->flags & IEEE80211_TX_CTL_MORE_FRAMES)) {
 		__set_bit(ENTRY_TXD_BURST, &txdesc->flags);
 		__set_bit(ENTRY_TXD_MORE_FRAG, &txdesc->flags);
 	}
-- 
1.6.3.3

