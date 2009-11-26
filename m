Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:37059 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752808AbZKZJn2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 04:43:28 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 1/6] libertas: remove mesh_autostart_enabled and sync_channel
Date: Thu, 26 Nov 2009 10:43:18 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911261043.18094.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mesh_autostart_enabled was nowhere set. Rumor is that this is used in the
OLPC tree, but they never did submit their code upstream.

After removing this code, it turned out that the sync_channel stuff is now
also unused, so get rid of that as well.

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>


--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -485,20 +485,8 @@ int lbs_process_event(struct lbs_private
 		break;
 
 	case MACREG_INT_CODE_MESH_AUTO_STARTED:
-		/* Ignore spurious autostart events if autostart is disabled */
-		if (!priv->mesh_autostart_enabled) {
-			lbs_pr_info("EVENT: MESH_AUTO_STARTED (ignoring)\n");
-			break;
-		}
-		lbs_pr_info("EVENT: MESH_AUTO_STARTED\n");
-		priv->mesh_connect_status = LBS_CONNECTED;
-		if (priv->mesh_open) {
-			netif_carrier_on(priv->mesh_dev);
-			if (!priv->tx_pending_len)
-				netif_wake_queue(priv->mesh_dev);
-		}
-		priv->mode = IW_MODE_ADHOC;
-		schedule_work(&priv->sync_channel);
+		/* Ignore spurious autostart events */
+		lbs_pr_info("EVENT: MESH_AUTO_STARTED (ignoring)\n");
 		break;
 
 	default:
--- linux-wl.orig/drivers/net/wireless/libertas/dev.h
+++ linux-wl/drivers/net/wireless/libertas/dev.h
@@ -42,11 +42,9 @@ struct lbs_private {
 	u32 mesh_connect_status;
 	struct lbs_mesh_stats mstats;
 	int mesh_open;
-	int mesh_autostart_enabled;
 	uint16_t mesh_tlv;
 	u8 mesh_ssid[IEEE80211_MAX_SSID_LEN + 1];
 	u8 mesh_ssid_len;
-	struct work_struct sync_channel;
 
 	/* Monitor mode */
 	struct net_device *rtap_net_dev;
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -806,18 +806,6 @@ int lbs_exit_auto_deep_sleep(struct lbs_
 	return 0;
 }
 
-static void lbs_sync_channel_worker(struct work_struct *work)
-{
-	struct lbs_private *priv = container_of(work, struct lbs_private,
-		sync_channel);
-
-	lbs_deb_enter(LBS_DEB_MAIN);
-	if (lbs_update_channel(priv))
-		lbs_pr_info("Channel synchronization failed.");
-	lbs_deb_leave(LBS_DEB_MAIN);
-}
-
-
 static int lbs_init_adapter(struct lbs_private *priv)
 {
 	size_t bufsize;
@@ -997,7 +985,6 @@ struct lbs_private *lbs_add_card(void *c
 	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
 	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
-	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
 
 	priv->mesh_open = 0;
 	sprintf(priv->mesh_ssid, "mesh");

-- 
http://www.holgerschurig.de
