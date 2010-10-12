Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab0JLWKL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 18:10:11 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so2776714bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 15:10:10 -0700 (PDT)
From: mike.rapoport@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 4/7] staging: brcm80211: replace MALLOC() with k[zm]alloc
Date: Wed, 13 Oct 2010 00:09:10 +0200
Message-Id: <4bf952e3344c16a253aab8c5a6b41dc9265a842a.1286920620.git.mike.rapoport@gmail.com>
In-Reply-To: <cover.1286920620.git.mike.rapoport@gmail.com>
References: <cover.1286920620.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c        |    5 +--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    6 +--
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |    3 +-
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |    3 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |    8 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   10 +++---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   39 ++++++++++----------
 drivers/staging/brcm80211/include/linux_osl.h      |    2 -
 drivers/staging/brcm80211/phy/wlc_phy_cmn.c        |    6 +--
 drivers/staging/brcm80211/phy/wlc_phy_lcn.c        |   13 +++----
 drivers/staging/brcm80211/phy/wlc_phy_n.c          |    6 ++--
 drivers/staging/brcm80211/sys/wl_mac80211.c        |    6 ++--
 drivers/staging/brcm80211/sys/wlc_alloc.c          |    4 +--
 drivers/staging/brcm80211/sys/wlc_ampdu.c          |    3 +-
 drivers/staging/brcm80211/sys/wlc_antsel.c         |    4 +--
 drivers/staging/brcm80211/sys/wlc_channel.c        |    3 +-
 drivers/staging/brcm80211/sys/wlc_event.c          |    7 +---
 drivers/staging/brcm80211/sys/wlc_phy_shim.c       |    4 +--
 drivers/staging/brcm80211/util/bcmotp.c            |    2 +-
 drivers/staging/brcm80211/util/bcmsrom.c           |   20 ++++------
 drivers/staging/brcm80211/util/hnddma.c            |   16 +++------
 drivers/staging/brcm80211/util/linux_osl.c         |   20 ----------
 drivers/staging/brcm80211/util/nicpci.c            |    4 +--
 drivers/staging/brcm80211/util/nvram/nvram_ro.c    |    5 ++-
 drivers/staging/brcm80211/util/siutils.c           |    2 +-
 26 files changed, 74 insertions(+), 129 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index 1b597e1..708575e 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -58,12 +58,11 @@ bcmsdh_info_t *bcmsdh_attach(osl_t *osh, void *cfghdl, void **regsva, uint irq)
 {
 	bcmsdh_info_t *bcmsdh;
 
-	bcmsdh = (bcmsdh_info_t *) MALLOC(osh, sizeof(bcmsdh_info_t));
+	bcmsdh = kzalloc(sizeof(bcmsdh_info_t), GFP_ATOMIC);
 	if (bcmsdh == NULL) {
 		BCMSDH_ERROR(("bcmsdh_attach: out of memory"));
 		return NULL;
 	}
-	bzero((char *)bcmsdh, sizeof(bcmsdh_info_t));
 
 	/* save the handler locally */
 	l_bcmsdh = bcmsdh;
@@ -317,7 +316,7 @@ int bcmsdh_cis_read(void *sdh, uint func, u8 * cis, uint length)
 	if (ascii) {
 		/* Move binary bits to tmp and format them
 			 into the provided buffer. */
-		tmp_buf = (u8 *) MALLOC(bcmsdh->osh, length);
+		tmp_buf = kmalloc(length, GFP_ATOMIC);
 		if (tmp_buf == NULL) {
 			BCMSDH_ERROR(("%s: out of memory\n", __func__));
 			return BCME_NOMEM;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index c6b9adc..9be6eb6 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -195,12 +195,11 @@ int bcmsdh_probe(struct device *dev)
 		SDLX_MSG(("%s: osl_attach failed\n", __func__));
 		goto err;
 	}
-	sdhc = MALLOC(osh, sizeof(bcmsdh_hc_t));
+	sdhc = kzalloc(sizeof(bcmsdh_hc_t), GFP_ATOMIC);
 	if (!sdhc) {
 		SDLX_MSG(("%s: out of memory\n", __func__));
 		goto err;
 	}
-	bzero(sdhc, sizeof(bcmsdh_hc_t));
 	sdhc->osh = osh;
 
 	sdhc->dev = (void *)dev;
@@ -427,12 +426,11 @@ bcmsdh_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		SDLX_MSG(("%s: osl_attach failed\n", __func__));
 		goto err;
 	}
-	sdhc = MALLOC(osh, sizeof(bcmsdh_hc_t));
+	sdhc = kzalloc(sizeof(bcmsdh_hc_t), GFP_ATOMIC);
 	if (!sdhc) {
 		SDLX_MSG(("%s: out of memory\n", __func__));
 		goto err;
 	}
-	bzero(sdhc, sizeof(bcmsdh_hc_t));
 	sdhc->osh = osh;
 
 	sdhc->dev = pdev;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index b8003db..c54da99 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -123,12 +123,11 @@ extern sdioh_info_t *sdioh_attach(osl_t *osh, void *bar0, uint irq)
 		return NULL;
 	}
 
-	sd = (sdioh_info_t *) MALLOC(osh, sizeof(sdioh_info_t));
+	sd = kzalloc(sizeof(sdioh_info_t), GFP_ATOMIC);
 	if (sd == NULL) {
 		sd_err(("sdioh_attach: out of memory\n"));
 		return NULL;
 	}
