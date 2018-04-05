Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gateway24.websitewelcome.com ([192.185.51.253]:44754 "EHLO
        gateway24.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751412AbeDEPtw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Apr 2018 11:49:52 -0400
Received: from cm14.websitewelcome.com (cm14.websitewelcome.com [100.42.49.7])
        by gateway24.websitewelcome.com (Postfix) with ESMTP id 5D946422DC
        for <linux-wireless@vger.kernel.org>; Thu,  5 Apr 2018 10:49:51 -0500 (CDT)
Date: Thu, 5 Apr 2018 10:49:49 -0500
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
To: Igor Mitsyanko <imitsyanko@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH] qtnfmac: pearl: pcie: fix memory leak in qtnf_fw_work_handler
Message-ID: <20180405154949.GA32223@embeddedor.com> (sfid-20180405_175005_831392_EC40598E)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In case memory resources for fw were succesfully allocated, release
them before jumping to fw_load_fail.

Addresses-Coverity-ID: 1466092 ("Resource leak")
Fixes: c3b2f7ca4186 ("qtnfmac: implement asynchronous firmware loading")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
index f117904..6c1e139 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/pearl/pcie.c
@@ -1185,6 +1185,10 @@ static void qtnf_fw_work_handler(struct work_struct *work)
 	if (qtnf_poll_state(&priv->bda->bda_ep_state, QTN_EP_FW_LOADRDY,
 			    QTN_FW_DL_TIMEOUT_MS)) {
 		pr_err("card is not ready\n");
+
+		if (!flashboot)
+			release_firmware(fw);
+
 		goto fw_load_fail;
 	}
 
-- 
2.7.4
