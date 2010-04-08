Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:46963 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933287Ab0DHT1s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 15:27:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>
Subject: [PATCH 076/102] ath9k_hw: Configure Tx interrupt mitigation timer
Date: Thu,  8 Apr 2010 15:27:12 -0400
Message-Id: <1270754858-26266-77-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vasanthakumar Thiagarajan <vasanth@atheros.com>

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 98c7e6a..5dcb066 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1288,6 +1288,11 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
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

