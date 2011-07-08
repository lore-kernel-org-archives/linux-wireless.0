Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57225 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1GHMmR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 08:42:17 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 3/4] ath9k_hw: Remove read-only registers from AR9003 intervals
Date: Fri, 8 Jul 2011 18:12:02 +0530
Message-ID: <1310128923-2778-3-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110708_144226_264298_7E1A296C)
In-Reply-To: <1310128923-2778-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1310128923-2778-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes read only registers that cause invalid
address access and also updates index for measurement filter
calibration window size.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index cbe765b..2339728 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -653,7 +653,7 @@ static const u32 ar9300_2p2_baseband_postamble[][5] = {
 	{0x0000a288, 0x00000110, 0x00000110, 0x00000110, 0x00000110},
 	{0x0000a28c, 0x00022222, 0x00022222, 0x00022222, 0x00022222},
 	{0x0000a2c4, 0x00158d18, 0x00158d18, 0x00158d18, 0x00158d18},
-	{0x0000a2d0, 0x00071981, 0x00071981, 0x00071981, 0x00071982},
+	{0x0000a2d0, 0x00041981, 0x00041981, 0x00041981, 0x00041982},
 	{0x0000a2d8, 0x7999a83b, 0x7999a83b, 0x7999a83b, 0x7999a83b},
 	{0x0000a358, 0x00000000, 0x00000000, 0x00000000, 0x00000000},
 	{0x0000a830, 0x0000019c, 0x0000019c, 0x0000019c, 0x0000019c},
@@ -1500,8 +1500,6 @@ static const u32 ar9300_2p2_mac_core[][2] = {
 	{0x0000816c, 0x00000000},
 	{0x000081c0, 0x00000000},
 	{0x000081c4, 0x33332210},
-	{0x000081c8, 0x00000000},
-	{0x000081cc, 0x00000000},
 	{0x000081ec, 0x00000000},
 	{0x000081f0, 0x00000000},
 	{0x000081f4, 0x00000000},
-- 
1.7.6

