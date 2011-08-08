Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2815 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752788Ab1HHN70 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:26 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 32/82] staging: brcm80211: move ioctl response wait
 code to dhd_sdio.c
Date: Mon, 8 Aug 2011 15:58:16 +0200
Message-ID: <1312811946-16713-33-git-send-email-arend@broadcom.com> (sfid-20110808_160204_031993_9EE238FF)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Ioctl response wait is used only by bus layer in fullmac. Move the
corresponding code to dhd_sdio.c

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h        |    5 --
 drivers/staging/brcm80211/brcmfmac/dhd_common.c |   18 -------
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c  |   52 --------------------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c   |   60 +++++++++++++++++++++-
 4 files changed, 57 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 1f203fb..f3633fe 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -779,11 +779,6 @@ extern int brcmf_proto_cdc_query_ioctl(struct brcmf_pub *drvr, int ifidx,
 /* OS independent layer functions */
 extern int brcmf_os_proto_block(struct brcmf_pub *drvr);
 extern int brcmf_os_proto_unblock(struct brcmf_pub *drvr);
-extern int brcmf_os_ioctl_resp_wait(struct brcmf_pub *drvr, uint *condition,
-				  bool *pending);
-extern int brcmf_os_ioctl_resp_wake(struct brcmf_pub *drvr);
-extern unsigned int brcmf_os_get_ioctl_resp_timeout(void);
-extern void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec);
 #ifdef BCMDBG
 extern int brcmf_write_to_file(struct brcmf_pub *drvr, u8 *buf, int size);
 #endif				/* BCMDBG */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index d5648f8..12c772d 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -55,7 +55,6 @@ enum {
 	IOV_LOGCAL,
 	IOV_LOGSTAMP,
 	IOV_GPIOOB,
-	IOV_IOCTLTIMEOUT,
 	IOV_LAST
 };
 
@@ -76,8 +75,6 @@ const struct brcmu_iovar brcmf_iovars[] = {
 	,
 	{"gpioob", IOV_GPIOOB, 0, IOVT_UINT32, 0}
 	,
-	{"ioctl_timeout", IOV_IOCTLTIMEOUT, 0, IOVT_UINT32, 0}
-	,
 	{NULL, 0, 0, 0, 0}
 };
 
