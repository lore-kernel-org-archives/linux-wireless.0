Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C098A3403F8
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338780; cv=none; b=f8HNyUR5XXaeG7pfl4voi9EFt9fFqrqCRmQ6FezuHZNQcLmEEqk6ttxGXI0vfVjgdI5JnHVtzoUGed+7lubCzjMcmHYezSdCcBLHUsXoJP4cJyyiFUFAbFCa1/eGdXu9EkBH5qXLATsufFnUTn7WVlcmfKbjU8DrQAX+zosDaco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338780; c=relaxed/simple;
	bh=QYBJc+KS2G6F8hj9Es+0609pP3Hj6Ex9nbVQUAxfVM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGLGk3stoXAxXyAG8bnCRS2SjmUjI6w068h9RtgdIMZerU74JUWxns21zeh3ZnD9YWrDSVGuSMxmiWoX0DjddEKwZy5ivpLUajbzesQyfPbd54zeGLIGoRp1WCMdOKgAwwMWawrMjR2Pvb37b8QtsfsUj0GD463/qcfFO/q4tkc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=MphdQwH9; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="MphdQwH9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=V3BeJyPsV0nAvoVnu7XnzZGB/0Hsk1C4Z6p3Bgk1wgY=; b=MphdQwH9VZXGhLCVZtCxwAAptT
	YRwuxHgUYDAkqoRNcd4Kv5aEe3ujPN9bkIdpQBvJjz2oHNjqWXDB5pZJXO3q2yuxKlU0A1E3X8BZZ
	ErdsvAHCY8BelXDM4LqSIeiJ3vhfl7nAf4ODQe+FKiHpWUo04IPeCblFGfHt0KBKo370=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbm-00Cwkn-0T;
	Wed, 02 Sep 2026 10:46:14 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 03/15] wifi: cfg80211: add the SCS evaluator
Date: Wed,  2 Sep 2026 10:45:58 +0200
Message-ID: <1357126abc94a3ec8b57ea64df489fc9664a1a8e.1788338716.git-series.nbd@nbd.name>
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

cfg80211_scs_evaluate() walks the descriptors of one peer and answers
with the user priority of the one that claims an MSDU. That is the whole
of SCS on the host side: everything before it parses, everything after it
stores.

When several descriptors match, 11.25.2 gives the frame to the one that
names the most classifier parameters, and an equal count keeps the first,
which the standard leaves to the implementation. Where the elements of a
descriptor are ORed, its count is the smallest of them, because that is
what a frame had to satisfy to match.

