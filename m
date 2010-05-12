Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:30802 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755178Ab0ELJkk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 05:40:40 -0400
Received: from vs3013.wh2.ocn.ne.jp (125.206.180.245)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0395227238
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 18:40:38 +0900 (JST)
Subject: [PATCH 11/12] ath5k: always calculate ANI listen time
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 12 May 2010 18:40:39 +0900
Message-ID: <20100512094039.6575.9705.stgit@tt-desk>
In-Reply-To: <20100512093947.6575.99595.stgit@tt-desk>
References: <20100512093947.6575.99595.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Calculate 'listen' time also when automatic ANI is off, since this and the
"busy" time is useful information also in manual mode.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ani.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ani.c b/drivers/net/wireless/ath/ath5k/ani.c
index f2311ab..987e3d3 100644
--- a/drivers/net/wireless/ath/ath5k/ani.c
+++ b/drivers/net/wireless/ath/ath5k/ani.c
@@ -481,14 +481,15 @@ ath5k_ani_calibration(struct ath5k_hw *ah)
 	struct ath5k_ani_state *as = &ah->ah_sc->ani_state;
 	int listen, ofdm_high, ofdm_low, cck_high, cck_low;
 
-	if (as->ani_mode != ATH5K_ANI_MODE_AUTO)
-		return;
-
 	/* get listen time since last call and add it to the counter because we
-	 * might not have restarted the "ani period" last time */
+	 * might not have restarted the "ani period" last time.
+	 * always do this to calculate the busy time also in manual mode */
 	listen = ath5k_hw_ani_get_listen_time(ah, as);
 	as->listen_time += listen;
 
+	if (as->ani_mode != ATH5K_ANI_MODE_AUTO)
+		return;
+
 	ath5k_ani_save_and_clear_phy_errors(ah, as);
 
 	ofdm_high = as->listen_time * ATH5K_ANI_OFDM_TRIG_HIGH / 1000;

