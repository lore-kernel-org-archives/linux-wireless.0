Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1730 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab1JBRPC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:02 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 19/20] staging: brcm80211: cleaned up buffer len defines
 in fullmac
Date: Sun, 2 Oct 2011 10:14:44 -0700
Message-ID: <1317575685-3156-20-git-send-email-frankyl@broadcom.com> (sfid-20111002_191545_441355_C61F049A)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Replaced identical definition BRCMF_C_DCMD_MAXLEN
by BRCMF_DCMD_MAXLEN. Renamed related buffer len definitions.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    6 ++----
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c     |    6 +++---
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    8 ++++----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    4 ++--
 4 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 501faed..3ec7477 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -23,10 +23,6 @@
 
 #define BRCMF_VERSION_STR		"4.218.248.5"
 
-#define	BRCMF_C_DCMD_SMLEN	256	/* "small" cmd buffer required */
-#define BRCMF_C_DCMD_MEDLEN	1536	/* "med" cmd buffer required */
-#define	BRCMF_C_DCMD_MAXLEN	8192
-
 /*******************************************************************************
  * IO codes that are interpreted by dongle firmware
  ******************************************************************************/
@@ -749,6 +745,8 @@ extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
 extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
 					     int enable, int master_mode);
 
+#define	BRCMF_DCMD_SMLEN	256	/* "small" cmd buffer required */
+#define BRCMF_DCMD_MEDLEN	1536	/* "med" cmd buffer required */
 #define	BRCMF_DCMD_MAXLEN	8192	/* max length cmd buffer required */
 
 /* message levels */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index ec0a057..e34c5c3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -97,7 +97,7 @@ struct brcmf_proto {
 	u32 lastcmd;
 	u8 bus_header[BUS_HEADER_LEN];
 	struct brcmf_proto_cdc_dcmd msg;
-	unsigned char buf[BRCMF_C_DCMD_MAXLEN + ROUND_UP_MARGIN];
+	unsigned char buf[BRCMF_DCMD_MAXLEN + ROUND_UP_MARGIN];
 };
 
 static int brcmf_proto_cdc_msg(struct brcmf_pub *drvr)
@@ -288,7 +288,7 @@ brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx, struct brcmf_dcmd *dcmd,
 
 	brcmf_dbg(TRACE, "Enter\n");
 
-	if (len > BRCMF_C_DCMD_MAXLEN)
+	if (len > BRCMF_DCMD_MAXLEN)
 		goto done;
 
 	if (prot->pending == true) {
@@ -435,7 +435,7 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 
 	drvr->prot = cdc;
 	drvr->hdrlen += BDC_HEADER_LEN;
-	drvr->maxctl = BRCMF_C_DCMD_MAXLEN +
+	drvr->maxctl = BRCMF_DCMD_MAXLEN +
 			sizeof(struct brcmf_proto_cdc_dcmd) + ROUND_UP_MARGIN;
 	return 0;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 42e7642..d12aa75 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -342,7 +342,7 @@ done:
 
 static s32 brcmf_dev_intvar_set(struct net_device *ndev, s8 *name, s32 val)
 {
-	s8 buf[BRCMF_C_DCMD_SMLEN];
+	s8 buf[BRCMF_DCMD_SMLEN];
 	u32 len;
 	s32 err = 0;
 	__le32 val_le;
@@ -363,7 +363,7 @@ static s32
 brcmf_dev_intvar_get(struct net_device *ndev, s8 *name, s32 *retval)
 {
 	union {
-		s8 buf[BRCMF_C_DCMD_SMLEN];
+		s8 buf[BRCMF_DCMD_SMLEN];
 		__le32 val;
 	} var;
 	u32 len;
@@ -451,7 +451,7 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	params = kzalloc(params_size, GFP_KERNEL);
 	if (!params)
 		return -ENOMEM;
-	BUG_ON(params_size >= BRCMF_C_DCMD_SMLEN);
+	BUG_ON(params_size >= BRCMF_DCMD_SMLEN);
 
 	wl_iscan_prep(&params->params_le, ssid);
 
@@ -460,7 +460,7 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	params->scan_duration = cpu_to_le16(0);
 
 	err = brcmf_dev_iovar_setbuf(iscan->ndev, "iscan", params, params_size,
-				     iscan->dcmd_buf, BRCMF_C_DCMD_SMLEN);
+				     iscan->dcmd_buf, BRCMF_DCMD_SMLEN);
 	if (err) {
 		if (err == -EBUSY)
 			WL_INFO("system busy : iscan canceled\n");
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 21c8f8e..e69f4f6 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -106,7 +106,7 @@ do {								\
 #define WL_DCMD_LEN_MAX	1024
 #define WL_EXTRA_BUF_MAX	2048
 #define WL_ISCAN_BUF_MAX	2048	/*
-				 * the buf length can be BRCMF_C_DCMD_MAXLEN
+				 * the buf length can be BRCMF_DCMD_MAXLEN
 				 * to reduce iteration
 				 */
 #define WL_ISCAN_TIMER_INTERVAL_MS	3000
@@ -251,7 +251,7 @@ struct brcmf_cfg80211_iscan_ctrl {
 	struct work_struct work;
 	struct brcmf_cfg80211_iscan_eloop el;
 	void *data;
-	s8 dcmd_buf[BRCMF_C_DCMD_SMLEN];
+	s8 dcmd_buf[BRCMF_DCMD_SMLEN];
 	s8 scan_buf[WL_ISCAN_BUF_MAX];
 };
 
-- 
1.7.1


