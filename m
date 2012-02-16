Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61219 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757148Ab2BPGXN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Feb 2012 01:23:13 -0500
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20284.41146.869660.914302@gargle.gargle.HOWL> (sfid-20120216_072316_988975_36507C7A)
Date: Thu, 16 Feb 2012 11:52:50 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 8/9] ath9k: Fix programming SYNTH4 for AR9462
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The LONG_SHIFT_SELECT offset is different for AR9462 from
the other chip families. Fix this.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.h b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
index aca24bf..81f3e85 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.h
@@ -625,8 +625,8 @@
 #define AR_PHY_AIC_STAT_2_B0	(AR_SM_BASE + 0x4cc)
 
 #define AR_PHY_65NM_CH0_SYNTH4      0x1608c
-#define AR_PHY_SYNTH4_LONG_SHIFT_SELECT   0x00000002
-#define AR_PHY_SYNTH4_LONG_SHIFT_SELECT_S 1
+#define AR_PHY_SYNTH4_LONG_SHIFT_SELECT   (AR_SREV_9462(ah) ? 0x00000001 : 0x00000002)
+#define AR_PHY_SYNTH4_LONG_SHIFT_SELECT_S (AR_SREV_9462(ah) ? 0 : 1)
 #define AR_PHY_65NM_CH0_SYNTH7      0x16098
 #define AR_PHY_65NM_CH0_BIAS1       0x160c0
 #define AR_PHY_65NM_CH0_BIAS2       0x160c4
-- 
1.7.9.1

