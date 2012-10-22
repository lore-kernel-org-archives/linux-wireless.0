Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2968 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755682Ab2JVRgh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:37 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 12/14] brcmfmac: use fwil for default configuration
 setup.
Date: Mon, 22 Oct 2012 10:36:25 -0700
Message-ID: <1350927387-25608-13-git-send-email-frankyl@broadcom.com> (sfid-20121022_193702_437523_42F20526)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

modify the setup code to use the refactored firmware interface layer.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   11 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |   26 --
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |  392 ++++++++------------
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   44 +--
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    8 +-
 5 files changed, 168 insertions(+), 313 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 51d7754..bde5e25 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -656,13 +656,6 @@ struct brcmf_pub {
 	int in_suspend;		/* flag set to 1 when early suspend called */
 	int dtim_skip;		/* dtim skip , default 0 means wake each dtim */
 
-	/* Pkt filter defination */
-	char *pktfilter[100];
-	int pktfilter_count;
-
-	u8 country_code[BRCM_CNTRY_BUF_SZ];
-	char eventmask[BRCMF_EVENTING_MASK_LEN];
-
 	struct brcmf_if *iflist[BRCMF_MAX_IFS];
 
 	struct mutex proto_block;
@@ -740,8 +733,4 @@ extern struct brcmf_if *brcmf_add_if(struct device *dev, int ifidx, s32 bssidx,
 				     char *name, u8 *mac_addr);
 extern void brcmf_del_if(struct brcmf_pub *drvr, int ifidx);
 
-extern void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg);
-extern void brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg,
-					     int enable, int master_mode);
-
 #endif				/* _BRCMF_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index b07a438..b9d8a5a 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -458,32 +458,6 @@ void brcmf_proto_detach(struct brcmf_pub *drvr)
 	drvr->prot = NULL;
 }
 
-int brcmf_proto_init(struct brcmf_pub *drvr)
-{
-	int ret = 0;
-	char buf[128];
-
-	brcmf_dbg(TRACE, "Enter\n");
-
-	mutex_lock(&drvr->proto_block);
-
-	/* Get the device MAC address */
-	strcpy(buf, "cur_etheraddr");
-	ret = brcmf_proto_cdc_query_dcmd(drvr, 0, BRCMF_C_GET_VAR,
-					  buf, sizeof(buf));
-	if (ret < 0) {
-		mutex_unlock(&drvr->proto_block);
-		return ret;
-	}
-	memcpy(drvr->mac, buf, ETH_ALEN);
-
-	mutex_unlock(&drvr->proto_block);
-
-	ret = brcmf_c_preinit_dcmds(drvr);
-
-	return ret;
-}
-
 void brcmf_proto_stop(struct brcmf_pub *drvr)
 {
 	/* Nothing to do for CDC */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 28b3eed..aa8b5e0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -28,12 +28,17 @@
 #include "dhd_bus.h"
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
+#include "fwil.h"
 
 #define BRCM_OUI			"\x00\x10\x18"
 #define DOT11_OUI_LEN			3
 #define BCMILCP_BCM_SUBTYPE_EVENT	1
-#define PKTFILTER_BUF_SIZE		2048
+#define PKTFILTER_BUF_SIZE		128
 #define BRCMF_ARPOL_MODE		0xb	/* agent|snoop|peer_autoreply */
+#define BRCMF_DEFAULT_BCN_TIMEOUT	3
+#define BRCMF_DEFAULT_SCAN_CHANNEL_TIME	40
+#define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
+#define BRCMF_DEFAULT_PACKET_FILTER	"100 0 0 0 0x01 0x00"
 
 #define MSGTRACE_VERSION	1
 
@@ -563,90 +568,57 @@ static int brcmf_c_pattern_atoh(char *src, char *dst)
 	return i;
 }
 
