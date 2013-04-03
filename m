Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2979 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760280Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/25] brcmfmac: hookup firmware signalling to firmware
 interface events
Date: Wed, 3 Apr 2013 12:40:30 +0200
Message-ID: <1364985650-11719-6-git-send-email-arend@broadcom.com> (sfid-20130403_124129_390506_AC0B6B61)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware signalling needs to handle resources upon interface
events. This patch add calls in the interface event handling
routine.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    7 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   10 +-
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |   10 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  177 ++++++++++++++------
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |    5 +
 5 files changed, 148 insertions(+), 61 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index b4b9700..64006ed 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -550,8 +550,9 @@ struct brcmf_if_event {
 	u8 bssidx;
 };
 
-/* forward declaration */
+/* forward declarations */
 struct brcmf_cfg80211_vif;
+struct brcmf_fws_mac_descriptor;
 
 /**
  * struct brcmf_if - interface control information.
@@ -560,6 +561,9 @@ struct brcmf_cfg80211_vif;
  * @vif: points to cfg80211 specific interface information.
  * @ndev: associated network device.
  * @stats: interface specific network statistics.
+ * @setmacaddr_work: worker object for setting mac address.
+ * @multicast_work: worker object for multicast provisioning.
+ * @fws_desc: interface specific firmware-signalling descriptor.
  * @ifidx: interface index in device firmware.
  * @bssidx: index of bss associated with this interface.
  * @mac_addr: assigned mac address.
@@ -573,6 +577,7 @@ struct brcmf_if {
 	struct net_device_stats stats;
 	struct work_struct setmacaddr_work;
 	struct work_struct multicast_work;
+	struct brcmf_fws_mac_descriptor *fws_desc;
 	int ifidx;
 	s32 bssidx;
 	u8 mac_addr[ETH_ALEN];
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index fa5a2af..a08db02 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -755,7 +755,6 @@ struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 	ifp->ifidx = ifidx;
 	ifp->bssidx = bssidx;
 
-
 	init_waitqueue_head(&ifp->pend_8021x_wait);
 
 	if (mac_addr != NULL)
@@ -882,6 +881,7 @@ int brcmf_bus_start(struct device *dev)
 
 	drvr->fw_signals = true;
 	(void)brcmf_fws_init(drvr);
+	brcmf_fws_add_interface(ifp);
 
 	drvr->config = brcmf_cfg80211_attach(drvr, bus_if->dev);
 	if (drvr->config == NULL) {
@@ -899,8 +899,10 @@ fail:
 		brcmf_err("failed: %d\n", ret);
 		if (drvr->config)
 			brcmf_cfg80211_detach(drvr->config);
-		if (drvr->fws)
+		if (drvr->fws) {
+			brcmf_fws_del_interface(ifp);
 			brcmf_fws_deinit(drvr);
+		}
 		free_netdev(ifp->ndev);
 		drvr->iflist[0] = NULL;
 		if (p2p_ifp) {
@@ -956,8 +958,10 @@ void brcmf_detach(struct device *dev)
 
 	/* make sure primary interface removed last */
 	for (i = BRCMF_MAX_IFS-1; i > -1; i--)
-		if (drvr->iflist[i])
+		if (drvr->iflist[i]) {
+			brcmf_fws_del_interface(drvr->iflist[i]);
 			brcmf_del_if(drvr, i);
+		}
 
 	brcmf_bus_detach(drvr);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index e9d6f91..dad9414 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -20,6 +20,7 @@
 
 #include "dhd.h"
 #include "dhd_dbg.h"
+#include "fwsignal.h"
 #include "fweh.h"
 #include "fwil.h"
 
@@ -198,15 +199,20 @@ static void brcmf_fweh_handle_if_event(struct brcmf_pub *drvr,
 				   emsg->ifname, emsg->addr);
 		if (IS_ERR(ifp))
 			return;
-
+		brcmf_fws_add_interface(ifp);
 		if (!drvr->fweh.evt_handler[BRCMF_E_IF])
 			err = brcmf_net_attach(ifp, false);
 	}
 
