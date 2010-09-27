Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:40887 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932620Ab0I0DWS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Sep 2010 23:22:18 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 4-0204777736
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 12:22:16 +0900 (JST)
Subject: [PATCH 1/4] ath5k: Remove unused variable for atim window
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Mon, 27 Sep 2010 12:22:16 +0900
Message-ID: <20100927032216.8754.45251.stgit@tt-desk>
In-Reply-To: <20100927032211.8754.49870.stgit@tt-desk>
References: <20100927032211.8754.49870.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It's not used and it's unlikely we will ever implement ATIM.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h  |    1 -
 drivers/net/wireless/ath/ath5k/attach.c |    1 -
 drivers/net/wireless/ath/ath5k/pcu.c    |    2 +-
 3 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index b96bb98..42e6e82 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1041,7 +1041,6 @@ struct ath5k_hw {
 #define ah_modes		ah_capabilities.cap_mode
 #define ah_ee_version		ah_capabilities.cap_eeprom.ee_version
 
-	u32			ah_atim_window;
 	u32			ah_limit_tx_retries;
 	u8			ah_coverage_class;
 
diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index 6e02de3..cd0b14a 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -118,7 +118,6 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	ah->ah_turbo = false;
 	ah->ah_txpower.txp_tpc = AR5K_TUNE_TPC_TXPOWER;
 	ah->ah_imr = 0;
-	ah->ah_atim_window = 0;
 	ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
 	ah->ah_software_retry = false;
 	ah->ah_ant_mode = AR5K_ANTMODE_DEFAULT;
diff --git a/drivers/net/wireless/ath/ath5k/pcu.c b/drivers/net/wireless/ath/ath5k/pcu.c
index 6a891c4..71dca10 100644
--- a/drivers/net/wireless/ath/ath5k/pcu.c
+++ b/drivers/net/wireless/ath/ath5k/pcu.c
@@ -600,7 +600,7 @@ void ath5k_hw_init_beacon(struct ath5k_hw *ah, u32 next_beacon, u32 interval)
 	/* Timer3 marks the end of our ATIM window
 	 * a zero length window is not allowed because
 	 * we 'll get no beacons */
-	timer3 = next_beacon + (ah->ah_atim_window ? ah->ah_atim_window : 1);
+	timer3 = next_beacon + 1;
 
 	/*
 	 * Set the beacon register and enable all timers.

