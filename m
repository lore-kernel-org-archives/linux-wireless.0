Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:35461 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088AbZCOUNQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Mar 2009 16:13:16 -0400
Date: Sun, 15 Mar 2009 22:13:39 +0200
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Cc: jirislaby@gmail.com, mcgrof@gmail.com, me@bobcopeland.com,
	nbd@openwrt.org
Subject: [PATCH 1/3] ath5k: Choose the right initvals for RF2425
Message-ID: <20090315201339.GA5246@makis> (sfid-20090315_211322_462576_03F45B80)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Fix a typo in initvals.c so that we use the RF2425 array for RF2425 and not RF2413

 Note: This also fixes incorect pd gain overlap since RF2425 has different pd gain overlap from RF2413

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
 drivers/net/wireless/ath5k/initvals.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/initvals.c b/drivers/net/wireless/ath5k/initvals.c
index 4488643..61fb621 100644
--- a/drivers/net/wireless/ath5k/initvals.c
+++ b/drivers/net/wireless/ath5k/initvals.c
@@ -1510,8 +1510,8 @@ int ath5k_hw_write_initvals(struct ath5k_hw *ah, u8 mode, bool change_channel)
 					rf2425_ini_mode_end, mode);
 
 			ath5k_hw_ini_registers(ah,
-					ARRAY_SIZE(rf2413_ini_common_end),
-					rf2413_ini_common_end, change_channel);
+					ARRAY_SIZE(rf2425_ini_common_end),
+					rf2425_ini_common_end, change_channel);
 
 			ath5k_hw_ini_registers(ah,
 					ARRAY_SIZE(rf5112_ini_bbgain),
