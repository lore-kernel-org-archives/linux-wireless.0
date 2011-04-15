Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2510 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab1DOJ5g (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 05:57:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 3/4] staging: brcm80211: replace error codes part 2
Date: Fri, 15 Apr 2011 11:57:23 +0200
Message-ID: <1302861444-27530-4-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1302861444-27530-1-git-send-email-rvossen@broadcom.com>
References: <1302861444-27530-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Replacing part of the proprietary error code values with native error
code values.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   24 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    6 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   55 +---------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   80 +++++++-------
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |   12 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    4 +-
 drivers/staging/brcm80211/brcmsmac/wlc_key.h       |   10 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |  108 +++++++++----------
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |   10 +-
 drivers/staging/brcm80211/include/bcmutils.h       |   24 -----
 drivers/staging/brcm80211/util/bcmotp.c            |   16 ++--
 drivers/staging/brcm80211/util/bcmsrom.c           |    2 +-
 drivers/staging/brcm80211/util/bcmutils.c          |    2 +-
 16 files changed, 143 insertions(+), 220 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 46c6a81..7ea19dd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -127,7 +127,7 @@ int bcmsdh_intr_enable(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_set(bcmsdh->sdioh, true);
-	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
 }
 
 int bcmsdh_intr_disable(void *sdh)
@@ -137,7 +137,7 @@ int bcmsdh_intr_disable(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_set(bcmsdh->sdioh, false);
-	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
 }
 
 int bcmsdh_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
@@ -147,7 +147,7 @@ int bcmsdh_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_register(bcmsdh->sdioh, fn, argh);
-	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
 }
 
 int bcmsdh_intr_dereg(void *sdh)
@@ -157,7 +157,7 @@ int bcmsdh_intr_dereg(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_deregister(bcmsdh->sdioh);
-	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
 }
 
 #if defined(DHD_DEBUG)
@@ -205,7 +205,7 @@ u8 bcmsdh_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
 #endif
 	if (err)
-		*err = (SDIOH_API_SUCCESS(status) ? 0 : -BCME_SDIO_ERROR);
+		*err = (SDIOH_API_SUCCESS(status) ? 0 : -EIO);
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -240,7 +240,7 @@ bcmsdh_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
 #endif
 	if (err)
-		*err = SDIOH_API_SUCCESS(status) ? 0 : -BCME_SDIO_ERROR;
+		*err = SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -262,7 +262,7 @@ u32 bcmsdh_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
 			       fnc_num, addr, &data, 4);
 
 	if (err)
-		*err = (SDIOH_API_SUCCESS(status) ? 0 : -BCME_SDIO_ERROR);
+		*err = (SDIOH_API_SUCCESS(status) ? 0 : -EIO);
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -287,7 +287,7 @@ bcmsdh_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 			       SDIOH_WRITE, fnc_num, addr, &data, 4);
 
 	if (err)
-		*err = (SDIOH_API_SUCCESS(status) ? 0 : -BCME_SDIO_ERROR);
+		*err = (SDIOH_API_SUCCESS(status) ? 0 : -EIO);
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -330,7 +330,7 @@ int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
 		kfree(tmp_buf);
 	}
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
 }
 
 static int bcmsdhsdio_set_sbaddr_window(void *sdh, u32 address)
@@ -489,7 +489,7 @@ bcmsdh_recv_buf(void *sdh, u32 addr, uint fn, uint flags,
 				      SDIOH_READ, fn, addr, width, nbytes, buf,
 				      pkt);
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_SDIO_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EIO;
 }
 
 int
@@ -534,7 +534,7 @@ bcmsdh_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 				      SDIOH_WRITE, fn, addr, width, nbytes, buf,
 				      pkt);
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
 }
 
 int bcmsdh_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
@@ -554,7 +554,7 @@ int bcmsdh_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 				 (rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
 				 addr, 4, nbytes, buf, NULL);
 
-	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -EBADE;
 }
 
 int bcmsdh_abort(void *sdh, uint fn)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index fab3853..05f50d3 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -656,7 +656,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 			if (sdioh_cfg_read
 			    (si, sd_ptr->func, sd_ptr->offset, &data)) {
-				bcmerror = -BCME_SDIO_ERROR;
+				bcmerror = -EIO;
 				break;
 			}
 
@@ -672,7 +672,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 			if (sdioh_cfg_write
 			    (si, sd_ptr->func, sd_ptr->offset, &data)) {
-				bcmerror = -BCME_SDIO_ERROR;
+				bcmerror = -EIO;
 				break;
 			}
 			break;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 95872f0..e44b674 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -357,7 +357,7 @@ int dhd_prot_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 	if (pktbuf->len < BDC_HEADER_LEN) {
 		DHD_ERROR(("%s: rx data too short (%d < %d)\n", __func__,
 			   pktbuf->len, BDC_HEADER_LEN));
-		return -BCME_ERROR;
+		return -EBADE;
 	}
 
 	h = (struct bdc_header *)(pktbuf->data);
@@ -366,14 +366,14 @@ int dhd_prot_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 	if (*ifidx >= DHD_MAX_IFS) {
 		DHD_ERROR(("%s: rx data ifnum out of range (%d)\n",
 			   __func__, *ifidx));
-		return -BCME_ERROR;
+		return -EBADE;
 	}
 
 	if (((h->flags & BDC_FLAG_VER_MASK) >> BDC_FLAG_VER_SHIFT) !=
 	    BDC_PROTO_VER) {
 		DHD_ERROR(("%s: non-BDC packet received, flags 0x%x\n",
 			   dhd_ifname(dhd, *ifidx), h->flags));
-		return -BCME_ERROR;
+		return -EBADE;
 	}
 
 	if (h->flags & BDC_FLAG_SUM_GOOD) {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index eda0935..5e7eebf 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -815,14 +815,14 @@ wl_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 
 	if (memcmp(BRCM_OUI, &pvt_data->bcm_hdr.oui[0], DOT11_OUI_LEN)) {
 		DHD_ERROR(("%s: mismatched OUI, bailing\n", __func__));
-		return -BCME_ERROR;
+		return -EBADE;
 	}
 
 	/* BRCM event pkt may be unaligned - use xxx_ua to load user_subtype. */
 	if (get_unaligned_be16(&pvt_data->bcm_hdr.usr_subtype) !=
 	    BCMILCP_BCM_SUBTYPE_EVENT) {
 		DHD_ERROR(("%s: mismatched subtype, bailing\n", __func__));
-		return -BCME_ERROR;
+		return -EBADE;
 	}
 
 	*data_ptr = &pvt_data[1];
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index b326722..8dd2764 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1619,51 +1619,6 @@ static int dhd_ethtool(dhd_info_t *dhd, void *uaddr)
 	return 0;
 }
 
