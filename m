Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2069 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758187Ab1F2XtU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:49:20 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 083/119] staging: brcm80211: clean up firmware download
 code in fullmac
Date: Wed, 29 Jun 2011 16:47:47 -0700
Message-ID: <1309391303-22741-84-git-send-email-frankyl@broadcom.com> (sfid-20110630_015229_416554_DE71EB94)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In brcmfmac the firmware download related code scatter all around.
And some old dead code which is not following the standard firmware
routine is still present. This patch limits the firmware download
related code only in dhd_sdio.c and removes the rest.

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmchip.h      |    3 +
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    2 -
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h |    2 +
 drivers/staging/brcm80211/brcmfmac/dhd.h          |    9 -
 drivers/staging/brcm80211/brcmfmac/dhd_bus.h      |    8 -
 drivers/staging/brcm80211/brcmfmac/dhd_common.c   |   13 --
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c    |   84 +----------
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c     |  180 ++++++++-------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c  |  115 -------------
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h  |   27 ---
 10 files changed, 77 insertions(+), 366 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmchip.h b/drivers/staging/brcm80211/brcmfmac/bcmchip.h
index 08729e1..d7d3afd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmchip.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmchip.h
@@ -25,5 +25,8 @@
 /* ARM Cortex M3 core, ID 0x82a */
 #define BCM4329_CORE_ARM_BASE		0x18002000
 #define BCM4329_RAMSIZE			0x48000
+/* firmware name */
+#define BCM4329_FW_NAME			"brcm/bcm4329-fullmac-4.bin"
+#define BCM4329_NV_NAME			"brcm/bcm4329-fullmac-4.txt"
 
 #endif				/* _bcmchip_h_ */
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 48527bb..764d839 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -40,8 +40,6 @@ static void brcmf_sdioh_irqhandler_f2(struct sdio_func *func);
 static int brcmf_sdioh_get_cisaddr(struct sdioh_info *sd, u32 regaddr);
 extern int brcmf_sdioh_reset_comm(struct mmc_card *card);
 
-extern PBCMSDH_SDMMC_INSTANCE gInstance;
-
 uint sd_f2_blocksize = 512;	/* Default blocksize */
 
 uint sd_msglevel = 0x01;
diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
index 1a6f68a..9c5eee0 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.h
@@ -133,4 +133,6 @@ typedef struct _BCMSDH_SDMMC_INSTANCE {
 	u32 host_claimed;
 } BCMSDH_SDMMC_INSTANCE, *PBCMSDH_SDMMC_INSTANCE;
 
+extern PBCMSDH_SDMMC_INSTANCE gInstance;
+
 #endif				/* __BCMSDH_SDMMC_H__ */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index b11eeee..b2db6b9 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -122,9 +122,6 @@
 #define WL_KF_RES_5	(1 << 5)	/* Reserved for backward compat */
 #define WL_IBSS_PEER_GROUP_KEY	(1 << 6)	/* Indicates a group key for a IBSS PEER */
 
-/* optionally set by a module_param_string() */
-#define MOD_PARAM_PATHLEN	2048
-
 /* For supporting multiple interfaces */
 #define DHD_MAX_IFS	16
 #define DHD_DEL_IF	-0xe
@@ -819,9 +816,6 @@ extern uint brcmf_pktgen_len;
 #define BRCMF_MAX_PKTGEN_LEN 1800
 #endif
 
-extern char brcmf_fw_path[MOD_PARAM_PATHLEN];
-extern char brcmf_nv_path[MOD_PARAM_PATHLEN];
-
 extern u32 g_assert_type;
 extern const bcmevent_name_t bcmevent_names[];
 extern const int bcmevent_names_size;
