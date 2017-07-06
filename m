Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:33308 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751654AbdGFOm1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 10:42:27 -0400
Received: by mail-pf0-f195.google.com with SMTP id e199so572427pfh.0
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 07:42:26 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Karun Eagalapati <karun256@gmail.com>
Subject: [v3 10/21] rsi: choose correct endpoint based on queue.
Date: Thu,  6 Jul 2017 20:07:13 +0530
Message-Id: <1499351844-2046-11-git-send-email-amitkarwar@gmail.com> (sfid-20170706_164229_990531_B222A1C0)
In-Reply-To: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
References: <1499351844-2046-1-git-send-email-amitkarwar@gmail.com>
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
