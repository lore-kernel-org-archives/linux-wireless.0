Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:38044 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752787AbXJOHe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 03:34:27 -0400
From: bruno randolf <bruno@thinktube.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] Re: atheros hardware needs padding for QoS data
Date: Mon, 15 Oct 2007 16:34:32 +0900
Cc: Johannes Berg <johannes@sipsolutions.net>
References: <200710121946.30024.bruno@thinktube.com> <1192194578.4770.55.camel@johannes.berg> <200710151241.17651.bruno@thinktube.com>
In-Reply-To: <200710151241.17651.bruno@thinktube.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200710151634.33480.bruno@thinktube.com> (sfid-20071015_083431_560687_FDFAF0B4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

what do you think about the following solution?

Atheros hardware requires the header to be padded to 4 byte (32 bit)
boundaries. It expects the payload data to start at multiples of 4 byte for TX
frames and will add the padding for received frames. For most headers there is
no need for padding, since they are multiples of 4 already - except QoS and 4
address headers.

This adds a new hw flag IEEE80211_HW_HEADER_PADDING to tell mac80211 that such
a padding is needed.
---
 drivers/net/wireless/ath5k/base.c |    1 +
 include/net/mac80211.h            |    8 ++++++++
 net/mac80211/rx.c                 |   20 ++++++++++++++++++++
 net/mac80211/tx.c                 |    5 +++++
 4 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath5k/base.c 
b/drivers/net/wireless/ath5k/base.c
index 08530d5..b705f68 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2382,6 +2382,7 @@ static int __devinit ath_pci_probe(struct pci_dev *pdev,
 	hw->extra_tx_headroom = 2;
 	hw->channel_change_time = 5000;
 	hw->max_rssi = 127; /* FIXME: get a real value for this. */
+	hw->flags |= IEEE80211_HW_HEADER_PADDING;
 	sc = hw->priv;
 	sc->hw = hw;
 	sc->pdev = pdev;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2b1bffb..18c30e6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -662,12 +662,20 @@ enum sta_notify_cmd {
  * @IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED:
  *	Channels are already configured to the default regulatory domain
  *	specified in the device's EEPROM
+ *
+ * @IEEE80211_HW_HEADER_PADDING:
+ *	Some hardware requires the header to be padded to 4 byte (32 bit)
+ *	boundaries. It expects the payload data to start at multiples
+ *	of 4 byte for TX frames and will add the padding for received
+ *	frames. For most headers there is no need for padding, since they
+ *	are multiples of 4 already - except QoS and 4 address headers.
  */
 enum ieee80211_hw_flags {
 	IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE		= 1<<0,
 	IEEE80211_HW_RX_INCLUDES_FCS			= 1<<1,
 	IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING	= 1<<2,
 	IEEE80211_HW_DEFAULT_REG_DOMAIN_CONFIGURED	= 1<<3,
+	IEEE80211_HW_HEADER_PADDING			= 1<<4,
 };
 
 /**
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 064924c..2ad94d1 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -419,6 +419,25 @@ ieee80211_rx_h_check(struct ieee80211_txrx_data *rx)
 
 
 static ieee80211_txrx_result
+ieee80211_rx_h_remove_padding(struct ieee80211_txrx_data *rx)
+{
+	struct ieee80211_hw *hw = local_to_hw(rx->local);
+	int hdrlen;
+	int pad;
+
+	if (!(hw->flags & IEEE80211_HW_HEADER_PADDING))
+		return TXRX_CONTINUE;
+
+	hdrlen = ieee80211_get_hdrlen(rx->fc);
+	if ((pad = hdrlen % 4)) {
+		memmove(rx->skb->data + pad, rx->skb->data, hdrlen);
+		skb_pull(rx->skb, pad);
+	}
+
+	return TXRX_CONTINUE;
+}
+
+static ieee80211_txrx_result
 ieee80211_rx_h_decrypt(struct ieee80211_txrx_data *rx)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) rx->skb->data;
@@ -1320,6 +1339,7 @@ ieee80211_rx_handler ieee80211_rx_handlers[] =
 	ieee80211_rx_h_if_stats,
 	ieee80211_rx_h_passive_scan,
 	ieee80211_rx_h_check,
+	ieee80211_rx_h_remove_padding,
 	ieee80211_rx_h_decrypt,
 	ieee80211_rx_h_sta_process,
 	ieee80211_rx_h_defragment,
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 957ec3c..ce4c6ce 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1334,6 +1334,7 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 			       struct net_device *dev)
 {
 	struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);
+	struct ieee80211_hw *hw = local_to_hw(local);
 	struct ieee80211_tx_packet_data *pkt_data;
 	struct ieee80211_sub_if_data *sdata;
 	int ret = 1, head_need;
@@ -1410,6 +1411,10 @@ int ieee80211_subif_start_xmit(struct sk_buff *skb,
 		sta_info_put(sta);
 	}
 
+	if (hw->flags & IEEE80211_HW_HEADER_PADDING) {
+		hdrlen = roundup(hdrlen, 4);
+	}
+
 	hdr.frame_control = cpu_to_le16(fc);
 	hdr.duration_id = 0;
 	hdr.seq_ctrl = 0;
-- 
1.5.3.4

