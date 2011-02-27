Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48450 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab1B0Dxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 26 Feb 2011 22:53:51 -0500
Received: by pvg12 with SMTP id 12so456738pvg.19
        for <linux-wireless@vger.kernel.org>; Sat, 26 Feb 2011 19:53:50 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19817.51920.241237.20545@gargle.gargle.HOWL>
Date: Sun, 27 Feb 2011 09:23:52 +0530
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel <ath9k-devel@lists.ath9k.org>, pma@sysgo.com,
	raghunathan.kailasanathan@wipro.com
Subject: [PATCH] ath9k_htc: Fix an endian issue
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <Sujith.Manoharan@atheros.com>

The stream length/tag fields have to be in little endian
format. Fixing this makes the driver work on big-endian
platforms.

Cc: stable@kernel.org
Tested-by: raghunathan.kailasanathan@wipro.com
Signed-off-by: Sujith Manoharan <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hif_usb.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 7dc2048..f1b8af6 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -222,8 +222,9 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 	struct tx_buf *tx_buf = NULL;
 	struct sk_buff *nskb = NULL;
 	int ret = 0, i;
-	u16 *hdr, tx_skb_cnt = 0;
+	u16 tx_skb_cnt = 0;
 	u8 *buf;
+	__le16 *hdr;
 
 	if (hif_dev->tx.tx_skb_cnt == 0)
 		return 0;
@@ -248,9 +249,9 @@ static int __hif_usb_tx(struct hif_device_usb *hif_dev)
 
 		buf = tx_buf->buf;
 		buf += tx_buf->offset;
-		hdr = (u16 *)buf;
-		*hdr++ = nskb->len;
-		*hdr++ = ATH_USB_TX_STREAM_MODE_TAG;
+		hdr = (__le16 *)buf;
+		*hdr++ = cpu_to_le16(nskb->len);
+		*hdr++ = cpu_to_le16(ATH_USB_TX_STREAM_MODE_TAG);
 		buf += 4;
 		memcpy(buf, nskb->data, nskb->len);
 		tx_buf->len = nskb->len + 4;
-- 
1.7.4.1

