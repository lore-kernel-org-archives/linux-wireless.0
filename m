Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43019 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbcDSO0Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Apr 2016 10:26:25 -0400
MIME-Version: 1.0
Message-ID: <20160419142158.GA4876@mwanda> (sfid-20160419_162637_051174_FB3D10AE)
Date: Tue, 19 Apr 2016 07:21:58 -0700 (PDT)
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch 1/2] mwifiex: missing error code on allocation failure
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We accidentally return success instead of -ENOMEM.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/marvell/mwifiex/usb.c b/drivers/net/wireless/marvell/mwifiex/usb.c
index 0510861..cdd8f9a 100644
--- a/drivers/net/wireless/marvell/mwifiex/usb.c
+++ b/drivers/net/wireless/marvell/mwifiex/usb.c
@@ -1017,8 +1017,10 @@ static int mwifiex_prog_fw_w_helper(struct mwifiex_adapter *adapter,
 
 	/* Allocate memory for receive */
 	recv_buff = kzalloc(FW_DNLD_RX_BUF_SIZE, GFP_KERNEL);
-	if (!recv_buff)
+	if (!recv_buff) {
+		ret = -ENOMEM;
 		goto cleanup;
+	}
 
 	do {
 		/* Send pseudo data to check winner status first */