-void
-brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
-			     int master_mode)
+static void
+brcmf_c_pktfilter_offload_enable(struct brcmf_if *ifp, char *arg, int enable,
+				 int master_mode)
 {
 	unsigned long res;
-	char *argv[8];
-	int i = 0;
-	const char *str;
-	int buf_len;
-	int str_len;
+	char *argv;
 	char *arg_save = NULL, *arg_org = NULL;
-	int rc;
-	char buf[128];
+	s32 err;
 	struct brcmf_pkt_filter_enable_le enable_parm;
-	struct brcmf_pkt_filter_enable_le *pkt_filterp;
-	__le32 mmode_le;
 
-	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
+	arg_save = kstrdup(arg, GFP_ATOMIC);
 	if (!arg_save)
 		goto fail;
 
 	arg_org = arg_save;
-	memcpy(arg_save, arg, strlen(arg) + 1);
 
-	argv[i] = strsep(&arg_save, " ");
+	argv = strsep(&arg_save, " ");
 
-	i = 0;
-	if (NULL == argv[i]) {
+	if (argv == NULL) {
 		brcmf_dbg(ERROR, "No args provided\n");
 		goto fail;
 	}
 
-	str = "pkt_filter_enable";
-	str_len = strlen(str);
-	strncpy(buf, str, str_len);
-	buf[str_len] = '\0';
-	buf_len = str_len + 1;
-
-	pkt_filterp = (struct brcmf_pkt_filter_enable_le *) (buf + str_len + 1);
-
 	/* Parse packet filter id. */
 	enable_parm.id = 0;
-	if (!kstrtoul(argv[i], 0, &res))
+	if (!kstrtoul(argv, 0, &res))
 		enable_parm.id = cpu_to_le32((u32)res);
 
-	/* Parse enable/disable value. */
+	/* Enable/disable the specified filter. */
 	enable_parm.enable = cpu_to_le32(enable);
 
-	buf_len += sizeof(enable_parm);
-	memcpy((char *)pkt_filterp, &enable_parm, sizeof(enable_parm));
+	err = brcmf_fil_iovar_data_set(ifp, "pkt_filter_enable", &enable_parm,
+				       sizeof(enable_parm));
+	if (err)
+		brcmf_dbg(ERROR, "Set pkt_filter_enable error (%d)\n", err);
 
-	/* Enable/disable the specified filter. */
-	rc = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, buf, buf_len);
-	rc = rc >= 0 ? 0 : rc;
-	if (rc)
-		brcmf_dbg(TRACE, "failed to add pktfilter %s, retcode = %d\n",
-			  arg, rc);
-	else
-		brcmf_dbg(TRACE, "successfully added pktfilter %s\n", arg);
-
-	/* Contorl the master mode */
-	mmode_le = cpu_to_le32(master_mode);
-	brcmf_c_mkiovar("pkt_filter_mode", (char *)&mmode_le, 4, buf,
-		    sizeof(buf));
-	rc = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, buf,
-				       sizeof(buf));
-	rc = rc >= 0 ? 0 : rc;
-	if (rc)
-		brcmf_dbg(TRACE, "failed to add pktfilter %s, retcode = %d\n",
-			  arg, rc);
+	/* Control the master mode */
+	err = brcmf_fil_iovar_int_set(ifp, "pkt_filter_mode", master_mode);
+	if (err)
+		brcmf_dbg(ERROR, "Set pkt_filter_mode error (%d)\n", err);
 
 fail:
 	kfree(arg_org);
 }
 
