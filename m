Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35784 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751725AbeAZFk3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 26 Jan 2018 00:40:29 -0500
From: Yu Wang <yyuwang@codeaurora.org>
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath10k: correct the length of DRAM dump for QCA6174 hw3.x/QCA9377 hw1.1
Date: Fri, 26 Jan 2018 13:40:21 +0800
Message-Id: <1516945221-4710-2-git-send-email-yyuwang@codeaurora.org> (sfid-20180126_064044_062374_0AF53166)
In-Reply-To: <1516945221-4710-1-git-send-email-yyuwang@codeaurora.org>
References: <1516945221-4710-1-git-send-email-yyuwang@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The length of DRAM dump for QCA6174 hw3.0/hw3.2 and QCA9377 hw1.1
are less than the actual value, some coredump contents are missed.
To fix it, change the length from 0x90000 to 0xa8000.

Fixes: 703f261dd77f ("ath10k: add memory dump support for QCA6174/QCA9377")
Signed-off-by: Yu Wang <yyuwang@codeaurora.org>
---
 drivers/net/wireless/ath/ath10k/coredump.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/coredump.c b/drivers/net/wireless/ath/ath10k/coredump.c
index 4dde126..7173b37 100644
--- a/drivers/net/wireless/ath/ath10k/coredump.c
+++ b/drivers/net/wireless/ath/ath10k/coredump.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2011-2017 Qualcomm Atheros, Inc.
+ * Copyright (c) 2018, The Linux Foundation. All rights reserved.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
  * purpose with or without fee is hereby granted, provided that the above
@@ -616,7 +617,7 @@
 	{
 		.type = ATH10K_MEM_REGION_TYPE_DRAM,
 		.start = 0x400000,
-		.len = 0x90000,
+		.len = 0xa8000,
 		.name = "DRAM",
 		.section_table = {
 			.sections = NULL,
-- 
1.9.1
