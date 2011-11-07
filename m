Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6038 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127Ab1KGFa1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Nov 2011 00:30:27 -0500
From: Raja Mani <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 10/11] ath6kl: Remove WARN_ON msg in Suspend path
Date: Mon, 7 Nov 2011 10:55:46 +0530
Message-ID: <1320643547-3578-11-git-send-email-rmani@qca.qualcomm.com> (sfid-20111107_063030_378045_774591F2)
In-Reply-To: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
References: <1320643547-3578-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the current code, WOW resume is executed first from RX path
and ar->state is moved to ATH6KL_STATE_ON. When platform calls
ath6kl_sdio_resume() in CFG resume context, that time ar->state
could have moved to ON state. Printing WARN_ON(1) is void in
this context. Hence removing this.

Once WOW resume is removed from RX path, This WARN_ON msg can be
reverted.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/sdio.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/sdio.c b/drivers/net/wireless/ath/ath6kl/sdio.c
index 0586b3b..beb5f9b 100644
--- a/drivers/net/wireless/ath/ath6kl/sdio.c
+++ b/drivers/net/wireless/ath/ath6kl/sdio.c
@@ -831,8 +831,6 @@ static int ath6kl_sdio_resume(struct ath6kl *ar)
 		break;
 
 	case ATH6KL_STATE_ON:
-		/* we shouldn't be on this state during resume */
-		WARN_ON(1);
 		break;
 
 	case ATH6KL_STATE_DEEPSLEEP:
-- 
1.7.1

