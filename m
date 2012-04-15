Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:44681 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752366Ab2DOKPw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Apr 2012 06:15:52 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 6/9] ath9k_hw: increase ACK timeout for half/quarter channels
Date: Sun, 15 Apr 2012 12:15:38 +0200
Message-Id: <1334484941-27673-6-git-send-email-nbd@openwrt.org> (sfid-20120415_121608_860838_CDBCDE91)
In-Reply-To: <1334484941-27673-5-git-send-email-nbd@openwrt.org>
References: <1334484941-27673-1-git-send-email-nbd@openwrt.org>
 <1334484941-27673-2-git-send-email-nbd@openwrt.org>
 <1334484941-27673-3-git-send-email-nbd@openwrt.org>
 <1334484941-27673-4-git-send-email-nbd@openwrt.org>
 <1334484941-27673-5-git-send-email-nbd@openwrt.org>
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
index 5df42ab..bb7e097 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -987,7 +987,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &common->hw->conf;
 	const struct ath9k_channel *chan = ah->curchan;
-	int acktimeout, ctstimeout;
+	int acktimeout, ctstimeout, ack_offset = 0;
 	int slottime;
 	int sifstime;
 	int rx_lat = 0, tx_lat = 0, eifs = 0;
@@ -1015,6 +1015,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 11;
 
+		ack_offset = 16;
 		slottime = 13;
 	} else if (IS_CHAN_QUARTER_RATE(chan)) {
 		eifs = 340;
@@ -1023,6 +1024,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		if (IS_CHAN_A_FAST_CLOCK(ah, chan))
 		    tx_lat += 22;
 
+		ack_offset = 32;
 		slottime = 21;
 	} else {
 		if (AR_SREV_9287(ah) && AR_SREV_9287_13_OR_LATER(ah)) {
@@ -1045,7 +1047,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 		sifstime = 10;
 
 	/* As defined by IEEE 802.11-2007 17.3.8.6 */
-	acktimeout = slottime + sifstime + 3 * ah->coverage_class;
+	acktimeout = slottime + sifstime + 3 * ah->coverage_class + ack_offset;
 	ctstimeout = acktimeout;
 
 	/*
@@ -1055,7 +1057,8 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
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

