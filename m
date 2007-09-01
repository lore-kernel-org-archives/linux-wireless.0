Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4413 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751905AbXIAEha (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:37:30 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 7FF35618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:37:29 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 34/35] Don't do additional MIB dumps if DEBUG is defined
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:37:29 -0400
Message-ID: <20070901043728.2498.56098.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

They are already printed from at76_startup_device(), which should be
enough.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 2c8ad54..ba0ad2c 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1823,10 +1823,6 @@ static void at76_work_assoc_done(struct work_struct *work)
 
 			at76_set_associd(priv, priv->assoc_id);
 			at76_set_listen_interval(priv, (u16)pm_period_beacon);
-#ifdef DEBUG
-			at76_dump_mib_mac(priv);
-			at76_dump_mib_mac_mgmt(priv);
-#endif
 		}
 		schedule_delayed_work(&priv->dwork_beacon, BEACON_TIMEOUT);
 	}
@@ -3305,9 +3301,6 @@ static int at76_open(struct net_device *netdev)
 			at76_dbg(DBG_PROGRESS, "%s: set new MAC addr %s",
 				 netdev->name, mac2str(netdev->dev_addr));
 	}
-#ifdef DEBUG
-	at76_dump_mib_mac_addr(priv);
-#endif
 
 	priv->scan_state = SCAN_IDLE;
 	priv->last_scan = jiffies;