-void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
+static void brcmf_c_pktfilter_offload_set(struct brcmf_if *ifp, char *arg)
 {
-	const char *str;
-	struct brcmf_pkt_filter_le pkt_filter;
-	struct brcmf_pkt_filter_le *pkt_filterp;
+	struct brcmf_pkt_filter_le *pkt_filter;
 	unsigned long res;
 	int buf_len;
-	int str_len;
-	int rc;
+	s32 err;
 	u32 mask_size;
 	u32 pattern_size;
 	char *argv[8], *buf = NULL;
@@ -664,104 +636,64 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 		goto fail;
 
 	argv[i] = strsep(&arg_save, " ");
-	while (argv[i++])
+	while (argv[i]) {
+		i++;
+		if (i >= 8) {
+			brcmf_dbg(ERROR, "Too many parameters\n");
+			goto fail;
+		}
 		argv[i] = strsep(&arg_save, " ");
+	}
 
-	i = 0;
-	if (NULL == argv[i]) {
-		brcmf_dbg(ERROR, "No args provided\n");
+	if (i != 6) {
+		brcmf_dbg(ERROR, "Not enough args provided %d\n", i);
 		goto fail;
 	}
 
-	str = "pkt_filter_add";
-	strcpy(buf, str);
-	str_len = strlen(str);
-	buf_len = str_len + 1;
-
-	pkt_filterp = (struct brcmf_pkt_filter_le *) (buf + str_len + 1);
+	pkt_filter = (struct brcmf_pkt_filter_le *)buf;
 
 	/* Parse packet filter id. */
-	pkt_filter.id = 0;
-	if (!kstrtoul(argv[i], 0, &res))
-		pkt_filter.id = cpu_to_le32((u32)res);
-
-	if (NULL == argv[++i]) {
-		brcmf_dbg(ERROR, "Polarity not provided\n");
-		goto fail;
-	}
+	pkt_filter->id = 0;
+	if (!kstrtoul(argv[0], 0, &res))
+		pkt_filter->id = cpu_to_le32((u32)res);
 
 	/* Parse filter polarity. */
-	pkt_filter.negate_match = 0;
-	if (!kstrtoul(argv[i], 0, &res))
-		pkt_filter.negate_match = cpu_to_le32((u32)res);
-
-	if (NULL == argv[++i]) {
-		brcmf_dbg(ERROR, "Filter type not provided\n");
-		goto fail;
-	}
+	pkt_filter->negate_match = 0;
+	if (!kstrtoul(argv[1], 0, &res))
+		pkt_filter->negate_match = cpu_to_le32((u32)res);
 
 	/* Parse filter type. */
-	pkt_filter.type = 0;
-	if (!kstrtoul(argv[i], 0, &res))
-		pkt_filter.type = cpu_to_le32((u32)res);
-
-	if (NULL == argv[++i]) {
-		brcmf_dbg(ERROR, "Offset not provided\n");
-		goto fail;
-	}
+	pkt_filter->type = 0;
+	if (!kstrtoul(argv[2], 0, &res))
+		pkt_filter->type = cpu_to_le32((u32)res);
 
 	/* Parse pattern filter offset. */
-	pkt_filter.u.pattern.offset = 0;
-	if (!kstrtoul(argv[i], 0, &res))
-		pkt_filter.u.pattern.offset = cpu_to_le32((u32)res);
-
-	if (NULL == argv[++i]) {
-		brcmf_dbg(ERROR, "Bitmask not provided\n");
-		goto fail;
-	}
+	pkt_filter->u.pattern.offset = 0;
+	if (!kstrtoul(argv[3], 0, &res))
+		pkt_filter->u.pattern.offset = cpu_to_le32((u32)res);
 
 	/* Parse pattern filter mask. */
-	mask_size =
-	    brcmf_c_pattern_atoh
-		   (argv[i], (char *)pkt_filterp->u.pattern.mask_and_pattern);
-
-	if (NULL == argv[++i]) {
-		brcmf_dbg(ERROR, "Pattern not provided\n");
-		goto fail;
-	}
+	mask_size = brcmf_c_pattern_atoh(argv[4],
+			(char *)pkt_filter->u.pattern.mask_and_pattern);
 
 	/* Parse pattern filter pattern. */
-	pattern_size =
-	    brcmf_c_pattern_atoh(argv[i],
-				   (char *)&pkt_filterp->u.pattern.
-				   mask_and_pattern[mask_size]);
+	pattern_size = brcmf_c_pattern_atoh(argv[5],
+		(char *)&pkt_filter->u.pattern.mask_and_pattern[mask_size]);
 
 	if (mask_size != pattern_size) {
 		brcmf_dbg(ERROR, "Mask and pattern not the same size\n");
 		goto fail;
 	}
 
-	pkt_filter.u.pattern.size_bytes = cpu_to_le32(mask_size);
-	buf_len += BRCMF_PKT_FILTER_FIXED_LEN;
-	buf_len += (BRCMF_PKT_FILTER_PATTERN_FIXED_LEN + 2 * mask_size);
+	pkt_filter->u.pattern.size_bytes = cpu_to_le32(mask_size);
+	buf_len = sizeof(*pkt_filter);
+	buf_len -= sizeof(pkt_filter->u.pattern.mask_and_pattern);
+	buf_len += mask_size + pattern_size;
 
-	/* Keep-alive attributes are set in local
-	 * variable (keep_alive_pkt), and
-	 ** then memcpy'ed into buffer (keep_alive_pktp) since there is no
-	 ** guarantee that the buffer is properly aligned.
-	 */
-	memcpy((char *)pkt_filterp,
-	       &pkt_filter,
-	       BRCMF_PKT_FILTER_FIXED_LEN + BRCMF_PKT_FILTER_PATTERN_FIXED_LEN);
-
-	rc = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, buf, buf_len);
-	rc = rc >= 0 ? 0 : rc;
-
-	if (rc)
-		brcmf_dbg(TRACE, "failed to add pktfilter %s, retcode = %d\n",
-			  arg, rc);
-	else
-		brcmf_dbg(TRACE, "successfully added pktfilter %s\n", arg);
+	err = brcmf_fil_iovar_data_set(ifp, "pkt_filter_add", pkt_filter,
+				       buf_len);
+	if (err)
+		brcmf_dbg(ERROR, "Set pkt_filter_add error (%d)\n", err);
 
 fail:
 	kfree(arg_org);
@@ -769,130 +701,126 @@ fail:
 	kfree(buf);
 }
 
