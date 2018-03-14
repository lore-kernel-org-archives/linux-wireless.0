Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:54972 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751426AbeCNOMp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Mar 2018 10:12:45 -0400
From: Colin King <colin.king@canonical.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][next] rsi: remove redundant duplicate assignment of buffer_size
Date: Wed, 14 Mar 2018 14:12:39 +0000
Message-Id: <20180314141239.8321-1-colin.king@canonical.com> (sfid-20180314_151311_521590_A3F7AE31)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

Variable buffer_size is re-assigned the same value, this duplicated
assignment is redundant and can be removed.

Cleans up clang warning:
drivers/net/wireless/rsi/rsi_91x_usb.c:140:4: warning: Value stored
to 'buffer_size' is never read

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index be8236f404b5..7b8bae313aa9 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -140,7 +140,6 @@ static int rsi_find_bulk_in_and_out_endpoints(struct usb_interface *interface,
 			buffer_size = endpoint->wMaxPacketSize;
 			dev->bulkout_endpoint_addr[bout_found] =
 				endpoint->bEndpointAddress;
-			buffer_size = endpoint->wMaxPacketSize;
 			dev->bulkout_size[bout_found] = buffer_size;
 			bout_found++;
 		}
-- 
2.15.1
