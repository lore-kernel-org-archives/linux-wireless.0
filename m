Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2303 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 02/61] staging: brcm80211: made error codes in
 bcmutils.h positive
Date: Tue, 3 May 2011 11:35:02 +0200
Message-ID: <1304415361-7813-3-git-send-email-arend@broadcom.com> (sfid-20110503_113637_477351_F552D7D9)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Bringing driver more inline with Linux code style.
Does not introduce behavioral changes.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |   32 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   18 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |   10 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   28 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |  104 +++++-----
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |  122 ++++++------
 drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c |   12 +-
 drivers/staging/brcm80211/brcmsmac/wl_mac80211.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |   10 +-
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c      |    4 +-
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_key.h       |   10 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |  202 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c       |   10 +-
 drivers/staging/brcm80211/include/bcmutils.h       |   56 +++---
 drivers/staging/brcm80211/util/bcmotp.c            |   30 ++--
 drivers/staging/brcm80211/util/bcmsrom.c           |   12 +-
 drivers/staging/brcm80211/util/bcmutils.c          |   14 +-
 drivers/staging/brcm80211/util/nvram/nvram_ro.c    |    6 +-
 20 files changed, 344 insertions(+), 342 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 0627b7d..745e3c2 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -126,7 +126,7 @@ int bcmsdh_intr_enable(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_set(bcmsdh->sdioh, true);
-	return SDIOH_API_SUCCESS(status) ? 0 : BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
 }
 
 int bcmsdh_intr_disable(void *sdh)
@@ -136,7 +136,7 @@ int bcmsdh_intr_disable(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_set(bcmsdh->sdioh, false);
-	return SDIOH_API_SUCCESS(status) ? 0 : BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
 }
 
 int bcmsdh_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
@@ -146,7 +146,7 @@ int bcmsdh_intr_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_register(bcmsdh->sdioh, fn, argh);
-	return SDIOH_API_SUCCESS(status) ? 0 : BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
 }
 
 int bcmsdh_intr_dereg(void *sdh)
@@ -156,7 +156,7 @@ int bcmsdh_intr_dereg(void *sdh)
 	ASSERT(bcmsdh);
 
 	status = sdioh_interrupt_deregister(bcmsdh->sdioh);
-	return SDIOH_API_SUCCESS(status) ? 0 : BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
 }
 
 #if defined(DHD_DEBUG)
@@ -174,7 +174,7 @@ int bcmsdh_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 	ASSERT(sdh);
 
 	/* don't support yet */
-	return BCME_UNSUPPORTED;
+	return -BCME_UNSUPPORTED;
 }
 
 u8 bcmsdh_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
@@ -204,7 +204,7 @@ u8 bcmsdh_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
 #endif
 	if (err)
-		*err = (SDIOH_API_SUCCESS(status) ? 0 : BCME_SDIO_ERROR);
+		*err = (SDIOH_API_SUCCESS(status) ? 0 : -BCME_SDIO_ERROR);
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -239,7 +239,7 @@ bcmsdh_cfg_write(void *sdh, uint fnc_num, u32 addr, u8 data, int *err)
 		 && (retry++ < SDIOH_API_ACCESS_RETRY_LIMIT));
 #endif
 	if (err)
-		*err = SDIOH_API_SUCCESS(status) ? 0 : BCME_SDIO_ERROR;
+		*err = SDIOH_API_SUCCESS(status) ? 0 : -BCME_SDIO_ERROR;
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u8data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -261,7 +261,7 @@ u32 bcmsdh_cfg_read_word(void *sdh, uint fnc_num, u32 addr, int *err)
 			       fnc_num, addr, &data, 4);
 
 	if (err)
-		*err = (SDIOH_API_SUCCESS(status) ? 0 : BCME_SDIO_ERROR);
+		*err = (SDIOH_API_SUCCESS(status) ? 0 : -BCME_SDIO_ERROR);
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -286,7 +286,7 @@ bcmsdh_cfg_write_word(void *sdh, uint fnc_num, u32 addr, u32 data,
 			       SDIOH_WRITE, fnc_num, addr, &data, 4);
 
 	if (err)
-		*err = (SDIOH_API_SUCCESS(status) ? 0 : BCME_SDIO_ERROR);
+		*err = (SDIOH_API_SUCCESS(status) ? 0 : -BCME_SDIO_ERROR);
 
 	BCMSDH_INFO(("%s:fun = %d, addr = 0x%x, u32data = 0x%x\n",
 		     __func__, fnc_num, addr, data));
@@ -317,7 +317,7 @@ int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
 		tmp_buf = kmalloc(length, GFP_ATOMIC);
 		if (tmp_buf == NULL) {
 			BCMSDH_ERROR(("%s: out of memory\n", __func__));
-			return BCME_NOMEM;
+			return -BCME_NOMEM;
 		}
 		memcpy(tmp_buf, cis, length);
 		for (tmp_ptr = tmp_buf, ptr = cis; ptr < (cis + length - 4);
@@ -329,7 +329,7 @@ int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
 		kfree(tmp_buf);
 	}
 
-	return SDIOH_API_SUCCESS(status) ? 0 : BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
 }
 
 static int bcmsdhsdio_set_sbaddr_window(void *sdh, u32 address)
@@ -467,7 +467,7 @@ bcmsdh_recv_buf(void *sdh, u32 addr, uint fn, uint flags,
 	/* Async not implemented yet */
 	ASSERT(!(flags & SDIO_REQ_ASYNC));
 	if (flags & SDIO_REQ_ASYNC)
-		return BCME_UNSUPPORTED;
+		return -BCME_UNSUPPORTED;
 
 	if (bar0 != bcmsdh->sbwad) {
 		err = bcmsdhsdio_set_sbaddr_window(bcmsdh, bar0);
@@ -488,7 +488,7 @@ bcmsdh_recv_buf(void *sdh, u32 addr, uint fn, uint flags,
 				      SDIOH_READ, fn, addr, width, nbytes, buf,
 				      pkt);
 
-	return SDIOH_API_SUCCESS(status) ? 0 : BCME_SDIO_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_SDIO_ERROR;
 }
 
 int
@@ -512,7 +512,7 @@ bcmsdh_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 	/* Async not implemented yet */
 	ASSERT(!(flags & SDIO_REQ_ASYNC));
 	if (flags & SDIO_REQ_ASYNC)
-		return BCME_UNSUPPORTED;
+		return -BCME_UNSUPPORTED;
 
 	if (bar0 != bcmsdh->sbwad) {
 		err = bcmsdhsdio_set_sbaddr_window(bcmsdh, bar0);
@@ -533,7 +533,7 @@ bcmsdh_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 				      SDIOH_WRITE, fn, addr, width, nbytes, buf,
 				      pkt);
 
-	return SDIOH_API_SUCCESS(status) ? 0 : BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
 }
 
 int bcmsdh_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
@@ -553,7 +553,7 @@ int bcmsdh_rwdata(void *sdh, uint rw, u32 addr, u8 *buf, uint nbytes)
 				 (rw ? SDIOH_WRITE : SDIOH_READ), SDIO_FUNC_1,
 				 addr, 4, nbytes, buf, NULL);
 
-	return SDIOH_API_SUCCESS(status) ? 0 : BCME_ERROR;
+	return SDIOH_API_SUCCESS(status) ? 0 : -BCME_ERROR;
 }
 
 int bcmsdh_abort(void *sdh, uint fn)
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index d765462..9212fcd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -423,7 +423,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	vi = bcm_iovar_lookup(sdioh_iovars, name);
 	if (vi == NULL) {
-		bcmerror = BCME_UNSUPPORTED;
+		bcmerror = -BCME_UNSUPPORTED;
 		goto exit;
 	}
 
@@ -472,7 +472,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	case IOV_GVAL(IOV_BLOCKSIZE):
 		if ((u32) int_val > si->num_funcs) {
-			bcmerror = BCME_BADARG;
+			bcmerror = -BCME_BADARG;
 			break;
 		}
 		int_val = (s32) si->client_block_size[int_val];
@@ -486,7 +486,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 			uint maxsize;
 
 			if (func > si->num_funcs) {
-				bcmerror = BCME_BADARG;
+				bcmerror = -BCME_BADARG;
 				break;
 			}
 
@@ -504,7 +504,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 				maxsize = 0;
 			}
 			if (blksize > maxsize) {
-				bcmerror = BCME_BADARG;
+				bcmerror = -BCME_BADARG;
 				break;
 			}
 			if (!blksize)
@@ -607,7 +607,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 			    || sd_ptr->offset > SD_MaxCurCap) {
 				sd_err(("%s: bad offset 0x%x\n", __func__,
 					sd_ptr->offset));
-				bcmerror = BCME_BADARG;
+				bcmerror = -BCME_BADARG;
 				break;
 			}
 
@@ -637,7 +637,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 			    || sd_ptr->offset > SD_MaxCurCap) {
 				sd_err(("%s: bad offset 0x%x\n", __func__,
 					sd_ptr->offset));
-				bcmerror = BCME_BADARG;
+				bcmerror = -BCME_BADARG;
 				break;
 			}
 
@@ -656,7 +656,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 			if (sdioh_cfg_read
 			    (si, sd_ptr->func, sd_ptr->offset, &data)) {
-				bcmerror = BCME_SDIO_ERROR;
+				bcmerror = -BCME_SDIO_ERROR;
 				break;
 			}
 
@@ -672,14 +672,14 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 			if (sdioh_cfg_write
 			    (si, sd_ptr->func, sd_ptr->offset, &data)) {
-				bcmerror = BCME_SDIO_ERROR;
+				bcmerror = -BCME_SDIO_ERROR;
 				break;
 			}
 			break;
 		}
 
 	default:
-		bcmerror = BCME_UNSUPPORTED;
+		bcmerror = -BCME_UNSUPPORTED;
 		break;
 	}
 exit:
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index bcacc38..0d72dd4 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -151,7 +151,7 @@ int sdioh_sdmmc_osinit(sdioh_info_t *sd)
 	sdos = kmalloc(sizeof(struct sdos_info), GFP_ATOMIC);
 	sd->sdos_info = (void *)sdos;
 	if (sdos == NULL)
-		return BCME_NOMEM;
+		return -BCME_NOMEM;
 
 	sdos->sd = sd;
 	spin_lock_init(&sdos->lock);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 39a4d00..db8c027 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -309,7 +309,7 @@ int
 dhd_prot_iovar_op(dhd_pub_t *dhdp, const char *name,
 		  void *params, int plen, void *arg, int len, bool set)
 {
-	return BCME_UNSUPPORTED;
+	return -BCME_UNSUPPORTED;
 }
 
 void dhd_prot_dump(dhd_pub_t *dhdp, struct bcmstrbuf *strbuf)
@@ -357,7 +357,7 @@ int dhd_prot_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 	if (pktbuf->len < BDC_HEADER_LEN) {
 		DHD_ERROR(("%s: rx data too short (%d < %d)\n", __func__,
 			   pktbuf->len, BDC_HEADER_LEN));
-		return BCME_ERROR;
+		return -BCME_ERROR;
 	}
 
 	h = (struct bdc_header *)(pktbuf->data);
@@ -366,14 +366,14 @@ int dhd_prot_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 	if (*ifidx >= DHD_MAX_IFS) {
 		DHD_ERROR(("%s: rx data ifnum out of range (%d)\n",
 			   __func__, *ifidx));
-		return BCME_ERROR;
+		return -BCME_ERROR;
 	}
 
 	if (((h->flags & BDC_FLAG_VER_MASK) >> BDC_FLAG_VER_SHIFT) !=
 	    BDC_PROTO_VER) {
 		DHD_ERROR(("%s: non-BDC packet received, flags 0x%x\n",
 			   dhd_ifname(dhd, *ifidx), h->flags));
-		return BCME_ERROR;
+		return -BCME_ERROR;
 	}
 
 	if (h->flags & BDC_FLAG_SUM_GOOD) {
@@ -416,7 +416,7 @@ int dhd_prot_attach(dhd_pub_t *dhd)
 
 fail:
 	kfree(cdc);
-	return BCME_NOMEM;
+	return -BCME_NOMEM;
 }
 
 /* ~NOTE~ What if another thread is waiting on the semaphore?  Holding it? */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 7d349b7..8d5acb8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -189,7 +189,7 @@ static int dhd_dump(dhd_pub_t *dhdp, char *buf, int buflen)
 	/* Add any bus info */
 	dhd_bus_dump(dhdp, strbuf);
 
