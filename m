Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7518 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755856AbXGCPWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:22:25 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:22:13 +0200
Subject: [PATCH] libertas: remove adapter->prescan
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031722.13505.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The value 1 was assigned to it and there was nowhere any code 
that
would have changed that to 0.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/assoc.c |    6 ++----
 drivers/net/wireless/libertas/dev.h   |    1 -
 drivers/net/wireless/libertas/main.c  |    2 --
 3 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/libertas/assoc.c 
b/drivers/net/wireless/libertas/assoc.c
index 5fdc96f..ffeec2f 100644
--- a/drivers/net/wireless/libertas/assoc.c
+++ b/drivers/net/wireless/libertas/assoc.c
@@ -57,10 +57,8 @@ static int assoc_helper_essid(wlan_private 
*priv,
 	lbs_deb_assoc("New SSID requested: '%s'\n",
 	              escape_essid(assoc_req->ssid, 
assoc_req->ssid_len));
 	if (assoc_req->mode == IW_MODE_INFRA) {
-		if (adapter->prescan) {
-			libertas_send_specific_ssid_scan(priv, assoc_req->ssid,
-				assoc_req->ssid_len, 0);
-		}
+		libertas_send_specific_ssid_scan(priv, assoc_req->ssid,
+			assoc_req->ssid_len, 0);
 
 		bss = libertas_find_ssid_in_list(adapter, assoc_req->ssid,
 				assoc_req->ssid_len, NULL, IW_MODE_INFRA, channel);
diff --git a/drivers/net/wireless/libertas/dev.h 
b/drivers/net/wireless/libertas/dev.h
index 765c0c4..83876a3 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -288,7 +288,6 @@ struct _wlan_adapter {
 	u32 rtsthsd;
 
 	u16 listeninterval;
-	u16 prescan;
 	u8 txretrycount;
 
 	/** Tx-related variables (for single packet tx) */
diff --git a/drivers/net/wireless/libertas/main.c 
b/drivers/net/wireless/libertas/main.c
index 5b4a134..e354ebb 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1037,8 +1037,6 @@ static void wlan_init_adapter(wlan_private 
* priv)
 
 	mutex_init(&adapter->lock);
 
-	adapter->prescan = 1;
-
 	memset(&adapter->curbssparams, 0, 
sizeof(adapter->curbssparams));
 	adapter->curbssparams.channel = DEFAULT_AD_HOC_CHANNEL;
 
-- 
1.5.2.1

