Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:5217 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755116Ab0JSH47 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Oct 2010 03:56:59 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0305215016
	for <linux-wireless@vger.kernel.org>; Tue, 19 Oct 2010 16:56:58 +0900 (JST)
Subject: [PATCH 2/2] ath5k: Add channel time to survey data
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Tue, 19 Oct 2010 16:56:54 +0900
Message-ID: <20101019075654.19979.9679.stgit@localhost6.localdomain6>
In-Reply-To: <20101019075648.19979.42181.stgit@localhost6.localdomain6>
References: <20101019075648.19979.42181.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Include the channel utilization (busy, rx, tx) in the survey results.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 8251946..484aad5 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3206,14 +3206,32 @@ static int ath5k_get_survey(struct ieee80211_hw *hw, int idx,
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
+	struct ath_common *common = ath5k_hw_common(sc->ah);
+	struct ath_cycle_counters *cc = &common->cc_survey;
+	unsigned int div = common->clockrate * 1000;
 
-	 if (idx != 0)
+	if (idx != 0)
 		return -ENOENT;
 
 	survey->channel = conf->channel;
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = sc->ah->ah_noise_floor;
 
+	spin_lock_bh(&common->cc_lock);
+	ath_hw_cycle_counters_update(common);
+	if (cc->cycles > 0) {
+		survey->filled |= SURVEY_INFO_CHANNEL_TIME |
+			SURVEY_INFO_CHANNEL_TIME_BUSY |
+			SURVEY_INFO_CHANNEL_TIME_RX |
+			SURVEY_INFO_CHANNEL_TIME_TX;
+		survey->channel_time += cc->cycles / div;
+		survey->channel_time_busy += cc->rx_busy / div;
+		survey->channel_time_rx += cc->rx_frame / div;
+		survey->channel_time_tx += cc->tx_frame / div;
+	}
+	memset(cc, 0, sizeof(*cc));
+	spin_unlock_bh(&common->cc_lock);
+
 	return 0;
 }
 

