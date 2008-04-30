Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:21031 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935AbYD3Ixg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Apr 2008 04:53:36 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org, Dan Williams <dcbw@redhat.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: make some functions void
Date: Wed, 30 Apr 2008 10:50:39 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804301050.39792.hs4233@mail.mn-solutions.de> (sfid-20080430_105328_887510_A60014AC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They don't return anything meaningfull and no-one cares about their results.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-testing/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/main.c	2008-04-30 09:24:05.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/main.c	2008-04-30 09:28:50.000000000 +0200
@@ -890,7 +890,7 @@ int lbs_suspend(struct lbs_private *priv
 }
 EXPORT_SYMBOL_GPL(lbs_suspend);
 
-int lbs_resume(struct lbs_private *priv)
+void lbs_resume(struct lbs_private *priv)
 {
 	lbs_deb_enter(LBS_DEB_FW);
 
@@ -906,7 +906,6 @@ int lbs_resume(struct lbs_private *priv)
 		netif_device_attach(priv->mesh_dev);
 
 	lbs_deb_leave(LBS_DEB_FW);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(lbs_resume);
 
@@ -1155,7 +1154,7 @@ done:
 EXPORT_SYMBOL_GPL(lbs_add_card);
 
 
-int lbs_remove_card(struct lbs_private *priv)
+void lbs_remove_card(struct lbs_private *priv)
 {
 	struct net_device *dev = priv->dev;
 	union iwreq_data wrqu;
@@ -1190,7 +1189,6 @@ int lbs_remove_card(struct lbs_private *
 	free_netdev(dev);
 
 	lbs_deb_leave(LBS_DEB_MAIN);
-	return 0;
 }
 EXPORT_SYMBOL_GPL(lbs_remove_card);
 
@@ -1261,10 +1259,9 @@ done:
 EXPORT_SYMBOL_GPL(lbs_start_card);
 
 
-int lbs_stop_card(struct lbs_private *priv)
+void lbs_stop_card(struct lbs_private *priv)
 {
 	struct net_device *dev = priv->dev;
-	int ret = -1;
 	struct cmd_ctrl_node *cmdnode;
 	unsigned long flags;
 
@@ -1289,8 +1286,7 @@ int lbs_stop_card(struct lbs_private *pr
 
 	unregister_netdev(dev);
 
-	lbs_deb_leave_args(LBS_DEB_MAIN, "ret %d", ret);
-	return ret;
+	lbs_deb_leave(LBS_DEB_MAIN);
 }
 EXPORT_SYMBOL_GPL(lbs_stop_card);
 
Index: wireless-testing/drivers/net/wireless/libertas/decl.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/decl.h	2008-04-30 09:24:05.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/decl.h	2008-04-30 09:26:45.000000000 +0200
@@ -64,9 +64,9 @@ void lbs_send_iwevcustom_event(struct lb
 struct chan_freq_power *lbs_get_region_cfp_table(u8 region,
 	int *cfp_no);
 struct lbs_private *lbs_add_card(void *card, struct device *dmdev);
-int lbs_remove_card(struct lbs_private *priv);
+void lbs_remove_card(struct lbs_private *priv);
 int lbs_start_card(struct lbs_private *priv);
-int lbs_stop_card(struct lbs_private *priv);
+void lbs_stop_card(struct lbs_private *priv);
 void lbs_host_to_card_done(struct lbs_private *priv);
 
 int lbs_update_channel(struct lbs_private *priv);
Index: wireless-testing/drivers/net/wireless/libertas/cmd.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/libertas/cmd.h	2008-04-30 09:29:13.000000000 +0200
+++ wireless-testing/drivers/net/wireless/libertas/cmd.h	2008-04-30 09:29:18.000000000 +0200
@@ -44,7 +44,7 @@ int lbs_mesh_config(struct lbs_private *
 
 int lbs_host_sleep_cfg(struct lbs_private *priv, uint32_t criteria);
 int lbs_suspend(struct lbs_private *priv);
-int lbs_resume(struct lbs_private *priv);
+void lbs_resume(struct lbs_private *priv);
 
 int lbs_cmd_802_11_inactivity_timeout(struct lbs_private *priv,
 				      uint16_t cmd_action, uint16_t *timeout);
