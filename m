Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2967 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755722Ab2JVRgh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:37 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 01/14] brcmfmac: refactor firmware interface layer.
Date: Mon, 22 Oct 2012 10:36:14 -0700
Message-ID: <1350927387-25608-2-git-send-email-frankyl@broadcom.com> (sfid-20121022_193705_648781_D236CA15)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Refactor the functions that are related to getting and setting
data to and and from the firmware.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   29 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |    3 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   10 -
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |  346 ++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/fwil.h     |   43 ++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  549 ++++++--------------
 8 files changed, 578 insertions(+), 404 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwil.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/fwil.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 9d5170b..fe80b63 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -24,6 +24,7 @@ ccflags-y += -D__CHECK_ENDIAN__
 obj-$(CONFIG_BRCMFMAC) += brcmfmac.o
 brcmfmac-objs += \
 		wl_cfg80211.o \
+		fwil.o \
 		dhd_cdc.o \
 		dhd_common.o \
 		dhd_linux.o
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 0510960..a73da9d 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -318,6 +318,12 @@ struct brcmf_event {
 #define BRCMF_E_LINK_ASSOC_REC			3
 #define BRCMF_E_LINK_BSSCFG_DIS			4
 
+/* Small, medium and maximum buffer size for dcmd
+ */
+#define BRCMF_DCMD_SMLEN	256
+#define BRCMF_DCMD_MEDLEN	1536
+#define BRCMF_DCMD_MAXLEN	8192
+
 /* Pattern matching filter. Specifies an offset within received packets to
  * start matching, the pattern to match, the size of the pattern, and a bitmask
  * that indicates which bits within the pattern should be matched.
@@ -661,6 +667,7 @@ struct brcmf_pub {
 	struct brcmf_if *iflist[BRCMF_MAX_IFS];
 
 	struct mutex proto_block;
+	unsigned char proto_buf[BRCMF_DCMD_MAXLEN];
 
 	struct work_struct setmacaddr_work;
 	struct work_struct multicast_work;
@@ -671,6 +678,22 @@ struct brcmf_pub {
 #endif
 };
 
+/* struct brcmf_if - Interface control information
+ *
+ * @drvr: back pointer to brcmf_pub
+ * @ndev: interface net device pointer
+ * @stats: net device statistics
+ * @idx: iface idx in dongle
+ * @mac_addr: assigned MAC address
+ */
+struct brcmf_if {
+	struct brcmf_pub *drvr;
+	struct net_device *ndev;
+	struct net_device_stats stats;
+	int idx;
+	u8 mac_addr[ETH_ALEN];
+};
+
 struct brcmf_if_event {
 	u8 ifidx;
 	u8 action;
@@ -701,6 +724,8 @@ extern char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 /* Query dongle */
 extern int brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 				       uint cmd, void *buf, uint len);
+extern int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
+				    void *buf, uint len);
 
 extern int brcmf_ifname2idx(struct brcmf_pub *drvr, char *name);
 extern int brcmf_c_host_event(struct brcmf_pub *drvr, int *idx,
@@ -713,8 +738,4 @@ extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
 extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 					     int enable, int master_mode);
 
-#define	BRCMF_DCMD_SMLEN	256	/* "small" cmd buffer required */
-#define BRCMF_DCMD_MEDLEN	1536	/* "med" cmd buffer required */
-#define	BRCMF_DCMD_MAXLEN	8192	/* max length cmd buffer required */
-
 #endif				/* _BRCMF_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index 7f89540..fa08058 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -18,6 +18,7 @@
 #include <linux/if.h>
 #include <linux/ieee80211.h>
 #include <linux/module.h>
+#include <linux/netdevice.h>
 
 #include <defs.h>
 #include <brcmu_wifi.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index fb508c2..eefa6c2 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -31,6 +31,7 @@
 #define BRCMF_EVENT_VAL	0x0800
 #define BRCMF_BTA_VAL	0x1000
 #define BRCMF_ISCAN_VAL 0x2000
+#define BRCMF_FIL_VAL	0x4000
 
 #if defined(DEBUG)
 
