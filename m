Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1868 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754762Ab3FRL3q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 07:29:46 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 4/8] brcmfmac: consolidate mac_descriptor related
 function names
Date: Tue, 18 Jun 2013 13:29:25 +0200
Message-ID: <1371554970-23495-5-git-send-email-arend@broadcom.com> (sfid-20130618_133002_623779_C1408CC4)
In-Reply-To: <1371554970-23495-1-git-send-email-arend@broadcom.com>
References: <1371554970-23495-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just cleaning up and being consistent in naming operations
related to struct brcmf_fws_mac_descriptor objects.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |   53 ++++++++++----------
 1 file changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index b702f3e..13e75c4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -631,8 +631,8 @@ static void brcmf_fws_macdesc_set_name(struct brcmf_fws_info *fws,
 			  desc->interface_id);
 }
 
-static void brcmf_fws_init_mac_descriptor(struct brcmf_fws_mac_descriptor *desc,
-					  u8 *addr, u8 ifidx)
+static void brcmf_fws_macdesc_init(struct brcmf_fws_mac_descriptor *desc,
+				   u8 *addr, u8 ifidx)
 {
 	brcmf_dbg(TRACE,
 		  "enter: desc %p ea=%pM, ifidx=%u\n", desc, addr, ifidx);
@@ -648,7 +648,7 @@ static void brcmf_fws_init_mac_descriptor(struct brcmf_fws_mac_descriptor *desc,
 }
 
 static
-void brcmf_fws_clear_mac_descriptor(struct brcmf_fws_mac_descriptor *desc)
+void brcmf_fws_macdesc_deinit(struct brcmf_fws_mac_descriptor *desc)
 {
 	brcmf_dbg(TRACE,
 		  "enter: ea=%pM, ifidx=%u\n", desc->ea, desc->interface_id);
@@ -659,7 +659,7 @@ void brcmf_fws_clear_mac_descriptor(struct brcmf_fws_mac_descriptor *desc)
 }
 
 static struct brcmf_fws_mac_descriptor *
-brcmf_fws_mac_descriptor_lookup(struct brcmf_fws_info *fws, u8 *ea)
+brcmf_fws_macdesc_lookup(struct brcmf_fws_info *fws, u8 *ea)
 {
 	struct brcmf_fws_mac_descriptor *entry;
 	int i;
@@ -678,8 +678,7 @@ brcmf_fws_mac_descriptor_lookup(struct brcmf_fws_info *fws, u8 *ea)
 }
 
 static struct brcmf_fws_mac_descriptor*
-brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, struct brcmf_if *ifp,
-			u8 *da)
+brcmf_fws_macdesc_find(struct brcmf_fws_info *fws, struct brcmf_if *ifp, u8 *da)
 {
 	struct brcmf_fws_mac_descriptor *entry = &fws->desc.other;
 	bool multicast;
@@ -695,7 +694,7 @@ brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, struct brcmf_if *ifp,
 		goto done;
 	}
 
-	entry = brcmf_fws_mac_descriptor_lookup(fws, da);
+	entry = brcmf_fws_macdesc_lookup(fws, da);
 	if (IS_ERR(entry))
 		entry = ifp->fws_desc;
 
@@ -703,9 +702,9 @@ done:
 	return entry;
 }
 
