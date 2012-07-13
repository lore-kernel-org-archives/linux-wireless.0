Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42349 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101Ab2GMX1G (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jul 2012 19:27:06 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH] ath9k_hw: fix 5 GHz frequency selection on AR934x/AR955x with 25 MHz refclock
Date: Sat, 14 Jul 2012 01:26:54 +0200
Message-Id: <1342222014-27980-1-git-send-email-nbd@openwrt.org> (sfid-20120714_012711_446282_36DAB068)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old code was an accidental copy&paste of the 2.4 GHz version,
which doesn't work.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ar9003_phy.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9003_phy.c b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
index d2346db..e476f9f 100644
--- a/drivers/net/wireless/ath/ath9k/ar9003_phy.c
+++ b/drivers/net/wireless/ath/ath9k/ar9003_phy.c
@@ -117,8 +117,8 @@ static int ar9003_hw_set_channel(struct ath_hw *ah, struct ath9k_channel *chan)
 		    ah->is_clk_25mhz) {
 			u32 chan_frac;
 
-			channelSel = (freq * 2) / 75;
-			chan_frac = (((freq * 2) % 75) * 0x20000) / 75;
+			channelSel = freq / 75;
+			chan_frac = ((freq % 75) * 0x20000) / 75;
 			channelSel = (channelSel << 17) | chan_frac;
 		} else {
 			channelSel = CHANSEL_5G(freq);
-- 
1.7.7.5 (Apple Git-26)