@@ -912,9 +906,6 @@ extern int brcmf_os_ioctl_resp_wait(dhd_pub_t *pub, uint *condition,
 extern int brcmf_os_ioctl_resp_wake(dhd_pub_t *pub);
 extern unsigned int brcmf_os_get_ioctl_resp_timeout(void);
 extern void brcmf_os_set_ioctl_resp_timeout(unsigned int timeout_msec);
-extern void *brcmf_os_open_image(char *filename);
-extern int brcmf_os_get_image_block(char *buf, int len, void *image);
-extern void brcmf_os_close_image(void *image);
 extern void brcmf_os_sdlock_sndup_rxq(dhd_pub_t *pub);
 extern void brcmf_customer_gpio_wlan_ctrl(int onoff);
 extern int brcmf_custom_get_mac_address(unsigned char *buf);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
index 1038ddb..c895b81 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_bus.h
@@ -36,10 +36,6 @@ extern uint brcmf_watchdog_ms;
 extern int dhd_bus_register(void);
 extern void dhd_bus_unregister(void);
 
-/* Download firmware image and nvram image */
-extern bool dhd_bus_download_firmware(struct dhd_bus *bus,
-				      char *fw_path, char *nv_path);
-
 /* Stop bus module: clear pending frames, disable data flow */
 extern void brcmf_sdbrcm_bus_stop(struct dhd_bus *bus, bool enforce_mutex);
 
@@ -75,10 +71,6 @@ extern void dhd_bus_clearcounts(dhd_pub_t *dhdp);
 /* return the dongle chipid */
 extern uint dhd_bus_chip(struct dhd_bus *bus);
 
-/* Set user-specified nvram parameters. */
-extern void dhd_bus_set_nvram_params(struct dhd_bus *bus,
-				     const char *nvram_params);
-
 extern void *dhd_bus_pub(struct dhd_bus *bus);
 extern void *dhd_bus_txq(struct dhd_bus *bus);
 extern uint dhd_bus_hdrlen(struct dhd_bus *bus);
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 8a32e88..44b8a25 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -33,8 +33,6 @@
 #define PKTFILTER_BUF_SIZE		2048
 
 int brcmf_msg_level;
-char brcmf_fw_path[MOD_PARAM_PATHLEN];
-char brcmf_nv_path[MOD_PARAM_PATHLEN];
 
 #define MSGTRACE_VERSION	1
 
@@ -111,17 +109,6 @@ void brcmf_c_init(void)
 	 * initializations.
 	 */
 	brcmf_msg_level = DHD_ERROR_VAL;
-#ifdef CONFIG_BCM4329_FW_PATH
-	strncpy(brcmf_fw_path, CONFIG_BCM4329_FW_PATH, MOD_PARAM_PATHLEN - 1);
-#else
-	brcmf_fw_path[0] = '\0';
-#endif
-#ifdef CONFIG_BCM4329_NVRAM_PATH
-	strncpy(brcmf_nv_path,
-		CONFIG_BCM4329_NVRAM_PATH, MOD_PARAM_PATHLEN - 1);
-#else
-	brcmf_nv_path[0] = '\0';
-#endif
 }
 
 static int brcmf_c_dump(dhd_pub_t *dhdp, char *buf, int buflen)
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 2213e4e..4724414 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -42,6 +42,7 @@
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
 #include "wl_cfg80211.h"
+#include "bcmchip.h"
 
 /* Global ASSERT type flag */
 u32 g_assert_type;
@@ -96,20 +97,6 @@ typedef struct dhd_info {
 #endif				/* CONFIG_HAS_EARLYSUSPEND */
 } dhd_info_t;
 
-/* Definitions to provide path to the firmware and nvram
- * example nvram_path[MOD_PARAM_PATHLEN]="/projects/wlan/nvram.txt"
- */
-char firmware_path[MOD_PARAM_PATHLEN];
-char nvram_path[MOD_PARAM_PATHLEN];
-
-/* load firmware and/or nvram values from the filesystem */
-module_param_string(firmware_path, firmware_path, MOD_PARAM_PATHLEN, 0);
-module_param_string(nvram_path, nvram_path, MOD_PARAM_PATHLEN, 0);
-
-/* No firmware required */
-bool brcmf_no_fw_req;
-module_param(brcmf_no_fw_req, bool, 0);
-
 /* Error bits */
 module_param(brcmf_msg_level, int, 0);
 
@@ -1080,7 +1067,7 @@ static void brcmf_ethtool_get_drvinfo(struct net_device *net,
 
 	sprintf(info->driver, KBUILD_MODNAME);
 	sprintf(info->version, "%lu", dhd->pub.drv_version);
-	sprintf(info->fw_version, "%s", wl_cfg80211_get_fwname());
+	sprintf(info->fw_version, "%s", BCM4329_FW_NAME);
 	sprintf(info->bus_info, "%s", dev_name(&wl_cfg80211_get_sdio_func()->dev));
 }
 
