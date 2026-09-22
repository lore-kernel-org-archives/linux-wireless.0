Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F00530DE6
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072031; cv=none; b=ZzKnL+tvI8jsOTAf2up/Pjp9CZM/7OkTnY+5VJsyLzvR15/2L8J2hEzxvHx+l86heFjScvDQ+DRZn9t8+5V6XkIY2JNNq35AvKxH76t+c2+Kpk0sm5AO3+cCO9e+tTnuWli/1fXnrinVOmOTBBFvd6dBoqJN+8E2cV6s6e9cquU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072031; c=relaxed/simple;
	bh=bruZdQ/I5fyuQ9heus9FbfAMdG13hMWhSU2GvzHVJpg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u1PUCE0+Ul+1AlNVH1kNxp6UPB6jw9JKKcX+mtkLEUxm9v3xrgBjOa2YRLQzYOQWxdj2VMVs8ohoRz2SrFIxKiBV0PQEjSTFMs5SjS09kZGugA/oHYe65Gkby6IJnVCpVHDlIjMlBsugl1PFJJjjMzhkSu0KO+bHsN5aYlmtXlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=ri2fBZMk; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="ri2fBZMk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=SP8/XZjeP+wH4OZEHY7ybqSn4JwYEcfh6Yxsv8Wu/Cc=; b=ri2fBZMk/tOuk0XYLVxStZO+Nb
	zI1IQviwCLbkY1b/rKa8otpMg+EOignP+Gm/YqEVjNZLhQu84ElSR6TawyNwgm0sbeRai8t44L2VZ
	eHsiLVA4vl7oDB16B2YrQxhxENvdUBeckQ5StJG01wAhTrfQRJhRGFV4dvRxWmkvOId4=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVS-00807z-2U;
	Tue, 22 Sep 2026 12:13:46 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 03/16] wifi: cfg80211: add the SCS evaluator
Date: Tue, 22 Sep 2026 12:13:30 +0200
Message-ID: <71b67decfab5c04f9aaf1c70f201799994f0ba5b.1790071773.git-series.nbd@nbd.name>
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

Add cfg80211_scs_evaluate(), which walks the active SCS descriptors of
a peer and returns the user priority of the descriptor that matches an
MSDU. When several descriptors match, the one that requires the most
classifier parameters wins, with the count defined in 11.25.2 of IEEE
802.11-2024. An equal count keeps the first descriptor.

A filter classifier cannot be answered from the flow key, so it reads
the frame again, at the IPv4 payload or at the occurrence of the named
IPv6 next header. Without a frame it does not match.

