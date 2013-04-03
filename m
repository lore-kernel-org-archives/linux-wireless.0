Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4488 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760581Ab3DCKlU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Apr 2013 06:41:20 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/25] brcmfmac: handle firmware signal for updating mac
 descriptor info
Date: Wed, 3 Apr 2013 12:40:31 +0200
Message-ID: <1364985650-11719-7-git-send-email-arend@broadcom.com> (sfid-20130403_124139_120226_82C2DCD7)
In-Reply-To: <1364985650-11719-1-git-send-email-arend@broadcom.com>
References: <1364985650-11719-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Firmware can signal the driver to allocate descriptor info for a given
mac address, which will be used for flow control and host queueing.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Piotr Haber <phaber@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    6 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  120 +++++++++++++++++---
 3 files changed, 112 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index ac79249..f0949b1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -141,11 +141,13 @@ ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
 			"header_pulls:     %u\n"
 			"header_only_pkt:  %u\n"
 			"tlv_parse_failed: %u\n"
-			"tlv_invalid_type: %u\n",
+			"tlv_invalid_type: %u\n"
+			"mac_update_fails: %u\n",
 			fwstats->header_pulls,
 			fwstats->header_only_pkt,
 			fwstats->tlv_parse_failed,
-			fwstats->tlv_invalid_type);
+			fwstats->tlv_invalid_type,
+			fwstats->mac_update_failed);
 
 	return simple_read_from_buffer(data, count, ppos, buf, res);
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index 4bc646b..371ae5b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -137,6 +137,7 @@ struct brcmf_fws_stats {
 	u32 tlv_invalid_type;
 	u32 header_only_pkt;
 	u32 header_pulls;
+	u32 mac_update_failed;
 };
 
 struct brcmf_pub;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index 7ceaceb..85fd0ec 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -141,6 +141,7 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
  * struct brcmf_fws_mac_descriptor - firmware signalling data per node/interface
  *
  * @occupied: slot is in use.
+ * @mac_handle: handle for mac entry determined by firmware.
  * @interface_id: interface index.
  * @state: current state.
  * @ac_bitmap: ac queue bitmap.
