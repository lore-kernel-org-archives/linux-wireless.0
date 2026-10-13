Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62039509EE9
	for <linux-wireless@vger.kernel.org>; Tue, 13 Oct 2026 13:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791898615; cv=none; b=T4uo7EUlv1VceW5pueYdMMAPHRH5x6bIWrGupvn1JwBzvC0sfKyzXt8ayKwyf/CG+pVIacDrujewsIIbqC2FDA6zoHJWURb+oZssNaRVS0hpySRaf7vbDva6ICcT7U76GGFWqEPjdkvLDXL3X3TBbkCw5GRp6If6EnB9l0suris=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791898615; c=relaxed/simple;
	bh=KFDgnJfu7h972WU+4VJFzCKmFPhr1pgE3IN/bx9PloM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VVoMutRDkdPgHpK4nheiSUVTGuZHuSfsNUvJQTTx/JinJr0fLJ+X8xywccS1yPbcGUERLqdex3ZGxp7PwECSyzEFgZbUikxQZK8p3ru/2vSD/M9Gz3MwGvcRNn0OAnpKwds6NXJPszOL5GC00gRnuPJMXoYJkHhCMmSijkwPX3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=q545FSst; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="q545FSst"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=gtt7cI/lMqqh+CJG0kllsQRF8xKJ4NcOSOZ+s55Py4s=;
	t=1791898613; x=1793108213; b=q545FSstNOw42OeI0FJqdjFLFqie+GYUbBDyLWZBz6UaySh
	XAIJudMoQmC1fWFsdlbjHiFo5uEqQyt/NsU6itK1T/HYgPCJw8T0rqzBa5zl1LbFs6GYFvpp3v6fO
	zGdiH59TYs+nqw3Py2xx3BnNxG8dCo2qR5bC6tWfwEp6ShMTEEq8WFb63rZ6cywcOY6E49/KoQjtc
	QOTERVTDFFZCPVoGZxM00l5CBP50zGeytdfAh/Rku/WJV2npr0rTRk9agVIV3PGozNkxaKdWnL/ay
	l/C/qOL6MYfYrn3Ok2H/EQvYm29AeOoAJbWwoSoj42RBVWEA6ZIqQRSDluCSe1nw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGcgO-0000000HRBK-0PqH;
	Tue, 13 Oct 2026 15:36:44 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 01/10] wifi: mac80211: parse and validate UHR parameters update
Date: Tue, 13 Oct 2026 15:25:13 +0200
Message-ID: <20261013153640.7216b9c6edd1.Ied9308726862ef36c71473d8871345f9adc6204d@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013133640.270974-12-johannes@sipsolutions.net>
References: <20261013133640.270974-12-johannes@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

Find the UHR parameters update element, defragment it and
validate that all the tuples are valid. This implements
the parsing per D2.0.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/linux/ieee80211-uhr.h | 178 +++++++++++++++++++++++++++++++---
 net/mac80211/ieee80211_i.h    |  14 ++-
 net/mac80211/parse.c          |  20 ++++
 3 files changed, 191 insertions(+), 21 deletions(-)

diff --git a/include/linux/ieee80211-uhr.h b/include/linux/ieee80211-uhr.h
index 19e9260d0db8..aef487b984e5 100644
--- a/include/linux/ieee80211-uhr.h
+++ b/include/linux/ieee80211-uhr.h
@@ -84,6 +84,15 @@ struct ieee80211_uhr_npca_info {
 	__le16 dis_subch_bmap[];
 } __packed;
 
+static inline int
+ieee80211_uhr_npca_info_size(const struct ieee80211_uhr_npca_info *npca)
+{
+	if (npca->params & cpu_to_le32(IEEE80211_UHR_NPCA_PARAMS_DIS_SUBCH_BMAP_PRES))
+		return sizeof(*npca) + sizeof(npca->dis_subch_bmap[0]);
+
+	return sizeof(*npca);
+}
+
 #define IEEE80211_UHR_DPS_PADDING_DELAY			0x0000003F
 #define IEEE80211_UHR_DPS_TRANSITION_DELAY		0x00003F00
 #define IEEE80211_UHR_DPS_ICF_REQUIRED			0x00010000