-	bzero((char *)sd, sizeof(sdioh_info_t));
 	sd->osh = osh;
 	if (sdioh_sdmmc_osinit(sd) != 0) {
 		sd_err(("%s:sdioh_sdmmc_osinit() failed\n", __func__));
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index ac89f82..7a80bcf 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -148,7 +148,7 @@ int sdioh_sdmmc_osinit(sdioh_info_t *sd)
 {
 	struct sdos_info *sdos;
 
-	sdos = (struct sdos_info *)MALLOC(sd->osh, sizeof(struct sdos_info));
+	sdos = kmalloc(sizeof(struct sdos_info), GFP_ATOMIC);
 	sd->sdos_info = (void *)sdos;
 	if (sdos == NULL)
 		return BCME_NOMEM;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 6c52f2b..3f8d1fd 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -406,12 +406,11 @@ int dhd_prot_attach(dhd_pub_t *dhd)
 {
 	dhd_prot_t *cdc;
 
-	cdc = (dhd_prot_t *) MALLOC(dhd->osh, sizeof(dhd_prot_t));
+	cdc = kzalloc(sizeof(dhd_prot_t), GFP_ATOMIC);
 	if (!cdc) {
 		DHD_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
 	}
-	memset(cdc, 0, sizeof(dhd_prot_t));
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
 	if ((uintptr) (&cdc->msg + 1) != (uintptr) cdc->buf) {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 36084e4..0d17ed0 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -998,7 +998,7 @@ dhd_pktfilter_offload_enable(dhd_pub_t *dhd, char *arg, int enable,
 	wl_pkt_filter_enable_t enable_parm;
 	wl_pkt_filter_enable_t *pkt_filterp;
 
-	arg_save = MALLOC(dhd->osh, strlen(arg) + 1);
+	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
 	if (!arg_save) {
 		DHD_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
@@ -1070,7 +1070,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 	char *arg_save = 0, *arg_org = 0;
 #define BUF_SIZE		2048
 
-	arg_save = MALLOC(dhd->osh, strlen(arg) + 1);
+	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
 	if (!arg_save) {
 		DHD_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
@@ -1078,7 +1078,7 @@ void dhd_pktfilter_offload_set(dhd_pub_t *dhd, char *arg)
 
 	arg_org = arg_save;
 
-	buf = MALLOC(dhd->osh, BUF_SIZE);
+	buf = kmalloc(BUF_SIZE, GFP_ATOMIC);
 	if (!buf) {
 		DHD_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
@@ -1363,7 +1363,7 @@ iscan_buf_t *dhd_iscan_allocate_buf(dhd_pub_t *dhd, iscan_buf_t **iscanbuf)
 
 	dhd_iscan_lock();
 
-	iscanbuf_alloc = (iscan_buf_t *) MALLOC(dhd->osh, sizeof(iscan_buf_t));
+	iscanbuf_alloc = kmalloc(sizeof(iscan_buf_t), GFP_ATOMIC);
 	if (iscanbuf_alloc == NULL)
 		goto fail;
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 224f426..27106ab 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -712,7 +712,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	/* Send down the multicast list first. */
 
 	buflen = sizeof("mcast_list") + sizeof(cnt) + (cnt * ETHER_ADDR_LEN);
-	bufp = buf = MALLOC(dhd->pub.osh, buflen);
+	bufp = buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!bufp) {
 		DHD_ERROR(("%s: out of memory for mcast_list, cnt %d\n",
 			   dhd_ifname(&dhd->pub, ifidx), cnt));
@@ -755,7 +755,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	 */
 
 	buflen = sizeof("allmulti") + sizeof(allmulti);
-	buf = MALLOC(dhd->pub.osh, buflen);
+	buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!buf) {
 		DHD_ERROR(("%s: out of memory for allmulti\n",
 			   dhd_ifname(&dhd->pub, ifidx)));
@@ -1672,7 +1672,7 @@ static int dhd_ioctl_entry(struct net_device *net, struct ifreq *ifr, int cmd)
 		   } else {
 		 */
 		{
-			buf = (char *)MALLOC(dhd->pub.osh, buflen);
+			buf = kmalloc(buflen, GFP_ATOMIC);
 			if (!buf) {
 				bcmerror = -BCME_NOMEM;
 				goto done;
@@ -1837,7 +1837,7 @@ dhd_add_if(dhd_info_t *dhd, int ifidx, void *handle, char *name,
 	ASSERT(dhd && (ifidx < DHD_MAX_IFS));
 
 	ifp = dhd->iflist[ifidx];
-	if (!ifp && !(ifp = MALLOC(dhd->pub.osh, sizeof(dhd_if_t)))) {
+	if (!ifp && !(ifp = kmalloc(sizeof(dhd_if_t), GFP_ATOMIC))) {
 		DHD_ERROR(("%s: OOM - dhd_if_t\n", __func__));
 		return -ENOMEM;
 	}
@@ -1900,7 +1900,7 @@ dhd_pub_t *dhd_attach(osl_t *osh, struct dhd_bus *bus, uint bus_hdrlen)
 	}
 
 	/* Allocate primary dhd_info */
-	dhd = MALLOC(osh, sizeof(dhd_info_t));
+	dhd = kmalloc(sizeof(dhd_info_t), GFP_ATOMIC);
 	if (!dhd) {
 		DHD_ERROR(("%s: OOM - alloc dhd_info\n", __func__));
 		goto fail;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 96ebba1..f9605f9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -1822,18 +1822,18 @@ static int dhdsdio_checkdied(dhd_bus_t *bus, u8 *data, uint size)
 		 * allocate memory to trace the trap or assert.
 		 */
 		size = msize;
-		mbuffer = data = MALLOC(bus->dhd->osh, msize);
+		mbuffer = data = kmalloc(msize, GFP_ATOMIC);
 		if (mbuffer == NULL) {
-			DHD_ERROR(("%s: MALLOC(%d) failed\n", __func__,
+			DHD_ERROR(("%s: kmalloc(%d) failed\n", __func__,
 				   msize));
 			bcmerror = BCME_NOMEM;
 			goto done;
 		}
 	}
 
-	str = MALLOC(bus->dhd->osh, maxstrlen);
+	str = kmalloc(maxstrlen, GFP_ATOMIC);
 	if (str == NULL) {
-		DHD_ERROR(("%s: MALLOC(%d) failed\n", __func__, maxstrlen));
+		DHD_ERROR(("%s: kmalloc(%d) failed\n", __func__, maxstrlen));
 		bcmerror = BCME_NOMEM;
 		goto done;
 	}
@@ -1944,7 +1944,7 @@ static int dhdsdio_mem_dump(dhd_bus_t *bus)
 
 	/* Get full mem size */
 	size = bus->ramsize;
-	buf = MALLOC(bus->dhd->osh, size);
+	buf = kmalloc(size, GFP_ATOMIC);
 	if (!buf) {
 		printf("%s: Out of memory (%d bytes)\n", __func__, size);
 		return -1;
@@ -2004,7 +2004,7 @@ static int dhdsdio_readconsole(dhd_bus_t *bus)
 	/* Allocate console buffer (one time only) */
 	if (c->buf == NULL) {
 		c->bufsize = ltoh32(c->log.buf_size);
-		c->buf = MALLOC(bus->dhd->osh, c->bufsize);
+		c->buf = kmalloc(c->bufsize, GFP_ATOMIC);
 		if (c->buf == NULL)
 			return BCME_NOMEM;
 	}
@@ -2080,7 +2080,7 @@ int dhdsdio_downloadvars(dhd_bus_t *bus, void *arg, int len)
 	if (bus->vars)
 		MFREE(bus->dhd->osh, bus->vars, bus->varsz);
 
-	bus->vars = MALLOC(bus->dhd->osh, len);
+	bus->vars = kmalloc(len, GFP_ATOMIC);
 	bus->varsz = bus->vars ? len : 0;
 	if (bus->vars == NULL) {
 		bcmerror = BCME_NOMEM;
@@ -2526,7 +2526,7 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 	varaddr = (bus->ramsize - 4) - varsize;
 
 	if (bus->vars) {
-		vbuffer = (u8 *) MALLOC(bus->dhd->osh, varsize);
+		vbuffer = kmalloc(varsize, GFP_ATOMIC);
 		if (!vbuffer)
 			return BCME_NOMEM;
 
@@ -2539,7 +2539,7 @@ static int dhdsdio_write_vars(dhd_bus_t *bus)
 #ifdef DHD_DEBUG
 		/* Verify NVRAM bytes */
 		DHD_INFO(("Compare NVRAM dl & ul; varsize=%d\n", varsize));
-		nvram_ularray = (char *)MALLOC(bus->dhd->osh, varsize);
+		nvram_ularray = kmalloc(varsize, GFP_ATOMIC);
 		if (!nvram_ularray)
 			return BCME_NOMEM;
 
@@ -5147,12 +5147,11 @@ static void *dhdsdio_probe(u16 venid, u16 devid, u16 bus_no,
 	}
 
 	/* Allocate private bus interface state */
-	bus = MALLOC(osh, sizeof(dhd_bus_t));
+	bus = kzalloc(sizeof(dhd_bus_t), GFP_ATOMIC);
 	if (!bus) {
-		DHD_ERROR(("%s: MALLOC of dhd_bus_t failed\n", __func__));
+		DHD_ERROR(("%s: kmalloc of dhd_bus_t failed\n", __func__));
 		goto fail;
 	}
-	bzero(bus, sizeof(dhd_bus_t));
 	bus->sdh = sdh;
 	bus->cl_devid = (u16) devid;
 	bus->bus = DHD_BUS;
@@ -5274,7 +5273,7 @@ dhdsdio_probe_attach(struct dhd_bus *bus, osl_t *osh, void *sdh, void *regsva,
 		udelay(65);
 
 		for (fn = 0; fn <= numfn; fn++) {
-			cis[fn] = MALLOC(osh, SBSDIO_CIS_SIZE_LIMIT);
+			cis[fn] = kmalloc(SBSDIO_CIS_SIZE_LIMIT, GFP_ATOMIC);
 			if (!cis[fn]) {
 				DHD_INFO(("dhdsdio_probe: fn %d cis malloc "
 					"failed\n", fn));
@@ -5386,18 +5385,18 @@ static bool dhdsdio_probe_malloc(dhd_bus_t *bus, osl_t *osh, void *sdh)
 		bus->rxblen =
 		    roundup((bus->dhd->maxctl + SDPCM_HDRLEN),
 			    ALIGNMENT) + DHD_SDALIGN;
-		bus->rxbuf = MALLOC(osh, bus->rxblen);
+		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
 		if (!(bus->rxbuf)) {
-			DHD_ERROR(("%s: MALLOC of %d-byte rxbuf failed\n",
+			DHD_ERROR(("%s: kmalloc of %d-byte rxbuf failed\n",
 				   __func__, bus->rxblen));
 			goto fail;
 		}
 	}
 
 	/* Allocate buffer to receive glomed packet */
-	bus->databuf = MALLOC(osh, MAX_DATA_BUF);
+	bus->databuf = kmalloc(MAX_DATA_BUF, GFP_ATOMIC);
 	if (!(bus->databuf)) {
-		DHD_ERROR(("%s: MALLOC of %d-byte databuf failed\n",
+		DHD_ERROR(("%s: kmalloc of %d-byte databuf failed\n",
 			   __func__, MAX_DATA_BUF));
 		/* release rxbuf which was already located as above */
 		if (!bus->rxblen)
@@ -5672,7 +5671,7 @@ static int dhdsdio_download_code_array(struct dhd_bus *bus)
 	{
 		unsigned char *ularray;
 
-		ularray = MALLOC(bus->dhd->osh, bus->ramsize);
+		ularray = kmalloc(bus->ramsize, GFP_ATOMIC);
 		/* Upload image to verify downloaded contents. */
 		offset = 0;
 		memset(ularray, 0xaa, bus->ramsize);
@@ -5734,7 +5733,7 @@ static int dhdsdio_download_code_file(struct dhd_bus *bus, char *fw_path)
 	if (image == NULL)
 		goto err;
 
-	memptr = memblock = MALLOC(bus->dhd->osh, MEMBLOCK + DHD_SDALIGN);
+	memptr = memblock = kmalloc(MEMBLOCK + DHD_SDALIGN, GFP_ATOMIC);
 	if (memblock == NULL) {
 		DHD_ERROR(("%s: Failed to allocate memory %d bytes\n",
 			   __func__, MEMBLOCK));
@@ -5861,7 +5860,7 @@ static int dhdsdio_download_nvram(struct dhd_bus *bus)
 			goto err;
 	}
 
-	memblock = MALLOC(bus->dhd->osh, MEMBLOCK);
+	memblock = kmalloc(MEMBLOCK, GFP_ATOMIC);
 	if (memblock == NULL) {
 		DHD_ERROR(("%s: Failed to allocate memory %d bytes\n",
 			   __func__, MEMBLOCK));
diff --git a/drivers/staging/brcm80211/include/linux_osl.h b/drivers/staging/brcm80211/include/linux_osl.h
index 9273301..69f0e84 100644
--- a/drivers/staging/brcm80211/include/linux_osl.h
+++ b/drivers/staging/brcm80211/include/linux_osl.h
@@ -94,9 +94,7 @@ typedef struct {
 
 #define BUS_SWAP32(v)		(v)
 
-#define MALLOC(osh, size)	osl_malloc((osh), (size))
 #define MFREE(osh, addr, size)	osl_mfree((osh), (addr), (size))
-extern void *osl_malloc(osl_t *osh, uint size);
 extern void osl_mfree(osl_t *osh, void *addr, uint size);
 
 #define NATIVE_MALLOC(osh, size)	kmalloc(size, GFP_ATOMIC)
diff --git a/drivers/staging/brcm80211/phy/wlc_phy_cmn.c b/drivers/staging/brcm80211/phy/wlc_phy_cmn.c
index 5da1597..739fe71 100644
--- a/drivers/staging/brcm80211/phy/wlc_phy_cmn.c
+++ b/drivers/staging/brcm80211/phy/wlc_phy_cmn.c
@@ -555,11 +555,10 @@ shared_phy_t *wlc_phy_shared_attach(shared_phy_params_t *shp)
 {
 	shared_phy_t *sh;
 
-	sh = (shared_phy_t *) MALLOC(shp->osh, sizeof(shared_phy_t));
+	sh = kzalloc(sizeof(shared_phy_t), GFP_ATOMIC);
 	if (sh == NULL) {
 		return NULL;
 	}
-	bzero((char *)sh, sizeof(shared_phy_t));
 
 	sh->osh = shp->osh;
 	sh->sih = shp->sih;
@@ -633,11 +632,10 @@ wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype, char *vars
 		return &pi->pubpi_ro;
 	}
 
-	pi = (phy_info_t *) MALLOC(osh, sizeof(phy_info_t));
+	pi = kzalloc(sizeof(phy_info_t), GFP_ATOMIC);
 	if (pi == NULL) {
 		return NULL;
 	}
-	bzero((char *)pi, sizeof(phy_info_t));
 	pi->regs = (d11regs_t *) regs;
 	pi->sh = sh;
 	pi->phy_init_por = true;
diff --git a/drivers/staging/brcm80211/phy/wlc_phy_lcn.c b/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
index 40b081c..1a70f9a 100644
--- a/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
+++ b/drivers/staging/brcm80211/phy/wlc_phy_lcn.c
@@ -1882,7 +1882,7 @@ wlc_lcnphy_tx_iqlo_cal(phy_info_t *pi,
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
 
-	values_to_save = MALLOC(pi->sh->osh, sizeof(u16) * 20);
+	values_to_save = kmalloc(sizeof(u16) * 20, GFP_ATOMIC);
 	if (NULL == values_to_save) {
 		return;
 	}
@@ -3289,7 +3289,7 @@ wlc_lcnphy_rx_iq_cal(phy_info_t *pi, const lcnphy_rx_iqcomp_t *iqcomp,
 	s16 *ptr;
 	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
 
-	ptr = MALLOC(pi->sh->osh, sizeof(s16) * 131);
+	ptr = kmalloc(sizeof(s16) * 131, GFP_ATOMIC);
 	if (NULL == ptr) {
 		return FALSE;
 	}
@@ -4038,12 +4038,12 @@ wlc_lcnphy_a1(phy_info_t *pi, int cal_type, int num_levels, int step_size_lg2)
 	u16 *phy_c32;
 	phy_c21 = 0;
 	phy_c10 = phy_c13 = phy_c14 = phy_c8 = 0;
-	ptr = MALLOC(pi->sh->osh, sizeof(s16) * 131);
+	ptr = kmalloc(sizeof(s16) * 131, GFP_ATOMIC);
 	if (NULL == ptr) {
 		return;
 	}
 
-	phy_c32 = MALLOC(pi->sh->osh, sizeof(u16) * 20);
+	phy_c32 = kmalloc(sizeof(u16) * 20, GFP_ATOMIC);
 	if (NULL == phy_c32) {
 		return;
 	}
@@ -5054,13 +5054,10 @@ bool wlc_phy_attach_lcnphy(phy_info_t *pi)
 {
 	phy_info_lcnphy_t *pi_lcn;
 
-	pi->u.pi_lcnphy =
-	    (phy_info_lcnphy_t *) MALLOC(pi->sh->osh,
-					 sizeof(phy_info_lcnphy_t));
+	pi->u.pi_lcnphy = kzalloc(sizeof(phy_info_lcnphy_t), GFP_ATOMIC);
 	if (pi->u.pi_lcnphy == NULL) {
 		return FALSE;
 	}
-	bzero((char *)pi->u.pi_lcnphy, sizeof(phy_info_lcnphy_t));
 
 	pi_lcn = pi->u.pi_lcnphy;
 
diff --git a/drivers/staging/brcm80211/phy/wlc_phy_n.c b/drivers/staging/brcm80211/phy/wlc_phy_n.c
index dd856c4..529e06c 100644
--- a/drivers/staging/brcm80211/phy/wlc_phy_n.c
+++ b/drivers/staging/brcm80211/phy/wlc_phy_n.c
@@ -22360,7 +22360,7 @@ wlc_phy_gen_load_samples_nphy(phy_info_t *pi, u32 f_kHz, u16 max_val,
 		tbl_len = (phy_bw << 1);
 	}
 
-	tone_buf = (cs32 *) MALLOC(pi->sh->osh, sizeof(cs32) * tbl_len);
+	tone_buf = kmalloc(sizeof(cs32) * tbl_len, GFP_ATOMIC);
 	if (tone_buf == NULL) {
 		return 0;
 	}
@@ -22414,7 +22414,7 @@ wlc_phy_loadsampletable_nphy(phy_info_t *pi, cs32 *tone_buf,
 	u16 t;
 	u32 *data_buf = NULL;
 
-	data_buf = (u32 *) MALLOC(pi->sh->osh, sizeof(u32) * num_samps);
+	data_buf = kmalloc(sizeof(u32) * num_samps, GFP_ATOMIC);
 	if (data_buf == NULL) {
 		return;
 	}
@@ -26727,7 +26727,7 @@ wlc_phy_a1_nphy(phy_info_t *pi, u8 core, u32 winsz, u32 start,
 	ASSERT(end > start);
 	ASSERT(end < NPHY_PAPD_EPS_TBL_SIZE);
 
-	buf = MALLOC(pi->sh->osh, 2 * sizeof(u32) * NPHY_PAPD_EPS_TBL_SIZE);
+	buf = kmalloc(2 * sizeof(u32) * NPHY_PAPD_EPS_TBL_SIZE, GFP_ATOMIC);
 	if (NULL == buf) {
 		return;
 	}
diff --git a/drivers/staging/brcm80211/sys/wl_mac80211.c b/drivers/staging/brcm80211/sys/wl_mac80211.c
index e43f05a..bcd6e69 100644
--- a/drivers/staging/brcm80211/sys/wl_mac80211.c
+++ b/drivers/staging/brcm80211/sys/wl_mac80211.c
@@ -1657,7 +1657,7 @@ wl_schedule_task(wl_info_t *wl, void (*fn) (struct wl_task *task),
 
 	WL_TRACE(("wl%d: wl_schedule_task\n", wl->pub->unit));
 
-	task = osl_malloc(wl->osh, sizeof(wl_task_t));
+	task = kmalloc(sizeof(wl_task_t), GFP_ATOMIC);
 	if (!task) {
 		WL_ERROR(("wl%d: wl_schedule_task: out of memory\n", wl->pub->unit));
 		return -ENOMEM;
@@ -1911,7 +1911,7 @@ wl_timer_t *wl_init_timer(wl_info_t *wl, void (*fn) (void *arg), void *arg,
 {
 	wl_timer_t *t;
 
-	t = osl_malloc(wl->osh, sizeof(wl_timer_t));
+	t = kmalloc(sizeof(wl_timer_t), GFP_ATOMIC);
 	if (!t) {
 		WL_ERROR(("wl%d: wl_init_timer: out of memory\n", wl->pub->unit));
 		return 0;
@@ -1929,7 +1929,7 @@ wl_timer_t *wl_init_timer(wl_info_t *wl, void (*fn) (void *arg), void *arg,
 	wl->timers = t;
 
 #ifdef BCMDBG
-	t->name = osl_malloc(wl->osh, strlen(name) + 1);
+	t->name = kmalloc(strlen(name) + 1, GFP_ATOMIC);
 	if (t->name)
 		strcpy(t->name, name);
 #endif
diff --git a/drivers/staging/brcm80211/sys/wlc_alloc.c b/drivers/staging/brcm80211/sys/wlc_alloc.c
index e637e62..feb9a05 100644
--- a/drivers/staging/brcm80211/sys/wlc_alloc.c
+++ b/drivers/staging/brcm80211/sys/wlc_alloc.c
@@ -37,11 +37,9 @@ void *wlc_calloc(osl_t *osh, uint unit, uint size)
 {
 	void *item;
 
-	item = MALLOC(osh, size);
+	item = kzalloc(size, GFP_ATOMIC);
 	if (item == NULL)
 		WL_ERROR(("wl%d: %s: out of memory\n", unit, __func__));
-	else
-		bzero((char *)item, size);
 	return item;
 }
 
diff --git a/drivers/staging/brcm80211/sys/wlc_ampdu.c b/drivers/staging/brcm80211/sys/wlc_ampdu.c
index 26bc9cc..8470baa 100644
--- a/drivers/staging/brcm80211/sys/wlc_ampdu.c
+++ b/drivers/staging/brcm80211/sys/wlc_ampdu.c
@@ -179,12 +179,11 @@ ampdu_info_t *wlc_ampdu_attach(wlc_info_t *wlc)
 	ASSERT(wlc->pub->tunables->ampdunummpdu <= AMPDU_MAX_MPDU);
 	ASSERT(wlc->pub->tunables->ampdunummpdu > 0);
 
-	ampdu = (ampdu_info_t *) MALLOC(wlc->osh, sizeof(ampdu_info_t));
+	ampdu = kzalloc(sizeof(ampdu_info_t), GFP_ATOMIC);
 	if (!ampdu) {
 		WL_ERROR(("wl%d: wlc_ampdu_attach: out of mem\n", wlc->pub->unit));
 		return NULL;
 	}
-	bzero((char *)ampdu, sizeof(ampdu_info_t));
 	ampdu->wlc = wlc;
 
 	for (i = 0; i < AMPDU_MAX_SCB_TID; i++)
diff --git a/drivers/staging/brcm80211/sys/wlc_antsel.c b/drivers/staging/brcm80211/sys/wlc_antsel.c
index ee1cefd..e7e7b6d 100644
--- a/drivers/staging/brcm80211/sys/wlc_antsel.c
+++ b/drivers/staging/brcm80211/sys/wlc_antsel.c
@@ -94,14 +94,12 @@ antsel_info_t *wlc_antsel_attach(wlc_info_t *wlc, osl_t *osh,
 						  wlc_hw_info_t *wlc_hw) {
 	antsel_info_t *asi;
 
-	asi = (antsel_info_t *) MALLOC(osh, sizeof(antsel_info_t));
+	asi = kzalloc(sizeof(antsel_info_t), GFP_ATOMIC);
 	if (!asi) {
 		WL_ERROR(("wl%d: wlc_antsel_attach: out of mem\n", pub->unit));
 		return NULL;
 	}
 
-	bzero((char *)asi, sizeof(antsel_info_t));
-
 	asi->wlc = wlc;
 	asi->pub = pub;
 	asi->antsel_type = ANTSEL_NA;
diff --git a/drivers/staging/brcm80211/sys/wlc_channel.c b/drivers/staging/brcm80211/sys/wlc_channel.c
index f62144a..b9395d6 100644
--- a/drivers/staging/brcm80211/sys/wlc_channel.c
+++ b/drivers/staging/brcm80211/sys/wlc_channel.c
@@ -612,12 +612,11 @@ wlc_cm_info_t *wlc_channel_mgr_attach(wlc_info_t *wlc)
 
 	WL_TRACE(("wl%d: wlc_channel_mgr_attach\n", wlc->pub->unit));
 
-	wlc_cm = (wlc_cm_info_t *) MALLOC(pub->osh, sizeof(wlc_cm_info_t));
+	wlc_cm = kzalloc(sizeof(wlc_cm_info_t), GFP_ATOMIC);
 	if (wlc_cm == NULL) {
 		WL_ERROR(("wl%d: %s: out of memory", pub->unit, __func__));
 		return NULL;
 	}
-	bzero((char *)wlc_cm, sizeof(wlc_cm_info_t));
 	wlc_cm->pub = pub;
 	wlc_cm->wlc = wlc;
 	wlc->cmi = wlc_cm;
diff --git a/drivers/staging/brcm80211/sys/wlc_event.c b/drivers/staging/brcm80211/sys/wlc_event.c
index 4af1e71..549ca0a 100644
--- a/drivers/staging/brcm80211/sys/wlc_event.c
+++ b/drivers/staging/brcm80211/sys/wlc_event.c
@@ -58,12 +58,10 @@ wlc_eventq_t *wlc_eventq_attach(wlc_pub_t *pub, struct wlc_info *wlc, void *wl,
 {
 	wlc_eventq_t *eq;
 
-	eq = (wlc_eventq_t *) MALLOC(pub->osh, sizeof(wlc_eventq_t));
+	eq = kzalloc(sizeof(wlc_eventq_t), GFP_ATOMIC);
 	if (eq == NULL)
 		return NULL;
 
-	bzero(eq, sizeof(wlc_eventq_t));
-
 	eq->cb = cb;
 	eq->wlc = wlc;
 	eq->wl = wl;
@@ -125,12 +123,11 @@ wlc_event_t *wlc_event_alloc(wlc_eventq_t *eq)
 {
 	wlc_event_t *e;
 
-	e = MALLOC(eq->pub->osh, sizeof(wlc_event_t));
+	e = kzalloc(sizeof(wlc_event_t), GFP_ATOMIC);
 
 	if (e == NULL)
 		return NULL;
 
-	bzero(e, sizeof(wlc_event_t));
 	return e;
 }
 
diff --git a/drivers/staging/brcm80211/sys/wlc_phy_shim.c b/drivers/staging/brcm80211/sys/wlc_phy_shim.c
index 37bb593..57acd30 100644
--- a/drivers/staging/brcm80211/sys/wlc_phy_shim.c
+++ b/drivers/staging/brcm80211/sys/wlc_phy_shim.c
@@ -66,13 +66,11 @@ wlc_phy_shim_info_t *wlc_phy_shim_attach(wlc_hw_info_t *wlc_hw,
 						       void *wl, void *wlc) {
 	wlc_phy_shim_info_t *physhim = NULL;
 
-	physhim = (wlc_phy_shim_info_t *)MALLOC(wlc_hw->osh,
-		sizeof(wlc_phy_shim_info_t));
+	physhim = kzalloc(sizeof(wlc_phy_shim_info_t), GFP_ATOMIC);
 	if (!physhim) {
 		WL_ERROR(("wl%d: wlc_phy_shim_attach: out of mem\n", wlc_hw->unit));
 		return NULL;
 	}
-	bzero((char *)physhim, sizeof(wlc_phy_shim_info_t));
 	physhim->wlc_hw = wlc_hw;
 	physhim->wlc = wlc;
 	physhim->wl = wl;
diff --git a/drivers/staging/brcm80211/util/bcmotp.c b/drivers/staging/brcm80211/util/bcmotp.c
index 30ad224..307cb00 100644
--- a/drivers/staging/brcm80211/util/bcmotp.c
+++ b/drivers/staging/brcm80211/util/bcmotp.c
@@ -760,7 +760,7 @@ static int hndotp_nvread(void *oh, char *data, uint *len)
 
 	/* Read the whole otp so we can easily manipulate it */
 	lim = hndotp_size(oh);
-	rawotp = MALLOC(si_osh(oi->sih), lim);
+	rawotp = kmalloc(lim, GFP_ATOMIC);
 	if (rawotp == NULL) {
 		rc = -2;
 		goto out;
diff --git a/drivers/staging/brcm80211/util/bcmsrom.c b/drivers/staging/brcm80211/util/bcmsrom.c
index 13fe173..377831d 100644
--- a/drivers/staging/brcm80211/util/bcmsrom.c
+++ b/drivers/staging/brcm80211/util/bcmsrom.c
@@ -398,7 +398,7 @@ int srom_parsecis(osl_t *osh, u8 *pcis[], uint ciscnt, char **vars, uint *count)
 
 	boardnum = -1;
 
-	base = MALLOC(osh, MAXSZ_NVRAM_VARS);
+	base = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
 	ASSERT(base != NULL);
 	if (!base)
 		return -2;
@@ -1509,13 +1509,11 @@ static int otp_read_pci(osl_t *osh, si_t *sih, u16 *buf, uint bufsz)
 
 	ASSERT(bufsz <= OTP_SZ_MAX);
 
-	otp = MALLOC(osh, OTP_SZ_MAX);
+	otp = kzalloc(OTP_SZ_MAX, GFP_ATOMIC);
 	if (otp == NULL) {
 		return BCME_ERROR;
 	}
 
-	bzero(otp, OTP_SZ_MAX);
-
 	err = otp_read_region(sih, OTP_HW_RGN, (u16 *) otp, &sz);
 
 	bcopy(otp, buf, bufsz);
@@ -1558,7 +1556,7 @@ static int initvars_table(osl_t *osh, char *start, char *end, char **vars,
 
 	/* do it only when there is more than just the null string */
 	if (c > 1) {
-		char *vp = MALLOC(osh, c);
+		char *vp = kmalloc(c, GFP_ATOMIC);
 		ASSERT(vp != NULL);
 		if (!vp)
 			return BCME_NOMEM;
@@ -1588,7 +1586,7 @@ static int initvars_flash(si_t *sih, osl_t *osh, char **base, uint len)
 	char devpath[SI_DEVPATH_BUFSZ];
 
 	/* allocate memory and read in flash */
-	flash = MALLOC(osh, NVRAM_SPACE);
+	flash = kmalloc(NVRAM_SPACE, GFP_ATOMIC);
 	if (!flash)
 		return BCME_NOMEM;
 	err = nvram_getall(flash, NVRAM_SPACE);
@@ -1645,7 +1643,7 @@ static int initvars_flash_si(si_t *sih, char **vars, uint *count)
 	ASSERT(vars != NULL);
 	ASSERT(count != NULL);
 
-	base = vp = MALLOC(osh, MAXSZ_NVRAM_VARS);
+	base = vp = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
 	ASSERT(vp != NULL);
 	if (!vp)
 		return BCME_NOMEM;
@@ -1859,7 +1857,7 @@ static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count)
 	 * if we should return an error when CRC fails or read SROM variables
 	 * from flash.
 	 */
-	srom = MALLOC(osh, SROM_MAX);
+	srom = kmalloc(SROM_MAX, GFP_ATOMIC);
 	ASSERT(srom != NULL);
 	if (!srom)
 		return -2;
@@ -1947,7 +1945,7 @@ static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count)
 	ASSERT(vars != NULL);
 	ASSERT(count != NULL);
 
-	base = vp = MALLOC(osh, MAXSZ_NVRAM_VARS);
+	base = vp = kmalloc(MAXSZ_NVRAM_VARS, GFP_ATOMIC);
 	ASSERT(vp != NULL);
 	if (!vp) {
 		err = -2;
@@ -2000,14 +1998,12 @@ static int initvars_cis_sdio(osl_t *osh, char **vars, uint *count)
 	ASSERT(numfn <= SDIOD_MAX_IOFUNCS);
 
 	for (fn = 0; fn <= numfn; fn++) {
-		cis[fn] = MALLOC(osh, SBSDIO_CIS_SIZE_LIMIT)
+		cis[fn] = kzalloc(SBSDIO_CIS_SIZE_LIMIT, GFP_ATOMIC);
 		if (cis[fn] == NULL) {
 			rc = -1;
 			break;
 		}
 
-		bzero(cis[fn], SBSDIO_CIS_SIZE_LIMIT);
-
 		if (bcmsdh_cis_read(NULL, fn, cis[fn], SBSDIO_CIS_SIZE_LIMIT) !=
 		    0) {
 			MFREE(osh, cis[fn], SBSDIO_CIS_SIZE_LIMIT);
diff --git a/drivers/staging/brcm80211/util/hnddma.c b/drivers/staging/brcm80211/util/hnddma.c
index cb99a23..2d915f0 100644
--- a/drivers/staging/brcm80211/util/hnddma.c
+++ b/drivers/staging/brcm80211/util/hnddma.c
@@ -378,7 +378,7 @@ hnddma_t *dma_attach(osl_t *osh, char *name, si_t *sih, void *dmaregstx,
 	uint size;
 
 	/* allocate private info structure */
-	di = MALLOC(osh, sizeof(dma_info_t));
+	di = kzalloc(sizeof(dma_info_t), GFP_ATOMIC);
 	if (di == NULL) {
 #ifdef BCMDBG
 		printf("dma_attach: out of memory\n");
@@ -386,8 +386,6 @@ hnddma_t *dma_attach(osl_t *osh, char *name, si_t *sih, void *dmaregstx,
 		return NULL;
 	}
 
-	bzero((char *)di, sizeof(dma_info_t));
-
 	di->msg_level = msg_level ? msg_level : &dma_msg_level;
 
 	/* old chips w/o sb is no longer supported */
@@ -514,23 +512,21 @@ hnddma_t *dma_attach(osl_t *osh, char *name, si_t *sih, void *dmaregstx,
 	/* allocate tx packet pointer vector */
 	if (ntxd) {
 		size = ntxd * sizeof(void *);
-		di->txp = MALLOC(osh, size);
+		di->txp = kzalloc(size, GFP_ATOMIC);
 		if (di->txp == NULL) {
 			DMA_ERROR(("%s: dma_attach: out of tx memory\n", di->name));
 			goto fail;
 		}
-		bzero((char *)di->txp, size);
 	}
 
 	/* allocate rx packet pointer vector */
 	if (nrxd) {
 		size = nrxd * sizeof(void *);
-		di->rxp = MALLOC(osh, size);
+		di->rxp = kzalloc(size, GFP_ATOMIC);
 		if (di->rxp == NULL) {
 			DMA_ERROR(("%s: dma_attach: out of rx memory\n", di->name));
 			goto fail;
 		}
-		bzero((char *)di->rxp, size);
 	}
 
 	/* allocate transmit descriptor ring, only need ntxd descriptors but it must be aligned */
@@ -562,18 +558,16 @@ hnddma_t *dma_attach(osl_t *osh, char *name, si_t *sih, void *dmaregstx,
 	if (DMASGLIST_ENAB) {
 		if (ntxd) {
 			size = ntxd * sizeof(hnddma_seg_map_t);
-			di->txp_dmah = (hnddma_seg_map_t *) MALLOC(osh, size);
+			di->txp_dmah = kzalloc(size, GFP_ATOMIC);
 			if (di->txp_dmah == NULL)
 				goto fail;
-			bzero((char *)di->txp_dmah, size);
 		}
 
 		if (nrxd) {
 			size = nrxd * sizeof(hnddma_seg_map_t);
-			di->rxp_dmah = (hnddma_seg_map_t *) MALLOC(osh, size);
+			di->rxp_dmah = kzalloc(size, GFP_ATOMIC);
 			if (di->rxp_dmah == NULL)
 				goto fail;
-			bzero((char *)di->rxp_dmah, size);
 		}
 	}
 
diff --git a/drivers/staging/brcm80211/util/linux_osl.c b/drivers/staging/brcm80211/util/linux_osl.c
index 7f4da18..43ac48d 100644
--- a/drivers/staging/brcm80211/util/linux_osl.c
+++ b/drivers/staging/brcm80211/util/linux_osl.c
@@ -285,26 +285,6 @@ uint osl_pci_slot(osl_t *osh)
 	return PCI_SLOT(((struct pci_dev *)osh->pdev)->devfn);
 }
 
-void *osl_malloc(osl_t *osh, uint size)
-{
-	void *addr;
-
-	/* only ASSERT if osh is defined */
-	if (osh)
-		ASSERT(osh->magic == OS_HANDLE_MAGIC);
-
-	addr = kmalloc(size, GFP_ATOMIC);
-	if (addr == NULL) {
-		if (osh)
-			osh->failed++;
-		return NULL;
-	}
-	if (osh)
-		osh->malloced += size;
-
-	return addr;
-}
-
 void osl_mfree(osl_t *osh, void *addr, uint size)
 {
 	if (osh) {
diff --git a/drivers/staging/brcm80211/util/nicpci.c b/drivers/staging/brcm80211/util/nicpci.c
index 1c7a21c..d769659 100644
--- a/drivers/staging/brcm80211/util/nicpci.c
+++ b/drivers/staging/brcm80211/util/nicpci.c
@@ -115,14 +115,12 @@ void *pcicore_init(si_t *sih, osl_t *osh, void *regs)
 	ASSERT(sih->bustype == PCI_BUS);
 
 	/* alloc pcicore_info_t */
-	pi = MALLOC(osh, sizeof(pcicore_info_t));
+	pi = kzalloc(sizeof(pcicore_info_t), GFP_ATOMIC);
 	if (pi == NULL) {
 		PCI_ERROR(("pci_attach: malloc failed!\n"));
 		return NULL;
 	}
 
-	bzero(pi, sizeof(pcicore_info_t));
-
 	pi->sih = sih;
 	pi->osh = osh;
 
diff --git a/drivers/staging/brcm80211/util/nvram/nvram_ro.c b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
index 0127ded..f0470a7 100644
--- a/drivers/staging/brcm80211/util/nvram/nvram_ro.c
+++ b/drivers/staging/brcm80211/util/nvram/nvram_ro.c
@@ -14,6 +14,7 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
+#include <linux/slab.h>
 #include <typedefs.h>
 #include <bcmdefs.h>
 #include <linux/string.h>
@@ -58,7 +59,7 @@ static void get_flash_nvram(si_t *sih, struct nvram_header *nvh)
 	nvs = R_REG(osh, &nvh->len) - sizeof(struct nvram_header);
 	bufsz = nvs + VARS_T_OH;
 
-	new = (vars_t *) MALLOC(osh, bufsz);
+	new = kmalloc(bufsz, GFP_ATOMIC);
 	if (new == NULL) {
 		NVR_MSG(("Out of memory for flash vars\n"));
 		return;
@@ -93,7 +94,7 @@ int nvram_append(void *si, char *varlst, uint varsz)
 	uint bufsz = VARS_T_OH;
 	vars_t *new;
 
-	new = MALLOC(si_osh((si_t *) si), bufsz);
+	new = kmalloc(bufsz, GFP_ATOMIC);
 	if (new == NULL)
 		return BCME_NOMEM;
 
diff --git a/drivers/staging/brcm80211/util/siutils.c b/drivers/staging/brcm80211/util/siutils.c
index ec21dbd..b2423c7 100644
--- a/drivers/staging/brcm80211/util/siutils.c
+++ b/drivers/staging/brcm80211/util/siutils.c
@@ -88,7 +88,7 @@ si_t *si_attach(uint devid, osl_t *osh, void *regs, uint bustype, void *sdh,
 	si_info_t *sii;
 
 	/* alloc si_info_t */
-	sii = MALLOC(osh, sizeof(si_info_t));
+	sii = kmalloc(sizeof(si_info_t), GFP_ATOMIC);
 	if (sii == NULL) {
 		SI_ERROR(("si_attach: malloc failed!\n"));
 		return NULL;
-- 
1.6.4.4

