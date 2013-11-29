Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4235 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753455Ab3K2LZp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:45 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/19] brcmfmac: Dynamically register a protocol layer.
Date: Fri, 29 Nov 2013 12:25:16 +0100
Message-ID: <1385724324-6361-12-git-send-email-arend@broadcom.com> (sfid-20131129_122557_859723_5ABB369B)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

BCDC is the default protocol layer and being called directly. This
patch installs the functions for this layer dynamically. This allows
new protocols to be added and selected dynamically depending on the
hw capabilties. As currently only BCDC is supported this is always
the installed protocol.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.c     |   93 +++++++++++---------
 drivers/net/wireless/brcm80211/brcmfmac/bcdc.h     |   24 +++++
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   24 +----
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    4 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |    7 +-
 drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/proto.c    |   62 +++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/proto.h    |   57 ++++++++++++
 9 files changed, 202 insertions(+), 71 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/bcdc.h
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/proto.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/proto.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index e15b61c..2082402 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -28,6 +28,7 @@ brcmfmac-objs += \
 		fweh.o \
 		fwsignal.o \
 		p2p.o \
+		proto.o \
 		bcdc.o \
 		dhd_common.o \
 		dhd_linux.o \
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
index 59c6c05..b5a2529 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.c
@@ -30,6 +30,8 @@
 #include "fwsignal.h"
 #include "dhd_dbg.h"
 #include "tracepoint.h"
