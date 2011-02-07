Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42495 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754990Ab1BGVo6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Feb 2011 16:44:58 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 6/7] ath9k:  Add debug info for configuring power level.
Date: Mon,  7 Feb 2011 13:44:37 -0800
Message-Id: <1297115078-27773-6-git-send-email-greearb@candelatech.com>
In-Reply-To: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
References: <1297115078-27773-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 1447887... e462a3f... M	drivers/net/wireless/ath/ath9k/main.c
 drivers/net/wireless/ath/ath9k/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 1447887..e462a3f 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1725,6 +1725,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
+		ath_dbg(common, ATH_DBG_CONFIG,
+			"Set power: %d\n", conf->power_level);
 		sc->config.txpowlimit = 2 * conf->power_level;
 		ath9k_ps_wakeup(sc);
 		ath9k_cmn_update_txpow(ah, sc->curtxpow,
-- 
1.7.2.3