-static s16 linuxbcmerrormap[] = { 0,	/* 0 */
-	-EINVAL,		/* -BCME_ERROR */
-	-EINVAL,		/* -BCME_BADARG */
-	-EINVAL,		/* -BCME_BADOPTION */
-	-EINVAL,		/* -BCME_NOTUP */
-	-EINVAL,		/* -BCME_NOTDOWN */
-	-EINVAL,		/* -BCME_NOTAP */
-	-EINVAL,		/* -BCME_NOTSTA */
-	-EINVAL,		/* -BCME_BADKEYIDX */
-	-EINVAL,		/* -BCME_RADIOOFF */
-	-EINVAL,		/* -BCME_NOTBANDLOCKED */
-	-EINVAL,		/* -BCME_NOCLK */
-	-EINVAL,		/* -BCME_BADRATESET */
-	-EINVAL,		/* -BCME_BADBAND */
-	-E2BIG,			/* -BCME_BUFTOOSHORT */
-	-E2BIG,			/* -BCME_BUFTOOLONG */
-	-EBUSY,			/* -BCME_BUSY */
-	-EINVAL,		/* -BCME_NOTASSOCIATED */
-	-EINVAL,		/* -BCME_BADSSIDLEN */
-	-EINVAL,		/* -BCME_OUTOFRANGECHAN */
-	-EINVAL,		/* -BCME_BADCHAN */
-	-EFAULT,		/* -BCME_BADADDR */
-	-ENOMEM,		/* -BCME_NORESOURCE */
-	-EOPNOTSUPP,		/* -BCME_UNSUPPORTED */
-	-EMSGSIZE,		/* -BCME_BADLENGTH */
-	-EINVAL,		/* -BCME_NOTREADY */
-	-EPERM,			/* -BCME_NOTPERMITTED */
-	-ENOMEM,		/* -BCME_NOMEM */
-	-EINVAL,		/* -BCME_ASSOCIATED */
-	-ERANGE,		/* -BCME_RANGE */
-	-EINVAL,		/* -BCME_NOTFOUND */
-	-EINVAL,		/* -BCME_WME_NOT_ENABLED */
-	-EINVAL,		/* -BCME_TSPEC_NOTFOUND */
-	-EINVAL,		/* -BCME_ACM_NOTSUPPORTED */
-	-EINVAL,		/* -BCME_NOT_WME_ASSOCIATION */
-	-EIO,			/* -BCME_SDIO_ERROR */
-	-ENODEV,		/* -BCME_DONGLE_DOWN */
-	-EINVAL,		/* -BCME_VERSION */
-	-EIO,			/* -BCME_TXFAIL */
-	-EIO,			/* -BCME_RXFAIL */
-	-EINVAL,		/* -BCME_NODEVICE */
-	-EINVAL,		/* -BCME_NMODE_DISABLED */
-	-ENODATA,		/* -BCME_NONRESIDENT */
-};
-
 static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 {
 	dhd_info_t *dhd = *(dhd_info_t **) netdev_priv(net);
@@ -1748,12 +1703,12 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 	/* send to dongle (must be up, and wl) */
 	if ((dhd->pub.busstate != DHD_BUS_DATA)) {
 		DHD_ERROR(("%s DONGLE_DOWN,__func__\n", __func__));
-		bcmerror = -BCME_DONGLE_DOWN;
+		bcmerror = -EIO;
 		goto done;
 	}
 
 	if (!dhd->pub.iswl) {
-		bcmerror = -BCME_DONGLE_DOWN;
+		bcmerror = -EIO;
 		goto done;
 	}
 
@@ -1781,10 +1736,8 @@ done:
 
 	if (bcmerror > 0)
 		bcmerror = 0;
-	else if (bcmerror < -BCME_LAST)
-		bcmerror = -BCME_ERROR;
 
-	return linuxbcmerrormap[-bcmerror];
+	return bcmerror;
 }
 
 static int dhd_stop(struct net_device *net)
@@ -2284,7 +2237,7 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 
 fail:
 	net->netdev_ops = NULL;
-	return -BCME_ERROR;
+	return -EBADE;
 }
 
 void dhd_bus_detach(dhd_pub_t *dhdp)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 1c90ec0..935a663 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -521,7 +521,7 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		if (err) {
 			DHD_ERROR(("%s: HT Avail request error: %d\n",
 				   __func__, err));
-			return -BCME_ERROR;
+			return -EBADE;
 		}
 
 		if (pendok && ((bus->sih->buscoretype == PCMCIA_CORE_ID)
@@ -537,7 +537,7 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		if (err) {
 			DHD_ERROR(("%s: HT Avail read error: %d\n",
 				   __func__, err));
-			return -BCME_ERROR;
+			return -EBADE;
 		}
 
 		/* Go to pending and await interrupt if appropriate */
@@ -549,7 +549,7 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 			if (err) {
 				DHD_ERROR(("%s: Devctl error setting CA: %d\n",
 					__func__, err));
-				return -BCME_ERROR;
+				return -EBADE;
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
@@ -582,12 +582,12 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		if (err) {
 			DHD_ERROR(("%s: HT Avail request error: %d\n",
 				   __func__, err));
-			return -BCME_ERROR;
+			return -EBADE;
 		}
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
 			DHD_ERROR(("%s: HT Avail timeout (%d): clkctl 0x%02x\n",
 				   __func__, PMU_MAX_TRANSITION_DLY, clkctl));
-			return -BCME_ERROR;
+			return -EBADE;
 		}
 
 		/* Mark clock available */
@@ -631,7 +631,7 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		if (err) {
 			DHD_ERROR(("%s: Failed access turning clock off: %d\n",
 				   __func__, err));
-			return -BCME_ERROR;
+			return -EBADE;
 		}
 	}
 	return 0;
@@ -654,7 +654,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			if (err) {
 				DHD_ERROR(("%s: error enabling sd_clock: %d\n",
 					   __func__, err));
-				return -BCME_ERROR;
+				return -EBADE;
 			}
 
 			iovalue = bus->sd_mode;
@@ -663,7 +663,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			if (err) {
 				DHD_ERROR(("%s: error changing sd_mode: %d\n",
 					   __func__, err));
-				return -BCME_ERROR;
+				return -EBADE;
 			}
 		} else if (bus->idleclock != DHD_IDLE_ACTIVE) {
 			/* Restore clock speed */
@@ -673,7 +673,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			if (err) {
 				DHD_ERROR(("%s: error restoring sd_divisor: %d\n",
 					__func__, err));
-				return -BCME_ERROR;
+				return -EBADE;
 			}
 		}
 		bus->clkstate = CLK_SDONLY;
