Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43382 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754550Ab1BMOlF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Feb 2011 09:41:05 -0500
Received: by mail-bw0-f46.google.com with SMTP id 15so4702350bwz.19
        for <linux-wireless@vger.kernel.org>; Sun, 13 Feb 2011 06:41:04 -0800 (PST)
From: Stanislav Fomichev <kernel@fomichev.me>
To: linux-wireless@vger.kernel.org
Cc: brudley@broadcom.com, gregkh@suse.de
Subject: [PATCH 6/8] brcm80211: replace bcopy with memcpy
Date: Sun, 13 Feb 2011 17:40:41 +0300
Message-Id: <1297608043-18381-6-git-send-email-kernel@fomichev.me>
In-Reply-To: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
References: <1297608043-18381-1-git-send-email-kernel@fomichev.me>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislav Fomichev <kernel@fomichev.me>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    2 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   40 +++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   32 ++++----
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   72 ++++++++--------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   10 +--
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |   55 ++++++------
 drivers/staging/brcm80211/include/osl.h            |    4 -
 drivers/staging/brcm80211/phy/wlc_phy_cmn.c        |   66 +++++++--------
 drivers/staging/brcm80211/phy/wlc_phy_lcn.c        |    5 +-
 drivers/staging/brcm80211/sys/wl_mac80211.c        |    4 +-
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |    2 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |    6 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |   90 ++++++++++----------
 drivers/staging/brcm80211/sys/wlc_rate.c           |    6 +-
 drivers/staging/brcm80211/sys/wlc_stf.c            |    2 +-
 drivers/staging/brcm80211/util/bcmotp.c            |    2 +-
 drivers/staging/brcm80211/util/bcmsrom.c           |    8 +-
 drivers/staging/brcm80211/util/bcmutils.c          |    2 +-
 drivers/staging/brcm80211/util/hnddma.c            |    8 +-
 drivers/staging/brcm80211/util/nvram/nvram_ro.c    |    4 +-
 drivers/staging/brcm80211/util/siutils.c           |    2 +-
 24 files changed, 208 insertions(+), 220 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index acf43a3..df9a139 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -324,7 +324,7 @@ int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
 			BCMSDH_ERROR(("%s: out of memory\n", __func__));
 			return BCME_NOMEM;
 		}
-		bcopy(cis, tmp_buf, length);
+		memcpy(tmp_buf, cis, length);
 		for (tmp_ptr = tmp_buf, ptr = cis; ptr < (cis + length - 4);
 		     tmp_ptr++) {
 			ptr += sprintf((char *)ptr, "%.2x ", *tmp_ptr & 0xff);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index d399b5c..6cde62a 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -441,7 +441,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 		val_size = sizeof(int);
 
 	if (plen >= (int)sizeof(int_val))
-		bcopy(params, &int_val, sizeof(int_val));
+		memcpy(&int_val, params, sizeof(int_val));
 
 	bool_val = (int_val != 0) ? true : false;
 
@@ -449,7 +449,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 	switch (actionid) {
 	case IOV_GVAL(IOV_MSGLEVEL):
 		int_val = (s32) sd_msglevel;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_MSGLEVEL):
@@ -458,7 +458,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	case IOV_GVAL(IOV_BLOCKMODE):
 		int_val = (s32) si->sd_blockmode;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_BLOCKMODE):
@@ -472,7 +472,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 			break;
 		}
 		int_val = (s32) si->client_block_size[int_val];
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_BLOCKSIZE):
@@ -514,12 +514,12 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	case IOV_GVAL(IOV_RXCHAIN):
 		int_val = false;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_GVAL(IOV_DMA):
 		int_val = (s32) si->sd_use_dma;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_DMA):
@@ -528,7 +528,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	case IOV_GVAL(IOV_USEINTS):
 		int_val = (s32) si->use_client_ints;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_USEINTS):
@@ -542,7 +542,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	case IOV_GVAL(IOV_DIVISOR):
 		int_val = (u32) sd_divisor;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_DIVISOR):
@@ -551,7 +551,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	case IOV_GVAL(IOV_POWER):
 		int_val = (u32) sd_power;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_POWER):
@@ -560,7 +560,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	case IOV_GVAL(IOV_CLOCK):
 		int_val = (u32) sd_clock;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_CLOCK):
@@ -569,7 +569,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	case IOV_GVAL(IOV_SDMODE):
 		int_val = (u32) sd_sdmode;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_SDMODE):
@@ -578,7 +578,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	case IOV_GVAL(IOV_HISPEED):
 		int_val = (u32) sd_hiok;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_HISPEED):
@@ -587,12 +587,12 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	case IOV_GVAL(IOV_NUMINTS):
 		int_val = (s32) si->intrcount;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_GVAL(IOV_NUMLOCALINTS):
 		int_val = (s32) 0;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_GVAL(IOV_HOSTREG):
@@ -621,7 +621,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 				int_val = 32;	/* sdioh_sdmmc_rreg(si,
 						 sd_ptr->offset); */
 
-			bcopy(&int_val, arg, sizeof(int_val));
+			memcpy(arg, &int_val, sizeof(int_val));
 			break;
 		}
 
@@ -657,7 +657,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 			}
 
 			int_val = (int)data;
-			bcopy(&int_val, arg, sizeof(int_val));
+			memcpy(arg, &int_val, sizeof(int_val));
 			break;
 		}
 
@@ -1048,14 +1048,14 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 
 		/* For a write, copy the buffer data into the packet. */
 		if (write)
-			bcopy(buffer, mypkt->data, buflen_u);
+			memcpy(mypkt->data, buffer, buflen_u);
 
 		Status =
 		    sdioh_request_packet(sd, fix_inc, write, func, addr, mypkt);
 
 		/* For a read, copy the packet data back to the buffer. */
 		if (!write)
