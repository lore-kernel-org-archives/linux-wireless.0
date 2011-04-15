Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1852 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab1DOJ5h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Apr 2011 05:57:37 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 2/4] staging: brcm80211: replace error codes part 1
Date: Fri, 15 Apr 2011 11:57:22 +0200
Message-ID: <1302861444-27530-3-git-send-email-rvossen@broadcom.com>
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
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    8 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   14 ++--
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   24 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   10 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   40 ++++----
 drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c     |   10 +-
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.c      |  104 ++++++++++----------
 drivers/staging/brcm80211/include/bcmutils.h       |   14 ---
 drivers/staging/brcm80211/util/bcmotp.c            |   14 ++--
 drivers/staging/brcm80211/util/bcmsrom.c           |   10 +-
 drivers/staging/brcm80211/util/bcmutils.c          |    8 +-
 drivers/staging/brcm80211/util/nvram/nvram_ro.c    |    6 +-
 15 files changed, 128 insertions(+), 142 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index eed0eca..46c6a81 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -175,7 +175,7 @@ int bcmsdh_devremove_reg(void *sdh, bcmsdh_cb_fn_t fn, void *argh)
 	ASSERT(sdh);
 
 	/* don't support yet */
-	return -BCME_UNSUPPORTED;
+	return -ENOTSUPP;
 }
 
 u8 bcmsdh_cfg_read(void *sdh, uint fnc_num, u32 addr, int *err)
@@ -318,7 +318,7 @@ int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
 		tmp_buf = kmalloc(length, GFP_ATOMIC);
 		if (tmp_buf == NULL) {
 			BCMSDH_ERROR(("%s: out of memory\n", __func__));
-			return -BCME_NOMEM;
+			return -ENOMEM;
 		}
 		memcpy(tmp_buf, cis, length);
 		for (tmp_ptr = tmp_buf, ptr = cis; ptr < (cis + length - 4);
@@ -468,7 +468,7 @@ bcmsdh_recv_buf(void *sdh, u32 addr, uint fn, uint flags,
 	/* Async not implemented yet */
 	ASSERT(!(flags & SDIO_REQ_ASYNC));
 	if (flags & SDIO_REQ_ASYNC)
-		return -BCME_UNSUPPORTED;
+		return -ENOTSUPP;
 
 	if (bar0 != bcmsdh->sbwad) {
 		err = bcmsdhsdio_set_sbaddr_window(bcmsdh, bar0);
@@ -513,7 +513,7 @@ bcmsdh_send_buf(void *sdh, u32 addr, uint fn, uint flags,
 	/* Async not implemented yet */
 	ASSERT(!(flags & SDIO_REQ_ASYNC));
 	if (flags & SDIO_REQ_ASYNC)
-		return -BCME_UNSUPPORTED;
+		return -ENOTSUPP;
 
 	if (bar0 != bcmsdh->sbwad) {
 		err = bcmsdhsdio_set_sbaddr_window(bcmsdh, bar0);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 9212fcd..fab3853 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -423,7 +423,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	vi = bcm_iovar_lookup(sdioh_iovars, name);
 	if (vi == NULL) {
-		bcmerror = -BCME_UNSUPPORTED;
+		bcmerror = -ENOTSUPP;
 		goto exit;
 	}
 
@@ -472,7 +472,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 
 	case IOV_GVAL(IOV_BLOCKSIZE):
 		if ((u32) int_val > si->num_funcs) {
-			bcmerror = -BCME_BADARG;
+			bcmerror = -EINVAL;
 			break;
 		}
 		int_val = (s32) si->client_block_size[int_val];
@@ -486,7 +486,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 			uint maxsize;
 
 			if (func > si->num_funcs) {
-				bcmerror = -BCME_BADARG;
+				bcmerror = -EINVAL;
 				break;
 			}
 
@@ -504,7 +504,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 				maxsize = 0;
 			}
 			if (blksize > maxsize) {
-				bcmerror = -BCME_BADARG;
+				bcmerror = -EINVAL;
 				break;
 			}
 			if (!blksize)
@@ -607,7 +607,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 			    || sd_ptr->offset > SD_MaxCurCap) {
 				sd_err(("%s: bad offset 0x%x\n", __func__,
 					sd_ptr->offset));
-				bcmerror = -BCME_BADARG;
+				bcmerror = -EINVAL;
 				break;
 			}
 
@@ -637,7 +637,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 			    || sd_ptr->offset > SD_MaxCurCap) {
 				sd_err(("%s: bad offset 0x%x\n", __func__,
 					sd_ptr->offset));
-				bcmerror = -BCME_BADARG;
+				bcmerror = -EINVAL;
 				break;
 			}
 
@@ -679,7 +679,7 @@ sdioh_iovar_op(sdioh_info_t *si, const char *name,
 		}
 
 	default:
-		bcmerror = -BCME_UNSUPPORTED;
+		bcmerror = -ENOTSUPP;
 		break;
 	}
 exit:
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 0d72dd4..a91684e 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -151,7 +151,7 @@ int sdioh_sdmmc_osinit(sdioh_info_t *sd)
 	sdos = kmalloc(sizeof(struct sdos_info), GFP_ATOMIC);
 	sd->sdos_info = (void *)sdos;
 	if (sdos == NULL)
-		return -BCME_NOMEM;
+		return -ENOMEM;
 
 	sdos->sd = sd;
 	spin_lock_init(&sdos->lock);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 456b5db..95872f0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -309,7 +309,7 @@ int
 dhd_prot_iovar_op(dhd_pub_t *dhdp, const char *name,
 		  void *params, int plen, void *arg, int len, bool set)
 {
-	return -BCME_UNSUPPORTED;
+	return -ENOTSUPP;
 }
 
 void dhd_prot_dump(dhd_pub_t *dhdp, struct bcmstrbuf *strbuf)
@@ -416,7 +416,7 @@ int dhd_prot_attach(dhd_pub_t *dhd)
 
 fail:
 	kfree(cdc);
-	return -BCME_NOMEM;
+	return -ENOMEM;
 }
 
 /* ~NOTE~ What if another thread is waiting on the semaphore?  Holding it? */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index acdd985..eda0935 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -189,7 +189,7 @@ static int dhd_dump(dhd_pub_t *dhdp, char *buf, int buflen)
 	/* Add any bus info */
 	dhd_bus_dump(dhdp, strbuf);
 
