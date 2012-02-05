Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:39730 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab2BEUPg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 5 Feb 2012 15:15:36 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mcgrof@qca.qualcomm.com,
	mohammed@qca.qualcomm.com
Subject: [PATCH 3.3 2/2] ath9k_hw: fix a RTS/CTS timeout regression
Date: Sun,  5 Feb 2012 21:15:18 +0100
Message-Id: <1328472918-30012-2-git-send-email-nbd@openwrt.org> (sfid-20120205_211548_004487_4EA38ED2)
In-Reply-To: <1328472918-30012-1-git-send-email-nbd@openwrt.org>
References: <1328472918-30012-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

commit adb5066 "ath9k_hw: do not apply the 2.4 ghz ack timeout
workaround to cts" reduced the hardware CTS timeout to the normal
values specified by the standard, but it turns out while it doesn't
need the same extra time that it needs for the ACK timeout, it
does need more than the value specified in the standard, but only
for 2.4 GHz.

This patch brings the CTS timeout value in sync with the initialization
values, while still allowing adjustment for bigger distances.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Cc: stable@vger.kernel.org
Reported-by: Seth Forshee <seth.forshee@canonical.com>
Reported-by: Marek Lindner <lindner_marek@yahoo.de>
---
 drivers/net/wireless/ath/ath9k/hw.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index ee77595..87db1ee 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1037,13 +1037,16 @@ void ath9k_hw_init_global_settings(struct ath_hw *ah)
 
 	/*
 	 * Workaround for early ACK timeouts, add an offset to match the
-	 * initval's 64us ack timeout value.
+	 * initval's 64us ack timeout value. Use 48us for the CTS timeout.
 	 * This was initially only meant to work around an issue with delayed
 	 * BA frames in some implementations, but it has been found to fix ACK
 	 * timeout issues in other cases as well.
 	 */
-	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ)
+	if (conf->channel && conf->channel->band == IEEE80211_BAND_2GHZ) {
 		acktimeout += 64 - sifstime - ah->slottime;
+		ctstimeout += 48 - sifstime - ah->slottime;
+	}
+
 
 	ath9k_hw_set_sifs_time(ah, sifstime);
 	ath9k_hw_setslottime(ah, slottime);
-- 
1.7.3.2

