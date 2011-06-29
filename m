Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4636 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757863Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 046/119] staging: brcm80211: rename fullmac functions
Date: Wed, 29 Jun 2011 16:47:10 -0700
Message-ID: <1309391303-22741-47-git-send-email-frankyl@broadcom.com> (sfid-20110630_014950_911448_59137D40)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function provided by dhd_linux.c have been renamed to make
the naming throughout the driver more consistent and remove
Broadcom specific acronyms which are not meaningful.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c  |    2 +-
 drivers/staging/brcm80211/brcmfmac/dhd.h           |   88 ++++++------
 drivers/staging/brcm80211/brcmfmac/dhd_cdc.c       |   20 ++--
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   24 ++--
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    6 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |  142 ++++++++++----------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |  132 +++++++++---------
 7 files changed, 209 insertions(+), 205 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 8007e90..3fabc08 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -169,7 +169,7 @@ int brcmf_sdio_probe(struct device *dev)
 #else
 	irq_flags = IRQF_TRIGGER_FALLING;
 #endif				/* HW_OOB */
-	irq = dhd_customer_oob_irq_map(&irq_flags);
+	irq = brcmf_customer_oob_irq_map(&irq_flags);
 	if (irq < 0) {
 		SDLX_MSG(("%s: Host irq is not defined\n", __func__));
 		return 1;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index bccda7f..d19d091 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -881,96 +881,98 @@ static inline void MUTEX_UNLOCK_WL_SCAN_SET(void)
  * Returned structure should have bus and prot pointers filled in.
  * bus_hdrlen specifies required headroom for bus module header.
  */
-extern dhd_pub_t *dhd_attach(struct dhd_bus *bus,
+extern dhd_pub_t *brcmf_attach(struct dhd_bus *bus,
 				uint bus_hdrlen);
-extern int dhd_net_attach(dhd_pub_t *dhdp, int idx);
+extern int brcmf_net_attach(dhd_pub_t *dhdp, int idx);
 
 /* Indication from bus module regarding removal/absence of dongle */
-extern void dhd_detach(dhd_pub_t *dhdp);
+extern void brcmf_detach(dhd_pub_t *dhdp);
 
 /* Indication from bus module to change flow-control state */
-extern void dhd_txflowcontrol(dhd_pub_t *dhdp, int ifidx, bool on);
+extern void brcmf_txflowcontrol(dhd_pub_t *dhdp, int ifidx, bool on);
 
 extern bool brcmf_c_prec_enq(dhd_pub_t *dhdp, struct pktq *q,
 			 struct sk_buff *pkt, int prec);
 
 /* Receive frame for delivery to OS.  Callee disposes of rxp. */
-extern void dhd_rx_frame(dhd_pub_t *dhdp, int ifidx,
+extern void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx,
 			 struct sk_buff *rxp, int numpkt);
 
 /* Return pointer to interface name */
-extern char *dhd_ifname(dhd_pub_t *dhdp, int idx);
+extern char *brcmf_ifname(dhd_pub_t *dhdp, int idx);
 
 /* Request scheduling of the bus dpc */
-extern void dhd_sched_dpc(dhd_pub_t *dhdp);
+extern void brcmf_sched_dpc(dhd_pub_t *dhdp);
 
 /* Notify tx completion */
-extern void dhd_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp, bool success);
+extern void brcmf_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp,
+			     bool success);
 
 /* Query ioctl */
 extern int dhdcdc_query_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf,
 			      uint len);
 
 /* OS independent layer functions */
-extern int dhd_os_proto_block(dhd_pub_t *pub);
-extern int dhd_os_proto_unblock(dhd_pub_t *pub);
-extern int dhd_os_ioctl_resp_wait(dhd_pub_t *pub, uint *condition,
+extern int brcmf_os_proto_block(dhd_pub_t *pub);
+extern int brcmf_os_proto_unblock(dhd_pub_t *pub);
+extern int brcmf_os_ioctl_resp_wait(dhd_pub_t *pub, uint *condition,
 				  bool *pending);
-extern int dhd_os_ioctl_resp_wake(dhd_pub_t *pub);
-extern unsigned int dhd_os_get_ioctl_resp_timeout(void);
-extern void dhd_os_set_ioctl_resp_timeout(unsigned int timeout_msec);
-extern void *dhd_os_open_image(char *filename);
-extern int dhd_os_get_image_block(char *buf, int len, void *image);
-extern void dhd_os_close_image(void *image);
-extern void dhd_os_wd_timer(void *bus, uint wdtick);
-extern void dhd_os_sdlock(dhd_pub_t *pub);
-extern void dhd_os_sdunlock(dhd_pub_t *pub);
-extern void dhd_os_sdlock_sndup_rxq(dhd_pub_t *pub);
-extern void dhd_customer_gpio_wlan_ctrl(int onoff);
-extern int dhd_custom_get_mac_address(unsigned char *buf);
-extern void dhd_os_sdunlock_sndup_rxq(dhd_pub_t *pub);
-extern void dhd_os_sdlock_eventq(dhd_pub_t *pub);
-extern void dhd_os_sdunlock_eventq(dhd_pub_t *pub);
+extern int brcmf_os_ioctl_resp_wake(dhd_pub_t *pub);
+extern unsigned int brcmf_os_get_ioctl_resp_timeout(void);
+extern void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec);
+extern void *brcmf_os_open_image(char *filename);
+extern int brcmf_os_get_image_block(char *buf, int len, void *image);
+extern void brcmf_os_close_image(void *image);
+extern void brcmf_os_wd_timer(void *bus, uint wdtick);
+extern void brcmf_os_sdlock(dhd_pub_t *pub);
+extern void brcmf_os_sdunlock(dhd_pub_t *pub);
+extern void brcmf_os_sdlock_sndup_rxq(dhd_pub_t *pub);
+extern void brcmf_customer_gpio_wlan_ctrl(int onoff);
+extern int brcmf_custom_get_mac_address(unsigned char *buf);
+extern void brcmf_os_sdunlock_sndup_rxq(dhd_pub_t *pub);
+extern void brcmf_os_sdlock_eventq(dhd_pub_t *pub);
+extern void brcmf_os_sdunlock_eventq(dhd_pub_t *pub);
 #ifdef DHD_DEBUG
-extern int write_to_file(dhd_pub_t *dhd, u8 *buf, int size);
+extern int brcmf_write_to_file(dhd_pub_t *dhd, u8 *buf, int size);
 #endif				/* DHD_DEBUG */
 #if defined(OOB_INTR_ONLY)
-extern int dhd_customer_oob_irq_map(unsigned long *irq_flags_ptr);
+extern int brcmf_customer_oob_irq_map(unsigned long *irq_flags_ptr);
 #endif				/* defined(OOB_INTR_ONLY) */
 
-extern void dhd_timeout_start(dhd_timeout_t *tmo, uint usec);
-extern int dhd_timeout_expired(dhd_timeout_t *tmo);
+extern void brcmf_timeout_start(dhd_timeout_t *tmo, uint usec);
+extern int brcmf_timeout_expired(dhd_timeout_t *tmo);
 
-extern int dhd_ifname2idx(struct dhd_info *dhd, char *name);
+extern int brcmf_ifname2idx(struct dhd_info *dhd, char *name);
 extern u8 *dhd_bssidx2bssid(dhd_pub_t *dhd, int idx);
 extern int brcmf_c_host_event(struct dhd_info *dhd, int *idx, void *pktdata,
 			 brcmf_event_msg_t *, void **data_ptr);
 
 extern void brcmf_c_init(void);
 
