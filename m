Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68522530DFB
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072032; cv=none; b=g5OyJxgFOrM/LZx8qeBJxYCiHayfKgh27UH7CUAg1Uywph04nKAqzimcgDcj3JWYySQgUfBMCH2G7kyOQ0XVd0uEHV5KwMvBHQwESH2jklgS43ccbzVlahs5eenwLasWjbgvIVzGgGVJNTe0IwVgQoH5omov223+35C9TBEFs1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072032; c=relaxed/simple;
	bh=y5eq+myVR7K2cMkO5bcO9RqRUZbB+MDb3u2yxJRjWzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfWveuXfPgxOkk337PBSsg/973eusx4r9ktL/r2wumurvLhEIkixhxYgb6MwT1++t/vx1MU/B31QV2zP+s0Uw03/UD3u5wTfL/YRbVeJmoy5P4aVZ3o4+Lq7bMEvIqmUGRHlB4L6YBEle1rMqt0DxKG6jt+io2BxsdvzV+byzlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=S+lz0b6A; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="S+lz0b6A"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ZyEi3Lnkr3yc3FarSSFoMEvEmQiFLxWn1Qa8ciMhFak=; b=S+lz0b6ARR4EqTNexDyN3k7BLc
	mMMKX/Qk8q9PEiP89OuZxv6ElhKgEOq6h57GlglU5ZDcphEUHpcp3BMEmKsF0jpfYbTlAWDB/vnF9
	tdrs38aqLQQxF5OlA8RHOIKRAADaU0VZEbFfRlX3IJSzxheMIf8oOeIMfjaRLiJN657I=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVT-00807z-0q;
	Tue, 22 Sep 2026 12:13:47 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 05/16] wifi: cfg80211: add SCS and MSCS request validation
Date: Tue, 22 Sep 2026 12:13:32 +0200
Message-ID: <ac3d17a1c4238c5d8ccf5b1087a454ce07572927.1790071773.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
References: <cover.5f82cb9d25f8f1b63e1994e64a6e9dac538e0ac8.1790071773.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The element parsers validate each classifier element on its own. Add
the checks for the constraints between the request type, the classifier
and the traffic description of an SCS descriptor, and the checks for an
MSCS descriptor.

A failed check is reported as a status code, not as an error. The
request came from a peer over the air and hostapd passes it on as is,
so an AP has to answer a well formed but unacceptable request with a
refusal.

A descriptor with an uplink or direct link traffic description carries
no classifier, since the AP does not classify those streams. Every
other descriptor needs one, and a TCLAS Processing element only with
more than one TCLAS element. The default processing mode is not
supported. A match-all descriptor whose elements require different
values for the same parameter can never match, so it is declined as
well.

