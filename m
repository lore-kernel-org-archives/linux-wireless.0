Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1731 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696Ab1JBRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:00 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 18/20] staging: brcm80211: renamed ioctl
 functions/structs to dcmd
Date: Sun, 2 Oct 2011 10:14:43 -0700
Message-ID: <1317575685-3156-19-git-send-email-frankyl@broadcom.com> (sfid-20111002_191546_499362_CE92A364)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

The fullmac dongle communicates with the driver using certain codes. These
codes were named 'ioctls' in the code, but this term is confusing since
it is used in kernel<->driver context. The term 'ioctl' has been replaced
with 'dcmd' for 'dongle command'.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |   32 ++----
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c     |  118 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |   32 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |  118 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h   |   13 +--
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |   26 +++--
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  126 +++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |   10 +-
 8 files changed, 233 insertions(+), 242 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index d79bd79..501faed 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -23,9 +23,9 @@
 
 #define BRCMF_VERSION_STR		"4.218.248.5"
 
-#define	BRCMF_C_IOCTL_SMLEN	256	/* "small" ioctl buffer required */
-#define BRCMF_C_IOCTL_MEDLEN	1536	/* "med" ioctl buffer required */
-#define	BRCMF_C_IOCTL_MAXLEN	8192
+#define	BRCMF_C_DCMD_SMLEN	256	/* "small" cmd buffer required */
+#define BRCMF_C_DCMD_MEDLEN	1536	/* "med" cmd buffer required */
+#define	BRCMF_C_DCMD_MAXLEN	8192
 
 /*******************************************************************************
  * IO codes that are interpreted by dongle firmware
@@ -572,12 +572,12 @@ struct brcmf_channel_info_le {
 	__le32 scan_channel;
 };
 
-/* Linux network driver ioctl encoding */
-struct brcmf_ioctl {
-	uint cmd;		/* common ioctl definition */
+/* Bus independent dongle command */
+struct brcmf_dcmd {
+	uint cmd;		/* common dongle cmd definition */
 	void *buf;		/* pointer to user buffer */
 	uint len;		/* length of user buffer */
-	u8 set;		/* get or set request (optional) */
+	u8 set;			/* get or set request (optional) */
 	uint used;		/* bytes read or written (optional) */
 	uint needed;		/* bytes needed (optional) */
 };
@@ -694,7 +694,7 @@ extern struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus,
 extern int brcmf_net_attach(struct brcmf_pub *drvr, int idx);
 extern int brcmf_netdev_wait_pend8021x(struct net_device *ndev);
 
-extern s32 brcmf_dev_ioctl(struct net_device *dev, u32 cmd, void *arg, u32 len);
+extern s32 brcmf_exec_dcmd(struct net_device *dev, u32 cmd, void *arg, u32 len);
 
 /* Indication from bus module regarding removal/absence of dongle */
 extern void brcmf_detach(struct brcmf_pub *drvr);
@@ -716,8 +716,8 @@ extern char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 extern void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp,
 			     bool success);
 
-/* Query ioctl */
-extern int brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx,
+/* Query dongle */
+extern int brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 				       uint cmd, void *buf, uint len);
 
 /* OS independent layer functions */
@@ -749,17 +749,7 @@ extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
 extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 					     int enable, int master_mode);
 
-/* per-driver magic numbers */
-#define BRCMF_IOCTL_MAGIC		0x00444944
-
-/* bump this number if you change the ioctl interface */
-#define BRCMF_IOCTL_VERSION	1
-#define	BRCMF_IOCTL_MAXLEN	8192	/* max length ioctl buffer required */
-
-/* common ioctl definitions */
-#define BRCMF_GET_VERSION				1
-#define BRCMF_GET_VAR				2
-#define BRCMF_SET_VAR				3
+#define	BRCMF_DCMD_MAXLEN	8192	/* max length cmd buffer required */
 
 /* message levels */
 #define BRCMF_ERROR_VAL	0x0001
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 4c171a3..ec0a057 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -15,8 +15,8 @@
  */
 
 /*******************************************************************************
- * Communicates with the dongle by using Broadcom specific ioctl codes.
- * For certain ioctl codes, the dongle interprets string data from the host.
+ * Communicates with the dongle by using dcmd codes.
+ * For certain dcmd codes, the dongle interprets string data from the host.
  ******************************************************************************/
 
 #include <linux/types.h>
@@ -32,8 +32,8 @@
 #include "dhd_bus.h"
 #include "dhd_dbg.h"
 
-struct brcmf_proto_cdc_ioctl {
-	__le32 cmd;	/* ioctl command value */
+struct brcmf_proto_cdc_dcmd {
+	__le32 cmd;	/* dongle command value */
 	__le32 len;	/* lower 16: output buflen;
 			 * upper 16: input buflen (excludes header) */
 	__le32 flags;	/* flag defns given below */
@@ -44,14 +44,14 @@ struct brcmf_proto_cdc_ioctl {
 #define CDC_MAX_MSG_SIZE	(ETH_FRAME_LEN+ETH_FCS_LEN)
 
 /* CDC flag definitions */
-#define CDCF_IOC_ERROR		0x01		/* 1=ioctl cmd failed */
-#define CDCF_IOC_SET		0x02		/* 0=get, 1=set cmd */
-#define CDCF_IOC_IF_MASK	0xF000		/* I/F index */
-#define CDCF_IOC_IF_SHIFT	12
-#define CDCF_IOC_ID_MASK	0xFFFF0000	/* id an ioctl pairing */
-#define CDCF_IOC_ID_SHIFT	16		/* ID Mask shift bits */
-#define CDC_IOC_ID(flags)	\
-	(((flags) & CDCF_IOC_ID_MASK) >> CDCF_IOC_ID_SHIFT)
+#define CDC_DCMD_ERROR		0x01	/* 1=cmd failed */
+#define CDC_DCMD_SET		0x02	/* 0=get, 1=set cmd */
+#define CDC_DCMD_IF_MASK	0xF000		/* I/F index */
+#define CDC_DCMD_IF_SHIFT	12
+#define CDC_DCMD_ID_MASK	0xFFFF0000	/* id an cmd pairing */
+#define CDC_DCMD_ID_SHIFT	16		/* ID Mask shift bits */
+#define CDC_DCMD_ID(flags)	\
+	(((flags) & CDC_DCMD_ID_MASK) >> CDC_DCMD_ID_SHIFT)
 
 /*
  * BDC header - Broadcom specific extension of CDC.
@@ -81,7 +81,7 @@ struct brcmf_proto_bdc_header {
 };
 
 
-#define RETRIES 2	/* # of retries to retrieve matching ioctl response */
+#define RETRIES 2 /* # of retries to retrieve matching dcmd response */
 #define BUS_HEADER_LEN	(16+BRCMF_SDALIGN) /* Must be atleast SDPCM_RESERVE
 					 * (amount of header tha might be added)
 					 * plus any space that might be needed
@@ -96,15 +96,15 @@ struct brcmf_proto {
 	u8 pending;
 	u32 lastcmd;
 	u8 bus_header[BUS_HEADER_LEN];
-	struct brcmf_proto_cdc_ioctl msg;
-	unsigned char buf[BRCMF_C_IOCTL_MAXLEN + ROUND_UP_MARGIN];
+	struct brcmf_proto_cdc_dcmd msg;
+	unsigned char buf[BRCMF_C_DCMD_MAXLEN + ROUND_UP_MARGIN];
 };
 
 static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
 {
 	struct brcmf_proto *prot = drvr->prot;
 	int len = le32_to_cpu(prot->msg.len) +
-			sizeof(struct brcmf_proto_cdc_ioctl);
+			sizeof(struct brcmf_proto_cdc_dcmd);
 
 	brcmf_dbg(TRACE, "Enter\n");
 
@@ -130,20 +130,20 @@ static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 	do {
 		ret = brcmf_sdbrcm_bus_rxctl(drvr->bus,
 				(unsigned char *)&prot->msg,
-				len + sizeof(struct brcmf_proto_cdc_ioctl));
+				len + sizeof(struct brcmf_proto_cdc_dcmd));
 		if (ret < 0)
 			break;
-	} while (CDC_IOC_ID(le32_to_cpu(prot->msg.flags)) != id);
+	} while (CDC_DCMD_ID(le32_to_cpu(prot->msg.flags)) != id);
 
 	return ret;
 }
 
 int
-brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
-			    void *buf, uint len)
+brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
+			       void *buf, uint len)
 {
 	struct brcmf_proto *prot = drvr->prot;
-	struct brcmf_proto_cdc_ioctl *msg = &prot->msg;
+	struct brcmf_proto_cdc_dcmd *msg = &prot->msg;
 	void *info;
 	int ret = 0, retries = 0;
 	u32 id, flags;
@@ -163,12 +163,13 @@ brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 		}
 	}
 
