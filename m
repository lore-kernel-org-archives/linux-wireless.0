Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51BC3530E0A
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072033; cv=none; b=iazYiO1tugZltDGBKso1jKkq3Jamrr6oJGOdGgObu3JED/l6jWM+hFMBoCc7B2sPjP8IVSdkkEG/NQv1GcCHrd56PzOQciK7KTihtgWl5HMWXSczifkBXroT8/ZkSADTdJe0HjWahkzs53sMVXQa2sP5lNvbtx143CdJlgIJ7GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072033; c=relaxed/simple;
	bh=xzzA+Wt7nOVkouBi2LP9A6jJiyFlN/t5/UMhaqQXFvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnhqoPp/rk3SONti9PagCnlsiO1NWnORvLlgxkUHkaCOT4cbHiO3hMd5G5Boe/PW7ZIAMB4fnsfH/qE+ZNpHsbcgJ5WHTIyPhztfOURD8Z3z7ifXLlIBiDC6ynUzWuX4ykgoE8FO/EfTiHgGAaJ1mQrCFiYqaCtFwdCtnxsfPFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=ALEq2PS1; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ALEq2PS1"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BIhmHN8TOOHlcpRxvWcWTEFJ+jXZVGjvhBQOaMc3CbM=; b=ALEq2PS112Skh2N+0Ym0nj4wHZ
	qo1lYPBE4nBd14T8qYQZSfajZTzqNgPwE7I3SrYt8w4lSqS0x1ZhB7nSmI2sCkyujVkuECkCoCNLq
	KFbB8xSwFHQrCsM6r5u2kO893umTG4iRGL1jmSlh7PIT1DsFlWlSizv68JllE7LbshCc=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVU-00807z-04;
	Tue, 22 Sep 2026 12:13:48 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 08/16] wifi: cfg80211: add KUnit tests for the SCS classifier
Date: Tue, 22 Sep 2026 12:13:35 +0200
Message-ID: <0a514991ba9fd2f243862a3b0a02aac61d272e37.1790071773.git-series.nbd@nbd.name>
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

Cover the cases that produce a wrong priority without a crash:

- A later IP fragment must report no ports, but still its addresses.
- A descriptor that the frame cannot satisfy must not match, and the
  parameter count must decide between two matching descriptors
  regardless of their order.
- A mirrored key must swap the addresses and the ports, the Ethernet
  addresses included, and leave every unselected field zero.
- The unsupported classifier types, and a TCLAS element with a User
  Priority other than 255, must be refused.
- A filter classifier must match on the payload it names and must not
  match on a value that the frame does not carry.
- The QoS Characteristics length check must place every optional field
  at the right offset and refuse a LinkID without a Service Start Time.
- An uplink descriptor without a classifier must pass validation.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/wireless/tests/Makefile |   2 +-
 net/wireless/tests/scs.c    | 488 +++++++++++++++++++++++++++++++++++++-
 2 files changed, 489 insertions(+), 1 deletion(-)
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
index 000000000000..d3636bd45964
--- /dev/null
+++ b/net/wireless/tests/scs.c
@@ -0,0 +1,488 @@
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
+		3, 0,
+		0, 0,
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
+	KUNIT_EXPECT_TRUE(test, QC_OK(no_link_id));
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
+	KUNIT_EXPECT_FALSE(test, QC_OK(orphan_link_id));
+	KUNIT_EXPECT_FALSE(test, QC_OK(short_elem));
+	KUNIT_EXPECT_FALSE(test, QC_OK(bad_ext_id));
+	KUNIT_EXPECT_FALSE(test, QC_OK(bad_length));
+}
+
+/* An uplink descriptor carries no classifier and no user priority */
+static void scs_traffic_description(struct kunit *test)
+{
+	/* Uplink, and a Service Start Time with no LinkID */
+	static const u8 uplink[] = {
+		0xff, 0x17, 0x71,
+		0x54, 0x05, 0x00, 0x00,
+		0xe8, 0x03, 0x00, 0x00,
+		0xd0, 0x07, 0x00, 0x00,
+		0x88, 0x13, 0x00,
+		0x20, 0x4e, 0x00,
+		0x78, 0x56, 0x34, 0x12,
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
+}
+
+static struct kunit_case scs_cases[] = {
+	KUNIT_CASE(flow_parse_fragment),
+	KUNIT_CASE(scs_granularity),
+	KUNIT_CASE(scs_filter),
+	KUNIT_CASE(flow_key_mirror),
+	KUNIT_CASE(flow_key_mirror_eth),
+	KUNIT_CASE(tclas_refused),
+	KUNIT_CASE(qos_characteristics),
+	KUNIT_CASE(scs_traffic_description),
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
