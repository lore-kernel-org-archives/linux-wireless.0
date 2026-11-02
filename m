Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657437;
	b=ytgXxmIYV1GeStxCd71SkxEzpllItrQJo2wX9oImBU4/a4ytAo2oU4MdE0hn/04AN7mS
	 U/40Vkolzv4mv5L9pNUyty5UlasVtQ13GKey+t+zan+XU+f4vUfoaFm7mZoAenwSwyLf4
	 ESnl5c8XopL1JWGK7MHm+xoqGzLpte5mMv8bHm/su3YRuJ2L1G2gcGdmQ8QFJg1evtKQk
	 zwA3zzrbYfzWPqa/pi44LUIX8AiTnDJ7ynz7aiaA/AEMjU+iR0EJpD2QyqUZep6iXtCmr
	 WNfGq3Dk0zdscAl8InENbe7O3o3jUaK++gbbL8qFrQdZi36bYF/A/SfTIRjcfP7a2lA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657437;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rBcmYo48GORdfEUT6SIIM8CTUjKjwCWO4qKhDBgs24U=;
	b=r7Ei1CiaQ1Prr5zfnc96AO6YSb5FwpCCEUZyFZvljgYgy5juI8W7/lN++xhFIpOssZme
	 O0KK/wbSLLIFCAWAUP4p7ZNN8Rlp/B1xYmgfjsDppQCPJxrMpGV0ke3eRrZLNSJEZtKZi
	 qkR5B0XnI2cg1rbRI4ttibPOQg8jKrFDMhtFNYyEOGvM+ltaZNvAaVEVWt7b6F/VLnmy8
	 5C/wGD2m1HE6Ex08lO6tGPc5CBVyFx9xmusaC1CncOEPIWHceTGNO8aU/69Cwoy6LbZUA
	 u6zDpPlPTRM3quSYMEg2eu091P3pHtQe/0CpI0QTeK+PpN7n04kaJerRDnvHkMx7OVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Uq7kcSjK;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B599A606A329
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=Uq7kcSjK
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=rBcmYo48GORdfEUT6SIIM8CTUjKjwCWO4qKhDBgs24U=;
	t=1793657436; x=1794867036; b=Uq7kcSjK11T5HRDqI4CLJFJCKwwQ/Ui/aXViuGq5Z6CHaIe
	R1Oe8qTUDUOo7oa4wfUCKQj1npOouw+Gnu3GtwfY90895qVCyLicxLRXR1hcxiedj3paROJI+N0j2
	5J6QsRogaY+G4ybjHpyZjxzZKuI11qTDhQYpWH76GCdRIcLxv7mdfdhlRvMggT3PdrDjU3l7kW0tP
	anAnK9xuWmdiBf7my6hYlWBBk/8lN+k+GRv5qdcY05vUyuFQNWEgxW07CMaqvDCTBFwZgIOs7WKNx
	6o6DvkRIuwgNCOLVkwltaV13Rh4WS00KrHwOymqWa/ZxHoMGFKwYecNRMbl3FZgA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0Ec-000000022rO-1Yzy;
	Mon, 02 Nov 2026 23:10:34 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 4/8] wifi: define SMD Transition frame formats
Date: Mon,  2 Nov 2026 23:08:24 +0100
Message-ID: <20261102231028.ce883e7ca2db.I1143a86c6ff8e8d99b625d7b3189df1218386c69@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102221028.1124852-10-johannes@sipsolutions.net>
References: <20261102221028.1124852-10-johannes@sipsolutions.net>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Define structures and flags for various bits and pieces
of frames and elements used during SMD Transition, per
Draft 802.11bn D2.0.

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-eht.h |   5 +
 include/linux/ieee80211-uhr.h | 315 ++++++++++++++++++++++++++++++++++
 include/linux/ieee80211.h     |   1 +
 3 files changed, 321 insertions(+)

