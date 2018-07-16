Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34174 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727313AbeGPODt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Jul 2018 10:03:49 -0400
Received: by mail-pf0-f194.google.com with SMTP id k19-v6so931804pfi.1
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jul 2018 06:36:19 -0700 (PDT)
From: Siva Rebbagondla <siva8118@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Amol Hanwate <amol.hanwate@redpinesignals.com>
Subject: [PATCH 4/6] rsi: Correct RSI_NEEDED_HEADROOM in mac80211_attach.
Date: Mon, 16 Jul 2018 19:09:35 +0530
Message-Id: <1531748377-29215-5-git-send-email-siva8118@gmail.com> (sfid-20180716_153622_832052_D80AD2A7)
In-Reply-To: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
References: <1531748377-29215-1-git-send-email-siva8118@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amol Hanwate <amol.hanwate@redpinesignals.com>

Currently, RSI_NEEDED_HEADROOM is '80' for rsi driver, which is wrong.
As per rsi internal frame format, the RSI_NEEDED_HEADROOM shall be '84',
which is 64(dword_align) + 4(extended_desc) + 16(frame_desc).
Hence, corrected the needed headroom.

Signed-off-by: Amol Hanwate <amol.hanwate@redpinesignals.com>
Signed-off-by: Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_mgmt.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 1462093..359fbdf 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -22,7 +22,7 @@
 #include "rsi_main.h"
 
 #define MAX_MGMT_PKT_SIZE               512
-#define RSI_NEEDED_HEADROOM             80
+#define RSI_NEEDED_HEADROOM             84
 #define RSI_RCV_BUFFER_LEN              2000
 
 #define RSI_11B_MODE                    0
-- 
2.5.5
