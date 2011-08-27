Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:36901 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751054Ab1H0XwU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 27 Aug 2011 19:52:20 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, rmanohar@qca.qualcomm.com,
	mcgrof@qca.qualcomm.com
Subject: [PATCH] ath9k_hw: do not apply the 2.4 ghz ack timeout workaround to cts
Date: Sun, 28 Aug 2011 01:52:10 +0200
Message-Id: <1314489130-18003-1-git-send-email-nbd@openwrt.org> (sfid-20110828_015228_139523_A2670BE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It is only used to workaround interoperability issues related to longer
delays in receiving the block ack, so it is not necessary to apply it
to the CTS exchange.
Should improve throughput slightly, especially when there are lots
of retransmissions.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a0d1147..3ccadeb 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -960,7 +960,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &common->hw->conf;
 	const struct ath9k_channel *chan = ah->curchan;
-	int acktimeout;
+	int acktimeout, ctstimeout;
 	int slottime;
 	int sifstime;
 	int rx_lat = 0, tx_lat = 0, eifs = 0;
@@ -1011,6 +1011,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 
 	/* As defined by IEEE 802.11-2007 17.3.8.6 */
 	acktimeout = slottime + sifstime + 3 * ah->coverage_class;
+	ctstimeout = acktimeout;
 
 	/*
 	 * Workaround for early ACK timeouts, add an offset to match the
@@ -1025,7 +1026,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	ath9k_hw_set_sifs_time(ah, sifstime);
 	ath9k_hw_setslottime(ah, slottime);
 	ath9k_hw_set_ack_timeout(ah, acktimeout);
-	ath9k_hw_set_cts_timeout(ah, acktimeout);
+	ath9k_hw_set_cts_timeout(ah, ctstimeout);
 	if (ah->globaltxtimeout != (u32) -1)
 		ath9k_hw_set_global_txtimeout(ah, ah->globaltxtimeout);
 
-- 
1.7.3.2