-	return !strbuf->size ? BCME_BUFTOOSHORT : 0;
+	return !strbuf->size ? -BCME_BUFTOOSHORT : 0;
 }
 
 static int
@@ -242,7 +242,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_WDTICK):
 		if (!dhd_pub->up) {
-			bcmerror = BCME_NOTUP;
+			bcmerror = -BCME_NOTUP;
 			break;
 		}
 		dhd_os_wd_timer(dhd_pub, (uint) int_val);
@@ -289,7 +289,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_IOCTLTIMEOUT):{
 			if (int_val <= 0)
-				bcmerror = BCME_BADARG;
+				bcmerror = -BCME_BADARG;
 			else
 				dhd_os_set_ioctl_resp_timeout((unsigned int)
 							      int_val);
@@ -297,7 +297,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 		}
 
 	default:
-		bcmerror = BCME_UNSUPPORTED;
+		bcmerror = -BCME_UNSUPPORTED;
 		break;
 	}
 
@@ -381,7 +381,7 @@ dhd_iovar_op(dhd_pub_t *dhd_pub, const char *name,
 
 	vi = bcm_iovar_lookup(dhd_iovars, name);
 	if (vi == NULL) {
-		bcmerror = BCME_UNSUPPORTED;
+		bcmerror = -BCME_UNSUPPORTED;
 		goto exit;
 	}
 
@@ -420,19 +420,19 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	if (!buf)
-		return BCME_BADARG;
+		return -BCME_BADARG;
 
 	switch (ioc->cmd) {
 	case DHD_GET_MAGIC:
 		if (buflen < sizeof(int))
-			bcmerror = BCME_BUFTOOSHORT;
+			bcmerror = -BCME_BUFTOOSHORT;
 		else
 			*(int *)buf = DHD_IOCTL_MAGIC;
 		break;
 
 	case DHD_GET_VERSION:
 		if (buflen < sizeof(int))
-			bcmerror = -BCME_BUFTOOSHORT;
+			bcmerror = BCME_BUFTOOSHORT;
 		else
 			*(int *)buf = DHD_IOCTL_VERSION;
 		break;
@@ -448,7 +448,7 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 				;
 
 			if (*arg) {
-				bcmerror = BCME_BUFTOOSHORT;
+				bcmerror = -BCME_BUFTOOSHORT;
 				break;
 			}
 
@@ -464,7 +464,7 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 				bcmerror =
 				    dhd_iovar_op(dhd_pub, buf, NULL, 0, arg,
 						 arglen, IOV_SET);
-			if (bcmerror != BCME_UNSUPPORTED)
+			if (bcmerror != -BCME_UNSUPPORTED)
 				break;
 
 			/* not in generic table, try protocol module */
@@ -476,7 +476,7 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 				bcmerror = dhd_prot_iovar_op(dhd_pub, buf,
 							     NULL, 0, arg,
 							     arglen, IOV_SET);
-			if (bcmerror != BCME_UNSUPPORTED)
+			if (bcmerror != -BCME_UNSUPPORTED)
 				break;
 
 			/* if still not found, try bus module */
@@ -493,7 +493,7 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 		}
 
 	default:
-		bcmerror = BCME_UNSUPPORTED;
+		bcmerror = -BCME_UNSUPPORTED;
 	}
 
 	return bcmerror;
@@ -815,14 +815,14 @@ wl_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 
 	if (memcmp(BRCM_OUI, &pvt_data->bcm_hdr.oui[0], DOT11_OUI_LEN)) {
 		DHD_ERROR(("%s: mismatched OUI, bailing\n", __func__));
-		return BCME_ERROR;
+		return -BCME_ERROR;
 	}
 
 	/* BRCM event pkt may be unaligned - use xxx_ua to load user_subtype. */
 	if (get_unaligned_be16(&pvt_data->bcm_hdr.usr_subtype) !=
 	    BCMILCP_BCM_SUBTYPE_EVENT) {
 		DHD_ERROR(("%s: mismatched subtype, bailing\n", __func__));
-		return BCME_ERROR;
+		return -BCME_ERROR;
 	}
 
 	*data_ptr = &pvt_data[1];
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 5d4b643..bb4fdc6 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1620,48 +1620,48 @@ static int dhd_ethtool(dhd_info_t *dhd, void *uaddr)
 }
 
 static s16 linuxbcmerrormap[] = { 0,	/* 0 */
-	-EINVAL,		/* BCME_ERROR */
-	-EINVAL,		/* BCME_BADARG */
-	-EINVAL,		/* BCME_BADOPTION */
-	-EINVAL,		/* BCME_NOTUP */
-	-EINVAL,		/* BCME_NOTDOWN */
-	-EINVAL,		/* BCME_NOTAP */
-	-EINVAL,		/* BCME_NOTSTA */
-	-EINVAL,		/* BCME_BADKEYIDX */
-	-EINVAL,		/* BCME_RADIOOFF */
-	-EINVAL,		/* BCME_NOTBANDLOCKED */
-	-EINVAL,		/* BCME_NOCLK */
-	-EINVAL,		/* BCME_BADRATESET */
-	-EINVAL,		/* BCME_BADBAND */
-	-E2BIG,			/* BCME_BUFTOOSHORT */
-	-E2BIG,			/* BCME_BUFTOOLONG */
-	-EBUSY,			/* BCME_BUSY */
-	-EINVAL,		/* BCME_NOTASSOCIATED */
-	-EINVAL,		/* BCME_BADSSIDLEN */
-	-EINVAL,		/* BCME_OUTOFRANGECHAN */
-	-EINVAL,		/* BCME_BADCHAN */
-	-EFAULT,		/* BCME_BADADDR */
-	-ENOMEM,		/* BCME_NORESOURCE */
-	-EOPNOTSUPP,		/* BCME_UNSUPPORTED */
-	-EMSGSIZE,		/* BCME_BADLENGTH */
-	-EINVAL,		/* BCME_NOTREADY */
-	-EPERM,			/* BCME_NOTPERMITTED */
-	-ENOMEM,		/* BCME_NOMEM */
-	-EINVAL,		/* BCME_ASSOCIATED */
-	-ERANGE,		/* BCME_RANGE */
-	-EINVAL,		/* BCME_NOTFOUND */
-	-EINVAL,		/* BCME_WME_NOT_ENABLED */
-	-EINVAL,		/* BCME_TSPEC_NOTFOUND */
-	-EINVAL,		/* BCME_ACM_NOTSUPPORTED */
-	-EINVAL,		/* BCME_NOT_WME_ASSOCIATION */
-	-EIO,			/* BCME_SDIO_ERROR */
-	-ENODEV,		/* BCME_DONGLE_DOWN */
-	-EINVAL,		/* BCME_VERSION */
-	-EIO,			/* BCME_TXFAIL */
-	-EIO,			/* BCME_RXFAIL */
-	-EINVAL,		/* BCME_NODEVICE */
-	-EINVAL,		/* BCME_NMODE_DISABLED */
-	-ENODATA,		/* BCME_NONRESIDENT */
+	-EINVAL,		/* -BCME_ERROR */
+	-EINVAL,		/* -BCME_BADARG */
+	-EINVAL,		/* -BCME_BADOPTION */
+	-EINVAL,		/* -BCME_NOTUP */
+	-EINVAL,		/* -BCME_NOTDOWN */
+	-EINVAL,		/* -BCME_NOTAP */
+	-EINVAL,		/* -BCME_NOTSTA */
+	-EINVAL,		/* -BCME_BADKEYIDX */
+	-EINVAL,		/* -BCME_RADIOOFF */
+	-EINVAL,		/* -BCME_NOTBANDLOCKED */
+	-EINVAL,		/* -BCME_NOCLK */
+	-EINVAL,		/* -BCME_BADRATESET */
+	-EINVAL,		/* -BCME_BADBAND */
+	-E2BIG,			/* -BCME_BUFTOOSHORT */
+	-E2BIG,			/* -BCME_BUFTOOLONG */
+	-EBUSY,			/* -BCME_BUSY */
+	-EINVAL,		/* -BCME_NOTASSOCIATED */
+	-EINVAL,		/* -BCME_BADSSIDLEN */
+	-EINVAL,		/* -BCME_OUTOFRANGECHAN */
+	-EINVAL,		/* -BCME_BADCHAN */
+	-EFAULT,		/* -BCME_BADADDR */
+	-ENOMEM,		/* -BCME_NORESOURCE */
+	-EOPNOTSUPP,		/* -BCME_UNSUPPORTED */
+	-EMSGSIZE,		/* -BCME_BADLENGTH */
+	-EINVAL,		/* -BCME_NOTREADY */
+	-EPERM,			/* -BCME_NOTPERMITTED */
+	-ENOMEM,		/* -BCME_NOMEM */
+	-EINVAL,		/* -BCME_ASSOCIATED */
+	-ERANGE,		/* -BCME_RANGE */
+	-EINVAL,		/* -BCME_NOTFOUND */
+	-EINVAL,		/* -BCME_WME_NOT_ENABLED */
+	-EINVAL,		/* -BCME_TSPEC_NOTFOUND */
+	-EINVAL,		/* -BCME_ACM_NOTSUPPORTED */
+	-EINVAL,		/* -BCME_NOT_WME_ASSOCIATION */
+	-EIO,			/* -BCME_SDIO_ERROR */
+	-ENODEV,		/* -BCME_DONGLE_DOWN */
+	-EINVAL,		/* -BCME_VERSION */
+	-EIO,			/* -BCME_TXFAIL */
+	-EIO,			/* -BCME_RXFAIL */
+	-EINVAL,		/* -BCME_NODEVICE */
+	-EINVAL,		/* -BCME_NMODE_DISABLED */
+	-ENODATA,		/* -BCME_NONRESIDENT */
 };
 
 static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
@@ -1699,7 +1699,7 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 
 	/* Copy the ioc control structure part of ioctl request */
 	if (copy_from_user(&ioc, ifr->ifr_data, sizeof(wl_ioctl_t))) {
-		bcmerror = -BCME_BADADDR;
+		bcmerror = BCME_BADADDR;
 		goto done;
 	}
 
@@ -1715,11 +1715,11 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 		{
 			buf = kmalloc(buflen, GFP_ATOMIC);
 			if (!buf) {
-				bcmerror = -BCME_NOMEM;
+				bcmerror = BCME_NOMEM;
 				goto done;
 			}
 			if (copy_from_user(buf, ioc.buf, buflen)) {
-				bcmerror = -BCME_BADADDR;
+				bcmerror = BCME_BADADDR;
 				goto done;
 			}
 		}
@@ -1728,12 +1728,12 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 	/* To differentiate between wl and dhd read 4 more byes */
 	if ((copy_from_user(&driver, (char *)ifr->ifr_data + sizeof(wl_ioctl_t),
 			    sizeof(uint)) != 0)) {
-		bcmerror = -BCME_BADADDR;
+		bcmerror = BCME_BADADDR;
 		goto done;
 	}
 
 	if (!capable(CAP_NET_ADMIN)) {
-		bcmerror = -BCME_EPERM;
+		bcmerror = BCME_EPERM;
 		goto done;
 	}
 
@@ -1748,12 +1748,12 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 	/* send to dongle (must be up, and wl) */
 	if ((dhd->pub.busstate != DHD_BUS_DATA)) {
 		DHD_ERROR(("%s DONGLE_DOWN,__func__\n", __func__));
-		bcmerror = BCME_DONGLE_DOWN;
+		bcmerror = -BCME_DONGLE_DOWN;
 		goto done;
 	}
 
 	if (!dhd->pub.iswl) {
-		bcmerror = BCME_DONGLE_DOWN;
+		bcmerror = -BCME_DONGLE_DOWN;
 		goto done;
 	}
 
@@ -1781,8 +1781,8 @@ done:
 
 	if (bcmerror > 0)
 		bcmerror = 0;
-	else if (bcmerror < BCME_LAST)
-		bcmerror = BCME_ERROR;
+	else if (bcmerror < -BCME_LAST)
+		bcmerror = -BCME_ERROR;
 
 	return linuxbcmerrormap[-bcmerror];
 }
@@ -2280,7 +2280,7 @@ int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
 
 fail:
 	net->netdev_ops = NULL;
