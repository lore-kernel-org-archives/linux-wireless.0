Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:65405 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab2EXED4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 May 2012 00:03:56 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20413.45790.400842.374410@gargle.gargle.HOWL> (sfid-20120524_060403_861626_7AE622B3)
Date: Thu, 24 May 2012 09:32:38 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 08/22] ath9k_hw: Fix variable usage
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
1.7.10.2

