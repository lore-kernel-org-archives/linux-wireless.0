Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:17991 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754644AbZKZN4c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Nov 2009 08:56:32 -0500
From: Holger Schurig <holgerschurig@gmail.com>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: move more association code to assoc.c
Date: Thu, 26 Nov 2009 14:56:20 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200911261456.20476.holgerschurig@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <holgerschurig@gmail.com>


--- linux-wl.orig/drivers/net/wireless/libertas/assoc.c
+++ linux-wl/drivers/net/wireless/libertas/assoc.c
@@ -1943,7 +1943,7 @@ out:
 }
 
 
-void lbs_association_worker(struct work_struct *work)
+static void lbs_association_worker(struct work_struct *work)
 {
 	struct lbs_private *priv = container_of(work, struct lbs_private,
 		assoc_work.work);
@@ -2237,3 +2237,24 @@ int lbs_cmd_80211_deauthenticate(struct 
 	return ret;
 }
 
+
+void lbs_assoc_init(struct lbs_private *priv)
+{
+	lbs_deb_enter(LBS_DEB_ASSOC);
+
+	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
+	priv->mode = IW_MODE_INFRA;
+	priv->enablehwauto = 1;
+
+	lbs_deb_leave(LBS_DEB_ASSOC);
+}
+
+
+void lbs_assoc_deinit(struct lbs_private *priv)
+{
+	lbs_deb_enter(LBS_DEB_ASSOC);
+
+	cancel_delayed_work_sync(&priv->assoc_work);
+
+	lbs_deb_leave(LBS_DEB_ASSOC);
+}
--- linux-wl.orig/drivers/net/wireless/libertas/assoc.h
+++ linux-wl/drivers/net/wireless/libertas/assoc.h
@@ -124,7 +124,6 @@ struct assoc_request {
 
 extern u8 lbs_bg_rates[MAX_RATES];
 
-void lbs_association_worker(struct work_struct *work);
 struct assoc_request *lbs_get_association_request(struct lbs_private *priv);
 
 int lbs_adhoc_stop(struct lbs_private *priv);
@@ -152,4 +151,7 @@ int lbs_cmd_802_11_enable_rsn(struct lbs
 int lbs_cmd_802_11_key_material(struct lbs_private *priv, uint16_t cmd_action,
 				struct assoc_request *assoc);
 
+void lbs_assoc_init(struct lbs_private *priv);
+void lbs_assoc_deinit(struct lbs_private *priv);
+
 #endif /* _LBS_ASSOC_H */
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -818,13 +818,12 @@ static int lbs_init_adapter(struct lbs_p
 
 	memset(priv->current_addr, 0xff, ETH_ALEN);
 
+	lbs_assoc_init(priv);
 	priv->connect_status = LBS_DISCONNECTED;
 	priv->secinfo.auth_mode = IW_AUTH_ALG_OPEN_SYSTEM;
-	priv->mode = IW_MODE_INFRA;
 	priv->channel = DEFAULT_AD_HOC_CHANNEL;
 	priv->mac_control = CMD_ACT_MAC_RX_ON | CMD_ACT_MAC_TX_ON;
 	priv->radio_on = 1;
-	priv->enablehwauto = 1;
 	priv->psmode = LBS802_11POWERMODECAM;
 	priv->psstate = PS_STATE_FULL_POWER;
 	priv->is_deep_sleep = 0;
@@ -964,7 +963,6 @@ struct lbs_private *lbs_add_card(void *c
 	}
 
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
-	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
 	INIT_WORK(&priv->mcast_work, lbs_set_mcast_worker);
 
 	priv->wol_criteria = 0xffffffff;
@@ -1002,7 +1000,7 @@ void lbs_remove_card(struct lbs_private 
 
 	dev = priv->dev;
 
-	cancel_delayed_work_sync(&priv->assoc_work);
+	lbs_assoc_deinit(priv);
 	cancel_work_sync(&priv->mcast_work);
 
 	/* worker thread destruction blocks on the in-flight command which

-- 
http://www.holgerschurig.de