-	return !strbuf->size ? -BCME_BUFTOOSHORT : 0;
+	return !strbuf->size ? -EOVERFLOW : 0;
 }
 
 static int
@@ -242,7 +242,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_WDTICK):
 		if (!dhd_pub->up) {
-			bcmerror = -BCME_NOTUP;
+			bcmerror = -ENOLINK;
 			break;
 		}
 		dhd_os_wd_timer(dhd_pub, (uint) int_val);
@@ -289,7 +289,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_IOCTLTIMEOUT):{
 			if (int_val <= 0)
-				bcmerror = -BCME_BADARG;
+				bcmerror = -EINVAL;
 			else
 				dhd_os_set_ioctl_resp_timeout((unsigned int)
 							      int_val);
@@ -297,7 +297,7 @@ dhd_doiovar(dhd_pub_t *dhd_pub, const bcm_iovar_t *vi, u32 actionid,
 		}
 
 	default:
-		bcmerror = -BCME_UNSUPPORTED;
+		bcmerror = -ENOTSUPP;
 		break;
 	}
 
@@ -381,7 +381,7 @@ dhd_iovar_op(dhd_pub_t *dhd_pub, const char *name,
 
 	vi = bcm_iovar_lookup(dhd_iovars, name);
 	if (vi == NULL) {
-		bcmerror = -BCME_UNSUPPORTED;
+		bcmerror = -ENOTSUPP;
 		goto exit;
 	}
 
@@ -420,19 +420,19 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	if (!buf)
-		return -BCME_BADARG;
+		return -EINVAL;
 
 	switch (ioc->cmd) {
 	case DHD_GET_MAGIC:
 		if (buflen < sizeof(int))
-			bcmerror = -BCME_BUFTOOSHORT;
+			bcmerror = -EOVERFLOW;
 		else
 			*(int *)buf = DHD_IOCTL_MAGIC;
 		break;
 
 	case DHD_GET_VERSION:
 		if (buflen < sizeof(int))
-			bcmerror = -BCME_BUFTOOSHORT;
+			bcmerror = -EOVERFLOW;
 		else
 			*(int *)buf = DHD_IOCTL_VERSION;
 		break;
@@ -448,7 +448,7 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 				;
 
 			if (*arg) {
-				bcmerror = -BCME_BUFTOOSHORT;
+				bcmerror = -EOVERFLOW;
 				break;
 			}
 
@@ -464,7 +464,7 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 				bcmerror =
 				    dhd_iovar_op(dhd_pub, buf, NULL, 0, arg,
 						 arglen, IOV_SET);
-			if (bcmerror != -BCME_UNSUPPORTED)
+			if (bcmerror != -ENOTSUPP)
 				break;
 
 			/* not in generic table, try protocol module */
@@ -476,7 +476,7 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 				bcmerror = dhd_prot_iovar_op(dhd_pub, buf,
 							     NULL, 0, arg,
 							     arglen, IOV_SET);
-			if (bcmerror != -BCME_UNSUPPORTED)
+			if (bcmerror != -ENOTSUPP)
 				break;
 
 			/* if still not found, try bus module */
@@ -493,7 +493,7 @@ int dhd_ioctl(dhd_pub_t *dhd_pub, dhd_ioctl_t *ioc, void *buf, uint buflen)
 		}
 
 	default:
-		bcmerror = -BCME_UNSUPPORTED;
+		bcmerror = -ENOTSUPP;
 	}
 
 	return bcmerror;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index a329f17..b326722 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -1699,7 +1699,7 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 
 	/* Copy the ioc control structure part of ioctl request */
 	if (copy_from_user(&ioc, ifr->ifr_data, sizeof(wl_ioctl_t))) {
-		bcmerror = -BCME_BADADDR;
+		bcmerror = -EINVAL;
 		goto done;
 	}
 
@@ -1715,11 +1715,11 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 		{
 			buf = kmalloc(buflen, GFP_ATOMIC);
 			if (!buf) {
-				bcmerror = -BCME_NOMEM;
+				bcmerror = -ENOMEM;
 				goto done;
 			}
 			if (copy_from_user(buf, ioc.buf, buflen)) {
-				bcmerror = -BCME_BADADDR;
+				bcmerror = -EINVAL;
 				goto done;
 			}
 		}
@@ -1728,12 +1728,12 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 	/* To differentiate between wl and dhd read 4 more byes */
 	if ((copy_from_user(&driver, (char *)ifr->ifr_data + sizeof(wl_ioctl_t),
 			    sizeof(uint)) != 0)) {
-		bcmerror = -BCME_BADADDR;
+		bcmerror = -EINVAL;
 		goto done;
 	}
 
 	if (!capable(CAP_NET_ADMIN)) {
-		bcmerror = -BCME_EPERM;
+		bcmerror = -EPERM;
 		goto done;
 	}
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 49df58f..1c90ec0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -799,7 +799,7 @@ int dhdsdio_bussleep(dhd_bus_t *bus, bool sleep)
 	if (sleep) {
 		/* Don't sleep if something is pending */
 		if (bus->dpc_sched || bus->rxskip || pktq_len(&bus->txq))
-			return -BCME_BUSY;
+			return -EBUSY;
 
 		/* Disable SDIO interrupts (no longer interested) */
 		bcmsdh_intr_disable(bus->sdh);
@@ -941,7 +941,7 @@ static int dhdsdio_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 				DHD_ERROR(("%s: couldn't allocate new %d-byte "
 					"packet\n",
 					__func__, pkt->len + DHD_SDALIGN));
-				ret = -BCME_NOMEM;
+				ret = -ENOMEM;
 				goto done;
 			}
 
