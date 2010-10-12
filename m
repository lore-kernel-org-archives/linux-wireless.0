Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0JLWK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 18:10:29 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so2776714bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 15:10:28 -0700 (PDT)
From: mike.rapoport@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 6/7] staging: brcm80211: replace MFREE with kfree
Date: Wed, 13 Oct 2010 00:09:12 +0200
Message-Id: <e391ab288f58a18324e5fe9604b75f6333400431.1286920620.git.mike.rapoport@gmail.com>
In-Reply-To: <cover.1286920620.git.mike.rapoport@gmail.com>
References: <cover.1286920620.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    4 +-
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    8 ++--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    4 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   10 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   16 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   32 ++++++------
 drivers/staging/brcm80211/include/linux_osl.h      |    3 -
 drivers/staging/brcm80211/phy/wlc_phy_cmn.c        |    6 +-
 drivers/staging/brcm80211/phy/wlc_phy_lcn.c        |   10 ++--
 drivers/staging/brcm80211/phy/wlc_phy_n.c          |    6 +-
 drivers/staging/brcm80211/sys/wl_mac80211.c        |   18 ++++----
 drivers/staging/brcm80211/sys/wlc_alloc.c          |   50 +++++++------------
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |    5 +-
 drivers/staging/brcm80211/sys/wlc_antsel.c         |    2 +-
 drivers/staging/brcm80211/sys/wlc_bmac.c           |    2 +-
 drivers/staging/brcm80211/sys/wlc_channel.c        |    2 +-
 drivers/staging/brcm80211/sys/wlc_event.c          |    6 +-
 drivers/staging/brcm80211/sys/wlc_mac80211.c       |   19 +++----
 drivers/staging/brcm80211/sys/wlc_phy_shim.c       |    2 +-
 drivers/staging/brcm80211/util/bcmotp.c            |    2 +-
 drivers/staging/brcm80211/util/bcmsrom.c           |   16 +++---
 drivers/staging/brcm80211/util/hnddma.c            |   12 ++---
 drivers/staging/brcm80211/util/linux_osl.c         |    9 ----
 drivers/staging/brcm80211/util/nicpci.c            |    2 +-
 drivers/staging/brcm80211/util/nvram/nvram_ro.c    |    4 +-
 drivers/staging/brcm80211/util/siutils.c           |    4 +-
 28 files changed, 115 insertions(+), 145 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 708575e..bf2aad7 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -92,7 +92,7 @@ int bcmsdh_detach(osl_t *osh, void *sdh)
 			sdioh_detach(osh, bcmsdh->sdioh);
 			bcmsdh->sdioh = NULL;
 		}
-		MFREE(osh, bcmsdh, sizeof(bcmsdh_info_t));
+		kfree(bcmsdh);
 	}
 
 	l_bcmsdh = NULL;
@@ -328,7 +328,7 @@ int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
 			if ((((tmp_ptr - tmp_buf) + 1) & 0xf) == 0)
 				ptr += sprintf((char *)ptr, "\n");
 		}
-		MFREE(bcmsdh->osh, tmp_buf, length);
+		kfree(tmp_buf);
 	}
 
 	return SDIOH_API_SUCCESS(status) ? 0 : BCME_ERROR;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 9be6eb6..47ca271 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -246,7 +246,7 @@ err:
 	if (sdhc) {
 		if (sdhc->sdh)
 			bcmsdh_detach(sdhc->osh, sdhc->sdh);
-		MFREE(osh, sdhc, sizeof(bcmsdh_hc_t));
+		kfree(sdhc);
 	}
 	if (osh)
 		osl_detach(osh);
@@ -283,7 +283,7 @@ int bcmsdh_remove(struct device *dev)
 
 	/* release SDIO Host Controller info */
 	osh = sdhc->osh;
-	MFREE(osh, sdhc, sizeof(bcmsdh_hc_t));
+	kfree(sdhc);
 	osl_detach(osh);
 
 #if !defined(BCMLXSDMMC)
@@ -471,7 +471,7 @@ err:
 	if (sdhc->sdh)
 		bcmsdh_detach(sdhc->osh, sdhc->sdh);
 	if (sdhc)
-		MFREE(osh, sdhc, sizeof(bcmsdh_hc_t));
+		kfree(sdhc);
 	if (osh)
 		osl_detach(osh);
 	return -ENODEV;
@@ -506,7 +506,7 @@ static void __devexit bcmsdh_pci_remove(struct pci_dev *pdev)
 
 	/* release SDIO Host Controller info */
 	osh = sdhc->osh;
-	MFREE(osh, sdhc, sizeof(bcmsdh_hc_t));
+	kfree(sdhc);
 	osl_detach(osh);
 }
 #endif				/* BCMLXSDMMC */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index c54da99..d591278 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -131,7 +131,7 @@ extern sdioh_info_t *sdioh_attach(osl_t *osh, void *bar0, uint irq)
 	sd->osh = osh;
 	if (sdioh_sdmmc_osinit(sd) != 0) {
 		sd_err(("%s:sdioh_sdmmc_osinit() failed\n", __func__));
-		MFREE(sd->osh, sd, sizeof(sdioh_info_t));
+		kfree(sd);
 		return NULL;
 	}
 
@@ -193,7 +193,7 @@ extern SDIOH_API_RC sdioh_detach(osl_t *osh, sdioh_info_t *sd)
 		/* deregister irq */
 		sdioh_sdmmc_osfree(sd);
 
-		MFREE(sd->osh, sd, sizeof(sdioh_info_t));
+		kfree(sd);
 	}
 	return SDIOH_API_RC_SUCCESS;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 7a80bcf..6ee2f48 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -164,7 +164,7 @@ void sdioh_sdmmc_osfree(sdioh_info_t *sd)
 	ASSERT(sd && sd->sdos_info);
 
 	sdos = (struct sdos_info *)sd->sdos_info;
