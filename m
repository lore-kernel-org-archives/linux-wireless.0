Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:10206 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbYA1Q0P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2008 11:26:15 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] libertas: make lbs_sync_channel() static
Date: Mon, 28 Jan 2008 17:26:28 +0100
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	Dan Williams <dcbw@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200801281726.28434.hs4233@mail.mn-solutions.de> (sfid-20080128_162619_026508_208B8F0B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... by moving it into the file where it's sole user resides

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/assoc.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/assoc.c	2008-01-18 10:42:26.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/assoc.c	2008-01-18 10:43:48.000000000 +0100
@@ -179,17 +179,6 @@ int lbs_update_channel(struct lbs_privat
 	return ret;
 }
 
-void lbs_sync_channel(struct work_struct *work)
-{
-	struct lbs_private *priv = container_of(work, struct lbs_private,
-		sync_channel);
-
-	lbs_deb_enter(LBS_DEB_ASSOC);
-	if (lbs_update_channel(priv))
-		lbs_pr_info("Channel synchronization failed.");
-	lbs_deb_leave(LBS_DEB_ASSOC);
-}
-
 static int assoc_helper_channel(struct lbs_private *priv,
                                 struct assoc_request * assoc_req)
 {
Index: wireless-2.6/drivers/net/wireless/libertas/assoc.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/assoc.h	2008-01-18 10:42:26.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/assoc.h	2008-01-18 10:43:49.000000000 +0100
@@ -7,6 +7,5 @@
 
 void lbs_association_worker(struct work_struct *work);
 struct assoc_request *lbs_get_association_request(struct lbs_private *priv);
-void lbs_sync_channel(struct work_struct *work);
 
 #endif /* _LBS_ASSOC_H */
Index: wireless-2.6/drivers/net/wireless/libertas/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/main.c	2008-01-18 10:42:26.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/libertas/main.c	2008-01-18 10:43:48.000000000 +0100
@@ -985,6 +985,18 @@ out:
 	lbs_deb_leave(LBS_DEB_CMD);
 }
 
+static void lbs_sync_channel_worker(struct work_struct *work)
+{
+	struct lbs_private *priv = container_of(work, struct lbs_private,
+		sync_channel);
+
+	lbs_deb_enter(LBS_DEB_MAIN);
+	if (lbs_update_channel(priv))
+		lbs_pr_info("Channel synchronization failed.");
+	lbs_deb_leave(LBS_DEB_MAIN);
+}
+
+
 static int lbs_init_adapter(struct lbs_private *priv)
 {
 	size_t bufsize;
@@ -1128,7 +1140,7 @@ struct lbs_private *lbs_add_card(void *c
 	priv->work_thread = create_singlethread_workqueue("lbs_worker");
 	INIT_DELAYED_WORK(&priv->assoc_work, lbs_association_worker);
 	INIT_DELAYED_WORK(&priv->scan_work, lbs_scan_worker);
-	INIT_WORK(&priv->sync_channel, lbs_sync_channel);
+	INIT_WORK(&priv->sync_channel, lbs_sync_channel_worker);
 
 	sprintf(priv->mesh_ssid, "mesh");
 	priv->mesh_ssid_len = 4;
