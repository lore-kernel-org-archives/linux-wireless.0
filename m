Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3762 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760200Ab3BHO4k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 09:56:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 01/27] brcmfmac: add peer-to-peer group discovery
 support
Date: Fri, 8 Feb 2013 15:53:36 +0100
Message-ID: <1360335242-12608-2-git-send-email-arend@broadcom.com> (sfid-20130208_163817_487128_68BBDC9E)
In-Reply-To: <1360335242-12608-1-git-send-email-arend@broadcom.com>
References: <1360335242-12608-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

First part for P2P support. It is a variation on the existing
scanning functionality and is used to discover peer-to-peer
group owners and/or peer-to-peer devices in listen state.

Tested with wpa_cli/wpa_supplicant v2.0-devel.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/Makefile   |    3 +-
 .../net/wireless/brcm80211/brcmfmac/dhd_linux.c    |    1 +
 drivers/net/wireless/brcm80211/brcmfmac/p2p.c      |  734 ++++++++++++++++++++
 drivers/net/wireless/brcm80211/brcmfmac/p2p.h      |  114 +++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  |  199 ++++--
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.h  |   78 ++-
 6 files changed, 1078 insertions(+), 51 deletions(-)
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/p2p.c
 create mode 100644 drivers/net/wireless/brcm80211/brcmfmac/p2p.h

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/Makefile b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
index 1a6661a..756e19f 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmfmac/Makefile
@@ -26,6 +26,7 @@ brcmfmac-objs += \
 		wl_cfg80211.o \
 		fwil.o \
 		fweh.o \
+		p2p.o \
 		dhd_cdc.o \
 		dhd_common.o \
 		dhd_linux.o
@@ -37,4 +38,4 @@ brcmfmac-$(CONFIG_BRCMFMAC_SDIO) += \
 brcmfmac-$(CONFIG_BRCMFMAC_USB) += \
 		usb.o
 brcmfmac-$(CONFIG_BRCMDBG) += \
-		dhd_dbg.o
\ No newline at end of file
+		dhd_dbg.o
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
index f90db57..b469bd1 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_linux.c
@@ -26,6 +26,7 @@
 #include "dhd_bus.h"
 #include "dhd_proto.h"
 #include "dhd_dbg.h"
