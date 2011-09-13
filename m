Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11944 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754984Ab1IMPSR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 11:18:17 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH] ath9k_hw: Do full chip reset on 11A channels
Date: Tue, 13 Sep 2011 20:48:52 +0530
Message-ID: <1315927132-21716-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110913_171821_102071_A0D40589)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AR9003 seems to have issues sometimes with fast channel change
in 5GHz and this case is handled specifically for AR9002 by doing
a full reset. So let's do a full reset for 5GHz channles for all
chipsets.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 308847d..622bfc9 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1504,7 +1504,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	    (chan->channel != ah->curchan->channel) &&
 	    ((chan->channelFlags & CHANNEL_ALL) ==
 	     (ah->curchan->channelFlags & CHANNEL_ALL)) &&
-	    (!AR_SREV_9280(ah) || AR_DEVID_7010(ah))) {
+	    !IS_CHAN_5GHZ(chan)) {
 
 		if (ath9k_hw_channel_change(ah, chan)) {
 			ath9k_hw_loadnf(ah, ah->curchan);
-- 
1.7.6.1

