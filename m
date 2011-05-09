Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:51781 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752924Ab1EINlw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2011 09:41:52 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 09 May 2011 06:41:24 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 4/4] ath9k: Failed to set default beacon rssi in AP/IBSS mode
Date: Mon, 9 May 2011 19:11:29 +0530
Message-ID: <1304948489-14585-4-git-send-email-rmanoharan@atheros.com> (sfid-20110509_154154_925976_C428EC62)
In-Reply-To: <1304948489-14585-1-git-send-email-rmanoharan@atheros.com>
References: <1304948489-14585-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This beacon rssi will be used to set noisefloor during ani reset.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 11d9eca..c4d32c5 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1409,6 +1409,7 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 
 	/* Set up ANI */
 	if ((iter_data.naps + iter_data.nadhocs) > 0) {
+		sc->sc_ah->stats.avgbrssi = ATH_RSSI_DUMMY_MARKER;
 		sc->sc_flags |= SC_OP_ANI_RUN;
 		ath_start_ani(common);
 	} else {
-- 
1.7.5.1

