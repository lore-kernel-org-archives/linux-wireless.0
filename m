Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723047;
	b=Gbiq2q32uQSEw+iZEB072LRo7u2lQHLYv1SUWR8EpDT6oGt8meECnWzj7fbmFjYMLCDX
	 kkTFtJvMo4fNnCTzY/596dCEsddSbUs9Pc6ZoyDOCt59lX2PXy/AF9m4bKkZnVkZrUTju
	 uI6Ypqms3pGReHXX2ZG0nMM2c4mCy/j2DjOYASwzgFf9ur7Pj3OcTV1aCaOzdT5PxNOF3
	 ME1mrxx67bgTXBjszrdld5y/8rnOb2WfZOcV/t1O/oPPuh8ZxC3f0o0IKbEvUi5lFKvBp
	 Hk4tX2XXWf1rsCD00OKRDkiPI72rB35eW3N8nbm6b900jvXV0OU6uizCiRHrq9A430w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723047;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=TTHYmLP+EBOTzj39US6IWzikaPay8kPzF1VtSqpqgjg=;
	b=L2gakZcn+lX7M+T+bZuFieYRSifH+PBD3xNOdA2Rgi2QqRC647ysRffcEH65sg7hD2LK
	 46xM5yI/T4P1l453iGj1TSde0KUCVQULdHxAURHq/iCMK/G86yL6ecKbTrYEkeE3XTDNT
	 GpxiXp3wa+CjNOE7HzAxaA3QPNsHSi1vZbVEOCzvwxAfGOICVHRFBgEdabo0x5DJza4ps
	 cvIPZrVvz9FhI5PPRLlTLfs64HIX1vZpKHmrrVwgq5xw42Rmpead7kp0NgT0RbpZLh3D9
	 tNQVwDAAfDhMORFAZ/JlPL62DsuKkdqrdboi1fHwZwtuObi1saoewR9L5D35LKBuNtA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=W0GaqBUG;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D948606A33C
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D948606A33C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=W0GaqBUG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=TTHYmLP+EBOTzj39US6IWzikaPay8kPzF1VtSqpqgjg=; b=W0GaqBUG45ClHjSllX5Wqn/dNh
	cBnm0RHCUfG0PnInrqMfSt6Cpi1U0nuBvBGURPSpF7S4ONedqG2JAaXnnWbGSPxX6bbqwKLmbFGWH
	pQKTLDnATSQmnqojZAhbZzb5X5Lwsi/hZkO7+oQyXjlyTO+1/ydtsB5eydxpOpraeYMI=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIl-00FDFp-0M;
	Tue, 03 Nov 2026 17:23:59 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 01/18] wifi: cfg80211: add the TCLAS element parsers
Date: Tue,  3 Nov 2026 17:23:34 +0100
Message-ID: <99dee8052b91a6476cc369cf7c49678fc714d8ac.1793722802.git-series.nbd@nbd.name>
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

SCS and MSCS requests carry their classifiers as raw TCLAS, TCLAS
Processing and TCLAS Mask elements. Add parsers for both element
chains. They produce a flow key with the selected fields set and every
other field zero, so that a match is a comparison of two keys and an
MSCS lookup can hash the same layout.

The supported classifier types are Ethernet header, IP and higher layer
parameters, VLAN tag and the octet filter on a protocol payload. Other
types are refused. A TCLAS element with a User Priority other than 255
is refused as well, since the UP of a downlink MSDU is not known yet
when it is classified.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/linux/ieee80211.h |   1 +-
 include/net/cfg80211.h    | 138 +++++++++++-
 net/wireless/Makefile     |   2 +-
 net/wireless/core.h       |   6 +-
 net/wireless/scs.c        | 477 +++++++++++++++++++++++++++++++++++++++-
 5 files changed, 623 insertions(+), 1 deletion(-)
 create mode 100644 net/wireless/scs.c

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index b2c90c4b262d..da7dec87b0e0 100644
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
index 46ba0fb27b14..b1ffecd8f4f6 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4082,6 +4082,144 @@ struct cfg80211_qos_map {
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
index 7318cec3a956..fd1db979d8a4 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -682,6 +682,12 @@ struct cfg80211_colocated_ap {
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
index 000000000000..1f2ba9d9ec58
--- /dev/null
+++ b/net/wireless/scs.c
@@ -0,0 +1,477 @@
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
+			    size_t len, bool values)
+{
+	const struct tclas_fc_vlan *fc = (const void *)data;
+	u16 tci;
+	u8 pcp;
+
+	if (len != sizeof(*fc))
+		return -EINVAL;
+
+	if (!values)
+		return 0;
+
+	pcp = fc->pcp & 0x0f;
+	if (pcp > 7)
+		return -EINVAL;
+
+	tci = pcp << 13;
+	tci |= (fc->dei & 1) << 12;
+	tci |= be16_to_cpu(fc->vid) & 0x0fff;
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
+		ret = tclas_parse_vlan(&raw, data, len, values);
+		break;
+	case CFG80211_TCLAS_FILTER:
+		/* A TCLAS Mask element cannot describe a filter classifier */
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
+ *	classifier the kernel cannot evaluate, -ENOSPC for a chain that does
+ *	not fit @out.
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