@@ -1438,12 +1425,6 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 	struct net_device *net;
 
 	DHD_TRACE(("%s: Enter\n", __func__));
-	/* updates firmware nvram path if it was provided as module
-		 paramters */
-	if ((firmware_path != NULL) && (firmware_path[0] != '\0'))
-		strcpy(brcmf_fw_path, firmware_path);
-	if ((nvram_path != NULL) && (nvram_path[0] != '\0'))
-		strcpy(brcmf_nv_path, nvram_path);
 
 	/* Allocate etherdev, including space for private structure */
 	net = alloc_etherdev(sizeof(dhd));
@@ -1503,10 +1484,6 @@ dhd_pub_t *brcmf_attach(struct dhd_bus *bus, uint bus_hdrlen)
 		DHD_ERROR(("wl_cfg80211_attach failed\n"));
 		goto fail;
 	}
-	if (!brcmf_no_fw_req) {
-		strcpy(brcmf_fw_path, wl_cfg80211_get_fwname());
-		strcpy(brcmf_nv_path, wl_cfg80211_get_nvramname());
-	}
 
 	if (brcmf_sysioc) {
 		sema_init(&dhd->sysioc_sem, 0);
@@ -1562,17 +1539,6 @@ int brcmf_bus_start(dhd_pub_t *dhdp)
 
 	DHD_TRACE(("%s:\n", __func__));
 
-	/* try to download image and nvram to the dongle */
-	if (dhd->pub.busstate == DHD_BUS_DOWN) {
-		if (!(dhd_bus_download_firmware(dhd->pub.bus, brcmf_fw_path,
-						brcmf_nv_path))) {
-			DHD_ERROR(("%s: dhd_bus_download_firmware failed. "
-				"firmware = %s nvram = %s\n",
-				__func__, brcmf_fw_path, brcmf_nv_path));
-			return -1;
-		}
-	}
-
 	/* Bring up the bus */
 	ret = brcmf_sdbrcm_bus_init(&dhd->pub, true);
 	if (ret != 0) {
@@ -1881,52 +1847,6 @@ int brcmf_os_ioctl_resp_wake(dhd_pub_t *pub)
 	return 0;
 }
 
-void *brcmf_os_open_image(char *filename)
-{
-	struct file *fp;
-
-	if (!brcmf_no_fw_req)
-		return wl_cfg80211_request_fw(filename);
-
-	fp = filp_open(filename, O_RDONLY, 0);
-	/*
-	 * 2.6.11 (FC4) supports filp_open() but later revs don't?
-	 * Alternative:
-	 * fp = open_namei(AT_FDCWD, filename, O_RD, 0);
-	 * ???
-	 */
-	if (IS_ERR(fp))
-		fp = NULL;
-
-	return fp;
-}
-
-int brcmf_os_get_image_block(char *buf, int len, void *image)
-{
-	struct file *fp = (struct file *)image;
-	int rdlen;
-
-	if (!brcmf_no_fw_req)
-		return wl_cfg80211_read_fw(buf, len);
-
-	if (!image)
-		return 0;
-
-	rdlen = kernel_read(fp, fp->f_pos, buf, len);
-	if (rdlen > 0)
-		fp->f_pos += rdlen;
-
-	return rdlen;
-}
-
-void brcmf_os_close_image(void *image)
-{
-	if (!brcmf_no_fw_req)
-		return wl_cfg80211_release_fw();
-	if (image)
-		filp_close((struct file *)image, NULL);
-}
-
 static int brcmf_host_event(dhd_info_t *dhd, int *ifidx, void *pktdata,
 			    brcmf_event_msg_t *event, void **data)
 {
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index d64ba7b..a4d30c7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -22,6 +22,8 @@
 #include <linux/netdevice.h>
 #include <linux/sched.h>
 #include <linux/mmc/sdio.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/firmware.h>
 #include <asm/unaligned.h>
 #include <defs.h>
 #include <brcmu_wifi.h>
@@ -29,6 +31,8 @@
 #include <brcm_hw_ids.h>
 #include <soc.h>
 #include "sdio_host.h"
+#include "bcmsdbus.h"
+#include "bcmsdh_sdmmc.h"
 
 /* register access macros */
 #ifndef __BIG_ENDIAN
@@ -473,9 +477,6 @@ typedef struct dhd_bus {
 	bool fcstate;		/* State of dongle flow-control */
 
 	u16 cl_devid;	/* cached devid for brcmf_sdio_probe_attach() */
-	char *fw_path;		/* module_param: path to firmware image */
-	char *nv_path;		/* module_param: path to nvram vars file */
-	const char *nvram_params;	/* user specified nvram params. */
 
 	uint blocksize;		/* Block size of SDIO transfers */
 	uint roundup;		/* Max roundup limit */
@@ -601,6 +602,11 @@ typedef struct dhd_bus {
 	bool threads_only;
 	struct semaphore sdsem;
 	spinlock_t sdlock;
+
+	const char *fw_name;
+	const struct firmware *firmware;
+	const char *nv_name;
+	u32 fw_ptr;
 } dhd_bus_t;
 
 typedef volatile struct _sbconfig {
@@ -804,8 +810,7 @@ static int brcmf_sdbrcm_send_buf(dhd_bus_t *bus, u32 addr, uint fn,
 static bool brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *sdh);
 static int  _brcmf_sdbrcm_download_firmware(struct dhd_bus *bus);
 
-static int
-brcmf_sdbrcm_download_code_file(struct dhd_bus *bus, char *image_path);
+static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus);
 static int brcmf_sdbrcm_download_nvram(struct dhd_bus *bus);
 static void brcmf_sdbrcm_chip_disablecore(struct brcmf_sdio *sdh, u32 corebase);
 static int brcmf_sdbrcm_chip_attach(struct dhd_bus *bus, void *regs);
@@ -822,6 +827,7 @@ static void brcmf_sdbrcm_dpc_tasklet(unsigned long data);
 static void brcmf_sdbrcm_sched_dpc(dhd_bus_t *bus);
 static void brcmf_sdbrcm_sdlock(dhd_bus_t *bus);
 static void brcmf_sdbrcm_sdunlock(dhd_bus_t *bus);
+static int brcmf_sdbrcm_get_image(char *buf, int len, struct dhd_bus *bus);
 
 /* Packet free applicable unconditionally for sdio and sdspi.
  * Conditional if bufpool was present for gspi bus.
@@ -3130,6 +3136,12 @@ int brcmf_sdbrcm_bus_init(dhd_pub_t *dhdp, bool enforce_mutex)
 
 	DHD_TRACE(("%s: Enter\n", __func__));
 
+	/* try to download image and nvram to the dongle */
+	if (dhdp->busstate == DHD_BUS_DOWN) {
+		if (!(brcmf_sdbrcm_download_firmware(bus, bus->sdh)))
+			return -1;
+	}
+
 	ASSERT(bus->dhd);
 	if (!bus->dhd)
 		return 0;
@@ -5606,18 +5618,6 @@ static bool brcmf_sdbrcm_probe_init(dhd_bus_t *bus, void *sdh)
 	return true;
 }
 
-bool
-dhd_bus_download_firmware(struct dhd_bus *bus, char *fw_path, char *nv_path)
-{
-	bool ret;
-	bus->fw_path = fw_path;
-	bus->nv_path = nv_path;
-
-	ret = brcmf_sdbrcm_download_firmware(bus, bus->sdh);
-
-	return ret;
-}
-
 static bool
 brcmf_sdbrcm_download_firmware(struct dhd_bus *bus, void *sdh)
 {
@@ -5744,24 +5744,29 @@ void dhd_bus_unregister(void)
 	brcmf_sdio_unregister();
 }
 
-static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus, char *fw_path)
+static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus)
 {
-	int bcmerror = -1;
 	int offset = 0;
 	uint len;
-	void *image = NULL;
 	u8 *memblock = NULL, *memptr;
+	int ret;
 
-	DHD_INFO(("%s: download firmware %s\n", __func__, brcmf_fw_path));
+	DHD_INFO(("%s: Enter\n", __func__));
 
-	image = brcmf_os_open_image(fw_path);
-	if (image == NULL)
-		goto err;
+	bus->fw_name = BCM4329_FW_NAME;
+	ret = request_firmware(&bus->firmware, bus->fw_name,
+			       &gInstance->func[2]->dev);
+	if (ret) {
+		DHD_ERROR(("%s: Fail to request firmware %d\n", __func__, ret));
+		return ret;
+	}
+	bus->fw_ptr = 0;
 
 	memptr = memblock = kmalloc(MEMBLOCK + BRCMF_SDALIGN, GFP_ATOMIC);
 	if (memblock == NULL) {
 		DHD_ERROR(("%s: Failed to allocate memory %d bytes\n",
 			   __func__, MEMBLOCK));
+		ret = -ENOMEM;
 		goto err;
 	}
 	if ((u32)(unsigned long)memblock % BRCMF_SDALIGN)
@@ -5770,12 +5775,11 @@ static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus, char *fw_path)
 
 	/* Download image */
 	while ((len =
-		brcmf_os_get_image_block((char *)memptr, MEMBLOCK, image))) {
-		bcmerror = brcmf_sdbrcm_membytes(bus, true, offset, memptr,
-						 len);
-		if (bcmerror) {
+		brcmf_sdbrcm_get_image((char *)memptr, MEMBLOCK, bus))) {
+		ret = brcmf_sdbrcm_membytes(bus, true, offset, memptr, len);
+		if (ret) {
 			DHD_ERROR(("%s: error %d on writing %d membytes at "
-			"0x%08x\n", __func__, bcmerror, MEMBLOCK, offset));
+			"0x%08x\n", __func__, ret, MEMBLOCK, offset));
 			goto err;
 		}
 
