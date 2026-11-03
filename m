Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723048;
	b=HB7N0MqYI6vmK+h51a37CikB6W2uzmtq2TujyhyLm6TsDsHbyRgmVK3uOE7Onvh6rfA6
	 esMX4qhCcACU/OzPNasiJkyEKHJ/dWHr4+f2attB2JGs243Tj58Sq4clXHZGmvf5SI0mx
	 0V0DTGZzJY5hf2VtnlrnDurMRO6zjZlwL2JbPD7q9OOsJxe5zFGGO076yazEvnLmzImN7
	 Z3+QbA2N3vKquftuB1tZk0Z+72faB8bOYSyfaMQrr8O7lpoJX7YnRTutA60Kpkt3sY/GG
	 ommsmBZxmfYr5Wz/V1DDxVvR0Dpwd6k/liWgkurLZIX4npmhLRHK9hw9DjrD+5f7fzg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723048;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=gZJSd/LVkRkexE0hKrDc5rOJgkcHEIhm74irI1KAM1g=;
	b=H2eICxMTcFJpou/FYtXKlp5ngUuZ/uGxsngD9dFFJj6p9ABGfyo7rhcE9HNeeIMrZEk8
	 8bOnZu3a0aDgCy46U1+TZelp9ngkqGdjlGTPPm0sF6/Ic+0jiBK2YYItk4LW33xjUvo+u
	 bPyv84oFgo5DT4HUT1glgYN6Q0MAYe16V0tPDpoT+E6kLJQKQAOOTs2R38Ofo9x60hc7G
	 OK0ms9YIRmpIGA0cj9WuaGBcDnZ6YjpmYyia//9pExBV9495mlt8b+UfSW/7dMW7aKqWY
	 ErtuwcUvkIznXQM2WrtViq5+Jy52UgSVkwUyeMBDM21+MLSmlJ4PiCI1J02WeW/uy8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b="Sx/yOh8M";
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32CAC606D801
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32CAC606D801
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Sx/yOh8M
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=gZJSd/LVkRkexE0hKrDc5rOJgkcHEIhm74irI1KAM1g=; b=Sx/yOh8MCathpzGbrjDl02Ry/f
	oZvlvphiL3ecIne83oB03krqHxH9ISpjmwiZdYl6UNE46hoR1qBYoDTTiU4IFJY+Vv9HKdCaFxIXk
	QpTI7pSQZfamSVBAW5G6fpzb0dukEvQsJfnGO23t7RLGEzOzuFEeN5X+CucVCRSF4g44=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIm-00FDFp-0k;
	Tue, 03 Nov 2026 17:24:00 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 07/18] wifi: cfg80211: add SCS and MSCS configuration commands
Date: Tue,  3 Nov 2026 17:23:40 +0100
Message-ID: <859e31543b55b94965e9c54a3ccfe8adcc3db07f.1793722802.git-series.nbd@nbd.name>
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

Add NL80211_CMD_SET_SCS and NL80211_CMD_SET_MSCS, which install the
stream classification that a peer requested. Userspace exchanges the
action frames and decides the admission policy. The commands reply with
the status code of each descriptor, from which userspace builds the
response.

The classifier elements are passed as raw elements, so that cfg80211
holds the only parser. An element from the air that cannot be accepted
is answered with a status code, not with a netlink error.