-			bcopy(mypkt->data, buffer, buflen_u);
+			memcpy(buffer, mypkt->data, buflen_u);
 
 		pkt_buf_free_skb(sd->osh, mypkt, write ? true : false);
 	} else if (((u32) (pkt->data) & DMA_ALIGN_MASK) != 0) {
@@ -1075,14 +1075,14 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 
 		/* For a write, copy the buffer data into the packet. */
 		if (write)
-			bcopy(pkt->data, mypkt->data, pkt->len);
+			memcpy(mypkt->data, pkt->data, pkt->len);
 
 		Status =
 		    sdioh_request_packet(sd, fix_inc, write, func, addr, mypkt);
 
 		/* For a read, copy the packet data back to the buffer. */
 		if (!write)
-			bcopy(mypkt->data, pkt->data, mypkt->len);
+			memcpy(pkt->data, mypkt->data, mypkt->len);
 
 		pkt_buf_free_skb(sd->osh, mypkt, write ? true : false);
 	} else {		/* case 3: We have a packet and
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index b7b527f..9dabd67 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -286,7 +286,7 @@ dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf, int len)
 
 		slen = strlen("wme_dp") + 1;
 		if (len >= (int)(slen + sizeof(int)))
-			bcopy(((char *)buf + slen), &val, sizeof(int));
+			memcpy(&val, (char *)buf + slen, sizeof(int));
 		dhd->wme_dp = (u8) ltoh32(val);
 	}
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 3dbf72e..01943f3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -214,7 +214,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 		goto exit;
 
 	if (plen >= (int)sizeof(int_val))
-		bcopy(params, &int_val, sizeof(int_val));
+		memcpy(&int_val, params, sizeof(int_val));
 
 	switch (actionid) {
 	case IOV_GVAL(IOV_VERSION):
@@ -224,7 +224,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_MSGLEVEL):
 		int_val = (s32) dhd_msg_level;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_MSGLEVEL):
@@ -239,12 +239,12 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_BCMERROR):
 		int_val = (s32) dhd_pub->bcmerror;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_GVAL(IOV_WDTICK):
 		int_val = (s32) dhd_watchdog_ms;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_WDTICK):
@@ -262,7 +262,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 #ifdef DHD_DEBUG
 	case IOV_GVAL(IOV_DCONSOLE_POLL):
 		int_val = (s32) dhd_console_ms;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_DCONSOLE_POLL):
@@ -290,7 +290,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_IOCTLTIMEOUT):{
 			int_val = (s32) dhd_os_get_ioctl_resp_timeout();
-			bcopy(&int_val, arg, sizeof(int_val));
+			memcpy(arg, &int_val, sizeof(int_val));
 			break;
 		}
 
@@ -913,7 +913,7 @@ wl_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 			DHD_TRACE(("Converted to WLC_E_LINK type %d\n", temp));
 
 			temp = ntoh32(WLC_E_NDIS_LINK);
-			memcpy((void *)(&pvt_data->event.event_type), &temp,
+			memcpy(&pvt_data->event.event_type, &temp,
 			       sizeof(pvt_data->event.event_type));
 		}
 		break;
@@ -1031,7 +1031,7 @@ dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 	enable_parm.enable = htod32(enable);
 
 	buf_len += sizeof(enable_parm);
-	memcpy((char *)pkt_filterp, &enable_parm, sizeof(enable_parm));
+	memcpy(pkt_filterp, &enable_parm, sizeof(enable_parm));
 
 	/* Enable/disable the specified filter. */
 	rc = dhdcdc_set_ioctl(dhd, 0, WLC_SET_VAR, buf, buf_len);
@@ -1174,7 +1174,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	 ** then memcpy'ed into buffer (keep_alive_pktp) since there is no
 	 ** guarantee that the buffer is properly aligned.
 	 */
-	memcpy((char *)pkt_filterp,
+	memcpy(pkt_filterp,
 	       &pkt_filter,
 	       WL_PKT_FILTER_FIXED_LEN + WL_PKT_FILTER_PATTERN_FIXED_LEN);
 
@@ -1263,8 +1263,7 @@ int dhd_preinit_ioctls(dhd_pub_t *dhd)
 			DHD_ERROR(("%s: can't set MAC address , error=%d\n",
 				   __func__, ret));
 		} else
-			memcpy(dhd->mac.octet, (void *)&ea_addr,
-			       ETH_ALEN);
+			memcpy(dhd->mac.octet, &ea_addr, ETH_ALEN);
 	}
 #endif				/* GET_CUSTOM_MAC_ENABLE */
 
@@ -1548,8 +1547,8 @@ int dhd_iscan_delete_bss(void *dhdp, void *addr, iscan_buf_t *iscan_skip)
 								(bi->length));
 /*
 			if(bi && bi_new) {
-				bcopy(bi, bi_new, results->buflen -
-				dtoh32(bi_new->length));
+				memcpy(bi_new, bi, results->buflen -
+				       dtoh32(bi_new->length));
 				results->buflen -= dtoh32(bi_new->length);
 			}
 */
@@ -1572,9 +1571,10 @@ int dhd_iscan_delete_bss(void *dhdp, void *addr, iscan_buf_t *iscan_skip)
 							    (wl_bss_info_t *)((unsigned long)bi +
 								 dtoh32
 								 (bi->length));
-							bcopy(bi, bi_new,
-							      dtoh32
-							      (bi->length));
+							memcpy(bi_new,
+							       bi,
+							       dtoh32
+							       (bi->length));
 							bi_new =
 							    (wl_bss_info_t *)((unsigned long)bi_new +
 								 dtoh32
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
index c3f18bb..06e2e85 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
@@ -151,7 +151,7 @@ int dhd_custom_get_mac_address(unsigned char *buf)
 	{
 		struct ether_addr ea_example = {
 			{0x00, 0x11, 0x22, 0x33, 0x44, 0xFF} };
-		bcopy((char *)&ea_example, buf, sizeof(struct ether_addr));
+		memcpy(buf, &ea_example, sizeof(struct ether_addr));
 	}
 #endif				/* EXAMPLE_GET_MAC */
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index db45083..c09e9a5 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -2203,7 +2203,7 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 	bcm_mkiovar("event_msgs", dhdp->eventmask, WL_EVENTING_MASK_LEN, iovbuf,
 		    sizeof(iovbuf));
 	dhdcdc_query_ioctl(dhdp, 0, WLC_GET_VAR, iovbuf, sizeof(iovbuf));
-	bcopy(iovbuf, dhdp->eventmask, WL_EVENTING_MASK_LEN);
+	memcpy(dhdp->eventmask, iovbuf, WL_EVENTING_MASK_LEN);
 
 	setbit(dhdp->eventmask, WLC_E_SET_SSID);
 	setbit(dhdp->eventmask, WLC_E_PRUNE);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 3edce44..11680ee 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -946,7 +946,7 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 			}
 
 			PKTALIGN(osh, new, pkt->len, DHD_SDALIGN);
-			bcopy(pkt->data, new->data, pkt->len);
+			memcpy(new->data, pkt->data, pkt->len);
 			if (free_pkt)
 				pkt_buf_free_skb(osh, pkt, true);
 			/* free the pkt if canned one is not used */
@@ -1396,7 +1396,7 @@ int dhd_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 
 	dhd_os_sdlock(bus->dhd);
 	rxlen = bus->rxlen;
-	bcopy(bus->rxctl, msg, min(msglen, rxlen));
+	memcpy(msg, bus->rxctl, min(msglen, rxlen));
 	bus->rxlen = 0;
 	dhd_os_sdunlock(bus->dhd);
 
@@ -1659,7 +1659,7 @@ static int dhdsdio_pktgen_get(dhd_bus_t *bus, u8 *arg)
 	pktgen.mode = bus->pktgen_mode;
 	pktgen.stop = bus->pktgen_stop;
 
-	bcopy(&pktgen, arg, sizeof(pktgen));
+	memcpy(arg, &pktgen, sizeof(pktgen));
 
 	return 0;
 }
@@ -1669,7 +1669,7 @@ static int dhdsdio_pktgen_set(dhd_bus_t *bus, u8 *arg)
 	dhd_pktgen_t pktgen;
 	uint oldcnt, oldmode;
 
-	bcopy(arg, &pktgen, sizeof(pktgen));
+	memcpy(&pktgen, arg, sizeof(pktgen));
 	if (pktgen.version != DHD_PKTGEN_VERSION)
 		return BCME_BADARG;
 
@@ -2095,7 +2095,7 @@ int dhdsdio_downloadvars(dhd_bus_t *bus, void *arg, int len)
 
 	/* Copy the passed variables, which should include the
 		 terminating double-null */
-	bcopy(arg, bus->vars, bus->varsz);
+	memcpy(bus->vars, arg, bus->varsz);
 err:
 	return bcmerror;
 }
@@ -2118,7 +2118,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 		goto exit;
 
 	if (plen >= (int)sizeof(int_val))
-		bcopy(params, &int_val, sizeof(int_val));
+		memcpy(&int_val, params, sizeof(int_val));
 
 	bool_val = (int_val != 0) ? true : false;
 
@@ -2138,7 +2138,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			bcmerror = dhdsdio_bussleep(bus, bool_val);
 		} else {
 			int_val = (s32) bus->sleeping;
-			bcopy(&int_val, arg, val_size);
+			memcpy(arg, &int_val, val_size);
 		}
 		goto exit;
 	}
@@ -2152,7 +2152,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 	switch (actionid) {
 	case IOV_GVAL(IOV_INTR):
 		int_val = (s32) bus->intr;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_INTR):
@@ -2173,7 +2173,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_POLLRATE):
 		int_val = (s32) bus->pollrate;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_POLLRATE):
@@ -2183,7 +2183,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_IDLETIME):
 		int_val = bus->idletime;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_IDLETIME):
@@ -2195,7 +2195,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_IDLECLOCK):
 		int_val = (s32) bus->idleclock;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_IDLECLOCK):
