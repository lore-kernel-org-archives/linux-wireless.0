Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35855 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab1GIENQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 00:13:16 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 7/9] ath9k_hw: set 5 GHz half/quarter channels on AR9002 using fractional mode
Date: Sat,  9 Jul 2011 11:12:52 +0700
Message-Id: <1310184774-32913-7-git-send-email-nbd@openwrt.org> (sfid-20110709_061322_070181_9CACCDB0)
In-Reply-To: <1310184774-32913-6-git-send-email-nbd@openwrt.org>
References: <1310184774-32913-1-git-send-email-nbd@openwrt.org>
 <1310184774-32913-2-git-send-email-nbd@openwrt.org>
 <1310184774-32913-3-git-send-email-nbd@openwrt.org>
 <1310184774-32913-4-git-send-email-nbd@openwrt.org>
 <1310184774-32913-5-git-send-email-nbd@openwrt.org>
 <1310184774-32913-6-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The radio seems to perform better that way

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index abc2cc8..ac8b35c 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -111,7 +111,9 @@ static int ar9002_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 
 		switch (ah->eep_ops->get_eeprom(ah, EEP_FRAC_N_5G)) {
 		case 0:
-			if ((freq % 20) == 0)
+			if (IS_CHAN_HALF_RATE(chan) || IS_CHAN_QUARTER_RATE(chan))
+				aModeRefSel = 0;
+			else if ((freq % 20) == 0)
 				aModeRefSel = 3;
 			else if ((freq % 10) == 0)
 				aModeRefSel = 2;
-- 
1.7.3.2

