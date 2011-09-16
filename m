Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:28533 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932076Ab1IPXEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 19:04:02 -0400
From: Paul Stewart <pstew@chromium.org>
Date: Fri, 16 Sep 2011 15:17:58 -0700
Subject: [PATCH] ath9k: Fix samp_lock init for non-DEBUGFS
To: linux-wireless@vger.kernel.org
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Adrian Chadd <adrian@freebsd.org>, linville@tuxdriver.com
In-Reply-To: <20110827111641.GA17693@vmraj-lnx.users.atheros.com>
References: <1314442067-11799-1-git-send-email-rmanohar@qca.qualcomm.com>
 <CAJ-Vmo=wLETTSy0i3uz3Zj5w+_o+AouzD=nJzFk9KnERK+g7Cg@mail.gmail.com>
 <20110827111641.GA17693@vmraj-lnx.users.atheros.com>
Message-Id: <20110916230334.0BDD92043D@glenhelen.mtv.corp.google.com> (sfid-20110917_010413_880556_77F4C66A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch "ath9k: Add debugfs support for mac/baseband samples" uses
"&sc->debug.samp_lock" which breaks non-ATH9K_DEBUGFS builds.  Place
the correct ifdef guard around it.

Signed-off-by: Paul Stewart <pstew@chromium.org>
Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Cc: Adrian Chadd <adrian@freebsd.org>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index 74c9c99..b99ab96 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -553,7 +553,9 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc, u16 subsysid,
 	spin_lock_init(&sc->wiphy_lock);
 	spin_lock_init(&sc->sc_serial_rw);
 	spin_lock_init(&sc->sc_pm_lock);
+#ifdef CONFIG_ATH9K_DEBUGFS
 	spin_lock_init(&sc->debug.samp_lock);
+#endif
 	mutex_init(&sc->mutex);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
-- 
1.7.3.1