@@ -2204,7 +2204,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_SD1IDLE):
 		int_val = (s32) sd1idle;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_SD1IDLE):
@@ -2223,8 +2223,8 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			ASSERT(plen >= 2 * sizeof(int));
 
 			address = (u32) int_val;
-			bcopy((char *)params + sizeof(int_val), &int_val,
-			      sizeof(int_val));
+			memcpy(&int_val, (char *)params + sizeof(int_val),
+			       sizeof(int_val));
 			size = (uint) int_val;
 
 			/* Do some validation */
@@ -2267,12 +2267,12 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_MEMSIZE):
 		int_val = (s32) bus->ramsize;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_GVAL(IOV_SDIOD_DRIVE):
 		int_val = (s32) dhd_sdiod_drive_strength;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_SDIOD_DRIVE):
@@ -2291,7 +2291,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_READAHEAD):
 		int_val = (s32) dhd_readahead;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_READAHEAD):
@@ -2302,7 +2302,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_SDRXCHAIN):
 		int_val = (s32) bus->use_rxchain;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_SDRXCHAIN):
@@ -2313,7 +2313,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 		break;
 	case IOV_GVAL(IOV_ALIGNCTL):
 		int_val = (s32) dhd_alignctl;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_ALIGNCTL):
@@ -2322,13 +2322,13 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_SDALIGN):
 		int_val = DHD_SDALIGN;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 #ifdef DHD_DEBUG
 	case IOV_GVAL(IOV_VARS):
 		if (bus->varsz < (uint) len)
-			bcopy(bus->vars, arg, bus->varsz);
+			memcpy(arg, bus->vars, bus->varsz);
 		else
 			bcmerror = BCME_BUFTOOSHORT;
 		break;
@@ -2347,7 +2347,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			int_val = (s32) bcmsdh_reg_read(bus->sdh, addr, size);
 			if (bcmsdh_regfail(bus->sdh))
 				bcmerror = BCME_SDIO_ERROR;
-			bcopy(&int_val, arg, sizeof(s32));
+			memcpy(arg, &int_val, sizeof(s32));
 			break;
 		}
 
@@ -2373,14 +2373,14 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			sdreg_t sdreg;
 			u32 addr, size;
 
-			bcopy(params, &sdreg, sizeof(sdreg));
+			memcpy(&sdreg, params, sizeof(sdreg));
 
 			addr = SI_ENUM_BASE + sdreg.offset;
 			size = sdreg.func;
 			int_val = (s32) bcmsdh_reg_read(bus->sdh, addr, size);
 			if (bcmsdh_regfail(bus->sdh))
 				bcmerror = BCME_SDIO_ERROR;
-			bcopy(&int_val, arg, sizeof(s32));
+			memcpy(arg, &int_val, sizeof(s32));
 			break;
 		}
 
@@ -2389,7 +2389,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			sdreg_t sdreg;
 			u32 addr, size;
 
-			bcopy(params, &sdreg, sizeof(sdreg));
+			memcpy(&sdreg, params, sizeof(sdreg));
 
 			addr = SI_ENUM_BASE + sdreg.offset;
 			size = sdreg.func;
@@ -2420,7 +2420,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_FORCEEVEN):
 		int_val = (s32) forcealign;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_FORCEEVEN):
@@ -2429,7 +2429,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_TXBOUND):
 		int_val = (s32) dhd_txbound;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_TXBOUND):
@@ -2438,7 +2438,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_RXBOUND):
 		int_val = (s32) dhd_rxbound;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_RXBOUND):
@@ -2447,7 +2447,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_GVAL(IOV_TXMINMAX):
 		int_val = (s32) dhd_txminmax;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_TXMINMAX):
@@ -2458,7 +2458,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 #ifdef SDTEST
 	case IOV_GVAL(IOV_EXTLOOP):
 		int_val = (s32) bus->ext_loop;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 		break;
 
 	case IOV_SVAL(IOV_EXTLOOP):
@@ -2492,7 +2492,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 		/* Get its status */
 		int_val = (bool) bus->dhd->dongle_reset;
-		bcopy(&int_val, arg, val_size);
+		memcpy(arg, &int_val, val_size);
 
 		break;
 
@@ -2537,7 +2537,7 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 			return BCME_NOMEM;
 
 		memset(vbuffer, 0, varsize);
-		bcopy(bus->vars, vbuffer, bus->varsz);
+		memcpy(vbuffer, bus->vars, bus->varsz);
 
 		/* Write the vars list */
 		bcmerror =
@@ -3100,13 +3100,13 @@ dhdsdio_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 	ASSERT(bus->rxctl >= bus->rxbuf);
 
 	/* Copy the already-read portion over */
-	bcopy(hdr, bus->rxctl, firstread);
+	memcpy(bus->rxctl, hdr, firstread);
 	if (len <= firstread)
 		goto gotpkt;
 
 	/* Copy the full data pkt in gSPI case and process ioctl. */
 	if (bus->bus == SPI_BUS) {
-		bcopy(hdr, bus->rxctl, len);
+		memcpy(bus->rxctl, hdr, len);
 		goto gotpkt;
 	}
 
@@ -3770,7 +3770,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 			dhd_os_sdunlock_rxq(bus->dhd);
 
 			/* Now check the header */
-			bcopy(rxbuf, bus->rxhdr, SDPCM_HDRLEN);
+			memcpy(bus->rxhdr, rxbuf, SDPCM_HDRLEN);
 
 			/* Extract hardware header fields */
 			len = ltoh16_ua(bus->rxhdr);
@@ -4136,7 +4136,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 
 		/* Copy the already-read portion */
 		skb_push(pkt, firstread);
-		bcopy(bus->rxhdr, pkt->data, firstread);
+		memcpy(pkt->data, bus->rxhdr, firstread);
 
 #ifdef DHD_DEBUG
 		if (DHD_BYTES_ON() && DHD_DATA_ON())
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 991463f..6f7277d 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -1039,12 +1039,10 @@ wl_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	 ** If SSID is zero join based on BSSID only
 	 */
 	memset(&join_params, 0, sizeof(join_params));
-	memcpy((void *)join_params.ssid.SSID, (void *)params->ssid,
-	       params->ssid_len);
+	memcpy(join_params.ssid.SSID, params->ssid, params->ssid_len);
 	join_params.ssid.SSID_len = htod32(params->ssid_len);
 	if (params->bssid)
-		memcpy(&join_params.params.bssid, params->bssid,
-		       ETH_ALEN);
+		memcpy(&join_params.params.bssid, params->bssid, ETH_ALEN);
 	else
 		memset(&join_params.params.bssid, 0, ETH_ALEN);
 
