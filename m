Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:19985 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751224AbaBHAay (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Feb 2014 19:30:54 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 26/30] mwifiex: add VHT support for TDLS
Date: Fri, 7 Feb 2014 16:30:39 -0800
Message-ID: <1391819442-21239-7-git-send-email-bzhao@marvell.com> (sfid-20140208_020008_372656_4EF8802F)
In-Reply-To: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
References: <1391819442-21239-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

During TDLS setup request/response, if HW is 11ac capable,
we add VHT Capability IEs in outgoing data frame. Also while
processing received setup request/response, we preserve peer's
11ac capability retrieved from IEs.

Patch also gets VHT parameters from config_station handlers and
sets it to FW using TDLS config command.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/11ac.c    |  83 ++++++++++++-
 drivers/net/wireless/mwifiex/11ac.h    |   2 +
 drivers/net/wireless/mwifiex/fw.h      |   5 +
 drivers/net/wireless/mwifiex/main.h    |  22 ++++
 drivers/net/wireless/mwifiex/sta_cmd.c |  20 +++
 drivers/net/wireless/mwifiex/tdls.c    | 221 ++++++++++++++++++++++++++++++++-
 6 files changed, 346 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/11ac.c b/drivers/net/wireless/mwifiex/11ac.c
index 5895bc8..bb43251 100644
--- a/drivers/net/wireless/mwifiex/11ac.c
+++ b/drivers/net/wireless/mwifiex/11ac.c
@@ -108,9 +108,8 @@ mwifiex_fill_vht_cap_info(struct mwifiex_private *priv,
 				cpu_to_le32(adapter->usr_dot_11ac_dev_cap_bg);
 }
 
-static void
-mwifiex_fill_vht_cap_tlv(struct mwifiex_private *priv,
-			 struct ieee80211_vht_cap *vht_cap, u8 bands)
+void mwifiex_fill_vht_cap_tlv(struct mwifiex_private *priv,
+			      struct ieee80211_vht_cap *vht_cap, u8 bands)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
 	u16 mcs_map_user, mcs_map_resp, mcs_map_result;
@@ -305,3 +304,81 @@ void mwifiex_set_11ac_ba_params(struct mwifiex_private *priv)
 
 	return;
 }
