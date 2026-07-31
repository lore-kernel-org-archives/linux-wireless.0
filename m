Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7C642847B
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 12:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785499448; cv=none; b=FnPEd+ZKJe48jMUI2AUy4fu7l2CEHE6Cq+VAuhzzyeCQ57W/v0EjgZZbMQlbtx91D3w/dYH+F5hd2POMZ1eAck5PwYY9dkl8bSa79UhdVGiJPQNCID+rqM5Gv0Z68BSaxY4tcypFpSVowoQKGD9V0SK/TQB4ykce9jiFyD3gNtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785499448; c=relaxed/simple;
	bh=9808LyISWz4cXhntTTUdekfz8KNoAvmPsxeVkj5KXyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uOXziursHVMPRGY1ytC2GqjEXDEQNKe1jZL5Cg0AQKPZlFpvhy+znU8cLvsrCssJDMMw0YEAblmRVkdVvGbmw3uyOKs/PRAsnUnomWqFKvUqlocBPqTDCfgpQtcwf8BSGrzAtPftOz2pXXxXvdbDhS2WV0NHUgjn/1T4SXb6uKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=YfWGwcYh; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="YfWGwcYh"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=FZoYqbg52bbXoBotsAEIPzss0/1XnFTFiDJY5s5N0fw=;
	t=1785499446; x=1786709046; b=YfWGwcYhGIogMmNn2PaLAhdClEgwIpSUvu4H7bGtMn7Fm55
	4HYvzqa9RL97Xo+xHv1ysR7yEWZWh//2Ym8sLI43VyWTYCG9VteC8KMkn0hBshl2NftYp9M7zqL44
	64cDUY7+q7BJGZhwMqvVcg6iJR98kUOOdNFcBVoOTIBhR+PE/oB64MUjpsFHG4ruDeldePG9OFTG4
	+5z7Ta+9HCn9ZNLKdQ4LZZzbZa9y7TnMCY8cBNnQcKeWuaQpJwpG/k9Xr7xI2AQb2piXo8Tl8X0hh
	ytw3U4GIzv9EjO2YrmqlHGBgfuLLFyRCnj6ygMKMMZCXlZIVtk5p6BntoxfSsCmw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wply5-00000001n1K-1NGj;
	Fri, 31 Jul 2026 14:04:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/2] wifi: update UHR to Draft_P802.11bn D1.5
Date: Fri, 31 Jul 2026 14:02:33 +0200
Message-ID: <20260731140351.0798bb37908d.I13592341f7f53f7566f9eeb74f0a0b85e73c1fef@changeid>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260731120351.213903-4-johannes@sipsolutions.net>
References: <20260731120351.213903-4-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-malware-bazaar: not-scanned

From: Johannes Berg <johannes.berg@intel.com>

Update various definitions and in particular NPCA
parsing to D1.5.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-eht.h | 18 ++++++-
 include/linux/ieee80211-uhr.h | 95 +++++++++++++++++++----------------
 net/wireless/chan.c           | 11 ++--
 3 files changed, 75 insertions(+), 49 deletions(-)

