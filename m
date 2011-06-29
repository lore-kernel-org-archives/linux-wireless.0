Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4529 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757681Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 040/119] staging: brcm80211: rename ioctl command codes
 in dhd.h
Date: Wed, 29 Jun 2011 16:47:04 -0700
Message-ID: <1309391303-22741-41-git-send-email-frankyl@broadcom.com> (sfid-20110630_014928_209302_CEE57871)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The naming convention in the driver is to be aligned. This commit
changes the prefix used for the ioctl command codes.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |   96 +++++++++---------
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c     |   20 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |   58 ++++++------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   39 ++++----
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  118 +++++++++++-----------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h |    4 +-
 6 files changed, 171 insertions(+), 164 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index b16ffc2..14713f5 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -26,50 +26,54 @@ struct dhd_bus;
 struct dhd_prot;
 struct dhd_info;
 
-#define WLC_UP					2
-#define WLC_SET_PROMISC				10
-#define WLC_GET_RATE				12
-#define WLC_GET_INFRA				19
-#define WLC_SET_INFRA				20
-#define WLC_GET_AUTH				21
-#define WLC_SET_AUTH				22
-#define WLC_GET_BSSID				23
-#define WLC_GET_SSID				25
-#define WLC_SET_SSID				26
-#define WLC_GET_CHANNEL				29
-#define WLC_GET_SRL				31
-#define WLC_GET_LRL				33
-#define WLC_GET_RADIO				37
-#define WLC_SET_RADIO				38
-#define WLC_GET_PHYTYPE				39
-#define WLC_SET_KEY				45
-#define WLC_SET_PASSIVE_SCAN			49
-#define WLC_SCAN				50
-#define WLC_SCAN_RESULTS			51
-#define WLC_DISASSOC				52
-#define WLC_REASSOC				53
-#define WLC_SET_ROAM_TRIGGER			55
-#define WLC_SET_ROAM_DELTA			57
-#define WLC_GET_DTIMPRD				77
-#define WLC_SET_COUNTRY				84
-#define WLC_GET_PM				85
-#define WLC_SET_PM				86
-#define WLC_GET_AP				117
-#define WLC_SET_AP				118
-#define WLC_GET_RSSI				127
-#define WLC_GET_WSEC				133
-#define WLC_SET_WSEC				134
-#define WLC_GET_PHY_NOISE			135
-#define WLC_GET_BSS_INFO			136
-#define WLC_SET_SCAN_CHANNEL_TIME		185
-#define WLC_SET_SCAN_UNASSOC_TIME		187
-#define WLC_SCB_DEAUTHENTICATE_FOR_REASON	201
-#define WLC_GET_VALID_CHANNELS			217
-#define WLC_GET_KEY_PRIMARY			235
-#define WLC_SET_KEY_PRIMARY			236
-#define WLC_SET_SCAN_PASSIVE_TIME		258
-#define WLC_GET_VAR				262	/* get value of named variable */
-#define WLC_SET_VAR				263	/* set named variable to value */
+#define	BRCMF_C_IOCTL_SMLEN	256	/* "small" ioctl buffer required */
+#define BRCMF_C_IOCTL_MEDLEN	1536	/* "med" ioctl buffer required */
+#define	BRCMF_C_IOCTL_MAXLEN	8192
+
+#define BRCMF_C_UP				2
+#define BRCMF_C_SET_PROMISC			10
+#define BRCMF_C_GET_RATE			12
+#define BRCMF_C_GET_INFRA			19
+#define BRCMF_C_SET_INFRA			20
+#define BRCMF_C_GET_AUTH			21
+#define BRCMF_C_SET_AUTH			22
+#define BRCMF_C_GET_BSSID			23
+#define BRCMF_C_GET_SSID			25
+#define BRCMF_C_SET_SSID			26
+#define BRCMF_C_GET_CHANNEL			29
+#define BRCMF_C_GET_SRL				31
+#define BRCMF_C_GET_LRL				33
+#define BRCMF_C_GET_RADIO			37
+#define BRCMF_C_SET_RADIO			38
+#define BRCMF_C_GET_PHYTYPE			39
+#define BRCMF_C_SET_KEY				45
+#define BRCMF_C_SET_PASSIVE_SCAN		49
+#define BRCMF_C_SCAN				50
+#define BRCMF_C_SCAN_RESULTS			51
+#define BRCMF_C_DISASSOC			52
+#define BRCMF_C_REASSOC				53
+#define BRCMF_C_SET_ROAM_TRIGGER		55
+#define BRCMF_C_SET_ROAM_DELTA			57
+#define BRCMF_C_GET_DTIMPRD			77
+#define BRCMF_C_SET_COUNTRY			84
+#define BRCMF_C_GET_PM				85
+#define BRCMF_C_SET_PM				86
+#define BRCMF_C_GET_AP				117
+#define BRCMF_C_SET_AP				118
+#define BRCMF_C_GET_RSSI			127
+#define BRCMF_C_GET_WSEC			133
+#define BRCMF_C_SET_WSEC			134
+#define BRCMF_C_GET_PHY_NOISE			135
+#define BRCMF_C_GET_BSS_INFO			136
+#define BRCMF_C_SET_SCAN_CHANNEL_TIME		185
+#define BRCMF_C_SET_SCAN_UNASSOC_TIME		187
+#define BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON	201
+#define BRCMF_C_GET_VALID_CHANNELS		217
+#define BRCMF_C_GET_KEY_PRIMARY			235
+#define BRCMF_C_SET_KEY_PRIMARY			236
+#define BRCMF_C_SET_SCAN_PASSIVE_TIME		258
+#define BRCMF_C_GET_VAR				262
+#define BRCMF_C_SET_VAR				263
 
 /* phy types (returned by WLC_GET_PHYTPE) */
 #define	WLC_PHY_TYPE_A		0
@@ -154,10 +158,6 @@ struct dhd_info;
 #define WL_KF_RES_5	(1 << 5)	/* Reserved for backward compat */
 #define WL_IBSS_PEER_GROUP_KEY	(1 << 6)	/* Indicates a group key for a IBSS PEER */
 