@@ -1113,7 +1113,7 @@ int dhd_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 			dhd_txcomplete(bus->dhd, pkt, false);
 			pkt_buf_free_skb(pkt);
 			DHD_ERROR(("%s: out of bus->txq !!!\n", __func__));
-			ret = -BCME_NORESOURCE;
+			ret = -ENOSR;
 		} else {
 			ret = 0;
 		}
@@ -1670,7 +1670,7 @@ static int dhdsdio_pktgen_set(dhd_bus_t *bus, u8 *arg)
 
 	memcpy(&pktgen, arg, sizeof(pktgen));
 	if (pktgen.version != DHD_PKTGEN_VERSION)
-		return -BCME_BADARG;
+		return -EINVAL;
 
 	oldcnt = bus->pktgen_count;
 	oldmode = bus->pktgen_mode;
@@ -1831,7 +1831,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 		if (mbuffer == NULL) {
 			DHD_ERROR(("%s: kmalloc(%d) failed\n", __func__,
 				   msize));
-			bcmerror = -BCME_NOMEM;
+			bcmerror = -ENOMEM;
 			goto done;
 		}
 	}
@@ -1839,7 +1839,7 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 	str = kmalloc(maxstrlen, GFP_ATOMIC);
 	if (str == NULL) {
 		DHD_ERROR(("%s: kmalloc(%d) failed\n", __func__, maxstrlen));
-		bcmerror = -BCME_NOMEM;
+		bcmerror = -ENOMEM;
 		goto done;
 	}
 
@@ -2008,7 +2008,7 @@ static int dhdsdio_readconsole(dhd_bus_t *bus)
 		c->bufsize = le32_to_cpu(c->log.buf_size);
 		c->buf = kmalloc(c->bufsize, GFP_ATOMIC);
 		if (c->buf == NULL)
-			return -BCME_NOMEM;
+			return -ENOMEM;
 	}
 
 	idx = le32_to_cpu(c->log.idx);
@@ -2074,7 +2074,7 @@ int dhdsdio_downloadvars(dhd_bus_t *bus, void *arg, int len)
 		goto err;
 	}
 	if (!len) {
-		bcmerror = -BCME_BUFTOOSHORT;
+		bcmerror = -EOVERFLOW;
 		goto err;
 	}
 
@@ -2084,7 +2084,7 @@ int dhdsdio_downloadvars(dhd_bus_t *bus, void *arg, int len)
 	bus->vars = kmalloc(len, GFP_ATOMIC);
 	bus->varsz = bus->vars ? len : 0;
 	if (bus->vars == NULL) {
-		bcmerror = -BCME_NOMEM;
+		bcmerror = -ENOMEM;
 		goto err;
 	}
 
@@ -2183,7 +2183,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_IDLETIME):
 		if ((int_val < 0) && (int_val != DHD_IDLE_IMMEDIATE))
-			bcmerror = -BCME_BADARG;
+			bcmerror = -EINVAL;
 		else
 			bus->idletime = int_val;
 		break;
@@ -2229,7 +2229,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 				"0x%08x size %d dsize %d\n",
 				__func__, (set ? "set" : "get"),
 				address, size, dsize));
-				bcmerror = -BCME_BADARG;
+				bcmerror = -EINVAL;
 				break;
 			}
 
@@ -2244,7 +2244,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 				DHD_ERROR(("%s: ramsize 0x%08x doesn't have %d "
 				"bytes at 0x%08x\n",
 				__func__, bus->orig_ramsize, size, address));
-				bcmerror = -BCME_BADARG;
+				bcmerror = -EINVAL;
 				break;
 			}
 
@@ -2302,7 +2302,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 
 	case IOV_SVAL(IOV_SDRXCHAIN):
 		if (bool_val && !bus->sd_rxchain)
-			bcmerror = -BCME_UNSUPPORTED;
+			bcmerror = -ENOTSUPP;
 		else
 			bus->use_rxchain = bool_val;
 		break;
@@ -2325,7 +2325,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 		if (bus->varsz < (uint) len)
 			memcpy(arg, bus->vars, bus->varsz);
 		else
-			bcmerror = -BCME_BUFTOOSHORT;
+			bcmerror = -EOVERFLOW;
 		break;
 #endif				/* DHD_DEBUG */
 
@@ -2489,7 +2489,7 @@ dhdsdio_doiovar(dhd_bus_t *bus, const bcm_iovar_t *vi, u32 actionid,
 		break;
 
 	default:
-		bcmerror = -BCME_UNSUPPORTED;
+		bcmerror = -ENOTSUPP;
 		break;
 	}
 
@@ -2526,7 +2526,7 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 	if (bus->vars) {
 		vbuffer = kzalloc(varsize, GFP_ATOMIC);
 		if (!vbuffer)
-			return -BCME_NOMEM;
+			return -ENOMEM;
 
 		memcpy(vbuffer, bus->vars, bus->varsz);
 
@@ -2538,7 +2538,7 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 		DHD_INFO(("Compare NVRAM dl & ul; varsize=%d\n", varsize));
 		nvram_ularray = kmalloc(varsize, GFP_ATOMIC);
 		if (!nvram_ularray)
-			return -BCME_NOMEM;
+			return -ENOMEM;
 
 		/* Upload image to verify downloaded contents. */
 		memset(nvram_ularray, 0xaa, varsize);
@@ -4953,7 +4953,7 @@ extern int dhd_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg, uint msglen)
 
 	/* Address could be zero if CONSOLE := 0 in dongle Makefile */
 	if (bus->console_addr == 0)
