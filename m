Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59983 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753095AbZESOCa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:02:30 -0400
Message-Id: <20090519140224.951046895@atheros.com>
References: <20090519140137.708996030@atheros.com>
Date: Tue, 19 May 2009 17:01:40 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 3/7] ath9k: Use TSFOOR interrupt to trigger TSF sync with next Beacon
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If the chip complains about TSF sync, make sure we remain awake to
sync with the next Beacon frame. In theory, this should not be needed
since we are currently trying to receive all Beacon frames, anyway,
better have this code ready should we ever change that.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/main.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-05-19 16:32:31.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-05-19 16:32:33.000000000 +0300
@@ -480,6 +480,16 @@ static void ath9k_tasklet(unsigned long 
 	if (status & ATH9K_INT_TX)
 		ath_tx_tasklet(sc);
 
+	if ((status & ATH9K_INT_TSFOOR) &&
+	    (sc->hw->conf.flags & IEEE80211_CONF_PS)) {
+		/*
+		 * TSF sync does not look correct; remain awake to sync with
+		 * the next Beacon.
+		 */
+		DPRINTF(sc, ATH_DBG_PS, "TSFOOR - Sync with next Beacon\n");
+		sc->sc_flags |= SC_OP_WAIT_FOR_BEACON;
+	}
+
 	/* re-enable hardware interrupt */
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 	ath9k_ps_restore(sc);

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