-	memset(msg, 0, sizeof(struct brcmf_proto_cdc_ioctl));
+	memset(msg, 0, sizeof(struct brcmf_proto_cdc_dcmd));
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
-	flags = (++prot->reqid << CDCF_IOC_ID_SHIFT);
-	flags = (flags & ~CDCF_IOC_IF_MASK) | (ifidx << CDCF_IOC_IF_SHIFT);
+	flags = (++prot->reqid << CDC_DCMD_ID_SHIFT);
+	flags = (flags & ~CDC_DCMD_IF_MASK) |
+		(ifidx << CDC_DCMD_IF_SHIFT);
 	msg->flags = cpu_to_le32(flags);
 
 	if (buf)
@@ -188,7 +189,7 @@ retry:
 		goto done;
 
 	flags = le32_to_cpu(msg->flags);
-	id = (flags & CDCF_IOC_ID_MASK) >> CDCF_IOC_ID_SHIFT;
+	id = (flags & CDC_DCMD_ID_MASK) >> CDC_DCMD_ID_SHIFT;
 
 	if ((id < prot->reqid) && (++retries < RETRIES))
 		goto retry;
@@ -210,7 +211,7 @@ retry:
 	}
 
 	/* Check the ERROR flag */
-	if (flags & CDCF_IOC_ERROR) {
+	if (flags & CDC_DCMD_ERROR) {
 		ret = le32_to_cpu(msg->status);
 		/* Cache error from dongle */
 		drvr->dongle_error = ret;
@@ -220,23 +221,24 @@ done:
 	return ret;
 }
 
-int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
-			      void *buf, uint len)
+int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
+				 void *buf, uint len)
 {
 	struct brcmf_proto *prot = drvr->prot;
-	struct brcmf_proto_cdc_ioctl *msg = &prot->msg;
+	struct brcmf_proto_cdc_dcmd *msg = &prot->msg;
 	int ret = 0;
 	u32 flags, id;
 
 	brcmf_dbg(TRACE, "Enter\n");
 	brcmf_dbg(CTL, "cmd %d len %d\n", cmd, len);
 
-	memset(msg, 0, sizeof(struct brcmf_proto_cdc_ioctl));
+	memset(msg, 0, sizeof(struct brcmf_proto_cdc_dcmd));
 
 	msg->cmd = cpu_to_le32(cmd);
 	msg->len = cpu_to_le32(len);
-	flags = (++prot->reqid << CDCF_IOC_ID_SHIFT) | CDCF_IOC_SET;
-	flags = (flags & ~CDCF_IOC_IF_MASK) | (ifidx << CDCF_IOC_IF_SHIFT);
+	flags = (++prot->reqid << CDC_DCMD_ID_SHIFT) | CDC_DCMD_SET;
+	flags = (flags & ~CDC_DCMD_IF_MASK) |
+		(ifidx << CDC_DCMD_IF_SHIFT);
 	msg->flags = cpu_to_le32(flags);
 
 	if (buf)
@@ -251,7 +253,7 @@ int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 		goto done;
 
 	flags = le32_to_cpu(msg->flags);
-	id = (flags & CDCF_IOC_ID_MASK) >> CDCF_IOC_ID_SHIFT;
+	id = (flags & CDC_DCMD_ID_MASK) >> CDC_DCMD_ID_SHIFT;
 
 	if (id != prot->reqid) {
 		brcmf_dbg(ERROR, "%s: unexpected request id %d (expected %d)\n",
@@ -261,7 +263,7 @@ int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	}
 
 	/* Check the ERROR flag */
-	if (flags & CDCF_IOC_ERROR) {
+	if (flags & CDC_DCMD_ERROR) {
 		ret = le32_to_cpu(msg->status);
 		/* Cache error from dongle */
 		drvr->dongle_error = ret;
@@ -272,7 +274,7 @@ done:
 }
 
 int
-brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
+brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx, struct brcmf_dcmd *dcmd,
 		  int len)
 {
 	struct brcmf_proto *prot = drvr->prot;
@@ -286,50 +288,50 @@ brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (len > BRCMF_C_IOCTL_MAXLEN)
+	if (len > BRCMF_C_DCMD_MAXLEN)
 		goto done;
 
 	if (prot->pending == true) {
 		brcmf_dbg(TRACE, "CDC packet is pending!!!! cmd=0x%x (%lu) lastcmd=0x%x (%lu)\n",
-			  ioc->cmd, (unsigned long)ioc->cmd, prot->lastcmd,
+			  dcmd->cmd, (unsigned long)dcmd->cmd, prot->lastcmd,
 			  (unsigned long)prot->lastcmd);
-		if ((ioc->cmd == BRCMF_C_SET_VAR) ||
-		    (ioc->cmd == BRCMF_C_GET_VAR))
-			brcmf_dbg(TRACE, "iovar cmd=%s\n", (char *)ioc->buf);
+		if (dcmd->cmd == BRCMF_C_SET_VAR ||
+		    dcmd->cmd == BRCMF_C_GET_VAR)
+			brcmf_dbg(TRACE, "iovar cmd=%s\n", (char *)dcmd->buf);
 
 		goto done;
 	}
 
 	prot->pending = true;
-	prot->lastcmd = ioc->cmd;
-	if (ioc->set)
-		ret = brcmf_proto_cdc_set_ioctl(drvr, ifidx, ioc->cmd,
-						ioc->buf, len);
+	prot->lastcmd = dcmd->cmd;
+	if (dcmd->set)
+		ret = brcmf_proto_cdc_set_dcmd(drvr, ifidx, dcmd->cmd,
+						   dcmd->buf, len);
 	else {
-		ret = brcmf_proto_cdc_query_ioctl(drvr, ifidx, ioc->cmd,
-						  ioc->buf, len);
+		ret = brcmf_proto_cdc_query_dcmd(drvr, ifidx, dcmd->cmd,
+						     dcmd->buf, len);
 		if (ret > 0)
-			ioc->used = ret - sizeof(struct brcmf_proto_cdc_ioctl);
+			dcmd->used = ret -
+					sizeof(struct brcmf_proto_cdc_dcmd);
 	}
 
-	/* Too many programs assume ioctl() returns 0 on success */
 	if (ret >= 0)
 		ret = 0;
 	else {
-		struct brcmf_proto_cdc_ioctl *msg = &prot->msg;
+		struct brcmf_proto_cdc_dcmd *msg = &prot->msg;
 		/* len == needed when set/query fails from dongle */
-		ioc->needed = le32_to_cpu(msg->len);
+		dcmd->needed = le32_to_cpu(msg->len);
 	}
 
-	/* Intercept the wme_dp ioctl here */
-	if (!ret && ioc->cmd == BRCMF_C_SET_VAR &&
-	    !strcmp(ioc->buf, "wme_dp")) {
+	/* Intercept the wme_dp dongle cmd here */
+	if (!ret && dcmd->cmd == BRCMF_C_SET_VAR &&
+	    !strcmp(dcmd->buf, "wme_dp")) {
 		int slen;
 		__le32 val = 0;
 
 		slen = strlen("wme_dp") + 1;
 		if (len >= (int)(slen + sizeof(int)))
-			memcpy(&val, (char *)ioc->buf + slen, sizeof(int));
+			memcpy(&val, (char *)dcmd->buf + slen, sizeof(int));
 		drvr->wme_dp = (u8) le32_to_cpu(val);
 	}
 
@@ -433,8 +435,8 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 
 	drvr->prot = cdc;
 	drvr->hdrlen += BDC_HEADER_LEN;
-	drvr->maxctl = BRCMF_C_IOCTL_MAXLEN +
-			sizeof(struct brcmf_proto_cdc_ioctl) + ROUND_UP_MARGIN;
+	drvr->maxctl = BRCMF_C_DCMD_MAXLEN +
+			sizeof(struct brcmf_proto_cdc_dcmd) + ROUND_UP_MARGIN;
 	return 0;
 
 fail:
@@ -472,7 +474,7 @@ int brcmf_proto_init(struct brcmf_pub *drvr)
 
 	/* Get the device MAC address */
 	strcpy(buf, "cur_etheraddr");
-	ret = brcmf_proto_cdc_query_ioctl(drvr, 0, BRCMF_C_GET_VAR,
+	ret = brcmf_proto_cdc_query_dcmd(drvr, 0, BRCMF_C_GET_VAR,
 					  buf, sizeof(buf));
 	if (ret < 0) {
 		brcmf_os_proto_unblock(drvr);
@@ -482,7 +484,7 @@ int brcmf_proto_init(struct brcmf_pub *drvr)
 
 	brcmf_os_proto_unblock(drvr);
 
-	ret = brcmf_c_preinit_ioctls(drvr);
+	ret = brcmf_c_preinit_dcmds(drvr);
 
 	/* Always assumes wl for now */
 	drvr->iswl = true;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 963d1a9..4075fd7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -596,7 +596,7 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 	memcpy((char *)pkt_filterp, &enable_parm, sizeof(enable_parm));
 
 	/* Enable/disable the specified filter. */
-	rc = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, buf, buf_len);
+	rc = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
 		brcmf_dbg(TRACE, "failed to add pktfilter %s, retcode = %d\n",
@@ -607,7 +607,7 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 	/* Contorl the master mode */
 	brcmu_mkiovar("pkt_filter_mode", (char *)&master_mode, 4, buf,
 		    sizeof(buf));
-	rc = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, buf,
+	rc = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, buf,
 				       sizeof(buf));
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
@@ -734,7 +734,7 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	       &pkt_filter,
 	       BRCMF_PKT_FILTER_FIXED_LEN + BRCMF_PKT_FILTER_PATTERN_FIXED_LEN);
 
-	rc = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, buf, buf_len);
+	rc = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
 
 	if (rc)
@@ -755,7 +755,7 @@ static void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
 	int retcode;
 
 	brcmu_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
-	retcode = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR,
+	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
@@ -772,7 +772,7 @@ static void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
 	int retcode;
 
 	brcmu_mkiovar("arpoe", (char *)&arp_enable, 4, iovbuf, sizeof(iovbuf));
-	retcode = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR,
+	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
@@ -783,7 +783,7 @@ static void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
 			  arp_enable);
 }
 
-int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
+int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 {
 	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];	/*  Room for
 				 "event_msgs" + '\0' + bitvec  */
@@ -801,7 +801,7 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 
 	/* Set Country code */
 	if (drvr->country_code[0] != 0) {
-		if (brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_COUNTRY,
+		if (brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_COUNTRY,
 					      drvr->country_code,
 					      sizeof(drvr->country_code)) < 0)
 			brcmf_dbg(ERROR, "country code setting failed\n");
@@ -811,7 +811,7 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 	memset(buf, 0, sizeof(buf));
 	ptr = buf;
 	brcmu_mkiovar("ver", NULL, 0, buf, sizeof(buf));
-	brcmf_proto_cdc_query_ioctl(drvr, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
+	brcmf_proto_cdc_query_dcmd(drvr, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
 	strsep(&ptr, "\n");
 	/* Print fw version info */
 	brcmf_dbg(ERROR, "Firmware version = %s\n", buf);
@@ -819,40 +819,40 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 	/* Match Host and Dongle rx alignment */
 	brcmu_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
 		    sizeof(iovbuf));
-	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
+	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* disable glom option per default */
 	brcmu_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
+	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* Setup timeout if Beacons are lost and roam is off to report
 		 link down */
 	brcmu_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
 		    sizeof(iovbuf));
-	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
+	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
 		 of romaing */
 	brcmu_mkiovar("roam_off", (char *)&roaming, 4,
 		      iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
+	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* Force STA UP */
-	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_UP, (char *)&up, sizeof(up));
+	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_UP, (char *)&up, sizeof(up));
 
 	/* Setup event_msgs */
 	brcmu_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
+	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
-	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
+	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 			 (char *)&scan_assoc_time, sizeof(scan_assoc_time));
-	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
+	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 			 (char *)&scan_unassoc_time, sizeof(scan_unassoc_time));
 
 	/* Set and enable ARP offload feature */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index a31b8a3..641cd9c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -141,7 +141,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	__le32 cnt_le;
 	__le32 allmulti_le;
 
