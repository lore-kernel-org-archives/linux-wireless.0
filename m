Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:48707 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751170AbZE1QZc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 May 2009 12:25:32 -0400
Date: Thu, 28 May 2009 19:25:28 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Add sanity check for beacon_int in adhoc/mesh case
Message-ID: <20090528162528.GA8117@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It looks like mac80211 can request the driver to start beaconing with
a beacon interval of zero in some cases (at least for mesh point). This
does not sound correct and something may need to be fixed in
mac80211. However, taken into account the unpleasantness of getting
stuck in an infinite busy loop with rtnl_lock held, let's add a quick
workaround in the driver to avoid the worst symptom while someone more
familiar with the mesh implementation can figure out what should be done
with mac80211 as far as beacon interval configuration is concerned.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/beacon.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/beacon.c	2009-05-28 19:13:54.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/beacon.c	2009-05-28 19:14:58.000000000 +0300
@@ -673,6 +673,14 @@ static void ath_beacon_config_adhoc(stru
 
 	intval = conf->beacon_interval & ATH9K_BEACON_PERIOD;
 
+	/*
+	 * It looks like mac80211 may end up using beacon interval of zero in
+	 * some cases (at least for mesh point). Avoid getting into an
+	 * infinite loop by using a bit safer value instead..
+	 */
+	if (intval == 0)
+		intval = 100;
+
 	/* Pull nexttbtt forward to reflect the current TSF */
 
 	nexttbtt = TSF_TO_TU(sc->beacon.bc_tstamp >> 32, sc->beacon.bc_tstamp);

-- 
Jouni Malinen                                            PGP id EFC895FA
