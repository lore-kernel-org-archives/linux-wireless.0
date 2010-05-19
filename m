Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:18180 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755193Ab0ESBcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:32:50 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0539182769
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:32:49 +0900 (JST)
Subject: [PATCH v2 11/20] ath5k: always calculate ANI listen time
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:31:37 +0900
Message-ID: <20100519013137.22206.45012.stgit@tt-desk>
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
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