-	struct brcmf_ioctl ioc;
+	struct brcmf_dcmd dcmd;
 	char *buf, *bufp;
 	uint buflen;
 	int ret;
@@ -177,13 +177,13 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 		cnt--;
 	}
 
-	memset(&ioc, 0, sizeof(ioc));
-	ioc.cmd = BRCMF_C_SET_VAR;
-	ioc.buf = buf;
-	ioc.len = buflen;
-	ioc.set = true;
+	memset(&dcmd, 0, sizeof(dcmd));
+	dcmd.cmd = BRCMF_C_SET_VAR;
+	dcmd.buf = buf;
+	dcmd.len = buflen;
+	dcmd.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, 0, &ioc, ioc.len);
+	ret = brcmf_proto_dcmd(&drvr_priv->pub, 0, &dcmd, dcmd.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set mcast_list failed, cnt %d\n",
 			  brcmf_ifname(&drvr_priv->pub, 0), cnt);
@@ -214,13 +214,13 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 		return;
 	}
 
-	memset(&ioc, 0, sizeof(ioc));
-	ioc.cmd = BRCMF_C_SET_VAR;
-	ioc.buf = buf;
-	ioc.len = buflen;
-	ioc.set = true;
+	memset(&dcmd, 0, sizeof(dcmd));
+	dcmd.cmd = BRCMF_C_SET_VAR;
+	dcmd.buf = buf;
+	dcmd.len = buflen;
+	dcmd.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, 0, &ioc, ioc.len);
+	ret = brcmf_proto_dcmd(&drvr_priv->pub, 0, &dcmd, dcmd.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set allmulti %d failed\n",
 			  brcmf_ifname(&drvr_priv->pub, 0),
@@ -235,13 +235,13 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 	allmulti = (ndev->flags & IFF_PROMISC) ? true : false;
 	allmulti_le = cpu_to_le32(allmulti);
 
-	memset(&ioc, 0, sizeof(ioc));
-	ioc.cmd = BRCMF_C_SET_PROMISC;
-	ioc.buf = &allmulti_le;
-	ioc.len = sizeof(allmulti_le);
-	ioc.set = true;
+	memset(&dcmd, 0, sizeof(dcmd));
+	dcmd.cmd = BRCMF_C_SET_PROMISC;
+	dcmd.buf = &allmulti_le;
+	dcmd.len = sizeof(allmulti_le);
+	dcmd.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, 0, &ioc, ioc.len);
+	ret = brcmf_proto_dcmd(&drvr_priv->pub, 0, &dcmd, dcmd.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: set promisc %d failed\n",
 			  brcmf_ifname(&drvr_priv->pub, 0),
@@ -253,7 +253,7 @@ static void
 _brcmf_set_mac_address(struct work_struct *work)
 {
 	char buf[32];
-	struct brcmf_ioctl ioc;
+	struct brcmf_dcmd dcmd;
 	int ret;
 
 	struct brcmf_info *drvr_priv = container_of(work, struct brcmf_info,
@@ -266,13 +266,13 @@ _brcmf_set_mac_address(struct work_struct *work)
 			  brcmf_ifname(&drvr_priv->pub, 0));
 		return;
 	}
-	memset(&ioc, 0, sizeof(ioc));
-	ioc.cmd = BRCMF_C_SET_VAR;
-	ioc.buf = buf;
-	ioc.len = 32;
-	ioc.set = true;
+	memset(&dcmd, 0, sizeof(dcmd));
+	dcmd.cmd = BRCMF_C_SET_VAR;
+	dcmd.buf = buf;
+	dcmd.len = 32;
+	dcmd.set = true;
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, 0, &ioc, ioc.len);
+	ret = brcmf_proto_dcmd(&drvr_priv->pub, 0, &dcmd, dcmd.len);
 	if (ret < 0)
 		brcmf_dbg(ERROR, "%s: set cur_etheraddr failed\n",
 			  brcmf_ifname(&drvr_priv->pub, 0));
