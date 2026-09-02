Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53ADF3822BB
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338780; cv=none; b=bnQ8hOVBYq4ZprQrb/37Gb/9lQeBOaly6Wkmo76UsmT05+gy9UvFVBEL9SILmO727O+aXkzt/BaP43hwVBi/t5bdiab4tMG62hnA/0C9yMgsZT1nhPacKcspHCY/1VnJ16ZDPMHmMmUYHHoX0Bv+rN2O8aAwPQ056LJBdPhgqS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338780; c=relaxed/simple;
	bh=74zLUsE5DAOLYrHsvZ2v7saAKtH/1rwuO/DFhmFqlGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nj/4s2Br46GIkoVbDP93hnepcK1VAPXuOeVHrS6VGTzRmmbD8vROSB3Rgdd9/d1VeMlgaWIfDxwgRIK4fjO2MAh85sDJsuLCMUsbkTHLrgmiAh85KeL+QWziJ376yvSk/GHqvwhRQuFVChvQkYowSy/ogMqpv4MVEh3KN8gDfgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=l5eymn+U; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="l5eymn+U"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/0+gNazQSy/fDT0lTyn7fkPhRrYKdiduZmGIwJHIWNQ=; b=l5eymn+UqVsi4JjkOKwIQGeT+P
	bZLn8gMQHEbZgcZRgapoxYT7eO8ss/xX531dKv3BfR1mpaPDc6WoUX7k5kRZN9gtwBk0NT3PplHuY
	fm69K/XizbG57d0U6jO4X6LqZWCtjueIpTF73HQGayxRZngyTrUo/969PPkIOTo4lDs4=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbm-00Cwkn-2C;
	Wed, 02 Sep 2026 10:46:14 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 06/15] wifi: cfg80211: add SCS and MSCS configuration commands
Date: Wed,  2 Sep 2026 10:46:01 +0200
Message-ID: <7af0ea59bb8291383fa8a8ccdcfa9e82ff922000.1788338716.git-series.nbd@nbd.name>
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

Add NL80211_CMD_SET_SCS and NL80211_CMD_SET_MSCS, which install on one
peer the stream classification it asked for. Userspace exchanges the
action frames and decides policy; these carry the result down.

The classifier travels as the raw element it arrived as, because nothing
in this path takes it apart. That also decides what is an error and what
is a refusal: an element came from the air, so a malformed or unsupported
one is answered with a status code in the reply, and a netlink error is
kept for what the caller built itself. Add the three status codes of
Table 9-80 that this maps onto.

A request is refused unless the wiphy advertises the matching extended
feature.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/ieee80211.h    |   4 +-
 include/uapi/linux/nl80211.h | 100 ++++++++-
 net/wireless/nl80211.c       | 426 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 530 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 6a515df36fc9..28630f8d2535 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1526,6 +1526,10 @@ enum ieee80211_statuscode {
 	WLAN_STATUS_DENIED_TID_TO_LINK_MAPPING = 133,
 	WLAN_STATUS_PREF_TID_TO_LINK_MAPPING_SUGGESTED = 134,
 	WLAN_STATUS_8021X_AUTH_SUCCESS = 153,
+	/* SCS and MSCS */
+	WLAN_STATUS_REQUESTED_TCLAS_NOT_SUPPORTED_BY_AP = 56,
+	WLAN_STATUS_INSUFFICIENT_TCLAS_PROCESSING_RESOURCES = 57,
+	WLAN_STATUS_TCLAS_PROCESSING_TERMINATED = 97,
 };
 
 
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f3e085c3c34c..e63eba2ee506 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1427,6 +1427,24 @@
  * @NL80211_CMD_STOP_PD: Stop the PD operation, identified by
  *	its %NL80211_ATTR_WDEV interface.
  *