@@ -56,6 +57,7 @@ do {									\
 #define BRCMF_BYTES_ON()	(brcmf_msg_level & BRCMF_BYTES_VAL)
 #define BRCMF_GLOM_ON()		(brcmf_msg_level & BRCMF_GLOM_VAL)
 #define BRCMF_EVENT_ON()	(brcmf_msg_level & BRCMF_EVENT_VAL)
+#define BRCMF_FIL_ON()		(brcmf_msg_level & BRCMF_FIL_VAL)
 
 #else	/* (defined DEBUG) || (defined DEBUG) */
 
@@ -67,6 +69,7 @@ do {									\
 #define BRCMF_BYTES_ON()	0
 #define BRCMF_GLOM_ON()		0
 #define BRCMF_EVENT_ON()	0
+#define BRCMF_FIL_ON()		0
 
 #endif				/* defined(DEBUG) */
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index c462263..189c5be 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -52,16 +52,6 @@ MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN fullmac cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
 
-/* Interface control information */
-struct brcmf_if {
-	struct brcmf_pub *drvr;	/* back pointer to brcmf_pub */
-	/* OS/stack specifics */
-	struct net_device *ndev;
-	struct net_device_stats stats;
-	int idx;		/* iface idx in dongle */
-	u8 mac_addr[ETH_ALEN];	/* assigned MAC address */
-};
-
 /* Error bits */
 int brcmf_msg_level = BRCMF_ERROR_VAL;
 module_param(brcmf_msg_level, int, 0);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
new file mode 100644
index 0000000..196797e
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -0,0 +1,346 @@
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
+/* FWIL is the Firmware Interface Layer. In this module the support functions
+ * are located to set and get variables to and from the firmware.
+ */
+
+#include <linux/kernel.h>
+#include <linux/netdevice.h>
+#include <defs.h>
+#include <brcmu_utils.h>
+#include <brcmu_wifi.h>
+#include "dhd.h"
+#include "dhd_bus.h"
+#include "dhd_dbg.h"
+
+
+static s32
+brcmf_fil_cmd_data(struct brcmf_if *ifp, u32 cmd, void *data, u32 len, bool set)
+{
+	struct brcmf_pub *drvr = ifp->drvr;
+	s32 err;
+
+	if (drvr->bus_if->state == BRCMF_BUS_DOWN) {
+		brcmf_dbg(ERROR, "bus is down. we have nothing to do.\n");
+		return -EIO;
+	}
+
+	if (data != NULL)
+		len = min_t(uint, len, BRCMF_DCMD_MAXLEN);
+	if (set)
+		err = brcmf_proto_cdc_set_dcmd(drvr, ifp->idx, cmd, data, len);
+	else
+		err = brcmf_proto_cdc_query_dcmd(drvr, ifp->idx, cmd, data,
+						 len);
+
+	if (err >= 0)
+		err = 0;
+	else
+		brcmf_dbg(ERROR, "Failed err=%d\n", err);
+
+	return err;
+}
+
+s32
+brcmf_fil_cmd_data_set(struct net_device *ndev, u32 cmd, void *data, u32 len)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	s32 err;
+
+	mutex_lock(&ifp->drvr->proto_block);
+
+	brcmf_dbg(FIL, "cmd=%d, len=%d\n", cmd, len);
+	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data, len, "data");
+
+	err = brcmf_fil_cmd_data(ifp, cmd, data, len, true);
+	mutex_unlock(&ifp->drvr->proto_block);
+
+	return err;
+}
+
+s32
+brcmf_fil_cmd_data_get(struct net_device *ndev, u32 cmd, void *data, u32 len)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	s32 err;
+
+	mutex_lock(&ifp->drvr->proto_block);
+	err = brcmf_fil_cmd_data(ifp, cmd, data, len, false);
+
+	brcmf_dbg(FIL, "cmd=%d, len=%d\n", cmd, len);
+	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data, len, "data");
+
+	mutex_unlock(&ifp->drvr->proto_block);
+
+	return err;
+}
+
+
+s32
+brcmf_fil_cmd_int_set(struct net_device *ndev, u32 cmd, u32 data)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	s32 err;
+	__le32 data_le = cpu_to_le32(data);
+
+	mutex_lock(&ifp->drvr->proto_block);
+	err = brcmf_fil_cmd_data(ifp, cmd, &data_le, sizeof(data_le), true);
+	mutex_unlock(&ifp->drvr->proto_block);
+
+	return err;
+}
+
+s32
+brcmf_fil_cmd_int_get(struct net_device *ndev, u32 cmd, u32 *data)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	s32 err;
+	__le32 data_le = cpu_to_le32(*data);
+
+	mutex_lock(&ifp->drvr->proto_block);
+	err = brcmf_fil_cmd_data(ifp, cmd, &data_le, sizeof(data_le), false);
+	mutex_unlock(&ifp->drvr->proto_block);
+	*data = le32_to_cpu(data_le);
+
+	return err;
+}
+
+static u32
+brcmf_create_iovar(char *name, char *data, u32 datalen, char *buf, u32 buflen)
+{
+	u32 len;
+
+	len = strlen(name) + 1;
+
+	if ((len + datalen) > buflen)
+		return 0;
+
+	memcpy(buf, name, len);
+
+	/* append data onto the end of the name string */
+	if (data && datalen)
+		memcpy(&buf[len], data, datalen);
+
+	return len + datalen;
+}
+
+
+s32
+brcmf_fil_iovar_data_set(struct net_device *ndev, char *name, void *data,
+			 u32 len)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = ifp->drvr;
+	s32 err;
+	u32 buflen;
+
+	mutex_lock(&drvr->proto_block);
+
+	brcmf_dbg(FIL, "name=%s, len=%d\n", name, len);
+	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data, len, "data");
+
+	buflen = brcmf_create_iovar(name, data, len, drvr->proto_buf,
+				    sizeof(drvr->proto_buf));
+	if (buflen) {
+		err = brcmf_fil_cmd_data(ifp, BRCMF_C_SET_VAR, drvr->proto_buf,
+					 buflen, true);
+	} else {
+		err = -EPERM;
+		brcmf_dbg(ERROR, "Creating iovar failed\n");
+	}
+
+	mutex_unlock(&drvr->proto_block);
+	return err;
+}
+
+s32
+brcmf_fil_iovar_data_get(struct net_device *ndev, char *name, void *data,
+			 u32 len)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = ifp->drvr;
+	s32 err;
+	u32 buflen;
+
+	mutex_lock(&drvr->proto_block);
+
+	buflen = brcmf_create_iovar(name, data, len, drvr->proto_buf,
+				    sizeof(drvr->proto_buf));
+	if (buflen) {
+		err = brcmf_fil_cmd_data(ifp, BRCMF_C_GET_VAR, drvr->proto_buf,
+					 buflen, false);
+		if (err == 0)
+			memcpy(data, drvr->proto_buf, len);
+	} else {
+		err = -EPERM;
+		brcmf_dbg(ERROR, "Creating iovar failed\n");
+	}
+
+	brcmf_dbg(FIL, "name=%s, len=%d\n", name, len);
+	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data, len, "data");
+
+	mutex_unlock(&drvr->proto_block);
+	return err;
+}
+
+s32
+brcmf_fil_iovar_int_set(struct net_device *ndev, char *name, u32 data)
+{
+	__le32 data_le = cpu_to_le32(data);
+
+	return brcmf_fil_iovar_data_set(ndev, name, &data_le, sizeof(data_le));
+}
+
+s32
+brcmf_fil_iovar_int_get(struct net_device *ndev, char *name, u32 *data)
+{
+	__le32 data_le = cpu_to_le32(*data);
+	s32 err;
+
+	err = brcmf_fil_iovar_data_get(ndev, name, &data_le, sizeof(data_le));
+	if (err == 0)
+		*data = le32_to_cpu(data_le);
+	return err;
+}
+
+static u32
+brcmf_create_bsscfg(s32 bssidx, char *name, char *data, u32 datalen, char *buf,
+		    u32 buflen)
+{
+	const s8 *prefix = "bsscfg:";
+	s8 *p;
+	u32 prefixlen;
+	u32 namelen;
+	u32 iolen;
+	__le32 bssidx_le;
+
+	if (bssidx == 0)
+		return brcmf_create_iovar(name, data, datalen, buf, buflen);
+
+	prefixlen = strlen(prefix);
+	namelen = strlen(name) + 1; /* lengh of iovar  name + null */
+	iolen = prefixlen + namelen + sizeof(bssidx_le) + datalen;
+
+	if (buflen < iolen) {
+		brcmf_dbg(ERROR, "buffer is too short\n");
+		return 0;
+	}
+
+	p = buf;
+
+	/* copy prefix, no null */
+	memcpy(p, prefix, prefixlen);
+	p += prefixlen;
+
+	/* copy iovar name including null */
+	memcpy(p, name, namelen);
+	p += namelen;
+
+	/* bss config index as first data */
+	bssidx_le = cpu_to_le32(bssidx);
+	memcpy(p, &bssidx_le, sizeof(bssidx_le));
+	p += sizeof(bssidx_le);
+
+	/* parameter buffer follows */
+	if (datalen)
+		memcpy(p, data, datalen);
+
+	return iolen;
+}
+
+s32
+brcmf_fil_bsscfg_data_set(struct net_device *ndev, s32 bssidx, char *name,
+			  void *data, u32 len)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = ifp->drvr;
+	s32 err;
+	u32 buflen;
+
+	mutex_lock(&drvr->proto_block);
+
+	brcmf_dbg(FIL, "bssidx=%d, name=%s, len=%d\n", bssidx, name, len);
+	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data, len, "data");
+
+	buflen = brcmf_create_bsscfg(bssidx, name, data, len, drvr->proto_buf,
+				     sizeof(drvr->proto_buf));
+	if (buflen) {
+		err = brcmf_fil_cmd_data(ifp, BRCMF_C_SET_VAR, drvr->proto_buf,
+					 buflen, true);
+	} else {
+		err = -EPERM;
+		brcmf_dbg(ERROR, "Creating bsscfg failed\n");
+	}
+
+	mutex_unlock(&drvr->proto_block);
+	return err;
+}
+
+s32
+brcmf_fil_bsscfg_data_get(struct net_device *ndev, s32 bssidx, char *name,
+			  void *data, u32 len)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	struct brcmf_pub *drvr = ifp->drvr;
+	s32 err;
+	u32 buflen;
+
+	mutex_lock(&drvr->proto_block);
+
+	buflen = brcmf_create_bsscfg(bssidx, name, NULL, len, drvr->proto_buf,
+				     sizeof(drvr->proto_buf));
+	if (buflen) {
+		err = brcmf_fil_cmd_data(ifp, BRCMF_C_GET_VAR, drvr->proto_buf,
+					 buflen, false);
+		if (err == 0)
+			memcpy(data, drvr->proto_buf, len);
+	} else {
+		err = -EPERM;
+		brcmf_dbg(ERROR, "Creating bsscfg failed\n");
+	}
+	brcmf_dbg(FIL, "bssidx=%d, name=%s, len=%d\n", bssidx, name, len);
+	brcmf_dbg_hex_dump(BRCMF_FIL_ON(), data, len, "data");
+
+	mutex_unlock(&drvr->proto_block);
+	return err;
+
+}
+
+s32
+brcmf_fil_bsscfg_int_set(struct net_device *ndev, s32 bssidx, char *name,
+			 u32 data)
+{
+	__le32 data_le = cpu_to_le32(data);
+
+	return brcmf_fil_bsscfg_data_set(ndev, bssidx, name, &data_le,
+					 sizeof(data_le));
+}
+
+s32
+brcmf_fil_bsscfg_int_get(struct net_device *ndev, s32 bssidx, char *name,
+			 u32 *data)
+{
+	__le32 data_le = cpu_to_le32(*data);
+	s32 err;
+
+	err = brcmf_fil_bsscfg_data_get(ndev, bssidx, name, &data_le,
+					sizeof(data_le));
+	if (err == 0)
+		*data = le32_to_cpu(data_le);
+	return err;
+}
+
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
new file mode 100644
index 0000000..54855ef
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.h
@@ -0,0 +1,43 @@
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
+#ifndef _fwil_h_
+#define _fwil_h_
+
+s32 brcmf_fil_cmd_data_set(struct net_device *ndev, u32 cmd, void *data,
+			   u32 len);
+s32 brcmf_fil_cmd_data_get(struct net_device *ndev, u32 cmd, void *data,
+			   u32 len);
+s32 brcmf_fil_cmd_int_set(struct net_device *ndev, u32 cmd, u32 data);
+s32 brcmf_fil_cmd_int_get(struct net_device *ndev, u32 cmd, u32 *data);
+
+s32 brcmf_fil_iovar_data_set(struct net_device *ndev, char *name, void *data,
+			     u32 len);
+s32 brcmf_fil_iovar_data_get(struct net_device *ndev, char *name, void *data,
+			     u32 len);
+s32 brcmf_fil_iovar_int_set(struct net_device *ndev, char *name, u32 data);
+s32 brcmf_fil_iovar_int_get(struct net_device *ndev, char *name, u32 *data);
+
+s32 brcmf_fil_bsscfg_data_set(struct net_device *ndev, s32 bssidx, char *name,
+			      void *data, u32 len);
+s32 brcmf_fil_bsscfg_data_get(struct net_device *ndev, s32 bssidx, char *name,
+			      void *data, u32 len);
+s32 brcmf_fil_bsscfg_int_set(struct net_device *ndev, s32 bssidx, char *name,
+			     u32 data);
+s32 brcmf_fil_bsscfg_int_get(struct net_device *ndev, s32 bssidx, char *name,
+			     u32 *data);
+
+#endif /* _fwil_h_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index fdbfa20..0beb2c6 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -35,6 +35,7 @@
 #include <brcmu_wifi.h>
 #include "dhd.h"
 #include "wl_cfg80211.h"
