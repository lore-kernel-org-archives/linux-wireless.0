Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:35868 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab1GIENS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2011 00:13:18 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 9/9] ath9k_hw: add a missing delay for an analog register
Date: Sat,  9 Jul 2011 11:12:54 +0700
Message-Id: <1310184774-32913-9-git-send-email-nbd@openwrt.org> (sfid-20110709_061324_999523_5A84E0F5)
In-Reply-To: <1310184774-32913-8-git-send-email-nbd@openwrt.org>
References: <1310184774-32913-1-git-send-email-nbd@openwrt.org>
 <1310184774-32913-2-git-send-email-nbd@openwrt.org>
 <1310184774-32913-3-git-send-email-nbd@openwrt.org>
 <1310184774-32913-4-git-send-email-nbd@openwrt.org>
 <1310184774-32913-5-git-send-email-nbd@openwrt.org>
 <1310184774-32913-6-git-send-email-nbd@openwrt.org>
 <1310184774-32913-7-git-send-email-nbd@openwrt.org>
 <1310184774-32913-8-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR_AN_SYNTH9 is in the analog shift register range and thus needs to be
written using the ath9k_hw_analog_shift_rmw function.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9002_phy.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9002_phy.c b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
index ac8b35c..3cbbb03 100644
--- a/drivers/net/wireless/ath/ath9k/ar9002_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9002_phy.c
@@ -131,8 +131,9 @@ static int ar9002_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 			channelSel = CHANSEL_5G(freq);
 
 			/* RefDivA setting */
-			REG_RMW_FIELD(ah, AR_AN_SYNTH9,
-				      AR_AN_SYNTH9_REFDIVA, refDivA);
+			ath9k_hw_analog_shift_rmw(ah, AR_AN_SYNTH9,
+				      AR_AN_SYNTH9_REFDIVA,
+				      AR_AN_SYNTH9_REFDIVA_S, refDivA);
 
 		}
 
-- 
1.7.3.2

