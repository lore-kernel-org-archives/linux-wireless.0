Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52277 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab1HEN3h (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 09:29:37 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Madhan Jaganathan <madhanj@qca.qualcomm.com>
Subject: [PATCH 3/3] ath9k_hw: Fix incorrect spur_freq_sd for AR9003
Date: Fri, 5 Aug 2011 18:59:42 +0530
Message-ID: <1312550982-21914-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110805_152940_424271_6BD8BB0D)
In-Reply-To: <1312550982-21914-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1312550982-21914-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Spur frequency was incorrectly computed with 10Mhz offset
which could cause the filter would not notch out the spur
and also this could improve rx sensitivity in HT40.

Cc: Madhan Jaganathan <madhanj@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index c906e9e..dbe0b58 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -370,7 +370,7 @@ static void ar9003_hw_spur_ofdm_work(struct ath_hw *ah,
 			else
 				spur_subchannel_sd = 0;
 
-			spur_freq_sd = ((freq_offset + 10) << 9) / 11;
+			spur_freq_sd = (freq_offset << 9) / 11;
 
 		} else {
 			if (REG_READ_FIELD(ah, AR_PHY_GEN_CTRL,
@@ -379,7 +379,7 @@ static void ar9003_hw_spur_ofdm_work(struct ath_hw *ah,
 			else
 				spur_subchannel_sd = 1;
 
-			spur_freq_sd = ((freq_offset - 10) << 9) / 11;
+			spur_freq_sd = (freq_offset << 9) / 11;
 
 		}
 
-- 
1.7.6

