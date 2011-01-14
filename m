Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:61292 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751579Ab1ANCTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Jan 2011 21:19:33 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 13 Jan 2011 18:19:15 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Jack Lee <jack.lee@atheros.com>,
	Carl Huang <carl.huang@atheros.com>,
	David Quan <david.quan@atheros.com>,
	Nael Atallah <nael.atallah@atheros.com>,
	Sarvesh Shrivastava <sarvesh.shrivastava@atheros.com>
Subject: [PATCH v2] ath9k_hw: ASPM interoperability fix for AR9380/AR9382
Date: Thu, 13 Jan 2011 18:19:29 -0800
Message-ID: <1294971569-2272-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There is an interoperability with AR9382/AR9380 in L1 state with a
few root complexes which can cause a hang. This is fixed by
setting some work around bits on the PCIE PHY. We fix by using
a new ini array to modify these bits when the radio is idle.

Cc: stable@kernel.org
Cc: Jack Lee <jack.lee@atheros.com>
Cc: Carl Huang <carl.huang@atheros.com>
Cc: David Quan <david.quan@atheros.com>
Cc: Nael Atallah <nael.atallah@atheros.com>
Cc: Sarvesh Shrivastava <sarvesh.shrivastava@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index 81f9cf2..9ecca93 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
@@ -1842,7 +1842,7 @@ static const u32 ar9300_2p2_soc_preamble[][2] = {
 
 static const u32 ar9300PciePhy_pll_on_clkreq_disable_L1_2p2[][2] = {
 	/* Addr      allmodes  */
-	{0x00004040, 0x08212e5e},
+	{0x00004040, 0x0821265e},
 	{0x00004040, 0x0008003b},
 	{0x00004044, 0x00000000},
 };
diff --git a/drivers/net/wireless/ath/ath9k/ar9003_hw.c b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
index 6137634..06fb2c8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -146,8 +146,8 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 		/* Sleep Setting */
 
 		INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-				ar9300PciePhy_clkreq_enable_L1_2p2,
-				ARRAY_SIZE(ar9300PciePhy_clkreq_enable_L1_2p2),
+				ar9300PciePhy_pll_on_clkreq_disable_L1_2p2,
+				ARRAY_SIZE(ar9300PciePhy_pll_on_clkreq_disable_L1_2p2),
 				2);
 
 		/* Fast clock modal settings */
-- 
1.7.3.2.90.gd4c43