-static void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
-{
-	char iovbuf[32];
-	int retcode;
-	__le32 arp_mode_le;
-
-	arp_mode_le = cpu_to_le32(arp_mode);
-	brcmf_c_mkiovar("arp_ol", (char *)&arp_mode_le, 4, iovbuf,
-			sizeof(iovbuf));
-	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
-				   iovbuf, sizeof(iovbuf));
-	retcode = retcode >= 0 ? 0 : retcode;
-	if (retcode)
-		brcmf_dbg(TRACE, "failed to set ARP offload mode to 0x%x, retcode = %d\n",
-			  arp_mode, retcode);
-	else
-		brcmf_dbg(TRACE, "successfully set ARP offload mode to 0x%x\n",
-			  arp_mode);
-}
-
-static void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
-{
-	char iovbuf[32];
-	int retcode;
-	__le32 arp_enable_le;
-
-	arp_enable_le = cpu_to_le32(arp_enable);
-
-	brcmf_c_mkiovar("arpoe", (char *)&arp_enable_le, 4,
-			iovbuf, sizeof(iovbuf));
-	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
-				   iovbuf, sizeof(iovbuf));
-	retcode = retcode >= 0 ? 0 : retcode;
-	if (retcode)
-		brcmf_dbg(TRACE, "failed to enable ARP offload to %d, retcode = %d\n",
-			  arp_enable, retcode);
-	else
-		brcmf_dbg(TRACE, "successfully enabled ARP offload to %d\n",
-			  arp_enable);
-}
-
-int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
+int brcmf_c_preinit_dcmds(struct brcmf_if *ifp)
 {
-	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];	/*  Room for
-				 "event_msgs" + '\0' + bitvec  */
-	char buf[128], *ptr;
-	__le32 roaming_le = cpu_to_le32(1);
-	__le32 bcn_timeout_le = cpu_to_le32(3);
-	__le32 scan_assoc_time_le = cpu_to_le32(40);
-	__le32 scan_unassoc_time_le = cpu_to_le32(40);
-	int i;
+	s8 eventmask[BRCMF_EVENTING_MASK_LEN];
+	u8 buf[BRCMF_DCMD_SMLEN];
+	char *ptr;
+	s32 err;
 	struct brcmf_bus_dcmd *cmdlst;
 	struct list_head *cur, *q;
 
