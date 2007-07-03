Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:7652 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbXGCPXf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jul 2007 11:23:35 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
Date: Tue, 3 Jul 2007 17:23:28 +0200
Subject: [PATCH] libertas: remove adapter->listeninterval
To: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707031723.29034.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

listeninterval was initialized with MRVDRV_DEFAULT_LISTEN_INTERVAL, but
there exists that would ever change it. So we can use this define directly.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 drivers/net/wireless/libertas/dev.h  |    1 -
 drivers/net/wireless/libertas/join.c |    2 +-
 drivers/net/wireless/libertas/main.c |    2 --
 3 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/libertas/dev.h b/drivers/net/wireless/libertas/dev.h
index 5bb8e51..6675cc6 100644
--- a/drivers/net/wireless/libertas/dev.h
+++ b/drivers/net/wireless/libertas/dev.h
@@ -287,7 +287,6 @@ struct _wlan_adapter {
 	u32 fragthsd;
 	u32 rtsthsd;
 
-	u16 listeninterval;
 	u8 txretrycount;
 
 	/** Tx-related variables (for single packet tx) */
diff --git a/drivers/net/wireless/libertas/join.c b/drivers/net/wireless/libertas/join.c
index 0bded0c..e335a7e 100644
--- a/drivers/net/wireless/libertas/join.c
+++ b/drivers/net/wireless/libertas/join.c
@@ -369,7 +369,7 @@ int libertas_cmd_80211_associate(wlan_private * priv,
 	pos += sizeof(passo->peerstaaddr);
 
 	/* set the listen interval */
-	passo->listeninterval = cpu_to_le16(adapter->listeninterval);
+	passo->listeninterval = cpu_to_le16(MRVDRV_DEFAULT_LISTEN_INTERVAL);
 
 	pos += sizeof(passo->capability);
 	pos += sizeof(passo->listeninterval);
diff --git a/drivers/net/wireless/libertas/main.c b/drivers/net/wireless/libertas/main.c
index 8d09cf5..79e2748 100644
--- a/drivers/net/wireless/libertas/main.c
+++ b/drivers/net/wireless/libertas/main.c
@@ -1045,8 +1045,6 @@ static void wlan_init_adapter(wlan_private * priv)
 
 	adapter->psmode = WLAN802_11POWERMODECAM;
 
-	adapter->listeninterval = MRVDRV_DEFAULT_LISTEN_INTERVAL;
-
 	adapter->psstate = PS_STATE_FULL_POWER;
 	adapter->needtowakeup = 0;
 
-- 
1.5.2.1

