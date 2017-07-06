Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:34402 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbdGFOmW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:42:22 -0400
Received: by mail-pf0-f193.google.com with SMTP id c24so564977pfe.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:42:21 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v3 09/21] rsi: rename USB endpoint macros
Date: Thu,  6 Jul 2017 20:07:12 +0530
Message-Id: <1499351844-2046-10-git-send-email-amitkarwar@gmail.com> (sfid-20170706_164225_056656_CEB54509)
In-Reply-To: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

These endpoints are for WLAN and BT protocols.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 2 +-
 drivers/net/wireless/rsi/rsi_usb.h     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index dc0a0b2..99967ce 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -384,7 +384,7 @@ static int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
 	u32 queueno = ((pkt[1] >> 4) & 0x7);
 	u8 endpoint;
 
-	endpoint = ((queueno == RSI_WIFI_MGMT_Q) ? MGMT_EP : DATA_EP);
+	endpoint = ((queueno == RSI_WIFI_MGMT_Q) ? WLAN_EP : BT_EP);
 
 	return rsi_write_multiple(adapter,
 				  endpoint,
diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 2c5c0e7..3babf81 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -33,8 +33,8 @@
 
 #define MAX_RX_URBS                  1
 #define MAX_BULK_EP                  8
-#define MGMT_EP                      1
-#define DATA_EP                      2
+#define WLAN_EP                      1
+#define BT_EP                        2
 
 #define RSI_USB_BUF_SIZE	     4096
 
-- 
2.7.4
