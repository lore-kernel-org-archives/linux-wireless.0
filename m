Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:34295 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752057AbdGFOmP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:42:15 -0400
Received: by mail-pg0-f68.google.com with SMTP id j186so499680pge.1
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:42:15 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [v3 08/21] rsi: correct the logic of deriving queue number
Date: Thu,  6 Jul 2017 20:07:11 +0530
Message-Id: <1499351844-2046-9-git-send-email-amitkarwar@gmail.com> (sfid-20170706_164218_771126_E30273C6)
In-Reply-To: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <amit.karwar@redpinesignals.com>

Maximum valid queue number is 0x5. So anding with 0x7 should be
ok here.

Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 25f6195..dc0a0b2 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -381,7 +381,7 @@ static int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
 				       u8 *pkt,
 				       u32 len)
 {
-	u32 queueno = ((pkt[1] >> 4) & 0xf);
+	u32 queueno = ((pkt[1] >> 4) & 0x7);
 	u8 endpoint;
 
 	endpoint = ((queueno == RSI_WIFI_MGMT_Q) ? MGMT_EP : DATA_EP);
-- 
2.7.4
