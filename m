Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway34.websitewelcome.com ([192.185.148.196]:33575 "EHLO
        gateway34.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751713AbeDZNfb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 09:35:31 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway34.websitewelcome.com (Postfix) with ESMTP id BCA5A46641
        for <linux-wireless@vger.kernel.org>; Thu, 26 Apr 2018 08:13:28 -0500 (CDT)
Date: Thu, 26 Apr 2018 08:13:24 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] rsi_91x_usb: fix uninitialized variable
Message-ID: <20180426131324.GA982@embeddedor.com> (sfid-20180426_153541_585203_5DDF5B5B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is a potential execution path in which variable ret is returned
without being properly initialized previously.

Fix this by storing the value returned by function
rsi_usb_master_reg_write into _ret_.

Addresses-Coverity-ID: 1468407 ("Uninitialized scalar variable")
Fixes: 16d3bb7b2f37 ("rsi: disable fw watchdog timer during reset")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/rsi/rsi_91x_usb.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index b065438..6ce6b75 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb.c
@@ -687,9 +687,10 @@ static int rsi_reset_card(struct rsi_hw *adapter)
 	 */
 	msleep(100);
 
-	if (rsi_usb_master_reg_write(adapter, SWBL_REGOUT,
-				     RSI_FW_WDT_DISABLE_REQ,
-				     RSI_COMMON_REG_SIZE) < 0) {
+	ret = rsi_usb_master_reg_write(adapter, SWBL_REGOUT,
+				       RSI_FW_WDT_DISABLE_REQ,
+				       RSI_COMMON_REG_SIZE);
+	if (ret < 0) {
 		rsi_dbg(ERR_ZONE, "Disabling firmware watchdog timer failed\n");
 		goto fail;
 	}
-- 
2.7.4
