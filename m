Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25112 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031997AbbKFKBj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Nov 2015 05:01:39 -0500
Date: Fri, 6 Nov 2015 13:01:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
	ath9k-devel@venema.h4ckr.net, kernel-janitors@vger.kernel.org
Subject: [patch] ath9k_htc: check for underflow in ath9k_htc_rx_msg()
Message-ID: <20151106100120.GB18557@mwanda> (sfid-20151106_110146_331046_4C562B2B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We check for overflow here, but we don't check for underflow so it
causes a static checker warning.

Fixes: fb9987d0f748 ('ath9k_htc: Support for AR9271 chipset.')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 2294709..fd85f996 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -414,7 +414,7 @@ void ath9k_htc_rx_msg(struct htc_target *htc_handle,
 		return;
 	}
 
-	if (epid >= ENDPOINT_MAX) {
+	if (epid < 0 || epid >= ENDPOINT_MAX) {
 		if (pipe_id != USB_REG_IN_PIPE)
 			dev_kfree_skb_any(skb);
 		else
