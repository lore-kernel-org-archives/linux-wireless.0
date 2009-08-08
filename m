Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f211.google.com ([209.85.219.211]:45076 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZHHV4L (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Aug 2009 17:56:11 -0400
Received: by ewy7 with SMTP id 7so1937881ewy.18
        for <linux-wireless@vger.kernel.org>; Sat, 08 Aug 2009 14:56:11 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 3/7] rt2x00: Align ieee80211 header to 4-byte boundary for PCI devices
Date: Sat, 8 Aug 2009 23:53:47 +0200
Cc: users@rt2x00.serialmonkey.com,
	"linux-wireless" <linux-wireless@vger.kernel.org>
References: <200908082353.04274.IvDoorn@gmail.com> <200908082353.26986.IvDoorn@gmail.com>
In-Reply-To: <200908082353.26986.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908082353.47835.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some hardware require the ieee80211 header to be aligned to a
4-byte boundary before mapping it to the DMA. Otherwise some
frames (like beacons) will not be send out correctly by the
device.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index 65435c9..e67e339 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -453,9 +453,21 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 			rt2x00crypto_tx_remove_iv(skb, &txdesc);
 	}
 
+	/*
+	 * When DMA allocation is required we should guarentee to the
+	 * driver that the DMA is aligned to a 4-byte boundary.
+	 * Aligning the header to this boundary can be done by calling
+	 * rt2x00queue_payload_align with the header length of 0.
+	 * However some drivers require L2 padding to pad the payload
+	 * rather then the header. This could be a requirement for
+	 * PCI and USB devices, while header alignment only is valid
+	 * for PCI devices.
+	 */
 	if (test_bit(DRIVER_REQUIRE_L2PAD, &queue->rt2x00dev->flags))
 		rt2x00queue_payload_align(entry->skb, true,
 					  txdesc.header_length);
+	else if (test_bit(DRIVER_REQUIRE_DMA, &queue->rt2x00dev->flags))
+		rt2x00queue_payload_align(entry->skb, false, 0);
 
 	/*
 	 * It could be possible that the queue was corrupted and this
-- 
1.6.3.3

