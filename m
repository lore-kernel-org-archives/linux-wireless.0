Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:33940 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753730AbdFMOwA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Jun 2017 10:52:00 -0400
Received: by mail-pf0-f194.google.com with SMTP id d5so9722570pfe.1
        for <linux-wireless@vger.kernel.org>; Tue, 13 Jun 2017 07:52:00 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Alexey.Brodkin@synopsys.com,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Subject: [PATCH 09/20] rsi: choose correct endpoint based on queue.
Date: Tue, 13 Jun 2017 20:18:57 +0530
Message-Id: <1497365348-2305-10-git-send-email-amit.karwar@redpinesignals.com> (sfid-20170613_165203_651741_D932C20B)
In-Reply-To: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
References: <1497365348-2305-1-git-send-email-amit.karwar@redpinesignals.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Karun Eagalapati <karun256@gmail.com>

Till now only management packets were handled. Let's enhance
the logic for choosing endpoint to accommodate other packets.

Signed-off-by: Karun Eagalapati <karun256@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index 99967ce..3febf24 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -384,7 +384,8 @@ static int rsi_usb_host_intf_write_pkt(struct rsi_hw *adapter,
 	u32 queueno = ((pkt[1] >> 4) & 0x7);
 	u8 endpoint;
 
-	endpoint = ((queueno == RSI_WIFI_MGMT_Q) ? WLAN_EP : BT_EP);
+	endpoint = ((queueno == RSI_WIFI_MGMT_Q || queueno == RSI_WIFI_DATA_Q ||
+		     queueno == RSI_COEX_Q) ? WLAN_EP : BT_EP);
 
 	return rsi_write_multiple(adapter,
 				  endpoint,
-- 
2.7.4
