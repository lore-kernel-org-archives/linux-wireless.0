Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:32210 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab1ALBqg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 20:46:36 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 11 Jan 2011 17:46:18 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Jack Lee <jack.lee@atheros.com>,
	Carl Huang <carl.huang@atheros.com>,
	David Quan <david.quan@atheros.com>,
	Nael Atallah <nael.atallah@atheros.com>,
	Sarvesh Shrivastava <sarvesh.shrivastava@atheros.com>
Subject: [PATCH] ath9k_hw: disable PLL / Clkreq for ASPM for AR9003
Date: Tue, 11 Jan 2011 17:46:31 -0800
Message-ID: <1294796791-2521-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This changes the PCIE PHY programming for better interoperability
with ASPM states. Without this AR9003 chipsets will hang when
using ASPM. This reproducible against an Apple Airport Extreme AP
by simply pinging it.

Cc: stable@kernel.org
Cc: Jack Lee <jack.lee@atheros.com>
Cc: Carl Huang <carl.huang@atheros.com>
Cc: David Quan <david.quan@atheros.com>
Cc: Nael Atallah <nael.atallah@atheros.com>
Cc: Sarvesh Shrivastava <sarvesh.shrivastava@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ar9003_hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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

