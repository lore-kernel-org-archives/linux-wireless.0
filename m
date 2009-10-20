Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:2743 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbZJTMjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 08:39:51 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: "linux-wireless" <linux-wireless@vger.kernel.org>
Subject: [PATCH, v2] libertas: move SIOCGIWAP calls to wext.c
Date: Tue, 20 Oct 2009 14:39:31 +0200
Cc: John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
References: <200910191504.36726.hs4233@mail.mn-solutions.de>
In-Reply-To: <200910191504.36726.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200910201439.31384.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---
v1: Less and less files now depend on WEXT :-)
v2: fix compilation issue

--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -27,23 +27,18 @@
  */
 void lbs_mac_event_disconnected(struct lbs_private *priv)
 {
-	union iwreq_data wrqu;
-
 	if (priv->connect_status != LBS_CONNECTED)
 		return;
 
 	lbs_deb_enter(LBS_DEB_ASSOC);
 
-	memset(wrqu.ap_addr.sa_data, 0x00, ETH_ALEN);
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 
 	/*
 	 * Cisco AP sends EAP failure and de-auth in less than 0.5 ms.
 	 * It causes problem in the Supplicant
 	 */
-
 	msleep_interruptible(1000);
-	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
+	lbs_send_disconnect_notification(priv);
 
 	/* report disconnect to upper layer */
 	netif_stop_queue(priv->dev);
--- linux-wl.orig/drivers/net/wireless/libertas/main.c
+++ linux-wl/drivers/net/wireless/libertas/main.c
@@ -1227,7 +1227,6 @@
 void lbs_remove_card(struct lbs_private *priv)
 {
 	struct net_device *dev = priv->dev;
-	union iwreq_data wrqu;
 
 	lbs_deb_enter(LBS_DEB_MAIN);
 
@@ -1252,9 +1251,7 @@
 		lbs_ps_wakeup(priv, CMD_OPTION_WAITFORRSP);
 	}
 
-	memset(wrqu.ap_addr.sa_data, 0xaa, ETH_ALEN);
-	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
+	lbs_send_disconnect_notification(priv);
 
 	if (priv->is_deep_sleep) {
 		priv->is_deep_sleep = 0;
--- linux-wl.orig/drivers/net/wireless/libertas/wext.c
+++ linux-wl/drivers/net/wireless/libertas/wext.c
@@ -45,6 +45,15 @@
 	priv->pending_assoc_req = NULL;
 }
 
+void lbs_send_disconnect_notification(struct lbs_private *priv)
+{
+	union iwreq_data wrqu;
+
+	memset(wrqu.ap_addr.sa_data, 0x00, ETH_ALEN);
+	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
+}
+
 void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
 {
 	union iwreq_data iwrq;
--- linux-wl.orig/drivers/net/wireless/libertas/wext.h
+++ linux-wl/drivers/net/wireless/libertas/wext.h
@@ -4,6 +4,7 @@
 #ifndef	_LBS_WEXT_H_
 #define	_LBS_WEXT_H_
 
+void lbs_send_disconnect_notification(struct lbs_private *priv);
 void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str);
 
 extern struct iw_handler_def lbs_handler_def;


-- 
http://www.holgerschurig.de
