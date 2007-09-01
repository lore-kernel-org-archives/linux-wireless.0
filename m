Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:8008 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbXIAEgd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:36:33 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 4A180618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:36:32 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 24/35] Do implicit scanning only with current ESSID
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:36:31 -0400
Message-ID: <20070901043631.2498.41986.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This should speed up association.  We don't need non-matching APs if
ESSID is set.

For user-requested scanning, scan for any essid after that.  For
international scanning, start with scan_runs 1, as it was meant to be
done.  Actually use ir_step 0 for international scanning.  Adjust debug
messages correspondingly.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 0873111..98960eb 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -3871,9 +3871,9 @@ static void at76_dwork_get_scan(struct work_struct *work)
 					 sizeof(mdomain.channel_list)),
 				 hex2str(mdomain.tx_powerlevel,
 					 sizeof(mdomain.tx_powerlevel)));
-		ret = at76_start_scan(priv, 0, 1);
+		ret = at76_start_scan(priv, 0, 0);
 		if (ret < 0)
-			err("%s: %s: start_scan (ANY) failed with %d",
+			err("%s: %s: start_scan (IR) failed with %d",
 			    priv->netdev->name, __func__, ret);
 		at76_dbg(DBG_MGMT_TIMER,
 			 "%s:%d: starting mgmt_timer for %d ticks",
@@ -3883,9 +3883,9 @@ static void at76_dwork_get_scan(struct work_struct *work)
 		break;
 
 	case 2:
-		ret = at76_start_scan(priv, 1, 1);
+		ret = at76_start_scan(priv, 0, 1);
 		if (ret < 0)
-			err("%s: %s: start_scan (SSID) failed with %d",
+			err("%s: %s: start_scan (ANY) failed with %d",
 			    priv->netdev->name, __func__, ret);
 		at76_dbg(DBG_MGMT_TIMER,
 			 "%s:%d: starting mgmt_timer for %d ticks",
@@ -4195,11 +4195,14 @@ static void at76_work_start_scan(struct work_struct *work)
 
 	/* only clear the bss list when a scan is actively initiated,
 	 * otherwise simply rely on at76_bss_list_timeout */
-	if (priv->scan_state == SCAN_IN_PROGRESS)
+	if (priv->scan_state == SCAN_IN_PROGRESS) {
 		at76_free_bss_list(priv);
+		priv->scan_runs = priv->international_roaming ? 1 : 2;
+	} else
+		priv->scan_runs = 3;
+
+	ret = at76_start_scan(priv, 1, 1);
 
-	priv->scan_runs = 2;
-	ret = at76_start_scan(priv, 0, 1);
 	if (ret < 0)
 		err("%s: %s: start_scan failed with %d",
 		    priv->netdev->name, __func__, ret);
