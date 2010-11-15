Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46976 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab0KOOLo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Nov 2010 09:11:44 -0500
Received: by fxm6 with SMTP id 6so1748765fxm.19
        for <linux-wireless@vger.kernel.org>; Mon, 15 Nov 2010 06:11:43 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH for-2.6.37] carl9170: fix usb anchor wait timeout
Date: Mon, 15 Nov 2010 15:11:26 +0100
Cc: linville@tuxdriver.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201011151511.26736.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

usb_wait_anchor_empty_timeout's @timeout
wants milliseconds and not jiffies.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
diff --git a/drivers/net/wireless/ath/carl9170/usb.c b/drivers/net/wireless/ath/carl9170/usb.c
index 82c5f1c..a268053 100644
--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -556,1 +556,1 @@ static int carl9170_usb_flush(struct ar9170 *ar)
-	ret = usb_wait_anchor_empty_timeout(&ar->tx_cmd, HZ);
+	ret = usb_wait_anchor_empty_timeout(&ar->tx_cmd, 1000);
@@ -561,1 +561,1 @@ static int carl9170_usb_flush(struct ar9170 *ar)
-	ret = usb_wait_anchor_empty_timeout(&ar->tx_anch, HZ);
+	ret = usb_wait_anchor_empty_timeout(&ar->tx_anch, 1000);
 
