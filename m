Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51489 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755239Ab2IUOlz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 10:41:55 -0400
From: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <kvalo@qca.qualcomm.com>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH V2] ath6kl: Array index out of bounds check
Date: Fri, 21 Sep 2012 20:11:46 +0530
Message-ID: <1348238506-9691-1-git-send-email-c_ppitch@qca.qualcomm.com> (sfid-20120921_164159_644635_B4709F52)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable assigned_ep can be assigned value of -1 and is never
checked if it equals -1. So the endpoint array can have -1  as the index
value and can be out of bounds.

The value of assigned_ep is checked for -1 and is ensured that the
endpoint array doesn't go out of bounds.

Signed-off-by: Pandiyarajan Pitchaimuthu <c_ppitch@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/htc_mbox.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_mbox.c b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
index cd0e1ba..ceaf921 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_mbox.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_mbox.c
@@ -2492,7 +2492,8 @@ static int ath6kl_htc_mbox_conn_service(struct htc_target *target,
 		max_msg_sz = le16_to_cpu(resp_msg->max_msg_sz);
 	}
 
-	if (assigned_ep >= ENDPOINT_MAX || !max_msg_sz) {
+	if (WARN_ON_ONCE(assigned_ep == ENDPOINT_UNUSED ||
+			 assigned_ep >= ENDPOINT_MAX || !max_msg_sz)) {
 		status = -ENOMEM;
 		goto fail_tx;
 	}
-- 
1.7.9.5