The verdict also carries an undecided bit, set when a descriptor named a
parameter the caller does not carry and did not match anyway. That means
nothing for a frame, and tells a caller answering per flow rather than
per frame that this flow cannot be decided from what it knows.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h       |  46 +++++++++++++++-
 include/uapi/linux/nl80211.h |  18 ++++++-
 net/wireless/scs.c           | 111 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 175 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index db5f53147179..c3b17ee6a192 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4212,6 +4212,52 @@ bool cfg80211_flow_key_build(const struct cfg80211_flow_info *info, u32 fields,
 			     struct cfg80211_flow_key *key);
 
 /**
+ * struct cfg80211_scs_desc - one SCS descriptor
+ *
+ * @req_type: add, remove or change
+ * @tclas_processing: how the elements of @tclas relate
+ * @qos_char: the whole QoS Characteristics element, or %NULL. Set only once
+ *	ieee80211_qos_char_size_ok() has passed, so the accessors in
+ *	<linux/ieee80211-eht.h> may read it.
+ * @id: SCSID, 1 to 255
+ * @up: user priority to assign to a matching MSDU
+ * @qos_char_len: length of @qos_char
+ * @n_tclas: number of entries in @tclas
+ * @tclas: the classifier
+ */
+struct cfg80211_scs_desc {
+	enum nl80211_scs_req_type req_type;
+	enum cfg80211_tclas_processing tclas_processing;
+	const struct ieee80211_qos_char_elem *qos_char;
+	u8 id;
+	u8 up;
+	u16 qos_char_len;
+	u8 n_tclas;
+	struct cfg80211_tclas tclas[] __counted_by(n_tclas);
+};
+
+/**
+ * struct cfg80211_scs_verdict - result of an SCS evaluation
+ *
+ * @match: an SCS descriptor claimed the MSDU
+ * @undecided: a descriptor named a parameter the caller does not carry and
+ *	did not match anyway. A frame is simply not classified; an offload
+ *	caller cannot answer for the flow at all.
+ * @scsid: identifier of the matching descriptor
+ * @up: user priority to assign
+ */
+struct cfg80211_scs_verdict {
+	bool match;
+	bool undecided;
+	u8 scsid;
+	u8 up;
+};
+
+void cfg80211_scs_evaluate(struct cfg80211_scs_desc * const *desc, u8 n_desc,
+			   const struct cfg80211_flow_info *info,
+			   struct cfg80211_scs_verdict *verdict);
+
+/**
  * DOC: Neighbor Awareness Networking (NAN)
  *
  * NAN uses two interface types:
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 020387d76412..86e1855c8475 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -6066,6 +6066,24 @@ enum nl80211_tx_power_setting {
 };
 
 /**
+ * enum nl80211_scs_req_type - SCS or MSCS request type
+ *
+ * The values are those of the Request Type field, IEEE Std 802.11-2024,
+ * Table 9-286.
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
diff --git a/net/wireless/scs.c b/net/wireless/scs.c
index 06ba0a3a4184..299a8d83205e 100644
--- a/net/wireless/scs.c
+++ b/net/wireless/scs.c
@@ -694,3 +694,114 @@ bool cfg80211_flow_key_build(const struct cfg80211_flow_info *info, u32 fields,
 	return true;
 }
 EXPORT_SYMBOL(cfg80211_flow_key_build);
+
+static bool tclas_match(const struct cfg80211_tclas *t,
+			const struct cfg80211_flow_info *info, bool *undecided)
+{
+	struct cfg80211_flow_key key;
+
+	if (!cfg80211_flow_key_build(info, t->fields, CFG80211_FLOW_AS_IS,
+				     &key)) {
+		*undecided = true;
+
+		return false;
+	}
+
+	return !memcmp(&key, &t->key, sizeof(key));
+}
+
+static u16 tclas_param_count(const struct cfg80211_tclas *t)
+{
+	/* The count is fixed at 3 for classifier type 5 */
+	if (t->type == CFG80211_TCLAS_VLAN)
+		return 3;
+
+	/* The IP version is not counted, and no other type carries it */
+	return hweight32(t->fields & ~FLOW_F(IP_VERSION));
+}
+
+static bool scs_desc_match(const struct cfg80211_scs_desc *desc,
+			   const struct cfg80211_flow_info *info,
+			   bool *undecided)
+{
+	unsigned int i;
+	bool any = false;
+
+	for (i = 0; i < desc->n_tclas; i++) {
+		if (tclas_match(&desc->tclas[i], info, undecided)) {
+			any = true;
+			continue;
+		}
+
+		if (desc->tclas_processing == CFG80211_TCLAS_PROCESSING_ALL)
+			return false;
+	}
+
+	return any;
+}
+
+static u16 scs_desc_param_count(const struct cfg80211_scs_desc *desc)
+{
+	unsigned int i;
+	u16 count;
+
+	if (desc->tclas_processing != CFG80211_TCLAS_PROCESSING_ALL) {
+		count = U16_MAX;
+		for (i = 0; i < desc->n_tclas; i++)
+			count = min(count, tclas_param_count(&desc->tclas[i]));
+
+		return count == U16_MAX ? 0 : count;
+	}
+
+	count = 0;
+	for (i = 0; i < desc->n_tclas; i++)
+		count += tclas_param_count(&desc->tclas[i]);
+
+	return count;
+}
+
+/**
+ * cfg80211_scs_evaluate - pick the SCS descriptor that claims a flow
+ *
+ * @desc: the active descriptors of one peer
+ * @n_desc: number of entries in @desc
+ * @info: the flow, from cfg80211_flow_parse()
+ * @verdict: receives the result
+ *
+ * When several descriptors match, the one that requires the greatest number of
+ * classifier parameters wins. An equal count keeps the first, which 11.25.2
+ * leaves to the implementation.
+ */
+void cfg80211_scs_evaluate(struct cfg80211_scs_desc * const *desc, u8 n_desc,
+			   const struct cfg80211_flow_info *info,
+			   struct cfg80211_scs_verdict *verdict)
+{
+	unsigned int i;
+	int best = -1;
+
+	memset(verdict, 0, sizeof(*verdict));
+
+	for (i = 0; i < n_desc; i++) {
+		bool undecided = false;
+		u16 count;
+
+		if (!scs_desc_match(desc[i], info, &undecided)) {
+			/*
+			 * A descriptor that matched is decided, whichever
+			 * element was skipped. Only this one leaves a question.
+			 */
+			verdict->undecided |= undecided;
+			continue;
+		}
+
+		count = scs_desc_param_count(desc[i]);
+		if (count <= best)
+			continue;
+
+		best = count;
+		verdict->match = true;
+		verdict->scsid = desc[i]->id;
+		verdict->up = desc[i]->up;
+	}
+}
+EXPORT_SYMBOL(cfg80211_scs_evaluate);
-- 
git-series 0.9.1