@@ -682,7 +682,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 		if ((bus->sd_divisor == -1) || (bus->sd_mode == -1)) {
 			DHD_TRACE(("%s: can't idle clock, divisor %d mode %d\n",
 				   __func__, bus->sd_divisor, bus->sd_mode));
-			return -BCME_ERROR;
+			return -EBADE;
 		}
 		if (bus->idleclock == DHD_IDLE_STOP) {
 			if (sd1idle) {
@@ -695,7 +695,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 				if (err) {
 					DHD_ERROR(("%s: error changing sd_clock: %d\n",
 						__func__, err));
-					return -BCME_ERROR;
+					return -EBADE;
 				}
 			}
 
@@ -705,7 +705,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			if (err) {
 				DHD_ERROR(("%s: error disabling sd_clock: %d\n",
 					   __func__, err));
-				return -BCME_ERROR;
+				return -EBADE;
 			}
 		} else if (bus->idleclock != DHD_IDLE_ACTIVE) {
 			/* Set divisor to idle value */
@@ -715,7 +715,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			if (err) {
 				DHD_ERROR(("%s: error changing sd_divisor: %d\n",
 					__func__, err));
-				return -BCME_ERROR;
+				return -EBADE;
 			}
 		}
 		bus->clkstate = CLK_NONE;
@@ -923,7 +923,7 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	sdh = bus->sdh;
 
 	if (bus->dhd->dongle_reset) {
-		ret = -BCME_NOTREADY;
+		ret = -EPERM;
 		goto done;
 	}
 
@@ -1069,7 +1069,7 @@ done:
 
 int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 {
-	int ret = -BCME_ERROR;
+	int ret = -EBADE;
 	uint datalen, prec;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
@@ -1779,7 +1779,7 @@ static int dhdsdio_readshared(dhd_bus_t *bus, sdpcm_shared_t *sh)
 	if (addr == 0 || ((~addr >> 16) & 0xffff) == (addr & 0xffff)) {
 		DHD_ERROR(("%s: address (0x%08x) of sdpcm_shared invalid\n",
 			   __func__, addr));
-		return -BCME_ERROR;
+		return -EBADE;
 	}
 
 	/* Read hndrte_shared structure */
@@ -1802,7 +1802,7 @@ static int dhdsdio_readshared(dhd_bus_t *bus, sdpcm_shared_t *sh)
 			   "is different than sdpcm_shared version %d in dongle\n",
 			   __func__, SDPCM_SHARED_VERSION,
 			   sh->flags & SDPCM_SHARED_VERSION_MASK));
-		return -BCME_ERROR;
+		return -EBADE;
 	}
 
 	return 0;
@@ -2015,7 +2015,7 @@ static int dhdsdio_readconsole(dhd_bus_t *bus)
 
 	/* Protect against corrupt value */
 	if (idx > c->bufsize)
-		return -BCME_ERROR;
+		return -EBADE;
 
 	/* Skip reading the console buffer if the index pointer
 	 has not moved */
@@ -2070,7 +2070,7 @@ int dhdsdio_downloadvars(dhd_bus_t *bus, void *arg, int len)
 
 	/* Basic sanity checks */
 	if (bus->dhd->up) {
-		bcmerror = -BCME_NOTDOWN;
+		bcmerror = -EISCONN;
 		goto err;
 	}
 	if (!len) {
@@ -2123,7 +2123,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 	/* Check if dongle is in reset. If so, only allow DEVRESET iovars */
 	if (bus->dhd->dongle_reset && !(actionid == IOV_SVAL(IOV_DEVRESET) ||
 					actionid == IOV_GVAL(IOV_DEVRESET))) {
-		bcmerror = -BCME_NOTREADY;
+		bcmerror = -EPERM;
 		goto exit;
 	}
 
@@ -2341,7 +2341,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			size = sd_ptr->func;
 			int_val = (s32) bcmsdh_reg_read(bus->sdh, addr, size);
 			if (bcmsdh_regfail(bus->sdh))
-				bcmerror = -BCME_SDIO_ERROR;
+				bcmerror = -EIO;
 			memcpy(arg, &int_val, sizeof(s32));
 			break;
 		}
@@ -2357,7 +2357,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			size = sd_ptr->func;
 			bcmsdh_reg_write(bus->sdh, addr, size, sd_ptr->value);
 			if (bcmsdh_regfail(bus->sdh))
-				bcmerror = -BCME_SDIO_ERROR;
+				bcmerror = -EIO;
 			break;
 		}
 
@@ -2374,7 +2374,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			size = sdreg.func;
 			int_val = (s32) bcmsdh_reg_read(bus->sdh, addr, size);
 			if (bcmsdh_regfail(bus->sdh))
-				bcmerror = -BCME_SDIO_ERROR;
+				bcmerror = -EIO;
 			memcpy(arg, &int_val, sizeof(s32));
 			break;
 		}
@@ -2390,7 +2390,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			size = sdreg.func;
 			bcmsdh_reg_write(bus->sdh, addr, size, sdreg.value);
 			if (bcmsdh_regfail(bus->sdh))
-				bcmerror = -BCME_SDIO_ERROR;
+				bcmerror = -EIO;
 			break;
 		}
 
@@ -2609,20 +2609,20 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 		if (!(si_setcore(bus->sih, ARM7S_CORE_ID, 0)) &&
 		    !(si_setcore(bus->sih, ARMCM3_CORE_ID, 0))) {
 			DHD_ERROR(("%s: Failed to find ARM core!\n", __func__));
-			bcmerror = -BCME_ERROR;
+			bcmerror = -EBADE;
 			goto fail;
 		}
 
 		si_core_disable(bus->sih, 0);
 		if (bcmsdh_regfail(bus->sdh)) {
-			bcmerror = -BCME_SDIO_ERROR;
+			bcmerror = -EIO;
 			goto fail;
 		}
 
 		if (!(si_setcore(bus->sih, SOCRAM_CORE_ID, 0))) {
 			DHD_ERROR(("%s: Failed to find SOCRAM core!\n",
 				   __func__));
-			bcmerror = -BCME_ERROR;
+			bcmerror = -EBADE;
 			goto fail;
 		}
 