@@ -227,21 +224,6 @@ brcmf_c_doiovar(struct brcmf_pub *drvr, const struct brcmu_iovar *vi,
 		brcmf_bus_clearcounts(drvr);
 		break;
 
-	case IOV_GVAL(IOV_IOCTLTIMEOUT):{
-			int_val = (s32) brcmf_os_get_ioctl_resp_timeout();
-			memcpy(arg, &int_val, sizeof(int_val));
-			break;
-		}
-
-	case IOV_SVAL(IOV_IOCTLTIMEOUT):{
-			if (int_val <= 0)
-				bcmerror = -EINVAL;
-			else
-				brcmf_os_set_ioctl_resp_timeout((unsigned int)
-							      int_val);
-			break;
-		}
-
 	default:
 		bcmerror = -ENOTSUPP;
 		break;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index f3eaef1..b7a741b 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -76,7 +76,6 @@ struct brcmf_info {
 	struct brcmf_if *iflist[BRCMF_MAX_IFS];
 
 	struct mutex proto_block;
-	wait_queue_head_t ioctl_resp_wait;
 
 	/* Thread to issue ioctl for multicast */
 	struct task_struct *sysioc_tsk;
@@ -127,9 +126,6 @@ module_param_string(iface_name, iface_name, IFNAMSIZ, 0);
 
 /* The following are specific to the SDIO dongle */
 
-/* IOCTL response timeout */
-int brcmf_ioctl_timeout_msec = IOCTL_RESP_TIMEOUT;
-
 #ifdef SDTEST
 /* Echo packet generator (pkts/s) */
 uint brcmf_pktgen;
@@ -1290,8 +1286,6 @@ struct brcmf_pub *brcmf_attach(struct brcmf_bus *bus, uint bus_hdrlen)
 
 	net->netdev_ops = NULL;
 	mutex_init(&drvr_priv->proto_block);
-	/* Initialize other structure content */
-	init_waitqueue_head(&drvr_priv->ioctl_resp_wait);
 
 	/* Link to info module */
 	drvr_priv->pub.info = drvr_priv;
@@ -1577,52 +1571,6 @@ int brcmf_os_proto_unblock(struct brcmf_pub *drvr)
 	return 0;
 }
 
-unsigned int brcmf_os_get_ioctl_resp_timeout(void)
-{
-	return (unsigned int)brcmf_ioctl_timeout_msec;
-}
-
-void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec)
-{
-	brcmf_ioctl_timeout_msec = (int)timeout_msec;
-}
-
-int brcmf_os_ioctl_resp_wait(struct brcmf_pub *drvr, uint *condition,
-			     bool *pending)
-{
-	struct brcmf_info *drvr_priv = drvr->info;
-	DECLARE_WAITQUEUE(wait, current);
-	int timeout = brcmf_ioctl_timeout_msec;
-
-	/* Convert timeout in millsecond to jiffies */
-	timeout = timeout * HZ / 1000;
-
-	/* Wait until control frame is available */
-	add_wait_queue(&drvr_priv->ioctl_resp_wait, &wait);
-	set_current_state(TASK_INTERRUPTIBLE);
-
-	while (!(*condition) && (!signal_pending(current) && timeout))
-		timeout = schedule_timeout(timeout);
-
-	if (signal_pending(current))
-		*pending = true;
-
-	set_current_state(TASK_RUNNING);
-	remove_wait_queue(&drvr_priv->ioctl_resp_wait, &wait);
-
-	return timeout;
-}
-
-int brcmf_os_ioctl_resp_wake(struct brcmf_pub *drvr)
-{
-	struct brcmf_info *drvr_priv = drvr->info;
-
-	if (waitqueue_active(&drvr_priv->ioctl_resp_wait))
-		wake_up_interruptible(&drvr_priv->ioctl_resp_wait);
-
-	return 0;
-}
-
 static int brcmf_host_event(struct brcmf_info *drvr_priv, int *ifidx, void *pktdata,
 			    struct brcmf_event_msg *event, void **data)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index 4235040..eb6d78e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -740,6 +740,7 @@ struct brcmf_bus {
 
 	spinlock_t txqlock;
 	wait_queue_head_t ctrl_wait;
+	wait_queue_head_t ioctl_resp_wait;
 
 	struct timer_list timer;
 	struct completion watchdog_wait;
@@ -857,6 +858,9 @@ module_param(brcmf_poll, uint, 0);
 uint brcmf_intr = true;
 module_param(brcmf_intr, uint, 0);
 
+/* IOCTL response timeout */
+static int brcmf_ioctl_timeout_msec = IOCTL_RESP_TIMEOUT;
+
 /* override the RAM size if possible */
 #define DONGLE_MIN_MEMSIZE (128 * 1024)
 int brcmf_dongle_memsize;
@@ -1005,6 +1009,9 @@ static void brcmf_sdbrcm_sched_dpc(struct brcmf_bus *bus);
 static void brcmf_sdbrcm_sdlock(struct brcmf_bus *bus);
 static void brcmf_sdbrcm_sdunlock(struct brcmf_bus *bus);
 static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus);
+static int brcmf_sdbrcm_ioctl_resp_wait(struct brcmf_bus *bus, uint *condition,
+					bool *pending);
+static int brcmf_sdbrcm_ioctl_resp_wake(struct brcmf_bus *bus);
 
 /* Packet free applicable unconditionally for sdio and sdspi.
  * Conditional if bufpool was present for gspi bus.
@@ -1832,7 +1839,7 @@ int brcmf_sdbrcm_bus_rxctl(struct brcmf_bus *bus, unsigned char *msg, uint msgle
 		return -EIO;
 
 	/* Wait until control frame is available */
-	timeleft = brcmf_os_ioctl_resp_wait(bus->drvr, &bus->rxlen, &pending);
+	timeleft = brcmf_sdbrcm_ioctl_resp_wait(bus, &bus->rxlen, &pending);
 
 	brcmf_sdbrcm_sdlock(bus);
 	rxlen = bus->rxlen;
