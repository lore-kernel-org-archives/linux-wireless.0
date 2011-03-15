Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web57405.mail.re1.yahoo.com ([66.196.100.56]:47304 "HELO
	web57405.mail.re1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758012Ab1COPfE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2011 11:35:04 -0400
Message-ID: <6781.8657.qm@web57405.mail.re1.yahoo.com>
Date: Tue, 15 Mar 2011 08:35:01 -0700 (PDT)
From: Joe Gunn <armadefuego@yahoo.com>
Subject: Flag this message [PATCH 2.6.38-rc8-wl 1/1] orinoco: Clear dangling pointer on hardware busy
To: orinoco-devel@lists.sourceforge.net
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On hardware busy the scan request pointer should be cleared, as higher levels will release. This avoids a crash when that pointer is erroneously used later.

Signed-off-by: Joseph J. Gunn <armadefuego@yahoo.com>
---
When the hardware is busy the error is propagated to higher levels on the stack. Those layers release the buffer. Therefore the copy of the pointer must be erased. Otherwise subsequent events checking this pointer ma crash.
---
diff --git a/drivers/net/wireless/orinoco/cfg.c b/drivers/net/wireless/orinoco/cfg.c
index 09fae2f..1eff4dc 100644
--- a/drivers/net/wireless/orinoco/cfg.c
+++ b/drivers/net/wireless/orinoco/cfg.c
@@ -151,8 +151,18 @@ static int orinoco_scan(struct wiphy *wiphy, struct net_device *dev,
 		return -EBUSY;
 
 	priv->scan_request = request;
+	DEBUG(3, "orinoco_scan():"
+		" scan_request %p wiphy %p, dev %p\n",
+		priv->scan_request,
+		priv->scan_request->wiphy,
+		priv->scan_request->dev
+		);
 
 	err = orinoco_hw_trigger_scan(priv, request->ssids);
+	/* On EBUSY the hardware is busy. We aren't processing the request */
+	if ( err == -EBUSY) {
+		priv->scan_request = NULL;
+	}
 
 	return err;
 }
diff --git a/drivers/net/wireless/orinoco/scan.c b/drivers/net/wireless/orinoco/scan.c
index e99ca1c..698e9ff 100644
--- a/drivers/net/wireless/orinoco/scan.c
+++ b/drivers/net/wireless/orinoco/scan.c
@@ -230,6 +230,12 @@ void orinoco_add_hostscan_results(struct orinoco_private *priv,
 
  scan_abort:
 	if (priv->scan_request) {
+		DEBUG(3, "orinoco_add_hostscan_results():"
+			" scan_request %p wiphy %p, dev %p\n",
+			priv->scan_request,
+			priv->scan_request->wiphy,
+			priv->scan_request->dev
+			);
 		cfg80211_scan_done(priv->scan_request, abort);
 		priv->scan_request = NULL;
 	}
@@ -238,6 +244,12 @@ void orinoco_add_hostscan_results(struct orinoco_private *priv,
 void orinoco_scan_done(struct orinoco_private *priv, bool abort)
 {
 	if (priv->scan_request) {
+		DEBUG(3, "orinoco_scan_done():"
+			" scan_request %p, wiphy %p, dev %p\n",
+			priv->scan_request,
+			priv->scan_request->wiphy,
+			priv->scan_request->dev
+			);
 		cfg80211_scan_done(priv->scan_request, abort);
 		priv->scan_request = NULL;
 	}



      