-	mutex_lock(&drvr->proto_block);
-
-	/* Set Country code */
-	if (drvr->country_code[0] != 0) {
-		if (brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_COUNTRY,
-					      drvr->country_code,
-					      sizeof(drvr->country_code)) < 0)
-			brcmf_dbg(ERROR, "country code setting failed\n");
+	/* retreive mac address */
+	err = brcmf_fil_iovar_data_get(ifp, "cur_etheraddr", ifp->mac_addr,
+				       sizeof(ifp->mac_addr));
+	if (err < 0) {
+		brcmf_dbg(ERROR, "Retreiving cur_etheraddr failed, %d\n",
+			  err);
+		goto done;
 	}
+	memcpy(ifp->drvr->mac, ifp->mac_addr, sizeof(ifp->drvr->mac));
 
 	/* query for 'ver' to get version info from firmware */
 	memset(buf, 0, sizeof(buf));
-	ptr = buf;
-	brcmf_c_mkiovar("ver", NULL, 0, buf, sizeof(buf));
-	brcmf_proto_cdc_query_dcmd(drvr, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
+	strcpy(buf, "ver");
+	err = brcmf_fil_iovar_data_get(ifp, "ver", buf, sizeof(buf));
+	if (err < 0) {
+		brcmf_dbg(ERROR, "Retreiving version information failed, %d\n",
+			  err);
+		goto done;
+	}
+	ptr = (char *)buf;
 	strsep(&ptr, "\n");
 	/* Print fw version info */
 	brcmf_dbg(ERROR, "Firmware version = %s\n", buf);
 
-	/* Setup timeout if Beacons are lost and roam is off to report
-		 link down */
-	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout_le, 4, iovbuf,
-		    sizeof(iovbuf));
-	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
-				  sizeof(iovbuf));
+	/*
+	 * Setup timeout if Beacons are lost and roam is off to report
+	 * link down
+	 */
+	err = brcmf_fil_iovar_int_set(ifp, "bcn_timeout",
+				      BRCMF_DEFAULT_BCN_TIMEOUT);
+	if (err) {
+		brcmf_dbg(ERROR, "bcn_timeout error (%d)\n", err);
+		goto done;
+	}
 
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
-		 of romaing */
-	brcmf_c_mkiovar("roam_off", (char *)&roaming_le, 4,
-		      iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
-				  sizeof(iovbuf));
-
-	/* Setup event_msgs */
-	brcmf_c_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
-		      iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
-				  sizeof(iovbuf));
-
-	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
-		 (char *)&scan_assoc_time_le, sizeof(scan_assoc_time_le));
-	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
-		 (char *)&scan_unassoc_time_le, sizeof(scan_unassoc_time_le));
-
-	/* Set and enable ARP offload feature */
-	brcmf_c_arp_offload_set(drvr, BRCMF_ARPOL_MODE);
-	brcmf_c_arp_offload_enable(drvr, true);
-
-	/* Set up pkt filter */
-	for (i = 0; i < drvr->pktfilter_count; i++) {
-		brcmf_c_pktfilter_offload_set(drvr, drvr->pktfilter[i]);
-		brcmf_c_pktfilter_offload_enable(drvr, drvr->pktfilter[i],
-						 0, true);
+	 * of romaing
+	 */
+	err = brcmf_fil_iovar_int_set(ifp, "roam_off", 1);
+	if (err) {
+		brcmf_dbg(ERROR, "roam_off error (%d)\n", err);
+		goto done;
 	}
 
+	/* Setup event_msgs, enable E_IF */
+	err = brcmf_fil_iovar_data_get(ifp, "event_msgs", eventmask,
+				       BRCMF_EVENTING_MASK_LEN);
+	if (err) {
+		brcmf_dbg(ERROR, "Get event_msgs error (%d)\n", err);
+		goto done;
+	}
+	setbit(eventmask, BRCMF_E_IF);
+	err = brcmf_fil_iovar_data_set(ifp, "event_msgs", eventmask,
+				       BRCMF_EVENTING_MASK_LEN);
+	if (err) {
+		brcmf_dbg(ERROR, "Set event_msgs error (%d)\n", err);
+		goto done;
+	}
+
+	/* Setup default scan channel time */
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_CHANNEL_TIME,
+				    BRCMF_DEFAULT_SCAN_CHANNEL_TIME);
+	if (err) {
+		brcmf_dbg(ERROR, "BRCMF_C_SET_SCAN_CHANNEL_TIME error (%d)\n",
+			  err);
+		goto done;
+	}
+
+	/* Setup default scan unassoc time */
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_SCAN_UNASSOC_TIME,
+				    BRCMF_DEFAULT_SCAN_UNASSOC_TIME);
+	if (err) {
+		brcmf_dbg(ERROR, "BRCMF_C_SET_SCAN_UNASSOC_TIME error (%d)\n",
+			  err);
+		goto done;
+	}
+
+	/* Try to set and enable ARP offload feature, this may fail */
+	err = brcmf_fil_iovar_int_set(ifp, "arp_ol", BRCMF_ARPOL_MODE);
+	if (err) {
+		brcmf_dbg(TRACE, "failed to set ARP offload mode to 0x%x, err = %d\n",
+			  BRCMF_ARPOL_MODE, err);
+		err = 0;
+	} else {
+		err = brcmf_fil_iovar_int_set(ifp, "arpoe", 1);
+		if (err) {
+			brcmf_dbg(TRACE, "failed to enable ARP offload err = %d\n",
+				  err);
+			err = 0;
+		} else
+			brcmf_dbg(TRACE, "successfully enabled ARP offload to 0x%x\n",
+				  BRCMF_ARPOL_MODE);
+	}
+
+	/* Setup packet filter */
+	brcmf_c_pktfilter_offload_set(ifp, BRCMF_DEFAULT_PACKET_FILTER);
+	brcmf_c_pktfilter_offload_enable(ifp, BRCMF_DEFAULT_PACKET_FILTER,
+					 0, true);
+
 	/* set bus specific command if there is any */