-	return BCME_ERROR;
+	return -BCME_ERROR;
 }
 
 void dhd_bus_detach(dhd_pub_t *dhdp)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index e6beeb7..12379d2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -541,7 +541,7 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		if (err) {
 			DHD_ERROR(("%s: HT Avail request error: %d\n",
 				   __func__, err));
-			return BCME_ERROR;
+			return -BCME_ERROR;
 		}
 
 		if (pendok && ((bus->ci->buscoretype == PCMCIA_CORE_ID)
@@ -557,7 +557,7 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		if (err) {
 			DHD_ERROR(("%s: HT Avail read error: %d\n",
 				   __func__, err));
-			return BCME_ERROR;
+			return -BCME_ERROR;
 		}
 
 		/* Go to pending and await interrupt if appropriate */
@@ -569,7 +569,7 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 			if (err) {
 				DHD_ERROR(("%s: Devctl error setting CA: %d\n",
 					__func__, err));
-				return BCME_ERROR;
+				return -BCME_ERROR;
 			}
 
 			devctl |= SBSDIO_DEVCTL_CA_INT_ONLY;
@@ -602,12 +602,12 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		if (err) {
 			DHD_ERROR(("%s: HT Avail request error: %d\n",
 				   __func__, err));
-			return BCME_ERROR;
+			return -BCME_ERROR;
 		}
 		if (!SBSDIO_CLKAV(clkctl, bus->alp_only)) {
 			DHD_ERROR(("%s: HT Avail timeout (%d): clkctl 0x%02x\n",
 				   __func__, PMU_MAX_TRANSITION_DLY, clkctl));
-			return BCME_ERROR;
+			return -BCME_ERROR;
 		}
 
 		/* Mark clock available */
@@ -651,7 +651,7 @@ static int dhdsdio_htclk(dhd_bus_t *bus, bool on, bool pendok)
 		if (err) {
 			DHD_ERROR(("%s: Failed access turning clock off: %d\n",
 				   __func__, err));
-			return BCME_ERROR;
+			return -BCME_ERROR;
 		}
 	}
 	return 0;
@@ -674,7 +674,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			if (err) {
 				DHD_ERROR(("%s: error enabling sd_clock: %d\n",
 					   __func__, err));
-				return BCME_ERROR;
+				return -BCME_ERROR;
 			}
 
 			iovalue = bus->sd_mode;
@@ -683,7 +683,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			if (err) {
 				DHD_ERROR(("%s: error changing sd_mode: %d\n",
 					   __func__, err));
-				return BCME_ERROR;
+				return -BCME_ERROR;
 			}
 		} else if (bus->idleclock != DHD_IDLE_ACTIVE) {
 			/* Restore clock speed */
@@ -693,7 +693,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			if (err) {
 				DHD_ERROR(("%s: error restoring sd_divisor: %d\n",
 					__func__, err));
-				return BCME_ERROR;
+				return -BCME_ERROR;
 			}
 		}
 		bus->clkstate = CLK_SDONLY;
@@ -702,7 +702,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 		if ((bus->sd_divisor == -1) || (bus->sd_mode == -1)) {
 			DHD_TRACE(("%s: can't idle clock, divisor %d mode %d\n",
 				   __func__, bus->sd_divisor, bus->sd_mode));
-			return BCME_ERROR;
+			return -BCME_ERROR;
 		}
 		if (bus->idleclock == DHD_IDLE_STOP) {
 			if (sd1idle) {
@@ -715,7 +715,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 				if (err) {
 					DHD_ERROR(("%s: error changing sd_clock: %d\n",
 						__func__, err));
-					return BCME_ERROR;
+					return -BCME_ERROR;
 				}
 			}
 
@@ -725,7 +725,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			if (err) {
 				DHD_ERROR(("%s: error disabling sd_clock: %d\n",
 					   __func__, err));
-				return BCME_ERROR;
+				return -BCME_ERROR;
 			}
 		} else if (bus->idleclock != DHD_IDLE_ACTIVE) {
 			/* Set divisor to idle value */
@@ -735,7 +735,7 @@ static int dhdsdio_sdclk(dhd_bus_t *bus, bool on)
 			if (err) {
 				DHD_ERROR(("%s: error changing sd_divisor: %d\n",
 					__func__, err));
-				return BCME_ERROR;
+				return -BCME_ERROR;
 			}
 		}
 		bus->clkstate = CLK_NONE;
@@ -819,7 +819,7 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 	if (sleep) {
 		/* Don't sleep if something is pending */
 		if (bus->dpc_sched || bus->rxskip || pktq_len(&bus->txq))
-			return BCME_BUSY;
+			return -BCME_BUSY;
 
 		/* Disable SDIO interrupts (no longer interested) */
 		bcmsdh_intr_disable(bus->sdh);
@@ -943,7 +943,7 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 	sdh = bus->sdh;
 
 	if (bus->dhd->dongle_reset) {
-		ret = BCME_NOTREADY;
+		ret = -BCME_NOTREADY;
 		goto done;
 	}
 
@@ -961,7 +961,7 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 				DHD_ERROR(("%s: couldn't allocate new %d-byte "
 					"packet\n",
 					__func__, pkt->len + DHD_SDALIGN));
-				ret = BCME_NOMEM;
+				ret = -BCME_NOMEM;
 				goto done;
 			}
 
@@ -1040,7 +1040,7 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 		    dhd_bcmsdh_send_buf(bus, bcmsdh_cur_sbwad(sdh), SDIO_FUNC_2,
 					F2SYNC, frame, len, pkt, NULL, NULL);
 		bus->f2txdata++;
-		ASSERT(ret != BCME_PENDING);
+		ASSERT(ret != -BCME_PENDING);
 
 		if (ret < 0) {
 			/* On failure, abort the command
@@ -1089,7 +1089,7 @@ done:
 
 int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 {
-	int ret = BCME_ERROR;
+	int ret = -BCME_ERROR;
 	uint datalen, prec;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
@@ -1133,7 +1133,7 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 			dhd_txcomplete(bus->dhd, pkt, false);
 			pkt_buf_free_skb(pkt);
 			DHD_ERROR(("%s: out of bus->txq !!!\n", __func__));
-			ret = BCME_NORESOURCE;
+			ret = -BCME_NORESOURCE;
 		} else {
 			ret = 0;
 		}
@@ -1347,7 +1347,7 @@ int dhd_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 						SDIO_FUNC_2, F2SYNC, frame, len,
 						NULL, NULL, NULL);
 
-			ASSERT(ret != BCME_PENDING);
+			ASSERT(ret != -BCME_PENDING);
 
 			if (ret < 0) {
 				/* On failure, abort the command and
@@ -1690,7 +1690,7 @@ static int dhdsdio_pktgen_set(dhd_bus_t *bus, u8 *arg)
 
 	memcpy(&pktgen, arg, sizeof(pktgen));
 	if (pktgen.version != DHD_PKTGEN_VERSION)
-		return BCME_BADARG;
+		return -BCME_BADARG;
 
 	oldcnt = bus->pktgen_count;
 	oldmode = bus->pktgen_mode;
@@ -1799,7 +1799,7 @@ static int dhdsdio_readshared(dhd_bus_t *bus, sdpcm_shared_t *sh)
 	if (addr == 0 || ((~addr >> 16) & 0xffff) == (addr & 0xffff)) {
 		DHD_ERROR(("%s: address (0x%08x) of sdpcm_shared invalid\n",
 			   __func__, addr));
-		return BCME_ERROR;
+		return -BCME_ERROR;
 	}
 
 	/* Read hndrte_shared structure */
@@ -1822,7 +1822,7 @@ static int dhdsdio_readshared(dhd_bus_t *bus, sdpcm_shared_t *sh)
 			   "is different than sdpcm_shared version %d in dongle\n",
 			   __func__, SDPCM_SHARED_VERSION,
 			   sh->flags & SDPCM_SHARED_VERSION_MASK));
-		return BCME_ERROR;
+		return -BCME_ERROR;
 	}
 
 	return 0;
@@ -1851,7 +1851,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 		if (mbuffer == NULL) {
 			DHD_ERROR(("%s: kmalloc(%d) failed\n", __func__,
 				   msize));
-			bcmerror = BCME_NOMEM;
+			bcmerror = -BCME_NOMEM;
 			goto done;
 		}
 	}
@@ -1859,7 +1859,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 	str = kmalloc(maxstrlen, GFP_ATOMIC);
 	if (str == NULL) {
 		DHD_ERROR(("%s: kmalloc(%d) failed\n", __func__, maxstrlen));
-		bcmerror = BCME_NOMEM;
+		bcmerror = -BCME_NOMEM;
 		goto done;
 	}
 
@@ -2028,14 +2028,14 @@ static int dhdsdio_readconsole(dhd_bus_t *bus)
 		c->bufsize = le32_to_cpu(c->log.buf_size);
 		c->buf = kmalloc(c->bufsize, GFP_ATOMIC);
 		if (c->buf == NULL)
-			return BCME_NOMEM;
+			return -BCME_NOMEM;
 	}
 
 	idx = le32_to_cpu(c->log.idx);
 
 	/* Protect against corrupt value */
 	if (idx > c->bufsize)
-		return BCME_ERROR;
+		return -BCME_ERROR;
 
 	/* Skip reading the console buffer if the index pointer
 	 has not moved */
@@ -2090,11 +2090,11 @@ int dhdsdio_downloadvars(dhd_bus_t *bus, void *arg, int len)
 
 	/* Basic sanity checks */
 	if (bus->dhd->up) {
-		bcmerror = BCME_NOTDOWN;
+		bcmerror = -BCME_NOTDOWN;
 		goto err;
 	}
 	if (!len) {
-		bcmerror = BCME_BUFTOOSHORT;
+		bcmerror = -BCME_BUFTOOSHORT;
 		goto err;
 	}
 
@@ -2104,7 +2104,7 @@ int dhdsdio_downloadvars(dhd_bus_t *bus, void *arg, int len)
 	bus->vars = kmalloc(len, GFP_ATOMIC);
 	bus->varsz = bus->vars ? len : 0;
 	if (bus->vars == NULL) {
-		bcmerror = BCME_NOMEM;
+		bcmerror = -BCME_NOMEM;
 		goto err;
 	}
 
@@ -2143,7 +2143,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 	/* Check if dongle is in reset. If so, only allow DEVRESET iovars */
 	if (bus->dhd->dongle_reset && !(actionid == IOV_SVAL(IOV_DEVRESET) ||
 					actionid == IOV_GVAL(IOV_DEVRESET))) {
-		bcmerror = BCME_NOTREADY;
+		bcmerror = -BCME_NOTREADY;
 		goto exit;
 	}
 
@@ -2203,7 +2203,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_IDLETIME):
 		if ((int_val < 0) && (int_val != DHD_IDLE_IMMEDIATE))
-			bcmerror = BCME_BADARG;
+			bcmerror = -BCME_BADARG;
 		else
 			bus->idletime = int_val;
 		break;
@@ -2249,7 +2249,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 				"0x%08x size %d dsize %d\n",
 				__func__, (set ? "set" : "get"),
 				address, size, dsize));
-				bcmerror = BCME_BADARG;
+				bcmerror = -BCME_BADARG;
 				break;
 			}
 
@@ -2264,7 +2264,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 				DHD_ERROR(("%s: ramsize 0x%08x doesn't have %d "
 				"bytes at 0x%08x\n",
 				__func__, bus->orig_ramsize, size, address));
-				bcmerror = BCME_BADARG;
+				bcmerror = -BCME_BADARG;
 				break;
 			}
 
@@ -2322,7 +2322,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_SDRXCHAIN):
 		if (bool_val && !bus->sd_rxchain)
-			bcmerror = BCME_UNSUPPORTED;
+			bcmerror = -BCME_UNSUPPORTED;
 		else
 			bus->use_rxchain = bool_val;
 		break;
@@ -2345,7 +2345,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 		if (bus->varsz < (uint) len)
 			memcpy(arg, bus->vars, bus->varsz);
 		else
-			bcmerror = BCME_BUFTOOSHORT;
+			bcmerror = -BCME_BUFTOOSHORT;
 		break;
 #endif				/* DHD_DEBUG */
 
@@ -2361,7 +2361,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			size = sd_ptr->func;
 			int_val = (s32) bcmsdh_reg_read(bus->sdh, addr, size);
 			if (bcmsdh_regfail(bus->sdh))
-				bcmerror = BCME_SDIO_ERROR;
+				bcmerror = -BCME_SDIO_ERROR;
 			memcpy(arg, &int_val, sizeof(s32));
 			break;
 		}
@@ -2377,7 +2377,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			size = sd_ptr->func;
 			bcmsdh_reg_write(bus->sdh, addr, size, sd_ptr->value);
 			if (bcmsdh_regfail(bus->sdh))