-extern int dhd_add_if(struct dhd_info *dhd, int ifidx, void *handle,
+extern int brcmf_add_if(struct dhd_info *dhd, int ifidx, void *handle,
 		      char *name, u8 *mac_addr, u32 flags, u8 bssidx);
-extern void dhd_del_if(struct dhd_info *dhd, int ifidx);
+extern void brcmf_del_if(struct dhd_info *dhd, int ifidx);
 
-extern void dhd_vif_add(struct dhd_info *dhd, int ifidx, char *name);
-extern void dhd_vif_del(struct dhd_info *dhd, int ifidx);
+extern void brcmf_vif_add(struct dhd_info *dhd, int ifidx, char *name);
+extern void brcmf_vif_del(struct dhd_info *dhd, int ifidx);
 
-extern void dhd_event(struct dhd_info *dhd, char *evpkt, int evlen, int ifidx);
-extern void dhd_vif_sendup(struct dhd_info *dhd, int ifidx, unsigned char * cp,
-			   int len);
+extern void brcmf_event(struct dhd_info *dhd, char *evpkt, int evlen,
+			int ifidx);
+extern void brcmf_vif_sendup(struct dhd_info *dhd, int ifidx,
+			     unsigned char *cp, int len);
 
 /* Send packet to dongle via data channel */
-extern int dhd_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pkt);
+extern int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pkt);
 
 /* Send event to host */
 extern void dhd_sendup_event(dhd_pub_t *dhdp, brcmf_event_msg_t *event,
 			     void *data);
-extern int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag);
+extern int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag);
 extern uint dhd_bus_status(dhd_pub_t *dhdp);
-extern int dhd_bus_start(dhd_pub_t *dhdp);
+extern int brcmf_bus_start(dhd_pub_t *dhdp);
 
-extern void dhd_wait_for_event(dhd_pub_t *dhd, bool * lockvar);
-extern void dhd_wait_event_wakeup(dhd_pub_t *dhd);
+extern void brcmf_wait_for_event(dhd_pub_t *dhd, bool * lockvar);
+extern void brcmf_wait_event_wakeup(dhd_pub_t *dhd);
 
 #ifdef PKT_FILTER_SUPPORT
 extern void brcmf_c_pktfilter_offload_set(dhd_pub_t *dhd, char *arg);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
index 0ed62a0..b229e05 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_cdc.c
@@ -204,7 +204,8 @@ retry:
 		goto retry;
 	if (id != prot->reqid) {
 		DHD_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
-			   dhd_ifname(dhd, ifidx), __func__, id, prot->reqid));
+			   brcmf_ifname(dhd, ifidx), __func__, id,
+			   prot->reqid));
 		ret = -EINVAL;
 		goto done;
 	}
@@ -264,7 +265,8 @@ int dhdcdc_set_ioctl(dhd_pub_t *dhd, int ifidx, uint cmd, void *buf, uint len)
 
 	if (id != prot->reqid) {
 		DHD_ERROR(("%s: %s: unexpected request id %d (expected %d)\n",
-			   dhd_ifname(dhd, ifidx), __func__, id, prot->reqid));
+			   brcmf_ifname(dhd, ifidx), __func__, id,
+			   prot->reqid));
 		ret = -EINVAL;
 		goto done;
 	}
@@ -292,7 +294,7 @@ dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf, int len)
 			   __func__));
 		return ret;
 	}
-	dhd_os_proto_block(dhd);
+	brcmf_os_proto_block(dhd);
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
@@ -346,7 +348,7 @@ dhd_prot_ioctl(dhd_pub_t *dhd, int ifidx, wl_ioctl_t *ioc, void *buf, int len)
 	prot->pending = false;
 
 done:
-	dhd_os_proto_unblock(dhd);
+	brcmf_os_proto_unblock(dhd);
 
 	return ret;
 }
@@ -427,14 +429,14 @@ int dhd_prot_hdrpull(dhd_pub_t *dhd, int *ifidx, struct sk_buff *pktbuf)
 	if (((h->flags & BDC_FLAG_VER_MASK) >> BDC_FLAG_VER_SHIFT) !=
 	    BDC_PROTO_VER) {
 		DHD_ERROR(("%s: non-BDC packet received, flags 0x%x\n",
-			   dhd_ifname(dhd, *ifidx), h->flags));
+			   brcmf_ifname(dhd, *ifidx), h->flags));
 		return -EBADE;
 	}
 
 	if (h->flags & BDC_FLAG_SUM_GOOD) {
 		DHD_INFO(("%s: BDC packet received with good rx-csum, "
 			"flags 0x%x\n",
-			dhd_ifname(dhd, *ifidx), h->flags));
+			brcmf_ifname(dhd, *ifidx), h->flags));
 		PKTSETSUMGOOD(pktbuf, true);
 	}
 
@@ -501,18 +503,18 @@ int dhd_prot_init(dhd_pub_t *dhd)
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
-	dhd_os_proto_block(dhd);
+	brcmf_os_proto_block(dhd);
 
 	/* Get the device MAC address */
 	strcpy(buf, "cur_etheraddr");
 	ret = dhdcdc_query_ioctl(dhd, 0, BRCMF_C_GET_VAR, buf, sizeof(buf));
 	if (ret < 0) {
-		dhd_os_proto_unblock(dhd);
+		brcmf_os_proto_unblock(dhd);
 		return ret;
 	}
 	memcpy(dhd->mac, buf, ETH_ALEN);
 
-	dhd_os_proto_unblock(dhd);
+	brcmf_os_proto_unblock(dhd);
 
 #ifdef EMBEDDED_PLATFORM
 	ret = brcmf_c_preinit_ioctls(dhd);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 9d604a6..e4680fb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -262,7 +262,7 @@ brcmf_c_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 			bcmerror = -ENOLINK;
 			break;
 		}
-		dhd_os_wd_timer(dhd_pub, (uint) int_val);
+		brcmf_os_wd_timer(dhd_pub, (uint) int_val);
 		break;
 
 	case IOV_GVAL(IOV_DUMP):
@@ -300,7 +300,7 @@ brcmf_c_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 		break;
 
 	case IOV_GVAL(IOV_IOCTLTIMEOUT):{
-			int_val = (s32) dhd_os_get_ioctl_resp_timeout();
+			int_val = (s32) brcmf_os_get_ioctl_resp_timeout();
 			memcpy(arg, &int_val, sizeof(int_val));
 			break;
 		}
