Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59161 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbcE3NHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 May 2016 09:07:17 -0400
From: <c_traja@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>,
	Tamizh chelvam <c_traja@qti.qualcomm.com>
Subject: [PATCH] ath10k: enable ipq4019 device probe in ahb module
Date: Mon, 30 May 2016 18:41:23 +0530
Message-ID: <1464613883-24036-1-git-send-email-c_traja@qti.qualcomm.com> (sfid-20160530_150739_135108_EA5F9C6D)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qti.qualcomm.com>

All the necessary patches to make wifi running (over AHB)
on ipq4019 SoC are ready now. It's good to enable
ipq4019 wifi device probing in ahb module and
remove work in progress debug print.

Device tree change is there in the public review by
below commit message
"qcom: ipq4019: add wifi nodes to ipq4019 SoC device tree"

Signed-off-by: Tamizh chelvam <c_traja@qti.qualcomm.com>
Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/ahb.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/ahb.c b/drivers/net/wireless/ath/ath10k/ahb.c
index bd62bc1..ce847bf 100644
--- a/drivers/net/wireless/ath/ath10k/ahb.c
+++ b/drivers/net/wireless/ath/ath10k/ahb.c
@@ -25,10 +25,9 @@
 #include "ahb.h"
 
 static const struct of_device_id ath10k_ahb_of_match[] = {
-	/* TODO: enable this entry once everything in place.
-	 * { .compatible = "qcom,ipq4019-wifi",
-	 *   .data = (void *)ATH10K_HW_QCA4019 },
-	 */
+	{ .compatible = "qcom,ipq4019-wifi",
+	  .data = (void *)ATH10K_HW_QCA4019
+	},
 	{ }
 };
 
@@ -918,8 +917,6 @@ int ath10k_ahb_init(void)
 {
 	int ret;
 
-	printk(KERN_ERR "AHB support is still work in progress\n");
-
 	ret = platform_driver_register(&ath10k_ahb_driver);
 	if (ret)
 		printk(KERN_ERR "failed to register ath10k ahb driver: %d\n",
-- 
1.7.9.5

