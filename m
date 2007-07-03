Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7519 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755791AbXGCPWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:22:25 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:22:17 +0200
Subject: [PATCH] libertas: remove adapter->scanprobes
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031722.17345.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The variable was initialized to 0 and nowhere else to anything 
different.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/dev.h  |    1 -
 drivers/net/wireless/libertas/main.c |    2 --
 drivers/net/wireless/libertas/scan.c |    5 ++---
 3 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h 
b/drivers/net/wireless/libertas/dev.h
index 83876a3..1dcfb05 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -375,7 +375,6 @@ struct _wlan_adapter {
 	struct wlan_offset_value offsetvalue;
 
 	struct cmd_ds_802_11_get_log logmsg;
-	u16 scanprobes;
 
 	u32 pkttxctrl;
 
diff --git a/drivers/net/wireless/libertas/main.c 
b/drivers/net/wireless/libertas/main.c
index e354ebb..1d439cd 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -998,8 +998,6 @@ static void wlan_init_adapter(wlan_private * 
priv)
 	wlan_adapter *adapter = priv->adapter;
 	int i;
 
-	adapter->scanprobes = 0;
-
 	adapter->bcn_avg_factor = DEFAULT_BCN_AVG_FACTOR;
 	adapter->data_avg_factor = DEFAULT_DATA_AVG_FACTOR;
 
diff --git a/drivers/net/wireless/libertas/scan.c 
b/drivers/net/wireless/libertas/scan.c
index f471157..7e4b0ab 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -416,8 +416,7 @@ wlan_scan_setup_scan_config(wlan_private * 
priv,
 		     scanmode);
 
 		/* Set the number of probes to send, use adapter setting if 
unset */
-		numprobes = (puserscanin->numprobes ? puserscanin->numprobes :
-			     adapter->scanprobes);
+		numprobes = puserscanin->numprobes ? puserscanin->numprobes : 
0;
 
 		/*
 		 * Set the BSSID filter to the incoming configuration,
@@ -450,7 +449,7 @@ wlan_scan_setup_scan_config(wlan_private * 
priv,
 		}
 	} else {
 		pscancfgout->bsstype = adapter->scanmode;
-		numprobes = adapter->scanprobes;
+		numprobes = 0;
 	}
 
 	/* If the input config or adapter has the number of Probes set, 
add tlv */
-- 
1.5.2.1

