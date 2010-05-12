Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:24185 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754387Ab0ELJj5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 05:39:57 -0400
Received: from vs3003.wh2.ocn.ne.jp (125.206.180.231)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0739657196
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 18:39:56 +0900 (JST)
Subject: [PATCH 03/12] ath5k: initialize calibration timers
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 12 May 2010 18:39:57 +0900
Message-ID: <20100512093957.6575.16388.stgit@tt-desk>
In-Reply-To: <20100512093947.6575.99595.stgit@tt-desk>
References: <20100512093947.6575.99595.stgit@tt-desk>
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
index 732a2c1..3fc1de4 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2925,6 +2925,8 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 
 	ath5k_ani_init(ah, ah->ah_sc->ani_state.ani_mode);
 
+	ah->ah_cal_next_full = jiffies;
+	ah->ah_cal_next_ani = jiffies;
 	/*
 	 * Change channels and update the h/w rate map if we're switching;
 	 * e.g. 11a to 11b/g.

