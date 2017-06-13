Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:33833 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753706AbdFMOvx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:51:53 -0400
Received: by mail-pg0-f67.google.com with SMTP id v14so19228036pgn.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:51:53 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 07/20] rsi: correct the logic of deriving queue number
Date: Tue, 13 Jun 2017 20:18:55 +0530
Message-Id: <1497365348-2305-8-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_165156_313384_98CBDB41)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
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