+#include "proto.h"
+#include "bcdc.h"
 
 struct brcmf_proto_cdc_dcmd {
 	__le32 cmd;	/* dongle command value */
@@ -104,7 +106,7 @@ struct brcmf_proto_bdc_header {
 				 * Currently is SDIO
 				 */
 
-struct brcmf_proto {
+struct brcmf_bcdc {
 	u16 reqid;
 	u8 bus_header[BUS_HEADER_LEN];
 	struct brcmf_proto_cdc_dcmd msg;
@@ -113,8 +115,8 @@ struct brcmf_proto {
 
 static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
 {
-	struct brcmf_proto *prot = drvr->prot;
-	int len = le32_to_cpu(prot->msg.len) +
+	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
+	int len = le32_to_cpu(bcdc->msg.len) +
 			sizeof(struct brcmf_proto_cdc_dcmd);
 
 	brcmf_dbg(CDC, "Enter\n");
@@ -127,32 +129,32 @@ static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
 		len = CDC_MAX_MSG_SIZE;
 
 	/* Send request */
-	return brcmf_bus_txctl(drvr->bus_if, (unsigned char *)&prot->msg, len);
+	return brcmf_bus_txctl(drvr->bus_if, (unsigned char *)&bcdc->msg, len);
 }
 
 static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 {
 	int ret;
-	struct brcmf_proto *prot = drvr->prot;
+	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
 
 	brcmf_dbg(CDC, "Enter\n");
 	len += sizeof(struct brcmf_proto_cdc_dcmd);
 	do {
-		ret = brcmf_bus_rxctl(drvr->bus_if, (unsigned char *)&prot->msg,
+		ret = brcmf_bus_rxctl(drvr->bus_if, (unsigned char *)&bcdc->msg,
 				      len);
 		if (ret < 0)
 			break;
-	} while (CDC_DCMD_ID(le32_to_cpu(prot->msg.flags)) != id);
+	} while (CDC_DCMD_ID(le32_to_cpu(bcdc->msg.flags)) != id);
 
 	return ret;
 }
 
-int
-brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
-			       void *buf, uint len)
+static int
+brcmf_proto_bcdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
+			    void *buf, uint len)
 {
-	struct brcmf_proto *prot = drvr->prot;
-	struct brcmf_proto_cdc_dcmd *msg = &prot->msg;
+	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
+	struct brcmf_proto_cdc_dcmd *msg = &bcdc->msg;
 	void *info;
 	int ret = 0, retries = 0;
 	u32 id, flags;
@@ -163,13 +165,13 @@ brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
-	flags = (++prot->reqid << CDC_DCMD_ID_SHIFT);
+	flags = (++bcdc->reqid << CDC_DCMD_ID_SHIFT);
 	flags = (flags & ~CDC_DCMD_IF_MASK) |
 		(ifidx << CDC_DCMD_IF_SHIFT);
 	msg->flags = cpu_to_le32(flags);
 
 	if (buf)
-		memcpy(prot->buf, buf, len);
+		memcpy(bcdc->buf, buf, len);
 
 	ret = brcmf_proto_cdc_msg(drvr);
 	if (ret < 0) {
@@ -180,18 +182,18 @@ brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 retry:
 	/* wait for interrupt and get first fragment */
-	ret = brcmf_proto_cdc_cmplt(drvr, prot->reqid, len);
+	ret = brcmf_proto_cdc_cmplt(drvr, bcdc->reqid, len);
 	if (ret < 0)
 		goto done;
 
 	flags = le32_to_cpu(msg->flags);
 	id = (flags & CDC_DCMD_ID_MASK) >> CDC_DCMD_ID_SHIFT;
 
-	if ((id < prot->reqid) && (++retries < RETRIES))
+	if ((id < bcdc->reqid) && (++retries < RETRIES))
 		goto retry;
-	if (id != prot->reqid) {
+	if (id != bcdc->reqid) {
 		brcmf_err("%s: unexpected request id %d (expected %d)\n",
-			  brcmf_ifname(drvr, ifidx), id, prot->reqid);
+			  brcmf_ifname(drvr, ifidx), id, bcdc->reqid);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -214,11 +216,12 @@ done:
 	return ret;
 }
 
-int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
-				 void *buf, uint len)
+static int
+brcmf_proto_bcdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
+			  void *buf, uint len)
 {
-	struct brcmf_proto *prot = drvr->prot;
-	struct brcmf_proto_cdc_dcmd *msg = &prot->msg;
+	struct brcmf_bcdc *bcdc = (struct brcmf_bcdc *)drvr->proto->pd;
+	struct brcmf_proto_cdc_dcmd *msg = &bcdc->msg;
 	int ret = 0;
 	u32 flags, id;
 
@@ -228,28 +231,28 @@ int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
-	flags = (++prot->reqid << CDC_DCMD_ID_SHIFT) | CDC_DCMD_SET;
+	flags = (++bcdc->reqid << CDC_DCMD_ID_SHIFT) | CDC_DCMD_SET;
 	flags = (flags & ~CDC_DCMD_IF_MASK) |
 		(ifidx << CDC_DCMD_IF_SHIFT);
 	msg->flags = cpu_to_le32(flags);
 
 	if (buf)
-		memcpy(prot->buf, buf, len);
+		memcpy(bcdc->buf, buf, len);
 
 	ret = brcmf_proto_cdc_msg(drvr);
 	if (ret < 0)
 		goto done;
 
-	ret = brcmf_proto_cdc_cmplt(drvr, prot->reqid, len);
+	ret = brcmf_proto_cdc_cmplt(drvr, bcdc->reqid, len);
 	if (ret < 0)
 		goto done;
 
 	flags = le32_to_cpu(msg->flags);
 	id = (flags & CDC_DCMD_ID_MASK) >> CDC_DCMD_ID_SHIFT;
 
-	if (id != prot->reqid) {
+	if (id != bcdc->reqid) {
 		brcmf_err("%s: unexpected request id %d (expected %d)\n",
-			  brcmf_ifname(drvr, ifidx), id, prot->reqid);
+			  brcmf_ifname(drvr, ifidx), id, bcdc->reqid);
 		ret = -EINVAL;
 		goto done;
 	}
@@ -272,7 +275,8 @@ static void pkt_set_sum_good(struct sk_buff *skb, bool x)
 	skb->ip_summed = (x ? CHECKSUM_UNNECESSARY : CHECKSUM_NONE);
 }
 
-void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
+static void
+brcmf_proto_bcdc_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
 			 struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bdc_header *h;
@@ -295,8 +299,9 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx, u8 offset,
 	trace_brcmf_bdchdr(pktbuf->data);
 }
 
-int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
-			struct sk_buff *pktbuf)
+static int
+brcmf_proto_bcdc_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
+			 struct sk_buff *pktbuf)
 {
 	struct brcmf_proto_bdc_header *h;
 
@@ -353,34 +358,38 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
 	return 0;
 }
 
