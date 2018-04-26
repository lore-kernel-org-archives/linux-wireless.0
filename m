Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:33876 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754727AbeDZOmy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Apr 2018 10:42:54 -0400
Date: Thu, 26 Apr 2018 17:42:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kalle Valo <kvalo@codeaurora.org>,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>
Cc: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Karun Eagalapati <karun256@gmail.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH] rsi: Uninitialized return value in rsi_reset_card()
Message-ID: <20180426144235.GA25897@mwanda> (sfid-20180426_164259_317909_2BBBA515)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If rsi_usb_master_reg_write() fails then "ret" hasn't been initialized.

Fixes: 16d3bb7b2f37 ("rsi: disable fw watchdog timer during reset")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb.c b/drivers/net/wireless/rsi/rsi_91x_usb.c
index b065438f51b2..6ce6b754df12 100644
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
