Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:33194 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751266AbdBUK2Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 05:28:16 -0500
Received: by mail-wr0-f169.google.com with SMTP id 97so589388wrb.0
        for <linux-wireless@vger.kernel.org>; Tue, 21 Feb 2017 02:28:16 -0800 (PST)
From: Marcin Rokicki <marcin.rokicki@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org, arend.vanspriel@broadcom.com
Subject: [PATCH v2] ath10k: Remove return statement from a void function
Date: Tue, 21 Feb 2017 11:28:11 +0100
Message-Id: <1487672891-8584-1-git-send-email-marcin.rokicki@tieto.com> (sfid-20170221_112820_261636_78E4E980)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The empty 'return;' statement in a void function should be
used to return from somewhere else than the end.

Signed-off-by: Marcin Rokicki <marcin.rokicki@tieto.com>
---

Changes for v2
 -remove only return statement instead of empty err label
  which can be used in the future

---
 drivers/net/wireless/ath/ath10k/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 59729aa..a22d3c9 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -2311,7 +2311,7 @@ static void ath10k_core_register_work(struct work_struct *work)
 	/* TODO: It's probably a good idea to release device from the driver
 	 * but calling device_release_driver() here will cause a deadlock.
 	 */
-	return;
+	;
 }
 
 int ath10k_core_register(struct ath10k *ar, u32 chip_id)
-- 
2.7.4
