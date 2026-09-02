Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD7836A37E
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338779; cv=none; b=Lq+UpSekLNUwCiKmrNMB7/+9in2WtBdW9Yma59PF+kLoh+3cEmhrJr/MvhsYk2NRk4bPVeU7uS+hWQ+9ata15CE1tWi2AqhCmnOm/P0vgZq+/1tJuugBlZKZOWcq9nDRX4SP4W5DS4oLSGS7i4Thn+Kmhk/SUFRKDdI2yXCLbMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338779; c=relaxed/simple;
	bh=zVmXevqNHy5YwnhJKolQg+lj4+cFqQUdSNmiHfU9vw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJ0fayczXkS6WPHFqDxt94MMhyLbtLGerPgA+ye0mtKsN4P94vAC8OcSjdtO3rEwcms+SMZ0HxfxoDlyEKB9yeMlZJz5Z3gpufI8uD0RVOqI0p2+t9yAIcvhvIqL2w7otlWqxZcV6oYhUNJZEE61lWHJ/PflaBY4uPYVq0xF0Uk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=N0mkVM0v; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="N0mkVM0v"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6Vmu0yrBYfIDSc0OAZsXSw8MZXiqg8aKgNp0UvDagqE=; b=N0mkVM0vFEMdCHx/xES4Us8me7
	v6vF685QjtNN8ba6d56RNAEPTptyfWggLBQozTFLYyVKb/dwcDQvyyJIO1O/kVGl+vLkjE9RlqOBr
	FOd5z8VbbRV+LYhVOXLMV68qA6GY2dI2iBEj2UMw8/qztFiCoWrx/LmQZcHTrWrF/aVE=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbl-00Cwkn-2V;
	Wed, 02 Sep 2026 10:46:13 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 01/15] wifi: cfg80211: add the TCLAS element parsers
Date: Wed,  2 Sep 2026 10:45:56 +0200
Message-ID: <d3d71ff7cd0416ff80b9db9a67f49e149aa71527.1788338716.git-series.nbd@nbd.name>
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

The classifier of an SCS or MSCS request reaches the kernel as the raw
element it arrived as, so add the code that reads the element format.
cfg80211_parse_tclas() walks a chain of TCLAS elements and picks up the
TCLAS Processing element; cfg80211_parse_tclas_mask() reads TCLAS Mask
elements and returns the union of the parameters they select. Both share
one frame classifier parser, which is the only place that knows the
layouts.

They accept the classifier types 0, 4 and 5 and refuse the rest:
9.4.2.29 deprecates type 2 and type 1 for IPv6, type 4 covers what is
left of type 1, and the others either classify an MPDU or need an offset
located per packet. A refusal is a status code and not an error, which is
what 11.25.2 provides for. A User Priority other than 255 is refused too,
since it would make the UP of the MSDU a match parameter when for a
downlink classification it is the result.

