Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:14711 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755754Ab1AaSSy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 13:18:54 -0500
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 10:18:34 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH 5/5] ath9k: do not access hw registers in FULL SLEEP
Date: Mon, 31 Jan 2011 23:47:46 +0530
Message-ID: <1296497866-3189-5-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1296497866-3189-1-git-send-email-rmanoharan@atheros.com>
References: <1296497866-3189-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The opmode recalculation is accessing hw registers.
When it is called from remove interface callback and
if there are no vifs present then hw is moved to FULL SLEEP
by radio disable. So use power save wrappers before
accessing hw registers in calculating opmode state.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 21e8d29..d838933 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1348,6 +1348,7 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 
 	ath9k_calculate_iter_data(hw, vif, &iter_data);
 
+	ath9k_ps_wakeup(sc);
 	/* Set BSSID mask. */
 	memcpy(common->bssidmask, iter_data.mask, ETH_ALEN);
 	ath_hw_setbssidmask(common);
@@ -1382,6 +1383,7 @@ static void ath9k_calculate_summary_state(struct ieee80211_hw *hw,
 	}
 
 	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_ps_restore(sc);
 
 	/* Set up ANI */
 	if ((iter_data.naps + iter_data.nadhocs) > 0) {
-- 
1.7.3.5

