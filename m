Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:15985 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752050AbZGTMAb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 08:00:31 -0400
Subject: [PATCH v2] ath5k: fix values for bus error bits in ISR2
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org
Content-Type: text/plain
Date: Mon, 20 Jul 2009 08:00:30 -0400
Message-Id: <1248091230.13859.9.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new values are taken from the recently open sourced Atheros HAL.
Correctness is also confirmed by the users with access to Atheros
documentation.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
Now with the masks.  Pointed out by Brett Wright <Brett.Wright@elprotech.com>

 drivers/net/wireless/ath/ath5k/reg.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 6809b54..debad07 100644
--- a/drivers/net/wireless/ath/ath5k/reg.h
+++ b/drivers/net/wireless/ath/ath5k/reg.h
@@ -339,9 +339,9 @@
 #define AR5K_SISR2		0x008c			/* Register Address [5211+] */
 #define AR5K_SISR2_QCU_TXURN	0x000003ff	/* Mask for QCU_TXURN */
 #define	AR5K_SISR2_QCU_TXURN_S	0
-#define	AR5K_SISR2_MCABT	0x00100000	/* Master Cycle Abort */
-#define	AR5K_SISR2_SSERR	0x00200000	/* Signaled System Error */
-#define	AR5K_SISR2_DPERR	0x00400000	/* Bus parity error */
+#define	AR5K_SISR2_MCABT	0x00010000	/* Master Cycle Abort */
+#define	AR5K_SISR2_SSERR	0x00020000	/* Signaled System Error */
+#define	AR5K_SISR2_DPERR	0x00040000	/* Bus parity error */
 #define	AR5K_SISR2_TIM		0x01000000	/* [5212+] */
 #define	AR5K_SISR2_CAB_END	0x02000000	/* [5212+] */
 #define	AR5K_SISR2_DTIM_SYNC	0x04000000	/* DTIM sync lost [5212+] */
@@ -430,9 +430,9 @@
 #define AR5K_SIMR2		0x00ac			/* Register Address [5211+] */
 #define AR5K_SIMR2_QCU_TXURN	0x000003ff	/* Mask for QCU_TXURN */
 #define AR5K_SIMR2_QCU_TXURN_S	0
-#define	AR5K_SIMR2_MCABT	0x00100000	/* Master Cycle Abort */
-#define	AR5K_SIMR2_SSERR	0x00200000	/* Signaled System Error */
-#define	AR5K_SIMR2_DPERR	0x00400000	/* Bus parity error */
+#define	AR5K_SIMR2_MCABT	0x00010000	/* Master Cycle Abort */
+#define	AR5K_SIMR2_SSERR	0x00020000	/* Signaled System Error */
+#define	AR5K_SIMR2_DPERR	0x00040000	/* Bus parity error */
 #define	AR5K_SIMR2_TIM		0x01000000	/* [5212+] */
 #define	AR5K_SIMR2_CAB_END	0x02000000	/* [5212+] */
 #define	AR5K_SIMR2_DTIM_SYNC	0x04000000	/* DTIM Sync lost [5212+] */

-- 
Regards,
Pavel Roskin
