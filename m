Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1673 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S968548Ab3HJK1q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:27:46 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 03/12] brcmfmac: add AMPDU reordering functionality
Date: Sat, 10 Aug 2013 12:27:21 +0200
Message-ID: <1376130450-29746-4-git-send-email-arend@broadcom.com> (sfid-20130810_122817_508470_AAFCE7C0)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This feature moves the responsibility of collecting all MPDUs in an
AMPDU session in the correct order from the firmware to the host
driver. This reduces buffer requirement on the firmware side.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |  27 +++
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    | 270 +++++++++++++++++++--
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  13 +-
 3 files changed, 283 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 86cbfe2..3943fb8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -209,6 +209,8 @@
 #define BRCMF_DCMD_MEDLEN	1536
 #define BRCMF_DCMD_MAXLEN	8192
 
+#define BRCMF_AMPDU_RX_REORDER_MAXFLOWS		256
+
 /* Pattern matching filter. Specifies an offset within received packets to
  * start matching, the pattern to match, the size of the pattern, and a bitmask
  * that indicates which bits within the pattern should be matched.
@@ -505,6 +507,25 @@ struct brcmf_dcmd {
 	uint needed;		/* bytes needed (optional) */
 };
 
+/**
+ * struct brcmf_ampdu_rx_reorder - AMPDU receive reorder info
+ *
+ * @pktslots: dynamic allocated array for ordering AMPDU packets.
+ * @flow_id: AMPDU flow identifier.
+ * @cur_idx: last AMPDU index from firmware.
+ * @exp_idx: expected next AMPDU index.
+ * @max_idx: maximum amount of packets per AMPDU.
+ * @pend_pkts: number of packets currently in @pktslots.
+ */
+struct brcmf_ampdu_rx_reorder {
+	struct sk_buff **pktslots;
+	u8 flow_id;
+	u8 cur_idx;
+	u8 exp_idx;
+	u8 max_idx;
+	u8 pend_pkts;
+};
+
 /* Forward decls for struct brcmf_pub (see below) */
 struct brcmf_proto;	/* device communication protocol info */
 struct brcmf_cfg80211_dev; /* cfg80211 device info */
@@ -539,6 +560,9 @@ struct brcmf_pub {
 	bool fw_signals;
 	struct brcmf_fws_info *fws;
 	spinlock_t fws_spinlock;
+
+	struct brcmf_ampdu_rx_reorder
+		*reorder_flows[BRCMF_AMPDU_RX_REORDER_MAXFLOWS];
 #ifdef DEBUG
 	struct dentry *dbgfs_dir;
 #endif
@@ -604,6 +628,9 @@ struct brcmf_if {
 	wait_queue_head_t pend_8021x_wait;
 };
 
+struct brcmf_skb_reorder_data {
+	u8 *reorder;
+};
 
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 8009901..9bc2785 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -38,6 +38,19 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 #define MAX_WAIT_FOR_8021X_TX		50	/* msecs */
 
+/* AMPDU rx reordering definitions */
+#define BRCMF_RXREORDER_FLOWID_OFFSET		0
+#define BRCMF_RXREORDER_MAXIDX_OFFSET		2
+#define BRCMF_RXREORDER_FLAGS_OFFSET		4
+#define BRCMF_RXREORDER_CURIDX_OFFSET		6
+#define BRCMF_RXREORDER_EXPIDX_OFFSET		8
+
+#define BRCMF_RXREORDER_DEL_FLOW		0x01
+#define BRCMF_RXREORDER_FLUSH_ALL		0x02
+#define BRCMF_RXREORDER_CURIDX_VALID		0x04
+#define BRCMF_RXREORDER_EXPIDX_VALID		0x08
+#define BRCMF_RXREORDER_NEW_HOLE		0x10
+
 /* Error bits */
 int brcmf_msg_level;
 module_param_named(debug, brcmf_msg_level, int, S_IRUSR | S_IWUSR);
@@ -279,16 +292,243 @@ void brcmf_txflowblock(struct device *dev, bool state)
 	}
 }
 
