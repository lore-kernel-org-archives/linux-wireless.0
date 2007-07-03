Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7708 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756425AbXGCPXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:23:55 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:23:49 +0200
Subject: [PATCH] libertas: remove adapter->scanmode
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031723.49485.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

scanmode was initialized with CMD_BSS_TYPE_ANY, but there is no code
that ever can store another value there, so it can go away.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/dev.h  |    1 -
 drivers/net/wireless/libertas/main.c |    3 ---
 drivers/net/wireless/libertas/scan.c |    6 ++----
 3 files changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 1b42fad..1002256 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -263,7 +263,6 @@ struct _wlan_adapter {
 	struct bss_descriptor *networks;
 
 	u8 scantype;
-	u32 scanmode;
 
 	u8 adhoccreate;
 
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 68aa9bc..0672bd6 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -998,9 +998,6 @@ static void wlan_init_adapter(wlan_private * priv)
 	/* scan type */
 	adapter->scantype = CMD_SCAN_TYPE_ACTIVE;
 
-	/* scan mode */
-	adapter->scanmode = CMD_BSS_TYPE_ANY;
-
 	/* 802.11 specific */
 	adapter->secinfo.wep_enabled = 0;
 	for (i = 0; i < sizeof(adapter->wep_keys) / sizeof(adapter->wep_keys[0]);
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 7e4b0ab..33ee459 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -361,7 +361,6 @@ wlan_scan_setup_scan_config(wlan_private * priv,
 			    u8 * pfilteredscan,
 			    u8 * pscancurrentonly)
 {
-	wlan_adapter *adapter = priv->adapter;
 	struct mrvlietypes_numprobes *pnumprobestlv;
 	struct mrvlietypes_ssidparamset *pssidtlv;
 	struct wlan_scan_cmd_config * pscancfgout = NULL;
@@ -412,8 +411,7 @@ wlan_scan_setup_scan_config(wlan_private * priv,
 
 		/* Set the bss type scan filter, use adapter setting if unset */
 		pscancfgout->bsstype =
-		    (puserscanin->bsstype ? puserscanin->bsstype : adapter->
-		     scanmode);
+		    puserscanin->bsstype ? puserscanin->bsstype : CMD_BSS_TYPE_ANY;
 
 		/* Set the number of probes to send, use adapter setting if unset */
 		numprobes = puserscanin->numprobes ? puserscanin->numprobes : 0;
@@ -448,7 +446,7 @@ wlan_scan_setup_scan_config(wlan_private * priv,
 			*pfilteredscan = 1;
 		}
 	} else {
-		pscancfgout->bsstype = adapter->scanmode;
+		pscancfgout->bsstype = CMD_BSS_TYPE_ANY;
 		numprobes = 0;
 	}
 
-- 
1.5.2.1

