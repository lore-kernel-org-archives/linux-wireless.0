Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7628 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbXGCPXY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:23:24 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:23:18 +0200
Subject: [PATCH] libertas: remove adapter->atimwindow
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031723.18548.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This varaible was initialized with 0 but there is no code that would ever
change it's value. So it can go away.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/dev.h  |    1 -
 drivers/net/wireless/libertas/join.c |    2 +-
 drivers/net/wireless/libertas/main.c |    3 ---
 3 files changed, 1 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 383d689..c52ce0b 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -303,7 +303,6 @@ struct _wlan_adapter {
 
 	/** POWER MANAGEMENT AND PnP SUPPORT */
 	u8 surpriseremoved;
-	u16 atimwindow;
 
 	u16 psmode;		/* Wlan802_11PowermodeCAM=disable
 				   Wlan802_11PowermodeMAX_PSP=enable */
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index 0803491..0bded0c 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -518,7 +518,7 @@ int libertas_cmd_80211_ad_hoc_start(wlan_private * priv,
 
 	adhs->ssparamset.ibssparamset.elementid = IBSS_PARA_IE_ID;
 	adhs->ssparamset.ibssparamset.len = IBSS_PARA_IE_LEN;
-	adhs->ssparamset.ibssparamset.atimwindow = cpu_to_le16(adapter->atimwindow);
+	adhs->ssparamset.ibssparamset.atimwindow = 0;
 
 	/* set capability info */
 	tmpcap = WLAN_CAPABILITY_IBSS;
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index d26df1a..8d09cf5 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -992,9 +992,6 @@ static void wlan_init_adapter(wlan_private * priv)
 	wlan_adapter *adapter = priv->adapter;
 	int i;
 
-	/* ATIM params */
-	adapter->atimwindow = 0;
-
 	adapter->connect_status = LIBERTAS_DISCONNECTED;
 	memset(adapter->current_addr, 0xff, ETH_ALEN);
 
-- 
1.5.2.1

