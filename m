Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11207 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab1JXMmv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Oct 2011 08:42:51 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	<stable@kernel.org>
Subject: [PATCH] ath9k_hw: Update AR9485 initvals to fix system hang issue
Date: Mon, 24 Oct 2011 18:13:40 +0530
Message-ID: <1319460220-6833-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20111024_144254_422315_5A0EF3E5)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes system hang when resuming from S3 state
and lower rate sens failure issue.

Cc: stable@kernel.org
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
index 611ea6c..d16d029 100644
--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -521,7 +521,7 @@ static const u32 ar9485_1_1_radio_postamble[][2] = {
 	{0x000160ac, 0x24611800},
 	{0x000160b0, 0x03284f3e},
 	{0x0001610c, 0x00170000},
-	{0x00016140, 0x10804008},
+	{0x00016140, 0x50804008},
 };
 
 static const u32 ar9485_1_1_mac_postamble[][5] = {
@@ -603,7 +603,7 @@ static const u32 ar9485_1_1_radio_core[][2] = {
 
 static const u32 ar9485_1_1_pcie_phy_pll_on_clkreq_enable_L1[][2] = {
 	/* Addr        allmodes */
-	{0x00018c00, 0x10052e5e},
+	{0x00018c00, 0x18052e5e},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0000080c},
 };
@@ -776,7 +776,7 @@ static const u32 ar9485_modes_green_ob_db_tx_gain_1_1[][5] = {
 
 static const u32 ar9485_1_1_pcie_phy_clkreq_disable_L1[][2] = {
 	/* Addr        allmodes */
-	{0x00018c00, 0x10013e5e},
+	{0x00018c00, 0x18013e5e},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0000080c},
 };
@@ -882,7 +882,7 @@ static const u32 ar9485_fast_clock_1_1_baseband_postamble[][3] = {
 
 static const u32 ar9485_1_1_pcie_phy_pll_on_clkreq_disable_L1[][2] = {
 	/* Addr        allmodes  */
-	{0x00018c00, 0x10012e5e},
+	{0x00018c00, 0x18012e5e},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0000080c},
 };
@@ -1021,7 +1021,7 @@ static const u32 ar9485_common_rx_gain_1_1[][2] = {
 
 static const u32 ar9485_1_1_pcie_phy_clkreq_enable_L1[][2] = {
 	/* Addr        allmodes */
-	{0x00018c00, 0x10053e5e},
+	{0x00018c00, 0x18053e5e},
 	{0x00018c04, 0x000801d8},
 	{0x00018c08, 0x0000080c},
 };
-- 
1.7.7