An MSCS descriptor needs a classifier mask unless it is a removal, and
a non-zero stream timeout.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h       | 25 ++++++++++-
 include/uapi/linux/nl80211.h | 17 +++++++-
 net/wireless/core.h          |  2 +-
 net/wireless/scs.c           | 94 +++++++++++++++++++++++++++++++++++++-
 4 files changed, 138 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index d6021b551384..1e65021cc1f0 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4247,21 +4247,46 @@ bool cfg80211_flow_key_build(const struct cfg80211_flow_info *info, u32 fields,
 /**
  * struct cfg80211_scs_desc - one SCS descriptor
  *
+ * @req_type: add, remove or change
  * @tclas_processing: how the elements of @tclas relate
+ * @qos_char: the whole QoS Characteristics element, or %NULL. Set only
+ *	after ieee80211_qos_char_size_ok() passed, so the accessors in
+ *	<linux/ieee80211-eht.h> may read it.
  * @id: SCSID, 1 to 255
  * @up: user priority to assign to a matching MSDU
+ * @qos_char_len: length of @qos_char
  * @n_tclas: number of entries in @tclas
  * @tclas: the classifier
  */
 struct cfg80211_scs_desc {
+	enum nl80211_scs_req_type req_type;
 	enum cfg80211_tclas_processing tclas_processing;
+	const struct ieee80211_qos_char_elem *qos_char;
 	u8 id;
 	u8 up;
+	u16 qos_char_len;
 	u8 n_tclas;
 	struct cfg80211_tclas tclas[] __counted_by(n_tclas);
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
  * @match: an SCS descriptor matched the MSDU
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 9a2ccb8d66b8..f010addee737 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -6078,6 +6078,23 @@ enum nl80211_tx_power_setting {
 };
 
 /**
+ * enum nl80211_scs_req_type - SCS or MSCS request type
+ *
+ * The values match the Request Type field of the descriptor on the air.
+ *
+ * @NL80211_SCS_REQ_ADD: create the stream, replacing an active one of the
+ *	same identifier
+ * @NL80211_SCS_REQ_REMOVE: terminate the stream
+ * @NL80211_SCS_REQ_CHANGE: modify an active stream, leaving it in force if
+ *	the request is declined
+ */
+enum nl80211_scs_req_type {
+	NL80211_SCS_REQ_ADD,
+	NL80211_SCS_REQ_REMOVE,
+	NL80211_SCS_REQ_CHANGE,
+};
+
+/**
  * enum nl80211_tid_config - TID config state
  * @NL80211_TID_CONFIG_ENABLE: Enable config for the TID
  * @NL80211_TID_CONFIG_DISABLE: Disable config for the TID
diff --git a/net/wireless/core.h b/net/wireless/core.h
index ccbf1beeb55c..9e8c2c42d67a 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -653,6 +653,8 @@ int cfg80211_parse_tclas(const u8 *elems, size_t len,
 			 struct cfg80211_tclas *out, u8 n_tclas,
 			 enum cfg80211_tclas_processing *processing);
 int cfg80211_parse_tclas_mask(const u8 *elems, size_t len, u32 *fields);
+bool cfg80211_scs_desc_valid(const struct cfg80211_scs_desc *desc);
+bool cfg80211_mscs_desc_valid(const struct cfg80211_mscs_desc *desc);
 
 #if IS_ENABLED(CONFIG_CFG80211_KUNIT_TEST)
 #define EXPORT_SYMBOL_IF_CFG80211_KUNIT(sym) EXPORT_SYMBOL_IF_KUNIT(sym)
diff --git a/net/wireless/scs.c b/net/wireless/scs.c
index 4bfee721f206..22c0b9d6930e 100644
--- a/net/wireless/scs.c
+++ b/net/wireless/scs.c
@@ -886,3 +886,97 @@ void cfg80211_scs_evaluate(struct cfg80211_scs_desc * const *desc, u8 n_desc,
 	}
 }
 EXPORT_SYMBOL(cfg80211_scs_evaluate);
+
+/* Two elements of a match-all descriptor can require conflicting values */
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
+ * cfg80211_scs_desc_valid - validate one SCS descriptor
+ *
+ * @desc: the descriptor, already parsed
+ *
+ * Checks the constraints between the request type, the classifier and the
+ * traffic description. cfg80211_parse_tclas() validates each element.
+ *
+ * Return: whether the descriptor may be installed. The caller reports a
+ *	refusal as a status code, not as an error.
+ */
+bool cfg80211_scs_desc_valid(const struct cfg80211_scs_desc *desc)
+{
+	bool want_tclas = true;
+	unsigned int i, j;
+
+	if (desc->req_type == NL80211_SCS_REQ_REMOVE)
+		return true;
+
+	/* Only a downlink stream is classified by the AP */
+	if (desc->qos_char &&
+	    ieee80211_qos_char_direction(desc->qos_char) !=
+	    IEEE80211_QOS_CHAR_DIR_DOWNLINK)
+		want_tclas = false;
+
+	if (want_tclas != !!desc->n_tclas)
+		return false;
+
+	if (!want_tclas)
+		return desc->tclas_processing ==
+		       CFG80211_TCLAS_PROCESSING_ABSENT;
+
+	switch (desc->tclas_processing) {
+	case CFG80211_TCLAS_PROCESSING_ALL:
+	case CFG80211_TCLAS_PROCESSING_ANY:
+		if (desc->n_tclas < 2)
+			return false;
+		break;
+	case CFG80211_TCLAS_PROCESSING_DEFAULT:
+		return false;
+	case CFG80211_TCLAS_PROCESSING_ABSENT:
+		if (desc->n_tclas > 1)
+			return false;
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
+ * cfg80211_mscs_desc_valid - validate an MSCS descriptor
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
+	/* A zero timeout would expire every entry at the next collection */
+	return remove || desc->stream_timeout;
+}
-- 
git-series 0.9.1