-	MFREE(sd->osh, sdos, sizeof(struct sdos_info));
+	kfree(sdos);
 }
 
 /* Interrupt enable/disable */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 3f8d1fd..2af896d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -427,14 +427,14 @@ int dhd_prot_attach(dhd_pub_t *dhd)
 
 fail:
 	if (cdc != NULL)
-		MFREE(dhd->osh, cdc, sizeof(dhd_prot_t));
+		kfree(cdc);
 	return BCME_NOMEM;
 }
 
 /* ~NOTE~ What if another thread is waiting on the semaphore?  Holding it? */
 void dhd_prot_detach(dhd_pub_t *dhd)
 {
-	MFREE(dhd->osh, dhd->prot, sizeof(dhd_prot_t));
+	kfree(dhd->prot);
 	dhd->prot = NULL;
 }
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 0d17ed0..40004f2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -1052,7 +1052,7 @@ dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 
 fail:
 	if (arg_org)
-		MFREE(dhd->osh, arg_org, strlen(arg) + 1);
+		kfree(arg_org);
 }
 
 void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
@@ -1188,10 +1188,10 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 
 fail:
 	if (arg_org)
-		MFREE(dhd->osh, arg_org, strlen(arg) + 1);
+		kfree(arg_org);
 
 	if (buf)
-		MFREE(dhd->osh, buf, BUF_SIZE);
+		kfree(buf);
 }
 
 void dhd_arp_offload_set(dhd_pub_t *dhd, int arp_mode)
@@ -1406,7 +1406,7 @@ void dhd_iscan_free_buf(void *dhdp, iscan_buf_t *iscan_delete)
 			iscanbuf_free = iscanbuf_cur;
 			iscanbuf_cur = iscanbuf_cur->next;
 			iscanbuf_free->next = 0;
-			MFREE(dhd->osh, iscanbuf_free, sizeof(iscan_buf_t));
+			kfree(iscanbuf_free);
 		}
 		iscan_chain = 0;
 	} else {
@@ -1420,7 +1420,7 @@ void dhd_iscan_free_buf(void *dhdp, iscan_buf_t *iscan_delete)
 			iscanbuf_prv->next = iscan_delete->next;
 
 		iscan_delete->next = 0;
-		MFREE(dhd->osh, iscan_delete, sizeof(iscan_buf_t));
+		kfree(iscan_delete);
 
 		if (!iscanbuf_prv)
 			iscan_chain = 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 27106ab..2d2c7ea 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -747,7 +747,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 		allmulti = cnt ? true : allmulti;
 	}
 
-	MFREE(dhd->pub.osh, buf, buflen);
+	kfree(buf);
 
 	/* Now send the allmulti setting.  This is based on the setting in the
 	 * net_device flags, but might be modified above to be turned on if we
@@ -768,7 +768,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 		DHD_ERROR(("%s: mkiovar failed for allmulti, datalen %d "
 			"buflen %u\n", dhd_ifname(&dhd->pub, ifidx),
 			(int)sizeof(allmulti), buflen));
-		MFREE(dhd->pub.osh, buf, buflen);
+		kfree(buf);
 		return;
 	}
 
@@ -784,7 +784,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 			   dhd_ifname(&dhd->pub, ifidx), ltoh32(allmulti)));
 	}
 
-	MFREE(dhd->pub.osh, buf, buflen);
+	kfree(buf);
 
 	/* Finally, pick up the PROMISC flag as well, like the NIC
 		 driver does */
@@ -921,7 +921,7 @@ static void dhd_op_if(dhd_if_t *ifp)
 			free_netdev(ifp->net);
 
 		dhd->iflist[ifp->idx] = NULL;
-		MFREE(dhd->pub.osh, ifp, sizeof(*ifp));
+		kfree(ifp);
 #ifdef SOFTAP
 		if (ifp->net == ap_net_dev)
 			ap_net_dev = NULL;	/*  NULL  SOFTAP global
@@ -1742,7 +1742,7 @@ done:
 	}
 
 	if (buf)
-		MFREE(dhd->pub.osh, buf, buflen);
+		kfree(buf);
 
 	return OSL_ERROR(bcmerror);
 }
@@ -2367,8 +2367,8 @@ void dhd_detach(dhd_pub_t *dhdp)
 			WAKE_LOCK_DESTROY(dhdp, WAKE_LOCK_LINK_DOWN_TMOUT);
 			WAKE_LOCK_DESTROY(dhdp, WAKE_LOCK_PNO_FIND_TMOUT);
 			free_netdev(ifp->net);
-			MFREE(dhd->pub.osh, ifp, sizeof(*ifp));
-			MFREE(dhd->pub.osh, dhd, sizeof(*dhd));
+			kfree(ifp);
+			kfree(dhd);
 		}
 	}
 }
@@ -2916,7 +2916,7 @@ int write_to_file(dhd_pub_t *dhd, u8 *buf, int size)
 
 exit:
 	/* free buf before return */
-	MFREE(dhd->osh, buf, size);
+	kfree(buf);
 	/* close file before return */
 	if (fp)
 		filp_close(fp, current->files);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index f9605f9..66837a1 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -1927,9 +1927,9 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 
 done:
 	if (mbuffer)
-		MFREE(bus->dhd->osh, mbuffer, msize);
+		kfree(mbuffer);
 	if (str)
-		MFREE(bus->dhd->osh, str, maxstrlen);
+		kfree(str);
 
 	return bcmerror;
 }
@@ -1959,7 +1959,7 @@ static int dhdsdio_mem_dump(dhd_bus_t *bus)
 		if (ret) {
 			printf("%s: Error membytes %d\n", __func__, ret);
 			if (buf)
-				MFREE(bus->dhd->osh, buf, size);
+				kfree(buf);
 			return -1;
 		}
 		printf(".");