@@ -161,6 +170,18 @@ struct ieee80211_uhr_dps_info {
 	__le32 params;
 } __packed;
 
+enum ieee80211_uhr_duo_params {
+	IEEE80211_UHR_DUO_PARAMS_MAX_STANDALONE_DUO_BSPR	= 0x1f,
+};
+
+/**
+ * struct ieee80211_uhr_duo_info - DUO information
+ * @params: the parameters, see &enum ieee80211_uhr_duo_params
+ */
+struct ieee80211_uhr_duo_info {
+	u8 params;
+} __packed;
+
 #define IEEE80211_UHR_DBE_OPER_BANDWIDTH			0x07
 #define IEEE80211_UHR_DBE_OPER_DIS_SUBCHANNEL_BITMAP_PRES	0x08
 
@@ -234,6 +255,15 @@ struct ieee80211_uhr_dbe_info {
 	__le16 dis_subch_bmap[];
 } __packed;
 
+static inline int
+ieee80211_uhr_dbe_info_size(const struct ieee80211_uhr_dbe_info *dbe)
+{
+	if (dbe->params & IEEE80211_UHR_DBE_OPER_DIS_SUBCHANNEL_BITMAP_PRES)
+		return sizeof(*dbe) + sizeof(dbe->dis_subch_bmap[0]);
+
+	return sizeof(*dbe);
+}
+
 #define IEEE80211_UHR_P_EDCA_ECWMIN		0x0007
 #define IEEE80211_UHR_P_EDCA_ECWMAX		0x0038
 #define IEEE80211_UHR_P_EDCA_AIFSN		0x01C0
@@ -287,16 +317,12 @@ static inline bool ieee80211_uhr_oper_size_ok(const u8 *data, u8 len)
 		const struct ieee80211_uhr_npca_info *npca =
 			(const void *)(data + needed);
 
-		needed += sizeof(*npca);
-		if (len < needed)
+		if (len < needed + sizeof(*npca))
 			return false;
 
-		if (npca->params &
-		    cpu_to_le32(IEEE80211_UHR_NPCA_PARAMS_DIS_SUBCH_BMAP_PRES)) {
-			needed += sizeof(npca->dis_subch_bmap[0]);
-			if (len < needed)
-				return false;
-		}
+		needed += ieee80211_uhr_npca_info_size(npca);
+		if (len < needed)
+			return false;
 	}
 
 	/* P-EDCA Operation Parameters */
@@ -311,16 +337,12 @@ static inline bool ieee80211_uhr_oper_size_ok(const u8 *data, u8 len)
 		const struct ieee80211_uhr_dbe_info *dbe =
 			(const void *)(data + needed);
 
-		needed += sizeof(*dbe);
-		if (len < needed)
+		if (len < needed + sizeof(*dbe))
 			return false;
 
-		if (dbe->params &
-		    IEEE80211_UHR_DBE_OPER_DIS_SUBCHANNEL_BITMAP_PRES) {
-			needed += sizeof(dbe->dis_subch_bmap[0]);
-			if (len < needed)
-				return false;
-		}
+		needed += ieee80211_uhr_dbe_info_size(dbe);
+		if (len < needed)
+			return false;
 	}
 
 	return len >= needed;
@@ -661,4 +683,128 @@ ieee80211_uhr_mode_change_tuple_size(const struct ieee80211_uhr_mode_change_tupl
 	     tuple = (const void *)((const u8 *)tuple +			\
 				    ieee80211_uhr_mode_change_tuple_size(tuple)))
 
