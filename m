Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:51094 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbaD3TC0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2014 15:02:26 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH v2] ath9k:  Prevent divide-by-zero upon bad beacon_interval.
Date: Wed, 30 Apr 2014 12:02:05 -0700
Message-Id: <1398884525-26439-1-git-send-email-greearb@candelatech.com> (sfid-20140430_210229_457103_96D1C939)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

A similar patch fixed crashes seen on an ath9k system
when testing against a broken ath10k AP.  This patch
is slightly less protective, but probably will do the
job and is less redundant.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

Compile tested only.

 drivers/net/wireless/ath/ath9k/beacon.c | 5 +++--
 drivers/net/wireless/ath/ath9k/recv.c   | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index bd9e634..e387f0b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -537,8 +537,6 @@ static void ath9k_cache_beacon_config(struct ath_softc *sc,
 	cur_conf->dtim_period = bss_conf->dtim_period;
 	cur_conf->dtim_count = 1;
 	cur_conf->ibss_creator = bss_conf->ibss_creator;
-	cur_conf->bmiss_timeout =
-		ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
 
 	/*
 	 * It looks like mac80211 may end up using beacon interval of zero in
@@ -549,6 +547,9 @@ static void ath9k_cache_beacon_config(struct ath_softc *sc,
 	if (cur_conf->beacon_interval == 0)
 		cur_conf->beacon_interval = 100;
 
+	cur_conf->bmiss_timeout =
+		ATH_DEFAULT_BMISS_LIMIT * cur_conf->beacon_interval;
+
 	/*
 	 * We don't parse dtim period from mac80211 during the driver
 	 * initialization as it breaks association with hidden-ssid
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index 441c714..43ae199 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -538,8 +538,8 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		sc->ps_flags &= ~PS_BEACON_SYNC;
 		ath_dbg(common, PS,
 			"Reconfigure beacon timers based on synchronized timestamp\n");
-		ath9k_set_beacon(sc);
-
+		if (!(WARN_ON_ONCE(sc->cur_beacon_conf.beacon_interval == 0)))
+			ath9k_set_beacon(sc);
 		if (sc->p2p_ps_vif)
 			ath9k_update_p2p_ps(sc, sc->p2p_ps_vif->vif);
 	}
-- 
1.7.11.7

