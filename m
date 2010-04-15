Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:54956 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756981Ab0DODa4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Apr 2010 23:30:56 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH v2 74/97] ath9k_hw: Configure Tx interrupt mitigation timer
Date: Wed, 14 Apr 2010 23:30:28 -0400
Message-Id: <1271302251-9075-75-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
References: <1271302251-9075-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index eeecc72..9e4288a 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1287,6 +1287,11 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		REG_RMW_FIELD(ah, AR_RIMT, AR_RIMT_FIRST, 2000);
 	}
 
+	if (ah->config.tx_intr_mitigation) {
+		REG_RMW_FIELD(ah, AR_TIMT, AR_TIMT_LAST, 300);
+		REG_RMW_FIELD(ah, AR_TIMT, AR_TIMT_FIRST, 750);
+	}
+
 	ath9k_hw_init_bb(ah, chan);
 
 	if (!ath9k_hw_init_cal(ah, chan))
-- 
1.6.3.3