-		return -BCME_UNSUPPORTED;
+		return -ENOTSUPP;
 
 	/* Exclusive bus access */
 	dhd_os_sdlock(bus->dhd);
@@ -5180,7 +5180,7 @@ static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
 	/* if firmware path present try to download and bring up bus */
 	ret = dhd_bus_start(bus->dhd);
 	if (ret != 0) {
-		if (ret == -BCME_NOTUP) {
+		if (ret == -ENOLINK) {
 			DHD_ERROR(("%s: dongle is not responding\n", __func__));
 			goto fail;
 		}
@@ -5643,7 +5643,7 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 
 		ularray = kmalloc(bus->ramsize, GFP_ATOMIC);
 		if (!ularray) {
-			bcmerror = -BCME_NOMEM;
+			bcmerror = -ENOMEM;
 			goto err;
 		}
 		/* Upload image to verify downloaded contents. */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
index af6db24..170c6f3 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_ampdu.c
@@ -529,14 +529,14 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 	/* Let pressure continue to build ... */
 	qlen = pktq_plen(&qi->q, prec);
 	if (ini->tx_in_transit > 0 && qlen < scb_ampdu->max_pdu) {
-		return -BCME_BUSY;
+		return -EBUSY;
 	}
 
 	wlc_ampdu_agg(ampdu, scb, p, tid);
 
 	if (wlc->block_datafifo) {
 		dev_err(dev, "%s: Fifo blocked\n", __func__);
-		return -BCME_BUSY;
+		return -EBUSY;
 	}
 	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
 	ampdu_len = 0;
@@ -557,7 +557,7 @@ wlc_sendampdu(struct ampdu_info *ampdu, struct wlc_txq_info *qi,
 		}
 
 		if (err) {
-			if (err == -BCME_BUSY) {
+			if (err == -EBUSY) {
 				dev_err(dev, "wl%d: wlc_sendampdu: prep_xdu "
 					"retry; seq 0x%x\n", wlc->pub->unit,
 					seq);
@@ -1205,12 +1205,12 @@ static int wlc_ampdu_set(struct ampdu_info *ampdu, bool on)
 		if (!N_ENAB(wlc->pub)) {
 			WL_AMPDU_ERR("wl%d: driver not nmode enabled\n",
 				     wlc->pub->unit);
-			return -BCME_UNSUPPORTED;
+			return -ENOTSUPP;
 		}
 		if (!wlc_ampdu_cap(ampdu)) {
 			WL_AMPDU_ERR("wl%d: device not ampdu capable\n",
 				     wlc->pub->unit);
-			return -BCME_UNSUPPORTED;
+			return -ENOTSUPP;
 		}
 		wlc->pub->_ampdu = on;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index e170b88..124e9cd 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -722,7 +722,7 @@ wlc_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
 	}
 
 	if (country == NULL)
-		return -BCME_BADARG;
+		return -EINVAL;
 
 	/* set the driver state for the country */
 	wlc_set_country_common(wlc_cm, country_abbrev, mapped_ccode,
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.c b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
index 3e2a071..22e9df9 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.c
@@ -827,7 +827,7 @@ static int wlc_get_current_txpwr(struct wlc_info *wlc, void *pwr, uint len)
 	if (len == sizeof(tx_power_legacy_t))
 		old_power = (tx_power_legacy_t *) pwr;
 	else if (len < sizeof(tx_power_t))
-		return -BCME_BUFTOOSHORT;
+		return -EOVERFLOW;
 
 	memset(&power, 0, sizeof(tx_power_t));
 
@@ -2554,7 +2554,7 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 	 * Gmode is not GMODE_LEGACY_B
 	 */
 	if (N_ENAB(wlc->pub) && gmode == GMODE_LEGACY_B)
-		return -BCME_UNSUPPORTED;
+		return -ENOTSUPP;
 
 	/* verify that we are dealing with 2G band and grab the band pointer */
 	if (wlc->band->bandtype == WLC_BAND_2G)
@@ -2563,7 +2563,7 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 		 (wlc->bandstate[OTHERBANDUNIT(wlc)]->bandtype == WLC_BAND_2G))
 		band = wlc->bandstate[OTHERBANDUNIT(wlc)];
 	else
-		return -BCME_BADBAND;
+		return -EINVAL;
 
 	/* Legacy or bust when no OFDM is supported by regulatory */
 	if ((wlc_channel_locale_flags_in_band(wlc->cmi, band->bandunit) &
@@ -2618,7 +2618,7 @@ int wlc_set_gmode(struct wlc_info *wlc, u8 gmode, bool config)
 		/* Error */
 		dev_err(wlc->dev, "wl%d: %s: invalid gmode %d\n",
 			 wlc->pub->unit, __func__, gmode);
-		return -BCME_UNSUPPORTED;
+		return -ENOTSUPP;
 	}
 
 	/*
@@ -2697,7 +2697,7 @@ static int wlc_nmode_validate(struct wlc_info *wlc, s32 nmode)
 	case WL_11N_2x2:
 	case WL_11N_3x3:
 		if (!(WLC_PHY_11N_CAP(wlc->band)))
-			err = -BCME_BADBAND;
+			err = -EINVAL;
 		break;
 
 	default:
@@ -2773,7 +2773,7 @@ static int wlc_set_rateset(struct wlc_info *wlc, wlc_rateset_t *rs_arg)
 
 	/* check for bad count value */
 	if ((rs.count == 0) || (rs.count > WLC_NUMRATES))
-		return -BCME_BADRATESET;
+		return -EINVAL;
 
 	/* try the current band */
 	bandunit = wlc->band->bandunit;
@@ -2909,7 +2909,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		if ((arg == NULL) || (len <= 0)) {
 			dev_err(wlc->dev, "wl%d: %s: Command %d needs arguments\n",
 				 wlc->pub->unit, __func__, cmd);
-			bcmerror = -BCME_BADARG;
+			bcmerror = -EINVAL;
 			goto done;
 		}
 	}
@@ -2934,7 +2934,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			channel_info_t *ci = (channel_info_t *) arg;
 
 			if (len <= (int)sizeof(ci)) {
-				bcmerror = BCME_BUFTOOSHORT;
+				bcmerror = EOVERFLOW;
 				goto done;
 			}
 
@@ -2951,12 +2951,12 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			chanspec_t chspec = CH20MHZ_CHSPEC(val);
 
 			if (val < 0 || val > MAXCHANNEL) {
-				bcmerror = -BCME_OUTOFRANGECHAN;
+				bcmerror = -EINVAL;
 				break;
 			}
 
 			if (!wlc_valid_chanspec_db(wlc->cmi, chspec)) {
-				bcmerror = -BCME_BADCHAN;
+				bcmerror = -EINVAL;
 				break;
 			}
 
@@ -2983,7 +2983,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 #if defined(BCMDBG)
 	case WLC_GET_UCFLAGS:
 		if (!wlc->pub->up) {
-			bcmerror = -BCME_NOTUP;
+			bcmerror = -ENOLINK;
 			break;
 		}
 
@@ -3007,7 +3007,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	case WLC_SET_UCFLAGS:
 		if (!wlc->pub->up) {
-			bcmerror = -BCME_NOTUP;
+			bcmerror = -ENOLINK;
 			break;
 		}
 
@@ -3045,7 +3045,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 
 		if (val & 1) {
-			bcmerror = -BCME_BADADDR;
+			bcmerror = -EINVAL;
 			break;
 		}
 
@@ -3066,7 +3066,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 
 		if (val & 1) {
-			bcmerror = -BCME_BADADDR;
+			bcmerror = -EINVAL;
 			break;
 		}
 
@@ -3080,7 +3080,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		band = WLC_BAND_AUTO;
 
 		if (len < (int)(sizeof(rw_reg_t) - sizeof(uint))) {
-			bcmerror = -BCME_BUFTOOSHORT;
+			bcmerror = -EOVERFLOW;
 			break;
 		}
 
@@ -3093,7 +3093,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 
 		if ((r->byteoff + r->size) > sizeof(d11regs_t)) {
-			bcmerror = -BCME_BADADDR;
+			bcmerror = -EINVAL;
 			break;
 		}
 		if (r->size == sizeof(u32))
@@ -3105,7 +3105,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			    R_REG((u16 *)((unsigned char *)(unsigned long)regs +
 					      r->byteoff));
 		else
-			bcmerror = -BCME_BADADDR;
+			bcmerror = -EINVAL;
 		break;
 
 	case WLC_W_REG:
@@ -3114,7 +3114,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		band = WLC_BAND_AUTO;
 
 		if (len < (int)(sizeof(rw_reg_t) - sizeof(uint))) {
-			bcmerror = -BCME_BUFTOOSHORT;
+			bcmerror = -EOVERFLOW;
 			break;
 		}
 
@@ -3127,7 +3127,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			break;
 
 		if (r->byteoff + r->size > sizeof(d11regs_t)) {
-			bcmerror = -BCME_BADADDR;
+			bcmerror = -EINVAL;
 			break;
 		}
 		if (r->size == sizeof(u32))
@@ -3137,7 +3137,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			W_REG((u16 *)((unsigned char *)(unsigned long) regs +
 					  r->byteoff), r->val);
 		else
-			bcmerror = -BCME_BADADDR;
+			bcmerror = -EINVAL;
 		break;
 #endif				/* BCMDBG */
 
@@ -3200,7 +3200,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			u16 rxstatus;
 
 			if (!wlc->pub->up) {
-				bcmerror = -BCME_NOTUP;
+				bcmerror = -ENOLINK;
 				break;
 			}
 
@@ -3227,7 +3227,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 	case WLC_SET_UCANTDIV:{
 			if (!wlc->pub->up) {
-				bcmerror = -BCME_NOTUP;
+				bcmerror = -ENOLINK;
 				break;
 			}
 
@@ -3358,7 +3358,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			wsec_key_t *src_key = wlc->wsec_keys[val];
 
 			if (len < (int)sizeof(key)) {
-				bcmerror = -BCME_BUFTOOSHORT;
+				bcmerror = -EOVERFLOW;
 				break;
 			}
 
@@ -3378,7 +3378,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 			memcpy(arg, &key, sizeof(key));
 		} else
-			bcmerror = -BCME_BADKEYIDX;
+			bcmerror = -EINVAL;
 		break;
 #endif				/* defined(BCMDBG) */
 
@@ -3392,7 +3392,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			wsec_key_t *key;
 
 			if (len < DOT11_WPA_KEY_RSC_LEN) {
-				bcmerror = -BCME_BUFTOOSHORT;
+				bcmerror = -EOVERFLOW;
 				break;
 			}
 
@@ -3429,7 +3429,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 				memcpy(arg, seq, sizeof(seq));
 			} else {
-				bcmerror = -BCME_BADKEYIDX;
+				bcmerror = -EINVAL;
 			}
 			break;
 		}
@@ -3444,7 +3444,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				rs = &wlc->default_bss->rateset;
 
 			if (len < (int)(rs->count + sizeof(rs->count))) {
-				bcmerror = -BCME_BUFTOOSHORT;
+				bcmerror = -EOVERFLOW;
 				break;
 			}
 
@@ -3462,7 +3462,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			wlc_default_rateset(wlc, (wlc_rateset_t *) &rs);
 
 			if (len < (int)(rs.count + sizeof(rs.count))) {
-				bcmerror = -BCME_BUFTOOSHORT;
+				bcmerror = -EOVERFLOW;
 				break;
 			}
 
@@ -3477,7 +3477,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			wl_rateset_t *in_rs = (wl_rateset_t *) arg;
 
 			if (len < (int)(in_rs->count + sizeof(in_rs->count))) {
-				bcmerror = -BCME_BUFTOOSHORT;
+				bcmerror = -EOVERFLOW;
 				break;
 			}
 
@@ -3668,7 +3668,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		{
 			unsigned char *cp = arg;
 			if (len < 3) {
-				bcmerror = -BCME_BUFTOOSHORT;
+				bcmerror = -EOVERFLOW;
 				break;
 			}
 
@@ -3800,14 +3800,14 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 
 			/* copyin */
 			if (len < (int)sizeof(wlc_rateset_t)) {
-				bcmerror = -BCME_BUFTOOSHORT;
+				bcmerror = -EOVERFLOW;
 				break;
 			}
 			memcpy(&rs, arg, sizeof(wlc_rateset_t));
 
 			/* check for bad count value */
 			if (rs.count > WLC_NUMRATES) {
-				bcmerror = -BCME_BADRATESET;
+				bcmerror = -EINVAL;
 				break;
 			}
 
@@ -3816,7 +3816,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			      ((NBANDS(wlc) > 1)
 			       && wlc->bandstate[OTHERBANDUNIT(wlc)]->gmode))) {
 				/* gmode only command when not in gmode */
-				bcmerror = -BCME_BADBAND;
+				bcmerror = -EINVAL;
 				break;
 			}
 
@@ -3839,7 +3839,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 							   false,
 							   wlc->stf->txstreams);
 			if (rs.count != new.count) {
-				bcmerror = BCME_BADRATESET;
+				bcmerror = EINVAL;
 				break;
 			}
 
