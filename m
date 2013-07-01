Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868Ab3GAMQ4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 1 Jul 2013 08:16:56 -0400
Date: Mon, 1 Jul 2013 14:19:30 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: [PATCH] iwl4965: better skb management in rx path
Message-ID: <20130701121929.GB1747@redhat.com> (sfid-20130701_141708_812016_8AA3D4DA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

4965 version of Eric patch "iwl3945: better skb management in rx path".
It fixes several problems :

1) skb->truesize is underestimated.
   We really consume PAGE_SIZE bytes for a fragment,
   not the frame length.
2) 128 bytes of initial headroom is a bit low and forces reallocations.
3) We can avoid consuming a full page for small enough frames.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/4965-mac.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index d287fd2..4e5d408 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -574,9 +574,11 @@ il4965_translate_rx_status(struct il_priv *il, u32 decrypt_in)
 	return decrypt_out;
 }
 
+#define SMALL_PACKET_SIZE 256
+
 static void
 il4965_pass_packet_to_mac80211(struct il_priv *il, struct ieee80211_hdr *hdr,
-			       u16 len, u32 ampdu_status, struct il_rx_buf *rxb,
+			       u32 len, u32 ampdu_status, struct il_rx_buf *rxb,
 			       struct ieee80211_rx_status *stats)
 {
 	struct sk_buff *skb;
@@ -598,21 +600,25 @@ il4965_pass_packet_to_mac80211(struct il_priv *il, struct ieee80211_hdr *hdr,
 	    il_set_decrypted_flag(il, hdr, ampdu_status, stats))
 		return;
 
-	skb = dev_alloc_skb(128);
+	skb = dev_alloc_skb(SMALL_PACKET_SIZE);
 	if (!skb) {
 		IL_ERR("dev_alloc_skb failed\n");
 		return;
 	}
 
-	skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb), len,
-			len);
+	if (len <= SMALL_PACKET_SIZE) {
+		memcpy(skb_put(skb, len), hdr, len);
+	} else {
+		skb_add_rx_frag(skb, 0, rxb->page, (void *)hdr - rxb_addr(rxb),
+				len, PAGE_SIZE << il->hw_params.rx_page_order);
+		il->alloc_rxb_page--;
+		rxb->page = NULL;
+	}
 
 	il_update_stats(il, false, fc, len);
 	memcpy(IEEE80211_SKB_RXCB(skb), stats, sizeof(*stats));
 
 	ieee80211_rx(il->hw, skb);
-	il->alloc_rxb_page--;
-	rxb->page = NULL;
 }
 
 /* Called for N_RX (legacy ABG frames), or
-- 
1.7.11.7