+	if (ifevent->action == BRCMF_E_IF_CHANGE)
+		brcmf_fws_reset_interface(ifp);
+
 	err = brcmf_fweh_call_event_handler(ifp, emsg->event_code, emsg, data);
 
-	if (ifevent->action == BRCMF_E_IF_DEL)
+	if (ifevent->action == BRCMF_E_IF_DEL) {
+		brcmf_fws_del_interface(ifp);
 		brcmf_del_if(drvr, ifevent->bssidx);
+	}
 }
 
 /**
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 071d55f..7ceaceb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -73,16 +73,6 @@ enum brcmf_fws_tlv_type {
 };
 #undef BRCMF_FWS_TLV_DEF
 
-/**
- * enum brcmf_fws_tlv_len - length values for tlvs.
- */
-#define BRCMF_FWS_TLV_DEF(name, id, len) \
-	BRCMF_FWS_TYPE_ ## name ## _LEN = len,
-enum brcmf_fws_tlv_len {
-	BRCMF_FWS_TLV_DEFLIST
-};
-#undef BRCMF_FWS_TLV_DEF
-
 #ifdef DEBUG
 /**
  * brcmf_fws_tlv_names - array of tlv names.
@@ -117,33 +107,57 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
 /**
  * flags used to enable tlv signalling from firmware.
  */
-#define BRCMF_FWS_FLAGS_RSSI_SIGNALS				0x0001
-#define BRCMF_FWS_FLAGS_XONXOFF_SIGNALS				0x0002
-#define BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS			0x0004
-#define BRCMF_FWS_FLAGS_HOST_PROPTXSTATUS_ACTIVE		0x0008
-#define BRCMF_FWS_FLAGS_PSQ_GENERATIONFSM_ENABLE		0x0010
-#define BRCMF_FWS_FLAGS_PSQ_ZERO_BUFFER_ENABLE			0x0020
-#define BRCMF_FWS_FLAGS_HOST_RXREORDER_ACTIVE			0x0040
-
-#define BRCMF_FWS_HANGER_MAXITEMS				1024
-#define BRCMF_FWS_HANGER_ITEM_STATE_FREE			1
-#define BRCMF_FWS_HANGER_ITEM_STATE_INUSE			2
-#define BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED		3
-
-#define BRCMF_FWS_STATE_OPEN					1
+#define BRCMF_FWS_FLAGS_RSSI_SIGNALS			0x0001
+#define BRCMF_FWS_FLAGS_XONXOFF_SIGNALS			0x0002
+#define BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS		0x0004
+#define BRCMF_FWS_FLAGS_HOST_PROPTXSTATUS_ACTIVE	0x0008
+#define BRCMF_FWS_FLAGS_PSQ_GENERATIONFSM_ENABLE	0x0010
+#define BRCMF_FWS_FLAGS_PSQ_ZERO_BUFFER_ENABLE		0x0020
+#define BRCMF_FWS_FLAGS_HOST_RXREORDER_ACTIVE		0x0040
+
+#define BRCMF_FWS_HANGER_MAXITEMS			1024
+#define BRCMF_FWS_HANGER_ITEM_STATE_FREE		1
+#define BRCMF_FWS_HANGER_ITEM_STATE_INUSE		2
+#define BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED	3
+
+#define BRCMF_FWS_STATE_OPEN				1
 #define BRCMF_FWS_STATE_CLOSE				2
 
 #define BRCMF_FWS_FCMODE_NONE				0
 #define BRCMF_FWS_FCMODE_IMPLIED_CREDIT			1
-#define BRCMF_FWS_FCMODE_EXPLICIT_CREDIT			2
+#define BRCMF_FWS_FCMODE_EXPLICIT_CREDIT		2
 
 #define BRCMF_FWS_MAC_DESC_TABLE_SIZE			32