+#include "p2p.h"
 #include "wl_cfg80211.h"
 #include "fwil.h"
 
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.c b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
new file mode 100644
index 0000000..22d9de8
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.c
@@ -0,0 +1,734 @@
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#include <linux/slab.h>
+#include <linux/netdevice.h>
+#include <net/cfg80211.h>
+
+#include <brcmu_wifi.h>
+#include <brcmu_utils.h>
+#include <defs.h>
+#include <dhd.h>
+#include <dhd_dbg.h>
+#include "fwil.h"
+#include "p2p.h"
+#include "wl_cfg80211.h"
+
+/* parameters used for p2p escan */
+#define P2PAPI_SCAN_NPROBES 1
+#define P2PAPI_SCAN_DWELL_TIME_MS 80
+#define P2PAPI_SCAN_SOCIAL_DWELL_TIME_MS 40
+#define P2PAPI_SCAN_HOME_TIME_MS 60
+#define P2PAPI_SCAN_NPROBS_TIME_MS 30
+#define P2PAPI_SCAN_AF_SEARCH_DWELL_TIME_MS 100
+#define WL_SCAN_CONNECT_DWELL_TIME_MS 200
+#define WL_SCAN_JOIN_PROBE_INTERVAL_MS 20
+
+#define BRCMF_P2P_WILDCARD_SSID		"DIRECT-"
+#define BRCMF_P2P_WILDCARD_SSID_LEN	(sizeof(BRCMF_P2P_WILDCARD_SSID) - 1)
+
+#define SOCIAL_CHAN_1		1
+#define SOCIAL_CHAN_2		6
+#define SOCIAL_CHAN_3		11
+#define SOCIAL_CHAN_CNT		3
+#define AF_PEER_SEARCH_CNT	2
+
+/**
+ * struct brcmf_p2p_disc_st_le - set discovery state in firmware.
+ *
+ * @state: requested discovery state (see enum brcmf_p2p_disc_state).
+ * @chspec: channel parameter for %WL_P2P_DISC_ST_LISTEN state.
+ * @dwell: dwell time in ms for %WL_P2P_DISC_ST_LISTEN state.
+ */
+struct brcmf_p2p_disc_st_le {
+	u8 state;
+	__le16 chspec;
+	__le16 dwell;
+};
+
+/**
+ * enum brcmf_p2p_disc_state - P2P discovery state values
+ *
+ * @WL_P2P_DISC_ST_SCAN: P2P discovery with wildcard SSID and P2P IE.
+ * @WL_P2P_DISC_ST_LISTEN: P2P discovery off-channel for specified time.
+ * @WL_P2P_DISC_ST_SEARCH: P2P discovery with P2P wildcard SSID and P2P IE.
+ */
+enum brcmf_p2p_disc_state {
+	WL_P2P_DISC_ST_SCAN,
+	WL_P2P_DISC_ST_LISTEN,
+	WL_P2P_DISC_ST_SEARCH
+};
+
+/**
+ * struct brcmf_p2p_scan_le - P2P specific scan request.
+ *
+ * @type: type of scan method requested (values: 'E' or 'S').
+ * @reserved: reserved (ignored).
+ * @eparams: parameters used for type 'E'.
+ * @sparams: parameters used for type 'S'.
+ */
+struct brcmf_p2p_scan_le {
+	u8 type;
+	u8 reserved[3];
+	union {
+		struct brcmf_escan_params_le eparams;
+		struct brcmf_scan_params_le sparams;
+	};
+};
+
+static struct brcmf_cfg80211_vif *p2p_discover_vif(struct brcmf_p2p_info *p2p)
+{
+	return p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+}
+
+/**
+ * brcmf_p2p_set_firmware() - prepare firmware for peer-to-peer operation.
+ *
+ * @p2p: P2P specific data.
+ */
+static int brcmf_p2p_set_firmware(struct brcmf_p2p_info *p2p)
+{
+	struct net_device *ndev = cfg_to_ndev(p2p->cfg);
+	u8 null_eth_addr[] = { 0, 0, 0, 0, 0, 0 };
+	s32 ret = 0;
+
+	brcmf_fil_iovar_int_set(netdev_priv(ndev), "apsta", 1);
+
+	/* In case of COB type, firmware has default mac address
+	 * After Initializing firmware, we have to set current mac address to
+	 * firmware for P2P device address
+	 */
+	ret = brcmf_fil_iovar_data_set(netdev_priv(ndev), "p2p_da_override",
+				       null_eth_addr, sizeof(null_eth_addr));
+	if (ret)
+		brcmf_err("failed to update device address ret %d\n", ret);
+
+	return ret;
+}
+
+/**
+ * brcmf_p2p_generate_bss_mac() - derive mac addresses for P2P.
+ *
+ * @p2p: P2P specific data.
+ *
+ * P2P needs mac addresses for P2P device and interface. These are
+ * derived from the primary net device, ie. the permanent ethernet
+ * address of the device.
+ */
+static void brcmf_p2p_generate_bss_mac(struct brcmf_p2p_info *p2p)
+{
+	struct net_device *ndev = cfg_to_ndev(p2p->cfg);
+
+	/* Generate the P2P Device Address.  This consists of the device's
+	 * primary MAC address with the locally administered bit set.
+	 */
+	memcpy(p2p->dev_addr, ndev->dev_addr, ETH_ALEN);
+	p2p->dev_addr[0] |= 0x02;
+
+	/* Generate the P2P Interface Address.  If the discovery and connection
+	 * BSSCFGs need to simultaneously co-exist, then this address must be
+	 * different from the P2P Device Address, but also locally administered.
+	 */
+	memcpy(p2p->int_addr, p2p->dev_addr, ETH_ALEN);
+	p2p->int_addr[4] ^= 0x80;
+}
+
+/**
+ * brcmf_p2p_scan_is_p2p_request() - is cfg80211 scan request a P2P scan.
+ *
+ * @request: the scan request as received from cfg80211.
+ *
+ * returns true if one of the ssids in the request matches the
+ * P2P wildcard ssid; otherwise returns false.
+ */
+static bool brcmf_p2p_scan_is_p2p_request(struct cfg80211_scan_request *request)
+{
+	struct cfg80211_ssid *ssids = request->ssids;
+	int i;
+
+	for (i = 0; i < request->n_ssids; i++) {
+		if (ssids[i].ssid_len != BRCMF_P2P_WILDCARD_SSID_LEN)
+			continue;
+
+		brcmf_dbg(INFO, "comparing ssid \"%s\"", ssids[i].ssid);
+		if (!memcmp(BRCMF_P2P_WILDCARD_SSID, ssids[i].ssid,
+			    BRCMF_P2P_WILDCARD_SSID_LEN))
+			return true;
+	}
+	return false;
+}
+
+/**
+ * brcmf_p2p_set_discover_state - set discover state in firmware.
+ *
+ * @ifp: low-level interface object.
+ * @state: discover state to set.
+ * @chanspec: channel parameters (for state @WL_P2P_DISC_ST_LISTEN only).
+ * @listen_ms: duration to listen (for state @WL_P2P_DISC_ST_LISTEN only).
+ */
+static s32 brcmf_p2p_set_discover_state(struct brcmf_if *ifp, u8 state,
+					u16 chanspec, u16 listen_ms)
+{
+	struct brcmf_p2p_disc_st_le discover_state;
+	s32 ret = 0;
+	brcmf_dbg(TRACE, "enter\n");
+
+	discover_state.state = state;
+	discover_state.chspec = cpu_to_le16(chanspec);
+	discover_state.dwell = cpu_to_le16(listen_ms);
+	ret = brcmf_fil_bsscfg_data_set(ifp, "p2p_state", &discover_state,
+					sizeof(discover_state));
+	return ret;
+}
+
+/**
+ * brcmf_p2p_discover_disable_search() - reset discover state.
+ *
+ * @p2p: P2P specific data.
+ *
+ * Reset the discover state to @WL_P2P_DISC_ST_SCAN. Returns 0 on success.
+ */
+static s32 brcmf_p2p_discover_disable_search(struct brcmf_p2p_info *p2p)
+{
+	struct brcmf_cfg80211_vif *vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	struct brcmf_p2p_disc_st_le discovery_mode;
+	int ret;
+
+	/*
+	 * vif presence indicates discovery is initialized.
+	 */
+	if (!vif)
+		return -ENODEV;
+
+	ret = brcmf_fil_bsscfg_data_get(vif->ifp, "p2p_state",
+					&discovery_mode,
+					sizeof(discovery_mode));
+	if (!ret && discovery_mode.state != WL_P2P_DISC_ST_SCAN)
+		ret = brcmf_p2p_set_discover_state(vif->ifp,
+						  WL_P2P_DISC_ST_SCAN, 0, 0);
+	return ret;
+}
+
+/**
+ * brcmf_p2p_init_discovery() - enable discovery in the firmware.
+ *
+ * @p2p: P2P specific data.
+ *
+ * Configures the firmware to allow P2P peer discovery. Creates the
+ * virtual interface and consequently the P2P device for it.
+ */
+static s32 brcmf_p2p_init_discovery(struct brcmf_p2p_info *p2p)
+{
+	struct net_device *ndev = cfg_to_ndev(p2p->cfg);
+	struct brcmf_cfg80211_vif *vif;
+	struct brcmf_if *ifp;
+	struct p2p_bss *bss_dev;
+	s32 index;
+	s32 ret;
+
+	brcmf_dbg(TRACE, "enter\n");
+
+	bss_dev = &p2p->bss_idx[P2PAPI_BSSCFG_DEVICE];
+	if (bss_dev->vif != NULL) {
+		brcmf_dbg(INFO, "do nothing, already initialized\n");
+		return 0;
+	}
+
+	/* Enable P2P Discovery in the firmware */
+	ret = brcmf_fil_iovar_int_set(netdev_priv(ndev), "p2p_disc", 1);
+	if (ret < 0) {
+		brcmf_err("set discover error\n");
+		return ret;
+	}
+
+	/* obtain bsscfg index for P2P discovery */
+	ret = brcmf_fil_iovar_int_get(netdev_priv(ndev), "p2p_dev", &index);
+	if (ret < 0) {
+		brcmf_err("retrieving discover bsscfg index failed\n");
+		return ret;
+	}
+
+	/*
+	 * need brcmf_if for setting the discovery state.
+	 */
+	ifp = kzalloc(sizeof(*vif->ifp), GFP_KERNEL);
+	if (!ifp) {
+		brcmf_err("could not create discovery if\n");
+		return -ENOMEM;
+	}
+
+	/* set required fields */
+	ifp->drvr = p2p->cfg->pub;
+	ifp->ifidx = 0;
+	ifp->bssidx = index;
+
+	/* Set the initial discovery state to SCAN */
+	ret = brcmf_p2p_set_discover_state(ifp, WL_P2P_DISC_ST_SCAN, 0, 0);
+
+	if (ret != 0) {
+		brcmf_err("unable to set WL_P2P_DISC_ST_SCAN\n");
+		(void)brcmf_fil_iovar_int_set(netdev_priv(ndev), "p2p_disc", 0);
+		kfree(ifp);
+		return ret;
+	}
+
+	/* create a vif for it */
+	vif = brcmf_alloc_vif(p2p->cfg, NULL, NL80211_IFTYPE_P2P_DEVICE, false);
+	if (IS_ERR(vif)) {
+		brcmf_err("could not create discovery vif\n");
+		kfree(ifp);
+		return PTR_ERR(vif);
+	}
+
+	vif->ifp = ifp;
+	ifp->vif = vif;
+	bss_dev->vif = vif;
+
+	return 0;
+}
+
+/**
+ * brcmf_p2p_deinit_discovery() - disable P2P device discovery.
+ *
+ * @p2p: P2P specific data.
+ *
+ * Resets the discovery state and disables it in firmware. The virtual
+ * interface and P2P device are freed.
+ */
+static s32 brcmf_p2p_deinit_discovery(struct brcmf_p2p_info *p2p)
+{
+	struct net_device *ndev = cfg_to_ndev(p2p->cfg);
+	struct brcmf_if *ifp;
+	struct p2p_bss *bss_dev;
+	brcmf_dbg(TRACE, "enter\n");
+
+	bss_dev = &p2p->bss_idx[P2PAPI_BSSCFG_DEVICE];
+	if (bss_dev->vif == NULL) {
+		brcmf_err("do nothing, not initialized\n");
+		return -EINVAL;
+	}
+
+	ifp = bss_dev->vif->ifp;
+
+	/* Set the discovery state to SCAN */
+	(void)brcmf_p2p_set_discover_state(ifp, WL_P2P_DISC_ST_SCAN, 0, 0);
+
+	/* Disable P2P discovery in the firmware */
+	(void)brcmf_fil_iovar_int_set(netdev_priv(ndev), "p2p_disc", 0);
+
+	/* remove discovery interface */
+	brcmf_free_vif(bss_dev->vif);
+	bss_dev->vif = NULL;
+	kfree(ifp);
+
+	return 0;
+}
+
+/**
+ * brcmf_p2p_enable_discovery() - initialize and configure discovery.
+ *
+ * @p2p: P2P specific data.
+ * @ie: buffer containing information elements.
+ * @ie_len: length of @ie buffer.
+ *
+ * Initializes the discovery device and configure the virtual interface.
+ */
+static int brcmf_p2p_enable_discovery(struct brcmf_p2p_info *p2p,
+				      const u8 *ie, u32 ie_len)
+{
+	struct brcmf_cfg80211_vif *vif;
+	s32 ret = 0;
+
+	brcmf_dbg(TRACE, "enter\n");
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+	if (vif) {
+		brcmf_dbg(INFO,
+			  "DISCOVERY init already done, just process IE\n");
+		goto set_ie;
+	}
+
+	ret = brcmf_p2p_init_discovery(p2p);
+	if (ret < 0) {
+		brcmf_err("init discovery error %d\n", ret);
+		goto exit;
+	}
+
+	vif = p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif;
+
+	/*
+	 * Set wsec to any non-zero value in the discovery bsscfg
+	 * to ensure our P2P probe responses have the privacy bit
+	 * set in the 802.11 WPA IE. Some peer devices may not
+	 * initiate WPS with us if this bit is not set.
+	 */
+	ret = brcmf_fil_bsscfg_int_set(vif->ifp, "wsec", AES_ENABLED);
+	if (ret < 0)
+		brcmf_err("wsec error %d\n", ret);
+
+set_ie:
+	if (ie_len) {
+		ret = brcmf_vif_set_mgmt_ie(vif, BRCMF_VNDR_IE_PRBREQ_FLAG,
+					    ie, ie_len);
+
+		if (ret < 0) {
+			brcmf_err("set probreq ie occurs error %d\n", ret);
+			goto exit;
+		}
+	}
+exit:
+	return ret;
+}
+
+/*
+ * brcmf_p2p_escan() - initiate a P2P scan.
+ *
+ * @p2p: P2P specific data.
+ * @num_chans: number of channels to scan.
+ * @chanspecs: channel parameters for @num_chans channels.
+ * @search_state: P2P discover state to use.
+ * @action: scan action to pass to firmware.
+ * @bss_type: type of P2P bss.
+ */
+static s32 brcmf_p2p_escan(struct brcmf_p2p_info *p2p, u32 num_chans,
+			   u16 chanspecs[], s32 search_state, u16 action,
+			   enum p2p_bss_type bss_type)
+{
+	s32 ret = 0;
+	s32 memsize = offsetof(struct brcmf_p2p_scan_le,
+			       eparams.params_le.channel_list);
+	s32 nprobes;
+	s32 active;
+	u32 i;
+	u8 *memblk;
+	struct brcmf_cfg80211_vif *vif;
+	struct brcmf_p2p_scan_le *p2p_params;
+	struct brcmf_scan_params_le *sparams;
+	struct brcmf_ssid ssid;
+
+	/* add padding if uneven */
+	if (num_chans % 2)
+		memsize += sizeof(__le16);
+	memsize += num_chans * sizeof(__le16);
+	memblk = kzalloc(memsize, GFP_KERNEL);
+	if (!memblk)
+		return -ENOMEM;
+
+	vif = p2p->bss_idx[bss_type].vif;
+	if (vif == NULL) {
+		brcmf_err("no vif for bss type %d\n", bss_type);
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	switch (search_state) {
+	case WL_P2P_DISC_ST_SEARCH:
+		/*
+		 * If we in SEARCH STATE, we don't need to set SSID explictly
+		 * because dongle use P2P WILDCARD internally by default
+		 */
+		/* use null ssid */
+		ssid.SSID_len = 0;
+		memset(ssid.SSID, 0, sizeof(ssid.SSID));
+		break;
+	case WL_P2P_DISC_ST_SCAN:
+		/*
+		 * wpa_supplicant has p2p_find command with type social or
+		 * progressive. For progressive, we need to set the ssid to
+		 * P2P WILDCARD because we just do broadcast scan unless
+		 * setting SSID.
+		 */
+		ssid.SSID_len = BRCMF_P2P_WILDCARD_SSID_LEN;
+		memcpy(ssid.SSID, BRCMF_P2P_WILDCARD_SSID, ssid.SSID_len);
+		break;
+	default:
+		brcmf_err(" invalid search state %d\n", search_state);
+		ret = -EINVAL;
+		goto exit;
+	}
+
+	brcmf_p2p_set_discover_state(vif->ifp, search_state, 0, 0);
+
+	/*
+	 * set p2p scan parameters.
+	 */
+	p2p_params = (struct brcmf_p2p_scan_le *)memblk;
+	p2p_params->type = 'E';
+
+	/* determine the scan engine parameters */
+	sparams = &p2p_params->eparams.params_le;
+	sparams->bss_type = DOT11_BSSTYPE_ANY;
+	if (p2p->cfg->active_scan)
+		sparams->scan_type = 0;
+	else
+		sparams->scan_type = 1;
+
+	memset(&sparams->bssid, 0xFF, ETH_ALEN);
+	if (ssid.SSID_len)
+		memcpy(sparams->ssid_le.SSID, ssid.SSID, ssid.SSID_len);
+	sparams->ssid_le.SSID_len = cpu_to_le32(ssid.SSID_len);
+	sparams->home_time = cpu_to_le32(P2PAPI_SCAN_HOME_TIME_MS);
+
+	/*
+	 * SOCIAL_CHAN_CNT + 1 takes care of the Progressive scan
+	 * supported by the supplicant.
+	 */
+	if (num_chans == SOCIAL_CHAN_CNT || num_chans == (SOCIAL_CHAN_CNT + 1))
+		active = P2PAPI_SCAN_SOCIAL_DWELL_TIME_MS;
+	else if (num_chans == AF_PEER_SEARCH_CNT)
+		active = P2PAPI_SCAN_AF_SEARCH_DWELL_TIME_MS;
+	else if (wl_get_vif_state_all(p2p->cfg, BRCMF_VIF_STATUS_CONNECTED))
+		active = -1;
+	else
+		active = P2PAPI_SCAN_DWELL_TIME_MS;
+
+	/* Override scan params to find a peer for a connection */
+	if (num_chans == 1) {
+		active = WL_SCAN_CONNECT_DWELL_TIME_MS;
+		/* XXX WAR to sync with presence period of VSDB GO.
+		 * send probe request more frequently
+		 */
+		nprobes = active / WL_SCAN_JOIN_PROBE_INTERVAL_MS;
+	} else {
+		nprobes = active / P2PAPI_SCAN_NPROBS_TIME_MS;
+	}
+
+	if (nprobes <= 0)
+		nprobes = 1;
+
+	brcmf_dbg(INFO, "nprobes # %d, active_time %d\n", nprobes, active);
+	sparams->active_time = cpu_to_le32(active);
+	sparams->nprobes = cpu_to_le32(nprobes);
+	sparams->passive_time = cpu_to_le32(-1);
+	sparams->channel_num = cpu_to_le32(num_chans &
+					   BRCMF_SCAN_PARAMS_COUNT_MASK);
+	for (i = 0; i < num_chans; i++)
+		sparams->channel_list[i] = cpu_to_le16(chanspecs[i]);
+
+	/* set the escan specific parameters */
+	p2p_params->eparams.version = cpu_to_le32(BRCMF_ESCAN_REQ_VERSION);
+	p2p_params->eparams.action =  cpu_to_le16(action);
+	p2p_params->eparams.sync_id = cpu_to_le16(0x1234);
+	/* perform p2p scan on primary device */
+	ret = brcmf_fil_bsscfg_data_set(vif->ifp, "p2p_scan", memblk, memsize);
+	if (!ret)
+		set_bit(BRCMF_SCAN_STATUS_BUSY, &p2p->cfg->scan_status);
+exit:
+	kfree(memblk);
+	return ret;
+}
+
+/**
+ * brcmf_p2p_run_escan() - escan callback for peer-to-peer.
+ *
+ * @cfg: driver private data for cfg80211 interface.
+ * @ndev: net device for which scan is requested.
+ * @request: scan request from cfg80211.
+ * @action: scan action.
+ *
+ * Determines the P2P discovery state based to scan request parameters and
+ * validates the channels in the request.
+ */
+static s32 brcmf_p2p_run_escan(struct brcmf_cfg80211_info *cfg,
+			       struct net_device *ndev,
+			       struct cfg80211_scan_request *request,
+			       u16 action)
+{
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	s32 err = 0;
+	s32 search_state = WL_P2P_DISC_ST_SCAN;
+	struct brcmf_cfg80211_vif *vif;
+	struct net_device *dev = NULL;
+	int i, num_nodfs = 0;
+	u16 *chanspecs;
+
+	brcmf_dbg(TRACE, "enter\n");
+
+	if (!request) {
+		err = -EINVAL;
+		goto exit;
+	}
+
+	if (request->n_channels) {
+		chanspecs = kcalloc(request->n_channels, sizeof(*chanspecs),
+				    GFP_KERNEL);
+		if (!chanspecs) {
+			err = -ENOMEM;
+			goto exit;
+		}
+		vif = p2p->bss_idx[P2PAPI_BSSCFG_CONNECTION].vif;
+		if (vif)
+			dev = vif->wdev.netdev;
+		if (request->n_channels == 3 &&
+		    request->channels[0]->hw_value == SOCIAL_CHAN_1 &&
+		    request->channels[1]->hw_value == SOCIAL_CHAN_2 &&
+		    request->channels[2]->hw_value == SOCIAL_CHAN_3) {
+			/* SOCIAL CHANNELS 1, 6, 11 */
+			search_state = WL_P2P_DISC_ST_SEARCH;
+			brcmf_dbg(INFO, "P2P SEARCH PHASE START\n");
+		} else if (dev != NULL && vif->mode == WL_MODE_AP) {
+			/* If you are already a GO, then do SEARCH only */
+			brcmf_dbg(INFO, "Already a GO. Do SEARCH Only\n");
+			search_state = WL_P2P_DISC_ST_SEARCH;
+		} else {
+			brcmf_dbg(INFO, "P2P SCAN STATE START\n");
+		}
+
+		/*
+		 * no P2P scanning on passive or DFS channels.
+		 */
+		for (i = 0; i < request->n_channels; i++) {
+			struct ieee80211_channel *chan = request->channels[i];
+
+			if (chan->flags & (IEEE80211_CHAN_RADAR |
+					   IEEE80211_CHAN_PASSIVE_SCAN))
+				continue;
+
+			chanspecs[i] = channel_to_chanspec(chan);
+			brcmf_dbg(INFO, "%d: chan=%d, channel spec=%x\n",
+				  num_nodfs, chan->hw_value, chanspecs[i]);
+			num_nodfs++;
+		}
+		err = brcmf_p2p_escan(p2p, num_nodfs, chanspecs, search_state,
+				      action, P2PAPI_BSSCFG_DEVICE);
+	}
+exit:
+	if (err)
+		brcmf_err("error (%d)\n", err);
+	return err;
+}
+
+/**
+ * brcmf_p2p_scan_prep() - prepare scan based on request.
+ *
+ * @wiphy: wiphy device.
+ * @request: scan request from cfg80211.
+ *
+ * Prepare the scan appropriately for type of scan requested. Overrides the
+ * escan .run() callback for peer-to-peer scanning.
+ */
+int brcmf_p2p_scan_prep(struct wiphy *wiphy,
+			struct cfg80211_scan_request *request)
+{
+	struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
+	struct brcmf_p2p_info *p2p = &cfg->p2p;
+	int err = 0;
+
+	if (brcmf_p2p_scan_is_p2p_request(request)) {
+		/* find my listen channel */
+		err = cfg80211_get_p2p_attr(request->ie, request->ie_len,
+				      IEEE80211_P2P_ATTR_LISTEN_CHANNEL,
+				      &p2p->listen_channel, 1);
+		if (err < 0)
+			return err;
+
+		clear_bit(BRCMF_P2P_STATUS_GO_NEG_PHASE, &p2p->status);
+		brcmf_dbg(INFO, "P2P: GO_NEG_PHASE status cleared\n");
+
+		err = brcmf_p2p_enable_discovery(p2p, request->ie,
+						 request->ie_len);
+
+		/*
+		 * override .run_escan() callback.
+		 */
+		cfg->escan_info.run = brcmf_p2p_run_escan;
+	} else {
+		/*
+		 * legacy scan trigger
+		 * So, we have to disable p2p discovery if p2p discovery is on
+		 */
+		(void)brcmf_p2p_discover_disable_search(p2p);
+
+		/*
+		 * clear p2p vendor ies for probe request set by
+		 * previous p2p related scan(s).
+		 */
+		if (p2p_discover_vif(p2p))
+			err = brcmf_vif_set_mgmt_ie(p2p_discover_vif(p2p),
+						    BRCMF_VNDR_IE_PRBREQ_FLAG,
+						    request->ie,
+						    request->ie_len);
+	}
+	return err;
+}
+
+/**
+ * brcmf_p2p_attach() - attach for P2P.
+ *
+ * @cfg: driver private data for cfg80211 interface.
+ */
+void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg)
+{
+	struct brcmf_p2p_info *p2p;
+
+	p2p = &cfg->p2p;
+
+	p2p->cfg = cfg;
+	brcmf_p2p_set_firmware(p2p);
+	brcmf_p2p_generate_bss_mac(p2p);
+}
+
+/**
+ * brcmf_p2p_detach() - detach P2P.
+ *
+ * @p2p: P2P specific data.
+ */
+void brcmf_p2p_detach(struct brcmf_p2p_info *p2p)
+{
+	brcmf_p2p_deinit_discovery(p2p);
+	/* just set it all to zero */
+	memset(p2p, 0, sizeof(*p2p));
+}
+
+/**
+ * brcmf_p2p_add_vif() - create a new P2P virtual interface.
+ *
+ * @wiphy: wiphy device of new interface.
+ * @name: name of the new interface.
+ * @type: nl80211 interface type.
+ * @flags: TBD
+ * @params: TBD
+ *
+ * TODO: not yet supported.
+ */
+struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
+				       enum nl80211_iftype type, u32 *flags,
+				       struct vif_params *params)
+{
+	brcmf_err("enter - not supported yet\n");
+	brcmf_dbg(INFO, "adding vif \"%s\" (type=%d)\n", name, type);
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+/**
+ * brcmf_p2p_del_vif() - delete a P2P virtual interface.
+ *
+ * @wiphy: wiphy device of interface.
+ * @wdev: wireless device of interface.
+ *
+ * TODO: not yet supported.
+ */
+int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev)
+{
+	struct brcmf_cfg80211_vif *vif;
+
+	vif = container_of(wdev, struct brcmf_cfg80211_vif, wdev);
+	if (wdev->netdev)
+		brcmf_dbg(INFO, "deleting vif \"%s\"\n", wdev->netdev->name);
+	else
+		brcmf_dbg(INFO, "deleting vif \"wdev-%u\"\n",
+			  wdev->identifier);
+	brcmf_err("enter - not supported yet\n");
+	return -EOPNOTSUPP;
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/p2p.h b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
new file mode 100644
index 0000000..f304adf
--- /dev/null
+++ b/drivers/net/wireless/brcm80211/brcmfmac/p2p.h
@@ -0,0 +1,114 @@
+/*
+ * Copyright (c) 2012 Broadcom Corporation
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
+ * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
+ * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
+ * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+#ifndef WL_CFGP2P_H_
+#define WL_CFGP2P_H_
+
+#include <net/cfg80211.h>
+
+struct brcmf_cfg80211_info;
+
+/* vendor ies max buffer length for probe response or beacon */
+#define VNDR_IES_MAX_BUF_LEN 1400
+/* normal vendor ies buffer length */
+#define VNDR_IES_BUF_LEN 512
+
+/* Structure to hold all saved P2P and WPS IEs for a BSSCFG */
+/**
+ * enum p2p_bss_type - different type of BSS configurations.
+ *
+ * @P2PAPI_BSSCFG_PRIMARY: maps to driver's primary bsscfg.
+ * @P2PAPI_BSSCFG_DEVICE: maps to driver's P2P device discovery bsscfg.
+ * @P2PAPI_BSSCFG_CONNECTION: maps to driver's P2P connection bsscfg.
+ * @P2PAPI_BSSCFG_MAX: used for range checking.
+ */
+enum p2p_bss_type {
+	P2PAPI_BSSCFG_PRIMARY, /* maps to driver's primary bsscfg */
+	P2PAPI_BSSCFG_DEVICE, /* maps to driver's P2P device discovery bsscfg */
+	P2PAPI_BSSCFG_CONNECTION, /* maps to driver's P2P connection bsscfg */
+	P2PAPI_BSSCFG_MAX
+};
+
+/**
+ * struct p2p_bss - peer-to-peer bss related information.
+ *
+ * @vif: virtual interface of this P2P bss.
+ * @private_data: TBD
+ */
+struct p2p_bss {
+	struct brcmf_cfg80211_vif *vif;
+	void *private_data;
+};
+
+/**
+ * enum brcmf_p2p_status - P2P specific dongle status.
+ *
+ * @BRCMF_P2P_STATUS_IF_ADD: peer-to-peer vif add sent to dongle.
+ * @BRCMF_P2P_STATUS_IF_DEL: NOT-USED?
+ * @BRCMF_P2P_STATUS_IF_DELETING: peer-to-peer vif delete sent to dongle.
+ * @BRCMF_P2P_STATUS_IF_CHANGING: peer-to-peer vif change sent to dongle.
+ * @BRCMF_P2P_STATUS_IF_CHANGED: peer-to-peer vif change completed on dongle.
+ * @BRCMF_P2P_STATUS_LISTEN_EXPIRED: listen duration expired.
+ * @BRCMF_P2P_STATUS_ACTION_TX_COMPLETED: action frame tx completed.
+ * @BRCMF_P2P_STATUS_ACTION_TX_NOACK: action frame tx not acked.
+ * @BRCMF_P2P_STATUS_GO_NEG_PHASE: P2P GO negotiation ongoing.
+ */
+enum brcmf_p2p_status {
+	BRCMF_P2P_STATUS_IF_ADD = 0,
+	BRCMF_P2P_STATUS_IF_DEL,
+	BRCMF_P2P_STATUS_IF_DELETING,
+	BRCMF_P2P_STATUS_IF_CHANGING,
+	BRCMF_P2P_STATUS_IF_CHANGED,
+	BRCMF_P2P_STATUS_LISTEN_EXPIRED,
+	BRCMF_P2P_STATUS_ACTION_TX_COMPLETED,
+	BRCMF_P2P_STATUS_ACTION_TX_NOACK,
+	BRCMF_P2P_STATUS_GO_NEG_PHASE
+};
+
+/**
+ * struct brcmf_p2p_info - p2p specific driver information.
+ *
+ * @cfg: driver private data for cfg80211 interface.
+ * @status: status of P2P (see enum brcmf_p2p_status).
+ * @dev_addr: P2P device address.
+ * @int_addr: P2P interface address.
+ * @bss_idx: informate for P2P bss types.
+ * @listen_timer: timer for @WL_P2P_DISC_ST_LISTEN discover state.
+ * @ssid: ssid for P2P GO.
+ * @listen_channel: channel for @WL_P2P_DISC_ST_LISTEN discover state.
+ */
+struct brcmf_p2p_info {
+	struct brcmf_cfg80211_info *cfg;
+	unsigned long status;
+	u8 dev_addr[ETH_ALEN];
+	u8 int_addr[ETH_ALEN];
+	struct p2p_bss bss_idx[P2PAPI_BSSCFG_MAX];
+	struct timer_list listen_timer;
+	struct brcmf_ssid ssid;
+	u8 listen_channel;
+};
+
+void brcmf_p2p_attach(struct brcmf_cfg80211_info *cfg);
+void brcmf_p2p_detach(struct brcmf_p2p_info *p2p);
+struct wireless_dev *brcmf_p2p_add_vif(struct wiphy *wiphy, const char *name,
+				       enum nl80211_iftype type, u32 *flags,
+				       struct vif_params *params);
+int brcmf_p2p_del_vif(struct wiphy *wiphy, struct wireless_dev *wdev);
+int brcmf_p2p_start_device(struct wiphy *wiphy, struct wireless_dev *wdev);
+void brcmf_p2p_stop_device(struct wiphy *wiphy, struct wireless_dev *wdev);
+int brcmf_p2p_scan_prep(struct wiphy *wiphy,
+			struct cfg80211_scan_request *request);
+
+#endif /* WL_CFGP2P_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index d78f946..5c4d1fc 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -26,6 +26,7 @@
 #include <brcmu_wifi.h>
 #include "dhd.h"
 #include "dhd_dbg.h"
+#include "p2p.h"
 #include "wl_cfg80211.h"
 #include "fwil.h"
 
@@ -41,12 +42,8 @@
 #define BRCMF_PNO_SCAN_COMPLETE		1
 #define BRCMF_PNO_SCAN_INCOMPLETE	0
 
-#define BRCMF_IFACE_MAX_CNT		2
+#define BRCMF_IFACE_MAX_CNT		3
 
-#define TLV_LEN_OFF			1	/* length offset */
-#define TLV_HDR_LEN			2	/* header length */
-#define TLV_BODY_OFF			2	/* body offset */
-#define TLV_OUI_LEN			3	/* oui id length */
 #define WPA_OUI				"\x00\x50\xF2"	/* WPA OUI */
 #define WPA_OUI_TYPE			1
 #define RSN_OUI				"\x00\x0F\xAC"	/* RSN OUI */
@@ -76,9 +73,7 @@
 #define VNDR_IE_PKTFLAG_OFFSET		8
 #define VNDR_IE_VSIE_OFFSET		12
 #define VNDR_IE_HDR_SIZE		12
-#define VNDR_IE_BEACON_FLAG		0x1
-#define VNDR_IE_PRBRSP_FLAG		0x2
-#define MAX_VNDR_IE_NUMBER		5
+#define VNDR_IE_PARSE_LIMIT		5
 
 #define	DOT11_MGMT_HDR_LEN		24	/* d11 management header len */
 #define	DOT11_BCN_PRB_FIXED_LEN		12	/* beacon/probe fixed length */
@@ -271,13 +266,6 @@ static const u32 __wl_cipher_suites[] = {
 	WLAN_CIPHER_SUITE_AES_CMAC,
 };
 
-/* tag_ID/length/value_buffer tuple */
-struct brcmf_tlv {
-	u8 id;
-	u8 len;
-	u8 data[1];
-};
-
 /* Vendor specific ie. id = 221, oui and type defines exact ie */
 struct brcmf_vs_tlv {
 	u8 id;
@@ -294,7 +282,7 @@ struct parsed_vndr_ie_info {
 
 struct parsed_vndr_ies {
 	u32 count;
-	struct parsed_vndr_ie_info ie_info[MAX_VNDR_IE_NUMBER];
+	struct parsed_vndr_ie_info ie_info[VNDR_IE_PARSE_LIMIT];
 };
 
 /* Quarter dBm units to mW
@@ -381,7 +369,7 @@ static u8 brcmf_mw_to_qdbm(u16 mw)
 	return qdbm;
 }
 
-static u16 channel_to_chanspec(struct ieee80211_channel *ch)
+u16 channel_to_chanspec(struct ieee80211_channel *ch)
 {
 	u16 chanspec;
 
@@ -431,6 +419,55 @@ send_key_to_dongle(struct net_device *ndev, struct brcmf_wsec_key *key)
 	return err;
 }
 
+static struct wireless_dev *brcmf_cfg80211_add_iface(struct wiphy *wiphy,
+						     const char *name,
+						     enum nl80211_iftype type,
+						     u32 *flags,
+						     struct vif_params *params)
+{
+	brcmf_dbg(TRACE, "enter: %s type %d\n", name, type);
+	switch (type) {
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_MESH_POINT:
+		return ERR_PTR(-EOPNOTSUPP);
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		return brcmf_p2p_add_vif(wiphy, name, type, flags, params);
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NL80211_IFTYPE_P2P_DEVICE:
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+}
+
+static
+int brcmf_cfg80211_del_iface(struct wiphy *wiphy, struct wireless_dev *wdev)
+{
+	switch (wdev->iftype) {
+	case NL80211_IFTYPE_ADHOC:
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_MESH_POINT:
+		return -EOPNOTSUPP;
+	case NL80211_IFTYPE_P2P_CLIENT:
+	case NL80211_IFTYPE_P2P_GO:
+		return brcmf_p2p_del_vif(wiphy, wdev);
+	case NL80211_IFTYPE_UNSPECIFIED:
+	case NL80211_IFTYPE_P2P_DEVICE:
+	default:
+		return -EINVAL;
+	}
+	return -EOPNOTSUPP;
+}
+
 static s32
 brcmf_cfg80211_change_iface(struct wiphy *wiphy, struct net_device *ndev,
 			 enum nl80211_iftype type, u32 *flags,
@@ -696,11 +733,12 @@ brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
 	s32 err;
 	u32 passive_scan;
 	struct brcmf_scan_results *results;
+	struct escan_info *escan = &cfg->escan_info;
 
 	brcmf_dbg(SCAN, "Enter\n");
-	cfg->escan_info.ndev = ndev;
-	cfg->escan_info.wiphy = wiphy;
-	cfg->escan_info.escan_state = WL_ESCAN_STATE_SCANNING;
+	escan->ndev = ndev;
+	escan->wiphy = wiphy;
+	escan->escan_state = WL_ESCAN_STATE_SCANNING;
 	passive_scan = cfg->active_scan ? 0 : 1;
 	err = brcmf_fil_cmd_int_set(netdev_priv(ndev), BRCMF_C_SET_PASSIVE_SCAN,
 				    passive_scan);
@@ -714,7 +752,7 @@ brcmf_do_escan(struct brcmf_cfg80211_info *cfg, struct wiphy *wiphy,
 	results->count = 0;
 	results->buflen = WL_ESCAN_RESULTS_FIXED_SIZE;
 
-	err = brcmf_run_escan(cfg, ndev, request, WL_ESCAN_ACTION_START);
+	err = escan->run(cfg, ndev, request, WL_ESCAN_ACTION_START);
 	if (err)
 		brcmf_set_mpc(ndev, 1);
 	return err;
@@ -769,6 +807,11 @@ brcmf_cfg80211_escan(struct wiphy *wiphy, struct net_device *ndev,
 	cfg->scan_request = request;
 	set_bit(BRCMF_SCAN_STATUS_BUSY, &cfg->scan_status);
 	if (escan_req) {
+		cfg->escan_info.run = brcmf_run_escan;
+		err = brcmf_p2p_scan_prep(wiphy, request);
+		if (err)
+			goto scan_out;
+
 		err = brcmf_do_escan(cfg, wiphy, ndev, request);
 		if (err)
 			goto scan_out;
@@ -2186,7 +2229,7 @@ static bool brcmf_is_ibssmode(struct brcmf_cfg80211_vif *vif)
  * triples, returning a pointer to the substring whose first element
  * matches tag
  */
-static struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key)
+struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key)
 {
 	struct brcmf_tlv *elt;
 	int totlen;
@@ -3227,7 +3270,7 @@ brcmf_parse_vndr_ies(const u8 *vndr_ie_buf, u32 vndr_ie_len,
 			  parsed_info->vndrie.oui[2],
 			  parsed_info->vndrie.oui_type);
 
-		if (vndr_ies->count >= MAX_VNDR_IE_NUMBER)
+		if (vndr_ies->count >= VNDR_IE_PARSE_LIMIT)
 			break;
 next:
 		remaining_len -= (ie->len + TLV_HDR_LEN);
@@ -3261,7 +3304,6 @@ brcmf_vndr_ie(u8 *iebuf, s32 pktflag, u8 *ie_ptr, u32 ie_len, s8 *add_del_cmd)
 	return ie_len + VNDR_IE_HDR_SIZE;
 }
 
-static
 s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			  const u8 *vndr_ie_buf, u32 vndr_ie_len)
 {
@@ -3295,12 +3337,12 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 	curr_ie_buf = iovar_ie_buf;
 	if (ifp->vif->mode == WL_MODE_AP) {
 		switch (pktflag) {
-		case VNDR_IE_PRBRSP_FLAG:
+		case BRCMF_VNDR_IE_PRBRSP_FLAG:
 			mgmt_ie_buf = saved_ie->probe_res_ie;
 			mgmt_ie_len = &saved_ie->probe_res_ie_len;
 			mgmt_ie_buf_len = sizeof(saved_ie->probe_res_ie);
 			break;
-		case VNDR_IE_BEACON_FLAG:
+		case BRCMF_VNDR_IE_BEACON_FLAG:
 			mgmt_ie_buf = saved_ie->beacon_ie;
 			mgmt_ie_len = &saved_ie->beacon_ie_len;
 			mgmt_ie_buf_len = sizeof(saved_ie->beacon_ie);
@@ -3311,9 +3353,17 @@ s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
 			goto exit;
 		}
 	} else {
-		err = -EPERM;
-		brcmf_err("not suitable type\n");
-		goto exit;
+		switch (pktflag) {
+		case BRCMF_VNDR_IE_PRBREQ_FLAG:
+			mgmt_ie_buf = saved_ie->probe_req_ie;
+			mgmt_ie_len = &saved_ie->probe_req_ie_len;
+			mgmt_ie_buf_len = sizeof(saved_ie->probe_req_ie);
+			break;
+		default:
+			err = -EPERM;
+			brcmf_err("not suitable type\n");
+			goto exit;
+		}
 	}
 
 	if (vndr_ie_len > mgmt_ie_buf_len) {
@@ -3508,7 +3558,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 	}
 	/* Set Beacon IEs to FW */
 	err = brcmf_vif_set_mgmt_ie(ndev_to_vif(ndev),
-				    VNDR_IE_BEACON_FLAG,
+				    BRCMF_VNDR_IE_BEACON_FLAG,
 				    settings->beacon.tail,
 				    settings->beacon.tail_len);
 	if (err)
@@ -3518,7 +3568,7 @@ brcmf_cfg80211_start_ap(struct wiphy *wiphy, struct net_device *ndev,
 
 	/* Set Probe Response IEs to FW */
 	err = brcmf_vif_set_mgmt_ie(ndev_to_vif(ndev),
-				    VNDR_IE_PRBRSP_FLAG,
+				    BRCMF_VNDR_IE_PRBRSP_FLAG,
 				    settings->beacon.proberesp_ies,
 				    settings->beacon.proberesp_ies_len);
 	if (err)
@@ -3625,6 +3675,8 @@ brcmf_cfg80211_del_station(struct wiphy *wiphy, struct net_device *ndev,
 }
 
 static struct cfg80211_ops wl_cfg80211_ops = {
+	.add_virtual_intf = brcmf_cfg80211_add_iface,
+	.del_virtual_intf = brcmf_cfg80211_del_iface,
 	.change_virtual_intf = brcmf_cfg80211_change_iface,
 	.scan = brcmf_cfg80211_scan,
 	.set_wiphy_params = brcmf_cfg80211_set_wiphy_params,
@@ -3656,20 +3708,30 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 #endif
 };
 
-static s32 brcmf_mode_to_nl80211_iftype(s32 mode)
+static s32 brcmf_nl80211_iftype_to_mode(enum nl80211_iftype type)
 {
-	s32 err = 0;
-
-	switch (mode) {
-	case WL_MODE_BSS:
-		return NL80211_IFTYPE_STATION;
-	case WL_MODE_IBSS:
-		return NL80211_IFTYPE_ADHOC;
+	switch (type) {
+	case NL80211_IFTYPE_AP_VLAN:
+	case NL80211_IFTYPE_WDS:
+	case NL80211_IFTYPE_MONITOR:
+	case NL80211_IFTYPE_MESH_POINT:
+		return -ENOTSUPP;
+	case NL80211_IFTYPE_ADHOC:
+		return WL_MODE_IBSS;
+	case NL80211_IFTYPE_STATION:
+	case NL80211_IFTYPE_P2P_CLIENT:
+		return WL_MODE_BSS;
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		return WL_MODE_AP;
+	case NL80211_IFTYPE_P2P_DEVICE:
+		return WL_MODE_P2P;
+	case NL80211_IFTYPE_UNSPECIFIED:
 	default:
-		return NL80211_IFTYPE_UNSPECIFIED;
+		break;
 	}
 
-	return err;
+	return -EINVAL;
 }
 
 static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
@@ -3681,6 +3743,28 @@ static void brcmf_wiphy_pno_params(struct wiphy *wiphy)
 	wiphy->flags |= WIPHY_FLAG_SUPPORTS_SCHED_SCAN;
 }
 
+static const struct ieee80211_iface_limit brcmf_iface_limits[] = {
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_STATION) |
+			 BIT(NL80211_IFTYPE_ADHOC) |
+			 BIT(NL80211_IFTYPE_AP)
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_CLIENT) |
+			 BIT(NL80211_IFTYPE_P2P_GO)
+	},
+};
+static const struct ieee80211_iface_combination brcmf_iface_combos[] = {
+	{
+		 .max_interfaces = BRCMF_IFACE_MAX_CNT - 1,
+		 .num_different_channels = 1, /* no multi-channel for now */
+		 .n_limits = ARRAY_SIZE(brcmf_iface_limits),
+		 .limits = brcmf_iface_limits
+	}
+};
+
 static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 {
 	struct wiphy *wiphy;
@@ -3693,10 +3777,15 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 	}
 	set_wiphy_dev(wiphy, phydev);
 	wiphy->max_scan_ssids = WL_NUM_SCAN_MAX;
