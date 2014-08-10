Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:65116 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbaHJOrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Aug 2014 10:47:53 -0400
Received: by mail-we0-f178.google.com with SMTP id w61so7670077wes.9
        for <linux-wireless@vger.kernel.org>; Sun, 10 Aug 2014 07:47:51 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 1/9] staging: vt6655: device.h use change __device_info to vnt_private
Date: Sun, 10 Aug 2014 15:46:55 +0100
Message-Id: <1407682023-2865-1-git-send-email-tvboxspy@gmail.com> (sfid-20140810_164759_652648_E3B11CAF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Coverting all functions to struct vnt_private in device.h and device_main.c

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h      |  19 +++--
 drivers/staging/vt6655/device_main.c | 158 ++++++++++++++++++-----------------
 2 files changed, 93 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 96d14da..878b6d2 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -337,9 +337,10 @@ typedef struct __device_opt {
 	u32         flags;
 } OPTIONS, *POPTIONS;
 
-typedef struct __device_info {
-	struct __device_info *next;
-	struct __device_info *prev;
+/* TODO Convert all functions to struct vnt_private and remove typedef */
+typedef struct vnt_private {
+	struct vnt_private *next;
+	struct vnt_private *prev;
 
 	struct pci_dev *pcid;
 
@@ -744,7 +745,8 @@ typedef struct __device_info {
 	bool bCommit;
 } DEVICE_INFO, *PSDevice;
 
-static inline bool device_get_ip(PSDevice pInfo) {
+static inline bool device_get_ip(struct vnt_private *pInfo)
+{
 	struct in_device *in_dev = (struct in_device *)pInfo->dev->ip_ptr;
 	struct in_ifaddr *ifa;
 
@@ -770,7 +772,10 @@ static inline PDEVICE_TD_INFO alloc_td_info(void)
 
 /*---------------------  Export Functions  --------------------------*/
 
-bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeIndex);
-bool device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF);
-int Config_FileOperation(PSDevice pDevice, bool fwrite, unsigned char *Parameter);
+bool device_dma0_xmit(struct vnt_private *pDevice,
+		      struct sk_buff *skb, unsigned int uNodeIndex);
+bool device_alloc_frag_buf(struct vnt_private *pDevice,
+			   PSDeFragControlBlock pDeF);
+int Config_FileOperation(struct vnt_private *pDevice,
+			 bool fwrite, unsigned char *Parameter);
 #endif
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index 8b98ce2..65de6c0 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -249,7 +249,7 @@ DEVICE_PARAM(bDiversityANTEnable, "ANT diversity mode");
 //
 
 static int          device_nics             = 0;
-static PSDevice     pDevice_Infos           = NULL;
+static struct vnt_private *pDevice_Infos = NULL;
 static struct net_device *root_device_dev = NULL;
 
 static CHIP_INFO chip_info_table[] = {
@@ -266,12 +266,13 @@ static const struct pci_device_id vt6655_pci_id_table[] = {
 /*---------------------  Static Functions  --------------------------*/
 
 static int  vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent);
-static void vt6655_init_info(struct pci_dev *pcid, PSDevice *ppDevice, PCHIP_INFO);
-static void device_free_info(PSDevice pDevice);
-static bool device_get_pci_info(PSDevice, struct pci_dev *pcid);
-static void device_print_info(PSDevice pDevice);
+static void vt6655_init_info(struct pci_dev *pcid,
+			     struct vnt_private **ppDevice, PCHIP_INFO);
+static void device_free_info(struct vnt_private *pDevice);
+static bool device_get_pci_info(struct vnt_private *, struct pci_dev *pcid);
+static void device_print_info(struct vnt_private *pDevice);
 static struct net_device_stats *device_get_stats(struct net_device *dev);
-static void device_init_diversity_timer(PSDevice pDevice);
+static void device_init_diversity_timer(struct vnt_private *pDevice);
 static int  device_open(struct net_device *dev);
 static int  device_xmit(struct sk_buff *skb, struct net_device *dev);
 static  irqreturn_t  device_intr(int irq,  void *dev_instance);
@@ -290,28 +291,28 @@ static struct notifier_block device_notifier = {
 };
 #endif
 
-static void device_init_rd0_ring(PSDevice pDevice);
-static void device_init_rd1_ring(PSDevice pDevice);
-static void device_init_defrag_cb(PSDevice pDevice);
-static void device_init_td0_ring(PSDevice pDevice);
-static void device_init_td1_ring(PSDevice pDevice);
+static void device_init_rd0_ring(struct vnt_private *pDevice);
+static void device_init_rd1_ring(struct vnt_private *pDevice);
+static void device_init_defrag_cb(struct vnt_private *pDevice);
+static void device_init_td0_ring(struct vnt_private *pDevice);
+static void device_init_td1_ring(struct vnt_private *pDevice);
 
 static int  device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev);
 //2008-0714<Add>by Mike Liu
-static bool device_release_WPADEV(PSDevice pDevice);
+static bool device_release_WPADEV(struct vnt_private *pDevice);
 
 static int  ethtool_ioctl(struct net_device *dev, void __user *useraddr);
-static int  device_rx_srv(PSDevice pDevice, unsigned int uIdx);
-static int  device_tx_srv(PSDevice pDevice, unsigned int uIdx);
-static bool device_alloc_rx_buf(PSDevice pDevice, PSRxDesc pDesc);
-static void device_init_registers(PSDevice pDevice);
-static void device_free_tx_buf(PSDevice pDevice, PSTxDesc pDesc);
-static void device_free_td0_ring(PSDevice pDevice);
-static void device_free_td1_ring(PSDevice pDevice);
-static void device_free_rd0_ring(PSDevice pDevice);
-static void device_free_rd1_ring(PSDevice pDevice);
-static void device_free_rings(PSDevice pDevice);
-static void device_free_frag_buf(PSDevice pDevice);
+static int  device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx);
+static int  device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx);
+static bool device_alloc_rx_buf(struct vnt_private *pDevice, PSRxDesc pDesc);
+static void device_init_registers(struct vnt_private *pDevice);
+static void device_free_tx_buf(struct vnt_private *pDevice, PSTxDesc pDesc);
+static void device_free_td0_ring(struct vnt_private *pDevice);
+static void device_free_td1_ring(struct vnt_private *pDevice);
+static void device_free_rd0_ring(struct vnt_private *pDevice);
+static void device_free_rd1_ring(struct vnt_private *pDevice);
+static void device_free_rings(struct vnt_private *pDevice);
+static void device_free_frag_buf(struct vnt_private *pDevice);
 static int Config_FileGetParameter(unsigned char *string,
 				   unsigned char *dest, unsigned char *source);
 
@@ -331,14 +332,15 @@ static char *get_chip_name(int chip_id)
 
 static void vt6655_remove(struct pci_dev *pcid)
 {
-	PSDevice pDevice = pci_get_drvdata(pcid);
+	struct vnt_private *pDevice = pci_get_drvdata(pcid);
 
 	if (pDevice == NULL)
 		return;
 	device_free_info(pDevice);
 }
 
-static void device_get_options(PSDevice pDevice, int index, char *devname)
+static void device_get_options(struct vnt_private *pDevice,
+			       int index, char *devname)
 {
 	POPTIONS pOpts = &(pDevice->sOpts);
 
@@ -363,7 +365,8 @@ static void device_get_options(PSDevice pDevice, int index, char *devname)
 }
 
 static void
-device_set_options(PSDevice pDevice) {
+device_set_options(struct vnt_private *pDevice)
+{
 	unsigned char abyBroadcastAddr[ETH_ALEN] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
 	unsigned char abySNAP_RFC1042[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0x00};
 	unsigned char abySNAP_Bridgetunnel[ETH_ALEN] = {0xAA, 0xAA, 0x03, 0x00, 0x00, 0xF8};
@@ -411,7 +414,8 @@ device_set_options(PSDevice pDevice) {
 	DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO " pDevice->bDiversityRegCtlON= %d\n", (int)pDevice->bDiversityRegCtlON);
 }
 
-static void s_vCompleteCurrentMeasure(PSDevice pDevice, unsigned char byResult)
+static void s_vCompleteCurrentMeasure(struct vnt_private *pDevice,
+				      unsigned char byResult)
 {
 	unsigned int ii;
 	unsigned long dwDuration = 0;
@@ -453,7 +457,7 @@ static void s_vCompleteCurrentMeasure(PSDevice pDevice, unsigned char byResult)
 // Initialisation of MAC & BBP registers
 //
 
-static void device_init_registers(PSDevice pDevice)
+static void device_init_registers(struct vnt_private *pDevice)
 {
 	unsigned int ii;
 	unsigned char byValue;
@@ -763,7 +767,7 @@ static void device_init_registers(PSDevice pDevice)
 	netif_stop_queue(pDevice->dev);
 }
 
-static void device_init_diversity_timer(PSDevice pDevice)
+static void device_init_diversity_timer(struct vnt_private *pDevice)
 {
 	init_timer(&pDevice->TimerSQ3Tmax1);
 	pDevice->TimerSQ3Tmax1.data = (unsigned long) pDevice;
@@ -781,7 +785,7 @@ static void device_init_diversity_timer(PSDevice pDevice)
 	pDevice->TimerSQ3Tmax3.expires = RUN_AT(HZ);
 }
 
-static bool device_release_WPADEV(PSDevice pDevice)
+static bool device_release_WPADEV(struct vnt_private *pDevice)
 {
 	viawget_wpa_header *wpahdr;
 	int ii = 0;
@@ -827,7 +831,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	static bool bFirst = true;
 	struct net_device *dev = NULL;
 	PCHIP_INFO  pChip_info = (PCHIP_INFO)ent->driver_data;
-	PSDevice    pDevice;
+	struct vnt_private *pDevice;
 	int         rc;
 
 	if (device_nics++ >= MAX_UINTS) {
@@ -837,7 +841,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 
 	dev = alloc_etherdev(sizeof(DEVICE_INFO));
 
-	pDevice = (PSDevice) netdev_priv(dev);
+	pDevice = netdev_priv(dev);
 
 	if (dev == NULL) {
 		pr_err(DEVICE_NAME ": allocate net device failed\n");
@@ -977,7 +981,7 @@ vt6655_probe(struct pci_dev *pcid, const struct pci_device_id *ent)
 	return 0;
 }
 
-static void device_print_info(PSDevice pDevice)
+static void device_print_info(struct vnt_private *pDevice)
 {
 	struct net_device *dev = pDevice->dev;
 
@@ -989,9 +993,11 @@ static void device_print_info(PSDevice pDevice)
 	DBG_PRT(MSG_LEVEL_INFO, KERN_INFO " IRQ=%d\n", pDevice->dev->irq);
 }
 
-static void vt6655_init_info(struct pci_dev *pcid, PSDevice *ppDevice,
-			     PCHIP_INFO pChip_info) {
-	PSDevice p;
+static void vt6655_init_info(struct pci_dev *pcid,
+			     struct vnt_private **ppDevice,
+			     PCHIP_INFO pChip_info)
+{
+	struct vnt_private *p;
 
 	memset(*ppDevice, 0, sizeof(DEVICE_INFO));
 
@@ -1013,7 +1019,8 @@ static void vt6655_init_info(struct pci_dev *pcid, PSDevice *ppDevice,
 	spin_lock_init(&((*ppDevice)->lock));
 }
 
-static bool device_get_pci_info(PSDevice pDevice, struct pci_dev *pcid)
+static bool device_get_pci_info(struct vnt_private *pDevice,
+				struct pci_dev *pcid)
 {
 	u16 pci_cmd;
 	u8  b;
@@ -1061,9 +1068,9 @@ static bool device_get_pci_info(PSDevice pDevice, struct pci_dev *pcid)
 	return true;
 }
 
-static void device_free_info(PSDevice pDevice)
+static void device_free_info(struct vnt_private *pDevice)
 {
-	PSDevice         ptr;
+	struct vnt_private *ptr;
 	struct net_device *dev = pDevice->dev;
 
 	ASSERT(pDevice);
@@ -1106,7 +1113,7 @@ static void device_free_info(PSDevice pDevice)
 		free_netdev(dev);
 }
 
-static bool device_init_rings(PSDevice pDevice)
+static bool device_init_rings(struct vnt_private *pDevice)
 {
 	void *vir_pool;
 
@@ -1198,7 +1205,7 @@ static bool device_init_rings(PSDevice pDevice)
 	return true;
 }
 
-static void device_free_rings(PSDevice pDevice)
+static void device_free_rings(struct vnt_private *pDevice)
 {
 	pci_free_consistent(pDevice->pcid,
 			    pDevice->sOpts.nRxDescs0 * sizeof(SRxDesc) +
@@ -1219,7 +1226,7 @@ static void device_free_rings(PSDevice pDevice)
 			);
 }
 
-static void device_init_rd0_ring(PSDevice pDevice)
+static void device_init_rd0_ring(struct vnt_private *pDevice)
 {
 	int i;
 	dma_addr_t      curr = pDevice->rd0_pool_dma;
@@ -1244,7 +1251,7 @@ static void device_init_rd0_ring(PSDevice pDevice)
 	pDevice->pCurrRD[0] = &(pDevice->aRD0Ring[0]);
 }
 
-static void device_init_rd1_ring(PSDevice pDevice)
+static void device_init_rd1_ring(struct vnt_private *pDevice)
 {
 	int i;
 	dma_addr_t      curr = pDevice->rd1_pool_dma;
@@ -1269,7 +1276,7 @@ static void device_init_rd1_ring(PSDevice pDevice)
 	pDevice->pCurrRD[1] = &(pDevice->aRD1Ring[0]);
 }
 
-static void device_init_defrag_cb(PSDevice pDevice)
+static void device_init_defrag_cb(struct vnt_private *pDevice)
 {
 	int i;
 	PSDeFragControlBlock pDeF;
@@ -1286,7 +1293,7 @@ static void device_init_defrag_cb(PSDevice pDevice)
 	pDevice->cbFreeDFCB = pDevice->cbDFCB;
 }
 
-static void device_free_rd0_ring(PSDevice pDevice)
+static void device_free_rd0_ring(struct vnt_private *pDevice)
 {
 	int i;
 
@@ -1303,7 +1310,7 @@ static void device_free_rd0_ring(PSDevice pDevice)
 	}
 }
 
-static void device_free_rd1_ring(PSDevice pDevice)
+static void device_free_rd1_ring(struct vnt_private *pDevice)
 {
 	int i;
 
@@ -1320,7 +1327,7 @@ static void device_free_rd1_ring(PSDevice pDevice)
 	}
 }
 
-static void device_free_frag_buf(PSDevice pDevice)
+static void device_free_frag_buf(struct vnt_private *pDevice)
 {
 	PSDeFragControlBlock pDeF;
 	int i;
@@ -1334,7 +1341,7 @@ static void device_free_frag_buf(PSDevice pDevice)
 	}
 }
 
-static void device_init_td0_ring(PSDevice pDevice)
+static void device_init_td0_ring(struct vnt_private *pDevice)
 {
 	int i;
 	dma_addr_t  curr;
@@ -1359,7 +1366,7 @@ static void device_init_td0_ring(PSDevice pDevice)
 	pDevice->apTailTD[0] = pDevice->apCurrTD[0] = &(pDevice->apTD0Rings[0]);
 }
 
-static void device_init_td1_ring(PSDevice pDevice)
+static void device_init_td1_ring(struct vnt_private *pDevice)
 {
 	int i;
 	dma_addr_t  curr;
@@ -1385,7 +1392,7 @@ static void device_init_td1_ring(PSDevice pDevice)
 	pDevice->apTailTD[1] = pDevice->apCurrTD[1] = &(pDevice->apTD1Rings[0]);
 }
 
-static void device_free_td0_ring(PSDevice pDevice)
+static void device_free_td0_ring(struct vnt_private *pDevice)
 {
 	int i;
 
@@ -1404,7 +1411,7 @@ static void device_free_td0_ring(PSDevice pDevice)
 	}
 }
 
-static void device_free_td1_ring(PSDevice pDevice)
+static void device_free_td1_ring(struct vnt_private *pDevice)
 {
 	int i;
 
@@ -1425,7 +1432,7 @@ static void device_free_td1_ring(PSDevice pDevice)
 
 /*-----------------------------------------------------------------*/
 
-static int device_rx_srv(PSDevice pDevice, unsigned int uIdx)
+static int device_rx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 {
 	PSRxDesc    pRD;
 	int works = 0;
@@ -1451,7 +1458,7 @@ static int device_rx_srv(PSDevice pDevice, unsigned int uIdx)
 	return works;
 }
 
-static bool device_alloc_rx_buf(PSDevice pDevice, PSRxDesc pRD)
+static bool device_alloc_rx_buf(struct vnt_private *pDevice, PSRxDesc pRD)
 {
 	PDEVICE_RD_INFO pRDInfo = pRD->pRDInfo;
 
@@ -1472,7 +1479,8 @@ static bool device_alloc_rx_buf(PSDevice pDevice, PSRxDesc pRD)
 	return true;
 }
 
-bool device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF)
+bool device_alloc_frag_buf(struct vnt_private *pDevice,
+			   PSDeFragControlBlock pDeF)
 {
 	pDeF->skb = dev_alloc_skb((int)pDevice->rx_buf_sz);
 	if (pDeF->skb == NULL)
@@ -1483,7 +1491,7 @@ bool device_alloc_frag_buf(PSDevice pDevice, PSDeFragControlBlock pDeF)
 	return true;
 }
 
-static int device_tx_srv(PSDevice pDevice, unsigned int uIdx)
+static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
 {
 	PSTxDesc                 pTD;
 	bool bFull = false;
@@ -1607,7 +1615,7 @@ static int device_tx_srv(PSDevice pDevice, unsigned int uIdx)
 	return works;
 }
 
-static void device_error(PSDevice pDevice, unsigned short status)
+static void device_error(struct vnt_private *pDevice, unsigned short status)
 {
 	if (status & ISR_FETALERR) {
 		DBG_PRT(MSG_LEVEL_ERR, KERN_ERR
@@ -1622,7 +1630,7 @@ static void device_error(PSDevice pDevice, unsigned short status)
 	}
 }
 
-static void device_free_tx_buf(PSDevice pDevice, PSTxDesc pDesc)
+static void device_free_tx_buf(struct vnt_private *pDevice, PSTxDesc pDesc)
 {
 	PDEVICE_TD_INFO  pTDInfo = pDesc->pTDInfo;
 	struct sk_buff *skb = pTDInfo->skb;
@@ -1643,7 +1651,7 @@ static void device_free_tx_buf(PSDevice pDevice, PSTxDesc pDesc)
 
 static int  device_open(struct net_device *dev)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	int i;
 #ifdef WPA_SM_Transtatus
 	extern SWPAResult wpa_Result;
@@ -1727,7 +1735,7 @@ static int  device_open(struct net_device *dev)
 
 static int  device_close(struct net_device *dev)
 {
-	PSDevice  pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject     pMgmt = pDevice->pMgmt;
 	//PLICE_DEBUG->
 //PLICE_DEBUG<-
@@ -1773,7 +1781,7 @@ static int  device_close(struct net_device *dev)
 
 static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev)
 {
-	PSDevice pDevice = netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 	unsigned char *pbMPDU;
 	unsigned int cbMPDULen = 0;
 
@@ -1803,7 +1811,8 @@ static int device_dma0_tx_80211(struct sk_buff *skb, struct net_device *dev)
 	return 0;
 }
 
-bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeIndex)
+bool device_dma0_xmit(struct vnt_private *pDevice,
+		      struct sk_buff *skb, unsigned int uNodeIndex)
 {
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	PSTxDesc        pHeadTD, pLastTD;
@@ -1943,10 +1952,8 @@ bool device_dma0_xmit(PSDevice pDevice, struct sk_buff *skb, unsigned int uNodeI
 }
 
 //TYPE_AC0DMA data tx
-static int  device_xmit(struct sk_buff *skb, struct net_device *dev)
-{
-	PSDevice pDevice = netdev_priv(dev);
-
+static int  device_xmit(struct sk_buff *skb, struct net_device *dev) {
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
 	PSTxDesc        pHeadTD, pLastTD;
 	unsigned int uNodeIndex = 0;
@@ -2298,8 +2305,7 @@ static int  device_xmit(struct sk_buff *skb, struct net_device *dev)
 static  irqreturn_t  device_intr(int irq,  void *dev_instance)
 {
 	struct net_device *dev = dev_instance;
-	PSDevice     pDevice = (PSDevice)netdev_priv(dev);
-
+	struct vnt_private *pDevice = netdev_priv(dev);
 	int             max_count = 0;
 	unsigned long dwMIBCounter = 0;
 	PSMgmtObject    pMgmt = pDevice->pMgmt;
@@ -2591,7 +2597,8 @@ static int Config_FileGetParameter(unsigned char *string,
 	return true;
 }
 
-int Config_FileOperation(PSDevice pDevice, bool fwrite, unsigned char *Parameter)
+int Config_FileOperation(struct vnt_private *pDevice,
+			 bool fwrite, unsigned char *Parameter)
 {
 	unsigned char *buffer = kmalloc(1024, GFP_KERNEL);
 	unsigned char tmpbuffer[20];
@@ -2638,10 +2645,8 @@ error1:
 	return result;
 }
 
-static void device_set_multi(struct net_device *dev)
-{
-	PSDevice         pDevice = (PSDevice)netdev_priv(dev);
-
+static void device_set_multi(struct net_device *dev) {
+	struct vnt_private *pDevice = netdev_priv(dev);
 	PSMgmtObject     pMgmt = pDevice->pMgmt;
 	u32              mc_filter[2];
 	struct netdev_hw_addr *ha;
@@ -2686,15 +2691,14 @@ static void device_set_multi(struct net_device *dev)
 
 static struct net_device_stats *device_get_stats(struct net_device *dev)
 {
-	PSDevice pDevice = (PSDevice)netdev_priv(dev);
+	struct vnt_private *pDevice = netdev_priv(dev);
 
 	return &pDevice->stats;
 }
 
 static int  device_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
 {
-	PSDevice	        pDevice = (PSDevice)netdev_priv(dev);
-
+	struct vnt_private *pDevice = netdev_priv(dev);
 	struct iwreq *wrq = (struct iwreq *)rq;
 	int rc = 0;
 	PSMgmtObject pMgmt = pDevice->pMgmt;
@@ -3191,7 +3195,7 @@ viawget_suspend(struct pci_dev *pcid, pm_message_t state)
 {
 	int power_status;   // to silence the compiler
 
-	PSDevice pDevice = pci_get_drvdata(pcid);
+	struct vnt_private *pDevice = pci_get_drvdata(pcid);
 	PSMgmtObject  pMgmt = pDevice->pMgmt;
 
 	netif_stop_queue(pDevice->dev);
@@ -3217,7 +3221,7 @@ viawget_suspend(struct pci_dev *pcid, pm_message_t state)
 static int
 viawget_resume(struct pci_dev *pcid)
 {
-	PSDevice  pDevice = pci_get_drvdata(pcid);
+	struct vnt_private *pDevice = pci_get_drvdata(pcid);
 	PSMgmtObject  pMgmt = pDevice->pMgmt;
 	int power_status;   // to silence the compiler
 
-- 
1.9.1

