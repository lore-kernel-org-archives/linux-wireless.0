Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2092 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757986Ab1F2Xss (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:48 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 061/119] staging: brcm80211: further renaming in fullmac
 sources
Date: Wed, 29 Jun 2011 16:47:25 -0700
Message-ID: <1309391303-22741-62-git-send-email-frankyl@broadcom.com> (sfid-20110630_015042_607210_3117B2B2)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

couple of items needed renaming to more consistent naming convention.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile      |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    8 +-
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h     |    8 ++
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c     |   10 +--
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |   20 +---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   10 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |  110 ++++++++++------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    9 +-
 8 files changed, 80 insertions(+), 99 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 9fa689b..07b9340 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -21,9 +21,9 @@ ccflags-y :=			\
 	-DBCMPLATFORM_BUS	\
 	-DBCMSDIO		\
 	-DBRCM_FULLMAC		\
-	-DDHD_FIRSTREAD=64	\
+	-DBRCMF_FIRSTREAD=64	\
 	-DDHD_SCHED		\
-	-DDHD_SDALIGN=64	\
+	-DBRCMF_SDALIGN=64	\
 	-DEMBEDDED_PLATFORM	\
 	-DMAX_HDR_READ=64	\
 	-DMMC_SDIO_ABORT	\
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index c990a2c..fb88c05 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -725,20 +725,20 @@ typedef struct {
 } bcmevent_name_t;
 
 #if defined(CONFIG_PM_SLEEP)
-extern atomic_t dhd_mmc_suspend;
+extern atomic_t brcmf_mmc_suspend;
 #define DHD_PM_RESUME_WAIT_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
 #define _DHD_PM_RESUME_WAIT(a, b) do { \
 		int retry = 0; \
-		while (atomic_read(&dhd_mmc_suspend) && retry++ != b) { \
+		while (atomic_read(&brcmf_mmc_suspend) && retry++ != b) { \
 			wait_event_timeout(a, false, HZ/100); \
 		} \
 	}	while (0)
 #define DHD_PM_RESUME_WAIT(a)	_DHD_PM_RESUME_WAIT(a, 30)
 #define DHD_PM_RESUME_WAIT_FOREVER(a)	_DHD_PM_RESUME_WAIT(a, ~0)
 #define DHD_PM_RESUME_RETURN_ERROR(a)	\
-	do { if (atomic_read(&dhd_mmc_suspend)) return a; } while (0)
+	do { if (atomic_read(&brcmf_mmc_suspend)) return a; } while (0)
 #define DHD_PM_RESUME_RETURN	do { \
-	if (atomic_read(&dhd_mmc_suspend)) \
+	if (atomic_read(&brcmf_mmc_suspend)) \
 		return; \
 	} while (0)
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 128a00d..73b72ff 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -17,6 +17,14 @@
 #ifndef _dhd_bus_h_
 #define _dhd_bus_h_
 