-int brcmf_proto_attach(struct brcmf_pub *drvr)
+int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr)
 {
-	struct brcmf_proto *cdc;
+	struct brcmf_bcdc *bcdc;
 
-	cdc = kzalloc(sizeof(struct brcmf_proto), GFP_ATOMIC);
-	if (!cdc)
+	bcdc = kzalloc(sizeof(*bcdc), GFP_ATOMIC);
+	if (!bcdc)
 		goto fail;
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
-	if ((unsigned long)(&cdc->msg + 1) != (unsigned long)cdc->buf) {
-		brcmf_err("struct brcmf_proto is not correctly defined\n");
+	if ((unsigned long)(&bcdc->msg + 1) != (unsigned long)bcdc->buf) {
+		brcmf_err("struct brcmf_proto_bcdc is not correctly defined\n");
 		goto fail;
 	}
 
-	drvr->prot = cdc;
+	drvr->proto->hdrpush = brcmf_proto_bcdc_hdrpush;
+	drvr->proto->hdrpull = brcmf_proto_bcdc_hdrpull;
+	drvr->proto->query_dcmd = brcmf_proto_bcdc_query_dcmd;
+	drvr->proto->set_dcmd = brcmf_proto_bcdc_set_dcmd;
+	drvr->proto->pd = bcdc;
+
 	drvr->hdrlen += BDC_HEADER_LEN + BRCMF_PROT_FW_SIGNAL_MAX_TXBYTES;
 	drvr->bus_if->maxctl = BRCMF_DCMD_MAXLEN +
 			sizeof(struct brcmf_proto_cdc_dcmd) + ROUND_UP_MARGIN;
 	return 0;
 
 fail:
-	kfree(cdc);
+	kfree(bcdc);
 	return -ENOMEM;
 }
 
-/* ~NOTE~ What if another thread is waiting on the semaphore?  Holding it? */
-void brcmf_proto_detach(struct brcmf_pub *drvr)
+void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr)
 {
-	kfree(drvr->prot);
-	drvr->prot = NULL;
+	kfree(drvr->proto->pd);
+	drvr->proto->pd = NULL;
 }
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcdc.h b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.h
new file mode 100644
index 0000000..17e8c03
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcdc.h
@@ -0,0 +1,24 @@
+/*
+ * Copyright (c) 2013 Broadcom Corporation
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
+#ifndef BRCMFMAC_BCDC_H
+#define BRCMFMAC_BCDC_H
+
+
+int brcmf_proto_bcdc_attach(struct brcmf_pub *drvr);
+void brcmf_proto_bcdc_detach(struct brcmf_pub *drvr);
+
+
+#endif /* BRCMFMAC_BCDC_H */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index dc2ebef..4ed7a97 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -535,7 +535,7 @@ struct brcmf_fws_info; /* firmware signalling info */
 struct brcmf_pub {
 	/* Linkage ponters */
 	struct brcmf_bus *bus_if;
-	struct brcmf_proto *prot;
+	struct brcmf_proto *proto;
 	struct brcmf_cfg80211_info *config;
 
 	/* Internal brcmf items */
@@ -635,28 +635,6 @@ int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 /* Return pointer to interface name */
 char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 
-/* Linkage, sets prot link and updates hdrlen in pub */
-int brcmf_proto_attach(struct brcmf_pub *drvr);
-
-/* Unlink, frees allocated protocol memory (including brcmf_proto) */
-void brcmf_proto_detach(struct brcmf_pub *drvr);
-
-/* Add any protocol-specific data header.
- * Caller must reserve prot_hdrlen prepend space.
- */
-void brcmf_proto_hdrpush(struct brcmf_pub *, int ifidx, u8 offset,
-			 struct sk_buff *txp);
-
-/* Query dongle */
-int brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
-			       void *buf, uint len);
-int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
-			     void *buf, uint len);
-
-/* Remove any protocol-specific data header. */
-int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
-			struct sk_buff *rxp);
-
 int brcmf_net_attach(struct brcmf_if *ifp, bool rtnl_locked);
 struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, s32 bssidx, s32 ifidx,
 			      char *name, u8 *mac_addr);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 9336f6d..644e62e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -30,6 +30,7 @@
 #include "wl_cfg80211.h"
 #include "fwil.h"
 #include "fwsignal.h"
+#include "proto.h"
 
 MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
@@ -1040,8 +1041,7 @@ void brcmf_detach(struct device *dev)
 
 	brcmf_bus_detach(drvr);
 
-	if (drvr->prot)
-		brcmf_proto_detach(drvr);
+	brcmf_proto_detach(drvr);
 
 	brcmf_fws_deinit(drvr);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index 04f3959..b72d339 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -27,6 +27,7 @@
 #include "dhd_dbg.h"
 #include "tracepoint.h"
 #include "fwil.h"
+#include "proto.h"
 
 
 #define MAX_HEX_DUMP_LEN	64
@@ -46,11 +47,9 @@ brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
 	if (data != NULL)
 		len = min_t(uint, len, BRCMF_DCMD_MAXLEN);
 	if (set)
