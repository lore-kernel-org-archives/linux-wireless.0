Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60084 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759303Ab2DJPO7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Apr 2012 11:14:59 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [WIP 05/11] ath9k: advertise supported WoW flags to upper layer
Date: Tue, 10 Apr 2012 20:43:15 +0530
Message-ID: <1334070801-21708-6-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120410_171512_552041_50D360CE)
In-Reply-To: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1334070801-21708-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

currently the code supports WoW triggers due to
*magic packet
*user defined patterns
*deauth and disassoc patterns
*disconnect - beacon miss, last beacon received timeout,
no ack for keeep alive frames.

we need to support other WoW offload features in the
near future. also a minor cleanup.

Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |   20 ++++++++++++++++++--
 1 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index cb00645..0e82981 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -656,8 +656,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 		IEEE80211_HW_SPECTRUM_MGMT |
 		IEEE80211_HW_REPORTS_TX_ACK_STATUS;
 
-	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
-		 hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_HT)
+		hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
 
 	if (AR_SREV_9160_10_OR_LATER(sc->sc_ah) || ath9k_modparam_nohwcrypt)
 		hw->flags |= IEEE80211_HW_MFP_CAPABLE;
@@ -677,6 +677,22 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 
+#ifdef CONFIG_PM_SLEEP
+
+	if ((ah->caps.wow_caps & ATH9K_HW_WOW_DEVICE_CAPABLE) &&
+					device_can_wakeup(sc->dev)) {
+
+		hw->wiphy->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
+					  WIPHY_WOWLAN_DISCONNECT;
+		hw->wiphy->wowlan.n_patterns = MAX_NUM_USER_PATTERN;
+		hw->wiphy->wowlan.pattern_min_len = 1;
+		hw->wiphy->wowlan.pattern_max_len = MAX_PATTERN_SIZE;
+		INIT_LIST_HEAD(&sc->wow_info.wow_patterns);
+
+	}
+
+#endif
+
 	hw->queues = 4;
 	hw->max_rates = 4;
 	hw->channel_change_time = 5000;
-- 
1.7.0.4

