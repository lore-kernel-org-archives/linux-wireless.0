Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:49081 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751903AbZKAJbo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Nov 2009 04:31:44 -0500
Date: Sun, 1 Nov 2009 11:31:45 +0200
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] mac80211_hwsim: Send ACK frames on the hwsim0 interface
Message-ID: <20091101093145.GB1058@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Report successful transmissions (receiver awake and on the same
channel) by generating ACK frames on the hwsim0 interface. This makes
it easier to figure out from packet capture logs whether frames were
delivered or not.

Signed-off-by: Jouni Malinen <j@w1.fi>

---
 drivers/net/wireless/mac80211_hwsim.c |   47 ++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

--- uml.orig/drivers/net/wireless/mac80211_hwsim.c	2009-10-01 17:22:15.000000000 +0300
+++ uml/drivers/net/wireless/mac80211_hwsim.c	2009-10-01 17:25:34.000000000 +0300
@@ -365,6 +365,49 @@ static void mac80211_hwsim_monitor_rx(st
 }
 
 
+static void mac80211_hwsim_monitor_ack(struct ieee80211_hw *hw, const u8 *addr)
+{
+	struct mac80211_hwsim_data *data = hw->priv;
+	struct sk_buff *skb;
+	struct hwsim_radiotap_hdr *hdr;
+	u16 flags;
+	struct ieee80211_hdr *hdr11;
+
+	if (!netif_running(hwsim_mon))
+		return;
+
+	skb = dev_alloc_skb(100);
+	if (skb == NULL)
+		return;
+
+	hdr = (struct hwsim_radiotap_hdr *) skb_put(skb, sizeof(*hdr));
+	hdr->hdr.it_version = PKTHDR_RADIOTAP_VERSION;
+	hdr->hdr.it_pad = 0;
+	hdr->hdr.it_len = cpu_to_le16(sizeof(*hdr));
+	hdr->hdr.it_present = cpu_to_le32((1 << IEEE80211_RADIOTAP_FLAGS) |
+					  (1 << IEEE80211_RADIOTAP_CHANNEL));
+	hdr->rt_flags = 0;
+	hdr->rt_rate = 0;
+	hdr->rt_channel = cpu_to_le16(data->channel->center_freq);
+	flags = IEEE80211_CHAN_2GHZ;
+	hdr->rt_chbitmask = cpu_to_le16(flags);
+
+	hdr11 = (struct ieee80211_hdr *) skb_put(skb, 10);
+	hdr11->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
+					   IEEE80211_STYPE_ACK);
+	hdr11->duration_id = cpu_to_le16(0);
+	memcpy(hdr11->addr1, addr, ETH_ALEN);
+
+	skb->dev = hwsim_mon;
+	skb_set_mac_header(skb, 0);
+	skb->ip_summed = CHECKSUM_UNNECESSARY;
+	skb->pkt_type = PACKET_OTHERHOST;
+	skb->protocol = htons(ETH_P_802_2);
+	memset(skb->cb, 0, sizeof(skb->cb));
+	netif_rx(skb);
+}
+
+
 static bool hwsim_ps_rx_ok(struct mac80211_hwsim_data *data,
 			   struct sk_buff *skb)
 {
@@ -471,6 +514,10 @@ static int mac80211_hwsim_tx(struct ieee
 	}
 
 	ack = mac80211_hwsim_tx_frame(hw, skb);
+	if (ack && skb->len >= 16) {
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+		mac80211_hwsim_monitor_ack(hw, hdr->addr2);
+	}
 
 	txi = IEEE80211_SKB_CB(skb);
 

-- 
Jouni Malinen                                            PGP id EFC895FA