+struct ieee80211_uhr_parameters_update {
+	u8 countdown;
+	u8 tuples[];
+} __packed;
+
+enum ieee80211_uhr_param_update_tuple_control {
+	IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ID		= 0x3f,
+	IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ENABLE	= 0x40,
+	IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_UPDATE	= 0x80,
+};
+
+enum ieee80211_uhr_param_update_mode_id {
+	IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DPS			= 0,
+	IEEE80211_UHR_PARAM_UPDATE_MODE_ID_NPCA			= 1,
+	IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DUO			= 2,
+	IEEE80211_UHR_PARAM_UPDATE_MODE_ID_P_EDCA		= 3,
+	IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DBE			= 4,
+	IEEE80211_UHR_PARAM_UPDATE_MODE_ID_AP_PUO		= 5,
+	IEEE80211_UHR_PARAM_UPDATE_MODE_ID_ELR_RX		= 6,
+};
+
+struct ieee80211_uhr_param_update_tuple {
+	u8 control;
+	/* mode length followed by mode specific */
+	u8 variable[];
+} __packed;
+
+static inline int
+ieee80211_uhr_param_update_tuple_size(const struct ieee80211_uhr_param_update_tuple *tuple)
+{
+	if (!(tuple->control & IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ENABLE))
+		return sizeof(*tuple);
+
+	/* fixed size (control) + length field + value of length field */
+	return sizeof(*tuple) + 1 + tuple->variable[0];
+}
+
+/* this also serves as a type-check for the macro */
+static inline size_t
+ieee80211_uhr_param_upd_tuples_rem(const struct ieee80211_uhr_parameters_update *upd,
+				   size_t len,
+				   const struct ieee80211_uhr_param_update_tuple *tuple)
+{
+	return len - ((const u8 *)tuple - (const u8 *)upd);
+}
+
+#define for_each_uhr_param_update_tuple(elem, len, tuple)		\
+	for (tuple = (const void *)((elem) ? (elem)->tuples : NULL);	\
+	     (elem) &&							\
+	     ieee80211_uhr_param_upd_tuples_rem(elem, len, tuple) >=	\
+		sizeof(*tuple) &&					\
+	     ieee80211_uhr_param_upd_tuples_rem(elem, len, tuple) >=	\
+		sizeof(*tuple) +					\
+		!!(tuple->control &					\
+		   IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ENABLE) &&	\
+	     ieee80211_uhr_param_upd_tuples_rem(elem, len, tuple) >=	\
+		ieee80211_uhr_param_update_tuple_size(tuple);		\
+	     tuple = (const void *)((const u8 *)tuple +			\
+				    ieee80211_uhr_param_update_tuple_size(tuple)))
+
+static inline bool
+ieee80211_uhr_param_update_ok(const void *elem, size_t len)
+{
+	const struct ieee80211_uhr_parameters_update *upd = elem;
+	const struct ieee80211_uhr_param_update_tuple *tuple;
+
+	/* the loop checks, but also check here for our after-the-loop check */
+	if (len < sizeof(*upd) + sizeof(*tuple))
+		return false;
+
+	for_each_uhr_param_update_tuple(upd, len, tuple) {
+		u8 params_len;
+
+		/* no further checks for disabled modes */
+		if (!(tuple->control & IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ENABLE))
+			continue;
+
+		params_len = tuple->variable[0];
+
+		switch (u8_get_bits(tuple->control,
+				    IEEE80211_UHR_PARAM_UPDATE_MODE_CTRL_MODE_ID)) {
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DPS:
+			if (params_len < sizeof(struct ieee80211_uhr_dps_info))
+				return false;
+			break;
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_NPCA:
+			if (params_len < sizeof(struct ieee80211_uhr_npca_info))
+				return false;
+			if (params_len <
+			    ieee80211_uhr_npca_info_size((const void *)(tuple->variable + 1)))
+				return false;
+			break;
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DUO:
+			/*
+			 * This one is defined very strangely in the spec,
+			 * having a reserved (!) enable bit and always
+			 * including the parameters. Let's hope it'll get
+			 * unified with the others and implement that.
+			 */
+			if (params_len < sizeof(struct ieee80211_uhr_duo_info))
+				return false;
+			break;
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_P_EDCA:
+			if (params_len < sizeof(struct ieee80211_uhr_p_edca_info))
+				return false;
+			break;
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_DBE:
+			if (params_len < sizeof(struct ieee80211_uhr_dbe_info))
+				return false;
+			if (params_len <
+			    ieee80211_uhr_dbe_info_size((const void *)(tuple->variable + 1)))
+				return false;
+			break;
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_AP_PUO:
+		case IEEE80211_UHR_PARAM_UPDATE_MODE_ID_ELR_RX:
+			/* no further length checks */
+			break;
+		}
+	}
+
+	/* valid only if the whole data was consumed by tuples */
+	return (const u8 *)tuple == (const u8 *)elem + len;
+}
+
 #endif /* LINUX_IEEE80211_UHR_H */
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 1a6cbbb5a17d..e321a50e5a6c 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1823,11 +1823,12 @@ struct ieee80211_csa_ie {
 };
 
 enum ieee80211_elems_parse_error {
-	IEEE80211_PARSE_ERR_INVALID_END		= BIT(0),
-	IEEE80211_PARSE_ERR_DUP_ELEM		= BIT(1),
-	IEEE80211_PARSE_ERR_BAD_ELEM_SIZE	= BIT(2),
-	IEEE80211_PARSE_ERR_UNEXPECTED_ELEM	= BIT(3),
-	IEEE80211_PARSE_ERR_DUP_NEST_ML_BASIC	= BIT(4),
+	IEEE80211_PARSE_ERR_INVALID_END			= BIT(0),
+	IEEE80211_PARSE_ERR_DUP_ELEM			= BIT(1),
+	IEEE80211_PARSE_ERR_BAD_ELEM_SIZE		= BIT(2),
+	IEEE80211_PARSE_ERR_UNEXPECTED_ELEM		= BIT(3),
+	IEEE80211_PARSE_ERR_DUP_NEST_ML_BASIC		= BIT(4),
+	IEEE80211_PARSE_ERR_INVALID_UHR_PARAM_UPD	= BIT(5),
 };
 
 /* Parsed Information Elements */
