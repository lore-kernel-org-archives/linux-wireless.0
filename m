Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:42184 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932729Ab0JEJzb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Oct 2010 05:55:31 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-034052530
	for <linux-wireless@vger.kernel.org>; Tue,  5 Oct 2010 18:55:30 +0900 (JST)
Subject: [PATCH 5/5] ath5k: Add busy ratios to survey data
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: nbd@openwrt.org, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, adrian@freebsd.org,
	vasanth@atheros.com
Date: Tue, 05 Oct 2010 18:55:31 +0900
Message-ID: <20101005095531.3083.39403.stgit@tt-desk>
In-Reply-To: <20101005095510.3083.46174.stgit@tt-desk>
References: <20101005095510.3083.46174.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Include the channel utilization (busy, rx, tx) in the survey results.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   17 +++++++++++++++++
 1 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index c158f2e..a33d9f2 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -3008,6 +3008,7 @@ static int ath5k_get_survey(struct ieee80211_hw *hw, int idx,
 {
 	struct ath5k_softc *sc = hw->priv;
 	struct ieee80211_conf *conf = &hw->conf;
+	struct ath_common *common = ath5k_hw_common(sc->ah);
 
 	 if (idx != 0)
 		return -ENOENT;
@@ -3016,6 +3017,22 @@ static int ath5k_get_survey(struct ieee80211_hw *hw, int idx,
 	survey->filled = SURVEY_INFO_NOISE_DBM;
 	survey->noise = sc->ah->ah_noise_floor;
 
+	ath_hw_cycle_counters_lock(common);
+	ath_hw_cycle_counters_update(common);
+	if (common->cc_survey.cycles > 0) {
+		survey->filled |= SURVEY_INFO_BUSY |
+				SURVEY_INFO_BUSY_TX | SURVEY_INFO_BUSY_RX;
+		survey->busy = common->cc_survey.rx_busy * 255 /
+					common->cc_survey.cycles;
+		survey->busy_tx = common->cc_survey.tx_frame * 255 /
+					common->cc_survey.cycles;
+		survey->busy_rx = common->cc_survey.rx_frame * 255 /
+					common->cc_survey.cycles;
+	}
+
+	memset(&common->cc_survey, 0, sizeof(struct ath_cycle_counters));
+	ath_hw_cycle_counters_unlock(common);
+
 	return 0;
 }
 

