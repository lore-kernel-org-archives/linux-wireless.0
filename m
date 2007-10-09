Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:18810 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037AbXJIMEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Oct 2007 08:04:24 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org, libertas-dev@lists.infradead.org,
	Dan Williams <dcbw@redhat.com>
Subject: [PATCH] libertas: automatically re-associate
Date: Tue, 9 Oct 2007 14:04:31 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200710091404.31491.hs4233@mail.mn-solutions.de> (sfid-20071009_130430_289485_A3E14ECA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Automatically re-association to an access point when we get de-associated.
This is especially helpful if an AP de-associates us because scanning took
to long (remember, the my firmware can't send 802.11 powersafe null packets).

* don't free pending_assoc_req in the association worker, keep it as is.
* free pending_assoc_req at adapter removal time.
* when we get a MAC level event saying that we've been de-associated, use
  the alredy filled in association record to make a new scan and
  re-associate.
* also moved wlan_postpone_association_work() and
  wlan_cancel_association_work() from a *.h file to the sole user, into
  wext.h. Renamed them to libertas_XXX as well.

Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

---

BTW, I've done a little bit of research (err, trying out). At least
orinoco_cs, ipw2200 and bcm43xx all automatically re-associate.

Months ago Dan once said that I should add some logic to not re-associate
more than X times to an AP. So far I don't know of any fullmac driver that
does is. Also I think that this makes things needlessly complicated. And it
buys us nothing. If an AP really doesn't want to have a client not associated
to itself, it should apply better means, e.g. WPA/WPA2 ...

Index: libertas-2.6/drivers/net/wireless/libertas/assoc.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/assoc.c	2007-10-09 14:39:30.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/assoc.c	2007-10-09 14:48:49.000000000 +0200
@@ -506,7 +506,6 @@ void libertas_association_worker(struct 
 
 	mutex_lock(&adapter->lock);
 	assoc_req = adapter->pending_assoc_req;
-	adapter->pending_assoc_req = NULL;
 	adapter->in_progress_assoc_req = assoc_req;
 	mutex_unlock(&adapter->lock);
 
@@ -675,7 +674,6 @@ out:
 	mutex_lock(&adapter->lock);
 	adapter->in_progress_assoc_req = NULL;
 	mutex_unlock(&adapter->lock);
-	kfree(assoc_req);
 
 done:
 	lbs_deb_leave(LBS_DEB_ASSOC);
Index: libertas-2.6/drivers/net/wireless/libertas/assoc.h
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/assoc.h	2007-10-09 14:38:33.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/assoc.h	2007-10-09 14:48:49.000000000 +0200
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
Index: libertas-2.6/drivers/net/wireless/libertas/cmdresp.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/cmdresp.c	2007-10-09 14:38:33.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/cmdresp.c	2007-10-09 14:49:05.000000000 +0200
@@ -79,6 +79,13 @@ void libertas_mac_event_disconnected(wla
 		lbs_deb_cmd("disconnected, so exit PS mode\n");
 		libertas_ps_wakeup(priv, 0);
 	}
+
+	if (adapter->pending_assoc_req) {
+		cancel_delayed_work(&priv->assoc_work);
+		queue_delayed_work(priv->work_thread,
+			&priv->assoc_work, HZ / 4);
+	}
+
 	lbs_deb_leave(LBS_DEB_CMD);
 }
 
Index: libertas-2.6/drivers/net/wireless/libertas/main.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/main.c	2007-10-09 14:38:33.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/main.c	2007-10-09 14:48:49.000000000 +0200
@@ -460,11 +460,17 @@ static int libertas_open(struct net_devi
 static int libertas_dev_close(struct net_device *dev)
 {
 	wlan_private *priv = dev->priv;
+	wlan_adapter *adapter = priv->adapter;
 
 	lbs_deb_enter(LBS_DEB_NET);
 
-	netif_carrier_off(priv->dev);
+	mutex_lock(&adapter->lock);
 	priv->open = 0;
+	adapter->connect_status = LIBERTAS_DISCONNECTED;
+	kfree(adapter->pending_assoc_req);
+	adapter->pending_assoc_req = NULL;
+	mutex_unlock(&adapter->lock);
+	netif_carrier_off(priv->dev);
 
 	lbs_deb_leave(LBS_DEB_NET);
 	return 0;
@@ -1103,15 +1109,10 @@ static void libertas_free_adapter(wlan_p
 		return;
 	}
 
-	lbs_deb_fw("free command buffer\n");
 	libertas_free_cmd_buffer(priv);
-
-	lbs_deb_fw("free command_timer\n");
 	del_timer(&adapter->command_timer);
-
-	lbs_deb_fw("free scan results table\n");
 	kfree(adapter->networks);
-	adapter->networks = NULL;
+	kfree(adapter->pending_assoc_req);
 
 	/* Free the adapter object itself */
 	lbs_deb_fw("free adapter\n");
Index: libertas-2.6/drivers/net/wireless/libertas/wext.c
===================================================================
--- libertas-2.6.orig/drivers/net/wireless/libertas/wext.c	2007-10-09 14:38:33.000000000 +0200
+++ libertas-2.6/drivers/net/wireless/libertas/wext.c	2007-10-09 14:48:49.000000000 +0200
@@ -21,6 +21,20 @@
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
+}
+
+
 /**
  *  @brief Find the channel frequency power info with specific channel
  *
@@ -969,9 +983,9 @@ static int wlan_set_freq(struct net_devi
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
 
@@ -1070,11 +1084,11 @@ static int wlan_set_mode(struct net_devi
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
@@ -1355,9 +1369,9 @@ static int wlan_set_encode(struct net_de
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
 
@@ -1596,9 +1610,9 @@ static int wlan_set_encodeext(struct net
 
 out:
 	if (ret == 0) {
-		wlan_postpone_association_work(priv);
+		libertas_postpone_association_work(priv);
 	} else {
-		wlan_cancel_association_work(priv);
+		libertas_cancel_association_work(priv);
 	}
 	mutex_unlock(&adapter->lock);
 
@@ -1643,9 +1657,9 @@ static int wlan_set_genie(struct net_dev
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
 
@@ -1772,9 +1786,9 @@ out:
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
 
@@ -1949,13 +1963,13 @@ out:
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
@@ -1993,13 +2007,13 @@ static int wlan_set_wap(struct net_devic
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