@@ -2078,7 +2078,7 @@ int dhdsdio_downloadvars(dhd_bus_t *bus, void *arg, int len)
 
 	/* Free the old ones and replace with passed variables */
 	if (bus->vars)
-		MFREE(bus->dhd->osh, bus->vars, bus->varsz);
+		kfree(bus->vars);
 
 	bus->vars = kmalloc(len, GFP_ATOMIC);
 	bus->varsz = bus->vars ? len : 0;
@@ -2562,10 +2562,10 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 			DHD_ERROR(("%s: Download/Upload/Compare of NVRAM ok.\n",
 				__func__));
 
-		MFREE(bus->dhd->osh, nvram_ularray, varsize);
+		kfree(nvram_ularray);
 #endif				/* DHD_DEBUG */
 
-		MFREE(bus->dhd->osh, vbuffer, varsize);
+		kfree(vbuffer);
 	}
 
 	/* adjust to the user specified RAM */
@@ -5286,7 +5286,7 @@ dhdsdio_probe_attach(struct dhd_bus *bus, osl_t *osh, void *sdh, void *regsva,
 			if (err) {
 				DHD_INFO(("dhdsdio_probe: fn %d cis read "
 					"err %d\n", fn, err));
-				MFREE(osh, cis[fn], SBSDIO_CIS_SIZE_LIMIT);
+				kfree(cis[fn]);
 				break;
 			}
 			dhd_dump_cis(fn, cis[fn]);
@@ -5294,7 +5294,7 @@ dhdsdio_probe_attach(struct dhd_bus *bus, osl_t *osh, void *sdh, void *regsva,
 
 		while (fn-- > 0) {
 			ASSERT(cis[fn]);
-			MFREE(osh, cis[fn], SBSDIO_CIS_SIZE_LIMIT);
+			kfree(cis[fn]);
 		}
 
 		if (err) {
@@ -5400,7 +5400,7 @@ static bool dhdsdio_probe_malloc(dhd_bus_t *bus, osl_t *osh, void *sdh)
 			   __func__, MAX_DATA_BUF));
 		/* release rxbuf which was already located as above */
 		if (!bus->rxblen)
-			MFREE(osh, bus->rxbuf, bus->rxblen);
+			kfree(bus->rxbuf);
 		goto fail;
 	}
 
@@ -5544,7 +5544,7 @@ static void dhdsdio_release(dhd_bus_t *bus, osl_t *osh)
 
 		dhdsdio_release_malloc(bus, osh);
 
-		MFREE(osh, bus, sizeof(dhd_bus_t));
+		kfree(bus);
 	}
 
 	if (osh)
@@ -5561,13 +5561,13 @@ static void dhdsdio_release_malloc(dhd_bus_t *bus, osl_t *osh)
 		return;
 
 	if (bus->rxbuf) {
-		MFREE(osh, bus->rxbuf, bus->rxblen);
+		kfree(bus->rxbuf);
 		bus->rxctl = bus->rxbuf = NULL;
 		bus->rxlen = 0;
 	}
 
 	if (bus->databuf) {
-		MFREE(osh, bus->databuf, MAX_DATA_BUF);
+		kfree(bus->databuf);
 		bus->databuf = NULL;
 	}
 }
@@ -5587,7 +5587,7 @@ static void dhdsdio_release_dongle(dhd_bus_t *bus, osl_t *osh)
 		dhdsdio_clkctl(bus, CLK_NONE, FALSE);
 		si_detach(bus->sih);
 		if (bus->vars && bus->varsz)
-			MFREE(osh, bus->vars, bus->varsz);
+			kfree(bus->vars);
 		bus->vars = NULL;
 	}
 
@@ -5710,7 +5710,7 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 			DHD_ERROR(("%s: Download/Upload/Compare succeeded.\n",
 				__func__));
 
-		MFREE(bus->dhd->osh, ularray, bus->ramsize);
+		kfree(ularray);
 	}
 #endif				/* DHD_DEBUG */
 
@@ -5758,7 +5758,7 @@ static int dhdsdio_download_code_file(struct dhd_bus *bus, char *fw_path)
 
 err:
 	if (memblock)
-		MFREE(bus->dhd->osh, memblock, MEMBLOCK + DHD_SDALIGN);
+		kfree(memblock);
 
 	if (image)
 		dhd_os_close_image(image);
@@ -5898,7 +5898,7 @@ static int dhdsdio_download_nvram(struct dhd_bus *bus)
 
 err:
 	if (memblock)
-		MFREE(bus->dhd->osh, memblock, MEMBLOCK);
+		kfree(memblock);
 
 	if (image)
 		dhd_os_close_image(image);
diff --git a/drivers/staging/brcm80211/include/linux_osl.h b/drivers/staging/brcm80211/include/linux_osl.h
index 0e00188..ec7fc1f 100644
--- a/drivers/staging/brcm80211/include/linux_osl.h
+++ b/drivers/staging/brcm80211/include/linux_osl.h
@@ -94,9 +94,6 @@ typedef struct {
 
 #define BUS_SWAP32(v)		(v)
 
-#define MFREE(osh, addr, size)	osl_mfree((osh), (addr), (size))
-extern void osl_mfree(osl_t *osh, void *addr, uint size);
-
 #define	DMA_CONSISTENT_ALIGN	osl_dma_consistent_align()
 extern uint osl_dma_consistent_align(void);
 extern void *osl_dma_alloc_consistent(osl_t *osh, uint size, u16 align,
diff --git a/drivers/staging/brcm80211/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/phy/wlc_phy_cmn.c
index 739fe71..ac9ff5e 100644
--- a/drivers/staging/brcm80211/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/phy/wlc_phy_cmn.c
@@ -599,7 +599,7 @@ void wlc_phy_shared_detach(shared_phy_t *phy_sh)
 		if (phy_sh->phy_head) {
 			ASSERT(!phy_sh->phy_head);
 		}
-		MFREE(osh, phy_sh, sizeof(shared_phy_t));
+		kfree(phy_sh);
 	}
 }
 