-				bcmerror = BCME_SDIO_ERROR;
+				bcmerror = -BCME_SDIO_ERROR;
 			break;
 		}
 
@@ -2394,7 +2394,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			size = sdreg.func;
 			int_val = (s32) bcmsdh_reg_read(bus->sdh, addr, size);
 			if (bcmsdh_regfail(bus->sdh))
-				bcmerror = BCME_SDIO_ERROR;
+				bcmerror = -BCME_SDIO_ERROR;
 			memcpy(arg, &int_val, sizeof(s32));
 			break;
 		}
@@ -2410,7 +2410,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 			size = sdreg.func;
 			bcmsdh_reg_write(bus->sdh, addr, size, sdreg.value);
 			if (bcmsdh_regfail(bus->sdh))
-				bcmerror = BCME_SDIO_ERROR;
+				bcmerror = -BCME_SDIO_ERROR;
 			break;
 		}
 
@@ -2509,7 +2509,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 		break;
 
 	default:
-		bcmerror = BCME_UNSUPPORTED;
+		bcmerror = -BCME_UNSUPPORTED;
 		break;
 	}
 
@@ -2546,7 +2546,7 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 	if (bus->vars) {
 		vbuffer = kzalloc(varsize, GFP_ATOMIC);
 		if (!vbuffer)
-			return BCME_NOMEM;
+			return -BCME_NOMEM;
 
 		memcpy(vbuffer, bus->vars, bus->varsz);
 
@@ -2558,7 +2558,7 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 		DHD_INFO(("Compare NVRAM dl & ul; varsize=%d\n", varsize));
 		nvram_ularray = kmalloc(varsize, GFP_ATOMIC);
 		if (!nvram_ularray)
-			return BCME_NOMEM;
+			return -BCME_NOMEM;
 
 		/* Upload image to verify downloaded contents. */
 		memset(nvram_ularray, 0xaa, varsize);
@@ -2644,7 +2644,7 @@ static int dhdsdio_download_state(dhd_bus_t *bus, bool enter)
 		if ((SICF_CLOCK_EN << SBTML_SICF_SHIFT) != regdata) {
 			DHD_ERROR(("%s: SOCRAM core is down after reset?\n",
 				   __func__));
-			bcmerror = BCME_ERROR;
+			bcmerror = -BCME_ERROR;
 			goto fail;
 		}
 
@@ -3105,7 +3105,7 @@ dhdsdio_read_control(dhd_bus_t *bus, u8 *hdr, uint len, uint doff)
 				(bus->rxctl + firstread), rdlen, NULL, NULL,
 				NULL);
 	bus->f2rxdata++;
-	ASSERT(sdret != BCME_PENDING);
+	ASSERT(sdret != -BCME_PENDING);
 
 	/* Control frame failures need retransmission */
 	if (sdret < 0) {
@@ -3291,7 +3291,7 @@ static u8 dhdsdio_rxglom(dhd_bus_t *bus, u8 rxseq)
 			errcode = -1;
 		}
 		bus->f2rxdata++;
-		ASSERT(errcode != BCME_PENDING);
+		ASSERT(errcode != -BCME_PENDING);
 
 		/* On failure, kill the superframe, allow a couple retries */
 		if (errcode < 0) {
@@ -3659,7 +3659,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 						    rdlen, NULL,
 						    NULL, NULL);
 					bus->f2rxdata++;
-					ASSERT(sdret != BCME_PENDING);
+					ASSERT(sdret != -BCME_PENDING);
 
 					/* Control frame failures need
 					 retransmission */
@@ -3701,7 +3701,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 						rxbuf, rdlen, pkt, NULL,
 						NULL);
 				bus->f2rxdata++;
-				ASSERT(sdret != BCME_PENDING);
+				ASSERT(sdret != -BCME_PENDING);
 
 				if (sdret < 0) {
 					DHD_ERROR(("%s (nextlen): read %d bytes failed: %d\n",
@@ -3902,7 +3902,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					F2SYNC, bus->rxhdr, firstread, NULL,
 					NULL, NULL);
 		bus->f2rxhdrs++;
-		ASSERT(sdret != BCME_PENDING);
+		ASSERT(sdret != -BCME_PENDING);
 
 		if (sdret < 0) {
 			DHD_ERROR(("%s: RXHEADER FAILED: %d\n", __func__,
@@ -4068,7 +4068,7 @@ static uint dhdsdio_readframes(dhd_bus_t *bus, uint maxframes, bool *finished)
 					F2SYNC, ((u8 *) (pkt->data)), rdlen,
 					pkt, NULL, NULL);
 		bus->f2rxdata++;
-		ASSERT(sdret != BCME_PENDING);
+		ASSERT(sdret != -BCME_PENDING);
 
 		if (sdret < 0) {
 			DHD_ERROR(("%s: read %d %s bytes failed: %d\n",
@@ -4420,7 +4420,7 @@ clkwait:
 					F2SYNC, (u8 *) bus->ctrl_frame_buf,
 					(u32) bus->ctrl_frame_len, NULL,
 					NULL, NULL);
-		ASSERT(ret != BCME_PENDING);
+		ASSERT(ret != -BCME_PENDING);
 
 		if (ret < 0) {
 			/* On failure, abort the command and
@@ -4918,7 +4918,7 @@ extern int dhd_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg, uint msglen)
 
 	/* Address could be zero if CONSOLE := 0 in dongle Makefile */
 	if (bus->console_addr == 0)
-		return BCME_UNSUPPORTED;
+		return -BCME_UNSUPPORTED;
 
 	/* Exclusive bus access */
 	dhd_os_sdlock(bus->dhd);
@@ -4926,7 +4926,7 @@ extern int dhd_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg, uint msglen)
 	/* Don't allow input if dongle is in reset */
 	if (bus->dhd->dongle_reset) {
 		dhd_os_sdunlock(bus->dhd);
-		return BCME_NOTREADY;
+		return -BCME_NOTREADY;
 	}
 
 	/* Request clock to allow SDIO accesses */
@@ -5145,7 +5145,7 @@ static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
 	/* if firmware path present try to download and bring up bus */
 	ret = dhd_bus_start(bus->dhd);
 	if (ret != 0) {
-		if (ret == BCME_NOTUP) {
+		if (ret == -BCME_NOTUP) {
 			DHD_ERROR(("%s: dongle is not responding\n", __func__));
 			goto fail;
 		}
@@ -5588,7 +5588,7 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 
 		ularray = kmalloc(bus->ramsize, GFP_ATOMIC);
 		if (!ularray) {
-			bcmerror = BCME_NOMEM;
+			bcmerror = -BCME_NOMEM;
 			goto err;
 		}
 		/* Upload image to verify downloaded contents. */
@@ -5811,7 +5811,7 @@ static int dhdsdio_download_nvram(struct dhd_bus *bus)
 	} else {
 		DHD_ERROR(("%s: error reading nvram file: %d\n",
 			   __func__, len));
-		bcmerror = BCME_SDIO_ERROR;
+		bcmerror = -BCME_SDIO_ERROR;
 	}
 
 err:
@@ -5969,7 +5969,7 @@ int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 			DHD_TRACE(("%s:  WLAN OFF DONE\n", __func__));
 			/* App can now remove power from device */
 		} else
-			bcmerror = BCME_SDIO_ERROR;
+			bcmerror = -BCME_SDIO_ERROR;
 	} else {
 		/* App must have restored power to device before calling */
 
@@ -6004,14 +6004,14 @@ int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 					DHD_TRACE(("%s: WLAN ON DONE\n",
 						   __func__));
 				} else
-					bcmerror = BCME_SDIO_ERROR;
+					bcmerror = -BCME_SDIO_ERROR;
 			} else
-				bcmerror = BCME_SDIO_ERROR;
+				bcmerror = -BCME_SDIO_ERROR;
 		} else {
-			bcmerror = BCME_NOTDOWN;
+			bcmerror = -BCME_NOTDOWN;
 			DHD_ERROR(("%s: Set DEVRESET=false invoked when device "
 				"is on\n", __func__));
-			bcmerror = BCME_SDIO_ERROR;
+			bcmerror = -BCME_SDIO_ERROR;
 		}
 	}
 	return bcmerror;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
index ccc79fd..afa4fca 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_n.c
@@ -22366,7 +22366,7 @@ wlc_phy_tx_tone_nphy(phy_info_t *pi, u32 f_kHz, u16 max_val,
 	num_samps =
 		wlc_phy_gen_load_samples_nphy(pi, f_kHz, max_val, dac_test_mode);
 	if (num_samps == 0) {
-		return BCME_ERROR;
+		return -BCME_ERROR;
 	}
 
 	wlc_phy_runsamples_nphy(pi, num_samps, loops, wait, iqmode,
@@ -24559,7 +24559,7 @@ static void wlc_phy_calc_rx_iq_comp_nphy(phy_info_t *pi, u8 core_mask)
 		}
 
 		if ((ii + qq) < NPHY_MIN_RXIQ_PWR) {
-			bcmerror = BCME_ERROR;
+			bcmerror = -BCME_ERROR;
 			break;
 		}
 
@@ -24571,14 +24571,14 @@ static void wlc_phy_calc_rx_iq_comp_nphy(phy_info_t *pi, u8 core_mask)
 			a = (-(iq << (30 - iq_nbits)) + (ii >> (1 + arsh)));
 			temp = (s32) (ii >> arsh);
 			if (temp == 0) {
-				bcmerror = BCME_ERROR;
+				bcmerror = -BCME_ERROR;
 				break;
 			}
 		} else {
 			a = (-(iq << (30 - iq_nbits)) + (ii << (-1 - arsh)));
 			temp = (s32) (ii << -arsh);
 			if (temp == 0) {
-				bcmerror = BCME_ERROR;
+				bcmerror = -BCME_ERROR;
 				break;
 			}
 		}
@@ -24590,14 +24590,14 @@ static void wlc_phy_calc_rx_iq_comp_nphy(phy_info_t *pi, u8 core_mask)
 			b = (qq << (31 - qq_nbits));
 			temp = (s32) (ii >> brsh);
 			if (temp == 0) {
-				bcmerror = BCME_ERROR;
+				bcmerror = -BCME_ERROR;
 				break;
 			}
 		} else {
 			b = (qq << (31 - qq_nbits));
 			temp = (s32) (ii << -brsh);
 			if (temp == 0) {
-				bcmerror = BCME_ERROR;
+				bcmerror = -BCME_ERROR;
 				break;
 			}
 		}
diff --git a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
index 61da97f..e16b0c9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
+++ b/drivers/staging/brcm80211/brcmsmac/wl_mac80211.c
@@ -1793,7 +1793,7 @@ int wl_ucode_init_buf(struct wl_info *wl, void **pbuf, u32 idx)
 	WL_ERROR("ERROR: ucode buf tag:%d can not be found!\n", idx);
 	*pbuf = NULL;
 fail:
-	return BCME_NOTFOUND;
+	return -BCME_NOTFOUND;
 }
 
 /*
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index 07fbc3d..e3e9e8c 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -538,14 +538,14 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 	/* Let pressure continue to build ... */
 	qlen = pktq_plen(&qi->q, prec);
 	if (ini->tx_in_transit > 0 && qlen < scb_ampdu->max_pdu) {
-		return BCME_BUSY;
+		return -BCME_BUSY;
 	}
 
 	wlc_ampdu_agg(ampdu, scb, p, tid);
 
 	if (wlc->block_datafifo) {
 		WL_ERROR("%s: Fifo blocked\n", __func__);
-		return BCME_BUSY;
+		return -BCME_BUSY;
 	}
 	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
 	ampdu_len = 0;
