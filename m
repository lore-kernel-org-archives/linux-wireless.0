Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alexa-out.qualcomm.com ([129.46.98.28]:29317 "EHLO
        alexa-out.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752166AbeBEELq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 4 Feb 2018 23:11:46 -0500
From: Govind Singh <govinds@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>
Subject: [PATCH] ath10k: Fix log message for hif power on failure
Date: Mon,  5 Feb 2018 09:41:34 +0530
Message-Id: <1517803894-4250-1-git-send-email-govinds@codeaurora.org> (sfid-20180205_051150_664852_137A424E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

HIF power-on failure is applicable to each underlying
bus type. Fix log message for hif power on failure.

Signed-off-by: Govind Singh <govinds@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 8716ea4..52a19c1 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1,6 +1,7 @@
 /*
  * Copyright (c) 2005-2011 Atheros Communications Inc.
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -2423,7 +2424,7 @@ static int ath10k_core_probe_fw(struct ath10k *ar)
 
 	ret = ath10k_hif_power_up(ar);
 	if (ret) {
-		ath10k_err(ar, "could not start pci hif (%d)\n", ret);
+		ath10k_err(ar, "could not power on hif bus (%d)\n", ret);
 		return ret;
 	}
 
-- 
1.9.1