@@ -780,7 +780,7 @@ wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype, char *vars
 
  err:
 	if (pi)
-		MFREE(sh->osh, pi, sizeof(phy_info_t));
+		kfree(pi);
 	return NULL;
 }
 
@@ -808,7 +808,7 @@ void wlc_phy_detach(wlc_phy_t *pih)
 		if (pi->pi_fptr.detach)
 			(pi->pi_fptr.detach) (pi);
 
-		MFREE(pi->sh->osh, pi, sizeof(phy_info_t));
+		kfree(pi);
 	}
 }
 
diff --git a/drivers/staging/brcm80211/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
index 1a70f9a..7b3ff3e 100644
--- a/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
@@ -2061,7 +2061,7 @@ wlc_lcnphy_tx_iqlo_cal(phy_info_t *pi,
 
  cleanup:
 	wlc_lcnphy_tx_iqlo_loopback_cleanup(pi, values_to_save);
-	MFREE(pi->sh->osh, values_to_save, 20 * sizeof(u16));
+	kfree(values_to_save);
 
 	if (!keep_tone)
 		wlc_lcnphy_stop_tx_tone(pi);
@@ -3437,7 +3437,7 @@ wlc_lcnphy_rx_iq_cal(phy_info_t *pi, const lcnphy_rx_iqcomp_t *iqcomp,
 	}
 
  cal_done:
-	MFREE(pi->sh->osh, ptr, 131 * sizeof(s16));
+	kfree(ptr);
 	return result;
 }
 
@@ -4212,8 +4212,8 @@ wlc_lcnphy_a1(phy_info_t *pi, int cal_type, int num_levels, int step_size_lg2)
 	write_phy_reg(pi, 0x4d8, phy_c30);
 	write_radio_reg(pi, RADIO_2064_REG026, phy_c31);
 
-	MFREE(pi->sh->osh, phy_c32, 20 * sizeof(u16));
-	MFREE(pi->sh->osh, ptr, 131 * sizeof(s16));
+	kfree(phy_c32);
+	kfree(ptr);
 }
 
 static void
@@ -5047,7 +5047,7 @@ void wlc_phy_txpower_recalc_target_lcnphy(phy_info_t *pi)
 
 void wlc_phy_detach_lcnphy(phy_info_t *pi)
 {
-	MFREE(pi->sh->osh, pi->u.pi_lcnphy, sizeof(phy_info_lcnphy_t));
+	kfree(pi->u.pi_lcnphy);
 }
 
 bool wlc_phy_attach_lcnphy(phy_info_t *pi)
diff --git a/drivers/staging/brcm80211/phy/wlc_phy_n.c b/drivers/staging/brcm80211/phy/wlc_phy_n.c
index 529e06c..b0ae73e 100644
--- a/drivers/staging/brcm80211/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/phy/wlc_phy_n.c
@@ -22382,7 +22382,7 @@ wlc_phy_gen_load_samples_nphy(phy_info_t *pi, u32 f_kHz, u16 max_val,
 	wlc_phy_loadsampletable_nphy(pi, tone_buf, num_samps);
 
 	if (tone_buf != NULL)
-		MFREE(pi->sh->osh, tone_buf, sizeof(cs32) * tbl_len);
+		kfree(tone_buf);
 
 	return num_samps;
 }
@@ -22430,7 +22430,7 @@ wlc_phy_loadsampletable_nphy(phy_info_t *pi, cs32 *tone_buf,
 				 data_buf);
 
 	if (data_buf != NULL)
-		MFREE(pi->sh->osh, data_buf, sizeof(u32) * num_samps);
+		kfree(data_buf);
 
 	if (pi->phyhang_avoid)
 		wlc_phy_stay_in_carriersearch_nphy(pi, FALSE);
@@ -26768,7 +26768,7 @@ wlc_phy_a1_nphy(phy_info_t *pi, u8 core, u32 winsz, u32 start,
 				  PHY_CORE_0) ? NPHY_TBL_ID_EPSILONTBL0 :
 				 NPHY_TBL_ID_EPSILONTBL1, sz, start, 32, dst);
 
-	MFREE(pi->sh->osh, buf, 2 * sizeof(u32) * NPHY_PAPD_EPS_TBL_SIZE);
+	kfree(buf);
 }
 
 static void
diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index bcd6e69..ee19502 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -1582,9 +1582,9 @@ void wl_free(wl_info_t *wl)
 		next = t->next;
 #ifdef BCMDBG
 		if (t->name)
-			MFREE(wl->osh, t->name, strlen(t->name) + 1);
+			kfree(t->name);
 #endif
-		MFREE(wl->osh, t, sizeof(wl_timer_t));
+		kfree(t);
 	}
 
 	osh = wl->osh;
@@ -1668,7 +1668,7 @@ wl_schedule_task(wl_info_t *wl, void (*fn) (struct wl_task *task),
 
 	if (!schedule_work(&task->work)) {
 		WL_ERROR(("wl%d: schedule_work() failed\n", wl->pub->unit));
-		MFREE(wl->osh, task, sizeof(wl_task_t));
+		kfree(task);
 		return -ENOMEM;
 	}
 
@@ -1984,9 +1984,9 @@ void wl_free_timer(wl_info_t *wl, wl_timer_t *t)
 		wl->timers = wl->timers->next;
 #ifdef BCMDBG
 		if (t->name)
-			MFREE(wl->osh, t->name, strlen(t->name) + 1);
+			kfree(t->name);
 #endif
-		MFREE(wl->osh, t, sizeof(wl_timer_t));
+		kfree(t);
 		return;
 
 	}
