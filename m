Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40815 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751152AbdFAD1m (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 31 May 2017 23:27:42 -0400
From: "Tobin C. Harding" <me@tobin.cc>
To: linux-wireless@vger.kernel.org
Cc: "Tobin C. Harding" <me@tobin.cc>,
        driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org, Wolfram Sang <wsa@the-dreams.de>,
        Tycho Andersen <tycho@tycho.ws>
Subject: [RFC 2/3] staging: ks7010: add cfg80211 files
Date: Thu,  1 Jun 2017 13:27:07 +1000
Message-Id: <1496287628-16787-3-git-send-email-me@tobin.cc> (sfid-20170601_052810_159628_945A5E59)
In-Reply-To: <1496287628-16787-1-git-send-email-me@tobin.cc>
References: <1496287628-16787-1-git-send-email-me@tobin.cc>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We are in the process of re-writing the current WEXT driver to use the
cfg80211 configuration API. Currently driver root directory is
empty. First step is to implement all the firmware interface in a
single layer of abstraction, Firmware Interface Layer (FIL). We can
add a skeleton implementation for most of the rest of the driver at
the same time.

Add cfg80211 driver skeleton. Implement FIL.

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/staging/ks7010/Makefile    |    6 +
 drivers/staging/ks7010/README.rst  |   73 ++
 drivers/staging/ks7010/TODO.rst    |   17 +
 drivers/staging/ks7010/cfg80211.c  |   45 ++
 drivers/staging/ks7010/cfg80211.h  |    9 +
 drivers/staging/ks7010/common.h    |   10 +
 drivers/staging/ks7010/eap.h       |   36 +
 drivers/staging/ks7010/fil.c       | 1294 ++++++++++++++++++++++++++++++++++++
 drivers/staging/ks7010/fil.h       |  527 +++++++++++++++
 drivers/staging/ks7010/fil_types.h |  845 +++++++++++++++++++++++
 drivers/staging/ks7010/hif.c       |  104 +++
 drivers/staging/ks7010/hif.h       |   23 +
 drivers/staging/ks7010/ks7010.h    |   94 +++
 drivers/staging/ks7010/main.c      |  122 ++++
 drivers/staging/ks7010/sdio.c      |  399 +++++++++++
 drivers/staging/ks7010/sdio.h      |   86 +++
 drivers/staging/ks7010/tx.c        |   29 +
 17 files changed, 3719 insertions(+)
 create mode 100644 drivers/staging/ks7010/README.rst
 create mode 100644 drivers/staging/ks7010/TODO.rst
 create mode 100644 drivers/staging/ks7010/cfg80211.c
 create mode 100644 drivers/staging/ks7010/cfg80211.h
 create mode 100644 drivers/staging/ks7010/common.h
 create mode 100644 drivers/staging/ks7010/eap.h
 create mode 100644 drivers/staging/ks7010/fil.c
 create mode 100644 drivers/staging/ks7010/fil.h
 create mode 100644 drivers/staging/ks7010/fil_types.h
 create mode 100644 drivers/staging/ks7010/hif.c
 create mode 100644 drivers/staging/ks7010/hif.h
 create mode 100644 drivers/staging/ks7010/ks7010.h
 create mode 100644 drivers/staging/ks7010/main.c
 create mode 100644 drivers/staging/ks7010/sdio.c
 create mode 100644 drivers/staging/ks7010/sdio.h
 create mode 100644 drivers/staging/ks7010/tx.c

diff --git a/drivers/staging/ks7010/Makefile b/drivers/staging/ks7010/Makefile
index f58cf9a..29c46db 100644
--- a/drivers/staging/ks7010/Makefile
+++ b/drivers/staging/ks7010/Makefile
@@ -1 +1,7 @@
 obj-$(CONFIG_KS7010) += ks7010.o
+ks7010-y	     += main.o
+ks7010-y	     += tx.o
+ks7010-y	     += sdio.o
+ks7010-y	     += cfg80211.o
+ks7010-y	     += fil.o
+ks7010-y	     += hif.o
diff --git a/drivers/staging/ks7010/README.rst b/drivers/staging/ks7010/README.rst
new file mode 100644
index 0000000..5ce54f9
--- /dev/null
+++ b/drivers/staging/ks7010/README.rst
@@ -0,0 +1,73 @@
+=============================
+Key Stream SDIO Device Driver
+=============================
+
+Current Status
+--------------
+
+Firmware Interface Layer only.
+Skeleton implementation in all other files.
+
+Description
+-----------
+
+Driver conversion from WEXT interface to cfg80211 API.
+
+The current KeyStream SDIO wireless driver (drivers/staging/ks7010)
+implements the WEXT interface.
+
+This driver is based on source code from the Ben Nanonote extra repository [1]
+which is based on the original v007 release from Renesas [2].
+
+[1] http://projects.qi-hardware.com/index.php/p/openwrt-packages/source/tree/master/ks7010/src
+[2] http://downloads.qi-hardware.com/software/ks7010_sdio_v007.tar.bz2
+
+Extensive refactoring has been done to the driver whilst in staging
+and the current mainline tip is untested.
+
+WEXT driver files :-
+ - ks7010_sdio.[ch] 	- SDIO code.
+ - ks_hostif.[ch] 	- Device interface.
+ - ks_wlan_net.c 	- WEXT interface.
+ - mic.[ch] 		- Custom Michael MIC implementation.
+ - eap_packet.h 	- EAP headers.
+ - ks_wlan_ioctl.h 	- WEXT IOCTL.
+
+cfg80211 driver files :-
+ - main.c 		- Main driver file (net_device_ops etc).
+ - ks7010.h 		- Main driver header file.
+ - common.h 		- Constant definitions and forward declarations.
+ - eap.h 		- EAPOL structure descriptions.
+ - sdio.[ch] 		- SDIO code.
+ - fil.[ch] 		- Firmware Interface Layer.
+ - fil_types.h 		- Internal FIL types.
+ - hif.[ch] 		- Host Interface Layer.
+ - cfg80211.c 		- cfg80211 API implementation.
+ - tx.c 		- Transmit path functions.
+
+cfg80211 driver files to do :-
+ - mic.[ch] 		- Interface to the kernel Michael MIC implementation.
+ - rx.c 		- Recive path functions.
+
+Other Information
+=================
+
+Hardware
+--------
+https://wikidevi.com/wiki/Spectec_SDW-821_(KeyStream)
+https://wikidevi.com/wiki/Spectec_SDW-823
+
+Kernel Config
+-------------
+http://cateee.net/lkddb/web-lkddb/KS7010.html
+
+also enable
+ - MMC_DEBUG
+
+Testing
+-------
+http://elinux.org/Tests:SDIO-KS7010
+
+Writing SDIO Linux Drivers
+--------------------------
+http://www.varsanofiev.com/inside/WritingLinuxSDIODrivers.htm
diff --git a/drivers/staging/ks7010/TODO.rst b/drivers/staging/ks7010/TODO.rst
new file mode 100644
index 0000000..8268855
--- /dev/null
+++ b/drivers/staging/ks7010/TODO.rst
@@ -0,0 +1,17 @@
+======
+TODO's
+======
+
+- Clear the FIXME's (in source files).
+- Clear the TODO's (in source files).
+- Implement cfg80211
+- Implement SDIO
+- Implement HIF (includes manually doing MIC for TKIP).
+- Implement init/cleanup functions at each layer (including probe/remove).
+- Implement tx/rx data paths.
+
+Please send patches to:
+Greg Kroah-Hartman <gregkh@linuxfoundation.org>
+Wolfram Sang <wsa@the-dreams.de>
+Tobin C. Harding <me@tobin.cc>
+Linux Driver Project Developer List <driverdev-devel@linuxdriverproject.org>
diff --git a/drivers/staging/ks7010/cfg80211.c b/drivers/staging/ks7010/cfg80211.c
new file mode 100644
index 0000000..fe5fffc
--- /dev/null
+++ b/drivers/staging/ks7010/cfg80211.c
@@ -0,0 +1,45 @@
+#include <net/cfg80211.h>
+#include <linux/inetdevice.h>
+
+#include "ks7010.h"
+#include "cfg80211.h"
+
+static struct cfg80211_ops ks7010_cfg80211_ops = {
+};
+
+static const struct ethtool_ops ks7010_ethtool_ops = {
+	.get_drvinfo = cfg80211_get_drvinfo,
+	.get_link = ethtool_op_get_link,
+};
+
+/**
+ * ks7010_cfg80211_create() - Create wiphy.
+ */
+struct ks7010 *ks7010_cfg80211_create(void)
+{
+	struct ks7010 *ks;
+	struct wiphy *wiphy;
+
+	/* create a new wiphy for use with cfg80211 */
+	wiphy = wiphy_new(&ks7010_cfg80211_ops, sizeof(*ks));
+
+	if (!wiphy) {
+		ks_err("couldn't allocate wiphy device\n");
+		return NULL;
+	}
+
+	ks = wiphy_priv(wiphy);
+	ks->wiphy = wiphy;
+
+	return ks;
+}
+
+/**
+ * ks7010_cfg80211_destroy() - Free wiphy.
+ * @ks: The ks7010 device.
+ */
+void ks7010_cfg80211_destroy(struct ks7010 *ks)
+{
+	wiphy_free(ks->wiphy);
+}
+
diff --git a/drivers/staging/ks7010/cfg80211.h b/drivers/staging/ks7010/cfg80211.h
new file mode 100644
index 0000000..ffad6cb
--- /dev/null
+++ b/drivers/staging/ks7010/cfg80211.h
@@ -0,0 +1,9 @@
+#ifndef _KS7010_CFG80211_H
+#define _KS7010_CFG80211_H
+
+#include "common.h"
+
+struct ks7010 *ks7010_cfg80211_create(void);
+void ks7010_cfg80211_destroy(struct ks7010 *ks);
+
+#endif	/* _KS7010_CFG80211_H */
diff --git a/drivers/staging/ks7010/common.h b/drivers/staging/ks7010/common.h
new file mode 100644
index 0000000..f9df129
--- /dev/null
+++ b/drivers/staging/ks7010/common.h
@@ -0,0 +1,10 @@
+#ifndef _KS7010_COMMON_H
+#define _KS7010_COMMON_H
+
+struct ks7010;
+
+#define MAX_U16_VAL 0xFFFF
+
+#define IE_MAX_SIZE 128
+
+#endif	/* _KS7010_COMMON_H */
diff --git a/drivers/staging/ks7010/eap.h b/drivers/staging/ks7010/eap.h
new file mode 100644
index 0000000..58b8575
--- /dev/null
+++ b/drivers/staging/ks7010/eap.h
@@ -0,0 +1,36 @@
+#ifndef _KS7010_EAP_H
+#define _KS7010_EAP_H
+
+/*
+ * FIXME these headers may be defined in the kernel already?
+ */
+
+/**
+ * enum protocol_id - Ethernet frame protocol identity.
+ * @PROTO_ID_EAPOL: EAP over LAN (802.1X)
+ * @PROTO_ID_IP: Internet Protocol version 4
+ * @PROTO_ID_ARP: Address resolution protocol
+ */
+enum protocol_id {
+	PROTO_ID_EAPOL	= 0x888e,
+	PROTO_ID_IP	= 0x0800,
+	PROTO_ID_ARP	= 0x0806
+};
+
+#define OUI_SIZE 3
+
+/**
+ * struct snap_hdr - EAPOL on 802.11 SNAP header.
+ * @dsap: Destination Service Access Point.
+ * @ssap: Source Service Access Point.
+ * @cntl: Control, set to 0x03 for Unnumbered Information.
+ * @oui: Organizationally Unique Identifier.
+ */
+struct snap_hdr {
+	u8 dsap;
+	u8 ssap;
+	u8 cntl;
+	u8 oui[OUI_SIZE];
+} __packed;
+
+#endif	/* _KS7010_EAP_H */
diff --git a/drivers/staging/ks7010/fil.c b/drivers/staging/ks7010/fil.c
new file mode 100644
index 0000000..08ecebc
--- /dev/null
+++ b/drivers/staging/ks7010/fil.c
@@ -0,0 +1,1294 @@
+#include <crypto/hash.h>
+#include <uapi/linux/wireless.h>
+#include <linux/skbuff.h>
+
+#include "ks7010.h"
+#include "fil.h"
+#include "eap.h"
+#include "fil_types.h"
+
+/**
+ * DOC: Firmware Interface Layer - Set and get variables to and from
+ * the device firmware.
+ */
+
+/*
+ * fil_t_hdr->size has different meaning depending on receive path or
+ * transmit path. Keep all the logic here in one place.
+ */
+
+static size_t tx_fil_t_hdr_to_frame_size(struct fil_t_hdr *fhdr)
+{
+	u16 size;
+
+	size = le16_to_cpu(fhdr->size);
+	return (size_t)(size + sizeof(fhdr->size));
+}
+
+static __le16 tx_frame_size_to_fil_t_hdr_size(size_t frame_size)
+{
+	struct fil_t_hdr fhdr;
+
+	return cpu_to_le16((u16)(frame_size - sizeof(fhdr.size)));
+}
+
+static size_t rx_fil_t_hdr_to_frame_size(struct fil_t_hdr *fhdr)
+{
+	return le16_to_cpu(fhdr->size);
+}
+
+static __le16 rx_frame_size_to_fil_t_hdr_size(size_t frame_size)
+{
+	return cpu_to_le16((u16)frame_size);
+}
+
+/**
+ * fil_alloc_tx_frame() - Allocate a tx frame buffer.
+ * @frame_size: Frame size in octets.
+ * @event: &struct fil_t_event
+ *
+ * Allocates an aligned frame big enough to fit @frame_size
+ * octets. Once fil_alloc_frame() returns we do not know how much
+ * memory was allocated, _tx_align() recalculates the aligned size.
+ *
+ * Sets the &struct fil_t_hdr size and event members.
+ */
+static void *fil_alloc_tx_frame(size_t frame_size, enum fil_t_event event)
+{
+	struct fil_t_hdr *fhdr;
+	size_t aligned_size;
+
+	aligned_size = fil_align_size(frame_size);
+
+	if (aligned_size > MAX_U16_VAL) {
+		ks_err("aligning frame overflows u16: %zu", frame_size);
+		return NULL;
+	}
+
+	fhdr = kzalloc(aligned_size, GFP_ATOMIC);
+	if (!fhdr)
+		return NULL;
+
+	fhdr->size = tx_frame_size_to_fil_t_hdr_size(frame_size);
+	fhdr->event = cpu_to_le16((u16)event);
+
+	return fhdr;
+}
+
+/**
+ * _tx_align() - Calculates aligned size and passe data to next layer.
+ * @ks: The ks7010 device.
+ * @data: Pointer to frame data allocated using fil_alloc_tx_frame().
+ * @frame_size: Unaligned frame size.
+ * @skb: sk_buff, NULL for SME frames.
+ */
+static int _tx_align(
+	struct ks7010 *ks, void *data, size_t frame_size, struct sk_buff *skb)
+{
+	int ret;
+	size_t data_size;
+
+	data_size = fil_align_size(frame_size);
+
+	ret = ks7010_tx(ks, (u8 *)data, data_size, NULL);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+/* Transmit an SME frame */
+static void fil_tx_sme(struct ks7010 *ks, void *data, size_t frame_size)
+{
+	int ret;
+
+	ret = _tx_align(ks, data, frame_size, NULL);
+	if (ret) {
+		struct fil_t_hdr *fhdr;
+		u16 event;
+
+		fhdr = (struct fil_t_hdr *)data;
+		event = le16_to_cpu(fhdr->event);
+		ks_debug("SME tx error for event %d", event);
+	}
+}
+
+/* Transmit a frame built from data received from network stack */
+static int fil_tx_skb(
+	struct ks7010 *ks, void *data, size_t frame_size, struct sk_buff *skb)
+{
+	return _tx_align(ks, data, frame_size, skb);
+}
+
+static void fil_mib_get_req(struct ks7010 *ks, enum mib_attribute attr)
+{
+	struct fil_t_mib_get_req *hdr;
+	size_t frame_size;
+
+	frame_size = sizeof(*hdr);
+
+	hdr = fil_alloc_tx_frame(frame_size, FIL_T_MIB_GET_REQ);
+	if (!hdr) {
+		ks_debug("fil_alloc_tx_frame failed for attr: %d", (int)attr);
+		return;
+	}
+
+	hdr->attribute = cpu_to_le32(attr);
+	fil_tx_sme(ks, hdr, frame_size);
+}
+
+static void _fil_mib_set_req(struct ks7010 *ks,
+			     enum mib_attribute attr,
+			     enum mib_data_type type,
+			     u8 *data, size_t data_size)
+{
+	struct fil_t_mib_set_req *hdr;
+	size_t frame_size;
+
+	frame_size = sizeof(*hdr) + data_size;
+	if (frame_size > MAX_U16_VAL) {
+		ks_debug("u16 overflow, attr: %d size: %d",
+			 (int)attr, (int)frame_size);
+		return;
+	}
+
+	hdr = fil_alloc_tx_frame(frame_size, FIL_T_MIB_SET_REQ);
+	if (!hdr) {
+		ks_debug("fil_alloc_tx_frame failed for attr: %d", (int)attr);
+		return;
+	}
+
+	hdr->attribute = cpu_to_le32(attr);
+	hdr->data_size = cpu_to_le16((u16)data_size);
+	hdr->data_type = cpu_to_le16(type);
+	memcpy(&hdr->data, data, data_size);
+
+	fil_tx_sme(ks, hdr, frame_size);
+}
+
+static void
+fil_mib_set_req_int(struct ks7010 *ks, enum mib_attribute attr, u32 val)
+{
+	__le32 v = cpu_to_le32(val);
+
+	_fil_mib_set_req(ks, attr, FIL_T_MIB_TYPE_INT, (u8 *)&v, sizeof(v));
+}
+
+static void
+fil_mib_set_req_bool(struct ks7010 *ks, enum mib_attribute attr, bool val)
+{
+	__le32 v = cpu_to_le32((u32)val);
+
+	_fil_mib_set_req(ks, attr, FIL_T_MIB_TYPE_BOOL, (u8 *)&v, sizeof(v));
+}
+
+static void fil_mib_set_req_ostring(struct ks7010 *ks, enum mib_attribute attr,
+				    u8 *data, size_t data_size)
+{
+	_fil_mib_set_req(ks, attr, FIL_T_MIB_TYPE_OSTRING, data, data_size);
+}
+
+static void fil_simple_req(struct ks7010 *ks, enum fil_t_event event)
+{
+	struct fil_t_hdr *hdr;
+	size_t frame_size = sizeof(*hdr);
+
+	hdr = fil_alloc_tx_frame(frame_size, event);
+	if (!hdr)
+		return;
+
+	fil_tx_sme(ks, hdr, frame_size);
+}
+
+void ks7010_fil_start(struct ks7010 *ks, enum fil_nw_type nw_type)
+{
+	struct fil_t_start_req *hdr;
+	size_t frame_size = sizeof(*hdr);
+
+	if (nw_type != NW_TYPE_INFRA) {
+		ks_debug("driver supports infrastructure networks only");
+		return;
+	}
+
+	hdr = fil_alloc_tx_frame(frame_size, FIL_T_START_REQ);
+	if (!hdr)
+		return;
+
+	hdr->nw_type = cpu_to_le16((u16)nw_type);
+
+	fil_tx_sme(ks, hdr, frame_size);
+}
+
+void ks7010_fil_stop(struct ks7010 *ks)
+{
+	fil_simple_req(ks, FIL_T_STOP_REQ);
+}
+
+void ks7010_fil_sleep(struct ks7010 *ks)
+{
+	fil_simple_req(ks, FIL_T_SLEEP_REQ);
+}
+
+void
+ks7010_fil_mic_failure(struct ks7010 *ks, struct fil_mic_failure *req)
+{
+	struct fil_t_mic_failure_req *hdr;
+	size_t frame_size = sizeof(*hdr);
+
+	hdr = fil_alloc_tx_frame(frame_size, FIL_T_MIC_FAILURE_REQ);
+	if (!hdr)
+		return;
+
+	hdr->count = cpu_to_le16(req->count);
+	hdr->timer = cpu_to_le16(req->timer);
+
+	fil_tx_sme(ks, hdr, frame_size);
+}
+
+void ks7010_fil_set_power_mgmt(struct ks7010 *ks, struct fil_power_mgmt *req)
+{
+	struct fil_t_power_mgmt_req *hdr;
+	size_t frame_size = sizeof(*hdr);
+
+	hdr = fil_alloc_tx_frame(frame_size, FIL_T_POWER_MGMT_REQ);
+	if (!hdr)
+		return;
+
+	if (req->ps_enable)
+		hdr->mode = cpu_to_le32(FIL_T_POWER_MGMT_MODE_SAVE);
+	else
+		hdr->mode = cpu_to_le32(FIL_T_POWER_MGMT_MODE_ACTIVE);
+
+	if (req->wake_up)
+		hdr->wake_up = cpu_to_le32(FIL_T_POWER_MGMT_WAKE_UP_TRUE);
+	else
+		hdr->wake_up = cpu_to_le32(FIL_T_POWER_MGMT_WAKE_UP_FALSE);
+
+	if (req->receive_dtims)
+		hdr->receive_dtims =
+			cpu_to_le32(FIL_T_POWER_MGMT_RECEIVE_DTIMS_TRUE);
+	else
+		hdr->receive_dtims =
+			cpu_to_le32(FIL_T_POWER_MGMT_RECEIVE_DTIMS_FALSE);
+
+	fil_tx_sme(ks, hdr, frame_size);
+}
+
+static bool _set_infra_req_is_valid(struct fil_set_infra *req)
+{
+	if (req->ssid_size > FIL_T_SSID_MAX_SIZE) {
+		ks_debug("ssid size to big: %zu", req->ssid_size);
+		return false;
+	}
+
+	if (req->channels_size > FIL_T_CHANNELS_MAX_SIZE) {
+		ks_debug("channels size to big: %zu", req->channels_size);
+		return false;
+	}
+
+	if (req->rates_size > FIL_T_INFRA_SET_REQ_RATES_MAX_SIZE) {
+		ks_debug("rates size to big: %zu", req->rates_size);
+		return false;
+	}
+
+	return true;
+}
+
+void ks7010_fil_set_infra(struct ks7010 *ks, struct fil_set_infra *req)
+{
+	struct fil_t_infra_set_req *hdr;
+	struct _infra_set_req *ptr;
+	size_t frame_size = sizeof(*hdr);
+
+	if (!_set_infra_req_is_valid(req))
+		return;
+
+	hdr = fil_alloc_tx_frame(frame_size, FIL_T_INFRA_SET_REQ);
+	if (!hdr)
+		return;
+
+	ptr = &hdr->req;
+
+	ptr->phy_type = cpu_to_le16((u16)req->phy_type);
+	ptr->cts_mode = cpu_to_le16((u16)req->cts_mode);
+	ptr->scan_type = cpu_to_le16((u16)req->scan_type);
+	ptr->auth_type = cpu_to_le16((u16)req->auth_type);
+
+	ptr->capability = cpu_to_le16(req->capability);
+	ptr->beacon_lost_count = cpu_to_le16(req->beacon_lost_count);
+
+	memcpy(&ptr->rates.body[0], &req->rates, req->rates_size);
+	ptr->rates.size = req->rates_size;
+
+	memcpy(&ptr->ssid.body[0], req->ssid, req->ssid_size);
+	ptr->ssid.size = req->ssid_size;
+
+	memcpy(&ptr->channels.body[0], req->channels, req->channels_size);
+	ptr->channels.size = req->channels_size;
+
+	fil_tx_sme(ks, hdr, frame_size);
+}
+
+void ks7010_fil_set_infra_bssid(
+	struct ks7010 *ks, struct fil_set_infra *req, u8 *bssid)
+{
+	struct fil_t_infra_set2_req *hdr;
+	struct _infra_set_req *ptr;
+	size_t frame_size = sizeof(*hdr);
+
+	if (!_set_infra_req_is_valid(req))
+		return;
+
+	hdr = fil_alloc_tx_frame(frame_size, FIL_T_INFRA_SET2_REQ);
+	if (!hdr)
+		return;
+
+	ptr = &hdr->req;
+
+	ptr->phy_type = cpu_to_le16((u16)req->phy_type);
+	ptr->cts_mode = cpu_to_le16((u16)req->cts_mode);
+	ptr->scan_type = cpu_to_le16((u16)req->scan_type);
+	ptr->auth_type = cpu_to_le16((u16)req->auth_type);
+
+	ptr->capability = cpu_to_le16(req->capability);
+	ptr->beacon_lost_count = cpu_to_le16(req->beacon_lost_count);
+
+	memcpy(&ptr->rates.body[0], &req->rates, req->rates_size);
+	ptr->rates.size = req->rates_size;
+
+	memcpy(&ptr->ssid.body[0], req->ssid, req->ssid_size);
+	ptr->ssid.size = req->ssid_size;
+
+	memcpy(&ptr->channels.body[0], req->channels, req->channels_size);
+	ptr->channels.size = req->channels_size;
+
+	memcpy(hdr->bssid, bssid, ETH_ALEN);
+
+	fil_tx_sme(ks, hdr, frame_size);
+}
+
+void ks7010_fil_set_mac_addr(struct ks7010 *ks, u8 *addr)
+{
+	fil_mib_set_req_ostring(ks, LOCAL_CURRENT_ADDRESS, addr, ETH_ALEN);
+}
+
+#define FIL_T_MCAST_MAX_NUM_ADDRS 32
+
+/**
+ * ks7010_fil_set_mcast_addr() - Set multicast address list.
+ * @ks: The ks7010 device.
+ * @addresses: Consecutive Ethernet addresses.
+ * @num_addresses: Number of addresses in @addresses.
+ */
+void ks7010_fil_set_mcast_addresses(
+	struct ks7010 *ks, u8 *addresses, int num_addresses)
+{
+	size_t size;
+
+	if (num_addresses > FIL_T_MCAST_MAX_NUM_ADDRS) {
+		ks_debug("to many mcast addresses: %d", num_addresses);
+		return;
+	}
+
+	size = num_addresses * ETH_ALEN;
+	fil_mib_set_req_ostring(ks, LOCAL_MULTICAST_ADDRESS, addresses, size);
+}
+
+void ks7010_fil_mcast_filter_enable(struct ks7010 *ks, bool enable)
+{
+	fil_mib_set_req_bool(ks, LOCAL_MULTICAST_FILTER, enable);
+}
+
+void ks7010_fil_privacy_invoked(struct ks7010 *ks, bool enable)
+{
+	fil_mib_set_req_bool(ks, DOT11_PRIVACY_INVOKED, enable);
+}
+
+void ks7010_fil_set_default_key_index(struct ks7010 *ks, int idx)
+{
+	fil_mib_set_req_int(ks, MIB_DEFAULT_KEY_INDEX, idx);
+}
+
+void ks7010_fil_set_key_1(struct ks7010 *ks, u8 *key, size_t key_size)
+{
+	fil_mib_set_req_ostring(ks, MIB_KEY_VALUE_1, key, key_size);
+}
+
+void ks7010_fil_set_key_2(struct ks7010 *ks, u8 *key, size_t key_size)
+{
+	fil_mib_set_req_ostring(ks, MIB_KEY_VALUE_2, key, key_size);
+}
+
+void ks7010_fil_set_key_3(struct ks7010 *ks, u8 *key, size_t key_size)
+{
+	fil_mib_set_req_ostring(ks, MIB_KEY_VALUE_3, key, key_size);
+}
+
+void ks7010_fil_set_key_4(struct ks7010 *ks, u8 *key, size_t key_size)
+{
+	fil_mib_set_req_ostring(ks, MIB_KEY_VALUE_4, key, key_size);
+}
+
+void ks7010_fil_wpa_enable(struct ks7010 *ks, bool enable)
+{
+	fil_mib_set_req_bool(ks, MIB_WPA_ENABLE, enable);
+}
+
+void ks7010_fil_set_wpa_mode(struct ks7010 *ks, enum fil_wpa_mode mode)
+{
+	struct {
+		__le32 mode;
+		__le16 capability;
+	} __packed mct;
+
+	mct.mode = cpu_to_le32((u32)mode);
+	mct.capability = 0;
+
+	fil_mib_set_req_ostring(ks, MIB_WPA_MODE, (u8 *)&mct, sizeof(mct));
+}
+
+void ks7010_fil_set_wpa_ucast_suite(struct ks7010 *ks, u8 *cipher,
+				    size_t cipher_size)
+{
+	fil_mib_set_req_ostring(ks, MIB_WPA_CONFIG_UCAST_SUITE,
+				cipher, cipher_size);
+}
+
+void ks7010_fil_set_wpa_mcast_suite(struct ks7010 *ks, u8 *cipher,
+				    size_t cipher_size)
+{
+	fil_mib_set_req_ostring(ks, MIB_WPA_CONFIG_MCAST_SUITE,
+				cipher, cipher_size);
+}
+
+void ks7010_fil_set_wpa_key_mgmt_suite(struct ks7010 *ks, u8 *cipher,
+				       size_t cipher_size)
+{
+	fil_mib_set_req_ostring(ks, MIB_WPA_CONFIG_AUTH_SUITE,
+				cipher, cipher_size);
+}
+
+void ks7010_fil_set_ptk_tsc(struct ks7010 *ks, u8 *seq, size_t seq_size)
+{
+	fil_mib_set_req_ostring(ks, MIB_PTK_TSC, seq, seq_size);
+}
+
+void ks7010_fil_set_gtk_1_tsc(struct ks7010 *ks, u8 *seq, size_t seq_size)
+{
+	fil_mib_set_req_ostring(ks, MIB_GTK_1_TSC, seq, seq_size);
+}
+
+void ks7010_fil_set_gtk_2_tsc(struct ks7010 *ks, u8 *seq, size_t seq_size)
+{
+	fil_mib_set_req_ostring(ks, MIB_GTK_2_TSC, seq, seq_size);
+}
+
+void ks7010_set_pmk(struct ks7010 *ks)
+{
+	/* TODO */
+}
+
+void ks7010_fil_set_region(struct ks7010 *ks, u32 region)
+{
+	fil_mib_set_req_int(ks, LOCAL_REGION, region);
+}
+
+void ks7010_fil_set_rts_thresh(struct ks7010 *ks, u32 thresh)
+{
+	fil_mib_set_req_int(ks, DOT11_RTS_THRESHOLD, thresh);
+}
+
+void ks7010_fil_set_frag_thresh(struct ks7010 *ks, u32 thresh)
+{
+	fil_mib_set_req_int(ks, DOT11_FRAGMENTATION_THRESHOLD, thresh);
+}
+
+void ks7010_fil_set_gain(struct ks7010 *ks, struct fil_gain *gain)
+{
+	fil_mib_set_req_ostring(ks, LOCAL_GAIN, (u8 *)gain, sizeof(*gain));
+}
+
+void ks7010_fil_get_mac_addr(struct ks7010 *ks)
+{
+	fil_mib_get_req(ks, DOT11_MAC_ADDRESS);
+}
+
+void ks7010_fil_get_fw_version(struct ks7010 *ks)
+{
+	fil_mib_get_req(ks, DOT11_PRODUCT_VERSION);
+}
+
+void ks7010_fil_get_eeprom_cksum(struct ks7010 *ks)
+{
+	fil_mib_get_req(ks, LOCAL_EEPROM_SUM);
+}
+
+void ks7010_fil_get_rts_thresh(struct ks7010 *ks)
+{
+	fil_mib_get_req(ks, DOT11_RTS_THRESHOLD);
+}
+
+void ks7010_fil_get_frag_thresh(struct ks7010 *ks)
+{
+	fil_mib_get_req(ks, DOT11_FRAGMENTATION_THRESHOLD);
+}
+
+void ks7010_fil_get_gain(struct ks7010 *ks)
+{
+	fil_mib_get_req(ks, LOCAL_GAIN);
+}
+
+/**
+ * ks7010_fil_get_phy_info() - Get PHY information.
+ * @ks: The ks7010 device.
+ * @timer: 0 for no timer.
+ */
+void ks7010_fil_get_phy_info(struct ks7010 *ks, u16 timer)
+{
+	struct fil_t_phy_info_req *hdr;
+	size_t frame_size = sizeof(*hdr);
+
+	hdr = fil_alloc_tx_frame(frame_size, FIL_T_PHY_INFO_REQ);
+	if (!hdr)
+		return;
+
+	if (timer) {
+		hdr->type = cpu_to_le16((u16)FIL_T_PHY_INFO_TYPE_TIME);
+		hdr->time = cpu_to_le16(timer);
+	} else {
+		hdr->type = cpu_to_le16((u16)FIL_T_PHY_INFO_TYPE_NORMAL);
+		hdr->time = 0;
+	}
+
+	fil_tx_sme(ks, hdr, frame_size);
+}
+
+static bool _scan_req_is_valid(struct fil_scan *req)
+{
+	if (req->ssid_size > FIL_T_SSID_MAX_SIZE) {
+		ks_debug("ssid size to big: %zu", req->ssid_size);
+		return false;
+	}
+
+	if (req->channels_size > FIL_T_CHANNELS_MAX_SIZE) {
+		ks_debug("channels size to big: %zu", req->channels_size);
+		return false;
+	}
+
+	return true;
+}
+
+void ks7010_fil_scan(struct ks7010 *ks, struct fil_scan *req)
+{
+	struct fil_t_scan_req *hdr;
+	size_t frame_size = sizeof(*hdr);
+
+	hdr = fil_alloc_tx_frame(frame_size, FIL_T_SCAN_REQ);
+	if (!hdr)
+		return;
+
+	if (!_scan_req_is_valid(req))
+		return;
+
+	hdr->ch_time_min = cpu_to_le32((u32)FIL_T_DEFAULT_CH_TIME_MIN);
+	hdr->ch_time_max = cpu_to_le32((u32)FIL_T_DEFAULT_CH_TIME_MAX);
+
+	memcpy(hdr->channels.body, req->channels, req->channels_size);
+	hdr->channels.size = req->channels_size;
+
+	memcpy(hdr->ssid.body, req->ssid, req->ssid_size);
+	hdr->ssid.size = req->ssid_size;
+
+	fil_tx_sme(ks, hdr, frame_size);
+}
+
+static void _fil_mib_set_conf(struct ks7010 *ks, u32 attribute)
+{
+	struct fil_ops *fil_ops = ks->fil_ops;
+	void (*callback)(struct ks7010 *ks);
+
+	switch (attribute) {
+	case LOCAL_CURRENT_ADDRESS:
+		callback = fil_ops->set_mac_addr_conf;
+		break;
+
+	case LOCAL_MULTICAST_ADDRESS:
+		callback = fil_ops->set_mcast_addresses_conf;
+		break;
+
+	case LOCAL_MULTICAST_FILTER:
+		callback = fil_ops->mcast_filter_enable_conf;
+		break;
+
+	case DOT11_PRIVACY_INVOKED:
+		callback = fil_ops->privacy_invoked_conf;
+		break;
+
+	case MIB_DEFAULT_KEY_INDEX:
+		callback = fil_ops->set_default_key_index_conf;
+		break;
+
+	case MIB_KEY_VALUE_1:
+		callback = fil_ops->set_key_1_conf;
+		break;
+
+	case MIB_KEY_VALUE_2:
+		callback = fil_ops->set_key_2_conf;
+		break;
+
+	case MIB_KEY_VALUE_3:
+		callback = fil_ops->set_key_3_conf;
+		break;
+
+	case MIB_KEY_VALUE_4:
+		callback = fil_ops->set_key_4_conf;
+		break;
+
+	case MIB_WPA_ENABLE:
+		callback = fil_ops->set_wpa_enable_conf;
+		break;
+
+	case MIB_WPA_MODE:
+		callback = fil_ops->set_wpa_mode_conf;
+		break;
+
+	case MIB_WPA_CONFIG_MCAST_SUITE:
+		callback = fil_ops->set_wpa_mcast_suite_conf;
+		break;
+
+	case MIB_WPA_CONFIG_UCAST_SUITE:
+		callback = fil_ops->set_wpa_ucast_suite_conf;
+		break;
+
+	case MIB_WPA_CONFIG_AUTH_SUITE:
+		callback = fil_ops->set_wpa_key_mgmt_suite_conf;
+		break;
+
+	case MIB_PTK_TSC:
+		callback = fil_ops->set_ptk_tsc_conf;
+		break;
+
+	case MIB_GTK_1_TSC:
+		callback = fil_ops->set_gtk_1_tsc_conf;
+		break;
+
+	case MIB_GTK_2_TSC:
+		callback = fil_ops->set_gtk_2_tsc_conf;
+		break;
+
+	case LOCAL_PMK:
+		callback = fil_ops->set_pmk_conf;
+		break;
+
+	case LOCAL_REGION:
+		callback = fil_ops->set_region_conf;
+		break;
+
+	case DOT11_RTS_THRESHOLD:
+		callback = fil_ops->set_rts_thresh_conf;
+		break;
+
+	case DOT11_FRAGMENTATION_THRESHOLD:
+		callback = fil_ops->set_frag_thresh_conf;
+		break;
+
+	case LOCAL_GAIN:
+		callback = fil_ops->set_gain_conf;
+		break;
+
+	default:
+		ks_debug("unknown attribute %d", attribute);
+		callback = NULL;
+		break;
+	}
+
+	if (callback)
+		callback(ks);
+}
+
+static void fil_mib_set_conf(struct ks7010 *ks, struct fil_t_mib_set_conf *hdr)
+{
+	u32 status, attribute;
+
+	status = le32_to_cpu(hdr->status);
+	attribute = le32_to_cpu(hdr->attribute);
+
+	switch (status) {
+	case MIB_STATUS_INVALID:
+		ks_debug("invalid status for attribute %d", attribute);
+		break;
+
+	case MIB_STATUS_READ_ONLY:
+		ks_debug("read only status for attribute %d", attribute);
+		break;
+
+	case MIB_STATUS_WRITE_ONLY:
+		ks_debug("write only status for attribute %d", attribute);
+		break;
+
+	case MIB_STATUS_SUCCESS:
+		_fil_mib_set_conf(ks, attribute);
+
+	default:
+		ks_debug("unknown status for attribute %d", attribute);
+		break;
+	}
+}
+
+static bool _mib_get_conf_attribute_and_type_is_valid(u32 attribute, u16 type)
+{
+	/* check the firmware behavior, confirm attributes match types ? */
+	return 0;
+}
+
+static void
+_fil_mib_get_conf(struct ks7010 *ks, u32 attribute, u8 *data, u16 data_size)
+{
+	struct fil_ops *fil_ops = ks->fil_ops;
+	void (*callback)(struct ks7010 *ks, u8 *data, u16 data_size);
+
+	switch (attribute) {
+	case DOT11_MAC_ADDRESS:
+		callback = fil_ops->get_mac_addr_conf;
+		break;
+
+	case DOT11_PRODUCT_VERSION:
+		callback = fil_ops->get_fw_version_conf;
+		break;
+
+	case LOCAL_EEPROM_SUM:
+		callback = fil_ops->get_eeprom_cksum_conf;
+		break;
+
+	case DOT11_RTS_THRESHOLD:
+		callback = fil_ops->get_rts_thresh_conf;
+		break;
+
+	case DOT11_FRAGMENTATION_THRESHOLD:
+		callback = fil_ops->get_frag_thresh_conf;
+		break;
+
+	case LOCAL_GAIN:
+		callback = fil_ops->get_gain_conf;
+		break;
+
+	default:
+		ks_debug("unknown status for attribute %d", attribute);
+		callback = NULL;
+	}
+
+	if (callback)
+		callback(ks, data, data_size);
+}
+
+static void fil_mib_get_conf(struct ks7010 *ks, struct fil_t_mib_get_conf *hdr)
+{
+	u32 status, attribute;
+	u16 data_size, type;
+
+	status = le32_to_cpu(hdr->status);
+	attribute = le32_to_cpu(hdr->attribute);
+	data_size = le16_to_cpu(hdr->data_size);
+	type = le16_to_cpu(hdr->data_type);
+
+	if (!_mib_get_conf_attribute_and_type_is_valid(attribute, type))
+		return;
+
+	switch (status) {
+	case MIB_STATUS_INVALID:
+		ks_debug("invalid status for attribute %d", attribute);
+		break;
+
+	case MIB_STATUS_READ_ONLY:
+		ks_debug("read only status for attribute %d", attribute);
+		break;
+
+	case MIB_STATUS_WRITE_ONLY:
+		ks_debug("write only status for attribute %d", attribute);
+		break;
+
+	case MIB_STATUS_SUCCESS:
+		_fil_mib_get_conf(ks, attribute, hdr->data, data_size);
+
+	default:
+		ks_debug("unknown status for attribute %d", attribute);
+		break;
+	}
+}
+
+static bool _result_code_is_valid(u16 result_code)
+{
+	if (result_code != RESULT_SUCCESS &&
+	    result_code != RESULT_INVALID_PARAMETERS &&
+	    result_code != RESULT_NOT_SUPPORTED) {
+		ks_debug("unknown result_code");
+		return false;
+	}
+
+	return true;
+}
+
+static void fil_result_code_conf(struct ks7010 *ks, u16 event,
+				 struct fil_t_result_code_conf *hdr)
+{
+	struct fil_ops *fil_ops = ks->fil_ops;
+	u16 result_code = le16_to_cpu(hdr->result_code);
+	void (*callback)(struct ks7010 *ks, u16 result_code);
+
+	if (!_result_code_is_valid(result_code))
+		return;
+
+	switch (event) {
+	case FIL_T_START_CONF:
+		callback = fil_ops->start_conf;
+		break;
+
+	case FIL_T_STOP_CONF:
+		callback = fil_ops->stop_conf;
+		break;
+
+	case FIL_T_SLEEP_CONF:
+		callback = fil_ops->sleep_conf;
+		break;
+
+	case FIL_T_MIC_FAILURE_CONF:
+		callback = fil_ops->mic_failure_conf;
+		break;
+
+	case FIL_T_POWER_MGMT_CONF:
+		callback = fil_ops->set_power_mgmt_conf;
+		break;
+
+	case FIL_T_INFRA_SET_CONF:
+		callback = fil_ops->set_infra_conf;
+		break;
+
+	case FIL_T_INFRA_SET2_CONF:
+		callback = fil_ops->set_infra_bssid_conf;
+		break;
+
+	default:
+		ks_debug("invalid event: %04X\n", event);
+		callback = NULL;
+		break;
+	}
+
+	if (callback)
+		callback(ks, result_code);
+}
+
+static void fil_phy_info_ind(struct ks7010 *ks, struct fil_t_phy_info_ind *le)
+{
+	struct fil_phy_info cpu;
+
+	cpu.rssi = le->rssi;
+	cpu.signal = le->signal;
+	cpu.noise = le->noise;
+	cpu.link_speed = le->link_speed;
+	cpu.tx_frame = le32_to_cpu(le->tx_frame);
+	cpu.rx_frame = le32_to_cpu(le->rx_frame);
+	cpu.rx_error = le32_to_cpu(le->tx_error);
+	cpu.rx_error = le32_to_cpu(le->rx_error);
+
+	ks_debug("PHY information indication received\n"
+		 "\tRSSI: %u\n\tSignal: %u\n\tNoise: %u\n"
+		 "\tLink Speed: %ux500Kbps\n"
+		 "\tTransmitted Frame Count: %u\n\tReceived Frame Count: %u\n"
+		 "\tTx Failed Count: %u\n\tFCS Error Count: %u\n",
+		 cpu.rssi, cpu.signal, cpu.noise, cpu.link_speed,
+		 cpu.tx_frame, cpu.rx_frame, cpu.tx_error, cpu.rx_error);
+
+	if (ks->fil_ops->get_phy_info_ind)
+		ks->fil_ops->get_phy_info_ind(ks, &cpu);
+}
+
+static void fil_phy_info_conf(struct ks7010 *ks, struct fil_t_hdr *fhdr)
+{
+	size_t frame_size;
+
+	ks_debug("Firmware appears to treat phy_info_conf the same as phy_info_ind?");
+
+	frame_size = rx_fil_t_hdr_to_frame_size(fhdr);
+	if (frame_size < sizeof(struct fil_t_phy_info_ind)) {
+		ks_debug("received frame size is too small");
+		return;
+	}
+
+	ks_debug("passing fhdr to fil_phy_info_ind()");
+	fil_phy_info_ind(ks, (struct fil_t_phy_info_ind *)fhdr);
+}
+
+/*
+ * struct fil_scan_conf contains a 'reserved' member, keep it separate
+ * from the other result_code headers for documentation purposes
+ */
+static void fil_scan_conf(struct ks7010 *ks, struct fil_t_scan_conf *hdr)
+{
+	u16 result_code;
+	void (*callback)(struct ks7010 *ks, u16 result_code);
+
+	callback = ks->fil_ops->scan_conf;
+
+	result_code = le16_to_cpu(hdr->result_code);
+	if (!_result_code_is_valid(result_code))
+		return;
+
+	if (callback)
+		callback(ks, result_code);
+}
+
+static void fil_scan_ind(struct ks7010 *ks, struct fil_t_scan_ind *le)
+{
+	struct fil_ops *fil_ops = ks->fil_ops;
+	struct fil_scan_ind *cpu;
+	size_t size;
+
+	if (!fil_ops->scan_ind) {
+		ks_debug("fil_ops->scan_ind is NULL");
+		return;
+	}
+
+	cpu = kzalloc(sizeof(*cpu), GFP_KERNEL);
+	if (!cpu)
+		return;
+
+	ether_addr_copy(cpu->bssid, le->bssid);
+
+	cpu->rssi = le->rssi;
+	cpu->signal = le->signal;
+	cpu->noise = le->noise;
+	cpu->channel = le->channel;
+
+	cpu->beacon_period = le16_to_cpu(le->beacon_period);
+	cpu->capability = le16_to_cpu(le->capability);
+
+	if (le->frame_type == FIL_T_FRAME_TYPE_PROBE_RESP) {
+		cpu->type = FRAME_TYPE_PROBE_RESP;
+
+	} else if (le->frame_type == FIL_T_FRAME_TYPE_BEACON) {
+		cpu->type = FRAME_TYPE_BEACON;
+
+	} else {
+		ks_debug("frame type is not a scan indication frame");
+		return;
+	}
+
+	size = le16_to_cpu(le->body_size);
+	memcpy(cpu->body, le->body, size);
+	cpu->body_size = size;
+
+	fil_ops->scan_ind(ks, cpu);
+}
+
+static void
+_conn_ind_copy_ie(struct fil_conn_ind *cpu, struct fil_t_conn_ind *le)
+{
+	size_t size;
+
+	size = le->ies.size < IE_MAX_SIZE ? le->ies.size : IE_MAX_SIZE;
+	memcpy(cpu->ie, le->ies.body, size);
+	cpu->ie_size = size;
+}
+
+static void fil_conn_ind(struct ks7010 *ks, struct fil_t_conn_ind *le)
+{
+	struct fil_ops *fil_ops = ks->fil_ops;
+	struct fil_conn_ind cpu;
+	u16 conn_code;
+	size_t size;
+
+	if (!fil_ops->conn_ind) {
+		ks_debug("fil_ops->conn_ind is NULL");
+		return;
+	}
+
+	conn_code = le16_to_cpu(le->conn_code);
+	if (conn_code != CONN_CODE_CONNECT &&
+	    conn_code != CONN_CODE_DISCONNECT) {
+		ks_debug("conn_code invalid");
+		return;
+	}
+	cpu.code = conn_code;
+
+	ether_addr_copy(cpu.bssid, le->bssid);
+
+	cpu.rssi = le->rssi;
+	cpu.signal = le->signal;
+	cpu.noise = le->noise;
+	cpu.channel = le->ds.channel;
+
+	cpu.beacon_period = le16_to_cpu(le->beacon_period);
+	cpu.capability = le16_to_cpu(le->capability);
+
+	size = le->rates.size;
+	memcpy(cpu.rates, le->rates.body, size);
+	cpu.rates_size = size;
+
+	if (le->ext_rates.size > 0) {
+		size_t size, available;
+		u8 *ptr;
+
+		available = KS7010_RATES_MAX_SIZE - cpu.rates_size;
+		size = le->ext_rates.size;
+		if (size > available) {
+			ks_debug("ext rates don't all fit");
+			size = available;
+		}
+
+		ptr = &cpu.rates[cpu.rates_size];
+		memcpy(ptr, le->ext_rates.body, size);
+		cpu.rates_size += size;
+	}
+
+	if (le->wpa_mode == FIL_WPA_MODE_WPA) {
+		cpu.element_id = ELEMENT_ID_WPA;
+		_conn_ind_copy_ie(&cpu, le);
+	}
+
+	if (le->wpa_mode == FIL_WPA_MODE_RSN) {
+		cpu.element_id = ELEMENT_ID_RSN;
+		_conn_ind_copy_ie(&cpu, le);
+	}
+
+	fil_ops->conn_ind(ks, &cpu);
+}
+
+static void fil_assoc_ind(struct ks7010 *ks, struct fil_t_assoc_ind *le)
+{
+	struct fil_ops *fil_ops = ks->fil_ops;
+	struct fil_assoc_ind cpu;
+	u8 type;
+
+	if (!fil_ops->assoc_ind) {
+		ks_debug("fil_ops->assoc_ind is NULL");
+		return;
+	}
+
+	memset(&cpu, 0, sizeof(cpu));
+
+	type = le->req.type;
+	if (type != FIL_T_FRAME_TYPE_ASSOC_REQ &&
+	    type != FIL_T_FRAME_TYPE_REASSOC_REQ) {
+		ks_debug("assoc req frame type is invalid");
+		return;
+	}
+	cpu.req.type = type;
+
+	cpu.req.capability = le16_to_cpu(le->req.capability);
+	cpu.req.listen_interval = le16_to_cpu(le->req.listen_interval);
+	ether_addr_copy(cpu.req.ap_addr, le->req.ap_addr);
+	cpu.req.ie_size = (size_t)le16_to_cpu(le->req.ie_size);
+	cpu.req.ie = le->ies;
+
+	type = le->resp.type;
+	if (type != FIL_T_FRAME_TYPE_ASSOC_RESP &&
+	    type != FIL_T_FRAME_TYPE_REASSOC_RESP) {
+		ks_debug("assoc resp frame type is invalid");
+		return;
+	}
+	cpu.resp.type = type;
+
+	cpu.resp.capability = le16_to_cpu(le->resp.capability);
+	cpu.resp.status = le16_to_cpu(le->resp.status);
+	cpu.resp.assoc_id = le16_to_cpu(le->resp.assoc_id);
+	cpu.resp.ie_size = (size_t)le16_to_cpu(le->resp.ie_size);
+
+	cpu.resp.ie = le->ies + cpu.req.ie_size;
+
+	fil_ops->assoc_ind(ks, &cpu);
+}
+
+static void fil_data_ind(struct ks7010 *ks, struct fil_t_data_ind *le)
+{
+	struct fil_ops *fil_ops = ks->fil_ops;
+	u16 auth_type;
+	int key_index;
+	size_t frame_size;
+	size_t data_size;
+	u8 *data;
+
+	if (!fil_ops->data_ind) {
+		ks_debug("fil_ops->data_ind is NULL");
+		return;
+	}
+
+	auth_type = le16_to_cpu(le->auth_type);
+
+	if (auth_type != AUTH_TYPE_PTK &&
+	    auth_type != AUTH_TYPE_GTK1 &&
+	    auth_type != AUTH_TYPE_GTK2) {
+		ks_debug("auth type is invalid");
+		return;
+	}
+
+	key_index = auth_type - 1;
+	frame_size = le16_to_cpu(le->fhdr.size);
+	data_size = frame_size - sizeof(*le);
+	data = le->data;
+
+	fil_ops->data_ind(ks, key_index, data, data_size);
+}
+
+static void fil_event_check(struct ks7010 *ks, struct fil_t_hdr *fhdr)
+{
+	u16 event = le16_to_cpu(fhdr->event);
+
+	switch (event) {
+	case FIL_T_START_CONF:
+	case FIL_T_STOP_CONF:
+	case FIL_T_SLEEP_CONF:
+	case FIL_T_MIC_FAILURE_CONF:
+	case FIL_T_POWER_MGMT_CONF:
+	case FIL_T_INFRA_SET_CONF:
+	case FIL_T_INFRA_SET2_CONF:
+		fil_result_code_conf(ks, event,
+				     (struct fil_t_result_code_conf *)fhdr);
+		break;
+
+	case FIL_T_MIB_SET_CONF:
+		fil_mib_set_conf(ks, (struct fil_t_mib_set_conf *)fhdr);
+		break;
+
+	case FIL_T_MIB_GET_CONF:
+		fil_mib_get_conf(ks, (struct fil_t_mib_get_conf *)fhdr);
+		break;
+
+	case FIL_T_PHY_INFO_CONF:
+		fil_phy_info_conf(ks, fhdr);
+		break;
+
+	case FIL_T_PHY_INFO_IND:
+		fil_phy_info_ind(ks, (struct fil_t_phy_info_ind *)fhdr);
+		break;
+
+	case FIL_T_SCAN_CONF:
+		fil_scan_conf(ks, (struct fil_t_scan_conf *)fhdr);
+		break;
+
+	case FIL_T_SCAN_IND:
+		fil_scan_ind(ks, (struct fil_t_scan_ind *)fhdr);
+		break;
+
+	case FIL_T_CONNECT_IND:
+		fil_conn_ind(ks, (struct fil_t_conn_ind *)fhdr);
+		break;
+
+	case FIL_T_ASSOC_IND:
+		fil_assoc_ind(ks, (struct fil_t_assoc_ind *)fhdr);
+		break;
+
+	case FIL_T_DATA_IND:
+		fil_data_ind(ks, (struct fil_t_data_ind *)fhdr);
+		break;
+
+	default:
+		ks_debug("undefined MIB event: %04X\n", event);
+		break;
+	}
+}
+
+static const struct snap_hdr SNAP = {
+	.dsap = 0xAA,
+	.ssap = 0xAA,
+	.cntl = 0x03
+	/* OUI is all zero */
+};
+
+/**
+ * ks7010_fil_tx() - Build FIL tx frame.
+ * @ks: The ks7010 device.
+ * @tx: &struct fil_tx used to build the frame.
+ */
+int ks7010_fil_tx(struct ks7010 *ks, struct fil_tx *tx)
+{
+	struct fil_eth_hdr *fil_eth;
+	struct fil_t_data_req *hdr;
+	size_t max_frame_size;
+	size_t frame_size;
+	size_t size;
+	u8 *p = NULL;
+	int ret;
+
+	/* hdr->size must be updated after the frame is built */
+	max_frame_size = sizeof(*hdr) + sizeof(*fil_eth) + tx->data_size;
+
+	hdr = fil_alloc_tx_frame(max_frame_size, FIL_T_DATA_REQ);
+	if (!hdr)
+		return -ENOMEM;
+
+	frame_size = 0;
+	p = hdr->data;
+
+	ether_addr_copy(p, tx->da);
+	frame_size += ETH_ALEN;
+	p += ETH_ALEN;
+
+	ether_addr_copy(p, tx->sa);
+	frame_size += ETH_ALEN;
+	p += ETH_ALEN;
+
+	if (tx->add_snap_hdr_to_frame) {
+		const struct snap_hdr *snap = &SNAP;
+
+		size = sizeof(*snap);
+		memcpy(p, snap, size);
+		frame_size += size;
+		p += size;
+	}
+
+	if (tx->add_protocol_to_frame) {
+		__be16 h_proto = htons(tx->proto);
+
+		size = sizeof(h_proto);
+		memcpy(p, &h_proto, size);
+		frame_size += size;
+		p += size;
+	}
+
+	memcpy(p, tx->data, tx->data_size);
+	frame_size += tx->data_size;
+
+	if (tx->type == TX_TYPE_AUTH)
+		hdr->type = cpu_to_le16((u16)FIL_T_DATA_REQ_TYPE_AUTH);
+	else
+		hdr->type = cpu_to_le16((u16)FIL_T_DATA_REQ_TYPE_DATA);
+
+	/* update hif_hdr size now we know the final packet size */
+	hdr->fhdr.size = tx_frame_size_to_fil_t_hdr_size(frame_size);
+
+	ret = fil_tx_skb(ks, hdr, frame_size, tx->skb);
+	if (ret)
+		goto free_hdr;
+
+	return 0;
+
+free_hdr:
+	kfree(hdr);
+	return ret;
+}
+
+/**
+ * ks7010_fil_rx() - FIL response to an rx event.
+ * @ks: The ks7010 device.
+ * @data: The rx data.
+ * @data_size: Size of data.
+ *
+ * Called by the rx interrupt bottom half to respond to an rx event.
+ */
+int ks7010_fil_rx(struct ks7010 *ks, u8 *data, size_t data_size)
+{
+	struct fil_t_hdr *fhdr;
+	u16 size;
+
+	fhdr = (struct fil_t_hdr *)data;
+	size = le16_to_cpu(fhdr->size);
+
+	if (data_size != size) {
+		ks_debug("rx size mismatch");
+		return -EINVAL;
+	}
+
+	fil_event_check(ks, fhdr);
+
+	return 0;
+}
diff --git a/drivers/staging/ks7010/fil.h b/drivers/staging/ks7010/fil.h
new file mode 100644
index 0000000..c89c9af
--- /dev/null
+++ b/drivers/staging/ks7010/fil.h
@@ -0,0 +1,527 @@
+#ifndef _KS7010_FIL_H
+#define _KS7010_FIL_H
+
+#include <linux/compiler.h>
+#include <linux/skbuff.h>
+#include <linux/ieee80211.h>
+#include <linux/skbuff.h>
+
+#include "common.h"
+
+/**
+ * fil_nw_type - Network type
+ * @NW_TYPE_INFRA: Infrastructure networks.
+ * @NW_TYPE_ADHOC: Not implemented.
+ */
+enum fil_nw_type {
+	NW_TYPE_INFRA,
+	/* No other network types implemented yet */
+	NW_TYPE_ADHOC
+};
+
+/**
+ * enum fil_wpa_mode - Wi-Fi Protected Access modes.
+ * @FIL_WPA_MODE_NONE: WPA not enabled.
+ * @FIL_WPA_MODE_WPA: WPA version 1.
+ * @FIL_WPA_MODE_RSN: WPA version 2.
+ */
+enum fil_wpa_mode {
+	FIL_WPA_MODE_NONE = 0,
+	FIL_WPA_MODE_WPA,
+	FIL_WPA_MODE_RSN
+};
+
+/**
+ * enum fil_scan_type - Scan type.
+ * @FIL_SCAN_TYPE_ACTIVE: Use probe request frames it identify networks.
+ * @FIL_SCAN_TYPE_PASSIVE: Identify networks by listening for beacons.
+ */
+enum fil_scan_type {
+	FIL_SCAN_TYPE_ACTIVE = 0,
+	FIL_SCAN_TYPE_PASSIVE
+};
+
+/**
+ * struct fil_scan - Data required to initiate a scan.
+ * @scan_type: &enum fil_scan_type
+ * @ssid: SSID to scan.
+ * @ssid_size: Size of SSID.
+ * @channels: List of channels to scan.
+ * @channels_size: Size (number) of channels in list.
+ */
+struct fil_scan {
+	enum fil_scan_type scan_type;
+	u8 *ssid;
+	size_t ssid_size;
+	u8 *channels;
+	size_t channels_size;
+};
+
+/* FIXME 802.11g is backward compatible with b? */
+enum fil_phy_type {
+	FIL_PYH_TYPE_11B_ONLY = 0,
+	FIL_PYH_TYPE_11G_ONLY,
+	FIL_PYH_TYPE_11BG_COMPATIBLE,
+};
+
+/**
+ * enum fil_cts_mode - Clear to send mode
+ * @FIL_CTS_MODE_FALSE: TODO document this
+ * @FIL_CTS_MODE_TRUE: TODO document this
+ */
+enum fil_cts_mode {
+	FIL_CTS_MODE_FALSE = 0,
+	FIL_CTS_MODE_TRUE
+};
+
+/**
+ * enum fil_dot11_auth_type - 802.11 Authentication.
+ * @FIL_DOT11_AUTH_TYPE_OPEN_SYSTEM: Open system authentication.
+ * @FIL_DOT11_AUTH_TYPE_SHARED_KEY: Shared key authentication.
+ */
+enum fil_dot11_auth_type {
+	FIL_DOT11_AUTH_TYPE_OPEN_SYSTEM = 0,
+	FIL_DOT11_AUTH_TYPE_SHARED_KEY
+};
+
+/**
+ * enum fil_bss_capability_flags - Basic service set capabilities.
+ * @BSS_CAP_ESS: Extended service set (mutually exclusive with IBSS).
+ * @BSS_CAP_IBSS: Independent service set (mutually exclusive with ESS).
+ * @BSS_CAP_CF_POLABLE: Contention free polling bits.
+ * @BSS_CAP_CF_POLL_REQ: Contention free polling bits.
+ * @BSS_CAP_PRIVACY: Privacy, bit set indicates WEP required.
+ * @BSS_CAP_SHORT_PREAMBLE: Bit on for short preamble. 802.11g always
+ *	uses short preamble.
+ * @BSS_CAP_PBCC: Packet binary convolution coding modulation scheme.
+ * @BSS_CAP_CHANNEL_AGILITY: Bit on for channel agility.
+ * @BSS_CAP_SHORT_SLOT_TIME: Short slot time (802.11g).
+ * @BSS_CAP_DSSS_OFDM: DSSS-OFDM frame construction (802.11g).
+ */
+enum fil_bss_capability_flags {
+	BSS_CAP_ESS             = 0,
+	BSS_CAP_IBSS            = 1,
+	BSS_CAP_CF_POLABLE      = 2,
+	BSS_CAP_CF_POLL_REQ     = 3,
+	BSS_CAP_PRIVACY         = 4,
+	BSS_CAP_SHORT_PREAMBLE  = 5,
+	BSS_CAP_PBCC            = 6,
+	BSS_CAP_CHANNEL_AGILITY = 7,
+	BSS_CAP_SHORT_SLOT_TIME = 10,
+	BSS_CAP_DSSS_OFDM       = 13
+};
+
+/**
+ * struct fil_set_infra - Data required to set network type to infrastructure.
+ * @phy_type: &enum fil_phy_type
+ * @cts_mode: &enum fil_cts_mode
+ * @scan_type: &enum fil_scan_type
+ * @auth_type: &enum fil_dot11_auth_type
+ * @capability: Network capability flags, &enum fil_bss_capability_flags.
+ * @beacon_lost_count: TODO document this
+ * @rates: Operational rates list.
+ * @rates_size: Size of rates list.
+ * @ssid: Service set identifier.
+ * @ssid_size: Size of SSID.
+ * @channels: Channel list.
+ * @channels_size: Size of channel list.
+ * @bssid: Basic service set identifier.
+ */
+struct fil_set_infra {
+	enum fil_phy_type phy_type;
+	enum fil_cts_mode cts_mode;
+	enum fil_scan_type scan_type;
+	enum fil_dot11_auth_type auth_type;
+
+	u16 capability;
+	u16 beacon_lost_count;
+
+	u8 *rates;
+	size_t rates_size;
+
+	u8 *ssid;
+	size_t ssid_size;
+
+	u8 *channels;
+	size_t channels_size;
+
+	u8 *bssid;
+};
+
+/**
+ * struct fil_power_mgmt - Data for device power management.
+ * @ps_enable: Enable power save.
+ * @wake_up: TODO verify what this does (see comment in fil_types.h).
+ * @receive_dtims: Periodically wake up to receive DTIM's.
+ */
+struct fil_power_mgmt {
+	bool ps_enable;
+	bool wake_up;
+	bool receive_dtims;
+};
+
+/**
+ * struct fil_gain - TODO document this
+ */
+struct fil_gain {
+	u8 tx_mode;
+	u8 rx_mode;
+	u8 tx_gain;
+	u8 rx_gain;
+};
+
+/**
+ * struct fil_t_mic_failure_req - Michael MIC failure event frame.
+ * @fhdr: &struct fil_t_hdr
+ * @count: Notify firmware that this is failure number @count.
+ * @timer: Number of jiffies since the last failure.
+ *
+ * Michael Message Integrity Check must be done by the driver, in the
+ * event of a failure use this frame type to notify the firmware of
+ * the failure.
+ */
+struct fil_mic_failure {
+	u16 count;
+	u16 timer;
+};
+
+/* TODO document fil_phy_info (same as fil_t_phy_info_ind) */
+
+/**
+ * struct fil_phy_info - PHY information.
+ * @rssi: Received signal strength indication.
+ * @signal:
+ * @noise:
+ * @link_speed:
+ * @tx_frame:
+ * @rx_frame:
+ * @tx_error:
+ * @rx_error:
+ */
+struct fil_phy_info {
+	u8 rssi;
+	u8 signal;
+	u8 noise;
+	u8 link_speed;
+	u32 tx_frame;
+	u32 rx_frame;
+	u32 tx_error;
+	u32 rx_error;
+};
+
+/**
+ * enum frame_type - Scan response frame type.
+ * @FRAME_TYPE_PROBE_RESP: Frame returned in response to a probe
+ *	request (active scan).
+ * @FRAME_TYPE_BEACON: Frame beacon type.
+ */
+enum frame_type {
+	FRAME_TYPE_PROBE_RESP,
+	FRAME_TYPE_BEACON
+};
+
+#define FIL_AP_INFO_MAX_SIZE	1024
+
+/**
+ * struct fil_scan_ind - Data received from firmware after scan completes.
+ * @bssid: Basic service set identifier.
+ * @rssi: Received signal strength indication.
+ * @signal: TODO document this
+ * @noise: TODO document this
+ * @channel: Channel for scanned network.
+ * @beacon_period: Beacon period (interval) in time units.
+ * @capability: Network capability flags, &enum fil_bss_capability_flags.
+ * @type: Probe response or beacon, &enum frame_type.
+ * @body_size: Size of @body in octets.
+ * @body: Scan indication data, made up of consecutive &struct fil_ap_info.
+ */
+struct fil_scan_ind {
+	u8 bssid[ETH_ALEN];
+	u8 rssi;
+	u8 signal;
+	u8 noise;
+	u8 channel;
+	u16 beacon_period;
+	u16 capability;
+	enum frame_type type;
+
+	size_t body_size;
+	u8 body[FIL_AP_INFO_MAX_SIZE];
+};
+
+/**
+ * struct fil_ap_info - Information element.
+ * @element_id: Information element identifier.
+ * @data_size: Size if IE
+ * @data: IE data.
+ */
+struct fil_ap_info {
+	u8 element_id;
+	u8 data_size;
+	u8 data[0];
+};
+
+/*
+ * FIXME these are constants define by 802.11, does the kernel
+ * define these already?
+ */
+enum element_id {
+	ELEMENT_ID_RSN	= 0x30,
+	ELEMENT_ID_WPA	= 0xdd
+};
+
+/**
+ * enum conn_code - Connection code type.
+ * @CONN_CODE_CONNECT: Connection.
+ * @CONN_CODE_DISCONNECT: Disconnection.
+ */
+enum conn_code {
+	CONN_CODE_CONNECT = 0,
+	CONN_CODE_DISCONNECT,
+};
+
+#define KS7010_RATES_MAX_SIZE	16
+#define KS7010_IE_MAX_SIZE	128
+
+/**
+ * struct fil_conn_ind - Data received from firmware on connection.
+ * @bssid: Basic service set identifier.
+ * @rssi: Received signal strength indication.
+ * @signal: TODO document this
+ * @noise: TODO document this
+ * @channel: Network channel.
+ * @beacon_period: Beacon period (interval) in time units.
+ * @capability: Network capability flags, &enum fil_bss_capability_flags.
+ * @rates_size: Size of rate set.
+ * @rates: List of rates supported by connected network.
+ * @element_id: IE identifier.
+ * @ie_size: Size of data in IE's.
+ * @ie: Information elements.
+ */
+struct fil_conn_ind {
+	enum conn_code code;
+	u8 bssid[ETH_ALEN];
+	u8 rssi;
+	u8 signal;
+	u8 noise;
+	u8 channel;
+
+	u16 beacon_period;
+	u16 capability;
+
+	u8 rates_size;
+	u8 rates[KS7010_RATES_MAX_SIZE];
+
+	enum element_id element_id;
+	size_t ie_size;
+	u8 ie[KS7010_IE_MAX_SIZE];
+};
+
+/**
+ * enum assoc_type -
+ * @ASSOC_TYPE_ASSOC: Association type.
+ * @ASSOC_TYPE_REASSOC: Re-association type.
+ */
+enum assoc_type {
+	ASSOC_TYPE_ASSOC,
+	ASSOC_TYPE_REASSOC
+};
+
+/**
+ * struct fil_assoc_ind_req_info - Association request information.
+ * @type: &enum assoc_type
+ * @capability: Network capability flags, &enum fil_bss_capability_flags.
+ * @listen_interval: Listen interval.
+ * @ap_addr: Current access point MAC address.
+ * @ie_size: Number of octets in IE.
+ * @ie: Information elements.
+ */
+struct fil_assoc_ind_req_info {
+	enum assoc_type type;
+	u16 capability;
+	u16 listen_interval;
+	u8 ap_addr[ETH_ALEN];
+	size_t ie_size;
+	u8 *ie;
+};
+
+/**
+ * struct fil_assoc_ind_resp_info - Association response information.
+ * @type: &enum assoc_type
+ * @capability: Network capability flags, &enum fil_bss_capability_flags.
+ * @status: TODO unknown.
+ * @assoc_id: Association identifier.
+ * @ie_size: Number of octets in IE.
+ * @ie: Information elements.
+ */
+struct fil_assoc_ind_resp_info {
+	enum assoc_type type;
+	u16 capability;
+	u16 status;
+	u16 assoc_id;
+	size_t ie_size;
+	u8 *ie;
+};
+
+/**
+ * struct fil_assoc_ind - Data received from firmware on association.
+ * @req: &struct fil_assoc_ind_req
+ * @resp: &struct fil_assoc_ind_resp
+ */
+struct fil_assoc_ind {
+	struct fil_assoc_ind_req_info req;
+	struct fil_assoc_ind_resp_info resp;
+};
+
+/**
+ * enum fil_tx_type - Tx frame type.
+ * @TX_TYPE_AUTH: Authentication frame type.
+ * @TX_TYPE_DATA: Data frame type.
+ */
+enum fil_tx_type {
+	TX_TYPE_AUTH,
+	TX_TYPE_DATA
+};
+
+/**
+ * struct fil_tx - Data required to initiate a transmission.
+ * @da: Destination MAC address.
+ * @sa: Source MAC address.
+ * @proto: Ethernet protocol.
+ * @add_snap_hdr_to_frame: True if frame should include LLC and SNAP headers.
+ * @add_protocol_to_frame: True if frame should include the protocol.
+ * @type: Authentication/data frame, &enum fil_tx_type.
+ * @data: Frame data.
+ * @data_size: Frame data size.
+ * @skb: Pointer to the sk_buff passed down from networking stack.
+ */
+struct fil_tx {
+	u8 *da;
+	u8 *sa;
+	u16 proto;
+	bool add_snap_hdr_to_frame;
+	bool add_protocol_to_frame;
+	enum fil_tx_type type;
+	u8 *data;
+	size_t data_size;
+	struct sk_buff *skb;
+};
+
+/**
+ * struct fil_ops - Firmware Interface Layer callbacks.
+ * @start_conf: Confirmation of ks7010_fil_start().
+ */
+struct fil_ops {
+	void (*start_conf)(struct ks7010 *ks, u16 result_code);
+	void (*stop_conf)(struct ks7010 *ks, u16 result_code);
+	void (*sleep_conf)(struct ks7010 *ks, u16 result_code);
+	void (*mic_failure_conf)(struct ks7010 *ks, u16 result_code);
+	void (*set_power_mgmt_conf)(struct ks7010 *ks, u16 result_code);
+	void (*set_infra_conf)(struct ks7010 *ks, u16 result_code);
+	void (*set_infra_bssid_conf)(struct ks7010 *ks, u16 result_code);
+
+	void (*set_mac_addr_conf)(struct ks7010 *ks);
+	void (*set_mcast_addresses_conf)(struct ks7010 *ks);
+	void (*mcast_filter_enable_conf)(struct ks7010 *ks);
+	void (*privacy_invoked_conf)(struct ks7010 *ks);
+	void (*set_default_key_index_conf)(struct ks7010 *ks);
+	void (*set_key_1_conf)(struct ks7010 *ks);
+	void (*set_key_2_conf)(struct ks7010 *ks);
+	void (*set_key_3_conf)(struct ks7010 *ks);
+	void (*set_key_4_conf)(struct ks7010 *ks);
+	void (*set_wpa_enable_conf)(struct ks7010 *ks);
+	void (*set_wpa_mode_conf)(struct ks7010 *ks);
+	void (*set_wpa_ucast_suite_conf)(struct ks7010 *ks);
+	void (*set_wpa_mcast_suite_conf)(struct ks7010 *ks);
+	void (*set_wpa_key_mgmt_suite_conf)(struct ks7010 *ks);
+	void (*set_ptk_tsc_conf)(struct ks7010 *ks);
+	void (*set_gtk_1_tsc_conf)(struct ks7010 *ks);
+	void (*set_gtk_2_tsc_conf)(struct ks7010 *ks);
+	void (*set_pmk_conf)(struct ks7010 *ks); /* TODO */
+	void (*set_region_conf)(struct ks7010 *ks);
+	void (*set_rts_thresh_conf)(struct ks7010 *ks);
+	void (*set_frag_thresh_conf)(struct ks7010 *ks);
+	void (*set_gain_conf)(struct ks7010 *ks);
+
+	void (*get_mac_addr_conf)(struct ks7010 *ks, u8 *data, u16 size);
+	void (*get_fw_version_conf)(struct ks7010 *ks, u8 *data, u16 size);
+	void (*get_eeprom_cksum_conf)(struct ks7010 *ks, u8 *data, u16 size);
+	void (*get_rts_thresh_conf)(struct ks7010 *ks, u8 *data, u16 size);
+	void (*get_frag_thresh_conf)(struct ks7010 *ks, u8 *data, u16 size);
+	void (*get_gain_conf)(struct ks7010 *ks, u8 *data, u16 size);
+
+	void (*get_phy_info_ind)(struct ks7010 *ks, struct fil_phy_info *ind);
+
+	void (*scan_conf)(struct ks7010 *ks, u16 result_code);
+
+	void (*scan_ind)(struct ks7010 *ks, struct fil_scan_ind *ind);
+
+	/* FIXME understand how connection and association are initiated */
+	void (*conn_ind)(struct ks7010 *ks, struct fil_conn_ind *ind);
+	void (*assoc_ind)(struct ks7010 *ks, struct fil_assoc_ind *ind);
+
+	void (*data_ind)(struct ks7010 *ks, int key_index,
+			 u8 *data, size_t data_size);
+};
+
+void ks7010_fil_start(struct ks7010 *ks, enum fil_nw_type type);
+void ks7010_fil_stop(struct ks7010 *ks);
+void ks7010_fil_sleep(struct ks7010 *ks);
+
+void ks7010_fil_mic_failure(struct ks7010 *ks, struct fil_mic_failure *req);
+
+void ks7010_fil_set_power_mgmt(struct ks7010 *ks, struct fil_power_mgmt *req);
+
+void ks7010_fil_set_infra(struct ks7010 *ks, struct fil_set_infra *req);
+void ks7010_fil_set_infra_bssid(struct ks7010 *ks,
+				struct fil_set_infra *req, u8 *bssid);
+
+void ks7010_fil_set_mac_addr(struct ks7010 *ks, u8 *addr);
+void ks7010_fil_set_mcast_addresses(struct ks7010 *ks,
+				    u8 *addresses, int num_addresses);
+void ks7010_fil_mcast_filter_enable(struct ks7010 *ks, bool enable);
+
+void ks7010_fil_privacy_invoked(struct ks7010 *ks, bool enable);
+void ks7010_fil_set_default_key_index(struct ks7010 *ks, int index);
+
+void ks7010_fil_set_key_1(struct ks7010 *ks, u8 *key, size_t key_size);
+void ks7010_fil_set_key_2(struct ks7010 *ks, u8 *key, size_t key_size);
+void ks7010_fil_set_key_3(struct ks7010 *ks, u8 *key, size_t key_size);
+void ks7010_fil_set_key_4(struct ks7010 *ks, u8 *key, size_t key_size);
+
+void ks7010_fil_wpa_enable(struct ks7010 *ks, bool enable);
+void ks7010_fil_set_wpa_mode(struct ks7010 *ks, enum fil_wpa_mode mode);
+
+void ks7010_fil_set_wpa_ucast_suite(struct ks7010 *ks, u8 *cipher,
+				    size_t cipher_size);
+void ks7010_fil_set_wpa_mcast_suite(struct ks7010 *ks, u8 *cipher,
+				    size_t cipher_size);
+void ks7010_fil_set_wpa_key_mgmt_suite(struct ks7010 *ks, u8 *cipher,
+				       size_t cipher_size);
+
+void ks7010_fil_set_ptk_tsc(struct ks7010 *ks, u8 *seq, size_t seq_size);
+void ks7010_fil_set_gtk_1_tsc(struct ks7010 *ks, u8 *seq, size_t seq_size);
+void ks7010_fil_set_gtk_2_tsc(struct ks7010 *ks, u8 *seq, size_t seq_size);
+
+void ks7010_set_pmk(struct ks7010 *ks); /* TODO */
+
+void ks7010_fil_set_region(struct ks7010 *ks, u32 region);
+void ks7010_fil_set_rts_thresh(struct ks7010 *ks, u32 thresh);
+void ks7010_fil_set_frag_thresh(struct ks7010 *ks, u32 thresh);
+void ks7010_fil_set_gain(struct ks7010 *ks, struct fil_gain *gain);
+
+void ks7010_fil_get_mac_addr(struct ks7010 *ks);
+void ks7010_fil_get_fw_version(struct ks7010 *ks);
+void ks7010_fil_get_eeprom_cksum(struct ks7010 *ks);
+
+void ks7010_fil_get_rts_thresh(struct ks7010 *ks);
+void ks7010_fil_get_frag_thresh(struct ks7010 *ks);
+void ks7010_fil_get_gain(struct ks7010 *ks);
+
+void ks7010_fil_get_phy_info(struct ks7010 *ks, u16 timer);
+void ks7010_fil_scan(struct ks7010 *ks, struct fil_scan *req);
+
+int ks7010_fil_tx(struct ks7010 *ks, struct fil_tx *tx);
+int ks7010_fil_rx(struct ks7010 *ks, u8 *data, size_t data_size);
+
+#endif	/* _KS7010_FIL_H */
diff --git a/drivers/staging/ks7010/fil_types.h b/drivers/staging/ks7010/fil_types.h
new file mode 100644
index 0000000..29be976
--- /dev/null
+++ b/drivers/staging/ks7010/fil_types.h
@@ -0,0 +1,845 @@
+/**
+ * DOC: Internal types for the Firmware Interface Layer.
+ */
+
+#define KS7010_SDIO_ALIGN 32
+
+/**
+ * fil_align_size() - Device alignment.
+ * @size: size to align.
+ */
+static inline size_t fil_align_size(size_t size)
+{
+	if (size % KS7010_SDIO_ALIGN)
+		return size + KS7010_SDIO_ALIGN - (size % KS7010_SDIO_ALIGN);
+
+	return size;
+}
+
+/**
+ * struct fil_t_hdr - Firmware Interface Layer header.
+ *
+ * @size: Value is tx/rx dependent.
+ * @event: &enum fil_t_event
+ *
+ * Do not access size manually, use helper functions.
+ * tx_fil_hdr_to_frame_size()
+ * tx_frame_size_to_fil_hdr_size()
+ * rx_fil_hdr_to_frame_size()
+ * rx_frame_size_to_fil_hdr_size()
+ */
+struct fil_t_hdr {
+	__le16 size;
+	__le16 event;
+} __packed;
+
+/**
+ * enum fil_t_event - Host interface events
+ *
+ * Events include;
+ *  - get/set requests, i.e commands to the target.
+ *  - confirmation and indication events.
+ *
+ * @FIL_T_MIB_SET_REQ: Management Information Base set request.
+ * @FIL_T_MIB_GET_REQ: Management Information Base get request.
+ */
+enum fil_t_event {
+	FIL_T_DATA_REQ		= 0xE001,
+	FIL_T_MIB_GET_REQ	= 0xE002,
+	FIL_T_MIB_SET_REQ	= 0xE003,
+	FIL_T_POWER_MGMT_REQ	= 0xE004,
+	FIL_T_START_REQ		= 0xE005,
+	FIL_T_STOP_REQ		= 0xE006,
+	/* FIL_T_PS_ADH_SET_REQ	= 0xE007, */
+	FIL_T_INFRA_SET_REQ	= 0xE008,
+	/* FIL_T_ADH_SET_REQ	= 0xE009, */
+	/* FIL_T_ADH_SET2_REQ	= 0xE010, */
+	/* FIL_T_AP_SET_REQ	= 0xE00A, */
+	FIL_T_MIC_FAILURE_REQ	= 0xE00B,
+	FIL_T_SCAN_REQ		= 0xE00C,
+	FIL_T_PHY_INFO_REQ	= 0xE00D,
+	FIL_T_SLEEP_REQ		= 0xE00E,
+	FIL_T_INFRA_SET2_REQ	= 0xE00F,
+
+	FIL_T_REQ_MAX		= 0xE010,
+
+	FIL_T_DATA_IND		= 0xE801,
+	FIL_T_MIB_GET_CONF	= 0xE802,
+	FIL_T_MIB_SET_CONF	= 0xE803,
+	FIL_T_POWER_MGMT_CONF	= 0xE804,
+	FIL_T_START_CONF	= 0xE805,
+	FIL_T_CONNECT_IND	= 0xE806,
+	FIL_T_STOP_CONF		= 0xE807,
+	/* FIL_T_PS_ADH_SET_CONF= 0xE808, */
+	FIL_T_INFRA_SET_CONF	= 0xE809,
+	/* FIL_T_ADH_SET_CONF	= 0xE80A, */
+	/* FIL_T_AP_SET_CONF	= 0xE80B, */
+	FIL_T_ASSOC_IND		= 0xE80C,
+	FIL_T_MIC_FAILURE_CONF	= 0xE80D,
+	FIL_T_SCAN_CONF		= 0xE80E,
+	FIL_T_PHY_INFO_CONF	= 0xE80F,
+	FIL_T_SLEEP_CONF	= 0xE810,
+	FIL_T_PHY_INFO_IND	= 0xE811,
+	FIL_T_SCAN_IND		= 0xE812,
+	FIL_T_INFRA_SET2_CONF	= 0xE813,
+	/* FIL_T_ADH_SET2_CONF	= 0xE814, */
+};
+
+/**
+ * struct fil_t_mib_get_req - Management Information Base get request frame.
+ * @fhdr: &struct fil_t_hdr.
+ * @attribute: &enum mib_attribute
+ */
+struct fil_t_mib_get_req {
+	struct fil_t_hdr fhdr;
+	__le32 attribute;
+} __packed;
+
+/**
+ * struct fil_t_mib_set_req - Management Information Base set request frame.
+ * @fhdr: &struct fil_t_hdr.
+ * @attribute: &enum mib_attribute
+ * @data_size: Size of data in octets.
+ * @type: &enum mib_data_type.
+ * @data: MIB request data.
+ */
+struct fil_t_mib_set_req {
+	struct fil_t_hdr fhdr;
+	__le32 attribute;
+	__le16 data_size;
+	__le16 data_type;
+	u8 data[0];
+} __packed;
+
+/**
+ * enum mib_attribute - Management Information Base attribute.
+ *
+ * Attribute value used for accessing and updating the
+ * Management Information Base, set/get req/ind.
+ *
+ * R is read only.
+ * W is write only.
+ * R/W is read and write.
+ *
+ * @DOT11_MAC_ADDRESS: MAC Address (R)
+ * @DOT11_PRODUCT_VERSION: FirmWare Version (R)
+ * @LOCAL_EEPROM_SUM: EEPROM checksum information (R)
+ *
+ * @LOCAL_CURRENT_ADDRESS: MAC Address change (W)
+ *
+ * @LOCAL_MULTICAST_ADDRESS: Multicast address (W)
+ * @LOCAL_MULTICAST_FILTER: Multicast filter enable/disable (W)
+ *
+ * @DOT11_PRIVACY_INVOKED: Use encryption (WEP/WPA/RSN)
+ *
+ * @MIB_DEFAULT_KEY_INDEX: WEP key index or WPA txkey (W)
+ * @MIB_KEY_VALUE_1: WEP Key 1 or TKIP/CCMP PTK (W)
+ * @MIB_KEY_VALUE_2: WEP Key 2 or TKIP/CCMP GTK 1 (W)
+ * @MIB_KEY_VALUE_3: WEP Key 3 or TKIP/CCMP GTK 2 (W)
+ * @MIB_KEY_VALUE_4: WEP Key 4 (not currently used for TKIP/CCMP) (W)
+
+ * @MIB_WPA_ENABLE: WPA/RSN enable/disable (W)
+ * @MIB_WPA_MODE: WPA or RSN (W)
+ * @MIB_WPA_CONFIG_UCAST_SUITE: Pairwise key cipher suite (W)
+ * @MIB_WPA_CONFIG_MCAST_SUITE: Group key cipher suite (W)
+ * @MIB_WPA_CONFIG_AUTH_SUITE: Authentication key management suite (W)
+ * @MIB_PTK_TSC: PTK sequence counter (W)
+ * @MIB_GTK_1_TSC: GTK 1 sequence counter (W)
+ * @MIB_GTK_2_TSC: GTK 2 sequence counter (W)
+ *
+ * @LOCAL_PMK: Pairwise Master Key cache (W)
+ *
+ * @LOCAL_REGION: Region setting (W)
+ *
+ * @DOT11_RTS_THRESHOLD: Request To Send Threshold (R/W)
+ * @DOT11_FRAGMENTATION_THRESHOLD: Fragment Threshold (R/W)
+ * @LOCAL_GAIN: Carrier sense threshold for demo ato show (R/W)
+ *
+ * @DOT11_WEP_LIST:
+ * @DOT11_DESIRED_SSID:
+ * @DOT11_CURRENT_CHANNEL:
+ * @DOT11_OPERATION_RATE_SET:
+ * @LOCAL_AP_SEARCH_INTEAVAL:
+ * @LOCAL_SEARCHED_AP_LIST:
+ * @LOCAL_LINK_AP_STATUS:
+ * @LOCAL_PACKET_STATISTICS:
+ * @LOCAL_AP_SCAN_LIST_TYPE_SET:
+ * @DOT11_RSN_CONFIG_VERSION:
+ * @LOCAL_RSN_CONFIG_ALL:
+ * @DOT11_GMK3_TSC:
+ */
+enum mib_attribute {
+	DOT11_MAC_ADDRESS		= 0x21010100,
+	DOT11_PRODUCT_VERSION		= 0x31024100,
+	LOCAL_EEPROM_SUM		= 0xF10E0100,
+
+	LOCAL_CURRENT_ADDRESS		= 0xF1050100,
+
+	LOCAL_MULTICAST_ADDRESS		= 0xF1060100,
+	LOCAL_MULTICAST_FILTER		= 0xF1060200,
+
+	DOT11_PRIVACY_INVOKED		= 0x15010100,
+	MIB_DEFAULT_KEY_INDEX		= 0x15020100,
+
+	MIB_KEY_VALUE_1			= 0x13020101,
+	MIB_KEY_VALUE_2			= 0x13020102,
+	MIB_KEY_VALUE_3			= 0x13020103,
+	MIB_KEY_VALUE_4			= 0x13020104,
+
+	MIB_WPA_ENABLE			= 0x15070100,
+	MIB_WPA_MODE			= 0x56010100,
+	MIB_WPA_CONFIG_UCAST_SUITE	= 0x52020100,
+	MIB_WPA_CONFIG_MCAST_SUITE	= 0x51040100,
+	MIB_WPA_CONFIG_AUTH_SUITE	= 0x53020100,
+
+	MIB_PTK_TSC			= 0x55010100,
+	MIB_GTK_1_TSC			= 0x55010101,
+	MIB_GTK_2_TSC			= 0x55010102,
+
+	LOCAL_PMK			= 0x58010100,
+
+	LOCAL_REGION			= 0xF10A0100,
+
+	DOT11_RTS_THRESHOLD		= 0x21020100,
+	DOT11_FRAGMENTATION_THRESHOLD	= 0x21050100,
+	LOCAL_GAIN			= 0xF10D0100,
+
+	 /* unused */
+	DOT11_WEP_LIST			= 0x13020100,
+	DOT11_RSN_CONFIG_VERSION	= 0x51020100,
+	LOCAL_RSN_CONFIG_ALL		= 0x5F010100,
+	DOT11_DESIRED_SSID		= 0x11090100,
+	DOT11_CURRENT_CHANNEL		= 0x45010100,
+	DOT11_OPERATION_RATE_SET	= 0x11110100,
+	LOCAL_AP_SEARCH_INTEAVAL	= 0xF1010100,
+	LOCAL_SEARCHED_AP_LIST		= 0xF1030100,
+	LOCAL_LINK_AP_STATUS		= 0xF1040100,
+	LOCAL_PACKET_STATISTICS		= 0xF1020100,
+	LOCAL_AP_SCAN_LIST_TYPE_SET	= 0xF1030200,
+	DOT11_GMK3_TSC                  = 0x55010103
+};
+
+/**
+ * enum mib_type - Message Information Base data type.
+ * @FIL_T_MIB_TYPE_NULL: Null type
+ * @FIL_T_MIB_TYPE_INT: Integer type
+ * @FIL_T_MIB_TYPE_BOOL: Boolean type
+ * @FIL_T_MIB_TYPE_COUNT32: unused
+ * @FIL_T_MIB_TYPE_OSTRING: Memory chunk
+ */
+enum mib_data_type {
+	FIL_T_MIB_TYPE_NULL = 0,
+	FIL_T_MIB_TYPE_INT,
+	FIL_T_MIB_TYPE_BOOL,
+	FIL_T_MIB_TYPE_COUNT32,
+	FIL_T_MIB_TYPE_OSTRING,
+};
+
+/**
+ * struct fil_t_phy_info_req - PHY information request frame.
+ * @fhdr: &struct fil_t_hdr
+ * @type: &enum fil_t_phy_info_type
+ * @time: unit 100ms
+ */
+struct fil_t_phy_info_req {
+	struct fil_t_hdr fhdr;
+	__le16 type;
+	__le16 time;
+} __packed;
+
+/**
+ * enum fil_t_phy_info_type - TODO document this enum
+ * @FIL_T_PHY_INFO_TYPE_NORMAL:
+ * @FIL_T_PHY_INFO_TYPE_TIME:
+ */
+enum fil_t_phy_info_type {
+	FIL_T_PHY_INFO_TYPE_NORMAL = 0,
+	FIL_T_PHY_INFO_TYPE_TIME,
+};
+
+/**
+ * struct fil_t_start_req - Start request frame.
+ * @fhdr: &struct fil_t_hdr
+ * @nw_type: &enum fil_t_nw_type
+ */
+struct fil_t_start_req {
+	struct fil_t_hdr fhdr;
+	__le16 nw_type;
+} __packed;
+
+/**
+ * enum fil_t_nw_type - Network type.
+ * @FIL_T_NW_TYPE_PSEUDO_ADHOC: Pseudo adhoc mode.
+ * @FIL_T_NW_TYPE_INFRASTRUCTURE: Infrastructure mode.
+ * @FIL_T_NW_TYPE_AP: Access point mode, not supported.
+ * @FIL_T_NW_TYPE_ADHOC: Adhoc mode.
+ */
+enum fil_t_nw_type {
+	FIL_T_NW_TYPE_PSEUDO_ADHOC = 0,
+	FIL_T_NW_TYPE_INFRASTRUCTURE,
+	FIL_T_NW_TYPE_AP,
+	FIL_T_NW_TYPE_ADHOC
+};
+
+/**
+ * struct fil_t_power_mgmt_req - Power management request frame.
+ * @fhdr: &struct fil_t_hdr
+ * @mode: enum fil_t_power_mgmt_mode
+ * @wake_up: enum fil_t_power_mgmt_wake_up
+ * @receive_dtims: enum fil_t_power_mgmt_receive_dtims
+ */
+struct fil_t_power_mgmt_req {
+	struct fil_t_hdr fhdr;
+	__le32 mode;
+	__le32 wake_up;
+	__le32 receive_dtims;
+} __packed;
+
+/**
+ * enum fil_t_power_mgmt_mode - Power management mode.
+ * @FIL_T_POWER_MGMT_MODE_ACTIVE: Disable power management, device
+ *	may not sleep.
+ * @FIL_T_POWER_MGMT_MODE_SAVE: Enable power management, used for
+ *	'sleep' mode and 'deep sleep' mode.
+ */
+enum fil_t_power_mgmt_mode {
+	FIL_T_POWER_MGMT_MODE_ACTIVE = 1,
+	FIL_T_POWER_MGMT_MODE_SAVE
+};
+
+/**
+ * enum fil_t_power_mgmt_wake_up - Wake up the device if it is asleep.
+ * @FIL_T_POWER_MGMT_WAKE_UP_FALSE:
+ * @FIL_T_POWER_MGMT_WAKE_UP_TRUE:
+ *
+ * Variable is unused in original Renesas open source driver, we have
+ * no indication of its purpose except the name.
+ *
+ * TODO test device and verify variables usage.
+ */
+enum fil_t_power_mgmt_wake_up {
+	FIL_T_POWER_MGMT_WAKE_UP_FALSE = 0,
+	FIL_T_POWER_MGMT_WAKE_UP_TRUE
+};
+
+/**
+ * enum fil_t_power_mgmt_receive_dtims - Receive DTIM's
+ * @FIL_T_POWER_MGMT_RECEIVE_DTIMS_FALSE: Do not wake up to receive DTIM.
+ * @FIL_T_POWER_MGMT_RECEIVE_DTIMS_TRUE: Wake up periodically to receive DTIM.
+ */
+enum fil_t_power_mgmt_receive_dtims {
+	FIL_T_POWER_MGMT_RECEIVE_DTIMS_FALSE = 0,
+	FIL_T_POWER_MGMT_RECEIVE_DTIMS_TRUE
+};
+
+#define FIL_T_CHANNELS_MAX_SIZE 14
+
+/**
+ * struct fil_t_channels - Channel list
+ * @size: Size of list, i.e number of channels.
+ * @body: List data.
+ * @pad: Unused, structure padding.
+ *
+ * Each channel number is a single octet.
+ */
+struct fil_t_channels {
+	u8 size;
+	u8 body[FIL_T_CHANNELS_MAX_SIZE];
+	u8 pad;
+} __packed;
+
+#define FIL_T_SSID_MAX_SIZE 32
+
+/**
+ * struct fil_t_ssid - Service Set Identity
+ * @size: Size of SSID in octets.
+ * @body: SSID data.
+ * @pad: Unused, structure padding.
+ */
+struct fil_t_ssid {
+	u8 size;
+	u8 body[FIL_T_SSID_MAX_SIZE];
+	u8 pad;
+} __packed;
+
+/**
+ * enum fil_t_default_channel_time - Default channel times.
+ * @FIL_T_DEFAULT_CH_TIME_MIN: Default minimum time.
+ * @FIL_T_DEFAULT_CH_TIME_MAX: Default maximum time.
+ */
+enum fil_t_default_channel_time {
+	FIL_T_DEFAULT_CH_TIME_MIN = 110,
+	FIL_T_DEFAULT_CH_TIME_MAX = 130
+};
+
+/**
+ * struct fil_t_scan_req - Scan request frame.
+ * @fhdr: &struct fil_t_hdr
+ * @scan_type: &enum fil_scan_type
+ * @pad: Unused, structure padding.
+ * @ch_time_min: Minimum scan time per channel in time units.
+ * @ch_time_max: Maximum scan time per channel in time units.
+ * @channels: List of channels to scan, &struct fil_t_channels.
+ * @ssid: SSID used during scan, &struct fil_t_ssid.
+ */
+struct fil_t_scan_req {
+	struct fil_t_hdr fhdr;
+	u8 scan_type;
+	u8 pad[3];
+	__le32 ch_time_min;
+	__le32 ch_time_max;
+	struct fil_t_channels channels;
+	struct fil_t_ssid ssid;
+} __packed;
+
+#define FIL_T_INFRA_SET_REQ_RATES_MAX_SIZE 16
+
+/**
+ * struct fil_t_rates - List of rates.
+ * @size: Size of list, i.e number of rates.
+ * @body: List data.
+ * @pad: Unused, structure padding.
+ *
+ * Each rate number is a single octet.
+ */
+struct fil_t_rates {
+	u8 size;
+	u8 body[FIL_T_INFRA_SET_REQ_RATES_MAX_SIZE];
+	u8 pad;
+} __packed;
+
+/**
+ * struct _infra_set_req - Network type infrastructure request frame.
+ * @fhdr: &struct fil_t_hdr
+ * @phy_type: &enum fil_phy_type
+ * @cts_mode: &enum cts_mode
+ * @rates: Supported data rates, &struct fil_t_rates
+ * @ssid: SSID, &struct fil_t_ssid
+ * @capability: Network capability flags, &enum fil_bss_capability_flags.
+ * @beacon_lost_count: TODO document this
+ * @auth_type: &enum fil_dot11_auth_type
+ * @channels: &struct fil_t_channels
+ * @scan_type: &enum fil_scan_type
+ */
+struct _infra_set_req {
+	struct fil_t_hdr fhdr;
+	__le16 phy_type;
+	__le16 cts_mode;
+	struct fil_t_rates rates;
+	struct fil_t_ssid ssid;
+	__le16 capability;
+	__le16 beacon_lost_count;
+	__le16 auth_type;
+	struct fil_t_channels channels;
+	__le16 scan_type;
+} __packed;
+
+/**
+ * struct fil_t_infra_set_req - Set BSS mode without specifying the BSSID
+ * @req: &struct _infra_set_req
+ */
+struct fil_t_infra_set_req {
+	struct _infra_set_req req;
+} __packed;
+
+/**
+ * struct fil_t_infra_set_req - Set BSS mode specifying the BSSID
+ * @req: &struct _infra_set_req
+ * @bssid: BSSID to use for request.
+ */
+struct fil_t_infra_set2_req {
+	struct _infra_set_req req;
+	u8 bssid[ETH_ALEN];
+} __packed;
+
+/**
+ * struct fil_t_mic_failure_req - Michael MIC failure event frame.
+ * @fhdr: &struct fil_t_hdr
+ * @count: Notify firmware that this is failure number @count.
+ * @timer: Number of jiffies since the last failure.
+ *
+ * Michael Message Integrity Check must be done by the driver, in the
+ * event of a failure use this frame type to notify the firmware of
+ * the failure.
+ */
+struct fil_t_mic_failure_req {
+	struct fil_t_hdr fhdr;
+	__le16 count;
+	__le16 timer;
+} __packed;
+
+/**
+ * struct fil_t_data_req - Tx data and auth frames.
+ * @fhdr: &struct fil_t_hdr
+ * @type: &enum data_req_type.
+ * @reserved: Unused, reserved.
+ * @data: Upper layer data.
+ *
+ * Frame used when building tx frames out of sk_buff passed down from
+ * networking stack, used for data frames and authentication frames.
+ */
+struct fil_t_data_req {
+	struct fil_t_hdr fhdr;
+	__le16 type;
+	__le16 reserved;
+	u8 data[0];
+} __packed;
+
+/**
+ * enum fil_data_req_type - Tx frame.
+ * @FIL_DATA_REQ_TYPE_DATA: Data requests frame.
+ * @FIL_DATA_REQ_TYTE_AUTH: Data authentication frame.
+ */
+enum fil_t_data_req_type {
+	FIL_T_DATA_REQ_TYPE_DATA = 0x0000,
+	FIL_T_DATA_REQ_TYPE_AUTH
+};
+
+/**
+ * struct fil_t_data_ind - Rx frame.
+ * @fhdr: &struct fil_t_hdr
+ * @auth_type: &struct data_ind_auth_type.
+ * @reserved: Unused, reserved.
+ * @data: Rx data.
+ */
+struct fil_t_data_ind {
+	struct fil_t_hdr fhdr;
+	__le16 auth_type;
+	__le16 reserved;
+	u8 data[0];
+} __packed;
+
+/**
+ * enum data_ind_auth_type - Key used for encryption.
+ * @AUTH_TYPE_PTK: Pairwise Transient Key
+ * @AUTH_TYPE_GTK1: Group Transient Key 1
+ * @AUTH_TYPE_GTK2: Group Transient Key 2
+ */
+enum data_ind_auth_type {
+	AUTH_TYPE_PTK = 0x0001,
+	AUTH_TYPE_GTK1,
+	AUTH_TYPE_GTK2
+};
+
+/**
+ * struct fil_t_mib_set_conf - 'MIB set' confirmation frame.
+ * @fhdr: &struct fil_t_hdr
+ * @status: &enum mib_status
+ * @attribute: &enum mib_attribute
+ */
+struct fil_t_mib_set_conf {
+	struct fil_t_hdr fhdr;
+	__le32 status;
+	__le32 attribute;
+} __packed;
+
+/**
+ * struct fil_t_mib_get_conf - 'MIB get' confirmation frame.
+ * @fhdr: &struct fil_t_hdr
+ * @status: &enum mib_status
+ * @attribute: &enum mib_attribute
+ * @data_size: Size of @data in octets.
+ * @data_type: &enum mib_data_type
+ */
+struct fil_t_mib_get_conf {
+	struct fil_t_hdr fhdr;
+	__le32 status;
+	__le32 attribute;
+	__le16 data_size;
+	__le16 data_type;
+	u8 data[0];
+} __packed;
+
+/**
+ * enum mib_status - Result status of a MIB get/set request.
+ * @MIB_STATUS_SUCCESS: Request successful.
+ * @MIB_STATUS_INVALID: Request invalid.
+ * @MIB_STATUS_READ_ONLY: Request failed, attribute is read only.
+ * @MIB_STATUS_WRITE_ONLY: Request failed, attribute is write only.
+ */
+enum mib_status {
+	MIB_STATUS_SUCCESS = 0,
+	MIB_STATUS_INVALID,
+	MIB_STATUS_READ_ONLY,
+	MIB_STATUS_WRITE_ONLY,
+};
+
+/**
+ * struct fil_t_result_code_conf - Generic confirmation frame.
+ * @fhdr: &struct fil_t_hdr
+ * @relust_code: &struct fil_t_result_code
+ */
+struct fil_t_result_code_conf {
+	struct fil_t_hdr fhdr;
+	__le16 result_code;
+} __packed;
+
+/**
+ * enum fil_t_result_code - Result code returned by various FIL 'set' functions.
+ * @RESULT_SUCCESS: Firmware set request successful.
+ * @RESULT_INVALID_PARAMETERS: Firmware set request failed, invalid parameters.
+ * @RESULT_NOT_SUPPORTED: Set request not supported by firmware.
+ */
+enum fil_t_result_code {
+	RESULT_SUCCESS = 0,
+	RESULT_INVALID_PARAMETERS,
+	RESULT_NOT_SUPPORTED,
+};
+
+/* TODO document struct fil_t_phy_info_ind */
+
+/**
+ * struct fil_t_phy_info_ind - PHY information frame.
+ * @fhdr: &struct fil_t_hdr
+ * @rssi: Received signal strength indication.
+ * @signal:
+ * @noise:
+ * @link_speed:
+ * @tx_frame:
+ * @rx_frame:
+ * @tx_error:
+ * @rx_error:
+ */
+struct fil_t_phy_info_ind {
+	struct fil_t_hdr fhdr;
+	u8 rssi;
+	u8 signal;
+	u8 noise;
+	u8 link_speed;
+	__le32 tx_frame;
+	__le32 rx_frame;
+	__le32 tx_error;
+	__le32 rx_error;
+} __packed;
+
+/**
+ * struct fil_t_scan_conf - Scan confirmation frame.
+ * @fhdr: &struct fil_t_hdr
+ * @relust_code: &struct fil_t_result_code
+ * @reserved: Unused, reserved.
+ */
+struct fil_t_scan_conf {
+	struct fil_t_hdr fhdr;
+	__le16 result_code;
+	__le16 reserved;
+} __packed;
+
+/* TODO document struct fil_t_phy_info_ind */
+
+#define FIL_T_AP_INFO_MAX_SIZE
+
+/**
+ * struct fil_t_scan_ind - Scan result information frame.
+ * @fhdr: &struct fil_t_hdr
+ * @bssid: Basic service set identifier.
+ * @rssi: Received signal strength indication.
+ * @signal:
+ * @noise:
+ * @pad0: Unused, structure padding.
+ * @beacon_period: Beacon period (interval) in time units.
+ * @capability: Network capability flags, &enum fil_bss_capability_flags.
+ * @frame_type: &enum fil_t_scan_ind_frame_type
+ * @channel: Channel to use.
+ * @body_size: Size of @body in octets.
+ * @body: Scan indication data, made up of consecutive &struct fil_ap_info.
+ */
+struct fil_t_scan_ind {
+	struct fil_t_hdr fhdr;
+	u8 bssid[ETH_ALEN];
+	u8 rssi;
+	u8 signal;
+	u8 noise;
+	u8 pad0;
+	__le16 beacon_period;
+	__le16 capability;
+	u8 frame_type;
+	u8 channel;
+	__le16 body_size;
+	u8 body[FIL_AP_INFO_MAX_SIZE];
+} __packed;
+
+/**
+ * enum fil_t_scan_ind_frame_type - FIL scan frame type.
+ * @FIL_T_FRAME_TYPE_PROBE_RESP: Probe response frame type.
+ * @FIL_T_FRAME_TYPE_BEACON: Beacon frame type.
+ */
+enum fil_t_scan_ind_frame_type {
+	FIL_T_FRAME_TYPE_PROBE_RESP		= 0x50,
+	FIL_T_FRAME_TYPE_BEACON			= 0x80
+};
+
+#define FIL_T_IE_MAX_SIZE 128
+#define FIL_T_CONN_IND_RATES_MAX_SIZE	8
+
+/**
+ * struct fil_t_conn_ind - Connection event indication frame.
+ * @fhdr: &struct fil_t_hdr
+ * @conn_code: &struct fil_conn_code
+ * @bssid: Basic service set identifier.
+ * @rssi: Received signal strength indication.
+ * @signal: TODO document this
+ * @noise: TODO document this
+ * @pad0: Unused, structure padding.
+ * @beacon_period: Beacon period (interval) in time units.
+ * @capability: Network capability flags, &enum fil_bss_capability_flags.
+ * @rates: List of supported data rates.
+ * @fh: Frequency hopping parameters.
+ * @ds: Direct sequence parameters.
+ * @cf: Contention free parameters.
+ * @ibss: Adhoc network parameters.
+ * @erp: Extended rate PHY parameters.
+ * @pad1: Unused, structure padding.
+ * @ext_rates: Extended rates list.
+ * @dtim_period: Delivery traffic indication map period.
+ * @wpa_mode: &struct fil_wpa_mode.
+ * @ies: Information elements
+ */
+struct fil_t_conn_ind {
+	struct fil_t_hdr fhdr;
+	__le16 conn_code;
+	u8 bssid[ETH_ALEN];
+	u8 rssi;
+	u8 signal;
+	u8 noise;
+	u8 pad0;
+	__le16 beacon_period;
+	__le16 capability;
+
+	struct {
+		u8 size;
+		u8 body[FIL_T_CONN_IND_RATES_MAX_SIZE];
+		u8 pad;
+	} __packed rates;
+
+	struct {
+		__le16 dwell_time;
+		u8 hop_set;
+		u8 hop_pattern;
+		u8 hop_index;
+	} __packed fh;
+
+	struct {
+		u8 channel;
+	} __packed ds;
+
+	struct {
+		u8 count;
+		u8 period;
+		__le16 max_duration;
+		__le16 dur_remaining;
+	} __packed cf;
+
+	struct {
+		__le16 atim_window;
+	} __packed ibss;
+
+	struct {
+		u8 info;
+	} __packed erp;
+
+	u8 pad1;
+
+	struct {
+		u8 size;
+		u8 body[FIL_T_CONN_IND_RATES_MAX_SIZE];
+		u8 pad;
+	} __packed ext_rates;
+
+	u8 dtim_period;
+	u8 wpa_mode;
+
+	struct {
+		u8 size;
+		u8 body[FIL_T_IE_MAX_SIZE];
+	} __packed ies;
+} __packed;
+
+/**
+ * struct fil_t_assoc_ind_req_info - Association event request information.
+ * @type: &enum fil_t_assoc_req_frame_type
+ * @pad: Unused, structure padding.
+ * @capability: Network capability flags, &enum fil_bss_capability_flags.
+ * @listen_interval: Management frame listen interval.
+ * @ap_addr: Current access point MAC address.
+ * @ie_size: Number of octets in the request portion of the
+ *	information elements data.
+ */
+struct fil_t_assoc_ind_req_info {
+	u8 type;
+	u8 pad;
+	__le16 capability;
+	__le16 listen_interval;
+	u8 ap_addr[ETH_ALEN];
+	__le16 ie_size;
+} __packed;
+
+/**
+ * enum fil_t_assoc_req_frame_type - Association request frame type.
+ * @FIL_T_FRAME_TYPE_ASSOC_REQ: Association request frame type.
+ * @FIL_T_FRAME_TYPE_REASSOC_REQ: Re-association request frame type.
+ */
+enum fil_t_assoc_req_frame_type {
+	FIL_T_FRAME_TYPE_ASSOC_REQ		= 0x00,
+	FIL_T_FRAME_TYPE_REASSOC_REQ		= 0x20
+};
+
+/**
+ * struct fil_t_assoc_ind_resp_info - Association event response information.
+ * @type: &enum fil_t_assoc_resp_frame_type
+ * @pad: Unused, structure padding.
+ * @capability: Network capability flags, &enum fil_bss_capability_flags.
+ * @status: No known information. Most likely this is a subset of
+ *	the 802.11 fixed-length management frame 'status' field.
+ * @assoc_id: Management frame association identifier.
+ * @ie_size: Number of octets in the request portion of the
+ *	information elements data.
+ */
+struct fil_t_assoc_ind_resp_info {
+	u8 type;
+	u8 pad;
+	__le16 capability;
+	__le16 status;
+	__le16 assoc_id;
+	__le16 ie_size;
+} __packed;
+
+/**
+ * enum fil_t_assoc_resp_frame_type - Association response frame type.
+ * @FIL_T_FRAME_TYPE_ASSOC_RESP: Association response frame type.
+ * @FIL_T_FRAME_TYPE_REASSOC_RESP: Re-association response frame type.
+ */
+enum fil_t_assoc_resp_frame_type {
+	FIL_T_FRAME_TYPE_ASSOC_RESP		= 0x10,
+	FIL_T_FRAME_TYPE_REASSOC_RESP		= 0x30
+};
+
+/**
+ * struct fil_t_assoc_ind - y
+ * @fhdr: &struct fil_t_hdr
+ * @req: &struct fil_t_assoc_ind_req_info
+ * @resp: &struct fil_t_assoc_ind_resp_info
+ * @ies: Consecutive information elements, @req IE's followed by @resp IE's.
+ */
+struct fil_t_assoc_ind {
+	struct fil_t_hdr fhdr;
+	struct fil_t_assoc_ind_req_info req;
+	struct fil_t_assoc_ind_resp_info resp;
+	u8 ies[0];
+	/* followed by (req->ie_size + resp->ie_size) octets of data */
+} __packed;
+
+/**
+ * struct fil_eth_hdr - Firmware Interface Layer Ethernet frame header.
+ * @h_dest: Destination MAC address.
+ * @h_source: Source MAC address.
+ * @snap: SNAP header.
+ * @h_proto: Protocol ID.
+ * @data: Upper layer data.
+ */
+struct fil_eth_hdr {
+	u8 h_dest[ETH_ALEN];
+	u8 h_source[ETH_ALEN];
+	struct snap_hdr snap;
+	__be16 h_proto;
+	u8 data[0];
+};
diff --git a/drivers/staging/ks7010/hif.c b/drivers/staging/ks7010/hif.c
new file mode 100644
index 0000000..ce462a2
--- /dev/null
+++ b/drivers/staging/ks7010/hif.c
@@ -0,0 +1,104 @@
+#include <crypto/hash.h>
+#include <uapi/linux/wireless.h>
+
+#include "ks7010.h"
+#include "hif.h"
+#include "fil.h"
+
+/**
+ * DOC: Host Interface Layer - Provides abstraction layer on top of
+ * Firmware Interface Layer. When interfacing with the device FIL
+ * provides the mechanism, HIF provides the policy.
+ */
+
+/**
+ * ks7010_hif_tx() - Implements HIF policy for transmit path.
+ * @ks: The ks7010 device.
+ * @skb: sk_buff from networking stack.
+ */
+int ks7010_hif_tx(struct ks7010 *ks, struct sk_buff *skb)
+{
+	ks_debug("not implemented yet");
+	return 0;
+}
+
+/**
+ * ks7010_hif_tx() - HIF response to an rx event.
+ * @ks: The ks7010 device.
+ * @data: The rx data.
+ * @data_size: Size of data.
+ */
+void ks7010_hif_rx(struct ks7010 *ks, u8 *data, size_t data_size)
+{
+	ks_debug("not implemented yet");
+}
+
+/**
+ * ks7010_hif_set_power_mgmt_active() - Disable power save.
+ * @ks: The ks7010 device.
+ */
+void ks7010_hif_set_power_mgmt_active(struct ks7010 *ks)
+{
+	struct fil_power_mgmt req;
+
+	req.ps_enable = false;
+	req.wake_up = true;
+	req.receive_dtims = true;
+
+	ks7010_fil_set_power_mgmt(ks, &req);
+}
+
+/**
+ * ks7010_hif_set_power_mgmt_sleep() - Enable power save, sleep.
+ * @ks: The ks7010 device.
+ *
+ * Power save sleep mode. Wake periodically to receive DTIM's.
+ */
+void ks7010_hif_set_power_mgmt_sleep(struct ks7010 *ks)
+{
+	struct fil_power_mgmt req;
+
+	req.ps_enable = true;
+	req.wake_up = false;
+	req.receive_dtims = true;
+
+	ks7010_fil_set_power_mgmt(ks, &req);
+}
+
+/**
+ * ks7010_hif_set_power_mgmt_deep_sleep() - Enable power save, deep sleep.
+ * @ks: The ks7010 device.
+ *
+ * Power save deep sleep mode. Do not wake to receive DTIM's.
+ */
+void ks7010_hif_set_power_mgmt_deep_sleep(struct ks7010 *ks)
+{
+	struct fil_power_mgmt req;
+
+	req.ps_enable = true;
+	req.wake_up = false;
+	req.receive_dtims = false;
+
+	ks7010_fil_set_power_mgmt(ks, &req);
+}
+
+void ks7010_hif_init(struct ks7010 *ks)
+{
+	ks_debug("not implemented yet");
+}
+
+void ks7010_hif_cleanup(struct ks7010 *ks)
+{
+	ks_debug("not implemented yet");
+}
+
+void ks7010_hif_create(struct ks7010 *ks)
+{
+	ks_debug("not implemented yet");
+}
+
+void ks7010_hif_destroy(struct ks7010 *ks)
+{
+	ks_debug("not implemented yet");
+}
+
diff --git a/drivers/staging/ks7010/hif.h b/drivers/staging/ks7010/hif.h
new file mode 100644
index 0000000..660aa73
--- /dev/null
+++ b/drivers/staging/ks7010/hif.h
@@ -0,0 +1,23 @@
+#ifndef _KS7010_HIF_H
+#define _KS7010_HIF_H
+
+#include <linux/compiler.h>
+#include <linux/skbuff.h>
+#include <linux/ieee80211.h>
+
+#include "common.h"
+
+int ks7010_hif_tx(struct ks7010 *ks, struct sk_buff *skb);
+void ks7010_hif_rx(struct ks7010 *ks, u8 *data, size_t data_size);
+
+void ks7010_hif_set_power_mgmt_active(struct ks7010 *ks);
+void ks7010_hif_set_power_mgmt_sleep(struct ks7010 *ks);
+void ks7010_hif_set_power_mgmt_deep_sleep(struct ks7010 *ks);
+
+void ks7010_hif_init(struct ks7010 *ks);
+void ks7010_hif_cleanup(struct ks7010 *ks);
+
+void ks7010_hif_create(struct ks7010 *ks);
+void ks7010_hif_destroy(struct ks7010 *ks);
+
+#endif	/* _KS7010_HIF_H */
diff --git a/drivers/staging/ks7010/ks7010.h b/drivers/staging/ks7010/ks7010.h
new file mode 100644
index 0000000..30878df
--- /dev/null
+++ b/drivers/staging/ks7010/ks7010.h
@@ -0,0 +1,94 @@
+#ifndef _KS7010_H
+#define _KS7010_H
+
+#include <net/cfg80211.h>
+#include <linux/list.h>
+#include <linux/if_ether.h>
+#include <linux/interrupt.h>
+#include <linux/wireless.h>
+#include <linux/skbuff.h>
+#include <crypto/hash.h>
+
+#include "common.h"
+#include "fil.h"
+
+#define DRIVER_PREFIX "ks7010: "
+
+#define ks_err(fmt, arg...) \
+	pr_err(DRIVER_PREFIX "ERROR " fmt "\n", ##arg)
+
+#define ks_info(fmt, arg...) \
+	pr_info(DRIVER_PREFIX "INFO " fmt "\n", ##arg)
+
+#define ks_warn(fmt, arg...) \
+	pr_warn(DRIVER_PREFIX "WARNING " fmt "\n", ##arg)
+
+#define ks_debug(fmt, arg...) \
+	pr_debug(DRIVER_PREFIX "%s: " fmt "\n", __func__, ##arg)
+
+/**
+ * enum ks7010_state - ks7010 device state.
+ * @KS7010_STATE_OFF: Device is off.
+ * @KS7010_STATE_READY:	Device ready.
+ */
+enum ks7010_state {
+	KS7010_STATE_OFF,
+	KS7010_STATE_READY
+};
+
+struct ks7010_sdio;
+
+/**
+ * ks7010_vif - Virtual interface (net_device private data).
+ * @ndev: Pointer to the net_device for this VIF.
+ */
+struct ks7010_vif {
+	struct net_device *ndev;
+};
+
+/**
+ * struct ks7010 - The ks7010 device.
+ * @priv: Pointer to the SDIO private data.
+ * @vif: The virtual interface (driver supports single VIF only).
+ * @state: The device state, &enum ks7010_state.
+ * @wiphy: The device wiphy.
+ * @dev: Pointer to the device embedded within the SDIO func.
+ * @fil_ops: Firmware interface layer operations.
+ * @mac_addr: Device MAC address.
+ * @mac_addr_valid: True if @mac_addr is valid.
+ */
+struct ks7010 {
+	struct ks7010_sdio *priv;
+	struct ks7010_vif *vif;
+
+	enum ks7010_state state;
+
+	struct wiphy *wiphy;
+
+	struct device *dev;
+
+	struct fil_ops *fil_ops;
+
+	u8 mac_addr[ETH_ALEN];
+	bool mac_addr_valid;
+
+	struct crypto_shash *tx_tfm_mic;
+	struct crypto_shash *rx_tfm_mic;
+};
+
+/* main.c */
+bool ks7010_is_asleep(struct ks7010 *ks);
+void ks7010_request_wakeup(struct ks7010 *ks);
+void ks7010_request_sleep(struct ks7010 *ks);
+
+int ks7010_init(struct ks7010 *ks);
+void ks7010_cleanup(struct ks7010 *ks);
+
+struct ks7010 *ks7010_create(struct device *dev);
+void ks7010_destroy(struct ks7010 *ks);
+
+/* tx.c */
+int ks7010_tx_start(struct sk_buff *skb, struct net_device *dev);
+int ks7010_tx(struct ks7010 *ks, u8 *data, size_t size, struct sk_buff *skb);
+
+#endif	/* _KS7010_H */
diff --git a/drivers/staging/ks7010/main.c b/drivers/staging/ks7010/main.c
new file mode 100644
index 0000000..886f086
--- /dev/null
+++ b/drivers/staging/ks7010/main.c
@@ -0,0 +1,122 @@
+#include <linux/firmware.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/workqueue.h>
+#include <linux/delay.h>
+#include <linux/inetdevice.h>
+
+#include "ks7010.h"
+#include "sdio.h"
+#include "cfg80211.h"
+
+/**
+ * ks7010_is_asleep() - True if the device is asleep.
+ * @ks: The ks7010 device.
+ */
+bool ks7010_is_asleep(struct ks7010 *ks)
+{
+	ks_debug("not implemented yet");
+	return false;
+}
+
+/**
+ * ks7010_request_wakeup() - Request the device to enter active mode.
+ * @ks: The ks7010 device.
+ */
+void ks7010_request_wakeup(struct ks7010 *ks)
+{
+	ks_debug("not implemented yet");
+}
+
+/**
+ * ks7010_request_sleep() - Request the device to enter sleep mode.
+ * @ks: The ks7010 device.
+ */
+void ks7010_request_sleep(struct ks7010 *ks)
+{
+	ks_debug("not implemented yet");
+}
+
+static int ks7010_open(struct net_device *ndev)
+{
+	return 0;
+}
+
+static int ks7010_close(struct net_device *ndev)
+{
+	ks_debug("not implemented yet");
+	return 0;
+}
+
+static int
+ks7010_set_features(struct net_device *dev, netdev_features_t features)
+{
+	ks_debug("not implemented yet");
+	return 0;
+}
+
+static void ks7010_set_multicast_list(struct net_device *dev)
+{
+	ks_debug("not implemented yet");
+}
+
+static const unsigned char dummy_addr[] = {
+	0x00, 0x0b, 0xe3, 0x00, 0x00, 0x00
+};
+
+static const struct net_device_ops ks7010_netdev_ops = {
+	.ndo_open               = ks7010_open,
+	.ndo_stop               = ks7010_close,
+	.ndo_start_xmit         = ks7010_tx_start,
+	.ndo_set_features       = ks7010_set_features,
+	.ndo_set_rx_mode	= ks7010_set_multicast_list,
+};
+
+/**
+ * ks7010_init() - Initialize the ks7010 device.
+ * @ks: The ks7010 device.
+ */
+int ks7010_init(struct ks7010 *ks)
+{
+	ks_debug("not implemented yet");
+	return 0;
+}
+
+/**
+ * ks7010_cleanup() - Cleanup the ks7010 device.
+ * @ks: The ks7010 device.
+ */
+void ks7010_cleanup(struct ks7010 *ks)
+{
+	ks_debug("not implemented yet");
+}
+
+/* FIXME what about the device embedded in the net_device? */
+
+/**
+ * ks7010 *ks7010_create() - Create the ks7010 device.
+ * @dev: The device embedded within the SDIO function.
+ */
+struct ks7010 *ks7010_create(struct device *dev)
+{
+	struct ks7010 *ks;
+
+	ks = ks7010_cfg80211_create();
+	if (!ks)
+		return NULL;
+
+	ks->dev = dev;
+	ks->state = KS7010_STATE_OFF;
+
+	return ks;
+}
+
+/**
+ * ks7010_destroy() - Destroy the ks7010 device.
+ * @ks: The ks7010 device.
+ */
+void ks7010_destroy(struct ks7010 *ks)
+{
+	ks->dev = NULL;
+	ks7010_cfg80211_destroy(ks);
+}
diff --git a/drivers/staging/ks7010/sdio.c b/drivers/staging/ks7010/sdio.c
new file mode 100644
index 0000000..f0ba87f
--- /dev/null
+++ b/drivers/staging/ks7010/sdio.c
@@ -0,0 +1,399 @@
+#include <linux/module.h>
+#include <linux/mmc/card.h>
+#include <linux/mmc/mmc.h>
+#include <linux/mmc/host.h>
+#include <linux/mmc/sdio_func.h>
+#include <linux/mmc/sdio_ids.h>
+#include <linux/mmc/sdio.h>
+#include <linux/mmc/sd.h>
+
+#include "ks7010.h"
+#include "sdio.h"
+
+/**
+ * enum ks7010_sdio_state - SDIO device state.
+ * @SDIO_DISABLED: SDIO function is disabled.
+ * @SDIO_ENABLED: SDIO function is enabled.
+ */
+enum ks7010_sdio_state {
+	SDIO_DISABLED,
+	SDIO_ENABLED
+};
+
+/**
+ * struct ks7010_sdio - SDIO device private data.
+ * @func: The SDIO function device.
+ * @ks: The ks7010 device.
+ * @id: The SDIO device identifier.
+ * @state: The SDIO device state, &enum ks7010_sdio_sate.
+ * @fw: Firmware for the device.
+ * @fw_size: Size of the firmware.
+ * @fw_version: Firmware version string.
+ * @fw_version_len: Length of firmware version string.
+ */
+struct ks7010_sdio {
+	struct sdio_func *func;
+	struct ks7010 *ks;
+
+	const struct sdio_device_id *id;
+	enum ks7010_sdio_state state;
+
+	u8 *fw;
+	size_t fw_size;
+
+	char fw_version[ETHTOOL_FWVERS_LEN];
+	size_t fw_version_len;
+};
+
+static struct sdio_func *ks_to_func(struct ks7010 *ks)
+{
+	struct ks7010_sdio *ks_sdio = ks->priv;
+
+	if (ks_sdio->state != SDIO_ENABLED) {
+		ks_debug("sdio_func is not ready");
+		return NULL;
+	}
+
+	return ks_sdio->func;
+}
+
+/**
+ * ks7010_sdio_readb() - Read a single byte from SDIO device.
+ * @ks: The ks7010 device.
+ * @addr: SDIO device address to read from.
+ * @byte: Pointer to store byte read.
+ */
+static int ks7010_sdio_readb(struct ks7010 *ks, int addr, u8 *byte)
+{
+	struct sdio_func *func = ks_to_func(ks);
+	int ret;
+
+	sdio_claim_host(func);
+	*byte = sdio_readb(func, addr, &ret);
+	if (ret)
+		ks_err("sdio read byte failed %d", ret);
+	sdio_release_host(func);
+
+	return ret;
+}
+
+/**
+ * ks7010_sdio_read() - Read data from SDIO device.
+ * @ks: The ks7010 device.
+ * @addr: SDIO device address to read from.
+ * @buf: Buffer to read data into.
+ * @len: Number of bytes to read.
+ */
+static int ks7010_sdio_read(struct ks7010 *ks, int addr, void *buf, size_t len)
+{
+	struct sdio_func *func = ks_to_func(ks);
+	int ret;
+
+	sdio_claim_host(func);
+	ret = sdio_memcpy_fromio(func, buf, addr, len);
+	if (ret)
+		ks_err("sdio read failed %d", ret);
+	sdio_release_host(func);
+
+	return ret;
+}
+
+/**
+ * ks7010_sdio_writeb() - Write a single byte to SDIO device.
+ * @ks: The ks7010 device.
+ * @addr: SDIO device address to write to.
+ * @byte: Byte to write.
+ */
+static int ks7010_sdio_writeb(struct ks7010 *ks, int addr, u8 byte)
+{
+	struct sdio_func *func = ks_to_func(ks);
+	int ret;
+
+	sdio_claim_host(func);
+	sdio_writeb(func, byte, addr, &ret);
+	if (ret)
+		ks_err("sdio write byte failed %d", ret);
+	sdio_release_host(func);
+
+	return ret;
+}
+
+/**
+ * ks7010_sdio_write() - Write data to SDIO device.
+ * @ks: The ks7010 device.
+ * @addr: SDIO device address to write to.
+ * @buf: Source data buffer.
+ * @len: Number of bytes to write.
+ */
+static int ks7010_sdio_write(struct ks7010 *ks, int addr, void *buf, size_t len)
+{
+	struct sdio_func *func = ks_to_func(ks);
+	int ret;
+
+	sdio_claim_host(func);
+	ret = sdio_memcpy_toio(func, addr, buf, len);
+	if (ret)
+		ks_err("sdio write failed %d", ret);
+	sdio_release_host(func);
+
+	return ret;
+}
+
+/**
+ * ks7010_sdio_tx() - Write tx data to the device.
+ * @ks: The ks7010 device.
+ * @data: The data to write.
+ * @size: Write size, must be aligned.
+ */
+int ks7010_sdio_tx(struct ks7010 *ks, u8 *data, size_t size)
+{
+	int ret;
+
+	ret = ks7010_sdio_write(ks, DATA_WINDOW_SIZE, data, size);
+	if (ret)
+		return ret;
+
+	ret = ks7010_sdio_writeb(ks, WRITE_STATUS_ADDR, WRITE_STATUS_BUSY);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
+static int ks7010_sdio_enable_interrupts(struct ks7010 *ks)
+{
+	struct sdio_func *func = ks_to_func(ks);
+	u8 byte;
+	int ret;
+
+	sdio_claim_host(func);
+
+	ret = ks7010_sdio_writeb(ks, INT_PENDING_ADDR, INT_CLEAR);
+	if (ret)
+		goto out;
+
+	byte = (INT_GCR_B | INT_READ_STATUS | INT_WRITE_STATUS);
+	ret = ks7010_sdio_writeb(ks, INT_ENABLE_ADDR, byte);
+out:
+	sdio_release_host(func);
+	return ret;
+}
+
+/**
+ * ks7010_sdio_interrupt() - Interrupt handler for device.
+ * @func: The SDIO function.
+ */
+static void ks7010_sdio_interrupt(struct sdio_func *func)
+{
+	ks_debug("not implemented yet");
+}
+
+/* called before ks7010 device is initialized */
+static int ks7010_sdio_init(struct ks7010_sdio *ks_sdio,
+			    const struct sdio_device_id *id)
+{
+	struct sdio_func *func = ks_sdio->func;
+	int ret = -ENODEV;
+
+	ks_sdio->id = id;
+
+	sdio_claim_host(func);
+
+	ret = sdio_enable_func(func);
+	if (ret)
+		goto err_release;
+
+	sdio_writeb(func, INT_DISABLE, INT_ENABLE_ADDR, &ret);
+	if (ret) {
+		ret = -EIO;
+		goto err_disable_func;
+	}
+
+	sdio_writeb(func, INT_CLEAR, INT_PENDING_ADDR, &ret);
+	if (ret) {
+		ret = -EIO;
+		goto err_disable_func;
+	}
+
+	ret = sdio_claim_irq(func, ks7010_sdio_interrupt);
+	if (ret)
+		goto err_disable_func;
+
+	sdio_release_host(func);
+
+	ks_sdio->state = SDIO_ENABLED;
+
+	return 0;
+
+err_release:
+	sdio_release_host(func);
+err_disable_func:
+	sdio_disable_func(func);
+
+	return ret;
+}
+
+static void ks7010_sdio_cleanup(struct ks7010 *ks)
+{
+	struct sdio_func *func = ks_to_func(ks);
+
+	sdio_claim_host(func);
+
+	sdio_release_irq(func);
+	sdio_disable_func(func);
+
+	sdio_release_host(func);
+}
+
+static int ks7010_sdio_config(struct ks7010 *ks)
+{
+	struct sdio_func *func = ks_to_func(ks);
+	int ret;
+
+	sdio_claim_host(func);
+
+	/* give us some time to enable, in ms */
+	func->enable_timeout = 100;
+
+	ret = sdio_set_block_size(func, KS7010_IO_BLOCK_SIZE);
+	if (ret) {
+		ks_err("set sdio block size %d failed: %d)\n",
+		       KS7010_IO_BLOCK_SIZE, ret);
+		goto out;
+	}
+
+out:
+	sdio_release_host(func);
+
+	return ret;
+}
+
+static int ks7010_sdio_probe(struct sdio_func *func,
+			     const struct sdio_device_id *id)
+{
+	struct ks7010_sdio *ks_sdio;
+	struct ks7010 *ks;
+	int ret;
+
+	ks_debug("sdio new func %d vendor 0x%x device 0x%x block 0x%x/0x%x",
+		 func->num, func->vendor, func->device,
+		 func->max_blksize, func->cur_blksize);
+
+	ks_sdio = kzalloc(sizeof(*ks_sdio), GFP_KERNEL);
+	if (!ks_sdio)
+		return -ENOMEM;
+
+	ks_sdio->state = SDIO_DISABLED;
+
+	ks_sdio->func = func;
+	sdio_set_drvdata(func, ks_sdio);
+
+	ret = ks7010_sdio_init(ks_sdio, id);
+	if (ret) {
+		ks_err("failed to init ks_sdio: %d", ret);
+		goto err_sdio_free;
+	}
+
+	ks = ks7010_create(&func->dev);
+	if (!ks) {
+		ret = -ENOMEM;
+		goto err_sdio_cleanup;
+	}
+
+	ks_sdio->ks = ks;
+	ks->priv = ks_sdio;
+
+	ret = ks7010_sdio_config(ks);
+	if (ret) {
+		ks_err("failed to config ks_sdio: %d", ret);
+		goto err_ks_destroy;
+	}
+
+	ret = ks7010_init(ks);
+	if (ret) {
+		ks_err("failed to init ks7010");
+		goto err_ks_destroy; /* FIXME undo ks7010_sdio_config() */
+	}
+
+	ret = ks7010_sdio_enable_interrupts(ks);
+	if (ret) {
+		ks_err("failed to enable interrupts");
+		goto err_ks_cleanup;
+	}
+
+	ks->state = KS7010_STATE_READY;
+	ks_info("SDIO device successfully probed");
+
+	return 0;
+
+err_ks_cleanup:
+	ks7010_cleanup(ks);
+err_ks_destroy:
+	ks7010_destroy(ks);
+err_sdio_cleanup:
+	ks7010_sdio_cleanup(ks);
+err_sdio_free:
+	kfree(ks_sdio);
+
+	return ret;
+}
+
+static void ks7010_sdio_remove(struct sdio_func *func)
+{
+	struct ks7010_sdio *ks_sdio = sdio_get_drvdata(func);
+	struct ks7010 *ks = ks_sdio->ks;
+
+	ks_debug("sdio removed func %d vendor 0x%x device 0x%x",
+		 func->num, func->vendor, func->device);
+
+	ks7010_destroy(ks);
+
+	ks7010_sdio_cleanup(ks);
+
+	sdio_set_drvdata(func, NULL);
+	kfree(ks_sdio);
+
+	ks_info("SDIO device removed");
+}
+
+static const struct sdio_device_id ks7010_sdio_ids[] = {
+	{SDIO_DEVICE(SDIO_VENDOR_ID_KS_CODE_A, SDIO_DEVICE_ID_KS_7010)},
+	{SDIO_DEVICE(SDIO_VENDOR_ID_KS_CODE_B, SDIO_DEVICE_ID_KS_7010)},
+	{ /* all zero */ }
+};
+MODULE_DEVICE_TABLE(sdio, ks7010_sdio_ids);
+
+static struct sdio_driver ks7010_sdio_driver = {
+	.name = "ks7010_sdio",
+	.id_table = ks7010_sdio_ids,
+	.probe = ks7010_sdio_probe,
+	.remove = ks7010_sdio_remove,
+};
+
+static int __init ks7010_sdio_module_init(void)
+{
+	int ret;
+
+	ret = sdio_register_driver(&ks7010_sdio_driver);
+	if (ret)
+		ks_err("failed to register sdio driver: %d", ret);
+
+	ks_info("module loaded");
+	ks_debug("debugging output enabled");
+
+	return ret;
+}
+
+static void __exit ks7010_sdio_module_exit(void)
+{
+	sdio_unregister_driver(&ks7010_sdio_driver);
+	ks_info("module unloaded");
+}
+
+module_init(ks7010_sdio_module_init);
+module_exit(ks7010_sdio_module_exit);
+
+MODULE_AUTHOR("Tobin C. Harding");
+MODULE_AUTHOR("Sang Engineering, Qi-Hardware, KeyStream");
+MODULE_DESCRIPTION("Driver for KeyStream KS7010 based SDIO cards");
+MODULE_LICENSE("GPL");
diff --git a/drivers/staging/ks7010/sdio.h b/drivers/staging/ks7010/sdio.h
new file mode 100644
index 0000000..bbd9688
--- /dev/null
+++ b/drivers/staging/ks7010/sdio.h
@@ -0,0 +1,86 @@
+#ifndef _KS7010_SDIO_H
+#define _KS7010_SDIO_H
+
+#include "common.h"
+
+/*  SDIO KeyStream vendor and device */
+#define SDIO_VENDOR_ID_KS_CODE_A	0x005b
+#define SDIO_VENDOR_ID_KS_CODE_B	0x0023
+
+/* Older sources suggest earlier versions were named 7910 or 79xx */
+#define SDIO_DEVICE_ID_KS_7010		0x7910
+
+#define KS7010_IO_BLOCK_SIZE 512
+
+/* read status register */
+#define READ_STATUS_ADDR	0x000000
+#define READ_STATUS_BUSY	0
+#define READ_STATUS_IDLE	1
+
+/* read index register */
+#define READ_INDEX_ADDR		0x000004
+
+/* read data size register */
+#define READ_DATA_SIZE_ADDR	0x000008
+
+/* write index register */
+#define WRITE_INDEX_ADDR	0x000010
+
+/* write status register */
+#define WRITE_STATUS_ADDR	0x00000C
+#define WRITE_STATUS_BUSY	0
+#define WRITE_STATUS_IDLE	1
+
+/* [write status] / [read data size] register
+ * Used for network packets less than 2048 bytes data.
+ */
+#define WSTATUS_RSIZE_ADDR	0x000014
+#define WSTATUS_MASK		0x80
+#define RSIZE_MASK		0x7F
+
+/* ARM to SD interrupt enable */
+#define INT_ENABLE_ADDR		0x000020
+#define INT_DISABLE		0
+
+/* ARM to SD interrupt pending */
+#define INT_PENDING_ADDR	0x000024
+#define INT_CLEAR		0xFF
+
+/* General Communication Register A */
+#define GCR_A_ADDR		0x000028
+enum gen_com_reg_a {
+	GCR_A_INIT = 0,
+	GCR_A_REMAP,
+	GCR_A_RUN
+};
+
+/* General Communication Register B */
+#define GCR_B_ADDR		0x00002C
+enum gen_com_reg_b {
+	GCR_B_ACTIVE = 0,
+	GCR_B_SLEEP
+};
+
+#define INT_GCR_B		BIT(7)
+#define INT_GCR_A		BIT(6)
+#define INT_WRITE_STATUS	BIT(5)
+#define INT_WRITE_INDEX		BIT(4)
+#define INT_WRITE_SIZE		BIT(3)
+#define INT_READ_STATUS		BIT(2)
+#define INT_READ_INDEX		BIT(1)
+#define INT_READ_SIZE		BIT(0)
+
+/* wake up register */
+#define WAKEUP_ADDR		0x008018
+#define WAKEUP_REQ		0x5a
+
+/* AHB Data Window  0x010000-0x01FFFF */
+#define DATA_WINDOW_ADDR	0x010000
+#define DATA_WINDOW_SIZE	(64 * 1024)
+
+#define KS7010_IRAM_ADDR	0x06000000
+#define	ROM_FILE "ks7010sd.rom"
+
+int ks7010_sdio_tx(struct ks7010 *ks, u8 *data, size_t size);
+
+#endif	/* _KS7010_SDIO_H */
diff --git a/drivers/staging/ks7010/tx.c b/drivers/staging/ks7010/tx.c
new file mode 100644
index 0000000..98446a2
--- /dev/null
+++ b/drivers/staging/ks7010/tx.c
@@ -0,0 +1,29 @@
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+
+#include "ks7010.h"
+
+/**
+ * ks7010_tx_start() - Start transmit.
+ * @ndev: The net_device associated with this sk_buff.
+ * @skb: sk_buff passed down from the networking stack.
+ *
+ * Tx data path initiation function called by the networking stack.
+ */
+int ks7010_tx_start(struct sk_buff *skb, struct net_device *ndev)
+{
+	return 0;
+}
+
+/**
+ * ks7010_tx() - Queue tx frame for transmission.
+ * @ks: The ks7010 device.
+ * @data: Data to transmit.
+ * @size: Size of data.
+ * @skb: Pointer to associated sk_buff, NULL for SME frames.
+ */
+int ks7010_tx(struct ks7010 *ks, u8 *data, size_t size, struct sk_buff *skb)
+{
+	return 0;
+}
+
-- 
2.7.4