@@ -2630,7 +2630,7 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 		if (bcmsdh_regfail(bus->sdh)) {
 			DHD_ERROR(("%s: Failure trying reset SOCRAM core?\n",
 				   __func__));
-			bcmerror = -BCME_SDIO_ERROR;
+			bcmerror = -EIO;
 			goto fail;
 		}
 
@@ -2644,14 +2644,14 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 		if (!(si_setcore(bus->sih, SOCRAM_CORE_ID, 0))) {
 			DHD_ERROR(("%s: Failed to find SOCRAM core!\n",
 				   __func__));
-			bcmerror = -BCME_ERROR;
+			bcmerror = -EBADE;
 			goto fail;
 		}
 
 		if (!si_iscoreup(bus->sih)) {
 			DHD_ERROR(("%s: SOCRAM core is down after reset?\n",
 				   __func__));
-			bcmerror = -BCME_ERROR;
+			bcmerror = -EBADE;
 			goto fail;
 		}
 
@@ -2665,7 +2665,7 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 		    !si_setcore(bus->sih, SDIOD_CORE_ID, 0)) {
 			DHD_ERROR(("%s: Can't change back to SDIO core?\n",
 				   __func__));
-			bcmerror = -BCME_ERROR;
+			bcmerror = -EBADE;
 			goto fail;
 		}
 		W_SDREG(0xFFFFFFFF, &bus->regs->intstatus, retries);
@@ -2673,7 +2673,7 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 		if (!(si_setcore(bus->sih, ARM7S_CORE_ID, 0)) &&
 		    !(si_setcore(bus->sih, ARMCM3_CORE_ID, 0))) {
 			DHD_ERROR(("%s: Failed to find ARM core!\n", __func__));
-			bcmerror = -BCME_ERROR;
+			bcmerror = -EBADE;
 			goto fail;
 		}
 
@@ -2681,7 +2681,7 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 		if (bcmsdh_regfail(bus->sdh)) {
 			DHD_ERROR(("%s: Failure trying to reset ARM core?\n",
 				   __func__));
-			bcmerror = -BCME_SDIO_ERROR;
+			bcmerror = -EIO;
 			goto fail;
 		}
 
@@ -4961,7 +4961,7 @@ extern int dhd_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg, uint msglen)
 	/* Don't allow input if dongle is in reset */
 	if (bus->dhd->dongle_reset) {
 		dhd_os_sdunlock(bus->dhd);
-		return -BCME_NOTREADY;
+		return -EPERM;
 	}
 
 	/* Request clock to allow SDIO accesses */
@@ -5866,7 +5866,7 @@ static int dhdsdio_download_nvram(struct dhd_bus *bus)
 	} else {
 		DHD_ERROR(("%s: error reading nvram file: %d\n",
 			   __func__, len));
-		bcmerror = -BCME_SDIO_ERROR;
+		bcmerror = -EIO;
 	}
 
 err:
@@ -6024,7 +6024,7 @@ int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 			DHD_TRACE(("%s:  WLAN OFF DONE\n", __func__));
 			/* App can now remove power from device */
 		} else
-			bcmerror = -BCME_SDIO_ERROR;
+			bcmerror = -EIO;
 	} else {
 		/* App must have restored power to device before calling */
 
@@ -6059,14 +6059,14 @@ int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 					DHD_TRACE(("%s: WLAN ON DONE\n",
 						   __func__));
 				} else
-					bcmerror = -BCME_SDIO_ERROR;
+					bcmerror = -EIO;
 			} else
-				bcmerror = -BCME_SDIO_ERROR;
+				bcmerror = -EIO;
 		} else {
-			bcmerror = -BCME_NOTDOWN;
+			bcmerror = -EISCONN;
 			DHD_ERROR(("%s: Set DEVRESET=false invoked when device "
 				"is on\n", __func__));
-			bcmerror = -BCME_SDIO_ERROR;
+			bcmerror = -EIO;
 		}
 	}
 	return bcmerror;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index 41baf51..b319071 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -22366,7 +22366,7 @@ wlc_phy_tx_tone_nphy(phy_info_t *pi, u32 f_kHz, u16 max_val,
 	num_samps =
 		wlc_phy_gen_load_samples_nphy(pi, f_kHz, max_val, dac_test_mode);
 	if (num_samps == 0) {
-		return -BCME_ERROR;
+		return -EBADE;
 	}
 
 	wlc_phy_runsamples_nphy(pi, num_samps, loops, wait, iqmode,
@@ -24559,7 +24559,7 @@ static void wlc_phy_calc_rx_iq_comp_nphy(phy_info_t *pi, u8 core_mask)
 		}
 
 		if ((ii + qq) < NPHY_MIN_RXIQ_PWR) {
-			bcmerror = -BCME_ERROR;
+			bcmerror = -EBADE;
 			break;
 		}
 
@@ -24571,14 +24571,14 @@ static void wlc_phy_calc_rx_iq_comp_nphy(phy_info_t *pi, u8 core_mask)
 			a = (-(iq << (30 - iq_nbits)) + (ii >> (1 + arsh)));
 			temp = (s32) (ii >> arsh);
 			if (temp == 0) {
-				bcmerror = -BCME_ERROR;
+				bcmerror = -EBADE;
 				break;
 			}
 		} else {
 			a = (-(iq << (30 - iq_nbits)) + (ii << (-1 - arsh)));
 			temp = (s32) (ii << -arsh);
 			if (temp == 0) {
-				bcmerror = -BCME_ERROR;
+				bcmerror = -EBADE;
 				break;
 			}
 		}
