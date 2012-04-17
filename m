Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44377 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab2DQWTK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 18:19:10 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Fix compile warnings when DEBUGFS is disabled.
Date: Tue, 17 Apr 2012 15:19:03 -0700
Message-Id: <1334701143-3960-1-git-send-email-greearb@candelatech.com> (sfid-20120418_001914_417767_AEF01BCC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This fixes two compile warnings, and removes a useless
cast when assigning the 'sc' variable.

Reported-by: Gabor Juhos <juhosg@openwrt.org>
Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 dd4b8f4... 8c827a1... M	drivers/net/wireless/ath/ath9k/hw.h
:100644 100644 301ef3e... 12b0979... M	drivers/net/wireless/ath/ath9k/recv.c
 drivers/net/wireless/ath/ath9k/hw.h   |    3 ++-
 drivers/net/wireless/ath/ath9k/recv.c |    2 +-
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index dd4b8f4..8c827a1 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -959,7 +959,8 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode);
 #ifdef CONFIG_ATH9K_DEBUGFS
 void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause);
 #else
-static void ath9k_debug_sync_cause(struct ath_common *common, u32 sync_cause) {}
+static inline void ath9k_debug_sync_cause(struct ath_common *common,
+					  u32 sync_cause) {}
 #endif
 
 /* Generic hw timer primitives */
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 301ef3e..12b0979 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -907,7 +907,7 @@ static int ath9k_process_rate(struct ath_common *common,
 	struct ieee80211_supported_band *sband;
 	enum ieee80211_band band;
 	unsigned int i = 0;
-	struct ath_softc *sc = (struct ath_softc *) common->priv;
+	struct ath_softc __maybe_unused *sc = common->priv;
 
 	band = hw->conf.channel->band;
 	sband = hw->wiphy->bands[band];
-- 
1.7.3.4