+#include "fwil.h"
 
 #define BRCMF_SCAN_IE_LEN_MAX		2048
 #define BRCMF_PNO_VERSION		2
@@ -391,57 +392,6 @@ static u8 brcmf_mw_to_qdbm(u16 mw)
 	return qdbm;
 }
 
-/* function for reading/writing a single u32 from/to the dongle */
-static int
-brcmf_exec_dcmd_u32(struct net_device *ndev, u32 cmd, u32 *par)
-{
-	int err;
-	__le32 par_le = cpu_to_le32(*par);
-
-	err = brcmf_exec_dcmd(ndev, cmd, &par_le, sizeof(__le32));
-	*par = le32_to_cpu(par_le);
-
-	return err;
-}
-
-static s32
-brcmf_dev_iovar_setbuf_bsscfg(struct net_device *ndev, s8 *name,
-			      void *param, s32 paramlen,
-			      void *buf, s32 buflen, s32 bssidx)
-{
-	s32 err = -ENOMEM;
-	u32 len;
-
-	len = brcmf_c_mkiovar_bsscfg(name, param, paramlen,
-				     buf, buflen, bssidx);
-	BUG_ON(!len);
-	if (len > 0)
-		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, buf, len);
-	if (err)
-		WL_ERR("error (%d)\n", err);
-
-	return err;
-}
-
-static s32
-brcmf_dev_iovar_getbuf_bsscfg(struct net_device *ndev, s8 *name,
-			      void *param, s32 paramlen,
-			      void *buf, s32 buflen, s32 bssidx)
-{
-	s32 err = -ENOMEM;
-	u32 len;
-
-	len = brcmf_c_mkiovar_bsscfg(name, param, paramlen,
-				     buf, buflen, bssidx);
-	BUG_ON(!len);
-	if (len > 0)
-		err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, buf, len);
-	if (err)
-		WL_ERR("error (%d)\n", err);
-
-	return err;
-}
-
 static void convert_key_from_CPU(struct brcmf_wsec_key *key,
 				 struct brcmf_wsec_key_le *key_le)
 {
@@ -465,10 +415,10 @@ send_key_to_dongle(struct brcmf_cfg80211_info *cfg, s32 bssidx,
 
 	convert_key_from_CPU(key, &key_le);
 
-	err  = brcmf_dev_iovar_setbuf_bsscfg(ndev, "wsec_key", &key_le,
-					     sizeof(key_le),
-					     cfg->extra_buf,
-					     WL_EXTRA_BUF_MAX, bssidx);
+	brcmf_netdev_wait_pend8021x(ndev);
+
+	err = brcmf_fil_bsscfg_data_set(ndev, bssidx, "wsec_key", &key_le,
+					sizeof(key_le));
 
 	if (err)
 		WL_ERR("wsec_key error (%d)\n", err);
@@ -521,7 +471,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		}
 		WL_INFO("IF Type = AP\n");
 	} else {
-		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_INFRA, &infra);
+		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_INFRA, infra);
 		if (err) {
 			WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 			err = -EAGAIN;
@@ -539,82 +489,6 @@ done:
 	return err;
 }
 
-static s32 brcmf_dev_intvar_set(struct net_device *ndev, s8 *name, s32 val)
-{
-	s8 buf[BRCMF_DCMD_SMLEN];
-	u32 len;
-	s32 err = 0;
-	__le32 val_le;
-
-	val_le = cpu_to_le32(val);
-	len = brcmf_c_mkiovar(name, (char *)(&val_le), sizeof(val_le), buf,
-			    sizeof(buf));
-	BUG_ON(!len);
-
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, buf, len);
-	if (err)
-		WL_ERR("error (%d)\n", err);
-
-	return err;
-}
-
-static s32
-brcmf_dev_intvar_get(struct net_device *ndev, s8 *name, s32 *retval)
-{
-	union {
-		s8 buf[BRCMF_DCMD_SMLEN];
-		__le32 val;
-	} var;
-	u32 len;
-	u32 data_null;
-	s32 err = 0;
-
-	len =
-	    brcmf_c_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
-			sizeof(var.buf));
-	BUG_ON(!len);
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, &var, len);
-	if (err)
-		WL_ERR("error (%d)\n", err);
-
-	*retval = le32_to_cpu(var.val);
-
-	return err;
-}
-
-static s32
-brcmf_dev_intvar_set_bsscfg(struct net_device *ndev, s8 *name, u32 val,
-			    s32 bssidx)
-{
-	s8 buf[BRCMF_DCMD_SMLEN];
-	__le32 val_le;
-
-	val_le = cpu_to_le32(val);
-
-	return brcmf_dev_iovar_setbuf_bsscfg(ndev, name, &val_le,
-					     sizeof(val_le), buf, sizeof(buf),
-					     bssidx);
-}
-
-static s32
-brcmf_dev_intvar_get_bsscfg(struct net_device *ndev, s8 *name, s32 *val,
-			    s32 bssidx)
-{
-	s8 buf[BRCMF_DCMD_SMLEN];
-	s32 err;
-	__le32 val_le;
-
-	memset(buf, 0, sizeof(buf));
-	err = brcmf_dev_iovar_getbuf_bsscfg(ndev, name, val, sizeof(*val), buf,
-					    sizeof(buf), bssidx);
-	if (err == 0) {
-		memcpy(&val_le, buf, sizeof(val_le));
-		*val = le32_to_cpu(val_le);
-	}
-	return err;
-}
-
-
 /*
  * For now brcmf_find_bssidx will return 0. Once p2p gets implemented this
  * should return the ndev matching bssidx.
@@ -631,7 +505,7 @@ static void brcmf_set_mpc(struct net_device *ndev, int mpc)
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 
 	if (test_bit(WL_STATUS_READY, &cfg->status)) {
-		err = brcmf_dev_intvar_set(ndev, "mpc", mpc);
+		err = brcmf_fil_iovar_int_set(ndev, "mpc", mpc);
 		if (err) {
 			WL_ERR("fail to set mpc\n");
 			return;
@@ -658,30 +532,6 @@ static void brcmf_iscan_prep(struct brcmf_scan_params_le *params_le,
 }
 
 static s32
-brcmf_dev_iovar_setbuf(struct net_device *ndev, s8 * iovar, void *param,
-		    s32 paramlen, void *bufptr, s32 buflen)
-{
-	s32 iolen;
-
-	iolen = brcmf_c_mkiovar(iovar, param, paramlen, bufptr, buflen);
-	BUG_ON(!iolen);
-
-	return brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, bufptr, iolen);
-}
-
-static s32
-brcmf_dev_iovar_getbuf(struct net_device *ndev, s8 * iovar, void *param,
-		    s32 paramlen, void *bufptr, s32 buflen)
-{
-	s32 iolen;
-
-	iolen = brcmf_c_mkiovar(iovar, param, paramlen, bufptr, buflen);
-	BUG_ON(!iolen);
-
-	return brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, bufptr, buflen);
-}
-
-static s32
 brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 		struct brcmf_ssid *ssid, u16 action)
 {
@@ -703,8 +553,8 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	params->action = cpu_to_le16(action);
 	params->scan_duration = cpu_to_le16(0);
 
-	err = brcmf_dev_iovar_setbuf(iscan->ndev, "iscan", params, params_size,
-				     iscan->dcmd_buf, BRCMF_DCMD_SMLEN);
+	err = brcmf_fil_iovar_data_set(iscan->ndev, "iscan", params,
+				       params_size);
 	if (err) {
 		if (err == -EBUSY)
 			WL_INFO("system busy : iscan canceled\n");
@@ -721,7 +571,7 @@ static s32 brcmf_do_iscan(struct brcmf_cfg80211_info *cfg)
 	struct brcmf_cfg80211_iscan_ctrl *iscan = cfg_to_iscan(cfg);
 	struct net_device *ndev = cfg_to_ndev(cfg);
 	struct brcmf_ssid ssid;
-	__le32 passive_scan;
+	u32 passive_scan;
 	s32 err = 0;
 
 	/* Broadcast scan by default */
@@ -729,9 +579,9 @@ static s32 brcmf_do_iscan(struct brcmf_cfg80211_info *cfg)
 
 	iscan->state = WL_ISCAN_STATE_SCANING;
 
