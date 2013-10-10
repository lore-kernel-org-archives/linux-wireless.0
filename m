Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37376 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754721Ab3JJMPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 08:15:21 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 09/10] ath9k: make ath9k_uses_beacons static
Date: Thu, 10 Oct 2013 14:15:11 +0200
Message-Id: <1381407312-72719-9-git-send-email-nbd@openwrt.org> (sfid-20131010_141524_706662_B6F5831E)
In-Reply-To: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
References: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 1 -
 drivers/net/wireless/ath/ath9k/main.c  | 2 +-
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index d03b85e..5492a0c 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -933,7 +933,6 @@ void ath9k_deinit_device(struct ath_softc *sc);
 void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw);
 void ath9k_reload_chainmask_settings(struct ath_softc *sc);
 
-bool ath9k_uses_beacons(int type);
 void ath9k_spectral_scan_trigger(struct ieee80211_hw *hw);
 int ath9k_spectral_scan_config(struct ieee80211_hw *hw,
 			       enum spectral_mode spectral_mode);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index bc89823..20a2fbc 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -896,7 +896,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	ath_dbg(common, CONFIG, "Driver halt\n");
 }
 
-bool ath9k_uses_beacons(int type)
+static bool ath9k_uses_beacons(int type)
 {
 	switch (type) {
 	case NL80211_IFTYPE_AP:
-- 
1.8.0.2

