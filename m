Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:61850 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751724AbXIAEhB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Sep 2007 00:37:01 -0400
Received: from dv.roinet.com (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by relay.cesmail.net (Postfix) with ESMTP id E6700618FE1
	for <linux-wireless@vger.kernel.org>; Sat,  1 Sep 2007 00:37:00 -0400 (EDT)
From: Pavel Roskin <proski@gnu.org>
Subject: [PATCH 29/35] Eliminate at76_dbg_dumpbuf() in favor of hex2str()
To: linux-wireless@vger.kernel.org
Date: Sat, 01 Sep 2007 00:37:00 -0400
Message-ID: <20070901043700.2498.74241.stgit@dv.roinet.com>
In-Reply-To: <20070901043233.2498.95850.stgit@dv.roinet.com>
References: <20070901043233.2498.95850.stgit@dv.roinet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Pavel Roskin <proski@gnu.org>
---

 drivers/net/wireless/at76_usb.c |   27 ++++-----------------------
 1 files changed, 4 insertions(+), 23 deletions(-)


diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index c648d5c..5922d35 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -4708,24 +4708,6 @@ static void at76_rx_mgmt(struct at76_priv *priv, struct at76_rx_buffer *buf)
 	return;
 }
 
-static void at76_dbg_dumpbuf(const char *tag, const u8 *buf, int size)
-{
-	int i;
-
-	if (!at76_debug)
-		return;
-
-	for (i = 0; i < size; i++) {
-		if ((i % 8) == 0) {
-			if (i)
-				pr_debug("\n");
-			pr_debug(DRIVER_NAME ": %s: ", tag);
-		}
-		pr_debug("%02x ", buf[i]);
-	}
-	pr_debug("\n");
-}
-
 /* Convert the 802.11 header into an ethernet-style header, make skb
  * ready for consumption by netif_rx() */
 static void at76_ieee80211_to_eth(struct sk_buff *skb, int iw_mode)
@@ -5005,12 +4987,11 @@ static void at76_rx_data(struct at76_priv *priv)
 	struct ieee80211_hdr_3addr *i802_11_hdr;
 	int length = le16_to_cpu(buf->wlength);
 
-	at76_dbg(DBG_RX_DATA, "%s received data packet:", netdev->name);
-	if (at76_debug & DBG_RX_DATA)
-		at76_dbg_dumpbuf(" rxhdr", skb->data, AT76_RX_HDRLEN);
+	at76_dbg(DBG_RX_DATA, "%s received data packet: %s", netdev->name,
+		 hex2str(skb->data, AT76_RX_HDRLEN));
 
-	if (at76_debug & DBG_RX_DATA_CONTENT)
-		at76_dbg_dumpbuf("packet", skb->data + AT76_RX_HDRLEN, length);
+	at76_dbg(DBG_RX_DATA_CONTENT, "rx packet: %s",
+		 hex2str(skb->data + AT76_RX_HDRLEN, length));
 
 	skb = at76_check_for_rx_frags(priv);
 	if (!skb)