+static void brcmf_netif_rx(struct brcmf_if *ifp, struct sk_buff *skb)
+{
+	skb->dev = ifp->ndev;
+	skb->protocol = eth_type_trans(skb, skb->dev);
+
+	if (skb->pkt_type == PACKET_MULTICAST)
+		ifp->stats.multicast++;
+
+	/* Process special event packets */
+	brcmf_fweh_process_skb(ifp->drvr, skb);
+
+	if (!(ifp->ndev->flags & IFF_UP)) {
+		brcmu_pkt_buf_free_skb(skb);
+		return;
+	}
+
+	ifp->stats.rx_bytes += skb->len;
+	ifp->stats.rx_packets++;
+
+	brcmf_dbg(DATA, "rx proto=0x%X\n", ntohs(skb->protocol));
+	if (in_interrupt())
+		netif_rx(skb);
+	else
+		/* If the receive is not processed inside an ISR,
+		 * the softirqd must be woken explicitly to service
+		 * the NET_RX_SOFTIRQ.  This is handled by netif_rx_ni().
+		 */
+		netif_rx_ni(skb);
+}
+
+static void brcmf_rxreorder_get_skb_list(struct brcmf_ampdu_rx_reorder *rfi,
+					 u8 start, u8 end,
+					 struct sk_buff_head *skb_list)
+{
+	/* initialize return list */
+	__skb_queue_head_init(skb_list);
+
+	if (rfi->pend_pkts == 0) {
+		brcmf_dbg(INFO, "no packets in reorder queue\n");
+		return;
+	}
+
+	do {
+		if (rfi->pktslots[start]) {
+			__skb_queue_tail(skb_list, rfi->pktslots[start]);
+			rfi->pktslots[start] = NULL;
+		}
+		start++;
+		if (start > rfi->max_idx)
+			start = 0;
+	} while (start != end);
+	rfi->pend_pkts -= skb_queue_len(skb_list);
+}
+
+static void brcmf_rxreorder_process_info(struct brcmf_if *ifp, u8 *reorder_data,
+					 struct sk_buff *pkt)
+{
+	u8 flow_id, max_idx, cur_idx, exp_idx, end_idx;
+	struct brcmf_ampdu_rx_reorder *rfi;
+	struct sk_buff_head reorder_list;
+	struct sk_buff *pnext;
+	u8 flags;
+	u32 buf_size;
+
+	flow_id = reorder_data[BRCMF_RXREORDER_FLOWID_OFFSET];
+	flags = reorder_data[BRCMF_RXREORDER_FLAGS_OFFSET];
+
+	/* validate flags and flow id */
+	if (flags == 0xFF) {
+		brcmf_err("invalid flags...so ignore this packet\n");
+		brcmf_netif_rx(ifp, pkt);
+		return;
+	}
+
+	rfi = ifp->drvr->reorder_flows[flow_id];
+	if (flags & BRCMF_RXREORDER_DEL_FLOW) {
+		brcmf_dbg(INFO, "flow-%d: delete\n",
+			  flow_id);
+
+		if (rfi == NULL) {
+			brcmf_dbg(INFO, "received flags to cleanup, but no flow (%d) yet\n",
+				  flow_id);
+			brcmf_netif_rx(ifp, pkt);
+			return;
+		}
+
+		brcmf_rxreorder_get_skb_list(rfi, rfi->exp_idx, rfi->exp_idx,
+					     &reorder_list);
+		/* add the last packet */
+		__skb_queue_tail(&reorder_list, pkt);
+		kfree(rfi);
+		ifp->drvr->reorder_flows[flow_id] = NULL;
+		goto netif_rx;
+	}
+	/* from here on we need a flow reorder instance */
+	if (rfi == NULL) {
+		buf_size = sizeof(*rfi);
+		max_idx = reorder_data[BRCMF_RXREORDER_MAXIDX_OFFSET];
+
+		buf_size += (max_idx + 1) * sizeof(pkt);
+
+		/* allocate space for flow reorder info */
+		brcmf_dbg(INFO, "flow-%d: start, maxidx %d\n",
+			  flow_id, max_idx);
+		rfi = kzalloc(buf_size, GFP_ATOMIC);
+		if (rfi == NULL) {
+			brcmf_err("failed to alloc buffer\n");
+			brcmf_netif_rx(ifp, pkt);
+			return;
+		}
+
+		ifp->drvr->reorder_flows[flow_id] = rfi;
+		rfi->pktslots = (struct sk_buff **)(rfi+1);
+		rfi->max_idx = max_idx;
+	}
+	if (flags & BRCMF_RXREORDER_NEW_HOLE)  {
+		if (rfi->pend_pkts) {
+			brcmf_rxreorder_get_skb_list(rfi, rfi->exp_idx,
+						     rfi->exp_idx,
+						     &reorder_list);
+			WARN_ON(rfi->pend_pkts);
+		} else {
+			__skb_queue_head_init(&reorder_list);
+		}
+		rfi->cur_idx = reorder_data[BRCMF_RXREORDER_CURIDX_OFFSET];
+		rfi->exp_idx = reorder_data[BRCMF_RXREORDER_EXPIDX_OFFSET];
+		rfi->max_idx = reorder_data[BRCMF_RXREORDER_MAXIDX_OFFSET];
+		rfi->pktslots[rfi->cur_idx] = pkt;
+		rfi->pend_pkts++;
+		brcmf_dbg(DATA, "flow-%d: new hole %d (%d), pending %d\n",
+			  flow_id, rfi->cur_idx, rfi->exp_idx, rfi->pend_pkts);
+	} else if (flags & BRCMF_RXREORDER_CURIDX_VALID) {
+		cur_idx = reorder_data[BRCMF_RXREORDER_CURIDX_OFFSET];
+		exp_idx = reorder_data[BRCMF_RXREORDER_EXPIDX_OFFSET];
+
+		if ((exp_idx == rfi->exp_idx) && (cur_idx != rfi->exp_idx)) {
+			/* still in the current hole */
+			/* enqueue the current on the buffer chain */
+			if (rfi->pktslots[cur_idx] != NULL) {
+				brcmf_dbg(INFO, "HOLE: ERROR buffer pending..free it\n");
+				brcmu_pkt_buf_free_skb(rfi->pktslots[cur_idx]);
+				rfi->pktslots[cur_idx] = NULL;
+			}
+			rfi->pktslots[cur_idx] = pkt;
+			rfi->pend_pkts++;
+			rfi->cur_idx = cur_idx;
+			brcmf_dbg(DATA, "flow-%d: store pkt %d (%d), pending %d\n",
+				  flow_id, cur_idx, exp_idx, rfi->pend_pkts);
+
+			/* can return now as there is no reorder
+			 * list to process.
+			 */
+			return;
+		}
+		if (rfi->exp_idx == cur_idx) {
+			if (rfi->pktslots[cur_idx] != NULL) {
+				brcmf_dbg(INFO, "error buffer pending..free it\n");
+				brcmu_pkt_buf_free_skb(rfi->pktslots[cur_idx]);
+				rfi->pktslots[cur_idx] = NULL;
+			}
+			rfi->pktslots[cur_idx] = pkt;
+			rfi->pend_pkts++;
+
+			/* got the expected one. flush from current to expected
+			 * and update expected
+			 */
+			brcmf_dbg(DATA, "flow-%d: expected %d (%d), pending %d\n",
+				  flow_id, cur_idx, exp_idx, rfi->pend_pkts);
+
+			rfi->cur_idx = cur_idx;
+			rfi->exp_idx = exp_idx;
+
+			brcmf_rxreorder_get_skb_list(rfi, cur_idx, exp_idx,
+						     &reorder_list);
+			brcmf_dbg(DATA, "flow-%d: freeing buffers %d, pending %d\n",
+				  flow_id, skb_queue_len(&reorder_list),
+				  rfi->pend_pkts);
+		} else {
+			u8 end_idx;
+
+			brcmf_dbg(DATA, "flow-%d (0x%x): both moved, old %d/%d, new %d/%d\n",
+				  flow_id, flags, rfi->cur_idx, rfi->exp_idx,
+				  cur_idx, exp_idx);
+			if (flags & BRCMF_RXREORDER_FLUSH_ALL)
+				end_idx = rfi->exp_idx;
+			else
+				end_idx = exp_idx;
+
+			/* flush pkts first */
+			brcmf_rxreorder_get_skb_list(rfi, rfi->exp_idx, end_idx,
+						     &reorder_list);
+
+			if (exp_idx == ((cur_idx + 1) % (rfi->max_idx + 1))) {
+				__skb_queue_tail(&reorder_list, pkt);
+			} else {
+				rfi->pktslots[cur_idx] = pkt;
+				rfi->pend_pkts++;
+			}
+			rfi->exp_idx = exp_idx;
+			rfi->cur_idx = cur_idx;
+		}
+	} else {
+		/* explicity window move updating the expected index */
+		exp_idx = reorder_data[BRCMF_RXREORDER_EXPIDX_OFFSET];
+
+		brcmf_dbg(DATA, "flow-%d (0x%x): change expected: %d -> %d\n",
+			  flow_id, flags, rfi->exp_idx, exp_idx);
+		if (flags & BRCMF_RXREORDER_FLUSH_ALL)
+			end_idx =  rfi->exp_idx;
+		else
+			end_idx =  exp_idx;
+
+		brcmf_rxreorder_get_skb_list(rfi, rfi->exp_idx, end_idx,
+					     &reorder_list);
+		__skb_queue_tail(&reorder_list, pkt);
+		/* set the new expected idx */
+		rfi->exp_idx = exp_idx;
+	}
+netif_rx:
+	skb_queue_walk_safe(&reorder_list, pkt, pnext) {
+		__skb_unlink(pkt, &reorder_list);
+		brcmf_netif_rx(ifp, pkt);
+	}
+}
+
 void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 {
 	struct sk_buff *skb, *pnext;
 	struct brcmf_if *ifp;
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
+	struct brcmf_skb_reorder_data *rd;
 	u8 ifidx;
 	int ret;
 
-	brcmf_dbg(DATA, "Enter\n");
+	brcmf_dbg(DATA, "Enter: %s: count=%u\n", dev_name(dev),
+		  skb_queue_len(skb_list));
 
 	skb_queue_walk_safe(skb_list, skb, pnext) {
 		skb_unlink(skb, skb_list);
@@ -304,31 +544,11 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 			continue;
 		}
 
-		skb->dev = ifp->ndev;
-		skb->protocol = eth_type_trans(skb, skb->dev);
-
-		if (skb->pkt_type == PACKET_MULTICAST)
-			ifp->stats.multicast++;
-
-		/* Process special event packets */
-		brcmf_fweh_process_skb(drvr, skb);
-
-		if (!(ifp->ndev->flags & IFF_UP)) {
-			brcmu_pkt_buf_free_skb(skb);
-			continue;
-		}
-
-		ifp->stats.rx_bytes += skb->len;
-		ifp->stats.rx_packets++;
-
-		if (in_interrupt())
-			netif_rx(skb);
+		rd = (struct brcmf_skb_reorder_data *)skb->cb;
+		if (rd->reorder)
+			brcmf_rxreorder_process_info(ifp, rd->reorder, skb);
 		else
-			/* If the receive is not processed inside an ISR,
-			 * the softirqd must be woken explicitly to service the
-			 * NET_RX_SOFTIRQ. This is handled by netif_rx_ni().
-			 */
-			netif_rx_ni(skb);
+			brcmf_netif_rx(ifp, skb);
 	}
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 601b0d0..438c7b9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -1483,6 +1483,7 @@ static int brcmf_fws_notify_bcmc_credit_support(struct brcmf_if *ifp,
 int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		      struct sk_buff *skb)
 {
+	struct brcmf_skb_reorder_data *rd;
 	struct brcmf_fws_info *fws = drvr->fws;
 	u8 *signal_data;
 	s16 data_len;
@@ -1536,9 +1537,12 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 
 		err = BRCMF_FWS_RET_OK_NOSCHEDULE;
 		switch (type) {
-		case BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS:
 		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
 			break;
+		case BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS:
+			rd = (struct brcmf_skb_reorder_data *)skb->cb;
+			rd->reorder = data;
+			break;
 		case BRCMF_FWS_TYPE_MACDESC_ADD:
 		case BRCMF_FWS_TYPE_MACDESC_DEL:
 			brcmf_fws_macdesc_indicate(fws, type, data);
@@ -1747,6 +1751,7 @@ int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
 	bool pae = eh->h_proto == htons(ETH_P_PAE);
 	int ret;
 
+	brcmf_dbg(DATA, "tx proto=0x%X\n", ntohs(eh->h_proto));
 	/* determine the priority */
 	if (!skb->priority)
 		skb->priority = cfg80211_classify8021d(skb);
@@ -1915,7 +1920,8 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	if (drvr->fws->fcmode != BRCMF_FWS_FCMODE_NONE)
 		tlv |= BRCMF_FWS_FLAGS_XONXOFF_SIGNALS |
 		       BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS |
-		       BRCMF_FWS_FLAGS_HOST_PROPTXSTATUS_ACTIVE;
+		       BRCMF_FWS_FLAGS_HOST_PROPTXSTATUS_ACTIVE |
+		       BRCMF_FWS_FLAGS_HOST_RXREORDER_ACTIVE;
 
 	rc = brcmf_fweh_register(drvr, BRCMF_E_FIFO_CREDIT_MAP,
 				 brcmf_fws_notify_credit_map);
@@ -1940,6 +1946,9 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 		goto fail_event;
 	}
 
+	if (brcmf_fil_iovar_int_set(drvr->iflist[0], "ampdu_hostreorder", 1))
+		brcmf_dbg(INFO, "enabling AMPDU host-reorder failed\n");
+
 	brcmf_fws_hanger_init(&drvr->fws->hanger);
 	brcmf_fws_macdesc_init(&drvr->fws->desc.other, NULL, 0);
 	brcmf_fws_macdesc_set_name(drvr->fws, &drvr->fws->desc.other);
-- 
1.8.1.3


