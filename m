Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2967 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755916Ab2JVRgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Oct 2012 13:36:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 06/14] brcmfmac: extend struct brcmf_if with bssidx
 field
Date: Mon, 22 Oct 2012 10:36:19 -0700
Message-ID: <1350927387-25608-7-git-send-email-frankyl@broadcom.com> (sfid-20121022_193658_284970_3956925C)
In-Reply-To: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
References: <1350927387-25608-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

When the firmware notifies the driver about adding a new interface
it also provides an index for the bss associated with this interface.
This index will be needed for upcoming features like peer-to-peer.
By adding this index in struct brcmf_if it is easy to obtain as this
will be associated with the net_device private data.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd.h      |   43 ++++++++++++--------
 drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h  |    2 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_common.c   |    3 +-
 drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c  |    1 +
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    7 ++-
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |    8 ++--
 6 files changed, 39 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
index faa81ef..d848bb9 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd.h
@@ -677,20 +677,9 @@ struct brcmf_pub {
 #endif
 };
 
-/* struct brcmf_if - Interface control information
- *
- * @drvr: back pointer to brcmf_pub
- * @ndev: interface net device pointer
- * @stats: net device statistics
- * @idx: iface idx in dongle
- * @mac_addr: assigned MAC address
- */
-struct brcmf_if {
-	struct brcmf_pub *drvr;
-	struct net_device *ndev;
-	struct net_device_stats stats;
-	int idx;
-	u8 mac_addr[ETH_ALEN];
+struct bcmevent_name {
+	uint event;
+	const char *name;
 };
 
 struct brcmf_if_event {
@@ -700,11 +689,31 @@ struct brcmf_if_event {
 	u8 bssidx;
 };
 
-struct bcmevent_name {
-	uint event;
-	const char *name;
+/**
+ * struct brcmf_if - interface control information.
+ *
+ * @drvr: points to device related information.
+ * @ndev: associated network device.
+ * @stats: interface specific network statistics.
+ * @idx: interface index in device firmware.
+ * @bssidx: index of bss associated with this interface.
+ * @mac_addr: assigned mac address.
+ */
+struct brcmf_if {
+	struct brcmf_pub *drvr;
+	struct net_device *ndev;
+	struct net_device_stats stats;
+	int idx;
+	s32 bssidx;
+	u8 mac_addr[ETH_ALEN];
 };
 
+static inline s32 brcmf_ndev_bssidx(struct net_device *ndev)
+{
+	struct brcmf_if *ifp = netdev_priv(ndev);
+	return ifp->bssidx;
+}
+
 extern const struct bcmevent_name bcmevent_names[];
 
 extern uint brcmf_c_mkiovar(char *name, char *data, uint datalen,
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
index 9b8ee19..ba42e4e 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_bus.h
@@ -111,7 +111,7 @@ extern void brcmf_txcomplete(struct device *dev, struct sk_buff *txp,
 
 extern int brcmf_bus_start(struct device *dev);
 
-extern int brcmf_add_if(struct device *dev, int ifidx,
+extern int brcmf_add_if(struct device *dev, int ifidx, s32 bssidx,
 			char *name, u8 *mac_addr);
 
 #ifdef CONFIG_BRCMFMAC_SDIO
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
index aa4f719..bc62791 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_common.c
@@ -480,7 +480,8 @@ brcmf_c_host_event(struct brcmf_pub *drvr, int *ifidx, void *pktdata,
 
 		if (ifevent->ifidx > 0 && ifevent->ifidx < BRCMF_MAX_IFS) {
 			if (ifevent->action == BRCMF_E_IF_ADD)
-				brcmf_add_if(drvr->dev, ifevent->ifidx,
+				brcmf_add_if(drvr->dev,
+					     ifevent->ifidx, ifevent->bssidx,
 					     event->ifname,
 					     pvt_data->eth.h_dest);
 			else
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
index fa08058..862d2ac 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_dbg.c
@@ -16,6 +16,7 @@
 #include <linux/debugfs.h>
 #include <linux/if_ether.h>
 #include <linux/if.h>
+#include <linux/netdevice.h>
 #include <linux/ieee80211.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index c524b04..f603032 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -837,7 +837,8 @@ fail:
 }
 
 int
-brcmf_add_if(struct device *dev, int ifidx, char *name, u8 *mac_addr)
+brcmf_add_if(struct device *dev, int ifidx, s32 bssidx,
+	     char *name, u8 *mac_addr)
 {
 	struct brcmf_if *ifp;
 	struct net_device *ndev;
@@ -872,6 +873,7 @@ brcmf_add_if(struct device *dev, int ifidx, char *name, u8 *mac_addr)
 	ifp->drvr = drvr;
 	drvr->iflist[ifidx] = ifp;
 	ifp->idx = ifidx;
+	ifp->bssidx = bssidx;
 	if (mac_addr != NULL)
 		memcpy(&ifp->mac_addr, mac_addr, ETH_ALEN);
 
@@ -1002,6 +1004,7 @@ int brcmf_bus_start(struct device *dev)
 	setbit(drvr->eventmask, BRCMF_E_TXFAIL);
 	setbit(drvr->eventmask, BRCMF_E_JOIN_START);
 	setbit(drvr->eventmask, BRCMF_E_SCAN_COMPLETE);
+	setbit(drvr->eventmask, BRCMF_E_IF);
 
 /* enable dongle roaming event */
 
@@ -1015,7 +1018,7 @@ int brcmf_bus_start(struct device *dev)
 		return ret;
 
 	/* add primary networking interface */
-	ret = brcmf_add_if(dev, 0, "wlan%d", drvr->mac);
+	ret = brcmf_add_if(dev, 0, 0, "wlan%d", drvr->mac);
 	if (ret < 0)
 		return ret;
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d354b2a..24f5580 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -3769,7 +3769,7 @@ brcmf_vndr_ie(u8 *iebuf, s32 pktflag, u8 *ie_ptr, u32 ie_len, s8 *add_del_cmd)
 
 static s32
 brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
-			struct net_device *ndev, s32 bssidx, s32 pktflag,
+			struct net_device *ndev, s32 pktflag,
 			u8 *vndr_ie_buf, u32 vndr_ie_len)
 {
 	s32 err = 0;
@@ -3785,6 +3785,7 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 	struct parsed_vndr_ies new_vndr_ies;
 	struct parsed_vndr_ie_info *vndrie_info;
 	s32 i;
+	s32 bssidx = brcmf_ndev_bssidx(ndev);
 	u8 *ptr;
 	int remained_buf_len;
 
@@ -3811,7 +3812,6 @@ brcmf_set_management_ie(struct brcmf_cfg80211_info *cfg,
 			WL_ERR("not suitable type\n");
 			goto exit;
 		}
-		bssidx = 0;
 	} else {
 		err = -EPERM;
 		WL_ERR("not suitable type\n");
@@ -4023,7 +4023,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		cfg->ap_info->security_mode = false;
 	}
 	/* Set Beacon IEs to FW */
-	err = brcmf_set_management_ie(cfg, ndev, bssidx,
+	err = brcmf_set_management_ie(cfg, ndev,
 				      VNDR_IE_BEACON_FLAG,
 				      (u8 *)settings->beacon.tail,
 				      settings->beacon.tail_len);
@@ -4033,7 +4033,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 		WL_TRACE("Applied Vndr IEs for Beacon\n");
 
 	/* Set Probe Response IEs to FW */
-	err = brcmf_set_management_ie(cfg, ndev, bssidx,
+	err = brcmf_set_management_ie(cfg, ndev,
 				      VNDR_IE_PRBRSP_FLAG,
 				      (u8 *)settings->beacon.proberesp_ies,
 				      settings->beacon.proberesp_ies_len);
-- 
1.7.6


