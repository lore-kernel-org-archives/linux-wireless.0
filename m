Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7685 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425AbXGCPXs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:23:48 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:23:42 +0200
Subject: [PATCH] libertas: remove adapter->beaconperiod
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031723.42855.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

beaconperiod was initialized with MRVDRV_BEACON_INTERVAL, but there is
no code that would ever change it's value. We can use the define directly.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/dev.h  |    1 -
 drivers/net/wireless/libertas/join.c |    2 +-
 drivers/net/wireless/libertas/main.c |    2 --
 3 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index eef6a72..1b42fad 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -265,7 +265,6 @@ struct _wlan_adapter {
 	u8 scantype;
 	u32 scanmode;
 
-	u16 beaconperiod;
 	u8 adhoccreate;
 
 	/** capability Info used in Association, start, join */
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index 95c21ba..c16d1f6 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -496,7 +496,7 @@ int libertas_cmd_80211_ad_hoc_start(wlan_private * priv,
 	/* set the BSS type */
 	adhs->bsstype = CMD_BSS_TYPE_IBSS;
 	adapter->mode = IW_MODE_ADHOC;
-	adhs->beaconperiod = cpu_to_le16(adapter->beaconperiod);
+	adhs->beaconperiod = cpu_to_le16(MRVDRV_BEACON_INTERVAL);
 
 	/* set Physical param set */
 #define DS_PARA_IE_ID   3
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 6882a7d..68aa9bc 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1037,8 +1037,6 @@ static void wlan_init_adapter(wlan_private * priv)
 	adapter->auto_rate = 1;
 	adapter->cur_rate = 0;
 
-	adapter->beaconperiod = MRVDRV_BEACON_INTERVAL;
-
 	// set default capabilities
 	adapter->capability = WLAN_CAPABILITY_SHORT_PREAMBLE;
 
-- 
1.5.2.1

