Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29096 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752054Ab2FDK6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2012 06:58:55 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20428.38059.197528.233989@gargle.gargle.HOWL> (sfid-20120604_125857_701336_65153984)
Date: Mon, 4 Jun 2012 16:27:47 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 08/20] ath9k_hw: Fix variable usage
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Exposed by sparse:
ar9003_mci.c:1134:31: warning: Using plain integer as NULL pointer

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 9331d73..b501bf1 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1131,7 +1131,7 @@ void ar9003_mci_init_cal_req(struct ath_hw *ah, bool *is_reusable)
 	if (ar9003_mci_wait_for_gpm(ah, MCI_GPM_BT_CAL_GRANT, 0, 50000)) {
 		ath_dbg(common, MCI, "MCI BT_CAL_GRANT received\n");
 	} else {
-		is_reusable = false;
+		*is_reusable = false;
 		ath_dbg(common, MCI, "MCI BT_CAL_GRANT not received\n");
 	}
 }
-- 
1.7.10.3