@@ -24590,14 +24590,14 @@ static void wlc_phy_calc_rx_iq_comp_nphy(phy_info_t *pi, u8 core_mask)
 			b = (qq << (31 - qq_nbits));
 			temp = (s32) (ii >> brsh);
 			if (temp == 0) {
-				bcmerror = -BCME_ERROR;
+				bcmerror = -EBADE;
 				break;
 			}
 		} else {
 			b = (qq << (31 - qq_nbits));
 			temp = (s32) (ii << -brsh);
 			if (temp == 0) {
-				bcmerror = -BCME_ERROR;
+				bcmerror = -EBADE;
 				break;
 			}
 		}
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index bbc1717..c0c7c3f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -1840,7 +1840,7 @@ int wl_ucode_init_buf(struct wl_info *wl, void **pbuf, u32 idx)
 	dev_err(dev, "ERROR: ucode buf tag:%d can not be found!\n", idx);
 	*pbuf = NULL;
 fail:
-	return -BCME_NOTFOUND;
+	return -ENODATA;
 }
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 1a94cd1..b78e6fb 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -1135,7 +1135,7 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 		if (wlc_hw->sih->bustype == PCI_BUS)
 			ai_pci_down(wlc_hw->sih);
 		wlc_bmac_xtal(wlc_hw, OFF);
-		return -BCME_RADIOOFF;
+		return -ENOMEDIUM;
 	}
 
 	if (wlc_hw->sih->bustype == PCI_BUS)
@@ -2807,7 +2807,7 @@ static void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 int wlc_bmac_xmtfifo_sz_get(struct wlc_hw_info *wlc_hw, uint fifo, uint *blocks)
 {
 	if (fifo >= NFIFO)
-		return -BCME_RANGE;
+		return -EINVAL;
 
 	*blocks = wlc_hw->xmtfifo_sz[fifo];
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_key.h b/drivers/staging/brcm80211/brcmsmac/wlc_key.h
index 4615173..cab10c7 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_key.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_key.h
@@ -115,7 +115,7 @@ typedef struct wsec_key {
 #define WSEC_IBSS_PEER_GROUP_KEY	(1 << 7)	/* Flag: group key for a IBSS PEER */
 #define WSEC_ICV_ERROR		(1 << 8)	/* Provoke deliberate ICV error */
 
-#define wlc_key_insert(a, b, c, d, e, f, g, h, i, j) (-BCME_ERROR)
+#define wlc_key_insert(a, b, c, d, e, f, g, h, i, j) (-EBADE)
 #define wlc_key_update(a, b, c) do {} while (0)
 #define wlc_key_remove(a, b, c) do {} while (0)
 #define wlc_key_remove_all(a, b) do {} while (0)
@@ -126,12 +126,12 @@ typedef struct wsec_key {
 #define wlc_key_hw_init(a, b, c)  do {} while (0)
 #define wlc_key_hw_wowl_init(a, b, c, d) do {} while (0)
 #define wlc_key_sw_wowl_update(a, b, c, d, e) do {} while (0)
-#define wlc_key_sw_wowl_create(a, b, c) (-BCME_ERROR)
+#define wlc_key_sw_wowl_create(a, b, c) (-EBADE)
 #define wlc_key_iv_update(a, b, c, d, e) do {(void)e; } while (0)
 #define wlc_key_iv_init(a, b, c) do {} while (0)
-#define wlc_key_set_error(a, b, c) (-BCME_ERROR)
-#define wlc_key_dump_hw(a, b) (-BCME_ERROR)
-#define wlc_key_dump_sw(a, b) (-BCME_ERROR)
+#define wlc_key_set_error(a, b, c) (-EBADE)
+#define wlc_key_dump_hw(a, b) (-EBADE)
+#define wlc_key_dump_sw(a, b) (-EBADE)
 #define wlc_key_defkeyflag(a) (0)
 #define wlc_rcmta_add_bssid(a, b) do {} while (0)
 #define wlc_rcmta_del_bssid(a, b) do {} while (0)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 22e9df9..3057c42 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -2335,7 +2335,7 @@ int wlc_up(struct wlc_info *wlc)
 
 	/* HW is turned off so don't try to access it */
 	if (wlc->pub->hw_off || DEVICEREMOVED(wlc))
-		return -BCME_RADIOOFF;
+		return -ENOMEDIUM;
 
 	if (!wlc->pub->hw_up) {
 		wlc_bmac_hw_up(wlc->hw);
@@ -2364,7 +2364,7 @@ int wlc_up(struct wlc_info *wlc)
 	 */
 	if (!wlc->pub->radio_disabled) {
 		int status = wlc_bmac_up_prep(wlc->hw);
-		if (status == -BCME_RADIOOFF) {
+		if (status == -ENOMEDIUM) {
 			if (!mboolisset
 			    (wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE)) {
 				int idx;
@@ -2568,7 +2568,7 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 	/* Legacy or bust when no OFDM is supported by regulatory */
 	if ((wlc_channel_locale_flags_in_band(wlc->cmi, band->bandunit) &
 	     WLC_NO_OFDM) && (gmode != GMODE_LEGACY_B))
-		return -BCME_RANGE;
+		return -EINVAL;
 
 	/* update configuration value */
 	if (config == true)
@@ -2701,7 +2701,7 @@ static int wlc_nmode_validate(struct wlc_info *wlc, s32 nmode)
 		break;
 
 	default:
-		err = -BCME_RANGE;
+		err = -EINVAL;
 		break;
 	}
 
@@ -2795,7 +2795,7 @@ static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg)
 			goto good;
 	}
 
-	return -BCME_ERROR;
+	return -EBADE;
 
  good:
 	/* apply new rateset */
@@ -2871,7 +2871,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		dev_err(wlc->dev, "wl%d: %s: dead chip\n", wlc->pub->unit,
 			__func__);
 		wl_down(wlc->wl);
-		return -BCME_ERROR;
+		return -EBADE;
 	}
 
 	/* default argument is generic integer */
@@ -2998,7 +2998,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 
 		if (val >= MHFMAX) {
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 			break;
 		}
 
@@ -3023,7 +3023,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 		i = (u16) val;
 		if (i >= MHFMAX) {
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 			break;
 		}
 
@@ -3185,7 +3185,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	case WLC_SET_ANTDIV:
 		/* values are -1=driver default, 0=force0, 1=force1, 2=start1, 3=start0 */
 		if ((val < -1) || (val > 3)) {
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 			break;
 		}
 
@@ -3206,7 +3206,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 			rxstatus = R_REG(&wlc->regs->phyrxstatus0);
 			if (rxstatus == 0xdead || rxstatus == (u16) -1) {
-				bcmerror = -BCME_ERROR;
+				bcmerror = -EBADE;
 				break;
 			}
 			*pval = (rxstatus & PRXS0_RXANT_UPSUBBAND) ? 1 : 0;
@@ -3216,7 +3216,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 #if defined(BCMDBG)
 	case WLC_GET_UCANTDIV:
 		if (!wlc->clk) {
-			bcmerror = -BCME_NOCLK;
+			bcmerror = -EIO;
 			break;
 		}
 
@@ -3233,7 +3233,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 			/* if multiband, band must be locked */
 			if (IS_MBAND_UNLOCKED(wlc)) {
-				bcmerror = -BCME_NOTBANDLOCKED;
+				bcmerror = -ENOMEDIUM;
 				break;
 			}
 
@@ -3259,7 +3259,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			}
 			wlc_wme_retries_write(wlc);
 		} else
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 		break;
 
 	case WLC_GET_LRL:
@@ -3278,7 +3278,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			}
 			wlc_wme_retries_write(wlc);
 		} else
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 		break;
 
 	case WLC_GET_CWMIN:
