Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:54611 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab1GVFn3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jul 2011 01:43:29 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 23/31] ath6kl: Print bad trailer data only when htc fails to parse trailer info
Date: Fri, 22 Jul 2011 08:41:56 +0300
Message-ID: <1311313324-6766-25-git-send-email-kvalo@qca.qualcomm.com> (sfid-20110722_074335_357496_282AF952)
In-Reply-To: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1311313324-6766-1-git-send-email-kvalo@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc.c b/drivers/net/wireless/ath/ath6kl/htc.c
index 8367979..9d9948e 100644
--- a/drivers/net/wireless/ath/ath6kl/htc.c
+++ b/drivers/net/wireless/ath/ath6kl/htc.c
@@ -1400,8 +1400,9 @@ static int htc_proc_trailer(struct htc_target *target,
 		len -= record->len;
 	}
 
-	ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "BAD Recv Trailer",
-		     orig_buf, orig_len);
+	if (status)
+		ath6kl_dbg_dump(ATH6KL_DBG_RAW_BYTES, "BAD Recv Trailer",
+				orig_buf, orig_len);
 
 	return status;
 }
-- 
1.7.1

