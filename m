Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26572 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932742Ab2IUJkf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 05:40:35 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH v2 3/3] ath6kl: Check for valid endpoint ID values in ath6kl_control_tx()
Date: Fri, 21 Sep 2012 15:08:55 +0530
Message-ID: <1348220335-29711-3-git-send-email-rmani@qca.qualcomm.com> (sfid-20120921_114039_316448_87AAC7B4)
In-Reply-To: <1348220335-29711-1-git-send-email-rmani@qca.qualcomm.com>
References: <1348220335-29711-1-git-send-email-rmani@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Raja Mani <rmani@qca.qualcomm.com>

It's safe to check endpoint id values before it get
really used. Found this on code review.

Signed-off-by: Raja Mani <rmani@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/txrx.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/txrx.c b/drivers/net/wireless/ath/ath6kl/txrx.c
index e867193..b6dd2bf 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -294,6 +294,12 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 		return -EACCES;
 	}
 
+	if (WARN_ON_ONCE(eid == ENDPOINT_UNUSED ||
+			 eid >= ENDPOINT_MAX)) {
+		status = -EINVAL;
+		goto fail_ctrl_tx;
+	}
+
 	spin_lock_bh(&ar->lock);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
-- 
1.7.1