Both descriptors take an optional client address, for the hosts behind
a 4-address peer, such as the backhaul station of a Wi-Fi EasyMesh
Agent. An MSCS can also be marked as configured by the AP on behalf of
a Multi-AP Controller.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/ieee80211.h    |   3 +-
 include/uapi/linux/nl80211.h | 110 ++++++++-
 net/wireless/nl80211.c       | 480 ++++++++++++++++++++++++++++++++++++-
 3 files changed, 593 insertions(+)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 3404afbebdd1..0f7d8fdfe609 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1501,6 +1501,9 @@ enum ieee80211_statuscode {
 	WLAN_STATUS_NO_DIRECT_LINK = 48,
 	WLAN_STATUS_STA_NOT_PRESENT = 49,
 	WLAN_STATUS_STA_NOT_QSTA = 50,
+	WLAN_STATUS_REQUESTED_TCLAS_NOT_SUPPORTED_BY_AP = 56,
+	WLAN_STATUS_INSUFFICIENT_TCLAS_PROCESSING_RESOURCES = 57,
+	WLAN_STATUS_TCLAS_PROCESSING_TERMINATED = 97,
 	/* 802.11s */
 	WLAN_STATUS_ANTI_CLOG_REQUIRED = 76,
 	WLAN_STATUS_FCG_NOT_SUPP = 78,
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index c39cf8a633e9..5e8cba941445 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1468,6 +1468,19 @@
  *	and multiple can be nested in %NL80211_ATTR_MLO_LINKS but then the
  *	update isn't atomic if any failures happen.
  *	Only supported with %NL80211_EXT_FEATURE_UPDATE_BEACON.
+ *
+ * @NL80211_CMD_SET_SCS: Add, change or remove stream classification service
+ *	descriptors of the peer given by %NL80211_ATTR_MAC, as requested in an
+ *	SCS Request frame. The descriptors are in
+ *	%NL80211_ATTR_SCS_DESCRIPTORS. The reply repeats the attribute with
+ *	the identifier and the status code of each descriptor, in the order
+ *	of the request. A declined descriptor does not make the command fail.
+ * @NL80211_CMD_SET_MSCS: Install, change or remove the mirrored stream
+ *	classification service of the peer given by %NL80211_ATTR_MAC, as
+ *	requested in an MSCS Request frame or a (Re)Association Request. The
+ *	parameters are in %NL80211_ATTR_MSCS_DESCRIPTOR. The reply carries
+ *	the status code in %NL80211_ATTR_STATUS_CODE.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -1750,6 +1763,9 @@ enum nl80211_commands {
 
 	NL80211_CMD_UPDATE_BEACON,
 
+	NL80211_CMD_SET_SCS,
+	NL80211_CMD_SET_MSCS,
+
 	/* add new commands above here */
 
 	/* used to define NL80211_CMD_MAX below */
@@ -3243,6 +3259,12 @@ enum nl80211_commands {
  * @NL80211_ATTR_ASSOC_PROTECTED_TWT: Enable protected TWT for the association,
  *	requires protected TWT support (flag attribute)
  *
+ * @NL80211_ATTR_SCS_DESCRIPTORS: Nested array of SCS descriptors, each one a
+ *	nested set of &enum nl80211_scs_desc_attr attributes. Used with
+ *	%NL80211_CMD_SET_SCS in both directions.
+ * @NL80211_ATTR_MSCS_DESCRIPTOR: Nested set of &enum nl80211_mscs_desc_attr
+ *	attributes. Used with %NL80211_CMD_SET_MSCS.
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -3850,6 +3872,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_ASSOC_PROTECTED_TWT,
 
+	NL80211_ATTR_SCS_DESCRIPTORS,
+	NL80211_ATTR_MSCS_DESCRIPTOR,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -6159,6 +6184,91 @@ enum nl80211_scs_req_type {
 };
 
 /**
+ * enum nl80211_scs_desc_attr - one SCS descriptor
+ *
+ * @__NL80211_SCS_DESC_ATTR_INVALID: invalid
+ * @NL80211_SCS_DESC_ATTR_ID: SCSID (u8, 1 to 255). An SCSID of 0 is
+ *	declined with a status code.
+ * @NL80211_SCS_DESC_ATTR_REQ_TYPE: request type (u8, see
+ *	&enum nl80211_scs_req_type). Other values are declined with a status
+ *	code.
+ * @NL80211_SCS_DESC_ATTR_UP: user priority to assign to a matching MSDU
+ *	(u8, 0 to 7), from the Intra-Access Category Priority element.
+ *	Required for a downlink descriptor or one without
+ *	%NL80211_SCS_DESC_ATTR_QOS_CHAR, and rejected otherwise.
+ * @NL80211_SCS_DESC_ATTR_TCLAS: one or more TCLAS elements and at most one
+ *	TCLAS Processing element (binary), as received over the air
+ * @NL80211_SCS_DESC_ATTR_QOS_CHAR: the whole QoS Characteristics element
+ *	(binary), header included, as received over the air
+ * @NL80211_SCS_DESC_ATTR_STATUS: IEEE status code (u16), kernel to userspace
+ * @NL80211_SCS_DESC_ATTR_CLIENT: MAC address of a host behind a 4-address
+ *	peer (6 octets). The descriptor then applies only to MSDUs with that
+ *	destination address. Without it, the descriptor applies to every MSDU
+ *	sent to the peer. The client does not scope the SCSID: userspace
+ *	assigns each descriptor of the peer an SCSID of its own, also one
+ *	for a host behind it or one that a Multi-AP Controller configures.
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
+	NL80211_SCS_DESC_ATTR_CLIENT,
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
+ *	&enum nl80211_scs_req_type). Other values are declined with a status
+ *	code.
+ * @NL80211_MSCS_DESC_ATTR_UP_BITMAP: user priorities that the AP learns
+ *	from, one bit each (u8). Required for an add or change.
+ * @NL80211_MSCS_DESC_ATTR_UP_LIMIT: ceiling for the assigned user priority
+ *	(u8, 0 to 7)
+ * @NL80211_MSCS_DESC_ATTR_STREAM_TIMEOUT: minimum lifetime of a learned
+ *	value, in TUs (u32)
+ * @NL80211_MSCS_DESC_ATTR_TCLAS_MASK: one or more TCLAS Mask elements
+ *	(binary), as received over the air. An add or change without it,
+ *	or a remove with it, is declined with a status code.
+ * @NL80211_MSCS_DESC_ATTR_CLIENT: MAC address of a host behind a 4-address
+ *	peer (6 octets). The AP then learns from uplink MSDUs with that source
+ *	address and applies the result to downlink MSDUs with that
+ *	destination address. Without it, the peer's own address is used.
+ * @NL80211_MSCS_DESC_ATTR_CONFIGURED: flag, the AP configures the MSCS on
+ *	behalf of the network, for example for a Multi-AP Controller, not at
+ *	the request of the peer. An MSCS is identified by its client and this
+ *	flag together, also in a removal. Where both apply to an MSDU, the
+ *	MSCS that the peer requested takes precedence.
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
+	NL80211_MSCS_DESC_ATTR_CLIENT,
+	NL80211_MSCS_DESC_ATTR_CONFIGURED,
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
index 2fc680382418..6b4862e5eac7 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -723,6 +723,32 @@ sar_policy[NL80211_SAR_ATTR_MAX + 1] = {
 	[NL80211_SAR_ATTR_SPECS] = NLA_POLICY_NESTED_ARRAY(sar_specs_policy),
 };
 
+/*
+ * The element parsers validate the binary attributes, so that a malformed
+ * element is answered with a status code instead of a netlink error.
+ */
+static const struct nla_policy
+nl80211_scs_desc_policy[NL80211_SCS_DESC_ATTR_MAX + 1] = {
+	[NL80211_SCS_DESC_ATTR_ID] = { .type = NLA_U8 },
+	[NL80211_SCS_DESC_ATTR_REQ_TYPE] = { .type = NLA_U8 },
+	[NL80211_SCS_DESC_ATTR_UP] = NLA_POLICY_MAX(NLA_U8, 7),
+	[NL80211_SCS_DESC_ATTR_TCLAS] = { .type = NLA_BINARY },
+	[NL80211_SCS_DESC_ATTR_QOS_CHAR] = { .type = NLA_BINARY },
+	[NL80211_SCS_DESC_ATTR_STATUS] = { .type = NLA_REJECT },
+	[NL80211_SCS_DESC_ATTR_CLIENT] = NLA_POLICY_ETH_ADDR,
+};
+
+static const struct nla_policy
+nl80211_mscs_desc_policy[NL80211_MSCS_DESC_ATTR_MAX + 1] = {
+	[NL80211_MSCS_DESC_ATTR_REQ_TYPE] = { .type = NLA_U8 },
+	[NL80211_MSCS_DESC_ATTR_UP_BITMAP] = { .type = NLA_U8 },
+	[NL80211_MSCS_DESC_ATTR_UP_LIMIT] = NLA_POLICY_MAX(NLA_U8, 7),
+	[NL80211_MSCS_DESC_ATTR_STREAM_TIMEOUT] = { .type = NLA_U32 },
+	[NL80211_MSCS_DESC_ATTR_TCLAS_MASK] = { .type = NLA_BINARY },
+	[NL80211_MSCS_DESC_ATTR_CLIENT] = NLA_POLICY_ETH_ADDR,
+	[NL80211_MSCS_DESC_ATTR_CONFIGURED] = { .type = NLA_FLAG },
+};
+
 static const struct nla_policy
 nl80211_mbssid_config_policy[NL80211_MBSSID_CONFIG_ATTR_MAX + 1] = {
 	[NL80211_MBSSID_CONFIG_ATTR_MAX_INTERFACES] = NLA_POLICY_MIN(NLA_U8, 2),
@@ -1201,6 +1227,10 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_ASSOC_CIP] = { .type = NLA_FLAG },
 	[NL80211_ATTR_CIP_CAPABILITIES] = { .type = NLA_U8 },
 	[NL80211_ATTR_ASSOC_PROTECTED_TWT] = { .type = NLA_FLAG },
+	[NL80211_ATTR_SCS_DESCRIPTORS] =
+		NLA_POLICY_NESTED_ARRAY(nl80211_scs_desc_policy),
+	[NL80211_ATTR_MSCS_DESCRIPTOR] =
+		NLA_POLICY_NESTED(nl80211_mscs_desc_policy),
 };
 
 /* policy for the key attributes */
@@ -18877,6 +18907,444 @@ static int nl80211_set_qos_map(struct sk_buff *skb,
 	return ret;
 }
 
+#define NL80211_MAX_SCS_DESC	255
+
+/* A station can install the traffic description of its uplink stream */
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
+/* Only an AP mirrors an uplink priority onto the downlink */
+static int nl80211_mscs_iftype_ok(struct net_device *dev)
+{
+	switch (dev->ieee80211_ptr->iftype) {
+	case NL80211_IFTYPE_AP:
+	case NL80211_IFTYPE_P2P_GO:
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
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
+static int nl80211_parse_stream_client(struct nlattr *attr, u8 *client,
+				       struct genl_info *info)
+{
+	if (!attr)
+		return 0;
+
+	if (!is_valid_ether_addr(nla_data(attr))) {
+		GENL_SET_ERR_MSG(info, "client is not a unicast address");
+		return -EINVAL;
+	}
+
+	ether_addr_copy(client, nla_data(attr));
+
+	return 0;
+}
+
+static void nl80211_free_scs_desc(struct cfg80211_scs_desc **desc,
+				  unsigned int n)
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
+nl80211_parse_scs_desc(struct nlattr *attr, u16 *status,
+		       struct genl_info *info)
+{
+	enum cfg80211_tclas_processing processing =
+		CFG80211_TCLAS_PROCESSING_ABSENT;
+	struct nlattr *tb[NL80211_SCS_DESC_ATTR_MAX + 1];
+	const struct ieee80211_qos_char_elem *qos_char = NULL;
+	struct nlattr *qos_attr, *tclas_attr;
+	struct cfg80211_scs_desc *desc;
+	u8 client[ETH_ALEN] = {};
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
+		GENL_SET_ERR_MSG(info,
+				 "SCS descriptor without an ID or a request type");
+		return ERR_PTR(-EINVAL);
+	}
+
+	err = nl80211_parse_stream_client(tb[NL80211_SCS_DESC_ATTR_CLIENT],
+					  client, info);
+	if (err)
+		return ERR_PTR(err);
+
+	remove = nla_get_u8(tb[NL80211_SCS_DESC_ATTR_REQ_TYPE]) ==
+		 NL80211_SCS_REQ_REMOVE;
+
+	/* A removal names only an SCSID, the elements are ignored */
+	qos_attr = remove ? NULL : tb[NL80211_SCS_DESC_ATTR_QOS_CHAR];
+	if (qos_attr && ieee80211_qos_char_size_ok(nla_data(qos_attr),
+						   nla_len(qos_attr)))
+		qos_char = nla_data(qos_attr);
+
+	/* An uplink or direct link descriptor carries no user priority */
+	if (qos_char && ieee80211_qos_char_direction(qos_char) !=
+			IEEE80211_QOS_CHAR_DIR_DOWNLINK)
+		wants_up = false;
+
+	/* Decline only this descriptor, the rest of the request stands */
+	if (!remove && (!qos_attr || qos_char) &&
+	    wants_up != !!tb[NL80211_SCS_DESC_ATTR_UP])
+		err = -EINVAL;
+
+	tclas_attr = remove ? NULL : tb[NL80211_SCS_DESC_ATTR_TCLAS];
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
+	ether_addr_copy(desc->client, client);
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
+		*status = nl80211_scs_status(err);
+	else if (!cfg80211_scs_desc_valid(desc))
+		*status = WLAN_STATUS_REQUEST_DECLINED;
+
+	return desc;
+}
+
+static struct sk_buff *nl80211_set_scs_reply_alloc(unsigned int n_desc)
+{
+	size_t size = nla_total_size(nla_total_size(sizeof(u8)) +
+				     nla_total_size(sizeof(u16)));
+
+	return nlmsg_new(NLMSG_DEFAULT_SIZE + n_desc * size, GFP_KERNEL);
+}
+
+static int nl80211_set_scs_reply(struct genl_info *info, struct sk_buff *msg,
+				 struct cfg80211_scs_desc * const *desc,
+				 const u16 *status,
+				 unsigned int n_desc)
+{
+	struct nlattr *list, *entry;
+	unsigned int i;
+	void *hdr;
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
+				status[i]))
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
+	struct cfg80211_scs_desc **desc;
+	DECLARE_BITMAP(seen, 256) = {};
+	struct sk_buff *msg;
+	struct nlattr *nla;
+	u16 *status;
+	int rem, err;
+
+	if (!wiphy_ext_feature_isset(&rdev->wiphy, NL80211_EXT_FEATURE_SCS))
+		return -EOPNOTSUPP;
+
+	if (!info->attrs[NL80211_ATTR_MAC] ||
+	    !info->attrs[NL80211_ATTR_SCS_DESCRIPTORS])
+		return -EINVAL;
+
+	if (info->attrs[NL80211_ATTR_MLO_LINK_ID]) {
+		GENL_SET_ERR_MSG(info,
+				 "SCS rules belong to the MLD, not to a link");
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
+	/* Both halves hold n_desc entries: the request, then the applied ones */
+	desc = kcalloc(2 * n_desc, sizeof(*desc), GFP_KERNEL);
+	status = kcalloc(2 * n_desc, sizeof(*status), GFP_KERNEL);
+	msg = nl80211_set_scs_reply_alloc(n_desc);
+	if (!desc || !status || !msg) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	i = 0;
+	nla_for_each_nested(nla, info->attrs[NL80211_ATTR_SCS_DESCRIPTORS],
+			    rem) {
+		desc[i] = nl80211_parse_scs_desc(nla, &status[i], info);
+		if (IS_ERR(desc[i])) {
+			err = PTR_ERR(desc[i]);
+			desc[i] = NULL;
+			goto out;
+		}
+
+		i++;
+	}
+
+	for (i = 0; i < n_desc; i++) {
+		if (test_and_set_bit(desc[i]->id, seen))
+			status[i] = WLAN_STATUS_REQUEST_DECLINED;
+
+		if (status[i] == WLAN_STATUS_SUCCESS)
+			desc[n_desc + n_apply++] = desc[i];
+	}
+
+	if (n_apply) {
+		err = rdev_set_scs(rdev, dev,
+				   nla_data(info->attrs[NL80211_ATTR_MAC]),
+				   &desc[n_desc], &status[n_desc], n_apply);
+		if (err)
+			goto out;
+	}
+
+	n_apply = 0;
+	for (i = 0; i < n_desc; i++) {
+		if (status[i] != WLAN_STATUS_SUCCESS)
+			continue;
+
+		status[i] = status[n_desc + n_apply++];
+		if (status[i] == WLAN_STATUS_SUCCESS &&
+		    desc[i]->req_type == NL80211_SCS_REQ_REMOVE)
+			status[i] = WLAN_STATUS_TCLAS_PROCESSING_TERMINATED;
+	}
+
+	err = nl80211_set_scs_reply(info, msg, desc, status, n_desc);
+	msg = NULL;
+
+out:
+	nlmsg_free(msg);
+	kfree(status);
+	if (desc)
+		nl80211_free_scs_desc(desc, n_desc);
+
+	return err;
+}
+
+static int nl80211_send_status_code(struct genl_info *info, struct sk_buff *msg,
+				    u32 cmd, u16 status)
+{
+	void *hdr;
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
+	struct sk_buff *msg;
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
+		GENL_SET_ERR_MSG(info,
+				 "an MSCS belongs to the MLD, not to a link");
+		return -EINVAL;
+	}
+
+	err = nl80211_mscs_iftype_ok(dev);
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
+		GENL_SET_ERR_MSG(info,
+				 "MSCS descriptor without a request type");
+		return -EINVAL;
+	}
+
+	err = nl80211_parse_stream_client(tb[NL80211_MSCS_DESC_ATTR_CLIENT],
+					  desc.client, info);
+	if (err)
+		return err;
+
+	desc.configured = nla_get_flag(tb[NL80211_MSCS_DESC_ATTR_CONFIGURED]);
+	desc.req_type = nla_get_u8(tb[NL80211_MSCS_DESC_ATTR_REQ_TYPE]);
+	remove = desc.req_type == NL80211_SCS_REQ_REMOVE;
+
+	if (!remove && !tb[NL80211_MSCS_DESC_ATTR_UP_BITMAP]) {
+		GENL_SET_ERR_MSG(info, "MSCS descriptor without a UP bitmap");
+		return -EINVAL;
+	}
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (!msg)
+		return -ENOMEM;
+
+	if (remove == !!tb[NL80211_MSCS_DESC_ATTR_TCLAS_MASK]) {
+		status = WLAN_STATUS_REQUEST_DECLINED;
+		goto reply;
+	}
+
+	desc.up_bitmap =
+		nla_get_u8_default(tb[NL80211_MSCS_DESC_ATTR_UP_BITMAP], 0);
+	desc.up_limit = nla_get_u8_default(tb[NL80211_MSCS_DESC_ATTR_UP_LIMIT],
+					   7);
+	desc.stream_timeout =
+		nla_get_u32_default(tb[NL80211_MSCS_DESC_ATTR_STREAM_TIMEOUT],
+				    0);
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
+	if (err == -ENOSPC) {
+		status = nl80211_scs_status(err);
+		goto reply;
+	}
+
+	if (err) {
+		nlmsg_free(msg);
+		return err;
+	}
+
+	if (remove)
+		status = WLAN_STATUS_TCLAS_PROCESSING_TERMINATED;
+
+reply:
+	return nl80211_send_status_code(info, msg, NL80211_CMD_SET_MSCS,
+					status);
+}
+
 static int nl80211_add_tx_ts(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
@@ -21157,6 +21625,18 @@ static const struct genl_small_ops nl80211_small_ops[] = {
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