-	list_for_each_safe(cur, q, &drvr->bus_if->dcmd_list) {
+	list_for_each_safe(cur, q, &ifp->drvr->bus_if->dcmd_list) {
 		cmdlst = list_entry(cur, struct brcmf_bus_dcmd, list);
 		if (cmdlst->name && cmdlst->param && cmdlst->param_len) {
-			brcmf_c_mkiovar(cmdlst->name, cmdlst->param,
-					cmdlst->param_len, iovbuf,
-					sizeof(iovbuf));
-			brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
-						 iovbuf, sizeof(iovbuf));
+			brcmf_fil_iovar_data_set(ifp, cmdlst->name,
+						 cmdlst->param,
+						 cmdlst->param_len);
 		}
 		list_del(cur);
 		kfree(cmdlst);
 	}
-
-	mutex_unlock(&drvr->proto_block);
-
-	return 0;
+done:
+	return err;
 }
+
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index b1f26b5..2976523 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -950,8 +950,6 @@ fail:
 int brcmf_bus_start(struct device *dev)
 {
 	int ret = -1;
-	/* Room for "event_msgs" + '\0' + bitvec */
-	char iovbuf[BRCMF_EVENTING_MASK_LEN + 12];
 	struct brcmf_bus *bus_if = dev_get_drvdata(dev);
 	struct brcmf_pub *drvr = bus_if->drvr;
 	struct brcmf_if *ifp;
@@ -965,43 +963,16 @@ int brcmf_bus_start(struct device *dev)
 		return ret;
 	}
 
