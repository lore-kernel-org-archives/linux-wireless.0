Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:39342 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab0DZTEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Apr 2010 15:04:42 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 12/13] ath9k_hw: fix noisefloor timeout handling on AR9003
Date: Mon, 26 Apr 2010 15:04:40 -0400
Message-Id: <1272308681-32396-13-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
References: <1272308681-32396-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Felix Fietkau <nbd@openwrt.org>

When the noisefloor calibration times out, do not load -50 into
the registers, since this might cause rx issues. Instead, leave
enough time for the noise floor calibration to complete until
the next check.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 806f4a5..80431a2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -1093,6 +1093,7 @@ static void ar9003_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan)
 		ath_print(common, ATH_DBG_ANY, "Timeout while waiting for nf "
 			  "to load: AR_PHY_AGC_CONTROL=0x%x\n",
 			  REG_READ(ah, AR_PHY_AGC_CONTROL));
+		return;
 	}
 
 	/*
-- 
1.6.3.3

