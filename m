Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:53495 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758189Ab1EaTru (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2011 15:47:50 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [RFC 08/32] ath9k: initialize rx gain table for AR9330
Date: Tue, 31 May 2011 21:36:59 +0200
Message-Id: <1306870643-7935-9-git-send-email-juhosg@openwrt.org> (sfid-20110531_214756_919704_4AF45EC8)
In-Reply-To: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
References: <1306870643-7935-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |   24 ++++++++++++++++++++++--
 1 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 264a7ea..8efdec2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -443,7 +443,17 @@ static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
 	switch (ar9003_hw_get_rx_gain_idx(ah)) {
 	case 0:
 	default:
-		if (AR_SREV_9340(ah))
+		if (AR_SREV_9330_12(ah))
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+					ar9331_common_rx_gain_1p2,
+					ARRAY_SIZE(ar9331_common_rx_gain_1p2),
+					2);
+		else if (AR_SREV_9330_11(ah))
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+					ar9331_common_rx_gain_1p1,
+					ARRAY_SIZE(ar9331_common_rx_gain_1p1),
+					2);
+		else if (AR_SREV_9340(ah))
 			INIT_INI_ARRAY(&ah->iniModesRxGain,
 				       ar9340Common_rx_gain_table_1p0,
 				       ARRAY_SIZE(ar9340Common_rx_gain_table_1p0),
@@ -460,7 +470,17 @@ static void ar9003_rx_gain_table_apply(struct ath_hw *ah)
 				       2);
 		break;
 	case 1:
-		if (AR_SREV_9340(ah))
+		if (AR_SREV_9330_12(ah))
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9331_common_wo_xlna_rx_gain_1p2,
+				ARRAY_SIZE(ar9331_common_wo_xlna_rx_gain_1p2),
+				2);
+		else if (AR_SREV_9330_11(ah))
+			INIT_INI_ARRAY(&ah->iniModesRxGain,
+				ar9331_common_wo_xlna_rx_gain_1p1,
+				ARRAY_SIZE(ar9331_common_wo_xlna_rx_gain_1p1),
+				2);
+		else if (AR_SREV_9340(ah))
 			INIT_INI_ARRAY(&ah->iniModesRxGain,
 				       ar9340Common_wo_xlna_rx_gain_table_1p0,
 				       ARRAY_SIZE(ar9340Common_wo_xlna_rx_gain_table_1p0),
-- 
1.7.2.1

