Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway23.websitewelcome.com ([192.185.50.141]:34723 "EHLO
        gateway23.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753210AbdEINPD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 9 May 2017 09:15:03 -0400
Received: from cm5.websitewelcome.com (cm5.websitewelcome.com [108.167.139.22])
        by gateway23.websitewelcome.com (Postfix) with ESMTP id 2B2C11A703
        for <linux-wireless@vger.kernel.org>; Tue,  9 May 2017 07:51:31 -0500 (CDT)
Date: Tue, 9 May 2017 07:51:29 -0500
From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH v2] ath10k: remove unnecessary code
Message-ID: <20170509125129.GA21962@embeddedgus> (sfid-20170509_151506_879921_5422911C)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The array fields in struct wmi_start_scan_arg that are checked here are
fixed size arrays so they can never be NULL.

Addresses-Coverity-ID: 1260031
Cc: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
Changes in v2:
 Rephrase commit log.

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
