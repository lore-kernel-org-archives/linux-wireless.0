Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f68.google.com ([74.125.83.68]:37673 "EHLO
        mail-pg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751144AbdHCOal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 3 Aug 2017 10:30:41 -0400
Received: by mail-pg0-f68.google.com with SMTP id 83so1656708pgb.4
        for <linux-wireless@vger.kernel.org>; Thu, 03 Aug 2017 07:30:41 -0700 (PDT)
From: Amitkumar Karwar <amitkarwar@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Subject: [PATCH] rsi: fix uninitialized descriptor pointer issue
Date: Thu,  3 Aug 2017 19:56:39 +0530
Message-Id: <1501770400-6659-1-git-send-email-amitkarwar@gmail.com> (sfid-20170803_163046_292241_6C6C1570)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>

This patch fixes the uninitialized descriptor pointer
issue in function rsi_send_internal_mgmt_frame().
Descriptor should point to start of the skb data.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 9a629fafe7d8 ("rsi: immediate wakeup bit and priority for TX command packets")
Signed-off-by: Prameela Rani Garnepudi <prameela.j04cs@gmail.com>
Signed-off-by: Amitkumar Karwar <amit.karwar@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index c6e8a20..ba8a68f 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -275,6 +275,7 @@ static int rsi_send_internal_mgmt_frame(struct rsi_common *common,
 		rsi_dbg(ERR_ZONE, "%s: Unable to allocate skb\n", __func__);
 		return -ENOMEM;
 	}
+	desc = (struct rsi_cmd_desc *)skb->data;
 	desc->desc_dword0.len_qno |= cpu_to_le16(DESC_IMMEDIATE_WAKEUP);
 	skb->priority = MGMT_SOFT_Q;
 	tx_params = (struct skb_info *)&IEEE80211_SKB_CB(skb)->driver_data;
-- 
2.7.4
