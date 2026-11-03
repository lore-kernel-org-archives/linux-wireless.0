Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723048;
	b=aAfaLI+29dkLqiLs170y2O6W45bdHy0RjUWElRBOaHhnIqpE7ygGr8pLbyJMrRKX9JjP
	 1QNCNKnRHQl+vVqnN0bHO2I4RueA+kWp6oycj6RjLoZYIji0deT+duEyeMuBCkE21Mdcm
	 5N396sO1pBedRqMoeeH4fzx5f6lzNhc+KKy0Rdi/rorwACPKlJruCvmBSceEGb9gY3FiS
	 IPd9zILg26WassvItKvGyeDmp43ojohTnocobAlqijq0b2p8ANJrVo07aygKdbNXNJmyC
	 4TbKGZp/4dGq6r/eB/vvKzT64cUQDUAbm6JMgHa9NNaLjXyREj56mODtoTce5MonHRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723048;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=sViWAvq8fJy6svB9FvzX9naFNDuKXQysa+ZQkFDooII=;
	b=ZovShtk+mgBCUtUnZHmZRo2OtyArKpEUXaW20kC8J84/mxQn2at3vWWR+tW54zASAgjk
	 8KGrFcHc+4iJhpUHATrB9Ya9kcGrvTZsoBw2dSaqDtxoVCf+mO1sOd/y55VJ/MlOYOav1
	 1dGTG4FH+NsE8RYFzUhdgqmpN8ZUbxmM9ppOaSw26pd0YMR4xyWeedMEUehPiAE67mtPC
	 sp4MVjlVEgefwe24DTzppY9hFcmsb6fAGnrxvuzgc2ZARXS2CXPGtr5ies+v772n2VnHr
	 Z3sjQZI4i0dFXzYczd201p5ecPz+IrSniPmzno57fwPwmhDgARhwr9kL8llwVNYgx1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=h5h6tLUE;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D89A606A33B
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D89A606A33B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=h5h6tLUE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=sViWAvq8fJy6svB9FvzX9naFNDuKXQysa+ZQkFDooII=; b=h5h6tLUERPPuu/VcESZKoH4rYd
	6GVcqNxQXHugx9Y2s6P8dyBecGSCOg5cLUzt06R8uiojhlPJ1X756JG4ZERwvk3LqkNLiDI9jVTsO
	GLFCX60qX9vztx1SR/CJLAGcf+80uyibK68ozOpaO2MsvoYJQbWkWFjpVPgZr+FrW5aE=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIl-00FDFp-1a;
	Tue, 03 Nov 2026 17:23:59 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 03/18] wifi: cfg80211: add the SCS evaluator
Date: Tue,  3 Nov 2026 17:23:36 +0100
Message-ID: <c8db19a443a4cd2dbdb68a7aaa41304d2aad6899.1793722802.git-series.nbd@nbd.name>
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

Add cfg80211_scs_evaluate(), which walks the active SCS descriptors of
a peer and returns the user priority of the descriptor that matches an
MSDU. When several descriptors match, the one that requires the most
classifier parameters wins.

A filter classifier cannot be answered from the flow key, so it reads
the frame again.

A descriptor can name a client, a host behind a 4-address peer. It then
only matches an MSDU whose destination address is that client.