@@ -1997,9 +1997,9 @@ void wl_free_timer(wl_info_t *wl, wl_timer_t *t)
 			tmp->next = t->next;
 #ifdef BCMDBG
 			if (t->name)
-				MFREE(wl->osh, t->name, strlen(t->name) + 1);
+				kfree(t->name);
 #endif
-			MFREE(wl->osh, t, sizeof(wl_timer_t));
+			kfree(t);
 			return;
 		}
 		tmp = tmp->next;
@@ -2199,7 +2199,7 @@ static void wl_rpcq_dispatch(struct wl_task *task)
 
 	RPCQ_UNLOCK(wl, flags);
 
-	MFREE(wl->osh, task, sizeof(wl_task_t));
+	kfree(task);
 	atomic_dec(&wl->callbacks);
 }
 
@@ -2259,7 +2259,7 @@ static void wl_timer_task(wl_task_t *task)
 	wl_timer_t *t = (wl_timer_t *) task->context;
 
 	_wl_timer(t);
-	MFREE(t->wl->osh, task, sizeof(wl_task_t));
+	kfree(task);
 
 	/* This dec is for the task_schedule. The timer related
 	 * callback is decremented in _wl_timer
diff --git a/drivers/staging/brcm80211/sys/wlc_alloc.c b/drivers/staging/brcm80211/sys/wlc_alloc.c
index feb9a05..522f463 100644
--- a/drivers/staging/brcm80211/sys/wlc_alloc.c
+++ b/drivers/staging/brcm80211/sys/wlc_alloc.c
@@ -106,15 +106,13 @@ static void wlc_pub_mfree(osl_t *osh, wlc_pub_t *pub)
 		return;
 
 	if (pub->multicast)
-		MFREE(osh, pub->multicast,
-		      (sizeof(struct ether_addr) * MAXMULTILIST));
-
+		kfree(pub->multicast);
 	if (pub->tunables) {
-		MFREE(osh, pub->tunables, sizeof(wlc_tunables_t));
+		kfree(pub->tunables);
 		pub->tunables = NULL;
 	}
 
-	MFREE(osh, pub, sizeof(wlc_pub_t));
+	kfree(pub);
 }
 
 wlc_bsscfg_t *wlc_bsscfg_malloc(osl_t *osh, uint unit)
@@ -143,22 +141,19 @@ void wlc_bsscfg_mfree(osl_t *osh, wlc_bsscfg_t *cfg)
 		return;
 
 	if (cfg->maclist) {
-		MFREE(osh, cfg->maclist,
-		      (int)(offsetof(struct maclist, ea) +
-			    cfg->nmac * ETHER_ADDR_LEN));
+		kfree(cfg->maclist);
 		cfg->maclist = NULL;
 	}
 
 	if (cfg->current_bss != NULL) {
 		wlc_bss_info_t *current_bss = cfg->current_bss;
 		if (current_bss->bcn_prb != NULL)
-			MFREE(osh, current_bss->bcn_prb,
-			      current_bss->bcn_prb_len);
-		MFREE(osh, current_bss, sizeof(wlc_bss_info_t));
+			kfree(current_bss->bcn_prb);
+		kfree(current_bss);
 		cfg->current_bss = NULL;
 	}
 
-	MFREE(osh, cfg, sizeof(wlc_bsscfg_t));
+	kfree(cfg);
 }
 
 void wlc_bsscfg_ID_assign(wlc_info_t *wlc, wlc_bsscfg_t *bsscfg)
@@ -313,12 +308,12 @@ void wlc_detach_mfree(wlc_info_t *wlc, osl_t *osh)
 		return;
 
 	if (wlc->modulecb) {
-		MFREE(osh, wlc->modulecb, sizeof(modulecb_t) * WLC_MAXMODULES);
+		kfree(wlc->modulecb);
 		wlc->modulecb = NULL;
 	}
 
 	if (wlc->default_bss) {
-		MFREE(osh, wlc->default_bss, sizeof(wlc_bss_info_t));
+		kfree(wlc->default_bss);
 		wlc->default_bss = NULL;
 	}
 	if (wlc->cfg) {
@@ -327,36 +322,30 @@ void wlc_detach_mfree(wlc_info_t *wlc, osl_t *osh)
 	}
 
 	if (wlc->pkt_callback && wlc->pub && wlc->pub->tunables) {
-		MFREE(osh,
-		      wlc->pkt_callback,
-		      sizeof(pkt_cb_t) * (wlc->pub->tunables->maxpktcb + 1));
+		kfree(wlc->pkt_callback);
 		wlc->pkt_callback = NULL;
 	}
 
 	if (wlc->wsec_def_keys[0])
-		MFREE(osh, wlc->wsec_def_keys[0],
-		      (sizeof(wsec_key_t) * WLC_DEFAULT_KEYS));
-
+		kfree(wlc->wsec_def_keys[0]);
 	if (wlc->protection) {
-		MFREE(osh, wlc->protection, sizeof(wlc_protection_t));
+		kfree(wlc->protection);
 		wlc->protection = NULL;
 	}
 
 	if (wlc->stf) {
-		MFREE(osh, wlc->stf, sizeof(wlc_stf_t));
+		kfree(wlc->stf);
 		wlc->stf = NULL;
 	}
 
 	if (wlc->bandstate[0])
-		MFREE(osh, wlc->bandstate[0], (sizeof(wlcband_t) * MAXBANDS));
+		kfree(wlc->bandstate[0]);
 
 	if (wlc->corestate) {
 		if (wlc->corestate->macstat_snapshot) {
-			MFREE(osh, wlc->corestate->macstat_snapshot,
-			      sizeof(macstat_t));
-			wlc->corestate->macstat_snapshot = NULL;
+	kfree(wlc->corestate->macstat_snapshot);			wlc->corestate->macstat_snapshot = NULL;
 		}
-		MFREE(osh, wlc->corestate, sizeof(wlccore_t));
+		kfree(wlc->corestate);
 		wlc->corestate = NULL;
 	}
 
@@ -369,18 +358,17 @@ void wlc_detach_mfree(wlc_info_t *wlc, osl_t *osh)
 	if (wlc->hw) {
 #ifdef WLC_LOW
 		if (wlc->hw->bandstate[0]) {
-			MFREE(osh, wlc->hw->bandstate[0],
-			      (sizeof(wlc_hwband_t) * MAXBANDS));
+			kfree(wlc->hw->bandstate[0]);
 			wlc->hw->bandstate[0] = NULL;
 		}
 #endif
 
 		/* free hw struct */