@@ -5785,10 +5789,10 @@ static int brcmf_sdbrcm_download_code_file(struct dhd_bus *bus, char *fw_path)
 err:
 	kfree(memblock);
 
-	if (image)
-		brcmf_os_close_image(image);
+	release_firmware(bus->firmware);
+	bus->fw_ptr = 0;
 
-	return bcmerror;
+	return ret;
 }
 
 /*
@@ -5842,66 +5846,31 @@ static uint brcmf_process_nvram_vars(char *varbuf, uint len)
 	return buf_len;
 }
 
-/*
-	EXAMPLE: nvram_array
-	nvram_arry format:
-	name=value
-	Use carriage return at the end of each assignment,
-	 and an empty string with
-	carriage return at the end of array.
-
-	For example:
-	unsigned char  nvram_array[] = {"name1=value1\n",
-	"name2=value2\n", "\n"};
-	Hex values start with 0x, and mac addr format: xx:xx:xx:xx:xx:xx.
-
-	Search "EXAMPLE: nvram_array" to see how the array is activated.
-*/
-
-void dhd_bus_set_nvram_params(struct dhd_bus *bus, const char *nvram_params)
-{
-	bus->nvram_params = nvram_params;
-}
-
 static int brcmf_sdbrcm_download_nvram(struct dhd_bus *bus)
 {
-	int bcmerror = -1;
 	uint len;
-	void *image = NULL;
 	char *memblock = NULL;
 	char *bufp;
-	char *nv_path;
-	bool nvram_file_exists;
-
-	nv_path = bus->nv_path;
-
-	nvram_file_exists = ((nv_path != NULL) && (nv_path[0] != '\0'));
-	if (!nvram_file_exists && (bus->nvram_params == NULL))
-		return 0;
+	int ret;
 
-	if (nvram_file_exists) {
-		image = brcmf_os_open_image(nv_path);
-		if (image == NULL)
-			goto err;
+	bus->nv_name = BCM4329_NV_NAME;
+	ret = request_firmware(&bus->firmware, bus->nv_name,
+			       &gInstance->func[2]->dev);
+	if (ret) {
+		DHD_ERROR(("%s: Fail to request nvram %d\n", __func__, ret));
+		return ret;
 	}
+	bus->fw_ptr = 0;
 
 	memblock = kmalloc(MEMBLOCK, GFP_ATOMIC);
 	if (memblock == NULL) {
 		DHD_ERROR(("%s: Failed to allocate memory %d bytes\n",
 			   __func__, MEMBLOCK));
+		ret = -ENOMEM;
 		goto err;
 	}
 
-	/* Download variables */
-	if (nvram_file_exists) {
-		len = brcmf_os_get_image_block(memblock, MEMBLOCK, image);
-	} else {
-		len = strlen(bus->nvram_params);
-		ASSERT(len <= MEMBLOCK);
-		if (len > MEMBLOCK)
-			len = MEMBLOCK;
-		memcpy(memblock, bus->nvram_params, len);
-	}
+	len = brcmf_sdbrcm_get_image(memblock, MEMBLOCK, bus);
 
 	if (len > 0 && len < MEMBLOCK) {
 		bufp = (char *)memblock;
@@ -5910,38 +5879,29 @@ static int brcmf_sdbrcm_download_nvram(struct dhd_bus *bus)
 		bufp += len;
 		*bufp++ = 0;
 		if (len)
-			bcmerror = brcmf_sdbrcm_downloadvars(bus, memblock,
-							   len + 1);
-		if (bcmerror) {
+			ret = brcmf_sdbrcm_downloadvars(bus, memblock, len + 1);
+		if (ret)
 			DHD_ERROR(("%s: error downloading vars: %d\n",
-				   __func__, bcmerror));
-		}
+				   __func__, ret));
 	} else {
 		DHD_ERROR(("%s: error reading nvram file: %d\n",
 			   __func__, len));
-		bcmerror = -EIO;
+		ret = -EIO;
 	}
 
 err:
 	kfree(memblock);
 
