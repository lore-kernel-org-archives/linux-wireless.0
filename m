Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4671 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 087/119] staging: brcm80211: rename macro definitions in
 dhd.h
Date: Wed, 29 Jun 2011 16:47:51 -0700
Message-ID: <1309391303-22741-88-git-send-email-frankyl@broadcom.com> (sfid-20110630_015013_226589_B0E964A0)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The definitions in dhd.h have been renamed with consistent prefix
BRCMF_.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   24 ++--
 drivers/staging/brcm80211/brcmfmac/dhd.h          |  120 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c      |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |   34 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h      |   52 +++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   46 ++++----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   44 ++++----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |   48 ++++----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |    2 +-
 9 files changed, 187 insertions(+), 185 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 764d839..167181d 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -43,10 +43,10 @@ extern int brcmf_sdioh_reset_comm(struct mmc_card *card);
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
 uint sd_msglevel = 0x01;
-DHD_PM_RESUME_WAIT_INIT(sdioh_request_byte_wait);
-DHD_PM_RESUME_WAIT_INIT(sdioh_request_word_wait);
-DHD_PM_RESUME_WAIT_INIT(sdioh_request_packet_wait);
-DHD_PM_RESUME_WAIT_INIT(sdioh_request_buffer_wait);
+BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_byte_wait);
+BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_word_wait);
+BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_packet_wait);
+BRCMF_PM_RESUME_WAIT_INIT(sdioh_request_buffer_wait);
 
 #define DMA_ALIGN_MASK	0x03
 
