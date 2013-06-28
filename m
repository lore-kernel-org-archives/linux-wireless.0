Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:53474 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab3F1OuT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 10:50:19 -0400
Message-ID: <1372431024.3301.277.camel@edumazet-glaptop> (sfid-20130628_165025_676180_92341180)
Subject: Re: [PATCH] iwl3945: better skb management in rx path
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Paul Stewart <pstew@google.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"Steinar H. Gunderson" <sesse@google.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>
Date: Fri, 28 Jun 2013 07:50:24 -0700
In-Reply-To: <CAMcMvshEdsFZ2PVEpaq0e2P4L+cksshjB56x2YvA4wt3T+3__w@mail.gmail.com>
References: <1372421021.3301.263.camel@edumazet-glaptop>
	 <CAMcMvshEdsFZ2PVEpaq0e2P4L+cksshjB56x2YvA4wt3T+3__w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eric Dumazet <edumazet@google.com>

On Fri, 2013-06-28 at 07:38 -0700, Paul Stewart wrote:

> Presumably this 256 is related to the "dev_alloc_skb(256)"?  It might
> be worth making this a constant of some sort so they don't
> inadvertently drift apart in the future.

Hi Paul !

Well, I can do that, but the 128 was not a constant to begin with ;)

Thanks

[PATCH v2] iwl3945: better skb management in rx path

Steinar reported reallocations of skb->head with IPv6, leading to
a warning in skb_try_coalesce()

It turns out iwl3945 has several problems :

1) skb->truesize is underestimated. 
   We really consume PAGE_SIZE bytes for a fragment,
   not the frame length.
2) 128 bytes of initial headroom is a bit low and forces reallocations.
3) We can avoid consuming a full page for small enough frames.

Reported-by: Steinar H. Gunderson <sesse@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Paul Stewart <pstew@google.com>
---
v2: use a SMALL_PACKET_SIZE macro

 drivers/net/wireless/iwlegacy/3945.c |   32 +++++++++++++++----------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index c092033..38e6be6 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -475,6 +475,8 @@ il3945_is_network_packet(struct il_priv *il, struct ieee80211_hdr *header)
 	}
 }
 
+#define SMALL_PACKET_SIZE 256
+
 static void
 il3945_pass_packet_to_mac80211(struct il_priv *il, struct il_rx_buf *rxb,
 			       struct ieee80211_rx_status *stats)
@@ -483,14 +485,13 @@ il3945_pass_packet_to_mac80211(struct il_priv *il, struct il_rx_buf *rxb,
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)IL_RX_DATA(pkt);
 	struct il3945_rx_frame_hdr *rx_hdr = IL_RX_HDR(pkt);
 	struct il3945_rx_frame_end *rx_end = IL_RX_END(pkt);
-	u16 len = le16_to_cpu(rx_hdr->len);
+	u32 len = le16_to_cpu(rx_hdr->len);
 	struct sk_buff *skb;
 	__le16 fc = hdr->frame_control;
+	u32 fraglen = PAGE_SIZE << il->hw_params.rx_page_order;
 
 	/* We received data from the HW, so stop the watchdog */
-	if (unlikely
-	    (len + IL39_RX_FRAME_SIZE >
-	     PAGE_SIZE << il->hw_params.rx_page_order)) {
+	if (unlikely(len + IL39_RX_FRAME_SIZE > fraglen)) {
 		D_DROP("Corruption detected!\n");
 		return;
 	}
@@ -506,26 +507,33 @@ il3945_pass_packet_to_mac80211(struct il_priv *il, struct il_rx_buf *rxb,
 		D_INFO("Woke queues - frame received on passive channel\n");
 	}
 
-	skb = dev_alloc_skb(128);
+	skb = dev_alloc_skb(SMALL_PACKET_SIZE);
 	if (!skb) {
 		IL_ERR("dev_alloc_skb failed\n");
 		return;
 	}
 
 	if (!il3945_mod_params.sw_crypto)
-		il_set_decrypted_flag(il, (struct ieee80211_hdr *)rxb_addr(rxb),
+		il_set_decrypted_flag(il, (struct ieee80211_hdr *)pkt,
 				      le32_to_cpu(rx_end->status), stats);
 
-	skb_add_rx_frag(skb, 0, rxb->page,
-			(void *)rx_hdr->payload - (void *)pkt, len,
-			len);
-
+	/* If frame is small enough to fit into skb->head, copy it
+	 * and do not consume a full page
+	 */
+	if (len <= SMALL_PACKET_SIZE) {
+		skb_copy_to_linear_data(skb, rx_hdr->payload, len);
+		skb->tail += len;
+	} else {
+		skb_add_rx_frag(skb, 0, rxb->page,
+				(void *)rx_hdr->payload - (void *)pkt, len,
+				fraglen);
+		il->alloc_rxb_page--;
+		rxb->page = NULL;
+	}
 	il_update_stats(il, false, fc, len);
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
 	ieee80211_rx(il->hw, skb);
-	il->alloc_rxb_page--;
-	rxb->page = NULL;
 }
 
 #define IL_DELAY_NEXT_SCAN_AFTER_ASSOC (HZ*6)


