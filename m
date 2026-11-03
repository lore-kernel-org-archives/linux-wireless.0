Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723048;
	b=Y6hSGdVjEvHHgDh8TOkH89CeWGSdld8jkum9vQtOl19wPlfCtxG2jQtRj7RXwiKTbZu2
	 FW52o4D71ic8s/vxARZ7blY1vvIOtUehe3e7HUpdVyMhRCiWRayjexXDNMa2HA1i0XDRN
	 XP/Xe/PgGEtXyJ6bIpaMk1rVpY0cstdFVv5cSTw71mbagNMXG7CUQjVC6O/Nv9QYBrrbq
	 3RaJvx+6pu6Sb8XIUjsRpifEv/dwPW/9IGixu5ntRqjxEBm59eU/jv4tQxMExnUWaSy4s
	 cmUGjn91lyOfghzRSf085btEvixl2wFOg2cjrnLqx34gL0d3ZLg7FHRNoGn4cho6uKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723048;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=OTeg8WnHejOfas1lRdcl08bUeujFtQzI0ODjc9/aciI=;
	b=a0RhlZ2HSJDoU8lziyUKS07sej1K8TZ6CFr34acsO4A2AESFzfXxkQ1yDEBhgAs1yALN
	 nZ4pu8bi4wOi4hHMFiRqKKCaap925iL0RBPjvc3zdvOAe4bv0bHvoh3lHs3kW1v5PIjOW
	 zQahaAHQv702zeifbK8vtXDYwA/uxTiB9O23fOeExslnxXELBeP/t0Ogjn7ezDAVWgxAw
	 P2x8etcodezWV/ehE89YzKTDY3YRkdjRUhNxDEiXeROUvupDjnHtyzkp9JYLxb/2rmBZm
	 RCNUDGcjeXgw7IVwA8aDfIQMdQ566LHvBCLNLH+++h1mEkg3V9K6sVTGaHwwYhwb3CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=k+mu9FDa;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B9C606A32E
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32B9C606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=k+mu9FDa
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=OTeg8WnHejOfas1lRdcl08bUeujFtQzI0ODjc9/aciI=; b=k+mu9FDaqs6NybZrg/aTEHMGOh
	yaJ7Clw/Vo78iSfxnDsuva1AZwLTdi9kZkpkduV46ChRJJWu4eUbTlIjv2YxnP8El87xD5zVwiJrL
	BMnrlcSfjpnUrKZ3czv1E+hVOcR/l6ULIoDJ74qTx2K6DEM+Tu1PW1Gs79ULi4okgmno=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIm-00FDFp-1Q;
	Tue, 03 Nov 2026 17:24:00 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 08/18] wifi: cfg80211: add KUnit tests for the SCS classifier
Date: Tue,  3 Nov 2026 17:23:41 +0100
Message-ID: <86f50b8e75254418218c0c32399d272dea638cac.1793722802.git-series.nbd@nbd.name>
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

Cover the cases that produce a wrong priority without a crash: IP
fragments, the granularity rule, mirrored keys, unsupported classifiers,
reserved bits, filter classifiers, client addresses, undecided verdicts,
the QoS Characteristics length check, uplink descriptors and the
validation rules of SCS and MSCS descriptors.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/wireless/tests/Makefile |   2 +-
 net/wireless/tests/scs.c    | 901 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 902 insertions(+), 1 deletion(-)
 create mode 100644 net/wireless/tests/scs.c

diff --git a/net/wireless/tests/Makefile b/net/wireless/tests/Makefile
index c364e63b508e..a4b7f2e206fc 100644
--- a/net/wireless/tests/Makefile
+++ b/net/wireless/tests/Makefile
@@ -1,3 +1,3 @@
-cfg80211-tests-y += module.o fragmentation.o scan.o util.o chan.o
+cfg80211-tests-y += module.o fragmentation.o scan.o util.o chan.o scs.o
 
 obj-$(CONFIG_CFG80211_KUNIT_TEST) += cfg80211-tests.o
