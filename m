Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:48152 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754665Ab2DPVJe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 17:09:34 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH v2 2/8] ath9k_hw: increase ACK timeout for half/quarter channels
Date: Mon, 16 Apr 2012 23:09:19 +0200
Message-Id: <1334610565-37399-2-git-send-email-nbd@openwrt.org> (sfid-20120416_230937_773387_C7676A29)
In-Reply-To: <1334610565-37399-1-git-send-email-nbd@openwrt.org>
References: <1334610565-37399-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some reason the MAC timing is a bit off when waiting for ACKs, so add
some extra delay to the ACK timeout values. Significantly reduces the
number of retransmissions in my tests.
Also disable the 2.4 GHz ACK timeout workaround in half/quarter mode, it
is not required there.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 122447c..0b16e30 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -971,7 +971,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &common->hw->conf;
 	const struct ath9k_channel *chan = ah->curchan;
-	int acktimeout, ctstimeout;
+	int acktimeout, ctstimeout, ack_offset = 0;
 	int slottime;
 	int sifstime;
 	int rx_lat = 0, tx_lat = 0, eifs = 0;
@@ -1005,6 +1005,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		    tx_lat += 11;
 
 		sifstime *= 2;
+		ack_offset = 16;
 		slottime = 13;
 	} else if (IS_CHAN_QUARTER_RATE(chan)) {
 		eifs = 340;
@@ -1014,6 +1015,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		    tx_lat += 22;
 
 		sifstime *= 4;
+		ack_offset = 32;
 		slottime = 21;
 	} else {
 		if (AR_SREV_9287(ah) && AR_SREV_9287_13_OR_LATER(ah)) {
@@ -1031,7 +1033,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	}
 
 	/* As defined by IEEE 802.11-2007 17.3.8.6 */
-	acktimeout = slottime + sifstime + 3 * ah->coverage_class;
+	acktimeout = slottime + sifstime + 3 * ah->coverage_class + ack_offset;
 	ctstimeout = acktimeout;
 
 	/*
@@ -1041,7 +1043,8 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	 * BA frames in some implementations, but it has been found to fix ACK
 	 * timeout issues in other cases as well.
 	 */
-	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ) {
+	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ &&
+	    !IS_CHAN_HALF_RATE(chan) && !IS_CHAN_QUARTER_RATE(chan)) {
 		acktimeout += 64 - sifstime - ah->slottime;
 		ctstimeout += 48 - sifstime - ah->slottime;
 	}
-- 
1.7.3.2

