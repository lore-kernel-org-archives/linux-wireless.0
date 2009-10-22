Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:2996 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbZJVNfi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Oct 2009 09:35:38 -0400
Message-Id: <20091022133419.553612632@mail.mn-solutions.de>
References: <20091022133043.185554096@mail.mn-solutions.de>
Date: Thu, 22 Oct 2009 15:30:57 +0200
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH 14/19] libertas: move mic failure event to wext.c
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... because for cfg80211 we'll need a completely different
implementation.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

--- linux-wl.orig/drivers/net/wireless/libertas/cmdresp.c
+++ linux-wl/drivers/net/wireless/libertas/cmdresp.c
@@ -73,32 +73,6 @@
 	lbs_deb_leave(LBS_DEB_ASSOC);
 }
 
-/**
- *  @brief This function handles MIC failure event.
- *
- *  @param priv    A pointer to struct lbs_private structure
- *  @para  event   the event id
- *  @return 	   n/a
- */
-static void handle_mic_failureevent(struct lbs_private *priv, u32 event)
-{
-	char buf[50];
-
-	lbs_deb_enter(LBS_DEB_CMD);
-	memset(buf, 0, sizeof(buf));
-
-	sprintf(buf, "%s", "MLME-MICHAELMICFAILURE.indication ");
-
-	if (event == MACREG_INT_CODE_MIC_ERR_UNICAST) {
-		strcat(buf, "unicast ");
-	} else {
-		strcat(buf, "multicast ");
-	}
-
-	lbs_send_iwevcustom_event(priv, buf);
-	lbs_deb_leave(LBS_DEB_CMD);
-}
-
 static int lbs_ret_reg_access(struct lbs_private *priv,
 			       u16 type, struct cmd_ds_command *resp)
 {
@@ -477,12 +451,12 @@
 
 	case MACREG_INT_CODE_MIC_ERR_UNICAST:
 		lbs_deb_cmd("EVENT: UNICAST MIC ERROR\n");
-		handle_mic_failureevent(priv, MACREG_INT_CODE_MIC_ERR_UNICAST);
+		lbs_send_mic_failureevent(priv, event);
 		break;
 
 	case MACREG_INT_CODE_MIC_ERR_MULTICAST:
 		lbs_deb_cmd("EVENT: MULTICAST MIC ERROR\n");
-		handle_mic_failureevent(priv, MACREG_INT_CODE_MIC_ERR_MULTICAST);
+		lbs_send_mic_failureevent(priv, event);
 		break;
 
 	case MACREG_INT_CODE_MIB_CHANGED:
--- linux-wl.orig/drivers/net/wireless/libertas/wext.c
+++ linux-wl/drivers/net/wireless/libertas/wext.c
@@ -54,7 +54,7 @@
 	wireless_send_event(priv->dev, SIOCGIWAP, &wrqu, NULL);
 }
 
-void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
+static void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str)
 {
 	union iwreq_data iwrq;
 	u8 buf[50];
@@ -79,6 +79,31 @@
 }
 
 /**
+ *  @brief This function handles MIC failure event.
+ *
+ *  @param priv    A pointer to struct lbs_private structure
+ *  @para  event   the event id
+ *  @return 	   n/a
+ */
+void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event)
+{
+	char buf[50];
+
+	lbs_deb_enter(LBS_DEB_CMD);
+	memset(buf, 0, sizeof(buf));
+
+	sprintf(buf, "%s", "MLME-MICHAELMICFAILURE.indication ");
+
+	if (event == MACREG_INT_CODE_MIC_ERR_UNICAST)
+		strcat(buf, "unicast ");
+	else
+		strcat(buf, "multicast ");
+
+	lbs_send_iwevcustom_event(priv, buf);
+	lbs_deb_leave(LBS_DEB_CMD);
+}
+
+/**
  *  @brief Find the channel frequency power info with specific channel
  *
  *  @param priv 	A pointer to struct lbs_private structure
--- linux-wl.orig/drivers/net/wireless/libertas/wext.h
+++ linux-wl/drivers/net/wireless/libertas/wext.h
@@ -5,7 +5,7 @@
 #define	_LBS_WEXT_H_
 
 void lbs_send_disconnect_notification(struct lbs_private *priv);
-void lbs_send_iwevcustom_event(struct lbs_private *priv, s8 *str);
+void lbs_send_mic_failureevent(struct lbs_private *priv, u32 event);
 
 extern struct iw_handler_def lbs_handler_def;
 extern struct iw_handler_def mesh_handler_def;

-- 
