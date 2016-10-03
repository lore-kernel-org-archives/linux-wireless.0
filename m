Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.fem.tu-ilmenau.de ([141.24.220.54]:55092 "EHLO
        mail.fem.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752987AbcJCLO3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 07:14:29 -0400
From: Michael Braun <michael-dev@fami-braun.de>
To: johannes@sipsolutions.net
Cc: Michael Braun <michael-dev@fami-braun.de>,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de,
        akarwar@marvell.com, nishants@marvell.com
Subject: [PATCHv3 3/3] mwifiex: check A-MSDU inner frame source address on AP interfaces
Date: Mon,  3 Oct 2016 13:14:17 +0200
Message-Id: <1475493257-21841-3-git-send-email-michael-dev@fami-braun.de> (sfid-20161003_131431_744719_1ED01892)
In-Reply-To: <1475493257-21841-1-git-send-email-michael-dev@fami-braun.de>
References: <1475493257-21841-1-git-send-email-michael-dev@fami-braun.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using WPA security, the station and thus the required key is
identified by its mac address when packets are received. So a
station usually cannot spoof its source mac address.

But when a station sends an A-MSDU frame, port control and crypto
is done using the outer mac address, while the packets delivered
and forwarded use the inner mac address.
This might affect ARP/IP filtering on the AccessPoint.

IEEE 802.11-2012 mandates that the outer source mac address should
match the inner source address (section 8.3.2.2). For the destination
mac address, matching is not required, as a wifi client may send all
its traffic to the AP in order to have it forwarded.

Signed-off-by: Michael Braun <michael-dev@fami-braun.de>

To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Cc: projekt-wlan@fem.tu-ilmenau.de
Cc: akarwar@marvell.com
Cc: nishants@marvell.com
---
 drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
index 49d0efe..f4469d7 100644
--- a/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
+++ b/drivers/net/wireless/marvell/mwifiex/11n_rxreorder.c
@@ -30,7 +30,8 @@
  * layer.
  */
 static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
-					  struct sk_buff *skb)
+					  struct sk_buff *skb,
+					  const u8 *ta)
 {
 	struct rxpd *local_rx_pd = (struct rxpd *)(skb->data);
 	int ret;
@@ -45,7 +46,7 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
 		skb_trim(skb, le16_to_cpu(local_rx_pd->rx_pkt_length));
 
 		ieee80211_amsdu_to_8023s(skb, &list, priv->curr_addr,
-					 priv->wdev.iftype, 0, NULL);
+					 priv->wdev.iftype, 0, ta);
 
 		while (!skb_queue_empty(&list)) {
 			struct rx_packet_hdr *rx_hdr;
@@ -76,9 +77,10 @@ static int mwifiex_11n_dispatch_amsdu_pkt(struct mwifiex_private *priv,
 /* This function will process the rx packet and forward it to kernel/upper
  * layer.
  */
-static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload)
+static int mwifiex_11n_dispatch_pkt(struct mwifiex_private *priv, void *payload,
+				    const u8 *ta)
 {
-	int ret = mwifiex_11n_dispatch_amsdu_pkt(priv, payload);
+	int ret = mwifiex_11n_dispatch_amsdu_pkt(priv, payload, ta);
 
 	if (!ret)
 		return 0;
@@ -119,7 +121,7 @@ mwifiex_11n_dispatch_pkt_until_start_win(struct mwifiex_private *priv,
 		}
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
 		if (rx_tmp_ptr)
-			mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
+			mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr, tbl->ta);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -161,7 +163,7 @@ mwifiex_11n_scan_and_dispatch(struct mwifiex_private *priv,
 		rx_tmp_ptr = tbl->rx_reorder_ptr[i];
 		tbl->rx_reorder_ptr[i] = NULL;
 		spin_unlock_irqrestore(&priv->rx_pkt_lock, flags);
-		mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr);
+		mwifiex_11n_dispatch_pkt(priv, rx_tmp_ptr, tbl->ta);
 	}
 
 	spin_lock_irqsave(&priv->rx_pkt_lock, flags);
@@ -568,12 +570,12 @@ int mwifiex_11n_rx_reorder_pkt(struct mwifiex_private *priv,
 	tbl = mwifiex_11n_get_rx_reorder_tbl(priv, tid, ta);
 	if (!tbl) {
 		if (pkt_type != PKT_TYPE_BAR)
-			mwifiex_11n_dispatch_pkt(priv, payload);
+			mwifiex_11n_dispatch_pkt(priv, payload, ta);
 		return ret;
 	}
 
 	if ((pkt_type == PKT_TYPE_AMSDU) && !tbl->amsdu) {
-		mwifiex_11n_dispatch_pkt(priv, payload);
+		mwifiex_11n_dispatch_pkt(priv, payload, ta);
 		return ret;
 	}
 
-- 
2.1.4
