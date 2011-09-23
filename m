Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2447 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754575Ab1IWAIP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Sep 2011 20:08:15 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH v2 16/19] staging: brcm80211: removed log after
 kzalloc()/kmalloc() failure
Date: Thu, 22 Sep 2011 17:07:53 -0700
Message-ID: <1316736476-23725-17-git-send-email-frankyl@broadcom.com> (sfid-20110923_020832_359194_3DA1194E)
In-Reply-To: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
References: <1316736476-23725-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

kzalloc/kmalloc already reports an allocation failure themselves.

Reported-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c     |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c  |   13 ++----
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c   |   19 ++------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |   26 ++---------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |   50 ++++++----------------
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |    6 +--
 drivers/staging/brcm80211/brcmsmac/antsel.c      |    5 +--
 drivers/staging/brcm80211/brcmsmac/channel.c     |    5 +--
 drivers/staging/brcm80211/brcmsmac/dma.c         |   16 +------
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   11 +----
 drivers/staging/brcm80211/brcmsmac/nicpci.c      |    3 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    7 +--
 12 files changed, 41 insertions(+), 124 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 28bdf9e..91b4d3c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -417,10 +417,8 @@ int brcmf_proto_attach(struct brcmf_pub *drvr)
 	struct brcmf_proto *cdc;
 
 	cdc = kzalloc(sizeof(struct brcmf_proto), GFP_ATOMIC);