@@ -628,19 +628,19 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *ndev)
 	 as a bitmap in toe_ol iovar */
 static int brcmf_toe_get(struct brcmf_info *drvr_priv, int ifidx, u32 *toe_ol)
 {
-	struct brcmf_ioctl ioc;
+	struct brcmf_dcmd dcmd;
 	char buf[32];
 	int ret;
 
-	memset(&ioc, 0, sizeof(ioc));
+	memset(&dcmd, 0, sizeof(dcmd));
 
-	ioc.cmd = BRCMF_C_GET_VAR;
-	ioc.buf = buf;
-	ioc.len = (uint) sizeof(buf);
-	ioc.set = false;
+	dcmd.cmd = BRCMF_C_GET_VAR;
+	dcmd.buf = buf;
+	dcmd.len = (uint) sizeof(buf);
+	dcmd.set = false;
 
 	strcpy(buf, "toe_ol");
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
+	ret = brcmf_proto_dcmd(&drvr_priv->pub, ifidx, &dcmd, dcmd.len);
 	if (ret < 0) {
 		/* Check for older dongle image that doesn't support toe_ol */
 		if (ret == -EIO) {
@@ -662,23 +662,23 @@ static int brcmf_toe_get(struct brcmf_info *drvr_priv, int ifidx, u32 *toe_ol)
 	 and set toe global enable iovar */
 static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 {
-	struct brcmf_ioctl ioc;
+	struct brcmf_dcmd dcmd;
 	char buf[32];
 	int toe, ret;
 
-	memset(&ioc, 0, sizeof(ioc));
+	memset(&dcmd, 0, sizeof(dcmd));
 
-	ioc.cmd = BRCMF_C_SET_VAR;
-	ioc.buf = buf;
-	ioc.len = (uint) sizeof(buf);
-	ioc.set = true;
+	dcmd.cmd = BRCMF_C_SET_VAR;
+	dcmd.buf = buf;
+	dcmd.len = (uint) sizeof(buf);
+	dcmd.set = true;
 
 	/* Set toe_ol as requested */
 
 	strcpy(buf, "toe_ol");
 	memcpy(&buf[sizeof("toe_ol")], &toe_ol, sizeof(u32));
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
+	ret = brcmf_proto_dcmd(&drvr_priv->pub, ifidx, &dcmd, dcmd.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: could not set toe_ol: ret=%d\n",
 			  brcmf_ifname(&drvr_priv->pub, ifidx), ret);
@@ -692,7 +692,7 @@ static int brcmf_toe_set(struct brcmf_info *drvr_priv, int ifidx, u32 toe_ol)
 	strcpy(buf, "toe");
 	memcpy(&buf[sizeof("toe")], &toe, sizeof(u32));
 
-	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.len);
+	ret = brcmf_proto_dcmd(&drvr_priv->pub, ifidx, &dcmd, dcmd.len);
 	if (ret < 0) {
 		brcmf_dbg(ERROR, "%s: could not set toe: ret=%d\n",
 			  brcmf_ifname(&drvr_priv->pub, ifidx), ret);
@@ -849,10 +849,10 @@ static int brcmf_netdev_ioctl_entry(struct net_device *ndev, struct ifreq *ifr,
 	return -EOPNOTSUPP;
 }
 
-/* called only from within this driver. Sends an ioctl to the dongle. */
-s32 brcmf_dev_ioctl(struct net_device *ndev, u32 cmd, void *arg, u32 len)
+/* called only from within this driver. Sends a command to the dongle. */
+s32 brcmf_exec_dcmd(struct net_device *ndev, u32 cmd, void *arg, u32 len)
 {
-	struct brcmf_ioctl ioc;
+	struct brcmf_dcmd dcmd;
 	s32 err = 0;
 	int buflen = 0;
 	bool is_set_key_cmd;
@@ -860,15 +860,15 @@ s32 brcmf_dev_ioctl(struct net_device *ndev, u32 cmd, void *arg, u32 len)
 					netdev_priv(ndev);
 	int ifidx;
 
-	memset(&ioc, 0, sizeof(ioc));
-	ioc.cmd = cmd;
-	ioc.buf = arg;
-	ioc.len = len;
+	memset(&dcmd, 0, sizeof(dcmd));
+	dcmd.cmd = cmd;
+	dcmd.buf = arg;
+	dcmd.len = len;
 
 	ifidx = brcmf_net2idx(drvr_priv, ndev);
 
-	if (ioc.buf != NULL)
-		buflen = min_t(uint, ioc.len, BRCMF_IOCTL_MAXLEN);
+	if (dcmd.buf != NULL)
+		buflen = min_t(uint, dcmd.len, BRCMF_DCMD_MAXLEN);
 
 	/* send to dongle (must be up, and wl) */
 	if ((drvr_priv->pub.busstate != BRCMF_BUS_DATA)) {
@@ -883,18 +883,18 @@ s32 brcmf_dev_ioctl(struct net_device *ndev, u32 cmd, void *arg, u32 len)
 	}
 
 	/*
-	 * Intercept BRCMF_C_SET_KEY IOCTL - serialize M4 send and
-	 * set key IOCTL to prevent M4 encryption.
+	 * Intercept BRCMF_C_SET_KEY CMD - serialize M4 send and
+	 * set key CMD to prevent M4 encryption.
 	 */
-	is_set_key_cmd = ((ioc.cmd == BRCMF_C_SET_KEY) ||
-			  ((ioc.cmd == BRCMF_C_SET_VAR) &&
-			   !(strncmp("wsec_key", ioc.buf, 9))) ||
-			  ((ioc.cmd == BRCMF_C_SET_VAR) &&
-			   !(strncmp("bsscfg:wsec_key", ioc.buf, 15))));
+	is_set_key_cmd = ((dcmd.cmd == BRCMF_C_SET_KEY) ||
+			  ((dcmd.cmd == BRCMF_C_SET_VAR) &&
+			   !(strncmp("wsec_key", dcmd.buf, 9))) ||
+			  ((dcmd.cmd == BRCMF_C_SET_VAR) &&
+			   !(strncmp("bsscfg:wsec_key", dcmd.buf, 15))));
 	if (is_set_key_cmd)
 		brcmf_netdev_wait_pend8021x(ndev);
 
-	err = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, buflen);
+	err = brcmf_proto_dcmd(&drvr_priv->pub, ifidx, &dcmd, buflen);
 
 done:
 	if (err > 0)
@@ -1107,7 +1107,7 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 
 	brcmu_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_query_ioctl(drvr, 0, BRCMF_C_GET_VAR, iovbuf,
+	brcmf_proto_cdc_query_dcmd(drvr, 0, BRCMF_C_GET_VAR, iovbuf,
 				    sizeof(iovbuf));
 	memcpy(drvr->eventmask, iovbuf, BRCMF_EVENTING_MASK_LEN);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index 24b0f99..4ee1ea8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -17,9 +17,6 @@
 #ifndef _BRCMF_PROTO_H_
 #define _BRCMF_PROTO_H_
 
-#define IOCTL_RESP_TIMEOUT  2000	/* In milli second */
-#define IOCTL_CHIP_ACTIVE_TIMEOUT  10	/* In milli second */
-
 /*
  * Exported from the brcmf protocol module (brcmf_cdc)
  */
@@ -48,16 +45,16 @@ extern void brcmf_proto_hdrpush(struct brcmf_pub *, int ifidx,
 extern int brcmf_proto_hdrpull(struct brcmf_pub *, int *ifidx,
 			       struct sk_buff *rxp);
 
-/* Use protocol to issue ioctl to dongle */
-extern int brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx,
-			     struct brcmf_ioctl *ioc, int len);
+/* Use protocol to issue command to dongle */
+extern int brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx,
+				struct brcmf_dcmd *dcmd, int len);
 
 /* Update local copy of dongle statistics */
 extern void brcmf_proto_dstats(struct brcmf_pub *drvr);
 
-extern int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr);
+extern int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr);
 
-extern int brcmf_proto_cdc_set_ioctl(struct brcmf_pub *drvr, int ifidx,
+extern int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx,
 				     uint cmd, void *buf, uint len);
 
 #endif				/* _BRCMF_PROTO_H_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index aa05cc0..5423280 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -35,6 +35,8 @@
 #include <soc.h>
 #include "sdio_host.h"
 
+#define DCMD_RESP_TIMEOUT  2000	/* In milli second */
+
 #ifdef BCMDBG
 
 #define BRCMF_TRAP_INFO_SIZE	80
@@ -641,7 +643,7 @@ struct brcmf_bus {
 
 	spinlock_t txqlock;
 	wait_queue_head_t ctrl_wait;
-	wait_queue_head_t ioctl_resp_wait;
+	wait_queue_head_t dcmd_resp_wait;
 
 	struct timer_list timer;
 	struct completion watchdog_wait;
@@ -1616,14 +1618,14 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 	return num;
 }
 
-static int brcmf_sdbrcm_ioctl_resp_wait(struct brcmf_bus *bus, uint *condition,
+static int brcmf_sdbrcm_dcmd_resp_wait(struct brcmf_bus *bus, uint *condition,
 					bool *pending)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	int timeout = msecs_to_jiffies(IOCTL_RESP_TIMEOUT);
+	int timeout = msecs_to_jiffies(DCMD_RESP_TIMEOUT);
 
 	/* Wait until control frame is available */
-	add_wait_queue(&bus->ioctl_resp_wait, &wait);
+	add_wait_queue(&bus->dcmd_resp_wait, &wait);
 	set_current_state(TASK_INTERRUPTIBLE);
 
 	while (!(*condition) && (!signal_pending(current) && timeout))
@@ -1633,15 +1635,15 @@ static int brcmf_sdbrcm_ioctl_resp_wait(struct brcmf_bus *bus, uint *condition,
 		*pending = true;
 
 	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&bus->ioctl_resp_wait, &wait);
+	remove_wait_queue(&bus->dcmd_resp_wait, &wait);
 
 	return timeout;
 }
 
-static int brcmf_sdbrcm_ioctl_resp_wake(struct brcmf_bus *bus)
+static int brcmf_sdbrcm_dcmd_resp_wake(struct brcmf_bus *bus)
 {
-	if (waitqueue_active(&bus->ioctl_resp_wait))
-		wake_up_interruptible(&bus->ioctl_resp_wait);
+	if (waitqueue_active(&bus->dcmd_resp_wait))
+		wake_up_interruptible(&bus->dcmd_resp_wait);
 
 	return 0;
 }
@@ -1732,7 +1734,7 @@ gotpkt:
 
 done:
 	/* Awake any waiters */
-	brcmf_sdbrcm_ioctl_resp_wake(bus);
+	brcmf_sdbrcm_dcmd_resp_wake(bus);
 }
 
 /* Pad read to blocksize for efficiency */
@@ -3106,7 +3108,7 @@ brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 	brcmf_dbg(TRACE, "Enter\n");
 
 	/* Wait until control frame is available */
-	timeleft = brcmf_sdbrcm_ioctl_resp_wait(bus, &bus->rxlen, &pending);
+	timeleft = brcmf_sdbrcm_dcmd_resp_wait(bus, &bus->rxlen, &pending);
 
 	down(&bus->sdsem);
 	rxlen = bus->rxlen;
@@ -3714,7 +3716,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus)
 
 	/* Clear rx control and wake any waiters */
 	bus->rxlen = 0;
