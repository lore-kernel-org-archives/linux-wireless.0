Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2351 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760953Ab1LQChb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 21:37:31 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 23/30] brcm80211: fmac: move common layer bus interface
 context to dhd_bus.h
Date: Fri, 16 Dec 2011 18:37:13 -0800
Message-ID: <1324089440-8957-24-git-send-email-frankyl@broadcom.com> (sfid-20111217_033751_759828_DE9A83E8)
In-Reply-To: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
References: <1324089440-8957-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dhd_bus.h is the header file for bus interface. Move functions
declarations and brcmf_bus structure to there. This is part of
the fullmac bus interface refactoring.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   71 ------------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |   77 ++++++++++++++++++++
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    4 -
 4 files changed, 78 insertions(+), 75 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 0b0eb4f..f17c818 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -34,6 +34,7 @@
 #include "dhd.h"
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
+#include "dhd_bus.h"
 
 #define SDIO_VENDOR_ID_BROADCOM		0x02d0
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index d3407f7..45b076e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -156,18 +156,6 @@ struct brcmf_event {
 	struct brcmf_event_msg msg;
 } __packed;
 
-struct dngl_stats {
-	unsigned long rx_packets;	/* total packets received */
-	unsigned long tx_packets;	/* total packets transmitted */
-	unsigned long rx_bytes;	/* total bytes received */
-	unsigned long tx_bytes;	/* total bytes transmitted */
-	unsigned long rx_errors;	/* bad packets received */
-	unsigned long tx_errors;	/* packet transmit problems */
-	unsigned long rx_dropped;	/* packets dropped by dongle */
-	unsigned long tx_dropped;	/* packets dropped by dongle */
-	unsigned long multicast;	/* multicast packets received */
-};
-
 /* event codes sent by the dongle to this driver */
 #define BRCMF_E_SET_SSID			0
 #define BRCMF_E_JOIN				1
@@ -317,13 +305,6 @@ struct dngl_stats {
 #define BRCMF_E_LINK_ASSOC_REC			3
 #define BRCMF_E_LINK_BSSCFG_DIS			4
 
-/* The level of bus communication with the dongle */
-enum brcmf_bus_state {
-	BRCMF_BUS_DOWN,		/* Not ready for frame transfers */
-	BRCMF_BUS_LOAD,		/* Download access only (CPU reset) */
-	BRCMF_BUS_DATA		/* Ready for frame transfers */
-};
-
 /* Pattern matching filter. Specifies an offset within received packets to
  * start matching, the pattern to match, the size of the pattern, and a bitmask
  * that indicates which bits within the pattern should be matched.
@@ -571,22 +552,6 @@ struct brcmf_dcmd {
 	uint needed;		/* bytes needed (optional) */
 };
 
-struct brcmf_bus {
-	u8 type;		/* bus type */
-	void *bus_priv;		/* pointer to bus private structure */
-	void *drvr;		/* pointer to driver pub structure brcmf_pub */
-	enum brcmf_bus_state state;
-	uint maxctl;		/* Max size rxctl request from proto to bus */
-	bool drvr_up;		/* Status flag of driver up/down */
-	unsigned long tx_realloc;	/* Tx packets realloced for headroom */
-	struct dngl_stats dstats;	/* Stats for dongle-based data */
-	u8 align;		/* bus alignment requirement */
-
-	/* interface functions pointers */
-	/* Stop bus module: clear pending frames, disable data flow */
-	void (*brcmf_bus_stop)(struct device *);
-};
-
 /* Forward decls for struct brcmf_pub (see below) */
 struct brcmf_proto;	/* device communication protocol info */
 struct brcmf_cfg80211_dev; /* cfg80211 device info */
@@ -667,46 +632,14 @@ extern const struct bcmevent_name bcmevent_names[];
 extern uint brcmf_c_mkiovar(char *name, char *data, uint datalen,
 			  char *buf, uint len);
 
-/* Indication from bus module regarding presence/insertion of dongle.
- * Return struct brcmf_pub pointer, used as handle to OS module in later calls.
- * Returned structure should have bus and prot pointers filled in.
- * bus_hdrlen specifies required headroom for bus module header.
- */
-extern int brcmf_attach(uint bus_hdrlen, struct device *dev);
 extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
 extern s32 brcmf_exec_dcmd(struct net_device *dev, u32 cmd, void *arg, u32 len);
 
-/* Indication from bus module regarding removal/absence of dongle */
-extern void brcmf_detach(struct device *dev);
-
-/* Indication from bus module to change flow-control state */
-extern void brcmf_txflowcontrol(struct device *dev, int ifidx, bool on);
-
-extern bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
-			 struct sk_buff *pkt, int prec);
-
-/* Receive frame for delivery to OS.  Callee disposes of rxp. */
-extern void brcmf_rx_frame(struct device *dev, int ifidx,
-			   struct sk_buff_head *rxlist);
-static inline void brcmf_rx_packet(struct device *dev, int ifidx,
-				   struct sk_buff *pkt)
-{
-	struct sk_buff_head q;
-
-	skb_queue_head_init(&q);
-	skb_queue_tail(&q, pkt);
-	brcmf_rx_frame(dev, ifidx, &q);
-}
-
 /* Return pointer to interface name */
 extern char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 
