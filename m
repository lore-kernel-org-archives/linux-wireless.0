Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4649 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758144Ab1F2XtI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:08 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 107/119] staging: brcm80211: removed unused code and
 definitions from fullmac
Date: Wed, 29 Jun 2011 16:48:11 -0700
Message-ID: <1309391303-22741-108-git-send-email-frankyl@broadcom.com> (sfid-20110630_015149_447592_A8C6FAA8)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdbus.h     |   21 ----
 drivers/staging/brcm80211/brcmfmac/bcmsdh.c       |   47 ---------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |   45 --------
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |   13 ---
 drivers/staging/brcm80211/brcmfmac/dhd.h          |   17 ---
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h      |   10 --
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c      |   10 --
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |   18 ----
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |  113 ---------------------
 drivers/staging/brcm80211/brcmfmac/dhd_proto.h    |    5 -
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |   23 ----
 drivers/staging/brcm80211/brcmfmac/sdio_host.h    |   23 ----
 12 files changed, 0 insertions(+), 345 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
index 3a09aa3..c4c6e54 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdbus.h
@@ -125,21 +125,10 @@ struct brcmf_sdmmc_instance {
 extern int  brcmf_sdioh_osinit(struct sdioh_info *sd);
 extern void brcmf_sdioh_osfree(struct sdioh_info *sd);
 
-/* OS-independent interrupt handler */
-extern bool brcmf_sdioh_check_client_intr(struct sdioh_info *sd);
-
 /* Core interrupt enable/disable of device interrupts */
 extern void brcmf_sdioh_dev_intr_on(struct sdioh_info *sd);
 extern void brcmf_sdioh_dev_intr_off(struct sdioh_info *sd);
 
-/* Register mapping routines */
-extern u32 *brcmf_sdioh_reg_map(s32 addr, int size);
-extern void brcmf_sdioh_reg_unmap(s32 addr, int size);
-
-/* Interrupt (de)registration routines */
-extern int  brcmf_sdioh_register_irq(struct sdioh_info *sd, uint irq);
-extern void brcmf_sdioh_free_irq(uint irq, struct sdioh_info *sd);
-
 /* attach, return handler on success, NULL if failed.
  *  The handler shall be provided by all subsequent calls. No local cache
  *  cfghdl points to the starting address of pci device mapped memory
@@ -153,10 +142,6 @@ brcmf_sdioh_interrupt_register(struct sdioh_info *si,
 
 extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *si);
 
-/* query whether SD interrupt is enabled or not */
-extern int
-brcmf_sdioh_interrupt_query(struct sdioh_info *si, bool *onoff);
-
 /* enable or disable SD interrupt */
 extern int
 brcmf_sdioh_interrupt_set(struct sdioh_info *si, bool enable_disable);
@@ -188,9 +173,6 @@ brcmf_sdioh_cfg_read(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
 extern int
 brcmf_sdioh_cfg_write(struct sdioh_info *si, uint fuc, u32 addr, u8 *data);
 
-/* query number of io functions */
-extern uint brcmf_sdioh_query_iofnum(struct sdioh_info *si);
-
 /* handle iovars */
 extern int brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 			  void *params, int plen, void *arg, int len, bool set);
@@ -198,9 +180,6 @@ extern int brcmf_sdioh_iovar_op(struct sdioh_info *si, const char *name,
 /* Issue abort to the specified function and clear controller as needed */
 extern int brcmf_sdioh_abort(struct sdioh_info *si, uint fnc);
 
-/* Helper function */
-void *brcmf_sdcard_get_sdioh(struct brcmf_sdio_card *card);
-
 /* Watchdog timer interface for pm ops */
 extern void brcmf_sdio_wdtmr_enable(bool enable);
 
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
index ae83403..84d1bcd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh.c
@@ -117,19 +117,6 @@ brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
 				    len, set);
 }
 
-bool brcmf_sdcard_intr_query(struct brcmf_sdio_card *card)
-{
-	int status;
-	bool on;
-
-	ASSERT(card);
-	status = brcmf_sdioh_interrupt_query(card->sdioh, &on);
-	if (status == 0)
-		return false;
-	else
-		return on;
-}
-
 int brcmf_sdcard_intr_enable(struct brcmf_sdio_card *card)
 {
 	ASSERT(card);
@@ -159,15 +146,6 @@ int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card)
 	return brcmf_sdioh_interrupt_deregister(card->sdioh);
 }
 
