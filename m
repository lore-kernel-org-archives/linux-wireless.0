Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4334 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754020Ab1JLSvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 20/22] brcm80211: moved function brcmu_mkiovar
Date: Wed, 12 Oct 2011 20:51:30 +0200
Message-ID: <1318445492-24207-21-git-send-email-arend@broadcom.com> (sfid-20111012_205237_186974_027ABEFB)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Moved the brcmu_mkiovar function into fmac, adjusting the
name accordingly.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |    3 ++
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   39 +++++++++++++++-----
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    6 ++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   24 ++++++------
 drivers/net/wireless/brcm80211/brcmutil/utils.c    |   20 ----------
 .../net/wireless/brcm80211/include/brcmu_utils.h   |    3 --
 6 files changed, 48 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 951910e..4645766 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -680,6 +680,9 @@ struct bcmevent_name {
 
 extern const struct bcmevent_name bcmevent_names[];
 
+extern uint brcmf_c_mkiovar(char *name, char *data, uint datalen,
+			  char *buf, uint len);
+
 /* Indication from bus module regarding presence/insertion of dongle.
  * Return struct brcmf_pub pointer, used as handle to OS module in later calls.
  * Returned structure should have bus and prot pointers filled in.
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index a43b3da..8918261 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -65,6 +65,26 @@ struct msgtrace_hdr {
 				 because of trace overflow */
 } __packed;
 
+
+uint
+brcmf_c_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
+{
+	uint len;
+
+	len = strlen(name) + 1;
+
+	if ((len + datalen) > buflen)
+		return 0;
+
+	strncpy(buf, name, buflen);
+
+	/* append data onto the end of the name string */
+	memcpy(&buf[len], data, datalen);
+	len += datalen;
+
+	return len;
+}
+
 void brcmf_c_init(void)
 {
 	/* Init global variables at run-time, not as part of the declaration.
@@ -607,7 +627,7 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 
 	/* Contorl the master mode */
 	mmode_le = cpu_to_le32(master_mode);
-	brcmu_mkiovar("pkt_filter_mode", (char *)&mmode_le, 4, buf,
+	brcmf_c_mkiovar("pkt_filter_mode", (char *)&mmode_le, 4, buf,
 		    sizeof(buf));
 	rc = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, buf,
 				       sizeof(buf));
@@ -756,7 +776,7 @@ static void brcmf_c_arp_offload_set(struct brcmf_pub *drvr, int arp_mode)
 	char iovbuf[32];
 	int retcode;
 
-	brcmu_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
+	brcmf_c_mkiovar("arp_ol", (char *)&arp_mode, 4, iovbuf, sizeof(iovbuf));
 	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
@@ -773,7 +793,8 @@ static void brcmf_c_arp_offload_enable(struct brcmf_pub *drvr, int arp_enable)
 	char iovbuf[32];
 	int retcode;
 
-	brcmu_mkiovar("arpoe", (char *)&arp_enable, 4, iovbuf, sizeof(iovbuf));
+	brcmf_c_mkiovar("arpoe", (char *)&arp_enable, 4,
+			iovbuf, sizeof(iovbuf));
 	retcode = brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
 	retcode = retcode >= 0 ? 0 : retcode;
@@ -812,33 +833,33 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 	/* query for 'ver' to get version info from firmware */
 	memset(buf, 0, sizeof(buf));
 	ptr = buf;
-	brcmu_mkiovar("ver", NULL, 0, buf, sizeof(buf));
+	brcmf_c_mkiovar("ver", NULL, 0, buf, sizeof(buf));
 	brcmf_proto_cdc_query_dcmd(drvr, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
 	strsep(&ptr, "\n");
 	/* Print fw version info */
 	brcmf_dbg(ERROR, "Firmware version = %s\n", buf);
 
 	/* Match Host and Dongle rx alignment */
-	brcmu_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
+	brcmf_c_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
 		    sizeof(iovbuf));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* disable glom option per default */
-	brcmu_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
+	brcmf_c_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* Setup timeout if Beacons are lost and roam is off to report
 		 link down */
-	brcmu_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
+	brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_timeout, 4, iovbuf,
 		    sizeof(iovbuf));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
 
 	/* Enable/Disable build-in roaming to allowed ext supplicant to take
 		 of romaing */