The verdict also reports a descriptor that did not match only because
the MSDU lacks a parameter that it selects, if that descriptor would
take precedence over the result. A caller that evaluates a flow instead
of a frame must not derive a flow rule from such a verdict.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h |  44 +++++++-
 net/wireless/scs.c     | 260 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 304 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb7b122e5020..e2aaf80dbf7c 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4257,6 +4257,50 @@ bool cfg80211_flow_key_build(const struct cfg80211_flow_info *info, u32 fields,
 			     struct cfg80211_flow_key *key);
 
 /**
+ * struct cfg80211_scs_desc - one SCS descriptor
+ *
+ * @tclas_processing: how the elements of @tclas relate
+ * @id: SCSID, 1 to 255
+ * @up: user priority to assign to a matching MSDU
+ * @client: the host behind a 4-address peer that the descriptor applies
+ *	to, matched against the destination address of an MSDU. All zero
+ *	for every MSDU sent to the peer. The client does not scope @id,
+ *	which names one descriptor among all descriptors of the peer.
+ * @n_tclas: number of entries in @tclas
+ * @tclas: the classifier
+ */
+struct cfg80211_scs_desc {
+	enum cfg80211_tclas_processing tclas_processing;
+	u8 id;
+	u8 up;
+	u8 client[ETH_ALEN];
+	u8 n_tclas;
+	struct cfg80211_tclas tclas[] __counted_by(n_tclas);
+};
+
+/**
+ * struct cfg80211_scs_verdict - result of an SCS evaluation
+ *
+ * @match: an SCS descriptor matched the MSDU
+ * @undecided: a descriptor that would take precedence over the result
+ *	matches every parameter that the MSDU carries, but selects one that
+ *	it lacks. A caller that evaluates a flow instead of a frame must not
+ *	derive a flow rule from this verdict.
+ * @scsid: identifier of the matching descriptor
+ * @up: user priority to assign
+ */
+struct cfg80211_scs_verdict {
+	bool match;
+	bool undecided;
+	u8 scsid;
+	u8 up;
+};
+
+void cfg80211_scs_evaluate(struct cfg80211_scs_desc * const *desc, u8 n_desc,
+			   const struct cfg80211_flow_info *info,
+			   struct cfg80211_scs_verdict *verdict);
+
+/**
  * DOC: Neighbor Awareness Networking (NAN)
  *
  * NAN uses two interface types:
diff --git a/net/wireless/scs.c b/net/wireless/scs.c
index e8e3b5501b39..1418cb130638 100644
--- a/net/wireless/scs.c
+++ b/net/wireless/scs.c
@@ -697,3 +697,263 @@ bool cfg80211_flow_key_build(const struct cfg80211_flow_info *info, u32 fields,
 	return true;
 }
 EXPORT_SYMBOL(cfg80211_flow_key_build);
+
+static bool tclas_filter_offset(const struct cfg80211_flow_info *info,
+				const struct cfg80211_tclas_filter *f,
+				unsigned int *off)
+{
+	struct ipv6hdr ip6h_buf, *ip6h;
+	unsigned int pos = info->l3_off;
+	unsigned int hdrs = 0;
+	u8 instance = 0;
+	u8 nexthdr;
+
+	if (info->key.ip_version == 4) {
+		struct iphdr iph_buf, *iph;
+
+		iph = skb_header_pointer(info->skb, pos, sizeof(*iph),
+					 &iph_buf);
+		if (!iph || iph->ihl < 5 || iph->frag_off & htons(IP_OFFSET))
+			return false;
+
+		pos += iph->ihl * 4;
+		if (iph->protocol == f->protocol && instance++ == f->instance) {
+			*off = pos;
+
+			return true;
+		}
+
+		/* IPv6 inside IPv4 continues the chain (9.4.2.29) */
+		if (iph->protocol != IPPROTO_IPV6)
+			return false;
+	} else if (info->key.ip_version != 6) {
+		return false;
+	}
+
+	ip6h = skb_header_pointer(info->skb, pos, sizeof(*ip6h), &ip6h_buf);
+	if (!ip6h || ip6h->version != 6)
+		return false;
+
+	nexthdr = ip6h->nexthdr;
+	pos += sizeof(*ip6h);
+
+	while (hdrs++ < 8) {
+		struct ipv6_opt_hdr hdr_buf, *hdr;
+
+		if (nexthdr == f->protocol && instance++ == f->instance) {
+			*off = pos;
+
+			return true;
+		}
+
+		if (!ipv6_ext_hdr(nexthdr) || nexthdr == NEXTHDR_NONE)
+			return false;
+
+		if (nexthdr == NEXTHDR_FRAGMENT) {
+			struct frag_hdr fh_buf, *fh;
+
+			/* A later fragment has none of the headers behind this */
+			fh = skb_header_pointer(info->skb, pos, sizeof(*fh),
+						&fh_buf);
+			if (!fh || fh->frag_off & htons(IP6_OFFSET))
+				return false;
+
+			nexthdr = fh->nexthdr;
+			pos += sizeof(*fh);
+			continue;
+		}
+
+		hdr = skb_header_pointer(info->skb, pos, sizeof(*hdr),
+					 &hdr_buf);
+		if (!hdr)
+			return false;
+
+		if (nexthdr == NEXTHDR_AUTH)
+			pos += ipv6_authlen(hdr);
+		else
+			pos += ipv6_optlen(hdr);
+
+		nexthdr = hdr->nexthdr;
+	}
+
+	return false;
+}
+
+enum scs_match {
+	SCS_MATCH_NO,
+	SCS_MATCH_YES,
+	SCS_MATCH_UNDECIDED,
+};
+
+static enum scs_match tclas_filter_match(const struct cfg80211_tclas *t,
+					 const struct cfg80211_flow_info *info)
+{
+	const struct cfg80211_tclas_filter *f = &t->filter;
+	u8 buf[CFG80211_TCLAS_FILTER_LEN], *p;
+	unsigned int i, off;
+
+	if (!info->skb)
+		return SCS_MATCH_UNDECIDED;
+
+	if (!tclas_filter_offset(info, f, &off))
+		return SCS_MATCH_NO;
+
+	p = skb_header_pointer(info->skb, off, f->len, buf);
+	if (!p)
+		return SCS_MATCH_NO;
+
+	for (i = 0; i < f->len; i++)
+		if ((p[i] ^ f->value[i]) & f->mask[i])
+			return SCS_MATCH_NO;
+
+	return SCS_MATCH_YES;
+}
+
+static enum scs_match tclas_match(const struct cfg80211_tclas *t,
+				  const struct cfg80211_flow_info *info)
+{
+	u32 fields = t->fields & info->present;
+	struct cfg80211_flow_key key, want;
+
+	if (t->type == CFG80211_TCLAS_FILTER)
+		return tclas_filter_match(t, info);
+
+	flow_key_select(&info->key, fields, &key);
+	flow_key_select(&t->key, fields, &want);
+	if (memcmp(&key, &want, sizeof(key)))
+		return SCS_MATCH_NO;
+
+	/* A parameter that @info does not carry could still differ */
+	if (fields != t->fields)
+		return SCS_MATCH_UNDECIDED;
+
+	return SCS_MATCH_YES;
+}
+
+/* Number of classifier parameters required for a match, see 11.25.2 */
+static u16 tclas_param_count(const struct cfg80211_tclas *t)
+{
+	if (t->type == CFG80211_TCLAS_FILTER)
+		return 1;
+
+	if (t->type == CFG80211_TCLAS_VLAN)
+		return 3;
+
+	return hweight32(t->fields & ~FLOW_F(IP_VERSION));
+}
+
+static enum scs_match
+scs_desc_client_match(const struct cfg80211_scs_desc *desc,
+		      const struct cfg80211_flow_info *info)
+{
+	if (is_zero_ether_addr(desc->client))
+		return SCS_MATCH_YES;
+
+	if (!(info->present & FLOW_F(ETH_DA)))
+		return SCS_MATCH_UNDECIDED;
+
+	if (!ether_addr_equal(desc->client, info->key.da))
+		return SCS_MATCH_NO;
+
+	return SCS_MATCH_YES;
+}
+
+/* A definite result of one element decides over an undecided one */
+static enum scs_match scs_desc_match(const struct cfg80211_scs_desc *desc,
+				     const struct cfg80211_flow_info *info)
+{
+	bool all = desc->tclas_processing == CFG80211_TCLAS_PROCESSING_ALL;
+	enum scs_match ret = all ? SCS_MATCH_YES : SCS_MATCH_NO;
+	enum scs_match client;
+	unsigned int i;
+
+	client = scs_desc_client_match(desc, info);
+	if (client == SCS_MATCH_NO)
+		return SCS_MATCH_NO;
+
+	for (i = 0; i < desc->n_tclas; i++) {
+		enum scs_match m = tclas_match(&desc->tclas[i], info);
+
+		if (m == SCS_MATCH_UNDECIDED)
+			ret = SCS_MATCH_UNDECIDED;
+		else if (all && m == SCS_MATCH_NO)
+			return SCS_MATCH_NO;
+		else if (!all && m == SCS_MATCH_YES)
+			return client;
+	}
+
+	if (ret == SCS_MATCH_YES)
+		return client;
+
+	return ret;
+}
+
+static u16 scs_desc_param_count(const struct cfg80211_scs_desc *desc)
+{
+	unsigned int i;
+	u16 count;
+
+	if (desc->tclas_processing != CFG80211_TCLAS_PROCESSING_ALL) {
+		count = U16_MAX;
+		for (i = 0; i < desc->n_tclas; i++)
+			count = min(count, tclas_param_count(&desc->tclas[i]));
+
+		return count == U16_MAX ? 0 : count;
+	}
+
+	count = 0;
+	for (i = 0; i < desc->n_tclas; i++)
+		count += tclas_param_count(&desc->tclas[i]);
+
+	return count;
+}
+
+/**
+ * cfg80211_scs_evaluate - pick the SCS descriptor that matches a flow
+ *
+ * @desc: the active descriptors of one peer
+ * @n_desc: number of entries in @desc
+ * @info: the frame or flow to classify
+ * @verdict: receives the result
+ *
+ * When several descriptors match, the one with the most classifier parameters
+ * wins. An equal count keeps the first. A descriptor with a client only
+ * matches an MSDU addressed to that client.
+ */
+void cfg80211_scs_evaluate(struct cfg80211_scs_desc * const *desc, u8 n_desc,
+			   const struct cfg80211_flow_info *info,
+			   struct cfg80211_scs_verdict *verdict)
+{
+	unsigned int i, best_idx = 0;
+	int best = -1;
+
+	memset(verdict, 0, sizeof(*verdict));
+
+	for (i = 0; i < n_desc; i++) {
+		u16 count = scs_desc_param_count(desc[i]);
+
+		if (count <= best ||
+		    scs_desc_match(desc[i], info) != SCS_MATCH_YES)
+			continue;
+
+		best = count;
+		best_idx = i;
+		verdict->match = true;
+		verdict->scsid = desc[i]->id;
+		verdict->up = desc[i]->up;
+	}
+
+	/* Only a descriptor that could beat the match leaves it undecided */
+	for (i = 0; i < n_desc; i++) {
+		int count = scs_desc_param_count(desc[i]);
+
+		if (count < best || (count == best && i >= best_idx))
+			continue;
+
+		if (scs_desc_match(desc[i], info) == SCS_MATCH_UNDECIDED) {
+			verdict->undecided = true;
+			break;
+		}
+	}
+}
+EXPORT_SYMBOL(cfg80211_scs_evaluate);
-- 
git-series 0.9.1