@@ -1533,7 +1531,7 @@ wl_add_keyext(struct wiphy *wiphy, struct net_device *dev,
 	/* Instead of bcast for ea address for default wep keys,
 		 driver needs it to be Null */
 	if (!is_multicast_ether_addr(mac_addr))
-		memcpy((char *)&key.ea, (void *)mac_addr, ETH_ALEN);
+		memcpy(&key.ea, mac_addr, ETH_ALEN);
 	key.len = (u32) params->key_len;
 	/* check for key index change */
 	if (key.len == 0) {
@@ -3692,7 +3690,7 @@ static s32 wl_dongle_filter(struct net_device *ndev, u32 filter_mode)
 	 * then memcpy'ed into buffer (keep_alive_pktp) since there is no
 	 * guarantee that the buffer is properly aligned.
 	 */
-	memcpy((char *)pkt_filterp, &pkt_filter,
+	memcpy(pkt_filterp, &pkt_filter,
 	       WL_PKT_FILTER_FIXED_LEN + WL_PKT_FILTER_PATTERN_FIXED_LEN);
 
 	err = wl_dev_ioctl(ndev, WLC_SET_VAR, buf, buf_len);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index db6e68e..fbee070 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -288,7 +288,7 @@ dev_wlc_bufvar_get(struct net_device *dev, char *name, char *buf, int buflen)
 	    dev_wlc_ioctl(dev, WLC_GET_VAR, (void *)ioctlbuf,
 			  MAX_WLIW_IOCTL_LEN);
 	if (!error)
-		bcopy(ioctlbuf, buf, buflen);
+		memcpy(buf, ioctlbuf, buflen);
 
 	return error;
 }
@@ -840,7 +840,7 @@ wl_iw_mlme(struct net_device *dev,
 	}
 
 	scbval.val = mlme->reason_code;
-	bcopy(&mlme->addr.sa_data, &scbval.ea, ETH_ALEN);
+	memcpy(&scbval.ea, &mlme->addr.sa_data, ETH_ALEN);
 
 	if (mlme->cmd == IW_MLME_DISASSOC) {
 		scbval.val = htod32(scbval.val);
@@ -1077,7 +1077,7 @@ static void wl_iw_set_event_mask(struct net_device *dev)
 	char iovbuf[WL_EVENTING_MASK_LEN + 12];
 
 	dev_iw_iovar_getbuf(dev, "event_msgs", "", 0, iovbuf, sizeof(iovbuf));
-	bcopy(iovbuf, eventmask, WL_EVENTING_MASK_LEN);
+	memcpy(eventmask, iovbuf, WL_EVENTING_MASK_LEN);
 	setbit(eventmask, WLC_E_SCAN_COMPLETE);
 	dev_iw_iovar_setbuf(dev, "event_msgs", eventmask, WL_EVENTING_MASK_LEN,
 			    iovbuf, sizeof(iovbuf));
@@ -2545,8 +2545,7 @@ wl_iw_set_encodeext(struct net_device *dev,
 	key.len = iwe->key_len;
 
 	if (!is_multicast_ether_addr(iwe->addr.sa_data))
-		bcopy((void *)&iwe->addr.sa_data, (char *)&key.ea,
-		      ETH_ALEN);
+		memcpy(&key.ea, &iwe->addr.sa_data, ETH_ALEN);
 
 	if (key.len == 0) {
 		if (iwe->ext_flags & IW_ENCODE_EXT_SET_TX_KEY) {
@@ -2571,13 +2570,13 @@ wl_iw_set_encodeext(struct net_device *dev,
 			key.flags = WL_PRIMARY_KEY;
 		}
 
-		bcopy((void *)iwe->key, key.data, iwe->key_len);
+		memcpy(key.data, iwe->key, iwe->key_len);
 
 		if (iwe->alg == IW_ENCODE_ALG_TKIP) {
 			u8 keybuf[8];
-			bcopy(&key.data[24], keybuf, sizeof(keybuf));
-			bcopy(&key.data[16], &key.data[24], sizeof(keybuf));
-			bcopy(keybuf, &key.data[16], sizeof(keybuf));
+			memcpy(keybuf, &key.data[24], sizeof(keybuf));
+			memcpy(&key.data[24], &key.data[16], sizeof(keybuf));
+			memcpy(&key.data[16], keybuf, sizeof(keybuf));
 		}
 
 		if (iwe->ext_flags & IW_ENCODE_EXT_RX_SEQ_VALID) {
@@ -2651,10 +2650,10 @@ wl_iw_set_pmksa(struct net_device *dev,
 			uint j;
 			pmkidptr = &pmkid;
 
-			bcopy(&iwpmksa->bssid.sa_data[0],
-			      &pmkidptr->pmkid[0].BSSID, ETH_ALEN);
-			bcopy(&iwpmksa->pmkid[0], &pmkidptr->pmkid[0].PMKID,
-			      WPA2_PMKID_LEN);
+			memcpy(&pmkidptr->pmkid[0].BSSID,
+			       &iwpmksa->bssid.sa_data[0], ETH_ALEN);
+			memcpy(&pmkidptr->pmkid[0].PMKID,
+			       &iwpmksa->pmkid[0], WPA2_PMKID_LEN);
 
 			WL_WSEC("wl_iw_set_pmksa:IW_PMKSA_REMOVE:PMKID: %pM = ",
 				&pmkidptr->pmkid[0].BSSID);
@@ -2673,12 +2672,12 @@ wl_iw_set_pmksa(struct net_device *dev,
 		    && (i < pmkid_list.pmkids.npmkid)) {
 			memset(&pmkid_list.pmkids.pmkid[i], 0, sizeof(pmkid_t));
 			for (; i < (pmkid_list.pmkids.npmkid - 1); i++) {
-				bcopy(&pmkid_list.pmkids.pmkid[i + 1].BSSID,
-				      &pmkid_list.pmkids.pmkid[i].BSSID,
-				      ETH_ALEN);
-				bcopy(&pmkid_list.pmkids.pmkid[i + 1].PMKID,
-				      &pmkid_list.pmkids.pmkid[i].PMKID,
-				      WPA2_PMKID_LEN);
+				memcpy(&pmkid_list.pmkids.pmkid[i].BSSID,
+				       &pmkid_list.pmkids.pmkid[i + 1].BSSID,
+				       ETH_ALEN);
+				memcpy(&pmkid_list.pmkids.pmkid[i].PMKID,
+				       &pmkid_list.pmkids.pmkid[i + 1].PMKID,
+				       WPA2_PMKID_LEN);
 			}
 			pmkid_list.pmkids.npmkid--;
 		} else
@@ -2692,12 +2691,12 @@ wl_iw_set_pmksa(struct net_device *dev,
 			     &pmkid_list.pmkids.pmkid[i].BSSID, ETH_ALEN))
 				break;
 		if (i < MAXPMKID) {
-			bcopy(&iwpmksa->bssid.sa_data[0],
-			      &pmkid_list.pmkids.pmkid[i].BSSID,
-			      ETH_ALEN);
-			bcopy(&iwpmksa->pmkid[0],
-			      &pmkid_list.pmkids.pmkid[i].PMKID,
-			      WPA2_PMKID_LEN);
+			memcpy(&pmkid_list.pmkids.pmkid[i].BSSID,
+			       &iwpmksa->bssid.sa_data[0],
+			       ETH_ALEN);
+			memcpy(&pmkid_list.pmkids.pmkid[i].PMKID,
+			       &iwpmksa->pmkid[0],
+			       WPA2_PMKID_LEN);
 			if (i == pmkid_list.pmkids.npmkid)
 				pmkid_list.pmkids.npmkid++;
 		} else
@@ -3483,9 +3482,9 @@ void wl_iw_event(struct net_device *dev, wl_event_msg_t *e, void *data)
 					if (pmkidcand->preauth)
 						iwpmkidcand->flags |=
 						    IW_PMKID_CAND_PREAUTH;
-					bcopy(&pmkidcand->BSSID,
-					      &iwpmkidcand->bssid.sa_data,
-					      ETH_ALEN);
+					memcpy(&iwpmkidcand->bssid.sa_data,
+					       &pmkidcand->BSSID,
+					       ETH_ALEN);
 #ifndef SANDGATE2G
 					wireless_send_event(dev, cmd, &wrqu,
 							    extra);
diff --git a/drivers/staging/brcm80211/include/osl.h b/drivers/staging/brcm80211/include/osl.h
index b282356..ee42450 100644
--- a/drivers/staging/brcm80211/include/osl.h
+++ b/drivers/staging/brcm80211/include/osl.h
@@ -111,8 +111,6 @@ extern void osl_dma_unmap(struct osl_info *osh, uint pa, uint size,
 #include <linux/kernel.h>	/* for vsn/printf's */
 #include <linux/string.h>	/* for mem*, str* */
 #endif
-/* bcopy's: Linux kernel doesn't provide these (anymore) */
-#define	bcopy(src, dst, len)	memcpy((dst), (src), (len))
 
 /* register access macros */
 #ifndef IL_BIGENDIAN
@@ -205,8 +203,6 @@ extern void osl_dma_unmap(struct osl_info *osh, uint pa, uint size,
 	} while (0)
 #endif				/* IL_BIGENDIAN */
 
-#define	bcopy(src, dst, len)	memcpy((dst), (src), (len))
-
 /* packet primitives */
 extern struct sk_buff *pkt_buf_get_skb(struct osl_info *osh, uint len);
 extern void pkt_buf_free_skb(struct osl_info *osh, struct sk_buff *skb, bool send);
diff --git a/drivers/staging/brcm80211/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/phy/wlc_phy_cmn.c
index 3bed37c..95f9511 100644
--- a/drivers/staging/brcm80211/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/phy/wlc_phy_cmn.c
@@ -779,7 +779,7 @@ wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype, char *vars
 
 	pi->vars = (char *)&pi->vars;
 
-	bcopy(&pi->pubpi, &pi->pubpi_ro, sizeof(wlc_phy_t));
+	memcpy(&pi->pubpi_ro, &pi->pubpi, sizeof(wlc_phy_t));
 
 	return &pi->pubpi_ro;
 
@@ -1619,40 +1619,36 @@ void wlc_phy_txpower_target_set(wlc_phy_t *ppi, struct txpwr_limits *txpwr)
 	bool mac_enabled = false;
 	phy_info_t *pi = (phy_info_t *) ppi;
 
-	bcopy(&txpwr->cck[0], &pi->tx_user_target[TXP_FIRST_CCK],
-	      WLC_NUM_RATES_CCK);
-
-	bcopy(&txpwr->ofdm[0], &pi->tx_user_target[TXP_FIRST_OFDM],
-	      WLC_NUM_RATES_OFDM);
-	bcopy(&txpwr->ofdm_cdd[0], &pi->tx_user_target[TXP_FIRST_OFDM_20_CDD],
-	      WLC_NUM_RATES_OFDM);
-
-	bcopy(&txpwr->ofdm_40_siso[0],
-	      &pi->tx_user_target[TXP_FIRST_OFDM_40_SISO], WLC_NUM_RATES_OFDM);
-	bcopy(&txpwr->ofdm_40_cdd[0],
-	      &pi->tx_user_target[TXP_FIRST_OFDM_40_CDD], WLC_NUM_RATES_OFDM);
-
-	bcopy(&txpwr->mcs_20_siso[0],
-	      &pi->tx_user_target[TXP_FIRST_MCS_20_SISO],
-	      WLC_NUM_RATES_MCS_1_STREAM);
-	bcopy(&txpwr->mcs_20_cdd[0], &pi->tx_user_target[TXP_FIRST_MCS_20_CDD],
-	      WLC_NUM_RATES_MCS_1_STREAM);
-	bcopy(&txpwr->mcs_20_stbc[0],
-	      &pi->tx_user_target[TXP_FIRST_MCS_20_STBC],
-	      WLC_NUM_RATES_MCS_1_STREAM);
-	bcopy(&txpwr->mcs_20_mimo[0], &pi->tx_user_target[TXP_FIRST_MCS_20_SDM],
-	      WLC_NUM_RATES_MCS_2_STREAM);
-
-	bcopy(&txpwr->mcs_40_siso[0],
-	      &pi->tx_user_target[TXP_FIRST_MCS_40_SISO],
-	      WLC_NUM_RATES_MCS_1_STREAM);
-	bcopy(&txpwr->mcs_40_cdd[0], &pi->tx_user_target[TXP_FIRST_MCS_40_CDD],
-	      WLC_NUM_RATES_MCS_1_STREAM);
-	bcopy(&txpwr->mcs_40_stbc[0],
-	      &pi->tx_user_target[TXP_FIRST_MCS_40_STBC],
-	      WLC_NUM_RATES_MCS_1_STREAM);
-	bcopy(&txpwr->mcs_40_mimo[0], &pi->tx_user_target[TXP_FIRST_MCS_40_SDM],
-	      WLC_NUM_RATES_MCS_2_STREAM);
+	memcpy(&pi->tx_user_target[TXP_FIRST_CCK], &txpwr->cck[0],
+	       WLC_NUM_RATES_CCK);
+
+	memcpy(&pi->tx_user_target[TXP_FIRST_OFDM], &txpwr->ofdm[0],
+	       WLC_NUM_RATES_OFDM);
+	memcpy(&pi->tx_user_target[TXP_FIRST_OFDM_20_CDD], &txpwr->ofdm_cdd[0],
+	       WLC_NUM_RATES_OFDM);
+
+	memcpy(&pi->tx_user_target[TXP_FIRST_OFDM_40_SISO],
+	       &txpwr->ofdm_40_siso[0], WLC_NUM_RATES_OFDM);
+	memcpy(&pi->tx_user_target[TXP_FIRST_OFDM_40_CDD],
+	       &txpwr->ofdm_40_cdd[0], WLC_NUM_RATES_OFDM);
+
+	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_20_SISO],
+	       &txpwr->mcs_20_siso[0], WLC_NUM_RATES_MCS_1_STREAM);
+	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_20_CDD],
+	       &txpwr->mcs_20_cdd[0], WLC_NUM_RATES_MCS_1_STREAM);
+	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_20_STBC],
+	       &txpwr->mcs_20_stbc[0], WLC_NUM_RATES_MCS_1_STREAM);
+	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_20_SDM],
+	       &txpwr->mcs_20_mimo[0], WLC_NUM_RATES_MCS_2_STREAM);
+
+	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_40_SISO],
+	       &txpwr->mcs_40_siso[0], WLC_NUM_RATES_MCS_1_STREAM);
+	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_40_CDD],
+	       &txpwr->mcs_40_cdd[0], WLC_NUM_RATES_MCS_1_STREAM);
+	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_40_STBC],
+	       &txpwr->mcs_40_stbc[0], WLC_NUM_RATES_MCS_1_STREAM);
+	memcpy(&pi->tx_user_target[TXP_FIRST_MCS_40_SDM],
+	       &txpwr->mcs_40_mimo[0], WLC_NUM_RATES_MCS_2_STREAM);
 
 	if (R_REG(pi->sh->osh, &pi->regs->maccontrol) & MCTL_EN_MAC)
 		mac_enabled = true;
