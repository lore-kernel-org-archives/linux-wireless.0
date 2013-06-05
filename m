Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61911 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab3FECQf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jun 2013 22:16:35 -0400
Received: by mail-wg0-f52.google.com with SMTP id z12so206874wgg.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jun 2013 19:16:33 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 5 Jun 2013 10:16:33 +0800
Message-ID: <CAPgLHd8XdFPQ+HUq085qmge66dhMxJurrZ2Uwut4w6Pfh_sqhA@mail.gmail.com> (sfid-20130605_041648_079277_61A5C4A3)
Subject: [PATCH] iwlegacy: fix error return code in il3945_pci_probe()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: sgruszka@redhat.com, linville@tuxdriver.com
Cc: yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Fix to return a negative error code in the il3945_hw_set_hw_params() error
handling case instead of 0, as done elsewhere in this function.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/net/wireless/iwlegacy/3945-mac.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index dce5e8f..9581d07 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -3727,7 +3727,8 @@ il3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * 5. Setup HW Constants
 	 * ********************/
 	/* Device-specific setup */
-	if (il3945_hw_set_hw_params(il)) {
+	err = il3945_hw_set_hw_params(il);
+	if (err) {
 		IL_ERR("failed to set hw settings\n");
 		goto out_eeprom_free;
 	}

