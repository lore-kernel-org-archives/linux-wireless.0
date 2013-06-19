Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:45340 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934108Ab3FSPv6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 11:51:58 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>,
	Bing Zhao <bzhao@marvell.com>,
	Paul Stewart <pstew@chromium.org>
Subject: [PATCH 2/3 v2] mwifiex: add basic 11h support for station
Date: Wed, 19 Jun 2013 08:49:05 -0700
Message-ID: <1371656945-28009-1-git-send-email-bzhao@marvell.com> (sfid-20130619_175206_035889_787832F1)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

This patch adds code to parse requested AP's 11h capabilities
and add 11h information in association request.

Also, deauth is sent to the AP after receiving channel switch
announcement event from firmware. This happens when AP advertises
WLAN_EID_CHANNEL_SWITCH IE in it's beacon.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Paul Stewart <pstew@chromium.org>
---
v2: fix missing 'break' statement (John W. Linville)

 drivers/net/wireless/mwifiex/11h.c       | 101 +++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/Makefile    |   1 +
 drivers/net/wireless/mwifiex/fw.h        |  14 +++++
 drivers/net/wireless/mwifiex/join.c      |   2 +
 drivers/net/wireless/mwifiex/main.h      |   7 +++
 drivers/net/wireless/mwifiex/scan.c      |  19 ++++++
 drivers/net/wireless/mwifiex/sta_event.c |   8 +++
 drivers/net/wireless/mwifiex/sta_ioctl.c |   3 +
 8 files changed, 155 insertions(+)
 create mode 100644 drivers/net/wireless/mwifiex/11h.c

diff --git a/drivers/net/wireless/mwifiex/11h.c b/drivers/net/wireless/mwifiex/11h.c
new file mode 100644
index 0000000..8d68307
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/11h.c
@@ -0,0 +1,101 @@
+/*
+ * Marvell Wireless LAN device driver: 802.11h
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
+#include "main.h"
+#include "fw.h"
+
+
+/* This function appends 11h info to a buffer while joining an
+ * infrastructure BSS
+ */
+static void
+mwifiex_11h_process_infra_join(struct mwifiex_private *priv, u8 **buffer,
+			       struct mwifiex_bssdescriptor *bss_desc)
+{
+	struct mwifiex_ie_types_header *ie_header;
+	struct mwifiex_ie_types_pwr_capability *cap;
+	struct mwifiex_ie_types_local_pwr_constraint *constraint;
+	struct ieee80211_supported_band *sband;
+	u8 radio_type;
+	int i;
+
+	if (!buffer || !(*buffer))
+		return;
+
+	radio_type = mwifiex_band_to_radio_type((u8) bss_desc->bss_band);
+	sband = priv->wdev->wiphy->bands[radio_type];
+
+	cap = (struct mwifiex_ie_types_pwr_capability *)*buffer;
+	cap->header.type = cpu_to_le16(WLAN_EID_PWR_CAPABILITY);
+	cap->header.len = cpu_to_le16(2);
+	cap->min_pwr = 0;
+	cap->max_pwr = 0;
+	*buffer += sizeof(*cap);
+
+	constraint = (struct mwifiex_ie_types_local_pwr_constraint *)*buffer;
+	constraint->header.type = cpu_to_le16(WLAN_EID_PWR_CONSTRAINT);
+	constraint->header.len = cpu_to_le16(2);
+	constraint->chan = bss_desc->channel;
+	constraint->constraint = bss_desc->local_constraint;
+	*buffer += sizeof(*constraint);
+
+	ie_header = (struct mwifiex_ie_types_header *)*buffer;
+	ie_header->type = cpu_to_le16(TLV_TYPE_PASSTHROUGH);
+	ie_header->len  = cpu_to_le16(2 * sband->n_channels + 2);
+	*buffer += sizeof(*ie_header);
+	*(*buffer)++ = WLAN_EID_SUPPORTED_CHANNELS;
+	*(*buffer)++ = 2 * sband->n_channels;
+	for (i = 0; i < sband->n_channels; i++) {
+		*(*buffer)++ = ieee80211_frequency_to_channel(
+					sband->channels[i].center_freq);
+		*(*buffer)++ = 1; /* one channel in the subband */
+	}
+}
+
+/* Enable or disable the 11h extensions in the firmware */
+static int mwifiex_11h_activate(struct mwifiex_private *priv, bool flag)
+{
+	u32 enable = flag;
+
+	return mwifiex_send_cmd_sync(priv, HostCmd_CMD_802_11_SNMP_MIB,
+				     HostCmd_ACT_GEN_SET, DOT11H_I, &enable);
+}
+
+/* This functions processes TLV buffer for a pending BSS Join command.
+ *
+ * Activate 11h functionality in the firmware if the spectrum management
+ * capability bit is found in the network we are joining. Also, necessary
+ * TLVs are set based on requested network's 11h capability.
+ */
+void mwifiex_11h_process_join(struct mwifiex_private *priv, u8 **buffer,
+			      struct mwifiex_bssdescriptor *bss_desc)
+{
+	if (bss_desc->sensed_11h) {
+		/* Activate 11h functions in firmware, turns on capability
+		 * bit
+		 */
+		mwifiex_11h_activate(priv, true);
+		bss_desc->cap_info_bitmap |= WLAN_CAPABILITY_SPECTRUM_MGMT;
+		mwifiex_11h_process_infra_join(priv, buffer, bss_desc);
+	} else {
+		/* Deactivate 11h functions in the firmware */
+		mwifiex_11h_activate(priv, false);
+		bss_desc->cap_info_bitmap &= ~WLAN_CAPABILITY_SPECTRUM_MGMT;
+	}
+}
diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index ecf2846..a42a506 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -40,6 +40,7 @@ mwifiex-y += sta_rx.o
 mwifiex-y += uap_txrx.o
 mwifiex-y += cfg80211.o
 mwifiex-y += ethtool.o
