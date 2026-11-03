Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723047;
	b=nAqBAoghqP4RSb+cEeZwgzn2TuvdS96PdZSR+p+Jrr9u6Er/bz1ckf7pJMs5c3DLAGFE
	 jNX4Qcqq8+TFcc7kYscUGabl9a39MxORoATkbHy7pMBM+kisRwFCEI3gEe/QHX+23Ziw8
	 xbdRifGYkpPR/sNHbp+qpMrJEhiGso6M8G7jP4NByB5QL+krsfIosbWDeYtSV5fQwZlcB
	 sp/cY4+FtWswUM0yUpJndRsWMDvYy/ov84S9YrejU3ZK15F+qZQoOGE8ItRs2Uwb1GDeP
	 d5KCnEkVgmmwbaWPEhcQqh0OT0qmlz9O+C2Z8U5X3Yp8XaTAclKkn4U9Fb/WB+49PnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723047;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=IWJRLqocIq8UdKoyG+66nO33k8q7xfFx/utK+NoS0E0=;
	b=QsP7UDqP1UeVEsN44k3qMoKTKQDRQeuImrp1a3ZzpF5Zs+O5ZeHzFkTYc7ke/CGDzdh2
	 211moUPibyl9DayhGKq3Gllsprtpc/Z4e1cWuG3e/etp2jGVqCRs3GZRsGdKOwp0Q/wWk
	 3+vwwLwIQAMJp5Ia2DDWJncDj6uNc/Hp7Hvmf6sikJbbTskt15Lki8JUP5UknDUVFPApc
	 0/GfuxxY4W29r2pgYiuTDg3dKnm/P7sY3+S/6xb2MPFa9KG3pbqTlHfl3qWHRufK4pbqV
	 kg+T1F39bVq2Ldh+4ZCjBN2zSSlKX7bKTSDT54WWp3VxHKBoqkBr7RzIUMOrG8VMAKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=FtWFX4Ll;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32BCD606A335
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32BCD606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=FtWFX4Ll
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=IWJRLqocIq8UdKoyG+66nO33k8q7xfFx/utK+NoS0E0=; b=FtWFX4LlTTgm6Cn853P1KyuycL
	KKxopk4/qWHeZdZgRhA5Mw4vl0Xo1ikCERnj2dHJx7iCpKY12Is0Cdnn1eCvRHwUp6+eAAUh2Wj66
	g2157AtKCDSEMzTIxGnJO0aTK1ilX+g7S7ORM1rA1GP1ZIhR604OjF5Hx99yo2IkbxNw=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIl-00FDFp-2n;
	Tue, 03 Nov 2026 17:23:59 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 05/18] wifi: cfg80211: add SCS and MSCS request validation
Date: Tue,  3 Nov 2026 17:23:38 +0100
Message-ID: <cb22b42159c78d7462f33680d7951880be67b91b.1793722802.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
References: <cover.118d7c7b799f8ed35de51dc2aefef460bf69727b.1793722802.git-series.nbd@nbd.name>
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

The element parsers validate each classifier element on its own. Add
the checks for the constraints between the request type, the classifier
and the traffic description of an SCS descriptor, and the checks for an
MSCS descriptor.

A failed check is reported as a status code, not as an error. The
request came from a peer over the air and hostapd passes it on as is,
so an AP has to answer a well formed but unacceptable request with a
refusal.

A descriptor with an uplink or direct link traffic description carries
no classifier, since the AP does not classify those streams. The
default processing mode is not supported.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h       |  32 ++++++++++++-
 include/uapi/linux/nl80211.h |  17 ++++++-
 net/wireless/core.h          |   2 +-
 net/wireless/scs.c           | 100 ++++++++++++++++++++++++++++++++++++-
 4 files changed, 151 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e2aaf80dbf7c..6132f218174a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4259,9 +4259,14 @@ bool cfg80211_flow_key_build(const struct cfg80211_flow_info *info, u32 fields,
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
  * @client: the host behind a 4-address peer that the descriptor applies
  *	to, matched against the destination address of an MSDU. All zero
  *	for every MSDU sent to the peer. The client does not scope @id,
@@ -4270,15 +4275,42 @@ bool cfg80211_flow_key_build(const struct cfg80211_flow_info *info, u32 fields,
  * @tclas: the classifier
  */
 struct cfg80211_scs_desc {
+	enum nl80211_scs_req_type req_type;
 	enum cfg80211_tclas_processing tclas_processing;
+	const struct ieee80211_qos_char_elem *qos_char;
 	u8 id;
 	u8 up;
+	u16 qos_char_len;
 	u8 client[ETH_ALEN];
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
+ * @client: the host behind a 4-address peer whose flows are mirrored. All
+ *	zero for the flows of the peer itself.
+ * @configured: the AP configured the MSCS on behalf of the network, not at
+ *	the request of the peer. An MSCS is identified by @client and
+ *	@configured together.
+ */
+struct cfg80211_mscs_desc {
+	enum nl80211_scs_req_type req_type;
+	u8 up_bitmap;
+	u8 up_limit;
+	u32 stream_timeout;
+	u32 fields;
+	u8 client[ETH_ALEN];
+	bool configured;
+};
+
+/**
  * struct cfg80211_scs_verdict - result of an SCS evaluation
  *
  * @match: an SCS descriptor matched the MSDU
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b56a96f57bec..1d38d59ea261 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -6142,6 +6142,23 @@ enum nl80211_tx_power_setting {
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
index fd1db979d8a4..08cff7526b0c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -687,6 +687,8 @@ int cfg80211_parse_tclas(const u8 *elems, size_t len,
 			 struct cfg80211_tclas *out, u8 n_tclas,
 			 enum cfg80211_tclas_processing *processing);
 int cfg80211_parse_tclas_mask(const u8 *elems, size_t len, u32 *fields);
+bool cfg80211_scs_desc_valid(const struct cfg80211_scs_desc *desc);
+bool cfg80211_mscs_desc_valid(const struct cfg80211_mscs_desc *desc);
 
 #if IS_ENABLED(CONFIG_CFG80211_KUNIT_TEST)
 #define EXPORT_SYMBOL_IF_CFG80211_KUNIT(sym) EXPORT_SYMBOL_IF_KUNIT(sym)
diff --git a/net/wireless/scs.c b/net/wireless/scs.c
index 1418cb130638..927d9b9e8b57 100644
--- a/net/wireless/scs.c
+++ b/net/wireless/scs.c
@@ -957,3 +957,103 @@ void cfg80211_scs_evaluate(struct cfg80211_scs_desc * const *desc, u8 n_desc,
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
+	if (!desc->id || desc->req_type > NL80211_SCS_REQ_CHANGE)
+		return false;
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
+	if (desc->req_type > NL80211_SCS_REQ_CHANGE)
+		return false;
+
+	if (remove == !!desc->fields)
+		return false;
+
+	/* A zero timeout would expire every entry at the next collection */
+	return remove || desc->stream_timeout;
+}
-- 
git-series 0.9.1