-	passive_scan = cfg->active_scan ? 0 : cpu_to_le32(1);
-	err = brcmf_exec_dcmd(cfg_to_ndev(cfg), BRCMF_C_SET_PASSIVE_SCAN,
-			&passive_scan, sizeof(passive_scan));
+	passive_scan = cfg->active_scan ? 0 : 1;
+	err = brcmf_fil_cmd_int_set(cfg_to_ndev(cfg),
+				    BRCMF_C_SET_PASSIVE_SCAN, passive_scan);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
@@ -757,7 +607,7 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct cfg80211_ssid *ssids;
 	struct brcmf_cfg80211_scan_req *sr = cfg->scan_req_int;
-	__le32 passive_scan;
+	u32 passive_scan;
 	bool iscan_req;
 	bool spec_scan;
 	s32 err = 0;
@@ -813,16 +663,16 @@ brcmf_cfg80211_iscan(struct wiphy *wiphy, struct net_device *ndev,
 			WL_SCAN("Broadcast scan\n");
 		}
 
-		passive_scan = cfg->active_scan ? 0 : cpu_to_le32(1);
-		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_PASSIVE_SCAN,
-				&passive_scan, sizeof(passive_scan));
+		passive_scan = cfg->active_scan ? 0 : 1;
+		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_PASSIVE_SCAN,
+					    passive_scan);
 		if (err) {
 			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
 		brcmf_set_mpc(ndev, 0);
-		err = brcmf_exec_dcmd(ndev, BRCMF_C_SCAN, &sr->ssid_le,
-				      sizeof(sr->ssid_le));
+		err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SCAN, &sr->ssid_le,
+					     sizeof(sr->ssid_le));
 		if (err) {
 			if (err == -EBUSY)
 				WL_INFO("system busy : scan for \"%s\" "
@@ -977,8 +827,8 @@ brcmf_notify_escan_complete(struct brcmf_cfg80211_info *cfg,
 		/* Scan is aborted by setting channel_list[0] to -1 */
 		params_le.channel_list[0] = cpu_to_le16(-1);
 		/* E-Scan (or anyother type) can be aborted by SCAN */
-		err = brcmf_exec_dcmd(ndev, BRCMF_C_SCAN, &params_le,
-			sizeof(params_le));
+		err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SCAN, &params_le,
+					     sizeof(params_le));
 		if (err)
 			WL_ERR("Scan abort  failed\n");
 	}
@@ -1036,8 +886,7 @@ brcmf_run_escan(struct brcmf_cfg80211_info *cfg, struct net_device *ndev,
 	params->action = cpu_to_le16(action);
 	params->sync_id = cpu_to_le16(0x1234);
 
-	err = brcmf_dev_iovar_setbuf(ndev, "escan", params, params_size,
-			cfg->escan_ioctl_buf, BRCMF_DCMD_MEDLEN);
+	err = brcmf_fil_iovar_data_set(ndev, "escan", params, params_size);
 	if (err) {
 		if (err == -EBUSY)
 			WL_INFO("system busy : escan canceled\n");
@@ -1055,16 +904,16 @@ brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
 	       struct net_device *ndev, struct cfg80211_scan_request *request)
 {
 	s32 err;
-	__le32 passive_scan;
+	u32 passive_scan;
 	struct brcmf_scan_results *results;
 
 	WL_SCAN("Enter\n");
 	cfg->escan_info.ndev = ndev;
 	cfg->escan_info.wiphy = wiphy;
 	cfg->escan_info.escan_state = WL_ESCAN_STATE_SCANNING;
-	passive_scan = cfg->active_scan ? 0 : cpu_to_le32(1);
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_PASSIVE_SCAN,
-			&passive_scan, sizeof(passive_scan));
+	passive_scan = cfg->active_scan ? 0 : 1;
+	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_PASSIVE_SCAN,
+				    passive_scan);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
@@ -1089,7 +938,7 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
 	struct cfg80211_ssid *ssids;
 	struct brcmf_cfg80211_scan_req *sr = cfg->scan_req_int;
-	__le32 passive_scan;
+	u32 passive_scan;
 	bool escan_req;
 	bool spec_scan;
 	s32 err;
@@ -1149,16 +998,16 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 		} else
 			WL_SCAN("Broadcast scan\n");
 
