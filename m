Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:55003 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757033Ab0DODa5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:57 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH v2 86/97] ath9k_hw: set cwmin and cwmax to 0 for for AR9003 upon txq reset
Date: Wed, 14 Apr 2010 23:30:40 -0400
Message-Id: <1271302251-9075-87-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/mac.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index c623e73..9ad1bfc 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -978,6 +978,12 @@ bool ath9k_hw_resettxqueue(struct ath_hw *ah, u32 q)
 			     AR_D_MISC_ARB_LOCKOUT_CNTRL_S)
 			  | AR_D_MISC_BEACON_USE
 			  | AR_D_MISC_POST_FR_BKOFF_DIS);
+		/* cwmin and cwmax should be 0 for beacon queue */
+		if (AR_SREV_9300_20_OR_LATER(ah)) {
+			REG_WRITE(ah, AR_DLCL_IFS(q), SM(0, AR_D_LCL_IFS_CWMIN)
+				  | SM(0, AR_D_LCL_IFS_CWMAX)
+				  | SM(qi->tqi_aifs, AR_D_LCL_IFS_AIFS));
+		}
 		break;
 	case ATH9K_TX_QUEUE_CAB:
 		REG_WRITE(ah, AR_QMISC(q), REG_READ(ah, AR_QMISC(q))
-- 
1.6.3.3

