Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41070 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933125Ab1IONcZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 09:32:25 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 2/2] ath9k: Reset caldata on radio enable
Date: Thu, 15 Sep 2011 19:02:54 +0530
Message-ID: <1316093574-8188-2-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110915_153228_182137_445395FC)
In-Reply-To: <1316093574-8188-1-git-send-email-rmanohar@qca.qualcomm.com>
References: <1316093574-8188-1-git-send-email-rmanohar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Not doing so, the caldata continues to retain older history
values learned on that channel. It is always safer to start
noise floor calibration from the defaults after the assoication.
So this patch resets the nf history buffer when none of the
STA vifs are associated.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8a17cff5..b38dc18 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2015,6 +2015,7 @@ static void ath9k_config_bss(struct ath_softc *sc, struct ieee80211_vif *vif)
 		/* Stop ANI */
 		sc->sc_flags &= ~SC_OP_ANI_RUN;
 		del_timer_sync(&common->ani.timer);
+		memset(&sc->caldata, 0, sizeof(sc->caldata));
 	}
 }
 
-- 
1.7.6.1