-int brcmf_sdcard_devremove_reg(struct brcmf_sdio_card *card,
-			       void (*fn)(void *), void *argh)
-{
-	ASSERT(card);
-
-	/* don't support yet */
-	return -ENOTSUPP;
-}
-
 u8 brcmf_sdcard_cfg_read(struct brcmf_sdio_card *card, uint fnc_num, u32 addr,
 			 int *err)
 {
@@ -551,26 +529,6 @@ int brcmf_sdcard_query_device(struct brcmf_sdio_card *card)
 	return card->vendevid;
 }
 
-uint brcmf_sdcard_query_iofnum(struct brcmf_sdio_card *card)
-{
-	if (!card)
-		card = l_card;
-
-	return brcmf_sdioh_query_iofnum(card->sdioh);
-}
-
-void *brcmf_sdcard_get_sdioh(struct brcmf_sdio_card *card)
-{
-	ASSERT(card);
-	return card->sdioh;
-}
-
-/* Function to pass device-status bits to DHD. */
-u32 brcmf_sdcard_get_dstatus(struct brcmf_sdio_card *card)
-{
-	return 0;
-}
-
 u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card)
 {
 	if (!card)
@@ -578,8 +536,3 @@ u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card)
 
 	return card->sbwad;
 }
-
-void brcmf_sdcard_chipinfo(struct brcmf_sdio_card *card, u32 chip, u32 chiprev)
-{
-	return;
-}
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 56e2435..45fb76e 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -58,51 +58,6 @@ static struct brcmf_sdioh_driver drvinfo = { NULL, NULL };
 /* debugging macros */
 #define SDLX_MSG(x)
 
-/**
- * Checks to see if vendor and device IDs match a supported SDIO Host Controller.
- */
-bool brcmf_sdio_chipmatch(u16 vendor, u16 device)
-{
-	/* Add other vendors and devices as required */
-
-#ifdef BCMSDIOH_STD
-	/* Check for Arasan host controller */
-	if (vendor == VENDOR_SI_IMAGE)
-		return true;
-
-	/* Check for BRCM 27XX Standard host controller */
-	if (device == BCM27XX_SDIOH_ID && vendor == PCI_VENDOR_ID_BROADCOM)
-		return true;
-
-	/* Check for BRCM Standard host controller */
-	if (device == SDIOH_FPGA_ID && vendor == PCI_VENDOR_ID_BROADCOM)
-		return true;
-
-	/* Check for TI PCIxx21 Standard host controller */
-	if (device == PCIXX21_SDIOH_ID && vendor == VENDOR_TI)
-		return true;
-
-	if (device == PCIXX21_SDIOH0_ID && vendor == VENDOR_TI)
-		return true;
-
-	/* Ricoh R5C822 Standard SDIO Host */
-	if (device == R5C822_SDIOH_ID && vendor == VENDOR_RICOH)
-		return true;
-
-	/* JMicron Standard SDIO Host */
-	if (device == JMICRON_SDIOH_ID && vendor == VENDOR_JMICRON)
-		return true;
-#endif				/* BCMSDIOH_STD */
-#ifdef BCMSDIOH_SPI
-	/* This is the PciSpiHost. */
-	if (device == SPIH_FPGA_ID && vendor == PCI_VENDOR_ID_BROADCOM) {
-		return true;
-	}
-#endif				/* BCMSDIOH_SPI */
-
-	return false;
-}
-
 /* forward declarations */
 int brcmf_sdio_probe(struct device *dev);
 EXPORT_SYMBOL(brcmf_sdio_probe);
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 2be9b08..1b55e56 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -244,19 +244,6 @@ extern int brcmf_sdioh_interrupt_deregister(struct sdioh_info *sd)
 	return 0;
 }
 
-extern int
-brcmf_sdioh_interrupt_query(struct sdioh_info *sd, bool *onoff)
-{
-	sd_trace(("%s: Entering\n", __func__));
-	*onoff = sd->client_intr_enabled;
-	return 0;
-}
-
-uint brcmf_sdioh_query_iofnum(struct sdioh_info *sd)
-{
-	return sd->num_funcs;
-}
-
 /* IOVar table */
 enum {
 	IOV_MSGLEVEL = 1,
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index a67d1ed..1540804 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -774,9 +774,6 @@ extern void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx,
 /* Return pointer to interface name */
 extern char *brcmf_ifname(struct brcmf_pub *drvr, int idx);
 
-/* Request scheduling of the bus dpc */
-extern void brcmf_sched_dpc(struct brcmf_pub *drvr);
-
 /* Notify tx completion */
 extern void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp,
 			     bool success);
