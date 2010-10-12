Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:43534 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab0JLWJy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Oct 2010 18:09:54 -0400
Received: by mail-bw0-f46.google.com with SMTP id 15so2776714bwz.19
        for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 15:09:53 -0700 (PDT)
From: mike.rapoport@gmail.com
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Nohee Ko <noheek@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 2/7] staging: brcm80211: remove DHD_USE_STATIC_BUF
Date: Wed, 13 Oct 2010 00:09:08 +0200
Message-Id: <5c3e0a93c89de6625936c2ea27c8715a9fa45fe6.1286920620.git.mike.rapoport@gmail.com>
In-Reply-To: <cover.1286920620.git.mike.rapoport@gmail.com>
References: <cover.1286920620.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The DHD_USE_STATIC_BUF cannot be enabled in the build configuration,
remove it.

Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   17 --
 drivers/staging/brcm80211/brcmfmac/dhd.h          |    4 +-
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c      |   13 --
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   21 ---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   25 ---
 drivers/staging/brcm80211/include/linux_osl.h     |    5 -
 drivers/staging/brcm80211/util/linux_osl.c        |  180 ---------------------
 7 files changed, 1 insertions(+), 264 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 1f277a3..05c89ad 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -1040,11 +1040,7 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 	if (pkt == NULL) {
 		sd_data(("%s: Creating new %s Packet, len=%d\n",
 			 __func__, write ? "TX" : "RX", buflen_u));
-#ifdef DHD_USE_STATIC_BUF
-		mypkt = PKTGET_STATIC(sd->osh, buflen_u, write ? true : FALSE);
-#else
 		mypkt = PKTGET(sd->osh, buflen_u, write ? true : FALSE);
-#endif				/* DHD_USE_STATIC_BUF */
 		if (!mypkt) {
 			sd_err(("%s: PKTGET failed: len %d\n",
 				__func__, buflen_u));
@@ -1062,11 +1058,7 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 		if (!write)
 			bcopy(PKTDATA(mypkt), buffer, buflen_u);
 
-#ifdef DHD_USE_STATIC_BUF
-		PKTFREE_STATIC(sd->osh, mypkt, write ? true : FALSE);
-#else
 		PKTFREE(sd->osh, mypkt, write ? true : FALSE);
-#endif				/* DHD_USE_STATIC_BUF */
 	} else if (((u32) (PKTDATA(pkt)) & DMA_ALIGN_MASK) != 0) {
 		/* Case 2: We have a packet, but it is unaligned. */
 
@@ -1075,12 +1067,7 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 
 		sd_data(("%s: Creating aligned %s Packet, len=%d\n",
 			 __func__, write ? "TX" : "RX", PKTLEN(pkt)));
-#ifdef DHD_USE_STATIC_BUF
-		mypkt = PKTGET_STATIC(sd->osh, PKTLEN(pkt),
-					write ? true : FALSE);
-#else
 		mypkt = PKTGET(sd->osh, PKTLEN(pkt), write ? true : FALSE);
-#endif				/* DHD_USE_STATIC_BUF */
 		if (!mypkt) {
 			sd_err(("%s: PKTGET failed: len %d\n",
 				__func__, PKTLEN(pkt)));
@@ -1098,11 +1085,7 @@ sdioh_request_buffer(sdioh_info_t *sd, uint pio_dma, uint fix_inc, uint write,
 		if (!write)
 			bcopy(PKTDATA(mypkt), PKTDATA(pkt), PKTLEN(mypkt));
 
-#ifdef DHD_USE_STATIC_BUF
-		PKTFREE_STATIC(sd->osh, mypkt, write ? true : FALSE);
-#else
 		PKTFREE(sd->osh, mypkt, write ? true : FALSE);
-#endif				/* DHD_USE_STATIC_BUF */
 	} else {		/* case 3: We have a packet and
 				 it is aligned. */
 		sd_data(("%s: Aligned %s Packet, direct DMA\n",
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 8ec3ebd..e0749d7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -73,9 +73,7 @@ enum dhd_prealloc_index {
 	DHD_PREALLOC_DATABUF,
 	DHD_PREALLOC_OSL_BUF
 };
-#ifdef DHD_USE_STATIC_BUF
-extern void *dhd_os_prealloc(int section, unsigned long size);
-#endif
+
 /* Common structure for module and instance linkage */
 typedef struct dhd_pub {
 	/* Linkage ponters */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index a8c385f..6c52f2b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -406,20 +406,11 @@ int dhd_prot_attach(dhd_pub_t *dhd)
 {
 	dhd_prot_t *cdc;
 
-#ifndef DHD_USE_STATIC_BUF
 	cdc = (dhd_prot_t *) MALLOC(dhd->osh, sizeof(dhd_prot_t));
 	if (!cdc) {
 		DHD_ERROR(("%s: kmalloc failed\n", __func__));
 		goto fail;
 	}
-#else
-	cdc = (dhd_prot_t *) dhd_os_prealloc(DHD_PREALLOC_PROT,
-						sizeof(dhd_prot_t));
-	if (!cdc) {
-		DHD_ERROR(("%s: kmalloc failed\n", __func__));
-		goto fail;
-	}
-#endif				/* DHD_USE_STATIC_BUF */
 	memset(cdc, 0, sizeof(dhd_prot_t));
 
 	/* ensure that the msg buf directly follows the cdc msg struct */
@@ -436,19 +427,15 @@ int dhd_prot_attach(dhd_pub_t *dhd)
 	return 0;
 
 fail:
-#ifndef DHD_USE_STATIC_BUF
 	if (cdc != NULL)
 		MFREE(dhd->osh, cdc, sizeof(dhd_prot_t));
-#endif
 	return BCME_NOMEM;
 }
 
 /* ~NOTE~ What if another thread is waiting on the semaphore?  Holding it? */
 void dhd_prot_detach(dhd_pub_t *dhd)
 {
-#ifndef DHD_USE_STATIC_BUF
 	MFREE(dhd->osh, dhd->prot, sizeof(dhd_prot_t));
-#endif
 	dhd->prot = NULL;
 }
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 717e586..3bc2c4d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -2671,27 +2671,6 @@ void dhd_os_sdtxunlock(dhd_pub_t *pub)
 	dhd_os_sdunlock(pub);
 }
 
-#ifdef DHD_USE_STATIC_BUF
-void *dhd_os_prealloc(int section, unsigned long size)
-{
-#if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
-	void *alloc_ptr = NULL;
-	if (wifi_control_data && wifi_control_data->mem_prealloc) {
-		alloc_ptr = wifi_control_data->mem_prealloc(section, size);
-		if (alloc_ptr) {
-			DHD_INFO(("success alloc section %d\n", section));
-			bzero(alloc_ptr, size);
-			return alloc_ptr;
-		}
-	}
-
-	DHD_ERROR(("can't alloc section %d\n", section));
-	return 0;
-#else
-	return MALLOC(0, size);
-#endif	/* #if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC) */
-}
-#endif	/* DHD_USE_STATIC_BUF */
 #if defined(CONFIG_WIRELESS_EXT)
 struct iw_statistics *dhd_get_wireless_stats(struct net_device *dev)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 363db37..96ebba1 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -5382,7 +5382,6 @@ static bool dhdsdio_probe_malloc(dhd_bus_t *bus, osl_t *osh, void *sdh)
 {
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-#ifndef DHD_USE_STATIC_BUF
 	if (bus->dhd->maxctl) {
 		bus->rxblen =
 		    roundup((bus->dhd->maxctl + SDPCM_HDRLEN),
@@ -5405,26 +5404,6 @@ static bool dhdsdio_probe_malloc(dhd_bus_t *bus, osl_t *osh, void *sdh)
 			MFREE(osh, bus->rxbuf, bus->rxblen);
 		goto fail;
 	}
-#else
-	if (bus->dhd->maxctl) {
-		bus->rxblen =
-		    roundup((bus->dhd->maxctl + SDPCM_HDRLEN),
-			    ALIGNMENT) + DHD_SDALIGN;
-		bus->rxbuf = dhd_os_prealloc(DHD_PREALLOC_RXBUF, bus->rxblen);
-		if (!(bus->rxbuf)) {
-			DHD_ERROR(("%s: MALLOC of %d-byte rxbuf failed\n",
-				   __func__, bus->rxblen));
-			goto fail;
-		}
-	}
-	/* Allocate buffer to receive glomed packet */
-	bus->databuf = dhd_os_prealloc(DHD_PREALLOC_DATABUF, MAX_DATA_BUF);
-	if (!(bus->databuf)) {
-		DHD_ERROR(("%s: MALLOC of %d-byte databuf failed\n",
-			   __func__, MAX_DATA_BUF));
-		goto fail;
-	}
-#endif				/* DHD_USE_STATIC_BUF */
 
 	/* Align the buffer */
 	if ((uintptr) bus->databuf % DHD_SDALIGN)
@@ -5583,17 +5562,13 @@ static void dhdsdio_release_malloc(dhd_bus_t *bus, osl_t *osh)
 		return;
 
 	if (bus->rxbuf) {
-#ifndef DHD_USE_STATIC_BUF
 		MFREE(osh, bus->rxbuf, bus->rxblen);
-#endif
 		bus->rxctl = bus->rxbuf = NULL;
 		bus->rxlen = 0;
 	}
 
 	if (bus->databuf) {
-#ifndef DHD_USE_STATIC_BUF
 		MFREE(osh, bus->databuf, MAX_DATA_BUF);
-#endif
 		bus->databuf = NULL;
 	}
 }
diff --git a/drivers/staging/brcm80211/include/linux_osl.h b/drivers/staging/brcm80211/include/linux_osl.h
index 12c9c32..006452e 100644
--- a/drivers/staging/brcm80211/include/linux_osl.h
+++ b/drivers/staging/brcm80211/include/linux_osl.h
@@ -337,11 +337,6 @@ extern void *osl_pktget(osl_t *osh, uint len);
 extern void osl_pktfree(osl_t *osh, void *skb, bool send);
 
 #ifdef BRCM_FULLMAC
-#ifdef DHD_USE_STATIC_BUF
-#define	PKTGET_STATIC(osh, len, send)		osl_pktget_static((osh), (len))
-#define	PKTFREE_STATIC(osh, skb, send)	\
-	osl_pktfree_static((osh), (skb), (send))
-#endif
 extern void *osl_pktget_static(osl_t *osh, uint len);
 extern void osl_pktfree_static(osl_t *osh, void *skb, bool send);
 
diff --git a/drivers/staging/brcm80211/util/linux_osl.c b/drivers/staging/brcm80211/util/linux_osl.c
index f16731a..15c236a 100644
--- a/drivers/staging/brcm80211/util/linux_osl.c
+++ b/drivers/staging/brcm80211/util/linux_osl.c
@@ -33,28 +33,6 @@
 #define OS_HANDLE_MAGIC		0x1234abcd	/* Magic # to recognise osh */
 #define BCM_MEM_FILENAME_LEN 	24	/* Mem. filename length */
 
-#if defined(BRCM_FULLMAC) && defined(DHD_USE_STATIC_BUF)
-#define MAX_STATIC_BUF_NUM 16
-#define STATIC_BUF_SIZE	(PAGE_SIZE*2)
-#define STATIC_BUF_TOTAL_LEN (MAX_STATIC_BUF_NUM*STATIC_BUF_SIZE)
-typedef struct bcm_static_buf {
-	struct semaphore static_sem;
-	unsigned char *buf_ptr;
-	unsigned char buf_use[MAX_STATIC_BUF_NUM];
-} bcm_static_buf_t;
-
-static bcm_static_buf_t *bcm_static_buf;
-
-#define MAX_STATIC_PKT_NUM 8
-typedef struct bcm_static_pkt {
-	struct sk_buff *skb_4k[MAX_STATIC_PKT_NUM];
-	struct sk_buff *skb_8k[MAX_STATIC_PKT_NUM];
-	struct semaphore osl_pkt_sem;
-	unsigned char pkt_use[MAX_STATIC_PKT_NUM * 2];
-} bcm_static_pkt_t;
-static bcm_static_pkt_t *bcm_static_skb;
-#endif				/* DHD_USE_STATIC_BUF */
-
 struct osl_info {
 	osl_pubinfo_t pub;
 	uint magic;
@@ -174,39 +152,6 @@ osl_t *osl_attach(void *pdev, uint bustype, bool pkttag)
 		break;
 	}
 
-#if defined(BRCM_FULLMAC) && defined(DHD_USE_STATIC_BUF)
-	if (!bcm_static_buf) {
-		bcm_static_buf = (bcm_static_buf_t *) dhd_os_prealloc(3,
-					STATIC_BUF_SIZE + STATIC_BUF_TOTAL_LEN);
-		if (!bcm_static_buf) {
-			printk(KERN_ERR "can not alloc static buf!\n");
-		} else
-			printk(KERN_ERR "alloc static buf at %x!\n",
-			       (unsigned int)bcm_static_buf);
-
-		init_MUTEX(&bcm_static_buf->static_sem);
-
-		bcm_static_buf->buf_ptr =
-		    (unsigned char *)bcm_static_buf + STATIC_BUF_SIZE;
-
-	}
-
-	if (!bcm_static_skb) {
-		int i;
-		void *skb_buff_ptr = 0;
-		bcm_static_skb =
-		    (bcm_static_pkt_t *) ((char *)bcm_static_buf + 2048);
-		skb_buff_ptr = dhd_os_prealloc(4, 0);
-
-		bcopy(skb_buff_ptr, bcm_static_skb,
-		      sizeof(struct sk_buff *) * 16);
-		for (i = 0; i < MAX_STATIC_PKT_NUM * 2; i++)
-			bcm_static_skb->pkt_use[i] = 0;
-
-		init_MUTEX(&bcm_static_skb->osl_pkt_sem);
-	}
-#endif /* defined(BRCM_FULLMAC) && defined(DHD_USE_STATIC_BUF) */
-
 #if defined(BCMDBG) && !defined(BRCM_FULLMAC)
 	if (pkttag) {
 		struct sk_buff *skb;
@@ -221,13 +166,6 @@ void osl_detach(osl_t *osh)
 	if (osh == NULL)
 		return;
 
-#if defined(BRCM_FULLMAC) && defined(DHD_USE_STATIC_BUF)
-	if (bcm_static_buf)
-		bcm_static_buf = 0;
-
-	if (bcm_static_skb)
-		bcm_static_skb = 0;
-#endif
 	ASSERT(osh->magic == OS_HANDLE_MAGIC);
 	kfree(osh);
 }
@@ -282,73 +220,6 @@ void BCMFASTPATH osl_pktfree(osl_t *osh, void *p, bool send)
 	}
 }
 
-#if defined(BRCM_FULLMAC) && defined(DHD_USE_STATIC_BUF)
-void *osl_pktget_static(osl_t *osh, uint len)
-{
-	int i = 0;
-	struct sk_buff *skb;
-
-	if (len > (PAGE_SIZE * 2)) {
-		printk(KERN_ERR "Do we really need this big skb??\n");
-		return osl_pktget(osh, len);
-	}
-
-	down(&bcm_static_skb->osl_pkt_sem);
-	if (len <= PAGE_SIZE) {
-		for (i = 0; i < MAX_STATIC_PKT_NUM; i++) {
-			if (bcm_static_skb->pkt_use[i] == 0)
-				break;
-		}
-
-		if (i != MAX_STATIC_PKT_NUM) {
-			bcm_static_skb->pkt_use[i] = 1;
-			up(&bcm_static_skb->osl_pkt_sem);
-
-			skb = bcm_static_skb->skb_4k[i];
-			skb->tail = skb->data + len;
-			skb->len = len;
-
-			return skb;
-		}
-	}
-
-	for (i = 0; i < MAX_STATIC_PKT_NUM; i++) {
-		if (bcm_static_skb->pkt_use[i + MAX_STATIC_PKT_NUM] == 0)
-			break;
-	}
-
-	if (i != MAX_STATIC_PKT_NUM) {
-		bcm_static_skb->pkt_use[i + MAX_STATIC_PKT_NUM] = 1;
-		up(&bcm_static_skb->osl_pkt_sem);
-		skb = bcm_static_skb->skb_8k[i];
-		skb->tail = skb->data + len;
-		skb->len = len;
-
-		return skb;
-	}
-
-	up(&bcm_static_skb->osl_pkt_sem);
-	printk(KERN_ERR "all static pkt in use!\n");
-	return osl_pktget(osh, len);
-}
-
-void osl_pktfree_static(osl_t *osh, void *p, bool send)
-{
-	int i;
-
-	for (i = 0; i < MAX_STATIC_PKT_NUM * 2; i++) {
-		if (p == bcm_static_skb->skb_4k[i]) {
-			down(&bcm_static_skb->osl_pkt_sem);
-			bcm_static_skb->pkt_use[i] = 0;
-			up(&bcm_static_skb->osl_pkt_sem);
-
-			return;
-		}
-	}
-	return osl_pktfree(osh, p, send);
-}
-#endif /* defined(BRCM_FULLMAC) && defined(DHD_USE_STATIC_BUF) */
-
 u32 osl_pci_read_config(osl_t *osh, uint offset, uint size)
 {
 	uint val = 0;
@@ -422,35 +293,6 @@ void *osl_malloc(osl_t *osh, uint size)
 	if (osh)
 		ASSERT(osh->magic == OS_HANDLE_MAGIC);
 
-#if defined(BRCM_FULLMAC) && defined(DHD_USE_STATIC_BUF)
-		if (bcm_static_buf) {
-			int i = 0;
-			if ((size >= PAGE_SIZE) && (size <= STATIC_BUF_SIZE)) {
-				down(&bcm_static_buf->static_sem);
-				for (i = 0; i < MAX_STATIC_BUF_NUM; i++) {
-					if (bcm_static_buf->buf_use[i] == 0)
-						break;
-				}
-				if (i == MAX_STATIC_BUF_NUM) {
-					up(&bcm_static_buf->static_sem);
-					printk(KERN_ERR "all static buff in use!\n");
-					goto original;
-				}
-				bcm_static_buf->buf_use[i] = 1;
-				up(&bcm_static_buf->static_sem);
-
-				bzero(bcm_static_buf->buf_ptr + STATIC_BUF_SIZE * i,
-					  size);
-				if (osh)
-					osh->malloced += size;
-
-				return (void *)(bcm_static_buf->buf_ptr +
-						 STATIC_BUF_SIZE * i);
-			}
-		}
-	original:
-#endif /* defined(BRCM_FULLMAC) && defined(DHD_USE_STATIC_BUF) */
-
 	addr = kmalloc(size, GFP_ATOMIC);
 	if (addr == NULL) {
 		if (osh)
@@ -465,28 +307,6 @@ void *osl_malloc(osl_t *osh, uint size)
 
 void osl_mfree(osl_t *osh, void *addr, uint size)
 {
-#if defined(BRCM_FULLMAC) && defined(DHD_USE_STATIC_BUF)
-	if (bcm_static_buf) {
-		if ((addr > (void *)bcm_static_buf) && ((unsigned char *)addr
-				<= ((unsigned char *)
-				    bcm_static_buf +
-				    STATIC_BUF_TOTAL_LEN))) {
-			int buf_idx = 0;
-			buf_idx =
-			    ((unsigned char *)addr -
-			     bcm_static_buf->buf_ptr) / STATIC_BUF_SIZE;
-			down(&bcm_static_buf->static_sem);
-			bcm_static_buf->buf_use[buf_idx] = 0;
-			up(&bcm_static_buf->static_sem);
-
-			if (osh) {
-				ASSERT(osh->magic == OS_HANDLE_MAGIC);
-				osh->malloced -= size;
-			}
-			return;
-		}
-	}
-#endif /* defined(BRCM_FULLMAC) && defined(DHD_USE_STATIC_BUF) */
 	if (osh) {
 		ASSERT(osh->magic == OS_HANDLE_MAGIC);
 		osh->malloced -= size;
-- 
1.6.4.4

