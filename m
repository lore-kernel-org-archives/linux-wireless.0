Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:13896 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbcAEKF5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2016 05:05:57 -0500
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 4/6] brcmfmac: use msecs_to_jiffies() in macro definitions
Date: Tue, 5 Jan 2016 11:05:48 +0100
Message-ID: <1451988350-2197-5-git-send-email-arend@broadcom.com> (sfid-20160105_110608_141339_0FCDAE7F)
In-Reply-To: <1451988350-2197-1-git-send-email-arend@broadcom.com>
References: <1451988350-2197-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead to having macro definition for millisecond timeout have
the definition directly in jiffies. This makes the unit of the
value immediately clear and may result in code that is bit more
compact.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.c    |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/cfg80211.h    |  2 ++
 .../net/wireless/broadcom/brcm80211/brcmfmac/core.c    |  4 ++--
 .../net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c  |  4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c | 18 +++++++++---------
 .../net/wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  7 +++----
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.c    | 18 ++++++++----------
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.h    |  4 ++--
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c |  5 ++---
 9 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
index c9657be..84788ea 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
@@ -568,7 +568,7 @@ struct wireless_dev *brcmf_ap_add_vif(struct wiphy *wiphy, const char *name,
 
 	/* wait for firmware event */
 	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_ADD,
-						    msecs_to_jiffies(1500));
+						    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err) {
 		brcmf_err("timeout occurred\n");
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
index 69af708..40efb53 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.h
@@ -75,6 +75,8 @@
 #define BRCMF_DEFAULT_BCN_TIMEOUT_ROAM_ON	2
 #define BRCMF_DEFAULT_BCN_TIMEOUT_ROAM_OFF	4
 
+#define BRCMF_VIF_EVENT_TIMEOUT		msecs_to_jiffies(1500)
+
 /**
  * enum brcmf_scan_status - scan engine status
  *
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
index 7c75b1a..ed9998b 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c
@@ -40,7 +40,7 @@ MODULE_AUTHOR("Broadcom Corporation");
 MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
 MODULE_LICENSE("Dual BSD/GPL");
 
-#define MAX_WAIT_FOR_8021X_TX		50	/* msecs */
+#define MAX_WAIT_FOR_8021X_TX			msecs_to_jiffies(50)
 
 /* AMPDU rx reordering definitions */
 #define BRCMF_RXREORDER_FLOWID_OFFSET		0
@@ -1282,7 +1282,7 @@ int brcmf_netdev_wait_pend8021x(struct brcmf_if *ifp)
 
 	err = wait_event_timeout(ifp->pend_8021x_wait,
 				 !brcmf_get_pend_8021x_cnt(ifp),
-				 msecs_to_jiffies(MAX_WAIT_FOR_8021X_TX));
+				 MAX_WAIT_FOR_8021X_TX);
 
 	WARN_ON(!err);
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
index 5df9138..c2bdb91 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/msgbuf.c
@@ -34,7 +34,7 @@
 #include "tracepoint.h"
 
 
-#define MSGBUF_IOCTL_RESP_TIMEOUT		2000
+#define MSGBUF_IOCTL_RESP_TIMEOUT		msecs_to_jiffies(2000)
 
 #define MSGBUF_TYPE_GEN_STATUS			0x1
 #define MSGBUF_TYPE_RING_STATUS			0x2
@@ -466,7 +466,7 @@ static int brcmf_msgbuf_ioctl_resp_wait(struct brcmf_msgbuf *msgbuf)
 {
 	return wait_event_timeout(msgbuf->ioctl_resp_wait,
 				  msgbuf->ctl_completed,
-				  msecs_to_jiffies(MSGBUF_IOCTL_RESP_TIMEOUT));
+				  MSGBUF_IOCTL_RESP_TIMEOUT);
 }
 
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
index b23dcbc..821b649 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/p2p.c
@@ -71,10 +71,10 @@
 #define P2P_AF_MED_DWELL_TIME		400
 #define P2P_AF_LONG_DWELL_TIME		1000
 #define P2P_AF_TX_MAX_RETRY		1
-#define P2P_AF_MAX_WAIT_TIME		2000
+#define P2P_AF_MAX_WAIT_TIME		msecs_to_jiffies(2000)
 #define P2P_INVALID_CHANNEL		-1
 #define P2P_CHANNEL_SYNC_RETRY		5
-#define P2P_AF_FRM_SCAN_MAX_WAIT	1500
+#define P2P_AF_FRM_SCAN_MAX_WAIT	msecs_to_jiffies(1500)
 #define P2P_DEFAULT_SLEEP_TIME_VSDB	200
 
 /* WiFi P2P Public Action Frame OUI Subtypes */
@@ -102,6 +102,7 @@
 #define P2PSD_ACTION_ID_GAS_CREQ	0x0c	/* GAS Comback Request AF */
 #define P2PSD_ACTION_ID_GAS_CRESP	0x0d	/* GAS Comback Response AF */
 
