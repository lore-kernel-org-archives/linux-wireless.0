Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59102 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756980AbaDHVoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2014 17:44:37 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 3.15 2/2] ath9k: fix a scheduling while atomic bug in CSA handling
Date: Tue,  8 Apr 2014 23:44:26 +0200
Message-Id: <1396993466-1799-2-git-send-email-nbd@openwrt.org> (sfid-20140408_234447_929478_E619CF00)
In-Reply-To: <1396993466-1799-1-git-send-email-nbd@openwrt.org>
References: <1396993466-1799-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit "ath9k: prepare for multi-interface CSA support" added a call to
ieee80211_iterate_active_interfaces in atomic context (beacon tasklet),
which is crashing.
Use ieee80211_iterate_active_interfaces_atomic instead.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 471e0f6..bd9e634 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -312,10 +312,9 @@ static void ath9k_csa_update_vif(void *data, u8 *mac, struct ieee80211_vif *vif)
 
 void ath9k_csa_update(struct ath_softc *sc)
 {
-	ieee80211_iterate_active_interfaces(sc->hw,
-					    IEEE80211_IFACE_ITER_NORMAL,
-					    ath9k_csa_update_vif,
-					    sc);
+	ieee80211_iterate_active_interfaces_atomic(sc->hw,
+						   IEEE80211_IFACE_ITER_NORMAL,
+						   ath9k_csa_update_vif, sc);
 }
 
 void ath9k_beacon_tasklet(unsigned long data)
-- 
1.8.5.2 (Apple Git-48)