@@ -793,12 +790,6 @@ extern int brcmf_os_ioctl_resp_wait(struct brcmf_pub *drvr, uint *condition,
 extern int brcmf_os_ioctl_resp_wake(struct brcmf_pub *drvr);
 extern unsigned int brcmf_os_get_ioctl_resp_timeout(void);
 extern void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec);
-extern void brcmf_os_sdlock_sndup_rxq(struct brcmf_pub *drvr);
-extern void brcmf_customer_gpio_wlan_ctrl(int onoff);
-extern int brcmf_custom_get_mac_address(unsigned char *buf);
-extern void brcmf_os_sdunlock_sndup_rxq(struct brcmf_pub *drvr);
-extern void brcmf_os_sdlock_eventq(struct brcmf_pub *drvr);
-extern void brcmf_os_sdunlock_eventq(struct brcmf_pub *drvr);
 #ifdef BCMDBG
 extern int brcmf_write_to_file(struct brcmf_pub *drvr, u8 *buf, int size);
 #endif				/* BCMDBG */
@@ -817,14 +808,6 @@ extern int brcmf_add_if(struct brcmf_info *drvr_priv, int ifidx, void *handle,
 		      char *name, u8 *mac_addr, u32 flags, u8 bssidx);
 extern void brcmf_del_if(struct brcmf_info *drvr_priv, int ifidx);
 
-extern void brcmf_vif_add(struct brcmf_info *drvr_priv, int ifidx, char *name);
-extern void brcmf_vif_del(struct brcmf_info *drvr_priv, int ifidx);
-
-extern void brcmf_event(struct brcmf_info *drvr_priv, char *evpkt, int evlen,
-			int ifidx);
-extern void brcmf_vif_sendup(struct brcmf_info *drvr_priv, int ifidx,
-			     unsigned char *cp, int len);
-
 /* Send packet to dongle via data channel */
 extern int brcmf_sendpkt(struct brcmf_pub *drvr, int ifidx,\
 			 struct sk_buff *pkt);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 50da972..a60aa41 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -54,9 +54,6 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen);
 extern int
 brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen);
 
