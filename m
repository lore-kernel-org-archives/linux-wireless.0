Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog113.obsmtp.com ([74.125.149.209]:57264 "EHLO
	na3sys009aog113.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab3BPFpn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Feb 2013 00:45:43 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 2/2] mwifiex: add 802.11AC support
Date: Fri, 15 Feb 2013 21:44:30 -0800
Message-Id: <1360993470-4828-3-git-send-email-bzhao@marvell.com> (sfid-20130216_064547_594171_4CABE5B3)
In-Reply-To: <1360993470-4828-1-git-send-email-bzhao@marvell.com>
References: <1360993470-4828-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Yogesh Ashok Powar <yogeshp@marvell.com>

For STA mode, collect VHT realated IEs from the Beacons or Probe
Responses and append similar VHT related IEs to association
requests.

For AP mode, get VHT related capability information and share it
with cfg80211 at the time of wiphy register. This information is
further used by cfg80211 and hostapd to start an AP with 802.11AC
support.

Currently only 8897 supports 802.11AC.

Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Nishant Sarmukadam <nishants@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Frank Huang <frankh@marvell.com>
---
 drivers/net/wireless/mwifiex/11ac.c        |  261 ++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/11ac.h        |   26 +++
 drivers/net/wireless/mwifiex/11n.c         |    7 +-
 drivers/net/wireless/mwifiex/11n.h         |    4 +-
 drivers/net/wireless/mwifiex/Makefile      |    1 +
 drivers/net/wireless/mwifiex/cfg80211.c    |  177 ++++++++++++++++---
 drivers/net/wireless/mwifiex/cfp.c         |  159 +++++++++++++++++-
 drivers/net/wireless/mwifiex/cmdevt.c      |   19 ++
 drivers/net/wireless/mwifiex/fw.h          |  127 +++++++++++++-
 drivers/net/wireless/mwifiex/ioctl.h       |    4 +
 drivers/net/wireless/mwifiex/join.c        |    8 +
 drivers/net/wireless/mwifiex/main.h        |   23 +++-
 drivers/net/wireless/mwifiex/scan.c        |   48 +++++
 drivers/net/wireless/mwifiex/sta_cmd.c     |    2 +-
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    1 +
 drivers/net/wireless/mwifiex/sta_ioctl.c   |    5 +-
 16 files changed, 830 insertions(+), 42 deletions(-)
 create mode 100644 drivers/net/wireless/mwifiex/11ac.c
 create mode 100644 drivers/net/wireless/mwifiex/11ac.h

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
new file mode 100644
index 0000000..cf43b3c
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -0,0 +1,261 @@
+/*
+ * Marvell Wireless LAN device driver: 802.11ac
+ *
+ * Copyright (C) 2013, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "decl.h"
+#include "ioctl.h"
+#include "fw.h"
+#include "main.h"
+#include "11ac.h"
+
+/* This function converts the 2-bit MCS map to the highest long GI
+ * VHT data rate.
+ */
+static u16
+mwifiex_convert_mcsmap_to_maxrate(struct mwifiex_private *priv,
+				  u8 bands, u16 mcs_map)
+{
+	u8 i, nss, max_mcs;
+	u16 max_rate = 0;
+	u32 usr_vht_cap_info = 0;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	/* tables of the MCS map to the highest data rate (in Mbps)
+	 * supported for long GI
+	 */
+	u16 max_rate_lgi_80MHZ[8][3] = {
+		{0x124, 0x15F, 0x186},	/* NSS = 1 */
+		{0x249, 0x2BE, 0x30C},  /* NSS = 2 */
+		{0x36D, 0x41D, 0x492},  /* NSS = 3 */
+		{0x492, 0x57C, 0x618},  /* NSS = 4 */
+		{0x5B6, 0x6DB, 0x79E},  /* NSS = 5 */
+		{0x6DB, 0x83A, 0x0},    /* NSS = 6 */
+		{0x7FF, 0x999, 0xAAA},  /* NSS = 7 */
+		{0x924, 0xAF8, 0xC30}   /* NSS = 8 */
+	};
+	u16 max_rate_lgi_160MHZ[8][3] = {
+		{0x249, 0x2BE, 0x30C},   /* NSS = 1 */
+		{0x492, 0x57C, 0x618},   /* NSS = 2 */
+		{0x6DB, 0x83A, 0x0},     /* NSS = 3 */
+		{0x924, 0xAF8, 0xC30},   /* NSS = 4 */
+		{0xB6D, 0xDB6, 0xF3C},   /* NSS = 5 */
+		{0xDB6, 0x1074, 0x1248}, /* NSS = 6 */
+		{0xFFF, 0x1332, 0x1554}, /* NSS = 7 */
+		{0x1248, 0x15F0, 0x1860} /* NSS = 8 */
+	};
+
+	if (bands & BAND_AAC)
+		usr_vht_cap_info = adapter->usr_dot_11ac_dev_cap_a;
+	else
+		usr_vht_cap_info = adapter->usr_dot_11ac_dev_cap_bg;
+
+	/* find the max NSS supported */
+	nss = 0;
+	for (i = 0; i < 8; i++) {
+		max_mcs = (mcs_map >> (2 * i)) & 0x3;
+		if (max_mcs < 3)
+			nss = i;
+	}
+	max_mcs = (mcs_map >> (2 * nss)) & 0x3;
+
+	/* if max_mcs is 3, nss must be 0 (SS = 1). Thus, max mcs is MCS 9 */
+	if (max_mcs >= 3)
+		max_mcs = 2;
+
+	if (GET_VHTCAP_CHWDSET(usr_vht_cap_info)) {
+		/* support 160 MHz */
+		max_rate = max_rate_lgi_160MHZ[nss][max_mcs];
+		if (!max_rate)
+			/* MCS9 is not supported in NSS6 */
+			max_rate = max_rate_lgi_160MHZ[nss][max_mcs - 1];
+	} else {
+		max_rate = max_rate_lgi_80MHZ[nss][max_mcs];
+		if (!max_rate)
+			/* MCS9 is not supported in NSS3 */
+			max_rate = max_rate_lgi_80MHZ[nss][max_mcs - 1];
+	}
+
+	return max_rate;
+}
+
+static void
+mwifiex_fill_vht_cap_info(struct mwifiex_private *priv,
+			  struct mwifiex_ie_types_vhtcap *vht_cap, u8 bands)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	if (bands & BAND_A)
+		vht_cap->vht_cap.vht_cap_info =
+				cpu_to_le32(adapter->usr_dot_11ac_dev_cap_a);
+	else
+		vht_cap->vht_cap.vht_cap_info =
+				cpu_to_le32(adapter->usr_dot_11ac_dev_cap_bg);
+}
+
+static void
+mwifiex_fill_vht_cap_tlv(struct mwifiex_private *priv,
+			 struct mwifiex_ie_types_vhtcap *vht_cap, u8 bands)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u16 mcs_map_user, mcs_map_resp, mcs_map_result;
+	u16 mcs_user, mcs_resp, nss, tmp;
+
+	/* Fill VHT cap info */
+	mwifiex_fill_vht_cap_info(priv, vht_cap, bands);
+
+	/* rx MCS Set: find the minimum of the user rx mcs and ap rx mcs */
+	mcs_map_user = GET_DEVRXMCSMAP(adapter->usr_dot_11ac_mcs_support);
+	mcs_map_resp = le16_to_cpu(vht_cap->vht_cap.supp_mcs.rx_mcs_map);
+	mcs_map_result = 0;
+
+	for (nss = 1; nss <= 8; nss++) {
+		mcs_user = GET_VHTNSSMCS(mcs_map_user, nss);
+		mcs_resp = GET_VHTNSSMCS(mcs_map_resp, nss);
+
+		if ((mcs_user == NO_NSS_SUPPORT) ||
+		    (mcs_resp == NO_NSS_SUPPORT))
+			SET_VHTNSSMCS(mcs_map_result, nss, NO_NSS_SUPPORT);
+		else
+			SET_VHTNSSMCS(mcs_map_result, nss,
+				      min(mcs_user, mcs_resp));
+	}
+
+	vht_cap->vht_cap.supp_mcs.rx_mcs_map = cpu_to_le16(mcs_map_result);
+
+	tmp = mwifiex_convert_mcsmap_to_maxrate(priv, bands, mcs_map_result);
+	vht_cap->vht_cap.supp_mcs.rx_highest = cpu_to_le16(tmp);
+
+	/* tx MCS Set: find the minimum of the user tx mcs and ap tx mcs */
+	mcs_map_user = GET_DEVTXMCSMAP(adapter->usr_dot_11ac_mcs_support);
+	mcs_map_resp = le16_to_cpu(vht_cap->vht_cap.supp_mcs.tx_mcs_map);
+	mcs_map_result = 0;
+
+	for (nss = 1; nss <= 8; nss++) {
+		mcs_user = GET_VHTNSSMCS(mcs_map_user, nss);
+		mcs_resp = GET_VHTNSSMCS(mcs_map_resp, nss);
+		if ((mcs_user == NO_NSS_SUPPORT) ||
+		    (mcs_resp == NO_NSS_SUPPORT))
+			SET_VHTNSSMCS(mcs_map_result, nss, NO_NSS_SUPPORT);
+		else
+			SET_VHTNSSMCS(mcs_map_result, nss,
+				      min(mcs_user, mcs_resp));
+	}
+
+	vht_cap->vht_cap.supp_mcs.tx_mcs_map = cpu_to_le16(mcs_map_result);
+
+	tmp = mwifiex_convert_mcsmap_to_maxrate(priv, bands, mcs_map_result);
+	vht_cap->vht_cap.supp_mcs.tx_highest = cpu_to_le16(tmp);
+
+	return;
+}
+
+int mwifiex_cmd_append_11ac_tlv(struct mwifiex_private *priv,
+			     struct mwifiex_bssdescriptor *bss_desc,
+			     u8 **buffer)
+{
+	struct mwifiex_ie_types_vhtcap *vht_cap;
+	struct mwifiex_ie_types_oper_mode_ntf *oper_ntf;
+	struct ieee_types_oper_mode_ntf *ieee_oper_ntf;
+	struct mwifiex_ie_types_vht_oper *vht_op;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 supp_chwd_set;
+	u32 usr_vht_cap_info;
+	int ret_len = 0;
+
+	if (bss_desc->bss_band & BAND_A)
+		usr_vht_cap_info = adapter->usr_dot_11ac_dev_cap_a;
+	else
+		usr_vht_cap_info = adapter->usr_dot_11ac_dev_cap_bg;
+
+	/* VHT Capabilities IE */
+	if (bss_desc->bcn_vht_cap) {
+		vht_cap = (struct mwifiex_ie_types_vhtcap *)*buffer;
+		memset(vht_cap, 0, sizeof(*vht_cap));
+		vht_cap->header.type = cpu_to_le16(WLAN_EID_VHT_CAPABILITY);
+		vht_cap->header.len  =
+				cpu_to_le16(sizeof(struct ieee80211_vht_cap));
+		memcpy((u8 *)vht_cap + sizeof(struct mwifiex_ie_types_header),
+		       (u8 *)bss_desc->bcn_vht_cap +
+		       sizeof(struct ieee_types_header),
+		       le16_to_cpu(vht_cap->header.len));
+
+		mwifiex_fill_vht_cap_tlv(priv, vht_cap, bss_desc->bss_band);
+		*buffer += sizeof(*vht_cap);
+		ret_len += sizeof(*vht_cap);
+	}
+
+	/* VHT Operation IE */
+	if (bss_desc->bcn_vht_oper) {
+		if (priv->bss_mode == HostCmd_BSS_MODE_IBSS) {
+			vht_op = (struct mwifiex_ie_types_vht_oper *)*buffer;
+			memset(vht_op, 0, sizeof(*vht_op));
+			vht_op->header.type =
+					cpu_to_le16(WLAN_EID_VHT_OPERATION);
+			vht_op->header.len  = cpu_to_le16(sizeof(*vht_op) -
+				      sizeof(struct mwifiex_ie_types_header));
+			memcpy((u8 *)vht_op +
+				sizeof(struct mwifiex_ie_types_header),
+			       (u8 *)bss_desc->bcn_vht_oper +
+			       sizeof(struct ieee_types_header),
+			       le16_to_cpu(vht_op->header.len));
+
+			/* negotiate the channel width and central freq
+			 * and keep the central freq as the peer suggests
+			 */
+			supp_chwd_set = GET_VHTCAP_CHWDSET(usr_vht_cap_info);
+
+			switch (supp_chwd_set) {
+			case 0:
+				vht_op->chan_width =
+				     min_t(u8, IEEE80211_VHT_CHANWIDTH_80MHZ,
+					   bss_desc->bcn_vht_oper->chan_width);
+				break;
+			case 1:
+				vht_op->chan_width =
+				     min_t(u8, IEEE80211_VHT_CHANWIDTH_160MHZ,
+					   bss_desc->bcn_vht_oper->chan_width);
+				break;
+			case 2:
+				vht_op->chan_width =
+				     min_t(u8, IEEE80211_VHT_CHANWIDTH_80P80MHZ,
+					   bss_desc->bcn_vht_oper->chan_width);
+				break;
+			default:
+				vht_op->chan_width =
+				     IEEE80211_VHT_CHANWIDTH_USE_HT;
+				break;
+			}
+
+			*buffer += sizeof(*vht_op);
+			ret_len += sizeof(*vht_op);
+		}
+	}
+
+	/* Operating Mode Notification IE */
+	if (bss_desc->oper_mode) {
+		ieee_oper_ntf = bss_desc->oper_mode;
+		oper_ntf = (void *)*buffer;
+		memset(oper_ntf, 0, sizeof(*oper_ntf));
+		oper_ntf->header.type = cpu_to_le16(WLAN_EID_OPMODE_NOTIF);
+		oper_ntf->header.len = cpu_to_le16(sizeof(u8));
+		oper_ntf->oper_mode = ieee_oper_ntf->oper_mode;
+		*buffer += sizeof(*oper_ntf);
+		ret_len += sizeof(*oper_ntf);
+	}
+
+	return ret_len;
+}
diff --git a/drivers/net/wireless/mwifiex/11ac.h b/drivers/net/wireless/mwifiex/11ac.h
new file mode 100644
index 0000000..80fd1ba
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/11ac.h
@@ -0,0 +1,26 @@
+/*
+ * Marvell Wireless LAN device driver: 802.11ac
+ *
+ * Copyright (C) 2013, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available by writing to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA or on the
+ * worldwide web at http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#ifndef _MWIFIEX_11AC_H_
+#define _MWIFIEX_11AC_H_
+
+int mwifiex_cmd_append_11ac_tlv(struct mwifiex_private *priv,
+				struct mwifiex_bssdescriptor *bss_desc,
+				u8 **buffer);
+#endif /* _MWIFIEX_11AC_H_ */
diff --git a/drivers/net/wireless/mwifiex/11n.c b/drivers/net/wireless/mwifiex/11n.c
index 48cc46b..5e4e51a 100644
--- a/drivers/net/wireless/mwifiex/11n.c
+++ b/drivers/net/wireless/mwifiex/11n.c
@@ -250,7 +250,8 @@ int mwifiex_cmd_amsdu_aggr_ctrl(struct host_cmd_ds_command *cmd,
  *      - Setting HT Tx capability and HT Tx information fields
  *      - Ensuring correct endian-ness
  */
-int mwifiex_cmd_11n_cfg(struct host_cmd_ds_command *cmd, u16 cmd_action,
+int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *cmd, u16 cmd_action,
 			struct mwifiex_ds_11n_tx_cfg *txcfg)
 {
 	struct host_cmd_ds_11n_cfg *htcfg = &cmd->params.htcfg;
@@ -260,6 +261,10 @@ int mwifiex_cmd_11n_cfg(struct host_cmd_ds_command *cmd, u16 cmd_action,
 	htcfg->action = cpu_to_le16(cmd_action);
 	htcfg->ht_tx_cap = cpu_to_le16(txcfg->tx_htcap);
 	htcfg->ht_tx_info = cpu_to_le16(txcfg->tx_htinfo);
+
+	if (priv->adapter->is_hw_11ac_capable)
+		htcfg->misc_config = cpu_to_le16(txcfg->misc_config);
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/mwifiex/11n.h b/drivers/net/wireless/mwifiex/11n.h
index 29a4c02..375db01 100644
--- a/drivers/net/wireless/mwifiex/11n.h
+++ b/drivers/net/wireless/mwifiex/11n.h
@@ -28,9 +28,9 @@ int mwifiex_ret_11n_delba(struct mwifiex_private *priv,
 			  struct host_cmd_ds_command *resp);
 int mwifiex_ret_11n_addba_req(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp);
-int mwifiex_cmd_11n_cfg(struct host_cmd_ds_command *cmd, u16 cmd_action,
+int mwifiex_cmd_11n_cfg(struct mwifiex_private *priv,
+			struct host_cmd_ds_command *cmd, u16 cmd_action,
 			struct mwifiex_ds_11n_tx_cfg *txcfg);
-
 int mwifiex_cmd_append_11n_tlv(struct mwifiex_private *priv,
 			       struct mwifiex_bssdescriptor *bss_desc,
 			       u8 **buffer);
diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index dd0410d..97b245c 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -23,6 +23,7 @@ mwifiex-y += util.o
 mwifiex-y += txrx.o
 mwifiex-y += wmm.o
 mwifiex-y += 11n.o
+mwifiex-y += 11ac.o
 mwifiex-y += 11n_aggr.o
 mwifiex-y += 11n_rxreorder.o
 mwifiex-y += scan.o
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 81c84a2..9667425 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -834,6 +834,66 @@ mwifiex_cfg80211_change_virtual_intf(struct wiphy *wiphy,
 	return ret;
 }
 
+static void
+mwifiex_parse_htinfo(struct mwifiex_private *priv, u8 tx_htinfo,
+		     struct rate_info *rate)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+
+	if (adapter->is_hw_11ac_capable) {
+		/* bit[1-0]: 00=LG 01=HT 10=VHT */
+		if (tx_htinfo & BIT(0)) {
+			/* HT */
+			rate->mcs = priv->tx_rate;
+			rate->flags |= RATE_INFO_FLAGS_MCS;
+		}
+		if (tx_htinfo & BIT(1)) {
+			/* VHT */
+			rate->mcs = priv->tx_rate & 0x0F;
+			rate->flags |= RATE_INFO_FLAGS_VHT_MCS;
+		}
+
+		if (tx_htinfo & (BIT(1) | BIT(0))) {
+			/* HT or VHT */
+			switch (tx_htinfo & (BIT(3) | BIT(2))) {
+			case 0:
+				/* This will be 20MHz */
+				break;
+			case (BIT(2)):
+				rate->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+				break;
+			case (BIT(3)):
+				rate->flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
+				break;
+			case (BIT(3) | BIT(2)):
+				rate->flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
+				break;
+			}
+
+			if (tx_htinfo & BIT(4))
+				rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
+
+			if ((priv->tx_rate >> 4) == 1)
+				rate->nss = 2;
+			else
+				rate->nss = 1;
+		}
+	} else {
+		/*
+		 * Bit 0 in tx_htinfo indicates that current Tx rate
+		 * is 11n rate. Valid MCS index values for us are 0 to 15.
+		 */
+		if ((tx_htinfo & BIT(0)) && (priv->tx_rate < 16)) {
+			rate->mcs = priv->tx_rate;
+			rate->flags |= RATE_INFO_FLAGS_MCS;
+			if (tx_htinfo & BIT(1))
+				rate->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+			if (tx_htinfo & BIT(2))
+				rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
+		}
+	}
+}
+
 /*
  * This function dumps the station information on a buffer.
  *
@@ -873,20 +933,7 @@ mwifiex_dump_station_info(struct mwifiex_private *priv,
 			      HostCmd_ACT_GEN_GET, DTIM_PERIOD_I,
 			      &priv->dtim_period);
 
-	/*
-	 * Bit 0 in tx_htinfo indicates that current Tx rate is 11n rate. Valid
-	 * MCS index values for us are 0 to 15.
-	 */
-	if ((priv->tx_htinfo & BIT(0)) && (priv->tx_rate < 16)) {
-		sinfo->txrate.mcs = priv->tx_rate;
-		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
-		/* 40MHz rate */
-		if (priv->tx_htinfo & BIT(1))
-			sinfo->txrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
-		/* SGI enabled */
-		if (priv->tx_htinfo & BIT(2))
-			sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
-	}
+	mwifiex_parse_htinfo(priv, priv->tx_htinfo, &sinfo->txrate);
 
 	sinfo->signal_avg = priv->bcn_rssi_avg;
 	sinfo->rx_bytes = priv->stats.rx_bytes;
@@ -1295,20 +1342,22 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 	/* Set appropriate bands */
 	if (params->chandef.chan->band == IEEE80211_BAND_2GHZ) {
 		bss_cfg->band_cfg = BAND_CONFIG_BG;
+		config_bands = BAND_B | BAND_G;
 
-		if (cfg80211_get_chandef_type(&params->chandef) ==
-						NL80211_CHAN_NO_HT)
-			config_bands = BAND_B | BAND_G;
-		else
-			config_bands = BAND_B | BAND_G | BAND_GN;
+		if (params->chandef.width > NL80211_CHAN_WIDTH_20_NOHT)
+			config_bands |= BAND_GN;
+
+		if (params->chandef.width > NL80211_CHAN_WIDTH_40)
+			config_bands |= BAND_GAC;
 	} else {
 		bss_cfg->band_cfg = BAND_CONFIG_A;
+		config_bands = BAND_A;
 
-		if (cfg80211_get_chandef_type(&params->chandef) ==
-						NL80211_CHAN_NO_HT)
-			config_bands = BAND_A;
-		else
-			config_bands = BAND_AN | BAND_A;
+		if (params->chandef.width > NL80211_CHAN_WIDTH_20_NOHT)
+			config_bands |= BAND_AN;
+
+		if (params->chandef.width > NL80211_CHAN_WIDTH_40)
+			config_bands |= BAND_AAC;
 	}
 
 	if (!((config_bands | priv->adapter->fw_bands) &
@@ -1881,6 +1930,79 @@ mwifiex_cfg80211_scan(struct wiphy *wiphy,
 	return 0;
 }
 
+static void mwifiex_setup_vht_caps(struct ieee80211_sta_vht_cap *vht_info,
+				   struct mwifiex_private *priv)
+{
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u32 vht_cap = 0, cap = adapter->hw_dot_11ac_dev_cap;
+
+	vht_info->vht_supported = true;
+
+	switch (GET_VHTCAP_MAXMPDULEN(cap)) {
+	case 0x00:
+		vht_cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_3895;
+		break;
+	case 0x01:
+		vht_cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_7991;
+		break;
+	case 0x10:
+		vht_cap |= IEEE80211_VHT_CAP_MAX_MPDU_LENGTH_11454;
+	    break;
+	default:
+	    dev_err(adapter->dev, "unsupported MAX MPDU len\n");
+	    break;
+	}
+
+	if (ISSUPP_11ACVHTHTCVHT(cap))
+		vht_cap |= IEEE80211_VHT_CAP_HTC_VHT;
+
+	if (ISSUPP_11ACVHTTXOPPS(cap))
+		vht_cap |= IEEE80211_VHT_CAP_VHT_TXOP_PS;
+
+	if (ISSUPP_11ACMURXBEAMFORMEE(cap))
+		vht_cap |= IEEE80211_VHT_CAP_MU_BEAMFORMER_CAPABLE;
+
+	if (ISSUPP_11ACMUTXBEAMFORMEE(cap))
+		vht_cap |= IEEE80211_VHT_CAP_MU_BEAMFORMEE_CAPABLE;
+
+	if (ISSUPP_11ACSUBEAMFORMER(cap))
+		vht_cap |= IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE;
+
+	if (ISSUPP_11ACSUBEAMFORMEE(cap))
+		vht_cap |= IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE;
+
+	if (ISSUPP_11ACRXSTBC(cap))
+		vht_cap |= IEEE80211_VHT_CAP_RXSTBC_1;
+
+	if (ISSUPP_11ACTXSTBC(cap))
+		vht_cap |= IEEE80211_VHT_CAP_TXSTBC;
+
+	if (ISSUPP_11ACSGI160(cap))
+		vht_cap |= IEEE80211_VHT_CAP_SHORT_GI_160;
+
+	if (ISSUPP_11ACSGI80(cap))
+		vht_cap |= IEEE80211_VHT_CAP_SHORT_GI_80;
+
+	if (ISSUPP_11ACLDPC(cap))
+		vht_cap |= IEEE80211_VHT_CAP_RXLDPC;
+
+	if (ISSUPP_11ACBW8080(cap))
+		vht_cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ;
+
+	if (ISSUPP_11ACBW160(cap))
+		vht_cap |= IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160MHZ;
+
+	vht_info->cap = vht_cap;
+
+	/* Update MCS support for VHT */
+	vht_info->vht_mcs.rx_mcs_map = cpu_to_le16(
+				adapter->hw_dot_11ac_mcs_support & 0xFFFF);
+	vht_info->vht_mcs.rx_highest = 0;
+	vht_info->vht_mcs.tx_mcs_map = cpu_to_le16(
+				adapter->hw_dot_11ac_mcs_support >> 16);
+	vht_info->vht_mcs.tx_highest = 0;
+}
+
 /*
  * This function sets up the CFG802.11 specific HT capability fields
  * with default values.
@@ -2094,11 +2216,18 @@ struct wireless_dev *mwifiex_add_virtual_intf(struct wiphy *wiphy,
 	priv->netdev = dev;
 
 	mwifiex_setup_ht_caps(&wiphy->bands[IEEE80211_BAND_2GHZ]->ht_cap, priv);
+	if (adapter->is_hw_11ac_capable)
+		mwifiex_setup_vht_caps(
+			&wiphy->bands[IEEE80211_BAND_2GHZ]->vht_cap, priv);
 
 	if (adapter->config_bands & BAND_A)
 		mwifiex_setup_ht_caps(
 			&wiphy->bands[IEEE80211_BAND_5GHZ]->ht_cap, priv);
 
+	if ((adapter->config_bands & BAND_A) && adapter->is_hw_11ac_capable)
+		mwifiex_setup_vht_caps(
+			&wiphy->bands[IEEE80211_BAND_5GHZ]->vht_cap, priv);
+
 	dev_net_set(dev, wiphy_net(wiphy));
 	dev->ieee80211_ptr = priv->wdev;
 	dev->ieee80211_ptr->iftype = priv->bss_mode;
diff --git a/drivers/net/wireless/mwifiex/cfp.c b/drivers/net/wireless/mwifiex/cfp.c
index f69300f..988552d 100644
--- a/drivers/net/wireless/mwifiex/cfp.c
+++ b/drivers/net/wireless/mwifiex/cfp.c
@@ -106,8 +106,8 @@ u8 *mwifiex_11d_code_2_region(u8 code)
  * This function maps an index in supported rates table into
  * the corresponding data rate.
  */
-u32 mwifiex_index_to_data_rate(struct mwifiex_private *priv, u8 index,
-							u8 ht_info)
+u32 mwifiex_index_to_acs_data_rate(struct mwifiex_private *priv,
+				   u8 index, u8 ht_info)
 {
 	/*
 	 * For every mcs_rate line, the first 8 bytes are for stream 1x1,
@@ -130,10 +130,155 @@ u32 mwifiex_index_to_data_rate(struct mwifiex_private *priv, u8 index,
 		{ 0x0e, 0x1c, 0x2b, 0x39, 0x56, 0x73, 0x82, 0x90,
 		  0x1c, 0x39, 0x56, 0x73, 0xad, 0xe7, 0x104, 0x120 }
 	};
+	/* AC rates */
+	u16 ac_mcs_rate_nss1[8][10] = {
+		/* LG 160M */
+		{ 0x75, 0xEA, 0x15F, 0x1D4, 0x2BE, 0x3A8, 0x41D,
+		  0x492, 0x57C, 0x618 },
+
+		/* SG 160M */
+		{ 0x82, 0x104, 0x186, 0x208, 0x30C, 0x410, 0x492,
+		  0x514, 0x618, 0x6C6 },
+
+		/* LG 80M */
+		{ 0x3B, 0x75, 0xB0, 0xEA, 0x15F, 0x1D4, 0x20F,
+		  0x249, 0x2BE, 0x30C },
+
+		/* SG 80M */
+		{ 0x41, 0x82, 0xC3, 0x104, 0x186, 0x208, 0x249,
+		  0x28A, 0x30C, 0x363 },
+
+		/* LG 40M */
+		{ 0x1B, 0x36, 0x51, 0x6C, 0xA2, 0xD8, 0xF3,
+		  0x10E, 0x144, 0x168 },
+
+		/* SG 40M */
+		{ 0x1E, 0x3C, 0x5A, 0x78, 0xB4, 0xF0, 0x10E,
+		  0x12C, 0x168, 0x190 },
+
+		/* LG 20M */
+		{ 0xD, 0x1A, 0x27, 0x34, 0x4E, 0x68, 0x75, 0x82, 0x9C, 0x00 },
+
+		/* SG 20M */
+		{ 0xF, 0x1D, 0x2C, 0x3A, 0x57, 0x74, 0x82, 0x91, 0xAE, 0x00 },
+	};
+	/* NSS2 note: the value in the table is 2 multiplier of the actual
+	 * rate
+	 */
+	u16 ac_mcs_rate_nss2[8][10] = {
+		/* LG 160M */
+		{ 0xEA, 0x1D4, 0x2BE, 0x3A8, 0x57C, 0x750, 0x83A,
+		  0x924, 0xAF8, 0xC30 },
+
+		/* SG 160M */
+		{ 0x104, 0x208, 0x30C, 0x410, 0x618, 0x820, 0x924,
+		  0xA28, 0xC30, 0xD8B },
+
+		/* LG 80M */
+		{ 0x75, 0xEA, 0x15F, 0x1D4, 0x2BE, 0x3A8, 0x41D,
+		  0x492, 0x57C, 0x618 },
+
+		/* SG 80M */
+		{ 0x82, 0x104, 0x186, 0x208, 0x30C, 0x410, 0x492,
+		  0x514, 0x618, 0x6C6 },
+
+		/* LG 40M */
+		{ 0x36, 0x6C, 0xA2, 0xD8, 0x144, 0x1B0, 0x1E6,
+		  0x21C, 0x288, 0x2D0 },
+
+		/* SG 40M */
+		{ 0x3C, 0x78, 0xB4, 0xF0, 0x168, 0x1E0, 0x21C,
+		  0x258, 0x2D0, 0x320 },
+
+		/* LG 20M */
+		{ 0x1A, 0x34, 0x4A, 0x68, 0x9C, 0xD0, 0xEA, 0x104,
+		  0x138, 0x00 },
+
+		/* SG 20M */
+		{ 0x1D, 0x3A, 0x57, 0x74, 0xAE, 0xE6, 0x104, 0x121,
+		  0x15B, 0x00 },
+	};
+	u32 rate = 0;
+	u8 mcs_index = 0;
+	u8 bw = 0;
+	u8 gi = 0;
+
+	if ((ht_info & 0x3) == MWIFIEX_RATE_FORMAT_VHT) {
+		mcs_index = min(index & 0xF, 9);
+
+		/* 20M: bw=0, 40M: bw=1, 80M: bw=2, 160M: bw=3 */
+		bw = (ht_info & 0xC) >> 2;
+
+		/* LGI: gi =0, SGI: gi = 1 */
+		gi = (ht_info & 0x10) >> 4;
+
+		if ((index >> 4) == 1)	/* NSS = 2 */
+			rate = ac_mcs_rate_nss2[2 * (3 - bw) + gi][mcs_index];
+		else			/* NSS = 1 */
+			rate = ac_mcs_rate_nss1[2 * (3 - bw) + gi][mcs_index];
+	} else if ((ht_info & 0x3) == MWIFIEX_RATE_FORMAT_HT) {
+		/* 20M: bw=0, 40M: bw=1 */
+		bw = (ht_info & 0xC) >> 2;
+
+		/* LGI: gi =0, SGI: gi = 1 */
+		gi = (ht_info & 0x10) >> 4;
+
+		if (index == MWIFIEX_RATE_BITMAP_MCS0) {
+			if (gi == 1)
+				rate = 0x0D;    /* MCS 32 SGI rate */
+			else
+				rate = 0x0C;    /* MCS 32 LGI rate */
+		} else if (index < 16) {
+			if ((bw == 1) || (bw == 0))
+				rate = mcs_rate[2 * (1 - bw) + gi][index];
+			else
+				rate = mwifiex_data_rates[0];
+		} else {
+			rate = mwifiex_data_rates[0];
+		}
+	} else {
+		/* 11n non-HT rates */
+		if (index >= MWIFIEX_SUPPORTED_RATES_EXT)
+			index = 0;
+		rate = mwifiex_data_rates[index];
+	}
+
+	return rate;
+}
+
+/* This function maps an index in supported rates table into
+ * the corresponding data rate.
+ */
+u32 mwifiex_index_to_data_rate(struct mwifiex_private *priv,
+			       u8 index, u8 ht_info)
+{
+	/* For every mcs_rate line, the first 8 bytes are for stream 1x1,
+	 * and all 16 bytes are for stream 2x2.
+	 */
+	u16  mcs_rate[4][16] = {
+		/* LGI 40M */
+		{ 0x1b, 0x36, 0x51, 0x6c, 0xa2, 0xd8, 0xf3, 0x10e,
+		  0x36, 0x6c, 0xa2, 0xd8, 0x144, 0x1b0, 0x1e6, 0x21c },
+
+		/* SGI 40M */
+		{ 0x1e, 0x3c, 0x5a, 0x78, 0xb4, 0xf0, 0x10e, 0x12c,
+		  0x3c, 0x78, 0xb4, 0xf0, 0x168, 0x1e0, 0x21c, 0x258 },
+
+		/* LGI 20M */
+		{ 0x0d, 0x1a, 0x27, 0x34, 0x4e, 0x68, 0x75, 0x82,
+		  0x1a, 0x34, 0x4e, 0x68, 0x9c, 0xd0, 0xea, 0x104 },
+
+		/* SGI 20M */
+		{ 0x0e, 0x1c, 0x2b, 0x39, 0x56, 0x73, 0x82, 0x90,
+		  0x1c, 0x39, 0x56, 0x73, 0xad, 0xe7, 0x104, 0x120 }
+	};
 	u32 mcs_num_supp =
 		(priv->adapter->hw_dev_mcs_support == HT_STREAM_2X2) ? 16 : 8;
 	u32 rate;
 
+	if (priv->adapter->is_hw_11ac_capable)
+		return mwifiex_index_to_acs_data_rate(priv, index, ht_info);
+
 	if (ht_info & BIT(0)) {
 		if (index == MWIFIEX_RATE_BITMAP_MCS0) {
 			if (ht_info & BIT(2))
@@ -269,6 +414,7 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 {
 	u32 k = 0;
 	struct mwifiex_adapter *adapter = priv->adapter;
+
 	if (priv->bss_mode == NL80211_IFTYPE_STATION) {
 		switch (adapter->config_bands) {
 		case BAND_B:
@@ -279,6 +425,7 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 			break;
 		case BAND_G:
 		case BAND_G | BAND_GN:
+		case BAND_G | BAND_GN | BAND_GAC:
 			dev_dbg(adapter->dev, "info: infra band=%d "
 				"supported_rates_g\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_g,
@@ -288,7 +435,11 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 		case BAND_A | BAND_B | BAND_G:
 		case BAND_A | BAND_B:
 		case BAND_A | BAND_B | BAND_G | BAND_GN | BAND_AN:
+		case BAND_A | BAND_B | BAND_G | BAND_GN | BAND_AN | BAND_AAC:
+		case BAND_A | BAND_B | BAND_G | BAND_GN | BAND_AN |
+		     BAND_AAC | BAND_GAC:
 		case BAND_B | BAND_G | BAND_GN:
+		case BAND_B | BAND_G | BAND_GN | BAND_GAC:
 			dev_dbg(adapter->dev, "info: infra band=%d "
 				"supported_rates_bg\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_bg,
@@ -301,14 +452,18 @@ u32 mwifiex_get_supported_rates(struct mwifiex_private *priv, u8 *rates)
 			k = mwifiex_copy_rates(rates, k, supported_rates_a,
 					       sizeof(supported_rates_a));
 			break;
+		case BAND_AN:
 		case BAND_A | BAND_AN:
+		case BAND_A | BAND_AN | BAND_AAC:
 		case BAND_A | BAND_G | BAND_AN | BAND_GN:
+		case BAND_A | BAND_G | BAND_AN | BAND_GN | BAND_AAC:
 			dev_dbg(adapter->dev, "info: infra band=%d "
 				"supported_rates_a\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_a,
 					       sizeof(supported_rates_a));
 			break;
 		case BAND_GN:
+		case BAND_GN | BAND_GAC:
 			dev_dbg(adapter->dev, "info: infra band=%d "
 				"supported_rates_n\n", adapter->config_bands);
 			k = mwifiex_copy_rates(rates, k, supported_rates_n,
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 5f438e6..5019f1f 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -24,6 +24,7 @@
 #include "main.h"
 #include "wmm.h"
 #include "11n.h"
+#include "11ac.h"
 
 /*
  * This function initializes a command node.
@@ -1470,6 +1471,24 @@ int mwifiex_ret_get_hw_spec(struct mwifiex_private *priv,
 	adapter->fw_release_number = le32_to_cpu(hw_spec->fw_release_number);
 	adapter->number_of_antenna = le16_to_cpu(hw_spec->number_of_antenna);
 
+	if (le32_to_cpu(hw_spec->dot_11ac_dev_cap)) {
+		adapter->is_hw_11ac_capable = true;
+
+		/* Copy 11AC cap */
+		adapter->hw_dot_11ac_dev_cap =
+					le32_to_cpu(hw_spec->dot_11ac_dev_cap);
+		adapter->usr_dot_11ac_dev_cap_bg = adapter->hw_dot_11ac_dev_cap;
+		adapter->usr_dot_11ac_dev_cap_a = adapter->hw_dot_11ac_dev_cap;
+
+		/* Copy 11AC mcs */
+		adapter->hw_dot_11ac_mcs_support =
+				le32_to_cpu(hw_spec->dot_11ac_mcs_support);
+		adapter->usr_dot_11ac_mcs_support =
+					adapter->hw_dot_11ac_mcs_support;
+	} else {
+		adapter->is_hw_11ac_capable = false;
+	}
+
 	dev_dbg(adapter->dev, "info: GET_HW_SPEC: fw_release_number- %#x\n",
 		adapter->fw_release_number);
 	dev_dbg(adapter->dev, "info: GET_HW_SPEC: permanent addr: %pM\n",
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index ebe2f6a..25acb06 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -49,13 +49,23 @@ struct tx_packet_hdr {
 #define A_SUPPORTED_RATES               9
 #define HOSTCMD_SUPPORTED_RATES         14
 #define N_SUPPORTED_RATES               3
-#define ALL_802_11_BANDS           (BAND_A | BAND_B | BAND_G | BAND_GN)
+#define ALL_802_11_BANDS           (BAND_A | BAND_B | BAND_G | BAND_GN | \
+				    BAND_AN | BAND_GAC | BAND_AAC)
 
-#define FW_MULTI_BANDS_SUPPORT  (BIT(8) | BIT(9) | BIT(10) | BIT(11))
+#define FW_MULTI_BANDS_SUPPORT  (BIT(8) | BIT(9) | BIT(10) | BIT(11) | \
+				 BIT(12) | BIT(13))
 #define IS_SUPPORT_MULTI_BANDS(adapter)        \
 	(adapter->fw_cap_info & FW_MULTI_BANDS_SUPPORT)
+
+/* shift bit 12 and bit 13 in fw_cap_info from the firmware to bit 13 and 14
+ * for 11ac so that bit 11 is for GN, bit 12 for AN, bit 13 for GAC, and bit
+ * bit 14 for AAC, in order to be compatible with the band capability
+ * defined in the driver after right shift of 8 bits.
+ */
 #define GET_FW_DEFAULT_BANDS(adapter)  \
-	((adapter->fw_cap_info >> 8) & ALL_802_11_BANDS)
+	    (((((adapter->fw_cap_info & 0x3000) << 1) | \
+	       (adapter->fw_cap_info & ~0xF000)) >> 8) & \
+	     ALL_802_11_BANDS)
 
 #define HostCmd_WEP_KEY_INDEX_MASK              0x3fff
 
@@ -216,6 +226,47 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 
 #define LLC_SNAP_LEN    8
 
+/* HW_SPEC fw_cap_info */
+
+#define ISSUPP_11ACENABLED(fw_cap_info) (fw_cap_info & (BIT(13)|BIT(14)))
+
+#define GET_VHTCAP_MAXMPDULEN(vht_cap_info) (vht_cap_info & 0x3)
+#define GET_VHTCAP_CHWDSET(vht_cap_info)    ((vht_cap_info >> 2) & 0x3)
+#define GET_VHTNSSMCS(mcs_mapset, nss) ((mcs_mapset >> (2 * (nss - 1))) & 0x3)
+#define SET_VHTNSSMCS(mcs_mapset, nss, value) (mcs_mapset |= (value & 0x3) << \
+					      (2 * (nss - 1)))
+#define NO_NSS_SUPPORT		0x3
+
+/* HW_SPEC: HTC-VHT supported */
+#define ISSUPP_11ACVHTHTCVHT(Dot11acDevCap) (Dot11acDevCap & BIT(22))
+/* HW_SPEC: VHT TXOP PS support */
+#define ISSUPP_11ACVHTTXOPPS(Dot11acDevCap) (Dot11acDevCap & BIT(21))
+/* HW_SPEC: MU RX beamformee support */
+#define ISSUPP_11ACMURXBEAMFORMEE(Dot11acDevCap) (Dot11acDevCap & BIT(20))
+/* HW_SPEC: MU TX beamformee support */
+#define ISSUPP_11ACMUTXBEAMFORMEE(Dot11acDevCap) (Dot11acDevCap & BIT(19))
+/* HW_SPEC: SU Beamformee support */
+#define ISSUPP_11ACSUBEAMFORMEE(Dot11acDevCap) (Dot11acDevCap & BIT(10))
+/* HW_SPEC: SU Beamformer support */
+#define ISSUPP_11ACSUBEAMFORMER(Dot11acDevCap) (Dot11acDevCap & BIT(9))
+/* HW_SPEC: Rx STBC support */
+#define ISSUPP_11ACRXSTBC(Dot11acDevCap) (Dot11acDevCap & BIT(8))
+/* HW_SPEC: Tx STBC support */
+#define ISSUPP_11ACTXSTBC(Dot11acDevCap) (Dot11acDevCap & BIT(7))
+/* HW_SPEC: Short GI support for 160MHz BW */
+#define ISSUPP_11ACSGI160(Dot11acDevCap) (Dot11acDevCap & BIT(6))
+/* HW_SPEC: Short GI support for 80MHz BW */
+#define ISSUPP_11ACSGI80(Dot11acDevCap) (Dot11acDevCap & BIT(5))
+/* HW_SPEC: LDPC coding support */
+#define ISSUPP_11ACLDPC(Dot11acDevCap) (Dot11acDevCap & BIT(4))
+/* HW_SPEC: Channel BW 20/40/80/160/80+80 MHz support */
+#define ISSUPP_11ACBW8080(Dot11acDevCap) (Dot11acDevCap & BIT(3))
+/* HW_SPEC: Channel BW 20/40/80/160 MHz support */
+#define ISSUPP_11ACBW160(Dot11acDevCap) (Dot11acDevCap & BIT(2))
+
+#define GET_DEVTXMCSMAP(dev_mcs_map)      (dev_mcs_map >> 16)
+#define GET_DEVRXMCSMAP(dev_mcs_map)      (dev_mcs_map & 0xFFFF)
+
 #define MOD_CLASS_HR_DSSS       0x03
 #define MOD_CLASS_OFDM          0x07
 #define MOD_CLASS_HT            0x08
@@ -455,9 +506,22 @@ struct rxpd {
 	u8 rx_rate;
 	s8 snr;
 	s8 nf;
-	/* Ht Info [Bit 0] RxRate format: LG=0, HT=1
+
+	/* For: Non-802.11 AC cards
+	 *
+	 * Ht Info [Bit 0] RxRate format: LG=0, HT=1
 	 * [Bit 1]  HT Bandwidth: BW20 = 0, BW40 = 1
-	 * [Bit 2]  HT Guard Interval: LGI = 0, SGI = 1 */
+	 * [Bit 2]  HT Guard Interval: LGI = 0, SGI = 1
+	 *
+	 * For: 802.11 AC cards
+	 * [Bit 1] [Bit 0] RxRate format: legacy rate = 00 HT = 01 VHT = 10
+	 * [Bit 3] [Bit 2] HT/VHT Bandwidth BW20 = 00 BW40 = 01
+	 *						BW80 = 10  BW160 = 11
+	 * [Bit 4] HT/VHT Guard interval LGI = 0 SGI = 1
+	 * [Bit 5] STBC support Enabled = 1
+	 * [Bit 6] LDPC support Enabled = 1
+	 * [Bit 7] Reserved
+	 */
 	u8 ht_info;
 	u8 reserved;
 } __packed;
@@ -680,7 +744,11 @@ struct host_cmd_ds_get_hw_spec {
 	__le32 dot_11n_dev_cap;
 	u8 dev_mcs_support;
 	__le16 mp_end_port;	/* SDIO only, reserved for other interfacces */
-	__le16 reserved_4;
+	__le16 mgmt_buf_count;	/* mgmt IE buffer count */
+	__le32 reserved_5;
+	__le32 reserved_6;
+	__le32 dot_11ac_dev_cap;
+	__le32 dot_11ac_mcs_support;
 } __packed;
 
 struct host_cmd_ds_802_11_rssi_info {
@@ -786,6 +854,12 @@ union ieee_types_phy_param_set {
 	struct ieee_types_ds_param_set ds_param_set;
 } __packed;
 
+struct ieee_types_oper_mode_ntf {
+	u8 element_id;
+	u8 len;
+	u8 oper_mode;
+} __packed;
+
 struct host_cmd_ds_802_11_ad_hoc_start {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 bss_mode;
@@ -846,11 +920,27 @@ struct host_cmd_ds_802_11_get_log {
 	__le32 wep_icv_err_cnt[4];
 };
 
+/* Enumeration for rate format */
+enum _mwifiex_rate_format {
+	MWIFIEX_RATE_FORMAT_LG = 0,
+	MWIFIEX_RATE_FORMAT_HT,
+	MWIFIEX_RATE_FORMAT_VHT,
+	MWIFIEX_RATE_FORMAT_AUTO = 0xFF,
+};
+
 struct host_cmd_ds_tx_rate_query {
 	u8 tx_rate;
-	/* Ht Info [Bit 0] RxRate format: LG=0, HT=1
+	/* Tx Rate Info: For 802.11 AC cards
+	 *
+	 * [Bit 0-1] tx rate formate: LG = 0, HT = 1, VHT = 2
+	 * [Bit 2-3] HT/VHT Bandwidth: BW20 = 0, BW40 = 1, BW80 = 2, BW160 = 3
+	 * [Bit 4]   HT/VHT Guard Interval: LGI = 0, SGI = 1
+	 *
+	 * For non-802.11 AC cards
+	 * Ht Info [Bit 0] RxRate format: LG=0, HT=1
 	 * [Bit 1]  HT Bandwidth: BW20 = 0, BW40 = 1
-	 * [Bit 2]  HT Guard Interval: LGI = 0, SGI = 1 */
+	 * [Bit 2]  HT Guard Interval: LGI = 0, SGI = 1
+	 */
 	u8 ht_info;
 } __packed;
 
@@ -1096,6 +1186,7 @@ struct host_cmd_ds_11n_cfg {
 	__le16 action;
 	__le16 ht_tx_cap;
 	__le16 ht_tx_info;
+	__le16 misc_config;	/* Needed for 802.11AC cards only */
 } __packed;
 
 struct host_cmd_ds_txbuf_cfg {
@@ -1183,6 +1274,26 @@ struct mwifiex_ie_types_htcap {
 	struct ieee80211_ht_cap ht_cap;
 } __packed;
 
+struct mwifiex_ie_types_vhtcap {
+	struct mwifiex_ie_types_header header;
+	struct ieee80211_vht_cap vht_cap;
+} __packed;
+
+struct mwifiex_ie_types_oper_mode_ntf {
+	struct mwifiex_ie_types_header header;
+	u8 oper_mode;
+} __packed;
+
+/* VHT Operations IE */
+struct mwifiex_ie_types_vht_oper {
+	struct mwifiex_ie_types_header header;
+	u8 chan_width;
+	u8 chan_center_freq_1;
+	u8 chan_center_freq_2;
+	/* Basic MCS set map, each 2 bits stands for a NSS */
+	u16 basic_mcs_map;
+} __packed;
+
 struct mwifiex_ie_types_wmmcap {
 	struct mwifiex_ie_types_header header;
 	struct mwifiex_types_wmm_info wmm_info;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index f3d9d04..d85e6eb 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -60,6 +60,8 @@ enum {
 	BAND_A = 4,
 	BAND_GN = 8,
 	BAND_AN = 16,
+	BAND_GAC = 32,
+	BAND_AAC = 64,
 };
 
 #define MWIFIEX_WPA_PASSHPHRASE_LEN 64
@@ -103,6 +105,7 @@ struct mwifiex_uap_bss_param {
 	struct wpa_param wpa_cfg;
 	struct wep_key wep_cfg[NUM_WEP_KEYS];
 	struct ieee80211_ht_cap ht_cap;
+	struct ieee80211_vht_cap vht_cap;
 	u8 rates[MWIFIEX_SUPPORTED_RATES];
 	u32 sta_ao_timer;
 	u32 ps_sta_ao_timer;
@@ -272,6 +275,7 @@ struct mwifiex_ds_pm_cfg {
 struct mwifiex_ds_11n_tx_cfg {
 	u16 tx_htcap;
 	u16 tx_htinfo;
+	u16 misc_config; /* Needed for 802.11AC cards only */
 };
 
 struct mwifiex_ds_11n_amsdu_aggr_ctrl {
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index a537297..246aa62 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -24,6 +24,7 @@
 #include "main.h"
 #include "wmm.h"
 #include "11n.h"
+#include "11ac.h"
 
 #define CAPINFO_MASK    (~(BIT(15) | BIT(14) | BIT(12) | BIT(11) | BIT(9)))
 
@@ -512,6 +513,12 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 	     priv->adapter->config_bands & BAND_AN))
 		mwifiex_cmd_append_11n_tlv(priv, bss_desc, &pos);
 
+	if (ISSUPP_11ACENABLED(priv->adapter->fw_cap_info) &&
+	    !bss_desc->disable_11n && !bss_desc->disable_11ac &&
+	    (priv->adapter->config_bands & BAND_GAC ||
+	     priv->adapter->config_bands & BAND_AAC))
+		mwifiex_cmd_append_11ac_tlv(priv, bss_desc, &pos);
+
 	/* Append vendor specific IE TLV */
 	mwifiex_cmd_append_vsie_tlv(priv, MWIFIEX_VSIE_MASK_ASSOC, &pos);
 
@@ -1421,6 +1428,7 @@ mwifiex_band_to_radio_type(u8 band)
 	case BAND_A:
 	case BAND_AN:
 	case BAND_A | BAND_AN:
+	case BAND_A | BAND_AN | BAND_AAC:
 		return HostCmd_SCAN_RADIO_TYPE_A;
 	case BAND_B:
 	case BAND_G:
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ac799a0..553adfb 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -295,6 +295,13 @@ struct mwifiex_bssdescriptor {
 	u16 bss_co_2040_offset;
 	u8 *bcn_ext_cap;
 	u16 ext_cap_offset;
+	struct ieee80211_vht_cap *bcn_vht_cap;
+	u16 vht_cap_offset;
+	struct ieee80211_vht_operation *bcn_vht_oper;
+	u16 vht_info_offset;
+	struct ieee_types_oper_mode_ntf *oper_mode;
+	u16 oper_mode_offset;
+	u8 disable_11ac;
 	struct ieee_types_vendor_specific *bcn_wpa_ie;
 	u16 wpa_offset;
 	struct ieee_types_generic *bcn_rsn_ie;
@@ -499,6 +506,7 @@ struct mwifiex_private {
 	u16 rsn_idx;
 	struct timer_list scan_delay_timer;
 	u8 ap_11n_enabled;
+	u8 ap_11ac_enabled;
 	u32 mgmt_frame_mask;
 	struct mwifiex_roc_cfg roc_cfg;
 };
@@ -722,6 +730,15 @@ struct mwifiex_adapter {
 	u16 max_mgmt_ie_index;
 	u8 scan_delay_cnt;
 	u8 empty_tx_q_cnt;
+
+	/* 11AC */
+	u32 is_hw_11ac_capable;
+	u32 hw_dot_11ac_dev_cap;
+	u32 hw_dot_11ac_mcs_support;
+	u32 usr_dot_11ac_dev_cap_bg;
+	u32 usr_dot_11ac_dev_cap_a;
+	u32 usr_dot_11ac_mcs_support;
+
 	atomic_t is_tx_received;
 	atomic_t pending_bridged_pkts;
 };
@@ -864,8 +881,10 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 int mwifiex_cmd_802_11_bg_scan_query(struct host_cmd_ds_command *cmd);
 struct mwifiex_chan_freq_power *mwifiex_get_cfp(struct mwifiex_private *priv,
 						u8 band, u16 channel, u32 freq);
-u32 mwifiex_index_to_data_rate(struct mwifiex_private *priv, u8 index,
-							u8 ht_info);
+u32 mwifiex_index_to_data_rate(struct mwifiex_private *priv,
+			       u8 index, u8 ht_info);
+u32 mwifiex_index_to_acs_data_rate(struct mwifiex_private *priv,
+				   u8 index, u8 ht_info);
 u32 mwifiex_find_freq_from_band_chan(u8, u8);
 int mwifiex_cmd_append_vsie_tlv(struct mwifiex_private *priv, u16 vsie_mask,
 				u8 **buffer);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index e275aec..db4d5ae 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -1250,6 +1250,23 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					sizeof(struct ieee_types_header) -
 					bss_entry->beacon_buf);
 			break;
+		case WLAN_EID_VHT_CAPABILITY:
+			bss_entry->disable_11ac = false;
+			bss_entry->bcn_vht_cap =
+				(void *)(current_ptr +
+					 sizeof(struct ieee_types_header));
+			bss_entry->vht_cap_offset =
+					(u16)((u8 *)bss_entry->bcn_vht_cap -
+					      bss_entry->beacon_buf);
+			break;
+		case WLAN_EID_VHT_OPERATION:
+			bss_entry->bcn_vht_oper =
+				(void *)(current_ptr +
+					 sizeof(struct ieee_types_header));
+			bss_entry->vht_info_offset =
+					(u16)((u8 *)bss_entry->bcn_vht_oper -
+					      bss_entry->beacon_buf);
+			break;
 		case WLAN_EID_BSS_COEX_2040:
 			bss_entry->bcn_bss_co_2040 = current_ptr +
 				sizeof(struct ieee_types_header);
@@ -1264,6 +1281,14 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 					sizeof(struct ieee_types_header) -
 					bss_entry->beacon_buf);
 			break;
+		case WLAN_EID_OPMODE_NOTIF:
+			bss_entry->oper_mode =
+				(void *)(current_ptr +
+					 sizeof(struct ieee_types_header));
+			bss_entry->oper_mode_offset =
+					(u16)((u8 *)bss_entry->oper_mode -
+					      bss_entry->beacon_buf);
+			break;
 		default:
 			break;
 		}
@@ -1494,6 +1519,17 @@ static int mwifiex_update_curr_bss_params(struct mwifiex_private *priv,
 	priv->curr_bss_params.bss_descriptor.ext_cap_offset = 0;
 	priv->curr_bss_params.bss_descriptor.beacon_buf = NULL;
 	priv->curr_bss_params.bss_descriptor.beacon_buf_size = 0;
+	priv->curr_bss_params.bss_descriptor.bcn_vht_cap = NULL;
+	priv->curr_bss_params.bss_descriptor.vht_cap_offset = 0;
+	priv->curr_bss_params.bss_descriptor.bcn_vht_oper = NULL;
+	priv->curr_bss_params.bss_descriptor.vht_info_offset = 0;
+	priv->curr_bss_params.bss_descriptor.oper_mode = NULL;
+	priv->curr_bss_params.bss_descriptor.oper_mode_offset = 0;
+
+	/* Disable 11ac by default. Enable it only where there
+	 * exist VHT_CAP IE in AP beacon
+	 */
+	priv->curr_bss_params.bss_descriptor.disable_11ac = true;
 
 	/* Make a copy of current BSSID descriptor */
 	memcpy(&priv->curr_bss_params.bss_descriptor, bss_desc,
@@ -2028,6 +2064,14 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 			(curr_bss->beacon_buf +
 			 curr_bss->ht_info_offset);
 
+	if (curr_bss->bcn_vht_cap)
+		curr_bss->bcn_ht_cap = (void *)(curr_bss->beacon_buf +
+						curr_bss->vht_cap_offset);
+
+	if (curr_bss->bcn_vht_oper)
+		curr_bss->bcn_ht_oper = (void *)(curr_bss->beacon_buf +
+						 curr_bss->vht_info_offset);
+
 	if (curr_bss->bcn_bss_co_2040)
 		curr_bss->bcn_bss_co_2040 =
 			(curr_bss->beacon_buf + curr_bss->bss_co_2040_offset);
@@ -2035,6 +2079,10 @@ mwifiex_save_curr_bcn(struct mwifiex_private *priv)
 	if (curr_bss->bcn_ext_cap)
 		curr_bss->bcn_ext_cap = curr_bss->beacon_buf +
 			curr_bss->ext_cap_offset;
+
+	if (curr_bss->oper_mode)
+		curr_bss->oper_mode = (void *)(curr_bss->beacon_buf +
+					       curr_bss->oper_mode_offset);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index c460785..c55c5bb 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1230,7 +1230,7 @@ int mwifiex_sta_prepare_cmd(struct mwifiex_private *priv, uint16_t cmd_no,
 						  data_buf);
 		break;
 	case HostCmd_CMD_11N_CFG:
-		ret = mwifiex_cmd_11n_cfg(cmd_ptr, cmd_action, data_buf);
+		ret = mwifiex_cmd_11n_cfg(priv, cmd_ptr, cmd_action, data_buf);
 		break;
 	case HostCmd_CMD_WMM_GET_STATUS:
 		dev_dbg(priv->adapter->dev,
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 8470564..4669f8d 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -24,6 +24,7 @@
 #include "main.h"
 #include "wmm.h"
 #include "11n.h"
+#include "11ac.h"
 
 
 /*
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 0d01846..7ce72e9 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -283,9 +283,10 @@ int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 
 			if (mwifiex_band_to_radio_type((u8) bss_desc->bss_band)
 			    == HostCmd_SCAN_RADIO_TYPE_BG)
-				config_bands = BAND_B | BAND_G | BAND_GN;
+				config_bands = BAND_B | BAND_G | BAND_GN |
+					       BAND_GAC;
 			else
-				config_bands = BAND_A | BAND_AN;
+				config_bands = BAND_A | BAND_AN | BAND_AAC;
 
 			if (!((config_bands | adapter->fw_bands) &
 			      ~adapter->fw_bands))
-- 
1.7.0.2

