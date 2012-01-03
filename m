Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23596 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab2ACJ6t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 04:58:49 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH] ath6kl: Change ielen in ath6kl_add_new_sta() from u8 to size_t
Date: Tue, 3 Jan 2012 15:28:53 +0530
Message-ID: <1325584733-7854-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120103_105853_416224_572D873E)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Otherwise if (ielen <= ATH6KL_MAX_IE) is dead code. It looks safe to
change the type of ielen from u8 to size_t instead of removing this
if check, this ielen can have the length of more than one ies in future.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/main.c b/drivers/net/wireless/ath/ath6kl/main.c
index c44eca2..347e987 100644
--- a/drivers/net/wireless/ath/ath6kl/main.c
+++ b/drivers/net/wireless/ath/ath6kl/main.c
@@ -53,7 +53,7 @@ struct ath6kl_sta *ath6kl_find_sta_by_aid(struct ath6kl *ar, u8 aid)
 }
 
 static void ath6kl_add_new_sta(struct ath6kl *ar, u8 *mac, u16 aid, u8 *wpaie,
-			u8 ielen, u8 keymgmt, u8 ucipher, u8 auth)
+			size_t ielen, u8 keymgmt, u8 ucipher, u8 auth)
 {
 	struct ath6kl_sta *sta;
 	u8 free_slot;
-- 
1.7.0.4