-extern void dhd_bus_isr(bool *InterruptRecognized,
-			bool *QueueMiniportHandleInterrupt, void *arg);
-
 /* Check for and handle local prot-specific iovar commands */
 extern int brcmf_sdbrcm_bus_iovar_op(struct brcmf_pub *drvr, const char *name,
 			    void *params, int plen, void *arg, int len,
@@ -69,13 +66,6 @@ extern void brcmf_sdbrcm_bus_dump(struct brcmf_pub *drvr,
 /* Clear any bus counters */
 extern void brcmf_bus_clearcounts(struct brcmf_pub *drvr);
 
-/* return the dongle chipid */
-extern uint brcmf_bus_chip(struct brcmf_bus *bus);
-
-extern void *brcmf_bus_drvr(struct brcmf_bus *bus);
-extern void *brcmf_bus_txq(struct brcmf_bus *bus);
-extern uint brcmf_bus_hdrlen(struct brcmf_bus *bus);
-
 extern void brcmf_sdbrcm_wd_timer(struct brcmf_bus *bus, uint wdtick);
 
 #endif				/* _dhd_bus_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index d07860b..a1902f2 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -352,16 +352,6 @@ done:
 		(((struct sk_buff *)(skb))->ip_summed = \
 		((x) ? CHECKSUM_UNNECESSARY : CHECKSUM_NONE))
 
-/* PKTSETSUMNEEDED and PKTSUMGOOD are not possible because
-	skb->ip_summed is overloaded */
-
-int
-brcmf_proto_iovar_op(struct brcmf_pub *drvr, const char *name,
-		  void *params, int plen, void *arg, int len, bool set)
-{
-	return -ENOTSUPP;
-}
-
 void brcmf_proto_dump(struct brcmf_pub *drvr, struct brcmu_strbuf *strbuf)
 {
 	brcmu_bprintf(strbuf, "Protocol CDC: reqid %d\n", drvr->prot->reqid);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index ddc2085..ec6093e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -414,20 +414,6 @@ int brcmf_c_ioctl(struct brcmf_pub *drvr, struct brcmf_c_ioctl *ioc, void *buf,
 			if (bcmerror != -ENOTSUPP)
 				break;
 
-			/* not in generic table, try protocol module */
-			if (ioc->cmd == BRCMF_GET_VAR)
-				bcmerror = brcmf_proto_iovar_op(drvr, buf,
-								arg, arglen,
-								buf, buflen,
-								IOV_GET);
-			else
-				bcmerror = brcmf_proto_iovar_op(drvr, buf,
-								NULL, 0, arg,
-								arglen,
-								IOV_SET);
-			if (bcmerror != -ENOTSUPP)
-				break;
-
 			/* if still not found, try bus module */
 			if (ioc->cmd == BRCMF_GET_VAR)
 				bcmerror = brcmf_sdbrcm_bus_iovar_op(drvr,
@@ -815,8 +801,6 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 		}
 		/* send up the if event: btamp user needs it */
 		*ifidx = brcmf_ifname2idx(drvr_priv, event->ifname);
-		/* push up to external supp/auth */
-		brcmf_event(drvr_priv, (char *)pvt_data, evlen, *ifidx);
 		break;
 
 		/* These are what external supplicant/authenticator wants */
@@ -829,8 +813,6 @@ brcmf_c_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 		/* Fall through: this should get _everything_  */
 
 		*ifidx = brcmf_ifname2idx(drvr_priv, event->ifname);
-		/* push up to external supp/auth */
-		brcmf_event(drvr_priv, (char *)pvt_data, evlen, *ifidx);
 		DHD_TRACE(("%s: MAC event %d, flags %x, status %x\n",
 			   __func__, type, flags, status));
 
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index fc9abba..8db4609 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -188,24 +188,6 @@ static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktd
 			    struct brcmf_event_msg *event_ptr,
 			    void **data_ptr);
 
-static void brcmf_set_packet_filter(int value, struct brcmf_pub *drvr)
-{
-	DHD_TRACE(("%s: %d\n", __func__, value));
-	/* 1 - Enable packet filter, only allow unicast packet to send up */
-	/* 0 - Disable packet filter */
-	if (brcmf_pkt_filter_enable) {
-		int i;
-
-		for (i = 0; i < drvr->pktfilter_count; i++) {
-			brcmf_c_pktfilter_offload_set(drvr, drvr->pktfilter[i]);
-			brcmf_c_pktfilter_offload_enable(drvr,
-							 drvr->pktfilter[i],
-							 value,
-							 brcmf_master_mode);
-		}
-	}
-}
-
 #if defined(CONFIG_HAS_EARLYSUSPEND)
 static int brcmf_set_suspend(int value, struct brcmf_pub *drvr)
 {
@@ -933,12 +915,6 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 	}
 }
 
-void brcmf_event(struct brcmf_info *drvr_priv, char *evpkt, int evlen, int ifidx)
-{
-	/* Linux version has nothing to do */
-	return;
-}
-
 void brcmf_txcomplete(struct brcmf_pub *drvr, struct sk_buff *txp, bool success)
 {
 	uint ifidx;
@@ -1600,30 +1576,6 @@ int brcmf_bus_start(struct brcmf_pub *drvr)
 	return 0;
 }
 
-int brcmf_iovar(struct brcmf_pub *drvr, int ifidx, char *name, char *cmd_buf,
-	  uint cmd_len, int set)
-{
-	char buf[strlen(name) + 1 + cmd_len];
-	int len = sizeof(buf);
-	struct brcmf_ioctl ioc;
-	int ret;
-
-	len = brcmu_mkiovar(name, cmd_buf, cmd_len, buf, len);
-
-	memset(&ioc, 0, sizeof(ioc));
-
-	ioc.cmd = set ? BRCMF_C_SET_VAR : BRCMF_C_GET_VAR;
-	ioc.buf = buf;
-	ioc.len = len;
-	ioc.set = set;
-
-	ret = brcmf_proto_ioctl(drvr, ifidx, &ioc, ioc.buf, ioc.len);
-	if (!set && ret >= 0)
-		memcpy(cmd_buf, buf, cmd_len);
-
-	return ret;
-}
-
 static struct net_device_ops brcmf_netdev_ops_pri = {
 	.ndo_open = brcmf_netdev_open,
 	.ndo_stop = brcmf_netdev_stop,
@@ -1886,71 +1838,6 @@ int brcmf_netdev_reset(struct net_device *dev, u8 flag)
 	return 1;
 }
 
-int brcmf_netdev_set_suspend_disable(struct net_device *dev, int val)
-{
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(dev);
-	int ret = 0;
-
-	if (drvr_priv) {
-		ret = drvr_priv->pub.suspend_disable_flag;
-		drvr_priv->pub.suspend_disable_flag = val;
-	}
-	return ret;
-}
-
-int brcmf_netdev_set_suspend(struct net_device *dev, int val)
-{
-	int ret = 0;
-#if defined(CONFIG_HAS_EARLYSUSPEND)
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(dev);
-
-	if (drvr_priv) {
-		brcmf_os_proto_block(&drvr_priv->pub);
-		ret = brcmf_set_suspend(val, &drvr_priv->pub);
-		brcmf_os_proto_unblock(&drvr_priv->pub);
-	}
-#endif		/* defined(CONFIG_HAS_EARLYSUSPEND) */
-	return ret;
-}
-
-int brcmf_netdev_set_dtim_skip(struct net_device *dev, int val)
-{
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(dev);
-
-	if (drvr_priv)
-		drvr_priv->pub.dtim_skip = val;
-
-	return 0;
-}
-
-int brcmf_netdev_set_packet_filter(struct net_device *dev, int val)
-{
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **) netdev_priv(dev);
-	int ret = 0;
-
-	/* Packet filtering is set only if we still in early-suspend and
-	 * we need either to turn it ON or turn it OFF
-	 * We can always turn it OFF in case of early-suspend, but we turn it
-	 * back ON only if suspend_disable_flag was not set
-	 */
-	if (drvr_priv && drvr_priv->pub.up) {
-		brcmf_os_proto_block(&drvr_priv->pub);
-		if (drvr_priv->pub.in_suspend) {
-			if (!val || (val && !drvr_priv->pub.suspend_disable_flag))
-				brcmf_set_packet_filter(val, &drvr_priv->pub);
-		}
-		brcmf_os_proto_unblock(&drvr_priv->pub);
-	}
-	return ret;
-}
-
-void brcmf_netdev_init_ioctl(struct net_device *dev)
-{
-	struct brcmf_info *drvr_priv = *(struct brcmf_info **)netdev_priv(dev);
-
-	brcmf_c_preinit_ioctls(&drvr_priv->pub);
-}
-
 static int brcmf_get_pend_8021x_cnt(struct brcmf_info *drvr_priv)
 {
 	return atomic_read(&drvr_priv->pend_8021x_cnt);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
index afec597..0a76216 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_proto.h
@@ -57,11 +57,6 @@ extern int brcmf_proto_hdrpull(struct brcmf_pub *, int *ifidx,
 extern int brcmf_proto_ioctl(struct brcmf_pub *dhd, int ifidx,
 			     struct brcmf_ioctl *ioc, void *buf, int len);
 
-/* Check for and handle local prot-specific iovar commands */
-extern int brcmf_proto_iovar_op(struct brcmf_pub *dhdp, const char *name,
-				void *params, int plen, void *arg, int len,
-				bool set);
-
 /* Add prot dump output to a buffer */
 extern void brcmf_proto_dump(struct brcmf_pub *dhdp,
 			     struct brcmu_strbuf *strbuf);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 3cbfacb..25c5e90 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -5565,8 +5565,6 @@ brcmf_sdbrcm_probe_attach(struct brcmf_bus *bus, void *card, void *regsva,
 		goto fail;
 	}
 
-	brcmf_sdcard_chipinfo(card, bus->ci->chip, bus->ci->chiprev);
-
 	if (!brcmf_sdbrcm_chipmatch((u16) bus->ci->chip)) {
 		DHD_ERROR(("%s: unsupported chip: 0x%04x\n",
 			   __func__, bus->ci->chip));
@@ -6046,27 +6044,6 @@ brcmf_sdbrcm_send_buf(struct brcmf_bus *bus, u32 addr, uint fn, uint flags,
 		 handle);
 }
 
-uint brcmf_bus_chip(struct brcmf_bus *bus)
-{
-	ASSERT(bus->ci != NULL);
-	return bus->ci->chip;
-}
-
-void *brcmf_bus_drvr(struct brcmf_bus *bus)
-{
-	return bus->drvr;
-}
-
-void *brcmf_bus_txq(struct brcmf_bus *bus)
-{
-	return &bus->txq;
-}
-
-uint brcmf_bus_hdrlen(struct brcmf_bus *bus)
-{
-	return SDPCM_HDRLEN;
-}
-
 int brcmf_bus_devreset(struct brcmf_pub *drvr, u8 flag)
 {
 	int bcmerror = 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/sdio_host.h b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
index 5d2178d..68a2a64 100644
--- a/drivers/staging/brcm80211/brcmfmac/sdio_host.h
+++ b/drivers/staging/brcm80211/brcmfmac/sdio_host.h
@@ -58,9 +58,6 @@ extern struct brcmf_sdio_card *brcmf_sdcard_attach(void *cfghdl, void **regsva,
 /* Detach - freeup resources allocated in attach */
 extern int brcmf_sdcard_detach(struct brcmf_sdio_card *card);
 
-/* Query if SD device interrupts are enabled */
-extern bool brcmf_sdcard_intr_query(struct brcmf_sdio_card *card);
-
 /* Enable/disable SD interrupt */
 extern int brcmf_sdcard_intr_enable(struct brcmf_sdio_card *card);
 extern int brcmf_sdcard_intr_disable(struct brcmf_sdio_card *card);
@@ -72,13 +69,6 @@ brcmf_sdcard_intr_reg(struct brcmf_sdio_card *card,
 
 extern int brcmf_sdcard_intr_dereg(struct brcmf_sdio_card *card);
 
-/* Register a callback to be called on device removal.
- * No-op in the case of non-removable/hardwired devices.
- */
-extern int
-brcmf_sdcard_devremove_reg(struct brcmf_sdio_card *card,
-			   void (*fn)(void *), void *argh);
-
 /* Access SDIO address space (e.g. CCCR) using CMD52 (single-byte interface).
  *   fn:   function number
  *   addr: unmodified SDIO-space address
@@ -173,9 +163,6 @@ extern int brcmf_sdcard_abort(struct brcmf_sdio_card *card, uint fn);
 /* Returns the "Device ID" of target device on the SDIO bus. */
 extern int brcmf_sdcard_query_device(struct brcmf_sdio_card *card);
 
-/* Returns the number of IO functions reported by the device */
-extern uint brcmf_sdcard_query_iofnum(struct brcmf_sdio_card *card);
-
 /* Miscellaneous knob tweaker. */
 extern int brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
 				 void *params, int plen, void *arg, int len,
@@ -183,8 +170,6 @@ extern int brcmf_sdcard_iovar_op(struct brcmf_sdio_card *card, const char *name,
 
 /* helper functions */
 
-extern void *brcmf_sdcard_get_sdioh(struct brcmf_sdio_card *card);
-
 /* callback functions */
 struct brcmf_sdioh_driver {
 	/* attach to device */
@@ -200,19 +185,11 @@ struct sdioh_info;
 extern int brcmf_sdio_function_init(void);
 extern int brcmf_sdio_register(struct brcmf_sdioh_driver *driver);
 extern void brcmf_sdio_unregister(void);
-extern bool brcmf_sdio_chipmatch(u16 vendor, u16 device);
 extern void brcmf_sdio_function_cleanup(void);
 extern int brcmf_sdio_probe(struct device *dev);
 extern int brcmf_sdio_remove(struct device *dev);
 
-/* Function to pass device-status bits to DHD. */
-extern u32 brcmf_sdcard_get_dstatus(struct brcmf_sdio_card *card);
-
 /* Function to return current window addr */
 extern u32 brcmf_sdcard_cur_sbwad(struct brcmf_sdio_card *card);
 
-/* Function to pass chipid and rev to lower layers for controlling pr's */
-extern void brcmf_sdcard_chipinfo(struct brcmf_sdio_card *card, u32 chip,
-				  u32 chiprev);
-
 #endif				/* _BRCM_SDH_H_ */
-- 
1.7.1


