Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp08.smtpout.orange.fr ([80.12.242.130]:34647 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751366AbdBSJ70 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 19 Feb 2017 04:59:26 -0500
From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To: lauro.venancio@openbossa.org, aloisio.almeida@openbossa.org,
        sameo@linux.intel.com, christophe.ricard@gmail.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Subject: [PATCH] NFC: st21nfca: Fix potential memory leak
Date: Sun, 19 Feb 2017 10:58:47 +0100
Message-Id: <20170219095847.9397-1-christophe.jaillet@wanadoo.fr> (sfid-20170219_105948_003507_B4752F44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If all bits of 'dev_mask' are already set, there is a memory leak because
'info' should be freed before returning.

While fixing it, 'return -ENOMEM' directly if the first kzalloc fails.
This makes the code more readable.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 drivers/nfc/st21nfca/core.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/nfc/st21nfca/core.c b/drivers/nfc/st21nfca/core.c
index dacb9166081b..50be3b788f1c 100644
--- a/drivers/nfc/st21nfca/core.c
+++ b/drivers/nfc/st21nfca/core.c
@@ -959,10 +959,8 @@ int st21nfca_hci_probe(void *phy_id, struct nfc_phy_ops *phy_ops,
 	unsigned long quirks = 0;
 
 	info = kzalloc(sizeof(struct st21nfca_hci_info), GFP_KERNEL);
-	if (!info) {
-		r = -ENOMEM;
-		goto err_alloc_hdev;
-	}
+	if (!info)
+		return -ENOMEM;
 
 	info->phy_ops = phy_ops;
 	info->phy_id = phy_id;
@@ -978,8 +976,10 @@ int st21nfca_hci_probe(void *phy_id, struct nfc_phy_ops *phy_ops,
 	 * persistent info to discriminate 2 identical chips
 	 */
 	dev_num = find_first_zero_bit(dev_mask, ST21NFCA_NUM_DEVICES);
-	if (dev_num >= ST21NFCA_NUM_DEVICES)
-		return -ENODEV;
+	if (dev_num >= ST21NFCA_NUM_DEVICES) {
+		r = -ENODEV;
+		goto err_alloc_hdev;
+	}
 
 	set_bit(dev_num, dev_mask);
 
-- 
2.9.3
