Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog126.obsmtp.com ([74.125.149.155]:59988 "HELO
	na3sys009aog126.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757817Ab2EIBd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 May 2012 21:33:59 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Avinash Patil <patila@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Stone Piao <piaoyun@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2 17/18] mwifiex: retrieve IEs from cfg80211_beacon_data and send to firmware
Date: Tue,  8 May 2012 18:30:29 -0700
Message-Id: <1336527030-2045-18-git-send-email-bzhao@marvell.com> (sfid-20120509_035905_140766_27A22804)
In-Reply-To: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
References: <1336527030-2045-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avinash Patil <patila@marvell.com>

This patch adds logic for setting tail beacon IE, probe response IE
and assoc response IE from cfg80211_ap_settings parameter of
start_ap handler into FW.

RSN IE is also retrieved from tail IE buffer and sent to firmware.

Signed-off-by: Avinash Patil <patila@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cfg80211.c |    2 +
 drivers/net/wireless/mwifiex/fw.h       |    7 ++
 drivers/net/wireless/mwifiex/ie.c       |  176 +++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/main.c     |    4 +
 drivers/net/wireless/mwifiex/main.h     |    6 +
 5 files changed, 195 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index d305b37..2d0952d 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -952,6 +952,8 @@ static int mwifiex_cfg80211_start_ap(struct wiphy *wiphy,
 
 	if (priv->bss_type != MWIFIEX_BSS_TYPE_UAP)
 		return -1;
+	if (mwifiex_set_mgmt_ies(priv, params))
+		return -1;
 
 	bss_cfg = kzalloc(sizeof(struct mwifiex_uap_bss_param), GFP_KERNEL);
 	if (!bss_cfg)
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index 0cb2b0c..9f674bb 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -97,6 +97,13 @@ enum MWIFIEX_802_11_PRIVACY_FILTER {
 #define UAP_CUSTOM_IE_I				1
 #define MWIFIEX_AUTO_IDX_MASK			0xffff
 #define MWIFIEX_DELETE_MASK			0x0000
+#define MGMT_MASK_ASSOC_REQ			0x01
+#define MGMT_MASK_REASSOC_REQ			0x04
+#define MGMT_MASK_ASSOC_RESP			0x02
+#define MGMT_MASK_REASSOC_RESP			0x08
+#define MGMT_MASK_PROBE_REQ			0x10
+#define MGMT_MASK_PROBE_RESP			0x20
+#define MGMT_MASK_BEACON			0x100
 
 #define TLV_TYPE_UAP_SSID			0x0000
 
diff --git a/drivers/net/wireless/mwifiex/ie.c b/drivers/net/wireless/mwifiex/ie.c
index 772bf3e..ca9ebcf 100644
--- a/drivers/net/wireless/mwifiex/ie.c
+++ b/drivers/net/wireless/mwifiex/ie.c
@@ -147,3 +147,179 @@ mwifiex_update_autoindex_ies(struct mwifiex_private *priv,
 
 	return 0;
 }
+
+/* Copy individual custom IEs for beacon, probe response and assoc response
+ * and prepare single structure for IE setting.
+ * This function also updates allocated IE indices from driver.
+ */
+static int
+mwifiex_update_uap_custom_ie(struct mwifiex_private *priv,
+			     struct mwifiex_ie *beacon_ie, u16 *beacon_idx,
+			     struct mwifiex_ie *pr_ie, u16 *probe_idx,
+			     struct mwifiex_ie *ar_ie, u16 *assoc_idx)
+{
+	struct mwifiex_ie_list *ap_custom_ie;
+	u8 *pos;
+	u16 len;
+	int ret;
+
+	ap_custom_ie = kzalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+	if (!ap_custom_ie)
+		return -ENOMEM;
+
+	ap_custom_ie->type = cpu_to_le16(TLV_TYPE_MGMT_IE);
+	pos = (u8 *)ap_custom_ie->ie_list;
+
+	if (beacon_ie) {
+		len = sizeof(struct mwifiex_ie) - IEEE_MAX_IE_SIZE +
+		      le16_to_cpu(beacon_ie->ie_length);
+		memcpy(pos, beacon_ie, len);
+		pos += len;
+		le16_add_cpu(&ap_custom_ie->len, len);
+	}
+	if (pr_ie) {
+		len = sizeof(struct mwifiex_ie) - IEEE_MAX_IE_SIZE +
+		      le16_to_cpu(pr_ie->ie_length);
+		memcpy(pos, pr_ie, len);
+		pos += len;
+		le16_add_cpu(&ap_custom_ie->len, len);
+	}
+	if (ar_ie) {
+		len = sizeof(struct mwifiex_ie) - IEEE_MAX_IE_SIZE +
+		      le16_to_cpu(ar_ie->ie_length);
+		memcpy(pos, ar_ie, len);
+		pos += len;
+		le16_add_cpu(&ap_custom_ie->len, len);
+	}
+
+	ret = mwifiex_update_autoindex_ies(priv, ap_custom_ie);
+
+	pos = (u8 *)(&ap_custom_ie->ie_list[0].ie_index);
+	if (beacon_ie && *beacon_idx == MWIFIEX_AUTO_IDX_MASK) {
+		/* save beacon ie index after auto-indexing */
+		*beacon_idx = le16_to_cpu(ap_custom_ie->ie_list[0].ie_index);
+		len = sizeof(*beacon_ie) - IEEE_MAX_IE_SIZE +
+		      le16_to_cpu(beacon_ie->ie_length);
+		pos += len;
+	}
+	if (pr_ie && le16_to_cpu(pr_ie->ie_index) == MWIFIEX_AUTO_IDX_MASK) {
+		/* save probe resp ie index after auto-indexing */
+		*probe_idx = *((u16 *)pos);
+		len = sizeof(*pr_ie) - IEEE_MAX_IE_SIZE +
+		      le16_to_cpu(pr_ie->ie_length);
+		pos += len;
+	}
+	if (ar_ie && le16_to_cpu(ar_ie->ie_index) == MWIFIEX_AUTO_IDX_MASK)
+		/* save assoc resp ie index after auto-indexing */
+		*assoc_idx = *((u16 *)pos);
+
+	return ret;
+}
+
+/* This function parses different IEs- Tail IEs, beacon IEs, probe response IEs,
+ * association response IEs from cfg80211_ap_settings function and sets these IE
+ * to FW.
+ */
+int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
+			 struct cfg80211_ap_settings *params)
+{
+	struct mwifiex_ie *beacon_ie = NULL, *pr_ie = NULL;
+	struct mwifiex_ie *ar_ie = NULL, *rsn_ie = NULL;
+	struct ieee_types_header *ie = NULL;
+	u16 beacon_idx = MWIFIEX_AUTO_IDX_MASK, pr_idx = MWIFIEX_AUTO_IDX_MASK;
+	u16 ar_idx = MWIFIEX_AUTO_IDX_MASK, rsn_idx = MWIFIEX_AUTO_IDX_MASK;
+	u16 mask;
+	int ret = 0;
+
+	if (params->beacon.tail && params->beacon.tail_len) {
+		ie = (void *)cfg80211_find_ie(WLAN_EID_RSN, params->beacon.tail,
+					      params->beacon.tail_len);
+		if (ie) {
+			rsn_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+			if (!rsn_ie)
+				return -ENOMEM;
+
+			rsn_ie->ie_index = cpu_to_le16(rsn_idx);
+			mask = MGMT_MASK_BEACON | MGMT_MASK_PROBE_RESP |
+			       MGMT_MASK_ASSOC_RESP;
+			rsn_ie->mgmt_subtype_mask = cpu_to_le16(mask);
+			rsn_ie->ie_length = cpu_to_le16(ie->len + 2);
+			memcpy(rsn_ie->ie_buffer, ie, ie->len + 2);
+
+			if (mwifiex_update_uap_custom_ie(priv, rsn_ie, &rsn_idx,
+							 NULL, NULL,
+							 NULL, NULL)) {
+				ret = -1;
+				goto done;
+			}
+
+			priv->rsn_idx = rsn_idx;
+		}
+	}
+
+	if (params->beacon.beacon_ies && params->beacon.beacon_ies_len) {
+		beacon_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+		if (!beacon_ie) {
+			ret = -ENOMEM;
+			goto done;
+		}
+
+		beacon_ie->ie_index = cpu_to_le16(beacon_idx);
+		beacon_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_BEACON);
+		beacon_ie->ie_length =
+				cpu_to_le16(params->beacon.beacon_ies_len);
+		memcpy(beacon_ie->ie_buffer, params->beacon.beacon_ies,
+		       params->beacon.beacon_ies_len);
+	}
+
+	if (params->beacon.proberesp_ies && params->beacon.proberesp_ies_len) {
+		pr_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+		if (!pr_ie) {
+			ret = -ENOMEM;
+			goto done;
+		}
+
+		pr_ie->ie_index = cpu_to_le16(pr_idx);
+		pr_ie->mgmt_subtype_mask = cpu_to_le16(MGMT_MASK_PROBE_RESP);
+		pr_ie->ie_length =
+				cpu_to_le16(params->beacon.proberesp_ies_len);
+		memcpy(pr_ie->ie_buffer, params->beacon.proberesp_ies,
+		       params->beacon.proberesp_ies_len);
+	}
+
+	if (params->beacon.assocresp_ies && params->beacon.assocresp_ies_len) {
+		ar_ie = kmalloc(sizeof(struct mwifiex_ie), GFP_KERNEL);
+		if (!ar_ie) {
+			ret = -ENOMEM;
+			goto done;
+		}
+
+		ar_ie->ie_index = cpu_to_le16(ar_idx);
+		mask = MGMT_MASK_ASSOC_RESP | MGMT_MASK_REASSOC_RESP;
+		ar_ie->mgmt_subtype_mask = cpu_to_le16(mask);
+		ar_ie->ie_length =
+				cpu_to_le16(params->beacon.assocresp_ies_len);
+		memcpy(ar_ie->ie_buffer, params->beacon.assocresp_ies,
+		       params->beacon.assocresp_ies_len);
+	}
+
+	if (beacon_ie || pr_ie || ar_ie) {
+		ret = mwifiex_update_uap_custom_ie(priv, beacon_ie,
+						   &beacon_idx, pr_ie,
+						   &pr_idx, ar_ie, &ar_idx);
+		if (ret)
+			goto done;
+	}
+
+	priv->beacon_idx = beacon_idx;
+	priv->proberesp_idx = pr_idx;
+	priv->assocresp_idx = ar_idx;
+
+done:
+	kfree(beacon_ie);
+	kfree(pr_ie);
+	kfree(ar_ie);
+	kfree(rsn_ie);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 49598e6..3192855 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -642,6 +642,10 @@ void mwifiex_init_priv_params(struct mwifiex_private *priv,
 	memset(&priv->nick_name, 0, sizeof(priv->nick_name));
 	memset(priv->mgmt_ie, 0,
 	       sizeof(struct mwifiex_ie) * MAX_MGMT_IE_INDEX);
+	priv->beacon_idx = MWIFIEX_AUTO_IDX_MASK;
+	priv->proberesp_idx = MWIFIEX_AUTO_IDX_MASK;
+	priv->assocresp_idx = MWIFIEX_AUTO_IDX_MASK;
+	priv->rsn_idx = MWIFIEX_AUTO_IDX_MASK;
 	priv->num_tx_timeout = 0;
 	memcpy(dev->dev_addr, priv->curr_addr, ETH_ALEN);
 }
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 988d31d..7d882ee 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -478,6 +478,10 @@ struct mwifiex_private {
 	u32 cqm_rssi_hyst;
 	u8 subsc_evt_rssi_state;
 	struct mwifiex_ie mgmt_ie[MAX_MGMT_IE_INDEX];
+	u16 beacon_idx;
+	u16 proberesp_idx;
+	u16 assocresp_idx;
+	u16 rsn_idx;
 };
 
 enum mwifiex_ba_status {
@@ -1001,6 +1005,8 @@ int mwifiex_del_virtual_intf(struct wiphy *wiphy, struct net_device *dev);
 
 void mwifiex_set_sys_config_invalid_data(struct mwifiex_uap_bss_param *config);
 
+int mwifiex_set_mgmt_ies(struct mwifiex_private *priv,
+			 struct cfg80211_ap_settings *params);
 u8 *mwifiex_11d_code_2_region(u8 code);
 
 #ifdef CONFIG_DEBUG_FS
-- 
1.7.0.2

