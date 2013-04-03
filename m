Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4463 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760521Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 15/25] brcmfmac: enable tx status signalling
Date: Wed, 3 Apr 2013 12:40:40 +0200
Message-ID: <1364985650-11719-16-git-send-email-arend@broadcom.com> (sfid-20130403_124308_771427_F02B63A1)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enabling the tx status signalling, which requires packet tagging
before sending to the firmware and handling the tx status signal.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |   30 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    8 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   18 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  485 +++++++++++++++++---
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |    1 +
 5 files changed, 455 insertions(+), 87 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index f0949b1..757701d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -138,16 +138,34 @@ ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
 		return 0;
 
 	res = scnprintf(buf, sizeof(buf),
-			"header_pulls:     %u\n"
-			"header_only_pkt:  %u\n"
-			"tlv_parse_failed: %u\n"
-			"tlv_invalid_type: %u\n"
-			"mac_update_fails: %u\n",
+			"header_pulls:      %u\n"
+			"header_only_pkt:   %u\n"
+			"tlv_parse_failed:  %u\n"
+			"tlv_invalid_type:  %u\n"
+			"mac_update_fails:  %u\n"
+			"pkt2bus:           %u\n"
+			"generic_error:     %u\n"
+			"txs_indicate:      %u\n"
+			"txs_discard:       %u\n"
+			"txs_suppr_core:    %u\n"
+			"txs_suppr_ps:      %u\n"
+			"txs_tossed:        %u\n"
+			"send_pkts:         BK:%u BE:%u VO:%u VI:%u BCMC:%u\n",
 			fwstats->header_pulls,
 			fwstats->header_only_pkt,
 			fwstats->tlv_parse_failed,
 			fwstats->tlv_invalid_type,
-			fwstats->mac_update_failed);
+			fwstats->mac_update_failed,
+			fwstats->pkt2bus,
+			fwstats->generic_error,
+			fwstats->txs_indicate,
+			fwstats->txs_discard,
+			fwstats->txs_supp_core,
+			fwstats->txs_supp_ps,
+			fwstats->txs_tossed,
+			fwstats->send_pkts[0], fwstats->send_pkts[1],
+			fwstats->send_pkts[2], fwstats->send_pkts[3],
+			fwstats->send_pkts[4]);
 
 	return simple_read_from_buffer(data, count, ppos, buf, res);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index 371ae5b..ef93fe4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -137,7 +137,15 @@ struct brcmf_fws_stats {
 	u32 tlv_invalid_type;
 	u32 header_only_pkt;
 	u32 header_pulls;
+	u32 pkt2bus;
+	u32 send_pkts[5];
+	u32 generic_error;
 	u32 mac_update_failed;
+	u32 txs_indicate;
+	u32 txs_discard;
+	u32 txs_supp_core;
+	u32 txs_supp_ps;
+	u32 txs_tossed;
 };
 
 struct brcmf_pub;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 05c8840..0299ab6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -223,18 +223,7 @@ static netdev_tx_t brcmf_netdev_start_xmit(struct sk_buff *skb,
 		goto done;
 	}
 
-	/* handle ethernet header */
-	eh = (struct ethhdr *)(skb->data);
-	if (is_multicast_ether_addr(eh->h_dest))
-		drvr->tx_multicast++;
-	if (ntohs(eh->h_proto) == ETH_P_PAE)
-		atomic_inc(&ifp->pend_8021x_cnt);
-
-	/* If the protocol uses a data header, apply it */
-	brcmf_proto_hdrpush(drvr, ifp->ifidx, 0, skb);
-
-	/* Use bus module to send data frame */
-	ret =  brcmf_bus_txdata(drvr->bus_if, skb);
+	ret = brcmf_fws_process_skb(ifp, skb);
 
 done:
 	if (ret) {
@@ -376,7 +365,7 @@ void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp,
 
 	ifp = drvr->iflist[ifidx];
 	if (!ifp)
-		return;
+		goto done;
 
 	if (res == 0) {
 		eh = (struct ethhdr *)(txp->data);
@@ -390,6 +379,8 @@ void brcmf_txfinalize(struct brcmf_pub *drvr, struct sk_buff *txp,
 	}
 	if (!success)
 		ifp->stats.tx_errors++;
+done:
+	brcmu_pkt_buf_free_skb(txp);
 }
 
 void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
@@ -402,7 +393,6 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 		return;
 
 	brcmf_txfinalize(drvr, txp, success);
-	brcmu_pkt_buf_free_skb(txp);
 }
 
 static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index cb1414d..9389bf7 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -19,12 +19,15 @@
 #include <linux/spinlock.h>
 #include <linux/skbuff.h>
 #include <linux/netdevice.h>
+#include <linux/etherdevice.h>
 #include <linux/err.h>
 #include <uapi/linux/nl80211.h>
+#include <net/cfg80211.h>
 
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include "dhd.h"
+#include "dhd_proto.h"
 #include "dhd_dbg.h"
 #include "dhd_bus.h"
 #include "fwil.h"