+	wiphy->max_scan_ie_len = BRCMF_SCAN_IE_LEN_MAX;
 	wiphy->max_num_pmkids = WL_NUM_PMKIDS_MAX;
 	wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
 				 BIT(NL80211_IFTYPE_ADHOC) |
-				 BIT(NL80211_IFTYPE_AP);
+				 BIT(NL80211_IFTYPE_AP) |
+				 BIT(NL80211_IFTYPE_P2P_CLIENT) |
+				 BIT(NL80211_IFTYPE_P2P_GO);
+	wiphy->iface_combinations = brcmf_iface_combos;
+	wiphy->n_iface_combinations = ARRAY_SIZE(brcmf_iface_combos);
 	wiphy->bands[IEEE80211_BAND_2GHZ] = &__wl_band_2ghz;
 	wiphy->bands[IEEE80211_BAND_5GHZ] = &__wl_band_5ghz_a;	/* Set
 						* it as 11a by default.
@@ -3722,23 +3811,25 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 	return wiphy;
 }
 
-static
 struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 					   struct net_device *netdev,
-					   s32 mode, bool pm_block)
+					   enum nl80211_iftype type,
+					   bool pm_block)
 {
 	struct brcmf_cfg80211_vif *vif;
 
 	if (cfg->vif_cnt == BRCMF_IFACE_MAX_CNT)
 		return ERR_PTR(-ENOSPC);
 
+	brcmf_dbg(TRACE, "allocating virtual interface (size=%d)\n",
+		  sizeof(*vif));
 	vif = kzalloc(sizeof(*vif), GFP_KERNEL);
 	if (!vif)
 		return ERR_PTR(-ENOMEM);
 
 	vif->wdev.wiphy = cfg->wiphy;
 	vif->wdev.netdev = netdev;
-	vif->wdev.iftype = brcmf_mode_to_nl80211_iftype(mode);
+	vif->wdev.iftype = type;
 
 	if (netdev) {
 		vif->ifp = netdev_priv(netdev);
@@ -3746,7 +3837,7 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 		SET_NETDEV_DEV(netdev, wiphy_dev(cfg->wiphy));
 	}
 
-	vif->mode = mode;
+	vif->mode = brcmf_nl80211_iftype_to_mode(type);
 	vif->pm_block = pm_block;
 	vif->roam_off = -1;
 
@@ -3757,7 +3848,7 @@ struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
 	return vif;
 }
 
-static void brcmf_free_vif(struct brcmf_cfg80211_vif *vif)
+void brcmf_free_vif(struct brcmf_cfg80211_vif *vif)
 {
 	struct brcmf_cfg80211_info *cfg;
 	struct wiphy *wiphy;
@@ -4226,7 +4317,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 	cfg->pub = drvr;
 	INIT_LIST_HEAD(&cfg->vif_list);
 
-	vif = brcmf_alloc_vif(cfg, ndev, WL_MODE_BSS, false);
+	vif = brcmf_alloc_vif(cfg, ndev, NL80211_IFTYPE_STATION, false);
 	if (IS_ERR(vif)) {
 		wiphy_free(wiphy);
 		return NULL;
@@ -4237,6 +4328,7 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		brcmf_err("Failed to init iwm_priv (%d)\n", err);
 		goto cfg80211_attach_out;
 	}
+	brcmf_p2p_attach(cfg);
 
 	ifp->vif = vif;
 	return cfg;
@@ -4482,3 +4574,14 @@ s32 brcmf_cfg80211_down(struct net_device *ndev)
 	return err;
 }
 
+u32 wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state)
+{
+	struct brcmf_cfg80211_vif *vif;
+	bool result = 0;
+
+	list_for_each_entry(vif, &cfg->vif_list, list) {
+		if (test_bit(state, &vif->sme_state))
+			result++;
+	}
+	return result;
+}
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
index e4d9cc7..014a463 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.h
@@ -41,6 +41,38 @@
 #define WL_AUTH_SHARED_KEY		1	/* d11 shared authentication */
 #define IE_MAX_LEN			512
 
