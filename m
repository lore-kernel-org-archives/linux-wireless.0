Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7669 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756326AbXGCPXk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:23:40 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:23:34 +0200
Subject: [PATCH] libertas: remove adapter->adhoc_grate_enabled
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031723.34967.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable was initialized with 0 (false). There is no code that would
ever change it, so we can use the false-patch directly.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/dev.h  |    2 --
 drivers/net/wireless/libertas/join.c |    9 ++-------
 drivers/net/wireless/libertas/main.c |    1 -
 3 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 6675cc6..eef6a72 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -281,8 +281,6 @@ struct _wlan_adapter {
 
 	u16 enablehwauto;
 	u16 ratebitmap;
-	/** control G rates */
-	u8 adhoc_grate_enabled;
 
 	u32 fragthsd;
 	u32 rtsthsd;
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index e335a7e..95c21ba 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -534,13 +534,8 @@ int libertas_cmd_80211_ad_hoc_start(wlan_private * priv,
 	adhs->probedelay = cpu_to_le16(CMD_SCAN_PROBE_DELAY_TIME);
 
 	memset(adhs->rates, 0, sizeof(adhs->rates));
-	if (adapter->adhoc_grate_enabled) {
-		ratesize = min(sizeof(adhs->rates), sizeof(libertas_bg_rates));
-		memcpy(adhs->rates, libertas_bg_rates, ratesize);
-	} else {
-		ratesize = min(sizeof(adhs->rates), sizeof(adhoc_rates_b));
-		memcpy(adhs->rates, adhoc_rates_b, ratesize);
-	}
+	ratesize = min(sizeof(adhs->rates), sizeof(adhoc_rates_b));
+	memcpy(adhs->rates, adhoc_rates_b, ratesize);
 
 	/* Copy the ad-hoc creating rates into Current BSS state structure */
 	memset(&adapter->curbssparams.rates, 0, sizeof(adapter->curbssparams.rates));
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 79e2748..6882a7d 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1036,7 +1036,6 @@ static void wlan_init_adapter(wlan_private * priv)
 
 	adapter->auto_rate = 1;
 	adapter->cur_rate = 0;
-	adapter->adhoc_grate_enabled = 0;
 
 	adapter->beaconperiod = MRVDRV_BEACON_INTERVAL;
 
-- 
1.5.2.1