+#define BRCMF_P2P_DISABLE_TIMEOUT	msecs_to_jiffies(500)
 /**
  * struct brcmf_p2p_disc_st_le - set discovery state in firmware.
  *
@@ -1514,7 +1515,7 @@ static s32 brcmf_p2p_tx_action_frame(struct brcmf_p2p_info *p2p,
 	p2p->af_tx_sent_jiffies = jiffies;
 
 	timeout = wait_for_completion_timeout(&p2p->send_af_done,
-					msecs_to_jiffies(P2P_AF_MAX_WAIT_TIME));
+					      P2P_AF_MAX_WAIT_TIME);
 
 	if (test_bit(BRCMF_P2P_STATUS_ACTION_TX_COMPLETED, &p2p->status)) {
 		brcmf_dbg(TRACE, "TX action frame operation is success\n");
@@ -1988,7 +1989,7 @@ int brcmf_p2p_ifchange(struct brcmf_cfg80211_info *cfg,
 		return err;
 	}
 	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_CHANGE,
-						    msecs_to_jiffies(1500));
+						    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err)  {
 		brcmf_err("No BRCMF_E_IF_CHANGE event received\n");
@@ -2090,7 +2091,7 @@ static struct wireless_dev *brcmf_p2p_create_p2pdev(struct brcmf_p2p_info *p2p,
 
 	/* wait for firmware event */
 	err = brcmf_cfg80211_wait_vif_event_timeout(p2p->cfg, BRCMF_E_IF_ADD,
-						    msecs_to_jiffies(1500));
+						    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(p2p->cfg, NULL);
 	brcmf_fweh_p2pdev_setup(pri_ifp, false);
 	if (!err) {
@@ -2180,7 +2181,7 @@ struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
 
 	/* wait for firmware event */
 	err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_ADD,
-						    msecs_to_jiffies(1500));
+						    BRCMF_VIF_EVENT_TIMEOUT);
 	brcmf_cfg80211_arm_vif_event(cfg, NULL);
 	if (!err) {
 		brcmf_err("timeout occurred\n");
@@ -2230,7 +2231,6 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 	struct brcmf_cfg80211_info *cfg = wiphy_priv(wiphy);
 	struct brcmf_p2p_info *p2p = &cfg->p2p;
 	struct brcmf_cfg80211_vif *vif;
-	unsigned long jiffie_timeout = msecs_to_jiffies(1500);
 	bool wait_for_disable = false;
 	int err;
 
@@ -2263,7 +2263,7 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 
 	if (wait_for_disable)
 		wait_for_completion_timeout(&cfg->vif_disabled,
-					    msecs_to_jiffies(500));
+					    BRCMF_P2P_DISABLE_TIMEOUT);
 
 	err = 0;
 	if (vif->wdev.iftype != NL80211_IFTYPE_P2P_DEVICE) {
@@ -2273,7 +2273,7 @@ int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
 	if (!err) {
 		/* wait for firmware event */
 		err = brcmf_cfg80211_wait_vif_event_timeout(cfg, BRCMF_E_IF_DEL,
-							    jiffie_timeout);
+							BRCMF_VIF_EVENT_TIMEOUT);
 		if (!err)
 			err = -EIO;
 		else
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index 3d2d790..0480b70 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -191,7 +191,7 @@ static struct brcmf_firmware_mapping brcmf_pcie_fwnames[] = {
 #define BRCMF_H2D_HOST_D0_INFORM_IN_USE		0x00000008
 #define BRCMF_H2D_HOST_D0_INFORM		0x00000010
 
-#define BRCMF_PCIE_MBDATA_TIMEOUT		2000
+#define BRCMF_PCIE_MBDATA_TIMEOUT		msecs_to_jiffies(2000)
 
 #define BRCMF_PCIE_CFGREG_STATUS_CMD		0x4
 #define BRCMF_PCIE_CFGREG_PM_CSR		0x4C
@@ -1885,9 +1885,8 @@ static int brcmf_pcie_pm_enter_D3(struct device *dev)
 	devinfo->mbdata_completed = false;
 	brcmf_pcie_send_mb_data(devinfo, BRCMF_H2D_HOST_D3_INFORM);
 
-	wait_event_timeout(devinfo->mbdata_resp_wait,
-			   devinfo->mbdata_completed,
-			   msecs_to_jiffies(BRCMF_PCIE_MBDATA_TIMEOUT));
+	wait_event_timeout(devinfo->mbdata_resp_wait, devinfo->mbdata_completed,
+			   BRCMF_PCIE_MBDATA_TIMEOUT);
 	if (!devinfo->mbdata_completed) {
 		brcmf_err("Timeout on response for entering D3 substate\n");
 		return -EIO;
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 2f02020..dd66143 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -45,8 +45,8 @@
 #include "chip.h"
 #include "firmware.h"
 
-#define DCMD_RESP_TIMEOUT	2000	/* In milli second */
-#define CTL_DONE_TIMEOUT	2000	/* In milli second */
+#define DCMD_RESP_TIMEOUT	msecs_to_jiffies(2000)
+#define CTL_DONE_TIMEOUT	msecs_to_jiffies(2000)
 
 #ifdef DEBUG
 
@@ -1657,7 +1657,7 @@ static int brcmf_sdio_dcmd_resp_wait(struct brcmf_sdio *bus, uint *condition,
 				     bool *pending)
 {
 	DECLARE_WAITQUEUE(wait, current);
-	int timeout = msecs_to_jiffies(DCMD_RESP_TIMEOUT);
+	int timeout = DCMD_RESP_TIMEOUT;
 
 	/* Wait until control frame is available */
 	add_wait_queue(&bus->dcmd_resp_wait, &wait);
@@ -2842,7 +2842,7 @@ brcmf_sdio_bus_txctl(struct device *dev, unsigned char *msg, uint msglen)
 
 	brcmf_sdio_trigger_dpc(bus);
 	wait_event_interruptible_timeout(bus->ctrl_wait, !bus->ctrl_frame_stat,
-					 msecs_to_jiffies(CTL_DONE_TIMEOUT));
+					 CTL_DONE_TIMEOUT);
 	ret = 0;
 	if (bus->ctrl_frame_stat) {
 		sdio_claim_host(bus->sdiodev->func[1]);
@@ -3552,7 +3552,7 @@ static void brcmf_sdio_bus_watchdog(struct brcmf_sdio *bus)
 	/* Poll for console output periodically */
 	if (bus->sdiodev->state == BRCMF_SDIOD_DATA && BRCMF_FWCON_ON() &&
 	    bus->console_interval != 0) {
-		bus->console.count += BRCMF_WD_POLL_MS;
+		bus->console.count += jiffies_to_msecs(BRCMF_WD_POLL);
 		if (bus->console.count >= bus->console_interval) {
 			bus->console.count -= bus->console_interval;
 			sdio_claim_host(bus->sdiodev->func[1]);
@@ -3909,7 +3909,7 @@ brcmf_sdio_watchdog(unsigned long data)
 		/* Reschedule the watchdog */
 		if (bus->wd_active)
 			mod_timer(&bus->timer,
-				  jiffies + msecs_to_jiffies(BRCMF_WD_POLL_MS));
+				  jiffies + BRCMF_WD_POLL);
 	}
 }
 
@@ -4234,14 +4234,12 @@ void brcmf_sdio_wd_timer(struct brcmf_sdio *bus, bool active)
 			/* Create timer again when watchdog period is
 			   dynamically changed or in the first instance
 			 */
-			bus->timer.expires =
-				jiffies + msecs_to_jiffies(BRCMF_WD_POLL_MS);
+			bus->timer.expires = jiffies + BRCMF_WD_POLL;
 			add_timer(&bus->timer);
 			bus->wd_active = true;
 		} else {
 			/* Re arm the timer, at last watchdog period */
-			mod_timer(&bus->timer,
-				jiffies + msecs_to_jiffies(BRCMF_WD_POLL_MS));
+			mod_timer(&bus->timer, jiffies + BRCMF_WD_POLL);
 		}
 	}
 }
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index ff47cee..5ec7a6d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -152,8 +152,8 @@
 /* Packet alignment for most efficient SDIO (can change based on platform) */
 #define BRCMF_SDALIGN	(1 << 6)
 
