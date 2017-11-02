Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:61691 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755842AbdKBLJp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 2 Nov 2017 07:09:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Ryan Hsu <ryanhsu@qti.qualcomm.com>,
        Govind Singh <govinds@qti.qualcomm.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Ashok Raj Nagarajan <arnagara@qti.qualcomm.com>,
        Ben Greear <greearb@candelatech.com>,
        Brian Norris <briannorris@chromium.org>,
        Colin Ian King <colin.king@canonical.com>,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ath10k: move pci suspend/resume functions
Date: Thu,  2 Nov 2017 12:08:53 +0100
Message-Id: <20171102110903.2886660-1-arnd@arndb.de> (sfid-20171102_121018_477855_465949EF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The combination of two patches has led to a build failure:

drivers/net/wireless/ath/ath10k/pci.c: In function 'ath10k_pci_pm_suspend':
drivers/net/wireless/ath/ath10k/pci.c:3416:8: error: implicit declaration of function 'ath10k_pci_suspend'; did you mean 'ath10k_pci_pm_suspend'? [-Werror=implicit-function-declaration]
drivers/net/wireless/ath/ath10k/pci.c: In function 'ath10k_pci_pm_resume':
drivers/net/wireless/ath/ath10k/pci.c:3428:8: error: implicit declaration of function 'ath10k_pci_resume'; did you mean 'ath10k_pci_pm_resume'? [-Werror=implicit-function-declaration]

This moves the functions outside of the now incorrect #ifdef.

Fixes: 96378bd2c6cd ("ath10k: fix core PCI suspend when WoWLAN is supported but disabled")
Fixes: 6af1de2e4ec4 ("ath10k: mark PM functions as __maybe_unused")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/wireless/ath/ath10k/pci.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/pci.c b/drivers/net/wireless/ath/ath10k/pci.c
index b18a9b690df4..6513edbd86e6 100644
--- a/drivers/net/wireless/ath/ath10k/pci.c
+++ b/drivers/net/wireless/ath/ath10k/pci.c
@@ -2585,6 +2585,13 @@ static int ath10k_pci_hif_suspend(struct ath10k *ar)
 	return 0;
 }
 
+static int ath10k_pci_hif_resume(struct ath10k *ar)
+{
+	/* Nothing to do; the important stuff is in the driver resume. */
+	return 0;
+}
+#endif
+
 static int ath10k_pci_suspend(struct ath10k *ar)
 {
 	/* The grace timer can still be counting down and ar->ps_awake be true.
@@ -2597,12 +2604,6 @@ static int ath10k_pci_suspend(struct ath10k *ar)
 	return 0;
 }
 
-static int ath10k_pci_hif_resume(struct ath10k *ar)
-{
-	/* Nothing to do; the important stuff is in the driver resume. */
-	return 0;
-}
-
 static int ath10k_pci_resume(struct ath10k *ar)
 {
 	struct ath10k_pci *ar_pci = ath10k_pci_priv(ar);
@@ -2627,7 +2628,6 @@ static int ath10k_pci_resume(struct ath10k *ar)
 
 	return ret;
 }
-#endif
 
 static bool ath10k_pci_validate_cal(void *data, size_t size)
 {
-- 
2.9.0