-	brcmf_c_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
-		      iovbuf, sizeof(iovbuf));
-	brcmf_proto_cdc_query_dcmd(drvr, 0, BRCMF_C_GET_VAR, iovbuf,
-				    sizeof(iovbuf));
-	memcpy(drvr->eventmask, iovbuf, BRCMF_EVENTING_MASK_LEN);
-
-	setbit(drvr->eventmask, BRCMF_E_SET_SSID);
-	setbit(drvr->eventmask, BRCMF_E_PRUNE);
-	setbit(drvr->eventmask, BRCMF_E_AUTH);
-	setbit(drvr->eventmask, BRCMF_E_REASSOC);
-	setbit(drvr->eventmask, BRCMF_E_REASSOC_IND);
-	setbit(drvr->eventmask, BRCMF_E_DEAUTH_IND);
-	setbit(drvr->eventmask, BRCMF_E_DISASSOC_IND);
-	setbit(drvr->eventmask, BRCMF_E_DISASSOC);
-	setbit(drvr->eventmask, BRCMF_E_JOIN);
-	setbit(drvr->eventmask, BRCMF_E_ASSOC_IND);
-	setbit(drvr->eventmask, BRCMF_E_PSK_SUP);
-	setbit(drvr->eventmask, BRCMF_E_LINK);
-	setbit(drvr->eventmask, BRCMF_E_NDIS_LINK);
-	setbit(drvr->eventmask, BRCMF_E_MIC_ERROR);
-	setbit(drvr->eventmask, BRCMF_E_PMKID_CACHE);
-	setbit(drvr->eventmask, BRCMF_E_TXFAIL);
-	setbit(drvr->eventmask, BRCMF_E_JOIN_START);
-	setbit(drvr->eventmask, BRCMF_E_SCAN_COMPLETE);
-	setbit(drvr->eventmask, BRCMF_E_IF);
-
-	/* Setup filter to allow only unicast */
-	drvr->pktfilter_count = 1;
-	drvr->pktfilter[0] = "100 0 0 0 0x01 0x00";
-
 	/* add primary networking interface */
-	ifp = brcmf_add_if(dev, 0, 0, "wlan%d", drvr->mac);
+	ifp = brcmf_add_if(dev, 0, 0, "wlan%d", NULL);
 	if (IS_ERR(ifp))
 		return PTR_ERR(ifp);
 
-	/* Bus is ready, do any protocol initialization */
-	ret = brcmf_proto_init(drvr);
+	/* signal bus ready */
+	bus_if->state = BRCMF_BUS_DATA;
+
+	/* Bus is ready, do any initialization */
+	ret = brcmf_c_preinit_dcmds(ifp);
 	if (ret < 0)
 		return ret;
 
@@ -1016,9 +987,6 @@ int brcmf_bus_start(struct device *dev)
 		return ret;
 	}
 
-
-	/* signal bus ready */
-	bus_if->state = BRCMF_BUS_DATA;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
index f3e72de..7fe6779 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
@@ -27,11 +27,6 @@ extern int brcmf_proto_attach(struct brcmf_pub *drvr);
 /* Unlink, frees allocated protocol memory (including brcmf_proto) */
 extern void brcmf_proto_detach(struct brcmf_pub *drvr);
 
-/* Initialize protocol: sync w/dongle state.
- * Sets dongle media info (drv_version, mac address).
- */
-extern int brcmf_proto_init(struct brcmf_pub *drvr);
-
 /* Stop protocol: sync w/dongle state. */
 extern void brcmf_proto_stop(struct brcmf_pub *drvr);
 
@@ -45,7 +40,8 @@ extern void brcmf_proto_hdrpush(struct brcmf_pub *, int ifidx,
 extern int brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx,
 				struct brcmf_dcmd *dcmd, int len);
 
-extern int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr);
+/* Sets dongle media info (drv_version, mac address). */
+extern int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
 
 extern int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx,
 				     uint cmd, void *buf, uint len);
-- 
1.7.6