-		passive_scan = cfg->active_scan ? 0 : cpu_to_le32(1);
-		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_PASSIVE_SCAN,
-				&passive_scan, sizeof(passive_scan));
+		passive_scan = cfg->active_scan ? 0 : 1;
+		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_PASSIVE_SCAN,
+					    passive_scan);
 		if (err) {
 			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
 		brcmf_set_mpc(ndev, 0);
-		err = brcmf_exec_dcmd(ndev, BRCMF_C_SCAN, &sr->ssid_le,
-				      sizeof(sr->ssid_le));
+		err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SCAN, &sr->ssid_le,
+					     sizeof(sr->ssid_le));
 		if (err) {
 			if (err == -EBUSY)
 				WL_INFO("BUSY: scan for \"%s\" canceled\n",
@@ -1210,7 +1059,7 @@ static s32 brcmf_set_rts(struct net_device *ndev, u32 rts_threshold)
 {
 	s32 err = 0;
 
-	err = brcmf_dev_intvar_set(ndev, "rtsthresh", rts_threshold);
+	err = brcmf_fil_iovar_int_set(ndev, "rtsthresh", rts_threshold);
 	if (err)
 		WL_ERR("Error (%d)\n", err);
 
@@ -1221,7 +1070,7 @@ static s32 brcmf_set_frag(struct net_device *ndev, u32 frag_threshold)
 {
 	s32 err = 0;
 
-	err = brcmf_dev_intvar_set(ndev, "fragthresh", frag_threshold);
+	err = brcmf_fil_iovar_int_set(ndev, "fragthresh", frag_threshold);
 	if (err)
 		WL_ERR("Error (%d)\n", err);
 
@@ -1233,7 +1082,7 @@ static s32 brcmf_set_retry(struct net_device *ndev, u32 retry, bool l)
 	s32 err = 0;
 	u32 cmd = (l ? BRCM_SET_LRL : BRCM_SET_SRL);
 
-	err = brcmf_exec_dcmd_u32(ndev, cmd, &retry);
+	err = brcmf_fil_cmd_int_set(ndev, cmd, retry);
 	if (err) {
 		WL_ERR("cmd (%d) , error (%d)\n", cmd, err);
 		return err;
@@ -1327,7 +1176,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_info *cfg)
 	if (cfg->link_up) {
 		ndev = cfg_to_ndev(cfg);
 		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
-		err = brcmf_exec_dcmd(ndev, BRCMF_C_DISASSOC, NULL, 0);
+		err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_DISASSOC, NULL, 0);
 		if (err)
 			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
 		cfg->link_up = false;
@@ -1399,7 +1248,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	if (params->privacy)
 		wsec |= WEP_ENABLED;
 
-	err = brcmf_dev_intvar_set(ndev, "wsec", wsec);
+	err = brcmf_fil_iovar_int_set(ndev, "wsec", wsec);
 	if (err) {
 		WL_ERR("wsec failed (%d)\n", err);
 		goto done;
@@ -1411,7 +1260,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	else
 		bcnprd = 100;
 
-	err = brcmf_exec_dcmd_u32(ndev, BRCM_SET_BCNPRD, &bcnprd);
+	err = brcmf_fil_cmd_int_set(ndev, BRCM_SET_BCNPRD, bcnprd);
 	if (err) {
 		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
@@ -1453,8 +1302,8 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 		/* set channel for starter */
 		target_channel = cfg->channel;
-		err = brcmf_exec_dcmd_u32(ndev, BRCM_SET_CHANNEL,
-					  &target_channel);
+		err = brcmf_fil_cmd_int_set(ndev, BRCM_SET_CHANNEL,
+					    target_channel);
 		if (err) {
 			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
 			goto done;
@@ -1465,8 +1314,8 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	cfg->ibss_starter = false;
 
 
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SSID,
-			   &join_params, join_params_size);
+	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SET_SSID,
+				     &join_params, join_params_size);
 	if (err) {
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
 		goto done;
@@ -1512,7 +1361,7 @@ static s32 brcmf_set_wpa_version(struct net_device *ndev,
 	else
 		val = WPA_AUTH_DISABLED;
 	WL_CONN("setting wpa_auth to 0x%0x\n", val);
-	err = brcmf_dev_intvar_set(ndev, "wpa_auth", val);
+	err = brcmf_fil_iovar_int_set(ndev, "wpa_auth", val);
 	if (err) {
 		WL_ERR("set wpa_auth failed (%d)\n", err);
 		return err;
@@ -1552,7 +1401,7 @@ static s32 brcmf_set_auth_type(struct net_device *ndev,
 		break;
 	}
 
-	err = brcmf_dev_intvar_set(ndev, "auth", val);
+	err = brcmf_fil_iovar_int_set(ndev, "auth", val);
 	if (err) {
 		WL_ERR("set auth failed (%d)\n", err);
 		return err;
@@ -1617,7 +1466,7 @@ brcmf_set_set_cipher(struct net_device *ndev,
 	}
 
 	WL_CONN("pval (%d) gval (%d)\n", pval, gval);
-	err = brcmf_dev_intvar_set(ndev, "wsec", pval | gval);
+	err = brcmf_fil_iovar_int_set(ndev, "wsec", pval | gval);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
@@ -1640,7 +1489,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 	s32 err = 0;
 
 	if (sme->crypto.n_akm_suites) {
-		err = brcmf_dev_intvar_get(ndev, "wpa_auth", &val);
+		err = brcmf_fil_iovar_int_get(ndev, "wpa_auth", &val);
 		if (err) {
 			WL_ERR("could not get wpa_auth (%d)\n", err);
 			return err;
@@ -1674,7 +1523,7 @@ brcmf_set_key_mgmt(struct net_device *ndev, struct cfg80211_connect_params *sme)
 		}
 
 		WL_CONN("setting wpa_auth to %d\n", val);
-		err = brcmf_dev_intvar_set(ndev, "wpa_auth", val);
+		err = brcmf_fil_iovar_int_set(ndev, "wpa_auth", val);
 		if (err) {
 			WL_ERR("could not set wpa_auth (%d)\n", err);
 			return err;
@@ -1747,7 +1596,7 @@ brcmf_set_sharedkey(struct net_device *ndev,
 	if (sec->auth_type == NL80211_AUTHTYPE_SHARED_KEY) {
 		WL_CONN("set auth_type to shared key\n");
 		val = WL_AUTH_SHARED_KEY;	/* shared key */
-		err = brcmf_dev_intvar_set_bsscfg(ndev, "auth", val, bssidx);
+		err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "auth", val);
 		if (err)
 			WL_ERR("set auth failed (%d)\n", err);
 	}
@@ -1835,8 +1684,8 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_ch_to_chanspec(cfg->channel,
 			     &join_params, &join_params_size);
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SSID,
-			   &join_params, join_params_size);
+	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SET_SSID,
+				     &join_params, join_params_size);
 	if (err)
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
 
@@ -1864,8 +1713,8 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 
 	memcpy(&scbval.ea, &profile->bssid, ETH_ALEN);
 	scbval.val = cpu_to_le32(reason_code);
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_DISASSOC, &scbval,
-			      sizeof(struct brcmf_scb_val_le));
+	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_DISASSOC, &scbval,
+				     sizeof(struct brcmf_scb_val_le));
 	if (err)
 		WL_ERR("error (%d)\n", err);
 
@@ -1905,7 +1754,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 	}
 	/* Make sure radio is off or on as far as software is concerned */
 	disable = WL_RADIO_SW_DISABLE << 16;
-	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_RADIO, &disable);
+	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_RADIO, disable);
 	if (err)
 		WL_ERR("WLC_SET_RADIO error (%d)\n", err);
 
@@ -1913,7 +1762,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 		txpwrmw = 0xffff;
 	else
 		txpwrmw = (u16) dbm;
-	err = brcmf_dev_intvar_set(ndev, "qtxpower",
+	err = brcmf_fil_iovar_int_set(ndev, "qtxpower",
 			(s32) (brcmf_mw_to_qdbm(txpwrmw)));
 	if (err)
 		WL_ERR("qtxpower error (%d)\n", err);
@@ -1936,7 +1785,7 @@ static s32 brcmf_cfg80211_get_tx_power(struct wiphy *wiphy, s32 *dbm)
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	err = brcmf_dev_intvar_get(ndev, "qtxpower", &txpwrdbm);
+	err = brcmf_fil_iovar_int_get(ndev, "qtxpower", &txpwrdbm);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		goto done;
@@ -1966,7 +1815,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 		return -EIO;
 
 	bssidx = brcmf_find_bssidx(cfg, ndev);
-	err = brcmf_dev_intvar_get_bsscfg(ndev, "wsec", &wsec, bssidx);
+	err = brcmf_fil_bsscfg_int_get(ndev, bssidx, "wsec", &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		goto done;
@@ -1975,8 +1824,8 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (wsec & WEP_ENABLED) {
 		/* Just select a new current key */
 		index = key_idx;
-		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_KEY_PRIMARY,
-					  &index);
+		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_KEY_PRIMARY,
+					    index);
 		if (err)
 			WL_ERR("error (%d)\n", err);
 	}
@@ -1991,7 +1840,6 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
 	struct brcmf_wsec_key key;
-	struct brcmf_wsec_key_le key_le;
 	s32 err = 0;
 	s32 bssidx;
 
@@ -2061,13 +1909,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 			WL_ERR("Invalid cipher (0x%x)\n", params->cipher);
 			return -EINVAL;
 		}
-		convert_key_from_CPU(&key, &key_le);
-
-		brcmf_netdev_wait_pend8021x(ndev);
-		err  = brcmf_dev_iovar_setbuf_bsscfg(ndev, "wsec_key", &key_le,
-						     sizeof(key_le),
-						     cfg->extra_buf,
-						     WL_EXTRA_BUF_MAX, bssidx);
+		err = send_key_to_dongle(cfg, bssidx, ndev, &key);
 		if (err)
 			WL_ERR("wsec_key error (%d)\n", err);
 	}
@@ -2152,13 +1994,13 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (err)
 		goto done;
 
-	err = brcmf_dev_intvar_get_bsscfg(ndev, "wsec", &wsec, bssidx);
+	err = brcmf_fil_bsscfg_int_get(ndev, bssidx, "wsec", &wsec);
 	if (err) {
 		WL_ERR("get wsec error (%d)\n", err);
 		goto done;
 	}
 	wsec |= val;
-	err = brcmf_dev_intvar_set_bsscfg(ndev, "wsec", wsec, bssidx);
+	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wsec", wsec);
 	if (err) {
 		WL_ERR("set wsec error (%d)\n", err);
 		goto done;
@@ -2228,7 +2070,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 	memset(&params, 0, sizeof(params));
 
 	bssidx = brcmf_find_bssidx(cfg, ndev);
-	err = brcmf_dev_intvar_get_bsscfg(ndev, "wsec", &wsec, bssidx);
+	err = brcmf_fil_bsscfg_int_get(ndev, bssidx, "wsec", &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -2286,27 +2128,25 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	s32 rate;
 	s32 err = 0;
 	u8 *bssid = profile->bssid;
-	struct brcmf_sta_info_le *sta_info_le;
+	struct brcmf_sta_info_le sta_info_le;
 
 	WL_TRACE("Enter, MAC %pM\n", mac);
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
 	if (cfg->conf->mode == WL_MODE_AP) {
-		err = brcmf_dev_iovar_getbuf(ndev, "sta_info", mac, ETH_ALEN,
-					     cfg->dcmd_buf,
-					     WL_DCMD_LEN_MAX);
+		memcpy(&sta_info_le, mac, ETH_ALEN);
+		err = brcmf_fil_iovar_data_get(ndev, "sta_info", &sta_info_le,
+					       sizeof(sta_info_le));
 		if (err < 0) {
 			WL_ERR("GET STA INFO failed, %d\n", err);
 			goto done;
 		}
-		sta_info_le = (struct brcmf_sta_info_le *)cfg->dcmd_buf;
-
 		sinfo->filled = STATION_INFO_INACTIVE_TIME;
-		sinfo->inactive_time = le32_to_cpu(sta_info_le->idle) * 1000;
-		if (le32_to_cpu(sta_info_le->flags) & BRCMF_STA_ASSOC) {
+		sinfo->inactive_time = le32_to_cpu(sta_info_le.idle) * 1000;
+		if (le32_to_cpu(sta_info_le.flags) & BRCMF_STA_ASSOC) {
 			sinfo->filled |= STATION_INFO_CONNECTED_TIME;
-			sinfo->connected_time = le32_to_cpu(sta_info_le->in);
+			sinfo->connected_time = le32_to_cpu(sta_info_le.in);
 		}
 		WL_TRACE("STA idle time : %d ms, connected time :%d sec\n",
 			 sinfo->inactive_time, sinfo->connected_time);
@@ -2318,7 +2158,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 			goto done;
 		}
 		/* Report the current tx rate */
-		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_GET_RATE, &rate);
+	err = brcmf_fil_cmd_int_get(ndev, BRCMF_C_GET_RATE, &rate);
 		if (err) {
 			WL_ERR("Could not get rate (%d)\n", err);
 			goto done;
@@ -2330,8 +2170,8 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 
 		if (test_bit(WL_STATUS_CONNECTED, &cfg->status)) {
 			memset(&scb_val, 0, sizeof(scb_val));
-			err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_RSSI, &scb_val,
-					      sizeof(scb_val));
+		err = brcmf_fil_cmd_data_get(ndev, BRCMF_C_GET_RSSI, &scb_val,
+					     sizeof(struct brcmf_scb_val_le));
 			if (err) {
 				WL_ERR("Could not get rssi (%d)\n", err);
 				goto done;
@@ -2376,7 +2216,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	pm = enabled ? PM_FAST : PM_OFF;
 	WL_INFO("power save %s\n", (pm ? "enabled" : "disabled"));
 
-	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_PM, &pm);
+	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_PM, pm);
 	if (err) {
 		if (err == -ENODEV)
 			WL_ERR("net_device is not ready yet\n");
@@ -2407,8 +2247,8 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 
 	/* addr param is always NULL. ignore it */
 	/* Get current rateset */
-	err = brcmf_exec_dcmd(ndev, BRCM_GET_CURR_RATESET, &rateset_le,
-			      sizeof(rateset_le));
+	err = brcmf_fil_cmd_data_get(ndev, BRCM_GET_CURR_RATESET, &rateset_le,
+				     sizeof(rateset_le));
 	if (err) {
 		WL_ERR("could not get current rateset (%d)\n", err);
 		goto done;
@@ -2435,8 +2275,8 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 	 *      Set rate override,
 	 *      Since the is a/b/g-blind, both a/bg_rate are enforced.
 	 */
-	err_bg = brcmf_dev_intvar_set(ndev, "bg_rate", rate);
-	err_a = brcmf_dev_intvar_set(ndev, "a_rate", rate);
+	err_bg = brcmf_fil_iovar_int_set(ndev, "bg_rate", rate);
+	err_a = brcmf_fil_iovar_int_set(ndev, "a_rate", rate);
 	if (err_bg && err_a) {
 		WL_ERR("could not set fixed rate (%d) (%d)\n", err_bg, err_a);
 		err = err_bg | err_a;
@@ -2565,7 +2405,8 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_info *cfg,
 
 	*(__le32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
 
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
+	err = brcmf_fil_cmd_data_get(ndev, BRCMF_C_GET_BSS_INFO, buf,
+				     WL_BSS_INFO_MAX);
 	if (err) {
 		WL_ERR("WLC_GET_BSS_INFO failed: %d\n", err);
 		goto CleanUp;
@@ -2706,8 +2547,9 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 	ssid = &profile->ssid;
 
 	*(__le32 *)cfg->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
-	err = brcmf_exec_dcmd(cfg_to_ndev(cfg), BRCMF_C_GET_BSS_INFO,
-			cfg->extra_buf, WL_EXTRA_BUF_MAX);
+	err = brcmf_fil_cmd_data_get(cfg_to_ndev(cfg),
+				     BRCMF_C_GET_BSS_INFO,
+				     cfg->extra_buf, WL_EXTRA_BUF_MAX);
 	if (err) {
 		WL_ERR("Could not get bss info %d\n", err);
 		goto update_bss_info_out;
@@ -2732,8 +2574,8 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_info *cfg)
 		* so we speficially query dtim information to dongle.
 		*/
 		u32 var;
-		err = brcmf_dev_intvar_get(cfg_to_ndev(cfg),
-					   "dtim_assoc", &var);
+		err = brcmf_fil_iovar_int_get(cfg_to_ndev(cfg),
+					      "dtim_assoc", &var);
 		if (err) {
 			WL_ERR("wl dtim_assoc failed (%d)\n", err);
 			goto update_bss_info_out;
@@ -2820,7 +2662,6 @@ static s32
 brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
 		     struct brcmf_scan_results **bss_list)
 {
-	struct brcmf_iscan_results list;
 	struct brcmf_scan_results *results;
 	struct brcmf_scan_results_le *results_le;
 	struct brcmf_iscan_results *list_buf;
@@ -2830,15 +2671,13 @@ brcmf_get_iscan_results(struct brcmf_cfg80211_iscan_ctrl *iscan, u32 *status,
 	list_buf = (struct brcmf_iscan_results *)iscan->scan_buf;
 	results = &list_buf->results;
 	results_le = &list_buf->results_le;
-	results->buflen = BRCMF_ISCAN_RESULTS_FIXED_SIZE;
-	results->version = 0;
-	results->count = 0;
+	results_le->buflen = cpu_to_le32(sizeof(iscan->scan_buf));
+	results_le->version = 0;
+	results_le->count = 0;
 
-	memset(&list, 0, sizeof(list));
-	list.results_le.buflen = cpu_to_le32(WL_ISCAN_BUF_MAX);
-	err = brcmf_dev_iovar_getbuf(iscan->ndev, "iscanresults", &list,
-				     BRCMF_ISCAN_RESULTS_FIXED_SIZE,
-				     iscan->scan_buf, WL_ISCAN_BUF_MAX);
+	err = brcmf_fil_iovar_data_get(iscan->ndev, "iscanresults",
+				       iscan->scan_buf,
+				       sizeof(iscan->scan_buf));
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
@@ -3222,42 +3061,6 @@ static s32 brcmf_cfg80211_suspend(struct wiphy *wiphy,
 }
 
 static __used s32
-brcmf_dev_bufvar_set(struct net_device *ndev, s8 *name, s8 *buf, s32 len)
-{
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
-	u32 buflen;
-
-	buflen = brcmf_c_mkiovar(name, buf, len, cfg->dcmd_buf,
-			       WL_DCMD_LEN_MAX);
-	BUG_ON(!buflen);
-
-	return brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, cfg->dcmd_buf,
-			       buflen);
-}
-
-static s32
-brcmf_dev_bufvar_get(struct net_device *ndev, s8 *name, s8 *buf,
-		  s32 buf_len)
-{
-	struct brcmf_cfg80211_info *cfg = ndev_to_cfg(ndev);
-	u32 len;
-	s32 err = 0;
-
-	len = brcmf_c_mkiovar(name, NULL, 0, cfg->dcmd_buf,
-			    WL_DCMD_LEN_MAX);
-	BUG_ON(!len);
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, cfg->dcmd_buf,
-			      WL_DCMD_LEN_MAX);
-	if (err) {
-		WL_ERR("error (%d)\n", err);
-		return err;
-	}
-	memcpy(buf, cfg->dcmd_buf, buf_len);
-
-	return err;
-}
-
-static __used s32
 brcmf_update_pmklist(struct net_device *ndev,
 		     struct brcmf_cfg80211_pmk_list *pmk_list, s32 err)
 {
@@ -3275,8 +3078,8 @@ brcmf_update_pmklist(struct net_device *ndev,
 	}
 
 	if (!err)
-		brcmf_dev_bufvar_set(ndev, "pmkid_info", (char *)pmk_list,
-					sizeof(*pmk_list));
+		brcmf_fil_iovar_data_set(ndev, "pmkid_info", (char *)pmk_list,
+					 sizeof(*pmk_list));
 
 	return err;
 }
@@ -3512,15 +3315,13 @@ out_err:
 #ifndef CONFIG_BRCMISCAN
 static int brcmf_dev_pno_clean(struct net_device *ndev)
 {
-	char iovbuf[128];
 	int ret;
 
 	/* Disable pfn */
-	ret = brcmf_dev_intvar_set(ndev, "pfn", 0);
+	ret = brcmf_fil_iovar_int_set(ndev, "pfn", 0);
 	if (ret == 0) {
 		/* clear pfn */
-		ret = brcmf_dev_iovar_setbuf(ndev, "pfnclear", NULL, 0,
-					     iovbuf, sizeof(iovbuf));
+		ret = brcmf_fil_iovar_data_set(ndev, "pfnclear", NULL, 0);
 	}
 	if (ret < 0)
 		WL_ERR("failed code %d\n", ret);
@@ -3531,7 +3332,6 @@ static int brcmf_dev_pno_clean(struct net_device *ndev)
 static int brcmf_dev_pno_config(struct net_device *ndev)
 {
 	struct brcmf_pno_param_le pfn_param;
-	char iovbuf[128];
 
 	memset(&pfn_param, 0, sizeof(pfn_param));
 	pfn_param.version = cpu_to_le32(BRCMF_PNO_VERSION);
@@ -3544,9 +3344,8 @@ static int brcmf_dev_pno_config(struct net_device *ndev)
 	/* set up pno scan fr */
 	pfn_param.scan_freq = cpu_to_le32(BRCMF_PNO_TIME);
 
-	return brcmf_dev_iovar_setbuf(ndev, "pfn_set",
-				      &pfn_param, sizeof(pfn_param),
-				      iovbuf, sizeof(iovbuf));
+	return brcmf_fil_iovar_data_set(ndev, "pfn_set", &pfn_param,
+					sizeof(pfn_param));
 }
 
 static int
@@ -3554,7 +3353,6 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 				struct net_device *ndev,
 				struct cfg80211_sched_scan_request *request)
 {
-	char iovbuf[128];
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
 	struct brcmf_pno_net_param_le pfn;
 	int i;
@@ -3620,15 +3418,14 @@ brcmf_cfg80211_sched_scan_start(struct wiphy *wiphy,
 			pfn.flags = cpu_to_le32(1 << BRCMF_PNO_HIDDEN_BIT);
 			pfn.ssid.SSID_len = cpu_to_le32(ssid_len);
 			memcpy(pfn.ssid.SSID, ssid->ssid, ssid_len);
-			ret = brcmf_dev_iovar_setbuf(ndev, "pfn_add",
-						     &pfn, sizeof(pfn),
-						     iovbuf, sizeof(iovbuf));
+			ret = brcmf_fil_iovar_data_set(ndev, "pfn_add",
+						       &pfn, sizeof(pfn));
 			WL_SCAN(">>> PNO filter %s for ssid (%s)\n",
 				ret == 0 ? "set" : "failed",
 				ssid->ssid);
 		}
 		/* Enable the PNO */
-		if (brcmf_dev_intvar_set(ndev, "pfn", 1) < 0) {
+		if (brcmf_fil_iovar_int_set(ndev, "pfn", 1) < 0) {
 			WL_ERR("PNO enable failed!! ret=%d\n", ret);
 			return -EINVAL;
 		}
@@ -3676,20 +3473,19 @@ static s32 brcmf_configure_opensecurity(struct net_device *ndev, s32 bssidx)
 	s32 err;
 
 	/* set auth */
-	err = brcmf_dev_intvar_set_bsscfg(ndev, "auth", 0, bssidx);
+	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "auth", 0);
 	if (err < 0) {
 		WL_ERR("auth error %d\n", err);
 		return err;
 	}
 	/* set wsec */
-	err = brcmf_dev_intvar_set_bsscfg(ndev, "wsec", 0, bssidx);
+	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wsec", 0);
 	if (err < 0) {
 		WL_ERR("wsec error %d\n", err);
 		return err;
 	}
 	/* set upper-layer auth */
-	err = brcmf_dev_intvar_set_bsscfg(ndev, "wpa_auth",
-					  WPA_AUTH_NONE, bssidx);
+	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wpa_auth", WPA_AUTH_NONE);
 	if (err < 0) {
 		WL_ERR("wpa_auth error %d\n", err);
 		return err;
@@ -3850,8 +3646,8 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 				wme_bss_disable = 0;
 		}
 		/* set wme_bss_disable to sync RSN Capabilities */
-		err = brcmf_dev_intvar_set_bsscfg(ndev, "wme_bss_disable",
-						  wme_bss_disable, bssidx);
+		err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wme_bss_disable",
+					       wme_bss_disable);
 		if (err < 0) {
 			WL_ERR("wme_bss_disable error %d\n", err);
 			goto exit;
@@ -3861,19 +3657,19 @@ brcmf_configure_wpaie(struct net_device *ndev, struct brcmf_vs_tlv *wpa_ie,
 	wsec = (pval | gval | SES_OW_ENABLED);
 
 	/* set auth */
-	err = brcmf_dev_intvar_set_bsscfg(ndev, "auth", auth, bssidx);
+	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "auth", auth);
 	if (err < 0) {
 		WL_ERR("auth error %d\n", err);
 		goto exit;
 	}
 	/* set wsec */
-	err = brcmf_dev_intvar_set_bsscfg(ndev, "wsec", wsec, bssidx);
+	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wsec", wsec);
 	if (err < 0) {
 		WL_ERR("wsec error %d\n", err);
 		goto exit;
 	}
 	/* set upper-layer auth */
-	err = brcmf_dev_intvar_set_bsscfg(ndev, "wpa_auth", wpa_auth, bssidx);
+	err = brcmf_fil_bsscfg_int_set(ndev, bssidx, "wpa_auth", wpa_auth);
 	if (err < 0) {
 		WL_ERR("wpa_auth error %d\n", err);
 		goto exit;
@@ -4103,11 +3899,9 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 		}
 	}
 	if (total_ie_buf_len) {
-		err  = brcmf_dev_iovar_setbuf_bsscfg(ndev, "vndr_ie",
-						     iovar_ie_buf,
-						     total_ie_buf_len,
-						     cfg->extra_buf,
-						     WL_EXTRA_BUF_MAX, bssidx);
+		err  = brcmf_fil_bsscfg_data_set(ndev, bssidx, "vndr_ie",
+						 iovar_ie_buf,
+						 total_ie_buf_len);
 		if (err)
 			WL_ERR("vndr ie set error : %d\n", err);
 	}
@@ -4124,7 +3918,6 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	s32 ie_offset;
 	struct brcmf_tlv *ssid_ie;
 	struct brcmf_ssid_le ssid_le;
-	s32 ioctl_value;
 	s32 err = -EPERM;
 	struct brcmf_tlv *rsn_ie;
 	struct brcmf_vs_tlv *wpa_ie;
@@ -4163,20 +3956,17 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	brcmf_set_mpc(ndev, 0);
-	ioctl_value = 1;
-	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_DOWN, &ioctl_value);
+	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_DOWN, 1);
 	if (err < 0) {
 		WL_ERR("BRCMF_C_DOWN error %d\n", err);
 		goto exit;
 	}
-	ioctl_value = 1;
-	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_INFRA, &ioctl_value);
+	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_INFRA, 1);
 	if (err < 0) {
 		WL_ERR("SET INFRA error %d\n", err);
 		goto exit;
 	}
-	ioctl_value = 1;
-	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_AP, &ioctl_value);
+	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_AP, 1);
 	if (err < 0) {
 		WL_ERR("setting AP mode failed %d\n", err);
 		goto exit;
@@ -4245,25 +4035,22 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		WL_TRACE("Applied Vndr IEs for Probe Resp\n");
 
 	if (settings->beacon_interval) {
-		ioctl_value = settings->beacon_interval;
-		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_BCNPRD,
-					  &ioctl_value);
+		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_BCNPRD,
+					    settings->beacon_interval);
 		if (err < 0) {
 			WL_ERR("Beacon Interval Set Error, %d\n", err);
 			goto exit;
 		}
 	}
 	if (settings->dtim_period) {
-		ioctl_value = settings->dtim_period;
-		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_DTIMPRD,
-					  &ioctl_value);
+		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_DTIMPRD,
+					    settings->dtim_period);
 		if (err < 0) {
 			WL_ERR("DTIM Interval Set Error, %d\n", err);
 			goto exit;
 		}
 	}
