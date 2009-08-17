Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:64142 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932113AbZHQQ4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2009 12:56:31 -0400
Received: by ewy10 with SMTP id 10so3097919ewy.37
        for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 09:56:31 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 5/7] rt2x00: wireless CLI ID and packet ID must not be 0
Date: Mon, 17 Aug 2009 18:55:15 +0200
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	users@rt2x00.serialmonkey.com,
	Benoit PAPILLAULT <benoit.papillault@free.fr>
References: <200908171853.24256.IvDoorn@gmail.com> <200908171854.19205.IvDoorn@gmail.com> <200908171854.50790.IvDoorn@gmail.com>
In-Reply-To: <200908171854.50790.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908171855.15390.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the TX descriptor the Packet ID must not be 0,
so add 1 to the ID. The wireless CLI ID is not allowed
to be 0 either, but also must be initialized with the
wcid value rather then keyid.

Based on a patch for rt2800pci from Benoit

Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index 6de2eda..3633e58 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1995,11 +1995,11 @@ static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXWI_W1_BW_WIN_SIZE, txdesc->ba_size);
 	rt2x00_set_field32(&word, TXWI_W1_WIRELESS_CLI_ID,
 			   test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags) ?
-			       txdesc->key_idx : 0xff);
+			       (skbdesc->entry->entry_idx + 1) : 0xff);
 	rt2x00_set_field32(&word, TXWI_W1_MPDU_TOTAL_BYTE_COUNT,
 			   skb->len - txdesc->l2pad);
 	rt2x00_set_field32(&word, TXWI_W1_PACKETID,
-			   skbdesc->entry->entry_idx);
+			   skbdesc->entry->queue->qid + 1);
 	rt2x00_desc_write(txwi, 1, word);
 
 	/*
-- 
1.6.4

