Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51173 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957Ab1CJFfs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 00:35:48 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 09 Mar 2011 21:35:25 -0800
From: Vivek Natarajan <vnatarajan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/3] ath9k_hw: Improve idle power consumption for AR9485.
Date: Thu, 10 Mar 2011 11:05:41 +0530
Message-ID: <1299735343-915-1-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set some GPIO pins to Pull-down mode to save power.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
index eac4d85..71cc0a3 100644
--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -667,6 +667,7 @@ static const u32 ar9485_1_0_pcie_phy_clkreq_enable_L1[][2] = {
 
 static const u32 ar9485_1_0_soc_preamble[][2] = {
 	/*   Addr     allmodes */
+	{0x00004090, 0x00aa10aa},
 	{0x000040a4, 0x00a0c9c9},
 	{0x00007048, 0x00000004},
 };
@@ -1708,6 +1709,7 @@ static const u32 ar9485_1_1_pcie_phy_clkreq_disable_L1[][2] = {
 static const u32 ar9485_1_1_soc_preamble[][2] = {
 	/* Addr        allmodes */
 	{0x00004014, 0xba280400},
+	{0x00004090, 0x00aa10aa},
 	{0x000040a4, 0x00a0c9c9},
 	{0x00007010, 0x00000022},
 	{0x00007020, 0x00000000},
-- 
1.6.3.3