+
+bool mwifiex_is_bss_in_11ac_mode(struct mwifiex_private *priv)
+{
+	struct mwifiex_bssdescriptor *bss_desc;
+	struct ieee80211_vht_operation *vht_oper;
+
+	bss_desc = &priv->curr_bss_params.bss_descriptor;
+	vht_oper = bss_desc->bcn_vht_oper;
+
+	if (!bss_desc->bcn_vht_cap || !vht_oper)
+		return false;
+
+	if (vht_oper->chan_width == IEEE80211_VHT_CHANWIDTH_USE_HT)
+		return false;
+
+	return true;
+}
+
+u8 mwifiex_get_center_freq_index(struct mwifiex_private *priv, u8 band,
+				 u32 pri_chan, u8 chan_bw)
+{
+	u8 center_freq_idx = 0;
+
+	if (band & BAND_AAC) {
+		switch (pri_chan) {
+		case 36:
+		case 40:
+		case 44:
+		case 48:
+			if (chan_bw == IEEE80211_VHT_CHANWIDTH_80MHZ)
+				center_freq_idx = 42;
+			break;
+		case 52:
+		case 56:
+		case 60:
+		case 64:
+			if (chan_bw == IEEE80211_VHT_CHANWIDTH_80MHZ)
+				center_freq_idx = 58;
+			else if (chan_bw == IEEE80211_VHT_CHANWIDTH_160MHZ)
+				center_freq_idx = 50;
+			break;
+		case 100:
+		case 104:
+		case 108:
+		case 112:
+			if (chan_bw == IEEE80211_VHT_CHANWIDTH_80MHZ)
+				center_freq_idx = 106;
+			break;
+		case 116:
+		case 120:
+		case 124:
+		case 128:
+			if (chan_bw == IEEE80211_VHT_CHANWIDTH_80MHZ)
+				center_freq_idx = 122;
+			else if (chan_bw == IEEE80211_VHT_CHANWIDTH_160MHZ)
+				center_freq_idx = 114;
+			break;
+		case 132:
+		case 136:
+		case 140:
+		case 144:
+			if (chan_bw == IEEE80211_VHT_CHANWIDTH_80MHZ)
+				center_freq_idx = 138;
+			break;
+		case 149:
+		case 153:
+		case 157:
+		case 161:
+			if (chan_bw == IEEE80211_VHT_CHANWIDTH_80MHZ)
+				center_freq_idx = 155;
+			break;
+		default:
+			center_freq_idx = 42;
+		}
+	}
+
+	return center_freq_idx;
+}
diff --git a/drivers/net/wireless/mwifiex/11ac.h b/drivers/net/wireless/mwifiex/11ac.h
index 7c2c69b..0b02cb6 100644
--- a/drivers/net/wireless/mwifiex/11ac.h
+++ b/drivers/net/wireless/mwifiex/11ac.h
@@ -40,4 +40,6 @@ int mwifiex_cmd_append_11ac_tlv(struct mwifiex_private *priv,
 int mwifiex_cmd_11ac_cfg(struct mwifiex_private *priv,
 			 struct host_cmd_ds_command *cmd, u16 cmd_action,
 			 struct mwifiex_11ac_vht_cfg *cfg);
+void mwifiex_fill_vht_cap_tlv(struct mwifiex_private *priv,
+			      struct ieee80211_vht_cap *vht_cap, u8 bands);
 #endif /* _MWIFIEX_11AC_H_ */
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 8c119bc..2344abd 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -1356,6 +1356,11 @@ struct mwifiex_ie_types_vhtcap {
 	struct ieee80211_vht_cap vht_cap;
 } __packed;
 
+struct mwifiex_ie_types_aid {
+	struct mwifiex_ie_types_header header;
+	__le16 aid;
+} __packed;
+
 struct mwifiex_ie_types_oper_mode_ntf {
 	struct mwifiex_ie_types_header header;
 	u8 oper_mode;
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 9696d57..631e07f 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -273,6 +273,21 @@ struct ieee_types_extcap {
 	u8 ext_capab[8];
 } __packed;
 
+struct ieee_types_vht_cap {
+	struct ieee_types_header ieee_hdr;
+	struct ieee80211_vht_cap vhtcap;
+} __packed;
+
+struct ieee_types_vht_oper {
+	struct ieee_types_header ieee_hdr;
+	struct ieee80211_vht_operation vhtoper;
+} __packed;
+
+struct ieee_types_aid {
+	struct ieee_types_header ieee_hdr;
+	u16 aid;
+} __packed;
+
 struct mwifiex_bssdescriptor {
 	u8 mac_address[ETH_ALEN];
 	struct cfg80211_ssid ssid;
@@ -603,10 +618,13 @@ struct mwifiex_tdls_capab {
 	u8 rates_len;
 	u8 qos_info;
 	u8 coex_2040;
+	u16 aid;
 	struct ieee80211_ht_cap ht_capb;
 	struct ieee80211_ht_operation ht_oper;
 	struct ieee_types_extcap extcap;
 	struct ieee_types_generic rsn_ie;
+	struct ieee80211_vht_cap vhtcap;
+	struct ieee80211_vht_operation vhtoper;
 };
 
 /* This is AP/TDLS specific structure which stores information
@@ -617,6 +635,7 @@ struct mwifiex_sta_node {
 	u8 mac_addr[ETH_ALEN];
 	u8 is_wmm_enabled;
 	u8 is_11n_enabled;
+	u8 is_11ac_enabled;
 	u8 ampdu_sta[MAX_NUM_TID];
 	u16 rx_seq[MAX_NUM_TID];
 	u16 max_amsdu;
@@ -1215,6 +1234,9 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 				       u8 *buf, int len);
 int mwifiex_tdls_oper(struct mwifiex_private *priv, u8 *peer, u8 action);
 int mwifiex_get_tdls_link_status(struct mwifiex_private *priv, u8 *mac);
+bool mwifiex_is_bss_in_11ac_mode(struct mwifiex_private *priv);
+u8 mwifiex_get_center_freq_index(struct mwifiex_private *priv, u8 band,
+				 u32 pri_chan, u8 chan_bw);
 
 #ifdef CONFIG_DEBUG_FS
 void mwifiex_debugfs_init(void);
diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/sta_cmd.c
index 8f1bcc3..b10425c 100644
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -1292,6 +1292,8 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 	struct mwifiex_ie_types_htcap *ht_capab;
 	struct mwifiex_ie_types_qos_info *wmm_qos_info;
 	struct mwifiex_ie_types_extcap *extcap;
+	struct mwifiex_ie_types_vhtcap *vht_capab;
+	struct mwifiex_ie_types_aid *aid;
 	u8 *pos, qos_info;
 	u16 config_len = 0;
 	struct station_parameters *params = priv->sta_params;
@@ -1370,6 +1372,24 @@ mwifiex_cmd_tdls_oper(struct mwifiex_private *priv,
 			config_len += sizeof(struct mwifiex_ie_types_extcap) +
 				      params->ext_capab_len;
 		}
+		if (params->vht_capa) {
+			vht_capab = (struct mwifiex_ie_types_vhtcap *)(pos +
+								    config_len);
+			vht_capab->header.type =
+					   cpu_to_le16(WLAN_EID_VHT_CAPABILITY);
+			vht_capab->header.len =
+				  cpu_to_le16(sizeof(struct ieee80211_vht_cap));
+			memcpy(&vht_capab->vht_cap, params->vht_capa,
+			       sizeof(struct ieee80211_vht_cap));
+			config_len += sizeof(struct mwifiex_ie_types_vhtcap);
+		}
+		if (params->aid) {
+			aid = (struct mwifiex_ie_types_aid *)(pos + config_len);
+			aid->header.type = cpu_to_le16(WLAN_EID_AID);
+			aid->header.len = cpu_to_le16(sizeof(params->aid));
+			aid->aid = cpu_to_le16(params->aid);
+			config_len += sizeof(struct mwifiex_ie_types_aid);
+		}
 
 		break;
 	default:
diff --git a/drivers/net/wireless/mwifiex/tdls.c b/drivers/net/wireless/mwifiex/tdls.c
index 243beab..770dcd7 100644
--- a/drivers/net/wireless/mwifiex/tdls.c
+++ b/drivers/net/wireless/mwifiex/tdls.c
@@ -19,6 +19,7 @@
 #include "wmm.h"
 #include "11n.h"
 #include "11n_rxreorder.h"
+#include "11ac.h"
 
 #define TDLS_REQ_FIX_LEN      6
 #define TDLS_RESP_FIX_LEN     8
@@ -151,7 +152,156 @@ mwifiex_tdls_append_rates_ie(struct mwifiex_private *priv,
 	return 0;
 }
 
-static void mwifiex_tdls_add_ext_capab(struct sk_buff *skb)
+static void mwifiex_tdls_add_aid(struct mwifiex_private *priv,
+				struct sk_buff *skb)
+{
+	struct ieee_types_assoc_rsp *assoc_rsp;
+	u8 *pos;
+
+	assoc_rsp = (struct ieee_types_assoc_rsp *)&priv->assoc_rsp_buf;
+	pos = (void *)skb_put(skb, 4);
+	*pos++ = WLAN_EID_AID;
+	*pos++ = 2;
+	*pos++ = le16_to_cpu(assoc_rsp->a_id);
+
+	return;
+}
+
+static int mwifiex_tdls_add_vht_capab(struct mwifiex_private *priv,
+				      struct sk_buff *skb)
+{
+	struct ieee80211_vht_cap vht_cap;
+	u8 *pos;
+
+	pos = (void *)skb_put(skb, sizeof(struct ieee80211_vht_cap) + 2);
+	*pos++ = WLAN_EID_VHT_CAPABILITY;
+	*pos++ = sizeof(struct ieee80211_vht_cap);
+
+	memset(&vht_cap, 0, sizeof(struct ieee80211_vht_cap));
+
+	mwifiex_fill_vht_cap_tlv(priv, &vht_cap, priv->curr_bss_params.band);
+	memcpy(pos, &vht_cap, sizeof(struct ieee80211_ht_cap));
+
+	return 0;
+}
+
+static int mwifiex_tdls_add_vht_oper(struct mwifiex_private *priv,
+				     u8 *mac, struct sk_buff *skb)
+{
+	struct mwifiex_bssdescriptor *bss_desc;
+	struct ieee80211_vht_operation *vht_oper;
+	struct ieee80211_vht_cap *vht_cap, *ap_vht_cap = NULL;
+	struct mwifiex_sta_node *sta_ptr;
+	struct mwifiex_adapter *adapter = priv->adapter;
+	u8 supp_chwd_set, peer_supp_chwd_set;
+	u8 *pos, ap_supp_chwd_set, chan_bw;
+	u16 mcs_map_user, mcs_map_resp, mcs_map_result;
+	u16 mcs_user, mcs_resp, nss;
+	u32 usr_vht_cap_info;
+
+	bss_desc = &priv->curr_bss_params.bss_descriptor;
+
+	sta_ptr = mwifiex_get_sta_entry(priv, mac);
+	if (unlikely(!sta_ptr)) {
+		dev_warn(adapter->dev, "TDLS peer station not found in list\n");
+		return -1;
+	}
+
+	if (!mwifiex_is_bss_in_11ac_mode(priv)) {
+		if (sta_ptr->tdls_cap.extcap.ext_capab[7] &
+		   WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED) {
+			dev_dbg(adapter->dev,
+				"TDLS peer doesn't support wider bandwitdh\n");
+			return 0;
+		}
+	} else {
+		ap_vht_cap = bss_desc->bcn_vht_cap;
+	}
+
+	pos = (void *)skb_put(skb, sizeof(struct ieee80211_vht_operation) + 2);
+	*pos++ = WLAN_EID_VHT_OPERATION;
+	*pos++ = sizeof(struct ieee80211_vht_operation);
+	vht_oper = (struct ieee80211_vht_operation *)pos;
+
+	if (bss_desc->bss_band & BAND_A)
+		usr_vht_cap_info = adapter->usr_dot_11ac_dev_cap_a;
+	else
+		usr_vht_cap_info = adapter->usr_dot_11ac_dev_cap_bg;
+
+	/* find the minmum bandwith between AP/TDLS peers */
+	vht_cap = &sta_ptr->tdls_cap.vhtcap;
+	supp_chwd_set = GET_VHTCAP_CHWDSET(usr_vht_cap_info);
+	peer_supp_chwd_set =
+			 GET_VHTCAP_CHWDSET(le32_to_cpu(vht_cap->vht_cap_info));
+	supp_chwd_set = min_t(u8, supp_chwd_set, peer_supp_chwd_set);
+
+	/* We need check AP's bandwidth when TDLS_WIDER_BANDWIDTH is off */
+
+	if (ap_vht_cap && sta_ptr->tdls_cap.extcap.ext_capab[7] &
+	    WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED) {
+		ap_supp_chwd_set =
+		      GET_VHTCAP_CHWDSET(le32_to_cpu(ap_vht_cap->vht_cap_info));
+		supp_chwd_set = min_t(u8, supp_chwd_set, ap_supp_chwd_set);
+	}
+
+	switch (supp_chwd_set) {
+	case IEEE80211_VHT_CHANWIDTH_80MHZ:
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80MHZ;
+		break;
+	case IEEE80211_VHT_CHANWIDTH_160MHZ:
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_160MHZ;
+		break;
+	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_80P80MHZ;
+		break;
+	default:
+		vht_oper->chan_width = IEEE80211_VHT_CHANWIDTH_USE_HT;
+		break;
+	}
+
+	mcs_map_user = GET_DEVRXMCSMAP(adapter->usr_dot_11ac_mcs_support);
+	mcs_map_resp = le16_to_cpu(vht_cap->supp_mcs.rx_mcs_map);
+	mcs_map_result = 0;
+
+	for (nss = 1; nss <= 8; nss++) {
+		mcs_user = GET_VHTNSSMCS(mcs_map_user, nss);
+		mcs_resp = GET_VHTNSSMCS(mcs_map_resp, nss);
+
+		if ((mcs_user == IEEE80211_VHT_MCS_NOT_SUPPORTED) ||
+		    (mcs_resp == IEEE80211_VHT_MCS_NOT_SUPPORTED))
+			SET_VHTNSSMCS(mcs_map_result, nss,
+				      IEEE80211_VHT_MCS_NOT_SUPPORTED);
+		else
+			SET_VHTNSSMCS(mcs_map_result, nss,
+				      min_t(u16, mcs_user, mcs_resp));
+	}
+
+	vht_oper->basic_mcs_set = cpu_to_le16(mcs_map_result);
+
+	switch (vht_oper->chan_width) {
+	case IEEE80211_VHT_CHANWIDTH_80MHZ:
+		chan_bw = IEEE80211_VHT_CHANWIDTH_80MHZ;
+		break;
+	case IEEE80211_VHT_CHANWIDTH_160MHZ:
+		chan_bw = IEEE80211_VHT_CHANWIDTH_160MHZ;
+		break;
+	case IEEE80211_VHT_CHANWIDTH_80P80MHZ:
+		chan_bw = IEEE80211_VHT_CHANWIDTH_80MHZ;
+		break;
+	default:
+		chan_bw = IEEE80211_VHT_CHANWIDTH_USE_HT;
+		break;
+	}
+	vht_oper->center_freq_seg1_idx =
+			mwifiex_get_center_freq_index(priv, BAND_AAC,
+						      bss_desc->channel,
+						      chan_bw);
+
+	return 0;
+}
+
+static void mwifiex_tdls_add_ext_capab(struct mwifiex_private *priv,
+				       struct sk_buff *skb)
 {
 	struct ieee_types_extcap *extcap;
 
@@ -160,6 +310,9 @@ static void mwifiex_tdls_add_ext_capab(struct sk_buff *skb)
 	extcap->ieee_hdr.len = 8;
 	memset(extcap->ext_capab, 0, 8);
 	extcap->ext_capab[4] |= WLAN_EXT_CAPA5_TDLS_ENABLED;
+
+	if (priv->adapter->is_hw_11ac_capable)
+		extcap->ext_capab[7] |= WLAN_EXT_CAPA8_TDLS_WIDE_BW_ENABLED;
 }
 
 static void mwifiex_tdls_add_qos_capab(struct sk_buff *skb)
@@ -213,7 +366,16 @@ static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 			return ret;
 		}
 
-		mwifiex_tdls_add_ext_capab(skb);
+		if (priv->adapter->is_hw_11ac_capable) {
+			ret = mwifiex_tdls_add_vht_capab(priv, skb);
+			if (ret) {
+				dev_kfree_skb_any(skb);
+				return ret;
+			}
+			mwifiex_tdls_add_aid(priv, skb);
+		}
+
+		mwifiex_tdls_add_ext_capab(priv, skb);
 		mwifiex_tdls_add_qos_capab(skb);
 		break;
 
@@ -241,7 +403,16 @@ static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 			return ret;
 		}
 
