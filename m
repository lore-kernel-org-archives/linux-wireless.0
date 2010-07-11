Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:46134 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab0GKKtD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Jul 2010 06:49:03 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: lrodriguez@atheros.com, linville@tuxdriver.com
Subject: [PATCH 2/7] ath9k_hw: fix a sign error in the IQ calibration code
Date: Sun, 11 Jul 2010 12:48:40 +0200
Message-Id: <1278845325-62000-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1278845325-62000-1-git-send-email-nbd@openwrt.org>
References: <1278845325-62000-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@kernel.org
---
 drivers/net/wireless/ath/ath9k/ar9002_calib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_calib.c b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
index 5fdbb53..dabafb8 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_calib.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_calib.c
@@ -239,7 +239,7 @@ static void ar9002_hw_iqcalibrate(struct ath_hw *ah, u8 numChains)
 			if (qCoff > 15)
 				qCoff = 15;
 			else if (qCoff <= -16)
-				qCoff = 16;
+				qCoff = -16;
 
 			ath_print(common, ATH_DBG_CALIBRATE,
 				  "Chn %d : iCoff = 0x%x  qCoff = 0x%x\n",
-- 
1.6.4.2