-static bool brcmf_fws_mac_desc_closed(struct brcmf_fws_info *fws,
-				      struct brcmf_fws_mac_descriptor *entry,
-				      int fifo)
+static bool brcmf_fws_macdesc_closed(struct brcmf_fws_info *fws,
+				     struct brcmf_fws_mac_descriptor *entry,
+				     int fifo)
 {
 	struct brcmf_fws_mac_descriptor *if_entry;
 	bool closed;
@@ -728,9 +727,9 @@ static bool brcmf_fws_mac_desc_closed(struct brcmf_fws_info *fws,
 	return closed || !(entry->ac_bitmap & BIT(fifo));
 }
 
-static void brcmf_fws_mac_desc_cleanup(struct brcmf_fws_info *fws,
-				       struct brcmf_fws_mac_descriptor *entry,
-				       int ifidx)
+static void brcmf_fws_macdesc_cleanup(struct brcmf_fws_info *fws,
+				      struct brcmf_fws_mac_descriptor *entry,
+				      int ifidx)
 {
 	if (entry->occupied && (ifidx == -1 || ifidx == entry->interface_id)) {
 		brcmf_fws_psq_flush(fws, &entry->psq, ifidx);
@@ -782,9 +781,9 @@ static void brcmf_fws_cleanup(struct brcmf_fws_info *fws, int ifidx)
 	/* cleanup individual nodes */
 	table = &fws->desc.nodes[0];
 	for (i = 0; i < ARRAY_SIZE(fws->desc.nodes); i++)
-		brcmf_fws_mac_desc_cleanup(fws, &table[i], ifidx);
+		brcmf_fws_macdesc_cleanup(fws, &table[i], ifidx);
 
-	brcmf_fws_mac_desc_cleanup(fws, &fws->desc.other, ifidx);
+	brcmf_fws_macdesc_cleanup(fws, &fws->desc.other, ifidx);
 	brcmf_fws_bus_txq_cleanup(fws, matchfn, ifidx);
 	brcmf_fws_hanger_cleanup(fws, matchfn, ifidx);
 }
@@ -924,18 +923,18 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 		if (entry->occupied) {
 			brcmf_dbg(TRACE, "deleting %s mac %pM\n",
 				  entry->name, addr);
-			brcmf_fws_mac_desc_cleanup(fws, entry, -1);
-			brcmf_fws_clear_mac_descriptor(entry);
+			brcmf_fws_macdesc_cleanup(fws, entry, -1);
+			brcmf_fws_macdesc_deinit(entry);
 		} else
 			fws->stats.mac_update_failed++;
 		return 0;
 	}
 
-	existing = brcmf_fws_mac_descriptor_lookup(fws, addr);
+	existing = brcmf_fws_macdesc_lookup(fws, addr);
 	if (IS_ERR(existing)) {
 		if (!entry->occupied) {
 			entry->mac_handle = mac_handle;
-			brcmf_fws_init_mac_descriptor(entry, addr, ifidx);
+			brcmf_fws_macdesc_init(entry, addr, ifidx);
 			brcmf_fws_macdesc_set_name(fws, entry);
 			brcmu_pktq_init(&entry->psq, BRCMF_FWS_PSQ_PREC_COUNT,
 					BRCMF_FWS_PSQ_LEN);
@@ -949,7 +948,7 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 			memcpy(entry, existing,
 			       offsetof(struct brcmf_fws_mac_descriptor, psq));
 			entry->mac_handle = mac_handle;
-			brcmf_fws_clear_mac_descriptor(existing);
+			brcmf_fws_macdesc_deinit(existing);
 			brcmf_fws_macdesc_set_name(fws, entry);
 			brcmf_dbg(TRACE, "relocate %s mac %pM\n", entry->name,
 				  addr);
@@ -1189,7 +1188,7 @@ static struct sk_buff *brcmf_fws_deq(struct brcmf_fws_info *fws, int fifo)
 	for (i = 0; i < num_nodes; i++) {
 		entry = &table[(node_pos + i) % num_nodes];
 		if (!entry->occupied ||
-		    brcmf_fws_mac_desc_closed(fws, entry, fifo))
+		    brcmf_fws_macdesc_closed(fws, entry, fifo))
 			continue;
 
 		if (entry->suppressed)
@@ -1810,7 +1809,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	/* set control buffer information */
 	skcb->if_flags = 0;
-	skcb->mac = brcmf_fws_find_mac_desc(fws, ifp, eh->h_dest);
+	skcb->mac = brcmf_fws_macdesc_find(fws, ifp, eh->h_dest);
 	skcb->state = BRCMF_FWS_SKBSTATE_NEW;
 	brcmf_skb_if_flags_set_field(skb, INDEX, ifp->ifidx);
 	if (!multicast)
@@ -1828,7 +1827,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 
 	if (skcb->mac->suppressed ||
 	    fws->bus_flow_blocked ||
-	    brcmf_fws_mac_desc_closed(fws, skcb->mac, fifo) ||
+	    brcmf_fws_macdesc_closed(fws, skcb->mac, fifo) ||
 	    brcmu_pktq_mlen(&skcb->mac->psq, 3 << (fifo * 2)) ||
 	    (!multicast &&
 	     brcmf_fws_consume_credit(fws, fifo, skb) < 0)) {
@@ -1850,7 +1849,7 @@ void brcmf_fws_reset_interface(struct brcmf_if *ifp)
 	if (!entry)
 		return;
 
-	brcmf_fws_init_mac_descriptor(entry, ifp->mac_addr, ifp->ifidx);
+	brcmf_fws_macdesc_init(entry, ifp->mac_addr, ifp->ifidx);
 }
 
 void brcmf_fws_add_interface(struct brcmf_if *ifp)
@@ -1863,7 +1862,7 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp)
 
 	entry = &fws->desc.iface[ifp->ifidx];
 	ifp->fws_desc = entry;
-	brcmf_fws_init_mac_descriptor(entry, ifp->mac_addr, ifp->ifidx);
+	brcmf_fws_macdesc_init(entry, ifp->mac_addr, ifp->ifidx);
 	brcmf_fws_macdesc_set_name(fws, entry);
 	brcmu_pktq_init(&entry->psq, BRCMF_FWS_PSQ_PREC_COUNT,
 			BRCMF_FWS_PSQ_LEN);
@@ -1881,7 +1880,7 @@ void brcmf_fws_del_interface(struct brcmf_if *ifp)
 	brcmf_fws_lock(ifp->drvr, flags);
 	ifp->fws_desc = NULL;
 	brcmf_dbg(TRACE, "deleting %s\n", entry->name);
-	brcmf_fws_clear_mac_descriptor(entry);
+	brcmf_fws_macdesc_deinit(entry);
 	brcmf_fws_cleanup(ifp->drvr->fws, ifp->ifidx);
 	brcmf_fws_unlock(ifp->drvr, flags);
 }
@@ -1986,7 +1985,7 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	}
 
 	brcmf_fws_hanger_init(&drvr->fws->hanger);
-	brcmf_fws_init_mac_descriptor(&drvr->fws->desc.other, NULL, 0);
+	brcmf_fws_macdesc_init(&drvr->fws->desc.other, NULL, 0);
 	brcmf_fws_macdesc_set_name(drvr->fws, &drvr->fws->desc.other);
 	brcmu_pktq_init(&drvr->fws->desc.other.psq, BRCMF_FWS_PSQ_PREC_COUNT,
 			BRCMF_FWS_PSQ_LEN);
-- 
1.7.10.4