@@ -534,8 +534,8 @@ brcmf_sdioh_request_byte(struct sdioh_info *sd, uint rw, uint func,
 	sd_info(("%s: rw=%d, func=%d, addr=0x%05x\n", __func__, rw, func,
 		 regaddr));
 
-	DHD_PM_RESUME_WAIT(sdioh_request_byte_wait);
-	DHD_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_byte_wait);
+	BRCMF_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
 	if (rw) {		/* CMD52 Write */
 		if (func == 0) {
 			/* Can only directly write to some F0 registers.
@@ -636,8 +636,8 @@ brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 	sd_info(("%s: cmd_type=%d, rw=%d, func=%d, addr=0x%05x, nbytes=%d\n",
 		 __func__, cmd_type, rw, func, addr, nbytes));
 
-	DHD_PM_RESUME_WAIT(sdioh_request_word_wait);
-	DHD_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_word_wait);
+	BRCMF_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
 	/* Claim host controller */
 	sdio_claim_host(gInstance->func[func]);
 
@@ -688,8 +688,8 @@ brcmf_sdioh_request_packet(struct sdioh_info *sd, uint fix_inc, uint write,
 	sd_trace(("%s: Enter\n", __func__));
 
 	ASSERT(pkt);
-	DHD_PM_RESUME_WAIT(sdioh_request_packet_wait);
-	DHD_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_packet_wait);
+	BRCMF_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
 
 	/* Claim host controller */
 	sdio_claim_host(gInstance->func[func]);
@@ -774,8 +774,8 @@ brcmf_sdioh_request_buffer(struct sdioh_info *sd, uint pio_dma, uint fix_inc,
 
 	sd_trace(("%s: Enter\n", __func__));
 
-	DHD_PM_RESUME_WAIT(sdioh_request_buffer_wait);
-	DHD_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
+	BRCMF_PM_RESUME_WAIT(sdioh_request_buffer_wait);
+	BRCMF_PM_RESUME_RETURN_ERROR(SDIOH_API_RC_FAIL);
 	/* Case 1: we don't have a packet. */
 	if (pkt == NULL) {
 		sd_data(("%s: Creating new %s Packet, len=%d\n",
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 93e0164..9b1a7f4 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -83,11 +83,11 @@
 #define	WLC_PHY_TYPE_LCN	8
 #define	WLC_PHY_TYPE_NULL	0xf
 
-#define WL_PKT_FILTER_FIXED_LEN		  offsetof(struct brcmf_pkt_filter, u)
-#define WL_PKT_FILTER_PATTERN_FIXED_LEN	\
+#define BRCMF_PKT_FILTER_FIXED_LEN	offsetof(struct brcmf_pkt_filter, u)
+#define BRCMF_PKT_FILTER_PATTERN_FIXED_LEN	\
 	offsetof(struct brcmf_pkt_filter_pattern, mask_and_pattern)
 
-#define WL_EVENTING_MASK_LEN	16
+#define BRCMF_EVENTING_MASK_LEN	16
 
 #define TOE_TX_CSUM_OL		0x00000001
 #define TOE_RX_CSUM_OL		0x00000002
@@ -95,38 +95,38 @@
 /* maximum channels returned by the get valid channels iovar */
 #define WL_NUMCHANNELS		64
 
-#define	WL_BSS_INFO_VERSION	108 /* current ver of brcmf_bss_info struct */
+#define	BRCMF_BSS_INFO_VERSION	108 /* current ver of brcmf_bss_info struct */
 
 /* size of brcmf_scan_params not including variable length array */
-#define WL_SCAN_PARAMS_FIXED_SIZE 64
+#define BRCMF_SCAN_PARAMS_FIXED_SIZE 64
 
 /* masks for channel and ssid count */
-#define WL_SCAN_PARAMS_COUNT_MASK 0x0000ffff
-#define WL_SCAN_PARAMS_NSSID_SHIFT 16
+#define BRCMF_SCAN_PARAMS_COUNT_MASK 0x0000ffff
+#define BRCMF_SCAN_PARAMS_NSSID_SHIFT 16
 
-#define WL_SCAN_ACTION_START      1
-#define WL_SCAN_ACTION_CONTINUE   2
+#define BRCMF_SCAN_ACTION_START      1
+#define BRCMF_SCAN_ACTION_CONTINUE   2
 #define WL_SCAN_ACTION_ABORT      3
 
-#define ISCAN_REQ_VERSION 1
+#define BRCMF_ISCAN_REQ_VERSION 1
 
 /* brcmf_iscan_results status values */
-#define WL_SCAN_RESULTS_SUCCESS	0
-#define WL_SCAN_RESULTS_PARTIAL	1
-#define WL_SCAN_RESULTS_PENDING	2
-#define WL_SCAN_RESULTS_ABORTED	3
-#define WL_SCAN_RESULTS_NO_MEM	4
+#define BRCMF_SCAN_RESULTS_SUCCESS	0
+#define BRCMF_SCAN_RESULTS_PARTIAL	1
+#define BRCMF_SCAN_RESULTS_PENDING	2
+#define BRCMF_SCAN_RESULTS_ABORTED	3
+#define BRCMF_SCAN_RESULTS_NO_MEM	4
 
 #define WL_SOFT_KEY	(1 << 0)	/* Indicates this key is using soft encrypt */
-#define WL_PRIMARY_KEY	(1 << 1)	/* Indicates this key is the primary (ie tx) key */
+#define BRCMF_PRIMARY_KEY	(1 << 1)	/* primary (ie tx) key */
 #define WL_KF_RES_4	(1 << 4)	/* Reserved for backward compat */
 #define WL_KF_RES_5	(1 << 5)	/* Reserved for backward compat */
 #define WL_IBSS_PEER_GROUP_KEY	(1 << 6)	/* Indicates a group key for a IBSS PEER */
 
 /* For supporting multiple interfaces */
-#define DHD_MAX_IFS	16
-#define DHD_DEL_IF	-0xe
-#define DHD_BAD_IF	-0xf
+#define BRCMF_MAX_IFS	16
+#define BRCMF_DEL_IF	-0xe
+#define BRCMF_BAD_IF	-0xf
 
 #define DOT11_BSSTYPE_ANY			2
 #define DOT11_MAX_DEFAULT_KEYS	4
@@ -454,7 +454,7 @@ struct brcmf_assoc_params {
 				 */
 	chanspec_t chanspec_list[1];	/* list of chanspecs */
 };
-#define WL_ASSOC_PARAMS_FIXED_SIZE \
+#define BRCMF_ASSOC_PARAMS_FIXED_SIZE \
 	(sizeof(struct brcmf_assoc_params) - sizeof(chanspec_t))
 
 /* used for join with or without a specific bssid and channel list */
@@ -591,7 +591,7 @@ typedef struct dhd_pub {
 	int pktfilter_count;
 
 	u8 country_code[WLC_CNTRY_BUF_SZ];
-	char eventmask[WL_EVENTING_MASK_LEN];
+	char eventmask[BRCMF_EVENTING_MASK_LEN];
 
 } dhd_pub_t;
 
@@ -616,24 +616,24 @@ typedef struct {
 
 #if defined(CONFIG_PM_SLEEP)
 extern atomic_t brcmf_mmc_suspend;
-#define DHD_PM_RESUME_WAIT_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
-#define _DHD_PM_RESUME_WAIT(a, b) do { \
+#define BRCMF_PM_RESUME_WAIT_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
+#define _BRCMF_PM_RESUME_WAIT(a, b) do { \
 		int retry = 0; \
 		while (atomic_read(&brcmf_mmc_suspend) && retry++ != b) { \
 			wait_event_timeout(a, false, HZ/100); \
 		} \
 	}	while (0)
-#define DHD_PM_RESUME_WAIT(a)	_DHD_PM_RESUME_WAIT(a, 30)
-#define DHD_PM_RESUME_WAIT_FOREVER(a)	_DHD_PM_RESUME_WAIT(a, ~0)
-#define DHD_PM_RESUME_RETURN_ERROR(a)	\
+#define BRCMF_PM_RESUME_WAIT(a)	_BRCMF_PM_RESUME_WAIT(a, 30)
+#define DHD_PM_RESUME_WAIT_FOREVER(a)	_BRCMF_PM_RESUME_WAIT(a, ~0)
+#define BRCMF_PM_RESUME_RETURN_ERROR(a)	\
 	do { if (atomic_read(&brcmf_mmc_suspend)) return a; } while (0)
 #define DHD_PM_RESUME_RETURN	do { \
 	if (atomic_read(&brcmf_mmc_suspend)) \
 		return; \
 	} while (0)
 
-#define DHD_SPINWAIT_SLEEP_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
-#define SPINWAIT_SLEEP(a, exp, us) do { \
+#define BRCMF_SPINWAIT_SLEEP_INIT(a) DECLARE_WAIT_QUEUE_HEAD(a);
+#define BRCMF_SPINWAIT_SLEEP(a, exp, us) do { \
 		uint countdown = (us) + 9999; \
 		while ((exp) && (countdown >= 10000)) { \
 			wait_event_timeout(a, false, HZ/100); \
@@ -643,14 +643,14 @@ extern atomic_t brcmf_mmc_suspend;
 
 #else
 
-#define DHD_PM_RESUME_WAIT_INIT(a)
-#define DHD_PM_RESUME_WAIT(a)
+#define BRCMF_PM_RESUME_WAIT_INIT(a)
+#define BRCMF_PM_RESUME_WAIT(a)
 #define DHD_PM_RESUME_WAIT_FOREVER(a)
-#define DHD_PM_RESUME_RETURN_ERROR(a)
+#define BRCMF_PM_RESUME_RETURN_ERROR(a)
 #define DHD_PM_RESUME_RETURN
 
-#define DHD_SPINWAIT_SLEEP_INIT(a)
-#define SPINWAIT_SLEEP(a, exp, us)  do { \
+#define BRCMF_SPINWAIT_SLEEP_INIT(a)
+#define BRCMF_SPINWAIT_SLEEP(a, exp, us)  do { \
 		uint countdown = (us) + 9; \
 		while ((exp) && (countdown >= 10)) { \
 			udelay(10);  \
@@ -861,35 +861,35 @@ typedef struct dhd_ioctl {
 } dhd_ioctl_t;
 
 /* per-driver magic numbers */
-#define DHD_IOCTL_MAGIC		0x00444944
+#define BRCMF_IOCTL_MAGIC		0x00444944
 
 /* bump this number if you change the ioctl interface */
-#define DHD_IOCTL_VERSION	1
+#define BRCMF_IOCTL_VERSION	1
 
-#define	DHD_IOCTL_MAXLEN	8192	/* max length ioctl buffer required */
+#define	BRCMF_IOCTL_MAXLEN	8192	/* max length ioctl buffer required */
 #define	DHD_IOCTL_SMLEN	256	/* "small" length ioctl buffer required */
 
 /* common ioctl definitions */
-#define DHD_GET_MAGIC				0
-#define DHD_GET_VERSION				1
-#define DHD_GET_VAR				2
-#define DHD_SET_VAR				3
+#define BRCMF_GET_MAGIC				0
+#define BRCMF_GET_VERSION				1
+#define BRCMF_GET_VAR				2
+#define BRCMF_SET_VAR				3
 
 /* message levels */
-#define DHD_ERROR_VAL	0x0001
-#define DHD_TRACE_VAL	0x0002
-#define DHD_INFO_VAL	0x0004
-#define DHD_DATA_VAL	0x0008
-#define DHD_CTL_VAL	0x0010
-#define DHD_TIMER_VAL	0x0020
-#define DHD_HDRS_VAL	0x0040
-#define DHD_BYTES_VAL	0x0080
-#define DHD_INTR_VAL	0x0100
+#define BRCMF_ERROR_VAL	0x0001
+#define BRCMF_TRACE_VAL	0x0002
+#define BRCMF_INFO_VAL	0x0004
+#define BRCMF_DATA_VAL	0x0008
+#define BRCMF_CTL_VAL	0x0010
+#define BRCMF_TIMER_VAL	0x0020
+#define BRCMF_HDRS_VAL	0x0040
+#define BRCMF_BYTES_VAL	0x0080
+#define BRCMF_INTR_VAL	0x0100
 #define DHD_LOG_VAL	0x0200
-#define DHD_GLOM_VAL	0x0400
-#define DHD_EVENT_VAL	0x0800
-#define DHD_BTA_VAL	0x1000
-#define DHD_ISCAN_VAL 0x2000
+#define BRCMF_GLOM_VAL	0x0400
+#define BRCMF_EVENT_VAL	0x0800
+#define BRCMF_BTA_VAL	0x1000
+#define BRCMF_ISCAN_VAL 0x2000
 
 #ifdef SDTEST
 /* For pktgen iovar */
@@ -909,22 +909,22 @@ typedef struct brcmf_pktgen {
 } brcmf_pktgen_t;
 
 /* Version in case structure changes */
-#define DHD_PKTGEN_VERSION 2
+#define BRCMF_PKTGEN_VERSION	2
 
 /* Type of test packets to use */
-#define DHD_PKTGEN_ECHO		1	/* Send echo requests */
-#define DHD_PKTGEN_SEND		2	/* Send discard packets */
-#define DHD_PKTGEN_RXBURST	3	/* Request dongle send N packets */
-#define DHD_PKTGEN_RECV		4	/* Continuous rx from continuous
+#define BRCMF_PKTGEN_ECHO	1	/* Send echo requests */
+#define BRCMF_PKTGEN_SEND	2	/* Send discard packets */
+#define BRCMF_PKTGEN_RXBURST	3	/* Request dongle send N packets */
+#define BRCMF_PKTGEN_RECV		4	/* Continuous rx from continuous
 					 tx dongle */
 #endif				/* SDTEST */
 
 /* Enter idle immediately (no timeout) */
-#define DHD_IDLE_IMMEDIATE	(-1)
+#define BRCMF_IDLE_IMMEDIATE	(-1)
 
 /* Values for idleclock iovar: other values are the sd_divisor to use
 	 when idle */
-#define DHD_IDLE_ACTIVE	0	/* Do not request any SD clock change
+#define BRCMF_IDLE_ACTIVE	0	/* Do not request any SD clock change
 				 when idle */
 #define DHD_IDLE_STOP   (-1)	/* Request SD clock be stopped
 				 (and use SD1 mode) */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 7efe69c..a336068 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -406,7 +406,7 @@ int brcmf_proto_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 	h = (struct brcmf_proto_bdc_header *)(pktbuf->data);
 
 	*ifidx = BDC_GET_IF_IDX(h);
-	if (*ifidx >= DHD_MAX_IFS) {
+	if (*ifidx >= BRCMF_MAX_IFS) {
 		DHD_ERROR(("%s: rx data ifnum out of range (%d)\n",
 			   __func__, *ifidx));
 		return -EBADE;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 84daa8e..9b0ad44 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -71,7 +71,7 @@ const struct brcmu_iovar brcmf_iovars[] = {
 	,
 	{"bcmerror", IOV_BCMERROR, 0, IOVT_INT8, 0}
 	,
-	{"dump", IOV_DUMP, 0, IOVT_BUFFER, DHD_IOCTL_MAXLEN}
+	{"dump", IOV_DUMP, 0, IOVT_BUFFER, BRCMF_IOCTL_MAXLEN}
 	,
 	{"clearcounts", IOV_CLEARCOUNTS, 0, IOVT_VOID, 0}
 	,
@@ -108,7 +108,7 @@ void brcmf_c_init(void)
 	 * first time that the driver is initialized vs subsequent
 	 * initializations.
 	 */
-	brcmf_msg_level = DHD_ERROR_VAL;
+	brcmf_msg_level = BRCMF_ERROR_VAL;
 }
 
 static int brcmf_c_dump(dhd_pub_t *drvr, char *buf, int buflen)
@@ -370,22 +370,22 @@ int brcmf_c_ioctl(dhd_pub_t *drvr, dhd_ioctl_t *ioc, void *buf, uint buflen)
 		return -EINVAL;
 
 	switch (ioc->cmd) {
-	case DHD_GET_MAGIC:
+	case BRCMF_GET_MAGIC:
 		if (buflen < sizeof(int))
 			bcmerror = -EOVERFLOW;
 		else
-			*(int *)buf = DHD_IOCTL_MAGIC;
+			*(int *)buf = BRCMF_IOCTL_MAGIC;
 		break;
 
-	case DHD_GET_VERSION:
+	case BRCMF_GET_VERSION:
 		if (buflen < sizeof(int))
 			bcmerror = -EOVERFLOW;
 		else
-			*(int *)buf = DHD_IOCTL_VERSION;
+			*(int *)buf = BRCMF_IOCTL_VERSION;
 		break;
 
-	case DHD_GET_VAR:
-	case DHD_SET_VAR:{
+	case BRCMF_GET_VAR:
+	case BRCMF_SET_VAR:{
 			char *arg;
 			uint arglen;
 
@@ -403,7 +403,7 @@ int brcmf_c_ioctl(dhd_pub_t *drvr, dhd_ioctl_t *ioc, void *buf, uint buflen)
 			arg++, arglen--;
 
 			/* call with the appropriate arguments */
-			if (ioc->cmd == DHD_GET_VAR)
+			if (ioc->cmd == BRCMF_GET_VAR)
 				bcmerror = brcmf_c_iovar_op(drvr, buf, arg,
 						arglen, buf, buflen, IOV_GET);
 			else
@@ -414,7 +414,7 @@ int brcmf_c_ioctl(dhd_pub_t *drvr, dhd_ioctl_t *ioc, void *buf, uint buflen)
 				break;
 
 			/* not in generic table, try protocol module */
-			if (ioc->cmd == DHD_GET_VAR)
+			if (ioc->cmd == BRCMF_GET_VAR)
 				bcmerror = brcmf_proto_iovar_op(drvr, buf,
 								arg, arglen,
 								buf, buflen,
@@ -428,7 +428,7 @@ int brcmf_c_ioctl(dhd_pub_t *drvr, dhd_ioctl_t *ioc, void *buf, uint buflen)
 				break;
 
 			/* if still not found, try bus module */
-			if (ioc->cmd == DHD_GET_VAR)
+			if (ioc->cmd == BRCMF_GET_VAR)
 				bcmerror = brcmf_sdbrcm_bus_iovar_op(drvr,
 						buf, arg, arglen, buf, buflen,
 						IOV_GET);
@@ -794,7 +794,7 @@ brcmf_c_host_event(struct dhd_info *drvr_priv, int *ifidx, void *pktdata,
 			DHD_TRACE(("%s: if event\n", __func__));
 
 			if (ifevent->ifidx > 0 &&
-				 ifevent->ifidx < DHD_MAX_IFS) {
+				 ifevent->ifidx < BRCMF_MAX_IFS) {
 				if (ifevent->action == BRCMF_E_IF_ADD)
 					brcmf_add_if(drvr_priv, ifevent->ifidx,
 						   NULL, event->ifname,
@@ -1054,8 +1054,8 @@ void brcmf_c_pktfilter_offload_set(dhd_pub_t *drvr, char *arg)
 	}
 
 	pkt_filter.u.pattern.size_bytes = mask_size;
-	buf_len += WL_PKT_FILTER_FIXED_LEN;
-	buf_len += (WL_PKT_FILTER_PATTERN_FIXED_LEN + 2 * mask_size);
+	buf_len += BRCMF_PKT_FILTER_FIXED_LEN;
+	buf_len += (BRCMF_PKT_FILTER_PATTERN_FIXED_LEN + 2 * mask_size);
 
 	/* Keep-alive attributes are set in local
 	 * variable (keep_alive_pkt), and
@@ -1064,7 +1064,7 @@ void brcmf_c_pktfilter_offload_set(dhd_pub_t *drvr, char *arg)
 	 */
 	memcpy((char *)pkt_filterp,
 	       &pkt_filter,
-	       WL_PKT_FILTER_FIXED_LEN + WL_PKT_FILTER_PATTERN_FIXED_LEN);
+	       BRCMF_PKT_FILTER_FIXED_LEN + BRCMF_PKT_FILTER_PATTERN_FIXED_LEN);
 
 	rc = brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
@@ -1118,7 +1118,7 @@ void brcmf_c_arp_offload_enable(dhd_pub_t *drvr, int arp_enable)
 
 int brcmf_c_preinit_ioctls(dhd_pub_t *drvr)
 {
-	char iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for
+	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];	/*  Room for
 				 "event_msgs" + '\0' + bitvec  */
 	uint up = 0;
 	char buf[128], *ptr;
@@ -1186,7 +1186,7 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *drvr)
 					  sizeof(up));
 
 	/* Setup event_msgs */
-	brcmu_mkiovar("event_msgs", drvr->eventmask, WL_EVENTING_MASK_LEN,
+	brcmu_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
index e0fc124..678a7e2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
@@ -20,46 +20,46 @@
 #if defined(BCMDBG)
 
 #define DHD_ERROR(args) \
-	do {if ((brcmf_msg_level & DHD_ERROR_VAL) && (net_ratelimit())) \
+	do {if ((brcmf_msg_level & BRCMF_ERROR_VAL) && (net_ratelimit())) \
 		printk args; } while (0)
-#define DHD_TRACE(args)		do {if (brcmf_msg_level & DHD_TRACE_VAL) \
+#define DHD_TRACE(args)		do {if (brcmf_msg_level & BRCMF_TRACE_VAL) \
 					printk args; } while (0)
-#define DHD_INFO(args)		do {if (brcmf_msg_level & DHD_INFO_VAL) \
+#define DHD_INFO(args)		do {if (brcmf_msg_level & BRCMF_INFO_VAL) \
 					printk args; } while (0)
-#define DHD_DATA(args)		do {if (brcmf_msg_level & DHD_DATA_VAL) \
+#define DHD_DATA(args)		do {if (brcmf_msg_level & BRCMF_DATA_VAL) \
 					printk args; } while (0)
-#define DHD_CTL(args)		do {if (brcmf_msg_level & DHD_CTL_VAL) \
+#define DHD_CTL(args)		do {if (brcmf_msg_level & BRCMF_CTL_VAL) \
 					printk args; } while (0)
-#define DHD_TIMER(args)		do {if (brcmf_msg_level & DHD_TIMER_VAL) \
+#define DHD_TIMER(args)		do {if (brcmf_msg_level & BRCMF_TIMER_VAL) \
 					printk args; } while (0)
-#define DHD_HDRS(args)		do {if (brcmf_msg_level & DHD_HDRS_VAL) \
+#define DHD_HDRS(args)		do {if (brcmf_msg_level & BRCMF_HDRS_VAL) \
 					printk args; } while (0)
-#define DHD_BYTES(args)		do {if (brcmf_msg_level & DHD_BYTES_VAL) \
+#define DHD_BYTES(args)		do {if (brcmf_msg_level & BRCMF_BYTES_VAL) \
 					printk args; } while (0)
-#define DHD_INTR(args)		do {if (brcmf_msg_level & DHD_INTR_VAL)	\
+#define DHD_INTR(args)		do {if (brcmf_msg_level & BRCMF_INTR_VAL) \
 					printk args; } while (0)
-#define DHD_GLOM(args)		do {if (brcmf_msg_level & DHD_GLOM_VAL) \
+#define DHD_GLOM(args)		do {if (brcmf_msg_level & BRCMF_GLOM_VAL) \
 					printk args; } while (0)
-#define DHD_EVENT(args)		do {if (brcmf_msg_level & DHD_EVENT_VAL) \
+#define DHD_EVENT(args)		do {if (brcmf_msg_level & BRCMF_EVENT_VAL) \
 					printk args; } while (0)
-#define DHD_BTA(args)		do {if (brcmf_msg_level & DHD_BTA_VAL) \
+#define DHD_BTA(args)		do {if (brcmf_msg_level & BRCMF_BTA_VAL) \
 					printk args; } while (0)
-#define DHD_ISCAN(args)		do {if (brcmf_msg_level & DHD_ISCAN_VAL) \
+#define DHD_ISCAN(args)		do {if (brcmf_msg_level & BRCMF_ISCAN_VAL) \
 					printk args; } while (0)
 
-#define DHD_ERROR_ON()		(brcmf_msg_level & DHD_ERROR_VAL)
-#define DHD_TRACE_ON()		(brcmf_msg_level & DHD_TRACE_VAL)
-#define DHD_INFO_ON()		(brcmf_msg_level & DHD_INFO_VAL)
-#define DHD_DATA_ON()		(brcmf_msg_level & DHD_DATA_VAL)
-#define DHD_CTL_ON()		(brcmf_msg_level & DHD_CTL_VAL)
-#define DHD_TIMER_ON()		(brcmf_msg_level & DHD_TIMER_VAL)
-#define DHD_HDRS_ON()		(brcmf_msg_level & DHD_HDRS_VAL)
-#define DHD_BYTES_ON()		(brcmf_msg_level & DHD_BYTES_VAL)
-#define DHD_INTR_ON()		(brcmf_msg_level & DHD_INTR_VAL)
-#define DHD_GLOM_ON()		(brcmf_msg_level & DHD_GLOM_VAL)
-#define DHD_EVENT_ON()		(brcmf_msg_level & DHD_EVENT_VAL)
-#define DHD_BTA_ON()		(brcmf_msg_level & DHD_BTA_VAL)
-#define DHD_ISCAN_ON()		(brcmf_msg_level & DHD_ISCAN_VAL)
+#define DHD_ERROR_ON()		(brcmf_msg_level & BRCMF_ERROR_VAL)
+#define DHD_TRACE_ON()		(brcmf_msg_level & BRCMF_TRACE_VAL)
+#define DHD_INFO_ON()		(brcmf_msg_level & BRCMF_INFO_VAL)
+#define DHD_DATA_ON()		(brcmf_msg_level & BRCMF_DATA_VAL)
+#define DHD_CTL_ON()		(brcmf_msg_level & BRCMF_CTL_VAL)
+#define DHD_TIMER_ON()		(brcmf_msg_level & BRCMF_TIMER_VAL)
+#define DHD_HDRS_ON()		(brcmf_msg_level & BRCMF_HDRS_VAL)
+#define DHD_BYTES_ON()		(brcmf_msg_level & BRCMF_BYTES_VAL)
+#define DHD_INTR_ON()		(brcmf_msg_level & BRCMF_INTR_VAL)
+#define DHD_GLOM_ON()		(brcmf_msg_level & BRCMF_GLOM_VAL)
+#define DHD_EVENT_ON()		(brcmf_msg_level & BRCMF_EVENT_VAL)
+#define DHD_BTA_ON()		(brcmf_msg_level & BRCMF_BTA_VAL)
+#define DHD_ISCAN_ON()		(brcmf_msg_level & BRCMF_ISCAN_VAL)
 
 #else	/* (defined BCMDBG) || (defined BCMDBG) */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 6b2682f..2135a64 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -79,7 +79,7 @@ typedef struct dhd_info {
 	dhd_pub_t pub;
 
 	/* OS/stack specifics */
-	dhd_if_t *iflist[DHD_MAX_IFS];
+	dhd_if_t *iflist[BRCMF_MAX_IFS];
 
 	struct semaphore proto_sem;
 	wait_queue_head_t ioctl_resp_wait;
@@ -370,18 +370,18 @@ static int brcmf_net2idx(dhd_info_t *drvr_priv, struct net_device *net)
 	int i = 0;
 
 	ASSERT(drvr_priv);
-	while (i < DHD_MAX_IFS) {
+	while (i < BRCMF_MAX_IFS) {
 		if (drvr_priv->iflist[i] && (drvr_priv->iflist[i]->net == net))
 			return i;
 		i++;
 	}
 
-	return DHD_BAD_IF;
+	return BRCMF_BAD_IF;
 }
 
 int brcmf_ifname2idx(dhd_info_t *drvr_priv, char *name)
 {
-	int i = DHD_MAX_IFS;
+	int i = BRCMF_MAX_IFS;
 
 	ASSERT(drvr_priv);
 
@@ -404,7 +404,7 @@ char *brcmf_ifname(dhd_pub_t *drvr, int ifidx)
 
 	ASSERT(drvr_priv);
 
-	if (ifidx < 0 || ifidx >= DHD_MAX_IFS) {
+	if (ifidx < 0 || ifidx >= BRCMF_MAX_IFS) {
 		DHD_ERROR(("%s: ifidx %d out of range\n", __func__, ifidx));
 		return "<if_bad>";
 	}
@@ -636,7 +636,7 @@ static void brcmf_op_if(dhd_if_t *ifp)
 				   __func__));
 			netif_stop_queue(ifp->net);
 			unregister_netdev(ifp->net);
-			ret = DHD_DEL_IF;	/* Make sure the free_netdev()
+			ret = BRCMF_DEL_IF;	/* Make sure the free_netdev()
 							 is called */
 		}
 		break;
@@ -673,7 +673,7 @@ static int _brcmf_sysioc_thread(void *data)
 	while (down_interruptible(&drvr_priv->sysioc_sem) == 0) {
 		if (kthread_should_stop())
 			break;
-		for (i = 0; i < DHD_MAX_IFS; i++) {
+		for (i = 0; i < BRCMF_MAX_IFS; i++) {
 			if (drvr_priv->iflist[i]) {
 #ifdef SOFTAP
 				in_ap = (ap_net_dev != NULL);
@@ -728,7 +728,7 @@ static int brcmf_netdev_set_mac_address(struct net_device *dev, void *addr)
 	int ifidx;
 
 	ifidx = brcmf_net2idx(drvr_priv, dev);
-	if (ifidx == DHD_BAD_IF)
+	if (ifidx == BRCMF_BAD_IF)
 		return -1;
 
 	ASSERT(drvr_priv->sysioc_tsk);
@@ -745,7 +745,7 @@ static void brcmf_netdev_set_multicast_list(struct net_device *dev)
 	int ifidx;
 
 	ifidx = brcmf_net2idx(drvr_priv, dev);
-	if (ifidx == DHD_BAD_IF)
+	if (ifidx == BRCMF_BAD_IF)
 		return;
 
 	ASSERT(drvr_priv->sysioc_tsk);
@@ -796,7 +796,7 @@ static int brcmf_netdev_start_xmit(struct sk_buff *skb, struct net_device *net)
 	}
 
 	ifidx = brcmf_net2idx(drvr_priv, net);
-	if (ifidx == DHD_BAD_IF) {
+	if (ifidx == BRCMF_BAD_IF) {
 		DHD_ERROR(("%s: bad ifidx %d\n", __func__, ifidx));
 		netif_stop_queue(net);
 		return -ENODEV;
@@ -907,7 +907,7 @@ void brcmf_rx_frame(dhd_pub_t *drvr, int ifidx, struct sk_buff *skb,
 					  skb_mac_header(skb),
 					  &event, &data);
 
-		ASSERT(ifidx < DHD_MAX_IFS && drvr_priv->iflist[ifidx]);
+		ASSERT(ifidx < BRCMF_MAX_IFS && drvr_priv->iflist[ifidx]);
 		if (drvr_priv->iflist[ifidx] &&
 		    !drvr_priv->iflist[ifidx]->state)
 			ifp = drvr_priv->iflist[ifidx];
@@ -964,7 +964,7 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	ifidx = brcmf_net2idx(drvr_priv, net);
-	if (ifidx == DHD_BAD_IF)
+	if (ifidx == BRCMF_BAD_IF)
 		return NULL;
 
 	ifp = drvr_priv->iflist[ifidx];
@@ -1208,7 +1208,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	ifidx = brcmf_net2idx(drvr_priv, net);
 	DHD_TRACE(("%s: ifidx %d, cmd 0x%04x\n", __func__, ifidx, cmd));
 
-	if (ifidx == DHD_BAD_IF)
+	if (ifidx == BRCMF_BAD_IF)
 		return -1;
 
 	if (cmd == SIOCETHTOOL)
@@ -1227,7 +1227,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 
 	/* Copy out any buffer passed */
 	if (ioc.buf) {
-		buflen = min_t(int, ioc.len, DHD_IOCTL_MAXLEN);
+		buflen = min_t(int, ioc.len, BRCMF_IOCTL_MAXLEN);
 		/* optimization for direct ioctl calls from kernel */
 		/*
 		   if (segment_eq(get_fs(), KERNEL_DS)) {
@@ -1260,7 +1260,7 @@ static int brcmf_netdev_ioctl_entry(struct net_device *net, struct ifreq *ifr,
 	}
 
 	/* check for local dhd ioctl and handle it */
-	if (driver == DHD_IOCTL_MAGIC) {
+	if (driver == BRCMF_IOCTL_MAGIC) {
 		bcmerror = brcmf_c_ioctl((void *)&drvr_priv->pub, &ioc, buf, buflen);
 		if (bcmerror)
 			drvr_priv->pub.bcmerror = bcmerror;
@@ -1378,7 +1378,7 @@ brcmf_add_if(dhd_info_t *drvr_priv, int ifidx, void *handle, char *name,
 
 	DHD_TRACE(("%s: idx %d, handle->%p\n", __func__, ifidx, handle));
 
-	ASSERT(drvr_priv && (ifidx < DHD_MAX_IFS));
+	ASSERT(drvr_priv && (ifidx < BRCMF_MAX_IFS));
 
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
@@ -1413,7 +1413,7 @@ void brcmf_del_if(dhd_info_t *drvr_priv, int ifidx)
 
 	DHD_TRACE(("%s: idx %d\n", __func__, ifidx));
 
-	ASSERT(drvr_priv && ifidx && (ifidx < DHD_MAX_IFS));
+	ASSERT(drvr_priv && ifidx && (ifidx < BRCMF_MAX_IFS));
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
 		DHD_ERROR(("%s: Null interface\n", __func__));
@@ -1465,7 +1465,7 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	}
 
 	if (brcmf_add_if(drvr_priv, 0, (void *)net, net->name, NULL, 0, 0) ==
-	    DHD_BAD_IF)
+	    BRCMF_BAD_IF)
 		goto fail;
 
 	net->netdev_ops = NULL;
@@ -1539,8 +1539,8 @@ int brcmf_bus_start(dhd_pub_t *drvr)
 {
 	int ret = -1;
 	dhd_info_t *drvr_priv = drvr->info;
-	char iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
-						 '\0' + bitvec  */
+	/* Room for "event_msgs" + '\0' + bitvec */
+	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];
 
 	ASSERT(drvr_priv);
 
@@ -1560,11 +1560,11 @@ int brcmf_bus_start(dhd_pub_t *drvr)
 		return -ENODEV;
 	}
 
-	brcmu_mkiovar("event_msgs", drvr->eventmask, WL_EVENTING_MASK_LEN,
+	brcmu_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_query_ioctl(drvr, 0, BRCMF_C_GET_VAR, iovbuf,
 				    sizeof(iovbuf));
-	memcpy(drvr->eventmask, iovbuf, WL_EVENTING_MASK_LEN);
+	memcpy(drvr->eventmask, iovbuf, BRCMF_EVENTING_MASK_LEN);
 
 	setbit(drvr->eventmask, BRCMF_E_SET_SSID);
 	setbit(drvr->eventmask, BRCMF_E_PRUNE);
@@ -1725,7 +1725,7 @@ void brcmf_detach(dhd_pub_t *drvr)
 					&drvr_priv->early_suspend);
 #endif				/* defined(CONFIG_HAS_EARLYSUSPEND) */
 
-			for (i = 1; i < DHD_MAX_IFS; i++)
+			for (i = 1; i < BRCMF_MAX_IFS; i++)
 				if (drvr_priv->iflist[i])
 					brcmf_del_if(drvr_priv, i);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index a4d30c7..8607972 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -404,7 +404,7 @@ struct rte_console {
 	(((prio) == PRIO_8021D_NONE || (prio) == PRIO_8021D_BE) ? \
 	((prio^2)) : (prio))
 
-DHD_SPINWAIT_SLEEP_INIT(sdioh_spinwait_sleep);
+BRCMF_SPINWAIT_SLEEP_INIT(sdioh_spinwait_sleep);
 
 /* Core reg address translation */
 #define CORE_CC_REG(base, field)	(base + offsetof(chipcregs_t, field))
@@ -940,7 +940,7 @@ static int brcmf_sdbrcm_htclk(dhd_bus_t *bus, bool on, bool pendok)
 
 		/* Otherwise, wait here (polling) for HT Avail */
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
-			SPINWAIT_SLEEP(sdioh_spinwait_sleep,
+			BRCMF_SPINWAIT_SLEEP(sdioh_spinwait_sleep,
 				       ((clkctl =
 					 brcmf_sdcard_cfg_read(sdh, SDIO_FUNC_1,
 						 SBSDIO_FUNC1_CHIPCLKCSR,
@@ -1403,7 +1403,8 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		else
 			bus->dhd->dstats.tx_bytes += datalen;
 
-		if ((bus->idletime == DHD_IDLE_IMMEDIATE) && !bus->dpc_sched) {
+		if (bus->idletime == BRCMF_IDLE_IMMEDIATE &&
+		    !bus->dpc_sched) {
 			bus->activity = false;
 			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 		}
@@ -1621,7 +1622,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		} while ((ret < 0) && retries++ < TXRETRIES);
 	}
 
-	if ((bus->idletime == DHD_IDLE_IMMEDIATE) && !bus->dpc_sched) {
+	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) && !bus->dpc_sched) {
 		bus->activity = false;
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
@@ -1752,7 +1753,7 @@ const struct brcmu_iovar dhdsdio_iovars[] = {
 	,
 	{"sbreg", IOV_SBREG, 0, IOVT_BUFFER, sizeof(struct brcmf_sdreg)}
 	,
-	{"sd_cis", IOV_SDCIS, 0, IOVT_BUFFER, DHD_IOCTL_MAXLEN}
+	{"sd_cis", IOV_SDCIS, 0, IOVT_BUFFER, BRCMF_IOCTL_MAXLEN}
 	,
 	{"forcealign", IOV_FORCEEVEN, 0, IOVT_BOOL, 0}
 	,
@@ -1909,7 +1910,7 @@ static int brcmf_sdbrcm_pktgen_get(dhd_bus_t *bus, u8 *arg)
 {
 	brcmf_pktgen_t pktgen;
 
-	pktgen.version = DHD_PKTGEN_VERSION;
+	pktgen.version = BRCMF_PKTGEN_VERSION;
 	pktgen.freq = bus->pktgen_freq;
 	pktgen.count = bus->pktgen_count;
 	pktgen.print = bus->pktgen_print;
@@ -1933,7 +1934,7 @@ static int brcmf_sdbrcm_pktgen_set(dhd_bus_t *bus, u8 *arg)
 	uint oldcnt, oldmode;
 
 	memcpy(&pktgen, arg, sizeof(pktgen));
-	if (pktgen.version != DHD_PKTGEN_VERSION)
+	if (pktgen.version != BRCMF_PKTGEN_VERSION)
 		return -EINVAL;
 
 	oldcnt = bus->pktgen_count;
@@ -2449,7 +2450,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 		break;
 
 	case IOV_SVAL(IOV_IDLETIME):
-		if ((int_val < 0) && (int_val != DHD_IDLE_IMMEDIATE))
+		if ((int_val < 0) && (int_val != BRCMF_IDLE_IMMEDIATE))
 			bcmerror = -EINVAL;
 		else
 			bus->idletime = int_val;
@@ -2793,7 +2794,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 	}
 
 exit:
-	if ((bus->idletime == DHD_IDLE_IMMEDIATE) && !bus->dpc_sched) {
+	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) && !bus->dpc_sched) {
 		bus->activity = false;
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
@@ -2998,7 +2999,8 @@ brcmf_sdbrcm_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 		}
 		bus->roundup = min(max_roundup, bus->blocksize);
 
-		if ((bus->idletime == DHD_IDLE_IMMEDIATE) && !bus->dpc_sched) {
+		if (bus->idletime == BRCMF_IDLE_IMMEDIATE &&
+		    !bus->dpc_sched) {
 			bus->activity = false;
 			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 		}
@@ -3859,7 +3861,7 @@ brcmf_sdbrcm_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 #ifdef SDTEST
 	/* Allow pktgen to override maxframes */
-	if (bus->pktgen_count && (bus->pktgen_mode == DHD_PKTGEN_RECV)) {
+	if (bus->pktgen_count && (bus->pktgen_mode == BRCMF_PKTGEN_RECV)) {
 		maxframes = bus->pktgen_count;
 		sdtest = true;
 	}
@@ -4738,7 +4740,7 @@ clkwait:
 
 	/* If we're done for now, turn off clock request. */
 	if ((bus->clkstate != CLK_PENDING)
-	    && bus->idletime == DHD_IDLE_IMMEDIATE) {
+	    && bus->idletime == BRCMF_IDLE_IMMEDIATE) {
 		bus->activity = false;
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 	}
@@ -4816,7 +4818,7 @@ static void brcmf_sdbrcm_pktgen_init(dhd_bus_t *bus)
 	bus->pktgen_count = (brcmf_pktgen * brcmf_watchdog_ms + 999) / 1000;
 
 	/* Default to echo mode */
-	bus->pktgen_mode = DHD_PKTGEN_ECHO;
+	bus->pktgen_mode = BRCMF_PKTGEN_ECHO;
 	bus->pktgen_stop = 1;
 }
 
@@ -4836,7 +4838,7 @@ static void brcmf_sdbrcm_pktgen(dhd_bus_t *bus)
 	}
 
 	/* For recv mode, just make sure dongle has started sending */
-	if (bus->pktgen_mode == DHD_PKTGEN_RECV) {
+	if (bus->pktgen_mode == BRCMF_PKTGEN_RECV) {
 		if (!bus->pktgen_rcvd)
 			brcmf_sdbrcm_sdtest_set(bus, true);
 		return;
@@ -4867,17 +4869,17 @@ static void brcmf_sdbrcm_pktgen(dhd_bus_t *bus)
 
 		/* Write test header cmd and extra based on mode */
 		switch (bus->pktgen_mode) {
-		case DHD_PKTGEN_ECHO:
+		case BRCMF_PKTGEN_ECHO:
 			*data++ = SDPCM_TEST_ECHOREQ;
 			*data++ = (u8) bus->pktgen_sent;
 			break;
 
-		case DHD_PKTGEN_SEND:
+		case BRCMF_PKTGEN_SEND:
 			*data++ = SDPCM_TEST_DISCARD;
 			*data++ = (u8) bus->pktgen_sent;
 			break;
 
-		case DHD_PKTGEN_RXBURST:
+		case BRCMF_PKTGEN_RXBURST:
 			*data++ = SDPCM_TEST_BURST;
 			*data++ = (u8) bus->pktgen_count;
 			break;
@@ -4923,7 +4925,7 @@ static void brcmf_sdbrcm_pktgen(dhd_bus_t *bus)
 			bus->pktgen_len = (u16) bus->pktgen_minlen;
 
 		/* Special case for burst mode: just send one request! */
-		if (bus->pktgen_mode == DHD_PKTGEN_RXBURST)
+		if (bus->pktgen_mode == BRCMF_PKTGEN_RXBURST)
 			break;
 	}
 }
@@ -5047,7 +5049,7 @@ brcmf_sdbrcm_checkdied(dhd_bus_t *bus, struct sk_buff *pkt, uint seq)
 	}
 
 	/* For recv mode, stop at limie (and tell dongle to stop sending) */
-	if (bus->pktgen_mode == DHD_PKTGEN_RECV) {
+	if (bus->pktgen_mode == BRCMF_PKTGEN_RECV) {
 		if (bus->pktgen_total
 		    && (bus->pktgen_rcvd >= bus->pktgen_total)) {
 			bus->pktgen_count = 0;
@@ -5209,7 +5211,7 @@ static int brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg,
 		brcmf_sdbrcm_txpkt(bus, pkt, SDPCM_EVENT_CHANNEL, true);
 
 done:
-	if ((bus->idletime == DHD_IDLE_IMMEDIATE) && !bus->dpc_sched) {
+	if ((bus->idletime == BRCMF_IDLE_IMMEDIATE) && !bus->dpc_sched) {
 		bus->activity = false;
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
@@ -5588,7 +5590,7 @@ static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh)
 	/* ...and initialize clock/power states */
 	bus->clkstate = CLK_SDONLY;
 	bus->idletime = (s32) brcmf_idletime;
-	bus->idleclock = DHD_IDLE_ACTIVE;
+	bus->idleclock = BRCMF_IDLE_ACTIVE;
 
 	/* Query the F2 block size, set roundup accordingly */
 	fnum = 2;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index aeb305c..2555838 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -636,7 +636,7 @@ wl_dev_iovar_getbuf(struct net_device *dev, s8 * iovar, void *param,
 static s32
 wl_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid, u16 action)
 {
-	s32 params_size = (WL_SCAN_PARAMS_FIXED_SIZE +
+	s32 params_size = (BRCMF_SCAN_PARAMS_FIXED_SIZE +
 				offsetof(struct brcmf_iscan_params, params));
 	struct brcmf_iscan_params *params;
 	s32 err = 0;
@@ -650,7 +650,7 @@ wl_run_iscan(struct wl_iscan_ctrl *iscan, struct brcmf_ssid *ssid, u16 action)
 
 	wl_iscan_prep(&params->params, ssid);
 
-	params->version = cpu_to_le32(ISCAN_REQ_VERSION);
+	params->version = cpu_to_le32(BRCMF_ISCAN_REQ_VERSION);
 	params->action = cpu_to_le16(action);
 	params->scan_duration = cpu_to_le16(0);
 
@@ -690,7 +690,7 @@ static s32 wl_do_iscan(struct wl_priv *wl)
 	}
 	wl_set_mpc(ndev, 0);
 	wl->iscan_kickstart = true;
-	wl_run_iscan(iscan, &ssid, WL_SCAN_ACTION_START);
+	wl_run_iscan(iscan, &ssid, BRCMF_SCAN_ACTION_START);
 	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
 	iscan->timer_on = 1;
 
@@ -1025,8 +1025,8 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	/* BSSID */
 	if (params->bssid) {
 		memcpy(join_params.params.bssid, params->bssid, ETH_ALEN);
-		join_params_size =
-			sizeof(join_params.ssid) + WL_ASSOC_PARAMS_FIXED_SIZE;
+		join_params_size = sizeof(join_params.ssid) +
+					BRCMF_ASSOC_PARAMS_FIXED_SIZE;
 	} else {
 		memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
 	}
@@ -1301,7 +1301,7 @@ wl_set_set_sharedkey(struct net_device *dev,
 				return -EINVAL;
 			}
 			memcpy(key.data, sme->key, key.len);
-			key.flags = WL_PRIMARY_KEY;
+			key.flags = BRCMF_PRIMARY_KEY;
 			switch (sec->cipher_pairwise) {
 			case WLAN_CIPHER_SUITE_WEP40:
 				key.algo = CRYPTO_ALGO_WEP1;
@@ -1693,7 +1693,7 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 	}
 	memcpy(key.data, params->key, key.len);
 
-	key.flags = WL_PRIMARY_KEY;
+	key.flags = BRCMF_PRIMARY_KEY;
 	switch (params->cipher) {
 	case WLAN_CIPHER_SUITE_WEP40:
 		key.algo = CRYPTO_ALGO_WEP1;
@@ -1770,7 +1770,7 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	memset(&key, 0, sizeof(key));
 
 	key.index = (u32) key_idx;
-	key.flags = WL_PRIMARY_KEY;
+	key.flags = BRCMF_PRIMARY_KEY;
 	key.algo = CRYPTO_ALGO_OFF;
 
 	WL_CONN("key index (%d)\n", key_idx);
@@ -2386,7 +2386,7 @@ static s32 wl_inform_bss(struct wl_priv *wl)
 	int i;
 
 	bss_list = wl->bss_list;
-	if (unlikely(bss_list->version != WL_BSS_INFO_VERSION)) {
+	if (unlikely(bss_list->version != BRCMF_BSS_INFO_VERSION)) {
 		WL_ERR("Version %d != WL_BSS_INFO_VERSION\n",
 		       bss_list->version);
 		return -EOPNOTSUPP;
@@ -2761,7 +2761,7 @@ static void wl_ch_to_chanspec(int ch, struct brcmf_join_params *join_params,
 		chanspec |= WL_CHANSPEC_BW_20;
 		chanspec |= WL_CHANSPEC_CTL_SB_NONE;
 
-		*join_params_size += WL_ASSOC_PARAMS_FIXED_SIZE +
+		*join_params_size += BRCMF_ASSOC_PARAMS_FIXED_SIZE +
 			join_params->params.chanspec_num * sizeof(chanspec_t);
 
 		join_params->params.chanspec_list[0] &= WL_CHANSPEC_CHAN_MASK;
@@ -3221,7 +3221,7 @@ static s32 wl_iscan_inprogress(struct wl_priv *wl)
 
 	rtnl_lock();
 	wl_inform_bss(wl);
-	wl_run_iscan(iscan, NULL, WL_SCAN_ACTION_CONTINUE);
+	wl_run_iscan(iscan, NULL, BRCMF_SCAN_ACTION_CONTINUE);
 	rtnl_unlock();
 	/* Reschedule the timer */
 	mod_timer(&iscan->timer, jiffies + iscan->timer_ms * HZ / 1000);
@@ -3254,7 +3254,7 @@ static s32 wl_iscan_thread(void *data)
 
 	sched_setscheduler(current, SCHED_FIFO, &param);
 	allow_signal(SIGTERM);
-	status = WL_SCAN_RESULTS_PARTIAL;
+	status = BRCMF_SCAN_RESULTS_PARTIAL;
 	while (likely(!down_interruptible(&iscan->sync))) {
 		if (kthread_should_stop())
 			break;
@@ -3265,7 +3265,7 @@ static s32 wl_iscan_thread(void *data)
 		rtnl_lock();
 		err = wl_get_iscan_results(iscan, &status, &wl->bss_list);
 		if (unlikely(err)) {
-			status = WL_SCAN_RESULTS_ABORTED;
+			status = BRCMF_SCAN_RESULTS_ABORTED;
 			WL_ERR("Abort iscan\n");
 		}
 		rtnl_unlock();
@@ -3313,11 +3313,11 @@ static s32 wl_invoke_iscan(struct wl_priv *wl)
 static void wl_init_iscan_eloop(struct wl_iscan_eloop *el)
 {
 	memset(el, 0, sizeof(*el));
-	el->handler[WL_SCAN_RESULTS_SUCCESS] = wl_iscan_done;
-	el->handler[WL_SCAN_RESULTS_PARTIAL] = wl_iscan_inprogress;
-	el->handler[WL_SCAN_RESULTS_PENDING] = wl_iscan_pending;
-	el->handler[WL_SCAN_RESULTS_ABORTED] = wl_iscan_aborted;
-	el->handler[WL_SCAN_RESULTS_NO_MEM] = wl_iscan_aborted;
+	el->handler[BRCMF_SCAN_RESULTS_SUCCESS] = wl_iscan_done;
+	el->handler[BRCMF_SCAN_RESULTS_PARTIAL] = wl_iscan_inprogress;
+	el->handler[BRCMF_SCAN_RESULTS_PENDING] = wl_iscan_pending;
+	el->handler[BRCMF_SCAN_RESULTS_ABORTED] = wl_iscan_aborted;
+	el->handler[BRCMF_SCAN_RESULTS_NO_MEM] = wl_iscan_aborted;
 }
 
 static s32 wl_init_iscan(struct wl_priv *wl)
@@ -3613,22 +3613,22 @@ static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype)
 
 static s32 wl_dongle_eventmsg(struct net_device *ndev)
 {
-	s8 iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
-						 '\0' + bitvec  */
-	s8 eventmask[WL_EVENTING_MASK_LEN];
+	/* Room for "event_msgs" + '\0' + bitvec */
+	s8 iovbuf[BRCMF_EVENTING_MASK_LEN + 12];
+	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
 	s32 err = 0;
 
 	WL_TRACE("Enter\n");
 
 	/* Setup event_msgs */
-	brcmu_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
+	brcmu_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
 		WL_ERR("Get event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
 	}
-	memcpy(eventmask, iovbuf, WL_EVENTING_MASK_LEN);
+	memcpy(eventmask, iovbuf, BRCMF_EVENTING_MASK_LEN);
 
 	setbit(eventmask, BRCMF_E_SET_SSID);
 	setbit(eventmask, BRCMF_E_ROAM);
@@ -3650,7 +3650,7 @@ static s32 wl_dongle_eventmsg(struct net_device *ndev)
 	setbit(eventmask, BRCMF_E_JOIN_START);
 	setbit(eventmask, BRCMF_E_SCAN_COMPLETE);
 
-	brcmu_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
+	brcmu_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
 	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 3400cc9..e6df203 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -112,7 +112,7 @@ do {								\
 				 * to reduce iteration
 				 */
 #define WL_ISCAN_TIMER_INTERVAL_MS	3000
-#define WL_SCAN_ERSULTS_LAST	(WL_SCAN_RESULTS_NO_MEM+1)
+#define WL_SCAN_ERSULTS_LAST	(BRCMF_SCAN_RESULTS_NO_MEM+1)
 #define WL_AP_MAX	256	/* virtually unlimitted as long
 				 * as kernel memory allows
 				 */
-- 
1.7.1


