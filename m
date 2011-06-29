Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:1997 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758035Ab1F2Xsy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:54 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 067/119] staging: brcm80211: remove EMBEDDED_PLATFORM
 macro definition
Date: Wed, 29 Jun 2011 16:47:31 -0700
Message-ID: <1309391303-22741-68-git-send-email-frankyl@broadcom.com> (sfid-20110630_015114_392726_8F4B2C97)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The macro is always intended to be defined so no need for it.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/Makefile      |    1 -
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c     |    2 -
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |    5 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |  238 ----------------------
 4 files changed, 1 insertions(+), 245 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/Makefile b/drivers/staging/brcm80211/brcmfmac/Makefile
index 1444fd4..2ccfa1f 100644
--- a/drivers/staging/brcm80211/brcmfmac/Makefile
+++ b/drivers/staging/brcm80211/brcmfmac/Makefile
@@ -20,7 +20,6 @@ ccflags-y :=			\
 	-DBRCM_FULLMAC		\
 	-DBRCMF_FIRSTREAD=64	\
 	-DBRCMF_SDALIGN=64	\
-	-DEMBEDDED_PLATFORM	\
 	-DMAX_HDR_READ=64	\
 	-DMMC_SDIO_ABORT	\
 	-DSHOW_EVENTS		\
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 594c217..a766707 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -504,9 +504,7 @@ int brcmf_proto_init(dhd_pub_t *dhd)
 
 	brcmf_os_proto_unblock(dhd);
 
-#ifdef EMBEDDED_PLATFORM
 	ret = brcmf_c_preinit_ioctls(dhd);
-#endif				/* EMBEDDED_PLATFORM */
 
 	/* Always assumes wl for now */
 	dhd->iswl = true;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 593d180..8a2c73d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1930,10 +1930,8 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 {
 	int ret = -1;
 	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
-#ifdef EMBEDDED_PLATFORM
 	char iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
 						 '\0' + bitvec  */
-#endif				/* EMBEDDED_PLATFORM */
 
 	ASSERT(dhd);
 
@@ -1981,7 +1979,7 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 		DHD_ERROR(("%s failed bus is not ready\n", __func__));
 		return -ENODEV;
 	}
-#ifdef EMBEDDED_PLATFORM
+
 	brcmu_mkiovar("event_msgs", dhdp->eventmask, WL_EVENTING_MASK_LEN,
 		      iovbuf, sizeof(iovbuf));
 	brcmf_proto_cdc_query_ioctl(dhdp, 0, BRCMF_C_GET_VAR, iovbuf,
@@ -2015,7 +2013,6 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 	dhdp->pktfilter_count = 1;
 	/* Setup filter to allow only unicast */
 	dhdp->pktfilter[0] = "100 0 0 0 0x01 0x00";
-#endif				/* EMBEDDED_PLATFORM */
 
 	/* Bus is ready, do any protocol initialization */
 	ret = brcmf_proto_init(&dhd->pub);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 086a93b..1d80d75 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -250,20 +250,6 @@ static void wl_init_conf(struct wl_conf *conf);
 /*
 ** dongle configuration utilities
 */
-#ifndef EMBEDDED_PLATFORM
-static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype);
-static s32 wl_dongle_country(struct net_device *ndev, u8 ccode);
-static s32 wl_dongle_up(struct net_device *ndev, u32 up);
-static s32 wl_dongle_power(struct net_device *ndev, u32 power_mode);
-static s32 wl_dongle_glom(struct net_device *ndev, u32 glom,
-			    u32 dongle_align);
-static s32 wl_dongle_offload(struct net_device *ndev, s32 arpoe,
-			       s32 arp_ol);
-static s32 wl_pattern_atoh(s8 *src, s8 *dst);
-static s32 wl_dongle_filter(struct net_device *ndev, u32 filter_mode);
-static s32 wl_update_wiphybands(struct wl_priv *wl);
-#endif				/* !EMBEDDED_PLATFORM */
-
 static s32 wl_dongle_eventmsg(struct net_device *ndev);
 static s32 wl_dongle_scantime(struct net_device *ndev, s32 scan_assoc_time,
 				s32 scan_unassoc_time, s32 scan_passive_time);
