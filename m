Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:26451 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753947Ab1C1U5m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Mar 2011 16:57:42 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 28 Mar 2011 13:57:17 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <greg@kroah.com>
CC: <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>, <stable@kernel.org>,
	Jack Lee <jack.lee@atheros.com>,
	Carl Huang <carl.huang@atheros.com>,
	David Quan <david.quan@atheros.com>,
	Nael Atallah <nael.atallah@atheros.com>,
	Sarvesh Shrivastava <sarvesh.shrivastava@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH 6/9] ath9k_hw: ASPM interoperability fix for AR9380/AR9382
Date: Mon, 28 Mar 2011 13:57:12 -0700
Message-ID: <1301345835-11401-7-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
References: <1301345835-11401-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit 58c5296991d233f2e492aa7a884635bba478cf12 upstream

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
Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 .../net/wireless/ath/ath9k/ar9003_2p2_initvals.h   |    2 +-
 drivers/net/wireless/ath/ath9k/ar9003_hw.c         |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h b/drivers/net/wireless/ath/ath9k/ar9003_2p2_initvals.h
index a14a5e4..c655cd2 100644
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
index c2a0571..cd8e0bd 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_hw.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_hw.c
@@ -95,8 +95,8 @@ static void ar9003_hw_init_mode_regs(struct ath_hw *ah)
 	/* Sleep Setting */
 
 	INIT_INI_ARRAY(&ah->iniPcieSerdesLowPower,
-		       ar9300PciePhy_clkreq_enable_L1_2p2,
-		       ARRAY_SIZE(ar9300PciePhy_clkreq_enable_L1_2p2),
+		       ar9300PciePhy_pll_on_clkreq_disable_L1_2p2,
+		       ARRAY_SIZE(ar9300PciePhy_pll_on_clkreq_disable_L1_2p2),
 		       2);
 
 	/* Fast clock modal settings */
-- 
1.7.4.15.g7811d

