Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:55520 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751172AbaBHA1t (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:27:49 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 17/30] mwifiex: add tdls_mgmt handler support
Date: Fri, 7 Feb 2014 16:27:32 -0800
Message-ID: <1391819254-21130-7-git-send-email-bzhao@marvell.com> (sfid-20140208_012753_822115_F9A9882D)
In-Reply-To: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
References: <1391819254-21130-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds support for TDLS management frames transmit
handler. mwifiex driver supports TDLS with external support,
i.e. expects user space application to form TDLS frames.
Same is advertised to cfg80211 during registration.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/Makefile   |   1 +
 drivers/net/wireless/mwifiex/cfg80211.c |  81 ++++++
 drivers/net/wireless/mwifiex/decl.h     |   1 +
 drivers/net/wireless/mwifiex/fw.h       |   2 +
 drivers/net/wireless/mwifiex/ioctl.h    |   4 +
 drivers/net/wireless/mwifiex/main.h     |  18 ++
 drivers/net/wireless/mwifiex/sta_tx.c   |   3 +
 drivers/net/wireless/mwifiex/tdls.c     | 423 ++++++++++++++++++++++++++++++++
 8 files changed, 533 insertions(+)
 create mode 100644 drivers/net/wireless/mwifiex/tdls.c

diff --git a/drivers/net/wireless/mwifiex/Makefile b/drivers/net/wireless/mwifiex/Makefile
index a42a506..2aa208f 100644
--- a/drivers/net/wireless/mwifiex/Makefile
+++ b/drivers/net/wireless/mwifiex/Makefile
@@ -41,6 +41,7 @@ mwifiex-y += uap_txrx.o
 mwifiex-y += cfg80211.o
 mwifiex-y += ethtool.o
 mwifiex-y += 11h.o
+mwifiex-y += tdls.o
 mwifiex-$(CONFIG_DEBUG_FS) += debugfs.o
 obj-$(CONFIG_MWIFIEX) += mwifiex.o
 
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 41e9aac..53e5874 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -2592,6 +2592,81 @@ static int mwifiex_cfg80211_set_coalesce(struct wiphy *wiphy,
 				     HostCmd_ACT_GEN_SET, 0, &coalesce_cfg);
 }
 
