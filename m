Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E9536B923
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338778; cv=none; b=FiQ4pWGbsZ/roX109uYnOJz2Bt2CeQdU2fSDPtwLRGvtvvCx5sk91uL7993/MTXXdWyjuids6mapkfksKJPWNLdt0t8gfQyk45Ix2HEuNAPvxGW8ITHHMbGP/+S8QsOVV7MArbwIxfFbdGwwRjMzzxGKg6fuuwrqsJ+wHlU3/mo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338778; c=relaxed/simple;
	bh=EDLRrjZcDnGn7w0R3aXmFL9VMSLP/FpPTW7RJvW76TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnCjOwrjnwGxL0uUwqP/lweawXUeWSLlhq3556gVdfiUse70rr5Cd+6rIRotyNqL9IA/ojZE5xpp7ft93AthoSpK6B/KIzhBlpp/WVY0Xs2ELPR0m4Ixu+eNAkpPB+yuLATXYMeWN5Esi9gWy07HxgCE4IYcU/KRACNvQsMTg3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=M03hOAQ0; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="M03hOAQ0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I1zfleYHdw9gTgQa/Kl/dqNAZMmwj7hTQF4cOXpF+Xw=; b=M03hOAQ0ax//dHwDgA3sno9enr
	pJgLkveZICXKy50/2rrYlvpTSJXZAw2rhG1KJiTCk6pORsaDIO5lsDPDx3GKtx/ntxQlC76deKcFB
	MhuK5JupIpX1lZG4adHLhEZbxRoy1iMuwgZmFcgLRQkf0I95xqDoUGJAP6lMiVVIQqZQ=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbm-00Cwkn-12;
	Wed, 02 Sep 2026 10:46:14 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 04/15] wifi: cfg80211: add SCS and MSCS request validation
Date: Wed,  2 Sep 2026 10:45:59 +0200
Message-ID: <2f4d60f5e8c2e7feabbe98e4b24db7f9dad3275a.1788338716.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
References: <cover.3af9ba310d9145a9dfd653b5a886feaba98e8884.1788338716.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Check what the element parsers leave: the rules of 9.4.2.120 and 9.4.2.242
relating the request type, the classifier and the traffic description to
each other.

A failed check is a status code and not an error. The request came from a
peer over the air and hostapd passes it on as it arrived, so an AP answers
a legal request with a legal refusal.

The one rule the standard leaves open is a TCLAS Processing 0 descriptor
whose elements name one parameter with two values. No MSDU can satisfy
it, so decline it rather than install a rule that never fires.

An uplink or direct link descriptor carries no classifier, so add the QoS
Characteristics element accessors that read the direction, and the size
check that has to pass before anything else reads one.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/ieee80211-eht.h | 128 +++++++++++++++++++++++++++++++++++-
 include/linux/ieee80211.h     |   1 +-
 include/net/cfg80211.h        |  17 +++++-
 net/wireless/core.h           |   2 +-
 net/wireless/scs.c            | 110 ++++++++++++++++++++++++++++++-
 5 files changed, 258 insertions(+)

diff --git a/include/linux/ieee80211-eht.h b/include/linux/ieee80211-eht.h
index b62297a978e7..73c1b441c7f3 100644
--- a/include/linux/ieee80211-eht.h
+++ b/include/linux/ieee80211-eht.h
@@ -1369,4 +1369,132 @@ static inline u32 ieee80211_eml_trans_timeout_in_us(u16 eml_cap)
 				 _data + ieee80211_mle_common_size(_data),\
 				 _len - ieee80211_mle_common_size(_data))
 