-	ioctl_value = 1;
-	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_UP, &ioctl_value);
+	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_UP, 1);
 	if (err < 0) {
 		WL_ERR("BRCMF_C_UP error (%d)\n", err);
 		goto exit;
@@ -4273,8 +4060,8 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	/* join parameters starts with ssid */
 	memcpy(&join_params.ssid_le, &ssid_le, sizeof(ssid_le));
 	/* create softap */
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SSID, &join_params,
-			      sizeof(join_params));
+	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SET_SSID, &join_params,
+				     sizeof(join_params));
 	if (err < 0) {
 		WL_ERR("SET SSID error (%d)\n", err);
 		goto exit;
@@ -4291,7 +4078,6 @@ exit:
 static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 {
 	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
-	s32 ioctl_value;
 	s32 err = -EPERM;
 
 	WL_TRACE("Enter\n");
@@ -4300,14 +4086,12 @@ static int brcmf_cfg80211_stop_ap(struct wiphy *wiphy, struct net_device *ndev)
 		/* Due to most likely deauths outstanding we sleep */
 		/* first to make sure they get processed by fw. */
 		msleep(400);
-		ioctl_value = 0;
-		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_AP, &ioctl_value);
+		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_AP, 0);
 		if (err < 0) {
 			WL_ERR("setting AP mode failed %d\n", err);
 			goto exit;
 		}
