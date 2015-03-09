Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:53362 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752584AbbCIIq1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Mar 2015 04:46:27 -0400
Received: from [117.207.78.0] (port=10150 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YUtKU-0033Ry-Mz
	for linux-wireless@vger.kernel.org; Mon, 09 Mar 2015 04:46:27 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] ath9k: Add PCIE powersave macros
Date: Mon,  9 Mar 2015 14:20:06 +0530
Message-Id: <1425891010-21522-2-git-send-email-sujith@msujith.org> (sfid-20150309_094638_187828_FD780398)
In-Reply-To: <1425891010-21522-1-git-send-email-sujith@msujith.org>
References: <1425891010-21522-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

These will be used to handle chip-specific
power save configuration.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 29a25d9..2bb3b33 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -309,6 +309,12 @@ enum ath9k_hw_hang_checks {
 	HW_MAC_HANG               = BIT(5),
 };
 
+#define AR_PCIE_PLL_PWRSAVE_CONTROL BIT(0)
+#define AR_PCIE_PLL_PWRSAVE_ON_D3   BIT(1)
+#define AR_PCIE_PLL_PWRSAVE_ON_D0   BIT(2)
+#define AR_PCIE_CDR_PWRSAVE_ON_D3   BIT(3)
+#define AR_PCIE_CDR_PWRSAVE_ON_D0   BIT(4)
+
 struct ath9k_ops_config {
 	int dma_beacon_response_time;
 	int sw_beacon_response_time;
-- 
2.3.1

