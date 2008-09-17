Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:39831 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847AbYIQErj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2008 00:47:39 -0400
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18640.35696.421614.964818@gargle.gargle.HOWL> (sfid-20080917_064742_362588_8DE235BE)
Date: Wed, 17 Sep 2008 10:15:36 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 2/3] ath9k: Fix nexttbtt calculation
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

nexttbtt has to be obtained from the timestamp of the beacon
obtained from mac80211. Fix this.
And <asm/unaligned.h> is not needed anymore.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/beacon.c |    9 ++++++---
 drivers/net/wireless/ath9k/core.h   |    1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath9k/beacon.c b/drivers/net/wireless/ath9k/beacon.c
index f8d952c..eedb465 100644
--- a/drivers/net/wireless/ath9k/beacon.c
+++ b/drivers/net/wireless/ath9k/beacon.c
@@ -16,7 +16,6 @@
 
  /* Implementation of beacon processing. */
 
-#include <asm/unaligned.h>
 #include "core.h"
 
 /*
@@ -305,6 +304,7 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 	struct ieee80211_hdr *hdr;
 	struct ath_buf *bf;
 	struct sk_buff *skb;
+	__le64 tstamp;
 
 	avp = sc->sc_vaps[if_id];
 	ASSERT(avp);
@@ -370,6 +370,9 @@ int ath_beacon_alloc(struct ath_softc *sc, int if_id)
 		return -ENOMEM;
 	}
 
+	tstamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
+	sc->bc_tstamp = le64_to_cpu(tstamp);
+
 	/*
 	 * Calculate a TSF adjustment factor required for
 	 * staggered beacons.  Note that we assume the format
@@ -669,8 +672,8 @@ void ath_beacon_config(struct ath_softc *sc, int if_id)
 	conf.bmiss_timeout = ATH_DEFAULT_BMISS_LIMIT * conf.beacon_interval;
 
 	/* extract tstamp from last beacon and convert to TU */
-	nexttbtt = TSF_TO_TU(get_unaligned_le32(conf.u.last_tstamp + 4),
-			     get_unaligned_le32(conf.u.last_tstamp));
+	nexttbtt = TSF_TO_TU(sc->bc_tstamp >> 32, sc->bc_tstamp);
+
 	/* XXX conditionalize multi-bss support? */
 	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
 		/*
diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index b66de29..6ff3bef 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -1001,6 +1001,7 @@ struct ath_softc {
 	u32 sc_bhalq;
 	u32 sc_bmisscount;
 	u32 ast_be_xmit;	/* beacons transmitted */
+	u64 bc_tstamp;
 
 	/* Rate */
 	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
-- 
1.6.0.2

