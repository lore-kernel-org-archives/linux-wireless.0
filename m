Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26880 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756541Ab2DIPUm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 11:20:42 -0400
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>,
	Subramania Sharma <sharmat@qca.qualcomm.com>
Subject: [PATCH V2] ath6kl: Fix 4-way handshake failure in AP and P2P GO mode
Date: Mon, 9 Apr 2012 20:51:20 +0530
Message-ID: <1333984880-4328-1-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120409_172046_020841_F64EE2D8)
In-Reply-To: <\>
References: <\>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

RSN capability field of RSN IE which is generated (which is what really
advertised in beacon/probe response) differs from the one generated in
wpa_supplicant. This inconsistency in rsn IE results in 4-way handshake
failure. To fix this, configure rsn capability used in wpa_supplicant
in firmware using a new wmi command, WMI_SET_IE_CMDID. There is a bit
(ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE) in fw_capabilities to advertise
this support to driver.

Signed-off-by: Subramania Sharma <sharmat@qca.qualcomm.com>
Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---

V2 - Fix sparse warning due to the way rsn_cap is used
     to store le16 (Reported by Kalle).

 drivers/net/wireless/ath/ath6kl/cfg80211.c |   64 ++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath6kl/core.h     |    3 +
 drivers/net/wireless/ath/ath6kl/wmi.c      |   23 ++++++++++
 drivers/net/wireless/ath/ath6kl/wmi.h      |   17 +++++++
 4 files changed, 107 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 06f12da..98a0046 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -2524,6 +2524,52 @@ static int ath6kl_set_ies(struct ath6kl_vif *vif,
 	return 0;
 }
 
+static int ath6kl_get_rsn_capab(struct cfg80211_beacon_data *beacon,
+				u8 *rsn_capab)
+{
+	const u8 *rsn_ie;
+	size_t rsn_ie_len;
+	u16 cnt;
+
+	if (!beacon->tail)
+		return -EINVAL;
+
+	rsn_ie = cfg80211_find_ie(WLAN_EID_RSN, beacon->tail, beacon->tail_len);
+	if (!rsn_ie)
+		return -EINVAL;
+
+	rsn_ie_len = *(rsn_ie + 1);
+	/* skip element id and length */
+	rsn_ie += 2;
+
+	/* skip version, group cipher */
+	if (rsn_ie_len < 6)
+		return -EINVAL;
+	rsn_ie +=  6;
+	rsn_ie_len -= 6;
+
+	/* skip pairwise cipher suite */
+	if (rsn_ie_len < 2)
+		return -EINVAL;
+	cnt = *((u16 *) rsn_ie);
+	rsn_ie += (2 + cnt * 4);
+	rsn_ie_len -= (2 + cnt * 4);
+
+	/* skip akm suite */
+	if (rsn_ie_len < 2)
+		return -EINVAL;
+	cnt = *((u16 *) rsn_ie);
+	rsn_ie += (2 + cnt * 4);
+	rsn_ie_len -= (2 + cnt * 4);
+
+	if (rsn_ie_len < 2)
+		return -EINVAL;
+
+	memcpy(rsn_capab, rsn_ie, 2);
+
+	return 0;
+}
+
 static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_ap_settings *info)
 {
@@ -2536,6 +2582,7 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 	struct wmi_connect_cmd p;
 	int res;
 	int i, ret;
+	u16 rsn_capab = 0;
 
 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "%s:\n", __func__);
 
@@ -2672,6 +2719,23 @@ static int ath6kl_start_ap(struct wiphy *wiphy, struct net_device *dev,
 			return res;
 	}
 
+	/*
+	 * Get the PTKSA replay counter in the RSN IE. Supplicant
+	 * will use the RSN IE in M3 message and firmware has to
+	 * advertise the same in beacon/probe response. Send
+	 * the complete RSN IE capability field to firmware
+	 */
+	if (!ath6kl_get_rsn_capab(&info->beacon, (u8 *) &rsn_capab) &&
+	    test_bit(ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE,
+		     ar->fw_capabilities)) {
+		res = ath6kl_wmi_set_ie_cmd(ar->wmi, vif->fw_vif_idx,
+					    WLAN_EID_RSN, WMI_RSN_IE_CAPB,
+					    (const u8 *) &rsn_capab,
+					    sizeof(rsn_capab));
+		if (res < 0)
+			return res;
+	}
+
 	res = ath6kl_wmi_ap_profile_commit(ar->wmi, vif->fw_vif_idx, &p);
 	if (res < 0)
 		return res;
