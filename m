Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:4413 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349AbXIAEhH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:37:07 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id 93F4A618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:37:06 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 30/35] Eliminate pr_debug() in favor of at76_dbg()
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:37:06 -0400
Message-ID: <20070901043706.2498.22327.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 5922d35..e612dc5 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1818,19 +1818,18 @@ static void at76_dump_bss_table(struct at76_priv *priv)
 
 	spin_lock_irqsave(&priv->bss_list_spinlock, flags);
 
-	pr_debug("%s BSS table (curr=%p):", priv->netdev->name, priv->curr_bss);
+	at76_dbg(DBG_BSS_TABLE, "%s BSS table (curr=%p):", priv->netdev->name,
+		 priv->curr_bss);
 
 	list_for_each(lptr, &priv->bss_list) {
 		ptr = list_entry(lptr, struct bss_info, list);
-		pr_debug("0x%p: bssid %s channel %d ssid %s (%s)"
-			 " capa 0x%04x rates %s rssi %d link %d noise %d",
-			 ptr, mac2str(ptr->bssid),
-			 ptr->channel,
-			 ptr->ssid,
-			 hex2str(ptr->ssid, ptr->ssid_len),
-			 ptr->capa,
-			 hex2str(ptr->rates, ptr->rates_len),
-			 ptr->rssi, ptr->link_qual, ptr->noise_level);
+		at76_dbg(DBG_BSS_TABLE,
+			 "0x%p: bssid %s channel %d ssid %s (%s)"
+			 " capa 0x%04x rates %s rssi %d link %d noise %d", ptr,
+			 mac2str(ptr->bssid), ptr->channel, ptr->ssid,
+			 hex2str(ptr->ssid, ptr->ssid_len), ptr->capa,
+			 hex2str(ptr->rates, ptr->rates_len), ptr->rssi,
+			 ptr->link_qual, ptr->noise_level);
 	}
 	spin_unlock_irqrestore(&priv->bss_list_spinlock, flags);
 }
