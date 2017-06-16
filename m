Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:33390 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752231AbdFPO54 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 10:57:56 -0400
Received: by mail-pf0-f196.google.com with SMTP id w12so6924770pfk.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Jun 2017 07:57:55 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [v2 07/20] rsi: correct the logic of deriving queue number
Date: Fri, 16 Jun 2017 20:24:28 +0530
Message-Id: <1497624881-2315-8-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170616_165759_006399_50409675)
In-Reply-To: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497624881-2315-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
