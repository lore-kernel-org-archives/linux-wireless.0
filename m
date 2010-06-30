Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:10968 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0F3KPf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jun 2010 06:15:35 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 30 Jun 2010 03:15:35 -0700
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] ath9k: Call ieee80211_wake_queue() during ATH_WIPHY_SCAN state also
Date: Wed, 30 Jun 2010 03:15:29 -0700
Message-ID: <1277892929-2437-1-git-send-email-vasanth@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Along with "mac80211: Dont allow to wake up netif tx queues while on off channel"
this patch fixes a tx hang issue which shows up when starting a background scanning.
The cause for hang is a missed call to ieee80211_wake_queue() after the tx queue
was stopped due to tx buffer shortage.

Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/virtual.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index 89423ca..2c2f193 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -703,7 +703,8 @@ void ath_mac80211_start_queue(struct ath_softc *sc, u16 skb_queue)
 	spin_lock_bh(&sc->wiphy_lock);
 
 	/* Start the primary wiphy */
-	if (sc->pri_wiphy->state == ATH_WIPHY_ACTIVE) {
+	if ((sc->pri_wiphy->state == ATH_WIPHY_ACTIVE) ||
+	    (sc->pri_wiphy->state == ATH_WIPHY_SCAN)) {
 		ieee80211_wake_queue(hw, skb_queue);
 		goto unlock;
 	}
-- 
1.7.0.4

