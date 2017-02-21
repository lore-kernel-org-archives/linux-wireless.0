Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f50.google.com ([209.85.215.50]:34276 "EHLO
        mail-lf0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbdBUJEh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 04:04:37 -0500
Received: by mail-lf0-f50.google.com with SMTP id g134so17495007lfe.1
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 01:04:36 -0800 (PST)
From: Marcin Rokicki <marcin.rokicki@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: Remove return statement from a void function
Date: Tue, 21 Feb 2017 10:04:33 +0100
Message-Id: <1487667873-3493-1-git-send-email-marcin.rokicki@tieto.com> (sfid-20170221_100442_296515_9E8F69AE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The empty 'return;' statement in a void function should be
used to return from somewhere else then the end.

Signed-off-by: Marcin Rokicki <marcin.rokicki@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 59729aa..d65850e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2268,7 +2268,7 @@ static void ath10k_core_register_work(struct work_struct *work)
 	status = ath10k_core_probe_fw(ar);
 	if (status) {
 		ath10k_err(ar, "could not probe fw (%d)\n", status);
-		goto err;
+		return;
 	}
 
 	status = ath10k_mac_register(ar);
@@ -2307,11 +2307,10 @@ static void ath10k_core_register_work(struct work_struct *work)
 	ath10k_mac_unregister(ar);
 err_release_fw:
 	ath10k_core_free_firmware_files(ar);
-err:
-	/* TODO: It's probably a good idea to release device from the driver
-	 * but calling device_release_driver() here will cause a deadlock.
-	 */
-	return;
+
+/* TODO: It's probably a good idea to release device from the driver
+ * but calling device_release_driver() here will cause a deadlock.
+ */
 }
 
 int ath10k_core_register(struct ath10k *ar, u32 chip_id)
-- 
2.7.4
