Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f208.google.com ([209.85.219.208]:42515 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762939AbZJOTRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Oct 2009 15:17:51 -0400
Received: by ewy4 with SMTP id 4so882040ewy.37
        for <linux-wireless@vger.kernel.org>; Thu, 15 Oct 2009 12:17:14 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] rt2x00: Fix crypto in TX frame for rt2800usb
Date: Thu, 15 Oct 2009 21:17:09 +0200
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200910152117.10567.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benoit PAPILLAULT <benoit.papillault@free.fr>

Signed-off-by: Benoit PAPILLAULT <benoit.papillault@free.fr>
Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800usb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800usb.c b/drivers/net/wireless/rt2x00/rt2800usb.c
index a084077..9fe770f 100644
--- a/drivers/net/wireless/rt2x00/rt2800usb.c
+++ b/drivers/net/wireless/rt2x00/rt2800usb.c
@@ -1994,7 +1994,7 @@ static void rt2800usb_write_tx_desc(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field32(&word, TXWI_W1_BW_WIN_SIZE, txdesc->ba_size);
 	rt2x00_set_field32(&word, TXWI_W1_WIRELESS_CLI_ID,
 			   test_bit(ENTRY_TXD_ENCRYPT, &txdesc->flags) ?
-			       (skbdesc->entry->entry_idx + 1) : 0xff);
+			   txdesc->key_idx : 0xff);
 	rt2x00_set_field32(&word, TXWI_W1_MPDU_TOTAL_BYTE_COUNT,
 			   skb->len - txdesc->l2pad);
 	rt2x00_set_field32(&word, TXWI_W1_PACKETID,
-- 
1.6.4.1