@@ -150,6 +151,7 @@ static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
  */
 struct brcmf_fws_mac_descriptor {
 	u8 occupied;
+	u8 mac_handle;
 	u8 interface_id;
 	u8 state;
 	u8 ac_bitmap;
@@ -194,6 +196,7 @@ struct brcmf_fws_mac_descriptor {
 struct brcmf_fws_info {
 	struct brcmf_pub *drvr;
 	struct brcmf_fws_stats stats;
+	struct brcmf_fws_mac_descriptor nodes[BRCMF_FWS_MAC_DESC_TABLE_SIZE];
 };
 
 /**
@@ -217,12 +220,107 @@ static int brcmf_fws_get_tlv_len(struct brcmf_fws_info *fws,
 }
 #undef BRCMF_FWS_TLV_DEF
 
+static void brcmf_fws_init_mac_descriptor(struct brcmf_fws_mac_descriptor *desc,
+					  u8 *addr, u8 ifidx)
+{
+	brcmf_dbg(TRACE, "enter: ea=%pM, ifidx=%u\n", addr, ifidx);
+	desc->occupied = 1;
+	desc->state = BRCMF_FWS_STATE_OPEN;
+	desc->requested_credit = 0;
+	/* depending on use may need ifp->bssidx instead */
+	desc->interface_id = ifidx;
+	desc->ac_bitmap = 0xff; /* update this when handling APSD */
+	memcpy(&desc->ea[0], addr, ETH_ALEN);
+}
+
+static
+void brcmf_fws_clear_mac_descriptor(struct brcmf_fws_mac_descriptor *desc)
+{
+	brcmf_dbg(TRACE,
+		  "enter: ea=%pM, ifidx=%u\n", desc->ea, desc->interface_id);
+	desc->occupied = 0;
+	desc->state = BRCMF_FWS_STATE_CLOSE;
+	desc->requested_credit = 0;
+}
+
+static struct brcmf_fws_mac_descriptor *
+brcmf_fws_mac_descriptor_lookup(struct brcmf_fws_info *fws, u8 *ea)
+{
+	struct brcmf_fws_mac_descriptor *entry;
+	int i;
+
+	brcmf_dbg(TRACE, "enter: ea=%pM\n", ea);
+	if (ea == NULL)
+		return ERR_PTR(-EINVAL);
+
+	entry = &fws->nodes[0];
+	for (i = 0; i < ARRAY_SIZE(fws->nodes); i++) {
+		if (entry->occupied && !memcmp(entry->ea, ea, ETH_ALEN))
+			return entry;
+		entry++;
+	}
+
+	return ERR_PTR(-ENOENT);
+}
+
 static int brcmf_fws_rssi_indicate(struct brcmf_fws_info *fws, s8 rssi)
 {
 	brcmf_dbg(CTL, "rssi %d\n", rssi);
 	return 0;
 }
 
+static
+int brcmf_fws_macdesc_indicate(struct brcmf_fws_info *fws, u8 type, u8 *data)
+{
+	struct brcmf_fws_mac_descriptor *entry, *existing;
+	u8 mac_handle;
+	u8 ifidx;
+	u8 *addr;
+
+	mac_handle = *data++;
+	ifidx = *data++;
+	addr = data;
+
+	entry = &fws->nodes[mac_handle & 0x1F];
+	if (type == BRCMF_FWS_TYPE_MACDESC_DEL) {
+		brcmf_dbg(TRACE, "deleting mac %pM idx %d\n", addr, ifidx);
+		if (entry->occupied) {
+			entry->occupied = 0;
+			entry->state = BRCMF_FWS_STATE_CLOSE;
+			entry->requested_credit = 0;
+		} else {
+			fws->stats.mac_update_failed++;
+		}
+		return 0;
+	}
+
+	brcmf_dbg(TRACE, "add mac %pM idx %d\n", addr, ifidx);
+	existing = brcmf_fws_mac_descriptor_lookup(fws, addr);
+	if (IS_ERR(existing)) {
+		if (!entry->occupied) {
+			entry->mac_handle = mac_handle;
+			brcmf_fws_init_mac_descriptor(entry, addr, ifidx);
+			brcmu_pktq_init(&entry->psq, BRCMF_FWS_PSQ_PREC_COUNT,
+					BRCMF_FWS_PSQ_LEN);
+		} else {
+			fws->stats.mac_update_failed++;
+		}
+	} else {
+		if (entry != existing) {
+			brcmf_dbg(TRACE, "relocate mac\n");
+			memcpy(entry, existing,
+			       offsetof(struct brcmf_fws_mac_descriptor, psq));
+			entry->mac_handle = mac_handle;
+			brcmf_fws_clear_mac_descriptor(existing);
+		} else {
+			brcmf_dbg(TRACE, "use existing\n");
+			WARN_ON(entry->mac_handle != mac_handle);
+			/* TODO: what should we do here: continue, reinit, .. */
+		}
+	}
+	return 0;
+}
+
 static int brcmf_fws_dbg_seqnum_check(struct brcmf_fws_info *fws, u8 *data)
 {
 	__le32 timestamp;
@@ -250,11 +348,13 @@ do {								\
 
 int brcmf_fws_init(struct brcmf_pub *drvr)
 {
-	u32 tlv;
+	u32 tlv = 0;
 	int rc;
 
 	/* enable rssi signals */
-	tlv = drvr->fw_signals ? BRCMF_FWS_FLAGS_RSSI_SIGNALS : 0;
+	if (drvr->fw_signals)
+		tlv = BRCMF_FWS_FLAGS_RSSI_SIGNALS |
+		      BRCMF_FWS_FLAGS_XONXOFF_SIGNALS;
 
 	spin_lock_init(&drvr->fws_spinlock);
 
@@ -361,8 +461,10 @@ int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
 		case BRCMF_FWS_TYPE_MAC_REQUEST_PACKET:
 		case BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS:
 		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
+			break;
 		case BRCMF_FWS_TYPE_MACDESC_ADD:
 		case BRCMF_FWS_TYPE_MACDESC_DEL:
+			brcmf_fws_macdesc_indicate(fws, type, data);
 			break;
 		case BRCMF_FWS_TYPE_RSSI:
 			brcmf_fws_rssi_indicate(fws, *data);
@@ -404,13 +506,7 @@ void brcmf_fws_reset_interface(struct brcmf_if *ifp)
 	if (!entry)
 		return;
 
-	entry->occupied = 1;
-	entry->state = BRCMF_FWS_STATE_OPEN;
-	entry->requested_credit = 0;
-	/* depending on use may need ifp->bssidx instead */
-	entry->interface_id = ifp->ifidx;
-	entry->ac_bitmap = 0xff; /* update this when handling APSD */
-	memcpy(&entry->ea[0], ifp->mac_addr, ETH_ALEN);
+	brcmf_fws_init_mac_descriptor(entry, ifp->mac_addr, ifp->ifidx);
 }
 
 void brcmf_fws_add_interface(struct brcmf_if *ifp)
@@ -425,7 +521,7 @@ void brcmf_fws_add_interface(struct brcmf_if *ifp)
 	entry = kzalloc(sizeof(*entry), GFP_ATOMIC);
 	if (entry) {
 		ifp->fws_desc = entry;
-		brcmf_fws_reset_interface(ifp);
+		brcmf_fws_init_mac_descriptor(entry, ifp->mac_addr, ifp->ifidx);
 		brcmu_pktq_init(&entry->psq, BRCMF_FWS_PSQ_PREC_COUNT,
 				BRCMF_FWS_PSQ_LEN);
 	} else {
@@ -442,8 +538,6 @@ void brcmf_fws_del_interface(struct brcmf_if *ifp)
 		return;
 
 	ifp->fws_desc = NULL;
-	entry->occupied = 0;
-	entry->state = BRCMF_FWS_STATE_CLOSE;
-	entry->requested_credit = 0;
+	brcmf_fws_clear_mac_descriptor(entry);
 	kfree(entry);
 }
-- 
1.7.10.4