+/**
+ * struct ieee80211_qos_char_elem - QoS Characteristics element
+ * @element_id: %WLAN_EID_EXTENSION
+ * @length: length of everything behind it
+ * @element_id_ext: %WLAN_EID_EXT_QOS_CHARACTERISTICS
+ * @control: control info, see %IEEE80211_QOS_CHAR_CTRL_*
+ * @min_service_interval: minimum service period interval, in microseconds
+ * @max_service_interval: maximum service period interval, in microseconds
+ * @min_data_rate: minimum data rate at the MAC SAP, in kilobits per second
+ * @delay_bound: targeted transport time of an MSDU, in microseconds
+ * @variable: the optional parameters that the presence bitmap names, in the
+ *	order of the %IEEE80211_QOS_CHAR_PRES_* bits
+ *
+ * This is the whole element, header included, because the only consumer of it
+ * is a device that takes it as it arrived.
+ */
+struct ieee80211_qos_char_elem {
+	u8 element_id;
+	u8 length;
+	u8 element_id_ext;
+	__le32 control;
+	__le32 min_service_interval;
+	__le32 max_service_interval;
+	u8 min_data_rate[3];
+	u8 delay_bound[3];
+	u8 variable[];
+} __packed;
+
+#define IEEE80211_QOS_CHAR_CTRL_DIRECTION		GENMASK(1, 0)
+#define IEEE80211_QOS_CHAR_CTRL_PRESENCE		GENMASK(24, 9)
+
+#define IEEE80211_QOS_CHAR_DIR_UPLINK			0
+#define IEEE80211_QOS_CHAR_DIR_DOWNLINK			1
+#define IEEE80211_QOS_CHAR_DIR_DIRECT			2
+
+#define IEEE80211_QOS_CHAR_PRES_MAX_MSDU_SIZE		BIT(0)
+#define IEEE80211_QOS_CHAR_PRES_SERVICE_START_TIME	BIT(1)
+#define IEEE80211_QOS_CHAR_PRES_SERVICE_START_LINK_ID	BIT(2)
+#define IEEE80211_QOS_CHAR_PRES_MEAN_DATA_RATE		BIT(3)
+#define IEEE80211_QOS_CHAR_PRES_BURST_SIZE		BIT(4)
+#define IEEE80211_QOS_CHAR_PRES_MSDU_LIFETIME		BIT(5)
+#define IEEE80211_QOS_CHAR_PRES_MSDU_DELIVERY_INFO	BIT(6)
+#define IEEE80211_QOS_CHAR_PRES_MEDIUM_TIME		BIT(7)
+
+/**
+ * ieee80211_qos_char_presence - QoS Characteristics presence bitmap
+ * @qc: the element
+ * Return: the Presence Bitmap Of Additional Parameters subfield, a bitmap of
+ *	%IEEE80211_QOS_CHAR_PRES_*
+ */
+static inline u16
+ieee80211_qos_char_presence(const struct ieee80211_qos_char_elem *qc)
+{
+	return u32_get_bits(le32_to_cpu(qc->control),
+			    IEEE80211_QOS_CHAR_CTRL_PRESENCE);
+}
+
+/**
+ * ieee80211_qos_char_direction - QoS Characteristics direction
+ * @qc: the element
+ * Return: %IEEE80211_QOS_CHAR_DIR_UPLINK, _DOWNLINK or _DIRECT
+ */
+static inline u8
+ieee80211_qos_char_direction(const struct ieee80211_qos_char_elem *qc)
+{
+	return u32_get_bits(le32_to_cpu(qc->control),
+			    IEEE80211_QOS_CHAR_CTRL_DIRECTION);
+}
+
+/**
+ * ieee80211_qos_char_size_ok - check a QoS Characteristics element
+ * @data: candidate octets, from the Element ID
+ * @len: length of @data
+ *
+ * Takes octets rather than an element, because deciding whether they are one
+ * is what it is for. Every other accessor takes the element, so it can only be
+ * read once this has passed.
+ *
+ * Return: %true if the octets are the element they claim to be and its length
+ *	matches the parameters it says are present
+ */
+static inline bool ieee80211_qos_char_size_ok(const u8 *data, size_t len)
+{
+	const struct ieee80211_qos_char_elem *qc = (const void *)data;
+	size_t needed = sizeof(*qc);
+	u16 present;
+
+	if (len < needed)
+		return false;
+
+	if (qc->element_id != WLAN_EID_EXTENSION ||
+	    qc->element_id_ext != WLAN_EID_EXT_QOS_CHARACTERISTICS ||
+	    qc->length != len - 2)
+		return false;
+
+	present = ieee80211_qos_char_presence(qc);
+
+	if (present & ~GENMASK(7, 0))
+		return false;
+
+	if (ieee80211_qos_char_direction(qc) > IEEE80211_QOS_CHAR_DIR_DIRECT)
+		return false;
+
+	/* A LinkID names the link of the Service Start Time, so it needs one */
+	if (present & IEEE80211_QOS_CHAR_PRES_SERVICE_START_LINK_ID &&
+	    !(present & IEEE80211_QOS_CHAR_PRES_SERVICE_START_TIME))
+		return false;
+
+	if (present & IEEE80211_QOS_CHAR_PRES_MAX_MSDU_SIZE)
+		needed += 2;
+	if (present & IEEE80211_QOS_CHAR_PRES_SERVICE_START_TIME)
+		needed += 4;
+	if (present & IEEE80211_QOS_CHAR_PRES_SERVICE_START_LINK_ID)
+		needed += 1;
+	if (present & IEEE80211_QOS_CHAR_PRES_MEAN_DATA_RATE)
+		needed += 3;
+	if (present & IEEE80211_QOS_CHAR_PRES_BURST_SIZE)
+		needed += 4;
+	if (present & IEEE80211_QOS_CHAR_PRES_MSDU_LIFETIME)
+		needed += 2;
+	if (present & IEEE80211_QOS_CHAR_PRES_MSDU_DELIVERY_INFO)
+		needed += 1;
+	if (present & IEEE80211_QOS_CHAR_PRES_MEDIUM_TIME)
+		needed += 2;
+
+	return len == needed;
+}
+
 #endif /* LINUX_IEEE80211_EHT_H */
diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 1837a4e7ea30..6a515df36fc9 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1826,6 +1826,7 @@ enum ieee80211_eid_ext {
 	WLAN_EID_EXT_EHT_MULTI_LINK = 107,
 	WLAN_EID_EXT_EHT_CAPABILITY = 108,
 	WLAN_EID_EXT_TID_TO_LINK_MAPPING = 109,
+	WLAN_EID_EXT_QOS_CHARACTERISTICS = 113,
 	WLAN_EID_EXT_BANDWIDTH_INDICATION = 135,
 	WLAN_EID_EXT_KNOWN_STA_IDENTIFCATION = 136,
 	WLAN_EID_EXT_NON_AP_STA_REG_CON = 137,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index c3b17ee6a192..f140c3c2a5b8 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4237,6 +4237,23 @@ struct cfg80211_scs_desc {
 };
 
 /**
+ * struct cfg80211_mscs_desc - the MSCS of one peer
+ *
+ * @req_type: add, remove or change
+ * @up_bitmap: user priorities that the AP learns from, one bit each
+ * @up_limit: ceiling for the assigned user priority, 0 to 7
+ * @stream_timeout: minimum lifetime of a learned value, in TUs
+ * @fields: classifier parameters, a bitmap of &enum cfg80211_flow_field
+ */
+struct cfg80211_mscs_desc {
+	enum nl80211_scs_req_type req_type;
+	u8 up_bitmap;
+	u8 up_limit;
+	u32 stream_timeout;
+	u32 fields;
+};
+
+/**
  * struct cfg80211_scs_verdict - result of an SCS evaluation
  *
  * @match: an SCS descriptor claimed the MSDU
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 6e8b9d651f4f..2d6d0d70abce 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -643,6 +643,8 @@ int cfg80211_parse_tclas(const u8 *elems, size_t len,
 			 struct cfg80211_tclas *out, u8 n_tclas,
 			 enum cfg80211_tclas_processing *processing);
 int cfg80211_parse_tclas_mask(const u8 *elems, size_t len, u32 *fields);
+bool cfg80211_scs_desc_valid(const struct cfg80211_scs_desc *desc);
+bool cfg80211_mscs_desc_valid(const struct cfg80211_mscs_desc *desc);
 
 #if IS_ENABLED(CONFIG_CFG80211_KUNIT_TEST)
 #define EXPORT_SYMBOL_IF_CFG80211_KUNIT(sym) EXPORT_SYMBOL_IF_KUNIT(sym)
diff --git a/net/wireless/scs.c b/net/wireless/scs.c
index 299a8d83205e..a8daaa99b49e 100644
--- a/net/wireless/scs.c
+++ b/net/wireless/scs.c
@@ -805,3 +805,113 @@ void cfg80211_scs_evaluate(struct cfg80211_scs_desc * const *desc, u8 n_desc,
 	}
 }
 EXPORT_SYMBOL(cfg80211_scs_evaluate);
+
+/*
+ * Two elements of one Processing 0 descriptor can demand two values for one
+ * parameter, which no MSDU satisfies.
+ */
+static bool tclas_conflict(const struct cfg80211_tclas *a,
+			   const struct cfg80211_tclas *b)
+{
+	struct cfg80211_flow_key ka, kb;
+	u32 common = a->fields & b->fields;
+
+	if (!common)
+		return false;
+
+	flow_key_select(&a->key, common, &ka);
+	flow_key_select(&b->key, common, &kb);
+
+	return memcmp(&ka, &kb, sizeof(ka));
+}
+
+/**
+ * cfg80211_scs_desc_valid - check one SCS descriptor against the standard
+ *
+ * @desc: the descriptor, already parsed
+ *
+ * The checks that a classifier element can fail on its own live in
+ * cfg80211_parse_tclas(). This is what is left: the rules that relate the
+ * request type, the classifier and the traffic description to each other.
+ *
+ * Return: whether the descriptor may be installed. A refusal is a legal
+ *	answer to a legal request, so the caller declines it with a status
+ *	code rather than failing the message.
+ */
+bool cfg80211_scs_desc_valid(const struct cfg80211_scs_desc *desc)
+{
+	bool want_tclas = true;
+	unsigned int i, j;
+
+	/*
+	 * 11.25.2 answers a termination with TCLAS_PROCESSING_TERMINATED and
+	 * makes no exception for a malformed one, and it offers no denial
+	 * status for one either. A removal names an identifier, so anything
+	 * else the station put in the descriptor changes nothing it means.
+	 */
+	if (desc->req_type == NL80211_SCS_REQ_REMOVE)
+		return true;
+
+	/* An uplink or direct link descriptor is a traffic description */
+	if (desc->qos_char &&
+	    ieee80211_qos_char_direction(desc->qos_char) !=
+	    IEEE80211_QOS_CHAR_DIR_DOWNLINK)
+		want_tclas = false;
+
+	if (want_tclas != !!desc->n_tclas)
+		return false;
+
+	/* Such a descriptor holds no classifier, so it relates nothing */
+	if (!want_tclas)
+		return desc->tclas_processing == CFG80211_TCLAS_PROCESSING_ABSENT;
+
+	switch (desc->tclas_processing) {
+	case CFG80211_TCLAS_PROCESSING_ALL:
+	case CFG80211_TCLAS_PROCESSING_ANY:
+		/* A choice between elements needs more than one element */
+		if (desc->n_tclas < 2)
+			return false;
+		break;
+	case CFG80211_TCLAS_PROCESSING_DEFAULT:
+		/* 9.4.2.120 pairs it with no classifier, and there is one */
+		return false;
+	case CFG80211_TCLAS_PROCESSING_ABSENT:
+		break;
+	default:
+		return false;
+	}
+
+	if (desc->tclas_processing != CFG80211_TCLAS_PROCESSING_ALL)
+		return true;
+
+	for (i = 0; i < desc->n_tclas; i++)
+		for (j = i + 1; j < desc->n_tclas; j++)
+			if (tclas_conflict(&desc->tclas[i], &desc->tclas[j]))
+				return false;
+
+	return true;
+}
+EXPORT_SYMBOL_IF_CFG80211_KUNIT(cfg80211_scs_desc_valid);
+
+/**
+ * cfg80211_mscs_desc_valid - check an MSCS descriptor against the standard
+ *
+ * @desc: the descriptor, already parsed
+ *
+ * Return: whether the descriptor may be installed.
+ */
+bool cfg80211_mscs_desc_valid(const struct cfg80211_mscs_desc *desc)
+{
+	bool remove = desc->req_type == NL80211_SCS_REQ_REMOVE;
+
+	if (remove == !!desc->fields)
+		return false;
+
+	/*
+	 * The Stream Timeout is the least time the AP keeps a learned value.
+	 * Zero asks for no guarantee at all, so nothing would ever expire the
+	 * entries of that station and its own table would fill with values for
+	 * flows that ended. 9.4.2.242 reserves the field for a Remove.
+	 */
+	return remove || desc->stream_timeout;
+}
-- 
git-series 0.9.1
