Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:50800 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab0LLNem (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Dec 2010 08:34:42 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH 2/7] ath9k_hw: fix the slot time setting for long distance links
Date: Sun, 12 Dec 2010 14:34:32 +0100
Message-Id: <1292160877-50618-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1292160877-50618-1-git-send-email-nbd@openwrt.org>
References: <1292160877-50618-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Testing shows that adjusting the slot time based on the coverage class
produces very high latencies and very low throughput on long distance links.

Adjusting only the ACK timeout and leaving the slot time at the regular
values - while technically not optimal for CSMA - works a lot better on
long links (tested with 10 km distance)

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/hw.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 856a76e..3c8db81 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -808,7 +808,7 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ)
 		acktimeout += 64 - sifstime - ah->slottime;
 
-	ath9k_hw_setslottime(ah, slottime);
+	ath9k_hw_setslottime(ah, ah->slottime);
 	ath9k_hw_set_ack_timeout(ah, acktimeout);
 	ath9k_hw_set_cts_timeout(ah, acktimeout);
 	if (ah->globaltxtimeout != (u32) -1)
-- 
1.7.3.2

