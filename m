Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0084.outbound.protection.outlook.com ([104.47.38.84]:56768
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751004AbeAVMrI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 07:47:08 -0500
From: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
To: linux-wireless@vger.kernel.org
Cc: Igor Mitsyanko <igor.mitsyanko.os@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Subject: [PATCH 06/11] qtnfmac: modify supported interface combinations
Date: Mon, 22 Jan 2018 15:46:29 +0300
Message-Id: <20180122124634.8430-7-sergey.matyukevich.os@quantenna.com> (sfid-20180122_134713_649787_7044AEFA)
In-Reply-To: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
References: <20180122124634.8430-1-sergey.matyukevich.os@quantenna.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update existing code handling configuration of supported interface
combinations. Current implementation is not complete since it does
not report multiple interface combinations which are incompatible
with each other. Instead current implementation packs all the
supported combinations into single entry.

In fact currently qsr10g wireless card supports the following
two distinct interface combinations:

1. STA/repeater: 1 STA and/or 1 AP
   {
     { .max = 1, .types = NL80211_IFTYPE_AP},
     { .max = 1, .types = NL80211_IFTYPE_STA},
   }

2. AP/mBSS
   {
     { .max = 8, .types = NL80211_IFTYPE_AP},
   }

The list of supported configuration is reported by firmware during
wireless card bring-up. Communication protocol between firmware
and host has been updated accordingly in order to accommodate passing
multiple interface combination entries.

Signed-off-by: Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
---
 drivers/net/wireless/quantenna/qtnfmac/cfg80211.c |  53 +++++------
 drivers/net/wireless/quantenna/qtnfmac/commands.c | 102 ++++++++++++++--------
 drivers/net/wireless/quantenna/qtnfmac/core.c     |  20 ++++-
 drivers/net/wireless/quantenna/qtnfmac/core.h     |   5 +-
 drivers/net/wireless/quantenna/qtnfmac/qlink.h    |  11 ++-
 5 files changed, 115 insertions(+), 76 deletions(-)

diff --git a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
index 03f819076197..78e8968ab3c7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/cfg80211.c
@@ -876,29 +876,29 @@ struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus)
 	return wiphy;
 }
 
