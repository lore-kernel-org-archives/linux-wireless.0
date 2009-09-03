Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:58435 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754513AbZICG1S (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 02:27:18 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 02 Sep 2009 23:27:21 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19103.25725.707217.596352@gargle.gargle.HOWL>
Date: Thu, 3 Sep 2009 12:08:53 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: Fix channelFlags for 2GHZ
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CHANNEL_G has to be set for 2GHZ channels since
IS_CHAN_G() checks for this in channelFlags and not in
chanmode. To make things messier, ath9k_hw_process_ini()
checks for CHANNEL_G in chanmode and not in channelFlags.
The supreme, brain-searing fix is to set the
flag in both cases.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b1d189c..a69fda8 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1879,7 +1879,7 @@ void ath9k_update_ichannel(struct ath_softc *sc, struct ieee80211_hw *hw,
 
 	if (chan->band == IEEE80211_BAND_2GHZ) {
 		ichan->chanmode = CHANNEL_G;
-		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM;
+		ichan->channelFlags = CHANNEL_2GHZ | CHANNEL_OFDM | CHANNEL_G;
 	} else {
 		ichan->chanmode = CHANNEL_A;
 		ichan->channelFlags = CHANNEL_5GHZ | CHANNEL_OFDM;
-- 
1.6.4.2