diff --git a/include/linux/ieee80211-eht.h b/include/linux/ieee80211-eht.h
index b62297a978e7..a699d108eee6 100644
--- a/include/linux/ieee80211-eht.h
+++ b/include/linux/ieee80211-eht.h
@@ -482,6 +482,7 @@ struct ieee80211_multi_link_elem {
 #define IEEE80211_MLC_BASIC_PRES_MLD_ID			0x0200
 #define IEEE80211_MLC_BASIC_PRES_EXT_MLD_CAPA_OP	0x0400
 #define IEEE80211_MLC_BASIC_PRES_ENH_CRIT_UPD		0x0800
+#define IEEE80211_MLC_BASIC_PRES_AGE_OF_BSS_LOAD	0x1000
 
 #define IEEE80211_MED_SYNC_DELAY_DURATION		0x00ff
 #define IEEE80211_MED_SYNC_DELAY_SYNC_OFDM_ED_THRESH	0x0f00
@@ -550,6 +551,8 @@ struct ieee80211_mle_basic_common_info {
 } __packed;
 
 #define IEEE80211_MLC_PREQ_PRES_MLD_ID			0x0010
+#define IEEE80211_MLC_PREQ_PRES_MLD_MAC_ADDR		0x0020
+#define IEEE80211_MLC_PREQ_PRES_NEIGH_AP_MLD_MAC_ADDR	0x0040
 
 struct ieee80211_mle_preq_common_info {
 	u8 len;
@@ -560,6 +563,7 @@ struct ieee80211_mle_preq_common_info {
 #define IEEE80211_MLC_RECONF_PRES_EML_CAPA		0x0020
 #define IEEE80211_MLC_RECONF_PRES_MLD_CAPA_OP		0x0040
 #define IEEE80211_MLC_RECONF_PRES_EXT_MLD_CAPA_OP	0x0080
+#define IEEE80211_MLC_RECONF_PRES_TARGET_AP_MLD_ADDR	0x0100
 
 /* no fixed fields in RECONF */
 
@@ -766,7 +770,7 @@ static inline u16 ieee80211_mle_get_mld_capa_op(const u8 *data)
 #define IEEE80211_EHT_ML_EXT_MLD_CAPA_NSTR_UPDATE		0x0020
 #define IEEE80211_EHT_ML_EXT_MLD_CAPA_EMLSR_ENA_ON_ONE_LINK	0x0040
 #define IEEE80211_EHT_ML_EXT_MLD_CAPA_BTM_MLD_RECO_MULTI_AP	0x0080
-/* defined by UHR Draft P802.11bn_D1.3 Figure 9-1147 */
+/* defined by UHR Draft P802.11bn_D1.5 Figure 9-1168 */
 #define IEEE80211_UHR_ML_EXT_MLD_CAPA_ML_PM			0x0100
 
 /**
@@ -928,11 +932,17 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
 			common += 2;
 		if (control & IEEE80211_MLC_BASIC_PRES_ENH_CRIT_UPD)
 			common += 1;
+		if (control & IEEE80211_MLC_BASIC_PRES_AGE_OF_BSS_LOAD)
+			common += 1;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_PREQ:
 		common += sizeof(struct ieee80211_mle_preq_common_info);
 		if (control & IEEE80211_MLC_PREQ_PRES_MLD_ID)
 			common += 1;
+		if (control & IEEE80211_MLC_PREQ_PRES_MLD_MAC_ADDR)
+			common += ETH_ALEN;
+		if (control & IEEE80211_MLC_PREQ_PRES_NEIGH_AP_MLD_MAC_ADDR)
+			common += ETH_ALEN;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_RECONF:
 		common += 1;
@@ -944,6 +954,8 @@ static inline bool ieee80211_mle_size_ok(const u8 *data, size_t len)
 			common += 2;
 		if (control & IEEE80211_MLC_RECONF_PRES_EXT_MLD_CAPA_OP)
 			common += 2;
+		if (control & IEEE80211_MLC_RECONF_PRES_TARGET_AP_MLD_ADDR)
+			common += ETH_ALEN;
 		break;
 	case IEEE80211_ML_CONTROL_TYPE_TDLS:
 		common += sizeof(struct ieee80211_mle_tdls_common_info);
@@ -1003,6 +1015,7 @@ enum ieee80211_mle_subelems {
 #define IEEE80211_MLE_STA_CONTROL_BSS_PARAM_CHANGE_CNT_PRESENT	0x0800
 #define IEEE80211_MLE_STA_CONTROL_ENH_CRIT_UPD_PRESENT		0x1000
 #define IEEE80211_MLE_STA_CONTROL_AP_CONDUCTED_TX_PWR_PRESENT	0x2000
+#define IEEE80211_MLE_STA_CONTROL_AGE_OF_BSS_LOAD_PRESENT	0x4000
 
 struct ieee80211_mle_per_sta_profile {
 	__le16 control;
@@ -1054,6 +1067,9 @@ static inline bool ieee80211_mle_basic_sta_prof_size_ok(const u8 *data,
 	if (control & IEEE80211_MLE_STA_CONTROL_AP_CONDUCTED_TX_PWR_PRESENT)
 		info_len += 1;
 
+	if (control & IEEE80211_MLE_STA_CONTROL_AGE_OF_BSS_LOAD_PRESENT)
+		info_len += 1;
+
 	return prof->sta_info_len >= info_len &&
 	       fixed + prof->sta_info_len - 1 <= len;
 }
diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index 398ce01fcdee..19e9260d0db8 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -17,32 +17,32 @@
 #define IEEE80211_UHR_OPER_PARAMS_PEDCA_ENA		0x0004
 #define IEEE80211_UHR_OPER_PARAMS_DBE_ENA		0x0008
 #define IEEE80211_UHR_OPER_PARAMS_DBE_BW		0x0070
-#define IEEE80211_UHR_OPER_PARAMS_DUO_PRES		0x0080
-#define IEEE80211_UHR_OPER_PARAMS_DPS_PRES		0x0100
-#define IEEE80211_UHR_OPER_PARAMS_NPCA_PRES		0x0200
-#define IEEE80211_UHR_OPER_PARAMS_PEDCA_PRES		0x0400
-#define IEEE80211_UHR_OPER_PARAMS_DBE_PRES		0x0800
+#define IEEE80211_UHR_OPER_PARAMS_ELR_RX		0x0080
+#define IEEE80211_UHR_OPER_PARAMS_DUO_PRES		0x0100
+#define IEEE80211_UHR_OPER_PARAMS_DPS_PRES		0x0200
+#define IEEE80211_UHR_OPER_PARAMS_NPCA_PRES		0x0400
+#define IEEE80211_UHR_OPER_PARAMS_PEDCA_PRES		0x0800
+#define IEEE80211_UHR_OPER_PARAMS_DBE_PRES		0x1000
 
 struct ieee80211_uhr_operation {
 	__le16 params;
-	u8 basic_mcs_nss_set[4];
 	u8 variable[];
 } __packed;
 
-#define IEEE80211_UHR_NPCA_PARAMS_PRIMARY_CHAN_OFFS	0x0000000F
-#define IEEE80211_UHR_NPCA_PARAMS_MIN_DUR_THRESH	0x000000F0
-#define IEEE80211_UHR_NPCA_PARAMS_SWITCH_DELAY		0x00003F00
-#define IEEE80211_UHR_NPCA_PARAMS_SWITCH_BACK_DELAY	0x000FC000
-#define IEEE80211_UHR_NPCA_PARAMS_INIT_QSRC		0x00300000
-#define IEEE80211_UHR_NPCA_PARAMS_MOPLEN		0x00400000
-#define IEEE80211_UHR_NPCA_PARAMS_DIS_SUBCH_BMAP_PRES	0x00800000
+#define IEEE80211_UHR_NPCA_PARAMS_PRIMARY_CHAN		0x000000FF
+#define IEEE80211_UHR_NPCA_PARAMS_MIN_DUR_THRESH	0x00000F00
+#define IEEE80211_UHR_NPCA_PARAMS_SWITCH_DELAY		0x0003F000
+#define IEEE80211_UHR_NPCA_PARAMS_SWITCH_BACK_DELAY	0x00FC0000
+#define IEEE80211_UHR_NPCA_PARAMS_INIT_QSRC		0x03000000
+#define IEEE80211_UHR_NPCA_PARAMS_MOPLEN		0x04000000
+#define IEEE80211_UHR_NPCA_PARAMS_DIS_SUBCH_BMAP_PRES	0x08000000
 
 /**
  * struct ieee80211_uhr_npca_info - npca operation information
  *
  * This structure is the "NPCA Operation Parameters field format" of "UHR
- * Operation Element" fields as described in P802.11bn_D1.3
- * subclause 9.4.2.353. See Figure 9-aa4.
+ * Operation Element" fields as described in P802.11bn_D1.5
+ * subclause 9.4.2.355.2, see Figure 9-aa6.
  *
  * Refer to IEEE80211_UHR_NPCA*
  * @params:
@@ -97,7 +97,7 @@ struct ieee80211_uhr_npca_info {
  * struct ieee80211_uhr_dps_info - DPS operation information
  *
  * This structure is the "DPS Operation Parameter field" of "UHR
- * Operation Element" fields as described in P802.11bn_D1.3
+ * Operation Element" fields as described in P802.11bn_D1.5
  * subclause 9.4.1.87. See Figure 9-207u.
  *
  * Refer to IEEE80211_UHR_DPS*
@@ -211,8 +211,8 @@ static inline int ieee80211_uhr_dbe_bw_mhz(enum ieee80211_uhr_dbe_oper_bw bw)
  * struct ieee80211_uhr_dbe_info - DBE operation information
  *
  * This structure is the "DBE Operation Parameters field" of
- * "UHR Operation Element" fields as described in P802.11bn_D1.3
- * subclause 9.4.2.353. See Figure 9-aa6.
+ * "UHR Operation Element" fields as described in P802.11bn_D1.5
+ * subclause 9.4.2.355.4, see Figure 9-aa9.
  *
  * Refer to IEEE80211_UHR_DBE_OPER*
  * @params:
@@ -234,25 +234,23 @@ struct ieee80211_uhr_dbe_info {
 	__le16 dis_subch_bmap[];
 } __packed;
 
-#define IEEE80211_UHR_P_EDCA_ECWMIN		0x0F
-#define IEEE80211_UHR_P_EDCA_ECWMAX		0xF0
-#define IEEE80211_UHR_P_EDCA_AIFSN		0x000F
-#define IEEE80211_UHR_P_EDCA_CW_DS		0x0030
-#define IEEE80211_UHR_P_EDCA_PSRC_THRESHOLD	0x01C0
-#define IEEE80211_UHR_P_EDCA_QSRC_THRESHOLD	0x0600
+#define IEEE80211_UHR_P_EDCA_ECWMIN		0x0007
+#define IEEE80211_UHR_P_EDCA_ECWMAX		0x0038
+#define IEEE80211_UHR_P_EDCA_AIFSN		0x01C0
+#define IEEE80211_UHR_P_EDCA_CW_DS		0x0600
+#define IEEE80211_UHR_P_EDCA_PSRC_THRESHOLD	0x3800
+#define IEEE80211_UHR_P_EDCA_QSRC_THRESHOLD	0xC000
 
 /**
  * struct ieee80211_uhr_p_edca_info - P-EDCA operation information
  *
  * This structure is the "P-EDCA Operation Parameters field" of
- * "UHR Operation Element" fields as described in P802.11bn_D1.3
- * subclause 9.4.2.353. See Figure 9-aa5.
+ * "UHR Operation Element" fields as described in P802.11bn_D1.5
+ * subclause 9.4.2.355.3, see Figure 9-aa8.
  *
  * Refer to IEEE80211_UHR_P_EDCA*
- * @p_edca_ec: P-EDCA ECWmin and ECWmax.
- *	These fields indicate the CWmin and CWmax values used by a
- *	P-EDCA STA during P-EDCA contention.
- * @params: AIFSN, CW DS, PSRC threshold, and QSRC threshold.
+ * @params: ECWmin, ECWmax, AIFSN, CW DS, PSRC threshold, and QSRC threshold.
+ *	- CWmin/CWmax values used by a P-EDCA STA during P-EDCA contention.
  *	- The AIFSN field indicates the AIFSN value used by a P-EDCA STA
  *	  during P-EDCA contention.
  *	- The CW DS field indicates the value used for randomization of the
@@ -266,7 +264,6 @@ struct ieee80211_uhr_dbe_info {
  *	  value 0 is reserved.
  */
 struct ieee80211_uhr_p_edca_info {
-	u8 p_edca_ec;
 	__le16 params;
 } __packed;
 
@@ -302,7 +299,7 @@ static inline bool ieee80211_uhr_oper_size_ok(const u8 *data, u8 len)
 		}
 	}
 
-	/* P-EDCA Operation Parameters (fixed 3 bytes) */
+	/* P-EDCA Operation Parameters */
 	if (oper->params & cpu_to_le16(IEEE80211_UHR_OPER_PARAMS_PEDCA_PRES)) {
 		needed += sizeof(struct ieee80211_uhr_p_edca_info);
 		if (len < needed)
@@ -421,28 +418,42 @@ ieee80211_uhr_oper_dbe_info(const struct ieee80211_uhr_operation *oper)
 #define IEEE80211_UHR_MAC_CAP2_UHR_OM_PU_TO_LOW		0xC0
 
 #define IEEE80211_UHR_MAC_CAP3_UHR_OM_PU_TO_HIGH	0x03
-#define IEEE80211_UHR_MAC_CAP3_PARAM_UPD_ADV_NOTIF_INTV	0x1C
-#define IEEE80211_UHR_MAC_CAP3_UPD_IND_TIM_INTV_LOW	0xE0
+#define IEEE80211_UHR_MAC_CAP3_PARAM_UPD_ADV_NOTIF_INTV	0x7C
+#define IEEE80211_UHR_MAC_CAP3_UPD_IND_TIM_INTV_LOW	0x80
 
-#define IEEE80211_UHR_MAC_CAP4_UPD_IND_TIM_INTV_HIGH	0x03
-#define IEEE80211_UHR_MAC_CAP4_BOUNDED_ESS		0x04
-#define IEEE80211_UHR_MAC_CAP4_BTM_ASSURANCE		0x08
-#define IEEE80211_UHR_MAC_CAP4_CO_BF_SUPP		0x10
+#define IEEE80211_UHR_MAC_CAP4_UPD_IND_TIM_INTV_HIGH	0x0F
+#define IEEE80211_UHR_MAC_CAP4_BOUNDED_ESS		0x10
+#define IEEE80211_UHR_MAC_CAP4_BTM_ASSURANCE		0x20
+#define IEEE80211_UHR_MAC_CAP4_CO_BF_SUPP		0x40
+#define IEEE80211_UHR_MAC_CAP4_CO_SR_SUPP		0x80
+
+#define IEEE80211_UHR_MAC_CAP5_MAPC_ENH_MSRMT_SUPP	0x01
 
 #define IEEE80211_UHR_MAC_CAP_DBE_MAX_BW		0x07
 #define IEEE80211_UHR_MAC_CAP_DBE_EHT_MCS_MAP_160_PRES	0x08
 #define IEEE80211_UHR_MAC_CAP_DBE_EHT_MCS_MAP_320_PRES	0x10
 
+/* struct ieee80211_uhr_cap_dbe::bwcap[].cap */
+#define IEEE80211_UHR_MAC_CAP_DBE_CAP_NUM_SND_DIMS		0x07
+#define IEEE80211_UHR_MAC_CAP_DBE_CAP_NON_OFDMA_UL_MUMIMO	0x08
+#define IEEE80211_UHR_MAC_CAP_DBE_CAP_MU_BEAMFORMER		0x10
+#define IEEE80211_UHR_MAC_CAP_DBE_CAP_BEAMFORMEE_SS		0xe0
+
 struct ieee80211_uhr_cap_dbe {
 	u8 cap;
+	u8 max_switch_time_period;
+	u8 mode_change_intvl;
 	/* present 0, 1 or 2 times depending on _PRES bits */
-	struct ieee80211_eht_mcs_nss_supp_bw eht_mcs_map[];
+	struct {
+		struct ieee80211_eht_mcs_nss_supp_bw eht_mcs_map;
+		u8 cap;
+	} __packed bwcap[];
 } __packed;
 
 /**
  * enum ieee80211_uhr_dbe_max_supported_bw - DBE Maximum Supported Bandwidth
  *
- * As per spec P802.11bn_D1.3 "Table 9-bb5—Encoding of the DBE Maximum
+ * As per spec P802.11bn_D1.5 Table 9-bb8 "Encoding of the DBE Maximum
  * Supported Bandwidth field".
  *
  * @IEEE80211_UHR_DBE_MAX_BW_40: Indicates 40 MHz DBE max supported bw
@@ -526,10 +537,10 @@ static inline bool ieee80211_uhr_capa_size_ok(const u8 *data, u8 len,
 		dbe = (const void *)cap->variable;
 
 		if (dbe->cap & IEEE80211_UHR_MAC_CAP_DBE_EHT_MCS_MAP_160_PRES)
-			needed += sizeof(dbe->eht_mcs_map[0]);
+			needed += sizeof(dbe->bwcap[0]);
 
 		if (dbe->cap & IEEE80211_UHR_MAC_CAP_DBE_EHT_MCS_MAP_320_PRES)
-			needed += sizeof(dbe->eht_mcs_map[0]);
+			needed += sizeof(dbe->bwcap[0]);
 	}
 
 	return len >= needed;
diff --git a/net/wireless/chan.c b/net/wireless/chan.c
index 7f6af1790736..1071e823108b 100644
--- a/net/wireless/chan.c
+++ b/net/wireless/chan.c
@@ -568,8 +568,8 @@ int cfg80211_chandef_add_npca(struct wiphy *wiphy,
 			      const struct ieee80211_uhr_npca_info *npca)
 {
 	struct cfg80211_chan_def new_chandef = *chandef;
-	u32 width, npca_freq;
-	u8 offs;
+	u32 npca_freq;
+	u8 chan;
 
 	if (chandef->npca_chan || chandef->npca_punctured)
 		return -EINVAL;
@@ -589,11 +589,10 @@ int cfg80211_chandef_add_npca(struct wiphy *wiphy,
 		return -EINVAL;
 	}
 
-	offs = le32_get_bits(npca->params,
-			     IEEE80211_UHR_NPCA_PARAMS_PRIMARY_CHAN_OFFS);
+	chan = le32_get_bits(npca->params,
+			     IEEE80211_UHR_NPCA_PARAMS_PRIMARY_CHAN);
 
-	width = cfg80211_chandef_get_width(chandef);
-	npca_freq = chandef->center_freq1 - width / 2 + 10 + 20 * offs;
+	npca_freq = ieee80211_channel_to_frequency(chan, chandef->chan->band);
 	new_chandef.npca_chan = ieee80211_get_channel(wiphy, npca_freq);
 	if (!new_chandef.npca_chan)
 		return -EINVAL;
-- 
2.55.0