@@ -566,7 +566,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		}
 
 		if (err) {
-			if (err == BCME_BUSY) {
+			if (err == -BCME_BUSY) {
 				WL_ERROR("wl%d: wlc_sendampdu: prep_xdu retry; seq 0x%x\n",
 					 wlc->pub->unit, seq);
 				WLCNTINCR(ampdu->cnt->sduretry);
@@ -1245,12 +1245,12 @@ static int wlc_ampdu_set(struct ampdu_info *ampdu, bool on)
 		if (!N_ENAB(wlc->pub)) {
 			WL_AMPDU_ERR("wl%d: driver not nmode enabled\n",
 				     wlc->pub->unit);
-			return BCME_UNSUPPORTED;
+			return -BCME_UNSUPPORTED;
 		}
 		if (!wlc_ampdu_cap(ampdu)) {
 			WL_AMPDU_ERR("wl%d: device not ampdu capable\n",
 				     wlc->pub->unit);
-			return BCME_UNSUPPORTED;
+			return -BCME_UNSUPPORTED;
 		}
 		wlc->pub->_ampdu = on;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index f52b339..bd8a629 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -1143,7 +1143,7 @@ int wlc_bmac_up_prep(struct wlc_hw_info *wlc_hw)
 		if (wlc_hw->sih->bustype == PCI_BUS)
 			si_pci_down(wlc_hw->sih);
 		wlc_bmac_xtal(wlc_hw, OFF);
-		return BCME_RADIOOFF;
+		return -BCME_RADIOOFF;
 	}
 
 	if (wlc_hw->sih->bustype == PCI_BUS)
@@ -2848,7 +2848,7 @@ static void wlc_bmac_mute(struct wlc_hw_info *wlc_hw, bool on, mbool flags)
 int wlc_bmac_xmtfifo_sz_get(struct wlc_hw_info *wlc_hw, uint fifo, uint *blocks)
 {
 	if (fifo >= NFIFO)
-		return BCME_RANGE;
+		return -BCME_RANGE;
 
 	*blocks = wlc_hw->xmtfifo_sz[fifo];
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index 96161c0..5a4e2bb 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -729,7 +729,7 @@ wlc_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
 	}
 
 	if (country == NULL)
-		return BCME_BADARG;
+		return -BCME_BADARG;
 
 	/* set the driver state for the country */
 	wlc_set_country_common(wlc_cm, country_abbrev, mapped_ccode,
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_key.h b/drivers/staging/brcm80211/brcmsmac/wlc_key.h
index 50a4e38..4615173 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_key.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_key.h
@@ -115,7 +115,7 @@ typedef struct wsec_key {
 #define WSEC_IBSS_PEER_GROUP_KEY	(1 << 7)	/* Flag: group key for a IBSS PEER */
 #define WSEC_ICV_ERROR		(1 << 8)	/* Provoke deliberate ICV error */
 
-#define wlc_key_insert(a, b, c, d, e, f, g, h, i, j) (BCME_ERROR)
+#define wlc_key_insert(a, b, c, d, e, f, g, h, i, j) (-BCME_ERROR)
 #define wlc_key_update(a, b, c) do {} while (0)
 #define wlc_key_remove(a, b, c) do {} while (0)
 #define wlc_key_remove_all(a, b) do {} while (0)
@@ -126,12 +126,12 @@ typedef struct wsec_key {
 #define wlc_key_hw_init(a, b, c)  do {} while (0)
 #define wlc_key_hw_wowl_init(a, b, c, d) do {} while (0)
 #define wlc_key_sw_wowl_update(a, b, c, d, e) do {} while (0)
-#define wlc_key_sw_wowl_create(a, b, c) (BCME_ERROR)
+#define wlc_key_sw_wowl_create(a, b, c) (-BCME_ERROR)
 #define wlc_key_iv_update(a, b, c, d, e) do {(void)e; } while (0)
 #define wlc_key_iv_init(a, b, c) do {} while (0)
-#define wlc_key_set_error(a, b, c) (BCME_ERROR)
-#define wlc_key_dump_hw(a, b) (BCME_ERROR)
-#define wlc_key_dump_sw(a, b) (BCME_ERROR)
+#define wlc_key_set_error(a, b, c) (-BCME_ERROR)
+#define wlc_key_dump_hw(a, b) (-BCME_ERROR)
+#define wlc_key_dump_sw(a, b) (-BCME_ERROR)
 #define wlc_key_defkeyflag(a) (0)
 #define wlc_rcmta_add_bssid(a, b) do {} while (0)
 #define wlc_rcmta_del_bssid(a, b) do {} while (0)
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index fce9378..ffc241f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -888,7 +888,7 @@ static int wlc_get_current_txpwr(struct wlc_info *wlc, void *pwr, uint len)
 	if (len == sizeof(tx_power_legacy_t))
 		old_power = (tx_power_legacy_t *) pwr;
 	else if (len < sizeof(tx_power_t))
-		return BCME_BUFTOOSHORT;
+		return -BCME_BUFTOOSHORT;
 
 	memset(&power, 0, sizeof(tx_power_t));
 
@@ -2452,7 +2452,7 @@ int wlc_up(struct wlc_info *wlc)
 
 	/* HW is turned off so don't try to access it */
 	if (wlc->pub->hw_off || DEVICEREMOVED(wlc))
-		return BCME_RADIOOFF;
+		return -BCME_RADIOOFF;
 
 	if (!wlc->pub->hw_up) {
 		wlc_bmac_hw_up(wlc->hw);
@@ -2477,11 +2477,11 @@ int wlc_up(struct wlc_info *wlc)
 	 * if radio is disabled, abort up, lower power, start radio timer and return 0(for NDIS)
 	 * don't call radio_update to avoid looping wlc_up.
 	 *
-	 * wlc_bmac_up_prep() returns either 0 or BCME_RADIOOFF only
+	 * wlc_bmac_up_prep() returns either 0 or -BCME_RADIOOFF only
 	 */
 	if (!wlc->pub->radio_disabled) {
 		int status = wlc_bmac_up_prep(wlc->hw);
-		if (status == BCME_RADIOOFF) {
+		if (status == -BCME_RADIOOFF) {
 			if (!mboolisset
 			    (wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE)) {
 				int idx;
@@ -2682,7 +2682,7 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 	 * Gmode is not GMODE_LEGACY_B
 	 */
 	if (N_ENAB(wlc->pub) && gmode == GMODE_LEGACY_B)
-		return BCME_UNSUPPORTED;
+		return -BCME_UNSUPPORTED;
 
 	/* verify that we are dealing with 2G band and grab the band pointer */
 	if (wlc->band->bandtype == WLC_BAND_2G)
@@ -2691,12 +2691,12 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 		 (wlc->bandstate[OTHERBANDUNIT(wlc)]->bandtype == WLC_BAND_2G))
 		band = wlc->bandstate[OTHERBANDUNIT(wlc)];
 	else
-		return BCME_BADBAND;
+		return -BCME_BADBAND;
 
 	/* Legacy or bust when no OFDM is supported by regulatory */
 	if ((wlc_channel_locale_flags_in_band(wlc->cmi, band->bandunit) &
 	     WLC_NO_OFDM) && (gmode != GMODE_LEGACY_B))
-		return BCME_RANGE;
+		return -BCME_RANGE;
 
 	/* update configuration value */
 	if (config == true)
@@ -2746,7 +2746,7 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 		/* Error */
 		WL_ERROR("wl%d: %s: invalid gmode %d\n",
 			 wlc->pub->unit, __func__, gmode);
-		return BCME_UNSUPPORTED;
+		return -BCME_UNSUPPORTED;
 	}
 
 	/*
@@ -2825,11 +2825,11 @@ static int wlc_nmode_validate(struct wlc_info *wlc, s32 nmode)
 	case WL_11N_2x2:
 	case WL_11N_3x3:
 		if (!(WLC_PHY_11N_CAP(wlc->band)))
-			err = BCME_BADBAND;
+			err = -BCME_BADBAND;
 		break;
 
 	default:
-		err = BCME_RANGE;
+		err = -BCME_RANGE;
 		break;
 	}
 
@@ -2904,7 +2904,7 @@ static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg)
 
 	/* check for bad count value */
 	if ((rs.count == 0) || (rs.count > WLC_NUMRATES))
-		return BCME_BADRATESET;
+		return -BCME_BADRATESET;
 
 	/* try the current band */
 	bandunit = wlc->band->bandunit;
@@ -2926,7 +2926,7 @@ static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg)
 			goto good;
 	}
 
-	return BCME_ERROR;
+	return -BCME_ERROR;
 
  good:
 	/* apply new rateset */
@@ -3001,7 +3001,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	if (!wlc->pub->hw_off && DEVICEREMOVED(wlc)) {
 		WL_ERROR("wl%d: %s: dead chip\n", wlc->pub->unit, __func__);
 		wl_down(wlc->wl);
-		return BCME_ERROR;
+		return -BCME_ERROR;
 	}
 
 	ASSERT(!(wlc->pub->hw_off && wlc->pub->up));
@@ -3041,7 +3041,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		if ((arg == NULL) || (len <= 0)) {
 			WL_ERROR("wl%d: %s: Command %d needs arguments\n",
 				 wlc->pub->unit, __func__, cmd);
-			bcmerror = BCME_BADARG;
+			bcmerror = -BCME_BADARG;
 			goto done;
 		}
 	}
@@ -3080,12 +3080,12 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			chanspec_t chspec = CH20MHZ_CHSPEC(val);
 
 			if (val < 0 || val > MAXCHANNEL) {
-				bcmerror = BCME_OUTOFRANGECHAN;
+				bcmerror = -BCME_OUTOFRANGECHAN;
 				break;
 			}
 
 			if (!wlc_valid_chanspec_db(wlc->cmi, chspec)) {
-				bcmerror = BCME_BADCHAN;
+				bcmerror = -BCME_BADCHAN;
 				break;
 			}
 
@@ -3112,7 +3112,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 #if defined(BCMDBG)
 	case WLC_GET_UCFLAGS:
 		if (!wlc->pub->up) {
-			bcmerror = BCME_NOTUP;
+			bcmerror = -BCME_NOTUP;
 			break;
 		}
 
@@ -3127,7 +3127,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 
 		if (val >= MHFMAX) {
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 			break;
 		}
 
@@ -3136,7 +3136,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	case WLC_SET_UCFLAGS:
 		if (!wlc->pub->up) {
-			bcmerror = BCME_NOTUP;
+			bcmerror = -BCME_NOTUP;
 			break;
 		}
 
@@ -3152,7 +3152,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 		i = (u16) val;
 		if (i >= MHFMAX) {
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 			break;
 		}
 
@@ -3174,7 +3174,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 
 		if (val & 1) {
-			bcmerror = BCME_BADADDR;
+			bcmerror = -BCME_BADADDR;
 			break;
 		}
 
@@ -3195,7 +3195,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 
 		if (val & 1) {
-			bcmerror = BCME_BADADDR;
+			bcmerror = -BCME_BADADDR;
 			break;
 		}
 
@@ -3209,7 +3209,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		band = WLC_BAND_AUTO;
 
 		if (len < (int)(sizeof(rw_reg_t) - sizeof(uint))) {
-			bcmerror = BCME_BUFTOOSHORT;
+			bcmerror = -BCME_BUFTOOSHORT;
 			break;
 		}
 
@@ -3222,7 +3222,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 
 		if ((r->byteoff + r->size) > sizeof(d11regs_t)) {
-			bcmerror = BCME_BADADDR;
+			bcmerror = -BCME_BADADDR;
 			break;
 		}
 		if (r->size == sizeof(u32))
@@ -3234,7 +3234,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			    R_REG((u16 *)((unsigned char *)(unsigned long)regs +
 					      r->byteoff));
 		else
-			bcmerror = BCME_BADADDR;
+			bcmerror = -BCME_BADADDR;
 		break;
 
 	case WLC_W_REG:
@@ -3243,7 +3243,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		band = WLC_BAND_AUTO;
 
 		if (len < (int)(sizeof(rw_reg_t) - sizeof(uint))) {
-			bcmerror = BCME_BUFTOOSHORT;
+			bcmerror = -BCME_BUFTOOSHORT;
 			break;
 		}
 
@@ -3256,7 +3256,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 
 		if (r->byteoff + r->size > sizeof(d11regs_t)) {
-			bcmerror = BCME_BADADDR;
+			bcmerror = -BCME_BADADDR;
 			break;
 		}
 		if (r->size == sizeof(u32))
@@ -3266,7 +3266,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			W_REG((u16 *)((unsigned char *)(unsigned long) regs +
 					  r->byteoff), r->val);
 		else
-			bcmerror = BCME_BADADDR;
+			bcmerror = -BCME_BADADDR;
 		break;
 #endif				/* BCMDBG */
 
@@ -3314,7 +3314,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	case WLC_SET_ANTDIV:
 		/* values are -1=driver default, 0=force0, 1=force1, 2=start1, 3=start0 */
 		if ((val < -1) || (val > 3)) {
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 			break;
 		}
 
@@ -3329,13 +3329,13 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			u16 rxstatus;
 
 			if (!wlc->pub->up) {
-				bcmerror = BCME_NOTUP;
+				bcmerror = -BCME_NOTUP;
 				break;
 			}
 
 			rxstatus = R_REG(&wlc->regs->phyrxstatus0);
 			if (rxstatus == 0xdead || rxstatus == (u16) -1) {
-				bcmerror = BCME_ERROR;
+				bcmerror = -BCME_ERROR;
 				break;
 			}
 			*pval = (rxstatus & PRXS0_RXANT_UPSUBBAND) ? 1 : 0;
@@ -3345,7 +3345,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 #if defined(BCMDBG)
 	case WLC_GET_UCANTDIV:
 		if (!wlc->clk) {
-			bcmerror = BCME_NOCLK;
+			bcmerror = -BCME_NOCLK;
 			break;
 		}
 
@@ -3356,13 +3356,13 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	case WLC_SET_UCANTDIV:{
 			if (!wlc->pub->up) {
-				bcmerror = BCME_NOTUP;
+				bcmerror = -BCME_NOTUP;
 				break;
 			}
 
 			/* if multiband, band must be locked */
 			if (IS_MBAND_UNLOCKED(wlc)) {
-				bcmerror = BCME_NOTBANDLOCKED;
+				bcmerror = -BCME_NOTBANDLOCKED;
 				break;
 			}
 
@@ -3388,7 +3388,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			}
 			wlc_wme_retries_write(wlc);
 		} else
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 		break;
 
 	case WLC_GET_LRL:
@@ -3407,7 +3407,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			}
 			wlc_wme_retries_write(wlc);
 		} else
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 		break;
 
 	case WLC_GET_CWMIN:
@@ -3416,14 +3416,14 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	case WLC_SET_CWMIN:
 		if (!wlc->clk) {
-			bcmerror = BCME_NOCLK;
+			bcmerror = -BCME_NOCLK;
 			break;
 		}
 
 		if (val >= 1 && val <= 255) {
 			wlc_set_cwmin(wlc, (u16) val);
 		} else
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 		break;
 
 	case WLC_GET_CWMAX:
@@ -3432,14 +3432,14 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	case WLC_SET_CWMAX:
 		if (!wlc->clk) {
-			bcmerror = BCME_NOCLK;
+			bcmerror = -BCME_NOCLK;
 			break;
 		}
 
 		if (val >= 255 && val <= 2047) {
 			wlc_set_cwmax(wlc, (u16) val);
 		} else
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 		break;
 
 	case WLC_GET_RADIO:	/* use mask if don't want to expose some internal bits */
@@ -3462,7 +3462,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			    || ((radioval & ~radiomask) != 0)) {
 				WL_ERROR("SET_RADIO with wrong bits 0x%x\n",
 					 val);
-				bcmerror = BCME_RANGE;
+				bcmerror = -BCME_RANGE;
 				break;
 			}
 
@@ -3487,7 +3487,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			wsec_key_t *src_key = wlc->wsec_keys[val];
 
 			if (len < (int)sizeof(key)) {
-				bcmerror = BCME_BUFTOOSHORT;
+				bcmerror = -BCME_BUFTOOSHORT;
 				break;
 			}
 
@@ -3507,7 +3507,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 			memcpy(arg, &key, sizeof(key));
 		} else