@@ -3657,212 +3643,6 @@ static s32 wl_dongle_mode(struct net_device *ndev, s32 iftype)
 	return 0;
 }
 
-#ifndef EMBEDDED_PLATFORM
-static s32 wl_dongle_country(struct net_device *ndev, u8 ccode)
-{
-
-	s32 err = 0;
-
-	return err;
-}
-
-static s32 wl_dongle_up(struct net_device *ndev, u32 up)
-{
-	s32 err = 0;
-
-	err = wl_dev_ioctl(ndev, BRCMF_C_UP, &up, sizeof(up));
-	if (unlikely(err)) {
-		WL_ERR("WLC_UP error (%d)\n", err);
-	}
-	return err;
-}
-
-static s32 wl_dongle_power(struct net_device *ndev, u32 power_mode)
-{
-	s32 err = 0;
-
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_PM,
-			   &power_mode, sizeof(power_mode));
-	if (unlikely(err)) {
-		WL_ERR("WLC_SET_PM error (%d)\n", err);
-	}
-	return err;
-}
-
-static s32
-wl_dongle_glom(struct net_device *ndev, u32 glom, u32 dongle_align)
-{
-	s8 iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
-						 '\0' + bitvec  */
-	s32 err = 0;
-
-	/* Match Host and Dongle rx alignment */
-	brcmu_mkiovar("bus:txglomalign", (char *)&dongle_align, 4, iovbuf,
-		    sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
-	if (unlikely(err)) {
-		WL_ERR("txglomalign error (%d)\n", err);
-		goto dongle_glom_out;
-	}
-	/* disable glom option per default */
-	brcmu_mkiovar("bus:txglom", (char *)&glom, 4, iovbuf, sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
-	if (unlikely(err)) {
-		WL_ERR("txglom error (%d)\n", err);
-		goto dongle_glom_out;
-	}
-dongle_glom_out:
-	return err;
-}
-
-static s32
-wl_dongle_offload(struct net_device *ndev, s32 arpoe, s32 arp_ol)
-{
-	s8 iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
-							 '\0' + bitvec  */
-	s32 err = 0;
-
-	/* Set ARP offload */
-	brcmu_mkiovar("arpoe", (char *)&arpoe, 4, iovbuf, sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			WL_INFO("arpoe is not supported\n");
-		else
-			WL_ERR("arpoe error (%d)\n", err);
-
-		goto dongle_offload_out;
-	}
-	brcmu_mkiovar("arp_ol", (char *)&arp_ol, 4, iovbuf, sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
-	if (err) {
-		if (err == -EOPNOTSUPP)
-			WL_INFO("arp_ol is not supported\n");
-		else
-			WL_ERR("arp_ol error (%d)\n", err);
-
-		goto dongle_offload_out;
-	}
-
-dongle_offload_out:
-	return err;
-}
-
-static s32 wl_pattern_atoh(s8 *src, s8 *dst)
-{
-	int i;
-	if (strncmp(src, "0x", 2) != 0 && strncmp(src, "0X", 2) != 0) {
-		WL_ERR("Mask invalid format. Needs to start with 0x\n");
-		return -1;
-	}
-	src = src + 2;		/* Skip past 0x */
-	if (strlen(src) % 2 != 0) {
-		WL_ERR("Mask invalid format. Needs to be of even length\n");
-		return -1;
-	}
-	for (i = 0; *src != '\0'; i++) {
-		char num[3];
-		strncpy(num, src, 2);
-		num[2] = '\0';
-		dst[i] = (u8) simple_strtoul(num, NULL, 16);
-		src += 2;
-	}
-	return i;
-}
-
-static s32 wl_dongle_filter(struct net_device *ndev, u32 filter_mode)
-{
-	s8 iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
-							 '\0' + bitvec  */
-	const s8 *str;
-	struct wl_pkt_filter pkt_filter;
-	struct wl_pkt_filter *pkt_filterp;
-	s32 buf_len;
-	s32 str_len;
-	u32 mask_size;
-	u32 pattern_size;
-	s8 buf[256];
-	s32 err = 0;
-
-/* add a default packet filter pattern */
-	str = "pkt_filter_add";
-	str_len = strlen(str);
-	strncpy(buf, str, str_len);
-	buf[str_len] = '\0';
-	buf_len = str_len + 1;
-
-	pkt_filterp = (struct wl_pkt_filter *)(buf + str_len + 1);
-
-	/* Parse packet filter id. */
-	pkt_filter.id = cpu_to_le32(100);
-
-	/* Parse filter polarity. */
-	pkt_filter.negate_match = cpu_to_le32(0);
-
-	/* Parse filter type. */
-	pkt_filter.type = cpu_to_le32(0);
-
-	/* Parse pattern filter offset. */
-	pkt_filter.u.pattern.offset = cpu_to_le32(0);
-
-	/* Parse pattern filter mask. */
-	mask_size = cpu_to_le32(wl_pattern_atoh("0xff",
-						(char *)pkt_filterp->u.pattern.
-						mask_and_pattern));
-
-	/* Parse pattern filter pattern. */
-	pattern_size = cpu_to_le32(wl_pattern_atoh("0x00",
-						   (char *)&pkt_filterp->u.
-						   pattern.
-						   mask_and_pattern
-						   [mask_size]));
-
-	if (mask_size != pattern_size) {
-		WL_ERR("Mask and pattern not the same size\n");
-		err = -EINVAL;
-		goto dongle_filter_out;
-	}
-
-	pkt_filter.u.pattern.size_bytes = mask_size;
-	buf_len += WL_PKT_FILTER_FIXED_LEN;
-	buf_len += (WL_PKT_FILTER_PATTERN_FIXED_LEN + 2 * mask_size);
-
-	/* Keep-alive attributes are set in local
-	 * variable (keep_alive_pkt), and
-	 * then memcpy'ed into buffer (keep_alive_pktp) since there is no
-	 * guarantee that the buffer is properly aligned.
-	 */
-	memcpy((char *)pkt_filterp, &pkt_filter,
-	       WL_PKT_FILTER_FIXED_LEN + WL_PKT_FILTER_PATTERN_FIXED_LEN);
-
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, buf, buf_len);
-	if (err) {
-		if (err == -EOPNOTSUPP) {
-			WL_INFO("filter not supported\n");
-		} else {
-			WL_ERR("filter (%d)\n", err);
-		}
-		goto dongle_filter_out;
-	}
-
-	/* set mode to allow pattern */
-	brcmu_mkiovar("pkt_filter_mode", (char *)&filter_mode, 4, iovbuf,
-		    sizeof(iovbuf));
-	err = wl_dev_ioctl(ndev, BRCMF_C_SET_VAR, iovbuf, sizeof(iovbuf));
-	if (err) {
-		if (err == -EOPNOTSUPP) {
-			WL_INFO("filter_mode not supported\n");
-		} else {
-			WL_ERR("filter_mode (%d)\n", err);
-		}
-		goto dongle_filter_out;
-	}
-
-dongle_filter_out:
-	return err;
-}
-#endif				/* !EMBEDDED_PLATFORM */
-
 static s32 wl_dongle_eventmsg(struct net_device *ndev)
 {
 	s8 iovbuf[WL_EVENTING_MASK_LEN + 12];	/*  Room for "event_msgs" +
@@ -4026,24 +3806,6 @@ s32 wl_config_dongle(struct wl_priv *wl, bool need_lock)
 	if (need_lock)
 		rtnl_lock();
 
-#ifndef EMBEDDED_PLATFORM
-	err = wl_dongle_up(ndev, 0);
-	if (unlikely(err))
-		goto default_conf_out;
-	err = wl_dongle_country(ndev, 0);
-	if (unlikely(err))
-		goto default_conf_out;
-	err = wl_dongle_power(ndev, PM_FAST);
-	if (unlikely(err))
-		goto default_conf_out;
-	err = wl_dongle_glom(ndev, 0, BRCMF_SDALIGN);
-	if (unlikely(err))
-		goto default_conf_out;
-
-	wl_dongle_offload(ndev, 1, 0xf);
-	wl_dongle_filter(ndev, 1);
-#endif /* !EMBEDDED_PLATFORM */
-
 	wl_dongle_scantime(ndev, WL_SCAN_CHANNEL_TIME,
 			WL_SCAN_UNASSOC_TIME, WL_SCAN_PASSIVE_TIME);
 
-- 
1.7.1


