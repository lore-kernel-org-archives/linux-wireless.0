Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:65310 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604AbZLBOaJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2009 09:30:09 -0500
Received: by mail-bw0-f227.google.com with SMTP id 27so217224bwz.21
        for <linux-wireless@vger.kernel.org>; Wed, 02 Dec 2009 06:30:15 -0800 (PST)
Message-Id: <20091202142942.015170962@gmail.com>
References: <20091202142555.654873300@gmail.com>
Date: Wed, 02 Dec 2009 15:26:01 +0100
From: Holger Schurig <holgerschurig@googlemail.com>
To: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Dan Williams <dcbw@redhat.com>
Subject: [PATCH 06/10] libertas: add access functions for mesh open/connect status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>

---
v2: define was in two lines


---
 drivers/net/wireless/libertas/cmd.c  |    2 +-
 drivers/net/wireless/libertas/main.c |    5 ++---
 drivers/net/wireless/libertas/mesh.c |    3 ++-
 drivers/net/wireless/libertas/mesh.h |    6 ++++++
 drivers/net/wireless/libertas/scan.c |    2 +-
 drivers/net/wireless/libertas/tx.c   |    2 +-
 drivers/net/wireless/libertas/wext.c |    6 +++---
 7 files changed, 16 insertions(+), 10 deletions(-)

--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -123,7 +123,7 @@ static ssize_t lbs_rtap_set(struct devic
 		if (priv->monitormode == monitor_mode)
 			return strlen(buf);
 		if (!priv->monitormode) {
-			if (priv->infra_open || priv->mesh_open)
+			if (priv->infra_open || lbs_mesh_open(priv))
 				return -EBUSY;
 			if (priv->mode == IW_MODE_INFRA)
 				lbs_cmd_80211_deauthenticate(priv,
@@ -619,7 +619,7 @@ static int lbs_thread(void *data)
 				if (priv->connect_status == LBS_CONNECTED)
 					netif_wake_queue(priv->dev);
 				if (priv->mesh_dev &&
-				    priv->mesh_connect_status == LBS_CONNECTED)
+				    lbs_mesh_connected(priv))
 					netif_wake_queue(priv->mesh_dev);
 			}
 		}
@@ -833,7 +833,6 @@ static int lbs_init_adapter(struct lbs_p
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 
 	priv->connect_status = LBS_DISCONNECTED;
-	priv->mesh_connect_status = LBS_DISCONNECTED;
 	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
 	priv->mode = IW_MODE_INFRA;
 	priv->channel = DEFAULT_AD_HOC_CHANNEL;
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.c
+++ linux-wl/drivers/net/wireless/libertas/mesh.c
@@ -1,4 +1,3 @@
-#include <linux/moduleparam.h>
 #include <linux/delay.h>
 #include <linux/etherdevice.h>
 #include <linux/netdevice.h>
@@ -196,6 +195,8 @@ int lbs_init_mesh(struct lbs_private *pr
 
 	lbs_deb_enter(LBS_DEB_MESH);
 
+	priv->mesh_connect_status = LBS_DISCONNECTED;
+
 	/* Determine mesh_fw_ver from fwrelease and fwcapinfo */
 	/* 5.0.16p0 9.0.0.p0 is known to NOT support any mesh */
 	/* 5.110.22 have mesh command with 0xa3 command id */
--- linux-wl.orig/drivers/net/wireless/libertas/mesh.h
+++ linux-wl/drivers/net/wireless/libertas/mesh.h
@@ -84,4 +84,10 @@ void lbs_mesh_ethtool_get_strings(struct
 	uint32_t stringset, uint8_t *s);
 
 
+/* Accessors */
+
+#define lbs_mesh_open(priv) (priv->mesh_open)
+#define lbs_mesh_connected(priv) (priv->mesh_connect_status == LBS_CONNECTED)
+
+
 #endif
--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -1304,7 +1304,7 @@ int lbs_execute_next_command(struct lbs_
 		if ((priv->psmode != LBS802_11POWERMODECAM) &&
 		    (priv->psstate == PS_STATE_FULL_POWER) &&
 		    ((priv->connect_status == LBS_CONNECTED) ||
-		    (priv->mesh_connect_status == LBS_CONNECTED))) {
+		    lbs_mesh_connected(priv))) {
 			if (priv->secinfo.WPAenabled ||
 			    priv->secinfo.WPA2enabled) {
 				/* check for valid WPA group keys */
--- linux-wl.orig/drivers/net/wireless/libertas/scan.c
+++ linux-wl/drivers/net/wireless/libertas/scan.c
@@ -640,7 +640,7 @@ out:
 		if (!priv->tx_pending_len)
 			netif_wake_queue(priv->dev);
 	}
-	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED)) {
+	if (priv->mesh_dev && lbs_mesh_connected(priv)) {
 		netif_carrier_on(priv->mesh_dev);
 		if (!priv->tx_pending_len)
 			netif_wake_queue(priv->mesh_dev);
--- linux-wl.orig/drivers/net/wireless/libertas/tx.c
+++ linux-wl/drivers/net/wireless/libertas/tx.c
@@ -198,7 +198,7 @@ void lbs_send_tx_feedback(struct lbs_pri
 	if (priv->connect_status == LBS_CONNECTED)
 		netif_wake_queue(priv->dev);
 
-	if (priv->mesh_dev && (priv->mesh_connect_status == LBS_CONNECTED))
+	if (priv->mesh_dev && lbs_mesh_connected(priv))
 		netif_wake_queue(priv->mesh_dev);
 }
 EXPORT_SYMBOL_GPL(lbs_send_tx_feedback);
--- linux-wl.orig/drivers/net/wireless/libertas/wext.c
+++ linux-wl/drivers/net/wireless/libertas/wext.c
@@ -192,7 +192,7 @@ static void copy_active_data_rates(struc
 	lbs_deb_enter(LBS_DEB_WEXT);
 
 	if ((priv->connect_status != LBS_CONNECTED) &&
-		(priv->mesh_connect_status != LBS_CONNECTED))
+		!lbs_mesh_connected(priv))
 		memcpy(rates, lbs_bg_rates, MAX_RATES);
 	else
 		memcpy(rates, priv->curbssparams.rates, MAX_RATES);
@@ -307,7 +307,7 @@ static int mesh_get_nick(struct net_devi
 
 	/* Use nickname to indicate that mesh is on */
 
-	if (priv->mesh_connect_status == LBS_CONNECTED) {
+	if (lbs_mesh_connected(priv)) {
 		strncpy(extra, "Mesh", 12);
 		extra[12] = '\0';
 		dwrq->length = strlen(extra);
@@ -863,7 +863,7 @@ static struct iw_statistics *lbs_get_wir
 
 	/* If we're not associated, all quality values are meaningless */
 	if ((priv->connect_status != LBS_CONNECTED) &&
-	    (priv->mesh_connect_status != LBS_CONNECTED))
+	    !lbs_mesh_connected(priv))
 		goto out;
 
 	/* Quality by RSSI */

-- 
