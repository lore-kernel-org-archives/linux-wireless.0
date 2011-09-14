Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47796 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab1INIty (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Sep 2011 04:49:54 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH v2] ath9k_hw: Do full chip reset on 11A channels for AR9003
Date: Wed, 14 Sep 2011 14:20:30 +0530
Message-ID: <1315990230-2921-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110914_104958_426006_284A2201)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003 seems to have issues sometimes with fast channel change
in 5GHz and this case is handled specifically for AR9280 by doing
a full reset. Let's do a full reset for 5GHz channles of AR9380
& for all channels of AR9280 pci chips.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 47d10a4..ae5adf2 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1499,14 +1499,16 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	}
 	ah->noise = ath9k_hw_getchan_noise(ah, chan);
 
+	if ((AR_SREV_9280(ah) && common->bus_ops->ath_bus_type == ATH_PCI) ||
+	    (AR_SREV_9300_20_OR_LATER(ah) && IS_CHAN_5GHZ(chan)))
+		bChannelChange = false;
+
 	if (bChannelChange &&
 	    (ah->chip_fullsleep != true) &&
 	    (ah->curchan != NULL) &&
 	    (chan->channel != ah->curchan->channel) &&
 	    ((chan->channelFlags & CHANNEL_ALL) ==
-	     (ah->curchan->channelFlags & CHANNEL_ALL)) &&
-	    (!AR_SREV_9280(ah) || AR_DEVID_7010(ah))) {
-
+	     (ah->curchan->channelFlags & CHANNEL_ALL))) {
 		if (ath9k_hw_channel_change(ah, chan)) {
 			ath9k_hw_loadnf(ah, ah->curchan);
 			ath9k_hw_start_nfcal(ah, true);
-- 
1.7.6.1

