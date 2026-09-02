Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABDFF36B90A
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338778; cv=none; b=fon94EYElgCFYGTn2L7iOBZbmd62zDUb8vGimoWVvpHbk+FCmhZCaqSshTF+Ef82P2PuDGNXvOCCXirDY5BA6fRZf8zD7eyeeoHjlMv19zVpFiVeNwQbpovpJqw8GWGxupjzm+no0YdUB2d043vv5a/5unmSYEKd56OxZhJa23c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338778; c=relaxed/simple;
	bh=pc6SeyptnfE5McwqWYorfpv6kABuBplDi8tuJI9a+d0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVhfuer2ci+VeApW7Y6v+PFVI7LdF/nBP9gjH/ObBy5s0z2gcUKzAgZfITjTZ/QIgdDsYCB0gZECkO1P0Taw9punXo/3H6i4wQHoWBaccu+/BL97Vyn3OYuoyJg5OamYif86CeMp6wegQymmUMa1c5b8wX4uErvbv1k0JPoAkoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=XOKwqd8m; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="XOKwqd8m"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=I/AJ6vBBYygED59HkU3zqsmkdX87NV8k/QQhLeSHWkk=; b=XOKwqd8mRvmefjoLY2ykQonDsU
	dv1Rum+4aQvTHZsvF65Turbp8OtbmpPdvMB+OaBHe1EbG2zNBFngGgUKcb7jbPHjMae7UUq6dQBVA
	6NfOqM/CFNmbg1wseC4XQEXzLdm7hnv5xbkJxXrFBWKcaN5LCHib5bcMbJkHfCHLZ6HI=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbl-00Cwkn-35;
	Wed, 02 Sep 2026 10:46:14 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 02/15] wifi: cfg80211: add the flow parser and the MSCS key
Date: Wed,  2 Sep 2026 10:45:57 +0200
Message-ID: <1a4481f449b5544f4193f5d46bb76487f57994f6.1788338716.git-series.nbd@nbd.name>
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

An SCS classifier is compared against the parameters of an MSDU, and an
MSCS lookup is keyed on them, so both need the frame read once into the
shape the classifier parser produces.

cfg80211_flow_parse() records which parameters the frame carries, because
a classifier that names one the frame lacks must not match. It reports
the ethertype behind any VLAN tag, so a tag the hardware stripped and an
inline one give the same answer, and for IPv6 the protocol of the header
itself rather than of whatever follows the extension headers.

It starts at skb->data instead of trusting skb->protocol or the network
header offset, because a frame the receive path forwards between two
stations arrives with skb->protocol set to ETH_P_802_3 and the network
header reset.

