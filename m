Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f67.google.com ([209.85.160.67]:33078 "EHLO
        mail-pl0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752481AbeEOJWe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 15 May 2018 05:22:34 -0400
Received: by mail-pl0-f67.google.com with SMTP id n10-v6so9070068plp.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 May 2018 02:22:33 -0700 (PDT)
From: Sushant Kumar Mishra <sushant2k1513@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>,
        linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amit.karwar@redpinesignals.com>,
        Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>,
        Sanjay Konduri <sanjay.konduri@redpinesignals.com>
Subject: [PATCH 1/2] rsi: add fix for crash during assertions
Date: Tue, 15 May 2018 14:34:30 +0530
Message-Id: <1526375071-7010-1-git-send-email-sushant2k1513@gmail.com> (sfid-20180515_112309_504353_9A69A267)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sanjay Konduri <sanjay.konduri@redpinesignals.com>

Observed crash in some scenarios when assertion has occurred,
this is because hw structure is freed and is tried to get
accessed in some functions where null check is already
present. So, avoided the crash by making the hw to NULL after
freeing.

Signed-off-by: Sanjay Konduri <sanjay.konduri@redpinesignals.com>
Signed-off-by: Sushant Kumar Mishra <sushant.mishra@redpinesignals.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 3faa044..bfa7569 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -245,6 +245,7 @@ void rsi_mac80211_detach(struct rsi_hw *adapter)
 		ieee80211_stop_queues(hw);
 		ieee80211_unregister_hw(hw);
 		ieee80211_free_hw(hw);
+		adapter->hw = NULL;
 	}
 
 	for (band = 0; band < NUM_NL80211_BANDS; band++) {
-- 
2.1.0
