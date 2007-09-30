Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:6021 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbXI3SkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Sep 2007 14:40:03 -0400
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 13/26] at76_usb: Eliminate variables used only in at76_dbg()
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Date: Sun, 30 Sep 2007 14:40:02 -0400
Message-ID: <20070930184002.23921.47972.stgit@tt.roinet.com>
In-Reply-To: <20070930183409.23921.97762.stgit@tt.roinet.com>
References: <20070930183409.23921.97762.stgit@tt.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make it possible to disable at76_dbg() at the compile time without
introducing any warnings.

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 81fefff..8d11988 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -4047,15 +4047,14 @@ static void at76_rx_mgmt_assoc(struct at76_priv *priv,
 {
 	struct ieee80211_assoc_response *resp =
 	    (struct ieee80211_assoc_response *)buf->packet;
-	struct ieee80211_hdr_3addr *mgmt = &resp->header;
 	u16 assoc_id = le16_to_cpu(resp->aid);
 	u16 status = le16_to_cpu(resp->status);
-	u16 capa = le16_to_cpu(resp->capability);
-	at76_dbg(DBG_RX_MGMT,
-		 "%s: rx AssocResp bssid %s capa 0x%04x status 0x%04x "
-		 "assoc_id 0x%04x rates %s", priv->netdev->name,
-		 mac2str(mgmt->addr3), capa, status, assoc_id,
-		 hex2str(resp->info_element->data, resp->info_element->len));
+
+	at76_dbg(DBG_RX_MGMT, "%s: rx AssocResp bssid %s capa 0x%04x status "
+		 "0x%04x assoc_id 0x%04x rates %s", priv->netdev->name,
+		 mac2str(resp->header.addr3), le16_to_cpu(resp->capability),
+		 status, assoc_id, hex2str(resp->info_element->data,
+					   resp->info_element->len));
 
 	if (priv->mac_state != MAC_ASSOC) {
 		printk(KERN_INFO "%s: AssocResp in state %s ignored\n",
