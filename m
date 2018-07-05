Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f196.google.com ([209.85.192.196]:37316 "EHLO
        mail-pf0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754071AbeGEM7x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jul 2018 08:59:53 -0400
Received: by mail-pf0-f196.google.com with SMTP id h20-v6so5371894pfn.4
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jul 2018 05:59:53 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Kumar Konduri <sajay.konduri@redpinesignals.com>,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
Subject: [PATCH 3/4] rsi: fix for WoWLAN wakeup in security mode.
Date: Thu,  5 Jul 2018 18:08:21 +0530
Message-Id: <1530794302-8833-4-git-send-email-sushant2k1513@gmail.com> (sfid-20180705_145956_821897_696B0B9F)
In-Reply-To: <1530794302-8833-1-git-send-email-sushant2k1513@gmail.com>
References: <1530794302-8833-1-git-send-email-sushant2k1513@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>

System is unable to wake-up through magic-packet in secured connections.
Because key descriptor is getting corrupted and firmware is unable to
decrypt the magic packet. Fixed the issue by properly preparing it
before sending it to firmware.

Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mgmt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mgmt.c b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
index 8280f32..1095df7 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mgmt.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mgmt.c
@@ -746,7 +746,7 @@ int rsi_hal_load_key(struct rsi_common *common,
 			key_descriptor |= RSI_CIPHER_TKIP;
 	}
 	key_descriptor |= RSI_PROTECT_DATA_FRAMES;
-	key_descriptor |= ((key_id << RSI_KEY_ID_OFFSET) & RSI_KEY_ID_MASK);
+	key_descriptor |= (key_id << RSI_KEY_ID_OFFSET);
 
 	rsi_set_len_qno(&set_key->desc_dword0.len_qno,
 			(frame_len - FRAME_DESC_SZ), RSI_WIFI_MGMT_Q);
-- 
2.5.5
