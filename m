Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:59541 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754860AbdL2JHh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Dec 2017 04:07:37 -0500
From: Colin King <colin.king@canonical.com>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][V2] wcn36xx: fix incorrect assignment to msg_body.min_ch_time
Date: Fri, 29 Dec 2017 09:07:31 +0000
Message-Id: <20171229090732.14928-1-colin.king@canonical.com> (sfid-20171229_100814_616881_7004E963)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Colin Ian King <colin.king@canonical.com>

The second assignment to msg_body.min_ch_time is incorrect, it
should actually be to msg_body.max_ch_time.

Thanks to Bjorn Andersson for identifying the correct way to fix
this as my original fix was incorrect.

Detected by CoverityScan, CID#1463042 ("Unused Value")

Fixes: 2f3bef4b247e ("wcn36xx: Add hardware scan offload support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/net/wireless/ath/wcn36xx/smd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wcn36xx/smd.c b/drivers/net/wireless/ath/wcn36xx/smd.c
index 2914618a0335..2a4871ca9c72 100644
--- a/drivers/net/wireless/ath/wcn36xx/smd.c
+++ b/drivers/net/wireless/ath/wcn36xx/smd.c
@@ -626,7 +626,7 @@ int wcn36xx_smd_start_hw_scan(struct wcn36xx *wcn, struct ieee80211_vif *vif,
 
 	msg_body.scan_type = WCN36XX_HAL_SCAN_TYPE_ACTIVE;
 	msg_body.min_ch_time = 30;
-	msg_body.min_ch_time = 100;
+	msg_body.max_ch_time = 100;
 	msg_body.scan_hidden = 1;
 	memcpy(msg_body.mac, vif->addr, ETH_ALEN);
 	msg_body.p2p_search = vif->p2p;
-- 
2.14.1