@@ -64,7 +67,7 @@
 	BRCMF_FWS_TLV_DEF(COMP_TXSTATUS, 19, 1) \
 	BRCMF_FWS_TLV_DEF(FILLER, 255, 0)
 
-/**
+/*
  * enum brcmf_fws_tlv_type - definition of tlv identifiers.
  */
 #define BRCMF_FWS_TLV_DEF(name, id, len) \
@@ -75,8 +78,18 @@ enum brcmf_fws_tlv_type {
 };
 #undef BRCMF_FWS_TLV_DEF
 
+/*
+ * enum brcmf_fws_tlv_len - definition of tlv lengths.
+ */
+#define BRCMF_FWS_TLV_DEF(name, id, len) \
+	BRCMF_FWS_TYPE_ ## name ## _LEN = (len),
+enum brcmf_fws_tlv_len {
+	BRCMF_FWS_TLV_DEFLIST
+};
+#undef BRCMF_FWS_TLV_DEF
+
 #ifdef DEBUG
-/**
+/*
  * brcmf_fws_tlv_names - array of tlv names.
  */
 #define BRCMF_FWS_TLV_DEF(name, id, len) \
@@ -106,7 +119,7 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 }
 #endif /* DEBUG */
 
-/**
+/*
  * flags used to enable tlv signalling from firmware.
  */
 #define BRCMF_FWS_FLAGS_RSSI_SIGNALS			0x0001
@@ -117,11 +130,6 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 #define BRCMF_FWS_FLAGS_PSQ_ZERO_BUFFER_ENABLE		0x0020
 #define BRCMF_FWS_FLAGS_HOST_RXREORDER_ACTIVE		0x0040
 
-#define BRCMF_FWS_HANGER_MAXITEMS			1024
-#define BRCMF_FWS_HANGER_ITEM_STATE_FREE		1
-#define BRCMF_FWS_HANGER_ITEM_STATE_INUSE		2
-#define BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED	3
-
 #define BRCMF_FWS_STATE_OPEN				1
 #define BRCMF_FWS_STATE_CLOSE				2
 
@@ -135,23 +143,27 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 #define BRCMF_FWS_PSQ_PREC_COUNT		((NL80211_NUM_ACS + 1) * 2)
 #define BRCMF_FWS_PSQ_LEN				256
 
+#define BRCMF_FWS_HTOD_FLAG_PKTFROMHOST			0x01
+#define BRCMF_FWS_HTOD_FLAG_PKT_REQUESTED		0x02
+
 /**
  * enum brcmf_fws_skb_state - indicates processing state of skb.
+ *
+ * @BRCMF_FWS_SKBSTATE_NEW: sk_buff is newly arrived in the driver.
+ * @BRCMF_FWS_SKBSTATE_DELAYED: sk_buff had to wait on queue.
+ * @BRCMF_FWS_SKBSTATE_SUPPRESSED: sk_buff has been suppressed by firmware.
  */
 enum brcmf_fws_skb_state {
-	WLFC_PKTTYPE_NEW,
-	WLFC_PKTTYPE_DELAYED,
-	WLFC_PKTTYPE_SUPPRESSED,
-	WLFC_PKTTYPE_MAX
+	BRCMF_FWS_SKBSTATE_NEW,
+	BRCMF_FWS_SKBSTATE_DELAYED,
+	BRCMF_FWS_SKBSTATE_SUPPRESSED
 };
 
 /**
  * struct brcmf_skbuff_cb - control buffer associated with skbuff.
  *
  * @if_flags: holds interface index and packet related flags.
- * @da: destination MAC address extracted from skbuff once.
  * @htod: host to device packet identifier (used in PKTTAG tlv).
- * @needs_hdr: the packet does not yet have a BDC header.
  * @state: transmit state of the packet.
  * @mac: descriptor related to destination for this packet.
  *
@@ -160,19 +172,17 @@ enum brcmf_fws_skb_state {
  */
 struct brcmf_skbuff_cb {
 	u16 if_flags;
-	u8 da[ETH_ALEN];
 	u32 htod;
-	u8 needs_hdr;
 	enum brcmf_fws_skb_state state;
 	struct brcmf_fws_mac_descriptor *mac;
 };
 
-/**
+/*
  * macro casting skbuff control buffer to struct brcmf_skbuff_cb.
  */
 #define brcmf_skbcb(skb)	((struct brcmf_skbuff_cb *)((skb)->cb))
 
