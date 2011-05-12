Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:47728 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169Ab1ELKym (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 06:54:42 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 03:54:13 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <ray.li@greenwavereality.com>, <kathy.giori@atheros.com>,
	<aeolus.yang@atheros.com>, <linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	<stable@kernel.org>, <compat@orbit-lab.org>
Subject: [PATCH 1/1] ath9k_hw: Fix STA connection issues with AR9380 (XB113).
Date: Thu, 12 May 2011 16:24:28 +0530
Message-ID: <1305197668-1883-1-git-send-email-senthilkumar@atheros.com> (sfid-20110512_125450_901323_04B98017)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

XB113 (AR9380) 3x3 SB 5G only cards were failing to connect to APs
due to incorrect xpabiaslevel configuration. fix it.

Cc: stable@kernel.org
Cc: Ray Li <ray.li@greenwavereality.com>
Cc: Kathy Giori <kathy.giori@atheros.com>
Cc: Aeolus Yang <aeolus.yang@atheros.com>
Cc: compat@orbit-lab.org
Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
index 8b2125a..d76a1bd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_eeprom.c
@@ -922,7 +922,7 @@ static const struct ar9300_eeprom ar9300_x113 = {
 		.db_stage2 = {3, 3, 3}, /* 3 chain */
 		.db_stage3 = {3, 3, 3}, /* doesn't exist for 2G */
 		.db_stage4 = {3, 3, 3},	 /* don't exist for 2G */
-		.xpaBiasLvl = 0,
+		.xpaBiasLvl = 0xf,
 		.txFrameToDataStart = 0x0e,
 		.txFrameToPaOn = 0x0e,
 		.txClip = 3, /* 4 bits tx_clip, 4 bits dac_scale_cck */
-- 
1.7.0.4

