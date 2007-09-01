Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36251 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751685AbXIAEf6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:35:58 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 2CB38618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:35:58 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 18/35] Only cancel correct timeouts for Auth and Assoc replies
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:35:57 -0400
Message-ID: <20070901043557.2498.6553.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Don't cancel all delayed works indiscriminately.  In case of
at76_rx_mgmt_auth(), cancel the timeout regardless of the status of the
reply, as long as the reply is for us.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   10 ++--------
 1 files changed, 2 insertions(+), 8 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index bda7632..2fc6084 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -4274,6 +4274,7 @@ static void at76_rx_mgmt_assoc(struct at76_priv *priv,
 
 	BUG_ON(!priv->curr_bss);
 
+	cancel_delayed_work(&priv->dwork_assoc);
 	if (status == WLAN_STATUS_SUCCESS) {
 		struct bss_info *ptr = priv->curr_bss;
 		priv->assoc_id = assoc_id & 0x3fff;
@@ -4287,10 +4288,6 @@ static void at76_rx_mgmt_assoc(struct at76_priv *priv,
 		at76_set_mac_state(priv, MAC_JOINING);
 		schedule_work(&priv->work_join);
 	}
-	cancel_delayed_work(&priv->dwork_get_scan);
-	cancel_delayed_work(&priv->dwork_beacon);
-	cancel_delayed_work(&priv->dwork_auth);
-	cancel_delayed_work(&priv->dwork_assoc);
 }
 
 /* Process disassociation request from the AP */
@@ -4376,11 +4373,8 @@ static void at76_rx_mgmt_auth(struct at76_priv *priv,
 	    || compare_ether_addr(priv->netdev->dev_addr, mgmt->addr1))
 		return;
 
+	cancel_delayed_work(&priv->dwork_auth);
 	if (status != WLAN_STATUS_SUCCESS) {
-		cancel_delayed_work(&priv->dwork_get_scan);
-		cancel_delayed_work(&priv->dwork_beacon);
-		cancel_delayed_work(&priv->dwork_auth);
-		cancel_delayed_work(&priv->dwork_assoc);
 		/* try to join next bss */
 		at76_set_mac_state(priv, MAC_JOINING);
 		schedule_work(&priv->work_join);
