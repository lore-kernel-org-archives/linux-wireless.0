Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:38163 "EHLO
        mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932215AbcLGRIM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 7 Dec 2016 12:08:12 -0500
Received: by mail-wm0-f42.google.com with SMTP id f82so177089964wmf.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 Dec 2016 09:08:12 -0800 (PST)
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 2/5] ath10k: override CE5 config for QCA9377
Date: Wed,  7 Dec 2016 18:07:31 +0100
Message-Id: <1481130454-27244-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20161207_180817_182703_29E11F41)
In-Reply-To: <1481130454-27244-1-git-send-email-bartosz.markowski@tieto.com>
References: <1481130454-27244-1-git-send-email-bartosz.markowski@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Similarly to QCA6174, QCA9377 requires the CE5 configuration to be
available for other feature. Use the ath10k_pci_override_ce_config()
for it as well.

This is required for TF2.0 firmware. Previous FW revisions were
working fine without this patch.

Fixes: a70587b3389a ("ath10k: configure copy engine 5 for HTT messages")
Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index 983f65bbb7fb..85367006a80a 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -3132,7 +3132,7 @@ int ath10k_pci_setup_resource(struct ath10k *ar)
 	setup_timer(&ar_pci->rx_post_retry, ath10k_pci_rx_replenish_retry,
 		    (unsigned long)ar);
 
-	if (QCA_REV_6174(ar))
+	if (QCA_REV_6174(ar) || QCA_REV_9377(ar))
 		ath10k_pci_override_ce_config(ar);
 
 	ret = ath10k_pci_alloc_pipes(ar);
-- 
2.1.2
