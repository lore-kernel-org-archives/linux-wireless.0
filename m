Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:8068 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752226Ab0CIHza (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Mar 2010 02:55:30 -0500
Received: from vs3004.wh2.ocn.ne.jp (125.206.180.167)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0898951329
	for <linux-wireless@vger.kernel.org>; Tue,  9 Mar 2010 16:55:29 +0900 (JST)
Subject: [PATCH 03/13] ath5k: preserve antenna settings
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 09 Mar 2010 16:55:28 +0900
Message-ID: <20100309075528.30616.58727.stgit@void>
In-Reply-To: <20100309075124.30616.40896.stgit@void>
References: <20100309075124.30616.40896.stgit@void>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

save antenna settings and preserve across resets.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/attach.c |    1 +
 drivers/net/wireless/ath/ath5k/base.c   |    2 +-
 drivers/net/wireless/ath/ath5k/phy.c    |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 4228444..c8bb102 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -123,6 +123,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	ah->ah_cw_min = AR5K_TUNE_CWMIN;
 	ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
 	ah->ah_software_retry = false;
+	ah->ah_ant_mode = AR5K_ANTMODE_DEFAULT;
 
 	/*
 	 * Find the mac version
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 85eb670..fd4dd3c 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2916,7 +2916,7 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 	 * then we must allow the user to set how many tx antennas we
 	 * have available
 	 */
-	ath5k_hw_set_antenna_mode(ah, AR5K_ANTMODE_DEFAULT);
+	ath5k_hw_set_antenna_mode(ah, ah->ah_ant_mode);
 
 unlock:
 	mutex_unlock(&sc->lock);
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index ffe253a..3fa4f4d 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1929,6 +1929,7 @@ ath5k_hw_set_antenna_mode(struct ath5k_hw *ah, u8 ant_mode)
 
 	ah->ah_tx_ant = tx_ant;
 	ah->ah_ant_mode = ant_mode;
+	ah->ah_def_ant = def_ant;
 
 	sta_id1 |= use_def_for_tx ? AR5K_STA_ID1_DEFAULT_ANTENNA : 0;
 	sta_id1 |= update_def_on_tx ? AR5K_STA_ID1_DESC_ANTENNA : 0;

