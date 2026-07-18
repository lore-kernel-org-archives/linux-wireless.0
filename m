Received: from out03-fra1-mx.uberspace.de (out03-fra1-mx.uberspace.de [185.139.157.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D5E239E60;
	Sat, 18 Jul 2026 21:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.139.157.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784408620; cv=none; b=Ab5zuu9NCb5A692ZmqYmVs1nTaOF226tmGo1MtBpbcvo7v/r59XUv3/w9jxVNYTHjUT/GRCZDX0A3XQWJAIYqgFFR0Mwry/hOxBr5I8Cx+UkL55dHLHU+ttcuqqjJPPR0r6lTeMF09252YbNd/5cKeWIDzVz5n7jbJuO1n7F5KY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784408620; c=relaxed/simple;
	bh=ONcdZmbjJEb2MeMuccgWJurxdBOkHwApK+mGkTXHb5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IBd8obj+Il06wCgi3+asUYfKgrJzNfeKxw6ban24tCLjYdwantFSGF8ULpPNm53gs9tmvLxoiMWuw3VFdTjuMRxrhWW51lxjGmVaf3VD/WeEyzFgrsNXYFxIAyK4+mS+h8PRAWeKpSmomj333Bgg0RIV5AjOrEzz0iojmaUTLcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de; spf=pass smtp.mailfrom=plantwatch.de; dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b=OFX+yHjE; arc=none smtp.client-ip=185.139.157.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=plantwatch.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=plantwatch.de header.i=@plantwatch.de header.b="OFX+yHjE"
Received: from janus.uberspace.de (janus.uberspace.de [IPv6:2a0b:20c0:2000:62:be24:11ff:fe50:5107])
	by out03-fra1-mx.uberspace.de (Postfix) with ESMTPS id CE194100090;
	Sat, 18 Jul 2026 23:03:20 +0200 (CEST)
From: Simon Dietz <simon.dietz@plantwatch.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plantwatch.de;
	s=uberspace1; t=1784408599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n47nuNsa+S1XDnrzcd1teuNlNFw6kiCbQqhhLfZG7u8=;
	b=OFX+yHjEDpKWJQwRco1h2yceTm0aXHgkcL/SqOU2kJ524ICzy2f5p9vOFyv6IdP5rHtlUc
	7FyeL+XlJwipieMBg3OTfig073UVfP+4Z8BQ+jwy/+PQW+/qOeHNb+7qBsP/BbtUVjzXI0
	RNkvZHPg5Uo3BUZkbdYJ8h/WQ2lnnceFwoRXfGF6RLJWRsBYKJZF78VK1jxqbSEfqc07jC
	HsNKVvklSDu4Jh1V1mB8Tbl7wfL8/e/zkErzj+Uf7l2q8+6GAWlW6TcYnZVEBA8VSC5dVg
	CTiRQfkib2y9XfVmz0XHLJ/aMeZ0tgaYQzhVJ59OCU4+N3HTi6HkUWYxEX0lfA==
Authentication-Results: ORIGINATING;
	auth=pass smtp.auth=simon.dietz@plantwatch.de smtp.mailfrom=simon.dietz@plantwatch.de
To: netdev@vger.kernel.org
Cc: andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	johannes@sipsolutions.net,
	kuniyu@google.com,
	linux-wireless@vger.kernel.org,
	simon.dietz@plantwatch.de,
	dietz23838@hs-ansbach.de
Subject: [RFC PATCH net-next v0.1 1/1] net: add GeoNetworking protocol
Date: Sat, 18 Jul 2026 23:00:33 +0200
Message-ID: <20260718210046.2357882-2-simon.dietz@plantwatch.de>
In-Reply-To: <20260718210046.2357882-1-simon.dietz@plantwatch.de>
References: <20260718210046.2357882-1-simon.dietz@plantwatch.de>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [2.34 / 999.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	MIME_GOOD(-0.10)[text/plain];
	BAYES_HAM(-0.06)[61.72%];
	RCVD_COUNT_ZERO(0.00)[0];
	ARC_NA(0.00)[];
	TAGGED_RCPT(0.00)[netdev];
	RCPT_COUNT_SEVEN(0.00)[9];
	ASN(0.00)[asn:3320, ipnet:2003::/19, country:DE];
	ALIAS_RESOLVED(0.00)[];
	DKIM_SIGNED(0.00)[plantwatch.de:s=uberspace1];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	LOCAL_OUTBOUND(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TO_DN_NONE(0.00)[];
	MIME_TRACE(0.00)[0:+]

Implement the GeoNetworking / ETSI ITS-G5 ('net/gn') protocol which
is based on 802.11p wifi and used for vehicle2x applications. It is
standardized by the ETSI and used by some car manufacturers
(especially in europe). It enables ad-hoc, multi-hop geographical
communication and routing among vehicles (and road- or railside
infrastructure).

Most work of this implementation has been done by the bachelor
project 2018/2019 of the operating systems and middleware group of
the Hasso Plattner Institute, University of Potsdam, which the author
was part of.

The code is published under the GPL v2 at this location:
https://gitlab.com/hpi-potsdam/osm/g5-on-linux/linux-geonetworking/

This patch set is not merge-ready, yet. E.g. network namespaces are
not supported at all, documentation is missing, ...

Purpose of this RFC is to determine if GeoNetworking support in the
linux kernel is desirable and if so what steps would have to be done
next.

In the original implementation new ioctl calls have been used. For the
removal of them and changing their functionality to use netlink (and
only this change) help of AI has been used as stated below.

Signed-off-by: Simon Dietz <simon.dietz@plantwatch.de>
Assisted-by: Gemini:gemini-3.1-pro antigravity-ide
---
 include/linux/gn.h                  |  363 +++++
 include/linux/gn_routing.h          |   68 +
 include/linux/socket.h              |    6 +-
 include/uapi/linux/gn.h             |   84 ++
 include/uapi/linux/if_ether.h       |    1 +
 include/uapi/linux/if_link.h        |   10 +
 net/Kconfig                         |    2 +
 net/Makefile                        |    1 +
 net/gn/Kconfig                      |    4 +
 net/gn/Makefile                     |    7 +
 net/gn/gn_netlink.c                 |  266 ++++
 net/gn/gn_prot.c                    | 1908 +++++++++++++++++++++++++++
 net/gn/gn_routing.c                 |  646 +++++++++
 net/gn/sysctl_net_gn.c              |   33 +
 security/selinux/hooks.c            |    5 +-
 security/selinux/include/classmap.h |    3 +-
 16 files changed, 3403 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/gn.h
 create mode 100644 include/linux/gn_routing.h
 create mode 100644 include/uapi/linux/gn.h
 create mode 100644 net/gn/Kconfig
 create mode 100644 net/gn/Makefile
 create mode 100644 net/gn/gn_netlink.c
 create mode 100644 net/gn/gn_prot.c
 create mode 100644 net/gn/gn_routing.c
 create mode 100644 net/gn/sysctl_net_gn.c

diff --git a/include/linux/gn.h b/include/linux/gn.h
new file mode 100644
index 000000000000..5940e3d85cae
--- /dev/null
+++ b/include/linux/gn.h
@@ -0,0 +1,363 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __LINUX_GN_H__
+#define __LINUX_GN_H__
+
+#include <net/sock.h>
+#include <uapi/linux/gn.h>
+#include <linux/types.h>
+#include <linux/atomic.h>
+#include <linux/bitfield.h>
+#include <asm/byteorder.h>
+#include <linux/etherdevice.h>
+
+#define GN_MAX_HEADER_SZ 88
+#define GN_MAXSZ (ETH_DATA_LEN - GN_MAX_HEADER_SZ)
+#define GN_MAXHOPS 255 /* 8 bits of hop counter */
+
+#define GN_VERSION 1
+#define GN_BROADCAST_ADDR 0xffffffffffffULL
+/* itsGnDefaultHopLimit: Default hop limit (for BH RHL/CH MHL) */
+#define DEFAULT_HOP_LIMIT 10
+
+/* UNIX timestamp in ms for the ETSI ITS Epoch (2004-01-01 00:00:00 TAI).
+ * 1072915200000 ms (2004-01-01 UTC) + 32000 ms (32 leap seconds).
+ */
+#define GN_EPOCH_UNIX_MS 1072915232000LLU
+
+/* time until location table entry becomes invalid */
+#define GN_LOC_TE_LIFETIME 20000
+/* time between two beacons */
+#define GN_BEACON_RETRANSMIT_TIME 3000
+/* time between retransmits of an unanswered location service request */
+#define GN_LS_RETRANSMIT_TIME 1000
+
+/* sizes in KiB */
+#define GN_UC_BUF_SIZE 256
+#define GN_BC_BUF_SIZE 1024
+#define GN_CBF_BUF_SIZE 256
+
+#define GN_UC_BUF 0
+#define GN_BC_BUF 1
+#define GN_CBF_BUF 2
+
+#define BH_NH_ANY 0
+#define BH_NH_COMMON_HEADER 1
+#define BH_NH_SECURED_PACKET 2
+
+#define GN_LT_BASE_50MS  (0 << 6)
+#define GN_LT_BASE_1S    (1 << 6)
+#define GN_LT_BASE_10S   (2 << 6)
+#define GN_LT_BASE_100S  (3 << 6)
+#define GN_ENCODE_LT(base, mult) ((base) | ((mult) & 0x3f))
+
+/* itsGnDefaultPacketLifetime: Default packet lifetime encoded as 60s (Base=1s, Mult=60) */
+#define BH_LT_DEFAULT GN_ENCODE_LT(GN_LT_BASE_1S, 60)
+
+#define CH_NH_ANY 0
+#define CH_NH_BTPA 1
+#define CH_NH_BTPB 2
+#define CH_NH_IPV6 3
+
+#define CH_FLAG_MOBILE (1 << 7)
+
+/* itsGnDefaultTrafficClass: Default traffic class */
+#define CH_TC_DEFAULT 0
+
+#define CH_HT_BEACON 1
+#define CH_HT_GUC 2
+#define CH_HT_GAC 3
+#define CH_HT_GBC 4
+#define CH_HT_TSB 5
+#define CH_HT_LS 6
+
+#define CH_HST_GABC_CIRCLE 0
+#define CH_HST_GABC_RECT 1
+#define CH_HST_GABC_ELIP 2
+
+#define CH_HST_TSB_SINGLE_HOP 0
+#define CH_HST_TSB_MULTI_HOP 1
+
+#define CH_HST_LS_REQUEST 0
+#define CH_HST_LS_REPLY 1
+
+#define CH_HST_UNSPECIFIED 0
+#define CH_HST_BEACON 1
+
+#define CH_PL_EMPTY 0L
+#define BEACON_MHL 1
+
+#define GN_BASE_HEADER_SIZE \
+	(sizeof(struct gn_basic_header) + sizeof(struct gn_common_header))
+#define GN_SET_BTP(skb, btp_h, extended_header_type)                         \
+	do {                                                                 \
+		skb_set_transport_header(                                    \
+			skb,                                                 \
+			GN_BASE_HEADER_SIZE + sizeof(extended_header_type)); \
+		btp_h = (struct btp_header *)skb_transport_header(skb);      \
+	} while (0)
+
+#define GN_GUC_HLEN sizeof(struct gn_guc_header)
+#define GN_GXC_HLEN sizeof(struct gn_gxc_header)
+#define GN_SHB_HLEN sizeof(struct gn_shb_header)
+#define GN_TSB_HLEN sizeof(struct gn_tsb_header)
+#define GN_BEACON_HLEN sizeof(struct gn_beacon_header)
+#define GN_LS_REQUEST_HLEN sizeof(struct gn_ls_request_header)
+#define GN_LS_REPLY_HLEN sizeof(struct gn_ls_reply_header)
+#define BTP_HLEN sizeof(struct btp_header)
+
+/**
+ *	struct gn_iface - GeoNetworking interface
+ *	@dev - Network device associated with this interface
+ *	@address - Our address
+ *	@local_sn - Current sequence number
+ */
+struct gn_iface {
+	struct net_device	*dev;
+	gn_address_t	address;
+	struct gn_position pos;
+	atomic_t local_sn;
+	struct hlist_node hnode;
+	struct rcu_head rcu;
+};
+
+struct gn_sock {
+	/* struct sock has to be the first member of gn_sock */
+	struct sock	sk;
+	struct gn_scope scope;
+	gn_address_t src_addr;
+	gn_address_t dst_addr;
+	u16 src_port;
+	u16 dst_port;
+	u8 protocol;
+};
+
+static inline struct gn_sock *gn_sk(struct sock *sk)
+{
+	return (struct gn_sock *)sk;
+}
+
+struct btp_header {
+	__be16 dst_port;
+	__be16 src_port;
+} __packed;
+
+enum ITS_TYPE {
+	UNKNOWN,
+	PEDESTRIAN,
+	CYCLIST,
+	MOPED,
+	MOTORCYCLE,
+	PASSENGER_CAR,
+	BUS,
+	LIGHT_TRUCK,
+	HEAVY_TRUCK,
+	TAILER,
+	SPECIAL_VEHICLE,
+	TRAM,
+	ROAD_SIDE_UNIT
+};
+
+#define GN_ADDRESS_M BIT(63)
+#define GN_ADDRESS_ST GENMASK(62, 58)
+#define GN_ADDRESS_RES GENMASK(57, 48)
+#define GN_ADDRESS_MID GENMASK(47, 0)
+
+typedef __be16 gn_spai_t;
+
+#define GN_LPV_PAI BIT(15)
+#define GN_LPV_S GENMASK(14, 0)
+
+struct gn_lpv {
+	gn_address_t addr;
+	__be32 tst;
+	__be32 lat;
+	__be32 lon;
+	gn_spai_t spai;
+	__be16 h; //signed
+} __packed;
+
+struct gn_spv {
+	gn_address_t addr;
+	__be32 tst;
+	__be32 lat; //short
+	__be32 lon;
+} __packed;
+
+/*version: Identifies the version of the GeoNetworking protocol
+ *
+ *nh: Identifies the type of header immediately following the GeoNetworking
+ *    Basic Header
+ *reserved: Reserved. Set to 0
+ *
+ *lt: Lifetime field.
+ *Indicates the maximum tolerable time a packet may be buffered until it
+ *reaches its destination Bit 0 to Bit 5:
+ *lt_sub:
+ *0) 50 ms
+ *1) 1s
+ *2) 10 s
+ *3) 100 s
+ *4) 600 s
+ *5) 1000s
+ *
+ *Bit 6 to Bit 11:
+ *lt_mul: Multiplier for lt_sub, between 0 and 63
+ *
+ *rhl: Remaining hop limit. Set to the maximum hop limit (mhl) initially and
+ *decremented by 1 at each hop.
+ *The packet is dropped when rhl reaches 0
+ */
+struct gn_basic_header {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 nh : 4;
+	__u8 version : 4;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8 version : 4;
+	__u8 nh : 4;
+#else
+#error "please fix asm/byteorder.h"
+#endif
+	__u8 reserved;
+	__u8 lt;
+	__u8 rhl;
+} __packed;
+
+struct gn_common_header {
+#if defined(__LITTLE_ENDIAN_BITFIELD)
+	__u8 reserved : 4;
+	__u8 nh : 4;
+	__u8 hst : 4;
+	__u8 ht : 4;
+#elif defined(__BIG_ENDIAN_BITFIELD)
+	__u8 nh : 4;
+	__u8 reserved : 4;
+	__u8 ht : 4;
+	__u8 hst : 4;
+#else
+#error "please fix asm/byteorder.h"
+#endif
+
+	__u8 tc;
+	__u8 flags;
+	__be16 pl;
+	__u8 mhl;
+	__u8 reserved2;
+} __packed;
+
+/*there are 6 types of headers:
+ * 1) GUC packet header (clause 9.8.2).
+ * 2) TSB packet header (clause 9.8.3).
+ * 3) SHB packet header (clause 9.8.4).
+ * 4) GBC and GAC packet headers (clause 9.8.5).
+ * 5) BEACON packet header (clause 9.8.6).
+ * 6) LS Request and LS Reply packet headers (clause 9.8.7 and clause 9.8.8).
+ */
+
+struct gn_guc_header {
+	__be16 sn;
+	__be16 reserved;
+	struct gn_lpv sopv;
+	struct gn_spv depv;
+} __packed;
+
+struct gn_tsb_header {
+	__be16 sn;
+	__be16 reserved;
+	struct gn_lpv sopv;
+} __packed;
+
+struct gn_shb_header {
+	struct gn_lpv sopv;
+	__be32 mdd;
+} __packed;
+
+/* GAC and GBC share the same header structure */
+struct gn_gxc_header {
+	__be16 sn;
+	__be16 reserved;
+	struct gn_lpv sopv;
+	__be32 gap_lat; //signed
+	__be32 gap_lon; //signed
+	__be16 da;
+	__be16 db;
+	__be16 angle;
+	__be16 reserved2;
+} __packed;
+
+#define gn_gac_header gn_gxc_header
+#define gn_gbc_header gn_gxc_header
+
+struct gn_beacon_header {
+	struct gn_lpv sopv;
+} __packed;
+
+struct gn_ls_request_header {
+	__be16 sn;
+	__be16 reserved;
+	struct gn_lpv sopv;
+	gn_address_t addr;
+} __packed;
+
+//same structure as gn_guc_header, left in for abstraction
+struct gn_ls_reply_header {
+	__be16 sn;
+	__be16 reserved;
+	struct gn_lpv sopv;
+	struct gn_spv depv;
+} __packed;
+
+struct gn_header {
+	struct gn_basic_header gb_h;
+	struct gn_common_header gc_h;
+	union {
+		struct gn_guc_header guc_h;
+		union {
+			struct gn_gxc_header gac_h;
+			struct gn_gxc_header gbc_h;
+		};
+		struct gn_tsb_header tsb_h;
+		struct gn_shb_header shb_h;
+		struct gn_beacon_header beacon_h;
+		struct gn_ls_request_header ls_request_h;
+		struct gn_ls_reply_header ls_reply_h;
+		__be16 sn;
+	};
+} __packed;
+
+/* Inter module exports */
+
+u32 gn_tai_to_gn(ktime_t tai_time);
+u32 gn_timestamp_now(void);
+
+void gn_fill_sopv(struct gn_iface *gnif, struct gn_lpv *sopv,
+		  gn_address_t addr);
+
+extern struct hlist_head gn_sockets;
+extern rwlock_t gn_sockets_lock;
+
+extern struct hlist_head gn_interfaces;
+extern spinlock_t gn_interfaces_lock;
+
+struct gn_iface *gn_if_add_device(struct net_device *dev,
+				  struct sockaddr_gn *sa);
+void gn_if_drop_device(struct net_device *dev);
+int gn_validate_pos(struct gn_position *pos);
+
+int gn_netlink_init(void);
+void gn_netlink_exit(void);
+
+#ifdef CONFIG_SYSCTL
+extern int gn_register_sysctl(void);
+extern void gn_unregister_sysctl(void);
+#else
+static inline int gn_register_sysctl(void)
+{
+	return 0;
+}
+static inline void gn_unregister_sysctl(void)
+{
+}
+#endif
+
+#endif /* __LINUX_GN_H__ */
diff --git a/include/linux/gn_routing.h b/include/linux/gn_routing.h
new file mode 100644
index 000000000000..64ccc80f5a90
--- /dev/null
+++ b/include/linux/gn_routing.h
@@ -0,0 +1,68 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef __LINUX_GN_ROUTING_H__
+#define __LINUX_GN_ROUTING_H__
+
+#include <linux/gn.h>
+#include <linux/types.h>
+#include <linux/if_ether.h>
+
+#define GN_MAX_PDR_EMA_BETA 90
+#define GN_MAX_PDR 100
+#define GN_DPL_SIZE 8
+#define GN_LSB_SIZE 16	// this is the number of entries per entry (has to be a power of 2 atm)
+			// ETSI sets a maximum of 1024 octets/bytes, which is not trivial to maintain
+
+#define GN_NON_AREA_FORWARDING_UNSPECIFIED	0
+#define GN_NON_AREA_FORWARDING_GREEDY		1
+#define GN_NON_AREA_FORWARDING_CBF		2
+#define GN_NON_AREA_FORWARDING GN_NON_AREA_FORWARDING_GREEDY
+
+#define GN_AREA_FORWARDING_UNSPECIFIED	0
+#define GN_AREA_FORWARDING_SIMPLE	1
+#define GN_AREA_FORWARDING_CBF		2
+#define GN_AREA_FORWARDING_ADVANCED	3
+#define GN_AREA_FORWARDING GN_AREA_FORWARDING_SIMPLE
+
+#define GN_QUEUE_DIRECT		0
+#define GN_QUEUE_LS_PENDING	1
+#define GN_QUEUE_LS_STALE	2
+#define GN_QUEUE_ERROR		3
+
+#define GN_FORWARD_BROADCAST	0
+#define GN_FORWARD_NEXT_HOP	1
+#define GN_FORWARD_BUFFER	2
+#define GN_FORWARD_DISCARD	3
+
+struct gn_dpd_buf {
+	u16 sn[GN_DPL_SIZE];
+	u8 head;
+};
+
+struct loc_te {
+	gn_address_t addr;
+	u8 ll_address[ETH_ALEN];
+	struct gn_lpv pv;
+	struct gn_dpd_buf dpl;
+	struct sk_buff_head lsb;
+	u32 tst_addr;
+	u32 pdr;
+	struct hlist_node hnode;
+	u8 ls_pending: 1;
+	u8 is_neighbour: 1;
+};
+
+s64 gn_F(struct gn_coord self, struct gn_geo_scope scope);
+int gn_gxc_forward(struct gn_iface *gnif, s64 f, u8 *addr, struct gn_lpv *depv);
+
+struct gn_iface *gn_find_interface(gn_address_t addr);
+struct gn_iface *gn_find_interface_by_dev(struct net_device *dev);
+int gn_query_ll_address(gn_address_t addr, u8 *ll_address);
+int gn_query_ll_nexthop(struct gn_iface *gnif, gn_address_t query_addr, u8 *ll_address);
+int gn_fill_depv(struct gn_spv *depv, gn_address_t dest_addr);
+int gn_ls_queue(gn_address_t dest_addr, struct sk_buff *skb);
+void gn_ls_flush(gn_address_t dest_addr);
+int gn_update_location_table(struct gn_lpv *pv, bool make_neighbour, const u8 *ll_address, const __be16 *sn);
+void gn_routing_exit(void);
+
+#endif // __LINUX_GN_ROUTING_H__
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 2a8d7b14f1d1..17d8c466f120 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -254,8 +254,8 @@ struct ucred {
 #define AF_MCTP		45	/* Management component
 				 * transport protocol
 				 */
-
-#define AF_MAX		46	/* For now.. */
+#define AF_GN		46	/* ETSI ITS GeoNetworking */
+#define AF_MAX		47	/* For now.. */
 
 /* Protocol families, same as address families. */
 #define PF_UNSPEC	AF_UNSPEC
@@ -306,6 +306,7 @@ struct ucred {
 #define PF_SMC		AF_SMC
 #define PF_XDP		AF_XDP
 #define PF_MCTP		AF_MCTP
+#define PF_GN		AF_GN
 #define PF_MAX		AF_MAX
 
 /* Maximum queue length specifiable by listen.  */
@@ -400,6 +401,7 @@ struct ucred {
 #define SOL_MCTP	285
 #define SOL_SMC		286
 #define SOL_VSOCK	287
+#define SOL_GN		288
 
 /* IPX options */
 #define IPX_TYPE	1
diff --git a/include/uapi/linux/gn.h b/include/uapi/linux/gn.h
new file mode 100644
index 000000000000..96cafbda54de
--- /dev/null
+++ b/include/uapi/linux/gn.h
@@ -0,0 +1,84 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI__LINUX_GN_H__
+#define _UAPI__LINUX_GN_H__
+
+#include <linux/types.h>
+#include <asm/byteorder.h>
+#include <linux/socket.h>
+
+#include <linux/time_types.h>
+
+/*
+ * GeoNetworking structures
+ *
+ */
+#define GNPORT_ANY	0
+#define GNPORT_FIRST	1
+#define GNPORT_RESERVED	3000
+#define GNPORT_LAST	65535
+
+#define GNADDR_BROADCAST 0x0000FFFFFFFFFFFFLLU
+
+/* Valid protocols */
+#define GN_PROTO_ANY	0
+#define GN_PROTO_BTP_A	1
+#define GN_PROTO_BTP_B	2
+#define GN_PROTO_INET6	3
+#define GN_PROTO_MAX	GN_PROTO_INET6
+
+/* protocol-specific ioctls */
+#define SIOCGNSPOSITION			(SIOCPROTOPRIVATE + 0)
+
+/* gn_position flags */
+#define GN_POSITION_MOBILE		(1 << 0)
+
+/* {get,set}sockopt options */
+#define GN_SCOPE 1
+
+#define GN_SCOPE_UNSPECIFIED		0
+#define GN_SCOPE_TOPOLOGICAL		1
+#define GN_SCOPE_GEOGRAPHICAL		2
+#define GN_SCOPE_GEOGRAPHICAL_ANYCAST	3
+#define GN_SCOPE_MAX			GN_SCOPE_GEOGRAPHICAL_ANYCAST
+
+#define GN_SHAPE_UNSPECIFIED	0
+#define GN_SHAPE_CIRCLE		1
+#define GN_SHAPE_ELLIPSE	2
+#define GN_SHAPE_RECTANGLE	3
+
+typedef __be64 gn_address_t;
+
+struct gn_coord {
+	__s32 lat;
+	__s32 lon;
+};
+
+struct gn_geo_scope {
+	struct gn_coord coord;
+	__u16 angle;
+	__u16 a, b;
+	__u8 shape;
+};
+
+struct gn_scope {
+	__u8 scope_type;
+	union {
+		__u8 topo_hops;
+		struct gn_geo_scope geo_scope;
+	};
+};
+
+struct gn_position {
+	struct __kernel_timespec tst;
+	struct gn_coord coord;
+	__u8 flags;
+};
+
+struct sockaddr_gn {
+	__kernel_sa_family_t sgn_family;
+	gn_address_t sgn_addr;
+	__u16 sgn_port;
+} __packed;
+
+#endif /* _UAPI__LINUX_GN_H__ */
diff --git a/include/uapi/linux/if_ether.h b/include/uapi/linux/if_ether.h
index 1ffac52c39df..e7b0baa0d15b 100644
--- a/include/uapi/linux/if_ether.h
+++ b/include/uapi/linux/if_ether.h
@@ -113,6 +113,7 @@
 #define ETH_P_FIP	0x8914		/* FCoE Initialization Protocol */
 #define ETH_P_80221	0x8917		/* IEEE 802.21 Media Independent Handover Protocol */
 #define ETH_P_HSR	0x892F		/* IEC 62439-3 HSRv1	*/
+#define ETH_P_GN	0x8947		/* ETSI-ITS Network Header */
 #define ETH_P_NSH	0x894F		/* Network Service Header */
 #define ETH_P_LOOPBACK	0x9000		/* Ethernet loopback packet, per IEEE 802.3 */
 #define ETH_P_QINQ1	0x9100		/* deprecated QinQ VLAN [ NOT AN OFFICIALLY REGISTERED ID ] */
diff --git a/include/uapi/linux/if_link.h b/include/uapi/linux/if_link.h
index 43cecca49f01..6fe5276b1998 100644
--- a/include/uapi/linux/if_link.h
+++ b/include/uapi/linux/if_link.h
@@ -2074,4 +2074,14 @@ enum {
 
 #define IFLA_OVPN_MAX	(__IFLA_OVPN_MAX - 1)
 
+/* GN section */
+
+enum {
+	IFLA_GN_UNSPEC,
+	IFLA_GN_POSITION,
+	__IFLA_GN_MAX,
+};
+
+#define IFLA_GN_MAX (__IFLA_GN_MAX - 1)
+
 #endif /* _UAPI_LINUX_IF_LINK_H */
diff --git a/net/Kconfig b/net/Kconfig
index e38477393551..b49b1e04b0da 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -26,6 +26,8 @@ menuconfig NET
 
 if NET
 
+source "net/gn/Kconfig"
+
 config WANT_COMPAT_NETLINK_MESSAGES
 	bool
 	help
diff --git a/net/Makefile b/net/Makefile
index 5b2dd7f07a85..bd3be868b2d8 100644
--- a/net/Makefile
+++ b/net/Makefile
@@ -75,3 +75,4 @@ obj-$(CONFIG_MPTCP)		+= mptcp/
 obj-$(CONFIG_MCTP)		+= mctp/
 obj-$(CONFIG_NET_HANDSHAKE)	+= handshake/
 obj-$(CONFIG_NET_SHAPER)	+= shaper/
+obj-$(CONFIG_GN)		+= gn/
diff --git a/net/gn/Kconfig b/net/gn/Kconfig
new file mode 100644
index 000000000000..4857e43f02c5
--- /dev/null
+++ b/net/gn/Kconfig
@@ -0,0 +1,4 @@
+config GN
+    tristate "Enable GeoNetworking support"
+    default y
+    select LLC
diff --git a/net/gn/Makefile b/net/gn/Makefile
new file mode 100644
index 000000000000..d8452508a162
--- /dev/null
+++ b/net/gn/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for the Linux GeoNetworking layer.
+#
+
+obj-$(CONFIG_GN) += gn.o
+gn-y			:= gn_prot.o gn_routing.o gn_netlink.o
+gn-$(CONFIG_SYSCTL)	+= sysctl_net_gn.o
diff --git a/net/gn/gn_netlink.c b/net/gn/gn_netlink.c
new file mode 100644
index 000000000000..96cb89ea5c42
--- /dev/null
+++ b/net/gn/gn_netlink.c
@@ -0,0 +1,266 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * GeoNetworking Netlink interface
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/netlink.h>
+#include <linux/rtnetlink.h>
+#include <linux/if_link.h>
+#include <linux/if_addr.h>
+#include <linux/if_arp.h>
+#include <linux/slab.h>
+#include <linux/rculist.h>
+#include <linux/gn.h>
+#include <linux/gn_routing.h>
+#include <net/sock.h>
+
+static const struct nla_policy ifa_gn_policy[IFA_MAX + 1] = {
+	[IFA_ADDRESS]		= { .type = NLA_U64 },
+	[IFA_LOCAL]		= { .type = NLA_U64 },
+};
+
+static int gn_rtm_newaddr(struct sk_buff *skb, struct nlmsghdr *nlh,
+			  struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nlattr *tb[IFA_MAX + 1];
+	struct net_device *dev;
+	struct sockaddr_gn sa;
+	struct gn_iface *gnif;
+	struct ifaddrmsg *ifm;
+	gn_address_t *addr;
+	int rc;
+
+	rc = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, ifa_gn_policy, extack);
+	if (rc < 0)
+		return rc;
+
+	ifm = nlmsg_data(nlh);
+	if (ifm->ifa_family != AF_GN)
+		return -EPFNOSUPPORT;
+
+	if (tb[IFA_LOCAL])
+		addr = nla_data(tb[IFA_LOCAL]);
+	else if (tb[IFA_ADDRESS])
+		addr = nla_data(tb[IFA_ADDRESS]);
+	else
+		return -EINVAL;
+
+	dev = __dev_get_by_index(net, ifm->ifa_index);
+	if (!dev)
+		return -ENODEV;
+
+	if (dev->type != ARPHRD_ETHER)
+		return -EINVAL;
+
+	if (gn_find_interface_by_dev(dev))
+		return -EEXIST;
+
+	memset(&sa, 0, sizeof(sa));
+	sa.sgn_family = AF_GN;
+	sa.sgn_addr = *addr;
+	sa.sgn_port = GNPORT_ANY;
+
+	gnif = gn_if_add_device(dev, &sa);
+	if (!gnif)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static int gn_rtm_deladdr(struct sk_buff *skb, struct nlmsghdr *nlh,
+			  struct netlink_ext_ack *extack)
+{
+	struct net *net = sock_net(skb->sk);
+	struct nlattr *tb[IFA_MAX + 1];
+	struct net_device *dev;
+	struct ifaddrmsg *ifm;
+	int rc;
+
+	rc = nlmsg_parse(nlh, sizeof(*ifm), tb, IFA_MAX, ifa_gn_policy, extack);
+	if (rc < 0)
+		return rc;
+
+	ifm = nlmsg_data(nlh);
+	if (ifm->ifa_family != AF_GN)
+		return -EPFNOSUPPORT;
+
+	dev = __dev_get_by_index(net, ifm->ifa_index);
+	if (!dev)
+		return -ENODEV;
+
+	if (!gn_find_interface_by_dev(dev))
+		return -EADDRNOTAVAIL;
+
+	gn_if_drop_device(dev);
+	return 0;
+}
+
+static int gn_fill_addrinfo(struct sk_buff *skb, struct gn_iface *gnif,
+			    int msg_type, u32 portid, u32 seq, int flag)
+{
+	struct ifaddrmsg *hdr;
+	struct nlmsghdr *nlh;
+
+	nlh = nlmsg_put(skb, portid, seq, msg_type, sizeof(*hdr), flag);
+	if (!nlh)
+		return -EMSGSIZE;
+
+	hdr = nlmsg_data(nlh);
+	memset(hdr, 0, sizeof(*hdr));
+	hdr->ifa_family = AF_GN;
+	hdr->ifa_prefixlen = 0;
+	hdr->ifa_flags = 0;
+	hdr->ifa_scope = 0;
+	hdr->ifa_index = gnif->dev->ifindex;
+
+	if (nla_put_u64_64bit(skb, IFA_LOCAL, gnif->address, IFA_UNSPEC) ||
+	    nla_put_u64_64bit(skb, IFA_ADDRESS, gnif->address, IFA_UNSPEC)) {
+		nlmsg_cancel(skb, nlh);
+		return -EMSGSIZE;
+	}
+
+	nlmsg_end(skb, nlh);
+	return 0;
+}
+
+static int gn_dump_addrinfo(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct net *net = sock_net(skb->sk);
+	struct ifaddrmsg *hdr;
+	struct gn_iface *gnif;
+	int ifindex = 0;
+	int idx = 0;
+	int s_idx = cb->args[0];
+	int rc = 0;
+
+	hdr = nlmsg_payload(cb->nlh, sizeof(*hdr));
+	if (hdr)
+		ifindex = hdr->ifa_index;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(gnif, &gn_interfaces, hnode) {
+		if (!net_eq(dev_net(gnif->dev), net))
+			continue;
+		if (ifindex && ifindex != gnif->dev->ifindex)
+			continue;
+		if (idx < s_idx) {
+			idx++;
+			continue;
+		}
+		rc = gn_fill_addrinfo(skb, gnif, RTM_NEWADDR,
+				      NETLINK_CB(cb->skb).portid,
+				      cb->nlh->nlmsg_seq, NLM_F_MULTI);
+		if (rc < 0)
+			break;
+		idx++;
+	}
+	rcu_read_unlock();
+
+	cb->args[0] = idx;
+	return skb->len;
+}
+
+static const struct nla_policy ifla_gn_policy[IFLA_GN_MAX + 1] = {
+	[IFLA_GN_POSITION]	= NLA_POLICY_EXACT_LEN(sizeof(struct gn_position)),
+};
+
+static int gn_fill_link_af(struct sk_buff *skb, const struct net_device *dev,
+			   u32 ext_filter_mask)
+{
+	struct gn_iface *gnif;
+
+	gnif = gn_find_interface_by_dev((struct net_device *)dev);
+	if (!gnif)
+		return -ENODATA;
+
+	if (nla_put(skb, IFLA_GN_POSITION, sizeof(gnif->pos), &gnif->pos))
+		return -EMSGSIZE;
+
+	return 0;
+}
+
+static size_t gn_get_link_af_size(const struct net_device *dev,
+				  u32 ext_filter_mask)
+{
+	struct gn_iface *gnif;
+
+	gnif = gn_find_interface_by_dev((struct net_device *)dev);
+	if (!gnif)
+		return 0;
+
+	return nla_total_size(sizeof(struct gn_position));
+}
+
+static int gn_set_link_af(struct net_device *dev, const struct nlattr *attr,
+			  struct netlink_ext_ack *extack)
+{
+	struct nlattr *tb[IFLA_GN_MAX + 1];
+	struct gn_position pos;
+	struct gn_iface *gnif;
+	int rc;
+
+	rc = nla_parse_nested(tb, IFLA_GN_MAX, attr, ifla_gn_policy, extack);
+	if (rc < 0)
+		return rc;
+
+	if (!tb[IFLA_GN_POSITION])
+		return 0;
+
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (nla_len(tb[IFLA_GN_POSITION]) < sizeof(struct gn_position))
+		return -EINVAL;
+
+	memcpy(&pos, nla_data(tb[IFLA_GN_POSITION]), sizeof(pos));
+	rc = gn_validate_pos(&pos);
+	if (rc < 0)
+		return rc;
+
+	gnif = gn_find_interface_by_dev(dev);
+	if (!gnif)
+		return -EADDRNOTAVAIL;
+
+	memcpy(&gnif->pos, &pos, sizeof(pos));
+	return 0;
+}
+
+static struct rtnl_af_ops gn_af_ops __read_mostly = {
+	.family			= PF_GN,
+	.fill_link_af		= gn_fill_link_af,
+	.get_link_af_size	= gn_get_link_af_size,
+	.set_link_af		= gn_set_link_af,
+};
+
+static const struct rtnl_msg_handler gn_rtnl_msg_handlers[] = {
+	{ .owner = THIS_MODULE, .protocol = PF_GN, .msgtype = RTM_NEWADDR,
+	  .doit = gn_rtm_newaddr },
+	{ .owner = THIS_MODULE, .protocol = PF_GN, .msgtype = RTM_DELADDR,
+	  .doit = gn_rtm_deladdr },
+	{ .owner = THIS_MODULE, .protocol = PF_GN, .msgtype = RTM_GETADDR,
+	  .dumpit = gn_dump_addrinfo },
+};
+
+int __init gn_netlink_init(void)
+{
+	int err;
+
+	err = rtnl_af_register(&gn_af_ops);
+	if (err)
+		return err;
+
+	err = rtnl_register_many(gn_rtnl_msg_handlers);
+	if (err)
+		rtnl_af_unregister(&gn_af_ops);
+
+	return err;
+}
+
+void gn_netlink_exit(void)
+{
+	rtnl_unregister_many(gn_rtnl_msg_handlers);
+	rtnl_af_unregister(&gn_af_ops);
+}
diff --git a/net/gn/gn_prot.c b/net/gn/gn_prot.c
new file mode 100644
index 000000000000..58095c4dc475
--- /dev/null
+++ b/net/gn/gn_prot.c
@@ -0,0 +1,1908 @@
+// SPDX-License-Identifier: GPL-2.0
+
+/*
+ * GeoNetworking
+ */
+
+#include <asm-generic/errno-base.h>
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
+#include <linux/if_arp.h>
+#include <linux/slab.h>
+#include <linux/termios.h>
+#include <net/sock.h>
+#include <net/datalink.h>
+#include <net/psnap.h>
+#include <linux/gn.h>
+#include <linux/gn_routing.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/export.h>
+#include <linux/etherdevice.h>
+#include <linux/timer.h>
+#include <linux/time.h>
+#include <linux/random.h>
+#include <linux/atomic.h>
+#include <linux/limits.h>
+#include <linux/if_ether.h>
+#include <linux/bug.h>
+
+struct datalink_proto *gn_dl;
+static const struct proto_ops gn_dgram_ops;
+static struct timer_list gn_beacon_timer;
+
+/* Handlers for the socket list. */
+
+DEFINE_RWLOCK(gn_sockets_lock);
+HLIST_HEAD(gn_sockets);
+
+static void __gn_insert_socket(struct sock *sk)
+{
+	sk_add_node(sk, &gn_sockets);
+}
+
+static void gn_remove_socket(struct sock *sk)
+{
+	write_lock_bh(&gn_sockets_lock);
+	sk_del_node_init(sk);
+	write_unlock_bh(&gn_sockets_lock);
+}
+
+#define from_timer(var, callback_timer, timer_fieldname) \
+	container_of(callback_timer, typeof(*(var)), timer_fieldname)
+
+static void gn_destroy_timer(struct timer_list *t)
+{
+	struct sock *sk = from_timer(sk, t, sk_timer);
+
+	if (sk_has_allocations(sk)) {
+		sk->sk_timer.expires = jiffies + SOCK_DESTROY_TIME;
+		add_timer(&sk->sk_timer);
+	} else {
+		sock_put(sk);
+	}
+}
+
+static void gn_destroy_socket(struct sock *sk)
+{
+	gn_remove_socket(sk);
+	skb_queue_purge(&sk->sk_receive_queue);
+
+	if (sk_has_allocations(sk)) {
+		timer_setup(&sk->sk_timer, gn_destroy_timer, 0);
+		sk->sk_timer.expires = jiffies + SOCK_DESTROY_TIME;
+		add_timer(&sk->sk_timer);
+	} else {
+		sock_put(sk);
+	}
+}
+
+/* Handling for system calls applied via the various interfaces to a
+ * GeoNetworking socket object.
+ */
+
+static struct proto gn_proto = {
+	.name = "GN",
+	.owner = THIS_MODULE,
+	.obj_size = sizeof(struct gn_sock),
+};
+
+HLIST_HEAD(gn_interfaces);
+DEFINE_SPINLOCK(gn_interfaces_lock);
+
+static void gn_activate_beacon(void);
+
+/**
+ * gn_iface - add device to the interface the socketaddress is bound to
+ */
+struct gn_iface *gn_if_add_device(struct net_device *dev,
+				  struct sockaddr_gn *sa)
+{
+	struct gn_iface *new_gnif = kzalloc_obj(*new_gnif, GFP_KERNEL);
+	struct gn_iface *gnif;
+	bool was_empty;
+
+	if (!new_gnif)
+		return NULL;
+
+	new_gnif->address = sa->sgn_addr;
+	new_gnif->dev = dev;
+
+	pr_info("Add interface %s with address %llx", dev->name,
+		new_gnif->address);
+
+	spin_lock_bh(&gn_interfaces_lock);
+	hlist_for_each_entry_rcu(gnif, &gn_interfaces, hnode) {
+		if (gnif->dev == dev) {
+			// Replace existing interface address
+			atomic_set(&new_gnif->local_sn,
+				   atomic_read(&gnif->local_sn));
+			memcpy(&new_gnif->pos, &gnif->pos, sizeof(gnif->pos));
+			hlist_replace_rcu(&gnif->hnode, &new_gnif->hnode);
+			spin_unlock_bh(&gn_interfaces_lock);
+			kfree_rcu(gnif, rcu);
+			return new_gnif;
+		}
+	}
+	was_empty = hlist_empty(&gn_interfaces);
+
+	// No existing interface address
+	hlist_add_head_rcu(&new_gnif->hnode, &gn_interfaces);
+	spin_unlock_bh(&gn_interfaces_lock);
+
+	if (was_empty)
+		gn_activate_beacon();
+
+	return new_gnif;
+}
+
+void gn_if_drop_device(struct net_device *dev)
+{
+	struct hlist_node *tmp;
+	struct gn_iface *gnif;
+
+	spin_lock_bh(&gn_interfaces_lock);
+	hlist_for_each_entry_safe(gnif, tmp, &gn_interfaces, hnode) {
+		if (gnif->dev == dev) {
+			hlist_del_rcu(&gnif->hnode);
+			kfree_rcu(gnif, rcu);
+			break;
+		}
+	}
+	spin_unlock_bh(&gn_interfaces_lock);
+}
+
+static void gn_interfaces_clear(void)
+{
+	struct hlist_node *tmp;
+	struct gn_iface *gnif;
+
+	spin_lock_bh(&gn_interfaces_lock);
+	hlist_for_each_entry_safe(gnif, tmp, &gn_interfaces, hnode) {
+		hlist_del_rcu(&gnif->hnode);
+		kfree_rcu(gnif, rcu);
+	}
+	spin_unlock_bh(&gn_interfaces_lock);
+}
+
+/*
+ * find the interface to which the socketaddress is bound
+ */
+struct gn_iface *gn_find_interface(gn_address_t addr)
+{
+	struct gn_iface *gnif;
+	bool found = false;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(gnif, &gn_interfaces, hnode) {
+		if (gnif->address == addr) {
+			found = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return found ? gnif : NULL;
+}
+
+/*
+ * find an interface by the device it belongs to
+ */
+struct gn_iface *gn_find_interface_by_dev(struct net_device *dev)
+{
+	struct gn_iface *gnif;
+	bool found = false;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(gnif, &gn_interfaces, hnode) {
+		if (gnif->dev == dev) {
+			found = true;
+			break;
+		}
+	}
+	rcu_read_unlock();
+	return found ? gnif : NULL;
+}
+
+/*
+ * A device event has occurred. Watch for devices going down and
+ * delete our use of them (iface and route).
+ */
+static int gn_device_event(struct notifier_block *this, unsigned long event,
+			   void *ptr)
+{
+	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
+
+	if (!net_eq(dev_net(dev), &init_net))
+		return NOTIFY_DONE;
+
+	if (dev->type != ARPHRD_ETHER)
+		return NOTIFY_DONE;
+
+	if (event == NETDEV_DOWN || event == NETDEV_UNREGISTER)
+		gn_if_drop_device(dev);
+
+	return NOTIFY_DONE;
+}
+
+/*
+ * Convert TAI timestamp in milliseconds to GN timestamp
+ */
+u32 gn_tai_to_gn(ktime_t tai_time)
+{
+	const ktime_t tai_offset = ms_to_ktime(GN_EPOCH_UNIX_MS);
+
+	WARN_ONCE(ktime_before(tai_time, tai_offset),
+		  "timestamp %lld out of bounds", tai_time);
+	/* truncate timestamp (GN timestamp has 32 bits) */
+	return (u32)ktime_sub(tai_time, tai_offset);
+}
+
+u32 gn_timestamp_now(void)
+{
+	return gn_tai_to_gn(ktime_get_clocktai());
+}
+
+/*
+ * Create a socket. Initialise the socket, blank the addresses
+ * set the state.
+ */
+static int gn_create(struct net *net, struct socket *sock, int protocol,
+		     int kern)
+{
+	struct sock *sk;
+	int rc;
+
+	rc = -EAFNOSUPPORT;
+	if (!net_eq(net, &init_net))
+		goto out;
+
+	rc = -ESOCKTNOSUPPORT;
+	if (sock->type != SOCK_DGRAM)
+		goto out;
+
+	if (protocol < GN_PROTO_ANY || protocol > GN_PROTO_MAX)
+		goto out;
+
+	/* Note: Only BTP/GeoNetworking protocols supported; IPv6 encap not enabled */
+	if (protocol == GN_PROTO_INET6)
+		goto out;
+
+	rc = -ENOMEM;
+	sk = sk_alloc(net, PF_GN, GFP_KERNEL, &gn_proto, kern);
+	if (!sk)
+		goto out;
+	rc = 0;
+	sock->ops = &gn_dgram_ops;
+	sock_init_data(sock, sk);
+	if (protocol == GN_PROTO_ANY)
+		gn_sk(sk)->protocol = GN_PROTO_BTP_A;
+	else
+		gn_sk(sk)->protocol = protocol;
+
+	/* Checksums on by default */
+//	sock_set_flag(sk, SOCK_ZAPPED);
+out:
+	return rc;
+}
+
+/* Free a socket. No work needed */
+static int gn_release(struct socket *sock)
+{
+	struct sock *sk = sock->sk;
+
+	if (sk) {
+		sock_hold(sk);
+		lock_sock(sk);
+
+		sock_orphan(sk);
+		sock->sk = NULL;
+		gn_destroy_socket(sk);
+
+		release_sock(sk);
+		sock_put(sk);
+	}
+	return 0;
+}
+
+static int gn_pick_and_bind_port(struct sock *sk, struct sockaddr_gn *sgn)
+{
+	int retval;
+
+	write_lock_bh(&gn_sockets_lock);
+
+	for (sgn->sgn_port = GNPORT_RESERVED; sgn->sgn_port < GNPORT_LAST;
+	     sgn->sgn_port++) {
+		struct sock *s;
+
+		sk_for_each(s, &gn_sockets) {
+			struct gn_sock *gn = gn_sk(s);
+
+			if (gn->src_port == sgn->sgn_port &&
+			    gn->src_addr == sgn->sgn_addr)
+				goto try_next_port;
+		}
+
+		/* Wheee, it's free, assign and insert. */
+		__gn_insert_socket(sk);
+		gn_sk(sk)->src_port = sgn->sgn_port;
+		retval = 0;
+		goto out;
+
+try_next_port:;
+	}
+
+	retval = -EBUSY;
+out:
+	write_unlock_bh(&gn_sockets_lock);
+	return retval;
+}
+
+static struct sock *gn_find_or_insert_socket(struct sock *sk,
+					     struct sockaddr_gn *sgn)
+{
+	struct gn_sock *gn;
+	struct sock *s;
+
+	write_lock_bh(&gn_sockets_lock);
+	sk_for_each(s, &gn_sockets) {
+		gn = gn_sk(s);
+
+		if (gn->src_port == sgn->sgn_port)
+			goto found;
+	}
+	s = NULL;
+	gn = gn_sk(sk);
+	gn->src_addr = sgn->sgn_addr;
+	gn->src_port = sgn->sgn_port;
+	pr_info("gn: Add socket addr=%llx port=%d", gn->src_addr, gn->src_port);
+	__gn_insert_socket(sk); /* Wheee, it's free, assign and insert. */
+found:
+	write_unlock_bh(&gn_sockets_lock);
+	return s;
+}
+
+static int gn_autobind(struct sock *sock)
+{
+	return -EOPNOTSUPP;
+}
+
+/* Set the address 'our end' of the connection */
+static int gn_bind(struct socket *sock, struct sockaddr_unsized *uaddr,
+		   int addr_len)
+{
+	DECLARE_SOCKADDR(struct sockaddr_gn *, addr, uaddr);
+	struct sock *sk = sock->sk;
+	struct gn_sock *gn;
+	int err;
+
+	gn = gn_sk(sk);
+
+	if (!sock_flag(sk, SOCK_ZAPPED) ||
+	    addr_len != sizeof(struct sockaddr_gn))
+		return -EINVAL;
+
+	if (addr->sgn_family != AF_GN)
+		return -EAFNOSUPPORT;
+
+	lock_sock(sk);
+	if (addr->sgn_addr != 0 && !gn_find_interface(addr->sgn_addr)) {
+		release_sock(sk);
+		return -EADDRNOTAVAIL;
+	}
+	gn->src_addr = addr->sgn_addr;
+
+	if (addr->sgn_port == GNPORT_ANY) {
+		err = gn_pick_and_bind_port(sk, addr);
+
+		if (err < 0)
+			goto out;
+	} else {
+		err = -EADDRINUSE;
+		if (gn_find_or_insert_socket(sk, addr))
+			goto out;
+	}
+	sock_reset_flag(sk, SOCK_ZAPPED);
+	err = 0;
+
+out:
+	release_sock(sk);
+	return err;
+}
+
+/* Set the address we talk to */
+static int gn_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
+		      int addr_len, int flags)
+{
+	struct sock *sk = sock->sk;
+	struct sockaddr_gn *addr;
+	struct gn_sock *gn;
+	int err;
+
+	gn = gn_sk(sk);
+
+	sk->sk_state = TCP_CLOSE;
+	sock->state = SS_UNCONNECTED;
+
+	if (addr_len != sizeof(*addr))
+		return -EINVAL;
+
+	addr = (struct sockaddr_gn *)uaddr;
+
+	if (addr->sgn_family != AF_GN)
+		return -EAFNOSUPPORT;
+
+	lock_sock(sk);
+	err = -EBUSY;
+	if (sock_flag(sk, SOCK_ZAPPED))
+		if (gn_autobind(sk) < 0)
+			goto out;
+
+	/* Note: Route resolution for connected sockets occurs during gn_sendmsg */
+
+	gn->dst_port = addr->sgn_port;
+	gn->dst_addr = addr->sgn_addr;
+
+	sock->state = SS_CONNECTED;
+	sk->sk_state = TCP_ESTABLISHED;
+	err = 0;
+out:
+	release_sock(sk);
+	return err;
+}
+
+static struct sock *gn_search_socket(struct sockaddr_gn *tosgn,
+				     struct gn_iface *gnif)
+{
+	struct gn_sock *gn;
+	struct sock *s;
+
+	read_lock_bh(&gn_sockets_lock);
+	sk_for_each(s, &gn_sockets) {
+		gn = gn_sk(s);
+
+		if (gn->src_port != tosgn->sgn_port)
+			continue;
+		if (!gnif || gn->src_addr == gnif->address) {
+			sock_hold(s);
+			goto out;
+		}
+	}
+	s = NULL;
+out:
+	read_unlock_bh(&gn_sockets_lock);
+	return s;
+}
+
+static u16 gn_if_next_sn(struct gn_iface *gnif)
+{
+	return atomic_inc_return(&gnif->local_sn) % USHRT_MAX;
+}
+
+void gn_fill_sopv(struct gn_iface *gnif, struct gn_lpv *sopv, gn_address_t addr)
+{
+	/* Note: Speed and Heading zeroed until velocity sensors integrated */
+
+	ktime_t tst = ktime_set(gnif->pos.tst.tv_sec, gnif->pos.tst.tv_nsec);
+	// fill empty or invalid timestamp with current timestamp
+	// (must be >= 2004-01-01 ETSI Epoch)
+	if (tst == 0 || ktime_before(tst, ms_to_ktime(GN_EPOCH_UNIX_MS)))
+		sopv->tst = cpu_to_be32(gn_timestamp_now());
+	else
+		sopv->tst = cpu_to_be32(gn_tai_to_gn(tst));
+	sopv->lon = cpu_to_be32(gnif->pos.coord.lon);
+	sopv->lat = cpu_to_be32(gnif->pos.coord.lat);
+	sopv->addr = addr;
+	sopv->spai = cpu_to_be16(FIELD_PREP(GN_LPV_PAI, 0) |
+				 FIELD_PREP(GN_LPV_S, 0));
+	sopv->h = cpu_to_be16(0);
+}
+
+static void gn_fill_bh_ch(struct gn_iface *gnif, struct gn_header *gh,
+			  u8 packet_type, u8 packet_subtype, u8 rhl,
+			  u8 next_header, __be16 payload_size)
+{
+	const u8 mhl = DEFAULT_HOP_LIMIT;
+	/* rhl should never be greater than mhl */
+	if (WARN_ON(rhl > mhl))
+		rhl = DEFAULT_HOP_LIMIT;
+
+	gh->gb_h.version = GN_VERSION;
+	gh->gb_h.nh = BH_NH_COMMON_HEADER;
+	gh->gb_h.reserved = 0;
+	gh->gb_h.lt = BH_LT_DEFAULT;
+	gh->gb_h.rhl = rhl;
+
+	gh->gc_h.nh = next_header;
+	gh->gc_h.reserved = 0;
+	gh->gc_h.reserved2 = 0;
+	gh->gc_h.ht = packet_type;
+	gh->gc_h.hst = packet_subtype;
+	gh->gc_h.tc = CH_TC_DEFAULT;
+	gh->gc_h.pl = payload_size;
+	if (packet_type == CH_HT_BEACON)
+		gh->gc_h.mhl = BEACON_MHL;
+	else
+		gh->gc_h.mhl = DEFAULT_HOP_LIMIT;
+
+	if (gnif->pos.flags & GN_POSITION_MOBILE)
+		gh->gc_h.flags = CH_FLAG_MOBILE;
+	else
+		gh->gc_h.flags = 0;
+}
+
+static void gn_fill_bh_ch_nopayload(struct gn_iface *gnif,
+				    struct gn_header *gn_h, u8 packet_type,
+				    u8 packet_subtype, u8 rhl)
+{
+	gn_fill_bh_ch(gnif, gn_h, packet_type, packet_subtype, rhl, CH_NH_ANY,
+		      0);
+}
+
+static void gn_location_service_req(struct gn_iface *gnif, gn_address_t saddr,
+				    gn_address_t daddr)
+{
+	struct gn_ls_request_header *gls_h;
+	struct gn_common_header *gc_h;
+	struct gn_basic_header *gb_h;
+	struct sk_buff *skb;
+	int size = 0;
+
+	size += gn_dl->header_length;
+	size += gnif->dev->hard_header_len;
+	size += sizeof(struct gn_basic_header);
+	size += sizeof(struct gn_common_header);
+	size += sizeof(struct gn_ls_request_header);
+
+	skb = netdev_alloc_skb(gnif->dev, size);
+	if (!skb)
+		return;
+	skb_reserve(skb, gn_dl->header_length);
+	skb_reserve(skb, gnif->dev->hard_header_len);
+	skb_reserve(skb, sizeof(struct gn_basic_header));
+	skb_reserve(skb, sizeof(struct gn_common_header));
+	skb_reserve(skb, sizeof(struct gn_ls_request_header));
+
+	gls_h = skb_push(skb, sizeof(struct gn_ls_request_header));
+	gc_h = skb_push(skb, sizeof(struct gn_common_header));
+	gb_h = skb_push(skb, sizeof(struct gn_basic_header));
+
+	gn_fill_bh_ch_nopayload(gnif, (struct gn_header *)gb_h, CH_HT_LS,
+				CH_HST_LS_REQUEST, DEFAULT_HOP_LIMIT);
+
+	gls_h->sn = cpu_to_be16(gn_if_next_sn(gnif));
+	gls_h->reserved = 0;
+	gls_h->addr = daddr;
+	gn_fill_sopv(gnif, &gls_h->sopv, saddr);
+
+	gn_dl->request(gn_dl, skb, gnif->dev->broadcast);
+}
+
+static void gn_location_service_reply(struct gn_spv *depv,
+				      struct gn_iface *gnif, gn_address_t addr,
+				      u64 llc)
+{
+	struct gn_ls_reply_header *gls_h;
+	struct gn_common_header *gc_h;
+	struct gn_basic_header *gb_h;
+	struct sk_buff *skb;
+	int size;
+
+	size = 0;
+	size += gn_dl->header_length;
+	size += gnif->dev->hard_header_len;
+	size += sizeof(struct gn_basic_header);
+	size += sizeof(struct gn_common_header);
+	size += sizeof(struct gn_ls_reply_header);
+
+	skb = netdev_alloc_skb(gnif->dev, size);
+	if (!skb)
+		return;
+	skb_reserve(skb, gn_dl->header_length);
+	skb_reserve(skb, gnif->dev->hard_header_len);
+	skb_reserve(skb, sizeof(struct gn_basic_header));
+	skb_reserve(skb, sizeof(struct gn_common_header));
+	skb_reserve(skb, sizeof(struct gn_ls_reply_header));
+
+	gls_h = skb_push(skb, sizeof(struct gn_ls_reply_header));
+	gc_h = skb_push(skb, sizeof(struct gn_common_header));
+	gb_h = skb_push(skb, sizeof(struct gn_basic_header));
+
+	gn_fill_bh_ch_nopayload(gnif, (struct gn_header *)gb_h, CH_HT_LS,
+				CH_HST_LS_REPLY, DEFAULT_HOP_LIMIT);
+
+	gls_h->sn = cpu_to_be16(gn_if_next_sn(gnif));
+	gls_h->reserved = 0;
+	gn_fill_sopv(gnif, &gls_h->sopv, addr);
+	memcpy(&gls_h->depv, depv, sizeof(*depv));
+
+	gn_dl->request(gn_dl, skb, gnif->dev->broadcast);
+}
+
+static int gn_pass_payload_sock(struct sockaddr_gn *tosgn, struct sk_buff *skb)
+{
+	int rc = NET_RX_DROP;
+	struct sock *sock;
+
+	sock = gn_search_socket(tosgn, NULL);
+	if (!sock)
+		return NET_RX_DROP;
+	if (sock_queue_rcv_skb(sock, skb) == 0)
+		rc = NET_RX_SUCCESS;
+	sock_put(sock);
+	return rc;
+}
+
+static int gn_forward_guc_packet(struct sk_buff *skb, gn_address_t dest_addr)
+{
+	struct sk_buff *forward_skb;
+	u8 next_hop_mac[ETH_ALEN];
+	struct gn_header *fwd_gh;
+	struct gn_iface *gnif;
+
+	fwd_gh = (struct gn_header *)skb_network_header(skb);
+	if (fwd_gh->gb_h.rhl <= 0)
+		return -EINVAL;
+
+	gnif = gn_find_interface_by_dev(skb->dev);
+	if (!gnif)
+		return -ENODEV;
+
+	forward_skb = skb_copy(skb, GFP_ATOMIC);
+	if (!forward_skb) {
+		pr_warn("Dropping packet during GUC forwarding\n");
+		return -ENOMEM;
+	}
+
+	fwd_gh = (struct gn_header *)skb_network_header(forward_skb);
+	fwd_gh->gb_h.rhl--;
+
+	if (gn_query_ll_nexthop(gnif, dest_addr, next_hop_mac) == 0)
+		gn_dl->request(gn_dl, forward_skb, next_hop_mac);
+	else
+		gn_dl->request(gn_dl, forward_skb, skb->dev->broadcast);
+
+	return 0;
+}
+
+static int gn_forward_tsb_packet(struct sk_buff *skb)
+{
+	struct sk_buff *forward_skb;
+	struct gn_header *fwd_gh;
+
+	fwd_gh = (struct gn_header *)skb_network_header(skb);
+	if (fwd_gh->gb_h.rhl <= 0)
+		return -EINVAL;
+
+	forward_skb = skb_copy(skb, GFP_ATOMIC);
+	if (!forward_skb) {
+		pr_warn("Dropping packet during TSB forwarding\n");
+		return -ENOMEM;
+	}
+
+	fwd_gh = (struct gn_header *)skb_network_header(forward_skb);
+	fwd_gh->gb_h.rhl--;
+
+	gn_dl->request(gn_dl, forward_skb, skb->dev->broadcast);
+	return 0;
+}
+
+static int gn_process_guc_packet(struct sk_buff *skb)
+{
+	struct btp_header *btp_h;
+	struct sockaddr_gn tosgn;
+	struct gn_iface *gnif;
+	struct gn_header *gh;
+
+	gh = (struct gn_header *)skb_network_header(skb);
+	GN_SET_BTP(skb, btp_h, struct gn_guc_header);
+
+	skb_reset_transport_header(skb);
+
+	tosgn.sgn_family = PF_GN;
+	tosgn.sgn_addr = gh->guc_h.depv.addr;
+	tosgn.sgn_port = be16_to_cpu(btp_h->dst_port);
+
+	if (gn_update_location_table(&gh->guc_h.sopv, false, NULL,
+				     &gh->guc_h.sn))
+		goto drop;
+
+	gnif = gn_find_interface(tosgn.sgn_addr);
+	if (!gnif) {
+		if (gn_forward_guc_packet(skb, tosgn.sgn_addr) == 0) {
+			kfree_skb(skb);
+			return NET_RX_SUCCESS;
+		}
+		goto drop;
+	}
+
+	if (gn_pass_payload_sock(&tosgn, skb) != NET_RX_SUCCESS)
+		goto drop;
+
+	return NET_RX_SUCCESS;
+drop:
+	kfree_skb(skb);
+	return NET_RX_DROP;
+}
+
+static u8 gn_decode_shape(u8 hst)
+{
+	switch (hst) {
+	case CH_HST_GABC_CIRCLE:
+		return GN_SHAPE_CIRCLE;
+	case CH_HST_GABC_RECT:
+		return GN_SHAPE_RECTANGLE;
+	case CH_HST_GABC_ELIP:
+		return GN_SHAPE_ELLIPSE;
+	default:
+		return GN_SHAPE_UNSPECIFIED;
+	};
+}
+
+static u8 gn_encode_shape(u8 shape)
+{
+	switch (shape) {
+	case GN_SHAPE_CIRCLE:
+		return CH_HST_GABC_CIRCLE;
+	case GN_SHAPE_RECTANGLE:
+		return CH_HST_GABC_RECT;
+	case GN_SHAPE_ELLIPSE:
+		return CH_HST_GABC_ELIP;
+	default:
+		return CH_HST_UNSPECIFIED;
+	};
+}
+
+static struct gn_geo_scope gn_decode_geo_scope(struct gn_header *gh)
+{
+	struct gn_geo_scope scope = {
+		.a = be16_to_cpu(gh->gbc_h.da),
+		.b = be16_to_cpu(gh->gbc_h.db),
+		.angle = be16_to_cpu(gh->gbc_h.angle),
+		.coord.lat = be32_to_cpu(gh->gbc_h.gap_lat),
+		.coord.lon = be32_to_cpu(gh->gbc_h.gap_lon),
+		.shape = gn_decode_shape(gh->gc_h.hst),
+	};
+	return scope;
+}
+
+static int gn_process_gxc_packet(struct sk_buff *skb)
+{
+	unsigned long long next_hop_addr;
+	struct gn_geo_scope scope;
+	struct btp_header *btp_h;
+	struct sockaddr_gn tosgn;
+	struct gn_iface *gnif;
+	struct gn_header *gh;
+	bool run_dpd;
+	s64 f_value;
+
+	next_hop_addr = GN_BROADCAST_ADDR;
+
+	gh = (struct gn_header *)skb_network_header(skb);
+	GN_SET_BTP(skb, btp_h, struct gn_gxc_header);
+
+	tosgn.sgn_family = PF_GN;
+	tosgn.sgn_addr = gh->gbc_h.sopv.addr;
+	tosgn.sgn_port = be16_to_cpu(btp_h->dst_port);
+
+	/* Resolve local GeoNetworking interface to check area membership */
+	gnif = gn_find_interface_by_dev(skb->dev);
+	if (!gnif)
+		goto drop;
+
+	scope = gn_decode_geo_scope(gh);
+	if (scope.shape == GN_SHAPE_UNSPECIFIED)
+		goto drop;
+
+	f_value = gn_F(gnif->pos.coord, scope);
+
+	if (f_value >= 0) {
+		// GeoAdhoc router is outside specified area
+		switch (GN_AREA_FORWARDING) {
+		case GN_AREA_FORWARDING_UNSPECIFIED:
+		case GN_AREA_FORWARDING_SIMPLE:
+			run_dpd = true;
+			break;
+		default:
+			run_dpd = false;
+			break;
+		}
+	} else {
+		// GeoAdhoc router is inside specified area
+		switch (GN_NON_AREA_FORWARDING) {
+		case GN_NON_AREA_FORWARDING_UNSPECIFIED:
+		case GN_NON_AREA_FORWARDING_GREEDY:
+			run_dpd = true;
+			break;
+		default:
+			run_dpd = false;
+		}
+	}
+	if (gn_update_location_table(&gh->gbc_h.sopv, false, NULL,
+				     run_dpd ? &gh->gbc_h.sn : NULL))
+		goto drop;
+	// Forwarding
+	if (gh->gb_h.rhl > 0 && ((gh->gc_h.ht == CH_HT_GAC && f_value >= 0) ||
+				 gh->gc_h.ht == CH_HT_GBC)) {
+		struct gn_basic_header *fwd_gb_h;
+		struct sk_buff *forward_skb;
+		u8 dest_addr[ETH_ALEN];
+		int rc;
+
+		forward_skb = skb_copy(skb, GFP_ATOMIC);
+		if (!forward_skb) {
+			pr_debug("dropping packet");
+			goto drop;
+		}
+		fwd_gb_h = (struct gn_basic_header *)skb_network_header(
+			forward_skb);
+		fwd_gb_h->rhl--;
+
+		rc = gn_gxc_forward(gnif, f_value, dest_addr, &gh->gbc_h.sopv);
+		switch (rc) {
+		case GN_FORWARD_NEXT_HOP:
+			gn_dl->request(gn_dl, forward_skb, dest_addr);
+			break;
+		case GN_FORWARD_BROADCAST:
+			gn_dl->request(gn_dl, forward_skb, skb->dev->broadcast);
+			break;
+		case GN_FORWARD_BUFFER:
+			pr_debug("forwarding buffers not implemented");
+			kfree_skb(forward_skb);
+			break;
+		case GN_FORWARD_DISCARD:
+			kfree_skb(forward_skb);
+			break;
+		default:
+			pr_debug("internal error: unexpected return value");
+			kfree_skb(forward_skb);
+			goto drop;
+		}
+	}
+
+	// Local delivery
+	if (f_value >= 0) {
+		if (gn_pass_payload_sock(&tosgn, skb) != NET_RX_SUCCESS)
+			goto drop;
+	} else {
+		kfree_skb(skb);
+	}
+
+	return NET_RX_SUCCESS;
+drop:
+	kfree_skb(skb);
+	return NET_RX_DROP;
+}
+
+static int gn_process_shb_packet(struct sk_buff *skb, const u8 *ll_address)
+{
+	struct btp_header *btp_h;
+	struct sockaddr_gn tosgn;
+	struct gn_header *gh;
+
+	gh = (struct gn_header *)skb_network_header(skb);
+	GN_SET_BTP(skb, btp_h, struct gn_shb_header);
+
+	/* Step 3: Duplicate Address Detection (DAD) check */
+
+	// 4. update PV in the LocTE
+	if (gn_update_location_table(&gh->shb_h.sopv, true, ll_address, NULL))
+		goto drop;
+
+	// 7. pass payload of GN_PDU to the upper protocol unit
+	tosgn.sgn_family = PF_GN;
+	tosgn.sgn_addr = gh->shb_h.sopv.addr;
+	tosgn.sgn_port = be16_to_cpu(btp_h->dst_port);
+
+	if (gn_pass_payload_sock(&tosgn, skb) != NET_RX_SUCCESS)
+		goto drop;
+
+	/* Step 8: Flush pending store-carry-forward buffers for source node */
+	gn_ls_flush(gh->shb_h.sopv.addr);
+
+	return NET_RX_SUCCESS;
+drop:
+	kfree_skb(skb);
+	return NET_RX_DROP;
+}
+
+static int gn_process_tsb_packet(struct sk_buff *skb)
+{
+	struct btp_header *btp_h;
+	struct sockaddr_gn tosgn;
+	struct gn_header *gh;
+
+	gh = (struct gn_header *)skb_network_header(skb);
+	GN_SET_BTP(skb, btp_h, struct gn_tsb_header);
+
+	/* Step 3: Duplicate Address Detection (DAD) check */
+
+	if (gn_update_location_table(&gh->tsb_h.sopv, false, NULL,
+				     &gh->tsb_h.sn))
+		goto drop;
+
+	if (gh->gb_h.rhl > 0)
+		gn_forward_tsb_packet(skb);
+
+	// 7. pass payload of GN_PDU to the upper protocol unit
+	tosgn.sgn_family = PF_GN;
+	tosgn.sgn_addr = gh->tsb_h.sopv.addr;
+	tosgn.sgn_port = be16_to_cpu(btp_h->dst_port);
+
+	if (gn_pass_payload_sock(&tosgn, skb) != NET_RX_SUCCESS)
+		goto drop;
+
+	/* Step 8: Flush pending store-carry-forward buffers for source node */
+	gn_ls_flush(gh->tsb_h.sopv.addr);
+
+	return NET_RX_SUCCESS;
+drop:
+	kfree_skb(skb);
+	return NET_RX_DROP;
+}
+
+static int gn_process_beacon_packet(struct sk_buff *skb, const u8 *llc)
+{
+	struct gn_header *gh = (struct gn_header *)skb_network_header(skb);
+
+	if (gn_update_location_table(&gh->beacon_h.sopv, true, llc, NULL)) {
+		pr_debug("LocT update failure\n");
+		kfree_skb(skb);
+		return NET_RX_DROP;
+	}
+
+	gn_ls_flush(gh->beacon_h.sopv.addr);
+	kfree_skb(skb);
+	return NET_RX_SUCCESS;
+}
+
+static int gn_process_ls_packet(struct sk_buff *skb)
+{
+	gn_address_t dest_addr;
+	struct gn_iface *gnif;
+	struct gn_header *gh;
+
+	gh = (struct gn_header *)skb_network_header(skb);
+
+	if (gh->gc_h.hst == CH_HST_LS_REQUEST) {
+		struct gn_ls_request_header *gls_req_h = &gh->ls_request_h;
+
+		// 2. execute dad
+		// 3. update loc_te
+		dest_addr = gls_req_h->addr;
+		if (gn_update_location_table(&gls_req_h->sopv, false, NULL,
+					     &gls_req_h->sn))
+			goto drop;
+		// 4. find out if the packet has to be answered or forwarded
+		gnif = gn_find_interface(dest_addr);
+		if (gnif) {
+			// has to be answered
+			/* Note: gn_spv is a prefix (addr, tst, lat, lon) of gn_lpv */
+			gn_location_service_reply(
+				(struct gn_spv *)&gls_req_h->sopv, gnif,
+				dest_addr, 0);
+		} else {
+			// has to be forwarded like a tsb
+			// 5. try to flush own forward buffer
+			gn_ls_flush(gls_req_h->sopv.addr);
+			// 6. forward like a tsb
+			gn_forward_tsb_packet(skb);
+		}
+	} else if (gh->gc_h.hst == CH_HST_LS_REPLY) {
+		struct gn_ls_reply_header *gls_rep_h = &gh->ls_reply_h;
+		// 2. execute dad
+		// 3. update loc_te
+		if (gn_update_location_table(&gls_rep_h->sopv, false, NULL,
+					     &gls_rep_h->sn))
+			goto drop;
+		dest_addr = gls_rep_h->depv.addr;
+
+		// 4. flush forward buffer
+		gn_ls_flush(gls_rep_h->sopv.addr);
+		// 5. find out if the packet has to be forwarded
+		if (!gn_find_interface(dest_addr))
+			gn_forward_guc_packet(skb, dest_addr);
+	} else {
+		goto drop;
+	}
+	kfree_skb(skb);
+	return NET_RX_SUCCESS;
+drop:
+	//pr_info("Packet was dropped.");
+	kfree_skb(skb);
+	return NET_RX_DROP;
+}
+
+/**	gn_rcv() - Receive a packet (in skb) from device dev
+ *	@skb - packet received
+ *	@dev - network device where the packet comes from
+ *	@pt - packet type
+ *
+ *	Receive a packet (in skb) from device dev. This has come from the SNAP
+ *	decoder, and on entry skb->network_header is the GN Basic Header.
+ *	The physical headers have been extracted.
+ */
+static int gn_rcv(struct sk_buff *skb, struct net_device *dev,
+		  struct packet_type *pt, struct net_device *orig_dev)
+{
+	struct gn_header *gh;
+	struct ethhdr *eth;
+
+	if (!net_eq(dev_net(dev), &init_net))
+		goto drop;
+
+	if (dev->type != ARPHRD_ETHER)
+		goto drop;
+
+	if (!gn_find_interface_by_dev(dev))
+		goto drop;
+
+	skb = skb_share_check(skb, GFP_ATOMIC);
+
+	if (!skb)
+		goto drop;
+
+	eth = (struct ethhdr *)skb_mac_header(skb);
+	// TODO: validate
+	if (skb->pkt_type == PACKET_LOOPBACK ||
+	    ether_addr_equal(eth->h_source, dev->dev_addr))
+		goto drop;
+
+	skb_reset_network_header(skb);
+
+	if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE))
+		goto drop;
+
+	// Basic Header processing
+	gh = (struct gn_header *)skb_network_header(skb);
+
+	if (gh->gb_h.version != GN_VERSION ||
+	    gh->gb_h.nh != BH_NH_COMMON_HEADER) {
+		pr_debug("corrupt packet");
+		goto drop;
+	}
+
+	/*
+	 * Retrieve information from socketbuffer an insert it into according headers;
+	 * this is necessary to determine if the packet is ours and find the matching
+	 * socket, or if the packet has to be forwarded
+	 */
+	// Common Header processing
+
+	//skb_trim(skb, min_t(unsigned int, skb->len, gc_h->pl + sizeof(*gb_h)
+	// + sizeof(*gc_h)));
+
+	if (gh->gc_h.mhl < gh->gb_h.rhl)
+		goto drop;
+
+	switch (gh->gc_h.ht) {
+	case CH_HT_GUC:
+		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + GN_GUC_HLEN +
+						BTP_HLEN))
+			goto drop;
+		return gn_process_guc_packet(skb);
+	case CH_HT_GAC:
+	case CH_HT_GBC:
+		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE +
+						GN_GXC_HLEN + BTP_HLEN)
+			goto drop;
+		return gn_process_gxc_packet(skb);
+	case CH_HT_TSB:
+		if (gh->gc_h.hst == CH_HST_TSB_SINGLE_HOP) {
+			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE +
+							GN_SHB_HLEN + BTP_HLEN))
+				goto drop;
+			return gn_process_shb_packet(skb, eth->h_source);
+		}
+		if (gh->gc_h.hst == CH_HST_TSB_MULTI_HOP) {
+			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE +
+							GN_TSB_HLEN + BTP_HLEN))
+				goto drop;
+			return gn_process_tsb_packet(skb);
+		}
+		goto drop;
+	case CH_HT_BEACON:
+		if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE + GN_BEACON_HLEN))
+			goto drop;
+		return gn_process_beacon_packet(skb, eth->h_source);
+	case CH_HT_LS:
+		if (gh->gc_h.hst == CH_HST_LS_REQUEST) {
+			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE +
+							GN_LS_REQUEST_HLEN))
+				goto drop;
+		} else if (gh->gc_h.hst == CH_HST_LS_REPLY) {
+			if (!pskb_may_pull(skb, GN_BASE_HEADER_SIZE +
+							GN_LS_REPLY_HLEN))
+				goto drop;
+		} else {
+			goto drop;
+		}
+		return gn_process_ls_packet(skb);
+	default:
+		goto drop;
+	}
+drop:
+	kfree_skb(skb);
+	return NET_RX_DROP;
+}
+
+static int gn_fill_guc_header(struct gn_guc_header *guc_h,
+			      struct gn_iface *gnif, gn_address_t dest_addr,
+			      struct gn_spv *depv, struct gn_sock *gn)
+{
+	gn_address_t saddr = gn->src_addr ? gn->src_addr : gnif->address;
+
+	memset(guc_h, 0, sizeof(*guc_h));
+	guc_h->sn = cpu_to_be16(gn_if_next_sn(gnif));
+	gn_fill_sopv(gnif, &guc_h->sopv, saddr);
+	guc_h->depv.addr = dest_addr;
+	if (depv && depv->tst) {
+		guc_h->depv.tst = depv->tst;
+		guc_h->depv.lat = depv->lat;
+		guc_h->depv.lon = depv->lon;
+	} else {
+		guc_h->depv.tst = htonl(0);
+		guc_h->depv.lat = htonl(0);
+		guc_h->depv.lon = htonl(0);
+	}
+	return 0;
+}
+
+static int gn_fill_gxc_header(struct gn_gxc_header *gxc_h,
+			      struct gn_iface *gnif, struct gn_sock *gn)
+{
+	gn_address_t saddr = gn->src_addr ? gn->src_addr : gnif->address;
+
+	WARN_ON_ONCE(gn->scope.scope_type != GN_SCOPE_GEOGRAPHICAL &&
+		     gn->scope.scope_type != GN_SCOPE_GEOGRAPHICAL_ANYCAST);
+
+	memset(gxc_h, 0, sizeof(*gxc_h));
+	gxc_h->sn = cpu_to_be16(gn_if_next_sn(gnif));
+	gn_fill_sopv(gnif, &gxc_h->sopv, saddr);
+
+	gxc_h->gap_lat = cpu_to_be32(gn->scope.geo_scope.coord.lat);
+	gxc_h->gap_lon = cpu_to_be32(gn->scope.geo_scope.coord.lon);
+	gxc_h->angle = cpu_to_be16(gn->scope.geo_scope.angle);
+	switch (gn->scope.geo_scope.shape) {
+	case GN_SHAPE_CIRCLE:
+		gxc_h->da = cpu_to_be16(gn->scope.geo_scope.a);
+		break;
+	case GN_SHAPE_ELLIPSE:
+	case GN_SHAPE_RECTANGLE:
+		gxc_h->da = cpu_to_be16(gn->scope.geo_scope.a);
+		gxc_h->db = cpu_to_be16(gn->scope.geo_scope.b);
+		break;
+	default:
+	case GN_SHAPE_UNSPECIFIED:
+		pr_debug("unknown shape type");
+		break;
+	}
+	return 0;
+}
+
+static int gn_fill_shb_header(struct gn_shb_header *shb_h,
+			      struct gn_iface *gnif, struct gn_sock *gn)
+{
+	gn_address_t saddr = gn->src_addr ? gn->src_addr : gnif->address;
+
+	memset(shb_h, 0, sizeof(*shb_h));
+	gn_fill_sopv(gnif, &shb_h->sopv, saddr);
+
+	// prefill media dependent data field with empty
+	shb_h->mdd = htonl(0);
+	return 0;
+}
+
+static int gn_fill_tsb_header(struct gn_tsb_header *tsb_h,
+			      struct gn_iface *gnif, struct gn_sock *gn)
+{
+	gn_address_t saddr = gn->src_addr ? gn->src_addr : gnif->address;
+
+	memset(tsb_h, 0, sizeof(*tsb_h));
+	tsb_h->sn = cpu_to_be16(gn_if_next_sn(gnif));
+	gn_fill_sopv(gnif, &tsb_h->sopv, saddr);
+	return 0;
+}
+
+/**
+ * gn_sendmsg - always called if sendmsg() is called on a socket with an
+ * address family matching AF_GN
+ * @msghdr - contains information, including the payload of the packet
+ * @len - the size of the payload
+ */
+static int gn_sendmsg(struct socket *sock, struct msghdr *msg, size_t len)
+{
+	DECLARE_SOCKADDR(struct sockaddr_gn *, usgn, msg->msg_name);
+	int packet_type, packet_subtype, btp_type;
+	struct gn_common_header *gc_h;
+	struct gn_basic_header *gb_h;
+	struct sockaddr_gn local_sgn;
+	struct gn_spv depv = { 0 };
+	u8 rhl = DEFAULT_HOP_LIMIT;
+	int flags = msg->msg_flags;
+	struct btp_header *btp_h;
+	struct net_device *dev;
+	struct gn_iface *gnif;
+	struct sk_buff *skb;
+	struct gn_sock *gn;
+	int err = -EINVAL;
+	struct sock *sk;
+	u32 eh_size;
+	void *gp_h;
+	u32 size;
+
+	sk = sock->sk;
+	gn = gn_sk(sk);
+
+	if (flags & ~(MSG_DONTWAIT | MSG_CMSG_COMPAT)) {
+		pr_debug("unsupported sendmsg flags");
+		return -EINVAL;
+	}
+
+	if (len > GN_MAXSZ) {
+		pr_warn("message too long (got %zu, maximum %d)", len,
+			GN_MAXSZ);
+		return -EMSGSIZE;
+	}
+	lock_sock(sk);
+	if (usgn) {
+		err = -EBUSY;
+		if (sock_flag(sk, SOCK_ZAPPED)) {
+			pr_debug("socket zapped and autobind not implemented");
+			if (gn_autobind(sk) < 0)
+				goto out;
+		}
+		err = -EINVAL;
+		if (msg->msg_namelen < sizeof(*usgn) ||
+		    usgn->sgn_family != AF_GN) {
+			pr_debug("incorrect address family\n");
+			goto out;
+		}
+		//appletalk makes another check here
+	} else {
+		err = -ENOTCONN;
+		if (sk->sk_state != TCP_ESTABLISHED)
+			goto out;
+		usgn = &local_sgn;
+		usgn->sgn_family = AF_GN;
+		usgn->sgn_port = gn->dst_port;
+		usgn->sgn_addr = gn->dst_addr;
+	}
+	/*
+	 * Before the packet can be send, we have determine if the gn_address of
+	 * the source is bound to an interface. The interface provides the device
+	 * for sending the packet.
+	 */
+	gnif = gn_find_interface(gn->src_addr);
+
+	if (!gnif) {
+		pr_debug("Could not find an interface\n");
+		err = -EFAULT;
+		goto out;
+	}
+	dev = gnif->dev;
+
+	packet_subtype = CH_HST_UNSPECIFIED;
+	if (usgn->sgn_addr != 0 && usgn->sgn_addr != GNADDR_BROADCAST &&
+	    gn->scope.scope_type == GN_SCOPE_UNSPECIFIED) {
+		packet_type = CH_HT_GUC;
+	} else {
+		switch (gn->scope.scope_type) {
+		case GN_SCOPE_GEOGRAPHICAL:
+			packet_type = CH_HT_GBC;
+			packet_subtype =
+				gn_encode_shape(gn->scope.geo_scope.shape);
+			break;
+		case GN_SCOPE_GEOGRAPHICAL_ANYCAST:
+			packet_type = CH_HT_GAC;
+			packet_subtype =
+				gn_encode_shape(gn->scope.geo_scope.shape);
+			break;
+		case GN_SCOPE_TOPOLOGICAL:
+			packet_type = CH_HT_TSB;
+			if (gn->scope.topo_hops <= 1)
+				packet_subtype = CH_HST_TSB_SINGLE_HOP;
+			else
+				packet_subtype = CH_HST_TSB_MULTI_HOP;
+			break;
+		case GN_SCOPE_UNSPECIFIED:
+			packet_type = CH_HT_TSB;
+			packet_subtype = CH_HST_TSB_SINGLE_HOP;
+			break;
+		default:
+			err = -EINVAL;
+			goto out;
+		}
+	}
+
+	switch (gn->protocol) {
+	case GN_PROTO_BTP_A:
+		btp_type = CH_NH_BTPA;
+		break;
+	case GN_PROTO_BTP_B:
+		btp_type = CH_NH_BTPB;
+		break;
+	default:
+		err = -EINVAL;
+		goto out;
+	}
+
+	// Determine extended (header type specific) header size
+	switch (packet_type) {
+	case CH_HT_GUC:
+		eh_size = sizeof(struct gn_guc_header);
+		break;
+	case CH_HT_GAC:
+	case CH_HT_GBC:
+		eh_size = sizeof(struct gn_gxc_header);
+		break;
+	case CH_HT_TSB:
+		if (packet_subtype == CH_HST_TSB_SINGLE_HOP) {
+			eh_size = sizeof(struct gn_shb_header);
+		} else if (packet_subtype == CH_HST_TSB_MULTI_HOP) {
+			eh_size = sizeof(struct gn_tsb_header);
+		} else {
+			pr_debug("internal error");
+			err = -EINVAL;
+			goto out;
+		}
+		break;
+	default:
+		pr_debug("internal error");
+		err = -EINVAL;
+		goto out;
+	}
+
+	/*
+	 * Find out, how much memory has to be allocated for the packet and
+	 * allocate it.
+	 */
+	size = gn_dl->header_length;
+	size += dev->hard_header_len;
+	size += sizeof(struct gn_basic_header);
+	size += sizeof(struct gn_common_header);
+	size += eh_size;
+	size += sizeof(struct btp_header);
+	size += len;
+
+	release_sock(sk);
+	skb = sock_alloc_send_skb(sk, size, (flags & MSG_DONTWAIT), &err);
+	lock_sock(sk);
+	if (!skb) {
+		err = -ENOMEM;
+		goto out;
+	}
+	/*
+	 * Reserve memory in the socketbuffer for datalink, hardware, our headers
+	 */
+	skb_reserve(skb, gn_dl->header_length);
+	skb_reserve(skb, dev->hard_header_len);
+	skb_reserve(skb, sizeof(struct gn_basic_header));
+	skb_reserve(skb, sizeof(struct gn_common_header));
+	skb_reserve(skb, eh_size);
+	skb_reserve(skb, sizeof(struct btp_header));
+
+	skb->dev = dev;
+	/*
+	 * Copy userdata from socket into the payload of the packet
+	 */
+	err = memcpy_from_msg(skb_put(skb, len), msg, len);
+	if (err) {
+		pr_debug("could not extract from msg\n");
+		kfree_skb(skb);
+		err = -EFAULT;
+		goto out;
+	}
+
+	/*
+	 * Get positions of headers and fill them
+	 */
+	btp_h = skb_push(skb, sizeof(struct btp_header));
+	gp_h = skb_push(skb, eh_size);
+	gc_h = skb_push(skb, sizeof(struct gn_common_header));
+	gb_h = skb_push(skb, sizeof(struct gn_basic_header));
+
+	switch (btp_type) {
+	case CH_NH_BTPA:
+		btp_h->src_port = htons(gn->src_port);
+		btp_h->dst_port = htons(usgn->sgn_port);
+		break;
+	case CH_NH_BTPB:
+		btp_h->dst_port = htons(usgn->sgn_port);
+		btp_h->src_port = 0;
+		break;
+	default:
+		pr_debug("internal error");
+		kfree_skb(skb);
+		err = -EINVAL;
+		goto out;
+	}
+
+	switch (packet_type) {
+	case CH_HT_GUC:
+		gn_fill_depv(&depv, usgn->sgn_addr);
+		gn_fill_guc_header((struct gn_guc_header *)gp_h, gnif,
+				   usgn->sgn_addr, &depv, gn);
+		break;
+	case CH_HT_GAC:
+	case CH_HT_GBC:
+		gn_fill_gxc_header((struct gn_gxc_header *)gp_h, gnif, gn);
+		break;
+	case CH_HT_TSB:
+		if (packet_subtype == CH_HST_TSB_SINGLE_HOP) {
+			rhl = 1;
+			gn_fill_shb_header((struct gn_shb_header *)gp_h, gnif,
+					   gn);
+		} else if (packet_subtype == CH_HST_TSB_MULTI_HOP) {
+			//at this point it is safe to assume that topological scope is used
+			rhl = gn->scope.topo_hops ?: DEFAULT_HOP_LIMIT;
+			gn_fill_tsb_header((struct gn_tsb_header *)gp_h, gnif,
+					   gn);
+		} else {
+			pr_debug("internal error");
+			kfree_skb(skb);
+			err = -EINVAL;
+			goto out;
+		}
+		break;
+	}
+
+	/* Note: BTP header type (A/B) is determined by socket protocol */
+	gn_fill_bh_ch(gnif, (struct gn_header *)gb_h, packet_type,
+		      packet_subtype, rhl, btp_type,
+		      htons(len + sizeof(struct btp_header)));
+
+	/* Note: DEPV is populated during location service queue processing */
+	if (packet_type == CH_HT_GUC) {
+		u8 ll_address[ETH_ALEN];
+		int queue_rc = gn_ls_queue(usgn->sgn_addr, skb);
+
+		switch (queue_rc) {
+		case GN_QUEUE_LS_STALE:
+			// We need to perform a LS request
+			gn_location_service_req(gnif, gn->src_addr,
+						usgn->sgn_addr);
+			break;
+		case GN_QUEUE_LS_PENDING:
+			// LS request is pending, we're done
+			break;
+		case GN_QUEUE_DIRECT:
+			/* Destination in LocTE; resolve MAC or greedy next-hop */
+			if (gn_query_ll_nexthop(gnif, usgn->sgn_addr,
+						ll_address))
+				gn_dl->request(gn_dl, skb, dev->broadcast);
+			else
+				gn_dl->request(gn_dl, skb, ll_address);
+			break;
+		case GN_QUEUE_ERROR:
+		default:
+			kfree_skb(skb);
+			err = -ENOMEM;
+			goto out;
+		}
+	} else {
+		// Not a unicast packet
+		gn_dl->request(gn_dl, skb, dev->broadcast);
+	}
+
+	/* Destination position vector routing handled by location service queue */
+
+	err = len;
+out:
+	release_sock(sk);
+	return err;
+}
+
+/**
+ * gn_recvmsg - called, when recv() is called on a socket with AF = AF_GN.
+ * Copies the data of a received packet into msg.
+ * @sock - socket, on which recv() was called
+ * @msg - buffer used to retrieve packetdata
+ * @size - size of msg
+ * @flags - flags for receiving
+ *
+ */
+
+static int gn_recvmsg(struct socket *sock, struct msghdr *msg, size_t size,
+		      int flags)
+{
+	struct sock *sk = sock->sk;
+	struct gn_header *gh;
+	struct sk_buff *skb;
+	u16 copied = 0;
+	int err = 0;
+	u32 offset;
+
+	/* It is necessary to find the actual length of the payload, which,
+	 * in case of an unsecured package, resides in the commonheader and
+	 * still has to be calculated without the length of the btp-header
+	 * (4byte).
+	 * Furthermore, the datapointer probably has to be set to the
+	 * beginning of the actual payload
+	 */
+	skb = skb_recv_datagram(sk, flags & MSG_DONTWAIT, &err);
+	lock_sock(sk);
+	if (!skb)
+		goto out;
+
+	/* Note: Socket validation checks performed during bind/connect */
+	gh = (struct gn_header *)skb_network_header(skb);
+
+	copied = be16_to_cpu(gh->gc_h.pl);
+	offset = skb->transport_header - skb->network_header +
+		 sizeof(struct btp_header);
+	copied -= sizeof(struct btp_header);
+
+	/* Handle truncated datagram reception when user buffer is smaller than
+	 * payload */
+	if (copied > size) {
+		copied = size;
+		msg->msg_flags |= MSG_TRUNC;
+	}
+
+	err = skb_copy_datagram_msg(skb, offset, msg, copied);
+
+	skb_free_datagram(sk, skb);
+
+out:
+	release_sock(sk);
+	return err ?: copied;
+}
+
+/*
+ * Geonetworking timer callbacks
+ */
+static int gn_send_beacon(struct gn_iface *gnif)
+{
+	/* Note: Media dependent procedures (e.g. ITS-G5 DCC / DCC Access)
+	 * are evaluated here */
+	struct gn_beacon_header *gbe_h;
+	struct gn_common_header *gc_h;
+	struct gn_basic_header *gb_h;
+	struct sk_buff *skb;
+	unsigned int size;
+
+	size = gn_dl->header_length;
+	size += gnif->dev->hard_header_len;
+	size += sizeof(struct gn_basic_header);
+	size += sizeof(struct gn_common_header);
+	size += sizeof(struct gn_beacon_header);
+
+	skb = netdev_alloc_skb(gnif->dev, size);
+	if (!skb)
+		goto out;
+
+	skb_reserve(skb, size);
+	skb->dev = gnif->dev;
+
+	gbe_h = skb_push(skb, sizeof(struct gn_beacon_header));
+	gc_h = skb_push(skb, sizeof(struct gn_common_header));
+	gb_h = skb_push(skb, sizeof(struct gn_basic_header));
+
+	gn_fill_bh_ch_nopayload(gnif, (struct gn_header *)gb_h, CH_HT_BEACON,
+				CH_HST_BEACON, 1);
+
+	gn_fill_sopv(gnif, &gbe_h->sopv, gnif->address);
+
+	gn_dl->request(gn_dl, skb, gnif->dev->broadcast);
+
+out:
+	return 0;
+}
+
+static void gn_send_beacons(struct timer_list *tl)
+{
+	struct gn_iface *gnif;
+	bool empty = true;
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(gnif, &gn_interfaces, hnode) {
+		gn_send_beacon(gnif);
+		empty = false;
+	}
+	rcu_read_unlock();
+
+	if (!empty)
+		mod_timer(tl, jiffies + msecs_to_jiffies(
+						GN_BEACON_RETRANSMIT_TIME));
+}
+
+static void gn_activate_beacon(void)
+{
+	mod_timer(&gn_beacon_timer,
+		  jiffies + msecs_to_jiffies(GN_BEACON_RETRANSMIT_TIME));
+}
+
+static int validate_geo_scope(struct gn_geo_scope *scope)
+{
+	if (scope->angle > 360)
+		return -EINVAL;
+
+	if (scope->a == 0)
+		return -EINVAL;
+
+	switch (scope->shape) {
+	case GN_SHAPE_CIRCLE:
+		return scope->b != 0 ? -EINVAL : 0;
+	case GN_SHAPE_RECTANGLE:
+	case GN_SHAPE_ELLIPSE:
+		return 0;
+	default:
+	case GN_SHAPE_UNSPECIFIED:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int validate_scope(struct gn_scope *scope)
+{
+	if (scope->scope_type < GN_SCOPE_TOPOLOGICAL ||
+	    scope->scope_type > GN_SCOPE_MAX)
+		return -EINVAL;
+	switch (scope->scope_type) {
+	case GN_SCOPE_TOPOLOGICAL:
+		return 0;
+	case GN_SCOPE_GEOGRAPHICAL:
+	case GN_SCOPE_GEOGRAPHICAL_ANYCAST:
+		return validate_geo_scope(&scope->geo_scope);
+	default:
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int gn_setsockopt(struct socket *sock, int level, int optname,
+			 sockptr_t optval, unsigned int optlen)
+{
+	struct sock *sk = sock->sk;
+	int rc = -ENOPROTOOPT;
+	struct gn_scope opt;
+	struct gn_sock *gn;
+
+	gn = gn_sk(sk);
+
+	if (level != SOL_GN || optname != GN_SCOPE)
+		goto out;
+
+	rc = -EINVAL;
+	if (optlen < sizeof(struct gn_scope))
+		goto out;
+
+	rc = -EFAULT;
+	if (copy_from_sockptr(&opt, optval, sizeof(struct gn_scope)))
+		goto out;
+
+	rc = validate_scope(&opt);
+	if (rc < 0)
+		goto out;
+
+	lock_sock(sk);
+	memcpy(&gn->scope, &opt, sizeof(struct gn_scope));
+	release_sock(sk);
+
+	rc = 0;
+out:
+	return rc;
+}
+
+static int gn_getsockopt(struct socket *sock, int level, int optname,
+			 char __user *optval, int __user *optlen)
+{
+	int len, rc = -ENOPROTOOPT;
+	struct sock *sk = sock->sk;
+	struct gn_sock *gn;
+
+	gn = gn_sk(sk);
+
+	if (level != SOL_GN || optname != GN_SCOPE)
+		goto out;
+
+	rc = -EFAULT;
+	if (get_user(len, optlen))
+		goto out;
+
+	rc = -EINVAL;
+	if (len < 0)
+		goto out;
+
+	len = min_t(unsigned int, len, sizeof(struct gn_scope));
+
+	rc = -EFAULT;
+	if (put_user(len, optlen))
+		goto out;
+
+	lock_sock(sk);
+	rc = copy_to_user(optval, &gn->scope, len) ? -EFAULT : 0;
+	release_sock(sk);
+out:
+	return rc;
+}
+
+/*
+ * validate a gn_position coming from userspace
+ */
+int gn_validate_pos(struct gn_position *pos)
+{
+	if (pos->tst.tv_sec < 0 || pos->tst.tv_nsec < 0 ||
+	    pos->tst.tv_nsec >= NSEC_PER_SEC)
+		return -EINVAL;
+	return 0;
+}
+
+static int gn_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
+{
+	void __user *argp = (void __user *)arg;
+	struct sock *sk = sock->sk;
+	int rc = -ENOIOCTLCMD;
+
+	switch (cmd) {
+	/* Protocol layer */
+	case TIOCOUTQ: {
+		long amount = sk->sk_sndbuf - sk_wmem_alloc_get(sk);
+
+		if (amount < 0)
+			amount = 0;
+		rc = put_user(amount, (int __user *)argp);
+		break;
+	}
+	case TIOCINQ: {
+		/*
+		 * These two are safe on a single CPU system as only
+		 * user tasks fiddle here
+		 */
+		struct sk_buff *skb = skb_peek(&sk->sk_receive_queue);
+		long amount = 0;
+
+		if (skb)
+			amount = skb->len - sizeof(struct gn_header);
+		rc = put_user(amount, (int __user *)argp);
+		break;
+	}
+	case SIOCGSTAMP_OLD:
+	case SIOCGSTAMP_NEW:
+	case SIOCGSTAMPNS_OLD:
+	case SIOCGSTAMPNS_NEW:
+		break;
+	}
+
+	return rc;
+}
+
+#ifdef CONFIG_COMPAT
+static int gn_compat_ioctl(struct socket *sock, unsigned int cmd,
+			   unsigned long arg)
+{
+	/* All GeoNetworking ioctl commands (TIOCOUTQ, TIOCINQ, SIOCGIFADDR, etc.)
+	 * and struct gn_position (using struct __kernel_timespec) are 64-bit
+	 * clean and compat-safe.
+	 */
+	return gn_ioctl(sock, cmd, arg);
+}
+#endif
+
+static const struct net_proto_family gn_family_ops = {
+	.family = PF_GN,
+	.create = gn_create,
+	.owner = THIS_MODULE,
+};
+
+static const struct proto_ops gn_dgram_ops = {
+	.family = PF_GN,
+	.owner = THIS_MODULE,
+	.release = gn_release,
+	.bind = gn_bind,
+	.connect = gn_connect,
+	.socketpair = sock_no_socketpair,
+	.accept = sock_no_accept,
+	.getname = sock_no_getname,
+	.poll = datagram_poll,
+	.ioctl = gn_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl = gn_compat_ioctl,
+#endif
+	.listen = sock_no_listen,
+	.shutdown = sock_no_shutdown,
+	.setsockopt = gn_setsockopt,
+	.getsockopt = gn_getsockopt,
+	.sendmsg = gn_sendmsg,
+	.recvmsg = gn_recvmsg,
+	.mmap = sock_no_mmap,
+};
+
+static struct notifier_block gn_notifier = {
+	.notifier_call = gn_device_event,
+};
+
+static struct packet_type gn_packet_type __read_mostly = {
+	.type = cpu_to_be16(ETH_P_GN),
+	.func = gn_rcv,
+};
+
+/*
+ * SNAP-ID for Geonetworking 0x8947
+ * Note: SNAP header format uses big-endian 0x8947 per ETSI EN 302 636-4-1
+ */
+static unsigned char gn_snap_id[] = { 0x00, 0x00, 0x00, 0x89, 0x47 };
+
+/* Called by proto.c on kernel start up */
+static int __init gn_init(void)
+{
+	int rc;
+
+	timer_setup(&gn_beacon_timer, gn_send_beacons, 0);
+
+	rc = proto_register(&gn_proto, 0);
+	if (rc)
+		return rc;
+
+	rc = sock_register(&gn_family_ops);
+	if (rc)
+		goto out_proto;
+
+	gn_dl = register_snap_client(gn_snap_id, gn_rcv);
+	if (!gn_dl) {
+		pr_warn("Unable to register GeoNetworking with SNAP.\n");
+		rc = -ENOMEM;
+		goto out_snap;
+	}
+
+	dev_add_pack(&gn_packet_type);
+
+	rc = register_netdevice_notifier(&gn_notifier);
+	if (rc)
+		goto out_dev;
+
+#ifdef CONFIG_SYSCTL
+	rc = gn_register_sysctl();
+	if (rc)
+		goto out_nd;
+#endif
+
+	rc = gn_netlink_init();
+	if (rc)
+		goto out_sysctl;
+
+	return 0;
+
+out_sysctl:
+#ifdef CONFIG_SYSCTL
+	gn_unregister_sysctl();
+#endif
+out_nd:
+	unregister_netdevice_notifier(&gn_notifier);
+out_dev:
+	dev_remove_pack(&gn_packet_type);
+	unregister_snap_client(gn_dl);
+out_snap:
+	sock_unregister(PF_GN);
+out_proto:
+	proto_unregister(&gn_proto);
+	return rc;
+}
+module_init(gn_init);
+
+static void __exit gn_exit(void)
+{
+	gn_netlink_exit();
+
+#ifdef CONFIG_SYSCTL
+	gn_unregister_sysctl();
+#endif /* CONFIG_SYSCTL */
+
+	timer_shutdown_sync(&gn_beacon_timer);
+
+	unregister_netdevice_notifier(&gn_notifier);
+	dev_remove_pack(&gn_packet_type);
+	unregister_snap_client(gn_dl);
+	sock_unregister(PF_GN);
+	proto_unregister(&gn_proto);
+
+	gn_interfaces_clear();
+	gn_routing_exit();
+	rcu_barrier();
+}
+module_exit(gn_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Mr Noname <email.here@domain");
+MODULE_DESCRIPTION("GeoNetworking protocol");
+MODULE_ALIAS_NETPROTO(PF_GN);
diff --git a/net/gn/gn_routing.c b/net/gn/gn_routing.c
new file mode 100644
index 000000000000..7d8df7165ecb
--- /dev/null
+++ b/net/gn/gn_routing.c
@@ -0,0 +1,646 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": %s: " fmt, __func__
+#include <linux/types.h>
+#include <linux/bitfield.h>
+#include <linux/hashtable.h>
+#include <linux/spinlock.h>
+#include <linux/skbuff.h>
+#include <net/datalink.h>
+
+#include <linux/gn_routing.h>
+#include <linux/gn.h>
+
+extern struct datalink_proto *gn_dl;
+
+static DEFINE_HASHTABLE(gn_loc_t, 3);
+static DEFINE_SPINLOCK(gn_loc_t_lock);
+
+// ###### values in meters
+#define EARTH_RADIUS 6378388ULL
+#define PI 31415926ULL // * 10^7
+#define METER_PER_LON 111317ULL
+#define RAD_PER_DEGREE 174533ULL // * 10^7 - same as long and lat from PV
+
+#define GN_LT_JIFFIES msecs_to_jiffies(GN_LOC_TE_LIFETIME)
+#define GN_TST_VALID(tst) \
+	time_before(jiffies, (unsigned long)(tst) + GN_LT_JIFFIES)
+
+/* GeoNetworking routing */
+
+static u16 *gn_dpd_find(struct gn_dpd_buf *buf, u16 sn)
+{
+	int i = 0;
+
+	for (; i < GN_DPL_SIZE; i++) {
+		if (buf->sn[i] == sn)
+			return &buf->sn[i];
+	}
+	return NULL;
+}
+
+static void gn_dpd_insert(struct gn_dpd_buf *buf, u16 sn)
+{
+	buf->sn[buf->head] = sn;
+	buf->head = (buf->head + 1) % GN_DPL_SIZE;
+}
+
+static u32 pdr(u32 old_pdr, u32 delta)
+{
+	if (!delta)
+		delta = 1;
+	return (GN_MAX_PDR_EMA_BETA * old_pdr) / 100 +
+	       (((100 - GN_MAX_PDR_EMA_BETA) * (100 / delta)) / 100);
+}
+
+// table is * 1000 | p1 * 100 entry
+static const int cos_table[] = {
+	100000, 99995,	99980,	99955,	99920,	99875,	99820,	99755,	99680,
+	99595,	99500,	99396,	99281,	99156,	99022,	98877,	98723,	98558,
+	98384,	98200,	98007,	97803,	97590,	97367,	97134,	96891,	96639,
+	96377,	96106,	95824,	95534,	95233,	94924,	94604,	94275,	93937,
+	93590,	93233,	92866,	92491,	92106,	91712,	91309,	90897,	90475,
+	90045,	89605,	89157,	88699,	88233,	87758,	87274,	86782,	86281,
+	85771,	85252,	84726,	84190,	83646,	83094,	82534,	81965,	81388,
+	80803,	80210,	79608,	78999,	78382,	77757,	77125,	76484,	75836,
+	75181,	74517,	73847,	73169,	72484,	71791,	71091,	70385,	69671,
+	68950,	68222,	67488,	66746,	65998,	65244,	64483,	63715,	62941,
+	62161,	61375,	60582,	59783,	58979,	58168,	57352,	56530,	55702,
+	54869,	54030,	53186,	52337,	51482,	50622,	49757,	48887,	48012,
+	47133,	46249,	45360,	44466,	43568,	42666,	41759,	40849,	39934,
+	39015,	38092,	37166,	36236,	35302,	34365,	33424,	32480,	31532,
+	30582,	29628,	28672,	27712,	26750,	25785,	24818,	23848,	22875,
+	21901,	20924,	19945,	18964,	17981,	16997,	16010,	15023,	14033,
+	13042,	12050,	11057,	10063,	9067,	8071,	7074,	6076,	5077,
+	4079,	3079,	2079,	1080,	0,	-920,	-1920,	-2920,	-3919,
+	-4918,	-5917,	-6915,	-7912,	-8909,	-9904,	-10899, -11892, -12884,
+	-13875, -14865, -15853, -16840, -17825, -18808, -19789, -20768, -21745,
+	-22720, -23693, -24663, -25631, -26596, -27559, -28519, -29476, -30430,
+	-31381, -32329, -33274, -34215, -35153, -36087, -37018, -37945, -38868,
+	-39788, -40703, -41615, -42522, -43425, -44323, -45218, -46107, -46992,
+	-47873, -48748, -49619, -50485, -51345, -52201, -53051, -53896, -54736,
+	-55570, -56399, -57221, -58039, -58850, -59656, -60455, -61249, -62036,
+	-62817, -63592, -64361, -65123, -65879, -66628, -67370, -68106, -68834,
+	-69556, -70271, -70979, -71680, -72374, -73060, -73739, -74411, -75075,
+	-75732, -76382, -77023, -77657, -78283, -78901, -79512, -80114, -80709,
+	-81295, -81873, -82444, -83005, -83559, -84104, -84641, -85169, -85689,
+	-86200, -86703, -87197, -87682, -88158, -88626, -89085, -89534, -89975,
+	-90407, -90830, -91244, -91648, -92044, -92430, -92807, -93175, -93533,
+	-93883, -94222, -94553, -94873, -95185, -95486, -95779, -96061, -96334,
+	-96598, -96852, -97096, -97330, -97555, -97770, -97975, -98170, -98356,
+	-98531, -98697, -98853, -98999, -99135, -99262, -99378, -99484, -99581,
+	-99667, -99744, -99810, -99867, -99914, -99950, -99977, -99993, -100000
+};
+
+/* icos() - look up in cos_table for a rad value.
+ * @rad : the rad value.* 10^7
+ *
+ * Return : the cosine value * 100000
+ */
+static int icos(__s64 rad)
+{
+	size_t idx;
+
+	if (rad < 0)
+		rad = -rad;
+
+	if (rad >= 2 * PI)
+		rad %= (2 * PI);
+
+	if (rad > PI)
+		rad = 2 * PI - rad;
+
+	idx = rad / 100000;
+	if (idx >= ARRAY_SIZE(cos_table))
+		idx = ARRAY_SIZE(cos_table) - 1;
+
+	return cos_table[idx];
+}
+
+/* degree_to_rad() - convert a degree value to a rad value.
+ * @a : the degree value as 1/10 micro degree (10^7).
+ *
+ * Return : the rad value * 10^7.
+ */
+static __s64 degree_to_rad(__s64 a)
+{
+	return (((RAD_PER_DEGREE * a) / 10000000ULL)) % (PI * 2ULL);
+}
+
+/* diff() - calculate the difference beween a and b.
+ * @a : value a.
+ * @b : value b.
+ *
+ * Return : the difference
+ */
+static __s32 diff(__s32 a, __s32 b)
+{
+	__s32 r = a - b;
+
+	return r < 0 ? r * -1 : r;
+}
+
+/* get_distance() - calculate the distance of to position vectors
+ * center/self: positionvectors, whose distance is calculated
+ * @x : after execute includes the meter on X-axes.
+ * @y : after execute includes the meter on Y-axes.
+ *
+ * the calculation based on pythagoras.
+ */
+static struct gn_coord gn_coord_diff(struct gn_coord lhs, struct gn_coord rhs)
+{
+	struct gn_coord c;
+	s32 lat;
+
+	lat = degree_to_rad((lhs.lat + rhs.lat) / 2);
+
+	c.lat = (METER_PER_LON * icos(lat) * diff(rhs.lon, lhs.lon)) /
+		(10000000ULL * 100000ULL);
+	c.lon = (METER_PER_LON * diff(rhs.lat, lhs.lat)) / 10000000ULL;
+	return c;
+}
+
+static inline struct gn_coord pv_to_coord(struct gn_lpv *pv)
+{
+	struct gn_coord c = {
+		.lat = be32_to_cpu(pv->lat),
+		.lon = be32_to_cpu(pv->lon),
+	};
+	return c;
+}
+
+static inline u64 dist(struct gn_coord c)
+{
+	return c.lat * c.lat + c.lon * c.lon;
+}
+
+/* gn_F() - decides if self is inside or at the border of the geographical area.
+ * @center: The position vector of the Package sender.
+ * @self: The own position vector.
+ * @t : The Type of geographical area.
+ * @r : The radius of area. Only use for circle.
+ * @a : The width of area. Only use for rectangel and elipse.
+ * @b : The height of area. Only use for rectangel and elipse.
+ * @angel : ???
+ *
+ * Return:  if the result is > 0 self is inside area.
+			if the result is 0 self is on border of area.
+			otherwise self is outside of area.
+ */
+__s64 gn_F(struct gn_coord self, struct gn_geo_scope scope)
+{
+	struct gn_coord coord_diff = gn_coord_diff(self, scope.coord);
+	s32 a2, b2, x2, y2;
+	s64 result = -1;
+	/* Note: Scope angle rotation for non-circular geographical areas */
+	a2 = scope.a * scope.a;
+	b2 = scope.b * scope.b;
+	x2 = coord_diff.lat * coord_diff.lat;
+	y2 = coord_diff.lon * coord_diff.lon;
+
+	switch (scope.shape) {
+	case GN_SHAPE_CIRCLE:
+		result = a2 - (x2 + y2);
+		break;
+	case GN_SHAPE_RECTANGLE:
+		result = a2 - x2;
+		if (result > (b2 - y2))
+			result = b2 - y2;
+		break;
+	case GN_SHAPE_ELLIPSE:
+		if (scope.a == 0 || scope.b == 0) {
+			pr_debug("internal error: input out of range");
+			break;
+		}
+		result = 1000;
+		result -= (y2 * 1000) / a2;
+		result -= (x2 * 1000) / b2;
+		break;
+	}
+
+	return result;
+}
+
+static int greedy_forward(struct gn_iface *gnif, u8 *addr, struct gn_lpv *depv)
+{
+	struct gn_coord dest_coord = pv_to_coord(depv);
+	u64 min_dist, curr_dist, ego_dist;
+	u8 *found_addr = NULL;
+	struct loc_te *curr;
+	int bkt, rc;
+
+	ego_dist = dist(gn_coord_diff(dest_coord, gnif->pos.coord));
+	min_dist = ego_dist;
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each(gn_loc_t, bkt, curr, hnode) {
+		if (curr->is_neighbour) {
+			curr_dist = dist(gn_coord_diff(dest_coord,
+						       pv_to_coord(&curr->pv)));
+			if (curr_dist < min_dist) {
+				min_dist = curr_dist;
+				found_addr = curr->ll_address;
+			}
+		}
+	}
+	/* Note: Traffic class and store-carry-forward evaluation for next-hop selection */
+	if (found_addr) {
+		ether_addr_copy(addr, found_addr);
+		rc = GN_FORWARD_NEXT_HOP;
+	} else {
+		rc = GN_FORWARD_BROADCAST;
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+
+	return rc;
+}
+
+int gn_gxc_forward(struct gn_iface *gnif, s64 f, u8 *addr, struct gn_lpv *depv)
+{
+	if (f >= 0) {
+		// Area forwarding
+		switch (GN_AREA_FORWARDING) {
+		case GN_AREA_FORWARDING_SIMPLE:
+			return GN_FORWARD_BROADCAST;
+		default:
+			pr_warn("non-simple area forwarding not implemented");
+			return GN_FORWARD_BROADCAST;
+		}
+	} else {
+		// Non-area forwarding
+		switch (GN_NON_AREA_FORWARDING) {
+		case GN_NON_AREA_FORWARDING_GREEDY:
+			return greedy_forward(gnif, addr, depv);
+		default:
+			return GN_FORWARD_BROADCAST;
+		}
+	}
+}
+
+static void debug_loc_te(void)
+{
+	struct hlist_node *tmp;
+	struct loc_te *entry;
+	int bucket;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	if (hash_empty(gn_loc_t)) {
+		spin_unlock_bh(&gn_loc_t_lock);
+		return;
+	}
+
+	pr_debug("Printing location table\n");
+	hash_for_each_safe(gn_loc_t, bucket, tmp, entry, hnode) {
+		pr_debug(
+			"LOC_TE(%p) tst=%x addr=%llx ll_addr=%llx is_neighbour=%x ls_pending=%x\n",
+			entry, entry->tst_addr, be64_to_cpu(entry->addr),
+			ether_addr_to_u64(entry->ll_address),
+			entry->is_neighbour, entry->ls_pending);
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+}
+
+static void gn_prune(void)
+{
+	struct hlist_node *tmp;
+	struct loc_te *entry;
+	int bucket;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each_safe(gn_loc_t, bucket, tmp, entry, hnode) {
+		if (!GN_TST_VALID(entry->tst_addr)) {
+			pr_debug("pruning entry addr=%llx\n", entry->addr);
+			skb_queue_purge(&entry->lsb);
+			hash_del(&entry->hnode);
+			kfree(entry);
+		}
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+}
+
+/* update_location_table() - update location table
+ * @pv: the position vector which indicate an entry.
+ *
+ * Return: 0 on success, negative errno on error, -EALREADY if packet is duplicate.
+ *
+ * Update an entry, which indicated by @spv. If no entry found its will be add a new one.
+ * And all entries will be check with the update function.
+ */
+int gn_update_location_table(struct gn_lpv *pv, bool make_neighbour,
+			     const u8 *ll_address, const __be16 *sn)
+{
+	/* ETSI EN 302 636-4-1 Clause C.2: Update PV only when incoming PV timestamp is newer */
+	struct loc_te *entry;
+	bool found = false;
+
+	if (gn_find_interface(pv->addr))
+		return -EINVAL;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each_possible(gn_loc_t, entry, hnode, pv->addr) {
+		if (entry->addr != pv->addr)
+			continue;
+
+		found = true;
+
+		pr_debug("updating entry addr=%llx\n", pv->addr);
+
+		entry->pdr = pdr(entry->pdr,
+				 jiffies_to_msecs(jiffies) -
+					 jiffies_to_msecs(entry->tst_addr));
+		entry->tst_addr = jiffies;
+		if (make_neighbour) {
+			if (!ll_address) {
+				spin_unlock_bh(&gn_loc_t_lock);
+				return -EINVAL;
+			}
+			ether_addr_copy(entry->ll_address, ll_address);
+			entry->is_neighbour = true;
+		}
+		memcpy(&entry->pv, pv, sizeof(*pv));
+		if (sn) {
+			// Perform DPD
+			if (gn_dpd_find(&entry->dpl, be16_to_cpu(*sn))) {
+				pr_debug("received duplicate packet\n");
+				spin_unlock_bh(&gn_loc_t_lock);
+				return -EALREADY;
+			}
+			gn_dpd_insert(&entry->dpl, be16_to_cpu(*sn));
+		}
+		break;
+	}
+
+	if (!found) {
+		entry = kzalloc_obj(*entry, GFP_ATOMIC);
+		if (!entry) {
+			spin_unlock_bh(&gn_loc_t_lock);
+			return -ENOMEM;
+		}
+		pr_debug("adding entry addr=%llx\n", pv->addr);
+		entry->addr = pv->addr;
+		entry->tst_addr = jiffies;
+		entry->is_neighbour = make_neighbour;
+		memcpy(&entry->pv, pv, sizeof(*pv));
+		skb_queue_head_init(&entry->lsb);
+		if (make_neighbour) {
+			if (!ll_address) {
+				kfree(entry);
+				spin_unlock_bh(&gn_loc_t_lock);
+				return -EINVAL;
+			}
+			ether_addr_copy(entry->ll_address, ll_address);
+		}
+		if (sn)
+			gn_dpd_insert(&entry->dpl, be16_to_cpu(*sn));
+
+		hash_add(gn_loc_t, &entry->hnode, entry->addr);
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+
+	gn_prune();
+
+	debug_loc_te();
+
+	return 0;
+}
+
+static void __ls_queue(struct sk_buff_head *q, struct sk_buff *skb)
+{
+	u32 qlen = skb_queue_len(q);
+	struct sk_buff *curr;
+
+	while (qlen-- > GN_LSB_SIZE) {
+		curr = skb_dequeue(q);
+		if (curr)
+			kfree_skb(curr);
+	}
+
+	skb_queue_tail(q, skb);
+}
+
+/* ls_queue() - queue packet for delivery if destination is not a neighbour
+ * @dest_addr: destination address
+ * @skb: the packet
+ *
+ * If the destination address is not a known neighbour ẃith recent activity,
+ * queue the packet
+ *
+ * Return: GN_QUEUE_DIRECT if the destination is a neighbour,
+ * GN_QUEUE_LS_PENDING if the destination is unknown, but a LS request is
+ * pending and the packet is queued,
+ * GN_QUEUE_LS_STALE if the destination is unknown or its entry is stale and
+ * we should send a LS query, GN_QUEUE_ERROR on error
+ */
+int gn_ls_queue(gn_address_t dest_addr, struct sk_buff *skb)
+{
+	struct loc_te *entry;
+	int rc = -ENOENT;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each_possible(gn_loc_t, entry, hnode, dest_addr) {
+		if (entry->addr != dest_addr)
+			continue;
+
+		if (GN_TST_VALID(entry->tst_addr)) {
+			// Entry is valid, no need for LS
+			rc = GN_QUEUE_DIRECT;
+		} else if (entry->ls_pending == 1) {
+			// Entry is stale, but we already sent a LS request
+			rc = GN_QUEUE_LS_PENDING;
+			__ls_queue(&entry->lsb, skb);
+		} else {
+			// Entry is stale, perform LS request
+			rc = GN_QUEUE_LS_STALE;
+
+			entry->ls_pending = 1;
+			__ls_queue(&entry->lsb, skb);
+		}
+
+		break;
+	}
+	if (rc == -ENOENT) {
+		entry = kzalloc_obj(*entry, GFP_ATOMIC);
+		if (!entry) {
+			spin_unlock_bh(&gn_loc_t_lock);
+			return -ENOMEM;
+		}
+
+		rc = GN_QUEUE_LS_STALE;
+		entry->addr = dest_addr;
+		entry->ls_pending = 1;
+		skb_queue_head_init(&entry->lsb);
+		__ls_queue(&entry->lsb, skb);
+
+		hash_add(gn_loc_t, &entry->hnode, entry->addr);
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+
+	return rc;
+}
+
+void gn_ls_flush(gn_address_t dest_addr)
+{
+	struct sk_buff *tmp_skb;
+	u8 ll_address[ETH_ALEN];
+	struct loc_te *entry;
+	bool has_mac = false;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each_possible(gn_loc_t, entry, hnode, dest_addr) {
+		if (entry->addr != dest_addr)
+			continue;
+		if (!entry->ls_pending)
+			break;
+
+		if (entry->is_neighbour &&
+		    !is_zero_ether_addr(entry->ll_address)) {
+			ether_addr_copy(ll_address, entry->ll_address);
+			has_mac = true;
+		}
+
+		while ((tmp_skb = skb_dequeue(&entry->lsb)) != NULL) {
+			struct gn_header *gh =
+				(struct gn_header *)skb_network_header(tmp_skb);
+			struct gn_iface *gnif =
+				gn_find_interface_by_dev(tmp_skb->dev);
+
+			/* Populate DEPV for queued GeoUnicast packets when location is
+			   resolved */
+			if (gh->gc_h.ht == CH_HT_GUC) {
+				gh->guc_h.depv.tst = entry->pv.tst;
+				gh->guc_h.depv.lat = entry->pv.lat;
+				gh->guc_h.depv.lon = entry->pv.lon;
+			}
+
+			if (has_mac)
+				gn_dl->request(gn_dl, tmp_skb, ll_address);
+			else if (gnif && !gn_query_ll_nexthop(gnif, dest_addr,
+							      ll_address))
+				gn_dl->request(gn_dl, tmp_skb, ll_address);
+			else
+				gn_dl->request(gn_dl, tmp_skb,
+					       tmp_skb->dev->broadcast);
+		}
+		entry->ls_pending = 0;
+		break;
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+}
+
+int gn_query_ll_address(gn_address_t query_addr, u8 *ll_address)
+{
+	struct loc_te *entry;
+	int rc = -ENOENT;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each_possible(gn_loc_t, entry, hnode, query_addr) {
+		if (entry->addr != query_addr)
+			continue;
+		if (!entry->is_neighbour || !GN_TST_VALID(entry->tst_addr))
+			break;
+		if (is_zero_ether_addr(entry->ll_address))
+			break;
+
+		rc = 0;
+		ether_addr_copy(ll_address, entry->ll_address);
+		break;
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+
+	return rc;
+}
+
+/**
+ * gn_query_ll_nexthop - Query linklayer address or next-hop for GUC forwarding
+ * @gnif: Local GeoNetworking interface sending the packet
+ * @query_addr: Destination GeoNetworking address
+ * @ll_address: Buffer to receive the linklayer (MAC) address
+ *
+ * If query_addr is a direct 1-hop neighbor, resolves directly to its MAC
+ * address.
+ * If query_addr is a multi-hop destination in LocTE, runs greedy forwarding
+ * to select the best next-hop neighbor toward the destination.
+ *
+ * Return: 0 if linklayer address resolved, negative errno if broadcast needed.
+ */
+int gn_query_ll_nexthop(struct gn_iface *gnif, gn_address_t query_addr,
+			u8 *ll_address)
+{
+	bool is_neighbor = false;
+	struct gn_lpv target_pv;
+	struct loc_te *entry;
+	bool found = false;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each_possible(gn_loc_t, entry, hnode, query_addr) {
+		if (entry->addr != query_addr)
+			continue;
+		if (!GN_TST_VALID(entry->tst_addr))
+			break;
+		if (entry->is_neighbour &&
+		    !is_zero_ether_addr(entry->ll_address)) {
+			ether_addr_copy(ll_address, entry->ll_address);
+			is_neighbor = true;
+		} else {
+			target_pv = entry->pv;
+		}
+		found = true;
+		break;
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+
+	if (!found)
+		return -ENOENT;
+	if (is_neighbor)
+		return 0;
+
+	return (greedy_forward(gnif, ll_address, &target_pv) ==
+		GN_FORWARD_NEXT_HOP) ?
+		       0 :
+		       -EHOSTUNREACH;
+}
+
+/**
+ * gn_fill_depv - Populate Destination Position Vector (DEPV) from Location Table
+ * @depv: Pointer to gn_spv struct to populate
+ * @dest_addr: GeoNetworking address of the destination
+ *
+ * Return: 0 if valid destination position found in LocTE,
+ * negative error code otherwise.
+ */
+int gn_fill_depv(struct gn_spv *depv, gn_address_t dest_addr)
+{
+	struct loc_te *entry;
+	int rc = -ENOENT;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each_possible(gn_loc_t, entry, hnode, dest_addr) {
+		if (entry->addr != dest_addr)
+			continue;
+		if (GN_TST_VALID(entry->tst_addr)) {
+			depv->addr = entry->pv.addr;
+			depv->tst = entry->pv.tst;
+			depv->lat = entry->pv.lat;
+			depv->lon = entry->pv.lon;
+			rc = 0;
+		}
+		break;
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+
+	return rc;
+}
+
+void gn_routing_exit(void)
+{
+	struct hlist_node *tmp;
+	struct loc_te *entry;
+	int bucket;
+
+	spin_lock_bh(&gn_loc_t_lock);
+	hash_for_each_safe(gn_loc_t, bucket, tmp, entry, hnode) {
+		skb_queue_purge(&entry->lsb);
+		hash_del(&entry->hnode);
+		kfree(entry);
+	}
+	spin_unlock_bh(&gn_loc_t_lock);
+}
diff --git a/net/gn/sysctl_net_gn.c b/net/gn/sysctl_net_gn.c
new file mode 100644
index 000000000000..12bb2cb64135
--- /dev/null
+++ b/net/gn/sysctl_net_gn.c
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * sysctl_net_gn.c: sysctl interface to net GeoNetworking subsystem
+ */
+
+#include <linux/sysctl.h>
+#include <net/sock.h>
+#include <linux/gn.h>
+
+static int dummy_var = 1234;
+
+static struct ctl_table gn_table[] = { {
+	.procname = "gn-dummy-var",
+	.data = &dummy_var,
+	.maxlen = sizeof(int),
+	.mode = 0644,
+	.proc_handler = proc_dointvec,
+} };
+
+static struct ctl_table_header *gn_table_header;
+
+int __init gn_register_sysctl(void)
+{
+	gn_table_header = register_net_sysctl(&init_net, "net/gn", gn_table);
+	if (!gn_table_header)
+		return -ENOMEM;
+	return 0;
+}
+
+void gn_unregister_sysctl(void)
+{
+	unregister_net_sysctl_table(gn_table_header);
+}
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 1a713d96206f..38876505cec3 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -1318,7 +1318,10 @@ static inline u16 socket_type_to_security_class(int family, int type, int protoc
 			return SECCLASS_XDP_SOCKET;
 		case PF_MCTP:
 			return SECCLASS_MCTP_SOCKET;
-#if PF_MAX > 46
+		case PF_GN:
+			return SECCLASS_GN_SOCKET;
+
+#if PF_MAX > 47
 #error New address family defined, please update this function.
 #endif
 		}
diff --git a/security/selinux/include/classmap.h b/security/selinux/include/classmap.h
index 90cb61b16425..dfa07a586060 100644
--- a/security/selinux/include/classmap.h
+++ b/security/selinux/include/classmap.h
@@ -174,6 +174,7 @@ const struct security_class_mapping secclass_map[] = {
 	    "map_create_as", "prog_load_as", NULL } },
 	{ "xdp_socket", { COMMON_SOCK_PERMS, NULL } },
 	{ "mctp_socket", { COMMON_SOCK_PERMS, NULL } },
+	{ "gn_socket",	{ COMMON_SOCK_PERMS, NULL } },
 	{ "perf_event",
 	  { "open", "cpu", "kernel", "tracepoint", "read", "write", NULL } },
 	{ "anon_inode", { COMMON_FILE_PERMS, NULL } },
@@ -187,7 +188,7 @@ const struct security_class_mapping secclass_map[] = {
 #ifdef __KERNEL__ /* avoid this check when building host programs */
 #include <linux/socket.h>
 
-#if PF_MAX > 46
+#if PF_MAX > 47
 #error New address family defined, please update secclass_map.
 #endif
 #endif
-- 
2.55.0