+/* Packet alignment for most efficient SDIO (can change based on platform) */
+#ifndef BRCMF_SDALIGN
+#define BRCMF_SDALIGN	32
+#endif
+#if !ISPOWEROF2(BRCMF_SDALIGN)
+#error BRCMF_SDALIGN is not a power of 2!
+#endif
+
 /*
  * Exported from dhd bus module (dhd_usb, dhd_sdio)
  */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index c544cbf..594c217 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -84,16 +84,8 @@ struct brcmf_proto_bdc_header {
 int wifi_get_mac_addr(unsigned char *buf);
 #endif
 
-/* Packet alignment for most efficient SDIO (can change based on platform) */
-#ifndef DHD_SDALIGN
-#define DHD_SDALIGN	32
-#endif
-#if !ISPOWEROF2(DHD_SDALIGN)
-#error DHD_SDALIGN is not a power of 2!
-#endif
-
 #define RETRIES 2	/* # of retries to retrieve matching ioctl response */
-#define BUS_HEADER_LEN	(16+DHD_SDALIGN) /* Must be atleast SDPCM_RESERVE
+#define BUS_HEADER_LEN	(16+BRCMF_SDALIGN) /* Must be atleast SDPCM_RESERVE
 					 * defined in dhd_sdio.c
 					 * (amount of header tha might be added)
 					 * plus any space that might be needed
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index a255d3d..deb8566 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -27,22 +27,15 @@
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
 
-#define BRCM_OUI		"\x00\x10\x18"
+#define BRCM_OUI			"\x00\x10\x18"
 #define DOT11_OUI_LEN			3
-#define BCMILCP_BCM_SUBTYPE_EVENT		1
+#define BCMILCP_BCM_SUBTYPE_EVENT	1
+#define PKTFILTER_BUF_SIZE		2048
 
 int brcmf_msg_level;
 char brcmf_fw_path[MOD_PARAM_PATHLEN];
 char brcmf_nv_path[MOD_PARAM_PATHLEN];
 
-/* Packet alignment for most efficient SDIO (can change based on platform) */
-#ifndef DHD_SDALIGN
-#define DHD_SDALIGN	32
-#endif
-#if !ISPOWEROF2(DHD_SDALIGN)
-#error DHD_SDALIGN is not a power of 2!
-#endif
-
 #define EPI_VERSION_STR         "4.218.248.5"
 #define MSGTRACE_VERSION	1
 
@@ -1028,7 +1021,6 @@ void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	char *argv[8], *buf = 0;
 	int i = 0;
 	char *arg_save = 0, *arg_org = 0;
-#define BUF_SIZE		2048
 
 	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
 	if (!arg_save) {
@@ -1038,7 +1030,7 @@ void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 
 	arg_org = arg_save;
 
-	buf = kmalloc(BUF_SIZE, GFP_ATOMIC);
+	buf = kmalloc(PKTFILTER_BUF_SIZE, GFP_ATOMIC);
 	if (!buf) {
 		DHD_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
@@ -1046,7 +1038,7 @@ void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 
 	memcpy(arg_save, arg, strlen(arg) + 1);
 
-	if (strlen(arg) > BUF_SIZE) {
+	if (strlen(arg) > PKTFILTER_BUF_SIZE) {
 		DHD_ERROR(("Not enough buffer %d < %d\n", (int)strlen(arg),
 			   (int)sizeof(buf)));
 		goto fail;
@@ -1193,7 +1185,7 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	uint up = 0;
 	char buf[128], *ptr;
 	uint power_mode = PM_FAST;
-	u32 dongle_align = DHD_SDALIGN;
+	u32 dongle_align = BRCMF_SDALIGN;
 	u32 glom = 0;
 	uint bcn_timeout = 3;
 	int scan_assoc_time = 40;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 5aa4492..9ee4866 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -173,7 +173,7 @@ void wifi_del_dev(void)
 
 #if defined(CONFIG_PM_SLEEP)
 #include <linux/suspend.h>
-atomic_t dhd_mmc_suspend;
+atomic_t brcmf_mmc_suspend;
 DECLARE_WAIT_QUEUE_HEAD(dhd_dpc_wait);
 #endif	/*  defined(CONFIG_PM_SLEEP) */
 
@@ -1910,7 +1910,7 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	g_bus = bus;
 #endif
 #if defined(CONFIG_PM_SLEEP)
-	atomic_set(&dhd_mmc_suspend, false);
+	atomic_set(&brcmf_mmc_suspend, false);
 #endif	/* defined(CONFIG_PM_SLEEP) */
 	/* && defined(DHD_GPL) */
 	/* Init lock suspend to prevent kernel going to suspend */
@@ -2055,7 +2055,7 @@ int brcmf_iovar(dhd_pub_t *pub, int ifidx, char *name, char *cmd_buf,
 	return ret;
 }
 
-static struct net_device_ops dhd_ops_pri = {
+static struct net_device_ops brcmf_netdev_ops_pri = {
 	.ndo_open = brcmf_netdev_open,
 	.ndo_stop = brcmf_netdev_stop,
 	.ndo_get_stats = brcmf_netdev_get_stats,
@@ -2080,7 +2080,7 @@ int brcmf_net_attach(dhd_pub_t *dhdp, int ifidx)
 	ASSERT(net);
 
 	ASSERT(!net->netdev_ops);
-	net->netdev_ops = &dhd_ops_pri;
+	net->netdev_ops = &brcmf_netdev_ops_pri;
 
 	/*
 	 * We have to use the primary MAC for virtual interfaces
@@ -2168,7 +2168,7 @@ void brcmf_detach(dhd_pub_t *dhdp)
 
 			ifp = dhd->iflist[0];
 			ASSERT(ifp);
-			if (ifp->net->netdev_ops == &dhd_ops_pri) {
+			if (ifp->net->netdev_ops == &brcmf_netdev_ops_pri) {
 				brcmf_netdev_stop(ifp->net);
 				unregister_netdev(ifp->net);
 			}
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index e8cc8d5..2b1762e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -202,27 +202,19 @@ struct rte_console {
 #define MAX_DATA_BUF	(32 * 1024)	/* Must be large enough to hold
 				 biggest possible glom */
 
-/* Packet alignment for most efficient SDIO (can change based on platform) */
-#ifndef DHD_SDALIGN
-#define DHD_SDALIGN	32
+#ifndef BRCMF_FIRSTREAD
+#define BRCMF_FIRSTREAD	32
 #endif
-#if !ISPOWEROF2(DHD_SDALIGN)
-#error DHD_SDALIGN is not a power of 2!
-#endif
-
-#ifndef DHD_FIRSTREAD
-#define DHD_FIRSTREAD	32
-#endif
-#if !ISPOWEROF2(DHD_FIRSTREAD)
-#error DHD_FIRSTREAD is not a power of 2!
+#if !ISPOWEROF2(BRCMF_FIRSTREAD)
+#error BRCMF_FIRSTREAD is not a power of 2!
 #endif
 
 /* Total length of frame header for dongle protocol */
 #define SDPCM_HDRLEN	(SDPCM_FRAMETAG_LEN + SDPCM_SWHEADER_LEN)
 #ifdef SDTEST
-#define SDPCM_RESERVE	(SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + DHD_SDALIGN)
+#define SDPCM_RESERVE	(SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + BRCMF_SDALIGN)
 #else
-#define SDPCM_RESERVE	(SDPCM_HDRLEN + DHD_SDALIGN)
+#define SDPCM_RESERVE	(SDPCM_HDRLEN + BRCMF_SDALIGN)
 #endif
 
 /*
@@ -492,7 +484,7 @@ typedef struct dhd_bus {
 	u8 tx_seq;		/* Transmit sequence number (next) */
 	u8 tx_max;		/* Maximum transmit sequence allowed */
 
-	u8 hdrbuf[MAX_HDR_READ + DHD_SDALIGN];
+	u8 hdrbuf[MAX_HDR_READ + BRCMF_SDALIGN];
 	u8 *rxhdr;		/* Header of current rx frame (in hdrbuf) */
 	u16 nextlen;		/* Next Read Len from last header */
 	u8 rx_seq;		/* Receive sequence number (expected) */
@@ -669,7 +661,7 @@ static bool retrydata;
 #define RETRYCHAN(chan) (((chan) == SDPCM_EVENT_CHANNEL) || retrydata)
 
 static const uint watermark = 8;
-static const uint firstread = DHD_FIRSTREAD;
+static const uint firstread = BRCMF_FIRSTREAD;
 
 #define HDATLEN (firstread - (SDPCM_HDRLEN))
 
@@ -1193,22 +1185,22 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	frame = (u8 *) (pkt->data);
 
 	/* Add alignment padding, allocate new packet if needed */
-	pad = ((unsigned long)frame % DHD_SDALIGN);
+	pad = ((unsigned long)frame % BRCMF_SDALIGN);
 	if (pad) {
 		if (skb_headroom(pkt) < pad) {
 			DHD_INFO(("%s: insufficient headroom %d for %d pad\n",
 				  __func__, skb_headroom(pkt), pad));
 			bus->dhd->tx_realloc++;
-			new = brcmu_pkt_buf_get_skb(pkt->len + DHD_SDALIGN);
+			new = brcmu_pkt_buf_get_skb(pkt->len + BRCMF_SDALIGN);
 			if (!new) {
 				DHD_ERROR(("%s: couldn't allocate new %d-byte "
 					"packet\n",
-					__func__, pkt->len + DHD_SDALIGN));
+					__func__, pkt->len + BRCMF_SDALIGN));
 				ret = -ENOMEM;
 				goto done;
 			}
 
-			PKTALIGN(new, pkt->len, DHD_SDALIGN);
+			PKTALIGN(new, pkt->len, BRCMF_SDALIGN);
 			memcpy(new->data, pkt->data, pkt->len);
 			if (free_pkt)
 				brcmu_pkt_buf_free_skb(pkt);
@@ -1216,7 +1208,7 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 			free_pkt = true;
 			pkt = new;
 			frame = (u8 *) (pkt->data);
-			ASSERT(((unsigned long)frame % DHD_SDALIGN) == 0);
+			ASSERT(((unsigned long)frame % BRCMF_SDALIGN) == 0);
 			pad = 0;
 		} else {
 			skb_push(pkt, pad);
@@ -1226,7 +1218,7 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 			memset(frame, 0, pad + SDPCM_HDRLEN);
 		}
 	}
-	ASSERT(pad < DHD_SDALIGN);
+	ASSERT(pad < BRCMF_SDALIGN);
 
 	/* Hardware tag: 2 byte len followed by 2 byte ~len check (all LE) */
 	len = (u16) (pkt->len);
@@ -1264,8 +1256,8 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 			if (pad <= skb_tailroom(pkt))
 #endif				/* NOTUSED */
 				len += pad;
-	} else if (len % DHD_SDALIGN) {
-		len += DHD_SDALIGN - (len % DHD_SDALIGN);
+	} else if (len % BRCMF_SDALIGN) {
+		len += BRCMF_SDALIGN - (len % BRCMF_SDALIGN);
 	}
 
 	/* Some controllers have trouble with odd bytes -- round to even */
@@ -1512,14 +1504,14 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 
 	/* Add alignment padding (optional for ctl frames) */
 	if (dhd_alignctl) {
-		doff = ((unsigned long)frame % DHD_SDALIGN);
+		doff = ((unsigned long)frame % BRCMF_SDALIGN);
 		if (doff) {
 			frame -= doff;
 			len += doff;
 			msglen += doff;
 			memset(frame, 0, doff + SDPCM_HDRLEN);
 		}
-		ASSERT(doff < DHD_SDALIGN);
+		ASSERT(doff < BRCMF_SDALIGN);
 	}
 	doff += SDPCM_HDRLEN;
 
@@ -1528,8 +1520,8 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		u16 pad = bus->blocksize - (len % bus->blocksize);
 		if ((pad <= bus->roundup) && (pad < bus->blocksize))
 			len += pad;
-	} else if (len % DHD_SDALIGN) {
-		len += DHD_SDALIGN - (len % DHD_SDALIGN);
+	} else if (len % BRCMF_SDALIGN) {
+		len += BRCMF_SDALIGN - (len % BRCMF_SDALIGN);
 	}
 
 	/* Satisfy length-alignment requirements */
@@ -2592,7 +2584,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		break;
 
 	case IOV_GVAL(IOV_SDALIGN):
-		int_val = DHD_SDALIGN;
+		int_val = BRCMF_SDALIGN;
 		memcpy(arg, &int_val, val_size);
 		break;
 
@@ -3279,9 +3271,9 @@ brcmf_sdbrcm_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 	bus->rxctl = bus->rxbuf;
 	if (dhd_alignctl) {
 		bus->rxctl += firstread;
-		pad = ((unsigned long)bus->rxctl % DHD_SDALIGN);
+		pad = ((unsigned long)bus->rxctl % BRCMF_SDALIGN);
 		if (pad)
-			bus->rxctl += (DHD_SDALIGN - pad);
+			bus->rxctl += (BRCMF_SDALIGN - pad);
 		bus->rxctl -= firstread;
 	}
 	ASSERT(bus->rxctl >= bus->rxbuf);
@@ -3304,8 +3296,8 @@ brcmf_sdbrcm_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 		if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
 		    ((len + pad) < bus->dhd->maxctl))
 			rdlen += pad;
-	} else if (rdlen % DHD_SDALIGN) {
-		rdlen += DHD_SDALIGN - (rdlen % DHD_SDALIGN);
+	} else if (rdlen % BRCMF_SDALIGN) {
+		rdlen += BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
 	}
 
 	/* Satisfy length-alignment requirements */
@@ -3410,9 +3402,9 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 				pnext = NULL;
 				break;
 			}
