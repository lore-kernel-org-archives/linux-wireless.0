Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10209 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2ACJs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 04:48:58 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2 3/3] ath6kl: Remove deadcode in main.c
Date: Tue, 3 Jan 2012 15:19:02 +0530
Message-ID: <1325584142-6746-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120103_104907_586418_02010C85)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ath6kl_reset_device(), since control can never reach switch..case
when the target_type is neither TARGET_TYPE_AR6003 nor TARGET_TYPE_AR6004,
remove the default option of switch statement.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
V2 -- Remove the hunk which removes dead code in
      ie length validation. That would be fixed in
      a different patch.

 drivers/net/wireless/ath/ath6kl/main.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index eea3c74..4b20abd 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -347,9 +347,6 @@ void ath6kl_reset_device(struct ath6kl *ar, u32 target_type,
 	case TARGET_TYPE_AR6004:
 		address = AR6004_RESET_CONTROL_ADDRESS;
 		break;
-	default:
-		address = AR6003_RESET_CONTROL_ADDRESS;
-		break;
 	}
 
 	status = ath6kl_diag_write32(ar, address, data);
-- 
1.7.0.4