-	if (image)
-		brcmf_os_close_image(image);
+	release_firmware(bus->firmware);
+	bus->fw_ptr = 0;
 
-	return bcmerror;
+	return ret;
 }
 
 static int _brcmf_sdbrcm_download_firmware(struct dhd_bus *bus)
 {
 	int bcmerror = -1;
 
-	bool embed = false;	/* download embedded firmware */
-	bool dlok = false;	/* download firmware succeeded */
-
-	/* Out immediately if no image to download */
-	if ((bus->fw_path == NULL) || (bus->fw_path[0] == '\0'))
-		return bcmerror;
-
 	/* Keep arm in reset */
 	if (brcmf_sdbrcm_download_state(bus, true)) {
 		DHD_ERROR(("%s: error placing ARM core in reset\n", __func__));
@@ -5949,18 +5909,9 @@ static int _brcmf_sdbrcm_download_firmware(struct dhd_bus *bus)
 	}
 
 	/* External image takes precedence if specified */
-	if ((bus->fw_path != NULL) && (bus->fw_path[0] != '\0')) {
-		if (brcmf_sdbrcm_download_code_file(bus, bus->fw_path)) {
-			DHD_ERROR(("%s: dongle image file download failed\n",
-				   __func__));
-			goto err;
-		} else {
-			embed = false;
-			dlok = true;
-		}
-	}
-	if (!dlok) {
-		DHD_ERROR(("%s: dongle image download failed\n", __func__));
+	if (brcmf_sdbrcm_download_code_file(bus)) {
+		DHD_ERROR(("%s: dongle image file download failed\n",
+			  __func__));
 		goto err;
 	}
 
@@ -6061,11 +6012,7 @@ int brcmf_bus_devreset(dhd_pub_t *dhdp, u8 flag)
 						 (u32 *) SI_ENUM_BASE,
 						 bus->cl_devid)) {
 				/* Attempt to download binary to the dongle */
-				if (brcmf_sdbrcm_probe_init
-				    (bus, bus->sdh)
-				    && brcmf_sdbrcm_download_firmware(bus,
-								 bus->sdh)) {
-
+				if (brcmf_sdbrcm_probe_init(bus, bus->sdh)) {
 					/* Re-init bus, enable F2 transfer */
 					brcmf_sdbrcm_bus_init(
 						(dhd_pub_t *) bus->dhd, false);
@@ -6669,3 +6616,16 @@ static void brcmf_sdbrcm_sdunlock(dhd_bus_t *bus)
 	else
 		spin_unlock_bh(&bus->sdlock);
 }
+
+static int brcmf_sdbrcm_get_image(char *buf, int len, struct dhd_bus *bus)
+{
+	if (bus->firmware->size < bus->fw_ptr + len)
+		len = bus->firmware->size - bus->fw_ptr;
+
+	memcpy(buf, &bus->firmware->data[bus->fw_ptr], len);
+	bus->fw_ptr += len;
+	return len;
+}
+
+MODULE_FIRMWARE(BCM4329_FW_NAME);
+MODULE_FIRMWARE(BCM4329_NV_NAME);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index a3c2e87..9d86fc1 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -24,7 +24,6 @@
 #include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <linux/mmc/sdio_func.h>
-#include <linux/firmware.h>
 #include <linux/uaccess.h>
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
@@ -42,9 +41,6 @@ static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 
 u32 brcmf_dbg_level = WL_DBG_ERR;
 
-#define WL_4329_FW_FILE "brcm/bcm4329-fullmac-4.bin"
-#define WL_4329_NVRAM_FILE "brcm/bcm4329-fullmac-4.txt"
-
 /*
 ** cfg80211_ops api/callback list
 */
@@ -283,11 +279,6 @@ static s32 wl_iscan_inprogress(struct wl_priv *wl);
 static s32 wl_iscan_aborted(struct wl_priv *wl);
 
 /*
-** fw/nvram downloading handler
-*/
-static void wl_init_fw(struct wl_fw_ctrl *fw);
-
-/*
 * find most significant bit set
 */
 static __used u32 wl_find_msb(u16 bit16);
@@ -3061,11 +3052,6 @@ static s32 wl_init_priv_mem(struct wl_priv *wl)
 		WL_ERR("Iscan buf alloc failed\n");
 		goto init_priv_mem_out;
 	}
-	wl->fw = kzalloc(sizeof(*wl->fw), GFP_KERNEL);
-	if (unlikely(!wl->fw)) {
-		WL_ERR("fw object alloc failed\n");
-		goto init_priv_mem_out;
-	}
 	wl->pmk_list = kzalloc(sizeof(*wl->pmk_list), GFP_KERNEL);
 	if (unlikely(!wl->pmk_list)) {
 		WL_ERR("pmk list alloc failed\n");
@@ -3098,8 +3084,6 @@ static void wl_deinit_priv_mem(struct wl_priv *wl)
 	wl->extra_buf = NULL;
 	kfree(wl->iscan);
 	wl->iscan = NULL;
-	kfree(wl->fw);
-	wl->fw = NULL;
 	kfree(wl->pmk_list);
 	wl->pmk_list = NULL;
 }
@@ -3361,12 +3345,6 @@ static s32 wl_init_iscan(struct wl_priv *wl)
 	return err;
 }
 