-			bcmerror = BCME_BADKEYIDX;
+			bcmerror = -BCME_BADKEYIDX;
 		break;
 #endif				/* defined(BCMDBG) */
 
@@ -3521,7 +3521,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			wsec_key_t *key;
 
 			if (len < DOT11_WPA_KEY_RSC_LEN) {
-				bcmerror = BCME_BUFTOOSHORT;
+				bcmerror = -BCME_BUFTOOSHORT;
 				break;
 			}
 
@@ -3558,7 +3558,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 				memcpy(arg, seq, sizeof(seq));
 			} else {
-				bcmerror = BCME_BADKEYIDX;
+				bcmerror = -BCME_BADKEYIDX;
 			}
 			break;
 		}
@@ -3573,7 +3573,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				rs = &wlc->default_bss->rateset;
 
 			if (len < (int)(rs->count + sizeof(rs->count))) {
-				bcmerror = BCME_BUFTOOSHORT;
+				bcmerror = -BCME_BUFTOOSHORT;
 				break;
 			}
 
@@ -3591,7 +3591,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			wlc_default_rateset(wlc, (wlc_rateset_t *) &rs);
 
 			if (len < (int)(rs.count + sizeof(rs.count))) {
-				bcmerror = BCME_BUFTOOSHORT;
+				bcmerror = -BCME_BUFTOOSHORT;
 				break;
 			}
 
@@ -3606,12 +3606,12 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			wl_rateset_t *in_rs = (wl_rateset_t *) arg;
 
 			if (len < (int)(in_rs->count + sizeof(in_rs->count))) {
-				bcmerror = BCME_BUFTOOSHORT;
+				bcmerror = -BCME_BUFTOOSHORT;
 				break;
 			}
 
 			if (in_rs->count > WLC_NUMRATES) {
-				bcmerror = BCME_BUFTOOLONG;
+				bcmerror = -BCME_BUFTOOLONG;
 				break;
 			}
 
@@ -3654,7 +3654,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		    && val <= DOT11_MAX_BEACON_PERIOD) {
 			wlc->default_bss->beacon_period = (u16) val;
 		} else
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 		break;
 
 	case WLC_GET_DTIMPRD:
@@ -3670,7 +3670,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		    && val <= DOT11_MAX_DTIM_PERIOD) {
 			wlc->default_bss->dtim_period = (u8) val;
 		} else
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 		break;
 
 #ifdef SUPPORT_PS
@@ -3686,7 +3686,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			/* Change watchdog driver to align watchdog with tbtt if possible */
 			wlc_watchdog_upd(wlc, PS_ALLOWED(wlc));
 		} else
-			bcmerror = BCME_ERROR;
+			bcmerror = -BCME_ERROR;
 		break;
 #endif				/* SUPPORT_PS */
 
@@ -3694,7 +3694,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 #ifdef BCMDBG
 	case WLC_GET_WAKE:
 		if (AP_ENAB(wlc->pub)) {
-			bcmerror = BCME_NOTSTA;
+			bcmerror = -BCME_NOTSTA;
 			break;
 		}
 		*pval = wlc->wake;
@@ -3702,7 +3702,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	case WLC_SET_WAKE:
 		if (AP_ENAB(wlc->pub)) {
-			bcmerror = BCME_NOTSTA;
+			bcmerror = -BCME_NOTSTA;
 			break;
 		}
 
@@ -3797,7 +3797,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		{
 			unsigned char *cp = arg;
 			if (len < 3) {
-				bcmerror = BCME_BUFTOOSHORT;
+				bcmerror = -BCME_BUFTOOSHORT;
 				break;
 			}
 
@@ -3823,7 +3823,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	case WLC_SET_SHORTSLOT_OVERRIDE:
 		if ((val != WLC_SHORTSLOT_AUTO) &&
 		    (val != WLC_SHORTSLOT_OFF) && (val != WLC_SHORTSLOT_ON)) {
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 			break;
 		}
 
@@ -3880,7 +3880,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		if (!wlc->pub->associated)
 			bcmerror = wlc_set_gmode(wlc, (u8) val, true);
 		else {
-			bcmerror = BCME_ASSOCIATED;
+			bcmerror = -BCME_ASSOCIATED;
 			break;
 		}
 		break;
@@ -3897,7 +3897,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		if ((val != WLC_PROTECTION_CTL_OFF) &&
 		    (val != WLC_PROTECTION_CTL_LOCAL) &&
 		    (val != WLC_PROTECTION_CTL_OVERLAP)) {
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 			break;
 		}
 
@@ -3916,7 +3916,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	case WLC_SET_GMODE_PROTECTION_OVERRIDE:
 		if ((val != WLC_PROTECTION_AUTO) &&
 		    (val != WLC_PROTECTION_OFF) && (val != WLC_PROTECTION_ON)) {
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 			break;
 		}
 
@@ -3929,14 +3929,14 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 			/* copyin */
 			if (len < (int)sizeof(wlc_rateset_t)) {
-				bcmerror = BCME_BUFTOOSHORT;
+				bcmerror = -BCME_BUFTOOSHORT;
 				break;
 			}
 			memcpy(&rs, arg, sizeof(wlc_rateset_t));
 
 			/* check for bad count value */
 			if (rs.count > WLC_NUMRATES) {
-				bcmerror = BCME_BADRATESET;	/* invalid rateset */
+				bcmerror = -BCME_BADRATESET;
 				break;
 			}
 
@@ -3944,7 +3944,8 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			if (!(wlc->band->gmode ||
 			      ((NBANDS(wlc) > 1)
 			       && wlc->bandstate[OTHERBANDUNIT(wlc)]->gmode))) {
-				bcmerror = BCME_BADBAND;	/* gmode only command when not in gmode */
+				/* gmode only command when not in gmode */
+				bcmerror = -BCME_BADBAND;
 				break;
 			}
 
@@ -3963,7 +3964,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 							   false,
 							   wlc->stf->txstreams);
 			if (rs.count != new.count) {
-				bcmerror = BCME_BADRATESET;	/* invalid rateset */
+				bcmerror = -BCME_BADRATESET;
 				break;
 			}
 
@@ -3985,11 +3986,12 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		if (!(wlc->band->gmode ||
 		      ((NBANDS(wlc) > 1)
 		       && wlc->bandstate[OTHERBANDUNIT(wlc)]->gmode))) {
-			bcmerror = BCME_BADBAND;	/* gmode only command when not in gmode */
+			/* gmode only command when not in gmode */
+			bcmerror = -BCME_BADBAND;
 			break;
 		}
 		if (len < (int)sizeof(wlc_rateset_t)) {
-			bcmerror = BCME_BUFTOOSHORT;
+			bcmerror = -BCME_BUFTOOSHORT;
 			break;
 		}
 		memcpy(arg, &wlc->sup_rates_override, sizeof(wlc_rateset_t));
@@ -4002,11 +4004,11 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	case WLC_SET_PRB_RESP_TIMEOUT:
 		if (wlc->pub->up) {
-			bcmerror = BCME_NOTDOWN;
+			bcmerror = -BCME_NOTDOWN;
 			break;
 		}
 		if (val < 0 || val >= 0xFFFF) {
-			bcmerror = BCME_RANGE;	/* bad value */
+			bcmerror = -BCME_RANGE;	/* bad value */
 			break;
 		}
 		wlc->prb_resp_timeout = (u16) val;
@@ -4020,7 +4022,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			if (key != NULL) {
 				*pval = key->id == val ? true : false;
 			} else {
-				bcmerror = BCME_BADKEYIDX;
+				bcmerror = -BCME_BADKEYIDX;
 			}
 			break;
 		}
@@ -4028,7 +4030,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	case WLC_SET_KEY_PRIMARY:{
 			wsec_key_t *key, *old_key;
 
-			bcmerror = BCME_BADKEYIDX;
+			bcmerror = -BCME_BADKEYIDX;
 
 			/* treat the 'val' parm as the key id */
 			for (i = 0; i < WSEC_MAX_DEFAULT_KEYS; i++) {
@@ -4062,7 +4064,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				;
 
 			if (i == (uint) len) {
-				bcmerror = BCME_BUFTOOSHORT;
+				bcmerror = -BCME_BUFTOOSHORT;
 				break;
 			}
 			i++;	/* include the null in the string length */
@@ -4083,13 +4085,13 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		}
 
 	case WLC_SET_WSEC_PMK:
-		bcmerror = BCME_UNSUPPORTED;
+		bcmerror = -BCME_UNSUPPORTED;
 		break;
 
 #if defined(BCMDBG)
 	case WLC_CURRENT_PWR:
 		if (!wlc->pub->up)
-			bcmerror = BCME_NOTUP;
+			bcmerror = -BCME_NOTUP;
 		else
 			bcmerror = wlc_get_current_txpwr(wlc, arg, len);
 		break;
@@ -4124,15 +4126,15 @@ int wlc_iocregchk(struct wlc_info *wlc, uint band)
 {
 	/* if band is specified, it must be the current band */
 	if ((band != WLC_BAND_AUTO) && (band != (uint) wlc->band->bandtype))
-		return BCME_BADBAND;
+		return -BCME_BADBAND;
 
 	/* if multiband and band is not specified, band must be locked */
 	if ((band == WLC_BAND_AUTO) && IS_MBAND_UNLOCKED(wlc))
-		return BCME_NOTBANDLOCKED;
+		return -BCME_NOTBANDLOCKED;
 
 	/* must have core clocks */
 	if (!wlc->clk)
-		return BCME_NOCLK;
+		return -BCME_NOCLK;
 
 	return 0;
 }
@@ -4143,7 +4145,7 @@ int wlc_iocregchk(struct wlc_info *wlc, uint band)
 int wlc_iocpichk(struct wlc_info *wlc, uint phytype)
 {
 	if (wlc->band->phytype != phytype)
-		return BCME_BADBAND;
+		return -BCME_BADBAND;
 	return 0;
 }
 #endif
@@ -4233,7 +4235,7 @@ int wlc_module_register(struct wlc_pub *pub, const bcm_iovar_t *iovars,
 
 	/* it is time to increase the capacity */
 	ASSERT(i < WLC_MAXMODULES);
-	return BCME_NORESOURCE;
+	return -BCME_NORESOURCE;
 }
 
 /* unregister module callbacks */
@@ -4243,7 +4245,7 @@ int wlc_module_unregister(struct wlc_pub *pub, const char *name, void *hdl)
 	int i;
 
 	if (wlc == NULL)
-		return BCME_NOTFOUND;
+		return -BCME_NOTFOUND;
 
 	ASSERT(name != NULL);
 
@@ -4256,7 +4258,7 @@ int wlc_module_unregister(struct wlc_pub *pub, const char *name, void *hdl)
 	}
 
 	/* table not found! */
