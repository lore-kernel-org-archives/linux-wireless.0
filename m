Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:39577 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753988AbeGEM7o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 08:59:44 -0400
Received: by mail-pf0-f194.google.com with SMTP id s21-v6so5375097pfm.6
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2018 05:59:44 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sajay.konduri@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Subject: [PATCH 1/4] rsi: fix for low throughput issue
Date: Thu,  5 Jul 2018 18:08:19 +0530
Message-Id: <1530794302-8833-2-git-send-email-sushant2k1513@gmail.com> (sfid-20180705_145947_264017_7FD9D6A7)
In-Reply-To: <1530794302-8833-1-git-send-email-sushant2k1513@gmail.com>
References: <1530794302-8833-1-git-send-email-sushant2k1513@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

observed low throughput rates during verification. This is because, QoS
enable flag is overridden by sequence number in the data descriptor frame.
Hence, added the fix for same.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 0761e61..533d9e9 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -246,7 +246,7 @@ int rsi_prepare_data_desc(struct rsi_common *common, struct sk_buff *skb)
 		}
 	}
 
-	data_desc->mac_flags = cpu_to_le16(seq_num & 0xfff);
+	data_desc->mac_flags |= cpu_to_le16(seq_num & 0xfff);
 	data_desc->qid_tid = ((skb->priority & 0xf) |
 			      ((tx_params->tid & 0xf) << 4));
 	data_desc->sta_id = tx_params->sta_id;
-- 
2.5.5
