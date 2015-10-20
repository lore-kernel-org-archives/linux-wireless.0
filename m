Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.com ([46.140.151.2]:34956 "EHLO mail.neratec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbbJTMTd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2015 08:19:33 -0400
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
To: linux-wireless@vger.kernel.org
Cc: kvalo@qca.qualcomm.com, ath9k-devel@lists.ath9k.org,
	adrian@freebsd.org
Subject: [PATCH] ath9k: fix phyerror codes
Date: Tue, 20 Oct 2015 14:19:26 +0200
Message-Id: <1445343566-24776-1-git-send-email-zefir.kurtisi@neratec.com> (sfid-20151020_141937_071609_91AE18AF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some of the ath9k_phyerr enums were wrong from the
beginning (and even before). Most of the time the
codes were used for counters to be displayed over
debugfs, which made this a non-functional issue.

Some (e.g. ATH9K_PHYERR_FALSE_RADAR_EXT) are used
for radar detection and require the correct code
to work as intended.

This patch includes:
a) fixes
  ATH9K_PHYERR_FALSE_RADAR_EXT:    24 => 36
  ATH9K_PHYERR_CCK_LENGTH_ILLEGAL: 32 => 28
  ATH9K_PHYERR_CCK_POWER_DROP:     33 => 29
  ATH9K_PHYERR_HT_CRC_ERROR:       34 => 32
  ATH9K_PHYERR_HT_LENGTH_ILLEGAL:  35 => 33
  ATH9K_PHYERR_HT_RATE_ILLEGAL:    36 => 34

b) extensions
  ATH9K_PHYERR_CCK_BLOCKER = 24
  ATH9K_PHYERR_HT_ZLF      = 35
  ATH9K_PHYERR_GREEN_FIELD = 37

Aside from the correction and completion made in
the enum, the patch also extends the display of
the related counters in the debugfs.

Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/common-debug.c | 14 +++++++++++---
 drivers/net/wireless/ath/ath9k/mac.h          | 18 +++++++++++-------
 2 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/common-debug.c b/drivers/net/wireless/ath/ath9k/common-debug.c
