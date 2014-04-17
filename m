Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38404 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751239AbaDQAlD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Apr 2014 20:41:03 -0400
From: greearb@candelatech.com
To: ath9k-devel@venema.h4ckr.net
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath9k:  Prevent divide by zero kernel crash.
Date: Wed, 16 Apr 2014 17:40:40 -0700
Message-Id: <1397695240-13710-1-git-send-email-greearb@candelatech.com> (sfid-20140417_024139_123476_132880EB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Make sure we cannot ever assign beacon interval to zero.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c | 4 ++++
 drivers/net/wireless/ath/ath9k/recv.c   | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 2e8bba0..5391f01 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -443,6 +443,8 @@ static u32 ath9k_mod_tsf64_tu(u64 tsf, u32 div_tu)
 {
 	u32 tsf_mod, tsf_hi, tsf_lo, mod_hi, mod_lo;
 
+	if (WARN_ON_ONCE(div_tu == 0))
+		div_tu = 100;
 	tsf_mod = tsf & (BIT(10) - 1);
 	tsf_hi = tsf >> 32;
 	tsf_lo = ((u32) tsf) >> 10;
@@ -667,6 +669,8 @@ static void ath9k_cache_beacon_config(struct ath_softc *sc,
 		"Caching beacon data for BSS: %pM\n", bss_conf->bssid);
 
 	cur_conf->beacon_interval = bss_conf->beacon_int;
+	if (WARN_ON_ONCE(cur_conf->beacon_interval == 0))
+		cur_conf->beacon_interval = 100;
 	cur_conf->dtim_period = bss_conf->dtim_period;
 	cur_conf->listen_interval = 1;
 	cur_conf->dtim_count = 1;
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b97217d..79c20c7 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -538,7 +538,8 @@ static void ath_rx_ps_beacon(struct ath_softc *sc, struct sk_buff *skb)
 		sc->ps_flags &= ~PS_BEACON_SYNC;
 		ath_dbg(common, PS,
 			"Reconfigure beacon timers based on synchronized timestamp\n");
-		ath9k_set_beacon(sc);
+		if (!(WARN_ON_ONCE(sc->cur_beacon_conf.beacon_interval == 0)))
+			ath9k_set_beacon(sc);
 	}
 
 	if (ath_beacon_dtim_pending_cab(skb)) {
-- 
1.7.11.7

