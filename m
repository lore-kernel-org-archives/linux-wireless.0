Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4467 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760476Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 12/25] brcmfmac: add firmware-signalling hanger
 functions
Date: Wed, 3 Apr 2013 12:40:37 +0200
Message-ID: <1364985650-11719-13-git-send-email-arend@broadcom.com> (sfid-20130403_124307_828819_F4C851A5)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The hanger for firmware-signalling is used to retain information for
outstanding transmit packets that await tx status.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  197 ++++++++++++++++++++
 1 file changed, 197 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index b123a80..a6443c6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -267,9 +267,64 @@ struct brcmf_fws_mac_descriptor {
 	struct pktq psq;
 };
 
+#define BRCMF_FWS_HANGER_MAXITEMS	1024
+
+/**
+ * enum brcmf_fws_hanger_item_state - state of hanger item.
+ *
+ * @WLFC_HANGER_ITEM_STATE_FREE: item is free for use.
+ * @WLFC_HANGER_ITEM_STATE_INUSE: item is in use.
+ * @WLFC_HANGER_ITEM_STATE_INUSE_SUPPRESSED: item was suppressed.
+ */
+enum brcmf_fws_hanger_item_state {
+	WLFC_HANGER_ITEM_STATE_FREE = 1,
+	WLFC_HANGER_ITEM_STATE_INUSE,
+	WLFC_HANGER_ITEM_STATE_INUSE_SUPPRESSED
+};
+
+
+/**
+ * struct brcmf_fws_hanger_item - single entry for tx pending packet.
+ *
+ * @state: entry is either free or occupied.
+ * @gen: generation.
+ * @identifier: packet identifier.
+ * @pkt: packet itself.
+ */
+struct brcmf_fws_hanger_item {
+	enum brcmf_fws_hanger_item_state state;
+	u8 gen;
+	u8 pad[2];
+	u32 identifier;
+	struct sk_buff *pkt;
+};
+
+/**
+ * struct brcmf_fws_hanger - holds packets awaiting firmware txstatus.
+ *
+ * @max_items: number of packets it can hold.
+ * @pushed: packets pushed to await txstatus.
+ * @popped: packets popped upon handling txstatus.
+ * @failed_to_push: packets that could not be pushed.
+ * @failed_to_pop: packets that could not be popped.
+ * @failed_slotfind: packets for which failed to find an entry.
+ * @slot_pos: last returned item index for a free entry.
+ * @items: array of hanger items.
+ */
+struct brcmf_fws_hanger {
+	u32 pushed;
+	u32 popped;
+	u32 failed_to_push;
+	u32 failed_to_pop;
+	u32 failed_slotfind;
+	u32 slot_pos;
+	struct brcmf_fws_hanger_item items[BRCMF_FWS_HANGER_MAXITEMS];
+};
+
 struct brcmf_fws_info {
 	struct brcmf_pub *drvr;
 	struct brcmf_fws_stats stats;
+	struct brcmf_fws_hanger hanger;
 	struct brcmf_fws_mac_descriptor nodes[BRCMF_FWS_MAC_DESC_TABLE_SIZE];
 	struct brcmf_fws_mac_descriptor other;
 	int fifo_credit[NL80211_NUM_ACS+1+1];
@@ -296,6 +351,145 @@ static int brcmf_fws_get_tlv_len(struct brcmf_fws_info *fws,
 }
 #undef BRCMF_FWS_TLV_DEF
 
+static void brcmf_fws_hanger_init(struct brcmf_fws_hanger *hanger)
+{
+	int i;
+
+	brcmf_dbg(TRACE, "enter\n");
+	memset(hanger, 0, sizeof(*hanger));
+	for (i = 0; i < ARRAY_SIZE(hanger->items); i++)
+		hanger->items[i].state = WLFC_HANGER_ITEM_STATE_FREE;
+}
+
+static __used u32 brcmf_fws_hanger_get_free_slot(struct brcmf_fws_hanger *h)
+{
+	u32 i;
+
+	brcmf_dbg(TRACE, "enter\n");
+	i = (h->slot_pos + 1) % BRCMF_FWS_HANGER_MAXITEMS;
+
+	while (i != h->slot_pos) {
+		if (h->items[i].state == WLFC_HANGER_ITEM_STATE_FREE) {
+			h->slot_pos = i;
+			return i;
+		}
+		i++;
+		if (i == BRCMF_FWS_HANGER_MAXITEMS)
+			i = 0;
+	}
+	brcmf_err("all slots occupied\n");
+	h->failed_slotfind++;
+	return BRCMF_FWS_HANGER_MAXITEMS;
+}
+
+static __used int brcmf_fws_hanger_pushpkt(struct brcmf_fws_hanger *h,
+					   struct sk_buff *pkt, u32 slot_id)
+{
+	brcmf_dbg(TRACE, "enter\n");
+	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
+		return -ENOENT;
+
+	if (h->items[slot_id].state != BRCMF_FWS_HANGER_ITEM_STATE_FREE) {
+		brcmf_err("slot is not free\n");
+		h->failed_to_push++;
+		return -EINVAL;
+	}
+
+	h->items[slot_id].state = BRCMF_FWS_HANGER_ITEM_STATE_INUSE;
+	h->items[slot_id].pkt = pkt;
+	h->items[slot_id].identifier = slot_id;
+	h->pushed++;
+	return 0;
+}
+
+static __used int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
+					  u32 slot_id, struct sk_buff **pktout,
+					  bool remove_item)
+{
+	brcmf_dbg(TRACE, "enter\n");
+	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
+		return -ENOENT;
+
+	if (h->items[slot_id].state == BRCMF_FWS_HANGER_ITEM_STATE_FREE) {
+		brcmf_err("entry not in use\n");
+		h->failed_to_pop++;
+		return -EINVAL;
+	}
+
+	*pktout = h->items[slot_id].pkt;
+	if (remove_item) {
+		h->items[slot_id].state = BRCMF_FWS_HANGER_ITEM_STATE_FREE;
+		h->items[slot_id].pkt = NULL;
+		h->items[slot_id].identifier = 0;
+		h->items[slot_id].gen = 0xff;
+		h->popped++;
+	}
+	return 0;
+}
+
+static __used int brcmf_fws_hanger_mark_suppressed(struct brcmf_fws_hanger *h,
+						   u32 slot_id, u8 gen)
+{
+	brcmf_dbg(TRACE, "enter\n");
+
+	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
+		return -ENOENT;
+
+	h->items[slot_id].gen = gen;
+
+	if (h->items[slot_id].state != WLFC_HANGER_ITEM_STATE_INUSE) {
+		brcmf_err("entry not in use\n");
+		return -EINVAL;
+	}
+
+	h->items[slot_id].state = WLFC_HANGER_ITEM_STATE_INUSE_SUPPRESSED;
+	return 0;
+}
+
+static __used int brcmf_fws_hanger_get_genbit(struct brcmf_fws_hanger *hanger,
+					      struct sk_buff *pkt, u32 slot_id,
+					      int *gen)
+{
+	brcmf_dbg(TRACE, "enter\n");
+	*gen = 0xff;
+
+	if (slot_id >= BRCMF_FWS_HANGER_MAXITEMS)
+		return -ENOENT;
+
+	if (hanger->items[slot_id].state == BRCMF_FWS_HANGER_ITEM_STATE_FREE) {
+		brcmf_err("slot not in use\n");
+		return -EINVAL;
+	}
+
+	*gen = hanger->items[slot_id].gen;
+	return 0;
+}
+
+static void brcmf_fws_hanger_cleanup(struct brcmf_fws_hanger *h,
+				     bool (*fn)(struct sk_buff *, void *),
+				     int ifidx)
+{
+	struct sk_buff *skb;
+	int i;
+	enum brcmf_fws_hanger_item_state s;
+
+	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
+	for (i = 0; i < ARRAY_SIZE(h->items); i++) {
+		s = h->items[i].state;
+		if (s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE ||
+		    s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED) {
+			skb = h->items[i].pkt;
+			if (fn == NULL || fn(skb, &ifidx)) {
+				/* suppress packets freed from psq */
+				if (s == BRCMF_FWS_HANGER_ITEM_STATE_INUSE)
+					brcmu_pkt_buf_free_skb(skb);
+				h->items[i].state =
+					BRCMF_FWS_HANGER_ITEM_STATE_FREE;
+			}
+		}
+	}
+}
+
 static void brcmf_fws_init_mac_descriptor(struct brcmf_fws_mac_descriptor *desc,
 					  u8 *addr, u8 ifidx)
 {
@@ -379,6 +573,7 @@ static void brcmf_fws_cleanup(struct brcmf_fws_info *fws, int ifidx)
 		brcmf_fws_mac_desc_cleanup(&table[i], matchfn, ifidx);
 
 	brcmf_fws_mac_desc_cleanup(&fws->other, matchfn, ifidx);
+	brcmf_fws_hanger_cleanup(&fws->hanger, matchfn, ifidx);
 }
 
 static int brcmf_fws_rssi_indicate(struct brcmf_fws_info *fws, s8 rssi)
@@ -511,6 +706,8 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 		goto fail;
 	}
 
+	brcmf_fws_hanger_init(&drvr->fws->hanger);
+
 	/* create debugfs file for statistics */
 	brcmf_debugfs_create_fws_stats(drvr, &drvr->fws->stats);
 
-- 
1.7.10.4


