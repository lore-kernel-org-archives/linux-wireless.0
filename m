Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:56093 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750999Ab0ENOv3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 10:51:29 -0400
Received: by wwi18 with SMTP id 18so599560wwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 07:51:27 -0700 (PDT)
Date: Fri, 14 May 2010 16:50:56 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ming Lei <tom.leiming@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [patch -next 1/2] ath9k_htc: dereferencing before check in
	hif_usb_tx_cb()
Message-ID: <20100514145056.GE17487@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

After c11d8f89d3b7: "ath9k_htc: Simplify TX URB management" we no longer
assume that tx_buf is a non-null pointer.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 46dc41a..ac82911 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -107,12 +107,14 @@ static inline void ath9k_skb_queue_purge(struct hif_device_usb *hif_dev,
 static void hif_usb_tx_cb(struct urb *urb)
 {
 	struct tx_buf *tx_buf = (struct tx_buf *) urb->context;
-	struct hif_device_usb *hif_dev = tx_buf->hif_dev;
+	struct hif_device_usb *hif_dev;
 	struct sk_buff *skb;
 
-	if (!hif_dev || !tx_buf)
+	if (!tx_buf || !tx_buf->hif_dev)
 		return;
 
+	hif_dev = tx_buf->hif_dev;
+
 	switch (urb->status) {
 	case 0:
 		break;
