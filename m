Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:43696 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab1ATU5j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 15:57:39 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/2] ath9k: remove a bogus error message
Date: Thu, 20 Jan 2011 21:57:30 +0100
Message-Id: <1295557051-64138-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When beacons are being added or removed for an interface, ieee80211_beacon_get
will sometimes not return a beacon. This is normal and should not result in
useless logspam.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 8de591e..ab8c05c 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -279,10 +279,8 @@ int ath_beacon_alloc(struct ath_wiphy *aphy, struct ieee80211_vif *vif)
 
 	/* NB: the beacon data buffer must be 32-bit aligned. */
 	skb = ieee80211_beacon_get(sc->hw, vif);
-	if (skb == NULL) {
-		ath_err(common, "ieee80211_beacon_get failed\n");
+	if (skb == NULL)
 		return -ENOMEM;
-	}
 
 	tstamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
 	sc->beacon.bc_tstamp = le64_to_cpu(tstamp);
-- 
1.7.3.2