-/* watchdog polling interval in ms */
-#define BRCMF_WD_POLL_MS	10
+/* watchdog polling interval */
+#define BRCMF_WD_POLL	msecs_to_jiffies(10)
 
 /**
  * enum brcmf_sdiod_state - the state of the bus.
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
index 66c26a9..c72b7b3 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/usb.c
@@ -29,7 +29,7 @@
 #include "usb.h"
 
 
-#define IOCTL_RESP_TIMEOUT		2000
+#define IOCTL_RESP_TIMEOUT		msecs_to_jiffies(2000)
 
 #define BRCMF_USB_RESET_GETVER_SPINWAIT	100	/* in unit of ms */
 #define BRCMF_USB_RESET_GETVER_LOOP_CNT	10
@@ -190,8 +190,7 @@ static struct brcmf_usbdev_info *brcmf_usb_get_businfo(struct device *dev)
 static int brcmf_usb_ioctl_resp_wait(struct brcmf_usbdev_info *devinfo)
 {
 	return wait_event_timeout(devinfo->ioctl_resp_wait,
-				  devinfo->ctl_completed,
-				  msecs_to_jiffies(IOCTL_RESP_TIMEOUT));
+				  devinfo->ctl_completed, IOCTL_RESP_TIMEOUT);
 }
 
 static void brcmf_usb_ioctl_resp_wake(struct brcmf_usbdev_info *devinfo)
-- 
1.9.1