-/**
+/*
  * sk_buff control if flags
  *
  *	b[11]  - packet sent upon firmware request.
@@ -207,7 +217,7 @@ struct brcmf_skbuff_cb {
 			BRCMF_SKB_IF_FLAGS_ ## field ## _MASK, \
 			BRCMF_SKB_IF_FLAGS_ ## field ## _SHIFT)
 
-/**
+/*
  * sk_buff control packet identifier
  *
  * 32-bit packet identifier used in PKTTAG tlv from host to dongle.
@@ -242,6 +252,61 @@ struct brcmf_skbuff_cb {
 			BRCMF_SKB_HTOD_TAG_ ## field ## _MASK, \
 			BRCMF_SKB_HTOD_TAG_ ## field ## _SHIFT)
 
+#define BRCMF_FWS_TXSTAT_GENERATION_MASK	0x80000000
+#define BRCMF_FWS_TXSTAT_GENERATION_SHIFT	31
+#define BRCMF_FWS_TXSTAT_FLAGS_MASK		0x78000000
+#define BRCMF_FWS_TXSTAT_FLAGS_SHIFT		27
+#define BRCMF_FWS_TXSTAT_FIFO_MASK		0x07000000
+#define BRCMF_FWS_TXSTAT_FIFO_SHIFT		24
+#define BRCMF_FWS_TXSTAT_HSLOT_MASK		0x00FFFF00
+#define BRCMF_FWS_TXSTAT_HSLOT_SHIFT		8
+#define BRCMF_FWS_TXSTAT_PKTID_MASK		0x00FFFFFF
+#define BRCMF_FWS_TXSTAT_PKTID_SHIFT		0
+
+#define brcmf_txstatus_get_field(txs, field) \
+	brcmu_maskget32(txs, BRCMF_FWS_TXSTAT_ ## field ## _MASK, \
+			BRCMF_FWS_TXSTAT_ ## field ## _SHIFT)
+
+/**
+ * enum brcmf_fws_fifo - fifo indices used by dongle firmware.
+ *
+ * @BRCMF_FWS_FIFO_AC_BK: fifo for background traffic.
+ * @BRCMF_FWS_FIFO_AC_BE: fifo for best-effort traffic.
+ * @BRCMF_FWS_FIFO_AC_VI: fifo for video traffic.
+ * @BRCMF_FWS_FIFO_AC_VO: fifo for voice traffic.
+ * @BRCMF_FWS_FIFO_BCMC: fifo for broadcast/multicast (AP only).
+ * @BRCMF_FWS_FIFO_ATIM: fifo for ATIM (AP only).
+ * @BRCMF_FWS_FIFO_COUNT: number of fifos.
+ */
+enum brcmf_fws_fifo {
+	BRCMF_FWS_FIFO_AC_BK,
+	BRCMF_FWS_FIFO_AC_BE,
+	BRCMF_FWS_FIFO_AC_VI,
+	BRCMF_FWS_FIFO_AC_VO,
+	BRCMF_FWS_FIFO_BCMC,
+	BRCMF_FWS_FIFO_ATIM,
+	BRCMF_FWS_FIFO_COUNT
+};
+
+/**
+ * enum brcmf_fws_txstatus - txstatus flag values.
+ *
+ * @BRCMF_FWS_TXSTATUS_DISCARD:
+ *	host is free to discard the packet.
+ * @BRCMF_FWS_TXSTATUS_CORE_SUPPRESS:
+ *	802.11 core suppressed the packet.
+ * @BRCMF_FWS_TXSTATUS_FW_PS_SUPPRESS:
+ *	firmware suppress the packet as device is already in PS mode.
+ * @BRCMF_FWS_TXSTATUS_FW_TOSSED:
+ *	firmware tossed the packet.
+ */
+enum brcmf_fws_txstatus {
+	BRCMF_FWS_TXSTATUS_DISCARD,
+	BRCMF_FWS_TXSTATUS_CORE_SUPPRESS,
+	BRCMF_FWS_TXSTATUS_FW_PS_SUPPRESS,
+	BRCMF_FWS_TXSTATUS_FW_TOSSED
+};
+
 enum brcmf_fws_fcmode {
 	BRCMF_FWS_FCMODE_NONE,
 	BRCMF_FWS_FCMODE_IMPLIED_CREDIT,
@@ -255,20 +320,28 @@ enum brcmf_fws_fcmode {
  * @mac_handle: handle for mac entry determined by firmware.
  * @interface_id: interface index.
  * @state: current state.
+ * @suppressed: mac entry is suppressed.
+ * @generation: generation bit.
  * @ac_bitmap: ac queue bitmap.
  * @requested_credit: credits requested by firmware.
  * @ea: ethernet address.
+ * @seq: per-node free-running sequence.
  * @psq: power-save queue.
+ * @transit_count: packet in transit to firmware.
  */
 struct brcmf_fws_mac_descriptor {
 	u8 occupied;
 	u8 mac_handle;
 	u8 interface_id;
 	u8 state;
+	bool suppressed;
+	u8 generation;
 	u8 ac_bitmap;
 	u8 requested_credit;
 	u8 ea[ETH_ALEN];
+	u8 seq[BRCMF_FWS_FIFO_COUNT];
 	struct pktq psq;
+	int transit_count;
 };
 
 #define BRCMF_FWS_HANGER_MAXITEMS	1024
@@ -276,14 +349,14 @@ struct brcmf_fws_mac_descriptor {
 /**
  * enum brcmf_fws_hanger_item_state - state of hanger item.
  *
- * @WLFC_HANGER_ITEM_STATE_FREE: item is free for use.
- * @WLFC_HANGER_ITEM_STATE_INUSE: item is in use.
- * @WLFC_HANGER_ITEM_STATE_INUSE_SUPPRESSED: item was suppressed.
+ * @BRCMF_FWS_HANGER_ITEM_STATE_FREE: item is free for use.
+ * @BRCMF_FWS_HANGER_ITEM_STATE_INUSE: item is in use.
+ * @BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED: item was suppressed.
  */
 enum brcmf_fws_hanger_item_state {
-	WLFC_HANGER_ITEM_STATE_FREE = 1,
-	WLFC_HANGER_ITEM_STATE_INUSE,
-	WLFC_HANGER_ITEM_STATE_INUSE_SUPPRESSED
+	BRCMF_FWS_HANGER_ITEM_STATE_FREE = 1,
+	BRCMF_FWS_HANGER_ITEM_STATE_INUSE,
+	BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED
 };
 
 
@@ -292,21 +365,17 @@ enum brcmf_fws_hanger_item_state {
  *
  * @state: entry is either free or occupied.
  * @gen: generation.
- * @identifier: packet identifier.
  * @pkt: packet itself.
  */
 struct brcmf_fws_hanger_item {
 	enum brcmf_fws_hanger_item_state state;
 	u8 gen;
-	u8 pad[2];
-	u32 identifier;
 	struct sk_buff *pkt;
 };
 
 /**
  * struct brcmf_fws_hanger - holds packets awaiting firmware txstatus.
  *
- * @max_items: number of packets it can hold.
  * @pushed: packets pushed to await txstatus.
  * @popped: packets popped upon handling txstatus.
  * @failed_to_push: packets that could not be pushed.
@@ -332,20 +401,39 @@ struct brcmf_fws_info {
 	struct brcmf_fws_mac_descriptor nodes[BRCMF_FWS_MAC_DESC_TABLE_SIZE];
 	struct brcmf_fws_mac_descriptor other;
 	enum brcmf_fws_fcmode fcmode;
-	int fifo_credit[NL80211_NUM_ACS+1+1];
+	int fifo_credit[BRCMF_FWS_FIFO_COUNT];
+};
+
+/*
+ * brcmf_fws_prio2fifo - mapping from 802.1d priority to firmware fifo index.
+ */
+static const int brcmf_fws_prio2fifo[] = {
+	BRCMF_FWS_FIFO_AC_BE,
+	BRCMF_FWS_FIFO_AC_BK,
+	BRCMF_FWS_FIFO_AC_BK,
+	BRCMF_FWS_FIFO_AC_BE,
+	BRCMF_FWS_FIFO_AC_VI,
+	BRCMF_FWS_FIFO_AC_VI,
+	BRCMF_FWS_FIFO_AC_VO,
+	BRCMF_FWS_FIFO_AC_VO
 };
 
 static int fcmode;
 module_param(fcmode, int, S_IRUSR);
 MODULE_PARM_DESC(fcmode, "mode of firmware signalled flow control");
 
-/**
- * brcmf_fws_get_tlv_len() - returns defined length for given tlv id.
- */
 #define BRCMF_FWS_TLV_DEF(name, id, len) \
 	case BRCMF_FWS_TYPE_ ## name: \
 		return len;
 
+/**
+ * brcmf_fws_get_tlv_len() - returns defined length for given tlv id.
+ *
+ * @fws: firmware-signalling information.
+ * @id: identifier of the TLV.
+ *
+ * Return: the specified length for the given TLV; Otherwise -EINVAL.
+ */
 static int brcmf_fws_get_tlv_len(struct brcmf_fws_info *fws,
 				 enum brcmf_fws_tlv_type id)
 {
@@ -360,6 +448,30 @@ static int brcmf_fws_get_tlv_len(struct brcmf_fws_info *fws,
 }
 #undef BRCMF_FWS_TLV_DEF
 
+static bool brcmf_fws_ifidx_match(struct sk_buff *skb, void *arg)
+{
+	u32 ifidx = brcmf_skb_if_flags_get_field(skb, INDEX);
+	return ifidx == *(int *)arg;
+}
+
+static void brcmf_fws_psq_flush(struct brcmf_fws_info *fws, struct pktq *q,
+				int ifidx)
+{
+	bool (*matchfn)(struct sk_buff *, void *) = NULL;
+	struct sk_buff *skb;
+	int prec;
+
+	if (ifidx != -1)
+		matchfn = brcmf_fws_ifidx_match;
+	for (prec = 0; prec < q->num_prec; prec++) {
+		skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
+		while (skb) {
+			brcmf_txfinalize(fws->drvr, skb, false);
+			skb = brcmu_pktq_pdeq_match(q, prec, matchfn, &ifidx);
+		}
+	}
+}
+
 static void brcmf_fws_hanger_init(struct brcmf_fws_hanger *hanger)
 {
 	int i;
@@ -367,10 +479,10 @@ static void brcmf_fws_hanger_init(struct brcmf_fws_hanger *hanger)
 	brcmf_dbg(TRACE, "enter\n");
 	memset(hanger, 0, sizeof(*hanger));
 	for (i = 0; i < ARRAY_SIZE(hanger->items); i++)
-		hanger->items[i].state = WLFC_HANGER_ITEM_STATE_FREE;
+		hanger->items[i].state = BRCMF_FWS_HANGER_ITEM_STATE_FREE;
 }
 
-static __used u32 brcmf_fws_hanger_get_free_slot(struct brcmf_fws_hanger *h)
+static u32 brcmf_fws_hanger_get_free_slot(struct brcmf_fws_hanger *h)
 {
 	u32 i;
 
@@ -378,7 +490,7 @@ static __used u32 brcmf_fws_hanger_get_free_slot(struct brcmf_fws_hanger *h)
 	i = (h->slot_pos + 1) % BRCMF_FWS_HANGER_MAXITEMS;
 
 	while (i != h->slot_pos) {
-		if (h->items[i].state == WLFC_HANGER_ITEM_STATE_FREE) {
+		if (h->items[i].state == BRCMF_FWS_HANGER_ITEM_STATE_FREE) {
 			h->slot_pos = i;
 			return i;
 		}
@@ -391,7 +503,7 @@ static __used u32 brcmf_fws_hanger_get_free_slot(struct brcmf_fws_hanger *h)
 	return BRCMF_FWS_HANGER_MAXITEMS;
 }
 
-static __used int brcmf_fws_hanger_pushpkt(struct brcmf_fws_hanger *h,
+static int brcmf_fws_hanger_pushpkt(struct brcmf_fws_hanger *h,
 					   struct sk_buff *pkt, u32 slot_id)
 {
 	brcmf_dbg(TRACE, "enter\n");
@@ -406,12 +518,11 @@ static __used int brcmf_fws_hanger_pushpkt(struct brcmf_fws_hanger *h,
 
 	h->items[slot_id].state = BRCMF_FWS_HANGER_ITEM_STATE_INUSE;
 	h->items[slot_id].pkt = pkt;
-	h->items[slot_id].identifier = slot_id;
 	h->pushed++;
 	return 0;
 }
 
-static __used int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
+static int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
 					  u32 slot_id, struct sk_buff **pktout,
 					  bool remove_item)
 {
@@ -429,7 +540,6 @@ static __used int brcmf_fws_hanger_poppkt(struct brcmf_fws_hanger *h,
 	if (remove_item) {
 		h->items[slot_id].state = BRCMF_FWS_HANGER_ITEM_STATE_FREE;
 		h->items[slot_id].pkt = NULL;
-		h->items[slot_id].identifier = 0;
 		h->items[slot_id].gen = 0xff;
 		h->popped++;
 	}
@@ -446,16 +556,16 @@ static __used int brcmf_fws_hanger_mark_suppressed(struct brcmf_fws_hanger *h,
 
 	h->items[slot_id].gen = gen;
 
-	if (h->items[slot_id].state != WLFC_HANGER_ITEM_STATE_INUSE) {
+	if (h->items[slot_id].state != BRCMF_FWS_HANGER_ITEM_STATE_INUSE) {
 		brcmf_err("entry not in use\n");
 		return -EINVAL;
 	}
 
-	h->items[slot_id].state = WLFC_HANGER_ITEM_STATE_INUSE_SUPPRESSED;
+	h->items[slot_id].state = BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED;
 	return 0;
 }
 
-static __used int brcmf_fws_hanger_get_genbit(struct brcmf_fws_hanger *hanger,
+static int brcmf_fws_hanger_get_genbit(struct brcmf_fws_hanger *hanger,
 					      struct sk_buff *pkt, u32 slot_id,
 					      int *gen)
 {
@@ -542,17 +652,50 @@ brcmf_fws_mac_descriptor_lookup(struct brcmf_fws_info *fws, u8 *ea)
 	return ERR_PTR(-ENOENT);
 }
 
-static void brcmf_fws_mac_desc_cleanup(struct brcmf_fws_mac_descriptor *entry,
-				       bool (*fn)(struct sk_buff *, void *),
+static struct brcmf_fws_mac_descriptor*
+brcmf_fws_find_mac_desc(struct brcmf_fws_info *fws, int ifidx, u8 *da)
+{
+	struct brcmf_fws_mac_descriptor *entry = &fws->other;
+	struct brcmf_if *ifp;
+	bool multicast;
+
+	brcmf_dbg(TRACE, "enter: ifidx=%d\n", ifidx);
+
+	multicast = is_multicast_ether_addr(da);
+	ifp = fws->drvr->iflist[ifidx ? ifidx + 1 : 0];
+	if (WARN_ON(!ifp))
+		goto done;
+
+	/* Multicast destination and P2P clients get the interface entry.
+	 * STA gets the interface entry if there is no exact match. For
+	 * example, TDLS destinations have their own entry.
+	 */
+	entry = NULL;
+	if ((/* ifp->iftype == 0 ||*/ multicast) && ifp->fws_desc)
+		entry = ifp->fws_desc;
+
+	if (entry != NULL && multicast)
+		goto done;
+
+	entry = brcmf_fws_mac_descriptor_lookup(fws, da);
+	if (IS_ERR(entry))
+		entry = &fws->other;
+
+done:
+	brcmf_dbg(TRACE, "exit: entry=%p\n", entry);
+	return entry;
+}
+
+static void brcmf_fws_mac_desc_cleanup(struct brcmf_fws_info *fws,
+				       struct brcmf_fws_mac_descriptor *entry,
 				       int ifidx)
 {
-	brcmf_dbg(TRACE, "enter: entry=(ea=%pM,ifid=%d), ifidx=%d\n",
+	brcmf_dbg(TRACE, "enter: entry=(ea=%pM, ifid=%d), ifidx=%d\n",
 		  entry->ea, entry->interface_id, ifidx);
-	if (entry->occupied && (fn == NULL || (ifidx == entry->interface_id))) {
-		brcmf_dbg(TRACE, "flush delayQ: ifidx=%d, qlen=%d\n",
+	if (entry->occupied && (ifidx == -1 || ifidx == entry->interface_id)) {
+		brcmf_dbg(TRACE, "flush psq: ifidx=%d, qlen=%d\n",
 			  ifidx, entry->psq.len);
-		/* release packets held in DELAYQ */
-		brcmu_pktq_flush(&entry->psq, true, fn, &ifidx);
+		brcmf_fws_psq_flush(fws, &entry->psq, ifidx);
 		entry->occupied = !!(entry->psq.len);
 	}
 }
@@ -587,12 +730,6 @@ static void brcmf_fws_bus_txq_cleanup(struct brcmf_fws_info *fws,
 	}
 }
 
-static bool brcmf_fws_ifidx_match(struct sk_buff *skb, void *arg)
-{
-	u32 ifidx = brcmf_skb_if_flags_get_field(skb, INDEX);
-	return ifidx == *(int *)arg;
-}
-
 static void brcmf_fws_cleanup(struct brcmf_fws_info *fws, int ifidx)
 {
 	int i;
@@ -609,9 +746,9 @@ static void brcmf_fws_cleanup(struct brcmf_fws_info *fws, int ifidx)
 	/* cleanup individual nodes */
 	table = &fws->nodes[0];
 	for (i = 0; i < ARRAY_SIZE(fws->nodes); i++)
-		brcmf_fws_mac_desc_cleanup(&table[i], matchfn, ifidx);
+		brcmf_fws_mac_desc_cleanup(fws, &table[i], ifidx);
 
-	brcmf_fws_mac_desc_cleanup(&fws->other, matchfn, ifidx);
+	brcmf_fws_mac_desc_cleanup(fws, &fws->other, ifidx);
 	brcmf_fws_bus_txq_cleanup(fws, matchfn, ifidx);
 	brcmf_fws_hanger_cleanup(&fws->hanger, matchfn, ifidx);
 }
@@ -637,17 +774,15 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 	entry = &fws->nodes[mac_handle & 0x1F];
 	if (type == BRCMF_FWS_TYPE_MACDESC_DEL) {
 		brcmf_dbg(TRACE, "deleting mac %pM idx %d\n", addr, ifidx);
-		if (entry->occupied) {
-			entry->occupied = 0;
-			entry->state = BRCMF_FWS_STATE_CLOSE;
-			entry->requested_credit = 0;
-		} else {
+		if (entry->occupied)
+			brcmf_fws_clear_mac_descriptor(entry);
+		else
 			fws->stats.mac_update_failed++;
-		}
 		return 0;
 	}
 
-	brcmf_dbg(TRACE, "add mac %pM idx %d\n", addr, ifidx);
+	brcmf_dbg(TRACE,
+		  "add mac %pM handle %u idx %d\n", addr, mac_handle, ifidx);
 	existing = brcmf_fws_mac_descriptor_lookup(fws, addr);
 	if (IS_ERR(existing)) {
 		if (!entry->occupied) {
@@ -674,6 +809,51 @@ int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
 	return 0;
 }
 
+static int
+brcmf_fws_txstatus_indicate(struct brcmf_fws_info *fws, u8 *data)
+{
+	u8 flags;
+	u32 status;
+	u32 hslot;
+	int ret;
+	struct sk_buff *skb;
+	struct brcmf_fws_mac_descriptor *entry = NULL;
+
+	status = le32_to_cpu(*(__le32 *)data);
+	flags = brcmf_txstatus_get_field(status, FLAGS);
+	hslot = brcmf_txstatus_get_field(status, HSLOT);
+	fws->stats.txs_indicate++;
+
+	brcmf_dbg(TRACE, "status: flags=0x%X, hslot=%d\n",
+		  flags, hslot);
+
+	if (flags == BRCMF_FWS_TXSTATUS_DISCARD)
+		fws->stats.txs_discard++;
+	else if (flags == BRCMF_FWS_TXSTATUS_FW_TOSSED)
+		fws->stats.txs_tossed++;
+	else
+		brcmf_err("unexpected txstatus\n");
+
+	ret = brcmf_fws_hanger_poppkt(&fws->hanger, hslot, &skb,
+				      true);
+	if (ret != 0) {
+		brcmf_err("no packet in hanger slot: hslot=%d\n", hslot);
+		return ret;
+	}
+
+	entry = brcmf_skbcb(skb)->mac;
+	if (WARN_ON(!entry)) {
+		ret = -EINVAL;
+		goto done;
+	}
+
+	entry->transit_count--;
+
+done:
+	brcmf_txfinalize(fws->drvr, skb, true);
+	return ret;
+}
+
 static int brcmf_fws_dbg_seqnum_check(struct brcmf_fws_info *fws, u8 *data)
 {
 	__le32 timestamp;
@@ -723,7 +903,8 @@ int brcmf_fws_init(struct brcmf_pub *drvr)
 	/* enable rssi signals */
 	if (drvr->fw_signals)
 		tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS |
-		      BRCMF_FWS_FLAGS_XONXOFF_SIGNALS;
+		      BRCMF_FWS_FLAGS_XONXOFF_SIGNALS |
+		      BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS;
 
 	spin_lock_init(&drvr->fws_spinlock);
 
@@ -839,7 +1020,6 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		case BRCMF_FWS_TYPE_MAC_OPEN:
 		case BRCMF_FWS_TYPE_MAC_CLOSE:
 		case BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT:
-		case BRCMF_FWS_TYPE_TXSTATUS:
 		case BRCMF_FWS_TYPE_PKTTAG:
 		case BRCMF_FWS_TYPE_INTERFACE_OPEN:
 		case BRCMF_FWS_TYPE_INTERFACE_CLOSE:
@@ -853,6 +1033,9 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		case BRCMF_FWS_TYPE_MACDESC_DEL:
 			brcmf_fws_macdesc_indicate(fws, type, data);
 			break;
+		case BRCMF_FWS_TYPE_TXSTATUS:
+			brcmf_fws_txstatus_indicate(fws, data);
+			break;
 		case BRCMF_FWS_TYPE_RSSI:
 			brcmf_fws_rssi_indicate(fws, *data);
 			break;
@@ -885,6 +1068,174 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	return 0;
 }
 
+static int brcmf_fws_hdrpush(struct brcmf_fws_info *fws, struct sk_buff *skb)
+{
+	struct brcmf_fws_mac_descriptor *entry = brcmf_skbcb(skb)->mac;
+	u8 *wlh;
+	u16 data_offset;
+	u8 fillers;
+	__le32 pkttag = cpu_to_le32(brcmf_skbcb(skb)->htod);
+
+	brcmf_dbg(TRACE, "enter: ea=%pM, ifidx=%u, pkttag=0x%08X\n",
+		  entry->ea, entry->interface_id, le32_to_cpu(pkttag));
+	/* +2 is for Type[1] and Len[1] in TLV, plus TIM signal */
+	data_offset = 2 + BRCMF_FWS_TYPE_PKTTAG_LEN;
+	fillers = round_up(data_offset, 4) - data_offset;
+	data_offset += fillers;
+
+	skb_push(skb, data_offset);
+	wlh = skb->data;
+
+	wlh[0] = BRCMF_FWS_TYPE_PKTTAG;
+	wlh[1] = BRCMF_FWS_TYPE_PKTTAG_LEN;
+	memcpy(&wlh[2], &pkttag, sizeof(pkttag));
+	wlh += BRCMF_FWS_TYPE_PKTTAG_LEN + 2;
+
+	if (fillers)
+		memset(wlh, BRCMF_FWS_TYPE_FILLER, fillers);
+
+	brcmf_proto_hdrpush(fws->drvr, brcmf_skb_if_flags_get_field(skb, INDEX),
+			    data_offset >> 2, skb);
+	return 0;
+}
+
+static int brcmf_fws_precommit_skb(struct brcmf_fws_info *fws, int fifo,
+				   struct sk_buff *p)
+{
+	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(p);
+	struct brcmf_fws_mac_descriptor *entry = skcb->mac;
+	int rc = 0;
+	bool header_needed;
+	int hslot = BRCMF_FWS_HANGER_MAXITEMS;
+	u8 free_ctr;
+	u8 ifidx;
+	u8 flags;
+
+	header_needed = skcb->state == BRCMF_FWS_SKBSTATE_NEW;
+
+	if (header_needed) {
+		/* obtaining free slot may fail, but that will be caught
+		 * by the hanger push. This assures the packet has a BDC
+		 * header upon return.
+		 */
+		hslot = brcmf_fws_hanger_get_free_slot(&fws->hanger);
+		free_ctr = entry->seq[fifo];
+		brcmf_skb_htod_tag_set_field(p, HSLOT, hslot);
+		brcmf_skb_htod_tag_set_field(p, FREERUN, free_ctr);
+		brcmf_skb_htod_tag_set_field(p, GENERATION, 1);
+		entry->transit_count++;
+	}
+	brcmf_skb_if_flags_set_field(p, TRANSMIT, 1);
+	brcmf_skb_htod_tag_set_field(p, FIFO, fifo);
+
+	flags = BRCMF_FWS_HTOD_FLAG_PKTFROMHOST;
+	if (!(skcb->if_flags & BRCMF_SKB_IF_FLAGS_CREDITCHECK_MASK)) {
+		/*
+		Indicate that this packet is being sent in response to an
+		explicit request from the firmware side.
+		*/
+		flags |= BRCMF_FWS_HTOD_FLAG_PKT_REQUESTED;
+	}
+	brcmf_skb_htod_tag_set_field(p, FLAGS, flags);
+	if (header_needed) {
+		brcmf_fws_hdrpush(fws, p);
+		rc = brcmf_fws_hanger_pushpkt(&fws->hanger, p, hslot);
+		if (rc)
+			brcmf_err("hanger push failed: rc=%d\n", rc);
+	} else {
+		int gen;
+
+		/* remove old header */
+		rc = brcmf_proto_hdrpull(fws->drvr, false, &ifidx, p);
+		if (rc == 0) {
+			hslot = brcmf_skb_htod_tag_get_field(p, HSLOT);
+			brcmf_fws_hanger_get_genbit(&fws->hanger, p,
+						    hslot, &gen);
+			brcmf_skb_htod_tag_set_field(p, GENERATION, gen);
+
+			/* push new header */
+			brcmf_fws_hdrpush(fws, p);
+		}
+	}
+
+	return rc;
+}
+
+static int brcmf_fws_commit_skb(struct brcmf_fws_info *fws, int fifo,
+				struct sk_buff *skb)
+{
+	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(skb);
+	struct brcmf_fws_mac_descriptor *entry;
+	struct brcmf_bus *bus = fws->drvr->bus_if;
+	int rc;
+
+	entry = skcb->mac;
+	if (IS_ERR(entry))
+		return PTR_ERR(entry);
+
+	rc = brcmf_fws_precommit_skb(fws, fifo, skb);
+	if (rc < 0) {
+		fws->stats.generic_error++;
+		goto done;
+	}
+
+	rc = brcmf_bus_txdata(bus, skb);
+	if (rc < 0)
+		goto done;
+
+	entry->seq[fifo]++;
+	fws->stats.pkt2bus++;
+	return rc;
+
+done:
+	brcmf_txfinalize(fws->drvr, skb, false);
+	return rc;
+}
+
+int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb)
+{
+	struct brcmf_pub *drvr = ifp->drvr;
+	struct brcmf_skbuff_cb *skcb = brcmf_skbcb(skb);
+	struct ethhdr *eh = (struct ethhdr *)(skb->data);
+	ulong flags;
+	u8 ifidx = ifp->ifidx;
+	int fifo = BRCMF_FWS_FIFO_BCMC;
+	bool multicast = is_multicast_ether_addr(eh->h_dest);
+
+	/* determine the priority */
+	if (!skb->priority)
+		skb->priority = cfg80211_classify8021d(skb);
+
+	drvr->tx_multicast += !!multicast;
+	if (ntohs(eh->h_proto) == ETH_P_PAE)
+		atomic_inc(&ifp->pend_8021x_cnt);
+
+	if (!brcmf_fws_fc_active(drvr->fws)) {
+		/* If the protocol uses a data header, apply it */
+		brcmf_proto_hdrpush(drvr, ifidx, 0, skb);
+
+		/* Use bus module to send data frame */
+		return brcmf_bus_txdata(drvr->bus_if, skb);
+	}
+
+	/* set control buffer information */
+	skcb->mac = brcmf_fws_find_mac_desc(drvr->fws, ifidx, eh->h_dest);
+	skcb->state = BRCMF_FWS_SKBSTATE_NEW;
+	brcmf_skb_if_flags_set_field(skb, INDEX, ifidx);
+	if (!multicast)
+		fifo = brcmf_fws_prio2fifo[skb->priority];
+	brcmf_skb_if_flags_set_field(skb, FIFO, fifo);
+	brcmf_skb_if_flags_set_field(skb, CREDITCHECK, 0);
+
+	brcmf_dbg(TRACE, "ea=%pM, multi=%d, fifo=%d\n", eh->h_dest,
+		  multicast, fifo);
+
+	brcmf_fws_lock(drvr, flags);
+	brcmf_fws_commit_skb(drvr->fws, fifo, skb);
+	brcmf_fws_unlock(drvr, flags);
+	return 0;
+}
+
 void brcmf_fws_reset_interface(struct brcmf_if *ifp)
 {
 	struct brcmf_fws_mac_descriptor *entry = ifp->fws_desc;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
index 1566f4d..7778e02 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
@@ -23,6 +23,7 @@ void brcmf_fws_deinit(struct brcmf_pub *drvr);
 bool brcmf_fws_fc_active(struct brcmf_fws_info *fws);
 int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		      struct sk_buff *skb);
+int brcmf_fws_process_skb(struct brcmf_if *ifp, struct sk_buff *skb);
 
 void brcmf_fws_reset_interface(struct brcmf_if *ifp);
 void brcmf_fws_add_interface(struct brcmf_if *ifp);
-- 
1.7.10.4