-#define	WLC_IOCTL_SMLEN			256	/* "small" length ioctl buffer required */
-#define WLC_IOCTL_MEDLEN		1536	/* "med" length ioctl buffer required */
-#define	WLC_IOCTL_MAXLEN	8192
-
 #define DHD_IF_VIF	0x01	/* Virtual IF (Hidden from user) */
 
 /* optionally set by a module_param_string() */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index af78764..0ed62a0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -109,7 +109,7 @@ typedef struct dhd_prot {
 	u32 lastcmd;
 	u8 bus_header[BUS_HEADER_LEN];
 	struct cdc_ioctl msg;
-	unsigned char buf[WLC_IOCTL_MAXLEN + ROUND_UP_MARGIN];
+	unsigned char buf[BRCMF_C_IOCTL_MAXLEN + ROUND_UP_MARGIN];
 } dhd_prot_t;
 
 static int dhdcdc_msg(dhd_pub_t *dhd)
@@ -162,7 +162,7 @@ dhdcdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 	DHD_CTL(("%s: cmd %d len %d\n", __func__, cmd, len));
 
 	/* Respond "bcmerror" and "bcmerrorstr" with local cache */
-	if (cmd == WLC_GET_VAR && buf) {
+	if (cmd == BRCMF_C_GET_VAR && buf) {
 		if (!strcmp((char *)buf, "bcmerrorstr")) {
 			strncpy((char *)buf, "bcm_error",
 				BCME_STRLEN);
@@ -296,9 +296,9 @@ dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf, int len)
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	ASSERT(len <= WLC_IOCTL_MAXLEN);
+	ASSERT(len <= BRCMF_C_IOCTL_MAXLEN);
 
-	if (len > WLC_IOCTL_MAXLEN)
+	if (len > BRCMF_C_IOCTL_MAXLEN)
 		goto done;
 
 	if (prot->pending == true) {
@@ -306,7 +306,8 @@ dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf, int len)
 			"lastcmd=0x%x (%lu)\n",
 			ioc->cmd, (unsigned long)ioc->cmd, prot->lastcmd,
 			(unsigned long)prot->lastcmd));
-		if ((ioc->cmd == WLC_SET_VAR) || (ioc->cmd == WLC_GET_VAR))
+		if ((ioc->cmd == BRCMF_C_SET_VAR) ||
+		    (ioc->cmd == BRCMF_C_GET_VAR))
 			DHD_TRACE(("iovar cmd=%s\n", (char *)buf));
 
 		goto done;
@@ -332,7 +333,8 @@ dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf, int len)
 	}
 
 	/* Intercept the wme_dp ioctl here */
-	if ((!ret) && (ioc->cmd == WLC_SET_VAR) && (!strcmp(buf, "wme_dp"))) {
+	if (!ret && ioc->cmd == BRCMF_C_SET_VAR &&
+	    !strcmp(buf, "wme_dp")) {
 		int slen, val = 0;
 
 		slen = strlen("wme_dp") + 1;
@@ -464,8 +466,8 @@ int dhd_prot_attach(dhd_pub_t *dhd)
 #ifdef BDC
 	dhd->hdrlen += BDC_HEADER_LEN;
 #endif
-	dhd->maxctl =
-		WLC_IOCTL_MAXLEN + sizeof(struct cdc_ioctl) + ROUND_UP_MARGIN;
+	dhd->maxctl = BRCMF_C_IOCTL_MAXLEN +
+				sizeof(struct cdc_ioctl) + ROUND_UP_MARGIN;
 	return 0;
 
 fail:
@@ -503,7 +505,7 @@ int dhd_prot_init(dhd_pub_t *dhd)
 
 	/* Get the device MAC address */
 	strcpy(buf, "cur_etheraddr");
-	ret = dhdcdc_query_ioctl(dhd, 0, WLC_GET_VAR, buf, sizeof(buf));
+	ret = dhdcdc_query_ioctl(dhd, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
 	if (ret < 0) {
 		dhd_os_proto_unblock(dhd);
 		return ret;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 849203c..4318bed 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -997,7 +997,7 @@ brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 	memcpy((char *)pkt_filterp, &enable_parm, sizeof(enable_parm));
 
 	/* Enable/disable the specified filter. */
-	rc = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, buf_len);
+	rc = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
 		DHD_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
@@ -1009,7 +1009,7 @@ brcmf_c_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 	/* Contorl the master mode */
 	brcmu_mkiovar("pkt_filter_mode", (char *)&master_mode, 4, buf,
 		    sizeof(buf));
-	rc = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, sizeof(buf));
+	rc = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf, sizeof(buf));
 	rc = rc >= 0 ? 0 : rc;
 	if (rc)
 		DHD_TRACE(("%s: failed to add pktfilter %s, retcode = %d\n",
@@ -1140,7 +1140,7 @@ void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	       &pkt_filter,
 	       WL_PKT_FILTER_FIXED_LEN + WL_PKT_FILTER_PATTERN_FIXED_LEN);
 
-	rc = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, buf_len);
+	rc = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, buf, buf_len);
 	rc = rc >= 0 ? 0 : rc;
 
 	if (rc)
@@ -1162,8 +1162,8 @@ void brcmf_c_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
 	int retcode;
 
 	brcmu_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
