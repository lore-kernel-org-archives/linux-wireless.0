Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2431 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab1IWAIO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:14 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 01/19] staging: brcm80211: sparse endianness warnings
 on dongle events
Date: Thu, 22 Sep 2011 17:07:38 -0700
Message-ID: <1316736476-23725-2-git-send-email-frankyl@broadcom.com> (sfid-20110923_020836_907381_1C7EE917)
In-Reply-To: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
References: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Structures received from dongle have been annotated.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |   14 ++++++------
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c    |    3 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   21 ++++++++++---------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |   24 +++++++++++-----------
 4 files changed, 32 insertions(+), 30 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index da53dd0..c368f71 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -134,13 +134,13 @@
 #define BRCMF_EVENT_MSG_GROUP		0x04
 
 struct brcmf_event_msg {
-	u16 version;
-	u16 flags;
-	u32 event_type;
-	u32 status;
-	u32 reason;
-	u32 auth_type;
-	u32 datalen;
+	__be16 version;
+	__be16 flags;
+	__be32 event_type;
+	__be32 status;
+	__be32 reason;
+	__be32 auth_type;
+	__be32 datalen;
 	u8 addr[ETH_ALEN];
 	char ifname[IFNAMSIZ];
 } __packed;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 0d8389e..6f65683 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -322,7 +322,8 @@ brcmf_proto_ioctl(struct brcmf_pub *drvr, int ifidx, struct brcmf_ioctl *ioc,
 	/* Intercept the wme_dp ioctl here */
 	if (!ret && ioc->cmd == BRCMF_C_SET_VAR &&
 	    !strcmp(ioc->buf, "wme_dp")) {
-		int slen, val = 0;
+		int slen;
+		__le32 val = 0;
 
 		slen = strlen("wme_dp") + 1;
 		if (len >= (int)(slen + sizeof(int)))
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 02c022a..c9bf92a 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -53,15 +53,15 @@ static const char brcmf_version[] =
 struct msgtrace_hdr {
 	u8 version;
 	u8 spare;
-	u16 len;		/* Len of the trace */
-	u32 seqnum;		/* Sequence number of message. Useful
+	__be16 len;		/* Len of the trace */
+	__be32 seqnum;		/* Sequence number of message. Useful
 				 * if the messsage has been lost
 				 * because of DMA error or a bus reset
 				 * (ex: SDIO Func2)
 				 */
-	u32 discarded_bytes;	/* Number of discarded bytes because of
+	__be32 discarded_bytes;	/* Number of discarded bytes because of
 				 trace overflow  */
-	u32 discarded_printf;	/* Number of discarded printf
+	__be32 discarded_printf;	/* Number of discarded printf
 				 because of trace overflow */
 } __packed;
 
@@ -401,7 +401,7 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 
 	case BRCMF_E_RSSI:
 		brcmf_dbg(EVENT, "MACEVENT: %s %d\n",
-			  event_name, be32_to_cpu(*((int *)event_data)));
+			  event_name, be32_to_cpu(*((__be32 *)event_data)));
 		break;
 
 	default:
@@ -498,14 +498,15 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 
 		/* put it back to BRCMF_E_NDIS_LINK */
 		if (type == BRCMF_E_NDIS_LINK) {
-			u32 temp;
+			u32 temp1;
+			__be32 temp2;
 
-			temp = get_unaligned_be32(&event->event_type);
+			temp1 = get_unaligned_be32(&event->event_type);
 			brcmf_dbg(TRACE, "Converted to WLC_E_LINK type %d\n",
-				  temp);
+				  temp1);
 
-			temp = be32_to_cpu(BRCMF_E_NDIS_LINK);
-			memcpy((void *)(&pvt_data->msg.event_type), &temp,
+			temp2 = cpu_to_be32(BRCMF_E_NDIS_LINK);
+			memcpy((void *)(&pvt_data->msg.event_type), &temp2,
 			       sizeof(pvt_data->msg.event_type));
 		}
 		break;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 720f567..fb9b351 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -63,10 +63,10 @@ struct brcmf_trap {
 
 #define CBUF_LEN	(128)
 
-struct rte_log {
-	u32 buf;		/* Can't be pointer on (64-bit) hosts */
-	uint buf_size;
-	uint idx;
+struct rte_log_le {
+	__le32 buf;		/* Can't be pointer on (64-bit) hosts */
+	__le32 buf_size;
+	__le32 idx;
 	char *_buf_compat;	/* Redundant pointer for backward compat. */
 };
 
@@ -89,7 +89,7 @@ struct rte_console {
 	 * Output will be lost if the output wraps around faster than the host
 	 * polls.
 	 */
-	struct rte_log log;
+	struct rte_log_le log_le;
 
 	/* Console input line buffer
 	 * Characters are read one at a time into cbuf
@@ -512,7 +512,7 @@ struct sdpcmd_regs {
 struct brcmf_console {
 	uint count;		/* Poll interval msec counter */
 	uint log_addr;		/* Log struct address (fixed) */
-	struct rte_log log;	/* Log struct (host copy) */
+	struct rte_log_le log_le;	/* Log struct (host copy) */
 	uint bufsize;		/* Size of log buffer */
 	u8 *buf;		/* Log buffer (host copy) */
 	uint last;		/* Last buffer read index */
@@ -3153,21 +3153,21 @@ static int brcmf_sdbrcm_readconsole(struct brcmf_bus *bus)
 		return 0;
 
 	/* Read console log struct */
-	addr = bus->console_addr + offsetof(struct rte_console, log);
-	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *)&c->log,
-				sizeof(c->log));
+	addr = bus->console_addr + offsetof(struct rte_console, log_le);
+	rv = brcmf_sdbrcm_membytes(bus, false, addr, (u8 *)&c->log_le,
+				   sizeof(c->log_le));
 	if (rv < 0)
 		return rv;
 
 	/* Allocate console buffer (one time only) */
 	if (c->buf == NULL) {
-		c->bufsize = le32_to_cpu(c->log.buf_size);
+		c->bufsize = le32_to_cpu(c->log_le.buf_size);
 		c->buf = kmalloc(c->bufsize, GFP_ATOMIC);
 		if (c->buf == NULL)
 			return -ENOMEM;
 	}
 
-	idx = le32_to_cpu(c->log.idx);
+	idx = le32_to_cpu(c->log_le.idx);
 
 	/* Protect against corrupt value */
 	if (idx > c->bufsize)
@@ -3179,7 +3179,7 @@ static int brcmf_sdbrcm_readconsole(struct brcmf_bus *bus)
 		return 0;
 
 	/* Read the console buffer */
-	addr = le32_to_cpu(c->log.buf);
+	addr = le32_to_cpu(c->log_le.buf);
 	rv = brcmf_sdbrcm_membytes(bus, false, addr, c->buf, c->bufsize);
 	if (rv < 0)
 		return rv;
-- 
1.7.1


