Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.184]:38918 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489AbYGDRod (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Jul 2008 13:44:33 -0400
Received: by mu-out-0910.google.com with SMTP id w8so379639mue.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Jul 2008 10:44:32 -0700 (PDT)
From: Milan Plzik <milan.plzik@gmail.com>
Subject: [PATCH 5/7] Minor final fixes.
To: linux-wireless@vger.kernel.org
Date: Fri, 04 Jul 2008 19:44:28 +0200
Message-ID: <20080704174428.4996.96550.stgit@localhost> (sfid-20080704_194435_736029_DBB30EDA)
In-Reply-To: <20080704174350.4996.72931.stgit@localhost>
References: <20080704174350.4996.72931.stgit@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

- report rate at which was frame received
- fix the issue with growing latencies (call ieee80211_wake_queues from tx
  complete handler)
- tx handler doesn't report ack'ed frame anymore -- the adapter doesn't
  report ACK status
- association after loading driver now works at first attempt

Signed-off-by: Milan Plzik <milan.plzik@gmail.com>
---

 drivers/net/wireless/at76_usb.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/at76_usb.c b/drivers/net/wireless/at76_usb.c
index 43ec42c..612c714 100644
--- a/drivers/net/wireless/at76_usb.c
+++ b/drivers/net/wireless/at76_usb.c
@@ -1607,6 +1607,7 @@ static void at76_rx_tasklet(unsigned long param)
 		      priv->rx_skb->len, "RX: len=%d", (int)(priv->rx_skb->len - AT76_RX_HDRLEN));
 
 	rx_status.signal = buf->rssi;
+	rx_status.rate_idx = buf->rx_rate;	/* FIXME: is rate_idx still present in structure? */
 	rx_status.flag |= RX_FLAG_DECRYPTED;
 	rx_status.flag |= RX_FLAG_IV_STRIPPED;
 
@@ -1707,7 +1708,7 @@ static void at76_mac80211_tx_callback(struct urb *urb)
 	switch (urb->status) {
 	case 0:
 		/* success */
-		info->flags |= IEEE80211_TX_STAT_ACK;
+		info->flags |= IEEE80211_TX_STAT_ACK;	/* FIXME: is the frame really ACKed when tx_callback is called ? */
 		break;
 	case -ENOENT:
 	case -ECONNRESET:
@@ -1919,12 +1920,12 @@ static void at76_dwork_hw_scan(struct work_struct *work)
 	ieee80211_scan_completed(priv->hw);
 
 	if (is_valid_ether_addr(priv->bssid)) {
-		ieee80211_start_queues(priv->hw);
+		ieee80211_wake_queues(priv->hw);
 		at76_join(priv);
 	} else
 		ieee80211_stop_queues(priv->hw);
 
-	ieee80211_start_queues(priv->hw);
+	ieee80211_wake_queues(priv->hw);
 
 // CHECKME:	ieee80211_wake_queues(priv->hw);
 
@@ -1989,7 +1990,7 @@ static int at76_config(struct ieee80211_hw *hw, struct ieee80211_conf *conf)
 
 	if (is_valid_ether_addr(priv->bssid)) {
 		at76_join(priv);
-		ieee80211_start_queues(priv->hw);
+		ieee80211_wake_queues(priv->hw);
 	} else {
 		ieee80211_stop_queues(priv->hw);
 		at76_start_monitor(priv);
@@ -2016,9 +2017,12 @@ static int at76_config_interface(struct ieee80211_hw *hw,
 	memcpy(priv->essid, conf->ssid, conf->ssid_len);
 	priv->essid_size = conf->ssid_len;
 
-	if (is_valid_ether_addr(priv->bssid))
+	if (is_valid_ether_addr(priv->bssid)) {
 		/* mac80211 is joining a bss */
+		ieee80211_wake_queues(priv->hw);
 		at76_join(priv);
+	} else
+		ieee80211_stop_queues(priv->hw);
 
 	mutex_unlock(&priv->mtx);
 