-		MFREE(osh, wlc->hw, sizeof(wlc_hw_info_t));
+		kfree(wlc->hw);
 		wlc->hw = NULL;
 	}
 
 	/* free the wlc */
-	MFREE(osh, wlc, sizeof(wlc_info_t));
+	kfree(wlc);
 	wlc = NULL;
 }
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index 8470baa..7f22c81 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -242,13 +242,12 @@ void wlc_ampdu_detach(ampdu_info_t *ampdu)
 	/* free all ini's which were to be freed on callbacks which were never called */
 	for (i = 0; i < AMPDU_INI_FREE; i++) {
 		if (ampdu->ini_free[i]) {
-			MFREE(ampdu->wlc->osh, ampdu->ini_free[i],
-			      sizeof(scb_ampdu_tid_ini_t));
+			kfree(ampdu->ini_free[i]);
 		}
 	}
 
 	wlc_module_unregister(ampdu->wlc->pub, "ampdu", ampdu);
-	MFREE(ampdu->wlc->osh, ampdu, sizeof(ampdu_info_t));
+	kfree(ampdu);
 }
 
 void scb_ampdu_cleanup(ampdu_info_t *ampdu, struct scb *scb)
diff --git a/drivers/staging/brcm80211/sys/wlc_antsel.c b/drivers/staging/brcm80211/sys/wlc_antsel.c
index e7e7b6d..fafef13 100644
--- a/drivers/staging/brcm80211/sys/wlc_antsel.c
+++ b/drivers/staging/brcm80211/sys/wlc_antsel.c
@@ -158,7 +158,7 @@ void wlc_antsel_detach(antsel_info_t *asi)
 	if (!asi)
 		return;
 
-	MFREE(asi->pub->osh, asi, sizeof(antsel_info_t));
+	kfree(asi);
 }
 
 void wlc_antsel_init(antsel_info_t *asi)
diff --git a/drivers/staging/brcm80211/sys/wlc_bmac.c b/drivers/staging/brcm80211/sys/wlc_bmac.c
index afbbfad..9544258 100644
--- a/drivers/staging/brcm80211/sys/wlc_bmac.c
+++ b/drivers/staging/brcm80211/sys/wlc_bmac.c
@@ -1106,7 +1106,7 @@ int wlc_bmac_detach(wlc_info_t *wlc)
 
 	/* free vars */
 	if (wlc_hw->vars) {
-		MFREE(wlc_hw->osh, wlc_hw->vars, wlc_hw->vars_size);
+		kfree(wlc_hw->vars);
 		wlc_hw->vars = NULL;
 	}
 
diff --git a/drivers/staging/brcm80211/sys/wlc_channel.c b/drivers/staging/brcm80211/sys/wlc_channel.c
index b9395d6..a3de0e2 100644
--- a/drivers/staging/brcm80211/sys/wlc_channel.c
+++ b/drivers/staging/brcm80211/sys/wlc_channel.c
@@ -650,7 +650,7 @@ wlc_cm_info_t *wlc_channel_mgr_attach(wlc_info_t *wlc)
 void wlc_channel_mgr_detach(wlc_cm_info_t *wlc_cm)
 {
 	if (wlc_cm)
-		MFREE(wlc_cm->pub->osh, wlc_cm, sizeof(wlc_cm_info_t));
+		kfree(wlc_cm);
 }
 
 const char *wlc_channel_country_abbrev(wlc_cm_info_t *wlc_cm)
diff --git a/drivers/staging/brcm80211/sys/wlc_event.c b/drivers/staging/brcm80211/sys/wlc_event.c
index 549ca0a..91a57e0 100644
--- a/drivers/staging/brcm80211/sys/wlc_event.c
+++ b/drivers/staging/brcm80211/sys/wlc_event.c
@@ -71,7 +71,7 @@ wlc_eventq_t *wlc_eventq_attach(wlc_pub_t *pub, struct wlc_info *wlc, void *wl,
 	if (!eq->timer) {
 		WL_ERROR(("wl%d: wlc_eventq_attach: timer failed\n",
 			  pub->unit));
-		MFREE(eq->pub->osh, eq, sizeof(wlc_eventq_t));
+		kfree(eq);
 		return NULL;
 	}
 
@@ -93,7 +93,7 @@ int wlc_eventq_detach(wlc_eventq_t *eq)
 	}
 
 	ASSERT(wlc_eventq_avail(eq) == FALSE);
-	MFREE(eq->pub->osh, eq, sizeof(wlc_eventq_t));
+	kfree(eq);
 	return 0;
 }
 
@@ -135,7 +135,7 @@ void wlc_event_free(wlc_eventq_t *eq, wlc_event_t *e)
 {
 	ASSERT(e->data == NULL);
 	ASSERT(e->next == NULL);
-	MFREE(eq->pub->osh, e, sizeof(wlc_event_t));
+	kfree(e);
 }
 
 void wlc_eventq_enq(wlc_eventq_t *eq, wlc_event_t *e)