@@ -309,7 +309,7 @@ brcmf_c_doiovar(dhd_pub_t *dhd_pub, const struct brcmu_iovar *vi, u32 actionid,
 			if (int_val <= 0)
 				bcmerror = -EINVAL;
 			else
-				dhd_os_set_ioctl_resp_timeout((unsigned int)
+				brcmf_os_set_ioctl_resp_timeout((unsigned int)
 							      int_val);
 			break;
 		}
@@ -865,13 +865,13 @@ brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 			if (ifevent->ifidx > 0 &&
 				 ifevent->ifidx < DHD_MAX_IFS) {
 				if (ifevent->action == BRCMF_E_IF_ADD)
-					dhd_add_if(dhd, ifevent->ifidx,
+					brcmf_add_if(dhd, ifevent->ifidx,
 						   NULL, event->ifname,
 						   pvt_data->eth.h_dest,
 						   ifevent->flags,
 						   ifevent->bssidx);
 				else
-					dhd_del_if(dhd, ifevent->ifidx);
+					brcmf_del_if(dhd, ifevent->ifidx);
 			} else {
 				DHD_ERROR(("%s: Invalid ifidx %d for %s\n",
 					   __func__, ifevent->ifidx,
@@ -879,9 +879,9 @@ brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 			}
 		}
 		/* send up the if event: btamp user needs it */
-		*ifidx = dhd_ifname2idx(dhd, event->ifname);
+		*ifidx = brcmf_ifname2idx(dhd, event->ifname);
 		/* push up to external supp/auth */
-		dhd_event(dhd, (char *)pvt_data, evlen, *ifidx);
+		brcmf_event(dhd, (char *)pvt_data, evlen, *ifidx);
 		break;
 
 #ifdef P2P
@@ -898,9 +898,9 @@ brcmf_c_host_event(struct dhd_info *dhd, int *ifidx, void *pktdata,
 	default:
 		/* Fall through: this should get _everything_  */
 
-		*ifidx = dhd_ifname2idx(dhd, event->ifname);
+		*ifidx = brcmf_ifname2idx(dhd, event->ifname);
 		/* push up to external supp/auth */
-		dhd_event(dhd, (char *)pvt_data, evlen, *ifidx);
+		brcmf_event(dhd, (char *)pvt_data, evlen, *ifidx);
 		DHD_TRACE(("%s: MAC event %d, flags %x, status %x\n",
 			   __func__, type, flags, status));
 
@@ -1207,7 +1207,7 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	u8 ea_addr[ETH_ALEN];
 #endif				/* GET_CUSTOM_MAC_ENABLE */
 
-	dhd_os_proto_block(dhd);
+	brcmf_os_proto_block(dhd);
 
 #ifdef GET_CUSTOM_MAC_ENABLE
 	/* Read MAC address from external customer place
@@ -1216,7 +1216,7 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	 ** firmware but unique per board mac address maybe provided by
 	 ** customer code
 	 */
-	ret = dhd_custom_get_mac_address(ea_addr);
+	ret = brcmf_custom_get_mac_address(ea_addr);
 	if (!ret) {
 		brcmu_mkiovar("cur_etheraddr", (void *)ea_addr, ETH_ALEN,
 			    buf, sizeof(buf));
@@ -1313,7 +1313,7 @@ int brcmf_c_preinit_ioctls(dhd_pub_t *dhd)
 	}
 #endif				/* PKT_FILTER_SUPPORT */
 
-	dhd_os_proto_unblock(dhd);
+	brcmf_os_proto_unblock(dhd);
 
 	return 0;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
index defc009..a60caea 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
@@ -52,7 +52,7 @@ static int dhd_oob_gpio_num = -1;	/* GG 19 */
 module_param(dhd_oob_gpio_num, int, 0644);
 MODULE_PARM_DESC(dhd_oob_gpio_num, "DHD oob gpio number");
 
-int dhd_customer_oob_irq_map(unsigned long *irq_flags_ptr)
+int brcmf_customer_oob_irq_map(unsigned long *irq_flags_ptr)
 {
 	int host_oob_irq = 0;
 
@@ -88,7 +88,7 @@ int dhd_customer_oob_irq_map(unsigned long *irq_flags_ptr)
 #endif				/* defined(OOB_INTR_ONLY) */
 
 /* Customer function to control hw specific wlan gpios */
-void dhd_customer_gpio_wlan_ctrl(int onoff)
+void brcmf_customer_gpio_wlan_ctrl(int onoff)
 {
 	switch (onoff) {
 	case WLAN_RESET_OFF:
@@ -137,7 +137,7 @@ void dhd_customer_gpio_wlan_ctrl(int onoff)
 
 #ifdef GET_CUSTOM_MAC_ENABLE
 /* Function to get custom MAC address */
-int dhd_custom_get_mac_address(unsigned char *buf)
+int brcmf_custom_get_mac_address(unsigned char *buf)
 {
 	WL_TRACE("%s Enter\n", __func__);
 	if (!buf)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index bebdd4d..928220c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -485,12 +485,12 @@ static void dhd_suspend_resume_helper(struct dhd_info *dhd, int val)
 {
 	dhd_pub_t *dhdp = &dhd->pub;
 
-	dhd_os_proto_block(dhdp);
+	brcmf_os_proto_block(dhdp);
 	/* Set flag when early suspend was called */
 	dhdp->in_suspend = val;
 	if (!dhdp->suspend_disable_flag)
 		dhd_set_suspend(val, dhdp);
-	dhd_os_proto_unblock(dhdp);
+	brcmf_os_proto_unblock(dhdp);
 }
 
 static void dhd_early_suspend(struct early_suspend *h)
@@ -520,15 +520,15 @@ static void dhd_late_resume(struct early_suspend *h)
  * back-off until
  * the sleep time reaches one jiffy, then switches over to task delay.  Usage:
  *
- *      dhd_timeout_start(&tmo, usec);
- *      while (!dhd_timeout_expired(&tmo))
+ *      brcmf_timeout_start(&tmo, usec);
+ *      while (!brcmf_timeout_expired(&tmo))
  *              if (poll_something())
  *                      break;
- *      if (dhd_timeout_expired(&tmo))
+ *      if (brcmf_timeout_expired(&tmo))
  *              fatal();
  */
 
-void dhd_timeout_start(dhd_timeout_t *tmo, uint usec)
+void brcmf_timeout_start(dhd_timeout_t *tmo, uint usec)
 {
 	tmo->limit = usec;
 	tmo->increment = 0;
@@ -536,7 +536,7 @@ void dhd_timeout_start(dhd_timeout_t *tmo, uint usec)
 	tmo->tick = 1000000 / HZ;
 }
 
-int dhd_timeout_expired(dhd_timeout_t *tmo)
+int brcmf_timeout_expired(dhd_timeout_t *tmo)
 {
 	/* Does nothing the first call */
 	if (tmo->increment == 0) {
@@ -587,7 +587,7 @@ static int dhd_net2idx(dhd_info_t *dhd, struct net_device *net)
 	return DHD_BAD_IF;
 }
 
-int dhd_ifname2idx(dhd_info_t *dhd, char *name)
+int brcmf_ifname2idx(dhd_info_t *dhd, char *name)
 {
 	int i = DHD_MAX_IFS;
 
@@ -606,7 +606,7 @@ int dhd_ifname2idx(dhd_info_t *dhd, char *name)
 	return i;		/* default - the primary interface */
 }
 
-char *dhd_ifname(dhd_pub_t *dhdp, int ifidx)
+char *brcmf_ifname(dhd_pub_t *dhdp, int ifidx)
 {
 	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
 
@@ -652,7 +652,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	bufp = buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!bufp) {
 		DHD_ERROR(("%s: out of memory for mcast_list, cnt %d\n",
-			   dhd_ifname(&dhd->pub, ifidx), cnt));
+			   brcmf_ifname(&dhd->pub, ifidx), cnt));
 		return;
 	}
 
@@ -680,7 +680,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set mcast_list failed, cnt %d\n",
-			   dhd_ifname(&dhd->pub, ifidx), cnt));
+			   brcmf_ifname(&dhd->pub, ifidx), cnt));
 		allmulti = cnt ? true : allmulti;
 	}
 
@@ -695,7 +695,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	buf = kmalloc(buflen, GFP_ATOMIC);
 	if (!buf) {
 		DHD_ERROR(("%s: out of memory for allmulti\n",
-			   dhd_ifname(&dhd->pub, ifidx)));
+			   brcmf_ifname(&dhd->pub, ifidx)));
 		return;
 	}
 	allmulti = cpu_to_le32(allmulti);
@@ -703,7 +703,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	if (!brcmu_mkiovar
 	    ("allmulti", (void *)&allmulti, sizeof(allmulti), buf, buflen)) {
 		DHD_ERROR(("%s: mkiovar failed for allmulti, datalen %d "
-			"buflen %u\n", dhd_ifname(&dhd->pub, ifidx),
+			"buflen %u\n", brcmf_ifname(&dhd->pub, ifidx),
 			(int)sizeof(allmulti), buflen));
 		kfree(buf);
 		return;
@@ -718,7 +718,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set allmulti %d failed\n",
-			   dhd_ifname(&dhd->pub, ifidx),
+			   brcmf_ifname(&dhd->pub, ifidx),
 			   le32_to_cpu(allmulti)));
 	}
 
@@ -739,7 +739,7 @@ static void _dhd_set_multicast_list(dhd_info_t *dhd, int ifidx)
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set promisc %d failed\n",
-			   dhd_ifname(&dhd->pub, ifidx),
+			   brcmf_ifname(&dhd->pub, ifidx),
 			   le32_to_cpu(allmulti)));
 	}
 }
@@ -755,7 +755,7 @@ _dhd_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
 	if (!brcmu_mkiovar
 	    ("cur_etheraddr", (char *)addr, ETH_ALEN, buf, 32)) {
 		DHD_ERROR(("%s: mkiovar failed for cur_etheraddr\n",
-			   dhd_ifname(&dhd->pub, ifidx)));
+			   brcmf_ifname(&dhd->pub, ifidx)));
 		return -1;
 	}
 	memset(&ioc, 0, sizeof(ioc));