@@ -3862,11 +3862,11 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		      ((NBANDS(wlc) > 1)
 		       && wlc->bandstate[OTHERBANDUNIT(wlc)]->gmode))) {
 			/* gmode only command when not in gmode */
-			bcmerror = -BCME_BADBAND;
+			bcmerror = -EINVAL;
 			break;
 		}
 		if (len < (int)sizeof(wlc_rateset_t)) {
-			bcmerror = -BCME_BUFTOOSHORT;
+			bcmerror = -EOVERFLOW;
 			break;
 		}
 		memcpy(arg, &wlc->sup_rates_override, sizeof(wlc_rateset_t));
@@ -3897,7 +3897,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 			if (key != NULL) {
 				*pval = key->id == val ? true : false;
 			} else {
-				bcmerror = -BCME_BADKEYIDX;
+				bcmerror = -EINVAL;
 			}
 			break;
 		}
@@ -3905,7 +3905,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 	case WLC_SET_KEY_PRIMARY:{
 			wsec_key_t *key, *old_key;
 
-			bcmerror = -BCME_BADKEYIDX;
+			bcmerror = -EINVAL;
 
 			/* treat the 'val' parm as the key id */
 			for (i = 0; i < WSEC_MAX_DEFAULT_KEYS; i++) {
@@ -3939,7 +3939,7 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 				;
 
 			if (i == (uint) len) {
-				bcmerror = -BCME_BUFTOOSHORT;
+				bcmerror = -EOVERFLOW;
 				break;
 			}
 			i++;	/* include the null in the string length */
@@ -3960,13 +3960,13 @@ _wlc_ioctl(struct wlc_info *wlc, int cmd, void *arg, int len,
 		}
 
 	case WLC_SET_WSEC_PMK:
-		bcmerror = -BCME_UNSUPPORTED;
+		bcmerror = -ENOTSUPP;
 		break;
 
 #if defined(BCMDBG)
 	case WLC_CURRENT_PWR:
 		if (!wlc->pub->up)
-			bcmerror = -BCME_NOTUP;
+			bcmerror = -ENOLINK;
 		else
 			bcmerror = wlc_get_current_txpwr(wlc, arg, len);
 		break;
@@ -3995,7 +3995,7 @@ int wlc_iocregchk(struct wlc_info *wlc, uint band)
 {
 	/* if band is specified, it must be the current band */
 	if ((band != WLC_BAND_AUTO) && (band != (uint) wlc->band->bandtype))
-		return -BCME_BADBAND;
+		return -EINVAL;
 
 	/* if multiband and band is not specified, band must be locked */
 	if ((band == WLC_BAND_AUTO) && IS_MBAND_UNLOCKED(wlc))
@@ -4014,7 +4014,7 @@ int wlc_iocregchk(struct wlc_info *wlc, uint band)
 int wlc_iocpichk(struct wlc_info *wlc, uint phytype)
 {
 	if (wlc->band->phytype != phytype)
-		return -BCME_BADBAND;
+		return -EINVAL;
 	return 0;
 }
 #endif
@@ -4097,7 +4097,7 @@ int wlc_module_register(struct wlc_pub *pub, const bcm_iovar_t *iovars,
 		}
 	}
 
-	return -BCME_NORESOURCE;
+	return -ENOSR;
 }
 
 /* unregister module callbacks */
@@ -4158,7 +4158,7 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 	    !(IS_ALIGNED((unsigned long)(arg), (uint) sizeof(int)))) {
 		dev_err(wlc->dev, "wl%d: %s unaligned get ptr for %s\n",
 			 wlc->pub->unit, __func__, name);
-		err = BCME_UNSUPPORTED;
+		err = ENOTSUPP;
 		goto exit;
 	}
 
