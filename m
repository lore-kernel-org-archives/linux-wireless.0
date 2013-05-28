Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59098 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758206Ab3E1LCB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 07:02:01 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH v2 3/3] ath9k: advertise support for active monitor interfaces
Date: Tue, 28 May 2013 13:01:54 +0200
Message-Id: <1369738914-34367-3-git-send-email-nbd@openwrt.org> (sfid-20130528_130204_454494_ABFF1272)
In-Reply-To: <1369738914-34367-1-git-send-email-nbd@openwrt.org>
References: <1369738914-34367-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index c0aa4ff..f1d028a 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -772,6 +772,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || ath9k_modparam_nohwcrypt)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
 
+	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
+
 	hw->wiphy->interface_modes =
 		BIT(NL80211_IFTYPE_P2P_GO) |
 		BIT(NL80211_IFTYPE_P2P_CLIENT) |
-- 
1.8.0.2

