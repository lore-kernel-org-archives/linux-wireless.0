Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8190 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755968AbaD1PrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Apr 2014 11:47:08 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/2] ath9k_hw: fix worse EVM for 11b rates
Date: Mon, 28 Apr 2014 21:17:08 +0530
Message-ID: <1398700028-28410-2-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140428_174728_444315_32DF7A26)
In-Reply-To: <1398700028-28410-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1398700028-28410-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adjust FIR filter co-efficients to improve EVM for 11b rates.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar9340_initvals.h | 6 +++---
 drivers/net/wireless/ath/ath9k/ar953x_initvals.h | 6 +++---
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
index 9cf7cca..b995ffe 100644
--- a/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9340_initvals.h
@@ -348,9 +348,9 @@ static const u32 ar9340_1p0_baseband_core[][2] = {
 	{0x0000a370, 0x00000000},
 	{0x0000a390, 0x00000001},
 	{0x0000a394, 0x00000444},
-	{0x0000a398, 0x00000000},
-	{0x0000a39c, 0x210d0401},
-	{0x0000a3a0, 0xab9a7144},
+	{0x0000a398, 0x001f0e0f},
+	{0x0000a39c, 0x0075393f},
+	{0x0000a3a0, 0xb79f6427},
 	{0x0000a3a4, 0x00000000},
 	{0x0000a3a8, 0xaaaaaaaa},
 	{0x0000a3ac, 0x3c466478},
diff --git a/drivers/net/wireless/ath/ath9k/ar953x_initvals.h b/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
index 3c9113d..8e5c3b9 100644
--- a/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar953x_initvals.h
@@ -257,9 +257,9 @@ static const u32 qca953x_1p0_baseband_core[][2] = {
 	{0x0000a370, 0x00000000},
 	{0x0000a390, 0x00000001},
 	{0x0000a394, 0x00000444},
-	{0x0000a398, 0x1f020503},
-	{0x0000a39c, 0x29180c03},
-	{0x0000a3a0, 0x9a8b6844},
+	{0x0000a398, 0x001f0e0f},
+	{0x0000a39c, 0x0075393f},
+	{0x0000a3a0, 0xb79f6427},
 	{0x0000a3a4, 0x000000ff},
 	{0x0000a3a8, 0x6a6a6a6a},
 	{0x0000a3ac, 0x6a6a6a6a},
-- 
1.9.2

