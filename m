Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:49538 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab2FSPs5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 11:48:57 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	<aeolus@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 04/10] ath9k_hw: advertise WoW support for capable chipsets
Date: Tue, 19 Jun 2012 21:17:24 +0530
Message-ID: <1340120850-9155-5-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120619_175638_892812_F77F7C02)
In-Reply-To: <1340120850-9155-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1340120850-9155-1-git-send-email-mohammed@qca.qualcomm.com>
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
Tested-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 784baee..fea7f24 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2560,6 +2560,14 @@ int ath9k_hw_fill_cap_info(struct ath_hw *ah)
 	}
 
 
+	if (AR_SREV_9280_20_OR_LATER(ah)) {
+		pCap->wow_caps = ATH9K_HW_WOW_DEVICE_CAPABLE |
+				 ATH9K_HW_WOW_PATTERN_MATCH_EXACT;
+
+		if (AR_SREV_9280(ah))
+			pCap->wow_caps |= ATH9K_HW_WOW_PATTERN_MATCH_DWORD;
+	}
+
 	return 0;
 }
 
-- 
1.7.0.4

