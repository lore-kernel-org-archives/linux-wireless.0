Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.29]:7643 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbYGDRoR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 13:44:17 -0400
Received: by yw-out-2324.google.com with SMTP id 9so567449ywe.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 10:44:17 -0700 (PDT)
From: Milan Plzik <milan.plzik@gmail.com>
Subject: [PATCH 3/7] Remove usage of data which were already skb_pull-ed.
To: linux-wireless@vger.kernel.org
Date: Fri, 04 Jul 2008 19:44:12 +0200
Message-ID: <20080704174412.4996.80140.stgit@localhost> (sfid-20080704_194419_759654_09D9FA25)
In-Reply-To: <20080704174350.4996.72931.stgit@localhost>
References: <20080704174350.4996.72931.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

at76_rx_tasklet makes use of data referenced by 'buf' despite of the fact
they were already marked as free by skb_pull. This patch delays skb_pull, so
data will remain valid.

Signed-off-by: Milan Plzik <milan.plzik@gmail.com>
---

 drivers/net/wireless/at76_usb.c |    9 +++++----
 1 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 13ea9ca..b6d06b8 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1594,15 +1594,16 @@ static void at76_rx_tasklet(unsigned long param)
 		 wiphy_name(priv->hw->wiphy), buf->rx_rate, buf->rssi,
 		 buf->noise_level, buf->link_quality);
 
-	skb_pull(priv->rx_skb, AT76_RX_HDRLEN);
-	skb_trim(priv->rx_skb, le16_to_cpu(buf->wlength));
-	at76_dbg_dump(DBG_RX_DATA, priv->rx_skb->data,
-		      priv->rx_skb->len, "RX: len=%d", priv->rx_skb->len);
+
+	skb_trim(priv->rx_skb, le16_to_cpu(buf->wlength) + AT76_RX_HDRLEN);
+	at76_dbg_dump(DBG_RX_DATA, &priv->rx_skb->data[AT76_RX_HDRLEN],
+		      priv->rx_skb->len, "RX: len=%d", priv->rx_skb->len - AT76_RX_HDRLEN);
 
 	rx_status.signal = buf->rssi;
 	rx_status.flag |= RX_FLAG_DECRYPTED;
 	rx_status.flag |= RX_FLAG_IV_STRIPPED;
 
+	skb_pull(priv->rx_skb, AT76_RX_HDRLEN);
 	at76_dbg(DBG_MAC80211, "calling ieee80211_rx_irqsafe(): %d/%d",
 		 priv->rx_skb->len, priv->rx_skb->data_len);
 	ieee80211_rx_irqsafe(priv->hw, priv->rx_skb, &rx_status);