+/* cfg80211 ops handler for tdls_mgmt.
+ * Function prepares TDLS action frame packets and forwards them to FW
+ */
+static int
+mwifiex_cfg80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
+			   u8 *peer, u8 action_code, u8 dialog_token,
+			   u16 status_code, const u8 *extra_ies,
+			   size_t extra_ies_len)
+{
+	struct mwifiex_private *priv = mwifiex_netdev_get_priv(dev);
+	int ret;
+
+	if (!(wiphy->flags & WIPHY_FLAG_SUPPORTS_TDLS))
+		return -ENOTSUPP;
+
+	/* make sure we are in station mode and connected */
+	if (!(priv->bss_type == MWIFIEX_BSS_TYPE_STA && priv->media_connected))
+		return -ENOTSUPP;
+
+	switch (action_code) {
+	case WLAN_TDLS_SETUP_REQUEST:
+		dev_dbg(priv->adapter->dev,
+			"Send TDLS Setup Request to %pM status_code=%d\n", peer,
+			 status_code);
+		ret = mwifiex_send_tdls_data_frame(priv, peer, action_code,
+						   dialog_token, status_code,
+						   extra_ies, extra_ies_len);
+		break;
+	case WLAN_TDLS_SETUP_RESPONSE:
+		dev_dbg(priv->adapter->dev,
+			"Send TDLS Setup Response to %pM status_code=%d\n",
+			peer, status_code);
+		ret = mwifiex_send_tdls_data_frame(priv, peer, action_code,
+						   dialog_token, status_code,
+						   extra_ies, extra_ies_len);
+		break;
+	case WLAN_TDLS_SETUP_CONFIRM:
+		dev_dbg(priv->adapter->dev,
+			"Send TDLS Confirm to %pM status_code=%d\n", peer,
+			status_code);
+		ret = mwifiex_send_tdls_data_frame(priv, peer, action_code,
+						   dialog_token, status_code,
+						   extra_ies, extra_ies_len);
+		break;
+	case WLAN_TDLS_TEARDOWN:
+		dev_dbg(priv->adapter->dev, "Send TDLS Tear down to %pM\n",
+			peer);
+		ret = mwifiex_send_tdls_data_frame(priv, peer, action_code,
+						   dialog_token, status_code,
+						   extra_ies, extra_ies_len);
+		break;
+	case WLAN_TDLS_DISCOVERY_REQUEST:
+		dev_dbg(priv->adapter->dev,
+			"Send TDLS Discovery Request to %pM\n", peer);
+		ret = mwifiex_send_tdls_data_frame(priv, peer, action_code,
+						   dialog_token, status_code,
+						   extra_ies, extra_ies_len);
+		break;
+	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
+		dev_dbg(priv->adapter->dev,
+			"Send TDLS Discovery Response to %pM\n", peer);
+		ret = mwifiex_send_tdls_action_frame(priv, peer, action_code,
+						   dialog_token, status_code,
+						   extra_ies, extra_ies_len);
+		break;
+	default:
+		dev_warn(priv->adapter->dev,
+			 "Unknown TDLS mgmt/action frame %pM\n", peer);
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
 /* station cfg80211 operations */
 static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.add_virtual_intf = mwifiex_add_virtual_intf,
@@ -2627,6 +2702,7 @@ static struct cfg80211_ops mwifiex_cfg80211_ops = {
 	.set_wakeup = mwifiex_cfg80211_set_wakeup,
 #endif
 	.set_coalesce = mwifiex_cfg80211_set_coalesce,
+	.tdls_mgmt = mwifiex_cfg80211_tdls_mgmt,
 };
 
 #ifdef CONFIG_PM
@@ -2712,6 +2788,11 @@ int mwifiex_register_cfg80211(struct mwifiex_adapter *adapter)
 			WIPHY_FLAG_AP_PROBE_RESP_OFFLOAD |
 			WIPHY_FLAG_AP_UAPSD |
 			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+
+	if (ISSUPP_TDLS_ENABLED(adapter->fw_cap_info))
+		wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
+				WIPHY_FLAG_TDLS_EXTERNAL_SETUP;
+
 	wiphy->regulatory_flags |=
 			REGULATORY_CUSTOM_REG |
 			REGULATORY_STRICT_REG;
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 3a21bd0..c709f1c 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -75,6 +75,7 @@
 
 #define MWIFIEX_BUF_FLAG_REQUEUED_PKT      BIT(0)
 #define MWIFIEX_BUF_FLAG_BRIDGED_PKT	   BIT(1)
+#define MWIFIEX_BUF_FLAG_TDLS_PKT	   BIT(2)
 
 #define MWIFIEX_BRIDGED_PKTS_THR_HIGH      1024
 #define MWIFIEX_BRIDGED_PKTS_THR_LOW        128
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 4139c6f..416518a 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -181,6 +181,7 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define MWIFIEX_TX_DATA_BUF_SIZE_8K        8192
 
 #define ISSUPP_11NENABLED(FwCapInfo) (FwCapInfo & BIT(11))
+#define ISSUPP_TDLS_ENABLED(FwCapInfo) (FwCapInfo & BIT(14))
 
 #define MWIFIEX_DEF_HT_CAP	(IEEE80211_HT_CAP_DSSSCCK40 | \
 				 (1 << IEEE80211_HT_CAP_RX_STBC_SHIFT) | \
@@ -497,6 +498,7 @@ struct mwifiex_ie_types_data {
 
 #define MWIFIEX_TxPD_POWER_MGMT_NULL_PACKET 0x01
 #define MWIFIEX_TxPD_POWER_MGMT_LAST_PACKET 0x08
+#define MWIFIEX_TXPD_FLAGS_TDLS_PACKET      0x10
 
 struct txpd {
 	u8 bss_type;
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 48f1590..fe12274 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -85,6 +85,10 @@ struct wep_key {
 #define BAND_CONFIG_A           0x01
 #define MWIFIEX_SUPPORTED_RATES                 14
 #define MWIFIEX_SUPPORTED_RATES_EXT             32
+#define MWIFIEX_TDLS_SUPPORTED_RATES		8
+#define MWIFIEX_TDLS_DEF_QOS_CAPAB		0xf
+#define MWIFIEX_PRIO_BK				2
+#define MWIFIEX_PRIO_VI				5
 
 struct mwifiex_uap_bss_param {
 	u8 channel;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ab53fad..c5368f2 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -262,6 +262,16 @@ struct ieee_types_generic {
 	u8 data[IEEE_MAX_IE_SIZE - sizeof(struct ieee_types_header)];
 } __packed;
 
+struct ieee_types_bss_co_2040 {
+	struct ieee_types_header ieee_hdr;
+	u8 bss_2040co;
+} __packed;
+
+struct ieee_types_extcap {
+	struct ieee_types_header ieee_hdr;
+	u8 ext_capab[8];
+} __packed;
+
 struct mwifiex_bssdescriptor {
 	u8 mac_address[ETH_ALEN];
 	struct cfg80211_ssid ssid;
@@ -1176,6 +1186,14 @@ struct mwifiex_sta_node *
 mwifiex_add_sta_entry(struct mwifiex_private *priv, u8 *mac);
 struct mwifiex_sta_node *
 mwifiex_get_sta_entry(struct mwifiex_private *priv, u8 *mac);
+int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv, u8 *peer,
+				 u8 action_code, u8 dialog_token,
+				 u16 status_code, const u8 *extra_ies,
+				 size_t extra_ies_len);
+int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv,
+				 u8 *peer, u8 action_code, u8 dialog_token,
+				 u16 status_code, const u8 *extra_ies,
+				 size_t extra_ies_len);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/sta_tx.c b/drivers/net/wireless/mwifiex/sta_tx.c
index 354d64c..1236a5d 100644
--- a/drivers/net/wireless/mwifiex/sta_tx.c
+++ b/drivers/net/wireless/mwifiex/sta_tx.c
@@ -95,6 +95,9 @@ void *mwifiex_process_sta_txpd(struct mwifiex_private *priv,
 		}
 	}
 
+	if (tx_info->flags & MWIFIEX_BUF_FLAG_TDLS_PKT)
+		local_tx_pd->flags |= MWIFIEX_TXPD_FLAGS_TDLS_PACKET;
+
 	/* Offset of actual data */
 	pkt_offset = sizeof(struct txpd) + pad;
 	if (pkt_type == PKT_TYPE_MGMT) {
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
new file mode 100644
index 0000000..73cd444
--- /dev/null
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -0,0 +1,423 @@
+/* Marvell Wireless LAN device driver: TDLS handling
+ *
+ * Copyright (C) 2014, Marvell International Ltd.
+ *
+ * This software file (the "File") is distributed by Marvell International
+ * Ltd. under the terms of the GNU General Public License Version 2, June 1991
+ * (the "License").  You may use, redistribute and/or modify this File in
+ * accordance with the terms and conditions of the License, a copy of which
+ * is available on the worldwide web at
+ * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
+ *
+ * THE FILE IS DISTRIBUTED AS-IS, WITHOUT WARRANTY OF ANY KIND, AND THE
+ * IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE
+ * ARE EXPRESSLY DISCLAIMED.  The License provides additional details about
+ * this warranty disclaimer.
+ */
+
+#include "main.h"
+
+/* This function appends rate TLV to scan config command. */
+static int
+mwifiex_tdls_append_rates_ie(struct mwifiex_private *priv,
+			     struct sk_buff *skb)
+{
+	u8 rates[MWIFIEX_SUPPORTED_RATES], *pos;
+	u16 rates_size, supp_rates_size, ext_rates_size;
+
+	memset(rates, 0, sizeof(rates));
+	rates_size = mwifiex_get_supported_rates(priv, rates);
+
+	supp_rates_size = min_t(u16, rates_size, MWIFIEX_TDLS_SUPPORTED_RATES);
+
+	if (skb_tailroom(skb) < rates_size + 4) {
+		dev_err(priv->adapter->dev,
+			"Insuffient space while adding rates\n");
+		return -ENOMEM;
+	}
+
+	pos = skb_put(skb, supp_rates_size + 2);
+	*pos++ = WLAN_EID_SUPP_RATES;
+	*pos++ = supp_rates_size;
+	memcpy(pos, rates, supp_rates_size);
+
+	if (rates_size > MWIFIEX_TDLS_SUPPORTED_RATES) {
+		ext_rates_size = rates_size - MWIFIEX_TDLS_SUPPORTED_RATES;
+		pos = skb_put(skb, ext_rates_size + 2);
+		*pos++ = WLAN_EID_EXT_SUPP_RATES;
+		*pos++ = ext_rates_size;
+		memcpy(pos, rates + MWIFIEX_TDLS_SUPPORTED_RATES,
+		       ext_rates_size);
+	}
+
+	return 0;
+}
+
+static void mwifiex_tdls_add_ext_capab(struct sk_buff *skb)
+{
+	struct ieee_types_extcap *extcap;
+
+	extcap = (void *)skb_put(skb, sizeof(struct ieee_types_extcap));
+	extcap->ieee_hdr.element_id = WLAN_EID_EXT_CAPABILITY;
+	extcap->ieee_hdr.len = 8;
+	memset(extcap->ext_capab, 0, 8);
+	extcap->ext_capab[4] |= WLAN_EXT_CAPA5_TDLS_ENABLED;
+}
+
+static void mwifiex_tdls_add_qos_capab(struct sk_buff *skb)
+{
+	u8 *pos = (void *)skb_put(skb, 3);
+
+	*pos++ = WLAN_EID_QOS_CAPA;
+	*pos++ = 1;
+	*pos++ = MWIFIEX_TDLS_DEF_QOS_CAPAB;
+}
+
+static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
+			     u8 *peer, u8 action_code, u8 dialog_token,
+			     u16 status_code, struct sk_buff *skb)
+{
+	struct ieee80211_tdls_data *tf;
+	int ret;
+	u16 capab;
+	struct ieee80211_ht_cap *ht_cap;
+	u8 radio, *pos;
+
+	capab = priv->curr_bss_params.bss_descriptor.cap_info_bitmap;
+
+	tf = (void *)skb_put(skb, offsetof(struct ieee80211_tdls_data, u));
+	memcpy(tf->da, peer, ETH_ALEN);
+	memcpy(tf->sa, priv->curr_addr, ETH_ALEN);
+	tf->ether_type = cpu_to_be16(ETH_P_TDLS);
+	tf->payload_type = WLAN_TDLS_SNAP_RFTYPE;
+
+	switch (action_code) {
+	case WLAN_TDLS_SETUP_REQUEST:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_SETUP_REQUEST;
+		skb_put(skb, sizeof(tf->u.setup_req));
+		tf->u.setup_req.dialog_token = dialog_token;
+		tf->u.setup_req.capability = cpu_to_le16(capab);
+		ret = mwifiex_tdls_append_rates_ie(priv, skb);
+		if (ret) {
+			dev_kfree_skb_any(skb);
+			return ret;
+		}
+
+		pos = (void *)skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		ht_cap = (void *)pos;
+		radio = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
+		ret = mwifiex_fill_cap_info(priv, radio, ht_cap);
+		if (ret) {
+			dev_kfree_skb_any(skb);
+			return ret;
+		}
+
+		mwifiex_tdls_add_ext_capab(skb);
+		mwifiex_tdls_add_qos_capab(skb);
+		break;
+
+	case WLAN_TDLS_SETUP_RESPONSE:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_SETUP_RESPONSE;
+		skb_put(skb, sizeof(tf->u.setup_resp));
+		tf->u.setup_resp.status_code = cpu_to_le16(status_code);
+		tf->u.setup_resp.dialog_token = dialog_token;
+		tf->u.setup_resp.capability = cpu_to_le16(capab);
+		ret = mwifiex_tdls_append_rates_ie(priv, skb);
+		if (ret) {
+			dev_kfree_skb_any(skb);
+			return ret;
+		}
+
+		pos = (void *)skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		ht_cap = (void *)pos;
+		radio = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
+		ret = mwifiex_fill_cap_info(priv, radio, ht_cap);
+		if (ret) {
+			dev_kfree_skb_any(skb);
+			return ret;
+		}
+
+		mwifiex_tdls_add_ext_capab(skb);
+		mwifiex_tdls_add_qos_capab(skb);
+		break;
+
+	case WLAN_TDLS_SETUP_CONFIRM:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_SETUP_CONFIRM;
+		skb_put(skb, sizeof(tf->u.setup_cfm));
+		tf->u.setup_cfm.status_code = cpu_to_le16(status_code);
+		tf->u.setup_cfm.dialog_token = dialog_token;
+		break;
+
+	case WLAN_TDLS_TEARDOWN:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_TEARDOWN;
+		skb_put(skb, sizeof(tf->u.teardown));
+		tf->u.teardown.reason_code = cpu_to_le16(status_code);
+		break;
+
+	case WLAN_TDLS_DISCOVERY_REQUEST:
+		tf->category = WLAN_CATEGORY_TDLS;
+		tf->action_code = WLAN_TDLS_DISCOVERY_REQUEST;
+		skb_put(skb, sizeof(tf->u.discover_req));
+		tf->u.discover_req.dialog_token = dialog_token;
+		break;
+	default:
+		dev_err(priv->adapter->dev, "Unknown TDLS frame type.\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void
+mwifiex_tdls_add_link_ie(struct sk_buff *skb, u8 *src_addr, u8 *peer, u8 *bssid)
+{
+	struct ieee80211_tdls_lnkie *lnkid;
+
+	lnkid = (void *)skb_put(skb, sizeof(struct ieee80211_tdls_lnkie));
+	lnkid->ie_type = WLAN_EID_LINK_ID;
+	lnkid->ie_len = sizeof(struct ieee80211_tdls_lnkie) -
+			sizeof(struct ieee_types_header);
+
+	memcpy(lnkid->bssid, bssid, ETH_ALEN);
+	memcpy(lnkid->init_sta, src_addr, ETH_ALEN);
+	memcpy(lnkid->resp_sta, peer, ETH_ALEN);
+}
+
+int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv,
+				 u8 *peer, u8 action_code, u8 dialog_token,
+				 u16 status_code, const u8 *extra_ies,
+				 size_t extra_ies_len)
+{
+	struct sk_buff *skb;
+	struct mwifiex_txinfo *tx_info;
+	struct timeval tv;
+	int ret;
+	u16 skb_len;
+
+	skb_len = MWIFIEX_MIN_DATA_HEADER_LEN +
+		  max(sizeof(struct ieee80211_mgmt),
+		      sizeof(struct ieee80211_tdls_data)) +
+		  MWIFIEX_MGMT_FRAME_HEADER_SIZE +
+		  MWIFIEX_SUPPORTED_RATES +
+		  3 + /* Qos Info */
+		  sizeof(struct ieee_types_extcap) +
+		  sizeof(struct ieee80211_ht_cap) +
+		  sizeof(struct ieee_types_bss_co_2040) +
+		  sizeof(struct ieee80211_ht_operation) +
+		  sizeof(struct ieee80211_tdls_lnkie) +
+		  extra_ies_len;
+
+	skb = dev_alloc_skb(skb_len);
+	if (!skb) {
+		dev_err(priv->adapter->dev,
+			"allocate skb failed for management frame\n");
+		return -ENOMEM;
+	}
+	skb_reserve(skb, MWIFIEX_MIN_DATA_HEADER_LEN);
+
+	switch (action_code) {
+	case WLAN_TDLS_SETUP_REQUEST:
+	case WLAN_TDLS_SETUP_CONFIRM:
+	case WLAN_TDLS_TEARDOWN:
+	case WLAN_TDLS_DISCOVERY_REQUEST:
+		ret = mwifiex_prep_tdls_encap_data(priv, peer, action_code,
+						   dialog_token, status_code,
+						   skb);
+		if (ret) {
+			dev_kfree_skb_any(skb);
+			return ret;
+		}
+		if (extra_ies_len)
+			memcpy(skb_put(skb, extra_ies_len), extra_ies,
+			       extra_ies_len);
+		mwifiex_tdls_add_link_ie(skb, priv->curr_addr, peer,
+					 priv->cfg_bssid);
+		break;
+	case WLAN_TDLS_SETUP_RESPONSE:
+		ret = mwifiex_prep_tdls_encap_data(priv, peer, action_code,
+						   dialog_token, status_code,
+						   skb);
+		if (ret) {
+			dev_kfree_skb_any(skb);
+			return ret;
+		}
+		if (extra_ies_len)
+			memcpy(skb_put(skb, extra_ies_len), extra_ies,
+			       extra_ies_len);
+		mwifiex_tdls_add_link_ie(skb, peer, priv->curr_addr,
+					 priv->cfg_bssid);
+		break;
+	}
+
+	switch (action_code) {
+	case WLAN_TDLS_SETUP_REQUEST:
+	case WLAN_TDLS_SETUP_RESPONSE:
+		skb->priority = MWIFIEX_PRIO_BK;
+		break;
+	default:
+		skb->priority = MWIFIEX_PRIO_VI;
+		break;
+	}
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	tx_info->bss_num = priv->bss_num;
+	tx_info->bss_type = priv->bss_type;
+
+	do_gettimeofday(&tv);
+	skb->tstamp = timeval_to_ktime(tv);
+	mwifiex_queue_tx_pkt(priv, skb);
+
+	return 0;
+}
+
+static int
+mwifiex_construct_tdls_action_frame(struct mwifiex_private *priv, u8 *peer,
+				    u8 action_code, u8 dialog_token,
+				    u16 status_code, struct sk_buff *skb)
+{
+	struct ieee80211_mgmt *mgmt;
+	u8 bc_addr[] = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff};
+	int ret;
+	u16 capab;
+	struct ieee80211_ht_cap *ht_cap;
+	u8 radio, *pos;
+
+	capab = priv->curr_bss_params.bss_descriptor.cap_info_bitmap;
+
+	mgmt = (void *)skb_put(skb, offsetof(struct ieee80211_mgmt, u));
+
+	memset(mgmt, 0, 24);
+	memcpy(mgmt->da, peer, ETH_ALEN);
+	memcpy(mgmt->sa, priv->curr_addr, ETH_ALEN);
+	memcpy(mgmt->bssid, priv->cfg_bssid, ETH_ALEN);
+	mgmt->frame_control = cpu_to_le16(IEEE80211_FTYPE_MGMT |
+					  IEEE80211_STYPE_ACTION);
+
+	/* add address 4 */
+	pos = skb_put(skb, ETH_ALEN);
+
+	switch (action_code) {
+	case WLAN_PUB_ACTION_TDLS_DISCOVER_RES:
+		skb_put(skb, sizeof(mgmt->u.action.u.tdls_discover_resp) + 1);
+		mgmt->u.action.category = WLAN_CATEGORY_PUBLIC;
+		mgmt->u.action.u.tdls_discover_resp.action_code =
+					      WLAN_PUB_ACTION_TDLS_DISCOVER_RES;
+		mgmt->u.action.u.tdls_discover_resp.dialog_token =
+								   dialog_token;
+		mgmt->u.action.u.tdls_discover_resp.capability =
+							     cpu_to_le16(capab);
+		/* move back for addr4 */
+		memmove(pos + ETH_ALEN, &mgmt->u.action.category,
+			sizeof(mgmt->u.action.u.tdls_discover_resp));
+		/* init address 4 */
+		memcpy(pos, bc_addr, ETH_ALEN);
+
+		ret = mwifiex_tdls_append_rates_ie(priv, skb);
+		if (ret) {
+			dev_kfree_skb_any(skb);
+			return ret;
+		}
+
+		pos = (void *)skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
+		*pos++ = WLAN_EID_HT_CAPABILITY;
+		*pos++ = sizeof(struct ieee80211_ht_cap);
+		ht_cap = (void *)pos;
+		radio = mwifiex_band_to_radio_type(priv->curr_bss_params.band);
+		ret = mwifiex_fill_cap_info(priv, radio, ht_cap);
+		if (ret) {
+			dev_kfree_skb_any(skb);
+			return ret;
+		}
+
+		mwifiex_tdls_add_ext_capab(skb);
+		mwifiex_tdls_add_qos_capab(skb);
+		break;
+	default:
+		dev_err(priv->adapter->dev, "Unknown TDLS action frame type\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv,
+				 u8 *peer, u8 action_code, u8 dialog_token,
+				 u16 status_code, const u8 *extra_ies,
+				 size_t extra_ies_len)
+{
+	struct sk_buff *skb;
+	struct mwifiex_txinfo *tx_info;
+	struct timeval tv;
+	u8 *pos;
+	u32 pkt_type, tx_control;
+	u16 pkt_len, skb_len;
+
+	skb_len = MWIFIEX_MIN_DATA_HEADER_LEN +
+		  max(sizeof(struct ieee80211_mgmt),
+		      sizeof(struct ieee80211_tdls_data)) +
+		  MWIFIEX_MGMT_FRAME_HEADER_SIZE +
+		  MWIFIEX_SUPPORTED_RATES +
+		  sizeof(struct ieee_types_extcap) +
+		  sizeof(struct ieee80211_ht_cap) +
+		  sizeof(struct ieee_types_bss_co_2040) +
+		  sizeof(struct ieee80211_ht_operation) +
+		  sizeof(struct ieee80211_tdls_lnkie) +
+		  extra_ies_len +
+		  3 + /* Qos Info */
+		  ETH_ALEN; /* Address4 */
+
+	skb = dev_alloc_skb(skb_len);
+	if (!skb) {
+		dev_err(priv->adapter->dev,
+			"allocate skb failed for management frame\n");
+		return -ENOMEM;
+	}
+
+	skb_reserve(skb, MWIFIEX_MIN_DATA_HEADER_LEN);
+
+	pkt_type = PKT_TYPE_MGMT;
+	tx_control = 0;
+	pos = skb_put(skb, MWIFIEX_MGMT_FRAME_HEADER_SIZE + sizeof(pkt_len));
+	memset(pos, 0, MWIFIEX_MGMT_FRAME_HEADER_SIZE + sizeof(pkt_len));
+	memcpy(pos, &pkt_type, sizeof(pkt_type));
+	memcpy(pos + sizeof(pkt_type), &tx_control, sizeof(tx_control));
+
+	if (mwifiex_construct_tdls_action_frame(priv, peer, action_code,
+						dialog_token, status_code,
+						skb)) {
+		dev_kfree_skb_any(skb);
+		return -EINVAL;
+	}
+
+	if (extra_ies_len)
+		memcpy(skb_put(skb, extra_ies_len), extra_ies, extra_ies_len);
+
+	/* the TDLS link IE is always added last we are the responder */
+
+	mwifiex_tdls_add_link_ie(skb, peer, priv->curr_addr,
+				 priv->cfg_bssid);
+
+	skb->priority = MWIFIEX_PRIO_VI;
+
+	tx_info = MWIFIEX_SKB_TXCB(skb);
+	tx_info->bss_num = priv->bss_num;
+	tx_info->bss_type = priv->bss_type;
+	tx_info->flags |= MWIFIEX_BUF_FLAG_TDLS_PKT;
+
+	pkt_len = skb->len - MWIFIEX_MGMT_FRAME_HEADER_SIZE - sizeof(pkt_len);
+	memcpy(skb->data + MWIFIEX_MGMT_FRAME_HEADER_SIZE, &pkt_len,
+	       sizeof(pkt_len));
+	do_gettimeofday(&tv);
+	skb->tstamp = timeval_to_ktime(tv);
+	mwifiex_queue_tx_pkt(priv, skb);
+
+	return 0;
+}
-- 
1.8.2.3