+/* IE TLV processing */
+#define TLV_LEN_OFF			1	/* length offset */
+#define TLV_HDR_LEN			2	/* header length */
+#define TLV_BODY_OFF			2	/* body offset */
+#define TLV_OUI_LEN			3	/* oui id length */
+
+/* 802.11 Mgmt Packet flags */
+#define BRCMF_VNDR_IE_BEACON_FLAG	0x1
+#define BRCMF_VNDR_IE_PRBRSP_FLAG	0x2
+#define BRCMF_VNDR_IE_ASSOCRSP_FLAG	0x4
+#define BRCMF_VNDR_IE_AUTHRSP_FLAG	0x8
+#define BRCMF_VNDR_IE_PRBREQ_FLAG	0x10
+#define BRCMF_VNDR_IE_ASSOCREQ_FLAG	0x20
+/* vendor IE in IW advertisement protocol ID field */
+#define BRCMF_VNDR_IE_IWAPID_FLAG	0x40
+/* allow custom IE id */
+#define BRCMF_VNDR_IE_CUSTOM_FLAG	0x100
+
+/* P2P Action Frames flags (spec ordered) */
+#define BRCMF_VNDR_IE_GONREQ_FLAG     0x001000
+#define BRCMF_VNDR_IE_GONRSP_FLAG     0x002000
+#define BRCMF_VNDR_IE_GONCFM_FLAG     0x004000
+#define BRCMF_VNDR_IE_INVREQ_FLAG     0x008000
+#define BRCMF_VNDR_IE_INVRSP_FLAG     0x010000
+#define BRCMF_VNDR_IE_DISREQ_FLAG     0x020000
+#define BRCMF_VNDR_IE_DISRSP_FLAG     0x040000
+#define BRCMF_VNDR_IE_PRDREQ_FLAG     0x080000
+#define BRCMF_VNDR_IE_PRDRSP_FLAG     0x100000
+
+#define BRCMF_VNDR_IE_P2PAF_SHIFT	12
+
+
 /**
  * enum brcmf_scan_status - dongle scan status
  *
@@ -52,11 +84,19 @@ enum brcmf_scan_status {
 	BRCMF_SCAN_STATUS_ABORT,
 };
 
-/* wi-fi mode */
+/**
+ * enum wl_mode - driver mode of virtual interface.
+ *
+ * @WL_MODE_BSS: connects to BSS.
+ * @WL_MODE_IBSS: operate as ad-hoc.
+ * @WL_MODE_AP: operate as access-point.
+ * @WL_MODE_P2P: provide P2P discovery.
+ */
 enum wl_mode {
 	WL_MODE_BSS,
 	WL_MODE_IBSS,
-	WL_MODE_AP
+	WL_MODE_AP,
+	WL_MODE_P2P
 };
 
 /* dongle configuration */
