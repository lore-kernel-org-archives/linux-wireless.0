Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D269B5304A1
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072031; cv=none; b=R1RkiU04QTqAa38ny0jTupQVzTR3bOzVYPYzax24iXmqcqd7k8GR2zQYcCwtFTqb79EXCyhVef//wZycDuzEsOuYmYDqLiUF6RsJiqbx++mLuKclBmoYg7XnRkk9hMiHw32AGR3iInUqehATqF6amiKiicsoTGk3GiJv3ATQ1zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072031; c=relaxed/simple;
	bh=eY4IEVjr1iivwkNTZoW0OPASv4n4ZJ2WReckG0voTtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TdQ3+FIC7hRI1OxIf7CRiITc+wCjvM+jEOmpWDB2j9USfd4tYEVB/DMHpNiEMM+hmEnHs5acqQ/HFCkvWftjICrhNxEVklFL+IwVIozXYuWHfeWifr5JwEIq7+1KI3L0HllKcNWRAQOtGKmoZobCyPveM8ErernvkORbJF5/vnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=BVrVXJzY; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="BVrVXJzY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=WiJgrSo8j/oFwHh+S3+gRID5De+ej5yjxl1eG8RMvqw=; b=BVrVXJzYvMe0P25Z0h5rHP1bHt
	GbFpL5T9Qtn8HXg3F0Y+73ch02HxQh3yJ72irSSc1fNA69KCiIT2EaC8ASe0jRI1aDvet3OOunqW7
	/RZZPnSGYYvOUPP9vMicYukjTgwZmWnzWTb59/2drOWrfl6W09un2/YwxA5M/uEVZk5E=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVS-00807z-0o;
	Tue, 22 Sep 2026 12:13:46 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 01/16] wifi: cfg80211: add the TCLAS element parsers
Date: Tue, 22 Sep 2026 12:13:28 +0200
Message-ID: <815fa6071b32e3546552fa830f767c3046811ec6.1790071773.git-series.nbd@nbd.name>
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

SCS and MSCS requests carry their classifiers as raw TCLAS, TCLAS
Processing and TCLAS Mask elements. Add parsers for both element
chains. They produce a flow key with the selected fields set and every
other field zero, so that a match is a comparison of two keys and an
MSCS lookup can hash the same layout.

The supported classifier types are Ethernet header, IP five tuple, VLAN
tag and the octet filter on a protocol payload. The remaining types are
deprecated or classify an MPDU instead of an MSDU. A TCLAS element with
a User Priority other than 255 is refused as well, since the UP of a
downlink MSDU is not known yet when it is classified. Both cases return
-EOPNOTSUPP, which the caller maps to the status code for an unsupported
classifier. A malformed element returns -EINVAL.