-	return BCME_NOTFOUND;
+	return -BCME_NOTFOUND;
 }
 
 /* Write WME tunable parameters for retransmit/max rate from wlc struct to ucode */
@@ -4321,7 +4323,7 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 	}
 	/* iovar name not found */
 	if (i >= WLC_MAXMODULES) {
-		err = BCME_UNSUPPORTED;
+		err = -BCME_UNSUPPORTED;
 		goto exit;
 	}
 
@@ -4364,22 +4366,22 @@ wlc_iovar_check(struct wlc_pub *pub, const bcm_iovar_t *vi, void *arg, int len,
 	if (set) {
 		if (((vi->flags & IOVF_SET_DOWN) && wlc->pub->up) ||
 		    ((vi->flags & IOVF_SET_UP) && !wlc->pub->up)) {
-			err = (wlc->pub->up ? BCME_NOTDOWN : BCME_NOTUP);
+			err = (wlc->pub->up ? -BCME_NOTDOWN : -BCME_NOTUP);
 		} else if ((vi->flags & IOVF_SET_BAND)
 			   && IS_MBAND_UNLOCKED(wlc)) {
-			err = BCME_NOTBANDLOCKED;
+			err = -BCME_NOTBANDLOCKED;
 		} else if ((vi->flags & IOVF_SET_CLK) && !wlc->clk) {
-			err = BCME_NOCLK;
+			err = -BCME_NOCLK;
 		}
 	} else {
 		if (((vi->flags & IOVF_GET_DOWN) && wlc->pub->up) ||
 		    ((vi->flags & IOVF_GET_UP) && !wlc->pub->up)) {
-			err = (wlc->pub->up ? BCME_NOTDOWN : BCME_NOTUP);
+			err = (wlc->pub->up ? -BCME_NOTDOWN : -BCME_NOTUP);
 		} else if ((vi->flags & IOVF_GET_BAND)
 			   && IS_MBAND_UNLOCKED(wlc)) {
-			err = BCME_NOTBANDLOCKED;
+			err = -BCME_NOTBANDLOCKED;
 		} else if ((vi->flags & IOVF_GET_CLK) && !wlc->clk) {
-			err = BCME_NOCLK;
+			err = -BCME_NOCLK;
 		}
 	}
 
@@ -4521,7 +4523,7 @@ wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
 
 	default:
 		WL_ERROR("wl%d: %s: unsupported\n", wlc->pub->unit, __func__);
-		err = BCME_UNSUPPORTED;
+		err = -BCME_UNSUPPORTED;
 		break;
 	}
 
@@ -4556,7 +4558,7 @@ wlc_iovar_rangecheck(struct wlc_info *wlc, u32 val, const bcm_iovar_t *vi)
 		/* Signed values are checked against max_val and min_val */
 		if ((s32) val < (s32) min_val
 		    || (s32) val > (s32) max_val)
-			err = BCME_RANGE;
+			err = -BCME_RANGE;
 		break;
 
 	case IOVT_UINT32:
@@ -4570,7 +4572,7 @@ wlc_iovar_rangecheck(struct wlc_info *wlc, u32 val, const bcm_iovar_t *vi)
 		if (vi->flags & IOVF_NTRL)
 			min_val = 1;
 		if ((val < min_val) || (val > max_val))
-			err = BCME_RANGE;
+			err = -BCME_RANGE;
 		break;
 	}
 
@@ -5159,7 +5161,7 @@ void BCMFASTPATH wlc_send_q(struct wlc_info *wlc, struct wlc_txq_info *qi)
 			}
 		}
 
-		if (err == BCME_BUSY) {
+		if (err == -BCME_BUSY) {
 			pktq_penq_head(q, prec, pkt[0]);
 			/* If send failed due to any other reason than a change in
 			 * HW FIFO condition, quit. Otherwise, read the new prec_map!
@@ -7770,7 +7772,7 @@ int wlc_prep_pdu(struct wlc_info *wlc, struct sk_buff *pdu, uint *fifop)
 	if (TXAVAIL(wlc, fifo) < MAX_DMA_SEGS) {
 		/* Mark precedences related to this FIFO, unsendable */
 		WLC_TX_FIFO_CLEAR(wlc, fifo);
-		return BCME_BUSY;
+		return -BCME_BUSY;
 	}
 
 	if (!ieee80211_is_data(txh->MacFrameControl))
@@ -7805,7 +7807,7 @@ int wlc_get_revision_info(struct wlc_info *wlc, void *buf, uint len)
 	wlc_rev_info_t *rinfo = (wlc_rev_info_t *) buf;
 
 	if (len < WL_REV_INFO_LEGACY_LENGTH)
-		return BCME_BUFTOOSHORT;
+		return -BCME_BUFTOOSHORT;
 
 	rinfo->vendorid = wlc->vendorid;
 	rinfo->deviceid = wlc->deviceid;
@@ -7911,7 +7913,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 		if (stf > PHY_TXC1_MODE_SDM) {
 			WL_ERROR("wl%d: %s: Invalid stf\n",
 				 WLCWLUNIT(wlc), __func__);
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 			goto done;
 		}
 
@@ -7922,7 +7924,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 			     && (stf != PHY_TXC1_MODE_CDD))) {
 				WL_ERROR("wl%d: %s: Invalid mcs 32\n",
 					 WLCWLUNIT(wlc), __func__);
-				bcmerror = BCME_RANGE;
+				bcmerror = -BCME_RANGE;
 				goto done;
 			}
 			/* mcs > 7 must use stf SDM */
@@ -7940,7 +7942,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 			     && (stf == PHY_TXC1_MODE_STBC))) {
 				WL_ERROR("wl%d: %s: Invalid STBC\n",
 					 WLCWLUNIT(wlc), __func__);
-				bcmerror = BCME_RANGE;
+				bcmerror = -BCME_RANGE;
 				goto done;
 			}
 		}
@@ -7948,7 +7950,7 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 		if ((stf != PHY_TXC1_MODE_CDD) && (stf != PHY_TXC1_MODE_SISO)) {
 			WL_ERROR("wl%d: %s: Invalid OFDM\n",
 				 WLCWLUNIT(wlc), __func__);
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 			goto done;
 		}
 	} else if (IS_CCK(rate)) {
@@ -7956,20 +7958,20 @@ mac80211_wlc_set_nrate(struct wlc_info *wlc, struct wlcband *cur_band,
 		    || (stf != PHY_TXC1_MODE_SISO)) {
 			WL_ERROR("wl%d: %s: Invalid CCK\n",
 				 WLCWLUNIT(wlc), __func__);
-			bcmerror = BCME_RANGE;
+			bcmerror = -BCME_RANGE;
 			goto done;
 		}
 	} else {
 		WL_ERROR("wl%d: %s: Unknown rate type\n",
 			 WLCWLUNIT(wlc), __func__);
-		bcmerror = BCME_RANGE;
+		bcmerror = -BCME_RANGE;
 		goto done;
 	}
 	/* make sure multiple antennae are available for non-siso rates */
 	if ((stf != PHY_TXC1_MODE_SISO) && (wlc->stf->txstreams == 1)) {
 		WL_ERROR("wl%d: %s: SISO antenna but !SISO request\n",
 			 WLCWLUNIT(wlc), __func__);
-		bcmerror = BCME_RANGE;
+		bcmerror = -BCME_RANGE;
 		goto done;
 	}
 