+mwifiex-y += 11h.o
 mwifiex-$(CONFIG_DEBUG_FS) += debugfs.o
 obj-$(CONFIG_MWIFIEX) += mwifiex.o
 
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index d6ada73..b6fbbf6 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -438,6 +438,7 @@ enum P2P_MODES {
 #define EVENT_BW_CHANGE                 0x00000048
 #define EVENT_UAP_MIC_COUNTERMEASURES   0x0000004c
 #define EVENT_HOSTWAKE_STAIE		0x0000004d
+#define EVENT_CHANNEL_SWITCH_ANN        0x00000050
 #define EVENT_REMAIN_ON_CHAN_EXPIRED    0x0000005f
 
 #define EVENT_ID_MASK                   0xffff
@@ -975,6 +976,7 @@ enum SNMP_MIB_INDEX {
 	LONG_RETRY_LIM_I = 7,
 	FRAG_THRESH_I = 8,
 	DOT11D_I = 9,
+	DOT11H_I = 10,
 };
 
 #define MAX_SNMP_BUF_SIZE   128
@@ -1206,6 +1208,18 @@ struct host_cmd_ds_sta_deauth {
 	__le16 reason;
 } __packed;
 
+struct mwifiex_ie_types_pwr_capability {
+	struct mwifiex_ie_types_header header;
+	s8 min_pwr;
+	s8 max_pwr;
+};
+
+struct mwifiex_ie_types_local_pwr_constraint {
+	struct mwifiex_ie_types_header header;
+	u8 chan;
+	u8 constraint;
+};
+
 struct mwifiex_ie_types_wmm_param_set {
 	struct mwifiex_ie_types_header header;
 	u8 wmm_ie[1];
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 122175a..1c8a771 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -534,6 +534,8 @@ int mwifiex_cmd_802_11_associate(struct mwifiex_private *priv,
 
 	mwifiex_cmd_append_tsf_tlv(priv, &pos, bss_desc);
 
+	mwifiex_11h_process_join(priv, &pos, bss_desc);
+
 	cmd->size = cpu_to_le16((u16) (pos - (u8 *) assoc) + S_DS_GEN);
 
 	/* Set the Capability info at last */
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 0832c24..95a6f52 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -309,6 +309,9 @@ struct mwifiex_bssdescriptor {
 	u16 wapi_offset;
 	u8 *beacon_buf;
 	u32 beacon_buf_size;
+	u8 sensed_11h;
+	u8 local_constraint;
+	u8 chan_sw_ie_present;
 };
 
 struct mwifiex_current_bss_params {
@@ -1119,6 +1122,10 @@ u8 *mwifiex_11d_code_2_region(u8 code);
 void mwifiex_uap_del_sta_data(struct mwifiex_private *priv,
 			      struct mwifiex_sta_node *node);
 
+void mwifiex_11h_process_join(struct mwifiex_private *priv, u8 **buffer,
+			      struct mwifiex_bssdescriptor *bss_desc);
+int mwifiex_11h_handle_event_chanswann(struct mwifiex_private *priv);
+
 extern const struct ethtool_ops mwifiex_ethtool_ops;
 
 #ifdef CONFIG_DEBUG_FS
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 801b6b7..284d68b 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -391,6 +391,12 @@ mwifiex_is_network_compatible(struct mwifiex_private *priv,
 		return 0;
 	}
 
+	if (bss_desc->chan_sw_ie_present) {
+		dev_err(adapter->dev,
+			"Don't connect to AP with WLAN_EID_CHANNEL_SWITCH\n");
+		return -1;
+	}
+
 	if (mwifiex_is_bss_wapi(priv, bss_desc)) {
 		dev_dbg(adapter->dev, "info: return success for WAPI AP\n");
 		return 0;
@@ -1169,6 +1175,19 @@ int mwifiex_update_bss_desc_with_ie(struct mwifiex_adapter *adapter,
 			bss_entry->erp_flags = *(current_ptr + 2);
 			break;
 
+		case WLAN_EID_PWR_CONSTRAINT:
+			bss_entry->local_constraint = *(current_ptr + 2);
+			bss_entry->sensed_11h = true;
+			break;
+
+		case WLAN_EID_CHANNEL_SWITCH:
+			bss_entry->chan_sw_ie_present = true;
+		case WLAN_EID_PWR_CAPABILITY:
+		case WLAN_EID_TPC_REPORT:
+		case WLAN_EID_QUIET:
+			bss_entry->sensed_11h = true;
+		    break;
+
 		case WLAN_EID_EXT_SUPP_RATES:
 			/*
 			 * Only process extended supported rate
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index 41aafc7..d28c920 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -427,6 +427,14 @@ int mwifiex_process_sta_event(struct mwifiex_private *priv)
 
 		break;
 
+	case EVENT_CHANNEL_SWITCH_ANN:
+		dev_dbg(adapter->dev, "event: Channel Switch Announcement\n");
+		ret = mwifiex_send_cmd_async(priv,
+			HostCmd_CMD_802_11_DEAUTHENTICATE,
+			HostCmd_ACT_GEN_SET, 0,
+			priv->curr_bss_params.bss_descriptor.mac_address);
+		break;
+
 	default:
 		dev_dbg(adapter->dev, "event: unknown event id: %#x\n",
 			eventcause);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 15b5457..498add7 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -178,6 +178,9 @@ int mwifiex_fill_new_bss_desc(struct mwifiex_private *priv,
 	 */
 	bss_desc->disable_11ac = true;
 
+	if (bss_desc->cap_info_bitmap & WLAN_CAPABILITY_SPECTRUM_MGMT)
+		bss_desc->sensed_11h = true;
+
 	return mwifiex_update_bss_desc_with_ie(priv->adapter, bss_desc);
 }
 
-- 
1.8.2.3