@@ -767,7 +767,7 @@ _dhd_set_mac_address(dhd_info_t *dhd, int ifidx, u8 *addr)
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: set cur_etheraddr failed\n",
-			   dhd_ifname(&dhd->pub, ifidx)));
+			   brcmf_ifname(&dhd->pub, ifidx)));
 	} else {
 		memcpy(dhd->iflist[ifidx]->net->dev_addr, addr, ETH_ALEN);
 	}
@@ -813,7 +813,7 @@ static void dhd_op_if(dhd_if_t *ifp)
 		if (ret == 0) {
 			strcpy(ifp->net->name, ifp->name);
 			memcpy(netdev_priv(ifp->net), &dhd, sizeof(dhd));
-			err = dhd_net_attach(&dhd->pub, ifp->idx);
+			err = brcmf_net_attach(&dhd->pub, ifp->idx);
 			if (err != 0) {
 				DHD_ERROR(("%s: dhd_net_attach failed, "
 					"err %d\n",
@@ -960,7 +960,7 @@ static void dhd_set_multicast_list(struct net_device *dev)
 	up(&dhd->sysioc_sem);
 }
 
-int dhd_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
+int brcmf_sendpkt(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf)
 {
 	int ret;
 	dhd_info_t *dhd = (dhd_info_t *) (dhdp->info);
@@ -1038,14 +1038,14 @@ static int dhd_start_xmit(struct sk_buff *skb, struct net_device *net)
 		struct sk_buff *skb2;
 
 		DHD_INFO(("%s: insufficient headroom\n",
-			  dhd_ifname(&dhd->pub, ifidx)));
+			  brcmf_ifname(&dhd->pub, ifidx)));
 		dhd->pub.tx_realloc++;
 		skb2 = skb_realloc_headroom(skb, dhd->pub.hdrlen);
 		dev_kfree_skb(skb);
 		skb = skb2;
 		if (skb == NULL) {
 			DHD_ERROR(("%s: skb_realloc_headroom failed\n",
-				   dhd_ifname(&dhd->pub, ifidx)));
+				   brcmf_ifname(&dhd->pub, ifidx)));
 			ret = -ENOMEM;
 			goto done;
 		}
@@ -1055,13 +1055,13 @@ static int dhd_start_xmit(struct sk_buff *skb, struct net_device *net)
 	pktbuf = PKTFRMNATIVE(dhd->pub.osh, skb);
 	if (!pktbuf) {
 		DHD_ERROR(("%s: PKTFRMNATIVE failed\n",
-			   dhd_ifname(&dhd->pub, ifidx)));
+			   brcmf_ifname(&dhd->pub, ifidx)));
 		dev_kfree_skb_any(skb);
 		ret = -ENOMEM;
 		goto done;
 	}
 
-	ret = dhd_sendpkt(&dhd->pub, ifidx, pktbuf);
+	ret = brcmf_sendpkt(&dhd->pub, ifidx, pktbuf);
 
 done:
 	if (ret)
@@ -1073,7 +1073,7 @@ done:
 	return 0;
 }
 
-void dhd_txflowcontrol(dhd_pub_t *dhdp, int ifidx, bool state)
+void brcmf_txflowcontrol(dhd_pub_t *dhdp, int ifidx, bool state)
 {
 	struct net_device *net;
 	dhd_info_t *dhd = dhdp->info;
@@ -1089,7 +1089,7 @@ void dhd_txflowcontrol(dhd_pub_t *dhdp, int ifidx, bool state)
 		netif_wake_queue(net);
 }
 
-void dhd_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf,
+void brcmf_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf,
 		  int numpkt)
 {
 	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
@@ -1175,13 +1175,13 @@ void dhd_rx_frame(dhd_pub_t *dhdp, int ifidx, struct sk_buff *pktbuf,
 	}
 }
 
-void dhd_event(struct dhd_info *dhd, char *evpkt, int evlen, int ifidx)
+void brcmf_event(struct dhd_info *dhd, char *evpkt, int evlen, int ifidx)
 {
 	/* Linux version has nothing to do */
 	return;
 }
 
-void dhd_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp, bool success)
+void brcmf_txcomplete(dhd_pub_t *dhdp, struct sk_buff *txp, bool success)
 {
 	uint ifidx;
 	dhd_info_t *dhd = (dhd_info_t *) (dhdp->info);
@@ -1345,7 +1345,7 @@ static void dhd_dpc(unsigned long data)
 	}
 }
 
-void dhd_sched_dpc(dhd_pub_t *dhdp)
+void brcmf_sched_dpc(dhd_pub_t *dhdp)
 {
 	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
 
@@ -1379,12 +1379,12 @@ static int dhd_toe_get(dhd_info_t *dhd, int ifidx, u32 *toe_ol)
 		/* Check for older dongle image that doesn't support toe_ol */
 		if (ret == -EIO) {
 			DHD_ERROR(("%s: toe not supported by device\n",
-				   dhd_ifname(&dhd->pub, ifidx)));
+				   brcmf_ifname(&dhd->pub, ifidx)));
 			return -EOPNOTSUPP;
 		}
 
 		DHD_INFO(("%s: could not get toe_ol: ret=%d\n",
-			  dhd_ifname(&dhd->pub, ifidx), ret));
+			  brcmf_ifname(&dhd->pub, ifidx), ret));
 		return ret;
 	}
 
@@ -1415,7 +1415,7 @@ static int dhd_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: could not set toe_ol: ret=%d\n",
-			   dhd_ifname(&dhd->pub, ifidx), ret));
+			   brcmf_ifname(&dhd->pub, ifidx), ret));
 		return ret;
 	}
 
@@ -1429,7 +1429,7 @@ static int dhd_toe_set(dhd_info_t *dhd, int ifidx, u32 toe_ol)
 	ret = dhd_prot_ioctl(&dhd->pub, ifidx, &ioc, ioc.buf, ioc.len);
 	if (ret < 0) {
 		DHD_ERROR(("%s: could not set toe: ret=%d\n",
-			   dhd_ifname(&dhd->pub, ifidx), ret));
+			   brcmf_ifname(&dhd->pub, ifidx), ret));
 		return ret;
 	}
 
