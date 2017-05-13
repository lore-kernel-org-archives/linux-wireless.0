Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35816 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751519AbdEMQlg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 13 May 2017 12:41:36 -0400
Received: by mail-wr0-f195.google.com with SMTP id g12so10240195wrg.2
        for <linux-wireless@vger.kernel.org>; Sat, 13 May 2017 09:41:36 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/5] staging: rtl8192e: Remove RX: IEEE802.1X EAPOL frame! warning.
Date: Sat, 13 May 2017 17:41:17 +0100
Message-Id: <20170513164121.14373-1-tvboxspy@gmail.com> (sfid-20170513_184149_535086_D2776547)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RX will receive countless EAPOL frames over the life of the connection.

A number of conditional calls to rtllib_is_eapol_frame are made in this function.

So this call serves no purpose other than to spam logs with false warning that
it is indeed a EAPOL frame, remove it.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/rtl8192e/rtllib_rx.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtllib_rx.c b/drivers/staging/rtl8192e/rtllib_rx.c
index 43a77745e6fb..0033dc6979e7 100644
--- a/drivers/staging/rtl8192e/rtllib_rx.c
+++ b/drivers/staging/rtl8192e/rtllib_rx.c
@@ -1214,9 +1214,6 @@ static int rtllib_rx_decrypt(struct rtllib_device *ieee, struct sk_buff *skb,
 		return -1;
 	}
 
-	if (rtllib_is_eapol_frame(ieee, skb, hdrlen))
-		netdev_warn(ieee->dev, "RX: IEEE802.1X EAPOL frame!\n");
-
 	return 0;
 }
 
-- 
2.11.0