diff --git a/net/wireless/tests/scs.c b/net/wireless/tests/scs.c
new file mode 100644
index 000000000000..6f6e94012ac0
--- /dev/null
+++ b/net/wireless/tests/scs.c
@@ -0,0 +1,901 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * KUnit tests for the SCS and MSCS classifier
+ *
+ * Copyright (C) 2026 Felix Fietkau <nbd@nbd.name>
+ */
+#include <kunit/skbuff.h>
+#include <kunit/test.h>
+#include <linux/ieee80211.h>
+#include <linux/ip.h>
+#include <net/cfg80211.h>
+#include "../core.h"
+
+static const u8 test_da[ETH_ALEN] = { 0x02, 0x00, 0x00, 0x00, 0x00, 0x02 };
+
+/* An Ethernet header, an IPv4 header and four octets of UDP ports */
+static const u8 udp_frame[] = {
+	0x02, 0x00, 0x00, 0x00, 0x00, 0x02,	/* destination address */
+	0x02, 0x00, 0x00, 0x00, 0x00, 0x01,	/* source address */
+	0x08, 0x00,
+	0x45, 0x00, 0x00, 0x20, 0xab, 0xcd, 0x00, 0x00,
+	0x40, 0x11, 0x00, 0x00,
+	192, 168, 1, 1,
+	192, 168, 1, 2,
+	0x13, 0x88, 0x27, 0x10,
+	0xde, 0xad, 0xbe, 0xef,
+};
+
+/* The same datagram, as a fragment with a nonzero offset */
+static const u8 udp_fragment[] = {
+	0x02, 0x00, 0x00, 0x00, 0x00, 0x02,	/* destination address */
+	0x02, 0x00, 0x00, 0x00, 0x00, 0x01,	/* source address */
+	0x08, 0x00,
+	0x45, 0x00, 0x00, 0x20, 0xab, 0xcd, 0x00, 0x02,
+	0x40, 0x11, 0x00, 0x00,
+	192, 168, 1, 1,
+	192, 168, 1, 2,
+	0x13, 0x88, 0x27, 0x10,
+	0xde, 0xad, 0xbe, 0xef,
+};
+
+/* UDP in IPv6 in IPv4 */
+static const u8 udp_6in4[] = {
+	0x02, 0x00, 0x00, 0x00, 0x00, 0x02,
+	0x02, 0x00, 0x00, 0x00, 0x00, 0x01,
+	0x08, 0x00,
+	0x45, 0x00, 0x00, 0x40, 0x00, 0x00, 0x00, 0x00,
+	0x40, 0x29, 0x00, 0x00,	/* protocol 41 */
+	192, 168, 1, 1,
+	192, 168, 1, 2,
+	0x60, 0x00, 0x00, 0x00, 0x00, 0x08, 0x11, 0x40,
+	0x20, 0x01, 0x0d, 0xb8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
+	0x20, 0x01, 0x0d, 0xb8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2,
+	0x13, 0x88, 0x27, 0x10,
+};
+
+static struct sk_buff *test_skb(struct kunit *test, const u8 *data,
+				size_t len)
+{
+	struct sk_buff *skb = kunit_zalloc_skb(test, 256, GFP_KERNEL);
+
+	KUNIT_ASSERT_NOT_NULL(test, skb);
+	skb_put_data(skb, data, len);
+
+	return skb;
+}
+
+#define TEST_SKB(test, buf)	test_skb(test, buf, sizeof(buf))
+
+#define FLOW_F(name)	BIT(CFG80211_FLOW_F_##name)
+
+#define QC(buf)		((const struct ieee80211_qos_char_elem *)(buf))
+#define QC_OK(buf)	ieee80211_qos_char_size_ok(buf, sizeof(buf))
+
+/* A later fragment carries no ports */
+static void flow_parse_fragment(struct kunit *test)
+{
+	struct cfg80211_flow_info info;
+
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_frame),
+					      &info));
+	KUNIT_EXPECT_TRUE(test, info.present & FLOW_F(SRC_PORT));
+	KUNIT_EXPECT_TRUE(test, info.present & FLOW_F(DST_PORT));
+	KUNIT_EXPECT_EQ(test, be16_to_cpu(info.key.src_port), 5000);
+	KUNIT_EXPECT_EQ(test, be16_to_cpu(info.key.dst_port), 10000);
+	KUNIT_EXPECT_EQ(test, info.key.proto, IPPROTO_UDP);
+
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_fragment),
+					      &info));
+	KUNIT_EXPECT_FALSE(test, info.present & FLOW_F(SRC_PORT));
+	KUNIT_EXPECT_FALSE(test, info.present & FLOW_F(DST_PORT));
+	KUNIT_EXPECT_EQ(test, be16_to_cpu(info.key.src_port), 0);
+	KUNIT_EXPECT_EQ(test, be16_to_cpu(info.key.dst_port), 0);
+	KUNIT_EXPECT_TRUE(test, info.present & FLOW_F(IP_SRC));
+	KUNIT_EXPECT_TRUE(test, info.present & FLOW_F(IP_DST));
+}
+
+static struct cfg80211_scs_desc *
+test_scs_desc(struct kunit *test, u8 id, u8 up, const u8 *elems, size_t len)
+{
+	struct cfg80211_scs_desc *desc;
+	int n_tclas;
+
+	n_tclas = cfg80211_tclas_count(elems, len);
+	KUNIT_ASSERT_GE(test, n_tclas, 0);
+
+	desc = kunit_kzalloc(test, struct_size(desc, tclas, n_tclas),
+			     GFP_KERNEL);
+	KUNIT_ASSERT_NOT_NULL(test, desc);
+
+	desc->id = id;
+	desc->up = up;
+	desc->n_tclas = n_tclas;
+	KUNIT_ASSERT_EQ(test, 0,
+			cfg80211_parse_tclas(elems, len, desc->tclas, n_tclas,
+					     &desc->tclas_processing));
+
+	return desc;
+}
+
+/* When two descriptors match, the more granular one wins */
+static void scs_granularity(struct kunit *test)
+{
+	static const u8 two_params[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x06,		/* type, mask: src and dst address */
+		4,			/* version */
+		192, 168, 1, 1,
+		192, 168, 1, 2,
+		0, 0, 0, 0,		/* ports, not selected */
+		0, 0, 0,		/* dscp, protocol, reserved */
+	};
+	static const u8 three_params[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x16,		/* src, dst, dst port */
+		4,
+		192, 168, 1, 1,
+		192, 168, 1, 2,
+		0, 0, 0x27, 0x10,
+		0, 0, 0,
+	};
+	static const u8 wrong_port[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x08,		/* src port only */
+		4,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0x00, 0x35, 0, 0,
+		0, 0, 0,
+	};
+	struct cfg80211_scs_desc *list[3];
+	struct cfg80211_scs_verdict verdict;
+	struct cfg80211_flow_info info;
+
+	list[0] = test_scs_desc(test, 1, 3, two_params, sizeof(two_params));
+	list[1] = test_scs_desc(test, 2, 6, three_params, sizeof(three_params));
+	list[2] = test_scs_desc(test, 3, 7, wrong_port, sizeof(wrong_port));
+
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_frame),
+					      &info));
+
+	/* The IP version is always matched, but does not count as a parameter */
+	KUNIT_EXPECT_EQ(test, list[0]->tclas[0].fields,
+			FLOW_F(IP_VERSION) | FLOW_F(IP_SRC) | FLOW_F(IP_DST));
+	KUNIT_EXPECT_EQ(test, list[1]->tclas[0].fields,
+			FLOW_F(IP_VERSION) | FLOW_F(IP_SRC) | FLOW_F(IP_DST) |
+			FLOW_F(DST_PORT));
+
+	cfg80211_scs_evaluate(list, 3, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_EQ(test, verdict.scsid, 2);
+	KUNIT_EXPECT_EQ(test, verdict.up, 6);
+
+	swap(list[0], list[1]);
+	cfg80211_scs_evaluate(list, 3, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_EQ(test, verdict.scsid, 2);
+
+	/* A frame without ports leaves only the address descriptor */
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_fragment),
+					      &info));
+	cfg80211_scs_evaluate(list, 3, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_EQ(test, verdict.scsid, 1);
+	KUNIT_EXPECT_EQ(test, verdict.up, 3);
+	KUNIT_EXPECT_TRUE(test, verdict.undecided);
+
+	/* An undecided descriptor that cannot beat the match does not count */
+	cfg80211_scs_evaluate(&list[1], 2, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_EQ(test, verdict.scsid, 1);
+	KUNIT_EXPECT_FALSE(test, verdict.undecided);
+}
+
+/* A key learned from an uplink frame must describe the downlink direction */
+static void flow_key_mirror(struct kunit *test)
+{
+	static const u8 mask_elem[] = {
+		WLAN_EID_EXTENSION, 19,
+		WLAN_EID_EXT_TCLAS_MASK,
+		4, 0x1e,
+		4,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0,
+	};
+	struct cfg80211_flow_key as_is, mirrored;
+	struct cfg80211_flow_info info;
+	u32 fields;
+
+	KUNIT_ASSERT_EQ(test, 0,
+			cfg80211_parse_tclas_mask(mask_elem, sizeof(mask_elem),
+						  &fields));
+	KUNIT_EXPECT_EQ(test, fields,
+			FLOW_F(IP_VERSION) | FLOW_F(IP_SRC) | FLOW_F(IP_DST) |
+			FLOW_F(SRC_PORT) | FLOW_F(DST_PORT));
+
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_frame),
+					      &info));
+
+	KUNIT_ASSERT_TRUE(test, cfg80211_flow_key_build(&info, fields,
+							CFG80211_FLOW_AS_IS,
+							&as_is));
+	KUNIT_ASSERT_TRUE(test, cfg80211_flow_key_build(&info, fields,
+							CFG80211_FLOW_MIRRORED,
+							&mirrored));
+
+	KUNIT_EXPECT_MEMEQ(test, &as_is.src, &mirrored.dst, sizeof(as_is.src));
+	KUNIT_EXPECT_MEMEQ(test, &as_is.dst, &mirrored.src, sizeof(as_is.dst));
+	KUNIT_EXPECT_EQ(test, be16_to_cpu(as_is.src_port),
+			be16_to_cpu(mirrored.dst_port));
+	KUNIT_EXPECT_EQ(test, be16_to_cpu(as_is.dst_port),
+			be16_to_cpu(mirrored.src_port));
+
+	/* No unselected field may reach the key */
+	KUNIT_EXPECT_MEMEQ(test, as_is.sa, "\x00\x00\x00\x00\x00\x00",
+			   ETH_ALEN);
+	KUNIT_EXPECT_EQ(test, be16_to_cpu(as_is.eth_type), 0);
+	KUNIT_EXPECT_EQ(test, as_is.proto, 0);
+	KUNIT_EXPECT_EQ(test, as_is.ip_version, 4);
+	KUNIT_EXPECT_EQ(test, mirrored.ip_version, 4);
+}
+
+/* The Ethernet addresses mirror as a pair */
+static void flow_key_mirror_eth(struct kunit *test)
+{
+	static const u8 mask_elem[] = {
+		WLAN_EID_EXTENSION, 17,
+		WLAN_EID_EXT_TCLAS_MASK,
+		0, 0x01,		/* classifier type 0, source address */
+		0, 0, 0, 0, 0, 0,
+		0, 0, 0, 0, 0, 0,
+		0, 0,
+	};
+	struct cfg80211_flow_key key;
+	struct cfg80211_flow_info info;
+	u32 fields;
+
+	KUNIT_ASSERT_EQ(test, 0,
+			cfg80211_parse_tclas_mask(mask_elem, sizeof(mask_elem),
+						  &fields));
+	KUNIT_EXPECT_EQ(test, fields, FLOW_F(ETH_SA));
+
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_frame),
+					      &info));
+
+	KUNIT_ASSERT_TRUE(test, cfg80211_flow_key_build(&info, fields,
+							CFG80211_FLOW_MIRRORED,
+							&key));
+
+	KUNIT_EXPECT_MEMEQ(test, key.sa, test_da, ETH_ALEN);
+	KUNIT_EXPECT_MEMEQ(test, key.da, "\x00\x00\x00\x00\x00\x00", ETH_ALEN);
+}
+
+/* Each unsupported classifier is refused with -EOPNOTSUPP, not -EINVAL */
+static void tclas_refused(struct kunit *test)
+{
+	static const u8 mac_header[] = {
+		WLAN_EID_TCLAS, 5,
+		255,
+		6, 0x00, 0x00, 0x00,	/* type 6, 3 octet mask */
+	};
+	static const u8 up_not_255[] = {
+		WLAN_EID_TCLAS, 17,
+		0,			/* a UP that takes part in the match */
+		0, 0x01,
+		0x02, 0x00, 0x00, 0x00, 0x00, 0x01,
+		0x02, 0x00, 0x00, 0x00, 0x00, 0x02,
+		0x08, 0x00,
+	};
+	static const u8 filter_in_mask[] = {
+		WLAN_EID_EXTENSION, 9,
+		WLAN_EID_EXT_TCLAS_MASK,
+		10, 0, 0, 17,		/* type, mask, instance, protocol */
+		0x00, 0x00,
+		0xff, 0xff,
+	};
+	static const u8 legacy_ip[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		1, 0x06,
+		4,
+		192, 168, 1, 1,
+		192, 168, 1, 2,
+		0, 0, 0, 0,
+		0, 0, 0,
+	};
+	static const u8 legacy_vlan[] = {
+		WLAN_EID_TCLAS, 5,
+		255,
+		2, 0x01,
+		0x00, 0x64,
+	};
+	enum cfg80211_tclas_processing processing;
+	struct cfg80211_tclas tclas;
+	u32 fields;
+
+	KUNIT_EXPECT_EQ(test, -EOPNOTSUPP,
+			cfg80211_parse_tclas(mac_header, sizeof(mac_header),
+					     &tclas, 1, &processing));
+	KUNIT_EXPECT_EQ(test, -EOPNOTSUPP,
+			cfg80211_parse_tclas(up_not_255, sizeof(up_not_255),
+					     &tclas, 1, &processing));
+	KUNIT_EXPECT_EQ(test, -EOPNOTSUPP,
+			cfg80211_parse_tclas(legacy_ip, sizeof(legacy_ip),
+					     &tclas, 1, &processing));
+	KUNIT_EXPECT_EQ(test, -EOPNOTSUPP,
+			cfg80211_parse_tclas(legacy_vlan, sizeof(legacy_vlan),
+					     &tclas, 1, &processing));
+	KUNIT_EXPECT_EQ(test, -EOPNOTSUPP,
+			cfg80211_parse_tclas_mask(filter_in_mask,
+						  sizeof(filter_in_mask),
+						  &fields));
+}
+
+/* A descriptor that matched leaves nothing undecided */
+static void scs_undecided(struct kunit *test)
+{
+	static const u8 addr_or_port[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x02,		/* source address */
+		4,
+		192, 168, 1, 1,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0,
+
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x08,		/* source port */
+		4,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0x13, 0x88, 0, 0,
+		0, 0, 0,
+
+		WLAN_EID_TCLAS_PROCESSING, 1, 1,
+	};
+	static const u8 port_only[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x08,
+		4,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0x13, 0x88, 0, 0,
+		0, 0, 0,
+	};
+	static const u8 other_addr_port[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x0a,		/* source address and port */
+		4,
+		10, 0, 0, 1,
+		0, 0, 0, 0,
+		0x13, 0x88, 0, 0,
+		0, 0, 0,
+	};
+	static const u8 port_and_other_addr[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x08,
+		4,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0x13, 0x88, 0, 0,
+		0, 0, 0,
+
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x02,
+		4,
+		10, 0, 0, 1,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0,
+
+		WLAN_EID_TCLAS_PROCESSING, 1, 0,
+	};
+	struct cfg80211_scs_verdict verdict;
+	struct cfg80211_flow_info info;
+	struct cfg80211_scs_desc *list[1];
+
+	list[0] = test_scs_desc(test, 1, 4, addr_or_port, sizeof(addr_or_port));
+	KUNIT_ASSERT_EQ(test, list[0]->n_tclas, 2);
+	KUNIT_ASSERT_EQ(test, list[0]->tclas_processing, 1);
+
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_frame),
+					      &info));
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_FALSE(test, verdict.undecided);
+
+	/* A later fragment has no ports, but the address element matches */
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_fragment),
+					      &info));
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_FALSE(test, verdict.undecided);
+
+	/* With nothing else to match on, the same fragment is undecided */
+	list[0] = test_scs_desc(test, 2, 4, port_only, sizeof(port_only));
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_FALSE(test, verdict.match);
+	KUNIT_EXPECT_TRUE(test, verdict.undecided);
+
+	/* A parameter that the fragment carries and that differs decides */
+	list[0] = test_scs_desc(test, 3, 4, other_addr_port,
+				sizeof(other_addr_port));
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_FALSE(test, verdict.match);
+	KUNIT_EXPECT_FALSE(test, verdict.undecided);
+
+	/* In a match-all descriptor, a mismatch decides over an earlier gap */
+	list[0] = test_scs_desc(test, 4, 4, port_and_other_addr,
+				sizeof(port_and_other_addr));
+	KUNIT_ASSERT_EQ(test, list[0]->tclas_processing,
+			CFG80211_TCLAS_PROCESSING_ALL);
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_FALSE(test, verdict.match);
+	KUNIT_EXPECT_FALSE(test, verdict.undecided);
+}
+
+/* A descriptor with a client only matches MSDUs addressed to that client */
+static void scs_client(struct kunit *test)
+{
+	static const u8 other_client[ETH_ALEN] = {
+		0x02, 0x00, 0x00, 0x00, 0x00, 0x03
+	};
+	static const u8 addrs[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x06,		/* src and dst address */
+		4,
+		192, 168, 1, 1,
+		192, 168, 1, 2,
+		0, 0, 0, 0,
+		0, 0, 0,
+	};
+	static const u8 addrs_port[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x16,		/* src, dst, dst port */
+		4,
+		192, 168, 1, 1,
+		192, 168, 1, 2,
+		0, 0, 0x27, 0x10,
+		0, 0, 0,
+	};
+	struct cfg80211_scs_verdict verdict;
+	struct cfg80211_flow_info info;
+	struct cfg80211_scs_desc *list[2];
+
+	list[0] = test_scs_desc(test, 1, 5, addrs, sizeof(addrs));
+	list[1] = test_scs_desc(test, 1, 6, addrs_port, sizeof(addrs_port));
+	ether_addr_copy(list[0]->client, test_da);
+	ether_addr_copy(list[1]->client, other_client);
+
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_frame),
+					      &info));
+
+	/* The more granular descriptor belongs to another client */
+	cfg80211_scs_evaluate(list, 2, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_EQ(test, verdict.up, 5);
+	KUNIT_EXPECT_FALSE(test, verdict.undecided);
+
+	/* Without a client, a descriptor applies to every destination */
+	eth_zero_addr(list[1]->client);
+	cfg80211_scs_evaluate(list, 2, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_EQ(test, verdict.up, 6);
+
+	/* No descriptor of another client matches */
+	ether_addr_copy(list[0]->client, other_client);
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_FALSE(test, verdict.match);
+	KUNIT_EXPECT_FALSE(test, verdict.undecided);
+
+	/* A flow description without a destination address cannot decide */
+	info.present &= ~FLOW_F(ETH_DA);
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_FALSE(test, verdict.match);
+	KUNIT_EXPECT_TRUE(test, verdict.undecided);
+
+	cfg80211_scs_evaluate(&list[1], 1, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_EQ(test, verdict.up, 6);
+}
+
+/* The presence bitmap decides where every optional field starts */
+static void qos_characteristics(struct kunit *test)
+{
+	/* Downlink, TID 5, UP 5, and a Service Start Time with no LinkID */
+	static const u8 no_link_id[] = {
+		0xff, 0x17, 0x71,	/* element header, 113 */
+		0x55, 0x05, 0x00, 0x00,	/* control info, presence bit 1 */
+		0xe8, 0x03, 0x00, 0x00,	/* minimum service interval */
+		0xd0, 0x07, 0x00, 0x00,	/* maximum service interval */
+		0x88, 0x13, 0x00,	/* minimum data rate */
+		0x20, 0x4e, 0x00,	/* delay bound */
+		0x78, 0x56, 0x34, 0x12,	/* service start time */
+	};
+	static const u8 with_link_id[] = {
+		0xff, 0x18, 0x71,
+		0x55, 0x0d, 0x00, 0x00,	/* presence bits 1 and 2 */
+		0xe8, 0x03, 0x00, 0x00,
+		0xd0, 0x07, 0x00, 0x00,
+		0x88, 0x13, 0x00,
+		0x20, 0x4e, 0x00,
+		0x78, 0x56, 0x34, 0x12,
+		0x03,			/* service start time LinkID */
+	};
+	/* Direct link, presence bit 7 */
+	static const u8 direct_medium_time[] = {
+		0xff, 0x15, 0x71,
+		0x56, 0x01, 0x01, 0x00,
+		0xe8, 0x03, 0x00, 0x00,
+		0xd0, 0x07, 0x00, 0x00,
+		0x88, 0x13, 0x00,
+		0x20, 0x4e, 0x00,
+		0x10, 0x00,		/* medium time */
+	};
+	static const u8 downlink_medium_time[] = {
+		0xff, 0x15, 0x71,
+		0x55, 0x01, 0x01, 0x00,
+		0xe8, 0x03, 0x00, 0x00,
+		0xd0, 0x07, 0x00, 0x00,
+		0x88, 0x13, 0x00,
+		0x20, 0x4e, 0x00,
+		0x10, 0x00,
+	};
+	static const u8 orphan_link_id[] = {
+		0xff, 0x14, 0x71,
+		0x55, 0x09, 0x00, 0x00,	/* presence bit 2 alone */
+		0xe8, 0x03, 0x00, 0x00,
+		0xd0, 0x07, 0x00, 0x00,
+		0x88, 0x13, 0x00,
+		0x20, 0x4e, 0x00,
+		0x03,
+	};
+	static const u8 bad_ext_id[] = {
+		0xff, 0x17, 0x70,
+		0x55, 0x05, 0x00, 0x00,
+		0xe8, 0x03, 0x00, 0x00,
+		0xd0, 0x07, 0x00, 0x00,
+		0x88, 0x13, 0x00,
+		0x20, 0x4e, 0x00,
+		0x78, 0x56, 0x34, 0x12,
+	};
+	static const u8 bad_length[] = {
+		0xff, 0x18, 0x71,
+		0x55, 0x05, 0x00, 0x00,
+		0xe8, 0x03, 0x00, 0x00,
+		0xd0, 0x07, 0x00, 0x00,
+		0x88, 0x13, 0x00,
+		0x20, 0x4e, 0x00,
+		0x78, 0x56, 0x34, 0x12,
+	};
+	static const u8 short_elem[] = {
+		0xff, 0x13, 0x71,
+		0x55, 0x05, 0x00, 0x00,
+		0xe8, 0x03, 0x00, 0x00,
+		0xd0, 0x07, 0x00, 0x00,
+		0x88, 0x13, 0x00,
+		0x20, 0x4e, 0x00,
+	};
+
+	/* The LinkID is present exactly when the Service Start Time is */
+	KUNIT_EXPECT_FALSE(test, QC_OK(no_link_id));
+	KUNIT_EXPECT_EQ(test, ieee80211_qos_char_direction(QC(no_link_id)),
+			IEEE80211_QOS_CHAR_DIR_DOWNLINK);
+	KUNIT_EXPECT_EQ(test, ieee80211_qos_char_presence(QC(no_link_id)),
+			IEEE80211_QOS_CHAR_PRES_SERVICE_START_TIME);
+
+	KUNIT_EXPECT_TRUE(test, QC_OK(with_link_id));
+	KUNIT_EXPECT_EQ(test, ieee80211_qos_char_presence(QC(with_link_id)),
+			IEEE80211_QOS_CHAR_PRES_SERVICE_START_TIME |
+			IEEE80211_QOS_CHAR_PRES_SERVICE_START_LINK_ID);
+
+	/* Only a direct link stream carries a Medium Time */
+	KUNIT_EXPECT_TRUE(test, QC_OK(direct_medium_time));
+	KUNIT_EXPECT_EQ(test,
+			ieee80211_qos_char_presence(QC(direct_medium_time)),
+			IEEE80211_QOS_CHAR_PRES_MEDIUM_TIME);
+	KUNIT_EXPECT_FALSE(test, QC_OK(downlink_medium_time));
+
+	KUNIT_EXPECT_FALSE(test, QC_OK(orphan_link_id));
+	KUNIT_EXPECT_FALSE(test, QC_OK(short_elem));
+	KUNIT_EXPECT_FALSE(test, QC_OK(bad_ext_id));
+	KUNIT_EXPECT_FALSE(test, QC_OK(bad_length));
+}
+
+/* An uplink descriptor carries no classifier and no user priority */
+static void scs_traffic_description(struct kunit *test)
+{
+	/* Uplink, with a Service Start Time and its LinkID */
+	static const u8 uplink[] = {
+		0xff, 0x18, 0x71,
+		0x54, 0x0d, 0x00, 0x00,
+		0xe8, 0x03, 0x00, 0x00,
+		0xd0, 0x07, 0x00, 0x00,
+		0x88, 0x13, 0x00,
+		0x20, 0x4e, 0x00,
+		0x78, 0x56, 0x34, 0x12,
+		0x03,
+	};
+	struct cfg80211_scs_desc desc = {
+		.req_type = NL80211_SCS_REQ_ADD,
+		.tclas_processing = CFG80211_TCLAS_PROCESSING_ABSENT,
+		.qos_char = QC(uplink),
+		.qos_char_len = sizeof(uplink),
+		.id = 1,
+	};
+
+	KUNIT_ASSERT_TRUE(test, QC_OK(uplink));
+	KUNIT_ASSERT_EQ(test, ieee80211_qos_char_direction(QC(uplink)),
+			IEEE80211_QOS_CHAR_DIR_UPLINK);
+
+	KUNIT_EXPECT_TRUE(test, cfg80211_scs_desc_valid(&desc));
+
+	/* Such a descriptor carries no TCLAS Processing element either */
+	desc.tclas_processing = CFG80211_TCLAS_PROCESSING_DEFAULT;
+	KUNIT_EXPECT_FALSE(test, cfg80211_scs_desc_valid(&desc));
+}
+
+/* A filter classifier matches on the payload octets of the named protocol */
+static void scs_filter(struct kunit *test)
+{
+	static const u8 udp_sport[] = {
+		WLAN_EID_TCLAS, 8,
+		255,
+		10, 0, 17,		/* type, instance, protocol */
+		0x13, 0x88,		/* value: source port 5000 */
+		0xff, 0xff,		/* mask */
+	};
+	static const u8 wrong_sport[] = {
+		WLAN_EID_TCLAS, 8,
+		255,
+		10, 0, 17,
+		0x00, 0x35,
+		0xff, 0xff,
+	};
+	struct cfg80211_scs_desc *list[1];
+	struct cfg80211_scs_verdict verdict;
+	struct cfg80211_flow_info info;
+
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_frame),
+					      &info));
+
+	list[0] = test_scs_desc(test, 1, 5, udp_sport, sizeof(udp_sport));
+	KUNIT_EXPECT_EQ(test, list[0]->tclas[0].type, 10);
+	KUNIT_EXPECT_EQ(test, list[0]->tclas[0].filter.len, 2);
+
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+	KUNIT_EXPECT_EQ(test, verdict.up, 5);
+
+	list[0] = test_scs_desc(test, 2, 5, wrong_sport, sizeof(wrong_sport));
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_FALSE(test, verdict.match);
+	KUNIT_EXPECT_FALSE(test, verdict.undecided);
+
+	/* A later fragment does not carry the header of the protocol */
+	list[0] = test_scs_desc(test, 3, 5, udp_sport, sizeof(udp_sport));
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_fragment),
+					      &info));
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_FALSE(test, verdict.match);
+
+	/* The protocol chain continues into an IPv6 packet inside IPv4 */
+	KUNIT_ASSERT_TRUE(test,
+			  cfg80211_flow_parse(TEST_SKB(test, udp_6in4),
+					      &info));
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_TRUE(test, verdict.match);
+
+	/* Without a frame, a filter classifier cannot decide the flow */
+	info.skb = NULL;
+	cfg80211_scs_evaluate(list, 1, &info, &verdict);
+	KUNIT_EXPECT_FALSE(test, verdict.match);
+	KUNIT_EXPECT_TRUE(test, verdict.undecided);
+}
+
+/* Reserved bits of a classifier are ignored, as are mask parameters */
+static void tclas_reserved(struct kunit *test)
+{
+	static const u8 vlan[] = {
+		WLAN_EID_TCLAS, 7,
+		255,
+		5, 0x07,		/* type, mask: PCP, DEI and VID */
+		0xf3,			/* PCP 3, reserved bits set */
+		0xfe,			/* DEI 0, reserved bits set */
+		0xf0, 0x64,		/* VID 100, reserved bits set */
+	};
+	static const u8 vlan_mask[] = {
+		WLAN_EID_EXTENSION, 7,
+		WLAN_EID_EXT_TCLAS_MASK,
+		5, 0x04,		/* VID */
+		0xff, 0xff, 0xff, 0xff,
+	};
+	enum cfg80211_tclas_processing processing;
+	struct cfg80211_tclas tclas;
+	u32 fields;
+
+	KUNIT_ASSERT_EQ(test, 0,
+			cfg80211_parse_tclas(vlan, sizeof(vlan), &tclas, 1,
+					     &processing));
+	KUNIT_EXPECT_EQ(test, be16_to_cpu(tclas.key.vlan_tci),
+			(3 << 13) | 100);
+
+	KUNIT_ASSERT_EQ(test, 0,
+			cfg80211_parse_tclas_mask(vlan_mask, sizeof(vlan_mask),
+						  &fields));
+	KUNIT_EXPECT_EQ(test, fields, FLOW_F(VLAN_VID));
+}
+
+/* The constraints between the elements of a downlink descriptor */
+static void scs_desc_rules(struct kunit *test)
+{
+	static const u8 one_addr[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x02,
+		4,
+		192, 168, 1, 1,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0,
+	};
+	static const u8 two_addrs_all[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x02,
+		4,
+		192, 168, 1, 1,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0,
+
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x04,
+		4,
+		0, 0, 0, 0,
+		192, 168, 1, 2,
+		0, 0, 0, 0,
+		0, 0, 0,
+
+		WLAN_EID_TCLAS_PROCESSING, 1, 0,
+	};
+	static const u8 conflict_all[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x02,
+		4,
+		192, 168, 1, 1,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0,
+
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x02,
+		4,
+		10, 0, 0, 1,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0,
+
+		WLAN_EID_TCLAS_PROCESSING, 1, 0,
+	};
+	static const u8 one_addr_any[] = {
+		WLAN_EID_TCLAS, 19,
+		255,
+		4, 0x02,
+		4,
+		192, 168, 1, 1,
+		0, 0, 0, 0,
+		0, 0, 0, 0,
+		0, 0, 0,
+
+		WLAN_EID_TCLAS_PROCESSING, 1, 1,
+	};
+	struct cfg80211_scs_desc *desc;
+
+	desc = test_scs_desc(test, 1, 5, one_addr, sizeof(one_addr));
+	KUNIT_EXPECT_TRUE(test, cfg80211_scs_desc_valid(desc));
+
+	desc->req_type = NL80211_SCS_REQ_CHANGE + 1;
+	KUNIT_EXPECT_FALSE(test, cfg80211_scs_desc_valid(desc));
+
+	desc = test_scs_desc(test, 0, 5, one_addr, sizeof(one_addr));
+	KUNIT_EXPECT_FALSE(test, cfg80211_scs_desc_valid(desc));
+
+	desc = test_scs_desc(test, 2, 5, two_addrs_all, sizeof(two_addrs_all));
+	KUNIT_EXPECT_TRUE(test, cfg80211_scs_desc_valid(desc));
+
+	/* Two elements that require different values can never match */
+	desc = test_scs_desc(test, 3, 5, conflict_all, sizeof(conflict_all));
+	KUNIT_EXPECT_FALSE(test, cfg80211_scs_desc_valid(desc));
+
+	/* A TCLAS Processing element needs more than one TCLAS element */
+	desc = test_scs_desc(test, 4, 5, one_addr_any, sizeof(one_addr_any));
+	KUNIT_EXPECT_FALSE(test, cfg80211_scs_desc_valid(desc));
+
+	/* A downlink descriptor needs a classifier */
+	desc = test_scs_desc(test, 5, 5, NULL, 0);
+	KUNIT_EXPECT_FALSE(test, cfg80211_scs_desc_valid(desc));
+
+	desc->req_type = NL80211_SCS_REQ_REMOVE;
+	KUNIT_EXPECT_TRUE(test, cfg80211_scs_desc_valid(desc));
+}
+
+static void mscs_desc_rules(struct kunit *test)
+{
+	struct cfg80211_mscs_desc desc = {
+		.req_type = NL80211_SCS_REQ_ADD,
+		.stream_timeout = 100,
+		.fields = FLOW_F(IP_VERSION) | FLOW_F(IP_SRC),
+	};
+
+	KUNIT_EXPECT_TRUE(test, cfg80211_mscs_desc_valid(&desc));
+
+	desc.req_type = NL80211_SCS_REQ_CHANGE + 1;
+	KUNIT_EXPECT_FALSE(test, cfg80211_mscs_desc_valid(&desc));
+
+	desc.req_type = NL80211_SCS_REQ_ADD;
+	desc.stream_timeout = 0;
+	KUNIT_EXPECT_FALSE(test, cfg80211_mscs_desc_valid(&desc));
+
+	desc.stream_timeout = 100;
+	desc.fields = 0;
+	KUNIT_EXPECT_FALSE(test, cfg80211_mscs_desc_valid(&desc));
+
+	desc.req_type = NL80211_SCS_REQ_REMOVE;
+	KUNIT_EXPECT_TRUE(test, cfg80211_mscs_desc_valid(&desc));
+
+	desc.fields = FLOW_F(IP_SRC);
+	KUNIT_EXPECT_FALSE(test, cfg80211_mscs_desc_valid(&desc));
+}
+
+static struct kunit_case scs_cases[] = {
+	KUNIT_CASE(flow_parse_fragment),
+	KUNIT_CASE(scs_granularity),
+	KUNIT_CASE(scs_undecided),
+	KUNIT_CASE(scs_filter),
+	KUNIT_CASE(scs_client),
+	KUNIT_CASE(flow_key_mirror),
+	KUNIT_CASE(flow_key_mirror_eth),
+	KUNIT_CASE(tclas_refused),
+	KUNIT_CASE(tclas_reserved),
+	KUNIT_CASE(qos_characteristics),
+	KUNIT_CASE(scs_traffic_description),
+	KUNIT_CASE(scs_desc_rules),
+	KUNIT_CASE(mscs_desc_rules),
+	{}
+};
+
+static struct kunit_suite scs = {
+	.name = "cfg80211-scs",
+	.test_cases = scs_cases,
+};
+
+kunit_test_suite(scs);
-- 
git-series 0.9.1