diff --git a/drivers/staging/brcm80211/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
index 3ac2b49..1b42966 100644
--- a/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
@@ -1965,8 +1965,9 @@ wlc_lcnphy_tx_iqlo_cal(phy_info_t *pi,
 			    tbl_iqcal_gainparams_lcnphy[band_idx][j][2];
 			cal_gains.pad_gain =
 			    tbl_iqcal_gainparams_lcnphy[band_idx][j][3];
-			bcopy(&tbl_iqcal_gainparams_lcnphy[band_idx][j][3],
-			      ncorr_override, sizeof(ncorr_override));
+			memcpy(ncorr_override,
+			      &tbl_iqcal_gainparams_lcnphy[band_idx][j][3],
+			      sizeof(ncorr_override));
 			break;
 		}
 	}
diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index 0c87baa..c1c9711 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -762,7 +762,7 @@ static struct wl_info *wl_attach(u16 vendor, u16 device, unsigned long regs,
 		goto fail;
 	}
 
-	bcopy(&wl->pub->cur_etheraddr, perm, ETH_ALEN);
+	memcpy(perm, &wl->pub->cur_etheraddr, ETH_ALEN);
 	ASSERT(is_valid_ether_addr(perm));
 	SET_IEEE80211_PERM_ADDR(hw, perm);
 
@@ -1718,7 +1718,7 @@ int wl_ucode_init_buf(struct wl_info *wl, void **pbuf, u32 idx)
 					printf("fail to alloc %d bytes\n",
 					       hdr->len);
 				}
-				bcopy(pdata, *pbuf, hdr->len);
+				memcpy(*pbuf, pdata, hdr->len);
 				return 0;
 			}
 		}
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index cb98baa..dcc2969 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -1329,7 +1329,7 @@ void wlc_ampdu_macaddr_upd(struct wlc_info *wlc)
 
 	/* driver needs to write the ta in the template; ta is at offset 16 */
 	memset(template, 0, sizeof(template));
