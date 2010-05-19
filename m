Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:22079 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756408Ab0ESBcI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:32:08 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-088612726
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:32:06 +0900 (JST)
Subject: [PATCH v2 03/20] ath5k: initialize calibration timers
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:30:55 +0900
Message-ID: <20100519013055.22206.21675.stgit@tt-desk>
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initialize calibration timers on reset, since otherwise they might be in the
future and the calibration tasklet might not be scheduled for a long time.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 9f9107b..de59a6e 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2926,6 +2926,8 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 
 	ath5k_ani_init(ah, ah->ah_sc->ani_state.ani_mode);
 
+	ah->ah_cal_next_full = jiffies;
+	ah->ah_cal_next_ani = jiffies;
 	/*
 	 * Change channels and update the h/w rate map if we're switching;
 	 * e.g. 11a to 11b/g.