@@ -4172,7 +4172,7 @@ wlc_iovar_op(struct wlc_info *wlc, const char *name,
 	}
 	/* iovar name not found */
 	if (i >= WLC_MAXMODULES) {
-		err = -BCME_UNSUPPORTED;
+		err = -ENOTSUPP;
 		goto exit;
 	}
 
@@ -4215,7 +4215,7 @@ wlc_iovar_check(struct wlc_pub *pub, const bcm_iovar_t *vi, void *arg, int len,
 	if (set) {
 		if (((vi->flags & IOVF_SET_DOWN) && wlc->pub->up) ||
 		    ((vi->flags & IOVF_SET_UP) && !wlc->pub->up)) {
-			err = (wlc->pub->up ? -BCME_NOTDOWN : -BCME_NOTUP);
+			err = (wlc->pub->up ? -BCME_NOTDOWN : -ENOLINK);
 		} else if ((vi->flags & IOVF_SET_BAND)
 			   && IS_MBAND_UNLOCKED(wlc)) {
 			err = -BCME_NOTBANDLOCKED;
@@ -4225,7 +4225,7 @@ wlc_iovar_check(struct wlc_pub *pub, const bcm_iovar_t *vi, void *arg, int len,
 	} else {
 		if (((vi->flags & IOVF_GET_DOWN) && wlc->pub->up) ||
 		    ((vi->flags & IOVF_GET_UP) && !wlc->pub->up)) {
-			err = (wlc->pub->up ? -BCME_NOTDOWN : -BCME_NOTUP);
+			err = (wlc->pub->up ? -BCME_NOTDOWN : -ENOLINK);
 		} else if ((vi->flags & IOVF_GET_BAND)
 			   && IS_MBAND_UNLOCKED(wlc)) {
 			err = -BCME_NOTBANDLOCKED;
@@ -4373,7 +4373,7 @@ wlc_doiovar(void *hdl, const bcm_iovar_t *vi, u32 actionid,
 	default:
 		dev_err(wlc->dev, "wl%d: %s: unsupported\n", wlc->pub->unit,
 			__func__);
-		err = -BCME_UNSUPPORTED;
+		err = -ENOTSUPP;
 		break;
 	}
 
@@ -4992,7 +4992,7 @@ void BCMFASTPATH wlc_send_q(struct wlc_info *wlc, struct wlc_txq_info *qi)
 			}
 		}
 
-		if (err == -BCME_BUSY) {
+		if (err == -EBUSY) {
 			pktq_penq_head(q, prec, pkt[0]);
 			/* If send failed due to any other reason than a change in
 			 * HW FIFO condition, quit. Otherwise, read the new prec_map!
@@ -7476,7 +7476,7 @@ int wlc_prep_pdu(struct wlc_info *wlc, struct sk_buff *pdu, uint *fifop)
 	if (TXAVAIL(wlc, fifo) < MAX_DMA_SEGS) {
 		/* Mark precedences related to this FIFO, unsendable */
 		WLC_TX_FIFO_CLEAR(wlc, fifo);
-		return -BCME_BUSY;
+		return -EBUSY;
 	}
 
 	if (!ieee80211_is_data(txh->MacFrameControl))
@@ -7511,7 +7511,7 @@ int wlc_get_revision_info(struct wlc_info *wlc, void *buf, uint len)
 	wlc_rev_info_t *rinfo = (wlc_rev_info_t *) buf;
 
 	if (len < WL_REV_INFO_LEGACY_LENGTH)
-		return -BCME_BUFTOOSHORT;
+		return -EOVERFLOW;
 
 	rinfo->vendorid = wlc->vendorid;
 	rinfo->deviceid = wlc->deviceid;
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 2c37dcd..a026356 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -252,26 +252,12 @@ extern struct sk_buff *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out);
 */
 
 #define BCME_ERROR			1	/* Error generic */
-#define BCME_BADARG			2	/* Bad Argument */
-#define BCME_NOTUP			4	/* Not up */
 #define BCME_NOTDOWN			5	/* Not down */
-#define BCME_BADKEYIDX			8	/* BAD Key Index */
 #define BCME_RADIOOFF			9	/* Radio Off */
 #define BCME_NOTBANDLOCKED		10	/* Not  band locked */
 #define BCME_NOCLK			11	/* No Clock */
-#define BCME_BADRATESET			12	/* BAD Rate valueset */
-#define BCME_BADBAND			13	/* BAD Band */
-#define BCME_BUFTOOSHORT		14	/* Buffer too short */
 #define BCME_BUFTOOLONG			15	/* Buffer too long */
-#define BCME_BUSY			16	/* Busy */
-#define BCME_OUTOFRANGECHAN		19	/* Out of Range Channel */
-#define BCME_BADCHAN			20	/* Bad Channel */
-#define BCME_BADADDR			21	/* Bad Address */
-#define BCME_NORESOURCE			22	/* Not Enough Resources */
-#define BCME_UNSUPPORTED		23	/* Unsupported */
 #define BCME_NOTREADY			25	/* Not Ready */
-#define BCME_EPERM			26	/* Not Permitted */
-#define BCME_NOMEM			27	/* No Memory */
 #define BCME_ASSOCIATED			28	/* Associated */
 #define BCME_RANGE			29	/* Not In Range */
 #define BCME_NOTFOUND			30	/* Not Found */
diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/util/bcmotp.c
index 6957339..bdfe586 100644
--- a/drivers/staging/brcm80211/util/bcmotp.c
+++ b/drivers/staging/brcm80211/util/bcmotp.c
@@ -386,7 +386,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
-			return -BCME_BUFTOOSHORT;
+			return -EOVERFLOW;
 		}
 		base = oi->hwbase;
 		break;
@@ -398,7 +398,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
-			return -BCME_BUFTOOSHORT;
+			return -EOVERFLOW;
 		}
 		base = oi->swbase;
 		break;
@@ -410,7 +410,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
-			return -BCME_BUFTOOSHORT;
+			return -EOVERFLOW;
 		}
 		base = oi->otpgu_base + OTPGU_CI_OFF;
 		break;