@@ -122,14 +162,18 @@ enum brcmf_vif_status {
 /**
  * struct vif_saved_ie - holds saved IEs for a virtual interface.
  *
+ * @probe_req_ie: IE info for probe request.
  * @probe_res_ie: IE info for probe response.
  * @beacon_ie: IE info for beacon frame.
+ * @probe_req_ie_len: IE info length for probe request.
  * @probe_res_ie_len: IE info length for probe response.
  * @beacon_ie_len: IE info length for beacon frame.
  */
 struct vif_saved_ie {
+	u8  probe_req_ie[VNDR_IES_BUF_LEN];
 	u8  probe_res_ie[IE_MAX_LEN];
 	u8  beacon_ie[IE_MAX_LEN];
+	u32 probe_req_ie_len;
 	u32 probe_res_ie_len;
 	u32 beacon_ie_len;
 };
@@ -189,6 +233,9 @@ struct escan_info {
 	u8 escan_buf[WL_ESCAN_BUF_SIZE];
 	struct wiphy *wiphy;
 	struct net_device *ndev;
+	s32 (*run)(struct brcmf_cfg80211_info *cfg,
+		   struct net_device *ndev,
+		   struct cfg80211_scan_request *request, u16 action);
 };
 
 /**
@@ -277,6 +324,7 @@ struct brcmf_pno_scanresults_le {
  *
  * @wiphy: wiphy object for cfg80211 interface.
  * @conf: dongle configuration.
+ * @p2p: peer-to-peer specific information.
  * @scan_request: cfg80211 scan request object.
  * @usr_sync: mainly for dongle up/down synchronization.
  * @bss_list: bss_list holding scanned ap information.
@@ -308,6 +356,7 @@ struct brcmf_pno_scanresults_le {
 struct brcmf_cfg80211_info {
 	struct wiphy *wiphy;
 	struct brcmf_cfg80211_conf *conf;
+	struct brcmf_p2p_info p2p;
 	struct cfg80211_scan_request *scan_request;
 	struct mutex usr_sync;
 	struct brcmf_scan_results *bss_list;
@@ -337,6 +386,19 @@ struct brcmf_cfg80211_info {
 	u8 vif_cnt;
 };
 
+/**
+ * struct brcmf_tlv - tag_ID/length/value_buffer tuple.
+ *
+ * @id: tag identifier.
+ * @len: number of bytes in value buffer.
+ * @data: value buffer.
+ */
+struct brcmf_tlv {
+	u8 id;
+	u8 len;
+	u8 data[1];
+};
+
 static inline struct wiphy *cfg_to_wiphy(struct brcmf_cfg80211_info *cfg)
 {
 	return cfg->wiphy;
@@ -389,4 +451,16 @@ void brcmf_cfg80211_detach(struct brcmf_cfg80211_info *cfg);
 s32 brcmf_cfg80211_up(struct net_device *ndev);
 s32 brcmf_cfg80211_down(struct net_device *ndev);
 
+struct brcmf_cfg80211_vif *brcmf_alloc_vif(struct brcmf_cfg80211_info *cfg,
+					   struct net_device *netdev,
+					   enum nl80211_iftype type,
+					   bool pm_block);
+void brcmf_free_vif(struct brcmf_cfg80211_vif *vif);
+
+s32 brcmf_vif_set_mgmt_ie(struct brcmf_cfg80211_vif *vif, s32 pktflag,
+			  const u8 *vndr_ie_buf, u32 vndr_ie_len);
+struct brcmf_tlv *brcmf_parse_tlvs(void *buf, int buflen, uint key);
+u16 channel_to_chanspec(struct ieee80211_channel *ch);
+u32 wl_get_vif_state_all(struct brcmf_cfg80211_info *cfg, unsigned long state);
+
 #endif				/* _wl_cfg80211_h_ */
-- 
1.7.10.4