@@ -3287,14 +3287,14 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	case WLC_SET_CWMIN:
 		if (!wlc->clk) {
-			bcmerror = -BCME_NOCLK;
+			bcmerror = -EIO;
 			break;
 		}
 
 		if (val >= 1 && val <= 255) {
 			wlc_set_cwmin(wlc, (u16) val);
 		} else
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 		break;
 
 	case WLC_GET_CWMAX:
@@ -3303,14 +3303,14 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	case WLC_SET_CWMAX:
 		if (!wlc->clk) {
-			bcmerror = -BCME_NOCLK;
+			bcmerror = -EIO;
 			break;
 		}
 
 		if (val >= 255 && val <= 2047) {
 			wlc_set_cwmax(wlc, (u16) val);
 		} else
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 		break;
 
 	case WLC_GET_RADIO:	/* use mask if don't want to expose some internal bits */
@@ -3333,7 +3333,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			    || ((radioval & ~radiomask) != 0)) {
 				dev_err(wlc->dev, "SET_RADIO with wrong bits 0x%x\n",
 					 val);
-				bcmerror = -BCME_RANGE;
+				bcmerror = -EINVAL;
 				break;
 			}
 
@@ -3482,7 +3482,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			}
 
 			if (in_rs->count > WLC_NUMRATES) {
-				bcmerror = -BCME_BUFTOOLONG;
+				bcmerror = -ENOBUFS;
 				break;
 			}
 
@@ -3525,7 +3525,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		    && val <= DOT11_MAX_BEACON_PERIOD) {
 			wlc->default_bss->beacon_period = (u16) val;
 		} else
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 		break;
 
 	case WLC_GET_DTIMPRD:
@@ -3541,7 +3541,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		    && val <= DOT11_MAX_DTIM_PERIOD) {
 			wlc->default_bss->dtim_period = (u8) val;
 		} else
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 		break;
 
 #ifdef SUPPORT_PS
@@ -3557,7 +3557,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			/* Change watchdog driver to align watchdog with tbtt if possible */
 			wlc_watchdog_upd(wlc, PS_ALLOWED(wlc));
 		} else
-			bcmerror = -BCME_ERROR;
+			bcmerror = -EBADE;
 		break;
 #endif				/* SUPPORT_PS */
 
@@ -3694,7 +3694,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	case WLC_SET_SHORTSLOT_OVERRIDE:
 		if ((val != WLC_SHORTSLOT_AUTO) &&
 		    (val != WLC_SHORTSLOT_OFF) && (val != WLC_SHORTSLOT_ON)) {
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 			break;
 		}
 
@@ -3751,7 +3751,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		if (!wlc->pub->associated)
 			bcmerror = wlc_set_gmode(wlc, (u8) val, true);
 		else {
-			bcmerror = -BCME_ASSOCIATED;
+			bcmerror = -EISCONN;
 			break;
 		}
 		break;
@@ -3768,7 +3768,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		if ((val != WLC_PROTECTION_CTL_OFF) &&
 		    (val != WLC_PROTECTION_CTL_LOCAL) &&
 		    (val != WLC_PROTECTION_CTL_OVERLAP)) {
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 			break;
 		}
 
@@ -3787,7 +3787,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	case WLC_SET_GMODE_PROTECTION_OVERRIDE:
 		if ((val != WLC_PROTECTION_AUTO) &&
 		    (val != WLC_PROTECTION_OFF) && (val != WLC_PROTECTION_ON)) {
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 			break;
 		}
 
@@ -3879,11 +3879,11 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	case WLC_SET_PRB_RESP_TIMEOUT:
 		if (wlc->pub->up) {
-			bcmerror = -BCME_NOTDOWN;
+			bcmerror = -EISCONN;
 			break;
 		}
 		if (val < 0 || val >= 0xFFFF) {
-			bcmerror = -BCME_RANGE;	/* bad value */
+			bcmerror = -EINVAL;	/* bad value */
 			break;
 		}
 		wlc->prb_resp_timeout = (u16) val;
@@ -3977,14 +3977,8 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	}
  done:
 
-	if (bcmerror) {
-		if (VALID_BCMERROR(bcmerror))
-			wlc->pub->bcmerror = bcmerror;
-		else {
-			bcmerror = 0;
-		}
-
-	}
+	if (bcmerror)
+		wlc->pub->bcmerror = bcmerror;
 
 	return bcmerror;
 }
@@ -3999,11 +3993,11 @@ int wlc_iocregchk(struct wlc_info *wlc, uint band)
 
 	/* if multiband and band is not specified, band must be locked */
 	if ((band == WLC_BAND_AUTO) && IS_MBAND_UNLOCKED(wlc))
-		return -BCME_NOTBANDLOCKED;
+		return -ENOMEDIUM;
 
 	/* must have core clocks */
 	if (!wlc->clk)
-		return -BCME_NOCLK;
+		return -EIO;
 
 	return 0;
 }
@@ -4107,7 +4101,7 @@ int wlc_module_unregister(struct wlc_pub *pub, const char *name, void *hdl)
 	int i;
 
 	if (wlc == NULL)
-		return -BCME_NOTFOUND;
+		return -ENODATA;
 
 	for (i = 0; i < WLC_MAXMODULES; i++) {
 		if (!strcmp(wlc->modulecb[i].name, name) &&
@@ -4118,7 +4112,7 @@ int wlc_module_unregister(struct wlc_pub *pub, const char *name, void *hdl)
 	}
 
 	/* table not found! */
-	return -BCME_NOTFOUND;
+	return -ENODATA;
 }
 
 /* Write WME tunable parameters for retransmit/max rate from wlc struct to ucode */