index 3b289f9..84afcf7 100644
--- a/drivers/net/wireless/ath/ath9k/common-debug.c
+++ b/drivers/net/wireless/ath/ath9k/common-debug.c
@@ -207,6 +207,7 @@ static ssize_t read_file_phy_err(struct file *file, char __user *user_buf,
 	PHY_ERR("RADAR ERR", ATH9K_PHYERR_RADAR);
 	PHY_ERR("SERVICE ERR", ATH9K_PHYERR_SERVICE);
 	PHY_ERR("TOR ERR", ATH9K_PHYERR_TOR);
+
 	PHY_ERR("OFDM-TIMING ERR", ATH9K_PHYERR_OFDM_TIMING);
 	PHY_ERR("OFDM-SIGNAL-PARITY ERR", ATH9K_PHYERR_OFDM_SIGNAL_PARITY);
 	PHY_ERR("OFDM-RATE ERR", ATH9K_PHYERR_OFDM_RATE_ILLEGAL);
@@ -214,17 +215,24 @@ static ssize_t read_file_phy_err(struct file *file, char __user *user_buf,
 	PHY_ERR("OFDM-POWER-DROP ERR", ATH9K_PHYERR_OFDM_POWER_DROP);
 	PHY_ERR("OFDM-SERVICE ERR", ATH9K_PHYERR_OFDM_SERVICE);
 	PHY_ERR("OFDM-RESTART ERR", ATH9K_PHYERR_OFDM_RESTART);
-	PHY_ERR("FALSE-RADAR-EXT ERR", ATH9K_PHYERR_FALSE_RADAR_EXT);
+
+	PHY_ERR("CCK-BLOCKER ERR", ATH9K_PHYERR_CCK_BLOCKER);
 	PHY_ERR("CCK-TIMING ERR", ATH9K_PHYERR_CCK_TIMING);
 	PHY_ERR("CCK-HEADER-CRC ERR", ATH9K_PHYERR_CCK_HEADER_CRC);
 	PHY_ERR("CCK-RATE ERR", ATH9K_PHYERR_CCK_RATE_ILLEGAL);
-	PHY_ERR("CCK-SERVICE ERR", ATH9K_PHYERR_CCK_SERVICE);
-	PHY_ERR("CCK-RESTART ERR", ATH9K_PHYERR_CCK_RESTART);
 	PHY_ERR("CCK-LENGTH ERR", ATH9K_PHYERR_CCK_LENGTH_ILLEGAL);
 	PHY_ERR("CCK-POWER-DROP ERR", ATH9K_PHYERR_CCK_POWER_DROP);
+	PHY_ERR("CCK-SERVICE ERR", ATH9K_PHYERR_CCK_SERVICE);
+	PHY_ERR("CCK-RESTART ERR", ATH9K_PHYERR_CCK_RESTART);
+
 	PHY_ERR("HT-CRC ERR", ATH9K_PHYERR_HT_CRC_ERROR);
 	PHY_ERR("HT-LENGTH ERR", ATH9K_PHYERR_HT_LENGTH_ILLEGAL);
 	PHY_ERR("HT-RATE ERR", ATH9K_PHYERR_HT_RATE_ILLEGAL);
+	PHY_ERR("HT-ZLF ERR", ATH9K_PHYERR_HT_ZLF);
+
+	PHY_ERR("FALSE-RADAR-EXT ERR", ATH9K_PHYERR_FALSE_RADAR_EXT);
+	PHY_ERR("GREEN-FIELD ERR", ATH9K_PHYERR_GREEN_FIELD);
+	PHY_ERR("SPECTRAL ERR", ATH9K_PHYERR_SPECTRAL);
 
 	if (len > size)
 		len = size;
diff --git a/drivers/net/wireless/ath/ath9k/mac.h b/drivers/net/wireless/ath/ath9k/mac.h
index e55fa11..7fbf7f9 100644
--- a/drivers/net/wireless/ath/ath9k/mac.h
+++ b/drivers/net/wireless/ath/ath9k/mac.h
@@ -209,21 +209,25 @@ enum ath9k_phyerr {
 	ATH9K_PHYERR_OFDM_POWER_DROP      = 21,
 	ATH9K_PHYERR_OFDM_SERVICE         = 22,
 	ATH9K_PHYERR_OFDM_RESTART         = 23,
-	ATH9K_PHYERR_FALSE_RADAR_EXT      = 24,
 
+	ATH9K_PHYERR_CCK_BLOCKER          = 24,
 	ATH9K_PHYERR_CCK_TIMING           = 25,
 	ATH9K_PHYERR_CCK_HEADER_CRC       = 26,
 	ATH9K_PHYERR_CCK_RATE_ILLEGAL     = 27,
+	ATH9K_PHYERR_CCK_LENGTH_ILLEGAL   = 28,
+	ATH9K_PHYERR_CCK_POWER_DROP       = 29,
 	ATH9K_PHYERR_CCK_SERVICE          = 30,
 	ATH9K_PHYERR_CCK_RESTART          = 31,
-	ATH9K_PHYERR_CCK_LENGTH_ILLEGAL   = 32,
-	ATH9K_PHYERR_CCK_POWER_DROP       = 33,
 
-	ATH9K_PHYERR_HT_CRC_ERROR         = 34,
-	ATH9K_PHYERR_HT_LENGTH_ILLEGAL    = 35,
-	ATH9K_PHYERR_HT_RATE_ILLEGAL      = 36,
+	ATH9K_PHYERR_HT_CRC_ERROR         = 32,
+	ATH9K_PHYERR_HT_LENGTH_ILLEGAL    = 33,
+	ATH9K_PHYERR_HT_RATE_ILLEGAL      = 34,
+	ATH9K_PHYERR_HT_ZLF               = 35,
+
+	ATH9K_PHYERR_FALSE_RADAR_EXT      = 36,
+	ATH9K_PHYERR_GREEN_FIELD          = 37,
+	ATH9K_PHYERR_SPECTRAL             = 38,
 
-	ATH9K_PHYERR_SPECTRAL		  = 38,
 	ATH9K_PHYERR_MAX                  = 39,
 };
 
-- 
2.5.0

