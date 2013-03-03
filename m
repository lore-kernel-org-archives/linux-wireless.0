Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2022 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753077Ab3CCLpw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Mar 2013 06:45:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 09/13] brcmfmac: add support for TLV based firmware
 signalling
Date: Sun, 3 Mar 2013 12:45:28 +0100
Message-ID: <1362311132-29561-10-git-send-email-arend@broadcom.com> (sfid-20130303_124606_561544_B20747C0)
In-Reply-To: <1362311132-29561-1-git-send-email-arend@broadcom.com>
References: <1362311132-29561-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The firmware and host can exchange signals which are carried within
the data packets. These are TLV based signals that are inserted
before the actual data, ie. ethernet frame.

This commit adds the new source module for this feature and enables
RSSI signals from firmware.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    8 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |   41 ++
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   13 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   28 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |   14 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |  382 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h |   25 ++
 9 files changed, 501 insertions(+), 18 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 7428273..598c8e2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -26,6 +26,7 @@ brcmfmac-objs += \
 		wl_cfg80211.o \
 		fwil.o \
 		fweh.o \
+		fwsignal.o \
 		p2p.o \
 		dhd_cdc.o \
 		dhd_common.o \
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index ef6f23b..c7fa208 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -501,6 +501,7 @@ struct brcmf_dcmd {
 /* Forward decls for struct brcmf_pub (see below) */
 struct brcmf_proto;	/* device communication protocol info */
 struct brcmf_cfg80211_dev; /* cfg80211 device info */
+struct brcmf_fws_info; /* firmware signalling info */
 
 /* Common structure for module and instance linkage */
 struct brcmf_pub {
@@ -527,6 +528,10 @@ struct brcmf_pub {
 	unsigned char proto_buf[BRCMF_DCMD_MAXLEN];
 
 	struct brcmf_fweh_info fweh;
+
+	bool fw_signals;
+	struct brcmf_fws_info *fws;
+	spinlock_t fws_spinlock;
 #ifdef DEBUG
 	struct dentry *dbgfs_dir;
 #endif
@@ -582,7 +587,7 @@ extern int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 				    void *buf, uint len);
 
 /* Remove any protocol-specific data header. */
-extern int brcmf_proto_hdrpull(struct brcmf_pub *drvr, u8 *ifidx,
+extern int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 			       struct sk_buff *rxp);
 
 extern int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 81e1be7..8212d43 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -28,6 +28,7 @@
 #include "dhd.h"
 #include "dhd_proto.h"
 #include "dhd_bus.h"
+#include "fwsignal.h"
 #include "dhd_dbg.h"
 
 struct brcmf_proto_cdc_dcmd {
@@ -294,7 +295,7 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 	BDC_SET_IF_IDX(h, ifidx);
 }
 
-int brcmf_proto_hdrpull(struct brcmf_pub *drvr, u8 *ifidx,
+int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 			struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bdc_header *h;
@@ -341,7 +342,10 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, u8 *ifidx,
 	pktbuf->priority = h->priority & BDC_PRIORITY_MASK;
 
 	skb_pull(pktbuf, BDC_HEADER_LEN);
-	skb_pull(pktbuf, h->data_offset << 2);
+	if (do_fws)
+		brcmf_fws_hdrpull(drvr, *ifidx, h->data_offset << 2, pktbuf);
+	else
+		skb_pull(pktbuf, h->data_offset << 2);
 
 	if (pktbuf->len == 0)
 		return -ENODATA;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index 50f2938..ac79249 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -124,3 +124,44 @@ void brcmf_debugfs_create_sdio_count(struct brcmf_pub *drvr,
 		debugfs_create_file("counters", S_IRUGO, dentry,
 				    sdcnt, &brcmf_debugfs_sdio_counter_ops);
 }
+
+static
+ssize_t brcmf_debugfs_fws_stats_read(struct file *f, char __user *data,
+				     size_t count, loff_t *ppos)
+{
+	struct brcmf_fws_stats *fwstats = f->private_data;
+	char buf[100];
+	int res;
+
+	/* only allow read from start */
+	if (*ppos > 0)
+		return 0;
+
+	res = scnprintf(buf, sizeof(buf),
+			"header_pulls:     %u\n"
+			"header_only_pkt:  %u\n"
+			"tlv_parse_failed: %u\n"
+			"tlv_invalid_type: %u\n",
+			fwstats->header_pulls,
+			fwstats->header_only_pkt,
+			fwstats->tlv_parse_failed,
+			fwstats->tlv_invalid_type);
+
+	return simple_read_from_buffer(data, count, ppos, buf, res);
+}
+
+static const struct file_operations brcmf_debugfs_fws_stats_ops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = brcmf_debugfs_fws_stats_read
+};
+
+void brcmf_debugfs_create_fws_stats(struct brcmf_pub *drvr,
+				    struct brcmf_fws_stats *stats)
+{
+	struct dentry *dentry =  drvr->dbgfs_dir;
+
+	if (!IS_ERR_OR_NULL(dentry))
+		debugfs_create_file("fws_stats", S_IRUGO, dentry,
+				    stats, &brcmf_debugfs_fws_stats_ops);
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index 0a1806f..4bc646b 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -132,6 +132,13 @@ struct brcmf_sdio_count {
 	ulong rx_readahead_cnt;	/* packets where header read-ahead was used */
 };
 
+struct brcmf_fws_stats {
+	u32 tlv_parse_failed;
+	u32 tlv_invalid_type;
+	u32 header_only_pkt;
+	u32 header_pulls;
+};
+
 struct brcmf_pub;
 #ifdef DEBUG
 void brcmf_debugfs_init(void);
@@ -141,6 +148,8 @@ void brcmf_debugfs_detach(struct brcmf_pub *drvr);
 struct dentry *brcmf_debugfs_get_devdir(struct brcmf_pub *drvr);
 void brcmf_debugfs_create_sdio_count(struct brcmf_pub *drvr,
 				     struct brcmf_sdio_count *sdcnt);
+void brcmf_debugfs_create_fws_stats(struct brcmf_pub *drvr,
+				    struct brcmf_fws_stats *stats);
 #else
 static inline void brcmf_debugfs_init(void)
 {
@@ -155,6 +164,10 @@ static inline int brcmf_debugfs_attach(struct brcmf_pub *drvr)
 static inline void brcmf_debugfs_detach(struct brcmf_pub *drvr)
 {
 }
+static inline void brcmf_debugfs_create_fws_stats(struct brcmf_pub *drvr,
+						  struct brcmf_fws_stats *stats)
+{
+}
 #endif
 
 #endif				/* _BRCMF_DBG_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 5b92341..8e84f90 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -30,6 +30,7 @@
 #include "p2p.h"
 #include "wl_cfg80211.h"
 #include "fwil.h"
+#include "fwsignal.h"
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
@@ -283,7 +284,7 @@ void brcmf_rx_frames(struct device *dev, struct sk_buff_head *skb_list)
 		skb_unlink(skb, skb_list);
 
 		/* process and remove protocol-specific header */
-		ret = brcmf_proto_hdrpull(drvr, &ifidx, skb);
+		ret = brcmf_proto_hdrpull(drvr, drvr->fw_signals, &ifidx, skb);
 		ifp = drvr->iflist[ifidx];
 
 		if (ret || !ifp || !ifp->ndev) {
@@ -357,20 +358,23 @@ void brcmf_txcomplete(struct device *dev, struct sk_buff *txp, bool success)
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 	struct brcmf_if *ifp;
+	int res;
 
-	brcmf_proto_hdrpull(drvr, &ifidx, txp);
+	res = brcmf_proto_hdrpull(drvr, false, &ifidx, txp);
 
 	ifp = drvr->iflist[ifidx];
 	if (!ifp)
 		return;
 
-	eh = (struct ethhdr *)(txp->data);
-	type = ntohs(eh->h_proto);
+	if (res == 0) {
+		eh = (struct ethhdr *)(txp->data);
+		type = ntohs(eh->h_proto);
 
-	if (type == ETH_P_PAE) {
-		atomic_dec(&ifp->pend_8021x_cnt);
-		if (waitqueue_active(&ifp->pend_8021x_wait))
-			wake_up(&ifp->pend_8021x_wait);
+		if (type == ETH_P_PAE) {
+			atomic_dec(&ifp->pend_8021x_cnt);
+			if (waitqueue_active(&ifp->pend_8021x_wait))
+				wake_up(&ifp->pend_8021x_wait);
+		}
 	}
 	if (!success)
 		ifp->stats.tx_errors++;
@@ -871,6 +875,9 @@ int brcmf_bus_start(struct device *dev)
 	if (ret < 0)
 		goto fail;
 
+	drvr->fw_signals = true;
+	(void)brcmf_fws_init(drvr);
+
 	drvr->config = brcmf_cfg80211_attach(drvr, bus_if->dev);
 	if (drvr->config == NULL) {
 		ret = -ENOMEM;
@@ -887,6 +894,8 @@ fail:
 		brcmf_err("failed: %d\n", ret);
 		if (drvr->config)
 			brcmf_cfg80211_detach(drvr->config);
+		if (drvr->fws)
+			brcmf_fws_deinit(drvr);
 		free_netdev(ifp->ndev);
 		drvr->iflist[0] = NULL;
 		if (p2p_ifp) {
@@ -950,6 +959,9 @@ void brcmf_detach(struct device *dev)
 	if (drvr->prot)
 		brcmf_proto_detach(drvr);
 
+	if (drvr->fws)
+		brcmf_fws_deinit(drvr);
+
 	brcmf_debugfs_detach(drvr);
 	bus_if->drvr = NULL;
 	kfree(drvr);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 3581763..84a4eb3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -1547,7 +1547,7 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 	struct sk_buff_head pktlist;	/* needed for bus interface */
 	u16 pad;		/* Number of pad bytes to read */
 	uint rxleft = 0;	/* Remaining number of frames allowed */
-	int sdret;		/* Return code from calls */
+	int ret;		/* Return code from calls */
 	uint rxcount = 0;	/* Total frames read */
 	struct brcmf_sdio_read *rd = &bus->cur_read, rd_new;
 	u8 head_read = 0;
@@ -1578,15 +1578,15 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		/* read header first for unknow frame length */
 		sdio_claim_host(bus->sdiodev->func[1]);
 		if (!rd->len) {
-			sdret = brcmf_sdcard_recv_buf(bus->sdiodev,
+			ret = brcmf_sdcard_recv_buf(bus->sdiodev,
 						      bus->sdiodev->sbwad,
 						      SDIO_FUNC_2, F2SYNC,
 						      bus->rxhdr,
 						      BRCMF_FIRSTREAD);
 			bus->sdcnt.f2rxhdrs++;
-			if (sdret < 0) {
+			if (ret < 0) {
 				brcmf_err("RXHEADER FAILED: %d\n",
-					  sdret);
+					  ret);
 				bus->sdcnt.rx_hdrfail++;
 				brcmf_sdbrcm_rxfail(bus, true, true);
 				sdio_release_host(bus->sdiodev->func[1]);
@@ -1638,14 +1638,14 @@ static uint brcmf_sdio_readframes(struct brcmf_sdio *bus, uint maxframes)
 		skb_pull(pkt, head_read);
 		pkt_align(pkt, rd->len_left, BRCMF_SDALIGN);
 
-		sdret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
+		ret = brcmf_sdcard_recv_pkt(bus->sdiodev, bus->sdiodev->sbwad,
 					      SDIO_FUNC_2, F2SYNC, pkt);
 		bus->sdcnt.f2rxdata++;
 		sdio_release_host(bus->sdiodev->func[1]);
 
-		if (sdret < 0) {
+		if (ret < 0) {
 			brcmf_err("read %d bytes from channel %d failed: %d\n",
-				  rd->len, rd->channel, sdret);
+				  rd->len, rd->channel, ret);
 			brcmu_pkt_buf_free_skb(pkt);
 			sdio_claim_host(bus->sdiodev->func[1]);
 			brcmf_sdbrcm_rxfail(bus, true,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
new file mode 100644
index 0000000..071d55f
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -0,0 +1,382 @@
+/*
+ * Copyright (c) 2010 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/types.h>
+#include <linux/if_ether.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/err.h>
+#include <uapi/linux/nl80211.h>
+
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
+#include "dhd.h"
+#include "dhd_dbg.h"
+#include "fwil.h"
+#include "fweh.h"
+#include "fwsignal.h"
+
+/**
+ * DOC: Firmware Signalling
+ *
+ * Firmware can send signals to host and vice versa, which are passed in the
+ * data packets using TLV based header. This signalling layer is on top of the
+ * BDC bus protocol layer.
+ */
+
+/*
+ * single definition for firmware-driver flow control tlv's.
+ *
+ * each tlv is specified by BRCMF_FWS_TLV_DEF(name, ID, length).
+ * A length value 0 indicates variable length tlv.
+ */
+#define BRCMF_FWS_TLV_DEFLIST \
+	BRCMF_FWS_TLV_DEF(MAC_OPEN, 1, 1) \
+	BRCMF_FWS_TLV_DEF(MAC_CLOSE, 2, 1) \
+	BRCMF_FWS_TLV_DEF(MAC_REQUEST_CREDIT, 3, 2) \
+	BRCMF_FWS_TLV_DEF(TXSTATUS, 4, 4) \
+	BRCMF_FWS_TLV_DEF(PKTTAG, 5, 4) \
+	BRCMF_FWS_TLV_DEF(MACDESC_ADD,	6, 8) \
+	BRCMF_FWS_TLV_DEF(MACDESC_DEL, 7, 8) \
+	BRCMF_FWS_TLV_DEF(RSSI, 8, 1) \
+	BRCMF_FWS_TLV_DEF(INTERFACE_OPEN, 9, 1) \
+	BRCMF_FWS_TLV_DEF(INTERFACE_CLOSE, 10, 1) \
+	BRCMF_FWS_TLV_DEF(FIFO_CREDITBACK, 11, 8) \
+	BRCMF_FWS_TLV_DEF(PENDING_TRAFFIC_BMP, 12, 2) \
+	BRCMF_FWS_TLV_DEF(MAC_REQUEST_PACKET, 13, 3) \
+	BRCMF_FWS_TLV_DEF(HOST_REORDER_RXPKTS, 14, 10) \
+	BRCMF_FWS_TLV_DEF(TRANS_ID, 18, 6) \
+	BRCMF_FWS_TLV_DEF(COMP_TXSTATUS, 19, 1) \
+	BRCMF_FWS_TLV_DEF(FILLER, 255, 0)
+
+/**
+ * enum brcmf_fws_tlv_type - definition of tlv identifiers.
+ */
+#define BRCMF_FWS_TLV_DEF(name, id, len) \
+	BRCMF_FWS_TYPE_ ## name =  id,
+enum brcmf_fws_tlv_type {
+	BRCMF_FWS_TLV_DEFLIST
+	BRCMF_FWS_TYPE_INVALID
+};
+#undef BRCMF_FWS_TLV_DEF
+
+/**
+ * enum brcmf_fws_tlv_len - length values for tlvs.
+ */
+#define BRCMF_FWS_TLV_DEF(name, id, len) \
+	BRCMF_FWS_TYPE_ ## name ## _LEN = len,
+enum brcmf_fws_tlv_len {
+	BRCMF_FWS_TLV_DEFLIST
+};
+#undef BRCMF_FWS_TLV_DEF
+
+#ifdef DEBUG
+/**
+ * brcmf_fws_tlv_names - array of tlv names.
+ */
+#define BRCMF_FWS_TLV_DEF(name, id, len) \
+	{ id, #name },
+static struct {
+	enum brcmf_fws_tlv_type id;
+	const char *name;
+} brcmf_fws_tlv_names[] = {
+	BRCMF_FWS_TLV_DEFLIST
+};
+#undef BRCMF_FWS_TLV_DEF
+
+static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(brcmf_fws_tlv_names); i++)
+		if (brcmf_fws_tlv_names[i].id == id)
+			return brcmf_fws_tlv_names[i].name;
+
+	return "INVALID";
+}
+#else
+static const char *brcmf_fws_get_tlv_name(enum brcmf_fws_tlv_type id)
+{
+	return "NODEBUG";
+}
+#endif /* DEBUG */
+
+/**
+ * flags used to enable tlv signalling from firmware.
+ */
+#define BRCMF_FWS_FLAGS_RSSI_SIGNALS				0x0001
+#define BRCMF_FWS_FLAGS_XONXOFF_SIGNALS				0x0002
+#define BRCMF_FWS_FLAGS_CREDIT_STATUS_SIGNALS			0x0004
+#define BRCMF_FWS_FLAGS_HOST_PROPTXSTATUS_ACTIVE		0x0008
+#define BRCMF_FWS_FLAGS_PSQ_GENERATIONFSM_ENABLE		0x0010
+#define BRCMF_FWS_FLAGS_PSQ_ZERO_BUFFER_ENABLE			0x0020
+#define BRCMF_FWS_FLAGS_HOST_RXREORDER_ACTIVE			0x0040
+
+#define BRCMF_FWS_HANGER_MAXITEMS				1024
+#define BRCMF_FWS_HANGER_ITEM_STATE_FREE			1
+#define BRCMF_FWS_HANGER_ITEM_STATE_INUSE			2
+#define BRCMF_FWS_HANGER_ITEM_STATE_INUSE_SUPPRESSED		3
+
+#define BRCMF_FWS_STATE_OPEN					1
+#define BRCMF_FWS_STATE_CLOSE				2
+
+#define BRCMF_FWS_FCMODE_NONE				0
+#define BRCMF_FWS_FCMODE_IMPLIED_CREDIT			1
+#define BRCMF_FWS_FCMODE_EXPLICIT_CREDIT			2
+
+#define BRCMF_FWS_MAC_DESC_TABLE_SIZE			32
+#define BRCMF_FWS_MAX_IFNUM					16
+#define BRCMF_FWS_MAC_DESC_ID_INVALID			0xff
+
+#define BRCMF_FWS_HOSTIF_FLOWSTATE_OFF			0
+#define BRCMF_FWS_HOSTIF_FLOWSTATE_ON			1
+
+/**
+ * FWFC packet identifier
+ *
+ * 32-bit packet identifier used in PKTTAG tlv from host to dongle.
+ *
+ * - Generated at the host (e.g. dhd)
+ * - Seen as a generic sequence number by wlc except the flags field
+ *
+ * Generation	: b[31]	=> generation number for this packet [host->fw]
+ *			   OR, current generation number [fw->host]
+ * Flags	: b[30:27] => command, status flags
+ * FIFO-AC	: b[26:24] => AC-FIFO id
+ * h-slot	: b[23:8] => hanger-slot
+ * freerun	: b[7:0] => A free running counter
+ */
+#define BRCMF_FWS_PKTTAG_GENERATION_MASK		0x80000000
+#define BRCMF_FWS_PKTTAG_GENERATION_SHIFT		31
+#define BRCMF_FWS_PKTTAG_FLAGS_MASK			0x78000000
+#define BRCMF_FWS_PKTTAG_FLAGS_SHIFT			27
+#define BRCMF_FWS_PKTTAG_FIFO_MASK			0x07000000
+#define BRCMF_FWS_PKTTAG_FIFO_SHIFT			24
+#define BRCMF_FWS_PKTTAG_HSLOT_MASK			0x00ffff00
+#define BRCMF_FWS_PKTTAG_HSLOT_SHIFT			8
+#define BRCMF_FWS_PKTTAG_FREERUN_MASK			0x000000ff
+#define BRCMF_FWS_PKTTAG_FREERUN_SHIFT			0
+
+#define brcmf_fws_pkttag_set_field(var, field, value) \
+	brcmu_maskset32((var), BRCMF_FWS_PKTTAG_ ## field ## _MASK, \
+			     BRCMF_FWS_PKTTAG_ ## field ## _SHIFT, (value))
+#define brcmf_fws_pkttag_get_field(var, field) \
+	brcmu_maskget32((var), BRCMF_FWS_PKTTAG_ ## field ## _MASK, \
+			     BRCMF_FWS_PKTTAG_ ## field ## _SHIFT)
+
+struct brcmf_fws_info {
+	struct brcmf_pub *drvr;
+	struct brcmf_fws_stats stats;
+};
+
+static int brcmf_fws_rssi_indicate(struct brcmf_fws_info *fws, s8 rssi)
+{
+	brcmf_dbg(CTL, "rssi %d\n", rssi);
+	return 0;
+}
+
+static int brcmf_fws_dbg_seqnum_check(struct brcmf_fws_info *fws, u8 *data)
+{
+	__le32 timestamp;
+
+	memcpy(&timestamp, &data[2], sizeof(timestamp));
+	brcmf_dbg(INFO, "received: seq %d, timestamp %d\n", data[1],
+		  le32_to_cpu(timestamp));
+	return 0;
+}
+
+/* using macro so sparse checking does not complain
+ * about locking imbalance.
+ */
+#define brcmf_fws_lock(drvr, flags)				\
+do {								\
+	flags = 0;						\
+	spin_lock_irqsave(&((drvr)->fws_spinlock), (flags));	\
+} while (0)
+
+/* using macro so sparse checking does not complain
+ * about locking imbalance.
+ */
+#define brcmf_fws_unlock(drvr, flags) \
+	spin_unlock_irqrestore(&((drvr)->fws_spinlock), (flags))
+
+int brcmf_fws_init(struct brcmf_pub *drvr)
+{
+	u32 tlv;
+	int rc;
+
+	/* enable rssi signals */
+	tlv = drvr->fw_signals ? BRCMF_FWS_FLAGS_RSSI_SIGNALS : 0;
+
+	spin_lock_init(&drvr->fws_spinlock);
+
+	drvr->fws = kzalloc(sizeof(*(drvr->fws)), GFP_KERNEL);
+	if (!drvr->fws) {
+		rc = -ENOMEM;
+		goto fail;
+	}
+
+	/* enable proptxtstatus signaling by default */
+	rc = brcmf_fil_iovar_int_set(drvr->iflist[0], "tlv", tlv);
+	if (rc < 0) {
+		brcmf_err("failed to set bdcv2 tlv signaling\n");
+		goto fail;
+	}
+	/* set linkage back */
+	drvr->fws->drvr = drvr;
+
+	/* create debugfs file for statistics */
+	brcmf_debugfs_create_fws_stats(drvr, &drvr->fws->stats);
+
+	/* TODO: remove upon feature delivery */
+	brcmf_err("%s bdcv2 tlv signaling [%x]\n",
+		  drvr->fw_signals ? "enabled" : "disabled", tlv);
+	return 0;
+
+fail:
+	/* disable flow control entirely */
+	drvr->fw_signals = false;
+	brcmf_fws_deinit(drvr);
+	return rc;
+}
+
+void brcmf_fws_deinit(struct brcmf_pub *drvr)
+{
+	/* free top structure */
+	kfree(drvr->fws);
+	drvr->fws = NULL;
+}
+
+int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
+		      struct sk_buff *skb)
+{
+	struct brcmf_fws_info *fws = drvr->fws;
+	ulong flags;
+	u8 *signal_data;
+	s16 data_len;
+	u8 type;
+	u8 len;
+	u8 *data;
+
+	brcmf_dbg(TRACE, "enter: ifidx %d, skblen %u, sig %d\n",
+		  ifidx, skb->len, signal_len);
+
+	WARN_ON(signal_len > skb->len);
+
+	/* if flow control disabled, skip to packet data and leave */
+	if (!signal_len || !drvr->fw_signals) {
+		skb_pull(skb, signal_len);
+		return 0;
+	}
+
+	/* lock during tlv parsing */
+	brcmf_fws_lock(drvr, flags);
+
+	fws->stats.header_pulls++;
+	data_len = signal_len;
+	signal_data = skb->data;
+
+	while (data_len > 0) {
+		/* extract tlv info */
+		type = signal_data[0];
+
+		/* FILLER type is actually not a TLV, but
+		 * a single byte that can be skipped.
+		 */
+		if (type == BRCMF_FWS_TYPE_FILLER) {
+			signal_data += 1;
+			data_len -= 1;
+			continue;
+		}
+		len = signal_data[1];
+		data = signal_data + 2;
+
+		/* abort parsing when length invalid */
+		if (data_len < len + 2)
+			break;
+
+		brcmf_dbg(INFO, "tlv type=%d (%s), len=%d\n", type,
+			  brcmf_fws_get_tlv_name(type), len);
+		switch (type) {
+		case BRCMF_FWS_TYPE_MAC_OPEN:
+		case BRCMF_FWS_TYPE_MAC_CLOSE:
+			WARN_ON(len != BRCMF_FWS_TYPE_MAC_OPEN_LEN);
+			break;
+		case BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT:
+			WARN_ON(len != BRCMF_FWS_TYPE_MAC_REQUEST_CREDIT_LEN);
+			break;
+		case BRCMF_FWS_TYPE_TXSTATUS:
+			WARN_ON(len != BRCMF_FWS_TYPE_TXSTATUS_LEN);
+			break;
+		case BRCMF_FWS_TYPE_PKTTAG:
+			WARN_ON(len != BRCMF_FWS_TYPE_PKTTAG_LEN);
+			break;
+		case BRCMF_FWS_TYPE_MACDESC_ADD:
+		case BRCMF_FWS_TYPE_MACDESC_DEL:
+			WARN_ON(len != BRCMF_FWS_TYPE_MACDESC_ADD_LEN);
+			break;
+		case BRCMF_FWS_TYPE_RSSI:
+			WARN_ON(len != BRCMF_FWS_TYPE_RSSI_LEN);
+			brcmf_fws_rssi_indicate(fws, *(s8 *)data);
+			break;
+		case BRCMF_FWS_TYPE_INTERFACE_OPEN:
+		case BRCMF_FWS_TYPE_INTERFACE_CLOSE:
+			WARN_ON(len != BRCMF_FWS_TYPE_INTERFACE_OPEN_LEN);
+			break;
+		case BRCMF_FWS_TYPE_FIFO_CREDITBACK:
+			WARN_ON(len != BRCMF_FWS_TYPE_FIFO_CREDITBACK_LEN);
+			break;
+		case BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP:
+			WARN_ON(len != BRCMF_FWS_TYPE_PENDING_TRAFFIC_BMP_LEN);
+			break;
+		case BRCMF_FWS_TYPE_MAC_REQUEST_PACKET:
+			WARN_ON(len != BRCMF_FWS_TYPE_MAC_REQUEST_PACKET_LEN);
+			break;
+		case BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS:
+			WARN_ON(len != BRCMF_FWS_TYPE_HOST_REORDER_RXPKTS_LEN);
+			break;
+		case BRCMF_FWS_TYPE_TRANS_ID:
+			WARN_ON(len != BRCMF_FWS_TYPE_TRANS_ID_LEN);
+			brcmf_fws_dbg_seqnum_check(fws, data);
+			break;
+		case BRCMF_FWS_TYPE_COMP_TXSTATUS:
+			WARN_ON(len != BRCMF_FWS_TYPE_COMP_TXSTATUS_LEN);
+			break;
+		default:
+			fws->stats.tlv_invalid_type++;
+			break;
+		}
+
+		signal_data += len + 2;
+		data_len -= len + 2;
+	}
+
+	if (data_len != 0)
+		fws->stats.tlv_parse_failed++;
+
+	/* signalling processing result does
+	 * not affect the actual ethernet packet.
+	 */
+	skb_pull(skb, signal_len);
+
+	/* this may be a signal-only packet
+	 */
+	if (skb->len == 0)
+		fws->stats.header_only_pkt++;
+
+	brcmf_fws_unlock(drvr, flags);
+	return 0;
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
new file mode 100644
index 0000000..e728eea
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.h
@@ -0,0 +1,25 @@
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+
+#ifndef FWSIGNAL_H_
+#define FWSIGNAL_H_
+
+int brcmf_fws_init(struct brcmf_pub *drvr);
+void brcmf_fws_deinit(struct brcmf_pub *drvr);
+int brcmf_fws_hdrpull(struct brcmf_pub *drvr, int ifidx, s16 signal_len,
+		      struct sk_buff *skb);
+#endif /* FWSIGNAL_H_ */
-- 
1.7.6


