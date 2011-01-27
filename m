Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:15307 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab1A0NKh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Jan 2011 08:10:37 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 27 Jan 2011 05:10:18 -0800
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>,
	<stable@kernel.org>, Paul Stewart <pstew@google.com>
Subject: [PATCH v2 2/2] ath9k: Fix power save usage count imbalance on deinit
Date: Thu, 27 Jan 2011 18:39:38 +0530
Message-ID: <1296133778-3150-2-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1296133778-3150-1-git-send-email-rmanoharan@atheros.com>
References: <1296133778-3150-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

While unloading the driver, the ps_usecount is incremented
before configuring gpio registers in deinit_device.
But it is failed to restore the ps_usecount after that.
The problem is that the chip is forcibly moved to FULL SLEEP
by radio_disable when mac80211 is reporting as idle
though ps_usecount is not zero.

This patch retores ps_usecount properly and ensures that
the chip is always moved to full sleep only if ps usage
count is zero which also helps in debugging deadbeef on
multivif case. And also fixes the following warning.

ath: DMA failed to stop in 10 ms AR_CR=0xdeadbeef AR_DIAG_SW=0xdeadbeef
ath: Could not stop RX, we could be confusing the DMA engine when we
start RX up
------------[ cut here ]------------
WARNING: at drivers/net/wireless/ath/ath9k/recv.c:536
ath_stoprecv+0xf4/0x100 [ath9k]()

Cc: stable@kernel.org
Cc: Paul Stewart <pstew@google.com>
Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 ++
 drivers/net/wireless/ath/ath9k/main.c |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 5279653..4538e6d 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -830,6 +830,8 @@ void ath9k_deinit_device(struct ath_softc *sc)
 	wiphy_rfkill_stop_polling(sc->hw->wiphy);
 	ath_deinit_leds(sc);
 
+	ath9k_ps_restore(sc);
+
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
 		if (aphy == NULL)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index facff10..65ad862 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -977,8 +977,6 @@ void ath_radio_disable(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	spin_unlock_bh(&sc->sc_pcu_lock);
 	ath9k_ps_restore(sc);
-
-	ath9k_setpower(sc, ATH9K_PM_FULL_SLEEP);
 }
 
 int ath_reset(struct ath_softc *sc, bool retry_tx)
-- 
1.7.3.5

