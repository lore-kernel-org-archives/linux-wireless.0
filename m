Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:55429 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756048Ab2CNPko (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Mar 2012 11:40:44 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 10/14] ath9k_hw: fix AR9380 register settings for channel 14
Date: Wed, 14 Mar 2012 16:40:30 +0100
Message-Id: <1331739634-22318-10-git-send-email-nbd@openwrt.org> (sfid-20120314_164055_241954_633F782F)
In-Reply-To: <1331739634-22318-9-git-send-email-nbd@openwrt.org>
References: <1331739634-22318-1-git-send-email-nbd@openwrt.org>
 <1331739634-22318-2-git-send-email-nbd@openwrt.org>
 <1331739634-22318-3-git-send-email-nbd@openwrt.org>
 <1331739634-22318-4-git-send-email-nbd@openwrt.org>
 <1331739634-22318-5-git-send-email-nbd@openwrt.org>
 <1331739634-22318-6-git-send-email-nbd@openwrt.org>
 <1331739634-22318-7-git-send-email-nbd@openwrt.org>
 <1331739634-22318-8-git-send-email-nbd@openwrt.org>
 <1331739634-22318-9-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Program the ah->ini_japan2484 INI values which were left out by accident

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index 70e27d2..99b64f2 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -691,6 +691,9 @@ static int ar9003_hw_process_ini(struct ath_hw *ah,
 	if (AR_SREV_9462(ah))
 		ar9003_hw_prog_ini(ah, &ah->ini_BTCOEX_MAX_TXPWR, 1);
 
+	if (chan->channel == 2484)
+		ar9003_hw_prog_ini(ah, &ah->ini_japan2484, 1);
+
 	ah->modes_index = modesIndex;
 	ar9003_hw_override_ini(ah);
 	ar9003_hw_set_channel_regs(ah, chan);
-- 
1.7.3.2