@@ -1906,6 +1913,7 @@ enum {
 	IOV_SD1IDLE,
 	IOV_SLEEP,
 	IOV_WDTICK,
+	IOV_IOCTLTIMEOUT,
 	IOV_VARS
 };
 
@@ -1927,6 +1935,7 @@ const struct brcmu_iovar brcmf_sdio_iovars[] = {
 	{"sdalign", IOV_SDALIGN, 0, IOVT_BOOL, 0},
 	{"devreset", IOV_DEVRESET, 0, IOVT_BOOL, 0},
 	{"wdtick", IOV_WDTICK, 0, IOVT_UINT32, 0},
+	{"ioctl_timeout", IOV_IOCTLTIMEOUT, 0, IOVT_UINT32, 0},
 #ifdef BCMDBG
 	{"cons", IOV_CONS, 0, IOVT_BUFFER, 0}
 	,
@@ -2964,6 +2973,20 @@ brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 ac
 		brcmf_sdbrcm_wd_timer(bus, (uint) int_val);
 		break;
 
+	case IOV_GVAL(IOV_IOCTLTIMEOUT):{
+			int_val = brcmf_ioctl_timeout_msec;
+			memcpy(arg, &int_val, sizeof(int_val));
+			break;
+		}
+
+	case IOV_SVAL(IOV_IOCTLTIMEOUT):{
+			if (int_val <= 0)
+				bcmerror = -EINVAL;
+			else
+				brcmf_ioctl_timeout_msec = int_val;
+			break;
+		}
+
 	default:
 		bcmerror = -ENOTSUPP;
 		break;
@@ -3293,7 +3316,7 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 
 	/* Clear rx control and wake any waiters */
 	bus->rxlen = 0;
-	brcmf_os_ioctl_resp_wake(bus->drvr);
+	brcmf_sdbrcm_ioctl_resp_wake(bus);
 
 	/* Reset some F2 state stuff */
 	bus->rxskip = false;
@@ -3593,7 +3616,7 @@ gotpkt:
 
 done:
 	/* Awake any waiters */
-	brcmf_os_ioctl_resp_wake(bus->drvr);
+	brcmf_sdbrcm_ioctl_resp_wake(bus);
 }
 
 static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
@@ -5506,6 +5529,7 @@ static void *brcmf_sdbrcm_probe(u16 venid, u16 devid, u16 bus_no,
 
 	spin_lock_init(&bus->txqlock);
 	init_waitqueue_head(&bus->ctrl_wait);
+	init_waitqueue_head(&bus->ioctl_resp_wait);
 
 	/* Set up the watchdog timer */
 	init_timer(&bus->timer);
@@ -6777,3 +6801,33 @@ static int brcmf_sdbrcm_get_image(char *buf, int len, struct brcmf_bus *bus)
 
 MODULE_FIRMWARE(BCM4329_FW_NAME);
 MODULE_FIRMWARE(BCM4329_NV_NAME);
+
+static int
+brcmf_sdbrcm_ioctl_resp_wait(struct brcmf_bus *bus, uint *condition, bool *pending)
+{
+	DECLARE_WAITQUEUE(wait, current);
+	int timeout = msecs_to_jiffies(brcmf_ioctl_timeout_msec);
+
+	/* Wait until control frame is available */
+	add_wait_queue(&bus->ioctl_resp_wait, &wait);
+	set_current_state(TASK_INTERRUPTIBLE);
+
+	while (!(*condition) && (!signal_pending(current) && timeout))
+		timeout = schedule_timeout(timeout);
+
+	if (signal_pending(current))
+		*pending = true;
+
+	set_current_state(TASK_RUNNING);
+	remove_wait_queue(&bus->ioctl_resp_wait, &wait);
+
+	return timeout;
+}
+
+static int brcmf_sdbrcm_ioctl_resp_wake(struct brcmf_bus *bus)
+{
+	if (waitqueue_active(&bus->ioctl_resp_wait))
+		wake_up_interruptible(&bus->ioctl_resp_wait);
+
+	return 0;
+}
-- 
1.7.4.1


