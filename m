Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723048;
	b=wXWWxFNxD5PZqg6HD6HN/2g6u9eyqvXNLQgD7Dru0N5tBvFWZ0SQcrq3yZsHGjFtANdB
	 D1/t2+qD1DdIVGpi8dQoEteORcH897AQjrAemouqbG1nfsYKPHFXeT3tUCGnXHX6ng+dl
	 R76CE5hi02lbzGxtrvlLZuf5cFwwSbD2wwdLgveZs7NuNmEIUsHF/tEl2Wv5QCBqlMiGp
	 mp6yeIFbjq1jyxbB2dQKg7now3lLbEYdKlHwDOfdYkHj8Q4XQhLzuFvSczgg9iCRABWx1
	 8t5p79l7wcFJJZxZBv8Ls1aMRfYgzTWuATxkA9U8YK1jEfXX+WJ+HeeRNxt1/LplVHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723048;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=CLqDVtwE6wRnzmamJRmBNuLdC5i8jxufJ5NkHbKEOgQ=;
	b=R51ImgeP9BFutwEE5SjL172wyndtPJWDeMkkxT/5X0bsCAXWmfEuL9Qbrwx39OhrOMm0
	 GapA9k8Sgz6Dbw2QeZyQ+fSBhv2925cTmQJigJQhoCrITOQzzsI+LkbNQ1mfdhsiiTcR2
	 Jm6ACv/Z+uegMSFReGP6VPOmI2D5bF2zo4l8V5f84lqUbp2A60qu/VNSHHCSFmQHmov4x
	 gkgKlwJkGiI2PgW7BsT9ousvuepy9dTNm3I6mSfxOU1DyihExUk4+Q9dLUtvVj1K6u8Np
	 swFAVJRlbKbXgDHhXPfzC6QWlWBU87+0q9pEu6ju9peK0dksKQUOAFRAfYuTvqXETLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=hhxLBq1x;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D754606A339
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D754606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=hhxLBq1x
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=CLqDVtwE6wRnzmamJRmBNuLdC5i8jxufJ5NkHbKEOgQ=; b=hhxLBq1xZp0W0b3Nc4hfmCM/Tc
	OWRf9IvuT0PxUurgJsWcM/neBqfVYMdYn/PxWZPEXMTyp4DZ3gVkU0vrD7MYFzE1GREufRV0BnJ17
	3EC9Gd9TnFQQsSyrYaut9JpBUiCrNRZW2xIHIC/3XEbjuBElTQ5nhymmn39SBPKw2vXw=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIl-00FDFp-0y;
	Tue, 03 Nov 2026 17:23:59 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 02/18] wifi: cfg80211: add the flow parser and the MSCS key
Date: Tue,  3 Nov 2026 17:23:35 +0100
Message-ID: <ff6705a35dd9b47bc01ae32e9d797067504921f1.1793722802.git-series.nbd@nbd.name>
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

Add cfg80211_flow_parse(), which reads the classifier parameters of an
MSDU into the key layout that the TCLAS parser produces. It also
records which parameters the frame carries, so that a classifier that
selects a missing one, such as the ports of a later IP fragment, does
not match on a zero value.

Add cfg80211_flow_key_build(), which masks the parsed frame down to the
parameters that an MSCS selects. An AP learns a flow from an uplink
frame and looks it up on the downlink, so the key can also be built for
the mirrored direction.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h |  37 +++++++-
 net/wireless/scs.c     | 222 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 259 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index b1ffecd8f4f6..bb7b122e5020 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4220,6 +4220,43 @@ struct cfg80211_tclas {
 };
 
 /**
+ * struct cfg80211_flow_info - classifier parameters of one MSDU
+ *
+ * @key: every parameter the source carries, with nothing masked out
+ * @present: bitmap of &enum cfg80211_flow_field, the parameters the source
+ *	actually carries. A classifier that names an absent parameter cannot
+ *	match.
+ * @skb: the frame the parameters came from, or %NULL when the caller
+ *	describes a flow rather than a frame. A filter classifier reads the
+ *	frame again and cannot be evaluated without it.
+ * @l3_off: offset of the IP header in @skb
+ */
+struct cfg80211_flow_info {
+	struct cfg80211_flow_key key;
+	u32 present;
+	const struct sk_buff *skb;
+	u16 l3_off;
+};
+
+bool cfg80211_flow_parse(struct sk_buff *skb, struct cfg80211_flow_info *info);
+
+/**
+ * enum cfg80211_flow_dir - direction of a built flow key
+ *
+ * @CFG80211_FLOW_AS_IS: the key describes the frame that was parsed
+ * @CFG80211_FLOW_MIRRORED: the key describes the reverse direction, with the
+ *	addresses and the ports swapped
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
index 1f2ba9d9ec58..e8e3b5501b39 100644
--- a/net/wireless/scs.c
+++ b/net/wireless/scs.c
@@ -475,3 +475,225 @@ int cfg80211_parse_tclas_mask(const u8 *elems, size_t len, u32 *fields)
 	return 0;
 }
 EXPORT_SYMBOL_IF_CFG80211_KUNIT(cfg80211_parse_tclas_mask);
+
+#define FLOW_F_PORTS	(FLOW_F(SRC_PORT) | FLOW_F(DST_PORT))
+
+static void cfg80211_flow_parse_ports(struct sk_buff *skb,
+				      unsigned int offset, int proto,
+				      struct cfg80211_flow_info *info)
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
+	/* The classifier matches Next Header, not the layer 4 protocol */
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
+ * Parses from skb->data, since a frame forwarded between two stations
+ * arrives with skb->protocol set to ETH_P_802_3 and no network header.
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
+		vhdr = skb_header_pointer(skb, offset, sizeof(*vhdr),
+					  &vhdr_buf);
+		if (!vhdr)
+			return false;
+
+		info->key.vlan_tci = vhdr->h_vlan_TCI;
+		info->present |= FLOW_F_VLAN;
+		proto = vhdr->h_vlan_encapsulated_proto;
+		offset += sizeof(*vhdr);
+	}
+
+	/* Use the type behind the VLAN tag, whether it was stripped or not */
+	info->key.eth_type = proto;
+	info->present |= FLOW_F(ETH_TYPE);
+
+	info->skb = skb;
+	info->l3_off = offset;
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
+ * cfg80211_flow_key_build - build a flow key
+ *
+ * @info: the frame or flow
+ * @fields: the classifier parameters to keep, a bitmap of
+ *	&enum cfg80211_flow_field
+ * @dir: whether the key describes @info or the reverse direction
+ * @key: receives the key
+ *
+ * Everything that @fields does not select stays zero, so the key is hashed and
+ * compared as a byte string.
+ *
+ * Return: %false when @info lacks a parameter that @fields selects
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