-		ioctl_value = 0;
-		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_UP, &ioctl_value);
+		err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_UP, 0);
 		if (err < 0) {
 			WL_ERR("BRCMF_C_UP error %d\n", err);
 			goto exit;
@@ -4337,8 +4121,9 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 
 	memcpy(&scbval.ea, mac, ETH_ALEN);
 	scbval.val = cpu_to_le32(WLAN_REASON_DEAUTH_LEAVING);
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
-			      &scbval, sizeof(scbval));
+	err = brcmf_fil_cmd_data_set(ndev,
+				     BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON,
+				     &scbval, sizeof(scbval));
 	if (err)
 		WL_ERR("SCB_DEAUTHENTICATE_FOR_REASON failed %d\n", err);
 
@@ -4549,8 +4334,8 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 
 	brcmf_clear_assoc_ies(cfg);
 
-	err = brcmf_dev_bufvar_get(ndev, "assoc_info", cfg->extra_buf,
-				WL_ASSOC_INFO_MAX);
+	err = brcmf_fil_iovar_data_get(ndev, "assoc_info", cfg->extra_buf,
+				       WL_ASSOC_INFO_MAX);
 	if (err) {
 		WL_ERR("could not get assoc info (%d)\n", err);
 		return err;
@@ -4560,9 +4345,9 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 	req_len = le32_to_cpu(assoc_info->req_len);
 	resp_len = le32_to_cpu(assoc_info->resp_len);
 	if (req_len) {
-		err = brcmf_dev_bufvar_get(ndev, "assoc_req_ies",
-					   cfg->extra_buf,
-					   WL_ASSOC_INFO_MAX);
+		err = brcmf_fil_iovar_data_get(ndev, "assoc_req_ies",
+					       cfg->extra_buf,
+					       WL_ASSOC_INFO_MAX);
 		if (err) {
 			WL_ERR("could not get assoc req (%d)\n", err);
 			return err;
@@ -4576,9 +4361,9 @@ static s32 brcmf_get_assoc_ies(struct brcmf_cfg80211_info *cfg)
 		conn_info->req_ie = NULL;
 	}
 	if (resp_len) {
-		err = brcmf_dev_bufvar_get(ndev, "assoc_resp_ies",
-					   cfg->extra_buf,
-					   WL_ASSOC_INFO_MAX);
+		err = brcmf_fil_iovar_data_get(ndev, "assoc_resp_ies",
+					       cfg->extra_buf,
+					       WL_ASSOC_INFO_MAX);
 		if (err) {
 			WL_ERR("could not get assoc resp (%d)\n", err);
 			return err;
@@ -4627,7 +4412,8 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_info *cfg,
 
 	/* data sent to dongle has to be little endian */
 	*(__le32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
+	err = brcmf_fil_cmd_data_get(ndev, BRCMF_C_GET_BSS_INFO, buf,
+				     WL_BSS_INFO_MAX);
 
 	if (err)
 		goto done;
@@ -4841,8 +4627,9 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_info *cfg,
 		goto scan_done_out;
 	}
 
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_CHANNEL, &channel_inform_le,
-			      sizeof(channel_inform_le));
+	err = brcmf_fil_cmd_data_get(ndev, BRCMF_C_GET_CHANNEL,
+				     &channel_inform_le,
+				     sizeof(channel_inform_le));
 	if (err) {
 		WL_ERR("scan busy (%d)\n", err);
 		scan_abort = true;
@@ -4856,8 +4643,8 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_info *cfg,
 
 	memset(cfg->scan_results, 0, len);
 	bss_list_le->buflen = cpu_to_le32(len);
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SCAN_RESULTS,
-			      cfg->scan_results, len);
+	err = brcmf_fil_cmd_data_get(ndev, BRCMF_C_SCAN_RESULTS,
+				     cfg->scan_results, len);
 	if (err) {
 		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
 		err = -EINVAL;
@@ -5201,22 +4988,18 @@ brcmf_cfg80211_event(struct net_device *ndev,
 
 static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 {
-	/* Room for "event_msgs" + '\0' + bitvec */
-	s8 iovbuf[BRCMF_EVENTING_MASK_LEN + 12];
 	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 
 	/* Setup event_msgs */
-	brcmf_c_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN,
-			iovbuf, sizeof(iovbuf));
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
+	err = brcmf_fil_iovar_data_get(ndev, "event_msgs", eventmask,
+				       BRCMF_EVENTING_MASK_LEN);
 	if (err) {
 		WL_ERR("Get event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
 	}
-	memcpy(eventmask, iovbuf, BRCMF_EVENTING_MASK_LEN);
 
 	setbit(eventmask, BRCMF_E_SET_SSID);
 	setbit(eventmask, BRCMF_E_ROAM);
@@ -5240,9 +5023,8 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 	setbit(eventmask, BRCMF_E_ESCAN_RESULT);
 	setbit(eventmask, BRCMF_E_PFN_NET_FOUND);
 
-	brcmf_c_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN,
-			iovbuf, sizeof(iovbuf));
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = brcmf_fil_iovar_data_set(ndev, "event_msgs", eventmask,
+				       BRCMF_EVENTING_MASK_LEN);
 	if (err) {
 		WL_ERR("Set event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
@@ -5256,23 +5038,16 @@ dongle_eventmsg_out:
 static s32
 brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 {
-	s8 iovbuf[32];
 	s32 err = 0;
 	__le32 roamtrigger[2];
 	__le32 roam_delta[2];
-	__le32 bcn_to_le;
-	__le32 roamvar_le;
 
 	/*
 	 * Setup timeout if Beacons are lost and roam is
 	 * off to report link down
 	 */
 	if (roamvar) {
-		bcn_to_le = cpu_to_le32(bcn_timeout);
-		brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_to_le,
-			sizeof(bcn_to_le), iovbuf, sizeof(iovbuf));
-		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR,
-				   iovbuf, sizeof(iovbuf));
+		err = brcmf_fil_iovar_int_set(ndev, "bcn_timeout", bcn_timeout);
 		if (err) {
 			WL_ERR("bcn_timeout error (%d)\n", err);
 			goto dongle_rom_out;
@@ -5284,10 +5059,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	 * to take care of roaming
 	 */
 	WL_INFO("Internal Roaming = %s\n", roamvar ? "Off" : "On");
-	roamvar_le = cpu_to_le32(roamvar);
-	brcmf_c_mkiovar("roam_off", (char *)&roamvar_le,
-				sizeof(roamvar_le), iovbuf, sizeof(iovbuf));
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = brcmf_fil_iovar_int_set(ndev, "roam_off", roamvar);
 	if (err) {
 		WL_ERR("roam_off error (%d)\n", err);
 		goto dongle_rom_out;
@@ -5295,8 +5067,8 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 
 	roamtrigger[0] = cpu_to_le32(WL_ROAM_TRIGGER_LEVEL);
 	roamtrigger[1] = cpu_to_le32(BRCM_BAND_ALL);
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_ROAM_TRIGGER,
-			(void *)roamtrigger, sizeof(roamtrigger));
+	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SET_ROAM_TRIGGER,
+				     (void *)roamtrigger, sizeof(roamtrigger));
 	if (err) {
 		WL_ERR("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
 		goto dongle_rom_out;
@@ -5304,8 +5076,8 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 
 	roam_delta[0] = cpu_to_le32(WL_ROAM_DELTA);
 	roam_delta[1] = cpu_to_le32(BRCM_BAND_ALL);
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_ROAM_DELTA,
-				(void *)roam_delta, sizeof(roam_delta));
+	err = brcmf_fil_cmd_data_set(ndev, BRCMF_C_SET_ROAM_DELTA,
+				     (void *)roam_delta, sizeof(roam_delta));
 	if (err) {
 		WL_ERR("WLC_SET_ROAM_DELTA error (%d)\n", err);
 		goto dongle_rom_out;
@@ -5320,12 +5092,9 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		      s32 scan_unassoc_time, s32 scan_passive_time)
 {
 	s32 err = 0;
-	__le32 scan_assoc_tm_le = cpu_to_le32(scan_assoc_time);
-	__le32 scan_unassoc_tm_le = cpu_to_le32(scan_unassoc_time);
-	__le32 scan_passive_tm_le = cpu_to_le32(scan_passive_time);
 
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SCAN_CHANNEL_TIME,
-			   &scan_assoc_tm_le, sizeof(scan_assoc_tm_le));
+	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_SCAN_CHANNEL_TIME,
+				    scan_assoc_time);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan assoc time is not supported\n");
@@ -5333,8 +5102,8 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 			WL_ERR("Scan assoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SCAN_UNASSOC_TIME,
-			   &scan_unassoc_tm_le, sizeof(scan_unassoc_tm_le));
+	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_SCAN_UNASSOC_TIME,
+				    scan_unassoc_time);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan unassoc time is not supported\n");
@@ -5343,8 +5112,8 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		goto dongle_scantime_out;
 	}
 
-	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SCAN_PASSIVE_TIME,
-			   &scan_passive_tm_le, sizeof(scan_passive_tm_le));
+	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_SCAN_PASSIVE_TIME,
+				    scan_passive_time);
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan passive time is not supported\n");
@@ -5364,8 +5133,8 @@ static s32 wl_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	s8 phy;
 	s32 err = 0;
 
-	err = brcmf_exec_dcmd(cfg_to_ndev(cfg), BRCM_GET_PHYLIST,
-			      &phy_list, sizeof(phy_list));
+	err = brcmf_fil_cmd_data_get(cfg_to_ndev(cfg), BRCM_GET_PHYLIST,
+				     &phy_list, sizeof(phy_list));
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
@@ -5407,7 +5176,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_info *cfg)
 		goto default_conf_out;
 
 	power_mode = cfg->pwr_save ? PM_FAST : PM_OFF;
-	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_PM, &power_mode);
+	err = brcmf_fil_cmd_int_set(ndev, BRCMF_C_SET_PM, power_mode);
 	if (err)
 		goto default_conf_out;
 	WL_INFO("power save set to %s\n",
-- 
1.7.6


