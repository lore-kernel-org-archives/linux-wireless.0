Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7729 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756710AbXGCPYD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:24:03 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:23:55 +0200
Subject: [PATCH] libertas: remove adapter->scantype
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031723.55503.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

scantype was initialized with CMD_SCAN_TYPE_ACTIVE, but there is no code
that would ever change it, so we can use that variable directly.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/dev.h  |    2 --
 drivers/net/wireless/libertas/main.c |    3 ---
 drivers/net/wireless/libertas/scan.c |    2 +-
 3 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 1002256..cfb6d71 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -262,8 +262,6 @@ struct _wlan_adapter {
 	struct list_head network_free_list;
 	struct bss_descriptor *networks;
 
-	u8 scantype;
-
 	u8 adhoccreate;
 
 	/** capability Info used in Association, start, join */
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 0672bd6..1548760 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -995,9 +995,6 @@ static void wlan_init_adapter(wlan_private * priv)
 	adapter->connect_status = LIBERTAS_DISCONNECTED;
 	memset(adapter->current_addr, 0xff, ETH_ALEN);
 
-	/* scan type */
-	adapter->scantype = CMD_SCAN_TYPE_ACTIVE;
-
 	/* 802.11 specific */
 	adapter->secinfo.wep_enabled = 0;
 	for (i = 0; i < sizeof(adapter->wep_keys) / sizeof(adapter->wep_keys[0]);
diff --git a/drivers/net/wireless/libertas/scan.c b/drivers/net/wireless/libertas/scan.c
index 33ee459..4f621a6 100644
--- a/drivers/net/wireless/libertas/scan.c
+++ b/drivers/net/wireless/libertas/scan.c
@@ -252,7 +252,7 @@ static void wlan_scan_create_channel_list(wlan_private * priv,
 	 *   be changed to passive on a per channel basis if restricted by
 	 *   regulatory requirements (11d or 11h)
 	 */
-	scantype = adapter->scantype;
+	scantype = CMD_SCAN_TYPE_ACTIVE;
 
 	for (rgnidx = 0; rgnidx < ARRAY_SIZE(adapter->region_channel); rgnidx++) {
 		if (priv->adapter->enable11d &&
-- 
1.5.2.1