@@ -1716,7 +1716,7 @@ static int dhd_open(struct net_device *net)
 	if (ifidx == 0) {	/* do it only for primary eth0 */
 
 		/* try to bring up bus */
-		ret = dhd_bus_start(&dhd->pub);
+		ret = brcmf_bus_start(&dhd->pub);
 		if (ret != 0) {
 			DHD_ERROR(("%s: failed with code %d\n", __func__, ret));
 			return -1;
@@ -1747,7 +1747,7 @@ static int dhd_open(struct net_device *net)
 }
 
 int
-dhd_add_if(dhd_info_t *dhd, int ifidx, void *handle, char *name,
+brcmf_add_if(dhd_info_t *dhd, int ifidx, void *handle, char *name,
 	   u8 *mac_addr, u32 flags, u8 bssidx)
 {
 	dhd_if_t *ifp;
@@ -1783,7 +1783,7 @@ dhd_add_if(dhd_info_t *dhd, int ifidx, void *handle, char *name,
 	return 0;
 }
 
-void dhd_del_if(dhd_info_t *dhd, int ifidx)
+void brcmf_del_if(dhd_info_t *dhd, int ifidx)
 {
 	dhd_if_t *ifp;
 
@@ -1802,7 +1802,7 @@ void dhd_del_if(dhd_info_t *dhd, int ifidx)
 	up(&dhd->sysioc_sem);
 }
 
-dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
+dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 {
 	dhd_info_t *dhd = NULL;
 	struct net_device *net;
@@ -1846,7 +1846,7 @@ dhd_pub_t *dhd_attach(struct dhd_bus *bus, uint bus_hdrlen)
 			strcat(net->name, "%d");
 	}
 
-	if (dhd_add_if(dhd, 0, (void *)net, net->name, NULL, 0, 0) ==
+	if (brcmf_add_if(dhd, 0, (void *)net, net->name, NULL, 0, 0) ==
 	    DHD_BAD_IF)
 		goto fail;
 
@@ -1961,12 +1961,12 @@ fail:
 	if (net)
 		free_netdev(net);
 	if (dhd)
-		dhd_detach(&dhd->pub);
+		brcmf_detach(&dhd->pub);
 
 	return NULL;
 }
 
-int dhd_bus_start(dhd_pub_t *dhdp)
+int brcmf_bus_start(dhd_pub_t *dhdp)
 {
 	int ret = -1;
 	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
@@ -1992,7 +1992,7 @@ int dhd_bus_start(dhd_pub_t *dhdp)
 
 	/* Start the watchdog timer */
 	dhd->pub.tickcnt = 0;
-	dhd_os_wd_timer(&dhd->pub, brcmf_watchdog_ms);
+	brcmf_os_wd_timer(&dhd->pub, brcmf_watchdog_ms);
 
 	/* Bring up the bus */
 	ret = brcmf_sdbrcm_bus_init(&dhd->pub, true);
@@ -2099,7 +2099,7 @@ static struct net_device_ops dhd_ops_pri = {
 	.ndo_set_multicast_list = dhd_set_multicast_list
 };
 
-int dhd_net_attach(dhd_pub_t *dhdp, int ifidx)
+int brcmf_net_attach(dhd_pub_t *dhdp, int ifidx)
 {
 	dhd_info_t *dhd = (dhd_info_t *) dhdp->info;
 	struct net_device *net;
@@ -2179,7 +2179,7 @@ void dhd_bus_detach(dhd_pub_t *dhdp)
 	}
 }
 
-void dhd_detach(dhd_pub_t *dhdp)
+void brcmf_detach(dhd_pub_t *dhdp)
 {
 	dhd_info_t *dhd;
 
@@ -2198,7 +2198,7 @@ void dhd_detach(dhd_pub_t *dhdp)
 
 			for (i = 1; i < DHD_MAX_IFS; i++)
 				if (dhd->iflist[i])
-					dhd_del_if(dhd, i);
+					brcmf_del_if(dhd, i);
 
 			ifp = dhd->iflist[0];
 			ASSERT(ifp);
@@ -2250,7 +2250,7 @@ static void __exit dhd_module_cleanup(void)
 	wifi_del_dev();
 #endif
 	/* Call customer gpio to turn off power with WL_REG_ON signal */
-	dhd_customer_gpio_wlan_ctrl(WLAN_POWER_OFF);
+	brcmf_customer_gpio_wlan_ctrl(WLAN_POWER_OFF);
 }
 
 static int __init dhd_module_init(void)
@@ -2274,7 +2274,7 @@ static int __init dhd_module_init(void)
 		return -EINVAL;
 	} while (0);
 	/* Call customer gpio to turn on power with WL_REG_ON signal */
-	dhd_customer_gpio_wlan_ctrl(WLAN_POWER_ON);
+	brcmf_customer_gpio_wlan_ctrl(WLAN_POWER_ON);
 
 #if defined(CUSTOMER_HW2) && defined(CONFIG_WIFI_CONTROL_FUNC)
 	sema_init(&wifi_control_sem, 0);
@@ -2306,7 +2306,7 @@ static int __init dhd_module_init(void)
 
 failed:
 	/* turn off power and exit */
-	dhd_customer_gpio_wlan_ctrl(WLAN_POWER_OFF);
+	brcmf_customer_gpio_wlan_ctrl(WLAN_POWER_OFF);
 	return -EINVAL;
 }
 
@@ -2316,7 +2316,7 @@ module_exit(dhd_module_cleanup);
 /*
  * OS specific functions required to implement DHD driver in OS independent way
  */
-int dhd_os_proto_block(dhd_pub_t *pub)
+int brcmf_os_proto_block(dhd_pub_t *pub)
 {
 	dhd_info_t *dhd = (dhd_info_t *) (pub->info);
 
@@ -2327,7 +2327,7 @@ int dhd_os_proto_block(dhd_pub_t *pub)
 	return 0;
 }
 
-int dhd_os_proto_unblock(dhd_pub_t *pub)
+int brcmf_os_proto_unblock(dhd_pub_t *pub)
 {
 	dhd_info_t *dhd = (dhd_info_t *) (pub->info);
 
@@ -2339,17 +2339,17 @@ int dhd_os_proto_unblock(dhd_pub_t *pub)
 	return 0;
 }
 
-unsigned int dhd_os_get_ioctl_resp_timeout(void)
+unsigned int brcmf_os_get_ioctl_resp_timeout(void)
 {
 	return (unsigned int)dhd_ioctl_timeout_msec;
 }
 
-void dhd_os_set_ioctl_resp_timeout(unsigned int timeout_msec)
+void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec)
 {
 	dhd_ioctl_timeout_msec = (int)timeout_msec;
 }
 
-int dhd_os_ioctl_resp_wait(dhd_pub_t *pub, uint *condition, bool *pending)
+int brcmf_os_ioctl_resp_wait(dhd_pub_t *pub, uint *condition, bool *pending)
 {
 	dhd_info_t *dhd = (dhd_info_t *) (pub->info);
 	DECLARE_WAITQUEUE(wait, current);
@@ -2374,7 +2374,7 @@ int dhd_os_ioctl_resp_wait(dhd_pub_t *pub, uint *condition, bool *pending)
 	return timeout;
 }
 
-int dhd_os_ioctl_resp_wake(dhd_pub_t *pub)
+int brcmf_os_ioctl_resp_wake(dhd_pub_t *pub)
 {
 	dhd_info_t *dhd = (dhd_info_t *) (pub->info);
 
@@ -2384,7 +2384,7 @@ int dhd_os_ioctl_resp_wake(dhd_pub_t *pub)
 	return 0;
 }
 
-void dhd_os_wd_timer(void *bus, uint wdtick)
+void brcmf_os_wd_timer(void *bus, uint wdtick)
 {
 	dhd_pub_t *pub = bus;
 	static uint save_dhd_watchdog_ms;
@@ -2429,7 +2429,7 @@ void dhd_os_wd_timer(void *bus, uint wdtick)
 	}
 }
 
-void *dhd_os_open_image(char *filename)
+void *brcmf_os_open_image(char *filename)
 {
 	struct file *fp;
 
@@ -2449,7 +2449,7 @@ void *dhd_os_open_image(char *filename)
 	return fp;
 }
 
-int dhd_os_get_image_block(char *buf, int len, void *image)
+int brcmf_os_get_image_block(char *buf, int len, void *image)
 {
 	struct file *fp = (struct file *)image;
 	int rdlen;
@@ -2467,7 +2467,7 @@ int dhd_os_get_image_block(char *buf, int len, void *image)
 	return rdlen;
 }
 
-void dhd_os_close_image(void *image)
+void brcmf_os_close_image(void *image)
 {
 	if (!dhd_no_fw_req)
 		return wl_cfg80211_release_fw();
@@ -2475,7 +2475,7 @@ void dhd_os_close_image(void *image)
 		filp_close((struct file *)image, NULL);
 }
 
-void dhd_os_sdlock(dhd_pub_t *pub)
+void brcmf_os_sdlock(dhd_pub_t *pub)
 {
 	dhd_info_t *dhd;
 
@@ -2487,7 +2487,7 @@ void dhd_os_sdlock(dhd_pub_t *pub)
 		spin_lock_bh(&dhd->sdlock);
 }
 
-void dhd_os_sdunlock(dhd_pub_t *pub)
+void brcmf_os_sdunlock(dhd_pub_t *pub)
 {
 	dhd_info_t *dhd;
 
@@ -2528,17 +2528,17 @@ void dhd_sendup_event(dhd_pub_t *dhdp, brcmf_event_msg_t *event, void *data)
 	}
 }
 
-void dhd_wait_for_event(dhd_pub_t *dhd, bool *lockvar)
+void brcmf_wait_for_event(dhd_pub_t *dhd, bool *lockvar)
 {
 	struct dhd_info *dhdinfo = dhd->info;
-	dhd_os_sdunlock(dhd);
+	brcmf_os_sdunlock(dhd);
 	wait_event_interruptible_timeout(dhdinfo->ctrl_wait,
 					 (*lockvar == false), HZ * 2);
-	dhd_os_sdlock(dhd);
+	brcmf_os_sdlock(dhd);
 	return;
 }
 
