Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44998 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2JOIOI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 04:14:08 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 11/12] ath9k: adjust duty cycle for FTP profile for AR9565
Date: Mon, 15 Oct 2012 13:25:37 +0530
Message-ID: <1350287738-18687-12-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121015_103931_416928_1DA07625)
In-Reply-To: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/mci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/mci.c b/drivers/net/wireless/ath/ath9k/mci.c
index 19dbac4..0dd2cbb 100644
--- a/drivers/net/wireless/ath/ath9k/mci.c
+++ b/drivers/net/wireless/ath/ath9k/mci.c
@@ -157,7 +157,7 @@ static void ath_mci_update_scheme(struct ath_softc *sc)
 			 * For single PAN/FTP profile, allocate 35% for BT
 			 * to improve WLAN throughput.
 			 */
-			btcoex->duty_cycle = 35;
+			btcoex->duty_cycle = AR_SREV_9565(sc->sc_ah) ? 40 : 35;
 			btcoex->btcoex_period = 53;
 			ath_dbg(common, MCI,
 				"Single PAN/FTP bt period %d ms dutycycle %d\n",
-- 
1.7.12.2

