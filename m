Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway21.websitewelcome.com ([192.185.45.2]:29481 "EHLO
        gateway21.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751272AbdEIEni (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 00:43:38 -0400
Received: from cm3.websitewelcome.com (unknown [108.167.139.23])
        by gateway21.websitewelcome.com (Postfix) with ESMTP id 3F2FA400D2330
        for <linux-wireless@vger.kernel.org>; Mon,  8 May 2017 23:22:03 -0500 (CDT)
Date: Mon, 8 May 2017 23:21:59 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] net: wireless: ath: ath10k: remove unnecessary code
Message-ID: <20170509042159.GA19727@embeddedgus> (sfid-20170509_064342_618104_A5FE4C55)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The name of an array used by itself will always return the array's address.
So these tests will always evaluate as false and therefore the _return_
will never be executed.

Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2f1743e..135cf83 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5933,15 +5933,6 @@ static struct sk_buff *ath10k_wmi_10_4_op_gen_init(struct ath10k *ar)
 
 int ath10k_wmi_start_scan_verify(const struct wmi_start_scan_arg *arg)
 {
-	if (arg->ie_len && !arg->ie)
-		return -EINVAL;
-	if (arg->n_channels && !arg->channels)
-		return -EINVAL;
-	if (arg->n_ssids && !arg->ssids)
-		return -EINVAL;
-	if (arg->n_bssids && !arg->bssids)
-		return -EINVAL;
-
 	if (arg->ie_len > WLAN_SCAN_PARAMS_MAX_IE_LEN)
 		return -EINVAL;
 	if (arg->n_channels > ARRAY_SIZE(arg->channels))
-- 
2.5.0
