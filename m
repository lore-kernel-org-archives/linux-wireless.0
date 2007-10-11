Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:1612 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbXJKJut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Oct 2007 05:50:49 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] move wlan_*_association_work from header to c file
Date: Thu, 11 Oct 2007 11:51:06 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710111151.06989.hs4233@mail.mn-solutions.de> (sfid-20071011_105107_190402_EACEE679)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Move wlan_postpone_association_work() and wlan_cancel_association_work()
from a assoc.h file to the sole user, into wext.c.

In passing, rename the functions to libertas_XXX.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Index: wireless-2.6/drivers/net/wireless/libertas/assoc.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/assoc.h	2007-10-11 12:14:50.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/libertas/assoc.h	2007-10-11 12:44:12.000000000 +0200
@@ -11,22 +11,4 @@ struct assoc_request * wlan_get_associat
 
 void libertas_sync_channel(struct work_struct *work);
 
-#define ASSOC_DELAY (HZ / 2)
-static inline void wlan_postpone_association_work(wlan_private *priv)
-{
-	if (priv->adapter->surpriseremoved)
-		return;
-	cancel_delayed_work(&priv->assoc_work);
-	queue_delayed_work(priv->work_thread, &priv->assoc_work, ASSOC_DELAY);
-}
-
-static inline void wlan_cancel_association_work(wlan_private *priv)
-{
-	cancel_delayed_work(&priv->assoc_work);
-	if (priv->adapter->pending_assoc_req) {
-		kfree(priv->adapter->pending_assoc_req);
-		priv->adapter->pending_assoc_req = NULL;
-	}
-}
-
 #endif /* _WLAN_ASSOC_H */
Index: wireless-2.6/drivers/net/wireless/libertas/wext.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/libertas/wext.c	2007-10-11 12:14:50.000000000 +0200
+++ wireless-2.6/drivers/net/wireless/libertas/wext.c	2007-10-11 12:50:29.000000000 +0200
@@ -21,6 +21,24 @@
 #include "assoc.h"
 
 
+static inline void libertas_postpone_association_work(wlan_private *priv)
+{
+	if (priv->adapter->surpriseremoved)
+		return;
+	cancel_delayed_work(&priv->assoc_work);
+	queue_delayed_work(priv->work_thread, &priv->assoc_work, HZ / 2);
+}
+
+static inline void libertas_cancel_association_work(wlan_private *priv)
+{
+	cancel_delayed_work(&priv->assoc_work);
+	if (priv->adapter->pending_assoc_req) {
+		kfree(priv->adapter->pending_assoc_req);
+		priv->adapter->pending_assoc_req = NULL;
+	}
+}
+
+
 /**
  *  @brief Find the channel frequency power info with specific channel
  *
@@ -949,9 +967,9 @@ static int wlan_set_freq(struct net_devi
 out:
 	if (ret == 0) {
 		set_bit(ASSOC_FLAG_CHANNEL, &assoc_req->flags);
-		wlan_postpone_association_work(priv);
+		libertas_postpone_association_work(priv);
 	} else {
-		wlan_cancel_association_work(priv);
+		libertas_cancel_association_work(priv);
 	}
 	mutex_unlock(&adapter->lock);
 
@@ -1050,11 +1068,11 @@ static int wlan_set_mode(struct net_devi
 	assoc_req = wlan_get_association_request(adapter);
 	if (!assoc_req) {
 		ret = -ENOMEM;
-		wlan_cancel_association_work(priv);
+		libertas_cancel_association_work(priv);
 	} else {
 		assoc_req->mode = *uwrq;
 		set_bit(ASSOC_FLAG_MODE, &assoc_req->flags);
-		wlan_postpone_association_work(priv);
+		libertas_postpone_association_work(priv);
 		lbs_deb_wext("Switching to mode: 0x%x\n", *uwrq);
 	}
 	mutex_unlock(&adapter->lock);
@@ -1335,9 +1353,9 @@ static int wlan_set_encode(struct net_de
 out:
 	if (ret == 0) {
 		set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
-		wlan_postpone_association_work(priv);
+		libertas_postpone_association_work(priv);
 	} else {
-		wlan_cancel_association_work(priv);
+		libertas_cancel_association_work(priv);
 	}
 	mutex_unlock(&adapter->lock);
 
@@ -1576,9 +1594,9 @@ static int wlan_set_encodeext(struct net
 
 out:
 	if (ret == 0) {
-		wlan_postpone_association_work(priv);
+		libertas_postpone_association_work(priv);
 	} else {
-		wlan_cancel_association_work(priv);
+		libertas_cancel_association_work(priv);
 	}
 	mutex_unlock(&adapter->lock);
 
@@ -1623,9 +1641,9 @@ static int wlan_set_genie(struct net_dev
 out:
 	if (ret == 0) {
 		set_bit(ASSOC_FLAG_WPA_IE, &assoc_req->flags);
-		wlan_postpone_association_work(priv);
+		libertas_postpone_association_work(priv);
 	} else {
-		wlan_cancel_association_work(priv);
+		libertas_cancel_association_work(priv);
 	}
 	mutex_unlock(&adapter->lock);
 
@@ -1752,9 +1770,9 @@ out:
 	if (ret == 0) {
 		if (updated)
 			set_bit(ASSOC_FLAG_SECINFO, &assoc_req->flags);
-		wlan_postpone_association_work(priv);
+		libertas_postpone_association_work(priv);
 	} else if (ret != -EOPNOTSUPP) {
-		wlan_cancel_association_work(priv);
+		libertas_cancel_association_work(priv);
 	}
 	mutex_unlock(&adapter->lock);
 
@@ -1929,13 +1947,13 @@ out:
 			memcpy(&assoc_req->ssid, &ssid, IW_ESSID_MAX_SIZE);
 			assoc_req->ssid_len = ssid_len;
 			set_bit(ASSOC_FLAG_SSID, &assoc_req->flags);
-			wlan_postpone_association_work(priv);
+			libertas_postpone_association_work(priv);
 		}
 	}
 
 	/* Cancel the association request if there was an error */
 	if (ret != 0) {
-		wlan_cancel_association_work(priv);
+		libertas_cancel_association_work(priv);
 	}
 
 	mutex_unlock(&adapter->lock);
@@ -1973,13 +1991,13 @@ static int wlan_set_wap(struct net_devic
 	/* Get or create the current association request */
 	assoc_req = wlan_get_association_request(adapter);
 	if (!assoc_req) {
-		wlan_cancel_association_work(priv);
+		libertas_cancel_association_work(priv);
 		ret = -ENOMEM;
 	} else {
 		/* Copy the BSSID to the association request */
 		memcpy(&assoc_req->bssid, awrq->sa_data, ETH_ALEN);
 		set_bit(ASSOC_FLAG_BSSID, &assoc_req->flags);
-		wlan_postpone_association_work(priv);
+		libertas_postpone_association_work(priv);
 	}
 
 	mutex_unlock(&adapter->lock);
