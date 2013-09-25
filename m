Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2567 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754265Ab3IYLF6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 07:05:58 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 4/7] brcmfmac: reserve memory for bus layer in
 sk_buff::cb
Date: Wed, 25 Sep 2013 13:05:43 +0200
Message-ID: <1380107146-24026-5-git-send-email-arend@broadcom.com> (sfid-20130925_130605_441372_734D29C8)
In-Reply-To: <1380107146-24026-1-git-send-email-arend@broadcom.com>
References: <1380107146-24026-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Bus layer need to share sk_buff::cb with firmware signal feature. Reserve
necessary memory so they won't overwrite each other.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   15 ++++++++++-----
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    2 ++
 2 files changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 1aa75d5..f9ba4d0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1786,10 +1786,15 @@ brcmf_sdbrcm_wait_event_wakeup(struct brcmf_sdio *bus)
 	return;
 }
 
+/**
+ * struct brcmf_skbuff_cb reserves first two bytes in sk_buff::cb for
+ * bus layer usage.
+ */
 /* flag marking a dummy skb added for DMA alignment requirement */
-#define DUMMY_SKB_FLAG		0x10000
+#define ALIGN_SKB_FLAG		0x8000
 /* bit mask of data length chopped from the previous packet */
-#define DUMMY_SKB_CHOP_LEN_MASK	0xffff
+#define ALIGN_SKB_CHOP_LEN_MASK	0x7fff
+
 /**
  * brcmf_sdio_txpkt_prep - packet preparation for transmit
  * @bus: brcmf_sdio structure pointer
@@ -1854,7 +1859,7 @@ brcmf_sdio_txpkt_prep(struct brcmf_sdio *bus, struct sk_buff_head *pktq,
 		memcpy(pkt_new->data,
 		       pkt_next->data + pkt_next->len - tail_chop,
 		       tail_chop);
-		*(u32 *)(pkt_new->cb) = DUMMY_SKB_FLAG + tail_chop;
+		*(u32 *)(pkt_new->cb) = ALIGN_SKB_FLAG + tail_chop;
 		skb_trim(pkt_next, pkt_next->len - tail_chop);
 		__skb_queue_after(pktq, pkt_next, pkt_new);
 	} else {
@@ -1908,8 +1913,8 @@ brcmf_sdio_txpkt_postp(struct brcmf_sdio *bus, struct sk_buff_head *pktq)
 
 	skb_queue_walk_safe(pktq, pkt_next, tmp) {
 		dummy_flags = *(u32 *)(pkt_next->cb);
-		if (dummy_flags & DUMMY_SKB_FLAG) {
-			chop_len = dummy_flags & DUMMY_SKB_CHOP_LEN_MASK;
+		if (dummy_flags & ALIGN_SKB_FLAG) {
+			chop_len = dummy_flags & ALIGN_SKB_CHOP_LEN_MASK;
 			if (chop_len) {
 				pkt_prev = pkt_next->prev;
 				memcpy(pkt_prev->data + pkt_prev->len,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 82f9140..d0cd0bf 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -168,6 +168,7 @@ enum brcmf_fws_skb_state {
 /**
  * struct brcmf_skbuff_cb - control buffer associated with skbuff.
  *
+ * @bus_flags: 2 bytes reserved for bus specific parameters
  * @if_flags: holds interface index and packet related flags.
  * @htod: host to device packet identifier (used in PKTTAG tlv).
  * @state: transmit state of the packet.
@@ -177,6 +178,7 @@ enum brcmf_fws_skb_state {
  * provides 48 bytes of storage so this structure should not exceed that.
  */
 struct brcmf_skbuff_cb {
+	u16 bus_flags;
 	u16 if_flags;
 	u32 htod;
 	enum brcmf_fws_skb_state state;
-- 
1.7.10.4