-	if (!cdc) {
-		brcmf_dbg(ERROR, "kmalloc failed\n");
+	if (!cdc)
 		goto fail;
-	}
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
 	if ((unsigned long)(&cdc->msg + 1) != (unsigned long)cdc->buf) {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 0c41c1c..963d1a9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -562,10 +562,9 @@ brcmf_c_pktfilter_offload_enable(struct brcmf_pub *drvr, char *arg, int enable,
 	struct brcmf_pkt_filter_enable *pkt_filterp;
 
 	arg_save = kmalloc(strlen(arg) + 1, GFP_ATOMIC);
-	if (!arg_save) {
-		brcmf_dbg(ERROR, "kmalloc failed\n");
+	if (!arg_save)
 		goto fail;
-	}
+
 	arg_org = arg_save;
 	memcpy(arg_save, arg, strlen(arg) + 1);
 
@@ -635,18 +634,14 @@ void brcmf_c_pktfilter_offload_set(struct brcmf_pub *drvr, char *arg)
 	char *arg_save = NULL, *arg_org = NULL;
 
 	arg_save = kstrdup(arg, GFP_ATOMIC);
-	if (!arg_save) {
-		brcmf_dbg(ERROR, "kmalloc failed\n");
+	if (!arg_save)
 		goto fail;
-	}
 
 	arg_org = arg_save;
 
 	buf = kmalloc(PKTFILTER_BUF_SIZE, GFP_ATOMIC);
-	if (!buf) {
-		brcmf_dbg(ERROR, "kmalloc failed\n");
+	if (!buf)
 		goto fail;
-	}
 
 	argv[i] = strsep(&arg_save, " ");
 	while (argv[i++])
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index cc8564a..659a9c2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -159,11 +159,8 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 
 	buflen = sizeof("mcast_list") + sizeof(cnt) + (cnt * ETH_ALEN);
 	bufp = buf = kmalloc(buflen, GFP_ATOMIC);
-	if (!bufp) {
-		brcmf_dbg(ERROR, "%s: out of memory for mcast_list, cnt %d\n",
-			  brcmf_ifname(&drvr_priv->pub, 0), cnt);
+	if (!bufp)
 		return;
-	}
 
 	strcpy(bufp, "mcast_list");
 	bufp += strlen("mcast_list") + 1;
@@ -202,11 +199,9 @@ static void _brcmf_set_multicast_list(struct work_struct *work)
 
 	buflen = sizeof("allmulti") + sizeof(allmulti);
 	buf = kmalloc(buflen, GFP_ATOMIC);
-	if (!buf) {
-		brcmf_dbg(ERROR, "%s: out of memory for allmulti\n",
-			  brcmf_ifname(&drvr_priv->pub, 0));
+	if (!buf)
 		return;
-	}
+
 	allmulti_le = cpu_to_le32(allmulti);
 
 	if (!brcmu_mkiovar
@@ -963,10 +958,8 @@ brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, struct net_device *net,
 	ifp = drvr_priv->iflist[ifidx];
 	if (!ifp) {
 		ifp = kmalloc(sizeof(struct brcmf_if), GFP_ATOMIC);
-		if (!ifp) {
-			brcmf_dbg(ERROR, "OOM - struct brcmf_if\n");
+		if (!ifp)
 			return -ENOMEM;
-		}
 	}
 
 	memset(ifp, 0, sizeof(struct brcmf_if));
@@ -1019,10 +1012,8 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 
 	/* Allocate primary brcmf_info */
 	drvr_priv = kzalloc(sizeof(struct brcmf_info), GFP_ATOMIC);
-	if (!drvr_priv) {
-		brcmf_dbg(ERROR, "OOM - alloc brcmf_info\n");
+	if (!drvr_priv)
 		goto fail;
-	}
 
 	/*
 	 * Save the brcmf_info into the priv
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 66ab752..9f8bcb3 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -2956,10 +2956,8 @@ static int brcmf_sdbrcm_mem_dump(struct brcmf_bus *bus)
 	/* Get full mem size */
 	size = bus->ramsize;
 	buf = kmalloc(size, GFP_ATOMIC);
-	if (!buf) {
-		brcmf_dbg(ERROR, "Out of memory (%d bytes)\n", size);
+	if (!buf)
 		return -1;
-	}
 
 	/* Read mem content */
 	printk(KERN_DEBUG "Dump dongle memory");
@@ -3013,7 +3011,6 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 		size = msize;
 		mbuffer = data = kmalloc(msize, GFP_ATOMIC);
 		if (mbuffer == NULL) {
-			brcmf_dbg(ERROR, "kmalloc(%d) failed\n", msize);
 			bcmerror = -ENOMEM;
 			goto done;
 		}
@@ -3021,7 +3018,6 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 
 	str = kmalloc(maxstrlen, GFP_ATOMIC);
 	if (str == NULL) {
-		brcmf_dbg(ERROR, "kmalloc(%d) failed\n", maxstrlen);
 		bcmerror = -ENOMEM;
 		goto done;
 	}
@@ -3737,8 +3733,6 @@ static int brcmf_sdbrcm_download_code_file(struct brcmf_bus *bus)
 
 	memptr = memblock = kmalloc(MEMBLOCK + BRCMF_SDALIGN, GFP_ATOMIC);
 	if (memblock == NULL) {
-		brcmf_dbg(ERROR, "Failed to allocate memory %d bytes\n",
-			  MEMBLOCK);
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -3837,8 +3831,6 @@ static int brcmf_sdbrcm_download_nvram(struct brcmf_bus *bus)
 
 	memblock = kmalloc(MEMBLOCK, GFP_ATOMIC);
 	if (memblock == NULL) {
-		brcmf_dbg(ERROR, "Failed to allocate memory %d bytes\n",
-			  MEMBLOCK);
 		ret = -ENOMEM;
 		goto err;
 	}
@@ -4254,18 +4246,13 @@ static bool brcmf_sdbrcm_probe_malloc(struct brcmf_bus *bus)
 		    roundup((bus->drvr->maxctl + SDPCM_HDRLEN),
 			    ALIGNMENT) + BRCMF_SDALIGN;
 		bus->rxbuf = kmalloc(bus->rxblen, GFP_ATOMIC);
-		if (!(bus->rxbuf)) {
-			brcmf_dbg(ERROR, "kmalloc of %d-byte rxbuf failed\n",
-				  bus->rxblen);
+		if (!(bus->rxbuf))
 			goto fail;
-		}
 	}
 
 	/* Allocate buffer to receive glomed packet */
 	bus->databuf = kmalloc(MAX_DATA_BUF, GFP_ATOMIC);
 	if (!(bus->databuf)) {
-		brcmf_dbg(ERROR, "kmalloc of %d-byte databuf failed\n",
-			  MAX_DATA_BUF);
 		/* release rxbuf which was already located as above */
 		if (!bus->rxblen)
 			kfree(bus->rxbuf);
@@ -4457,10 +4444,8 @@ brcmf_sdbrcm_chip_attach(struct brcmf_bus *bus, u32 regs)
 
 	/* alloc chip_info_t */
 	ci = kzalloc(sizeof(struct chip_info), GFP_ATOMIC);
-	if (NULL == ci) {
-		brcmf_dbg(ERROR, "malloc failed!\n");
+	if (NULL == ci)
 		return -ENOMEM;
-	}
 
 	/* bus/core/clk setup for register access */
 	/* Try forcing SDIO core to do ALPAvail request only */
@@ -4785,10 +4770,9 @@ void *brcmf_sdbrcm_probe(u16 bus_no, u16 slot, u16 func, uint bustype,
 
 	/* Allocate private bus interface state */
 	bus = kzalloc(sizeof(struct brcmf_bus), GFP_ATOMIC);
-	if (!bus) {
-		brcmf_dbg(ERROR, "kmalloc of struct dhd_bus failed\n");
+	if (!bus)
 		goto fail;
-	}
+
 	bus->sdiodev = sdiodev;
 	sdiodev->bus = bus;
 	bus->txbound = BRCMF_TXBOUND;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 6acaaae..d0ae2b6 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -2023,7 +2023,6 @@ static s32 wl_inform_ibss(struct brcmf_cfg80211_priv *cfg_priv,
 
 	buf = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
 	if (buf == NULL) {
-		WL_ERR("kzalloc() failed\n");
 		err = -ENOMEM;
 		goto CleanUp;
 	}
@@ -2660,10 +2659,9 @@ static struct wireless_dev *brcmf_alloc_wdev(s32 sizeof_iface,
 	s32 err = 0;
 
 	wdev = kzalloc(sizeof(*wdev), GFP_KERNEL);
-	if (!wdev) {
-		WL_ERR("Could not allocate wireless device\n");
+	if (!wdev)
 		return ERR_PTR(-ENOMEM);
-	}
+
 	wdev->wiphy =
 	    wiphy_new(&wl_cfg80211_ops,
 		      sizeof(struct brcmf_cfg80211_priv) + sizeof_iface);
@@ -3124,51 +3122,33 @@ static void brcmf_deinit_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 static s32 brcmf_init_priv_mem(struct brcmf_cfg80211_priv *cfg_priv)
 {
 	cfg_priv->scan_results = kzalloc(WL_SCAN_BUF_MAX, GFP_KERNEL);
-	if (!cfg_priv->scan_results) {
-		WL_ERR("Scan results alloc failed\n");
+	if (!cfg_priv->scan_results)
 		goto init_priv_mem_out;
-	}
 	cfg_priv->conf = kzalloc(sizeof(*cfg_priv->conf), GFP_KERNEL);
-	if (!cfg_priv->conf) {
-		WL_ERR("wl_conf alloc failed\n");
+	if (!cfg_priv->conf)
 		goto init_priv_mem_out;
-	}
 	cfg_priv->profile = kzalloc(sizeof(*cfg_priv->profile), GFP_KERNEL);
-	if (!cfg_priv->profile) {
-		WL_ERR("wl_profile alloc failed\n");
+	if (!cfg_priv->profile)
 		goto init_priv_mem_out;
-	}
 	cfg_priv->bss_info = kzalloc(WL_BSS_INFO_MAX, GFP_KERNEL);
-	if (!cfg_priv->bss_info) {
-		WL_ERR("Bss information alloc failed\n");
+	if (!cfg_priv->bss_info)
 		goto init_priv_mem_out;
-	}
 	cfg_priv->scan_req_int = kzalloc(sizeof(*cfg_priv->scan_req_int),
 					 GFP_KERNEL);
-	if (!cfg_priv->scan_req_int) {
-		WL_ERR("Scan req alloc failed\n");
+	if (!cfg_priv->scan_req_int)
 		goto init_priv_mem_out;
-	}
 	cfg_priv->ioctl_buf = kzalloc(WL_IOCTL_LEN_MAX, GFP_KERNEL);
-	if (!cfg_priv->ioctl_buf) {
-		WL_ERR("Ioctl buf alloc failed\n");
+	if (!cfg_priv->ioctl_buf)
 		goto init_priv_mem_out;
-	}
 	cfg_priv->extra_buf = kzalloc(WL_EXTRA_BUF_MAX, GFP_KERNEL);
-	if (!cfg_priv->extra_buf) {
-		WL_ERR("Extra buf alloc failed\n");
+	if (!cfg_priv->extra_buf)
 		goto init_priv_mem_out;
-	}
 	cfg_priv->iscan = kzalloc(sizeof(*cfg_priv->iscan), GFP_KERNEL);
-	if (!cfg_priv->iscan) {
-		WL_ERR("Iscan buf alloc failed\n");
+	if (!cfg_priv->iscan)
 		goto init_priv_mem_out;
-	}
 	cfg_priv->pmk_list = kzalloc(sizeof(*cfg_priv->pmk_list), GFP_KERNEL);
-	if (!cfg_priv->pmk_list) {
-		WL_ERR("pmk list alloc failed\n");
+	if (!cfg_priv->pmk_list)
 		goto init_priv_mem_out;
-	}
 
 	return 0;
 
@@ -3210,10 +3190,8 @@ brcmf_enq_event(struct brcmf_cfg80211_priv *cfg_priv, u32 event,
 	s32 err = 0;
 
 	e = kzalloc(sizeof(struct brcmf_cfg80211_event_q), GFP_KERNEL);
-	if (!e) {
-		WL_ERR("event alloc failed\n");
+	if (!e)
 		return -ENOMEM;
-	}
 
 	e->etype = event;
 	memcpy(&e->emsg, msg, sizeof(struct brcmf_event_msg));
@@ -3333,10 +3311,8 @@ struct brcmf_cfg80211_dev *brcmf_cfg80211_attach(struct net_device *ndev,
 		return NULL;
 	}
 	cfg_dev = kzalloc(sizeof(struct brcmf_cfg80211_dev), GFP_KERNEL);
-	if (!cfg_dev) {
-		WL_ERR("wl_cfg80211_dev is invalid\n");
+	if (!cfg_dev)
 		return NULL;
-	}
 
 	wdev = brcmf_alloc_wdev(sizeof(struct brcmf_cfg80211_iface), busdev);
 	if (IS_ERR(wdev)) {
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index d221a3a..b94d60c 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -227,11 +227,9 @@ struct ampdu_info *brcms_c_ampdu_attach(struct brcms_c_info *wlc)
 	int i;
 
 	ampdu = kzalloc(sizeof(struct ampdu_info), GFP_ATOMIC);
-	if (!ampdu) {
-		wiphy_err(wlc->wiphy, "wl%d: brcms_c_ampdu_attach: out of mem"
-			  "\n", wlc->pub->unit);
+	if (!ampdu)
 		return NULL;
-	}
+
 	ampdu->wlc = wlc;
 
 	for (i = 0; i < AMPDU_MAX_SCB_TID; i++)
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index 29b51a1..c61c520 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -110,11 +110,8 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 	struct antsel_info *asi;
 
 	asi = kzalloc(sizeof(struct antsel_info), GFP_ATOMIC);
-	if (!asi) {
-		wiphy_err(wlc->wiphy, "wl%d: brcms_c_antsel_attach: out of "
-			  "mem\n", wlc->pub->unit);
+	if (!asi)
 		return NULL;
-	}
 
 	asi->wlc = wlc;
 	asi->pub = wlc->pub;
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index af01c9d..a9defe2 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -1090,11 +1090,8 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	wlc_cm = kzalloc(sizeof(struct brcms_cm_info), GFP_ATOMIC);
-	if (wlc_cm == NULL) {
-		wiphy_err(wlc->wiphy, "wl%d: %s: out of memory", pub->unit,
-			  __func__);
+	if (wlc_cm == NULL)
 		return NULL;
-	}
 	wlc_cm->pub = pub;
 	wlc_cm->wlc = wlc;
 	wlc->cmi = wlc_cm;
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 06990b3..714c74c 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -559,12 +559,8 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 
 	/* allocate private info structure */
 	di = kzalloc(sizeof(struct dma_info), GFP_ATOMIC);
-	if (di == NULL) {
-#ifdef BCMDBG
-		printk(KERN_ERR "dma_attach: out of memory\n");
-#endif
+	if (di == NULL)
 		return NULL;
-	}
 
 	di->msg_level = msg_level ? msg_level : &dma_msg_level;
 
@@ -651,22 +647,16 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	if (ntxd) {
 		size = ntxd * sizeof(void *);
 		di->txp = kzalloc(size, GFP_ATOMIC);
-		if (di->txp == NULL) {
-			DMA_ERROR(("%s: dma_attach: out of tx memory\n",
-				   di->name));
+		if (di->txp == NULL)
 			goto fail;
-		}
 	}
 
 	/* allocate rx packet pointer vector */
 	if (nrxd) {
 		size = nrxd * sizeof(void *);
 		di->rxp = kzalloc(size, GFP_ATOMIC);
-		if (di->rxp == NULL) {
-			DMA_ERROR(("%s: dma_attach: out of rx memory\n",
-				   di->name));
+		if (di->rxp == NULL)
 			goto fail;
-		}
 	}
 
 	/*
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 65d30b5..32d7abf 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -1541,11 +1541,8 @@ struct brcms_timer *brcms_init_timer(struct brcms_info *wl,
 	struct brcms_timer *t;
 
 	t = kzalloc(sizeof(struct brcms_timer), GFP_ATOMIC);
-	if (!t) {
-		wiphy_err(wl->wiphy, "wl%d: brcms_init_timer: out of memory\n",
-			  wl->pub->unit);
+	if (!t)
 		return NULL;
-	}
 
 	init_timer(&t->timer);
 	t->timer.data = (unsigned long) t;
@@ -1659,11 +1656,9 @@ int brcms_ucode_init_buf(struct brcms_info *wl, void **pbuf, u32 idx)
 				pdata = wl->fw.fw_bin[i]->data +
 					le32_to_cpu(hdr->offset);
 				*pbuf = kmalloc(len, GFP_ATOMIC);
-				if (*pbuf == NULL) {
-					wiphy_err(wl->wiphy, "fail to alloc %d"
-						  " bytes\n", len);
+				if (*pbuf == NULL)
 					goto fail;
-				}
+
 				memcpy(*pbuf, pdata, len);
 				return 0;
 			}
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index a2cab5c..f5a2695 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -245,9 +245,8 @@ struct pcicore_info *pcicore_init(struct si_pub *sih, struct pci_dev *pdev,
 
 	/* alloc struct pcicore_info */
 	pi = kzalloc(sizeof(struct pcicore_info), GFP_ATOMIC);
-	if (pi == NULL) {
+	if (pi == NULL)
 		return NULL;
-	}
 
 	pi->sih = sih;
 	pi->dev = pdev;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 31c9374..e0c19b6 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -41,12 +41,9 @@ struct phy_shim_info *wlc_phy_shim_attach(struct brcms_hardware *wlc_hw,
 	struct phy_shim_info *physhim = NULL;
 
 	physhim = kzalloc(sizeof(struct phy_shim_info), GFP_ATOMIC);
-	if (!physhim) {
-		wiphy_err(wlc_hw->wlc->wiphy,
-			  "wl%d: wlc_phy_shim_attach: out of mem\n",
-			  wlc_hw->unit);
+	if (!physhim)
 		return NULL;
-	}
+
 	physhim->wlc_hw = wlc_hw;
 	physhim->wlc = wlc;
 	physhim->wl = wl;
-- 
1.7.1