-static void wl_init_fw(struct wl_fw_ctrl *fw)
-{
-	fw->status = 0;		/* init fw loading status.
-				 0 means nothing was loaded yet */
-}
-
 static s32 wl_init_priv(struct wl_priv *wl)
 {
 	struct wiphy *wiphy = wl_to_wiphy(wl);
@@ -3394,7 +3372,6 @@ static s32 wl_init_priv(struct wl_priv *wl)
 	err = wl_init_iscan(wl);
 	if (unlikely(err))
 		return err;
-	wl_init_fw(wl->fw);
 	wl_init_conf(wl->conf);
 	wl_init_prof(wl->profile);
 	wl_link_down(wl);
@@ -4066,98 +4043,6 @@ static void *wl_get_drvdata(struct wl_dev *dev)
 	return data;
 }
 
-s32 wl_cfg80211_read_fw(s8 *buf, u32 size)
-{
-	const struct firmware *fw_entry;
-	struct wl_priv *wl;
-
-	wl = WL_PRIV_GET();
-
-	fw_entry = wl->fw->fw_entry;
-
-	if (fw_entry->size < wl->fw->ptr + size)
-		size = fw_entry->size - wl->fw->ptr;
-
-	memcpy(buf, &fw_entry->data[wl->fw->ptr], size);
-	wl->fw->ptr += size;
-	return size;
-}
-
-void wl_cfg80211_release_fw(void)
-{
-	struct wl_priv *wl;
-
-	wl = WL_PRIV_GET();
-	release_firmware(wl->fw->fw_entry);
-	wl->fw->ptr = 0;
-}
-
-void *wl_cfg80211_request_fw(s8 *file_name)
-{
-	struct wl_priv *wl;
-	const struct firmware *fw_entry = NULL;
-	s32 err = 0;
-
-	WL_INFO("file name : \"%s\"\n", file_name);
-	wl = WL_PRIV_GET();
-
-	if (!test_bit(WL_FW_LOADING_DONE, &wl->fw->status)) {
-		err = request_firmware(&wl->fw->fw_entry, file_name,
-				&wl_cfg80211_get_sdio_func()->dev);
-		if (unlikely(err)) {
-			WL_ERR("Could not download fw (%d)\n", err);
-			goto req_fw_out;
-		}
-		set_bit(WL_FW_LOADING_DONE, &wl->fw->status);
-		fw_entry = wl->fw->fw_entry;
-		if (fw_entry) {
-			WL_INFO("fw size (%zd), data (%p)\n",
-			       fw_entry->size, fw_entry->data);
-		}
-	} else if (!test_bit(WL_NVRAM_LOADING_DONE, &wl->fw->status)) {
-		err = request_firmware(&wl->fw->fw_entry, file_name,
-				&wl_cfg80211_get_sdio_func()->dev);
-		if (unlikely(err)) {
-			WL_ERR("Could not download nvram (%d)\n", err);
-			goto req_fw_out;
-		}
-		set_bit(WL_NVRAM_LOADING_DONE, &wl->fw->status);
-		fw_entry = wl->fw->fw_entry;
-		if (fw_entry) {
-			WL_INFO("nvram size (%zd), data (%p)\n",
-			       fw_entry->size, fw_entry->data);
-		}
-	} else {
-		WL_INFO("Downloading already done. Nothing to do more\n");
-		err = -EPERM;
-	}
-
-req_fw_out:
-	if (unlikely(err)) {
-		return NULL;
-	}
-	wl->fw->ptr = 0;
-	return (void *)fw_entry->data;
-}
-
-s8 *wl_cfg80211_get_fwname(void)
-{
-	struct wl_priv *wl;
-
-	wl = WL_PRIV_GET();
-	strcpy(wl->fw->fw_name, WL_4329_FW_FILE);
-	return wl->fw->fw_name;
-}
-
-s8 *wl_cfg80211_get_nvramname(void)
-{
-	struct wl_priv *wl;
-
-	wl = WL_PRIV_GET();
-	strcpy(wl->fw->nvram_name, WL_4329_NVRAM_FILE);
-	return wl->fw->nvram_name;
-}
-
 static void wl_set_mpc(struct net_device *ndev, int mpc)
 {
 	s32 err = 0;
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index bc7b4a3..7848b3c 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -116,7 +116,6 @@ do {								\
 #define WL_AP_MAX	256	/* virtually unlimitted as long
 				 * as kernel memory allows
 				 */
-#define WL_FILE_NAME_MAX		256
 
 #define WL_ROAM_TRIGGER_LEVEL		-75
 #define WL_ROAM_DELTA			20
@@ -161,12 +160,6 @@ enum wl_iscan_state {
 	WL_ISCAN_STATE_SCANING
 };
 
-/* fw downloading status */
-enum wl_fw_status {
-	WL_FW_LOADING_DONE,
-	WL_NVRAM_LOADING_DONE
-};
-
 /* beacon / probe_response */
 struct beacon_proberesp {
 	__le64 timestamp;
@@ -288,15 +281,6 @@ struct wl_connect_info {
 	s32 resp_ie_len;
 };
 
-/* firmware /nvram downloading controller */
-struct wl_fw_ctrl {
-	const struct firmware *fw_entry;
-	unsigned long status;
-	u32 ptr;
-	s8 fw_name[WL_FILE_NAME_MAX];
-	s8 nvram_name[WL_FILE_NAME_MAX];
-};
-
 /* assoc ie length */
 struct wl_assoc_ielen {
 	u32 req_len;
@@ -334,8 +318,6 @@ struct wl_priv {
 	struct wl_iscan_ctrl *iscan;	/* iscan controller */
 	struct wl_connect_info conn_info;	/* association information
 						 container */
-	struct wl_fw_ctrl *fw;	/* control firwmare / nvram paramter
-				 downloading */
 	struct wl_pmk_list *pmk_list;	/* wpa2 pmk list */
 	struct task_struct *event_tsk;	/* task of main event handler thread */
 	unsigned long status;		/* current dongle status */
@@ -395,13 +377,4 @@ extern s32 wl_cfg80211_up(void);	/* dongle up */
 extern s32 wl_cfg80211_down(void);	/* dongle down */
 extern void wl_cfg80211_dbg_level(u32 level);	/* set dongle
 							 debugging level */
-extern void *wl_cfg80211_request_fw(s8 *file_name);	/* request fw /nvram
-							 downloading */
-extern s32 wl_cfg80211_read_fw(s8 *buf, u32 size);	/* read fw
-								 image */
-extern void wl_cfg80211_release_fw(void);	/* release fw */
-extern s8 *wl_cfg80211_get_fwname(void);	/* get firmware name for
-						 the dongle */
-extern s8 *wl_cfg80211_get_nvramname(void);	/* get nvram name for
-						 the dongle */
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.1