-		mwifiex_tdls_add_ext_capab(skb);
+		if (priv->adapter->is_hw_11ac_capable) {
+			ret = mwifiex_tdls_add_vht_capab(priv, skb);
+			if (ret) {
+				dev_kfree_skb_any(skb);
+				return ret;
+			}
+			mwifiex_tdls_add_aid(priv, skb);
+		}
+
+		mwifiex_tdls_add_ext_capab(priv, skb);
 		mwifiex_tdls_add_qos_capab(skb);
 		break;
 
@@ -251,6 +422,13 @@ static int mwifiex_prep_tdls_encap_data(struct mwifiex_private *priv,
 		skb_put(skb, sizeof(tf->u.setup_cfm));
 		tf->u.setup_cfm.status_code = cpu_to_le16(status_code);
 		tf->u.setup_cfm.dialog_token = dialog_token;
+		if (priv->adapter->is_hw_11ac_capable) {
+			ret = mwifiex_tdls_add_vht_oper(priv, peer, skb);
+			if (ret) {
+				dev_kfree_skb_any(skb);
+				return ret;
+			}
+		}
 		break;
 
 	case WLAN_TDLS_TEARDOWN:
@@ -313,6 +491,11 @@ int mwifiex_send_tdls_data_frame(struct mwifiex_private *priv,
 		  sizeof(struct ieee80211_tdls_lnkie) +
 		  extra_ies_len;
 
+	if (priv->adapter->is_hw_11ac_capable)
+		skb_len += sizeof(struct ieee_types_vht_cap) +
+			   sizeof(struct ieee_types_vht_oper) +
+			   sizeof(struct ieee_types_aid);
+
 	skb = dev_alloc_skb(skb_len);
 	if (!skb) {
 		dev_err(priv->adapter->dev,
@@ -435,7 +618,16 @@ mwifiex_construct_tdls_action_frame(struct mwifiex_private *priv, u8 *peer,
 			return ret;
 		}
 
-		mwifiex_tdls_add_ext_capab(skb);
+		if (priv->adapter->is_hw_11ac_capable) {
+			ret = mwifiex_tdls_add_vht_capab(priv, skb);
+			if (ret) {
+				dev_kfree_skb_any(skb);
+				return ret;
+			}
+			mwifiex_tdls_add_aid(priv, skb);
+		}
+
+		mwifiex_tdls_add_ext_capab(priv, skb);
 		mwifiex_tdls_add_qos_capab(skb);
 		break;
 	default:
@@ -472,6 +664,11 @@ int mwifiex_send_tdls_action_frame(struct mwifiex_private *priv,
 		  3 + /* Qos Info */
 		  ETH_ALEN; /* Address4 */
 
+	if (priv->adapter->is_hw_11ac_capable)
+		skb_len += sizeof(struct ieee_types_vht_cap) +
+			   sizeof(struct ieee_types_vht_oper) +
+			   sizeof(struct ieee_types_aid);
+
 	skb = dev_alloc_skb(skb_len);
 	if (!skb) {
 		dev_err(priv->adapter->dev,
@@ -626,6 +823,22 @@ void mwifiex_process_tdls_action_frame(struct mwifiex_private *priv,
 		case WLAN_EID_QOS_CAPA:
 			sta_ptr->tdls_cap.qos_info = pos[2];
 			break;
+		case WLAN_EID_VHT_OPERATION:
+			if (priv->adapter->is_hw_11ac_capable)
+				memcpy(&sta_ptr->tdls_cap.vhtoper, pos,
+				       sizeof(struct ieee80211_vht_operation));
+			break;
+		case WLAN_EID_VHT_CAPABILITY:
+			if (priv->adapter->is_hw_11ac_capable) {
+				memcpy((u8 *)&sta_ptr->tdls_cap.vhtcap, pos,
+				       sizeof(struct ieee80211_vht_cap));
+				sta_ptr->is_11ac_enabled = 1;
+			}
+			break;
+		case WLAN_EID_AID:
+			if (priv->adapter->is_hw_11ac_capable)
+				sta_ptr->tdls_cap.aid =
+					      le16_to_cpu(*(__le16 *)(pos + 2));
 		default:
 			break;
 		}
-- 
1.8.2.3

