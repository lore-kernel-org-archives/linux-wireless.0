Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4875 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757121Ab2FYOOZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Jun 2012 10:14:25 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	<vadivel@qca.qualcomm.com>, <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH v3 05/10] ath9k: advertise supported WoW flags to upper layer
Date: Mon, 25 Jun 2012 19:42:54 +0530
Message-ID: <1340633579-7514-6-git-send-email-mohammed@qca.qualcomm.com> (sfid-20120625_161437_336698_4BBD736A)
In-Reply-To: <1340633579-7514-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1340633579-7514-1-git-send-email-mohammed@qca.qualcomm.com>
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

Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: vadivel@qca.qualcomm.com
Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |   16 ++++++++++++++++
 1 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 9dfce1a..576f808 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -713,6 +713,22 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS;
 	hw->wiphy->flags |= WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
 
+#ifdef CONFIG_PM_SLEEP
+
+	if ((ah->caps.hw_caps & ATH9K_HW_WOW_DEVICE_CAPABLE) &&
+	    device_can_wakeup(sc->dev)) {
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

