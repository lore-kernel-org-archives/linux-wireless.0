Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:46301 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab3KRTO5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Nov 2013 14:14:57 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 2/2] ath9k_hw: allow fast channel change when only CHANNEL_HT changes
Date: Mon, 18 Nov 2013 20:14:44 +0100
Message-Id: <1384802084-55082-2-git-send-email-nbd@openwrt.org> (sfid-20131118_201504_653725_7278D412)
In-Reply-To: <1384802084-55082-1-git-send-email-nbd@openwrt.org>
References: <1384802084-55082-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CHANNEL_HT flag is insignificant for fast channel change conditions,
since it does not affect any important part of the hardware reset /
channel setup.
Scanning usually runs with HT disabled, so this change will slightly
improve scan time on many chipsets.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 4046da5..94652e5 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1503,8 +1503,9 @@ static bool ath9k_hw_channel_change(struct ath_hw *ah,
 	int r;
 
 	if (pCap->hw_caps & ATH9K_HW_CAP_FCC_BAND_SWITCH) {
-		band_switch = IS_CHAN_5GHZ(ah->curchan) != IS_CHAN_5GHZ(chan);
-		mode_diff = (chan->channelFlags != ah->curchan->channelFlags);
+		u32 flags_diff = chan->channelFlags ^ ah->curchan->channelFlags;
+		band_switch = !!(flags_diff & CHANNEL_5GHZ);
+		mode_diff = !!(flags_diff & ~CHANNEL_HT);
 	}
 
 	for (qnum = 0; qnum < AR_NUM_QCU; qnum++) {
@@ -1816,7 +1817,7 @@ static int ath9k_hw_do_fastcc(struct ath_hw *ah, struct ath9k_channel *chan)
 	 * If cross-band fcc is not supoprted, bail out if channelFlags differ.
 	 */
 	if (!(pCap->hw_caps & ATH9K_HW_CAP_FCC_BAND_SWITCH) &&
-	    chan->channelFlags != ah->curchan->channelFlags)
+	    ((chan->channelFlags ^ ah->curchan->channelFlags) & ~CHANNEL_HT))
 		goto fail;
 
 	if (!ath9k_hw_check_alive(ah))
-- 
1.8.3.4 (Apple Git-47)

