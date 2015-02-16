Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:48964 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139AbbBPFRT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 00:17:19 -0500
Received: from [117.222.159.239] (port=14037 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YNE3a-000EUz-2M
	for linux-wireless@vger.kernel.org; Mon, 16 Feb 2015 00:17:18 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/9] ath9k: Remove useless check in MCI reset
Date: Mon, 16 Feb 2015 10:49:54 +0530
Message-Id: <1424064001-7009-3-git-send-email-sujith@msujith.org> (sfid-20150216_061722_814420_DD8270B4)
In-Reply-To: <1424064001-7009-1-git-send-email-sujith@msujith.org>
References: <1424064001-7009-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

If we fail to allocate the sched/gpm buffers when
initializing MCI, we bail out properly. Checking
them in ar9003_mci_reset() is unnecessary, so remove it.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 7b94a6c..4aed985 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -831,11 +831,6 @@ int ar9003_mci_reset(struct ath_hw *ah, bool en_int, bool is_2g,
 	ath_dbg(common, MCI, "MCI Reset (full_sleep = %d, is_2g = %d)\n",
 		is_full_sleep, is_2g);
 
-	if (!mci->gpm_addr && !mci->sched_addr) {
-		ath_err(common, "MCI GPM and schedule buffers are not allocated\n");
-		return -ENOMEM;
-	}
-
 	if (REG_READ(ah, AR_BTCOEX_CTRL) == 0xdeadbeef) {
 		ath_err(common, "BTCOEX control register is dead\n");
 		return -EINVAL;
-- 
2.3.0