@@ -8014,7 +8016,7 @@ wlc_duty_cycle_set(struct wlc_info *wlc, int duty_cycle, bool isOFDM,
 	    M_TX_IDLE_BUSY_RATIO_X_16_CCK;
 	if (duty_cycle > 100 || duty_cycle < 0) {
 		WL_ERROR("wl%d:  duty cycle value off limit\n", wlc->pub->unit);
-		return BCME_RANGE;
+		return -BCME_RANGE;
 	}
 	if (duty_cycle)
 		idle_busy_ratio_x_16 = (100 - duty_cycle) * 16 / duty_cycle;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index 25bb2ca..799b9ae 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -255,12 +255,12 @@ int wlc_stf_txchain_set(struct wlc_info *wlc, s32 int_val, bool force)
 
 	if ((txchain & ~wlc->stf->hw_txchain)
 	    || !(txchain & wlc->stf->hw_txchain))
-		return BCME_RANGE;
+		return -BCME_RANGE;
 
 	/* if nrate override is configured to be non-SISO STF mode, reject reducing txchain to 1 */
 	txstreams = (u8) WLC_BITSCNT(txchain);
 	if (txstreams > MAX_STREAMS_SUPPORTED)
-		return BCME_RANGE;
+		return -BCME_RANGE;
 
 	if (txstreams == 1) {
 		for (i = 0; i < NBANDS(wlc); i++)
@@ -269,7 +269,7 @@ int wlc_stf_txchain_set(struct wlc_info *wlc, s32 int_val, bool force)
 			    || (RSPEC_STF(wlc->bandstate[i]->mrspec_override) !=
 				PHY_TXC1_MODE_SISO)) {
 				if (!force)
-					return BCME_ERROR;
+					return -BCME_ERROR;
 
 				/* over-write the override rspec */
 				if (RSPEC_STF(wlc->bandstate[i]->rspec_override)
@@ -375,7 +375,7 @@ int wlc_stf_ant_txant_validate(struct wlc_info *wlc, s8 val)
 
 	/* when there is only 1 tx_streams, don't allow to change the txant */
 	if (WLCISNPHY(wlc->band) && (wlc->stf->txstreams == 1))
-		return ((val == wlc->stf->txant) ? bcmerror : BCME_RANGE);
+		return ((val == wlc->stf->txant) ? bcmerror : -BCME_RANGE);
 
 	switch (val) {
 	case -1:
@@ -391,7 +391,7 @@ int wlc_stf_ant_txant_validate(struct wlc_info *wlc, s8 val)
 		val = ANT_TX_LAST_RX;
 		break;
 	default:
-		bcmerror = BCME_RANGE;
+		bcmerror = -BCME_RANGE;
 		break;
 	}
 
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 462bd89..0bbc7b2 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -241,7 +241,7 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 /* ** driver/apps-shared section ** */
 
 #define BCME_STRLEN 		64	/* Max string length for BCM errors */
-#define VALID_BCMERROR(e)  ((e <= 0) && (e >= BCME_LAST))
+#define VALID_BCMERROR(e)  ((e <= 0) && (e >= -BCME_LAST))
 
 /*
  * error codes could be added but the defined ones shouldn't be changed/deleted
@@ -251,33 +251,33 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
  * update osl files with os specific errorcode map
 */
 
-#define BCME_ERROR			-1	/* Error generic */
-#define BCME_BADARG			-2	/* Bad Argument */
-#define BCME_NOTUP			-4	/* Not up */
-#define BCME_NOTDOWN			-5	/* Not down */
-#define BCME_BADKEYIDX			-8	/* BAD Key Index */
-#define BCME_RADIOOFF			-9	/* Radio Off */
-#define BCME_NOTBANDLOCKED		-10	/* Not  band locked */
-#define BCME_NOCLK			-11	/* No Clock */
-#define BCME_BADRATESET			-12	/* BAD Rate valueset */
-#define BCME_BADBAND			-13	/* BAD Band */
-#define BCME_BUFTOOSHORT		-14	/* Buffer too short */
-#define BCME_BUFTOOLONG			-15	/* Buffer too long */
-#define BCME_BUSY			-16	/* Busy */
-#define BCME_OUTOFRANGECHAN		-19	/* Out of Range Channel */
-#define BCME_BADCHAN			-20	/* Bad Channel */
-#define BCME_BADADDR			-21	/* Bad Address */
-#define BCME_NORESOURCE			-22	/* Not Enough Resources */
-#define BCME_UNSUPPORTED		-23	/* Unsupported */
-#define BCME_NOTREADY			-25	/* Not Ready */
-#define BCME_EPERM			-26	/* Not Permitted */
-#define BCME_NOMEM			-27	/* No Memory */
-#define BCME_ASSOCIATED			-28	/* Associated */
-#define BCME_RANGE			-29	/* Not In Range */
-#define BCME_NOTFOUND			-30	/* Not Found */
-#define BCME_SDIO_ERROR			-35	/* SDIO Bus Error */
-#define BCME_DONGLE_DOWN		-36	/* Dongle Not Accessible */
-#define BCME_NONRESIDENT		-42	/* access to nonresident overlay */
+#define BCME_ERROR			1	/* Error generic */
+#define BCME_BADARG			2	/* Bad Argument */
+#define BCME_NOTUP			4	/* Not up */
+#define BCME_NOTDOWN			5	/* Not down */
+#define BCME_BADKEYIDX			8	/* BAD Key Index */
+#define BCME_RADIOOFF			9	/* Radio Off */
+#define BCME_NOTBANDLOCKED		10	/* Not  band locked */
+#define BCME_NOCLK			11	/* No Clock */
+#define BCME_BADRATESET			12	/* BAD Rate valueset */
+#define BCME_BADBAND			13	/* BAD Band */
+#define BCME_BUFTOOSHORT		14	/* Buffer too short */
+#define BCME_BUFTOOLONG			15	/* Buffer too long */
+#define BCME_BUSY			16	/* Busy */
+#define BCME_OUTOFRANGECHAN		19	/* Out of Range Channel */
+#define BCME_BADCHAN			20	/* Bad Channel */
+#define BCME_BADADDR			21	/* Bad Address */
+#define BCME_NORESOURCE			22	/* Not Enough Resources */
+#define BCME_UNSUPPORTED		23	/* Unsupported */
+#define BCME_NOTREADY			25	/* Not Ready */
+#define BCME_EPERM			26	/* Not Permitted */
+#define BCME_NOMEM			27	/* No Memory */
+#define BCME_ASSOCIATED			28	/* Associated */
+#define BCME_RANGE			29	/* Not In Range */
+#define BCME_NOTFOUND			30	/* Not Found */
+#define BCME_SDIO_ERROR			35	/* SDIO Bus Error */
+#define BCME_DONGLE_DOWN		36	/* Dongle Not Accessible */
+#define BCME_NONRESIDENT		42  /* access to nonresident overlay */
 #define BCME_LAST			BCME_NONRESIDENT
 
 /* These are collection of BCME Error strings */
diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/util/bcmotp.c
index 1799121..41c9c43 100644
--- a/drivers/staging/brcm80211/util/bcmotp.c
+++ b/drivers/staging/brcm80211/util/bcmotp.c
@@ -384,11 +384,11 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		sz = (uint) oi->hwlim - oi->hwbase;
 		if (!(oi->status & OTPS_GUP_HW)) {
 			*wlen = sz;
-			return BCME_NOTFOUND;
+			return -BCME_NOTFOUND;
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
-			return BCME_BUFTOOSHORT;
+			return -BCME_BUFTOOSHORT;
 		}
 		base = oi->hwbase;
 		break;
@@ -396,11 +396,11 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		sz = ((uint) oi->swlim - oi->swbase);
 		if (!(oi->status & OTPS_GUP_SW)) {
 			*wlen = sz;
-			return BCME_NOTFOUND;
+			return -BCME_NOTFOUND;
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
-			return BCME_BUFTOOSHORT;
+			return -BCME_BUFTOOSHORT;
 		}
 		base = oi->swbase;
 		break;
@@ -408,11 +408,11 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		sz = OTPGU_CI_SZ;
 		if (!(oi->status & OTPS_GUP_CI)) {
 			*wlen = sz;
-			return BCME_NOTFOUND;
+			return -BCME_NOTFOUND;
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
-			return BCME_BUFTOOSHORT;
+			return -BCME_BUFTOOSHORT;
 		}
 		base = oi->otpgu_base + OTPGU_CI_OFF;
 		break;
@@ -420,11 +420,11 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		sz = (uint) oi->flim - oi->fbase;
 		if (!(oi->status & OTPS_GUP_FUSE)) {
 			*wlen = sz;
-			return BCME_NOTFOUND;
+			return -BCME_NOTFOUND;
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
-			return BCME_BUFTOOSHORT;
+			return -BCME_BUFTOOSHORT;
 		}
 		base = oi->fbase;
 		break;
@@ -432,16 +432,16 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		sz = ((uint) oi->flim - oi->hwbase);
 		if (!(oi->status & (OTPS_GUP_HW | OTPS_GUP_SW))) {
 			*wlen = sz;
-			return BCME_NOTFOUND;
+			return -BCME_NOTFOUND;
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
-			return BCME_BUFTOOSHORT;
+			return -BCME_BUFTOOSHORT;
 		}
 		base = oi->hwbase;
 		break;
 	default:
-		return BCME_BADARG;
+		return -BCME_BADARG;
 	}
 
 	idx = si_coreidx(oi->sih);
@@ -459,7 +459,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 
 static int ipxotp_nvread(void *oh, char *data, uint *len)
 {
-	return BCME_UNSUPPORTED;
+	return -BCME_UNSUPPORTED;
 }
 
 static otp_fn_t ipxotp_fn = {
@@ -708,7 +708,7 @@ static int hndotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 	/* Region empty? */
 	st = oi->hwprot | oi->signvalid;
 	if ((st & region) == 0)
-		return BCME_NOTFOUND;
+		return -BCME_NOTFOUND;
 
 	*wlen =
 	    ((int)*wlen < oi->boundary / 2) ? *wlen : (uint) oi->boundary / 2;
@@ -926,13 +926,13 @@ otp_read_region(si_t *sih, int region, u16 *data,
 		si_otp_power(sih, true);
 
 	if (!si_is_otp_powered(sih) || si_is_otp_disabled(sih)) {
-		err = BCME_NOTREADY;
+		err = -BCME_NOTREADY;
 		goto out;
 	}
 
 	oh = otp_init(sih);
 	if (oh == NULL) {
-		err = BCME_ERROR;
+		err = -BCME_ERROR;
 		goto out;
 	}
 
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 2f8d7f7..6b5a13d 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -280,7 +280,7 @@ static int otp_read_pci(si_t *sih, u16 *buf, uint bufsz)
 
 	otp = kzalloc(OTP_SZ_MAX, GFP_ATOMIC);
 	if (otp == NULL) {
-		return BCME_ERROR;
+		return -BCME_ERROR;
 	}
 
 	err = otp_read_region(sih, OTP_HW_RGN, (u16 *) otp, &sz);
@@ -324,7 +324,7 @@ static int initvars_table(char *start, char *end,
 		char *vp = kmalloc(c, GFP_ATOMIC);
 		ASSERT(vp != NULL);
 		if (!vp)
-			return BCME_NOMEM;
+			return -BCME_NOMEM;
 		memcpy(vp, start, c);
 		*vars = vp;
 		*count = c;
@@ -353,7 +353,7 @@ static int initvars_flash(si_t *sih, char **base, uint len)
 	/* allocate memory and read in flash */
 	flash = kmalloc(NVRAM_SPACE, GFP_ATOMIC);
 	if (!flash)
-		return BCME_NOMEM;
+		return -BCME_NOMEM;
 	err = nvram_getall(flash, NVRAM_SPACE);
 	if (err)
 		goto exit;
@@ -372,7 +372,7 @@ static int initvars_flash(si_t *sih, char **base, uint len)
 		/* is there enough room to copy? */
 		copy_len = l - dl + 1;
 		if (len < copy_len) {
-			err = BCME_BUFTOOSHORT;
+			err = -BCME_BUFTOOSHORT;
 			goto exit;
 		}
 
@@ -384,7 +384,7 @@ static int initvars_flash(si_t *sih, char **base, uint len)
 
 	/* add null string as terminator */
 	if (len < 1) {
-		err = BCME_BUFTOOSHORT;
+		err = -BCME_BUFTOOSHORT;
 		goto exit;
 	}
 	*vp++ = '\0';
@@ -410,7 +410,7 @@ static int initvars_flash_si(si_t *sih, char **vars, uint *count)
 	base = vp = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
 	ASSERT(vp != NULL);
 	if (!vp)
-		return BCME_NOMEM;
+		return -BCME_NOMEM;
 
 	err = initvars_flash(sih, &vp, MAXSZ_NVRAM_VARS);
 	if (err == 0)
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 387fd5d..e8aedde 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -472,9 +472,9 @@ const char *bcmerrorstr(int bcmerror)
 {
 	/* check if someone added a bcmerror code but
 		 forgot to add errorstring */
-	ASSERT(ABS(BCME_LAST) == (ARRAY_SIZE(bcmerrorstrtable) - 1));
+	ASSERT(ABS(-BCME_LAST) == (ARRAY_SIZE(bcmerrorstrtable) - 1));
 
-	if (bcmerror > 0 || bcmerror < BCME_LAST) {
+	if (bcmerror > 0 || bcmerror < -BCME_LAST) {
 		snprintf(bcm_undeferrstr, BCME_STRLEN, "Undefined error %d",
 			 bcmerror);
 		return bcm_undeferrstr;
@@ -524,31 +524,31 @@ int bcm_iovar_lencheck(const bcm_iovar_t *vi, void *arg, int len, bool set)
 	case IOVT_UINT32:
 		/* all integers are s32 sized args at the ioctl interface */
 		if (len < (int)sizeof(int)) {
-			bcmerror = BCME_BUFTOOSHORT;
+			bcmerror = -BCME_BUFTOOSHORT;
 		}
 		break;
 
 	case IOVT_BUFFER:
 		/* buffer must meet minimum length requirement */
 		if (len < vi->minlen) {
-			bcmerror = BCME_BUFTOOSHORT;
+			bcmerror = -BCME_BUFTOOSHORT;
 		}
 		break;
 
 	case IOVT_VOID:
 		if (!set) {
 			/* Cannot return nil... */
-			bcmerror = BCME_UNSUPPORTED;
+			bcmerror = -BCME_UNSUPPORTED;
 		} else if (len) {
 			/* Set is an action w/o parameters */
-			bcmerror = BCME_BUFTOOLONG;
+			bcmerror = -BCME_BUFTOOLONG;
 		}
 		break;
 
 	default:
 		/* unknown type for length check in iovar info */
 		ASSERT(0);
-		bcmerror = BCME_UNSUPPORTED;
+		bcmerror = -BCME_UNSUPPORTED;
 	}
 
 	return bcmerror;
diff --git a/drivers/staging/brcm80211/util/nvram/nvram_ro.c b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
index 397eb8c..3361e1a 100644
--- a/drivers/staging/brcm80211/util/nvram/nvram_ro.c
+++ b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
@@ -89,7 +89,7 @@ int nvram_append(void *si, char *varlst, uint varsz)
 
 	new = kmalloc(bufsz, GFP_ATOMIC);
 	if (new == NULL)
-		return BCME_NOMEM;
+		return -BCME_NOMEM;
 
 	new->vars = varlst;
 	new->bufsz = bufsz;
@@ -188,7 +188,7 @@ int nvram_getall(char *buf, int count)
 		while ((from < lim) && (*from)) {
 			len = strlen(from) + 1;
 			if (resid < (acc + len))
-				return BCME_BUFTOOSHORT;
+				return -BCME_BUFTOOSHORT;
 			memcpy(to, from, len);
 			acc += len;
 			from += len;
@@ -200,7 +200,7 @@ int nvram_getall(char *buf, int count)
 		this = this->next;
 	}
 	if (resid < 1)
-		return BCME_BUFTOOSHORT;
+		return -BCME_BUFTOOSHORT;
 	*buf = '\0';
 	return 0;
 }
-- 
1.7.4.1