cfg80211_flow_key_build() masks the parsed frame down to the parameters
an MSCS names, and mirrors it when the caller asks: 11.25.3 item b) swaps
the addresses and the ports and nothing else.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h |  31 ++++++-
 net/wireless/scs.c     | 228 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 259 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 795dd87b795e..db5f53147179 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4181,6 +4181,37 @@ struct cfg80211_tclas {
 };
 
 /**
+ * struct cfg80211_flow_info - classifier parameters of one MSDU
+ *
+ * @key: every parameter the source carries, with nothing masked out
+ * @present: bitmap of &enum cfg80211_flow_field, the parameters that the
+ *	source really carries. A classifier that names an absent parameter
+ *	does not match.
+ */
+struct cfg80211_flow_info {
+	struct cfg80211_flow_key key;
+	u32 present;
+};
+
+bool cfg80211_flow_parse(struct sk_buff *skb, struct cfg80211_flow_info *info);
+
+/**
+ * enum cfg80211_flow_dir - direction of a built flow key
+ *
+ * @CFG80211_FLOW_AS_IS: the key describes the frame that was parsed
+ * @CFG80211_FLOW_MIRRORED: the key describes the reverse direction, so the
+ *	three pairs of IEEE Std 802.11-2024, 11.25.3 item b) are swapped
+ */
+enum cfg80211_flow_dir {
+	CFG80211_FLOW_AS_IS,
+	CFG80211_FLOW_MIRRORED,
+};
+
+bool cfg80211_flow_key_build(const struct cfg80211_flow_info *info, u32 fields,
+			     enum cfg80211_flow_dir dir,
+			     struct cfg80211_flow_key *key);
+
+/**
  * DOC: Neighbor Awareness Networking (NAN)
  *
  * NAN uses two interface types:
diff --git a/net/wireless/scs.c b/net/wireless/scs.c
index b674d5aa180e..06ba0a3a4184 100644
--- a/net/wireless/scs.c
+++ b/net/wireless/scs.c
@@ -466,3 +466,231 @@ int cfg80211_parse_tclas_mask(const u8 *elems, size_t len, u32 *fields)
 	return 0;
 }
 EXPORT_SYMBOL_IF_CFG80211_KUNIT(cfg80211_parse_tclas_mask);
+
+#define FLOW_F_PORTS	(FLOW_F(SRC_PORT) | FLOW_F(DST_PORT))
+
+static void cfg80211_flow_parse_ports(struct sk_buff *skb, unsigned int offset,
+				      int proto, struct cfg80211_flow_info *info)
+{
+	__be16 ports[2], *p;
+
+	switch (proto) {
+	case IPPROTO_TCP:
+	case IPPROTO_UDP:
+	case IPPROTO_SCTP:
+		break;
+	default:
+		return;
+	}
+
+	p = skb_header_pointer(skb, offset, sizeof(ports), ports);
+	if (!p)
+		return;
+
+	info->key.src_port = p[0];
+	info->key.dst_port = p[1];
+	info->present |= FLOW_F_PORTS;
+}
+
+static void cfg80211_flow_parse_ipv4(struct sk_buff *skb, unsigned int offset,
+				     struct cfg80211_flow_info *info)
+{
+	struct iphdr iph_buf, *iph;
+
+	iph = skb_header_pointer(skb, offset, sizeof(*iph), &iph_buf);
+	if (!iph || iph->version != 4 || iph->ihl < 5)
+		return;
+
+	info->key.ip_version = 4;
+	info->key.dscp = ipv4_get_dsfield(iph) >> 2;
+	info->key.proto = iph->protocol;
+	memcpy(&info->key.src, &iph->saddr, sizeof(iph->saddr));
+	memcpy(&info->key.dst, &iph->daddr, sizeof(iph->daddr));
+	info->present |= FLOW_F(IP_VERSION) | FLOW_F(IP_SRC) | FLOW_F(IP_DST) |
+			 FLOW_F(DSCP) | FLOW_F(PROTO);
+
+	if (iph->frag_off & htons(IP_OFFSET))
+		return;
+
+	cfg80211_flow_parse_ports(skb, offset + iph->ihl * 4, iph->protocol,
+				  info);
+}
+
+static void cfg80211_flow_parse_ipv6(struct sk_buff *skb, unsigned int offset,
+				     struct cfg80211_flow_info *info)
+{
+	struct ipv6hdr ip6h_buf, *ip6h;
+	__be16 frag_off = 0;
+	int l4_off;
+	u8 nexthdr;
+
+	ip6h = skb_header_pointer(skb, offset, sizeof(*ip6h), &ip6h_buf);
+	if (!ip6h || ip6h->version != 6)
+		return;
+
+	info->key.ip_version = 6;
+	info->key.dscp = ipv6_get_dsfield(ip6h) >> 2;
+	info->key.flow_label = ip6_flowlabel(ip6h);
+	info->key.src = ip6h->saddr;
+	info->key.dst = ip6h->daddr;
+
+	/*
+	 * The parameter is the field of the IPv6 header, not the upper layer
+	 * protocol behind the extension headers.
+	 */
+	info->key.proto = ip6h->nexthdr;
+	info->present |= FLOW_F(IP_VERSION) | FLOW_F(IP_SRC) | FLOW_F(IP_DST) |
+			 FLOW_F(DSCP) | FLOW_F(FLOW_LABEL) | FLOW_F(PROTO);
+
+	nexthdr = ip6h->nexthdr;
+	l4_off = ipv6_skip_exthdr(skb, offset + sizeof(*ip6h), &nexthdr,
+				  &frag_off);
+	if (l4_off < 0 || frag_off & htons(IP6_OFFSET))
+		return;
+
+	cfg80211_flow_parse_ports(skb, l4_off, nexthdr, info);
+}
+
+/**
+ * cfg80211_flow_parse - read the classifier parameters of an MSDU
+ *
+ * @skb: the frame, in IEEE 802.3 format
+ * @info: receives the parameters
+ *
+ * The parser starts at skb->data and treats it as an Ethernet header. It uses
+ * neither skb->protocol nor skb->network_header, because a frame that the
+ * receive path forwards between two stations arrives with skb->protocol equal
+ * to ETH_P_802_3 and with the network header reset to the Ethernet header.
+ *
+ * Return: %true when @info describes the frame.
+ */
+bool cfg80211_flow_parse(struct sk_buff *skb, struct cfg80211_flow_info *info)
+{
+	struct ethhdr eth_buf, *eth;
+	unsigned int offset = ETH_HLEN;
+	__be16 proto;
+
+	memset(info, 0, sizeof(*info));
+
+	eth = skb_header_pointer(skb, 0, sizeof(*eth), &eth_buf);
+	if (!eth)
+		return false;
+
+	ether_addr_copy(info->key.sa, eth->h_source);
+	ether_addr_copy(info->key.da, eth->h_dest);
+	info->present = FLOW_F(ETH_SA) | FLOW_F(ETH_DA);
+	proto = eth->h_proto;
+
+	if (skb_vlan_tag_present(skb)) {
+		info->key.vlan_tci = htons(skb_vlan_tag_get(skb));
+		info->present |= FLOW_F_VLAN;
+	} else if (eth_type_vlan(proto)) {
+		struct vlan_hdr vhdr_buf, *vhdr;
+
+		vhdr = skb_header_pointer(skb, offset, sizeof(*vhdr), &vhdr_buf);
+		if (!vhdr)
+			return false;
+
+		info->key.vlan_tci = vhdr->h_vlan_TCI;
+		info->present |= FLOW_F_VLAN;
+		proto = vhdr->h_vlan_encapsulated_proto;
+		offset += sizeof(*vhdr);
+	}
+
+	/*
+	 * The parameter is the ethertype behind any VLAN tag, so that a tag the
+	 * hardware stripped and an inline one give the same answer.
+	 */
+	info->key.eth_type = proto;
+	info->present |= FLOW_F(ETH_TYPE);
+
+	switch (proto) {
+	case htons(ETH_P_IP):
+		cfg80211_flow_parse_ipv4(skb, offset, info);
+		break;
+	case htons(ETH_P_IPV6):
+		cfg80211_flow_parse_ipv6(skb, offset, info);
+		break;
+	}
+
+	return true;
+}
+EXPORT_SYMBOL(cfg80211_flow_parse);
+
+static void flow_key_swap(struct cfg80211_flow_key *k)
+{
+	u8 addr[ETH_ALEN];
+
+	memcpy(addr, k->sa, ETH_ALEN);
+	memcpy(k->sa, k->da, ETH_ALEN);
+	memcpy(k->da, addr, ETH_ALEN);
+
+	swap(k->src, k->dst);
+	swap(k->src_port, k->dst_port);
+}
+
+/* Only these three pairs mirror; every other parameter mirrors onto itself */
+static u32 cfg80211_flow_fields_mirror(u32 fields)
+{
+	static const u8 pairs[][2] = {
+		{ CFG80211_FLOW_F_ETH_SA, CFG80211_FLOW_F_ETH_DA },
+		{ CFG80211_FLOW_F_IP_SRC, CFG80211_FLOW_F_IP_DST },
+		{ CFG80211_FLOW_F_SRC_PORT, CFG80211_FLOW_F_DST_PORT },
+	};
+	unsigned int i;
+	u32 out = fields;
+
+	for (i = 0; i < ARRAY_SIZE(pairs); i++) {
+		u32 lo = BIT(pairs[i][0]), hi = BIT(pairs[i][1]);
+
+		out &= ~(lo | hi);
+		if (fields & lo)
+			out |= hi;
+		if (fields & hi)
+			out |= lo;
+	}
+
+	return out;
+}
+
+/**
+ * cfg80211_flow_key_build - build an MSCS lookup key
+ *
+ * @info: parsed frame, from cfg80211_flow_parse()
+ * @fields: classifier parameters of the MSCS, a bitmap of
+ *	&enum cfg80211_flow_field
+ * @dir: %CFG80211_FLOW_MIRRORED when @info describes an uplink frame and the
+ *	key shall describe the downlink direction
+ * @key: receives the key
+ *
+ * Everything that @fields does not select stays zero, so the key is hashed and
+ * compared as a byte string.
+ *
+ * Return: %false when @info lacks a parameter that @fields selects, in which
+ *	case the MSDU is not classified at all.
+ */
+bool cfg80211_flow_key_build(const struct cfg80211_flow_info *info, u32 fields,
+			     enum cfg80211_flow_dir dir,
+			     struct cfg80211_flow_key *key)
+{
+	struct cfg80211_flow_key mirrored;
+
+	if (dir == CFG80211_FLOW_AS_IS) {
+		if (fields & ~info->present)
+			return false;
+
+		flow_key_select(&info->key, fields, key);
+
+		return true;
+	}
+
+	if (cfg80211_flow_fields_mirror(fields) & ~info->present)
+		return false;
+
+	mirrored = info->key;
+	flow_key_swap(&mirrored);
+	flow_key_select(&mirrored, fields, key);
+
+	return true;
+}
+EXPORT_SYMBOL(cfg80211_flow_key_build);
-- 
git-series 0.9.1
