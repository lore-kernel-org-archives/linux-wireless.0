Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13478 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbcFUFrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2016 01:47:01 -0400
From: <akolli@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <akolli@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	Anilkumar Kolli <akolli@qti.qualcomm.com>
Subject: [PATCH 1/2] ath10k: remove unused member in ath10k_hw_regs
Date: Tue, 21 Jun 2016 11:18:07 +0530
Message-ID: <1466488088-20961-1-git-send-email-akolli@qti.qualcomm.com> (sfid-20160621_074722_783677_A06E37CA)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Anilkumar Kolli <akolli@qti.qualcomm.com>

rtc_state_cold_reset_mask is unused in ath10k_hw_regs.
instead fixed delays are used.

Signed-off-by: Anilkumar Kolli <akolli@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/hw.c |    3 ---
 drivers/net/wireless/ath/ath10k/hw.h |    2 --
 2 files changed, 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/hw.c b/drivers/net/wireless/ath/ath10k/hw.c
index f544d48518c3..433e064c7718 100644
--- a/drivers/net/wireless/ath/ath10k/hw.c
+++ b/drivers/net/wireless/ath/ath10k/hw.c
@@ -19,7 +19,6 @@
 #include "hw.h"
 
 const struct ath10k_hw_regs qca988x_regs = {
-	.rtc_state_cold_reset_mask	= 0x00000400,
 	.rtc_soc_base_address		= 0x00004000,
 	.rtc_wmac_base_address		= 0x00005000,
 	.soc_core_base_address		= 0x00009000,
@@ -46,7 +45,6 @@ const struct ath10k_hw_regs qca988x_regs = {
 };
 
 const struct ath10k_hw_regs qca6174_regs = {
-	.rtc_state_cold_reset_mask		= 0x00002000,
 	.rtc_soc_base_address			= 0x00000800,
 	.rtc_wmac_base_address			= 0x00001000,
 	.soc_core_base_address			= 0x0003a000,
@@ -73,7 +71,6 @@ const struct ath10k_hw_regs qca6174_regs = {
 };
 
 const struct ath10k_hw_regs qca99x0_regs = {
-	.rtc_state_cold_reset_mask		= 0x00000400,
 	.rtc_soc_base_address			= 0x00080000,
 	.rtc_wmac_base_address			= 0x00000000,
 	.soc_core_base_address			= 0x00082000,
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index f41c91ccb56a..549f99bdfb86 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -208,7 +208,6 @@ enum ath10k_hw_rev {
 };
 
 struct ath10k_hw_regs {
-	u32 rtc_state_cold_reset_mask;
 	u32 rtc_soc_base_address;
 	u32 rtc_wmac_base_address;
 	u32 soc_core_base_address;
@@ -495,7 +494,6 @@ enum ath10k_hw_4addr_pad {
 /* as of IP3.7.1 */
 #define RTC_STATE_V_ON				ar->hw_values->rtc_state_val_on
 
-#define RTC_STATE_COLD_RESET_MASK		ar->regs->rtc_state_cold_reset_mask
 #define RTC_STATE_V_LSB				0
 #define RTC_STATE_V_MASK			0x00000007
 #define RTC_STATE_ADDRESS			0x0000
-- 
1.7.9.5

