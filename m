Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:45854 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205Ab2DVTuv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Apr 2012 15:50:51 -0400
Received: by wgbds11 with SMTP id ds11so2016908wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Apr 2012 12:50:50 -0700 (PDT)
From: Zefir Kurtisi <zefir.kurtisi@gmail.com>
To: linville@tuxdriver.com
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org,
	rodrigue@qca.qualcomm.com, achadd@qca.qualcomm.com,
	chunkeey@googlemail.com, Zefir Kurtisi <zefir.kurtisi@neratec.com>
Subject: [PATCH 4/4] ath9k: set radar config if switching to DFS channel
Date: Sun, 22 Apr 2012 21:50:23 +0200
Message-Id: <1335124223-15439-5-git-send-email-zefir.kurtisi@gmail.com> (sfid-20120422_215055_525525_0E283525)
In-Reply-To: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com>
References: <1335124223-15439-1-git-send-email-zefir.kurtisi@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zefir Kurtisi <zefir.kurtisi@neratec.com>


Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3879485..0aeba88 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -371,6 +371,16 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 
 	r = ath_reset_internal(sc, hchan, false);
 
+	if ((r == 0) && (hchan->chan->flags & IEEE80211_CHAN_RADAR)) {
+		/* set HW specific DFS configuration if on DFS channel */
+		struct ath_hw *ah = sc->sc_ah;
+		struct ath_common *common = ath9k_hw_common(ah);
+
+		ath9k_hw_set_radar_params(ah);
+		ath_dbg(common, DFS, "DFS enabled for channel %d\n",
+			hchan->chan->center_freq);
+	}
+
 	return r;
 }
 
-- 
1.7.4.1

