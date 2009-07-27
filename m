Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:31178 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754177AbZG0SxI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jul 2009 14:53:08 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2009 11:53:09 -0700
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/3] ath9k: re-order cancelling of work on mac80211 workqueue
Date: Mon, 27 Jul 2009 11:53:02 -0700
Message-ID: <1248720784-15671-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1248720784-15671-1-git-send-email-lrodriguez@atheros.com>
References: <1248720784-15671-1-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k uses the mac80211 workqueue for 4 different types of work:

 * Led blink work
 * TX hang monitoring work
 * internal wiphy schedular work
 * channel change work done for internal wiphy schedular

Since the internal wiphy schedular can end up kicking off some
channel channel change work we should first cancel the wiphy
schedular work and then the channel change work.

The TX hang work can be cancelled second since we're going down
anyway.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1ce1de5..dfcd8d9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1253,9 +1253,9 @@ void ath_detach(struct ath_softc *sc)
 	DPRINTF(sc, ATH_DBG_CONFIG, "Detach ATH hw\n");
 
 	ath_deinit_leds(sc);
-	cancel_work_sync(&sc->chan_work);
-	cancel_delayed_work_sync(&sc->wiphy_work);
 	cancel_delayed_work_sync(&sc->tx_complete_work);
+	cancel_delayed_work_sync(&sc->wiphy_work);
+	cancel_work_sync(&sc->chan_work);
 
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
-- 
1.6.0.4