diff --git a/drivers/staging/brcm80211/sys/wlc_mac80211.c b/drivers/staging/brcm80211/sys/wlc_mac80211.c
index 464bd63..ee14c82 100644
--- a/drivers/staging/brcm80211/sys/wlc_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wlc_mac80211.c
@@ -2249,8 +2249,7 @@ int wlc_bmac_detach(wlc_info_t *wlc)
 
 	for (idx = 0; idx < MAXBANDS; idx++)
 		if (wlc->bandstate[idx]->pi) {
-			osl_mfree(wlc->osh, wlc->bandstate[idx]->pi,
-				  sizeof(wlc_phy_t));
+			kfree(wlc->bandstate[idx]->pi);
 			wlc->bandstate[idx]->pi = NULL;
 		}
 
@@ -2337,15 +2336,14 @@ uint wlc_detach(wlc_info_t *wlc)
 	 * references the wlc->hw->vars which is freed in wlc_bmac_detach()
 	 */
 	if (wlc->pub->vars) {
-		osl_mfree(wlc->osh, wlc->pub->vars, wlc->vars_size);
+		kfree(wlc->pub->vars);
 		wlc->pub->vars = NULL;
 	}
 #endif
 
 #ifdef BCMDBG
 	if (wlc->country_ie_override) {
-		osl_mfree(wlc->osh, wlc->country_ie_override,
-			  wlc->country_ie_override->len + TLV_HDR_LEN);
+		kfree(wlc->country_ie_override);
 		wlc->country_ie_override = NULL;
 	}
 #endif				/* BCMDBG */
@@ -2356,7 +2354,7 @@ uint wlc_detach(wlc_info_t *wlc)
 		prev = ptr = wlc->dumpcb_head;
 		while (ptr) {
 			ptr = prev->next;
-			osl_mfree(wlc->osh, prev, sizeof(dumpcb_t));
+			kfree(prev);
 			prev = ptr;
 		}
 		wlc->dumpcb_head = NULL;
@@ -7191,10 +7189,9 @@ void wlc_bss_list_free(wlc_info_t *wlc, wlc_bss_list_t *bss_list)
 		bi = bss_list->ptrs[index];
 		if (bi) {
 			if (bi->bcn_prb) {
-				osl_mfree(wlc->osh, bi->bcn_prb,
-					  bi->bcn_prb_len);
+				kfree(bi->bcn_prb);
 			}
-			osl_mfree(wlc->osh, bi, sizeof(wlc_bss_info_t));
+			kfree(bi);
 			bss_list->ptrs[index] = NULL;
 		}
 	}
@@ -8179,7 +8176,7 @@ static void wlc_process_eventq(void *arg)
 		/* Perform OS specific event processing */
 		wl_event(wlc->wl, etmp->event.ifname, etmp);
 		if (etmp->data) {
-			osl_mfree(wlc->osh, etmp->data, etmp->event.datalen);
+			kfree(etmp->data);
 			etmp->data = NULL;
 		}
 		wlc_event_free(wlc->eventq, etmp);
@@ -8677,5 +8674,5 @@ static void wlc_txq_free(wlc_info_t *wlc, osl_t *osh, wlc_txq_info_t *qi)
 			p->next = p->next->next;
 	}
 
-	osl_mfree(osh, qi, sizeof(wlc_txq_info_t));
+	kfree(qi);
 }
diff --git a/drivers/staging/brcm80211/sys/wlc_phy_shim.c b/drivers/staging/brcm80211/sys/wlc_phy_shim.c
index 57acd30..6980935 100644
--- a/drivers/staging/brcm80211/sys/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/sys/wlc_phy_shim.c
@@ -83,7 +83,7 @@ void wlc_phy_shim_detach(wlc_phy_shim_info_t *physhim)
 	if (!physhim)
 		return;
 
-	MFREE(physhim->wlc_hw->osh, physhim, sizeof(wlc_phy_shim_info_t));
+	kfree(physhim);
 }
 
 struct wlapi_timer *wlapi_init_timer(wlc_phy_shim_info_t *physhim,
diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/util/bcmotp.c
index 307cb00..d7c6fc3 100644
--- a/drivers/staging/brcm80211/util/bcmotp.c
+++ b/drivers/staging/brcm80211/util/bcmotp.c
@@ -842,7 +842,7 @@ static int hndotp_nvread(void *oh, char *data, uint *len)
 
  out:
 	if (rawotp)
-		MFREE(si_osh(oi->sih), rawotp, lim);
+		kfree(rawotp);
 	si_setcoreidx(oi->sih, idx);
 
 	return rc;
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 377831d..3985fbe 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -1399,7 +1399,7 @@ int srom_parsecis(osl_t *osh, u8 *pcis[], uint ciscnt, char **vars, uint *count)
 	ASSERT(b.buf - base <= MAXSZ_NVRAM_VARS);
 	err = initvars_table(osh, base, b.buf, vars, count);
 
-	MFREE(osh, base, MAXSZ_NVRAM_VARS);
+	kfree(base);
 	return err;
 }
 
@@ -1519,7 +1519,7 @@ static int otp_read_pci(osl_t *osh, si_t *sih, u16 *buf, uint bufsz)
 	bcopy(otp, buf, bufsz);
 
 	if (otp)
-		MFREE(osh, otp, OTP_SZ_MAX);
+		kfree(otp);
 
 	/* Check CRC */
 	if (buf[0] == 0xffff) {
@@ -1626,7 +1626,7 @@ static int initvars_flash(si_t *sih, osl_t *osh, char **base, uint len)
 
 	*base = vp;
 
- exit:	MFREE(osh, flash, NVRAM_SPACE);
+ exit:	kfree(flash);
 	return err;
 }
 
@@ -1652,7 +1652,7 @@ static int initvars_flash_si(si_t *sih, char **vars, uint *count)
 	if (err == 0)
 		err = initvars_table(osh, base, vp, vars, count);
 
-	MFREE(osh, base, MAXSZ_NVRAM_VARS);
+	kfree(base);
 
 	return err;
 }
