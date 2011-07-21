Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24939 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753427Ab1GURgo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2011 13:36:44 -0400
Subject: [PATCH 3/3] ath5k: use get_unaligned_le32() in
 ath5k_write_pwr_to_pdadc_table()
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Thu, 21 Jul 2011 13:36:42 -0400
Message-ID: <20110721173642.30989.45021.stgit@mj.roinet.com> (sfid-20110721_193657_723031_A1318774)
In-Reply-To: <20110721173628.30989.19587.stgit@mj.roinet.com>
References: <20110721173628.30989.19587.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/phy.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index a0c66cf..81e465e 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -22,6 +22,7 @@
 
 #include <linux/delay.h>
 #include <linux/slab.h>
+#include <asm/unaligned.h>
 
 #include "ath5k.h"
 #include "reg.h"
@@ -2794,12 +2795,8 @@ ath5k_write_pwr_to_pdadc_table(struct ath5k_hw *ah, u8 ee_mode)
 	 * Write TX power values
 	 */
 	for (i = 0; i < (AR5K_EEPROM_POWER_TABLE_SIZE / 2); i++) {
-		ath5k_hw_reg_write(ah,
-			((pdadc_out[4 * i + 0] & 0xff) << 0) |
-			((pdadc_out[4 * i + 1] & 0xff) << 8) |
-			((pdadc_out[4 * i + 2] & 0xff) << 16) |
-			((pdadc_out[4 * i + 3] & 0xff) << 24),
-			AR5K_PHY_PDADC_TXPOWER(i));
+		u32 val = get_unaligned_le32(&pdadc_out[4 * i]);
+		ath5k_hw_reg_write(ah, val, AR5K_PHY_PDADC_TXPOWER(i));
 	}
 }
 