-			if (sublen % DHD_SDALIGN) {
+			if (sublen % BRCMF_SDALIGN) {
 				DHD_ERROR(("%s: sublen %d not multiple of %d\n",
-				__func__, sublen, DHD_SDALIGN));
+				__func__, sublen, BRCMF_SDALIGN));
 				usechain = false;
 			}
 			totlen += sublen;
@@ -3426,7 +3418,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 			}
 
 			/* Allocate/chain packet for next subframe */
-			pnext = brcmu_pkt_buf_get_skb(sublen + DHD_SDALIGN);
+			pnext = brcmu_pkt_buf_get_skb(sublen + BRCMF_SDALIGN);
 			if (pnext == NULL) {
 				DHD_ERROR(("%s: bcm_pkt_buf_get_skb failed, "
 					"num %d len %d\n", __func__,
@@ -3444,7 +3436,7 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 			}
 
 			/* Adhere to start alignment requirements */
-			PKTALIGN(pnext, sublen, DHD_SDALIGN);
+			PKTALIGN(pnext, sublen, BRCMF_SDALIGN);
 		}
 
 		/* If all allocations succeeded, save packet chain
@@ -3846,9 +3838,9 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					    && ((rdlen + pad + firstread) <
 						MAX_RX_DATASZ))
 						rdlen += pad;
-				} else if (rdlen % DHD_SDALIGN) {
+				} else if (rdlen % BRCMF_SDALIGN) {
 					rdlen +=
-					    DHD_SDALIGN - (rdlen % DHD_SDALIGN);
+					    BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
 				}
 			}
 
@@ -3863,7 +3855,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			 * or non-data frame.
 			 */
 			/* Allocate a packet buffer */
-			pkt = brcmu_pkt_buf_get_skb(rdlen + DHD_SDALIGN);
+			pkt = brcmu_pkt_buf_get_skb(rdlen + BRCMF_SDALIGN);
 			if (!pkt) {
 				if (bus->bus == SPI_BUS) {
 					bus->usebufpool = false;
@@ -3871,10 +3863,10 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					if (dhd_alignctl) {
 						bus->rxctl += firstread;
 						pad = ((unsigned long)bus->rxctl %
-						      DHD_SDALIGN);
+						      BRCMF_SDALIGN);
 						if (pad)
 							bus->rxctl +=
-							    (DHD_SDALIGN - pad);
+							    (BRCMF_SDALIGN - pad);
 						bus->rxctl -= firstread;
 					}
 					ASSERT(bus->rxctl >= bus->rxbuf);
@@ -3918,7 +3910,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					bus->usebufpool = true;
 
 				ASSERT(!(pkt->prev));
-				PKTALIGN(pkt, rdlen, DHD_SDALIGN);
+				PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
 				rxbuf = (u8 *) (pkt->data);
 				/* Read the entire frame */
 				sdret = brcmf_sdcard_recv_buf(sdh,
@@ -4225,8 +4217,8 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			if ((pad <= bus->roundup) && (pad < bus->blocksize) &&
 			    ((rdlen + pad + firstread) < MAX_RX_DATASZ))
 				rdlen += pad;
-		} else if (rdlen % DHD_SDALIGN) {
-			rdlen += DHD_SDALIGN - (rdlen % DHD_SDALIGN);
+		} else if (rdlen % BRCMF_SDALIGN) {
+			rdlen += BRCMF_SDALIGN - (rdlen % BRCMF_SDALIGN);
 		}
 
 		/* Satisfy length-alignment requirements */
@@ -4243,7 +4235,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			continue;
 		}
 
-		pkt = brcmu_pkt_buf_get_skb(rdlen + firstread + DHD_SDALIGN);
+		pkt = brcmu_pkt_buf_get_skb(rdlen + firstread + BRCMF_SDALIGN);
 		if (!pkt) {
 			/* Give up on data, request rtx of events */
 			DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed: rdlen %d"
@@ -4258,7 +4250,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 		/* Leave room for what we already read, and align remainder */
 		ASSERT(firstread < pkt->len);
 		skb_pull(pkt, firstread);
-		PKTALIGN(pkt, rdlen, DHD_SDALIGN);
+		PKTALIGN(pkt, rdlen, BRCMF_SDALIGN);
 
 		/* Read the remaining frame data */
 		sdret = brcmf_sdcard_recv_buf(sdh, brcmf_sdcard_cur_sbwad(sdh),
@@ -4809,7 +4801,7 @@ static void brcmf_sdbrcm_pktgen(dhd_bus_t *bus)
 		/* Allocate an appropriate-sized packet */
 		len = bus->pktgen_len;
 		pkt = brcmu_pkt_buf_get_skb(
-			(len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + DHD_SDALIGN),
+			(len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN + BRCMF_SDALIGN),
 			true);
 		if (!pkt) {
 			DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed!\n",
@@ -4817,7 +4809,7 @@ static void brcmf_sdbrcm_pktgen(dhd_bus_t *bus)
 			break;
 		}
 		PKTALIGN(pkt, (len + SDPCM_HDRLEN + SDPCM_TEST_HDRLEN),
-			 DHD_SDALIGN);
+			 BRCMF_SDALIGN);
 		data = (u8 *) (pkt->data) + SDPCM_HDRLEN;
 
 		/* Write test header cmd and extra based on mode */
@@ -4890,12 +4882,12 @@ static void brcmf_sdbrcm_sdtest_set(dhd_bus_t *bus, bool start)
 
 	/* Allocate the packet */
 	pkt = brcmu_pkt_buf_get_skb(SDPCM_HDRLEN + SDPCM_TEST_HDRLEN +
-		DHD_SDALIGN, true);
+		BRCMF_SDALIGN, true);
 	if (!pkt) {
 		DHD_ERROR(("%s: brcmu_pkt_buf_get_skb failed!\n", __func__));
 		return;
 	}
-	PKTALIGN(pkt, (SDPCM_HDRLEN + SDPCM_TEST_HDRLEN), DHD_SDALIGN);
+	PKTALIGN(pkt, (SDPCM_HDRLEN + SDPCM_TEST_HDRLEN), BRCMF_SDALIGN);
 	data = (u8 *) (pkt->data) + SDPCM_HDRLEN;
 
 	/* Fill in the test header */
@@ -5417,7 +5409,7 @@ brcmf_sdbrcm_probe_attach(struct dhd_bus *bus, void *sdh, void *regsva,
 	brcmu_pktq_init(&bus->txq, (PRIOMASK + 1), TXQLEN);
 
 	/* Locate an appropriately-aligned portion of hdrbuf */
-	bus->rxhdr = (u8 *) roundup((unsigned long)&bus->hdrbuf[0], DHD_SDALIGN);
+	bus->rxhdr = (u8 *) roundup((unsigned long)&bus->hdrbuf[0], BRCMF_SDALIGN);
 
 	/* Set the poll and/or interrupt flags */
 	bus->intr = (bool) brcmf_intr;
@@ -5438,7 +5430,7 @@ static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *sdh)
 	if (bus->dhd->maxctl) {
 		bus->rxblen =
 		    roundup((bus->dhd->maxctl + SDPCM_HDRLEN),
-			    ALIGNMENT) + DHD_SDALIGN;
+			    ALIGNMENT) + BRCMF_SDALIGN;
 		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
 		if (!(bus->rxbuf)) {
 			DHD_ERROR(("%s: kmalloc of %d-byte rxbuf failed\n",
@@ -5459,10 +5451,10 @@ static bool brcmf_sdbrcm_probe_malloc(dhd_bus_t *bus, void *sdh)
 	}
 
 	/* Align the buffer */
-	if ((unsigned long)bus->databuf % DHD_SDALIGN)
+	if ((unsigned long)bus->databuf % BRCMF_SDALIGN)
 		bus->dataptr =
-		    bus->databuf + (DHD_SDALIGN -
-				    ((unsigned long)bus->databuf % DHD_SDALIGN));
+		    bus->databuf + (BRCMF_SDALIGN -
+				    ((unsigned long)bus->databuf % BRCMF_SDALIGN));
 	else
 		bus->dataptr = bus->databuf;
 
@@ -5665,15 +5657,15 @@ static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus, char *fw_path)
 	if (image == NULL)
 		goto err;
 
-	memptr = memblock = kmalloc(MEMBLOCK + DHD_SDALIGN, GFP_ATOMIC);
+	memptr = memblock = kmalloc(MEMBLOCK + BRCMF_SDALIGN, GFP_ATOMIC);
 	if (memblock == NULL) {
 		DHD_ERROR(("%s: Failed to allocate memory %d bytes\n",
 			   __func__, MEMBLOCK));
 		goto err;
 	}
-	if ((u32)(unsigned long)memblock % DHD_SDALIGN)
+	if ((u32)(unsigned long)memblock % BRCMF_SDALIGN)
 		memptr +=
-		    (DHD_SDALIGN - ((u32)(unsigned long)memblock % DHD_SDALIGN));
+		    (BRCMF_SDALIGN - ((u32)(unsigned long)memblock % BRCMF_SDALIGN));
 
 	/* Download image */
 	while ((len =
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index ca45829..086a93b 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2095,7 +2095,7 @@ static s32 wl_cfg80211_resume(struct wiphy *wiphy)
 	WL_TRACE("Enter\n");
 
 #if defined(CONFIG_PM_SLEEP)
-	atomic_set(&dhd_mmc_suspend, false);
+	atomic_set(&brcmf_mmc_suspend, false);
 #endif	/*  defined(CONFIG_PM_SLEEP) */
 
 	if (test_bit(WL_STATUS_READY, &wl->status)) {
@@ -2166,7 +2166,7 @@ static s32 wl_cfg80211_suspend(struct wiphy *wiphy, struct cfg80211_wowlan *wow)
 	}
 
 #if defined(CONFIG_PM_SLEEP)
-	atomic_set(&dhd_mmc_suspend, true);
+	atomic_set(&brcmf_mmc_suspend, true);
 #endif	/*  defined(CONFIG_PM_SLEEP) */
 
 	WL_TRACE("Exit\n");
@@ -4014,9 +4014,6 @@ dongle_scantime_out:
 
 s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
 {
-#ifndef DHD_SDALIGN
-#define DHD_SDALIGN	32
-#endif
 	struct net_device *ndev;
 	struct wireless_dev *wdev;
 	s32 err = 0;
@@ -4039,7 +4036,7 @@ s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
 	err = wl_dongle_power(ndev, PM_FAST);
 	if (unlikely(err))
 		goto default_conf_out;
-	err = wl_dongle_glom(ndev, 0, DHD_SDALIGN);
+	err = wl_dongle_glom(ndev, 0, BRCMF_SDALIGN);
 	if (unlikely(err))
 		goto default_conf_out;
 
-- 
1.7.1