-	brcmf_sdbrcm_ioctl_resp_wake(bus);
+	brcmf_sdbrcm_dcmd_resp_wake(bus);
 
 	/* Reset some F2 state stuff */
 	bus->rxskip = false;
@@ -4508,7 +4510,7 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 
 	spin_lock_init(&bus->txqlock);
 	init_waitqueue_head(&bus->ctrl_wait);
-	init_waitqueue_head(&bus->ioctl_resp_wait);
+	init_waitqueue_head(&bus->dcmd_resp_wait);
 
 	/* Set up the watchdog timer */
 	init_timer(&bus->timer);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index b956c90..42e7642 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -14,7 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-/* Toplevel file. Relies on dhd_linux.c to send ioctls to the dongle. */
+/* Toplevel file. Relies on dhd_linux.c to send commands to the dongle. */
 
 #include <linux/kernel.h>
 #include <linux/if_arp.h>
@@ -251,12 +251,12 @@ static const u32 __wl_cipher_suites[] = {
 
 /* function for reading/writing a single u32 from/to the dongle */
 static int
-brcmf_dev_ioctl_u32(struct net_device *ndev, u32 cmd, u32 *par)
+brcmf_exec_dcmd_u32(struct net_device *ndev, u32 cmd, u32 *par)
 {
 	int err;
 	__le32 par_le = cpu_to_le32(*par);
 
-	err = brcmf_dev_ioctl(ndev, cmd, &par_le, sizeof(__le32));
+	err = brcmf_exec_dcmd(ndev, cmd, &par_le, sizeof(__le32));
 	*par = le32_to_cpu(par_le);
 
 	return err;
@@ -283,7 +283,7 @@ static int send_key_to_dongle(struct net_device *ndev,
 	struct brcmf_wsec_key_le key_le;
 
 	convert_key_from_CPU(key, &key_le);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_KEY, &key_le, sizeof(key_le));
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_KEY, &key_le, sizeof(key_le));
 	if (err)
 		WL_ERR("WLC_SET_KEY error (%d)\n", err);
 	return err;
@@ -322,7 +322,7 @@ brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 		goto done;
 	}
 
