Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:59702 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753764AbZGRWMP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jul 2009 18:12:15 -0400
Subject: [PATCH] ath5k: fix values for bus error bits in ISR2
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
From: Pavel Roskin <proski@gnu.org>
Date: Sat, 18 Jul 2009 18:12:12 -0400
Message-ID: <20090718221212.10818.52921.stgit@mj.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new values are taken from the recently open sourced Atheros HAL.
Correctness is also confirmed by the users with access to Atheros
documentation.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---
 drivers/net/wireless/ath/ath5k/reg.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reg.h b/drivers/net/wireless/ath/ath5k/reg.h
index 6809b54..9ebe188 100644
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