-/* Notify tx completion */
-extern void brcmf_txcomplete(struct device *dev, struct sk_buff *txp,
-			     bool success);
-
 /* Query dongle */
 extern int brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 				       uint cmd, void *buf, uint len);
@@ -720,16 +653,12 @@ extern int brcmf_c_host_event(struct brcmf_pub *drvr, int *idx,
 			      void *pktdata, struct brcmf_event_msg *,
 			      void **data_ptr);
 
-extern int brcmf_add_if(struct device *dev, int ifidx,
-			char *name, u8 *mac_addr);
 extern void brcmf_del_if(struct brcmf_pub *drvr, int ifidx);
 
 /* Send packet to dongle via data channel */
 extern int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx,\
 			 struct sk_buff *pkt);
 
-extern int brcmf_bus_start(struct device *dev);
-
 extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
 extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 					     int enable, int master_mode);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 25c1bc3..dc022e3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -17,6 +17,83 @@
 #ifndef _BRCMF_BUS_H_
 #define _BRCMF_BUS_H_
 
+/* The level of bus communication with the dongle */
+enum brcmf_bus_state {
+	BRCMF_BUS_DOWN,		/* Not ready for frame transfers */
+	BRCMF_BUS_LOAD,		/* Download access only (CPU reset) */
+	BRCMF_BUS_DATA		/* Ready for frame transfers */
+};
+
+struct dngl_stats {
+	unsigned long rx_packets;	/* total packets received */
+	unsigned long tx_packets;	/* total packets transmitted */
+	unsigned long rx_bytes;	/* total bytes received */
+	unsigned long tx_bytes;	/* total bytes transmitted */
+	unsigned long rx_errors;	/* bad packets received */
+	unsigned long tx_errors;	/* packet transmit problems */
+	unsigned long rx_dropped;	/* packets dropped by dongle */
+	unsigned long tx_dropped;	/* packets dropped by dongle */
+	unsigned long multicast;	/* multicast packets received */
+};
+
+/* interface structure between common and bus layer */
+struct brcmf_bus {
+	u8 type;		/* bus type */
+	void *bus_priv;		/* pointer to bus private structure */
+	void *drvr;		/* pointer to driver pub structure brcmf_pub */
+	enum brcmf_bus_state state;
+	uint maxctl;		/* Max size rxctl request from proto to bus */
+	bool drvr_up;		/* Status flag of driver up/down */
+	unsigned long tx_realloc;	/* Tx packets realloced for headroom */
+	struct dngl_stats dstats;	/* Stats for dongle-based data */
+	u8 align;		/* bus alignment requirement */
+
+	/* interface functions pointers */
+	/* Stop bus module: clear pending frames, disable data flow */
+	void (*brcmf_bus_stop)(struct device *);
+};
+
+/*
+ * interface functions from common layer
+ */
+
+/* Remove any protocol-specific data header. */
+extern int brcmf_proto_hdrpull(struct device *dev, int *ifidx,
+			       struct sk_buff *rxp);
+
+extern bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
+			 struct sk_buff *pkt, int prec);
+
+/* Receive frame for delivery to OS.  Callee disposes of rxp. */
+extern void brcmf_rx_frame(struct device *dev, int ifidx,
+			   struct sk_buff_head *rxlist);
+static inline void brcmf_rx_packet(struct device *dev, int ifidx,
+				   struct sk_buff *pkt)
+{
+	struct sk_buff_head q;
+
+	skb_queue_head_init(&q);
+	skb_queue_tail(&q, pkt);
+	brcmf_rx_frame(dev, ifidx, &q);
+}
+
+/* Indication from bus module regarding presence/insertion of dongle. */
+extern int brcmf_attach(uint bus_hdrlen, struct device *dev);
+/* Indication from bus module regarding removal/absence of dongle */
+extern void brcmf_detach(struct device *dev);
+
+/* Indication from bus module to change flow-control state */
+extern void brcmf_txflowcontrol(struct device *dev, int ifidx, bool on);
+
+/* Notify tx completion */
+extern void brcmf_txcomplete(struct device *dev, struct sk_buff *txp,
+			     bool success);
+
+extern int brcmf_bus_start(struct device *dev);
+
+extern int brcmf_add_if(struct device *dev, int ifidx,
+			char *name, u8 *mac_addr);
+
 /*
  * Exported from brcmf bus module (brcmf_usb, brcmf_sdio)
  */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
index 7005ff17..6bc4425 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
@@ -41,10 +41,6 @@ extern void brcmf_proto_stop(struct brcmf_pub *drvr);
 extern void brcmf_proto_hdrpush(struct brcmf_pub *, int ifidx,
 				struct sk_buff *txp);
 
-/* Remove any protocol-specific data header. */
-extern int brcmf_proto_hdrpull(struct device *dev, int *ifidx,
-			       struct sk_buff *rxp);
-
 /* Use protocol to issue command to dongle */
 extern int brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx,
 				struct brcmf_dcmd *dcmd, int len);
-- 
1.7.5.4


