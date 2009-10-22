Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:9957 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755597AbZJVNfJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:35:09 -0400
Message-Id: <20091022133413.281617538@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
Date: Thu, 22 Oct 2009 15:30:52 +0200
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 09/19] libertas: move lbs_send_iwevcustom_event() to wext.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... because it's purely a WEXT function.

No functional change.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/cmd.c
+++ linux-wl/drivers/net/wireless/libertas/cmd.c
@@ -1543,30 +1543,6 @@
 	return ret;
 }
 
-void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
-{
-	union iwreq_data iwrq;
-	u8 buf[50];
-
-	lbs_deb_enter(LBS_DEB_WEXT);
-
-	memset(&iwrq, 0, sizeof(union iwreq_data));
-	memset(buf, 0, sizeof(buf));
-
-	snprintf(buf, sizeof(buf) - 1, "%s", str);
-
-	iwrq.data.length = strlen(buf) + 1 + IW_EV_LCP_LEN;
-
-	/* Send Event to upper layer */
-	lbs_deb_wext("event indication string %s\n", (char *)buf);
-	lbs_deb_wext("event indication length %d\n", iwrq.data.length);
-	lbs_deb_wext("sending wireless event IWEVCUSTOM for %s\n", str);
-
-	wireless_send_event(priv->dev, IWEVCUSTOM, &iwrq, buf);
-
-	lbs_deb_leave(LBS_DEB_WEXT);
-}
-
 static void lbs_send_confirmsleep(struct lbs_private *priv)
 {
 	unsigned long flags;
--- linux-wl.orig/drivers/net/wireless/libertas/decl.h
+++ linux-wl/drivers/net/wireless/libertas/decl.h
@@ -44,8 +44,6 @@
 	u8 band,
 	u16 channel);
 
-void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str);
-
 /* persistcfg.c */
 void lbs_persist_config_init(struct net_device *net);
 void lbs_persist_config_remove(struct net_device *net);
--- linux-wl.orig/drivers/net/wireless/libertas/wext.c
+++ linux-wl/drivers/net/wireless/libertas/wext.c
@@ -45,6 +45,30 @@
 	priv->pending_assoc_req = NULL;
 }
 
+void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
+{
+	union iwreq_data iwrq;
+	u8 buf[50];
+
+	lbs_deb_enter(LBS_DEB_WEXT);
+
+	memset(&iwrq, 0, sizeof(union iwreq_data));
+	memset(buf, 0, sizeof(buf));
+
+	snprintf(buf, sizeof(buf) - 1, "%s", str);
+
+	iwrq.data.length = strlen(buf) + 1 + IW_EV_LCP_LEN;
+
+	/* Send Event to upper layer */
+	lbs_deb_wext("event indication string %s\n", (char *)buf);
+	lbs_deb_wext("event indication length %d\n", iwrq.data.length);
+	lbs_deb_wext("sending wireless event IWEVCUSTOM for %s\n", str);
+
+	wireless_send_event(priv->dev, IWEVCUSTOM, &iwrq, buf);
+
+	lbs_deb_leave(LBS_DEB_WEXT);
+}
+
 /**
  *  @brief Find the channel frequency power info with specific channel
  *
--- linux-wl.orig/drivers/net/wireless/libertas/wext.h
+++ linux-wl/drivers/net/wireless/libertas/wext.h
@@ -4,6 +4,8 @@
 #ifndef	_LBS_WEXT_H_
 #define	_LBS_WEXT_H_
 
+void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str);
+
 extern struct iw_handler_def lbs_handler_def;
 extern struct iw_handler_def mesh_handler_def;
 

-- 