diff --git a/include/linux/ieee80211-eht.h b/include/linux/ieee80211-eht.h
index cada6270f60a..b5412b205307 100644
--- a/include/linux/ieee80211-eht.h
+++ b/include/linux/ieee80211-eht.h
@@ -772,6 +772,9 @@ static inline u16 ieee80211_mle_get_mld_capa_op(const u8 *data)
 #define IEEE80211_EHT_ML_EXT_MLD_CAPA_BTM_MLD_RECO_MULTI_AP	0x0080
 /* defined by UHR Draft P802.11bn_D1.5 Figure 9-1168 */
 #define IEEE80211_UHR_ML_EXT_MLD_CAPA_ML_PM			0x0100
+/* defined by UHR Draft P802.11bn_D2.0 Figure 9-1171 */
+#define IEEE80211_UHR_ML_EXT_MLD_CAPA_MAX_DL_BA_BITMAP_LEN	0x1c00
+#define IEEE80211_UHR_ML_EXT_MLD_CAPA_DL_DUAL_BA		0x2000
 
 /**
  * ieee80211_mle_get_ext_mld_capa_op - returns the extended MLD capabilities
@@ -1159,6 +1162,8 @@ ieee80211_mle_basic_sta_prof_enh_crit_upd(const struct ieee80211_mle_per_sta_pro
 #define IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_TYPE_DEL_LINK	3
 #define IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_TYPE_NSTR_STATUS	4
 #define IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_TYPE_UHR_OMP_UPD	5
+#define IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_TYPE_DEL_ST_PREP	6
+#define IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_TYPE_ST_LINK_DISABLE	7
 #define IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_PARAMS_PRESENT	0x0800
 #define IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_NSTR_BMAP_SIZE	0x1000
 #define IEEE80211_MLE_STA_RECONF_CONTROL_OPERATION_NSTR_IND_BMAP_PRES	0x2000
diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index c6c89e4562f4..d8b766ad252e 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -10,6 +10,7 @@
 #include <linux/types.h>
 #include <linux/bitfield.h>
 #include <linux/if_ether.h>
+#include <linux/unaligned.h>
 #include "ieee80211-eht.h"
 
 #define IEEE80211_UHR_OPER_PARAMS_DPS_ENA		0x0001
@@ -643,6 +644,7 @@ enum ieee80211_uhr_link_reconfig_response_type {
 enum ieee80211_uhr_link_reconfig_notify_type {
 	IEEE80211_UHR_LINK_RECONFIG_NOTIFY_DL_DRAINED		= 2,
 	IEEE80211_UHR_LINK_RECONFIG_NOTIFY_OMP_RESPONSE		= 3,
+	IEEE80211_UHR_LINK_RECONFIG_NOTIFY_ST_UPDATE		= 5,
 };
 
 enum ieee80211_uhr_mode_change_control {
@@ -830,4 +832,317 @@ ieee80211_uhr_param_update_ok(const void *elem, size_t len)
 	return (const u8 *)tuple == (const u8 *)elem + len;
 }
 
+struct ieee80211_smd_bss_trans_scs_list {
+	u8 n_ids;
+	u8 ids[];
+} __packed;
+
+static inline bool
+ieee80211_smd_bss_trans_scs_list_ok(const u8 **pos, size_t *remaining)
+{
+	const struct ieee80211_smd_bss_trans_scs_list *scs = (const void *)*pos;
+	size_t size;
+
+	if (*remaining < sizeof(*scs))
+		return false;
+
+	size = sizeof(*scs) + scs->n_ids;
+	if (*remaining < size)
+		return false;
+
+	*pos += size;
+	*remaining -= size;
+	return true;
+}
+
+enum ieee80211_st_control_prep_req {
+	IEEE80211_ST_CONTROL_PREP_REQ_NO_DL_SN_TRANSFER	= 0x01,
+	IEEE80211_ST_CONTROL_PREP_REQ_NO_UL_SN_TRANSFER	= 0x02,
+	IEEE80211_ST_CONTROL_PREP_REQ_SCS_LIST_PRESENT	= 0x04,
+};
+
+/**
+ * struct ieee80211_smd_bss_trans_params_prep_req - SMD BSS Transition Parameters
+ *	element in preparation request
+ * @st_control: ST control field, see &enum ieee80211_st_control_prep_req
+ * @listen_interval: listen interval
+ * @variable: variable (currently SCS list)
+ */
+struct ieee80211_smd_bss_trans_params_prep_req {
+	u8 st_control;
+	__le16 listen_interval;
+	u8 variable[];
+} __packed;
+
+enum ieee80211_st_control_prep_resp {
+	IEEE80211_ST_CONTROL_PREP_RESP_DL_BA_INFO_PRESENT	= 0x01,
+	IEEE80211_ST_CONTROL_PREP_RESP_UL_BA_INFO_PRESENT	= 0x02,
+	IEEE80211_ST_CONTROL_PREP_RESP_SCS_LIST_PRESENT		= 0x04,
+};
+
+/* Note: D2.0 - we expect this to change */
+struct ieee80211_smd_bss_trans_ext_ba_params {
+	__le16 ba_param_set;
+	u8 addba_ext_param_set;
+} __packed;
+
+struct ieee80211_smd_bss_trans_ba_info {
+	u8 tid_bitmap;
+	struct ieee80211_smd_bss_trans_ext_ba_params params[];
+} __packed;
+
+static inline bool
+ieee80211_smd_bss_trans_ba_info_ok(const u8 **pos, size_t *remaining)
+{
+	const struct ieee80211_smd_bss_trans_ba_info *ba = (const void *)*pos;
+	size_t size;
+
+	if (*remaining < sizeof(*ba))
+		return false;
+
+	/* one extended BA parameters entry per TID set in the bitmap */
+	size = sizeof(*ba) + hweight8(ba->tid_bitmap) * sizeof(ba->params[0]);
+	if (*remaining < size)
+		return false;
+
+	*pos += size;
+	*remaining -= size;
+	return true;
+}
+
+/**
+ * struct ieee80211_smd_bss_trans_params_prep_resp - SMD BSS Transition Parameters
+ *	element in preparation response
+ * @st_control: ST control field, see &enum ieee80211_st_control_prep_resp
+ * @variable: variable (DL BA info, UL BA info, SCS list)
+ */
+struct ieee80211_smd_bss_trans_params_prep_resp {
+	u8 st_control;
+	u8 variable[];
+} __packed;
+
+static inline bool
+ieee80211_smd_prep_resp_size_ok(const u8 *data, u8 len)
+{
+	const struct ieee80211_smd_bss_trans_params_prep_resp *params =
+		(const void *)data;
+	const u8 *pos = params->variable;
+	size_t remaining;
+
+	if (len < sizeof(*params))
+		return false;
+	remaining = len - sizeof(*params);
+
+	/* DL BA info, UL BA info and the SCS list follow in order, if present */
+	if ((params->st_control &
+	     IEEE80211_ST_CONTROL_PREP_RESP_DL_BA_INFO_PRESENT) &&
+	    !ieee80211_smd_bss_trans_ba_info_ok(&pos, &remaining))
+		return false;
+
+	if ((params->st_control &
+	     IEEE80211_ST_CONTROL_PREP_RESP_UL_BA_INFO_PRESENT) &&
+	    !ieee80211_smd_bss_trans_ba_info_ok(&pos, &remaining))
+		return false;
+
+	if ((params->st_control &
+	     IEEE80211_ST_CONTROL_PREP_RESP_SCS_LIST_PRESENT) &&
+	    !ieee80211_smd_bss_trans_scs_list_ok(&pos, &remaining))
+		return false;
+
+	return true;
+}
+
+/**
+ * ieee80211_smd_prep_resp_ba_info - get per-TID Block Ack info from a
+ *	preparation response element
+ * @data: the SMD BSS Transition Parameters (preparation response) element data,
+ *	which must already have passed ieee80211_smd_prep_resp_size_ok()
+ * @uplink: %true for the uplink BA info, %false for the downlink BA info
+ * @tid: the TID to look up
+ *
+ * Return: a pointer to the extended BA parameters for @tid in the requested
+ *	direction, or %NULL if that direction is not present or @tid is not set
+ *	in its TID bitmap.
+ */
+static inline const struct ieee80211_smd_bss_trans_ext_ba_params *
+ieee80211_smd_prep_resp_ba_info(const u8 *data, bool uplink, u8 tid)
+{
+	const struct ieee80211_smd_bss_trans_params_prep_resp *params =
+		(const void *)data;
+	const struct ieee80211_smd_bss_trans_ba_info *ba;
+	const u8 *pos = params->variable;
+
+	if (uplink) {
+		if (!(params->st_control &
+		      IEEE80211_ST_CONTROL_PREP_RESP_UL_BA_INFO_PRESENT))
+			return NULL;
+
+		/* the UL BA info follows the DL BA info, if present */
+		if (params->st_control &
+		    IEEE80211_ST_CONTROL_PREP_RESP_DL_BA_INFO_PRESENT) {
+			ba = (const void *)pos;
+			pos += sizeof(*ba) +
+			       hweight8(ba->tid_bitmap) * sizeof(ba->params[0]);
+		}
+	} else if (!(params->st_control &
+		     IEEE80211_ST_CONTROL_PREP_RESP_DL_BA_INFO_PRESENT)) {
+		return NULL;
+	}
+
+	ba = (const void *)pos;
+
+	if (!(ba->tid_bitmap & BIT(tid)))
+		return NULL;
+
+	/* entries are ordered by TID, one per bit set below @tid */
+	return &ba->params[hweight8(ba->tid_bitmap & (BIT(tid) - 1))];
+}
+
+enum ieee80211_st_control_exec_req {
+	IEEE80211_ST_CONTROL_EXEC_REQ_DL_TID_BITMAP_PRESENT	= 0x01,
+};
+
+/**
+ * struct ieee80211_smd_bss_trans_params_exec_req - SMD BSS Transition Parameters
+ *	element in execution request
+ * @st_control: ST control field, see &enum ieee80211_st_control_exec_req
+ * @variable: variable (currently DL TID bitmap)
+ */
+struct ieee80211_smd_bss_trans_params_exec_req {
+	u8 st_control;
+	u8 variable[];
+} __packed;
+
+enum ieee80211_st_control_exec_resp {
+	IEEE80211_ST_CONTROL_EXEC_RESP_NOM_MAX_DL_DRAIN_PRESENT	= 0x01,
+	IEEE80211_ST_CONTROL_EXEC_RESP_UL_SN_LIST_PRESENT	= 0x02,
+};
+
+struct ieee80211_smd_bss_trans_ul_sn_list {
+	u8 tid_bitmap;
+	/*
+	 * a list of 12-bit SNs for each TID in the bitmap,
+	 * then rounded up to be a full number of octets
+	 */
+	u8 variable[];
+} __packed;
+
+static inline bool
+ieee80211_smd_bss_trans_ul_sn_list_ok(const u8 **pos, size_t *remaining)
+{
+	const struct ieee80211_smd_bss_trans_ul_sn_list *sn =
+		(const void *)*pos;
+	size_t size;
+
+	if (*remaining < sizeof(*sn))
+		return false;
+
+	/* one 12-bit SN per TID set in the bitmap, padded to whole octets */
+	size = sizeof(*sn) + DIV_ROUND_UP(hweight8(sn->tid_bitmap) * 12, 8);
+	if (*remaining < size)
+		return false;
+
+	*pos += size;
+	*remaining -= size;
+	return true;
+}
+
+/**
+ * struct ieee80211_smd_bss_trans_params_exec_resp - SMD BSS Transition Parameters
+ *	element in execution response
+ * @st_control: ST control field, see &enum ieee80211_st_control_exec_resp
+ * @variable: variable (nominal maximum DL draining period duration,
+ *	Latest UL SN List)
+ */
+struct ieee80211_smd_bss_trans_params_exec_resp {
+	u8 st_control;
+	u8 variable[];
+} __packed;
+
+static inline bool
+ieee80211_smd_exec_resp_size_ok(const u8 *data, u8 len)
+{
+	const struct ieee80211_smd_bss_trans_params_exec_resp *params =
+		(const void *)data;
+	const u8 *pos = params->variable;
+	size_t remaining;
+
+	if (len < sizeof(*params))
+		return false;
+	remaining = len - sizeof(*params);
+
+	/* nominal maximum DL draining period duration */
+	if (params->st_control &
+	    IEEE80211_ST_CONTROL_EXEC_RESP_NOM_MAX_DL_DRAIN_PRESENT) {
+		if (remaining < sizeof(__le16))
+			return false;
+		pos += sizeof(__le16);
+		remaining -= sizeof(__le16);
+	}
+
+	/* Latest UL SN List */
+	if ((params->st_control &
+	     IEEE80211_ST_CONTROL_EXEC_RESP_UL_SN_LIST_PRESENT) &&
+	    !ieee80211_smd_bss_trans_ul_sn_list_ok(&pos, &remaining))
+		return false;
+
+	return true;
+}
+
+/**
+ * ieee80211_smd_exec_resp_ul_sn - get a per-TID uplink SN from an execution
+ *	response element
+ * @data: the SMD BSS Transition Parameters (execution response) element data,
+ *	which must already have passed ieee80211_smd_exec_resp_size_ok()
+ * @tid: the TID to look up
+ *
+ * Return: the 12-bit uplink sequence number for @tid, or -1 if the UL SN list
+ *	is not present or @tid is not set in its TID bitmap.
+ */
+static inline int
+ieee80211_smd_exec_resp_ul_sn(const u8 *data, u8 tid)
+{
+	const struct ieee80211_smd_bss_trans_params_exec_resp *params =
+		(const void *)data;
+	const struct ieee80211_smd_bss_trans_ul_sn_list *sn;
+	const u8 *pos = params->variable;
+	unsigned int offset, bit_offset;
+
+	if (!(params->st_control &
+	      IEEE80211_ST_CONTROL_EXEC_RESP_UL_SN_LIST_PRESENT))
+		return -1;
+
+	/* the UL SN list follows the nominal maximum DL draining duration */
+	if (params->st_control &
+	    IEEE80211_ST_CONTROL_EXEC_RESP_NOM_MAX_DL_DRAIN_PRESENT)
+		pos += sizeof(__le16);
+
+	sn = (const void *)pos;
+
+	if (!(sn->tid_bitmap & BIT(tid)))
+		return -1;
+
+	/* 12-bit SNs, ordered by TID, packed least-significant-bit first */
+	offset = hweight8(sn->tid_bitmap & (BIT(tid) - 1));
+	bit_offset = offset * 12;
+
+	return (get_unaligned_le16(&sn->variable[bit_offset / 8]) >>
+		(bit_offset % 8)) & 0xfff;
+}
+
+enum ieee80211_dl_data_drain_info_flags {
+	IEEE80211_DL_DATA_DRAIN_INFO_DRAIN_COMPLETED		= 0x01,
+	IEEE80211_DL_DATA_DRAIN_INFO_PER_TID_DL_BITMAP_PRESENT	= 0x02,
+};
+
+/**
+ * struct ieee80211_dl_data_drain_info - DL Data Drain Info field
+ * @flags: the info field with flags from &enum ieee80211_dl_data_drain_info_flags
+ * @variable: variable (Per-TID DL bitmap)
+ */
+struct ieee80211_dl_data_drain_info {
+	u8 flags;
+	u8 variable[];
+} __packed;
+
 #endif /* LINUX_IEEE80211_UHR_H */
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b2c90c4b262d..90964d5075fd 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1815,6 +1815,7 @@ enum ieee80211_eid_ext {
 	WLAN_EID_EXT_OPS = 46,
 	WLAN_EID_EXT_HE_BSS_LOAD = 47,
 	WLAN_EID_EXT_MAX_CHANNEL_SWITCH_TIME = 52,
+	WLAN_EID_EXT_OCI = 54,
 	WLAN_EID_EXT_MULTIPLE_BSSID_CONFIGURATION = 55,
 	WLAN_EID_EXT_NON_INHERITANCE = 56,
 	WLAN_EID_EXT_KNOWN_BSSID = 57,
-- 
2.56.0

