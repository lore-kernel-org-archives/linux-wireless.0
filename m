Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:40169 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab2CCORS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Mar 2012 09:17:18 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com
Subject: [PATCH 5/5] ath9k: fix signal strength reporting issues
Date: Sat,  3 Mar 2012 15:17:06 +0100
Message-Id: <1330784226-65563-5-git-send-email-nbd@openwrt.org> (sfid-20120303_151721_780197_1C3C0F2B)
In-Reply-To: <1330784226-65563-4-git-send-email-nbd@openwrt.org>
References: <1330784226-65563-1-git-send-email-nbd@openwrt.org>
 <1330784226-65563-2-git-send-email-nbd@openwrt.org>
 <1330784226-65563-3-git-send-email-nbd@openwrt.org>
 <1330784226-65563-4-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On A-MPDU frames, the hardware only reports valid signal strength data for
the last subframe. The driver also mangled rx_stats->rs_rssi using the
ATH_EP_RND macro in a way that may make sense for ANI, but definitely
not for reporting to mac80211.
This patch changes the code to calculate the signal strength from the rssi
directly instead of taking the average value, and flag everything but
the last subframe in an A-MPDU to tell mac80211 to ignore the signal strength
entirely, fixing signal strength fluctuation issues reported by various
users.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/recv.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index cdba79f..027d232 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -953,6 +953,7 @@ static void ath9k_process_rssi(struct ath_common *common,
 	struct ath_softc *sc = hw->priv;
 	struct ath_hw *ah = common->ah;
 	int last_rssi;
+	int rssi = rx_stats->rs_rssi;
 
 	if (!rx_stats->is_mybeacon ||
 	    ((ah->opmode != NL80211_IFTYPE_STATION) &&
@@ -964,13 +965,12 @@ static void ath9k_process_rssi(struct ath_common *common,
 
 	last_rssi = sc->last_rssi;
 	if (likely(last_rssi != ATH_RSSI_DUMMY_MARKER))
-		rx_stats->rs_rssi = ATH_EP_RND(last_rssi,
-					      ATH_RSSI_EP_MULTIPLIER);
-	if (rx_stats->rs_rssi < 0)
-		rx_stats->rs_rssi = 0;
+		rssi = ATH_EP_RND(last_rssi, ATH_RSSI_EP_MULTIPLIER);
+	if (rssi < 0)
+		rssi = 0;
 
 	/* Update Beacon RSSI, this is used by ANI. */
-	ah->stats.avgbrssi = rx_stats->rs_rssi;
+	ah->stats.avgbrssi = rssi;
 }
 
 /*
@@ -1010,6 +1010,8 @@ static int ath9k_rx_skb_preprocess(struct ath_common *common,
 	rx_status->signal = ah->noise + rx_stats->rs_rssi;
 	rx_status->antenna = rx_stats->rs_antenna;
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
+	if (rx_stats->rs_moreaggr)
+		rx_status->flag |= RX_FLAG_NO_SIGNAL_VAL;
 
 	return 0;
 }
-- 
1.7.3.2

