Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:41704 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194AbbA2Bw3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2015 20:52:29 -0500
Received: from [117.199.141.188] (port=12173 helo=sujith-pixel.qualcomm.com)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YGRci-001zZ7-0V
	for linux-wireless@vger.kernel.org; Wed, 28 Jan 2015 07:21:32 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v2 2/6] ath9k: Update AR955x initvals
Date: Wed, 28 Jan 2015 17:54:22 +0530
Message-Id: <1422447866-19967-3-git-send-email-sujith@msujith.org> (sfid-20150129_025358_297338_DEAE533C)
In-Reply-To: <1422447866-19967-1-git-send-email-sujith@msujith.org>
References: <1422447866-19967-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch disables HW peak detect calibration for
AR955x, since it is problematic on a few boards.
Instead, manual calibration will be done in the
driver.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h b/drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h
index fd6a84c..148562a 100644
--- a/drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar955x_1p0_initvals.h
@@ -63,7 +63,7 @@ static const u32 ar955x_1p0_baseband_postamble[][5] = {
 	{0x00009e1c, 0x0001cf9c, 0x0001cf9c, 0x00021f9c, 0x00021f9c},
 	{0x00009e20, 0x000003b5, 0x000003b5, 0x000003ce, 0x000003ce},
 	{0x00009e2c, 0x0000001c, 0x0000001c, 0x00000021, 0x00000021},
-	{0x00009e3c, 0xcfa10820, 0xcfa10820, 0xcfa10822, 0xcfa10822},
+	{0x00009e3c, 0xcfa10820, 0xcfa10820, 0xcfa10820, 0xcfa10820},
 	{0x00009e44, 0xfe321e27, 0xfe321e27, 0xfe291e27, 0xfe291e27},
 	{0x00009e48, 0x5030201a, 0x5030201a, 0x50302012, 0x50302012},
 	{0x00009fc8, 0x0003f000, 0x0003f000, 0x0001a000, 0x0001a000},
@@ -83,7 +83,7 @@ static const u32 ar955x_1p0_baseband_postamble[][5] = {
 	{0x0000a284, 0x00000000, 0x00000000, 0x00000010, 0x00000010},
 	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
 	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
-	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
+	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00058d18, 0x00058d18},
 	{0x0000a2cc, 0x18c50033, 0x18c43433, 0x18c41033, 0x18c44c33},
 	{0x0000a2d0, 0x00041982, 0x00041982, 0x00041982, 0x00041982},
 	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
-- 
2.2.2

