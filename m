Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:25339 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752623Ab0CYFth (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 01:49:37 -0400
Received: from vs3017.wh2.ocn.ne.jp (125.206.180.250)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0815636176
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:49:36 +0900 (JST)
Subject: [PATCH 06/10] ath5k: initialize default noise floor
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Thu, 25 Mar 2010 14:49:31 +0900
Message-ID: <20100325054931.10697.46232.stgit@tt-desk>
In-Reply-To: <20100325054603.10697.48915.stgit@tt-desk>
References: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize noise floor variable with a default of -95. This was used
uninitialized in the signal strength (RSSI -> dBm) conversion until the first
noise floor calibration was completed.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/attach.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/attach.c b/drivers/net/wireless/ath/ath5k/attach.c
index dd4099a..f80d3d5 100644
--- a/drivers/net/wireless/ath/ath5k/attach.c
+++ b/drivers/net/wireless/ath/ath5k/attach.c
@@ -123,6 +123,7 @@ int ath5k_hw_attach(struct ath5k_softc *sc)
 	ah->ah_limit_tx_retries = AR5K_INIT_TX_RETRY;
 	ah->ah_software_retry = false;
 	ah->ah_ant_mode = AR5K_ANTMODE_DEFAULT;
+	ah->ah_noise_floor = -95;	/* until first NF calibration is run */
 
 	/*
 	 * Find the mac version