-	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_INFRA, &infra);
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_INFRA, &infra);
 	if (err) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		err = -EAGAIN;
@@ -342,7 +342,7 @@ done:
 
 static s32 brcmf_dev_intvar_set(struct net_device *ndev, s8 *name, s32 val)
 {
-	s8 buf[BRCMF_C_IOCTL_SMLEN];
+	s8 buf[BRCMF_C_DCMD_SMLEN];
 	u32 len;
 	s32 err = 0;
 	__le32 val_le;
@@ -352,7 +352,7 @@ static s32 brcmf_dev_intvar_set(struct net_device *ndev, s8 *name, s32 val)
 			    sizeof(buf));
 	BUG_ON(!len);
 
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, buf, len);
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, buf, len);
 	if (err)
 		WL_ERR("error (%d)\n", err);
 
@@ -363,7 +363,7 @@ static s32
 brcmf_dev_intvar_get(struct net_device *ndev, s8 *name, s32 *retval)
 {
 	union {
-		s8 buf[BRCMF_C_IOCTL_SMLEN];
+		s8 buf[BRCMF_C_DCMD_SMLEN];
 		__le32 val;
 	} var;
 	u32 len;
@@ -374,7 +374,7 @@ brcmf_dev_intvar_get(struct net_device *ndev, s8 *name, s32 *retval)
 	    brcmu_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
 			sizeof(var.buf));
 	BUG_ON(!len);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_VAR, &var, len);
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, &var, len);
 	if (err)
 		WL_ERR("error (%d)\n", err);
 
@@ -422,7 +422,7 @@ brcmf_dev_iovar_setbuf(struct net_device *ndev, s8 * iovar, void *param,
 	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
-	return brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, bufptr, iolen);
+	return brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, bufptr, iolen);
 }
 
 static s32
@@ -434,7 +434,7 @@ brcmf_dev_iovar_getbuf(struct net_device *ndev, s8 * iovar, void *param,
 	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
-	return brcmf_dev_ioctl(ndev, BRCMF_C_GET_VAR, bufptr, buflen);
+	return brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, bufptr, buflen);
 }
 
 static s32
@@ -451,7 +451,7 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	params = kzalloc(params_size, GFP_KERNEL);
 	if (!params)
 		return -ENOMEM;
-	BUG_ON(params_size >= BRCMF_C_IOCTL_SMLEN);
+	BUG_ON(params_size >= BRCMF_C_DCMD_SMLEN);
 
 	wl_iscan_prep(&params->params_le, ssid);
 
@@ -460,7 +460,7 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	params->scan_duration = cpu_to_le16(0);
 
 	err = brcmf_dev_iovar_setbuf(iscan->ndev, "iscan", params, params_size,
-				     iscan->ioctl_buf, BRCMF_C_IOCTL_SMLEN);
+				     iscan->dcmd_buf, BRCMF_C_DCMD_SMLEN);
 	if (err) {
 		if (err == -EBUSY)
 			WL_INFO("system busy : iscan canceled\n");
@@ -486,7 +486,7 @@ static s32 brcmf_do_iscan(struct brcmf_cfg80211_priv *cfg_priv)
 	iscan->state = WL_ISCAN_STATE_SCANING;
 
 	passive_scan = cfg_priv->active_scan ? 0 : 1;
-	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCMF_C_SET_PASSIVE_SCAN,
+	err = brcmf_exec_dcmd(cfg_to_ndev(cfg_priv), BRCMF_C_SET_PASSIVE_SCAN,
 			&passive_scan, sizeof(passive_scan));
 	if (err) {
 		WL_ERR("error (%d)\n", err);
@@ -570,14 +570,14 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		}
 
 		passive_scan = cfg_priv->active_scan ? 0 : 1;
-		err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_PASSIVE_SCAN,
+		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_PASSIVE_SCAN,
 				&passive_scan, sizeof(passive_scan));
 		if (err) {
 			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
 		brcmf_set_mpc(ndev, 0);
-		err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN, &sr->ssid_le,
+		err = brcmf_exec_dcmd(ndev, BRCMF_C_SCAN, &sr->ssid_le,
 				      sizeof(sr->ssid_le));
 		if (err) {
 			if (err == -EBUSY)
@@ -645,7 +645,7 @@ static s32 brcmf_set_retry(struct net_device *ndev, u32 retry, bool l)
 	s32 err = 0;
 	u32 cmd = (l ? BRCM_SET_LRL : BRCM_SET_SRL);
 
-	err = brcmf_dev_ioctl_u32(ndev, cmd, &retry);
+	err = brcmf_exec_dcmd_u32(ndev, cmd, &retry);
 	if (err) {
 		WL_ERR("cmd (%d) , error (%d)\n", cmd, err);
 		return err;
@@ -794,7 +794,7 @@ static void brcmf_link_down(struct brcmf_cfg80211_priv *cfg_priv)
 	if (cfg_priv->link_up) {
 		ndev = cfg_to_ndev(cfg_priv);
 		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
-		err = brcmf_dev_ioctl(ndev, BRCMF_C_DISASSOC, NULL, 0);
+		err = brcmf_exec_dcmd(ndev, BRCMF_C_DISASSOC, NULL, 0);
 		if (err)
 			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
 		cfg_priv->link_up = false;
@@ -880,7 +880,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	else
 		bcnprd = 100;
 
-	err = brcmf_dev_ioctl_u32(ndev, BRCM_SET_BCNPRD, &bcnprd);
+	err = brcmf_exec_dcmd_u32(ndev, BRCM_SET_BCNPRD, &bcnprd);
 	if (err) {
 		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
@@ -924,7 +924,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 		/* set channel for starter */
 		target_channel = cfg_priv->channel;
-		err = brcmf_dev_ioctl_u32(ndev, BRCM_SET_CHANNEL,
+		err = brcmf_exec_dcmd_u32(ndev, BRCM_SET_CHANNEL,
 					  &target_channel);
 		if (err) {
 			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
@@ -936,7 +936,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	cfg_priv->ibss_starter = false;
 
 
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_SSID,
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SSID,
 			   &join_params, join_params_size);
 	if (err) {
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
@@ -1296,7 +1296,7 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *ndev,
 
 	brcmf_ch_to_chanspec(cfg_priv->channel,
 			     &join_params, &join_params_size);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_SSID,
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SSID,
 			   &join_params, join_params_size);
 	if (err)
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
@@ -1324,7 +1324,7 @@ brcmf_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *ndev,
 
 	memcpy(&scbval.ea, brcmf_read_prof(cfg_priv, WL_PROF_BSSID), ETH_ALEN);
 	scbval.val = cpu_to_le32(reason_code);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_DISASSOC, &scbval,
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_DISASSOC, &scbval,
 			      sizeof(struct brcmf_scb_val_le));
 	if (err)
 		WL_ERR("error (%d)\n", err);
@@ -1370,7 +1370,7 @@ brcmf_cfg80211_set_tx_power(struct wiphy *wiphy,
 	}
 	/* Make sure radio is off or on as far as software is concerned */
 	disable = WL_RADIO_SW_DISABLE << 16;
-	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_RADIO, &disable);
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_RADIO, &disable);
 	if (err)
 		WL_ERR("WLC_SET_RADIO error (%d)\n", err);
 
@@ -1428,7 +1428,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (!check_sys_up(wiphy))
 		return -EIO;
 
-	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_GET_WSEC, &wsec);
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_GET_WSEC, &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		goto done;
@@ -1437,7 +1437,7 @@ brcmf_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *ndev,
 	if (wsec & WEP_ENABLED) {
 		/* Just select a new current key */
 		index = key_idx;
-		err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_KEY_PRIMARY,
+		err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_KEY_PRIMARY,
 					  &index);
 		if (err)
 			WL_ERR("error (%d)\n", err);
@@ -1523,7 +1523,7 @@ brcmf_add_keyext(struct wiphy *wiphy, struct net_device *ndev,
 		convert_key_from_CPU(&key, &key_le);
 
 		brcmf_netdev_wait_pend8021x(ndev);
-		err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_KEY, &key_le,
+		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_KEY, &key_le,
 				      sizeof(key_le));
 		if (err) {
 			WL_ERR("WLC_SET_KEY error (%d)\n", err);
@@ -1615,7 +1615,7 @@ brcmf_cfg80211_add_key(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	val = 1;		/* assume shared key. otherwise 0 */
-	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_AUTH, &val);
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_AUTH, &val);
 	if (err)
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 done:
@@ -1676,7 +1676,7 @@ brcmf_cfg80211_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	val = 0;		/* assume open key. otherwise 1 */
-	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_AUTH, &val);
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_AUTH, &val);
 	if (err) {
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1705,7 +1705,7 @@ brcmf_cfg80211_get_key(struct wiphy *wiphy, struct net_device *ndev,
 
 	memset(&params, 0, sizeof(params));
 
-	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_GET_WSEC, &wsec);
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_GET_WSEC, &wsec);
 	if (err) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1778,7 +1778,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	/* Report the current tx rate */
