Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:10555 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab2GJJZ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 05:25:27 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v4 04/10] ath9k_hw: advertise WoW support for capable chipsets
Date: Tue, 10 Jul 2012 14:55:17 +0530
Message-ID: <1341912317-12156-1-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120710_112531_322438_F0B5B2EC)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

support WoW for all chipsets starting from AR9280, AR9285, AR9287,
AR9380, AR9382, AR9485, AR9462. Really all hardware may not support
WoW even though the flag is set and the WoW working depends on
your laptop, BIOS apart from the hardware.

Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: vadivel@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index c1659d0..9c8e0d8 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2589,6 +2589,14 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		pCap->hw_caps |= ATH9K_HW_WOW_DEVICE_CAPABLE |
+				 ATH9K_HW_WOW_PATTERN_MATCH_EXACT;
+
+		if (AR_SREV_9280(ah))
+			pCap->hw_caps |= ATH9K_HW_WOW_PATTERN_MATCH_DWORD;
+	}
+
 	return 0;
 }
 
-- 
1.7.0.4