-#define BRCMF_FWS_MAX_IFNUM					16
+#define BRCMF_FWS_MAX_IFNUM				16
 #define BRCMF_FWS_MAC_DESC_ID_INVALID			0xff
 
 #define BRCMF_FWS_HOSTIF_FLOWSTATE_OFF			0
 #define BRCMF_FWS_HOSTIF_FLOWSTATE_ON			1
 
+#define BRCMF_FWS_PSQ_PREC_COUNT		((NL80211_NUM_ACS + 1) * 2)
+#define BRCMF_FWS_PSQ_LEN				256
+
+/**
+ * struct brcmf_fws_mac_descriptor - firmware signalling data per node/interface
+ *
+ * @occupied: slot is in use.
+ * @interface_id: interface index.
+ * @state: current state.
+ * @ac_bitmap: ac queue bitmap.
+ * @requested_credit: credits requested by firmware.
+ * @ea: ethernet address.
+ * @psq: power-save queue.
+ */
+struct brcmf_fws_mac_descriptor {
+	u8 occupied;
+	u8 interface_id;
+	u8 state;
+	u8 ac_bitmap;
+	u8 requested_credit;
+	u8 ea[ETH_ALEN];
+	struct pktq psq;
+};
+
 /**
  * FWFC packet identifier
  *
@@ -182,6 +196,27 @@ struct brcmf_fws_info {
 	struct brcmf_fws_stats stats;
 };
 
+/**
+ * brcmf_fws_get_tlv_len() - returns defined length for given tlv id.
+ */
+#define BRCMF_FWS_TLV_DEF(name, id, len) \
+	case BRCMF_FWS_TYPE_ ## name: \
+		return len;
+
+static int brcmf_fws_get_tlv_len(struct brcmf_fws_info *fws,
+				 enum brcmf_fws_tlv_type id)
+{
+	switch (id) {
+	BRCMF_FWS_TLV_DEFLIST
+	default:
+		brcmf_err("invalid tlv id: %d\n", id);
+		fws->stats.tlv_invalid_type++;
+		break;
+	}
+	return -EINVAL;
+}
+#undef BRCMF_FWS_TLV_DEF
+
 static int brcmf_fws_rssi_indicate(struct brcmf_fws_info *fws, s8 rssi)
 {
 	brcmf_dbg(CTL, "rssi %d\n", rssi);
@@ -308,53 +343,33 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		if (data_len < len + 2)
 			break;
 
+		if (len != brcmf_fws_get_tlv_len(fws, type))
+			break;
+
 		brcmf_dbg(INFO, "tlv type=%d (%s), len=%d\n", type,
 			  brcmf_fws_get_tlv_name(type), len);
 		switch (type) {
 		case BRCMF_FWS_TYPE_MAC_OPEN:
 		case BRCMF_FWS_TYPE_MAC_CLOSE:
-			WARN_ON(len != BRCMF_FWS_TYPE_MAC_OPEN_LEN);
-			break;
 		case BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT:
-			WARN_ON(len != BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT_LEN);
-			break;
 		case BRCMF_FWS_TYPE_TXSTATUS:
-			WARN_ON(len != BRCMF_FWS_TYPE_TXSTATUS_LEN);
-			break;
 		case BRCMF_FWS_TYPE_PKTTAG:
-			WARN_ON(len != BRCMF_FWS_TYPE_PKTTAG_LEN);
-			break;
-		case BRCMF_FWS_TYPE_MACDESC_ADD:
-		case BRCMF_FWS_TYPE_MACDESC_DEL:
-			WARN_ON(len != BRCMF_FWS_TYPE_MACDESC_ADD_LEN);
-			break;
-		case BRCMF_FWS_TYPE_RSSI:
-			WARN_ON(len != BRCMF_FWS_TYPE_RSSI_LEN);
-			brcmf_fws_rssi_indicate(fws, *(s8 *)data);
-			break;
 		case BRCMF_FWS_TYPE_INTERFACE_OPEN:
 		case BRCMF_FWS_TYPE_INTERFACE_CLOSE:
-			WARN_ON(len != BRCMF_FWS_TYPE_INTERFACE_OPEN_LEN);
-			break;
 		case BRCMF_FWS_TYPE_FIFO_CREDITBACK:
-			WARN_ON(len != BRCMF_FWS_TYPE_FIFO_CREDITBACK_LEN);
-			break;
 		case BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP:
-			WARN_ON(len != BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN);
-			break;
 		case BRCMF_FWS_TYPE_MAC_REQUEST_PACKET:
-			WARN_ON(len != BRCMF_FWS_TYPE_MAC_REQUEST_PACKET_LEN);
-			break;
 		case BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS:
-			WARN_ON(len != BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS_LEN);
+		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
+		case BRCMF_FWS_TYPE_MACDESC_ADD:
+		case BRCMF_FWS_TYPE_MACDESC_DEL:
+			break;
+		case BRCMF_FWS_TYPE_RSSI:
+			brcmf_fws_rssi_indicate(fws, *data);
 			break;
 		case BRCMF_FWS_TYPE_TRANS_ID:
-			WARN_ON(len != BRCMF_FWS_TYPE_TRANS_ID_LEN);
 			brcmf_fws_dbg_seqnum_check(fws, data);
 			break;
-		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
-			WARN_ON(len != BRCMF_FWS_TYPE_COMP_TXSTATUS_LEN);
-			break;
 		default:
 			fws->stats.tlv_invalid_type++;
 			break;
@@ -380,3 +395,55 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 	brcmf_fws_unlock(drvr, flags);
 	return 0;
 }
+
+void brcmf_fws_reset_interface(struct brcmf_if *ifp)
+{
+	struct brcmf_fws_mac_descriptor *entry = ifp->fws_desc;
+
+	brcmf_dbg(TRACE, "enter: idx=%d\n", ifp->bssidx);
+	if (!entry)
+		return;
+
+	entry->occupied = 1;
+	entry->state = BRCMF_FWS_STATE_OPEN;
+	entry->requested_credit = 0;
+	/* depending on use may need ifp->bssidx instead */
+	entry->interface_id = ifp->ifidx;
+	entry->ac_bitmap = 0xff; /* update this when handling APSD */
+	memcpy(&entry->ea[0], ifp->mac_addr, ETH_ALEN);
+}
+
+void brcmf_fws_add_interface(struct brcmf_if *ifp)
+{
+	struct brcmf_fws_mac_descriptor *entry;
+
+	brcmf_dbg(TRACE, "enter: idx=%d, mac=%pM\n",
+		  ifp->bssidx, ifp->mac_addr);
+	if (!ifp->drvr->fw_signals)
+		return;
+
+	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
+	if (entry) {
+		ifp->fws_desc = entry;
+		brcmf_fws_reset_interface(ifp);
+		brcmu_pktq_init(&entry->psq, BRCMF_FWS_PSQ_PREC_COUNT,
+				BRCMF_FWS_PSQ_LEN);
+	} else {
+		brcmf_err("no firmware signalling\n");
+	}
+}
+
+void brcmf_fws_del_interface(struct brcmf_if *ifp)
+{
+	struct brcmf_fws_mac_descriptor *entry = ifp->fws_desc;
+
+	brcmf_dbg(TRACE, "enter: idx=%d\n", ifp->bssidx);
+	if (!entry)
+		return;
+
+	ifp->fws_desc = NULL;
+	entry->occupied = 0;
+	entry->state = BRCMF_FWS_STATE_CLOSE;
+	entry->requested_credit = 0;
+	kfree(entry);
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
index e728eea..38a75e4 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
@@ -22,4 +22,9 @@ int brcmf_fws_init(struct brcmf_pub *drvr);
 void brcmf_fws_deinit(struct brcmf_pub *drvr);
 int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		      struct sk_buff *skb);
+
+void brcmf_fws_reset_interface(struct brcmf_if *ifp);
+void brcmf_fws_add_interface(struct brcmf_if *ifp);
+void brcmf_fws_del_interface(struct brcmf_if *ifp);
+
 #endif /* FWSIGNAL_H_ */
-- 
1.7.10.4


