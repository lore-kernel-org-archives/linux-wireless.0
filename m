Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f46.google.com ([74.125.82.46]:48184 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab0ENOw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 May 2010 10:52:56 -0400
Received: by wwi18 with SMTP id 18so600875wwi.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 May 2010 07:52:55 -0700 (PDT)
Date: Fri, 14 May 2010 16:52:37 +0200
From: Dan Carpenter <error27@gmail.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ming Lei <tom.leiming@gmail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Subject: [patch -next 2/2] ath9k_htc: rare leak in
	ath9k_hif_usb_alloc_tx_urbs()
Message-ID: <20100514145237.GF17487@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is obviously a small picky thing.  The original error handling code
doesn't free the most recent allocations which haven't been added to the
hif_dev->tx.tx_buf list yet.

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/hif_usb.c b/drivers/net/wireless/ath/ath9k/hif_usb.c
index 46dc41a..77b3591 100644
--- a/drivers/net/wireless/ath/ath9k/hif_usb.c
+++ b/drivers/net/wireless/ath/ath9k/hif_usb.c
@@ -607,6 +609,10 @@ static int ath9k_hif_usb_alloc_tx_urbs(struct hif_device_usb *hif_dev)
 
 	return 0;
 err:
+	if (tx_buf) {
+		kfree(tx_buf->buf);
+		kfree(tx_buf);
+	}
 	ath9k_hif_usb_dealloc_tx_urbs(hif_dev);
 	return -ENOMEM;
 }
