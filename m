Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2564 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752790Ab3ABOXO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:23:14 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Hante Meuleman" <meuleman@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/18] brcmfmac: Use dedicated trace level for CDC.
Date: Wed, 2 Jan 2013 15:22:44 +0100
Message-ID: <1357136572-18273-12-git-send-email-arend@broadcom.com> (sfid-20130102_152323_032617_1C8C3CE6)
In-Reply-To: <1357136572-18273-1-git-send-email-arend@broadcom.com>
References: <1357136572-18273-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

CDC debug is partly done with TRACE and partly with CTL, however
CDC hardly ever needs debugging. Use dedicated level CDC and
replace TRACE and CTL in dhd_cdc with that.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   16 +++++-----
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h  |   31 ++++++++++----------
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    2 +-
 3 files changed, 24 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index aa37f3e..db3bc2e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -105,7 +105,7 @@ static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
 	int len = le32_to_cpu(prot->msg.len) +
 			sizeof(struct brcmf_proto_cdc_dcmd);
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(CDC, "Enter\n");
 
 	/* NOTE : cdc->msg.len holds the desired length of the buffer to be
 	 *        returned. Only up to CDC_MAX_MSG_SIZE of this buffer area
@@ -123,7 +123,7 @@ static int brcmf_proto_cdc_cmplt(struct brcmf_pub *drvr, u32 id, u32 len)
 	int ret;
 	struct brcmf_proto *prot = drvr->prot;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(CDC, "Enter\n");
 	len += sizeof(struct brcmf_proto_cdc_dcmd);
 	do {
 		ret = brcmf_bus_rxctl(drvr->bus_if, (unsigned char *)&prot->msg,
@@ -145,8 +145,7 @@ brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	int ret = 0, retries = 0;
 	u32 id, flags;
 
-	brcmf_dbg(TRACE, "Enter\n");
-	brcmf_dbg(CTL, "cmd %d len %d\n", cmd, len);
+	brcmf_dbg(CDC, "Enter, cmd %d len %d\n", cmd, len);
 
 	/* Respond "bcmerror" and "bcmerrorstr" with local cache */
 	if (cmd == BRCMF_C_GET_VAR && buf) {
@@ -226,8 +225,7 @@ int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 	int ret = 0;
 	u32 flags, id;
 
-	brcmf_dbg(TRACE, "Enter\n");
-	brcmf_dbg(CTL, "cmd %d len %d\n", cmd, len);
+	brcmf_dbg(CDC, "Enter, cmd %d len %d\n", cmd, len);
 
 	memset(msg, 0, sizeof(struct brcmf_proto_cdc_dcmd));
 
@@ -285,7 +283,7 @@ void brcmf_proto_hdrpush(struct brcmf_pub *drvr, int ifidx,
 {
 	struct brcmf_proto_bdc_header *h;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(CDC, "Enter\n");
 
 	/* Push BDC header used to convey priority for buses that don't */
 
@@ -308,7 +306,7 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, u8 *ifidx,
 {
 	struct brcmf_proto_bdc_header *h;
 
-	brcmf_dbg(TRACE, "Enter\n");
+	brcmf_dbg(CDC, "Enter\n");
 
 	/* Pop BDC header used to convey priority for buses that don't */
 
@@ -334,7 +332,7 @@ int brcmf_proto_hdrpull(struct brcmf_pub *drvr, u8 *ifidx,
 	}
 
 	if (h->flags & BDC_FLAG_SUM_GOOD) {
-		brcmf_dbg(INFO, "%s: BDC packet received with good rx-csum, flags 0x%x\n",
+		brcmf_dbg(CDC, "%s: BDC rcv, good checksum, flags 0x%x\n",
 			  brcmf_ifname(drvr, *ifidx), h->flags);
 		pkt_set_sum_good(pktbuf, true);
 	}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
index 968dcb0..7433deb 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.h
@@ -18,21 +18,22 @@
 #define _BRCMF_DBG_H_
 
 /* message levels */
-#define BRCMF_TRACE_VAL	0x0002
-#define BRCMF_INFO_VAL	0x0004
-#define BRCMF_DATA_VAL	0x0008
-#define BRCMF_CTL_VAL	0x0010
-#define BRCMF_TIMER_VAL	0x0020
-#define BRCMF_HDRS_VAL	0x0040
-#define BRCMF_BYTES_VAL	0x0080
-#define BRCMF_INTR_VAL	0x0100
-#define BRCMF_GLOM_VAL	0x0200
-#define BRCMF_EVENT_VAL	0x0400
-#define BRCMF_BTA_VAL	0x0800
-#define BRCMF_FIL_VAL	0x1000
-#define BRCMF_USB_VAL	0x2000
-#define BRCMF_SCAN_VAL	0x4000
-#define BRCMF_CONN_VAL	0x8000
+#define BRCMF_TRACE_VAL	0x00000002
+#define BRCMF_INFO_VAL	0x00000004
+#define BRCMF_DATA_VAL	0x00000008
+#define BRCMF_CTL_VAL	0x00000010
+#define BRCMF_TIMER_VAL	0x00000020
+#define BRCMF_HDRS_VAL	0x00000040
+#define BRCMF_BYTES_VAL	0x00000080
+#define BRCMF_INTR_VAL	0x00000100
+#define BRCMF_GLOM_VAL	0x00000200
+#define BRCMF_EVENT_VAL	0x00000400
+#define BRCMF_BTA_VAL	0x00000800
+#define BRCMF_FIL_VAL	0x00001000
+#define BRCMF_USB_VAL	0x00002000
+#define BRCMF_SCAN_VAL	0x00004000
+#define BRCMF_CONN_VAL	0x00008000
+#define BRCMF_CDC_VAL	0x00010000
 
 /* set default print format */
 #undef pr_fmt
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index 682cb02..a1ca691 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -459,7 +459,7 @@ static int brcmf_ethtool(struct brcmf_if *ifp, void __user *uaddr)
 		sprintf(info.version, "%lu", drvr->drv_version);
 		if (copy_to_user(uaddr, &info, sizeof(info)))
 			return -EFAULT;
-		brcmf_dbg(CTL, "given %*s, returning %s\n",
+		brcmf_dbg(TRACE, "given %*s, returning %s\n",
 			  (int)sizeof(drvname), drvname, info.driver);
 		break;
 
-- 
1.7.10.4