The parsed values live in a struct cfg80211_flow_key, masked to the
parameters the classifier names, which is what the frame parser and the
MSCS lookup use as well.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/ieee80211.h |   1 +-
 include/net/cfg80211.h    | 113 +++++++++-
 net/wireless/Makefile     |   2 +-
 net/wireless/core.h       |   6 +-
 net/wireless/scs.c        | 468 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 589 insertions(+), 1 deletion(-)
 create mode 100644 net/wireless/scs.c

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 26e674038865..1837a4e7ea30 100644
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
index 97c16d4ff127..795dd87b795e 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4068,6 +4068,119 @@ struct cfg80211_qos_map {
 };
 
 /**
+ * enum cfg80211_tclas_processing - how the TCLAS elements relate
+ *
+ * @CFG80211_TCLAS_PROCESSING_ALL: an MSDU has to match every element
+ * @CFG80211_TCLAS_PROCESSING_ANY: one matching element is enough
+ * @CFG80211_TCLAS_PROCESSING_DEFAULT: the stream claims what no other stream
+ *	claims, and carries no element
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
+ * The MSCS lookup key. Every field the layout does not select is zero, and
+ * the whole structure is hashed and compared as a byte string, so it must
+ * hold no undefined octet.
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
+/**
+ * struct cfg80211_tclas - parsed TCLAS element
+ *
+ * Only the classifier types 0, 4 and 5 are represented; see
+ * cfg80211_parse_tclas().
+ *
+ * @type: classifier type, see Table 9-203
+ * @fields: the parameters the classifier mask selects, as a bitmap of
+ *	&enum cfg80211_flow_field
+ * @key: the values those parameters must have, with everything @fields does
+ *	not select left zero, so a match is a comparison of two keys
+ */
+struct cfg80211_tclas {
+	u8 type;
+	u32 fields;
+	struct cfg80211_flow_key key;
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
index b4610f6685dc..6e8b9d651f4f 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -638,6 +638,12 @@ struct cfg80211_colocated_ap {
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
index 000000000000..b674d5aa180e
--- /dev/null
+++ b/net/wireless/scs.c
@@ -0,0 +1,468 @@
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
+};
+
+/* Frame Classifier field, one layout per classifier type */
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
+/* The key is hashed and compared as a byte string, so it must have no hole */
+static_assert(sizeof(struct cfg80211_flow_key) ==
+	      2 * sizeof(struct in6_addr) + sizeof(__be32) + 2 * ETH_ALEN +
+	      4 * sizeof(__be16) + 4);
+
+#define FLOW_F(name)	BIT(CFG80211_FLOW_F_##name)
+
+#define FLOW_F_VLAN	(FLOW_F(VLAN_PCP) | FLOW_F(VLAN_DEI) | FLOW_F(VLAN_VID))
+
+/*
+ * The parameter that each classifier mask bit selects, LSB first. A table
+ * length is also the number of parameters that the classifier type has, which
+ * is what drops the reserved bits above them.
+ */
+static const u8 tclas_map_eth[] = {
+	CFG80211_FLOW_F_ETH_SA,
+	CFG80211_FLOW_F_ETH_DA,
+	CFG80211_FLOW_F_ETH_TYPE,
+};
+
+/* Both IP versions share this, and only IPv6 has the flow label */
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
+		/* Only IPv6 has the last one, the flow label */
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
+/* Copy the selected parameters, so that two keys compare as byte strings */
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
+	key->flow_label =
+		cpu_to_be32(get_unaligned_be24(fc->flow_label) & 0xfffff);
+
+	return 0;
+}
+
+/*
+ * A TCLAS Mask element reserves the Version subfield, so the length is what
+ * says which layout this is. The two below are handed the layout it picked,
+ * so only this one sees octets.
+ */
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
+	/*
+	 * 9.4.2.29 gives the Priority Code Point four bits of value space
+	 * where a tag carries three, so the element can name a value no frame
+	 * has. Refuse one rather than fold it onto a value that matches.
+	 */
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
+/* @values is false for a TCLAS Mask element, which reserves every value */
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
+	default:
+		/*
+		 * The rest is deprecated, classifies an MPDU rather than an
+		 * MSDU, or needs a window located per packet.
+		 */
+		return -EOPNOTSUPP;
+	}
+
+	if (ret)
+		return ret;
+
+	t->fields = tclas_mask_fields(t->type, raw.ip_version, fc->mask);
+
+	/*
+	 * The element's own length fixes the version, so comparing it can only
+	 * refuse a packet of the other version whose address happens to equal
+	 * the first octets of this one. 11.25.2 excludes it from the parameter
+	 * count, not from the comparison.
+	 */
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
+ * Sizes the array that cfg80211_parse_tclas() fills. It counts what the chain
+ * claims and validates nothing.
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
+ * The chain holds TCLAS elements (9.4.2.29) and at most one TCLAS Processing
+ * element (9.4.2.31). This is one of the two places in the kernel that reads
+ * the classifier element format.
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
+			 * Any other value matches on the UP of the MSDU, which
+			 * for a downlink classification is the result.
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
+			/* One element, once, with a value the standard gives */
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
+ * A TCLAS Mask element carries no classifier values, so the field selection is
+ * its whole content.
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