@@ -1977,9 +1977,9 @@ static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count)
 
  errout:
 	if (base)
-		MFREE(osh, base, MAXSZ_NVRAM_VARS);
+		kfree(base);
 
-	MFREE(osh, srom, SROM_MAX);
+	kfree(srom);
 	return err;
 }
 
@@ -2006,7 +2006,7 @@ static int initvars_cis_sdio(osl_t *osh, char **vars, uint *count)
 
 		if (bcmsdh_cis_read(NULL, fn, cis[fn], SBSDIO_CIS_SIZE_LIMIT) !=
 		    0) {
-			MFREE(osh, cis[fn], SBSDIO_CIS_SIZE_LIMIT);
+			kfree(cis[fn]);
 			rc = -2;
 			break;
 		}
@@ -2016,7 +2016,7 @@ static int initvars_cis_sdio(osl_t *osh, char **vars, uint *count)
 		rc = srom_parsecis(osh, cis, fn, vars, count);
 
 	while (fn-- > 0)
-		MFREE(osh, cis[fn], SBSDIO_CIS_SIZE_LIMIT);
+		kfree(cis[fn]);
 
 	return rc;
 }
diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/util/hnddma.c
index 2d915f0..c6a8206 100644
--- a/drivers/staging/brcm80211/util/hnddma.c
+++ b/drivers/staging/brcm80211/util/hnddma.c
@@ -722,22 +722,20 @@ static void _dma_detach(dma_info_t *di)
 
 	/* free packet pointer vectors */
 	if (di->txp)
-		MFREE(di->osh, (void *)di->txp, (di->ntxd * sizeof(void *)));
+		kfree((void *)di->txp);
 	if (di->rxp)
-		MFREE(di->osh, (void *)di->rxp, (di->nrxd * sizeof(void *)));
+		kfree((void *)di->rxp);
 
 	/* free tx packet DMA handles */
 	if (di->txp_dmah)
-		MFREE(di->osh, (void *)di->txp_dmah,
-		      di->ntxd * sizeof(hnddma_seg_map_t));
+		kfree(di->txp_dmah);
 
 	/* free rx packet DMA handles */
 	if (di->rxp_dmah)
-		MFREE(di->osh, (void *)di->rxp_dmah,
-		      di->nrxd * sizeof(hnddma_seg_map_t));
+		kfree(di->rxp_dmah);
 
 	/* free our private info structure */
-	MFREE(di->osh, (void *)di, sizeof(dma_info_t));
+	kfree((void *)di);
 
 }
 
diff --git a/drivers/staging/brcm80211/util/linux_osl.c b/drivers/staging/brcm80211/util/linux_osl.c
index 43ac48d..876d72f 100644
--- a/drivers/staging/brcm80211/util/linux_osl.c
+++ b/drivers/staging/brcm80211/util/linux_osl.c
@@ -285,15 +285,6 @@ uint osl_pci_slot(osl_t *osh)
 	return PCI_SLOT(((struct pci_dev *)osh->pdev)->devfn);
 }
 
-void osl_mfree(osl_t *osh, void *addr, uint size)
-{
-	if (osh) {
-		ASSERT(osh->magic == OS_HANDLE_MAGIC);
-		osh->malloced -= size;
-	}
-	kfree(addr);
-}
-
 uint osl_dma_consistent_align(void)
 {
 	return PAGE_SIZE;
diff --git a/drivers/staging/brcm80211/util/nicpci.c b/drivers/staging/brcm80211/util/nicpci.c
index d769659..c1e26d9 100644
--- a/drivers/staging/brcm80211/util/nicpci.c
+++ b/drivers/staging/brcm80211/util/nicpci.c
@@ -144,7 +144,7 @@ void pcicore_deinit(void *pch)
 
 	if (pi == NULL)
 		return;
-	MFREE(pi->osh, pi, sizeof(pcicore_info_t));
+	kfree(pi);
 }
 
 /* return cap_offset if requested capability exists in the PCI config space */
diff --git a/drivers/staging/brcm80211/util/nvram/nvram_ro.c b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
index f0470a7..7c5f88d 100644
--- a/drivers/staging/brcm80211/util/nvram/nvram_ro.c
+++ b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
@@ -116,11 +116,11 @@ void nvram_exit(void *si)
 	this = vars;
 
 	if (this)
-		MFREE(si_osh(sih), this->vars, this->size);
+		kfree(this->vars);
 
 	while (this) {
 		next = this->next;
-		MFREE(si_osh(sih), this, this->bufsz);
+		kfree(this);
 		this = next;
 	}
 	vars = NULL;
diff --git a/drivers/staging/brcm80211/util/siutils.c b/drivers/staging/brcm80211/util/siutils.c
index b2423c7..906cae4 100644
--- a/drivers/staging/brcm80211/util/siutils.c
+++ b/drivers/staging/brcm80211/util/siutils.c
@@ -96,7 +96,7 @@ si_t *si_attach(uint devid, osl_t *osh, void *regs, uint bustype, void *sdh,
 
 	if (si_doattach(sii, devid, osh, regs, bustype, sdh, vars, varsz) ==
 	    NULL) {
-		MFREE(osh, sii, sizeof(si_info_t));
+		kfree(sii);
 		return NULL;
 	}
 	sii->vars = vars ? *vars : NULL;
@@ -728,7 +728,7 @@ void si_detach(si_t *sih)
 #if !defined(BCMBUSTYPE) || (BCMBUSTYPE == SI_BUS)
 	if (sii != &ksii)
 #endif				/* !BCMBUSTYPE || (BCMBUSTYPE == SI_BUS) */
-		MFREE(sii->osh, sii, sizeof(si_info_t));
+		kfree(sii);
 }
 
 void *si_osh(si_t *sih)
-- 
1.6.4.4

