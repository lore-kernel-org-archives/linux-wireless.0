Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33747 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756861Ab0KMSOW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Nov 2010 13:14:22 -0500
Received: by mail-ew0-f46.google.com with SMTP id 8so221913ewy.19
        for <linux-wireless@vger.kernel.org>; Sat, 13 Nov 2010 10:14:22 -0800 (PST)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 8/9] rt2x00: Fix header_length in rt2x00lib_txdone
Date: Sat, 13 Nov 2010 19:12:54 +0100
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
References: <201011131908.15595.IvDoorn@gmail.com> <201011131911.22874.IvDoorn@gmail.com> <201011131911.47346.IvDoorn@gmail.com>
In-Reply-To: <201011131911.47346.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011131912.55384.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: RA-Jay Hung <Jay_Hung@ralinktech.com>

Put the assignment of header_length after pull out extra tx headroom

Signed-off-by: RA-Jay Hung <jay_hung@ralinktech.com>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00dev.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00dev.c b/drivers/net/wireless/rt2x00/rt2x00dev.c
index 3afa2a3..c879f9a 100644
--- a/drivers/net/wireless/rt2x00/rt2x00dev.c
+++ b/drivers/net/wireless/rt2x00/rt2x00dev.c
@@ -250,10 +250,9 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(entry->skb);
 	struct skb_frame_desc *skbdesc = get_skb_frame_desc(entry->skb);
 	enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);
-	unsigned int header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
+	unsigned int header_length, i;
 	u8 rate_idx, rate_flags, retry_rates;
 	u8 skbdesc_flags = skbdesc->flags;
-	unsigned int i;
 	bool success;
 
 	/*
@@ -272,6 +271,11 @@ void rt2x00lib_txdone(struct queue_entry *entry,
 	skbdesc->flags &= ~SKBDESC_DESC_IN_SKB;
 
 	/*
+	 * Determine the length of 802.11 header.
+	 */
+	header_length = ieee80211_get_hdrlen_from_skb(entry->skb);
+
+	/*
 	 * Remove L2 padding which was added during
 	 */
 	if (test_bit(DRIVER_REQUIRE_L2PAD, &rt2x00dev->flags))
-- 
1.7.2.3