-	retcode = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
-				       sizeof(iovbuf));
+	retcode = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
 		DHD_TRACE(("%s: failed to set ARP offload mode to 0x%x, "
@@ -1179,8 +1179,8 @@ void brcmf_c_arp_offload_enable(dhd_pub_t *dhd, int arp_enable)
 	int retcode;
 
 	brcmu_mkiovar("arpoe", (char *)&arp_enable, 4, iovbuf, sizeof(iovbuf));
-	retcode = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
-				       sizeof(iovbuf));
+	retcode = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
 	if (retcode)
 		DHD_TRACE(("%s: failed to enabe ARP offload to %d, "
@@ -1220,8 +1220,8 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	if (!ret) {
 		brcmu_mkiovar("cur_etheraddr", (void *)ea_addr, ETH_ALEN,
 			    buf, sizeof(buf));
-		ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf,
-					   sizeof(buf));
+		ret = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR,
+				       buf, sizeof(buf));
 		if (ret < 0) {
 			DHD_ERROR(("%s: can't set MAC address , error=%d\n",
 				   __func__, ret));
@@ -1233,7 +1233,7 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 
 	/* Set Country code */
 	if (dhd->country_code[0] != 0) {
-		if (dhdcdc_set_ioctl(dhd, 0, WLC_SET_COUNTRY,
+		if (dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_COUNTRY,
 				     dhd->country_code,
 				     sizeof(dhd->country_code)) < 0) {
 			DHD_ERROR(("%s: country code setting failed\n",
@@ -1245,47 +1245,47 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	memset(buf, 0, sizeof(buf));
 	ptr = buf;
 	brcmu_mkiovar("ver", 0, 0, buf, sizeof(buf));
-	dhdcdc_query_ioctl(dhd, 0, WLC_GET_VAR, buf, sizeof(buf));
+	dhdcdc_query_ioctl(dhd, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
 	strsep(&ptr, "\n");
 	/* Print fw version info */
 	DHD_ERROR(("Firmware version = %s\n", buf));
 
 	/* Set PowerSave mode */
-	dhdcdc_set_ioctl(dhd, 0, WLC_SET_PM, (char *)&power_mode,
+	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM, (char *)&power_mode,
 			 sizeof(power_mode));
 
 	/* Match Host and Dongle rx alignment */
 	brcmu_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
 		    sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 
 	/* disable glom option per default */
 	brcmu_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 
 	/* Setup timeout if Beacons are lost and roam is off to report
 		 link down */
 	brcmu_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
 		    sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
 		 of romaing */
 	brcmu_mkiovar("roam_off", (char *)&dhd_roam, 4, iovbuf, sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 
 	/* Force STA UP */
 	if (dhd_radio_up)
-		dhdcdc_set_ioctl(dhd, 0, WLC_UP, (char *)&up, sizeof(up));
+		dhdcdc_set_ioctl(dhd, 0, BRCMF_C_UP, (char *)&up, sizeof(up));
 
 	/* Setup event_msgs */
 	brcmu_mkiovar("event_msgs", dhd->eventmask, WL_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 
-	dhdcdc_set_ioctl(dhd, 0, WLC_SET_SCAN_CHANNEL_TIME,
+	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_SCAN_CHANNEL_TIME,
 			 (char *)&scan_assoc_time, sizeof(scan_assoc_time));
-	dhdcdc_set_ioctl(dhd, 0, WLC_SET_SCAN_UNASSOC_TIME,
+	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_SCAN_UNASSOC_TIME,
 			 (char *)&scan_unassoc_time, sizeof(scan_unassoc_time));
 
 #ifdef ARP_OFFLOAD_SUPPORT
@@ -1626,7 +1626,7 @@ int dhd_iscan_request(void *dhdp, u16 action)
 	int rc;
 	wl_iscan_params_t params;
 	dhd_pub_t *dhd = dhd_bus_pub(dhdp);
-	char buf[WLC_IOCTL_SMLEN];
+	char buf[BRCMF_C_IOCTL_SMLEN];
 
 	memset(&params, 0, sizeof(wl_iscan_params_t));
 	memcpy(&params.params.bssid, &ether_bcast, ETH_ALEN);
@@ -1645,8 +1645,8 @@ int dhd_iscan_request(void *dhdp, u16 action)
 	params.scan_duration = 0;
 
 	brcmu_mkiovar("iscan", (char *)&params, sizeof(wl_iscan_params_t), buf,
-		    WLC_IOCTL_SMLEN);
-	rc = dhd_wl_ioctl(dhdp, WLC_SET_VAR, buf, WLC_IOCTL_SMLEN);
+		    BRCMF_C_IOCTL_SMLEN);
+	rc = dhd_wl_ioctl(dhdp, BRCMF_C_SET_VAR, buf, BRCMF_C_IOCTL_SMLEN);
 
 	return rc;
 }
@@ -1683,7 +1683,7 @@ static int dhd_iscan_get_partial_result(void *dhdp, uint *scan_count)
 	brcmu_mkiovar("iscanresults", (char *)&list,
 		      WL_ISCAN_RESULTS_FIXED_SIZE,
 		      iscan_cur->iscan_buf, WLC_IW_ISCAN_MAXLEN);
-	rc = dhd_wl_ioctl(dhdp, WLC_GET_VAR, iscan_cur->iscan_buf,
+	rc = dhd_wl_ioctl(dhdp, BRCMF_C_GET_VAR, iscan_cur->iscan_buf,
 			  WLC_IW_ISCAN_MAXLEN);
 
 	results->buflen = results->buflen;
@@ -1714,13 +1714,13 @@ int dhd_pno_clean(dhd_pub_t *dhd)
 	/* Disable pfn */
 	iov_len = brcmu_mkiovar("pfn", (char *)&pfn_enabled, 4, iovbuf,
 				sizeof(iovbuf));
-	ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	ret = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (ret >= 0) {
 		/* clear pfn */
 		iov_len = brcmu_mkiovar("pfnclear", 0, 0, iovbuf,
 					sizeof(iovbuf));
 		if (iov_len) {
-			ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
+			ret = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
 					iov_len);
 			if (ret < 0) {
 				DHD_ERROR(("%s failed code %d\n", __func__,
@@ -1750,7 +1750,7 @@ int dhd_pno_enable(dhd_pub_t *dhd, int pfn_enabled)
 	ret = brcmu_mkiovar("pfn", (char *)&pfn_enabled, 4, iovbuf,
 			sizeof(iovbuf));
 	if (ret > 0) {
-		ret = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
+		ret = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
 				sizeof(iovbuf));
 		if (ret < 0) {
 			DHD_ERROR(("%s failed for error=%d\n", __func__, ret));
@@ -1822,7 +1822,7 @@ dhd_pno_set(dhd_pub_t *dhd, wlc_ssid_t *ssids_local, int nssid, unsigned char sc
 
 	brcmu_mkiovar("pfn_set", (char *)&pfn_param, sizeof(pfn_param), iovbuf,
 		    sizeof(iovbuf));
-	dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 
 	/* set all pfn ssid */
 	for (i = 0; i < nssid; i++) {
@@ -1840,7 +1840,7 @@ dhd_pno_set(dhd_pub_t *dhd, wlc_ssid_t *ssids_local, int nssid, unsigned char sc
 		err = brcmu_mkiovar("pfn_add", (char *)&pfn_element,
 				sizeof(pfn_element), iovbuf, sizeof(iovbuf));
 		if (err > 0) {
-			err = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
+			err = dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
 					sizeof(iovbuf));
 			if (err < 0) {
 				DHD_ERROR(("%s failed for i=%d error=%d\n",
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index da39948..0ab95b3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -417,7 +417,7 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 			DHD_TRACE(("%s: force extra Suspend setting\n",
 				   __func__));
 
-			dhdcdc_set_ioctl(dhd, 0, WLC_SET_PM,
+			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM,
 					 (char *)&power_mode,
 					 sizeof(power_mode));
 
@@ -437,7 +437,7 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 				bcn_li_dtim = dhd->dtim_skip;
 			brcmu_mkiovar("bcn_li_dtim", (char *)&bcn_li_dtim,
 				    4, iovbuf, sizeof(iovbuf));
-			dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
+			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
 					 sizeof(iovbuf));
 #ifdef CUSTOMER_HW2
 			/* Disable build-in roaming to allowed \
@@ -445,7 +445,7 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 			 */
 			brcmu_mkiovar("roam_off", (char *)&roamvar, 4,
 				    iovbuf, sizeof(iovbuf));
-			dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
+			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
 					 sizeof(iovbuf));
 #endif				/* CUSTOMER_HW2 */
 		} else {
@@ -455,7 +455,7 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 				   __func__));
 
 			power_mode = PM_FAST;
-			dhdcdc_set_ioctl(dhd, 0, WLC_SET_PM,
+			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_PM,
 					 (char *)&power_mode,
 					 sizeof(power_mode));
 
@@ -466,13 +466,13 @@ static int dhd_set_suspend(int value, dhd_pub_t *dhd)
 			brcmu_mkiovar("bcn_li_dtim", (char *)&dhd->dtim_skip,
 				    4, iovbuf, sizeof(iovbuf));
 
-			dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
+			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
 					 sizeof(iovbuf));
 #ifdef CUSTOMER_HW2
 			roamvar = 0;
 			brcmu_mkiovar("roam_off", (char *)&roamvar, 4, iovbuf,
 				    sizeof(iovbuf));
-			dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, iovbuf,
+			dhdcdc_set_ioctl(dhd, 0, BRCMF_C_SET_VAR, iovbuf,
 					 sizeof(iovbuf));
 #endif				/* CUSTOMER_HW2 */
 		}
@@ -672,7 +672,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	}
 
 	memset(&ioc, 0, sizeof(ioc));
-	ioc.cmd = WLC_SET_VAR;
+	ioc.cmd = BRCMF_C_SET_VAR;
 	ioc.buf = buf;
 	ioc.len = buflen;
 	ioc.set = true;
@@ -710,7 +710,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	}
 
 	memset(&ioc, 0, sizeof(ioc));
-	ioc.cmd = WLC_SET_VAR;
+	ioc.cmd = BRCMF_C_SET_VAR;
 	ioc.buf = buf;
 	ioc.len = buflen;
 	ioc.set = true;
@@ -731,7 +731,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	allmulti = cpu_to_le32(allmulti);
 
 	memset(&ioc, 0, sizeof(ioc));
-	ioc.cmd = WLC_SET_PROMISC;
+	ioc.cmd = BRCMF_C_SET_PROMISC;
 	ioc.buf = &allmulti;
 	ioc.len = sizeof(allmulti);
 	ioc.set = true;
@@ -759,7 +759,7 @@ _dhd_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
 		return -1;
 	}
 	memset(&ioc, 0, sizeof(ioc));
-	ioc.cmd = WLC_SET_VAR;
+	ioc.cmd = BRCMF_C_SET_VAR;
 	ioc.buf = buf;
 	ioc.len = 32;
 	ioc.set = true;
@@ -1368,7 +1368,7 @@ static int dhd_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
 
 	memset(&ioc, 0, sizeof(ioc));
 
-	ioc.cmd = WLC_GET_VAR;
+	ioc.cmd = BRCMF_C_GET_VAR;
 	ioc.buf = buf;
 	ioc.len = (uint) sizeof(buf);
 	ioc.set = false;
@@ -1402,7 +1402,7 @@ static int dhd_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 
 	memset(&ioc, 0, sizeof(ioc));
 
-	ioc.cmd = WLC_SET_VAR;
+	ioc.cmd = BRCMF_C_SET_VAR;
 	ioc.buf = buf;
 	ioc.len = (uint) sizeof(buf);
 	ioc.set = true;
@@ -1652,13 +1652,14 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 		goto done;
 	}
 
-	/* Intercept WLC_SET_KEY IOCTL - serialize M4 send and set key IOCTL to
-	 * prevent M4 encryption.
+	/*
+	 * Intercept BRCMF_C_SET_KEY IOCTL - serialize M4 send and
+	 * set key IOCTL to prevent M4 encryption.
 	 */
-	is_set_key_cmd = ((ioc.cmd == WLC_SET_KEY) ||
-			  ((ioc.cmd == WLC_SET_VAR) &&
+	is_set_key_cmd = ((ioc.cmd == BRCMF_C_SET_KEY) ||
+			  ((ioc.cmd == BRCMF_C_SET_VAR) &&
 			   !(strncmp("wsec_key", ioc.buf, 9))) ||
-			  ((ioc.cmd == WLC_SET_VAR) &&
+			  ((ioc.cmd == BRCMF_C_SET_VAR) &&
 			   !(strncmp("bsscfg:wsec_key", ioc.buf, 15))));
 	if (is_set_key_cmd)
 		dhd_wait_pend8021x(net);
@@ -2023,7 +2024,7 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 #ifdef EMBEDDED_PLATFORM
 	brcmu_mkiovar("event_msgs", dhdp->eventmask, WL_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
-	dhdcdc_query_ioctl(dhdp, 0, WLC_GET_VAR, iovbuf, sizeof(iovbuf));
+	dhdcdc_query_ioctl(dhdp, 0, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
 	memcpy(dhdp->eventmask, iovbuf, WL_EVENTING_MASK_LEN);
 
 	setbit(dhdp->eventmask, WLC_E_SET_SSID);
@@ -2076,7 +2077,7 @@ dhd_iovar(dhd_pub_t *pub, int ifidx, char *name, char *cmd_buf, uint cmd_len,
 
 	memset(&ioc, 0, sizeof(ioc));
 
-	ioc.cmd = set ? WLC_SET_VAR : WLC_GET_VAR;
+	ioc.cmd = set ? BRCMF_C_SET_VAR : BRCMF_C_GET_VAR;
 	ioc.buf = buf;
 	ioc.len = len;
 	ioc.set = set;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 915546c..ee751a0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -596,7 +596,7 @@ wl_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 	}
 
 	infra = cpu_to_le32(infra);
-	err = wl_dev_ioctl(ndev, WLC_SET_INFRA, &infra, sizeof(infra));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_INFRA, &infra, sizeof(infra));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		err = -EAGAIN;
@@ -643,7 +643,7 @@ wl_dev_iovar_setbuf(struct net_device *dev, s8 * iovar, void *param,
 	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
-	return wl_dev_ioctl(dev, WLC_SET_VAR, bufptr, iolen);
+	return wl_dev_ioctl(dev, BRCMF_C_SET_VAR, bufptr, iolen);
 }
 
 static s32
@@ -655,7 +655,7 @@ wl_dev_iovar_getbuf(struct net_device *dev, s8 * iovar, void *param,
 	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
-	return wl_dev_ioctl(dev, WLC_GET_VAR, bufptr, buflen);
+	return wl_dev_ioctl(dev, BRCMF_C_GET_VAR, bufptr, buflen);
 }
 
 static s32
@@ -671,7 +671,7 @@ wl_run_iscan(struct wl_iscan_ctrl *iscan, struct wlc_ssid *ssid, u16 action)
 	params = kzalloc(params_size, GFP_KERNEL);
 	if (unlikely(!params))
 		return -ENOMEM;
-	BUG_ON(params_size >= WLC_IOCTL_SMLEN);
+	BUG_ON(params_size >= BRCMF_C_IOCTL_SMLEN);
 
 	wl_iscan_prep(&params->params, ssid);
 
@@ -681,7 +681,7 @@ wl_run_iscan(struct wl_iscan_ctrl *iscan, struct wlc_ssid *ssid, u16 action)
 
 	/* params_size += offsetof(wl_iscan_params_t, params); */
 	err = wl_dev_iovar_setbuf(iscan->dev, "iscan", params, params_size,
-				iscan->ioctl_buf, WLC_IOCTL_SMLEN);
+				iscan->ioctl_buf, BRCMF_C_IOCTL_SMLEN);
 	if (unlikely(err)) {
 		if (err == -EBUSY) {
 			WL_INFO("system busy : iscan canceled\n");
@@ -707,7 +707,7 @@ static s32 wl_do_iscan(struct wl_priv *wl)
 	iscan->state = WL_ISCAN_STATE_SCANING;
 
 	passive_scan = wl->active_scan ? 0 : 1;
-	err = wl_dev_ioctl(wl_to_ndev(wl), WLC_SET_PASSIVE_SCAN,
+	err = wl_dev_ioctl(wl_to_ndev(wl), BRCMF_C_SET_PASSIVE_SCAN,
 			&passive_scan, sizeof(passive_scan));
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
@@ -786,14 +786,14 @@ __wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		}
 
 		passive_scan = wl->active_scan ? 0 : 1;
-		err = wl_dev_ioctl(ndev, WLC_SET_PASSIVE_SCAN,
+		err = wl_dev_ioctl(ndev, BRCMF_C_SET_PASSIVE_SCAN,
 				&passive_scan, sizeof(passive_scan));
 		if (unlikely(err)) {
 			WL_ERR("WLC_SET_PASSIVE_SCAN error (%d)\n", err);
 			goto scan_out;
 		}
 		wl_set_mpc(ndev, 0);
-		err = wl_dev_ioctl(ndev, WLC_SCAN, &sr->ssid,
+		err = wl_dev_ioctl(ndev, BRCMF_C_SCAN, &sr->ssid,
 				sizeof(sr->ssid));
 		if (err) {
 			if (err == -EBUSY) {
@@ -835,7 +835,7 @@ wl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 
 static s32 wl_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 {
-	s8 buf[WLC_IOCTL_SMLEN];
+	s8 buf[BRCMF_C_IOCTL_SMLEN];
 	u32 len;
 	s32 err = 0;
 
@@ -844,7 +844,7 @@ static s32 wl_dev_intvar_set(struct net_device *dev, s8 *name, s32 val)
 			    sizeof(buf));
 	BUG_ON(!len);
 
-	err = wl_dev_ioctl(dev, WLC_SET_VAR, buf, len);
+	err = wl_dev_ioctl(dev, BRCMF_C_SET_VAR, buf, len);
 	if (unlikely(err))
 		WL_ERR("error (%d)\n", err);
 
@@ -855,7 +855,7 @@ static s32
 wl_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
 {
 	union {
-		s8 buf[WLC_IOCTL_SMLEN];
+		s8 buf[BRCMF_C_IOCTL_SMLEN];
 		s32 val;
 	} var;
 	u32 len;
@@ -866,7 +866,7 @@ wl_dev_intvar_get(struct net_device *dev, s8 *name, s32 *retval)
 	    brcmu_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
 			sizeof(var.buf));
 	BUG_ON(!len);
-	err = wl_dev_ioctl(dev, WLC_GET_VAR, &var, len);
+	err = wl_dev_ioctl(dev, BRCMF_C_GET_VAR, &var, len);
 	if (unlikely(err))
 		WL_ERR("error (%d)\n", err);
 
@@ -1084,7 +1084,8 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	wl->ibss_starter = false;
 
 
-	err = wl_dev_ioctl(dev, WLC_SET_SSID, &join_params, join_params_size);
+	err = wl_dev_ioctl(dev, BRCMF_C_SET_SSID,
+			   &join_params, join_params_size);
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
 		goto done;
@@ -1343,7 +1344,7 @@ wl_set_set_sharedkey(struct net_device *dev,
 			       key.len, key.index, key.algo);
 			WL_CONN("key \"%s\"\n", key.data);
 			swap_key_from_BE(&key);
-			err = wl_dev_ioctl(dev, WLC_SET_KEY, &key,
+			err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY, &key,
 					sizeof(key));
 			if (unlikely(err)) {
 				WL_ERR("WLC_SET_KEY error (%d)\n", err);
@@ -1448,7 +1449,8 @@ wl_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	wl_ch_to_chanspec(wl->channel, &join_params, &join_params_size);
-	err = wl_dev_ioctl(dev, WLC_SET_SSID, &join_params, join_params_size);
+	err = wl_dev_ioctl(dev, BRCMF_C_SET_SSID,
+			   &join_params, join_params_size);
 	if (err)
 		WL_ERR("WLC_SET_SSID failed (%d)\n", err);
 
@@ -1475,7 +1477,7 @@ wl_cfg80211_disconnect(struct wiphy *wiphy, struct net_device *dev,
 	scbval.val = reason_code;
 	memcpy(&scbval.ea, wl_read_prof(wl, WL_PROF_BSSID), ETH_ALEN);
 	scbval.val = cpu_to_le32(scbval.val);
-	err = wl_dev_ioctl(dev, WLC_DISASSOC, &scbval,
+	err = wl_dev_ioctl(dev, BRCMF_C_DISASSOC, &scbval,
 			sizeof(scb_val_t));
 	if (unlikely(err))
 		WL_ERR("error (%d)\n", err);
@@ -1521,7 +1523,7 @@ wl_cfg80211_set_tx_power(struct wiphy *wiphy,
 	/* Make sure radio is off or on as far as software is concerned */
 	disable = WL_RADIO_SW_DISABLE << 16;
 	disable = cpu_to_le32(disable);
-	err = wl_dev_ioctl(ndev, WLC_SET_RADIO, &disable, sizeof(disable));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_RADIO, &disable, sizeof(disable));
 	if (unlikely(err))
 		WL_ERR("WLC_SET_RADIO error (%d)\n", err);
 
@@ -1577,7 +1579,7 @@ wl_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 	WL_CONN("key index (%d)\n", key_idx);
 	CHECK_SYS_UP();
 
-	err = wl_dev_ioctl(dev, WLC_GET_WSEC, &wsec, sizeof(wsec));
+	err = wl_dev_ioctl(dev, BRCMF_C_GET_WSEC, &wsec, sizeof(wsec));
 	if (unlikely(err)) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		goto done;
@@ -1588,7 +1590,7 @@ wl_cfg80211_config_default_key(struct wiphy *wiphy, struct net_device *dev,
 		/* Just select a new current key */
 		index = (u32) key_idx;
 		index = cpu_to_le32(index);
-		err = wl_dev_ioctl(dev, WLC_SET_KEY_PRIMARY, &index,
+		err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY_PRIMARY, &index,
 				sizeof(index));
 		if (unlikely(err))
 			WL_ERR("error (%d)\n", err);
@@ -1616,7 +1618,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	if (key.len == 0) {
 		/* key delete */
 		swap_key_from_BE(&key);
-		err = wl_dev_ioctl(dev, WLC_SET_KEY, &key, sizeof(key));
+		err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 		if (unlikely(err)) {
 			WL_ERR("key delete error (%d)\n", err);
 			return err;
@@ -1676,7 +1678,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 		swap_key_from_BE(&key);
 
 		dhd_wait_pend8021x(dev);
-		err = wl_dev_ioctl(dev, WLC_SET_KEY, &key, sizeof(key));
+		err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 		if (unlikely(err)) {
 			WL_ERR("WLC_SET_KEY error (%d)\n", err);
 			return err;
@@ -1749,7 +1751,7 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 
 	/* Set the new key/index */
 	swap_key_from_BE(&key);
-	err = wl_dev_ioctl(dev, WLC_SET_KEY, &key, sizeof(key));
+	err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_KEY error (%d)\n", err);
 		goto done;
@@ -1771,7 +1773,7 @@ wl_cfg80211_add_key(struct wiphy *wiphy, struct net_device *dev,
 
 	val = 1;		/* assume shared key. otherwise 0 */
 	val = cpu_to_le32(val);
-	err = wl_dev_ioctl(dev, WLC_SET_AUTH, &val, sizeof(val));
+	err = wl_dev_ioctl(dev, BRCMF_C_SET_AUTH, &val, sizeof(val));
 	if (unlikely(err))
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 done:
@@ -1799,7 +1801,7 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 	WL_CONN("key index (%d)\n", key_idx);
 	/* Set the new key/index */
 	swap_key_from_BE(&key);
-	err = wl_dev_ioctl(dev, WLC_SET_KEY, &key, sizeof(key));
+	err = wl_dev_ioctl(dev, BRCMF_C_SET_KEY, &key, sizeof(key));
 	if (unlikely(err)) {
 		if (err == -EINVAL) {
 			if (key.index >= DOT11_MAX_DEFAULT_KEYS)
@@ -1833,7 +1835,7 @@ wl_cfg80211_del_key(struct wiphy *wiphy, struct net_device *dev,
 
 	val = 0;		/* assume open key. otherwise 1 */
 	val = cpu_to_le32(val);
-	err = wl_dev_ioctl(dev, WLC_SET_AUTH, &val, sizeof(val));
+	err = wl_dev_ioctl(dev, BRCMF_C_SET_AUTH, &val, sizeof(val));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_AUTH error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1867,7 +1869,7 @@ wl_cfg80211_get_key(struct wiphy *wiphy, struct net_device *dev,
 	params.key_len = (u8) min_t(u8, WLAN_MAX_KEY_LEN, key.len);
 	memcpy(params.key, key.data, params.key_len);
 
-	err = wl_dev_ioctl(dev, WLC_GET_WSEC, &wsec, sizeof(wsec));
+	err = wl_dev_ioctl(dev, BRCMF_C_GET_WSEC, &wsec, sizeof(wsec));
 	if (unlikely(err)) {
 		WL_ERR("WLC_GET_WSEC error (%d)\n", err);
 		/* Ignore this error, may happen during DISASSOC */
@@ -1942,7 +1944,7 @@ wl_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 	}
 
 	/* Report the current tx rate */
-	err = wl_dev_ioctl(dev, WLC_GET_RATE, &rate, sizeof(rate));
+	err = wl_dev_ioctl(dev, BRCMF_C_GET_RATE, &rate, sizeof(rate));
 	if (err) {
 		WL_ERR("Could not get rate (%d)\n", err);
 	} else {
@@ -1954,7 +1956,7 @@ wl_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 
 	if (test_bit(WL_STATUS_CONNECTED, &wl->status)) {
 		scb_val.val = 0;
-		err = wl_dev_ioctl(dev, WLC_GET_RSSI, &scb_val,
+		err = wl_dev_ioctl(dev, BRCMF_C_GET_RSSI, &scb_val,
 				sizeof(scb_val_t));
 		if (unlikely(err)) {
 			WL_ERR("Could not get rssi (%d)\n", err);
@@ -1984,7 +1986,7 @@ wl_cfg80211_set_power_mgmt(struct wiphy *wiphy, struct net_device *dev,
 	pm = cpu_to_le32(pm);
 	WL_INFO("power save %s\n", (pm ? "enabled" : "disabled"));
 
-	err = wl_dev_ioctl(dev, WLC_SET_PM, &pm, sizeof(pm));
+	err = wl_dev_ioctl(dev, BRCMF_C_SET_PM, &pm, sizeof(pm));
 	if (unlikely(err)) {
 		if (err == -ENODEV)
 			WL_ERR("net_device is not ready yet\n");
@@ -2522,7 +2524,7 @@ wl_inform_ibss(struct wl_priv *wl, struct net_device *dev, const u8 *bssid)
 
 	*(u32 *)buf = cpu_to_le32(WL_BSS_INFO_MAX);
 
-	err = wl_dev_ioctl(dev, WLC_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
+	err = wl_dev_ioctl(dev, BRCMF_C_GET_BSS_INFO, buf, WL_BSS_INFO_MAX);
 	if (unlikely(err)) {
 		WL_ERR("WLC_GET_BSS_INFO failed: %d\n", err);
 		goto CleanUp;
@@ -2684,7 +2686,7 @@ wl_dev_bufvar_set(struct net_device *dev, s8 *name, s8 *buf, s32 len)
 	buflen = brcmu_mkiovar(name, buf, len, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
 	BUG_ON(!buflen);
 
-	return wl_dev_ioctl(dev, WLC_SET_VAR, wl->ioctl_buf, buflen);
+	return wl_dev_ioctl(dev, BRCMF_C_SET_VAR, wl->ioctl_buf, buflen);
 }
 
 static s32
@@ -2697,7 +2699,7 @@ wl_dev_bufvar_get(struct net_device *dev, s8 *name, s8 *buf,
 
 	len = brcmu_mkiovar(name, NULL, 0, wl->ioctl_buf, WL_IOCTL_LEN_MAX);
 	BUG_ON(!len);
-	err = wl_dev_ioctl(dev, WLC_GET_VAR, (void *)wl->ioctl_buf,
+	err = wl_dev_ioctl(dev, BRCMF_C_GET_VAR, (void *)wl->ioctl_buf,
 			WL_IOCTL_LEN_MAX);
 	if (unlikely(err)) {
 		WL_ERR("error (%d)\n", err);
@@ -2827,7 +2829,7 @@ static s32 wl_update_bss_info(struct wl_priv *wl)
 	ssid = (struct wlc_ssid *)wl_read_prof(wl, WL_PROF_SSID);
 
 	*(u32 *)wl->extra_buf = cpu_to_le32(WL_EXTRA_BUF_MAX);
-	err = wl_dev_ioctl(wl_to_ndev(wl), WLC_GET_BSS_INFO,
+	err = wl_dev_ioctl(wl_to_ndev(wl), BRCMF_C_GET_BSS_INFO,
 			wl->extra_buf, WL_EXTRA_BUF_MAX);
 	if (unlikely(err)) {
 		WL_ERR("Could not get bss info %d\n", err);
@@ -2969,7 +2971,7 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 		goto scan_done_out;
 	}
 
-	err = wl_dev_ioctl(ndev, WLC_GET_CHANNEL, &channel_inform,
+	err = wl_dev_ioctl(ndev, BRCMF_C_GET_CHANNEL, &channel_inform,
 			sizeof(channel_inform));
 	if (unlikely(err)) {
 		WL_ERR("scan busy (%d)\n", err);
@@ -2987,7 +2989,7 @@ wl_notify_scan_status(struct wl_priv *wl, struct net_device *ndev,
 	memset(bss_list, 0, len);
 	bss_list->buflen = cpu_to_le32(len);
 
-	err = wl_dev_ioctl(ndev, WLC_SCAN_RESULTS, bss_list, len);
+	err = wl_dev_ioctl(ndev, BRCMF_C_SCAN_RESULTS, bss_list, len);
 	if (unlikely(err)) {
 		WL_ERR("%s Scan_results error (%d)\n", ndev->name, err);
 		err = -EINVAL;
@@ -3646,7 +3648,7 @@ static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype)
 		return err;
 	}
 	infra = cpu_to_le32(infra);
-	err = wl_dev_ioctl(ndev, WLC_SET_INFRA, &infra, sizeof(infra));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_INFRA, &infra, sizeof(infra));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_INFRA error (%d)\n", err);
 		return err;
@@ -3668,7 +3670,7 @@ static s32 wl_dongle_up(struct net_device *ndev, u32 up)
 {
 	s32 err = 0;
 
-	err = wl_dev_ioctl(ndev, WLC_UP, &up, sizeof(up));
+	err = wl_dev_ioctl(ndev, BRCMF_C_UP, &up, sizeof(up));
 	if (unlikely(err)) {
 		WL_ERR("WLC_UP error (%d)\n", err);
 	}
@@ -3679,7 +3681,8 @@ static s32 wl_dongle_power(struct net_device *ndev, u32 power_mode)
 {
 	s32 err = 0;
 
-	err = wl_dev_ioctl(ndev, WLC_SET_PM, &power_mode, sizeof(power_mode));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_PM,
+			   &power_mode, sizeof(power_mode));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_PM error (%d)\n", err);
 	}
@@ -3696,14 +3699,14 @@ wl_dongle_glom(struct net_device *ndev, u32 glom, u32 dongle_align)
 	/* Match Host and Dongle rx alignment */
 	brcmu_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
 		    sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
 		WL_ERR("txglomalign error (%d)\n", err);
 		goto dongle_glom_out;
 	}
 	/* disable glom option per default */
 	brcmu_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
 		WL_ERR("txglom error (%d)\n", err);
 		goto dongle_glom_out;
@@ -3721,7 +3724,7 @@ wl_dongle_offload(struct net_device *ndev, s32 arpoe, s32 arp_ol)
 
 	/* Set ARP offload */
 	brcmu_mkiovar("arpoe", (char *)&arpoe, 4, iovbuf, sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			WL_INFO("arpoe is not supported\n");
@@ -3731,7 +3734,7 @@ wl_dongle_offload(struct net_device *ndev, s32 arpoe, s32 arp_ol)
 		goto dongle_offload_out;
 	}
 	brcmu_mkiovar("arp_ol", (char *)&arp_ol, 4, iovbuf, sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			WL_INFO("arp_ol is not supported\n");
@@ -3832,7 +3835,7 @@ static s32 wl_dongle_filter(struct net_device *ndev, u32 filter_mode)
 	memcpy((char *)pkt_filterp, &pkt_filter,
 	       WL_PKT_FILTER_FIXED_LEN + WL_PKT_FILTER_PATTERN_FIXED_LEN);
 
-	err = wl_dev_ioctl(ndev, WLC_SET_VAR, buf, buf_len);
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, buf, buf_len);
 	if (err) {
 		if (err == -EOPNOTSUPP) {
 			WL_INFO("filter not supported\n");
@@ -3845,7 +3848,7 @@ static s32 wl_dongle_filter(struct net_device *ndev, u32 filter_mode)
 	/* set mode to allow pattern */
 	brcmu_mkiovar("pkt_filter_mode", (char *)&filter_mode, 4, iovbuf,
 		    sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		if (err == -EOPNOTSUPP) {
 			WL_INFO("filter_mode not supported\n");
@@ -3872,7 +3875,7 @@ static s32 wl_dongle_eventmsg(struct net_device *ndev)
 	/* Setup event_msgs */
 	brcmu_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, WLC_GET_VAR, iovbuf, sizeof(iovbuf));
+	err = wl_dev_ioctl(ndev, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
 		WL_ERR("Get event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
@@ -3901,7 +3904,7 @@ static s32 wl_dongle_eventmsg(struct net_device *ndev)
 
 	brcmu_mkiovar("event_msgs", eventmask, WL_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
 		WL_ERR("Set event_msgs error (%d)\n", err);
 		goto dongle_eventmsg_out;
@@ -3927,7 +3930,8 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	if (roamvar) {
 		brcmu_mkiovar("bcn_timeout", (char *)&bcn_timeout,
 			sizeof(bcn_timeout), iovbuf, sizeof(iovbuf));
-		err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+		err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR,
+				   iovbuf, sizeof(iovbuf));
 		if (unlikely(err)) {
 			WL_ERR("bcn_timeout error (%d)\n", err);
 			goto dongle_rom_out;
@@ -3941,7 +3945,7 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	WL_INFO("Internal Roaming = %s\n", roamvar ? "Off" : "On");
 	brcmu_mkiovar("roam_off", (char *)&roamvar,
 				sizeof(roamvar), iovbuf, sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, WLC_SET_VAR, iovbuf, sizeof(iovbuf));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (unlikely(err)) {
 		WL_ERR("roam_off error (%d)\n", err);
 		goto dongle_rom_out;
@@ -3949,7 +3953,7 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 
 	roamtrigger[0] = WL_ROAM_TRIGGER_LEVEL;
 	roamtrigger[1] = WLC_BAND_ALL;
-	err = wl_dev_ioctl(ndev, WLC_SET_ROAM_TRIGGER,
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_ROAM_TRIGGER,
 			(void *)roamtrigger, sizeof(roamtrigger));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_ROAM_TRIGGER error (%d)\n", err);
@@ -3958,7 +3962,7 @@ wl_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 
 	roam_delta[0] = WL_ROAM_DELTA;
 	roam_delta[1] = WLC_BAND_ALL;
-	err = wl_dev_ioctl(ndev, WLC_SET_ROAM_DELTA,
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_ROAM_DELTA,
 				(void *)roam_delta, sizeof(roam_delta));
 	if (unlikely(err)) {
 		WL_ERR("WLC_SET_ROAM_DELTA error (%d)\n", err);
@@ -3975,8 +3979,8 @@ wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 {
 	s32 err = 0;
 
-	err = wl_dev_ioctl(ndev, WLC_SET_SCAN_CHANNEL_TIME, &scan_assoc_time,
-			sizeof(scan_assoc_time));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_SCAN_CHANNEL_TIME,
+			   &scan_assoc_time, sizeof(scan_assoc_time));
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan assoc time is not supported\n");
@@ -3984,8 +3988,8 @@ wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 			WL_ERR("Scan assoc time error (%d)\n", err);
 		goto dongle_scantime_out;
 	}
-	err = wl_dev_ioctl(ndev, WLC_SET_SCAN_UNASSOC_TIME, &scan_unassoc_time,
-			sizeof(scan_unassoc_time));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_SCAN_UNASSOC_TIME,
+			   &scan_unassoc_time, sizeof(scan_unassoc_time));
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan unassoc time is not supported\n");
@@ -3994,8 +3998,8 @@ wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 		goto dongle_scantime_out;
 	}
 
-	err = wl_dev_ioctl(ndev, WLC_SET_SCAN_PASSIVE_TIME, &scan_passive_time,
-			sizeof(scan_passive_time));
+	err = wl_dev_ioctl(ndev, BRCMF_C_SET_SCAN_PASSIVE_TIME,
+			   &scan_passive_time, sizeof(scan_passive_time));
 	if (err) {
 		if (err == -EOPNOTSUPP)
 			WL_INFO("Scan passive time is not supported\n");
@@ -4266,7 +4270,7 @@ static void wl_link_down(struct wl_priv *wl)
 	if (wl->link_up) {
 		dev = wl_to_ndev(wl);
 		WL_INFO("Call WLC_DISASSOC to stop excess roaming\n ");
-		err = wl_dev_ioctl(dev, WLC_DISASSOC, NULL, 0);
+		err = wl_dev_ioctl(dev, BRCMF_C_DISASSOC, NULL, 0);
 		if (unlikely(err))
 			WL_ERR("WLC_DISASSOC failed (%d)\n", err);
 		wl->link_up = false;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 80940bd..3b0c8ae 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -108,7 +108,7 @@ do {								\
 #define WL_IOCTL_LEN_MAX	1024
 #define WL_EXTRA_BUF_MAX	2048
 #define WL_ISCAN_BUF_MAX	2048	/*
-				 * the buf lengh can be WLC_IOCTL_MAXLEN (8K)
+				 * the buf length can be BRCMF_C_IOCTL_MAXLEN
 				 * to reduce iteration
 				 */
 #define WL_ISCAN_TIMER_INTERVAL_MS	3000
@@ -276,7 +276,7 @@ struct wl_iscan_ctrl {
 	struct semaphore sync;
 	struct wl_iscan_eloop el;
 	void *data;
-	s8 ioctl_buf[WLC_IOCTL_SMLEN];
+	s8 ioctl_buf[BRCMF_C_IOCTL_SMLEN];
 	s8 scan_buf[WL_ISCAN_BUF_MAX];
 };
 
-- 
1.7.1


