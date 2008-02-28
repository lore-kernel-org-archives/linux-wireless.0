Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ruslug.rutgers.edu ([165.230.139.146]:46276 "EHLO
	ruslug.rutgers.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675AbYB1W5D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Feb 2008 17:57:03 -0500
Date: Thu, 28 Feb 2008 17:56:57 -0500
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: linville@tuxdriver.com
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	jirislaby@gmail.com, mickflemm@gmail.com, bruno@thinktube.com,
	me@bobcopeland.com
Subject: [PATCH 1/8] ath5k: Add RF2413 srev values
Message-ID: <f6d5bb6d43d1ddfb60d5ed8b8d6ee472643eafd8.1204236793.git.mcgrof@winlab.rutgers.edu> (sfid-20080228_225707_049029_5664C677)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Add RF2413 srev values and a new entry on ath5k_radio enum for it
  since it differs from RF5413 (it's not like 5112-2112).

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@winlab.rutgers.edu>
---
 drivers/net/wireless/ath5k/ath5k.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath5k/ath5k.h b/drivers/net/wireless/ath5k/ath5k.h
index 18223d9..25c8e98 100644
--- a/drivers/net/wireless/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath5k/ath5k.h
@@ -140,7 +140,8 @@ enum ath5k_radio {
 	AR5K_RF5110	= 0,
 	AR5K_RF5111	= 1,
 	AR5K_RF5112	= 2,
-	AR5K_RF5413	= 3,
+	AR5K_RF2413	= 3,
+	AR5K_RF5413	= 4,
 };
 
 /*
@@ -168,12 +169,15 @@ struct ath5k_srev_name {
 #define AR5K_SREV_VER_AR5212	0x50
 #define AR5K_SREV_VER_AR5213	0x55
 #define AR5K_SREV_VER_AR5213A	0x59
+#define AR5K_SREV_VER_AR2413	0x78
+#define AR5K_SREV_VER_AR2414	0x79
 #define AR5K_SREV_VER_AR2424	0xa0
 #define AR5K_SREV_VER_AR5424	0xa3
 #define AR5K_SREV_VER_AR5413	0xa4
 #define AR5K_SREV_VER_AR5414	0xa5
 #define AR5K_SREV_VER_AR5416	0xc0	/* ? */
 #define AR5K_SREV_VER_AR5418	0xca
+#define AR5K_SREV_VER_AR2425	0xe2
 
 #define AR5K_SREV_RAD_5110	0x00
 #define AR5K_SREV_RAD_5111	0x10
@@ -183,8 +187,9 @@ struct ath5k_srev_name {
 #define AR5K_SREV_RAD_5112A	0x35
 #define AR5K_SREV_RAD_2112	0x40
 #define AR5K_SREV_RAD_2112A	0x45
+#define AR5K_SREV_RAD_SC0	0x56	/* Found on 2413/2414 */
 #define AR5K_SREV_RAD_SC1	0x63	/* Found on 5413/5414 */
-#define AR5K_SREV_RAD_SC2	0xa2	/* Found on 2424/5424 */
+#define AR5K_SREV_RAD_SC2	0xa2	/* Found on 2424-5/5424 */
 #define AR5K_SREV_RAD_5133	0xc0	/* MIMO found on 5418 */
 
 /* IEEE defs */
-- 
1.5.3.7