@@ -1902,6 +1903,7 @@ struct ieee802_11_elems {
 	const struct ieee80211_uhr_cap *uhr_cap;
 	const struct ieee80211_uhr_operation *uhr_operation;
 	const struct ieee80211_cip_cap *cip_cap;
+	const struct ieee80211_uhr_parameters_update *uhr_param_upd;
 
 	/* not the order in the psd values is per element, not per chandef */
 	struct ieee80211_parsed_tpe tpe;
@@ -1933,6 +1935,8 @@ struct ieee802_11_elems {
 	size_t ml_basic_len;
 	size_t ml_reconf_len;
 	size_t ml_epcs_len;
+	/* same for UHR parameters update */
+	size_t uhr_param_upd_len;
 
 	u8 ttlm_num;
 
diff --git a/net/mac80211/parse.c b/net/mac80211/parse.c
index f3c5a9f6ec7c..22bba5adef26 100644
--- a/net/mac80211/parse.c
+++ b/net/mac80211/parse.c
@@ -55,6 +55,7 @@ struct ieee80211_elems_parse {
 	struct ieee802_11_elems elems;
 
 	struct ieee80211_elem_defrag ml_reconf, ml_epcs, ml_basic;
+	struct ieee80211_elem_defrag uhr_param_upd;
 
 	bool inside_multilink;
 	bool skip_vendor;
@@ -227,6 +228,14 @@ ieee80211_parse_extension_element(u32 *crc,
 			elems->uhr_cap_len = len;
 		}
 		break;
+	case WLAN_EID_EXT_UHR_PARAM_UPD:
+		if (params->mode < IEEE80211_CONN_MODE_UHR)
+			break;
+		calc_crc = true;
+		elems_parse->uhr_param_upd.elem = elem;
+		elems_parse->uhr_param_upd.start = params->start;
+		elems_parse->uhr_param_upd.len = params->len;
+		break;
 	}
 
 	if (crc && calc_crc)
@@ -1167,6 +1176,17 @@ ieee802_11_parse_elems_full(struct ieee80211_elems_parse_params *params)
 						       &elems_parse->ml_basic,
 						       &elems->ml_basic_len);
 
+	elems->uhr_param_upd = ieee80211_mle_defrag(elems_parse,
+						    &elems_parse->uhr_param_upd,
+						    &elems->uhr_param_upd_len);
+	if (elems_parse->uhr_param_upd.elem &&
+	    !ieee80211_uhr_param_update_ok(elems->uhr_param_upd,
+					   elems->uhr_param_upd_len)) {
+		elems->uhr_param_upd = NULL;
+		elems->uhr_param_upd_len = 0;
+		elems->parse_error |= IEEE80211_PARSE_ERR_INVALID_UHR_PARAM_UPD;
+	}
+
 	if (elems->tim && !elems->parse_error) {
 		const struct ieee80211_tim_ie *tim_ie = elems->tim;
 
-- 
2.56.0