@@ -4215,22 +4209,22 @@ wlc_iovar_check(struct wlc_pub *pub, const bcm_iovar_t *vi, void *arg, int len,
 	if (set) {
 		if (((vi->flags & IOVF_SET_DOWN) && wlc->pub->up) ||
 		    ((vi->flags & IOVF_SET_UP) && !wlc->pub->up)) {
-			err = (wlc->pub->up ? -BCME_NOTDOWN : -ENOLINK);
+			err = (wlc->pub->up ? -EISCONN : -ENOLINK);
 		} else if ((vi->flags & IOVF_SET_BAND)
 			   && IS_MBAND_UNLOCKED(wlc)) {
-			err = -BCME_NOTBANDLOCKED;
+			err = -ENOMEDIUM;
 		} else if ((vi->flags & IOVF_SET_CLK) && !wlc->clk) {
-			err = -BCME_NOCLK;
+			err = -EIO;
 		}
 	} else {
 		if (((vi->flags & IOVF_GET_DOWN) && wlc->pub->up) ||
 		    ((vi->flags & IOVF_GET_UP) && !wlc->pub->up)) {
-			err = (wlc->pub->up ? -BCME_NOTDOWN : -ENOLINK);
+			err = (wlc->pub->up ? -EISCONN : -ENOLINK);
 		} else if ((vi->flags & IOVF_GET_BAND)
 			   && IS_MBAND_UNLOCKED(wlc)) {
-			err = -BCME_NOTBANDLOCKED;
+			err = -ENOMEDIUM;
 		} else if ((vi->flags & IOVF_GET_CLK) && !wlc->clk) {
-			err = -BCME_NOCLK;
+			err = -EIO;
 		}
 	}
 
@@ -4408,7 +4402,7 @@ wlc_iovar_rangecheck(struct wlc_info *wlc, u32 val, const bcm_iovar_t *vi)
 		/* Signed values are checked against max_val and min_val */
 		if ((s32) val < (s32) min_val
 		    || (s32) val > (s32) max_val)
-			err = -BCME_RANGE;
+			err = -EINVAL;
 		break;
 
 	case IOVT_UINT32:
@@ -4422,7 +4416,7 @@ wlc_iovar_rangecheck(struct wlc_info *wlc, u32 val, const bcm_iovar_t *vi)
 		if (vi->flags & IOVF_NTRL)
 			min_val = 1;
 		if ((val < min_val) || (val > max_val))
-			err = -BCME_RANGE;
+			err = -EINVAL;
 		break;
 	}
 
@@ -7615,7 +7609,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 		if (stf > PHY_TXC1_MODE_SDM) {
 			dev_err(wlc->dev, "wl%d: %s: Invalid stf\n",
 				 WLCWLUNIT(wlc), __func__);
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 			goto done;
 		}
 
@@ -7626,7 +7620,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 			     && (stf != PHY_TXC1_MODE_CDD))) {
 				dev_err(wlc->dev, "wl%d: %s: Invalid mcs 32\n",
 					 WLCWLUNIT(wlc), __func__);
-				bcmerror = -BCME_RANGE;
+				bcmerror = -EINVAL;
 				goto done;
 			}
 			/* mcs > 7 must use stf SDM */
@@ -7644,7 +7638,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 			     && (stf == PHY_TXC1_MODE_STBC))) {
 				dev_err(wlc->dev, "wl%d: %s: Invalid STBC\n",
 					 WLCWLUNIT(wlc), __func__);
-				bcmerror = -BCME_RANGE;
+				bcmerror = -EINVAL;
 				goto done;
 			}
 		}
@@ -7652,7 +7646,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 		if ((stf != PHY_TXC1_MODE_CDD) && (stf != PHY_TXC1_MODE_SISO)) {
 			dev_err(wlc->dev, "wl%d: %s: Invalid OFDM\n",
 				 WLCWLUNIT(wlc), __func__);
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 			goto done;
 		}
 	} else if (IS_CCK(rate)) {
@@ -7660,20 +7654,20 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 		    || (stf != PHY_TXC1_MODE_SISO)) {
 			dev_err(wlc->dev, "wl%d: %s: Invalid CCK\n",
 				 WLCWLUNIT(wlc), __func__);
-			bcmerror = -BCME_RANGE;
+			bcmerror = -EINVAL;
 			goto done;
 		}
 	} else {
 		dev_err(wlc->dev, "wl%d: %s: Unknown rate type\n",
 			 WLCWLUNIT(wlc), __func__);
-		bcmerror = -BCME_RANGE;
+		bcmerror = -EINVAL;
 		goto done;
 	}
 	/* make sure multiple antennae are available for non-siso rates */
 	if ((stf != PHY_TXC1_MODE_SISO) && (wlc->stf->txstreams == 1)) {
 		dev_err(wlc->dev, "wl%d: %s: SISO antenna but !SISO request\n",
 			 WLCWLUNIT(wlc), __func__);
-		bcmerror = -BCME_RANGE;
+		bcmerror = -EINVAL;
 		goto done;
 	}
 