-		err = brcmf_proto_cdc_set_dcmd(drvr, ifp->ifidx, cmd, data,
-					       len);
+		err = brcmf_proto_set_dcmd(drvr, ifp->ifidx, cmd, data, len);
 	else
-		err = brcmf_proto_cdc_query_dcmd(drvr, ifp->ifidx, cmd, data,
-						 len);
+		err = brcmf_proto_query_dcmd(drvr, ifp->ifidx, cmd, data, len);
 
 	if (err >= 0)
 		err = 0;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
index b96ee3a..e9bdfdb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwsignal.c
@@ -35,6 +35,7 @@
 #include "fwsignal.h"
 #include "p2p.h"
 #include "wl_cfg80211.h"
+#include "proto.h"
 
 /**
  * DOC: Firmware Signalling
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.c b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
new file mode 100644
index 0000000..87eb2bd
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.c
@@ -0,0 +1,62 @@
+/*
+ * Copyright (c) 2013 Broadcom Corporation
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
+ #include <linux/types.h>
+#include <linux/slab.h>
+#include <linux/netdevice.h>
+
+#include <brcmu_wifi.h>
+#include "dhd.h"
+#include "dhd_dbg.h"
+#include "proto.h"
+#include "bcdc.h"
+
+
+int brcmf_proto_attach(struct brcmf_pub *drvr)
+{
+	struct brcmf_proto *proto;
+
+	proto = kzalloc(sizeof(*proto), GFP_ATOMIC);
+	if (!proto)
+		goto fail;
+
+	drvr->proto = proto;
+	/* BCDC protocol is only protocol supported for the moment */
+	if (brcmf_proto_bcdc_attach(drvr))
+		goto fail;
+
+	if ((proto->hdrpush == NULL) || (proto->hdrpull == NULL) ||
+	    (proto->query_dcmd == NULL) || (proto->set_dcmd == NULL)) {
+		brcmf_err("Not all proto handlers have been installed\n");
+		goto fail;
+	}
+	return 0;
+
+fail:
+	kfree(proto);
+	drvr->proto = NULL;
+	return -ENOMEM;
+}
+
+void brcmf_proto_detach(struct brcmf_pub *drvr)
+{
+	if (drvr->proto) {
+		brcmf_proto_bcdc_detach(drvr);
+		kfree(drvr->proto);
+		drvr->proto = NULL;
+	}
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/proto.h b/drivers/net/wireless/brcm80211/brcmfmac/proto.h
new file mode 100644
index 0000000..8de1b3b
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/proto.h
@@ -0,0 +1,57 @@
+/*
+ * Copyright (c) 2013 Broadcom Corporation
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
+#ifndef BRCMFMAC_PROTO_H
+#define BRCMFMAC_PROTO_H
+
+struct brcmf_proto {
+	void (*hdrpush)(struct brcmf_pub *drvr, int ifidx, u8 offset,
+			struct sk_buff *skb);
+	int (*hdrpull)(struct brcmf_pub *drvr, bool do_fws, u8 *ifidx,
+		       struct sk_buff *skb);
+	int (*query_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd,
+			  void *buf, uint len);
+	int (*set_dcmd)(struct brcmf_pub *drvr, int ifidx, uint cmd, void *buf,
+			uint len);
+	void *pd;
+};
+
+
+int brcmf_proto_attach(struct brcmf_pub *drvr);
+void brcmf_proto_detach(struct brcmf_pub *drvr);
+
+static inline void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
+				       u8 offset, struct sk_buff *skb)
+{
+	drvr->proto->hdrpush(drvr, ifidx, offset, skb);
+}
+static inline int brcmf_proto_hdrpull(struct brcmf_pub *drvr, bool do_fws,
+				      u8 *ifidx, struct sk_buff *skb)
+{
+	return drvr->proto->hdrpull(drvr, do_fws, ifidx, skb);
+}
+static inline int brcmf_proto_query_dcmd(struct brcmf_pub *drvr, int ifidx,
+					 uint cmd, void *buf, uint len)
+{
+	return drvr->proto->query_dcmd(drvr, ifidx, cmd, buf, len);
+}
+static inline int brcmf_proto_set_dcmd(struct brcmf_pub *drvr, int ifidx,
+				       uint cmd, void *buf, uint len)
+{
+	return drvr->proto->set_dcmd(drvr, ifidx, cmd, buf, len);
+}
+
+
+#endif /* BRCMFMAC_PROTO_H */
-- 
1.7.10.4