-	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_GET_RATE, &rate);
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_GET_RATE, &rate);
 	if (err) {
 		WL_ERR("Could not get rate (%d)\n", err);
 	} else {
@@ -1789,7 +1789,7 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *ndev,
 
 	if (test_bit(WL_STATUS_CONNECTED, &cfg_priv->status)) {
 		scb_val.val = cpu_to_le32(0);
-		err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_RSSI, &scb_val,
+		err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_RSSI, &scb_val,
 				      sizeof(struct brcmf_scb_val_le));
 		if (err)
 			WL_ERR("Could not get rssi (%d)\n", err);
@@ -1833,7 +1833,7 @@ brcmf_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *ndev,
 	pm = enabled ? PM_FAST : PM_OFF;
 	WL_INFO("power save %s\n", (pm ? "enabled" : "disabled"));
 
-	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_PM, &pm);
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_PM, &pm);
 	if (err) {
 		if (err == -ENODEV)
 			WL_ERR("net_device is not ready yet\n");
@@ -1864,7 +1864,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 
 	/* addr param is always NULL. ignore it */
 	/* Get current rateset */
-	err = brcmf_dev_ioctl(ndev, BRCM_GET_CURR_RATESET, &rateset_le,
+	err = brcmf_exec_dcmd(ndev, BRCM_GET_CURR_RATESET, &rateset_le,
 			      sizeof(rateset_le));
 	if (err) {
 		WL_ERR("could not get current rateset (%d)\n", err);
@@ -2016,7 +2016,7 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
 
 	*(__le32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
 
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
 	if (err) {
 		WL_ERR("WLC_GET_BSS_INFO failed: %d\n", err);
 		goto CleanUp;
@@ -2084,7 +2084,7 @@ static s32 brcmf_update_bss_info(struct brcmf_cfg80211_priv *cfg_priv)
 	ssid = (struct brcmf_ssid *)brcmf_read_prof(cfg_priv, WL_PROF_SSID);
 
 	*(__le32 *)cfg_priv->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
-	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCMF_C_GET_BSS_INFO,
+	err = brcmf_exec_dcmd(cfg_to_ndev(cfg_priv), BRCMF_C_GET_BSS_INFO,
 			cfg_priv->extra_buf, WL_EXTRA_BUF_MAX);
 	if (err) {
 		WL_ERR("Could not get bss info %d\n", err);
@@ -2444,11 +2444,11 @@ brcmf_dev_bufvar_set(struct net_device *ndev, s8 *name, s8 *buf, s32 len)
 	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	u32 buflen;
 
-	buflen = brcmu_mkiovar(name, buf, len, cfg_priv->ioctl_buf,
-			       WL_IOCTL_LEN_MAX);
+	buflen = brcmu_mkiovar(name, buf, len, cfg_priv->dcmd_buf,
+			       WL_DCMD_LEN_MAX);
 	BUG_ON(!buflen);
 
-	return brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, cfg_priv->ioctl_buf,
+	return brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, cfg_priv->dcmd_buf,
 			       buflen);
 }
 
@@ -2460,16 +2460,16 @@ brcmf_dev_bufvar_get(struct net_device *ndev, s8 *name, s8 *buf,
 	u32 len;
 	s32 err = 0;
 
-	len = brcmu_mkiovar(name, NULL, 0, cfg_priv->ioctl_buf,
-			    WL_IOCTL_LEN_MAX);
+	len = brcmu_mkiovar(name, NULL, 0, cfg_priv->dcmd_buf,
+			    WL_DCMD_LEN_MAX);
 	BUG_ON(!len);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_VAR, cfg_priv->ioctl_buf,
-			      WL_IOCTL_LEN_MAX);
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, cfg_priv->dcmd_buf,
+			      WL_DCMD_LEN_MAX);
 	if (err) {
 		WL_ERR("error (%d)\n", err);
 		return err;
 	}
-	memcpy(buf, cfg_priv->ioctl_buf, buf_len);
+	memcpy(buf, cfg_priv->dcmd_buf, buf_len);
 
 	return err;
 }
@@ -2846,7 +2846,7 @@ brcmf_bss_roaming_done(struct brcmf_cfg80211_priv *cfg_priv,
 	brcmf_update_prof(cfg_priv, NULL, &e->addr, WL_PROF_BSSID);
 	brcmf_update_bss_info(cfg_priv);
 
-	brcmf_dev_ioctl(ndev, BRCMF_C_GET_CHANNEL, &channel_le,
+	brcmf_exec_dcmd(ndev, BRCMF_C_GET_CHANNEL, &channel_le,
 			sizeof(channel_le));
 
 	target_channel = le32_to_cpu(channel_le.target_channel);
@@ -3018,7 +3018,7 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 		goto scan_done_out;
 	}
 
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_CHANNEL, &channel_inform_le,
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_CHANNEL, &channel_inform_le,
 			      sizeof(channel_inform_le));
 	if (err) {
 		WL_ERR("scan busy (%d)\n", err);
@@ -3033,7 +3033,7 @@ brcmf_notify_scan_status(struct brcmf_cfg80211_priv *cfg_priv,
 
 	memset(cfg_priv->scan_results, 0, len);
 	bss_list_le->buflen = cpu_to_le32(len);
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN_RESULTS,
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SCAN_RESULTS,
 			      cfg_priv->scan_results, len);
 	if (err) {
 		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
@@ -3096,8 +3096,8 @@ static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 	cfg_priv->profile = NULL;
 	kfree(cfg_priv->scan_req_int);
 	cfg_priv->scan_req_int = NULL;
-	kfree(cfg_priv->ioctl_buf);
-	cfg_priv->ioctl_buf = NULL;
+	kfree(cfg_priv->dcmd_buf);
+	cfg_priv->dcmd_buf = NULL;
 	kfree(cfg_priv->extra_buf);
 	cfg_priv->extra_buf = NULL;
 	kfree(cfg_priv->iscan);
@@ -3124,8 +3124,8 @@ static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 					 GFP_KERNEL);
 	if (!cfg_priv->scan_req_int)
 		goto init_priv_mem_out;
-	cfg_priv->ioctl_buf = kzalloc(WL_IOCTL_LEN_MAX, GFP_KERNEL);
-	if (!cfg_priv->ioctl_buf)
+	cfg_priv->dcmd_buf = kzalloc(WL_DCMD_LEN_MAX, GFP_KERNEL);
+	if (!cfg_priv->dcmd_buf)
 		goto init_priv_mem_out;
 	cfg_priv->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
 	if (!cfg_priv->extra_buf)
@@ -3377,7 +3377,7 @@ static s32 brcmf_dongle_mode(struct net_device *ndev, s32 iftype)
 		WL_ERR("invalid type (%d)\n", iftype);
 		return err;
 	}
-	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_INFRA, &infra);
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_INFRA, &infra);
 	if (err) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		return err;
