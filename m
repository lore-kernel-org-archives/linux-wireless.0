Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25960 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753642AbZA0IYk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2009 03:24:40 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2009 00:24:40 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18814.50159.933773.566773@gargle.gargle.HOWL> (sfid-20090127_092455_113597_0C7E4467)
Date: Tue, 27 Jan 2009 13:51:03 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH] ath9k: Setup short preamble properly in rate registration
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes an issue where hw_value_short was not being filled
with the proper ratecode during rate registration, but was being used
in the RX path for decoding the packet rate.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index e659c36..6d5394c 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -217,7 +217,13 @@ static void ath_setup_rates(struct ath_softc *sc, enum ieee80211_band band)
 	for (i = 0; i < maxrates; i++) {
 		rate[i].bitrate = rate_table->info[i].ratekbps / 100;
 		rate[i].hw_value = rate_table->info[i].ratecode;
+		if (rate_table->info[i].short_preamble) {
+			rate[i].hw_value_short = rate_table->info[i].ratecode |
+				rate_table->info[i].short_preamble;
+			rate[i].flags = IEEE80211_RATE_SHORT_PREAMBLE;
+		}
 		sband->n_bitrates++;
+
 		DPRINTF(sc, ATH_DBG_CONFIG, "Rate: %2dMbps, ratecode: %2d\n",
 			rate[i].bitrate / 10, rate[i].hw_value);
 	}
-- 
1.6.1