@@ -422,7 +422,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
-			return -BCME_BUFTOOSHORT;
+			return -EOVERFLOW;
 		}
 		base = oi->fbase;
 		break;
@@ -434,12 +434,12 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 		}
 		if (*wlen < sz) {
 			*wlen = sz;
-			return -BCME_BUFTOOSHORT;
+			return -EOVERFLOW;
 		}
 		base = oi->hwbase;
 		break;
 	default:
-		return -BCME_BADARG;
+		return -EINVAL;
 	}
 
 	idx = ai_coreidx(oi->sih);
@@ -457,7 +457,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 
 static int ipxotp_nvread(void *oh, char *data, uint *len)
 {
-	return -BCME_UNSUPPORTED;
+	return -ENOTSUPP;
 }
 
 static otp_fn_t ipxotp_fn = {
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 6778c64..d5afa37 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -324,7 +324,7 @@ static int initvars_table(char *start, char *end,
 		char *vp = kmalloc(c, GFP_ATOMIC);
 		ASSERT(vp != NULL);
 		if (!vp)
-			return -BCME_NOMEM;
+			return -ENOMEM;
 		memcpy(vp, start, c);
 		*vars = vp;
 		*count = c;
@@ -353,7 +353,7 @@ static int initvars_flash(si_t *sih, char **base, uint len)
 	/* allocate memory and read in flash */
 	flash = kmalloc(NVRAM_SPACE, GFP_ATOMIC);
 	if (!flash)
-		return -BCME_NOMEM;
+		return -ENOMEM;
 	err = nvram_getall(flash, NVRAM_SPACE);
 	if (err)
 		goto exit;
@@ -372,7 +372,7 @@ static int initvars_flash(si_t *sih, char **base, uint len)
 		/* is there enough room to copy? */
 		copy_len = l - dl + 1;
 		if (len < copy_len) {
-			err = -BCME_BUFTOOSHORT;
+			err = -EOVERFLOW;
 			goto exit;
 		}
 
@@ -384,7 +384,7 @@ static int initvars_flash(si_t *sih, char **base, uint len)
 
 	/* add null string as terminator */
 	if (len < 1) {
-		err = -BCME_BUFTOOSHORT;
+		err = -EOVERFLOW;
 		goto exit;
 	}
 	*vp++ = '\0';
@@ -410,7 +410,7 @@ static int initvars_flash_si(si_t *sih, char **vars, uint *count)
 	base = vp = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
 	ASSERT(vp != NULL);
 	if (!vp)
-		return -BCME_NOMEM;
+		return -ENOMEM;
 
 	err = initvars_flash(sih, &vp, MAXSZ_NVRAM_VARS);
 	if (err == 0)
diff --git a/drivers/staging/brcm80211/util/bcmutils.c b/drivers/staging/brcm80211/util/bcmutils.c
index 385c3fb..457a023 100644
--- a/drivers/staging/brcm80211/util/bcmutils.c
+++ b/drivers/staging/brcm80211/util/bcmutils.c
@@ -503,21 +503,21 @@ int bcm_iovar_lencheck(const bcm_iovar_t *vi, void *arg, int len, bool set)
 	case IOVT_UINT32:
 		/* all integers are s32 sized args at the ioctl interface */
 		if (len < (int)sizeof(int)) {
-			bcmerror = -BCME_BUFTOOSHORT;
+			bcmerror = -EOVERFLOW;
 		}
 		break;
 
 	case IOVT_BUFFER:
 		/* buffer must meet minimum length requirement */
 		if (len < vi->minlen) {
-			bcmerror = -BCME_BUFTOOSHORT;
+			bcmerror = -EOVERFLOW;
 		}
 		break;
 
 	case IOVT_VOID:
 		if (!set) {
 			/* Cannot return nil... */
-			bcmerror = -BCME_UNSUPPORTED;
+			bcmerror = -ENOTSUPP;
 		} else if (len) {
 			/* Set is an action w/o parameters */
 			bcmerror = -BCME_BUFTOOLONG;
@@ -527,7 +527,7 @@ int bcm_iovar_lencheck(const bcm_iovar_t *vi, void *arg, int len, bool set)
 	default:
 		/* unknown type for length check in iovar info */
 		ASSERT(0);
-		bcmerror = -BCME_UNSUPPORTED;
+		bcmerror = -ENOTSUPP;
 	}
 
 	return bcmerror;
diff --git a/drivers/staging/brcm80211/util/nvram/nvram_ro.c b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
index 3361e1a..ab31f2d 100644
--- a/drivers/staging/brcm80211/util/nvram/nvram_ro.c
+++ b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
@@ -89,7 +89,7 @@ int nvram_append(void *si, char *varlst, uint varsz)
 
 	new = kmalloc(bufsz, GFP_ATOMIC);
 	if (new == NULL)
-		return -BCME_NOMEM;
+		return -ENOMEM;
 
 	new->vars = varlst;
 	new->bufsz = bufsz;
@@ -188,7 +188,7 @@ int nvram_getall(char *buf, int count)
 		while ((from < lim) && (*from)) {
 			len = strlen(from) + 1;
 			if (resid < (acc + len))
-				return -BCME_BUFTOOSHORT;
+				return -EOVERFLOW;
 			memcpy(to, from, len);
 			acc += len;
 			from += len;
@@ -200,7 +200,7 @@ int nvram_getall(char *buf, int count)
 		this = this->next;
 	}
 	if (resid < 1)
-		return -BCME_BUFTOOSHORT;
+		return -EOVERFLOW;
 	*buf = '\0';
 	return 0;
 }
-- 
1.7.1