-void dhd_wait_event_wakeup(dhd_pub_t *dhd)
+void brcmf_wait_event_wakeup(dhd_pub_t *dhd)
 {
 	struct dhd_info *dhdinfo = dhd->info;
 	if (waitqueue_active(&dhdinfo->ctrl_wait))
@@ -2552,13 +2552,13 @@ int dhd_dev_reset(struct net_device *dev, u8 flag)
 
 	/* Turning off watchdog */
 	if (flag)
-		dhd_os_wd_timer(&dhd->pub, 0);
+		brcmf_os_wd_timer(&dhd->pub, 0);
 
-	dhd_bus_devreset(&dhd->pub, flag);
+	brcmf_bus_devreset(&dhd->pub, flag);
 
 	/* Turning on watchdog back */
 	if (!flag)
-		dhd_os_wd_timer(&dhd->pub, brcmf_watchdog_ms);
+		brcmf_os_wd_timer(&dhd->pub, brcmf_watchdog_ms);
 	DHD_ERROR(("%s:  WLAN OFF DONE\n", __func__));
 
 	return 1;
@@ -2583,9 +2583,9 @@ int net_os_set_suspend(struct net_device *dev, int val)
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(dev);
 
 	if (dhd) {
-		dhd_os_proto_block(&dhd->pub);
+		brcmf_os_proto_block(&dhd->pub);
 		ret = dhd_set_suspend(val, &dhd->pub);
-		dhd_os_proto_unblock(&dhd->pub);
+		brcmf_os_proto_unblock(&dhd->pub);
 	}
 #endif		/* defined(CONFIG_HAS_EARLYSUSPEND) */
 	return ret;
@@ -2612,12 +2612,12 @@ int net_os_set_packet_filter(struct net_device *dev, int val)
 	 * back ON only if suspend_disable_flag was not set
 	 */
 	if (dhd && dhd->pub.up) {
-		dhd_os_proto_block(&dhd->pub);
+		brcmf_os_proto_block(&dhd->pub);
 		if (dhd->pub.in_suspend) {
 			if (!val || (val && !dhd->pub.suspend_disable_flag))
 				dhd_set_packet_filter(val, &dhd->pub);
 		}
-		dhd_os_proto_unblock(&dhd->pub);
+		brcmf_os_proto_unblock(&dhd->pub);
 	}
 	return ret;
 }
@@ -2696,11 +2696,11 @@ void wl_os_wd_timer(struct net_device *ndev, uint wdtick)
 {
 	dhd_info_t *dhd = *(dhd_info_t **)netdev_priv(ndev);
 
-	dhd_os_wd_timer(&dhd->pub, wdtick);
+	brcmf_os_wd_timer(&dhd->pub, wdtick);
 }
 
 #ifdef DHD_DEBUG
-int write_to_file(dhd_pub_t *dhd, u8 *buf, int size)
+int brcmf_write_to_file(dhd_pub_t *dhd, u8 *buf, int size)
 {
 	int ret = 0;
 	struct file *fp;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 5ce62fe..cb389ae 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -999,7 +999,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 	/* Early exit if we're already there */
 	if (bus->clkstate == target) {
 		if (target == CLK_AVAIL) {
-			dhd_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
+			brcmf_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
 			bus->activity = true;
 		}
 		return 0;
@@ -1012,7 +1012,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 			brcmf_sdbrcm_sdclk(bus, true);
 		/* Now request HT Avail on the backplane */
 		brcmf_sdbrcm_htclk(bus, true, pendok);
-		dhd_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
+		brcmf_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
 		bus->activity = true;
 		break;
 
@@ -1025,7 +1025,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 		else
 			DHD_ERROR(("brcmf_sdbrcm_clkctl: request for %d -> %d"
 				   "\n", bus->clkstate, target));
-		dhd_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
+		brcmf_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
 		break;
 
 	case CLK_NONE:
@@ -1034,7 +1034,7 @@ static int brcmf_sdbrcm_clkctl(dhd_bus_t *bus, uint target, bool pendok)
 			brcmf_sdbrcm_htclk(bus, false, false);
 		/* Now remove the SD clock */
 		brcmf_sdbrcm_sdclk(bus, false);
-		dhd_os_wd_timer(bus->dhd, 0);
+		brcmf_os_wd_timer(bus->dhd, 0);
 		break;
 	}
 #ifdef DHD_DEBUG
@@ -1324,9 +1324,9 @@ static int brcmf_sdbrcm_txpkt(dhd_bus_t *bus, struct sk_buff *pkt, uint chan,
 done:
 	/* restore pkt buffer pointer before calling tx complete routine */
 	skb_pull(pkt, SDPCM_HDRLEN + pad);
-	dhd_os_sdunlock(bus->dhd);
-	dhd_txcomplete(bus->dhd, pkt, ret != 0);
-	dhd_os_sdlock(bus->dhd);
+	brcmf_os_sdunlock(bus->dhd);
+	brcmf_txcomplete(bus->dhd, pkt, ret != 0);
+	brcmf_os_sdlock(bus->dhd);
 
 	if (free_pkt)
 		brcmu_pkt_buf_free_skb(pkt);
@@ -1377,7 +1377,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		spin_lock_bh(&bus->txqlock);
 		if (brcmf_c_prec_enq(bus->dhd, &bus->txq, pkt, prec) == false) {
 			skb_pull(pkt, SDPCM_HDRLEN);
-			dhd_txcomplete(bus->dhd, pkt, false);
+			brcmf_txcomplete(bus->dhd, pkt, false);
 			brcmu_pkt_buf_free_skb(pkt);
 			DHD_ERROR(("%s: out of bus->txq !!!\n", __func__));
 			ret = -ENOSR;
@@ -1387,7 +1387,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		spin_unlock_bh(&bus->txqlock);
 
 		if (pktq_len(&bus->txq) >= TXHI)
-			dhd_txflowcontrol(bus->dhd, 0, ON);
+			brcmf_txflowcontrol(bus->dhd, 0, ON);
 
 #ifdef DHD_DEBUG
 		if (pktq_plen(&bus->txq, prec) > qcount[prec])
@@ -1396,11 +1396,11 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 		/* Schedule DPC if needed to send queued packet(s) */
 		if (dhd_deferred_tx && !bus->dpc_sched) {
 			bus->dpc_sched = true;
-			dhd_sched_dpc(bus->dhd);
+			brcmf_sched_dpc(bus->dhd);
 		}
 	} else {
 		/* Lock: we're about to use shared data/code (and SDIO) */
-		dhd_os_sdlock(bus->dhd);
+		brcmf_os_sdlock(bus->dhd);
 
 		/* Otherwise, send it now */
 		BUS_WAKE(bus);
@@ -1425,7 +1425,7 @@ int brcmf_sdbrcm_bus_txdata(struct dhd_bus *bus, struct sk_buff *pkt)
 			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 		}
 
-		dhd_os_sdunlock(bus->dhd);
+		brcmf_os_sdunlock(bus->dhd);
 	}
 
 	return ret;
@@ -1486,7 +1486,7 @@ static uint brcmf_sdbrcm_sendfromq(dhd_bus_t *bus, uint maxframes)
 	/* Deflow-control stack if needed */
 	if (dhd->up && (dhd->busstate == DHD_BUS_DATA) &&
 	    dhd->txoff && (pktq_len(&bus->txq) < TXLOW))
-		dhd_txflowcontrol(dhd, 0, OFF);
+		brcmf_txflowcontrol(dhd, 0, OFF);
 
 	return cnt;
 }
@@ -1541,7 +1541,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	ASSERT(IS_ALIGNED((unsigned long)frame, 2));
 
 	/* Need to lock here to protect txseq and SDIO tx calls */
-	dhd_os_sdlock(bus->dhd);
+	brcmf_os_sdlock(bus->dhd);
 
 	BUS_WAKE(bus);
 
@@ -1569,7 +1569,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		bus->ctrl_frame_buf = frame;
 		bus->ctrl_frame_len = len;
 
