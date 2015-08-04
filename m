Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22298 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbbHDHtu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Aug 2015 03:49:50 -0400
Date: Tue, 4 Aug 2015 10:49:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] mwifiex: usb: return an error if kmalloc fails
Message-ID: <20150804074927.GD10867@mwanda> (sfid-20150804_094955_078731_78A26012)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current code returns success if kmalloc fails.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/mwifiex/usb.c b/drivers/net/wireless/mwifiex/usb.c
index fbad99c..f866d5d 100644
--- a/drivers/net/wireless/mwifiex/usb.c
+++ b/drivers/net/wireless/mwifiex/usb.c
@@ -870,8 +870,10 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 
 	/* Allocate memory for transmit */
 	fwdata = kzalloc(FW_DNLD_TX_BUF_SIZE, GFP_KERNEL);
-	if (!fwdata)
+	if (!fwdata) {
+		ret = -ENOMEM;
 		goto fw_exit;
+	}
 
 	/* Allocate memory for receive */
 	recv_buff = kzalloc(FW_DNLD_RX_BUF_SIZE, GFP_KERNEL);