A classifier mask that selects no field is refused, since such a
classifier would match every MSDU. An IP classifier always matches on
the IP version, which the element length implies.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/ieee80211.h |   1 +-
 include/net/cfg80211.h    | 138 +++++++++++-
 net/wireless/Makefile     |   2 +-
 net/wireless/core.h       |   6 +-
 net/wireless/scs.c        | 472 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 618 insertions(+), 1 deletion(-)
 create mode 100644 net/wireless/scs.c

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 7fbc51f873ff..7959f96de562 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1821,6 +1821,7 @@ enum ieee80211_eid_ext {
 	WLAN_EID_EXT_SHORT_SSID_LIST = 58,
 	WLAN_EID_EXT_HE_6GHZ_CAPA = 59,
 	WLAN_EID_EXT_UL_MU_POWER_CAPA = 60,
+	WLAN_EID_EXT_TCLAS_MASK = 89,
 	WLAN_EID_EXT_EHT_OPERATION = 106,
 	WLAN_EID_EXT_EHT_MULTI_LINK = 107,
 	WLAN_EID_EXT_EHT_CAPABILITY = 108,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 9aa7d2d4a184..0aaefb02a678 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4070,6 +4070,144 @@ struct cfg80211_qos_map {
 };
 
 /**
+ * enum cfg80211_tclas_processing - how the TCLAS elements relate
+ *
+ * @CFG80211_TCLAS_PROCESSING_ALL: an MSDU has to match every element
+ * @CFG80211_TCLAS_PROCESSING_ANY: one matching element is enough
+ * @CFG80211_TCLAS_PROCESSING_DEFAULT: matches every MSDU that no other
+ *	descriptor matches, and carries no element
+ * @CFG80211_TCLAS_PROCESSING_ABSENT: the descriptor carries no TCLAS
+ *	Processing element. Not a value of the Processing field.
+ */
+enum cfg80211_tclas_processing {
+	CFG80211_TCLAS_PROCESSING_ALL		= 0,
+	CFG80211_TCLAS_PROCESSING_ANY		= 1,
+	CFG80211_TCLAS_PROCESSING_DEFAULT	= 2,
+
+	CFG80211_TCLAS_PROCESSING_ABSENT	= 0xff,
+};
+
+/**
+ * enum cfg80211_flow_field - classifier parameter of one MSDU
+ *
+ * A set of these is held as a bitmap of BIT(field) in a u32.
+ *
+ * @CFG80211_FLOW_F_ETH_SA: Ethernet source address
+ * @CFG80211_FLOW_F_ETH_DA: Ethernet destination address
+ * @CFG80211_FLOW_F_ETH_TYPE: ethertype
+ * @CFG80211_FLOW_F_VLAN_PCP: IEEE 802.1Q priority code point
+ * @CFG80211_FLOW_F_VLAN_DEI: IEEE 802.1Q drop eligibility indicator
+ * @CFG80211_FLOW_F_VLAN_VID: IEEE 802.1Q VLAN identifier
+ * @CFG80211_FLOW_F_IP_VERSION: IP version
+ * @CFG80211_FLOW_F_IP_SRC: IP source address
+ * @CFG80211_FLOW_F_IP_DST: IP destination address
+ * @CFG80211_FLOW_F_SRC_PORT: layer 4 source port
+ * @CFG80211_FLOW_F_DST_PORT: layer 4 destination port
+ * @CFG80211_FLOW_F_DSCP: differentiated services code point
+ * @CFG80211_FLOW_F_PROTO: IPv4 protocol or IPv6 next header
+ * @CFG80211_FLOW_F_FLOW_LABEL: IPv6 flow label
+ * @NUM_CFG80211_FLOW_FIELDS: number of fields
+ */
+enum cfg80211_flow_field {
+	CFG80211_FLOW_F_ETH_SA,
+	CFG80211_FLOW_F_ETH_DA,
+	CFG80211_FLOW_F_ETH_TYPE,
+	CFG80211_FLOW_F_VLAN_PCP,
+	CFG80211_FLOW_F_VLAN_DEI,
+	CFG80211_FLOW_F_VLAN_VID,
+	CFG80211_FLOW_F_IP_VERSION,
+	CFG80211_FLOW_F_IP_SRC,
+	CFG80211_FLOW_F_IP_DST,
+	CFG80211_FLOW_F_SRC_PORT,
+	CFG80211_FLOW_F_DST_PORT,
+	CFG80211_FLOW_F_DSCP,
+	CFG80211_FLOW_F_PROTO,
+	CFG80211_FLOW_F_FLOW_LABEL,
+
+	NUM_CFG80211_FLOW_FIELDS,
+};
+
+/**
+ * struct cfg80211_flow_key - masked classifier parameters of one MSDU
+ *
+ * Unselected fields are zero. The whole structure is hashed and compared as a
+ * byte string, so it must contain no undefined octet.
+ *
+ * @src: IP source address, IPv4 in the first four octets
+ * @dst: IP destination address, IPv4 in the first four octets
+ * @flow_label: IPv6 flow label
+ * @sa: Ethernet source address
+ * @da: Ethernet destination address
+ * @eth_type: ethertype
+ * @vlan_tci: IEEE 802.1Q tag control information
+ * @src_port: layer 4 source port
+ * @dst_port: layer 4 destination port
+ * @ip_version: IP version, which keeps IPv4 and IPv6 keys apart
+ * @dscp: differentiated services code point, in the six LSBs
+ * @proto: IPv4 protocol or IPv6 next header
+ * @pad: must be zero
+ */
+struct cfg80211_flow_key {
+	struct in6_addr src;
+	struct in6_addr dst;
+	__be32 flow_label;
+	u8 sa[ETH_ALEN];
+	u8 da[ETH_ALEN];
+	__be16 eth_type;
+	__be16 vlan_tci;
+	__be16 src_port;
+	__be16 dst_port;
+	u8 ip_version;
+	u8 dscp;
+	u8 proto;
+	u8 pad;
+};
+
+/* Longest Filter Value and Filter Mask a filter classifier may carry */
+#define CFG80211_TCLAS_FILTER_LEN	28
+
+/**
+ * struct cfg80211_tclas_filter - octet filter on a protocol payload
+ *
+ * @protocol: IPv4 protocol or IPv6 next header value that locates the
+ *	payload to compare
+ * @instance: which occurrence of @protocol to use, counted from zero
+ * @len: length of @value and @mask
+ * @value: octets to compare against the payload
+ * @mask: the bits of @value that are compared
+ */
+struct cfg80211_tclas_filter {
+	u8 protocol;
+	u8 instance;
+	u8 len;
+	u8 value[CFG80211_TCLAS_FILTER_LEN];
+	u8 mask[CFG80211_TCLAS_FILTER_LEN];
+};
+
+/**
+ * struct cfg80211_tclas - parsed TCLAS element
+ *
+ * Only the classifier types the kernel can evaluate are represented, see
+ * cfg80211_parse_tclas().
+ *
+ * @type: classifier type
+ * @fields: the parameters the classifier mask selects, as a bitmap of
+ *	&enum cfg80211_flow_field. Zero for a filter classifier, which
+ *	selects no field of its own.
+ * @key: the required values, with unselected fields zero, so that a match is
+ *	a comparison of two keys
+ * @filter: the octet filter, when @type is a filter classifier
+ */
+struct cfg80211_tclas {
+	u8 type;
+	u32 fields;
+	union {
+		struct cfg80211_flow_key key;
+		struct cfg80211_tclas_filter filter;
+	};
+};
+
+/**
  * DOC: Neighbor Awareness Networking (NAN)
  *
  * NAN uses two interface types:
diff --git a/net/wireless/Makefile b/net/wireless/Makefile
index a77fd5ba6368..552f4557ca23 100644
--- a/net/wireless/Makefile
+++ b/net/wireless/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_WEXT_PRIV) += wext-priv.o
 
 cfg80211-y += core.o sysfs.o radiotap.o util.o reg.o scan.o nl80211.o
 cfg80211-y += mlme.o ibss.o sme.o chan.o ethtool.o mesh.o ap.o trace.o ocb.o
-cfg80211-y += michael-mic.o pmsr.o
+cfg80211-y += michael-mic.o pmsr.o scs.o
 cfg80211-$(CONFIG_OF) += of.o
 cfg80211-$(CONFIG_CFG80211_DEBUGFS) += debugfs.o
 cfg80211-$(CONFIG_CFG80211_WEXT) += wext-compat.o wext-sme.o
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 6138d207caf4..ccbf1beeb55c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -648,6 +648,12 @@ struct cfg80211_colocated_ap {
 	s8 psd_20;
 };
 
+int cfg80211_tclas_count(const u8 *elems, size_t len);
+int cfg80211_parse_tclas(const u8 *elems, size_t len,
+			 struct cfg80211_tclas *out, u8 n_tclas,
+			 enum cfg80211_tclas_processing *processing);
+int cfg80211_parse_tclas_mask(const u8 *elems, size_t len, u32 *fields);
+
 #if IS_ENABLED(CONFIG_CFG80211_KUNIT_TEST)
 #define EXPORT_SYMBOL_IF_CFG80211_KUNIT(sym) EXPORT_SYMBOL_IF_KUNIT(sym)
 #define VISIBLE_IF_CFG80211_KUNIT
diff --git a/net/wireless/scs.c b/net/wireless/scs.c
new file mode 100644
index 000000000000..b0d6037b1f5e
--- /dev/null
+++ b/net/wireless/scs.c
@@ -0,0 +1,472 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Stream classification service (SCS) and mirrored SCS (MSCS)
+ *
+ * Copyright (C) 2026 Felix Fietkau <nbd@nbd.name>
+ */
+#include <kunit/visibility.h>
+#include <linux/ieee80211.h>
+#include <linux/if_vlan.h>
+#include <linux/ip.h>
+#include <linux/ipv6.h>
+#include <linux/unaligned.h>
+#include <net/cfg80211.h>
+#include <net/dsfield.h>
+#include <net/ip.h>
+#include <net/ipv6.h>
+#include "core.h"
+
+enum cfg80211_tclas_type {
+	CFG80211_TCLAS_ETH		= 0,
+	CFG80211_TCLAS_IP		= 4,
+	CFG80211_TCLAS_VLAN		= 5,
+	CFG80211_TCLAS_FILTER		= 10,
+};
+
+struct tclas_fc {
+	u8 type;
+	u8 mask;
+} __packed;
+
+struct tclas_fc_eth {
+	struct tclas_fc hdr;
+	u8 sa[ETH_ALEN];
+	u8 da[ETH_ALEN];
+	__be16 ethertype;
+} __packed;
+
+struct tclas_fc_ip4 {
+	struct tclas_fc hdr;
+	u8 version;
+	__be32 src;
+	__be32 dst;
+	__be16 src_port;
+	__be16 dst_port;
+	u8 dscp;
+	u8 proto;
+	u8 reserved;
+} __packed;
+
+struct tclas_fc_ip6 {
+	struct tclas_fc hdr;
+	u8 version;
+	struct in6_addr src;
+	struct in6_addr dst;
+	__be16 src_port;
+	__be16 dst_port;
+	u8 dscp;
+	u8 proto;
+	u8 flow_label[3];
+} __packed;
+
+struct tclas_fc_vlan {
+	struct tclas_fc hdr;
+	u8 pcp;
+	u8 dei;
+	__be16 vid;
+} __packed;
+
+/* Hashed and compared as a byte string, so it must contain no padding */
+static_assert(sizeof(struct cfg80211_flow_key) ==
+	      2 * sizeof(struct in6_addr) + sizeof(__be32) + 2 * ETH_ALEN +
+	      4 * sizeof(__be16) + 4);
+
+#define FLOW_F(name)	BIT(CFG80211_FLOW_F_##name)
+
+#define FLOW_F_VLAN	(FLOW_F(VLAN_PCP) | FLOW_F(VLAN_DEI) | FLOW_F(VLAN_VID))
+
+/* Reserved classifier mask bits above the array length are ignored */
+static const u8 tclas_map_eth[] = {
+	CFG80211_FLOW_F_ETH_SA,
+	CFG80211_FLOW_F_ETH_DA,
+	CFG80211_FLOW_F_ETH_TYPE,
+};
+
+/* Shared by both IP versions, only IPv6 has the flow label */
+static const u8 tclas_map_ip[] = {
+	CFG80211_FLOW_F_IP_VERSION,
+	CFG80211_FLOW_F_IP_SRC,
+	CFG80211_FLOW_F_IP_DST,
+	CFG80211_FLOW_F_SRC_PORT,
+	CFG80211_FLOW_F_DST_PORT,
+	CFG80211_FLOW_F_DSCP,
+	CFG80211_FLOW_F_PROTO,
+	CFG80211_FLOW_F_FLOW_LABEL,
+};
+
+static const u8 tclas_map_vlan[] = {
+	CFG80211_FLOW_F_VLAN_PCP,
+	CFG80211_FLOW_F_VLAN_DEI,
+	CFG80211_FLOW_F_VLAN_VID,
+};
+
+static u32 tclas_mask_fields(u8 type, u8 version, u8 mask)
+{
+	size_t n = ARRAY_SIZE(tclas_map_ip);
+	const u8 *map = tclas_map_ip;
+	unsigned int i;
+	u32 fields = 0;
+
+	switch (type) {
+	case CFG80211_TCLAS_ETH:
+		map = tclas_map_eth;
+		n = ARRAY_SIZE(tclas_map_eth);
+		break;
+	case CFG80211_TCLAS_VLAN:
+		map = tclas_map_vlan;
+		n = ARRAY_SIZE(tclas_map_vlan);
+		break;
+	default:
+		n -= version == 4;
+		break;
+	}
+
+	for (i = 0; i < n; i++)
+		if (mask & BIT(i))
+			fields |= BIT(map[i]);
+
+	return fields;
+}
+
+static void flow_key_select(const struct cfg80211_flow_key *src, u32 fields,
+			    struct cfg80211_flow_key *dst)
+{
+	memset(dst, 0, sizeof(*dst));
+
+	if (fields & FLOW_F(ETH_SA))
+		memcpy(dst->sa, src->sa, ETH_ALEN);
+	if (fields & FLOW_F(ETH_DA))
+		memcpy(dst->da, src->da, ETH_ALEN);
+	if (fields & FLOW_F(ETH_TYPE))
+		dst->eth_type = src->eth_type;
+
+	if (fields & FLOW_F_VLAN) {
+		u16 tci = 0;
+
+		if (fields & FLOW_F(VLAN_PCP))
+			tci |= VLAN_PRIO_MASK;
+		if (fields & FLOW_F(VLAN_DEI))
+			tci |= VLAN_CFI_MASK;
+		if (fields & FLOW_F(VLAN_VID))
+			tci |= VLAN_VID_MASK;
+
+		dst->vlan_tci = src->vlan_tci & htons(tci);
+	}
+
+	if (fields & FLOW_F(IP_VERSION))
+		dst->ip_version = src->ip_version;
+	if (fields & FLOW_F(IP_SRC))
+		dst->src = src->src;
+	if (fields & FLOW_F(IP_DST))
+		dst->dst = src->dst;
+	if (fields & FLOW_F(SRC_PORT))
+		dst->src_port = src->src_port;
+	if (fields & FLOW_F(DST_PORT))
+		dst->dst_port = src->dst_port;
+
+	if (fields & FLOW_F(DSCP))
+		dst->dscp = src->dscp;
+	if (fields & FLOW_F(PROTO))
+		dst->proto = src->proto;
+	if (fields & FLOW_F(FLOW_LABEL))
+		dst->flow_label = src->flow_label;
+}
+
+static int tclas_parse_eth(struct cfg80211_flow_key *key, const u8 *data,
+			   size_t len)
+{
+	const struct tclas_fc_eth *fc = (const void *)data;
+
+	if (len != sizeof(*fc))
+		return -EINVAL;
+
+	memcpy(key->sa, fc->sa, ETH_ALEN);
+	memcpy(key->da, fc->da, ETH_ALEN);
+	key->eth_type = fc->ethertype;
+
+	return 0;
+}
+
+static int tclas_parse_ip4(struct cfg80211_flow_key *key,
+			   const struct tclas_fc_ip4 *fc, bool values)
+{
+	if (values && fc->version != 4)
+		return -EINVAL;
+
+	key->ip_version = 4;
+	memcpy(&key->src, &fc->src, sizeof(fc->src));
+	memcpy(&key->dst, &fc->dst, sizeof(fc->dst));
+	key->src_port = fc->src_port;
+	key->dst_port = fc->dst_port;
+	key->dscp = fc->dscp & 0x3f;
+	key->proto = fc->proto;
+
+	return 0;
+}
+
+static int tclas_parse_ip6(struct cfg80211_flow_key *key,
+			   const struct tclas_fc_ip6 *fc, bool values)
+{
+	if (values && fc->version != 6)
+		return -EINVAL;
+
+	key->ip_version = 6;
+	memcpy(&key->src, &fc->src, sizeof(fc->src));
+	memcpy(&key->dst, &fc->dst, sizeof(fc->dst));
+	key->src_port = fc->src_port;
+	key->dst_port = fc->dst_port;
+	key->dscp = fc->dscp & 0x3f;
+	key->proto = fc->proto;
+	/* Same encoding as ip6_flowlabel(), so the two compare equal */
+	key->flow_label =
+		cpu_to_be32(get_unaligned_be24(fc->flow_label) & 0xfffff);
+
+	return 0;
+}
+
+/* The Version subfield is reserved in a mask, so the length selects v4/v6 */
+static int tclas_parse_ip(struct cfg80211_flow_key *key, const u8 *data,
+			  size_t len, bool values)
+{
+	if (len == sizeof(struct tclas_fc_ip4))
+		return tclas_parse_ip4(key, (const void *)data, values);
+
+	if (len == sizeof(struct tclas_fc_ip6))
+		return tclas_parse_ip6(key, (const void *)data, values);
+
+	return -EINVAL;
+}
+
+static int tclas_parse_vlan(struct cfg80211_flow_key *key, const u8 *data,
+			    size_t len)
+{
+	const struct tclas_fc_vlan *fc = (const void *)data;
+	u16 tci;
+
+	if (len != sizeof(*fc))
+		return -EINVAL;
+
+	if (fc->pcp > 7 || fc->dei > 1 || be16_to_cpu(fc->vid) > 0xfff)
+		return -EINVAL;
+
+	tci = fc->pcp << 13;
+	tci |= fc->dei << 12;
+	tci |= be16_to_cpu(fc->vid);
+	key->vlan_tci = cpu_to_be16(tci);
+
+	return 0;
+}
+
+/* The octets after the header are the value and the mask, of equal length */
+static int tclas_parse_filter(struct cfg80211_tclas *t, const u8 *data,
+			      size_t len)
+{
+	struct cfg80211_tclas_filter *f = &t->filter;
+
+	if (len < 3 || (len - 3) % 2)
+		return -EINVAL;
+
+	f->len = (len - 3) / 2;
+	if (!f->len || f->len > CFG80211_TCLAS_FILTER_LEN)
+		return -EOPNOTSUPP;
+
+	f->instance = data[1];
+	f->protocol = data[2];
+	memcpy(f->value, data + 3, f->len);
+	memcpy(f->mask, data + 3 + f->len, f->len);
+
+	return 0;
+}
+
+/* @values is false for a TCLAS Mask element, which carries no values */
+static int cfg80211_parse_frame_classifier(struct cfg80211_tclas *t,
+					   const u8 *data, size_t len,
+					   bool values)
+{
+	const struct tclas_fc *fc = (const void *)data;
+	struct cfg80211_flow_key raw = {};
+	int ret;
+
+	if (len < sizeof(*fc))
+		return -EINVAL;
+
+	memset(t, 0, sizeof(*t));
+	t->type = fc->type;
+
+	switch (t->type) {
+	case CFG80211_TCLAS_ETH:
+		ret = tclas_parse_eth(&raw, data, len);
+		break;
+	case CFG80211_TCLAS_IP:
+		ret = tclas_parse_ip(&raw, data, len, values);
+		break;
+	case CFG80211_TCLAS_VLAN:
+		ret = tclas_parse_vlan(&raw, data, len);
+		break;
+	case CFG80211_TCLAS_FILTER:
+		/* A mask element selects fields, which a filter does not */
+		if (!values)
+			return -EOPNOTSUPP;
+
+		return tclas_parse_filter(t, data, len);
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	if (ret)
+		return ret;
+
+	t->fields = tclas_mask_fields(t->type, raw.ip_version, fc->mask);
+
+	/* A mask that selects nothing would match every MSDU */
+	if (!t->fields)
+		return -EINVAL;
+
+	/* Always match on the IP version, which the element length selects */
+	if (t->type == CFG80211_TCLAS_IP)
+		t->fields |= FLOW_F(IP_VERSION);
+
+	flow_key_select(&raw, t->fields, &t->key);
+
+	return 0;
+}
+
+/**
+ * cfg80211_tclas_count - count the TCLAS elements of a chain
+ *
+ * @elems: element chain, as it arrived over the air
+ * @len: length of @elems
+ *
+ * Sizes the array for cfg80211_parse_tclas(). Does not validate the
+ * elements.
+ *
+ * Return: the number of TCLAS elements, or -ENOSPC for more than a descriptor
+ *	can hold.
+ */
+int cfg80211_tclas_count(const u8 *elems, size_t len)
+{
+	const struct element *elem;
+	unsigned int n = 0;
+
+	for_each_element_id(elem, WLAN_EID_TCLAS, elems, len)
+		n++;
+
+	if (n > U8_MAX)
+		return -ENOSPC;
+
+	return n;
+}
+EXPORT_SYMBOL_IF_CFG80211_KUNIT(cfg80211_tclas_count);
+
+/**
+ * cfg80211_parse_tclas - parse a chain of TCLAS elements
+ *
+ * @elems: element chain, as it arrived over the air
+ * @len: length of @elems
+ * @out: array that receives the parsed elements
+ * @n_tclas: number of entries in @out, from cfg80211_tclas_count()
+ * @processing: receives how the elements relate, or
+ *	%CFG80211_TCLAS_PROCESSING_ABSENT when the chain carries no TCLAS
+ *	Processing element
+ *
+ * The chain holds TCLAS elements and at most one TCLAS Processing element.
+ *
+ * Return: 0 on success, -EINVAL for a malformed chain, -EOPNOTSUPP for a
+ *	classifier the kernel cannot evaluate, -ENOSPC for a chain that no
+ *	longer fits @out.
+ */
+int cfg80211_parse_tclas(const u8 *elems, size_t len,
+			 struct cfg80211_tclas *out, u8 n_tclas,
+			 enum cfg80211_tclas_processing *processing)
+{
+	const struct element *elem;
+	unsigned int n = 0;
+	int ret;
+
+	*processing = CFG80211_TCLAS_PROCESSING_ABSENT;
+
+	for_each_element(elem, elems, len) {
+		switch (elem->id) {
+		case WLAN_EID_TCLAS:
+			if (n == n_tclas)
+				return -ENOSPC;
+
+			if (elem->datalen < 1)
+				return -EINVAL;
+
+			/*
+			 * Any other value matches on the UP of the MSDU,
+			 * which is not known yet at classification time.
+			 */
+			if (elem->data[0] != 255)
+				return -EOPNOTSUPP;
+
+			ret = cfg80211_parse_frame_classifier(&out[n],
+							      elem->data + 1,
+							      elem->datalen - 1,
+							      true);
+			if (ret)
+				return ret;
+
+			n++;
+			break;
+		case WLAN_EID_TCLAS_PROCESSING:
+			if (elem->datalen != 1 ||
+			    *processing != CFG80211_TCLAS_PROCESSING_ABSENT ||
+			    elem->data[0] > CFG80211_TCLAS_PROCESSING_DEFAULT)
+				return -EINVAL;
+
+			*processing = elem->data[0];
+			break;
+		default:
+			return -EINVAL;
+		}
+	}
+
+	if (!for_each_element_completed(elem, elems, len))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_IF_CFG80211_KUNIT(cfg80211_parse_tclas);
+
+/**
+ * cfg80211_parse_tclas_mask - parse a chain of TCLAS Mask elements
+ *
+ * @elems: element chain, as it arrived over the air
+ * @len: length of @elems
+ * @fields: receives the union of the selected classifier parameters, as a
+ *	bitmap of &enum cfg80211_flow_field
+ *
+ * A TCLAS Mask element carries no values, only the field selection.
+ *
+ * Return: 0 on success, -EINVAL for a malformed chain, -EOPNOTSUPP for a
+ *	classifier type the kernel cannot evaluate.
+ */
+int cfg80211_parse_tclas_mask(const u8 *elems, size_t len, u32 *fields)
+{
+	const struct element *elem;
+	struct cfg80211_tclas t;
+	int ret;
+
+	*fields = 0;
+
+	for_each_element(elem, elems, len) {
+		if (elem->id != WLAN_EID_EXTENSION || elem->datalen < 1 ||
+		    elem->data[0] != WLAN_EID_EXT_TCLAS_MASK)
+			return -EINVAL;
+
+		ret = cfg80211_parse_frame_classifier(&t, elem->data + 1,
+						      elem->datalen - 1, false);
+		if (ret)
+			return ret;
+
+		*fields |= t.fields;
+	}
+
+	if (!for_each_element_completed(elem, elems, len))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL_IF_CFG80211_KUNIT(cfg80211_parse_tclas_mask);
-- 
git-series 0.9.1
