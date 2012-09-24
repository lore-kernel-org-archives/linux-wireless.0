Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50787 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755369Ab2IXIec (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Sep 2012 04:34:32 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: fix BT sleep state on chip wakeup
Date: Mon, 24 Sep 2012 14:04:24 +0530
Message-ID: <1348475664-22502-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20120924_103436_378732_A3DCE6F1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever both WLAN and BT in/out sleep mode, sometimes WLAN
is not able to take back the shared LNA control after resumes
from sleep mode. The idea is that for WLAN to check if BT owns
LNA control and BT is in sleep mode when WLAN just resumes from
sleep mode. If the condition is true, do a BTCOEX_RC_WARM_RESET
for WLAN to take back the control of shared LNA.
Now the issue is the BT sleep value read from MCI register is
overlooked by assigning u32 into u8. Hence the above condition never
be met so that WLAN used to report beacon losses and frequent
connection drops.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index cab2384..d3fae36 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1410,7 +1410,7 @@ void ar9003_mci_set_power_awake(struct ath_hw *ah)
 	}
 	REG_WRITE(ah, AR_DIAG_SW, (diag_sw | BIT(27) | BIT(19) | BIT(18)));
 	lna_ctrl = REG_READ(ah, AR_OBS_BUS_CTRL) & 0x3;
-	bt_sleep = REG_READ(ah, AR_MCI_RX_STATUS) & AR_MCI_RX_REMOTE_SLEEP;
+	bt_sleep = MS(REG_READ(ah, AR_MCI_RX_STATUS), AR_MCI_RX_REMOTE_SLEEP);
 
 	REG_WRITE(ah, AR_BTCOEX_CTRL2, btcoex_ctrl2);
 	REG_WRITE(ah, AR_DIAG_SW, diag_sw);
-- 
1.7.12.1

