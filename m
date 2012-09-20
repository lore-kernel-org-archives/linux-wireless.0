Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28188 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab2ITGWH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2012 02:22:07 -0400
From: <rmani@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qca.qualcomm.com>
Subject: [PATCH 3/3] ath6kl: Check for valid endpoint ID values in ath6kl_control_tx()
Date: Thu, 20 Sep 2012 11:51:08 +0530
Message-ID: <1348122068-24648-3-git-send-email-rmani@qca.qualcomm.com> (sfid-20120920_082210_622195_76066238)
In-Reply-To: <1348122068-24648-1-git-send-email-rmani@qca.qualcomm.com>
References: <1348122068-24648-1-git-send-email-rmani@qca.qualcomm.com>
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
index e867193..4ea6559 100644
--- a/drivers/net/wireless/ath/ath6kl/txrx.c
+++ b/drivers/net/wireless/ath/ath6kl/txrx.c
@@ -294,6 +294,12 @@ int ath6kl_control_tx(void *devt, struct sk_buff *skb,
 		return -EACCES;
 	}
 
+	if (WARN_ON_ONCE(eid == ENDPOINT_UNUSED ||
+	    eid >= ENDPOINT_MAX)) {
+		status = -EINVAL;
+		goto fail_ctrl_tx;
+	}
+
 	spin_lock_bh(&ar->lock);
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_TX,
-- 
1.7.1