-static int qtnf_wiphy_setup_if_comb(struct wiphy *wiphy,
-				    struct ieee80211_iface_combination *if_comb,
-				    const struct qtnf_mac_info *mac_info)
+static int
+qtnf_wiphy_setup_if_comb(struct wiphy *wiphy, struct qtnf_mac_info *mac_info)
 {
-	size_t max_interfaces = 0;
+	struct ieee80211_iface_combination *if_comb;
+	size_t n_if_comb;
 	u16 interface_modes = 0;
-	size_t i;
+	size_t i, j;
+
+	if_comb = mac_info->if_comb;
+	n_if_comb = mac_info->n_if_comb;
 
-	if (unlikely(!mac_info->limits || !mac_info->n_limits))
+	if (!if_comb || !n_if_comb)
 		return -ENOENT;
 
-	if_comb->limits = mac_info->limits;
-	if_comb->n_limits = mac_info->n_limits;
+	for (i = 0; i < n_if_comb; i++) {
+		if_comb[i].radar_detect_widths = mac_info->radar_detect_widths;
 
-	for (i = 0; i < mac_info->n_limits; i++) {
-		max_interfaces += mac_info->limits[i].max;
-		interface_modes |= mac_info->limits[i].types;
+		for (j = 0; j < if_comb[i].n_limits; j++)
+			interface_modes |= if_comb[i].limits[j].types;
 	}
 
-	if_comb->num_different_channels = 1;
-	if_comb->beacon_int_infra_match = true;
-	if_comb->max_interfaces = max_interfaces;
-	if_comb->radar_detect_widths = mac_info->radar_detect_widths;
+	wiphy->iface_combinations = if_comb;
+	wiphy->n_iface_combinations = n_if_comb;
 	wiphy->interface_modes = interface_modes;
 
 	return 0;
@@ -907,7 +907,6 @@ static int qtnf_wiphy_setup_if_comb(struct wiphy *wiphy,
 int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 {
 	struct wiphy *wiphy = priv_to_wiphy(mac);
-	struct ieee80211_iface_combination *iface_comb = NULL;
 	int ret;
 
 	if (!wiphy) {
@@ -915,14 +914,6 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 		return -EFAULT;
 	}
 
-	iface_comb = kzalloc(sizeof(*iface_comb), GFP_KERNEL);
-	if (!iface_comb)
-		return -ENOMEM;
-
-	ret = qtnf_wiphy_setup_if_comb(wiphy, iface_comb, &mac->macinfo);
-	if (ret)
-		goto out;
-
 	wiphy->frag_threshold = mac->macinfo.frag_thr;
 	wiphy->rts_threshold = mac->macinfo.rts_thr;
 	wiphy->retry_short = mac->macinfo.sretry_limit;
@@ -934,11 +925,12 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 	wiphy->mgmt_stypes = qtnf_mgmt_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
 	wiphy->max_acl_mac_addrs = mac->macinfo.max_acl_mac_addrs;
-
-	wiphy->iface_combinations = iface_comb;
-	wiphy->n_iface_combinations = 1;
 	wiphy->max_num_csa_counters = 2;
 
+	ret = qtnf_wiphy_setup_if_comb(wiphy, &mac->macinfo);
+	if (ret)
+		goto out;
+
 	/* Initialize cipher suits */
 	wiphy->cipher_suites = qtnf_cipher_suites;
 	wiphy->n_cipher_suites = ARRAY_SIZE(qtnf_cipher_suites);
@@ -987,12 +979,7 @@ int qtnf_wiphy_register(struct qtnf_hw_info *hw_info, struct qtnf_wmac *mac)
 		ret = regulatory_hint(wiphy, hw_info->rd->alpha2);
 
 out:
-	if (ret) {
-		kfree(iface_comb);
-		return ret;
-	}
-
-	return 0;
+	return ret;
 }
 
 void qtnf_netdev_updown(struct net_device *ndev, bool up)
diff --git a/drivers/net/wireless/quantenna/qtnfmac/commands.c b/drivers/net/wireless/quantenna/qtnfmac/commands.c
index 2017532477c9..2820b0318c6a 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/commands.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/commands.c
@@ -1116,19 +1116,22 @@ qtnf_cmd_resp_proc_hw_info(struct qtnf_bus *bus,
 static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 					const u8 *tlv_buf, size_t tlv_buf_size)
 {
-	struct ieee80211_iface_limit *limits = NULL;
-	const struct qlink_iface_limit *limit_record;
-	size_t record_count = 0, rec = 0;
-	u16 tlv_type, tlv_value_len;
-	struct qlink_iface_comb_num *comb;
+	struct ieee80211_iface_combination *comb = NULL;
+	size_t n_comb = 0;
+	struct ieee80211_iface_limit *limits;
+	const struct qlink_iface_comb_num *comb_num;
+	const struct qlink_iface_limit_record *rec;
+	const struct qlink_iface_limit *lim;
+	u16 rec_len;
+	u16 tlv_type;
+	u16 tlv_value_len;
 	size_t tlv_full_len;
 	const struct qlink_tlv_hdr *tlv;
 	u8 *ext_capa = NULL;
 	u8 *ext_capa_mask = NULL;
 	u8 ext_capa_len = 0;
 	u8 ext_capa_mask_len = 0;
-
-	mac->macinfo.n_limits = 0;
+	int i = 0;
 
 	tlv = (const struct qlink_tlv_hdr *)tlv_buf;
 	while (tlv_buf_size >= sizeof(struct qlink_tlv_hdr)) {
@@ -1143,52 +1146,77 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 
 		switch (tlv_type) {
 		case QTN_TLV_ID_NUM_IFACE_COMB:
-			if (unlikely(tlv_value_len != sizeof(*comb)))
+			if (tlv_value_len != sizeof(*comb_num))
 				return -EINVAL;
 
-			comb = (void *)tlv->val;
-			record_count = le16_to_cpu(comb->iface_comb_num);
+			comb_num = (void *)tlv->val;
+
+			/* free earlier iface comb memory */
+			qtnf_mac_iface_comb_free(mac);
 
-			mac->macinfo.n_limits = record_count;
-			/* free earlier iface limits memory */
-			kfree(mac->macinfo.limits);
-			mac->macinfo.limits =
-				kzalloc(sizeof(*mac->macinfo.limits) *
-					record_count, GFP_KERNEL);
+			mac->macinfo.n_if_comb =
+				le32_to_cpu(comb_num->iface_comb_num);
 
-			if (unlikely(!mac->macinfo.limits))
+			mac->macinfo.if_comb =
+				kcalloc(mac->macinfo.n_if_comb,
+					sizeof(*mac->macinfo.if_comb),
+					GFP_KERNEL);
+
+			if (!mac->macinfo.if_comb)
 				return -ENOMEM;
 
-			limits = mac->macinfo.limits;
+			comb = mac->macinfo.if_comb;
+
+			pr_debug("MAC%u: %zu iface combinations\n",
+				 mac->macid, mac->macinfo.n_if_comb);
+
 			break;
 		case QTN_TLV_ID_IFACE_LIMIT:
-			if (unlikely(!limits)) {
-				pr_warn("MAC%u: limits are not inited\n",
+			if (unlikely(!comb)) {
+				pr_warn("MAC%u: no combinations advertised\n",
 					mac->macid);
 				return -EINVAL;
 			}
 
-			if (unlikely(tlv_value_len != sizeof(*limit_record))) {
-				pr_warn("MAC%u: record size mismatch\n",
+			if (n_comb >= mac->macinfo.n_if_comb) {
+				pr_warn("MAC%u: combinations count exceeded\n",
 					mac->macid);
-				return -EINVAL;
+				n_comb++;
+				break;
 			}
 
-			limit_record = (void *)tlv->val;
-			limits[rec].max = le16_to_cpu(limit_record->max_num);
-			limits[rec].types = qlink_iface_type_to_nl_mask(
-				le16_to_cpu(limit_record->type));
+			rec = (void *)tlv->val;
+			rec_len = sizeof(*rec) + rec->n_limits * sizeof(*lim);
 
-			/* supported modes: STA, AP */
-			limits[rec].types &= BIT(NL80211_IFTYPE_AP) |
-					     BIT(NL80211_IFTYPE_AP_VLAN) |
-					     BIT(NL80211_IFTYPE_STATION);
+			if (unlikely(tlv_value_len != rec_len)) {
+				pr_warn("MAC%u: record %zu size mismatch\n",
+					mac->macid, n_comb);
+				return -EINVAL;
+			}
 
-			pr_debug("MAC%u: MAX: %u; TYPES: %.4X\n", mac->macid,
-				 limits[rec].max, limits[rec].types);
+			limits = kzalloc(sizeof(*limits) * rec->n_limits,
+					 GFP_KERNEL);
+			if (!limits)
+				return -ENOMEM;
+
+			comb[n_comb].num_different_channels =
+				rec->num_different_channels;
+			comb[n_comb].max_interfaces =
+				le16_to_cpu(rec->max_interfaces);
+			comb[n_comb].n_limits = rec->n_limits;
+			comb[n_comb].limits = limits;
+
+			for (i = 0; i < rec->n_limits; i++) {
+				lim = &rec->limits[i];
+				limits[i].max = le16_to_cpu(lim->max_num);
+				limits[i].types =
+					qlink_iface_type_to_nl_mask(le16_to_cpu(lim->type));
+				pr_debug("MAC%u: comb[%zu]: MAX:%u TYPES:%.4X\n",
+					 mac->macid, n_comb,
+					 limits[i].max, limits[i].types);
+			}
 
-			if (limits[rec].types)
-				rec++;
+			n_comb++;
 			break;
 		case WLAN_EID_EXT_CAPABILITY:
 			if (unlikely(tlv_value_len > U8_MAX))
@@ -1216,9 +1244,9 @@ static int qtnf_parse_variable_mac_info(struct qtnf_wmac *mac,
 		return -EINVAL;
 	}
 
-	if (mac->macinfo.n_limits != rec) {
+	if (mac->macinfo.n_if_comb != n_comb) {
 		pr_err("MAC%u: combination mismatch: reported=%zu parsed=%zu\n",
-		       mac->macid, mac->macinfo.n_limits, rec);
+		       mac->macid, mac->macinfo.n_if_comb, n_comb);
 		return -EINVAL;
 	}
 
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.c b/drivers/net/wireless/quantenna/qtnfmac/core.c
index 1acbe30dfc66..b1344d0731d7 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.c
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.c
@@ -262,6 +262,23 @@ struct qtnf_vif *qtnf_mac_get_base_vif(struct qtnf_wmac *mac)
 	return vif;
 }
 
+void qtnf_mac_iface_comb_free(struct qtnf_wmac *mac)
+{
+	struct ieee80211_iface_combination *comb;
+	int i;
+
+	if (mac->macinfo.if_comb) {
+		for (i = 0; i < mac->macinfo.n_if_comb; i++) {
+			comb = &mac->macinfo.if_comb[i];
+			kfree(comb->limits);
+			comb->limits = NULL;
+		}
+
+		kfree(mac->macinfo.if_comb);
+		mac->macinfo.if_comb = NULL;
+	}
+}
+
 static void qtnf_vif_reset_handler(struct work_struct *work)
 {
 	struct qtnf_vif *vif = container_of(work, struct qtnf_vif, reset_work);
@@ -420,10 +437,9 @@ static void qtnf_core_mac_detach(struct qtnf_bus *bus, unsigned int macid)
 		wiphy->bands[band] = NULL;
 	}
 
-	kfree(mac->macinfo.limits);
+	qtnf_mac_iface_comb_free(mac);
 	kfree(mac->macinfo.extended_capabilities);
 	kfree(mac->macinfo.extended_capabilities_mask);
-	kfree(wiphy->iface_combinations);
 	wiphy_free(wiphy);
 	bus->mac[macid] = NULL;
 }
diff --git a/drivers/net/wireless/quantenna/qtnfmac/core.h b/drivers/net/wireless/quantenna/qtnfmac/core.h
index e47198cbcceb..29f38bd3b491 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/core.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/core.h
@@ -108,8 +108,8 @@ struct qtnf_mac_info {
 	u32 max_acl_mac_addrs;
 	struct ieee80211_ht_cap ht_cap_mod_mask;
 	struct ieee80211_vht_cap vht_cap_mod_mask;
-	struct ieee80211_iface_limit *limits;
-	size_t n_limits;
+	struct ieee80211_iface_combination *if_comb;
+	size_t n_if_comb;
 	u8 *extended_capabilities;
 	u8 *extended_capabilities_mask;
 	u8 extended_capabilities_len;
@@ -151,6 +151,7 @@ struct qtnf_hw_info {
 
 struct qtnf_vif *qtnf_mac_get_free_vif(struct qtnf_wmac *mac);
 struct qtnf_vif *qtnf_mac_get_base_vif(struct qtnf_wmac *mac);
+void qtnf_mac_iface_comb_free(struct qtnf_wmac *mac);
 struct wiphy *qtnf_wiphy_allocate(struct qtnf_bus *bus);
 int qtnf_core_net_attach(struct qtnf_wmac *mac, struct qtnf_vif *priv,
 			 const char *name, unsigned char name_assign_type);
diff --git a/drivers/net/wireless/quantenna/qtnfmac/qlink.h b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
index 51cadd2a43f0..9bf3ae4d1b3b 100644
--- a/drivers/net/wireless/quantenna/qtnfmac/qlink.h
+++ b/drivers/net/wireless/quantenna/qtnfmac/qlink.h
@@ -1092,13 +1092,20 @@ struct qlink_tlv_hdr {
 	u8 val[0];
 } __packed;
 
+struct qlink_iface_comb_num {
+	__le32 iface_comb_num;
+} __packed;
+
 struct qlink_iface_limit {
 	__le16 max_num;
 	__le16 type;
 } __packed;
 
-struct qlink_iface_comb_num {
-	__le16 iface_comb_num;
+struct qlink_iface_limit_record {
+	__le16 max_interfaces;
+	u8 num_different_channels;
+	u8 n_limits;
+	struct qlink_iface_limit limits[0];
 } __packed;
 
 #define QLINK_RSSI_OFFSET	120
-- 
2.11.0
