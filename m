Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44090 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2JOINs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2012 04:13:48 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 08/12] ath9k_hw: Fix max rx rate drop for AR9565
Date: Mon, 15 Oct 2012 13:25:34 +0530
Message-ID: <1350287738-18687-9-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20121015_101352_128878_87A4E1DF)
In-Reply-To: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1350287738-18687-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Whenever i_coff of IQ calibration is too high, AR9565 drops max
rx rate to MCS4. Skipping IQ update at this time can avoid this
problem for AR9565.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_calib.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_calib.c b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
index 84b558d..162401f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_calib.c
@@ -276,6 +276,11 @@ static void ar9003_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 				offset_array[i],
 				REG_READ(ah, offset_array[i]));
 
+			if (AR_SREV_9565(ah) &&
+			    (iCoff == 63 || qCoff == 63 ||
+			     iCoff == -63 || qCoff == -63))
+				return;
+
 			REG_RMW_FIELD(ah, offset_array[i],
 				      AR_PHY_RX_IQCAL_CORR_IQCORR_Q_I_COFF,
 				      iCoff);
-- 
1.7.12.2