Add struct cfg80211_scs_desc, which holds the part of a parsed
descriptor that the evaluator reads.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/cfg80211.h |  34 +++++++-
 net/wireless/scs.c     | 192 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 226 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index ab9f3ce06b88..d6021b551384 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4245,6 +4245,40 @@ bool cfg80211_flow_key_build(const struct cfg80211_flow_info *info, u32 fields,
 			     struct cfg80211_flow_key *key);
 
 /**
+ * struct cfg80211_scs_desc - one SCS descriptor
+ *
+ * @tclas_processing: how the elements of @tclas relate
+ * @id: SCSID, 1 to 255
+ * @up: user priority to assign to a matching MSDU
+ * @n_tclas: number of entries in @tclas
+ * @tclas: the classifier
+ */
+struct cfg80211_scs_desc {
+	enum cfg80211_tclas_processing tclas_processing;
+	u8 id;
+	u8 up;
+	u8 n_tclas;
+	struct cfg80211_tclas tclas[] __counted_by(n_tclas);
+};
+
+/**
+ * struct cfg80211_scs_verdict - result of an SCS evaluation
+ *
+ * @match: an SCS descriptor matched the MSDU
+ * @scsid: identifier of the matching descriptor
+ * @up: user priority to assign
+ */
+struct cfg80211_scs_verdict {
+	bool match;
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
index 912a8cdc50a8..4bfee721f206 100644
--- a/net/wireless/scs.c
+++ b/net/wireless/scs.c
@@ -694,3 +694,195 @@ bool cfg80211_flow_key_build(const struct cfg80211_flow_info *info, u32 fields,
 	return true;
 }
 EXPORT_SYMBOL(cfg80211_flow_key_build);
+
+/* Find the payload behind the @instance-th occurrence of the protocol */
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
+		if (!iph || iph->protocol != f->protocol || f->instance)
+			return false;
+
+		*off = pos + iph->ihl * 4;
+
+		return true;
+	}
+
+	if (info->key.ip_version != 6)
+		return false;
+
+	ip6h = skb_header_pointer(info->skb, pos, sizeof(*ip6h), &ip6h_buf);
+	if (!ip6h)
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
+		hdr = skb_header_pointer(info->skb, pos, sizeof(*hdr),
+					 &hdr_buf);
+		if (!hdr)
+			return false;
+
+		if (nexthdr == NEXTHDR_FRAGMENT)
+			pos += 8;
+		else if (nexthdr == NEXTHDR_AUTH)
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
+static bool tclas_filter_match(const struct cfg80211_tclas *t,
+			       const struct cfg80211_flow_info *info)
+{
+	const struct cfg80211_tclas_filter *f = &t->filter;
+	u8 buf[CFG80211_TCLAS_FILTER_LEN], *p;
+	unsigned int i, off;
+
+	if (!info->skb)
+		return false;
+
+	if (!tclas_filter_offset(info, f, &off))
+		return false;
+
+	p = skb_header_pointer(info->skb, off, f->len, buf);
+	if (!p)
+		return false;
+
+	for (i = 0; i < f->len; i++)
+		if ((p[i] ^ f->value[i]) & f->mask[i])
+			return false;
+
+	return true;
+}
+
+static bool tclas_match(const struct cfg80211_tclas *t,
+			const struct cfg80211_flow_info *info)
+{
+	struct cfg80211_flow_key key;
+
+	if (t->type == CFG80211_TCLAS_FILTER)
+		return tclas_filter_match(t, info);
+
+	if (!cfg80211_flow_key_build(info, t->fields, CFG80211_FLOW_AS_IS,
+				     &key))
+		return false;
+
+	return !memcmp(&key, &t->key, sizeof(key));
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
+static bool scs_desc_match(const struct cfg80211_scs_desc *desc,
+			   const struct cfg80211_flow_info *info)
+{
+	unsigned int i;
+	bool any = false;
+
+	for (i = 0; i < desc->n_tclas; i++) {
+		if (tclas_match(&desc->tclas[i], info)) {
+			any = true;
+			continue;
+		}
+
+		if (desc->tclas_processing == CFG80211_TCLAS_PROCESSING_ALL)
+			return false;
+	}
+
+	return any;
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
+ * @info: the flow, from cfg80211_flow_parse()
+ * @verdict: receives the result
+ *
+ * When several descriptors match, the one with the most classifier parameters
+ * wins. An equal count keeps the first.
+ */
+void cfg80211_scs_evaluate(struct cfg80211_scs_desc * const *desc, u8 n_desc,
+			   const struct cfg80211_flow_info *info,
+			   struct cfg80211_scs_verdict *verdict)
+{
+	unsigned int i;
+	int best = -1;
+
+	memset(verdict, 0, sizeof(*verdict));
+
+	for (i = 0; i < n_desc; i++) {
+		u16 count;
+
+		if (!scs_desc_match(desc[i], info))
+			continue;
+
+		count = scs_desc_param_count(desc[i]);
+		if (count <= best)
+			continue;
+
+		best = count;
+		verdict->match = true;
+		verdict->scsid = desc[i]->id;
+		verdict->up = desc[i]->up;
+	}
+}
+EXPORT_SYMBOL(cfg80211_scs_evaluate);
-- 
git-series 0.9.1