@@ -7718,7 +7712,7 @@ wlc_duty_cycle_set(struct wlc_info *wlc, int duty_cycle, bool isOFDM,
 	if (duty_cycle > 100 || duty_cycle < 0) {
 		dev_err(wlc->dev, "wl%d:  duty cycle value off limit\n",
 			WLCWLUNIT(wlc));
-		return -BCME_RANGE;
+		return -EINVAL;
 	}
 	if (duty_cycle)
 		idle_busy_ratio_x_16 = (100 - duty_cycle) * 16 / duty_cycle;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index fdd9524..26f1897 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -255,12 +255,12 @@ int wlc_stf_txchain_set(struct wlc_info *wlc, s32 int_val, bool force)
 
 	if ((txchain & ~wlc->stf->hw_txchain)
 	    || !(txchain & wlc->stf->hw_txchain))
-		return -BCME_RANGE;
+		return -EINVAL;
 
 	/* if nrate override is configured to be non-SISO STF mode, reject reducing txchain to 1 */
 	txstreams = (u8) WLC_BITSCNT(txchain);
 	if (txstreams > MAX_STREAMS_SUPPORTED)
-		return -BCME_RANGE;
+		return -EINVAL;
 
 	if (txstreams == 1) {
 		for (i = 0; i < NBANDS(wlc); i++)
@@ -269,7 +269,7 @@ int wlc_stf_txchain_set(struct wlc_info *wlc, s32 int_val, bool force)
 			    || (RSPEC_STF(wlc->bandstate[i]->mrspec_override) !=
 				PHY_TXC1_MODE_SISO)) {
 				if (!force)
-					return -BCME_ERROR;
+					return -EBADE;
 
 				/* over-write the override rspec */
 				if (RSPEC_STF(wlc->bandstate[i]->rspec_override)
@@ -377,7 +377,7 @@ int wlc_stf_ant_txant_validate(struct wlc_info *wlc, s8 val)
 
 	/* when there is only 1 tx_streams, don't allow to change the txant */
 	if (WLCISNPHY(wlc->band) && (wlc->stf->txstreams == 1))
-		return ((val == wlc->stf->txant) ? bcmerror : -BCME_RANGE);
+		return ((val == wlc->stf->txant) ? bcmerror : -EINVAL);
 
 	switch (val) {
 	case -1:
@@ -393,7 +393,7 @@ int wlc_stf_ant_txant_validate(struct wlc_info *wlc, s8 val)
 		val = ANT_TX_LAST_RX;
 		break;
 	default:
-		bcmerror = -BCME_RANGE;
+		bcmerror = -EINVAL;
 		break;
 	}
 
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index a026356..f2e81e5 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -241,30 +241,6 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 /* ** driver/apps-shared section ** */
 
 #define BCME_STRLEN 		64	/* Max string length for BCM errors */
-#define VALID_BCMERROR(e)  ((e <= 0) && (e >= -BCME_LAST))
-
-/*
- * error codes could be added but the defined ones shouldn't be changed/deleted
- * these error codes are exposed to the user code
- * when ever a new error code is added to this list
- * please update errorstring table with the related error string and
- * update osl files with os specific errorcode map
-*/
-
-#define BCME_ERROR			1	/* Error generic */
-#define BCME_NOTDOWN			5	/* Not down */
-#define BCME_RADIOOFF			9	/* Radio Off */
-#define BCME_NOTBANDLOCKED		10	/* Not  band locked */
-#define BCME_NOCLK			11	/* No Clock */
-#define BCME_BUFTOOLONG			15	/* Buffer too long */
-#define BCME_NOTREADY			25	/* Not Ready */
-#define BCME_ASSOCIATED			28	/* Associated */
-#define BCME_RANGE			29	/* Not In Range */
-#define BCME_NOTFOUND			30	/* Not Found */
-#define BCME_SDIO_ERROR			35	/* SDIO Bus Error */
-#define BCME_DONGLE_DOWN		36	/* Dongle Not Accessible */
-#define BCME_NONRESIDENT		42  /* access to nonresident overlay */
-#define BCME_LAST			BCME_NONRESIDENT
 
 #ifndef ABS
 #define	ABS(a)			(((a) < 0) ? -(a) : (a))
diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/util/bcmotp.c
index bdfe586..d150c05 100644
--- a/drivers/staging/brcm80211/util/bcmotp.c
+++ b/drivers/staging/brcm80211/util/bcmotp.c
@@ -382,7 +382,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		sz = (uint) oi->hwlim - oi->hwbase;
 		if (!(oi->status & OTPS_GUP_HW)) {
 			*wlen = sz;
-			return -BCME_NOTFOUND;
+			return -ENODATA;
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
@@ -394,7 +394,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		sz = ((uint) oi->swlim - oi->swbase);
 		if (!(oi->status & OTPS_GUP_SW)) {
 			*wlen = sz;
-			return -BCME_NOTFOUND;
+			return -ENODATA;
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
@@ -406,7 +406,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		sz = OTPGU_CI_SZ;
 		if (!(oi->status & OTPS_GUP_CI)) {
 			*wlen = sz;
-			return -BCME_NOTFOUND;
+			return -ENODATA;
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
@@ -418,7 +418,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		sz = (uint) oi->flim - oi->fbase;
 		if (!(oi->status & OTPS_GUP_FUSE)) {
 			*wlen = sz;
-			return -BCME_NOTFOUND;
+			return -ENODATA;
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
@@ -430,7 +430,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		sz = ((uint) oi->flim - oi->hwbase);
 		if (!(oi->status & (OTPS_GUP_HW | OTPS_GUP_SW))) {
 			*wlen = sz;
-			return -BCME_NOTFOUND;
+			return -ENODATA;
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
@@ -706,7 +706,7 @@ static int hndotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 	/* Region empty? */
 	st = oi->hwprot | oi->signvalid;
 	if ((st & region) == 0)
-		return -BCME_NOTFOUND;
+		return -ENODATA;
 
 	*wlen =
 	    ((int)*wlen < oi->boundary / 2) ? *wlen : (uint) oi->boundary / 2;
@@ -924,13 +924,13 @@ otp_read_region(si_t *sih, int region, u16 *data,
 		ai_otp_power(sih, true);
 
 	if (!ai_is_otp_powered(sih) || ai_is_otp_disabled(sih)) {
-		err = -BCME_NOTREADY;
+		err = -EPERM;
 		goto out;
 	}
 
 	oh = otp_init(sih);
 	if (oh == NULL) {
-		err = -BCME_ERROR;
+		err = -EBADE;
 		goto out;
 	}
 
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index d5afa37..bf058e4 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -280,7 +280,7 @@ static int otp_read_pci(si_t *sih, u16 *buf, uint bufsz)
 
 	otp = kzalloc(OTP_SZ_MAX, GFP_ATOMIC);
 	if (otp == NULL) {
-		return -BCME_ERROR;
+		return -EBADE;
 	}
 
 	err = otp_read_region(sih, OTP_HW_RGN, (u16 *) otp, &sz);
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 457a023..1acdc0e 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -520,7 +520,7 @@ int bcm_iovar_lencheck(const bcm_iovar_t *vi, void *arg, int len, bool set)
 			bcmerror = -ENOTSUPP;
 		} else if (len) {
 			/* Set is an action w/o parameters */
-			bcmerror = -BCME_BUFTOOLONG;
+			bcmerror = -ENOBUFS;
 		}
 		break;
 
-- 
1.7.1


