Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47142 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab2JOKA7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 06:00:59 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2 02/11] ath9k_hw: Fix selfgen chainmask for 9565
Date: Mon, 15 Oct 2012 15:29:46 +0530
Message-ID: <1350295195-23410-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121015_120102_783961_89D30EB3)
In-Reply-To: <1350295195-23410-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1350295195-23410-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Self generated MCI messages is configured to use chain 1. As
ar9565 is 1x1 solution, It can not use Chain 1. Hence fix
Chain 1 for ar9462 alone. Not doing so, could affect WLAN
connectivity in ar9565 as LNA sharing is not informed by BT.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_mci.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_mci.c b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
index 9fa6d22..6fbd376 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_mci.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_mci.c
@@ -1043,7 +1043,9 @@ void ar9003_mci_2g5g_switch(struct ath_hw *ah, bool force)
 
 		if (!(mci->config & ATH_MCI_CONFIG_DISABLE_OSLA))
 			ar9003_mci_osla_setup(ah, true);
-		REG_WRITE(ah, AR_SELFGEN_MASK, 0x02);
+
+		if (AR_SREV_9462(ah))
+			REG_WRITE(ah, AR_SELFGEN_MASK, 0x02);
 	} else {
 		ar9003_mci_send_lna_take(ah, true);
 		udelay(5);
-- 
1.7.12.2