-		dhd_wait_for_event(bus->dhd, &bus->ctrl_frame_stat);
+		brcmf_wait_for_event(bus->dhd, &bus->ctrl_frame_stat);
 
 		if (bus->ctrl_frame_stat == false) {
 			DHD_INFO(("%s: ctrl_frame_stat == false\n", __func__));
@@ -1643,7 +1643,7 @@ brcmf_sdbrcm_bus_txctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
 
-	dhd_os_sdunlock(bus->dhd);
+	brcmf_os_sdunlock(bus->dhd);
 
 	if (ret)
 		bus->dhd->tx_ctlerrs++;
@@ -1665,13 +1665,13 @@ int brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 		return -EIO;
 
 	/* Wait until control frame is available */
-	timeleft = dhd_os_ioctl_resp_wait(bus->dhd, &bus->rxlen, &pending);
+	timeleft = brcmf_os_ioctl_resp_wait(bus->dhd, &bus->rxlen, &pending);
 
-	dhd_os_sdlock(bus->dhd);
+	brcmf_os_sdlock(bus->dhd);
 	rxlen = bus->rxlen;
 	memcpy(msg, bus->rxctl, min(msglen, rxlen));
 	bus->rxlen = 0;
-	dhd_os_sdunlock(bus->dhd);
+	brcmf_os_sdunlock(bus->dhd);
 
 	if (rxlen) {
 		DHD_CTL(("%s: resumed on rxctl frame, got %d expected %d\n",
@@ -1679,9 +1679,9 @@ int brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	} else if (timeleft == 0) {
 		DHD_ERROR(("%s: resumed on timeout\n", __func__));
 #ifdef DHD_DEBUG
-		dhd_os_sdlock(bus->dhd);
+		brcmf_os_sdlock(bus->dhd);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
-		dhd_os_sdunlock(bus->dhd);
+		brcmf_os_sdunlock(bus->dhd);
 #endif				/* DHD_DEBUG */
 	} else if (pending == true) {
 		DHD_CTL(("%s: cancelled\n", __func__));
@@ -1689,9 +1689,9 @@ int brcmf_sdbrcm_bus_rxctl(struct dhd_bus *bus, unsigned char *msg, uint msglen)
 	} else {
 		DHD_CTL(("%s: resumed for unknown reason?\n", __func__));
 #ifdef DHD_DEBUG
-		dhd_os_sdlock(bus->dhd);
+		brcmf_os_sdlock(bus->dhd);
 		brcmf_sdbrcm_checkdied(bus, NULL, 0);
-		dhd_os_sdunlock(bus->dhd);
+		brcmf_os_sdunlock(bus->dhd);
 #endif				/* DHD_DEBUG */
 	}
 
@@ -2252,12 +2252,12 @@ static int brcmf_sdbrcm_mem_dump(dhd_bus_t *bus)
 	printk(KERN_DEBUG "Done\n");
 
 	/* free buf before return !!! */
-	if (write_to_file(bus->dhd, buf, bus->ramsize)) {
+	if (brcmf_write_to_file(bus->dhd, buf, bus->ramsize)) {
 		DHD_ERROR(("%s: Error writing to files\n", __func__));
 		return -1;
 	}
 
-	/* buf free handled in write_to_file, not here */
+	/* buf free handled in brcmf_write_to_file, not here */
 	return 0;
 }
 
@@ -2396,7 +2396,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 	bool_val = (int_val != 0) ? true : false;
 
 	/* Some ioctls use the bus */
-	dhd_os_sdlock(bus->dhd);
+	brcmf_os_sdlock(bus->dhd);
 
 	/* Check if dongle is in reset. If so, only allow DEVRESET iovars */
 	if (bus->dhd->dongle_reset && !(actionid == IOV_SVAL(IOV_DEVRESET) ||
@@ -2757,7 +2757,7 @@ brcmf_sdbrcm_doiovar(dhd_bus_t *bus, const struct brcmu_iovar *vi, u32 actionid,
 			__func__, bool_val, bus->dhd->dongle_reset,
 			bus->dhd->busstate));
 
-		dhd_bus_devreset(bus->dhd, (u8) bool_val);
+		brcmf_bus_devreset(bus->dhd, (u8) bool_val);
 
 		break;
 
@@ -2781,7 +2781,7 @@ exit:
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
 
-	dhd_os_sdunlock(bus->dhd);
+	brcmf_os_sdunlock(bus->dhd);
 
 	if (actionid == IOV_SVAL(IOV_DEVRESET) && bool_val == false)
 		brcmf_c_preinit_ioctls((dhd_pub_t *) bus->dhd);
@@ -2953,7 +2953,7 @@ brcmf_sdbrcm_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 	/* Look up var locally; if not found pass to host driver */
 	vi = brcmu_iovar_lookup(dhdsdio_iovars, name);
 	if (vi == NULL) {
-		dhd_os_sdlock(bus->dhd);
+		brcmf_os_sdlock(bus->dhd);
 
 		BUS_WAKE(bus);
 
@@ -2986,7 +2986,7 @@ brcmf_sdbrcm_bus_iovar_op(dhd_pub_t *dhdp, const char *name,
 			brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 		}
 
-		dhd_os_sdunlock(bus->dhd);
+		brcmf_os_sdunlock(bus->dhd);
 		goto exit;
 	}
 
@@ -3027,7 +3027,7 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 	DHD_TRACE(("%s: Enter\n", __func__));
 
 	if (enforce_mutex)
-		dhd_os_sdlock(bus->dhd);
+		brcmf_os_sdlock(bus->dhd);
 
 	BUS_WAKE(bus);
 
@@ -3081,14 +3081,14 @@ void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex)
 
 	/* Clear rx control and wake any waiters */
 	bus->rxlen = 0;
-	dhd_os_ioctl_resp_wake(bus->dhd);
+	brcmf_os_ioctl_resp_wake(bus->dhd);
 
 	/* Reset some F2 state stuff */
 	bus->rxskip = false;
 	bus->tx_seq = bus->rx_seq = 0;
 
 	if (enforce_mutex)
-		dhd_os_sdunlock(bus->dhd);
+		brcmf_os_sdunlock(bus->dhd);
 }
 
 int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
@@ -3107,7 +3107,7 @@ int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 		return 0;
 
 	if (enforce_mutex)
-		dhd_os_sdlock(bus->dhd);
+		brcmf_os_sdlock(bus->dhd);
 
 	/* Make sure backplane clock is on, needed to generate F2 interrupt */
 	brcmf_sdbrcm_clkctl(bus, CLK_AVAIL, false);
@@ -3138,10 +3138,10 @@ int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 			       NULL);
 
 	/* Give the dongle some time to do its thing and set IOR2 */
-	dhd_timeout_start(&tmo, DHD_WAIT_F2RDY * 1000);
+	brcmf_timeout_start(&tmo, DHD_WAIT_F2RDY * 1000);
 
 	ready = 0;
-	while (ready != enable && !dhd_timeout_expired(&tmo))
+	while (ready != enable && !brcmf_timeout_expired(&tmo))
 		ready =
 		    brcmf_sdcard_cfg_read(bus->sdh, SDIO_FUNC_0, SDIO_CCCR_IORx,
 				    NULL);
@@ -3194,7 +3194,7 @@ int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 
 exit:
 	if (enforce_mutex)
-		dhd_os_sdunlock(bus->dhd);
+		brcmf_os_sdunlock(bus->dhd);
 
 	return ret;
 }
@@ -3365,7 +3365,7 @@ gotpkt:
 
 done:
 	/* Awake any waiters */
-	dhd_os_ioctl_resp_wake(bus->dhd);
+	brcmf_os_ioctl_resp_wake(bus->dhd);
 }
 
 static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
@@ -3758,9 +3758,9 @@ static u8 brcmf_sdbrcm_rxglom(dhd_bus_t *bus, u8 rxseq)
 #endif				/* DHD_DEBUG */
 		}
 		if (num) {
-			dhd_os_sdunlock(bus->dhd);
-			dhd_rx_frame(bus->dhd, ifidx, save_pfirst, num);
-			dhd_os_sdlock(bus->dhd);
+			brcmf_os_sdunlock(bus->dhd);
+			brcmf_rx_frame(bus->dhd, ifidx, save_pfirst, num);
+			brcmf_os_sdlock(bus->dhd);
 		}
 
 		bus->rxglomframes++;
