Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:64136 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757284AbZHQQ43 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 12:56:29 -0400
Received: by mail-ew0-f214.google.com with SMTP id 10so3097890ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 09:56:30 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 4/7] rt2x00: Set SKBDESC_L2_PADDED in RX path
Date: Mon, 17 Aug 2009 18:54:50 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com
References: <200908171853.24256.IvDoorn@gmail.com> <200908171853.57397.IvDoorn@gmail.com> <200908171854.19205.IvDoorn@gmail.com>
In-Reply-To: <200908171854.19205.IvDoorn@gmail.com>
MIME-Version: 1.0
Message-Id: <200908171854.50790.IvDoorn@gmail.com>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the RX descriptor indicates the frame was L2 padded,
the SKBDESC_L2_PADDED flag should be set to make sure the
L2 padding is removed before it is send to mac80211.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index c82474e..6de2eda 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -2163,8 +2163,10 @@ static void rt2800usb_fill_rxdone(struct queue_entry *entry,
 	if (rt2x00_get_field32(rxd0, RXD_W0_MY_BSS))
 		rxdesc->dev_flags |= RXDONE_MY_BSS;
 
-	if (rt2x00_get_field32(rxd0, RXD_W0_L2PAD))
+	if (rt2x00_get_field32(rxd0, RXD_W0_L2PAD)) {
 		rxdesc->dev_flags |= RXDONE_L2PAD;
+		skbdesc->flags |= SKBDESC_L2_PADDED;
+	}
 
 	if (rt2x00_get_field32(rxwi1, RXWI_W1_SHORT_GI))
 		rxdesc->flags |= RX_FLAG_SHORT_GI;
-- 
1.6.4