-	bcopy((char *)wlc->pub->cur_etheraddr.octet, template, ETH_ALEN);
+	memcpy(template, wlc->pub->cur_etheraddr.octet, ETH_ALEN);
 	wlc_write_template_ram(wlc, (T_BA_TPL_BASE + 16), (T_RAM_ACCESS_SZ * 2),
 			       template);
 }
diff --git a/drivers/staging/brcm80211/sys/wlc_bmac.c b/drivers/staging/brcm80211/sys/wlc_bmac.c
index 69f600a..a74d2a1 100644
--- a/drivers/staging/brcm80211/sys/wlc_bmac.c
+++ b/drivers/staging/brcm80211/sys/wlc_bmac.c
@@ -1350,13 +1350,13 @@ void wlc_bmac_wait_for_wake(struct wlc_hw_info *wlc_hw)
 
 void wlc_bmac_hw_etheraddr(struct wlc_hw_info *wlc_hw, struct ether_addr *ea)
 {
-	bcopy(&wlc_hw->etheraddr, ea, ETH_ALEN);
+	memcpy(ea, &wlc_hw->etheraddr, ETH_ALEN);
 }
 
 void wlc_bmac_set_hw_etheraddr(struct wlc_hw_info *wlc_hw,
 			       struct ether_addr *ea)
 {
-	bcopy(ea, &wlc_hw->etheraddr, ETH_ALEN);
+	memcpy(&wlc_hw->etheraddr, ea, ETH_ALEN);
 }
 
 int wlc_bmac_bandtype(struct wlc_hw_info *wlc_hw)
@@ -1811,7 +1811,7 @@ wlc_bmac_write_template_ram(struct wlc_hw_info *wlc_hw, int offset, int len,
 	be_bit = (R_REG(osh, &regs->maccontrol) & MCTL_BIGEND) != 0;
 
 	while (len > 0) {
-		bcopy((u8 *) buf, &word, sizeof(u32));
+		memcpy(&word, buf, sizeof(u32));
 
 		if (be_bit)
 			word = hton32(word);
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index aa4d01f..ddca7ff 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -990,7 +990,7 @@ static int wlc_get_current_txpwr(struct wlc_info *wlc, void *pwr, uint len)
 	 * or convert to a tx_power_legacy_t struct
 	 */
 	if (!old_power) {
-		bcopy(&power, pwr, sizeof(tx_power_t));
+		memcpy(pwr, &power, sizeof(tx_power_t));
 	} else {
 		int band_idx = CHSPEC_IS2G(power.chanspec) ? 0 : 1;
 
@@ -1840,8 +1840,7 @@ void *wlc_attach(void *wl, u16 vendor, u16 device, uint unit, bool piomode,
 
 	wlc_bmac_hw_etheraddr(wlc->hw, &wlc->perm_etheraddr);
 
-	bcopy((char *)&wlc->perm_etheraddr, (char *)&pub->cur_etheraddr,
-	      ETH_ALEN);
+	memcpy(&pub->cur_etheraddr, &wlc->perm_etheraddr, ETH_ALEN);
 
 	for (j = 0; j < NBANDS(wlc); j++) {
 		/* Use band 1 for single band 11a */
@@ -2892,7 +2891,7 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 
 	/* Set default bss rateset */
 	wlc->default_bss->rateset.count = rs.count;
-	bcopy((char *)rs.rates, (char *)wlc->default_bss->rateset.rates,
+	memcpy(wlc->default_bss->rateset.rates, rs.rates,
 	      sizeof(wlc->default_bss->rateset.rates));
 
 	return ret;
@@ -2986,7 +2985,7 @@ static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg)
 	wlc_rateset_t rs, new;
 	uint bandunit;
 
-	bcopy((char *)rs_arg, (char *)&rs, sizeof(wlc_rateset_t));
+	memcpy(&rs, rs_arg, sizeof(wlc_rateset_t));
 
 	/* check for bad count value */
 	if ((rs.count == 0) || (rs.count > WLC_NUMRATES))
@@ -2994,7 +2993,7 @@ static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg)
 
 	/* try the current band */
 	bandunit = wlc->band->bandunit;
-	bcopy((char *)&rs, (char *)&new, sizeof(wlc_rateset_t));
+	memcpy(&new, &rs, sizeof(wlc_rateset_t));
 	if (wlc_rate_hwrs_filter_sort_validate
 	    (&new, &wlc->bandstate[bandunit]->hw_rateset, true,
 	     wlc->stf->txstreams))
@@ -3003,7 +3002,7 @@ static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg)
 	/* try the other band */
 	if (IS_MBAND_UNLOCKED(wlc)) {
 		bandunit = OTHERBANDUNIT(wlc);
-		bcopy((char *)&rs, (char *)&new, sizeof(wlc_rateset_t));
+		memcpy(&new, &rs, sizeof(wlc_rateset_t));
 		if (wlc_rate_hwrs_filter_sort_validate(&new,
 						       &wlc->
 						       bandstate[bandunit]->
@@ -3016,9 +3015,8 @@ static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg)
 
  good:
 	/* apply new rateset */
-	bcopy((char *)&new, (char *)&wlc->default_bss->rateset,
-	      sizeof(wlc_rateset_t));
-	bcopy((char *)&new, (char *)&wlc->bandstate[bandunit]->defrateset,
+	memcpy(&wlc->default_bss->rateset, &new, sizeof(wlc_rateset_t));
+	memcpy(&wlc->bandstate[bandunit]->defrateset, &new,
 	      sizeof(wlc_rateset_t));
 	return 0;
 }
@@ -3099,7 +3097,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	/* This will prevent the misaligned access */
 	if (pval && (u32) len >= sizeof(val))
-		bcopy(pval, &val, sizeof(val));
+		memcpy(&val, pval, sizeof(val));
 	else
 		val = 0;
 
@@ -3595,18 +3593,18 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			if (src_key) {
 				key.index = src_key->id;
 				key.len = src_key->len;
-				bcopy(src_key->data, key.data, key.len);
+				memcpy(key.data, src_key->data, key.len);
 				key.algo = src_key->algo;
 				if (WSEC_SOFTKEY(wlc, src_key, bsscfg))
 					key.flags |= WL_SOFT_KEY;
 				if (src_key->flags & WSEC_PRIMARY_KEY)
 					key.flags |= WL_PRIMARY_KEY;
 
-				bcopy(src_key->ea.octet, key.ea.octet,
-				      ETH_ALEN);
+				memcpy(key.ea.octet, src_key->ea.octet,
+				       ETH_ALEN);
 			}
 
-			bcopy((char *)&key, arg, sizeof(key));
+			memcpy(arg, &key, sizeof(key));
 		} else
 			bcmerror = BCME_BADKEYIDX;
 		break;
@@ -3657,7 +3655,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				seq[6] = 0;
 				seq[7] = 0;
 
-				bcopy((char *)seq, arg, sizeof(seq));
+				memcpy(arg, seq, sizeof(seq));
 			} else {
 				bcmerror = BCME_BADKEYIDX;
 			}
@@ -3680,7 +3678,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 			/* Copy only legacy rateset section */
 			ret_rs->count = rs->count;
-			bcopy(&rs->rates, &ret_rs->rates, rs->count);
+			memcpy(&ret_rs->rates, &rs->rates, rs->count);
 			break;
 		}
 
@@ -3698,7 +3696,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 			/* Copy only legacy rateset section */
 			ret_rs->count = rs.count;
-			bcopy(&rs.rates, &ret_rs->rates, rs.count);
+			memcpy(&ret_rs->rates, &rs.rates, rs.count);
 			break;
 		}
 
@@ -3720,16 +3718,18 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 			/* Copy only legacy rateset section */
 			rs.count = in_rs->count;
-			bcopy(&in_rs->rates, &rs.rates, rs.count);
+			memcpy(&rs.rates, &in_rs->rates, rs.count);
 
 			/* merge rateset coming in with the current mcsset */
 			if (N_ENAB(wlc->pub)) {
 				if (bsscfg->associated)
-					bcopy(&current_bss->rateset.mcs[0],
-					      rs.mcs, MCSSET_LEN);
+					memcpy(rs.mcs,
+					      &current_bss->rateset.mcs[0],
+					      MCSSET_LEN);
 				else
-					bcopy(&wlc->default_bss->rateset.mcs[0],
-					      rs.mcs, MCSSET_LEN);
+					memcpy(rs.mcs,
+					       &wlc->default_bss->rateset.mcs[0],
+					       MCSSET_LEN);
 			}
 
 			bcmerror = wlc_set_rateset(wlc, &rs);
@@ -4032,7 +4032,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				bcmerror = BCME_BUFTOOSHORT;
 				break;
 			}