+ * @NL80211_CMD_SET_SCS: Add, change or remove stream classification service
+ *	descriptors of the peer given by %NL80211_ATTR_MAC. The descriptors
+ *	are in %NL80211_ATTR_SCS_DESCRIPTORS, and one message can carry
+ *	several with different request types, because one SCS Request frame
+ *	can. Userspace builds and parses the action frames and holds the
+ *	dialog tokens. The reply repeats %NL80211_ATTR_SCS_DESCRIPTORS with
+ *	the identifier and the IEEE status code of each descriptor, so that
+ *	userspace can build the SCS Status List directly. The netlink return
+ *	code stays 0 when the kernel processed the message, even if it
+ *	declined single descriptors.
+ * @NL80211_CMD_SET_MSCS: Install, change or remove the mirrored stream
+ *	classification service of the peer given by %NL80211_ATTR_MAC. The
+ *	parameters are in %NL80211_ATTR_MSCS_DESCRIPTOR. A peer has at most
+ *	one active MSCS, so the reply carries a single
+ *	%NL80211_ATTR_STATUS_CODE. The same command serves both setup paths:
+ *	an MSCS Request frame, and a (Re)Association Request frame that
+ *	carried an MSCS Descriptor element.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1705,6 +1723,9 @@ enum nl80211_commands {
 	NL80211_CMD_START_PD,
 	NL80211_CMD_STOP_PD,
 
+	NL80211_CMD_SET_SCS,
+	NL80211_CMD_SET_MSCS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -3184,6 +3205,11 @@ enum nl80211_commands {
  *
  *	The aggregated message always precedes the per-link messages for the
  *	same station within a dump sequence.
+ * @NL80211_ATTR_SCS_DESCRIPTORS: Nested array of SCS descriptors, each one a
+ *	nested set of &enum nl80211_scs_desc_attr attributes. Used with
+ *	%NL80211_CMD_SET_SCS in both directions.
+ * @NL80211_ATTR_MSCS_DESCRIPTOR: Nested set of &enum nl80211_mscs_desc_attr
+ *	attributes. Used with %NL80211_CMD_SET_MSCS.
  *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
@@ -3784,6 +3810,8 @@ enum nl80211_attrs {
 	NL80211_ATTR_NPCA_PUNCT_BITMAP,
 
 	NL80211_ATTR_STA_DUMP_LINK_STATS,
+	NL80211_ATTR_SCS_DESCRIPTORS,
+	NL80211_ATTR_MSCS_DESCRIPTOR,
 
 	/* add attributes here, update the policy in nl80211.c */
 
@@ -6084,6 +6112,78 @@ enum nl80211_scs_req_type {
 };
 
 /**
+ * enum nl80211_scs_desc_attr - one SCS descriptor
+ *
+ * The scalars that carry policy are typed attributes, because they are the
+ * values that a bad request can make nonsensical, and netlink policy checks
+ * them before any code runs. The classifier travels as the raw element it
+ * arrived as, because no userspace component in this path takes it apart:
+ * wpa_supplicant holds it opaque, and a Multi-AP Agent moves it between
+ * agents verbatim.
+ *
+ * @__NL80211_SCS_DESC_ATTR_INVALID: invalid
+ * @NL80211_SCS_DESC_ATTR_ID: SCSID (u8, 1 to 255)
+ * @NL80211_SCS_DESC_ATTR_REQ_TYPE: request type (u8, see
+ *	&enum nl80211_scs_req_type)
+ * @NL80211_SCS_DESC_ATTR_UP: user priority to assign to a matching MSDU
+ *	(u8, 0 to 7), taken from the Intra-Access Category Priority element.
+ *	Required for add and change, and rejected for remove and for a
+ *	descriptor whose %NL80211_SCS_DESC_ATTR_QOS_CHAR gives a direction
+ *	other than downlink, which carries no such element.
+ * @NL80211_SCS_DESC_ATTR_TCLAS: one or more TCLAS elements and at most one
+ *	TCLAS Processing element (binary), as they arrived over the air
+ * @NL80211_SCS_DESC_ATTR_QOS_CHAR: QoS Characteristics element (binary), whole
+ *	and as it arrived over the air, header included
+ * @NL80211_SCS_DESC_ATTR_STATUS: IEEE status code (u16), kernel to userspace
+ *
+ * @__NL80211_SCS_DESC_ATTR_AFTER_LAST: internal use
+ * @NL80211_SCS_DESC_ATTR_MAX: highest attribute
+ */
+enum nl80211_scs_desc_attr {
+	__NL80211_SCS_DESC_ATTR_INVALID,
+	NL80211_SCS_DESC_ATTR_ID,
+	NL80211_SCS_DESC_ATTR_REQ_TYPE,
+	NL80211_SCS_DESC_ATTR_UP,
+	NL80211_SCS_DESC_ATTR_TCLAS,
+	NL80211_SCS_DESC_ATTR_QOS_CHAR,
+	NL80211_SCS_DESC_ATTR_STATUS,
+
+	__NL80211_SCS_DESC_ATTR_AFTER_LAST,
+	NL80211_SCS_DESC_ATTR_MAX = __NL80211_SCS_DESC_ATTR_AFTER_LAST - 1
+};
+
+/**
+ * enum nl80211_mscs_desc_attr - the MSCS of one peer
+ *
+ * @__NL80211_MSCS_DESC_ATTR_INVALID: invalid
+ * @NL80211_MSCS_DESC_ATTR_REQ_TYPE: request type (u8, see
+ *	&enum nl80211_scs_req_type)
+ * @NL80211_MSCS_DESC_ATTR_UP_BITMAP: user priorities that the AP learns
+ *	from, one bit each (u8)
+ * @NL80211_MSCS_DESC_ATTR_UP_LIMIT: ceiling for the assigned user priority
+ *	(u8, 0 to 7)
+ * @NL80211_MSCS_DESC_ATTR_STREAM_TIMEOUT: minimum lifetime of a learned
+ *	value, in TUs (u32)
+ * @NL80211_MSCS_DESC_ATTR_TCLAS_MASK: one or more TCLAS Mask elements
+ *	(binary), as they arrived over the air. Required for add and change,
+ *	and rejected for remove.
+ *
+ * @__NL80211_MSCS_DESC_ATTR_AFTER_LAST: internal use
+ * @NL80211_MSCS_DESC_ATTR_MAX: highest attribute
+ */
+enum nl80211_mscs_desc_attr {
+	__NL80211_MSCS_DESC_ATTR_INVALID,
+	NL80211_MSCS_DESC_ATTR_REQ_TYPE,
+	NL80211_MSCS_DESC_ATTR_UP_BITMAP,
+	NL80211_MSCS_DESC_ATTR_UP_LIMIT,
+	NL80211_MSCS_DESC_ATTR_STREAM_TIMEOUT,
+	NL80211_MSCS_DESC_ATTR_TCLAS_MASK,
+
+	__NL80211_MSCS_DESC_ATTR_AFTER_LAST,
+	NL80211_MSCS_DESC_ATTR_MAX = __NL80211_MSCS_DESC_ATTR_AFTER_LAST - 1
+};
+
+/**
  * enum nl80211_tid_config - TID config state
  * @NL80211_TID_CONFIG_ENABLE: Enable config for the TID
  * @NL80211_TID_CONFIG_DISABLE: Disable config for the TID
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 44f2bad08670..cce843850fd3 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -623,6 +623,32 @@ sar_policy[NL80211_SAR_ATTR_MAX + 1] = {
 	[NL80211_SAR_ATTR_SPECS] = NLA_POLICY_NESTED_ARRAY(sar_specs_policy),
 };
 
+/*
+ * The raw element attributes carry what arrived over the air, and the code
+ * that reads them validates it. A length check here would answer a malformed
+ * element with a netlink error instead of the status code it is due.
+ */
+static const struct nla_policy
+nl80211_scs_desc_policy[NL80211_SCS_DESC_ATTR_MAX + 1] = {
+	[NL80211_SCS_DESC_ATTR_ID] = NLA_POLICY_MIN(NLA_U8, 1),
+	[NL80211_SCS_DESC_ATTR_REQ_TYPE] =
+		NLA_POLICY_MAX(NLA_U8, NL80211_SCS_REQ_CHANGE),
+	[NL80211_SCS_DESC_ATTR_UP] = NLA_POLICY_MAX(NLA_U8, 7),
+	[NL80211_SCS_DESC_ATTR_TCLAS] = { .type = NLA_BINARY },
+	[NL80211_SCS_DESC_ATTR_QOS_CHAR] = { .type = NLA_BINARY },
+	[NL80211_SCS_DESC_ATTR_STATUS] = { .type = NLA_REJECT },
+};
+
+static const struct nla_policy
+nl80211_mscs_desc_policy[NL80211_MSCS_DESC_ATTR_MAX + 1] = {
+	[NL80211_MSCS_DESC_ATTR_REQ_TYPE] =
+		NLA_POLICY_MAX(NLA_U8, NL80211_SCS_REQ_CHANGE),
+	[NL80211_MSCS_DESC_ATTR_UP_BITMAP] = { .type = NLA_U8 },
+	[NL80211_MSCS_DESC_ATTR_UP_LIMIT] = NLA_POLICY_MAX(NLA_U8, 7),
+	[NL80211_MSCS_DESC_ATTR_STREAM_TIMEOUT] = { .type = NLA_U32 },
+	[NL80211_MSCS_DESC_ATTR_TCLAS_MASK] = { .type = NLA_BINARY },
+};
+
 static const struct nla_policy
 nl80211_mbssid_config_policy[NL80211_MBSSID_CONFIG_ATTR_MAX + 1] = {
 	[NL80211_MBSSID_CONFIG_ATTR_MAX_INTERFACES] = NLA_POLICY_MIN(NLA_U8, 2),
@@ -1096,6 +1122,10 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_NPCA_PUNCT_BITMAP] =
 		NLA_POLICY_FULL_RANGE(NLA_U32, &nl80211_punct_bitmap_range),
 	[NL80211_ATTR_STA_DUMP_LINK_STATS] = { .type = NLA_FLAG },
+	[NL80211_ATTR_SCS_DESCRIPTORS] =
+		NLA_POLICY_NESTED_ARRAY(nl80211_scs_desc_policy),
+	[NL80211_ATTR_MSCS_DESCRIPTOR] =
+		NLA_POLICY_NESTED(nl80211_mscs_desc_policy),
 };
 
 /* policy for the key attributes */
@@ -18256,6 +18286,390 @@ static int nl80211_set_qos_map(struct sk_buff *skb,
 	return ret;
 }
 
+/* The SCS Descriptor List field of one SCS Request frame cannot exceed this */
+#define NL80211_MAX_SCS_DESC	255
+
+static int nl80211_scs_iftype_ok(struct net_device *dev)
+{
+	switch (dev->ieee80211_ptr->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+	case NL80211_IFTYPE_STATION:
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+/*
+ * A raw element came from the air and hostapd passes it on unchanged, so a bad
+ * one is declined rather than rejected as a malformed message.
+ */
+static u16 nl80211_scs_status(int err)
+{
+	switch (err) {
+	case -EOPNOTSUPP:
+		return WLAN_STATUS_REQUESTED_TCLAS_NOT_SUPPORTED_BY_AP;
+	case -ENOSPC:
+		return WLAN_STATUS_INSUFFICIENT_TCLAS_PROCESSING_RESOURCES;
+	default:
+		return WLAN_STATUS_REQUEST_DECLINED;
+	}
+}
+
+static void nl80211_free_scs_desc(struct cfg80211_scs_desc **desc, unsigned int n)
+{
+	unsigned int i;
+
+	for (i = 0; i < n; i++)
+		kfree(desc[i]);
+
+	kfree(desc);
+}
+
+static struct cfg80211_scs_desc *
+nl80211_parse_scs_desc(struct nlattr *attr, struct cfg80211_scs_result *res,
+		       struct genl_info *info)
+{
+	enum cfg80211_tclas_processing processing = CFG80211_TCLAS_PROCESSING_ABSENT;
+	struct nlattr *tb[NL80211_SCS_DESC_ATTR_MAX + 1];
+	const struct ieee80211_qos_char_elem *qos_char = NULL;
+	struct nlattr *qos_attr, *tclas_attr;
+	struct cfg80211_scs_desc *desc;
+	bool wants_up = true;
+	int n_tclas = 0;
+	bool remove;
+	int err;
+
+	err = nla_parse_nested(tb, NL80211_SCS_DESC_ATTR_MAX, attr,
+			       nl80211_scs_desc_policy, info->extack);
+	if (err)
+		return ERR_PTR(err);
+
+	if (!tb[NL80211_SCS_DESC_ATTR_ID] ||
+	    !tb[NL80211_SCS_DESC_ATTR_REQ_TYPE]) {
+		GENL_SET_ERR_MSG(info, "SCS descriptor without an ID or a request type");
+		return ERR_PTR(-EINVAL);
+	}
+
+	remove = nla_get_u8(tb[NL80211_SCS_DESC_ATTR_REQ_TYPE]) ==
+		 NL80211_SCS_REQ_REMOVE;
+
+	qos_attr = tb[NL80211_SCS_DESC_ATTR_QOS_CHAR];
+	/* Only a candidate that passes is an element anyone may read */
+	if (qos_attr && ieee80211_qos_char_size_ok(nla_data(qos_attr),
+						   nla_len(qos_attr)))
+		qos_char = nla_data(qos_attr);
+
+	/*
+	 * An uplink or direct link descriptor carries no Intra-Access Category
+	 * Priority element, so userspace has no user priority to unpack from
+	 * one.
+	 */
+	if (qos_char && ieee80211_qos_char_direction(qos_char) !=
+			IEEE80211_QOS_CHAR_DIR_DOWNLINK)
+		wants_up = false;
+
+	/*
+	 * The elements that decide this came from the air, so a descriptor
+	 * that contradicts them is declined below and the rest of the request
+	 * stands. A malformed element hides the direction, and is declined
+	 * too. A removal is answered whatever it carries, per 11.25.2.
+	 */
+	if (!remove && (!qos_attr || qos_char) &&
+	    wants_up != !!tb[NL80211_SCS_DESC_ATTR_UP])
+		err = -EINVAL;
+
+	tclas_attr = tb[NL80211_SCS_DESC_ATTR_TCLAS];
+	if (!err && tclas_attr) {
+		n_tclas = cfg80211_tclas_count(nla_data(tclas_attr),
+					       nla_len(tclas_attr));
+		if (n_tclas < 0) {
+			err = n_tclas;
+			n_tclas = 0;
+		}
+	}
+
+	desc = kzalloc(struct_size(desc, tclas, n_tclas), GFP_KERNEL);
+	if (!desc)
+		return ERR_PTR(-ENOMEM);
+
+	desc->id = nla_get_u8(tb[NL80211_SCS_DESC_ATTR_ID]);
+	desc->req_type = nla_get_u8(tb[NL80211_SCS_DESC_ATTR_REQ_TYPE]);
+	desc->up = nla_get_u8_default(tb[NL80211_SCS_DESC_ATTR_UP], 0);
+	desc->n_tclas = n_tclas;
+
+	if (!err && tclas_attr) {
+		err = cfg80211_parse_tclas(nla_data(tclas_attr),
+					   nla_len(tclas_attr), desc->tclas,
+					   n_tclas, &processing);
+		if (err) {
+			desc->n_tclas = 0;
+			processing = CFG80211_TCLAS_PROCESSING_ABSENT;
+		}
+	}
+
+	desc->tclas_processing = processing;
+
+	if (!err && qos_attr) {
+		if (!qos_char) {
+			NL_SET_ERR_MSG(info->extack,
+				       "bad QoS Characteristics element");
+			err = -EINVAL;
+		} else {
+			desc->qos_char = qos_char;
+			desc->qos_char_len = nla_len(qos_attr);
+		}
+	}
+
+	if (err)
+		res->status = nl80211_scs_status(err);
+	else if (!cfg80211_scs_desc_valid(desc))
+		res->status = WLAN_STATUS_REQUEST_DECLINED;
+
+	return desc;
+}
+
+static int nl80211_set_scs_reply(struct genl_info *info,
+				 struct cfg80211_scs_desc * const *desc,
+				 const struct cfg80211_scs_result *res,
+				 unsigned int n_desc)
+{
+	struct nlattr *list, *entry;
+	struct sk_buff *msg;
+	unsigned int i;
+	size_t size;
+	void *hdr;
+
+	/* Identifier and status, for up to 255 descriptors */
+	size = nla_total_size(nla_total_size(sizeof(u8)) +
+			      nla_total_size(sizeof(u16)));
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE + n_desc * size, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0,
+			     NL80211_CMD_SET_SCS);
+	if (!hdr)
+		goto nla_put_failure;
+
+	list = nla_nest_start(msg, NL80211_ATTR_SCS_DESCRIPTORS);
+	if (!list)
+		goto nla_put_failure;
+
+	for (i = 0; i < n_desc; i++) {
+		entry = nla_nest_start(msg, i + 1);
+		if (!entry)
+			goto nla_put_failure;
+
+		if (nla_put_u8(msg, NL80211_SCS_DESC_ATTR_ID, desc[i]->id) ||
+		    nla_put_u16(msg, NL80211_SCS_DESC_ATTR_STATUS,
+				res[i].status))
+			goto nla_put_failure;
+
+		nla_nest_end(msg, entry);
+	}
+
+	nla_nest_end(msg, list);
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+
+nla_put_failure:
+	nlmsg_free(msg);
+
+	return -ENOBUFS;
+}
+
+static int nl80211_set_scs(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct net_device *dev = info->user_ptr[1];
+	unsigned int i, n_desc = 0, n_apply = 0;
+	struct cfg80211_scs_result *res;
+	struct cfg80211_scs_desc **desc;
+	struct nlattr *nla;
+	int rem, err;
+
+	if (!wiphy_ext_feature_isset(&rdev->wiphy, NL80211_EXT_FEATURE_SCS))
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_SCS_DESCRIPTORS])
+		return -EINVAL;
+
+	/* The result is a user priority, which applies to every link */
+	if (info->attrs[NL80211_ATTR_MLO_LINK_ID]) {
+		GENL_SET_ERR_MSG(info, "SCS rules belong to the MLD, not to a link");
+		return -EINVAL;
+	}
+
+	err = nl80211_scs_iftype_ok(dev);
+	if (err)
+		return err;
+
+	nla_for_each_nested(nla, info->attrs[NL80211_ATTR_SCS_DESCRIPTORS], rem)
+		n_desc++;
+
+	if (!n_desc || n_desc > NL80211_MAX_SCS_DESC)
+		return -EINVAL;
+
+	desc = kcalloc(n_desc, sizeof(*desc), GFP_KERNEL);
+	if (!desc)
+		return -ENOMEM;
+
+	res = kcalloc(n_desc, sizeof(*res), GFP_KERNEL);
+	if (!res) {
+		kfree(desc);
+		return -ENOMEM;
+	}
+
+	i = 0;
+	nla_for_each_nested(nla, info->attrs[NL80211_ATTR_SCS_DESCRIPTORS],
+			    rem) {
+		desc[i] = nl80211_parse_scs_desc(nla, &res[i], info);
+		if (IS_ERR(desc[i])) {
+			err = PTR_ERR(desc[i]);
+			desc[i] = NULL;
+			goto out;
+		}
+
+		i++;
+	}
+
+	/*
+	 * The driver is given the unanswered descriptors alone. Gathering them
+	 * at the front keeps each one at the index of its result, and a reply
+	 * entry carries its own SCSID, so the order means nothing.
+	 */
+	for (i = 0; i < n_desc; i++) {
+		if (res[i].status != WLAN_STATUS_SUCCESS)
+			continue;
+
+		swap(desc[i], desc[n_apply]);
+		swap(res[i], res[n_apply]);
+		n_apply++;
+	}
+
+	if (n_apply) {
+		err = rdev_set_scs(rdev, dev,
+				   nla_data(info->attrs[NL80211_ATTR_MAC]),
+				   desc, res, n_apply);
+		if (err)
+			goto out;
+	}
+
+	err = nl80211_set_scs_reply(info, desc, res, n_desc);
+
+out:
+	kfree(res);
+	nl80211_free_scs_desc(desc, n_desc);
+
+	return err;
+}
+
+static int nl80211_send_status_code(struct genl_info *info, u32 cmd, u16 status)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	hdr = nl80211hdr_put(msg, info->snd_portid, info->snd_seq, 0, cmd);
+	if (!hdr || nla_put_u16(msg, NL80211_ATTR_STATUS_CODE, status)) {
+		nlmsg_free(msg);
+		return -ENOBUFS;
+	}
+
+	genlmsg_end(msg, hdr);
+
+	return genlmsg_reply(msg, info);
+}
+
+static int nl80211_set_mscs(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	struct nlattr *tb[NL80211_MSCS_DESC_ATTR_MAX + 1];
+	struct net_device *dev = info->user_ptr[1];
+	struct cfg80211_mscs_desc desc = {};
+	u16 status = WLAN_STATUS_SUCCESS;
+	struct nlattr *mask;
+	bool remove;
+	int err;
+
+	if (!wiphy_ext_feature_isset(&rdev->wiphy, NL80211_EXT_FEATURE_MSCS))
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_MSCS_DESCRIPTOR])
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_MLO_LINK_ID]) {
+		GENL_SET_ERR_MSG(info, "an MSCS belongs to the MLD, not to a link");
+		return -EINVAL;
+	}
+
+	err = nl80211_scs_iftype_ok(dev);
+	if (err)
+		return err;
+
+	err = nla_parse_nested(tb, NL80211_MSCS_DESC_ATTR_MAX,
+			       info->attrs[NL80211_ATTR_MSCS_DESCRIPTOR],
+			       nl80211_mscs_desc_policy, info->extack);
+	if (err)
+		return err;
+
+	if (!tb[NL80211_MSCS_DESC_ATTR_REQ_TYPE]) {
+		GENL_SET_ERR_MSG(info, "MSCS descriptor without a request type");
+		return -EINVAL;
+	}
+
+	desc.req_type = nla_get_u8(tb[NL80211_MSCS_DESC_ATTR_REQ_TYPE]);
+	remove = desc.req_type == NL80211_SCS_REQ_REMOVE;
+
+	if (remove == !!tb[NL80211_MSCS_DESC_ATTR_TCLAS_MASK]) {
+		GENL_SET_ERR_MSG(info, "TCLAS Mask elements do not match the request type");
+		return -EINVAL;
+	}
+
+	desc.up_bitmap = nla_get_u8_default(tb[NL80211_MSCS_DESC_ATTR_UP_BITMAP],
+					    0);
+	desc.up_limit = nla_get_u8_default(tb[NL80211_MSCS_DESC_ATTR_UP_LIMIT],
+					   7);
+	desc.stream_timeout =
+		nla_get_u32_default(tb[NL80211_MSCS_DESC_ATTR_STREAM_TIMEOUT], 0);
+
+	mask = tb[NL80211_MSCS_DESC_ATTR_TCLAS_MASK];
+	if (mask) {
+		err = cfg80211_parse_tclas_mask(nla_data(mask), nla_len(mask),
+						&desc.fields);
+		if (err) {
+			status = nl80211_scs_status(err);
+			goto reply;
+		}
+	}
+
+	if (!cfg80211_mscs_desc_valid(&desc)) {
+		status = WLAN_STATUS_REQUEST_DECLINED;
+		goto reply;
+	}
+
+	err = rdev_set_mscs(rdev, dev,
+			    nla_data(info->attrs[NL80211_ATTR_MAC]), &desc);
+	if (err)
+		return err;
+
+	/* 11.25.3 gives an accepted termination a status of its own */
+	if (remove)
+		status = WLAN_STATUS_TCLAS_PROCESSING_TERMINATED;
+
+reply:
+	return nl80211_send_status_code(info, NL80211_CMD_SET_MSCS, status);
+}
+
 static int nl80211_add_tx_ts(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -20409,6 +20823,18 @@ static const struct genl_small_ops nl80211_small_ops[] = {
 		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
 	},
 	{
+		.cmd = NL80211_CMD_SET_SCS,
+		.doit = nl80211_set_scs,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+	},
+	{
+		.cmd = NL80211_CMD_SET_MSCS,
+		.doit = nl80211_set_mscs,
+		.flags = GENL_UNS_ADMIN_PERM,
+		.internal_flags = IFLAGS(NL80211_FLAG_NEED_NETDEV_UP),
+	},
+	{
 		.cmd = NL80211_CMD_ADD_TX_TS,
 		.validate = GENL_DONT_VALIDATE_STRICT | GENL_DONT_VALIDATE_DUMP,
 		.doit = nl80211_add_tx_ts,
-- 
git-series 0.9.1
