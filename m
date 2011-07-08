Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8225 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864Ab1GHMmI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 08:42:08 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/4] ath9k_hw: Disable power detector calibration for AR9003
Date: Fri, 8 Jul 2011 18:12:01 +0530
Message-ID: <1310128923-2778-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110708_144225_185694_BEC8FBE9)
In-Reply-To: <1310128923-2778-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1310128923-2778-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The power detector calibration is disabled because this block
doesn't exist in AR9003 based chips and also parallel
calibration is enabled otherwise the calibration will never stop.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 39efcbf..cbe765b 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -654,7 +654,7 @@ static const u32 ar9300_2p2_baseband_postamble[][5] = {
 	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
 	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
 	{0x0000a2d0, 0x00071981, 0x00071981, 0x00071981, 0x00071982},
-	{0x0000a2d8, 0x7999a83a, 0x7999a83a, 0x7999a83a, 0x7999a83a},
+	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a830, 0x0000019c, 0x0000019c, 0x0000019c, 0x0000019c},
 	{0x0000ae04, 0x001c0000, 0x001c0000, 0x001c0000, 0x001c0000},
@@ -761,7 +761,7 @@ static const u32 ar9300_2p2_baseband_core[][2] = {
 	{0x0000a3ec, 0x20202020},
 	{0x0000a3f0, 0x00000000},
 	{0x0000a3f4, 0x00000246},
-	{0x0000a3f8, 0x0cdbd380},
+	{0x0000a3f8, 0x0c9bd380},
 	{0x0000a3fc, 0x000f0f01},
 	{0x0000a400, 0x8fa91f01},
 	{0x0000a404, 0x00000000},
-- 
1.7.6

