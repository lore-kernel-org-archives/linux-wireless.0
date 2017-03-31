Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32795 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932838AbdCaL40 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2017 07:56:26 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
        "Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH] ath10k: Enable a HTC debug message during insufficient tx credits
Date: Fri, 31 Mar 2017 17:29:26 +0530
Message-ID: <1490961566-328-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20170331_135629_473216_E9E161E2)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Add an ath10k HTC debug message when insufficient tx credits
are available to send the WMI commands. This is very useful
in debugging issues like 'tx credit starvation' that could
possibly happen with multiclient setup with constant roaming

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/htc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/htc.c b/drivers/net/wireless/ath/ath10k/htc.c
index 9f6a915..f56f604 100644
--- a/drivers/net/wireless/ath/ath10k/htc.c
+++ b/drivers/net/wireless/ath/ath10k/htc.c
@@ -119,6 +119,9 @@ int ath10k_htc_send(struct ath10k_htc *htc,
 		credits = DIV_ROUND_UP(skb->len, htc->target_credit_size);
 		spin_lock_bh(&htc->tx_lock);
 		if (ep->tx_credits < credits) {
+			ath10k_dbg(ar, ATH10K_DBG_HTC,
+				   "htc insufficient credits ep %d required %d available %d\n",
+				   eid, credits, ep->tx_credits);
 			spin_unlock_bh(&htc->tx_lock);
 			ret = -EAGAIN;
 			goto err_pull;
-- 
1.9.1