-			bcopy((char *)arg, (char *)&rs, sizeof(wlc_rateset_t));
+			memcpy(&rs, arg, sizeof(wlc_rateset_t));
 
 			/* check for bad count value */
 			if (rs.count > WLC_NUMRATES) {
@@ -4068,8 +4068,8 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			}
 
 			/* apply new rateset to the override */
-			bcopy((char *)&new, (char *)&wlc->sup_rates_override,
-			      sizeof(wlc_rateset_t));
+			memcpy(&wlc->sup_rates_override, &new,
+			       sizeof(wlc_rateset_t));
 
 			/* update bcn and probe resp if needed */
 			if (wlc->pub->up && AP_ENAB(wlc->pub)
@@ -4092,8 +4092,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			bcmerror = BCME_BUFTOOSHORT;
 			break;
 		}
-		bcopy((char *)&wlc->sup_rates_override, (char *)arg,
-		      sizeof(wlc_rateset_t));
+		memcpy(arg, &wlc->sup_rates_override, sizeof(wlc_rateset_t));
 
 		break;
 
@@ -4502,7 +4501,7 @@ wlc_iovar_check(struct wlc_pub *pub, const bcm_iovar_t *vi, void *arg, int len,
 		case IOVT_UINT8:
 		case IOVT_UINT16:
 		case IOVT_UINT32:
-			bcopy(arg, &int_val, sizeof(int));
+			memcpy(&int_val, arg, sizeof(int));
 			err = wlc_iovar_rangecheck(wlc, int_val, vi);
 			break;
 		}
@@ -4546,11 +4545,12 @@ wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
 
 	/* convenience int and bool vals for first 8 bytes of buffer */
 	if (p_len >= (int)sizeof(int_val))
-		bcopy(params, &int_val, sizeof(int_val));
+		memcpy(&int_val, params, sizeof(int_val));
 
 	if (p_len >= (int)sizeof(int_val) * 2)
-		bcopy((void *)((unsigned long)params + sizeof(int_val)), &int_val2,
-		      sizeof(int_val));
+		memcpy(&int_val2,
+		       (void *)((unsigned long)params + sizeof(int_val)),
+		       sizeof(int_val));
 
 	/* convenience int ptr for 4-byte gets (requires int aligned arg) */
 	ret_int_ptr = (s32 *) arg;
@@ -5953,8 +5953,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	/* (3) PLCP: determine PLCP header and MAC duration, fill d11txh_t */
 	wlc_compute_plcp(wlc, rspec[0], phylen, plcp);
 	wlc_compute_plcp(wlc, rspec[1], phylen, plcp_fallback);
-	bcopy(plcp_fallback, (char *)&txh->FragPLCPFallback,
-	      sizeof(txh->FragPLCPFallback));
+	memcpy(&txh->FragPLCPFallback, plcp_fallback,
+	       sizeof(txh->FragPLCPFallback));
 
 	/* Length field now put in CCK FBR CRC field */
 	if (IS_CCK(rspec[1])) {
@@ -6027,14 +6027,14 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 	}
 
 	/* MacFrameControl */
-	bcopy((char *)&h->frame_control, (char *)&txh->MacFrameControl, sizeof(u16));
+	memcpy(&txh->MacFrameControl, &h->frame_control, sizeof(u16));
 
 	txh->TxFesTimeNormal = htol16(0);
 
 	txh->TxFesTimeFallback = htol16(0);
 
 	/* TxFrameRA */
-	bcopy((char *)h->addr1, (char *)&txh->TxFrameRA, ETH_ALEN);
+	memcpy(&txh->TxFrameRA, h->addr1, ETH_ALEN);
 
 	/* TxFrameID */
 	txh->TxFrameID = htol16(frameid);
@@ -6102,8 +6102,8 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		/* fallback rate version of RTS PLCP header */
 		wlc_compute_plcp(wlc, rts_rspec[1], rts_phylen,
 				 rts_plcp_fallback);
-		bcopy(rts_plcp_fallback, (char *)&txh->RTSPLCPFallback,
-		      sizeof(txh->RTSPLCPFallback));
+		memcpy(&txh->RTSPLCPFallback, rts_plcp_fallback,
+		       sizeof(txh->RTSPLCPFallback));
 
 		/* RTS frame fields... */
 		rts = (struct ieee80211_rts *)&txh->rts_frame;
@@ -6122,12 +6122,11 @@ wlc_d11hdrs_mac80211(struct wlc_info *wlc, struct ieee80211_hw *hw,
 		if (use_cts) {
 			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
 							 IEEE80211_STYPE_CTS);
-			bcopy((char *)h->addr2, (char *)rts->ra, ETH_ALEN);
+			memcpy(rts->ra, h->addr2, ETH_ALEN);
 		} else {
 			rts->frame_control = cpu_to_le16(IEEE80211_FTYPE_CTL |
 							 IEEE80211_STYPE_RTS);
-			bcopy((char *)h->addr1, (char *)rts->ra,
-			      2 * ETH_ALEN);
+			memcpy(rts->ra, h->addr1, 2 * ETH_ALEN);
 		}
 
 		/* mainrate
@@ -7656,10 +7655,9 @@ wlc_bcn_prb_template(struct wlc_info *wlc, uint type, ratespec_t bcn_rspec,
 	/* DUR is 0 for multicast bcn, or filled in by MAC for prb resp */
 	/* A1 filled in by MAC for prb resp, broadcast for bcn */
 	if (type == IEEE80211_STYPE_BEACON)
-		bcopy((const char *)&ether_bcast, h->da,
-		      ETH_ALEN);
-	bcopy((char *)&cfg->cur_etheraddr, h->sa, ETH_ALEN);
-	bcopy((char *)&cfg->BSSID, h->bssid, ETH_ALEN);
+		memcpy(h->da, &ether_bcast, ETH_ALEN);
+	memcpy(h->sa, &cfg->cur_etheraddr, ETH_ALEN);
+	memcpy(h->bssid, &cfg->BSSID, ETH_ALEN);
 
 	/* SEQ filled in by MAC */
 
@@ -7750,7 +7748,7 @@ void wlc_shm_ssid_upd(struct wlc_info *wlc, wlc_bsscfg_t *cfg)
 
 	/* padding the ssid with zero and copy it into shm */
 	memset(ssidbuf, 0, DOT11_MAX_SSID_LEN);
-	bcopy(ssidptr, ssidbuf, cfg->SSID_len);
+	memcpy(ssidbuf, ssidptr, cfg->SSID_len);
 
 	wlc_copyto_shm(wlc, base, ssidbuf, DOT11_MAX_SSID_LEN);
 