@@ -3398,7 +3398,7 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 	/* Setup event_msgs */
 	brcmu_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		WL_ERR("Get event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
@@ -3427,7 +3427,7 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 
 	brcmu_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		WL_ERR("Set event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
@@ -3453,7 +3453,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	if (roamvar) {
 		brcmu_mkiovar("bcn_timeout", (char *)&bcn_timeout,
 			sizeof(bcn_timeout), iovbuf, sizeof(iovbuf));
-		err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR,
+		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 		if (err) {
 			WL_ERR("bcn_timeout error (%d)\n", err);
@@ -3468,7 +3468,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	WL_INFO("Internal Roaming = %s\n", roamvar ? "Off" : "On");
 	brcmu_mkiovar("roam_off", (char *)&roamvar,
 				sizeof(roamvar), iovbuf, sizeof(iovbuf));
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		WL_ERR("roam_off error (%d)\n", err);
 		goto dongle_rom_out;
@@ -3476,7 +3476,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 
 	roamtrigger[0] = WL_ROAM_TRIGGER_LEVEL;
 	roamtrigger[1] = BRCM_BAND_ALL;
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_ROAM_TRIGGER,
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_ROAM_TRIGGER,
 			(void *)roamtrigger, sizeof(roamtrigger));
 	if (err) {
 		WL_ERR("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
@@ -3485,7 +3485,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 
 	roam_delta[0] = WL_ROAM_DELTA;
 	roam_delta[1] = BRCM_BAND_ALL;
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_ROAM_DELTA,
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_ROAM_DELTA,
 				(void *)roam_delta, sizeof(roam_delta));
 	if (err) {
 		WL_ERR("WLC_SET_ROAM_DELTA error (%d)\n", err);
@@ -3502,7 +3502,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 {
 	s32 err = 0;
 
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_SCAN_CHANNEL_TIME,
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 			   &scan_assoc_time, sizeof(scan_assoc_time));
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -3511,7 +3511,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 			WL_ERR("Scan assoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_SCAN_UNASSOC_TIME,
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 			   &scan_unassoc_time, sizeof(scan_unassoc_time));
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -3521,7 +3521,7 @@ brcmf_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		goto dongle_scantime_out;
 	}
 
-	err = brcmf_dev_ioctl(ndev, BRCMF_C_SET_SCAN_PASSIVE_TIME,
+	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_SCAN_PASSIVE_TIME,
 			   &scan_passive_time, sizeof(scan_passive_time));
 	if (err) {
 		if (err == -EOPNOTSUPP)
@@ -3542,7 +3542,7 @@ static s32 wl_update_wiphybands(struct brcmf_cfg80211_priv *cfg_priv)
 	s8 phy;
 	s32 err = 0;
 
-	err = brcmf_dev_ioctl(cfg_to_ndev(cfg_priv), BRCM_GET_PHYLIST,
+	err = brcmf_exec_dcmd(cfg_to_ndev(cfg_priv), BRCM_GET_PHYLIST,
 			      &phy_list, sizeof(phy_list));
 	if (err) {
 		WL_ERR("error (%d)\n", err);
@@ -3588,7 +3588,7 @@ static s32 brcmf_config_dongle(struct brcmf_cfg80211_priv *cfg_priv,
 		goto default_conf_out;
 
 	power_mode = cfg_priv->pwr_save ? PM_FAST : PM_OFF;
-	err = brcmf_dev_ioctl_u32(ndev, BRCMF_C_SET_PM,	&power_mode);
+	err = brcmf_exec_dcmd_u32(ndev, BRCMF_C_SET_PM, &power_mode);
 	if (err)
 		goto default_conf_out;
 	WL_INFO("power save set to %s\n",
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index afc60d9..21c8f8e 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -103,10 +103,10 @@ do {								\
 				 * report it to cfg80211 through "connect"
 				 * event
 				 */
-#define WL_IOCTL_LEN_MAX	1024
+#define WL_DCMD_LEN_MAX	1024
 #define WL_EXTRA_BUF_MAX	2048
 #define WL_ISCAN_BUF_MAX	2048	/*
-				 * the buf length can be BRCMF_C_IOCTL_MAXLEN
+				 * the buf length can be BRCMF_C_DCMD_MAXLEN
 				 * to reduce iteration
 				 */
 #define WL_ISCAN_TIMER_INTERVAL_MS	3000
@@ -251,7 +251,7 @@ struct brcmf_cfg80211_iscan_ctrl {
 	struct work_struct work;
 	struct brcmf_cfg80211_iscan_eloop el;
 	void *data;
-	s8 ioctl_buf[BRCMF_C_IOCTL_SMLEN];
+	s8 dcmd_buf[BRCMF_C_DCMD_SMLEN];
 	s8 scan_buf[WL_ISCAN_BUF_MAX];
 };
 
@@ -312,8 +312,8 @@ struct brcmf_cfg80211_priv {
 	bool dongle_up;		/* indicate whether dongle up or not */
 	bool roam_on;		/* on/off switch for dongle self-roaming */
 	bool scan_tried;	/* indicates if first scan attempted */
-	u8 *ioctl_buf;	/* ioctl buffer */
-	u8 *extra_buf;	/* maily to grab assoc information */
+	u8 *dcmd_buf;		/* dcmd buffer */
+	u8 *extra_buf;		/* maily to grab assoc information */
 	struct dentry *debugfsdir;
 	u8 ci[0] __aligned(NETDEV_ALIGN);
 };
-- 
1.7.1


