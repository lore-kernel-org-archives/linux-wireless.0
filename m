Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3401 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933264Ab2KOCqf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Nov 2012 21:46:35 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Hante Meuleman" <meuleman@broadcom.com>
Subject: [PATCH 19/19] brcmfmac: code cleanup
Date: Wed, 14 Nov 2012 18:46:23 -0800
Message-ID: <1352947583-25341-20-git-send-email-frankyl@broadcom.com> (sfid-20121115_034653_093152_03683E1A)
In-Reply-To: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
References: <1352947583-25341-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Hante Meuleman <meuleman@broadcom.com>

Removing obsolete functions and prototypes. Moving (and renaming)
defines to place with similar definitions. Removing unnecessary
includes.

Reviewed-by: Arend Van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   20 ++++-------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c  |    2 --
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |   24 -------------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    5 ---
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |   38 ++------------------
 .../net/wireless/brcm80211/brcmfmac/dhd_proto.h    |    4 ---
 drivers/net/wireless/brcm80211/brcmfmac/fweh.c     |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/fwil.c     |    1 -
 drivers/net/wireless/brcm80211/brcmfmac/usb.c      |   21 ++---------
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |   17 +++------
 12 files changed, 16 insertions(+), 119 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index 6dd75cc..a800502 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -491,7 +491,6 @@ static int brcmf_ops_sdio_probe(struct sdio_func *func,
 
 	sdiodev->bus_if = bus_if;
 	bus_if->bus_priv.sdio = sdiodev;
-	bus_if->type = SDIO_BUS;
 	bus_if->align = BRCMF_SDALIGN;
 	dev_set_drvdata(&func->dev, bus_if);
 	dev_set_drvdata(&sdiodev->func[1]->dev, bus_if);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index 499c5c2..24bc4e3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -40,8 +40,11 @@
 #define BRCMF_C_GET_SSID			25
 #define BRCMF_C_SET_SSID			26
 #define BRCMF_C_GET_CHANNEL			29
+#define BRCMF_C_SET_CHANNEL			30
 #define BRCMF_C_GET_SRL				31
+#define BRCMF_C_SET_SRL				32
 #define BRCMF_C_GET_LRL				33
+#define BRCMF_C_SET_LRL				34
 #define BRCMF_C_GET_RADIO			37
 #define BRCMF_C_SET_RADIO			38
 #define BRCMF_C_GET_PHYTYPE			39
@@ -60,6 +63,7 @@
 #define BRCMF_C_SET_COUNTRY			84
 #define BRCMF_C_GET_PM				85
 #define BRCMF_C_SET_PM				86
+#define BRCMF_C_GET_CURR_RATESET		114
 #define BRCMF_C_GET_AP				117
 #define BRCMF_C_SET_AP				118
 #define BRCMF_C_GET_RSSI			127
@@ -67,6 +71,7 @@
 #define BRCMF_C_SET_WSEC			134
 #define BRCMF_C_GET_PHY_NOISE			135
 #define BRCMF_C_GET_BSS_INFO			136
+#define BRCMF_C_GET_PHYLIST			180
 #define BRCMF_C_SET_SCAN_CHANNEL_TIME		185
 #define BRCMF_C_SET_SCAN_UNASSOC_TIME		187
 #define BRCMF_C_SCB_DEAUTHENTICATE_FOR_REASON	201
@@ -102,16 +107,8 @@
 #define BRCMF_SCAN_PARAMS_COUNT_MASK 0x0000ffff
 #define BRCMF_SCAN_PARAMS_NSSID_SHIFT 16
 
-/* Indicates this key is using soft encrypt */
-#define WL_SOFT_KEY	(1 << 0)
 /* primary (ie tx) key */
 #define BRCMF_PRIMARY_KEY	(1 << 1)
-/* Reserved for backward compat */
-#define WL_KF_RES_4	(1 << 4)
-/* Reserved for backward compat */
-#define WL_KF_RES_5	(1 << 5)
-/* Indicates a group key for a IBSS PEER */
-#define WL_IBSS_PEER_GROUP_KEY	(1 << 6)
 
 /* For supporting multiple interfaces */
 #define BRCMF_MAX_IFS	16
@@ -286,7 +283,7 @@ struct brcm_rateset_le {
 	/* # rates in this set */
 	__le32 count;
 	/* rates in 500kbps units w/hi bit set if basic */
-	u8 rates[WL_NUMRATES];
+	u8 rates[BRCMF_MAXRATES_IN_SET];
 };
 
 struct brcmf_ssid {
@@ -580,11 +577,6 @@ extern int brcmf_proto_cdc_query_dcmd(struct brcmf_pub *drvr, int ifidx,
 extern int brcmf_proto_cdc_set_dcmd(struct brcmf_pub *drvr, int ifidx, uint cmd,
 				    void *buf, uint len);
 
-extern int brcmf_ifname2idx(struct brcmf_pub *drvr, char *name);
-extern int brcmf_c_host_event(struct brcmf_pub *drvr, int *idx,
-			      void *pktdata, struct brcmf_event_msg *,
-			      void **data_ptr);
-
 extern int brcmf_net_attach(struct brcmf_if *ifp);
 extern struct brcmf_if *brcmf_add_if(struct brcmf_pub *drvr, int ifidx,
 				     s32 bssidx, char *name, u8 *mac_addr);
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index a8bb5d2..b8f2487 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -45,7 +45,6 @@ struct brcmf_bus_dcmd {
 
 /* interface structure between common and bus layer */
 struct brcmf_bus {
-	u8 type;		/* bus type */
 	union {
 		struct brcmf_sdio_dev *sdio;
 		struct brcmf_usbdev *usb;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
index 601d4d7..87536d3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_cdc.c
@@ -23,8 +23,6 @@
 
 #include <linux/types.h>
 #include <linux/netdevice.h>
-#include <linux/sched.h>
-#include <defs.h>
 
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index 3d59332..eee7175 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -18,10 +18,7 @@
 
 #include <linux/kernel.h>
 #include <linux/string.h>
-#include <linux/sched.h>
 #include <linux/netdevice.h>
-#include <asm/unaligned.h>
-#include <defs.h>
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include "dhd.h"
@@ -30,9 +27,6 @@
 #include "dhd_dbg.h"
 #include "fwil.h"
 
-#define BRCM_OUI			"\x00\x10\x18"
-#define DOT11_OUI_LEN			3
-#define BCMILCP_BCM_SUBTYPE_EVENT	1
 #define PKTFILTER_BUF_SIZE		128
 #define BRCMF_ARPOL_MODE		0xb	/* agent|snoop|peer_autoreply */
 #define BRCMF_DEFAULT_BCN_TIMEOUT	3
@@ -40,8 +34,6 @@
 #define BRCMF_DEFAULT_SCAN_UNASSOC_TIME	40
 #define BRCMF_DEFAULT_PACKET_FILTER	"100 0 0 0 0x01 0x00"
 
-#define MSGTRACE_VERSION	1
-
 #ifdef DEBUG
 static const char brcmf_version[] =
 	"Dongle Host Driver, version " BRCMF_VERSION_STR "\nCompiled on "
@@ -51,22 +43,6 @@ static const char brcmf_version[] =
 	"Dongle Host Driver, version " BRCMF_VERSION_STR;
 #endif
 
-/* Message trace header */
-struct msgtrace_hdr {
-	u8 version;
-	u8 spare;
-	__be16 len;		/* Len of the trace */
-	__be32 seqnum;		/* Sequence number of message. Useful
-				 * if the messsage has been lost
-				 * because of DMA error or a bus reset
-				 * (ex: SDIO Func2)
-				 */
-	__be32 discarded_bytes;	/* Number of discarded bytes because of
-				 trace overflow  */
-	__be32 discarded_printf;	/* Number of discarded printf
-				 because of trace overflow */
-} __packed;
-
 
 bool brcmf_c_prec_enq(struct device *dev, struct pktq *q,
 		      struct sk_buff *pkt, int prec)
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index 49f53ba..7e58e8c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -14,17 +14,12 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 #include <linux/debugfs.h>
-#include <linux/if_ether.h>
-#include <linux/if.h>
 #include <linux/netdevice.h>
-#include <linux/ieee80211.h>
 #include <linux/module.h>
 
-#include <defs.h>
 #include <brcmu_wifi.h>
 #include <brcmu_utils.h>
 #include "dhd.h"
-#include "dhd_bus.h"
 #include "dhd_dbg.h"
 
 static struct dentry *root_folder;
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index a39ea20..b6c86b0 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -16,27 +16,11 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/init.h>
 #include <linux/kernel.h>
-#include <linux/kthread.h>
-#include <linux/slab.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-#include <linux/mmc/sdio_func.h>
-#include <linux/random.h>
-#include <linux/spinlock.h>
-#include <linux/ethtool.h>
-#include <linux/fcntl.h>
-#include <linux/fs.h>
-#include <linux/uaccess.h>
-#include <linux/hardirq.h>
-#include <linux/mutex.h>
-#include <linux/wait.h>
 #include <linux/module.h>
 #include <net/cfg80211.h>
 #include <net/rtnetlink.h>
-#include <defs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 
@@ -48,8 +32,8 @@
 #include "fwil.h"
 
 MODULE_AUTHOR("Broadcom Corporation");
-MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN fullmac driver.");
-MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN fullmac cards");
+MODULE_DESCRIPTION("Broadcom 802.11 wireless LAN fullmac driver.");
+MODULE_SUPPORTED_DEVICE("Broadcom 802.11 WLAN fullmac cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
 #define MAX_WAIT_FOR_8021X_TX		50	/* msecs */
@@ -58,24 +42,6 @@ MODULE_LICENSE("Dual BSD/GPL");
 int brcmf_msg_level = BRCMF_ERROR_VAL;
 module_param(brcmf_msg_level, int, 0);
 
-int brcmf_ifname2idx(struct brcmf_pub *drvr, char *name)
-{
-	int i = BRCMF_MAX_IFS;
-	struct brcmf_if *ifp;
-
-	if (name == NULL || *name == '\0')
-		return 0;
-
-	while (--i > 0) {
-		ifp = drvr->iflist[i];
-		if (ifp && !strncmp(ifp->ndev->name, name, IFNAMSIZ))
-			break;
-	}
-
-	brcmf_dbg(TRACE, "return idx %d for \"%s\"\n", i, name);
-
-	return i;		/* default - the primary interface */
-}
 
 char *brcmf_ifname(struct brcmf_pub *drvr, int ifidx)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
index 9b7969d..48fa703 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_proto.h
@@ -36,10 +36,6 @@ extern void brcmf_proto_stop(struct brcmf_pub *drvr);
 extern void brcmf_proto_hdrpush(struct brcmf_pub *, int ifidx,
 				struct sk_buff *txp);
 
-/* Use protocol to issue command to dongle */
-extern int brcmf_proto_dcmd(struct brcmf_pub *drvr, int ifidx,
-				struct brcmf_dcmd *dcmd, int len);
-
 /* Sets dongle media info (drv_version, mac address). */
 extern int brcmf_c_preinit_dcmds(struct brcmf_if *ifp);
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
index 37f853d..1e4188c 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.c
@@ -15,7 +15,6 @@
  */
 #include <linux/netdevice.h>
 
-#include "defs.h"
 #include "brcmu_wifi.h"
 #include "brcmu_utils.h"
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
index 7e678e9..51a1450 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil.c
@@ -20,7 +20,6 @@
 
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
-#include <defs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include "dhd.h"
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/usb.c b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
index 589afe6..feaca14 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/usb.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/usb.c
@@ -14,24 +14,11 @@
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
  */
 
-#include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
-#include <linux/kthread.h>
-#include <linux/slab.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <linux/spinlock.h>
-#include <linux/ethtool.h>
-#include <linux/fcntl.h>
-#include <linux/fs.h>
-#include <linux/uaccess.h>
 #include <linux/firmware.h>
 #include <linux/usb.h>
-#include <linux/vmalloc.h>
-#include <net/cfg80211.h>
 
-#include <defs.h>
 #include <brcmu_utils.h>
 #include <brcmu_wifi.h>
 #include <dhd_bus.h>
@@ -1240,8 +1227,7 @@ error:
 	return NULL;
 }
 
-static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo,
-			      const char *desc,	u32 bustype, u32 hdrlen)
+static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo)
 {
 	struct brcmf_bus *bus = NULL;
 	struct brcmf_usbdev *bus_pub = NULL;
@@ -1265,12 +1251,11 @@ static int brcmf_usb_probe_cb(struct brcmf_usbdev_info *devinfo,
 	bus->brcmf_bus_stop = brcmf_usb_down;
 	bus->brcmf_bus_txctl = brcmf_usb_tx_ctlpkt;
 	bus->brcmf_bus_rxctl = brcmf_usb_rx_ctlpkt;
-	bus->type = bustype;
 	bus->bus_priv.usb = bus_pub;
 	dev_set_drvdata(dev, bus);
 
 	/* Attach to the common driver interface */
-	ret = brcmf_attach(hdrlen, dev);
+	ret = brcmf_attach(0, dev);
 	if (ret) {
 		brcmf_dbg(ERROR, "brcmf_attach failed\n");
 		goto fail;
@@ -1419,7 +1404,7 @@ brcmf_usb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	else
 		brcmf_dbg(USB, "Broadcom full speed USB wireless device detected\n");
 
-	ret = brcmf_usb_probe_cb(devinfo, "", USB_BUS, 0);
+	ret = brcmf_usb_probe_cb(devinfo);
 	if (ret)
 		goto fail;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index be45893..e2a4981 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -19,14 +19,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/kernel.h>
-#include <linux/if_arp.h>
-#include <linux/sched.h>
-#include <linux/kthread.h>
-#include <linux/netdevice.h>
-#include <linux/bitops.h>
 #include <linux/etherdevice.h>
-#include <linux/ieee80211.h>
-#include <linux/uaccess.h>
 #include <net/cfg80211.h>
 #include <net/netlink.h>
 
@@ -883,7 +876,7 @@ static s32 brcmf_set_frag(struct net_device *ndev, u32 frag_threshold)
 static s32 brcmf_set_retry(struct net_device *ndev, u32 retry, bool l)
 {
 	s32 err = 0;
-	u32 cmd = (l ? BRCM_SET_LRL : BRCM_SET_SRL);
+	u32 cmd = (l ? BRCMF_C_SET_LRL : BRCMF_C_SET_SRL);
 
 	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), cmd, retry);
 	if (err) {
@@ -1066,7 +1059,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 	else
 		bcnprd = 100;
 
-	err = brcmf_fil_cmd_int_set(ifp, BRCM_SET_BCNPRD, bcnprd);
+	err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_BCNPRD, bcnprd);
 	if (err) {
 		WL_ERR("WLC_SET_BCNPRD failed (%d)\n", err);
 		goto done;
@@ -1108,7 +1101,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *ndev,
 
 		/* set channel for starter */
 		target_channel = cfg->channel;
-		err = brcmf_fil_cmd_int_set(ifp, BRCM_SET_CHANNEL,
+		err = brcmf_fil_cmd_int_set(ifp, BRCMF_C_SET_CHANNEL,
 					    target_channel);
 		if (err) {
 			WL_ERR("WLC_SET_CHANNEL failed (%d)\n", err);
@@ -2044,7 +2037,7 @@ brcmf_cfg80211_set_bitrate_mask(struct wiphy *wiphy, struct net_device *ndev,
 
 	/* addr param is always NULL. ignore it */
 	/* Get current rateset */
-	err = brcmf_fil_cmd_data_get(ifp, BRCM_GET_CURR_RATESET,
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_CURR_RATESET,
 				     &rateset_le, sizeof(rateset_le));
 	if (err) {
 		WL_ERR("could not get current rateset (%d)\n", err);
@@ -4456,7 +4449,7 @@ static s32 wl_update_wiphybands(struct brcmf_cfg80211_info *cfg)
 	s8 phy;
 	s32 err = 0;
 
-	err = brcmf_fil_cmd_data_get(ifp, BRCM_GET_PHYLIST,
+	err = brcmf_fil_cmd_data_get(ifp, BRCMF_C_GET_PHYLIST,
 				     &phy_list, sizeof(phy_list));
 	if (err) {
 		WL_ERR("error (%d)\n", err);
-- 
1.7.9.5