diff --git a/drivers/staging/brcm80211/sys/wlc_rate.c b/drivers/staging/brcm80211/sys/wlc_rate.c
index ab7d0be..6904f8b 100644
--- a/drivers/staging/brcm80211/sys/wlc_rate.c
+++ b/drivers/staging/brcm80211/sys/wlc_rate.c
@@ -382,7 +382,7 @@ ratespec_t BCMFASTPATH wlc_compute_rspec(d11rxhdr_t *rxh, u8 *plcp)
 /* copy rateset src to dst as-is (no masking or sorting) */
 void wlc_rateset_copy(const wlc_rateset_t *src, wlc_rateset_t *dst)
 {
-	bcopy(src, dst, sizeof(wlc_rateset_t));
+	memcpy(dst, src, sizeof(wlc_rateset_t));
 }
 
 /*
@@ -417,7 +417,7 @@ wlc_rateset_filter(wlc_rateset_t *src, wlc_rateset_t *dst, bool basic_only,
 	dst->htphy_membership = src->htphy_membership;
 
 	if (mcsallow && rates != WLC_RATES_CCK)
-		bcopy(&src->mcs[0], &dst->mcs[0], MCSSET_LEN);
+		memcpy(&dst->mcs[0], &src->mcs[0], MCSSET_LEN);
 	else
 		wlc_rateset_mcs_clear(dst);
 }
@@ -487,7 +487,7 @@ void wlc_rateset_mcs_clear(wlc_rateset_t *rateset)
 
 void wlc_rateset_mcs_build(wlc_rateset_t *rateset, u8 txstreams)
 {
-	bcopy(&cck_ofdm_mimo_rates.mcs[0], &rateset->mcs[0], MCSSET_LEN);
+	memcpy(&rateset->mcs[0], &cck_ofdm_mimo_rates.mcs[0], MCSSET_LEN);
 	wlc_rateset_mcs_upd(rateset, txstreams);
 }
 
diff --git a/drivers/staging/brcm80211/sys/wlc_stf.c b/drivers/staging/brcm80211/sys/wlc_stf.c
index bb56a88..c067fa4 100644
--- a/drivers/staging/brcm80211/sys/wlc_stf.c
+++ b/drivers/staging/brcm80211/sys/wlc_stf.c
@@ -558,7 +558,7 @@ void wlc_stf_phy_chain_calc(struct wlc_info *wlc)
 	wlc->stf->rxstreams = (u8) WLC_BITSCNT(wlc->stf->hw_rxchain);
 
 	/* initialize the txcore table */
-	bcopy(txcore_default, wlc->stf->txcore, sizeof(wlc->stf->txcore));
+	memcpy(wlc->stf->txcore, txcore_default, sizeof(wlc->stf->txcore));
 
 	/* default spatial_policy */
 	wlc->stf->spatial_policy = MIN_SPATIAL_EXPANSION;
diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/util/bcmotp.c
index d820e7b..6fa04ed 100644
--- a/drivers/staging/brcm80211/util/bcmotp.c
+++ b/drivers/staging/brcm80211/util/bcmotp.c
@@ -818,7 +818,7 @@ static int hndotp_nvread(void *oh, char *data, uint *len)
 			if (offset + dsz >= *len) {
 				goto out;
 			}
-			bcopy((char *)&rawotp[i + 2], &data[offset], dsz);
+			memcpy(&data[offset], &rawotp[i + 2], dsz);
 			offset += dsz;
 			/* Remove extra null characters at the end */
 			while (offset > 1 &&
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 19d4502..992d247 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -1336,8 +1336,8 @@ int srom_parsecis(struct osl_info *osh, u8 *pcis[], uint ciscnt, char **vars,
 						u8 srev = cis[i + 1 + 70];
 						ASSERT(srev == 3);
 						/* make tuple value 16-bit aligned and parse it */
-						bcopy(&cis[i + 1], srom,
-						      sizeof(srom));
+						memcpy(srom, &cis[i + 1],
+						       sizeof(srom));
 						_initvars_srom_pci(srev, srom,
 								   SROM3_SWRGN_OFF,
 								   &b);
@@ -1518,7 +1518,7 @@ static int otp_read_pci(struct osl_info *osh, si_t *sih, u16 *buf, uint bufsz)
 
 	err = otp_read_region(sih, OTP_HW_RGN, (u16 *) otp, &sz);
 
-	bcopy(otp, buf, bufsz);
+	memcpy(buf, otp, bufsz);
 
 	if (otp)
 		kfree(otp);
@@ -1562,7 +1562,7 @@ static int initvars_table(struct osl_info *osh, char *start, char *end,
 		ASSERT(vp != NULL);
 		if (!vp)
 			return BCME_NOMEM;
-		bcopy(start, vp, c);
+		memcpy(vp, start, c);
 		*vars = vp;
 		*count = c;
 	} else {
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index fd30cc6..43bce96 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -51,7 +51,7 @@ uint pktfrombuf(struct osl_info *osh, struct sk_buff *p, uint offset, int len,
 	/* copy the data */
 	for (; p && len; p = p->next) {
 		n = min((uint) (p->len) - offset, (uint) len);
-		bcopy(buf, p->data + offset, n);
+		memcpy(p->data + offset, buf, n);
 		buf += n;
 		len -= n;
 		ret += n;
diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/util/hnddma.c
index d088692..3bfaad9 100644
--- a/drivers/staging/brcm80211/util/hnddma.c
+++ b/drivers/staging/brcm80211/util/hnddma.c
@@ -1961,8 +1961,8 @@ static void dma32_txrotate(dma_info_t *di)
 
 		/* Move the segment map as well */
 		if (DMASGLIST_ENAB) {
-			bcopy(&di->txp_dmah[old], &di->txp_dmah[new],
-			      sizeof(hnddma_seg_map_t));
+			memcpy(&di->txp_dmah[new], &di->txp_dmah[old],
+			       sizeof(hnddma_seg_map_t));
 			memset(&di->txp_dmah[old], 0, sizeof(hnddma_seg_map_t));
 		}
 
@@ -2639,8 +2639,8 @@ static void dma64_txrotate(dma_info_t *di)
 
 		/* Move the map */
 		if (DMASGLIST_ENAB) {
-			bcopy(&di->txp_dmah[old], &di->txp_dmah[new],
-			      sizeof(hnddma_seg_map_t));
+			memcpy(&di->txp_dmah[new], &di->txp_dmah[old],
+			       sizeof(hnddma_seg_map_t));
 			memset(&di->txp_dmah[old], 0, sizeof(hnddma_seg_map_t));
 		}
 
diff --git a/drivers/staging/brcm80211/util/nvram/nvram_ro.c b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
index e4d41ee..b2e6c0d 100644
--- a/drivers/staging/brcm80211/util/nvram/nvram_ro.c
+++ b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
@@ -70,7 +70,7 @@ static void get_flash_nvram(si_t *sih, struct nvram_header *nvh)
 	new->next = vars;
 	vars = new;
 
-	bcopy((char *)(&nvh[1]), new->vars, nvs);
+	memcpy(new->vars, &nvh[1], nvs);
 
 	NVR_MSG(("%s: flash nvram @ %p, copied %d bytes to %p\n", __func__,
 		 nvh, nvs, new->vars));
@@ -195,7 +195,7 @@ int nvram_getall(char *buf, int count)
 			len = strlen(from) + 1;
 			if (resid < (acc + len))
 				return BCME_BUFTOOSHORT;
-			bcopy(from, to, len);
+			memcpy(to, from, len);
 			acc += len;
 			from += len;
 			to += len;
diff --git a/drivers/staging/brcm80211/util/siutils.c b/drivers/staging/brcm80211/util/siutils.c
index b66de9b..6ff331c 100644
--- a/drivers/staging/brcm80211/util/siutils.c
+++ b/drivers/staging/brcm80211/util/siutils.c
@@ -700,7 +700,7 @@ void si_detach(si_t *sih)
 	uint idx;
 
 	struct si_pub *si_local = NULL;
-	bcopy(&sih, &si_local, sizeof(si_t **));
+	memcpy(&si_local, &sih, sizeof(si_t **));
 
 	sii = SI_INFO(sih);
 
-- 
1.7.1

