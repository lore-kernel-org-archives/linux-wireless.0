Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:53948 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbYLTKCB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 05:02:01 -0500
Received: by ey-out-2122.google.com with SMTP id 22so125886eye.37
        for <linux-wireless@vger.kernel.org>; Sat, 20 Dec 2008 02:02:00 -0800 (PST)
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 7/15] rt2x00: Rename CONFIG_CRYPTO_COPY_IV
Date: Sat, 20 Dec 2008 10:56:36 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>,
	rt2400-devel@lists.sourceforge.net
References: <200812201052.00655.IvDoorn@gmail.com> <200812201055.34597.IvDoorn@gmail.com> <200812201055.58126.IvDoorn@gmail.com>
In-Reply-To: <200812201055.58126.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200812201056.36218.IvDoorn@gmail.com> (sfid-20081220_110212_332581_5F3FE026)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>From 4c3622010fe750be76403ebe4ad53e6d06ac40da Mon Sep 17 00:00:00 2001
From: Ivo van Doorn <IvDoorn@gmail.com>
Date: Sat, 20 Dec 2008 10:22:25 +0100
Subject: [PATCH] rt2x00: Rename CONFIG_CRYPTO_COPY_IV

CONFIG_CRYPTO_COPY_IV is a bad name since it is part
of the driver requirements instead of a configuration option.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2500usb.c   |    2 +-
 drivers/net/wireless/rt2x00/rt2x00.h      |    2 +-
 drivers/net/wireless/rt2x00/rt2x00queue.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2500usb.c b/drivers/net/wireless/rt2x00/rt2500usb.c
index ce76a87..8a53f9b 100644
--- a/drivers/net/wireless/rt2x00/rt2500usb.c
+++ b/drivers/net/wireless/rt2x00/rt2500usb.c
@@ -1897,7 +1897,7 @@ static int rt2500usb_probe_hw(struct rt2x00_dev *rt2x00dev)
 	__set_bit(DRIVER_REQUIRE_SCHEDULED, &rt2x00dev->flags);
 	if (!modparam_nohwcrypt) {
 		__set_bit(CONFIG_SUPPORT_HW_CRYPTO, &rt2x00dev->flags);
-		__set_bit(CONFIG_CRYPTO_COPY_IV, &rt2x00dev->flags);
+		__set_bit(DRIVER_REQUIRE_COPY_IV, &rt2x00dev->flags);
 	}
 	__set_bit(CONFIG_DISABLE_LINK_TUNING, &rt2x00dev->flags);
 
diff --git a/drivers/net/wireless/rt2x00/rt2x00.h b/drivers/net/wireless/rt2x00/rt2x00.h
index dea5022..1612a9c 100644
--- a/drivers/net/wireless/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/rt2x00/rt2x00.h
@@ -586,6 +586,7 @@ enum rt2x00_flags {
 	DRIVER_REQUIRE_ATIM_QUEUE,
 	DRIVER_REQUIRE_SCHEDULED,
 	DRIVER_REQUIRE_DMA,
+	DRIVER_REQUIRE_COPY_IV,
 
 	/*
 	 * Driver features
@@ -602,7 +603,6 @@ enum rt2x00_flags {
 	CONFIG_EXTERNAL_LNA_BG,
 	CONFIG_DOUBLE_ANTENNA,
 	CONFIG_DISABLE_LINK_TUNING,
-	CONFIG_CRYPTO_COPY_IV,
 };
 
 /*
diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.c b/drivers/net/wireless/rt2x00/rt2x00queue.c
index eaec6bd..0777120 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.c
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.c
@@ -402,7 +402,7 @@ int rt2x00queue_write_tx_frame(struct data_queue *queue, struct sk_buff *skb)
 	 */
 	if (test_bit(ENTRY_TXD_ENCRYPT, &txdesc.flags) &&
 	    !test_bit(ENTRY_TXD_ENCRYPT_IV, &txdesc.flags)) {
-		if (test_bit(CONFIG_CRYPTO_COPY_IV, &queue->rt2x00dev->flags))
+		if (test_bit(DRIVER_REQUIRE_COPY_IV, &queue->rt2x00dev->flags))
 			rt2x00crypto_tx_copy_iv(skb, iv_len);
 		else
 			rt2x00crypto_tx_remove_iv(skb, iv_len);
-- 
1.5.6.1