diff --git a/drivers/net/wireless/ath/ath6kl/core.h b/drivers/net/wireless/ath/ath6kl/core.h
index 75b1d86..72e6a94 100644
--- a/drivers/net/wireless/ath/ath6kl/core.h
+++ b/drivers/net/wireless/ath/ath6kl/core.h
@@ -97,6 +97,9 @@ enum ath6kl_fw_capability {
 	 */
 	ATH6KL_FW_CAPABILITY_INACTIVITY_TIMEOUT,
 
+	/* Firmware has support to override rsn cap of rsn ie */
+	ATH6KL_FW_CAPABILITY_RSN_CAP_OVERRIDE,
+
 	/* this needs to be last */
 	ATH6KL_FW_CAPABILITY_MAX,
 };
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index b1b1f34..7cd1d96 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3184,6 +3184,29 @@ int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
 				   NO_SYNC_WMIFLAG);
 }
 
+int ath6kl_wmi_set_ie_cmd(struct wmi *wmi, u8 if_idx, u8 ie_id, u8 ie_field,
+			  const u8 *ie_info, u8 ie_len)
+{
+	struct sk_buff *skb;
+	struct wmi_set_ie_cmd *p;
+
+	skb = ath6kl_wmi_get_new_buf(sizeof(*p) + ie_len);
+	if (!skb)
+		return -ENOMEM;
+
+	ath6kl_dbg(ATH6KL_DBG_WMI, "set_ie_cmd: ie_id=%u ie_ie_field=%u ie_len=%u\n",
+		   ie_id, ie_field, ie_len);
+	p = (struct wmi_set_ie_cmd *) skb->data;
+	p->ie_id = ie_id;
+	p->ie_field = ie_field;
+	p->ie_len = ie_len;
+	if (ie_info && ie_len > 0)
+		memcpy(p->ie_info, ie_info, ie_len);
+
+	return ath6kl_wmi_cmd_send(wmi, if_idx, skb, WMI_SET_IE_CMDID,
+				   NO_SYNC_WMIFLAG);
+}
+
 int ath6kl_wmi_disable_11b_rates_cmd(struct wmi *wmi, bool disable)
 {
 	struct sk_buff *skb;
diff --git a/drivers/net/wireless/ath/ath6kl/wmi.h b/drivers/net/wireless/ath/ath6kl/wmi.h
index b99e9bd..25aa6b8 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.h
+++ b/drivers/net/wireless/ath/ath6kl/wmi.h
@@ -426,6 +426,7 @@ enum wmi_cmd_id {
 	WMI_SET_FRAMERATES_CMDID,
 	WMI_SET_AP_PS_CMDID,
 	WMI_SET_QOS_SUPP_CMDID,
+	WMI_SET_IE_CMDID,
 
 	/* WMI_THIN_RESERVED_... mark the start and end
 	 * values for WMI_THIN_RESERVED command IDs. These
@@ -632,6 +633,11 @@ enum wmi_mgmt_frame_type {
 	WMI_NUM_MGMT_FRAME
 };
 
+enum wmi_ie_field_type {
+	WMI_RSN_IE_CAPB	= 0x1,
+	WMI_IE_FULL	= 0xFF,  /* indicats full IE */
+};
+
 /* WMI_CONNECT_CMDID  */
 enum network_type {
 	INFRA_NETWORK = 0x01,
@@ -1916,6 +1922,14 @@ struct wmi_set_appie_cmd {
 	u8 ie_info[0];
 } __packed;
 
+struct wmi_set_ie_cmd {
+	u8 ie_id;
+	u8 ie_field;	/* enum wmi_ie_field_type */
+	u8 ie_len;
+	u8 reserved;
+	u8 ie_info[0];
+} __packed;
+
 /* Notify the WSC registration status to the target */
 #define WSC_REG_ACTIVE     1
 #define WSC_REG_INACTIVE   0
@@ -2523,6 +2537,9 @@ int ath6kl_wmi_set_rx_frame_format_cmd(struct wmi *wmi, u8 if_idx,
 int ath6kl_wmi_set_appie_cmd(struct wmi *wmi, u8 if_idx, u8 mgmt_frm_type,
 			     const u8 *ie, u8 ie_len);
 
+int ath6kl_wmi_set_ie_cmd(struct wmi *wmi, u8 if_idx, u8 ie_id, u8 ie_field,
+			  const u8 *ie_info, u8 ie_len);
+
 /* P2P */
 int ath6kl_wmi_disable_11b_rates_cmd(struct wmi *wmi, bool disable);
 
-- 
1.7.0.4