@@ -4344,9 +4344,9 @@ deliver:
 		}
 
 		/* Unlock during rx call */
-		dhd_os_sdunlock(bus->dhd);
-		dhd_rx_frame(bus->dhd, ifidx, pkt, 1);
-		dhd_os_sdlock(bus->dhd);
+		brcmf_os_sdunlock(bus->dhd);
+		brcmf_rx_frame(bus->dhd, ifidx, pkt, 1);
+		brcmf_os_sdlock(bus->dhd);
 	}
 	rxcount = maxframes - rxleft;
 #ifdef DHD_DEBUG
@@ -4456,7 +4456,7 @@ bool brcmf_sdbrcm_dpc(dhd_bus_t *bus)
 	/* Start with leftover status bits */
 	intstatus = bus->intstatus;
 
-	dhd_os_sdlock(bus->dhd);
+	brcmf_os_sdlock(bus->dhd);
 
 	/* If waiting for HTAVAIL, check status */
 	if (bus->clkstate == CLK_PENDING) {
@@ -4650,7 +4650,7 @@ clkwait:
 
 		DHD_INFO(("Return_dpc value is : %d\n", ret));
 		bus->ctrl_frame_stat = false;
-		dhd_wait_event_wakeup(bus->dhd);
+		brcmf_wait_event_wakeup(bus->dhd);
 	}
 	/* Send queued frames (limit 1 if rx may still be pending) */
 	else if ((bus->clkstate == CLK_AVAIL) && !bus->fcstate &&
@@ -4689,7 +4689,7 @@ clkwait:
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 	}
 
-	dhd_os_sdunlock(bus->dhd);
+	brcmf_os_sdunlock(bus->dhd);
 
 	return resched;
 }
@@ -4748,7 +4748,7 @@ void brcmf_sdbrcm_isr(void *arg)
 		;
 #else
 	bus->dpc_sched = true;
-	dhd_sched_dpc(bus->dhd);
+	brcmf_sched_dpc(bus->dhd);
 #endif
 
 }
@@ -5029,7 +5029,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 	if (bus->sleeping)
 		return false;
 
-	dhd_os_sdlock(bus->dhd);
+	brcmf_os_sdlock(bus->dhd);
 
 	/* Poll period: check device if appropriate. */
 	if (bus->poll && (++bus->polltick >= bus->pollrate)) {
@@ -5060,7 +5060,7 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 					brcmf_sdcard_intr_disable(bus->sdh);
 
 				bus->dpc_sched = true;
-				dhd_sched_dpc(bus->dhd);
+				brcmf_sched_dpc(bus->dhd);
 
 			}
 		}
@@ -5099,14 +5099,14 @@ extern bool brcmf_sdbrcm_bus_watchdog(dhd_pub_t *dhdp)
 			bus->idlecount = 0;
 			if (bus->activity) {
 				bus->activity = false;
-				dhd_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
+				brcmf_os_wd_timer(bus->dhd, brcmf_watchdog_ms);
 			} else {
 				brcmf_sdbrcm_clkctl(bus, CLK_NONE, false);
 			}
 		}
 	}
 
-	dhd_os_sdunlock(bus->dhd);
+	brcmf_os_sdunlock(bus->dhd);
 
 	return bus->ipend;
 }
@@ -5125,11 +5125,11 @@ extern int brcmf_sdbrcm_bus_console_in(dhd_pub_t *dhdp, unsigned char *msg,
 		return -ENOTSUPP;
 
 	/* Exclusive bus access */
-	dhd_os_sdlock(bus->dhd);
+	brcmf_os_sdlock(bus->dhd);
 
 	/* Don't allow input if dongle is in reset */
 	if (bus->dhd->dongle_reset) {
-		dhd_os_sdunlock(bus->dhd);
+		brcmf_os_sdunlock(bus->dhd);
 		return -EPERM;
 	}
 
@@ -5171,7 +5171,7 @@ done:
 		brcmf_sdbrcm_clkctl(bus, CLK_NONE, true);
 	}
 
-	dhd_os_sdunlock(bus->dhd);
+	brcmf_os_sdunlock(bus->dhd);
 
 	return rv;
 }
@@ -5288,7 +5288,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	spin_lock_init(&bus->txqlock);
 
 	/* Attach to the dhd/OS/network interface */
-	bus->dhd = dhd_attach(bus, SDPCM_RESERVE);
+	bus->dhd = brcmf_attach(bus, SDPCM_RESERVE);
 	if (!bus->dhd) {
 		DHD_ERROR(("%s: dhd_attach failed\n", __func__));
 		goto fail;
@@ -5320,7 +5320,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 	DHD_INFO(("%s: completed!!\n", __func__));
 
 	/* if firmware path present try to download and bring up bus */
-	ret = dhd_bus_start(bus->dhd);
+	ret = brcmf_bus_start(bus->dhd);
 	if (ret != 0) {
 		if (ret == -ENOLINK) {
 			DHD_ERROR(("%s: dongle is not responding\n", __func__));
@@ -5328,7 +5328,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 		}
 	}
 	/* Ok, have the per-port tell the stack we're open for business */
-	if (dhd_net_attach(bus->dhd, 0) != 0) {
+	if (brcmf_net_attach(bus->dhd, 0) != 0) {
 		DHD_ERROR(("%s: Net attach failed!!\n", __func__));
 		goto fail;
 	}
@@ -5568,7 +5568,7 @@ static void brcmf_sdbrcm_release(dhd_bus_t *bus)
 		brcmf_sdcard_intr_dereg(bus->sdh);
 
 		if (bus->dhd) {
-			dhd_detach(bus->dhd);
+			brcmf_detach(bus->dhd);
 			brcmf_sdbrcm_release_dongle(bus);
 			bus->dhd = NULL;
 		}
@@ -5663,7 +5663,7 @@ static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus, char *fw_path)
 
 	DHD_INFO(("%s: download firmware %s\n", __func__, brcmf_fw_path));
 
-	image = dhd_os_open_image(fw_path);
+	image = brcmf_os_open_image(fw_path);
 	if (image == NULL)
 		goto err;
 
@@ -5679,7 +5679,7 @@ static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus, char *fw_path)
 
 	/* Download image */
 	while ((len =
-		dhd_os_get_image_block((char *)memptr, MEMBLOCK, image))) {
+		brcmf_os_get_image_block((char *)memptr, MEMBLOCK, image))) {
 		bcmerror = brcmf_sdbrcm_membytes(bus, true, offset, memptr,
 						 len);
 		if (bcmerror) {
@@ -5695,7 +5695,7 @@ err:
 	kfree(memblock);
 
 	if (image)
-		dhd_os_close_image(image);
+		brcmf_os_close_image(image);
 
 	return bcmerror;
 }
@@ -5789,7 +5789,7 @@ static int brcmf_sdbrcm_download_nvram(struct dhd_bus *bus)
 		return 0;
 
 	if (nvram_file_exists) {
-		image = dhd_os_open_image(nv_path);
+		image = brcmf_os_open_image(nv_path);
 		if (image == NULL)
 			goto err;
 	}
@@ -5803,7 +5803,7 @@ static int brcmf_sdbrcm_download_nvram(struct dhd_bus *bus)
 
 	/* Download variables */
 	if (nvram_file_exists) {
-		len = dhd_os_get_image_block(memblock, MEMBLOCK, image);
+		len = brcmf_os_get_image_block(memblock, MEMBLOCK, image);
 	} else {
 		len = strlen(bus->nvram_params);
 		ASSERT(len <= MEMBLOCK);
@@ -5835,7 +5835,7 @@ err:
 	kfree(memblock);
 
 	if (image)
-		dhd_os_close_image(image);
+		brcmf_os_close_image(image);
 
 	return bcmerror;
 }
@@ -5929,7 +5929,7 @@ uint dhd_bus_hdrlen(struct dhd_bus *bus)
 	return SDPCM_HDRLEN;
 }
 
-int dhd_bus_devreset(dhd_pub_t *dhdp, u8 flag)
+int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 {
 	int bcmerror = 0;
 	dhd_bus_t *bus;
-- 
1.7.1


