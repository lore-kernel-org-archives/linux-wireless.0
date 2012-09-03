Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28992 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab2ICHUZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Sep 2012 03:20:25 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 2/4] ath6kl: Remove unnecessary recovery state check in ath6kl_recovery_hb_timer()
Date: Mon, 3 Sep 2012 12:49:35 +0530
Message-ID: <1346656777-15197-2-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120903_092028_240425_54DE14D8)
In-Reply-To: <1346656777-15197-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1346656777-15197-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Checking for recovery state just before re-arming hb_timer is not
necessary, this should be done at the begining of the timer instead.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/recovery.c |    5 +----
 1 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/recovery.c b/drivers/net/wireless/ath/ath6kl/recovery.c
index c30df50..1a82e8b 100644
--- a/drivers/net/wireless/ath/ath6kl/recovery.c
+++ b/drivers/net/wireless/ath/ath6kl/recovery.c
@@ -61,7 +61,7 @@ static void ath6kl_recovery_hb_timer(unsigned long data)
 	struct ath6kl *ar = (struct ath6kl *) data;
 	int err;
 
-	if (!ar->fw_recovery.enable)
+	if (!ar->fw_recovery.enable || (ar->state == ATH6KL_STATE_RECOVERY))
 		return;
 
 	if (ar->fw_recovery.hb_pending)
@@ -86,9 +86,6 @@ static void ath6kl_recovery_hb_timer(unsigned long data)
 		ath6kl_warn("Failed to send hb challenge request, err:%d\n",
 			    err);
 
-	if ((ar->state == ATH6KL_STATE_RECOVERY) || !ar->fw_recovery.enable)
-		return;
-
 	mod_timer(&ar->fw_recovery.hb_timer, jiffies +
 		  msecs_to_jiffies(ar->fw_recovery.hb_poll));
 }
-- 
1.7.0.4

