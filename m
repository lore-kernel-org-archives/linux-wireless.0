Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:58559 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755959AbaHVMd0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Aug 2014 08:33:26 -0400
Received: by mail-la0-f47.google.com with SMTP id mc6so9783064lab.6
        for <linux-wireless@vger.kernel.org>; Fri, 22 Aug 2014 05:33:24 -0700 (PDT)
From: Michal Kazior <michal.kazior@tieto.com>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Michal Kazior <michal.kazior@tieto.com>
Subject: [PATCH v2 1/6] ath10k: move fw init print
Date: Fri, 22 Aug 2014 14:23:29 +0200
Message-Id: <1408710214-24894-2-git-send-email-michal.kazior@tieto.com> (sfid-20140822_143329_567905_748EF803)
In-Reply-To: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
References: <1408710214-24894-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware probing is done only once when driver is
registered and firmware version is guaranteed to
remain the same until driver is unregistered.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 28f0ade..23ba321 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -815,11 +815,6 @@ int ath10k_core_start(struct ath10k *ar)
 
 	INIT_LIST_HEAD(&ar->arvifs);
 
-	if (!test_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags))
-		ath10k_print_driver_info(ar);
-
-	__set_bit(ATH10K_FLAG_FIRST_BOOT_DONE, &ar->dev_flags);
-
 	return 0;
 
 err_hif_stop:
@@ -924,6 +919,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 		return ret;
 	}
 
+	ath10k_print_driver_info(ar);
 	ath10k_core_stop(ar);
 
 	mutex_unlock(&ar->conf_mutex);
-- 
1.8.5.3