-	brcmu_mkiovar("roam_off", (char *)&roaming, 4,
+	brcmf_c_mkiovar("roam_off", (char *)&roaming, 4,
 		      iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
@@ -847,7 +868,7 @@ int brcmf_c_preinit_dcmds(struct brcmf_pub *drvr)
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_UP, (char *)&up, sizeof(up));
 
 	/* Setup event_msgs */
-	brcmu_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
+	brcmf_c_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_set_dcmd(drvr, 0, BRCMF_C_SET_VAR, iovbuf,
 				  sizeof(iovbuf));
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index b05f177..4acbac5 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -204,7 +204,7 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 
 	dcmd_le_value = cpu_to_le32(dcmd_value);
 
-	if (!brcmu_mkiovar
+	if (!brcmf_c_mkiovar
 	    ("allmulti", (void *)&dcmd_le_value,
 	    sizeof(dcmd_le_value), buf, buflen)) {
 		brcmf_dbg(ERROR, "%s: mkiovar failed for allmulti, datalen %d buflen %u\n",
@@ -260,7 +260,7 @@ _brcmf_set_mac_address(struct work_struct *work)
 						    setmacaddr_work);
 
 	brcmf_dbg(TRACE, "enter\n");
-	if (!brcmu_mkiovar("cur_etheraddr", (char *)drvr_priv->macvalue,
+	if (!brcmf_c_mkiovar("cur_etheraddr", (char *)drvr_priv->macvalue,
 			   ETH_ALEN, buf, 32)) {
 		brcmf_dbg(ERROR, "%s: mkiovar failed for cur_etheraddr\n",
 			  brcmf_ifname(&drvr_priv->pub, 0));
@@ -1084,7 +1084,7 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 		return -ENODEV;
 	}
 
-	brcmu_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
+	brcmf_c_mkiovar("event_msgs", drvr->eventmask, BRCMF_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_query_dcmd(drvr, 0, BRCMF_C_GET_VAR, iovbuf,
 				    sizeof(iovbuf));
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index 857b328..5eddabe 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -437,7 +437,7 @@ static s32 brcmf_dev_intvar_set(struct net_device *ndev, s8 *name, s32 val)
 	__le32 val_le;
 
 	val_le = cpu_to_le32(val);
-	len = brcmu_mkiovar(name, (char *)(&val_le), sizeof(val_le), buf,
+	len = brcmf_c_mkiovar(name, (char *)(&val_le), sizeof(val_le), buf,
 			    sizeof(buf));
 	BUG_ON(!len);
 
@@ -460,7 +460,7 @@ brcmf_dev_intvar_get(struct net_device *ndev, s8 *name, s32 *retval)
 	s32 err = 0;
 
 	len =
-	    brcmu_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
+	    brcmf_c_mkiovar(name, (char *)(&data_null), 0, (char *)(&var),
 			sizeof(var.buf));
 	BUG_ON(!len);
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, &var, len);
@@ -508,7 +508,7 @@ brcmf_dev_iovar_setbuf(struct net_device *ndev, s8 * iovar, void *param,
 {
 	s32 iolen;
 
-	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
+	iolen = brcmf_c_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
 	return brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, bufptr, iolen);
@@ -520,7 +520,7 @@ brcmf_dev_iovar_getbuf(struct net_device *ndev, s8 * iovar, void *param,
 {
 	s32 iolen;
 
-	iolen = brcmu_mkiovar(iovar, param, paramlen, bufptr, buflen);
+	iolen = brcmf_c_mkiovar(iovar, param, paramlen, bufptr, buflen);
 	BUG_ON(!iolen);
 
 	return brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, bufptr, buflen);
@@ -2554,7 +2554,7 @@ brcmf_dev_bufvar_set(struct net_device *ndev, s8 *name, s8 *buf, s32 len)
 	struct brcmf_cfg80211_priv *cfg_priv = ndev_to_cfg(ndev);
 	u32 buflen;
 
-	buflen = brcmu_mkiovar(name, buf, len, cfg_priv->dcmd_buf,
+	buflen = brcmf_c_mkiovar(name, buf, len, cfg_priv->dcmd_buf,
 			       WL_DCMD_LEN_MAX);
 	BUG_ON(!buflen);
 
@@ -2570,7 +2570,7 @@ brcmf_dev_bufvar_get(struct net_device *ndev, s8 *name, s8 *buf,
 	u32 len;
 	s32 err = 0;
 
-	len = brcmu_mkiovar(name, NULL, 0, cfg_priv->dcmd_buf,
+	len = brcmf_c_mkiovar(name, NULL, 0, cfg_priv->dcmd_buf,
 			    WL_DCMD_LEN_MAX);
 	BUG_ON(!len);
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, cfg_priv->dcmd_buf,
@@ -3513,8 +3513,8 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 	WL_TRACE("Enter\n");
 
 	/* Setup event_msgs */
-	brcmu_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN, iovbuf,
-		    sizeof(iovbuf));
+	brcmf_c_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN,
+			iovbuf, sizeof(iovbuf));
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_GET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		WL_ERR("Get event_msgs error (%d)\n", err);
@@ -3542,8 +3542,8 @@ static s32 brcmf_dongle_eventmsg(struct net_device *ndev)
 	setbit(eventmask, BRCMF_E_JOIN_START);
 	setbit(eventmask, BRCMF_E_SCAN_COMPLETE);
 
-	brcmu_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN, iovbuf,
-		    sizeof(iovbuf));
+	brcmf_c_mkiovar("event_msgs", eventmask, BRCMF_EVENTING_MASK_LEN,
+			iovbuf, sizeof(iovbuf));
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
 		WL_ERR("Set event_msgs error (%d)\n", err);
@@ -3571,7 +3571,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	 */
 	if (roamvar) {
 		bcn_to_le = cpu_to_le32(bcn_timeout);
-		brcmu_mkiovar("bcn_timeout", (char *)&bcn_to_le,
+		brcmf_c_mkiovar("bcn_timeout", (char *)&bcn_to_le,
 			sizeof(bcn_to_le), iovbuf, sizeof(iovbuf));
 		err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR,
 				   iovbuf, sizeof(iovbuf));
@@ -3587,7 +3587,7 @@ brcmf_dongle_roam(struct net_device *ndev, u32 roamvar, u32 bcn_timeout)
 	 */
 	WL_INFO("Internal Roaming = %s\n", roamvar ? "Off" : "On");
 	roamvar_le = cpu_to_le32(roamvar);
-	brcmu_mkiovar("roam_off", (char *)&roamvar_le,
+	brcmf_c_mkiovar("roam_off", (char *)&roamvar_le,
 				sizeof(roamvar_le), iovbuf, sizeof(iovbuf));
 	err = brcmf_exec_dcmd(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
 	if (err) {
diff --git a/drivers/net/wireless/brcm80211/brcmutil/utils.c b/drivers/net/wireless/brcm80211/brcmutil/utils.c
index 2d903ba..d55595a 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/utils.c
+++ b/drivers/net/wireless/brcm80211/brcmutil/utils.c
@@ -439,23 +439,3 @@ int brcmu_format_hex(char *str, const void *bytes, int len)
 }
 EXPORT_SYMBOL(brcmu_format_hex);
 #endif				/* defined(BCMDBG) */
-
-uint brcmu_mkiovar(char *name, char *data, uint datalen, char *buf, uint buflen)
-{
-	uint len;
-
-	len = strlen(name) + 1;
-
-	if ((len + datalen) > buflen)
-		return 0;
-
-	strncpy(buf, name, buflen);
-
-	/* append data onto the end of the name string */
-	memcpy(&buf[len], data, datalen);
-	len += datalen;
-
-	return len;
-}
-EXPORT_SYMBOL(brcmu_mkiovar);
-
diff --git a/drivers/net/wireless/brcm80211/include/brcmu_utils.h b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
index c19490c..f8664b2 100644
--- a/drivers/net/wireless/brcm80211/include/brcmu_utils.h
+++ b/drivers/net/wireless/brcm80211/include/brcmu_utils.h
@@ -200,7 +200,4 @@ extern int brcmu_format_flags(const struct brcmu_bit_desc *bd, u32 flags,
 extern int brcmu_format_hex(char *str, const void *bytes, int len);
 #endif
 
-extern uint brcmu_mkiovar(char *name, char *data, uint datalen,
-			  char *buf, uint len);
-
 #endif				/* _BRCMU_UTILS_H_ */
-- 
1.7.4.1


