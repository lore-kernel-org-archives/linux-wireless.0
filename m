Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723049;
	b=2quwI8aZ/gM4utyN+g6PNjyNDB/IAtpwU+LslmmKykFkXA1GJYkgm4iaAaxIgxIIigEG
	 ZLQpNYdYcIli1w93Uj+eSxcGpRfC+aATGbE3JLZALAFRprg/8a/mHNg3rJsqdQ7vwjSah
	 uxteOSYuPZCoEj8HZMsI8NpN0QSGc0+U4yA7xMtUw4KbWBsPeMAmuD5XaW0LPQ+hkyqm+
	 vEfLuOrgT3AnNQvOQ2plKdv7/Qan1+RwH9tZOAGKMTgiDoty6drOfjnVJ/f4chS2/5b1l
	 Qz3oCYqIzYXnwmyYz1qVQh1NlWwax3wSrm6tKRPnLtcdDlP3OzY7aOBiqk/NvO5FYeQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723049;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=ice8q9BDuA8itvavCwQW9bp0DhqmPdw1QgegzPqNt/8=;
	b=GwjlN+Fw53gwmIVso7Hd5sFd+mhBCTsPpCwvPXw1E5qPw/8GEPr84hfu+s8BAH6B7CYC
	 1SM4/u8FMJmLgVOAl1cbP11TYUE8AWdwD5Yz8YpREzcmgUoH8UPb0ClPdfSNcqll5CM9l
	 ShLiruF6yebD9ViF4/yvV++0mfLCMUv0RHqExQLjRSY/uHFj25IjK7cfaCt+61Aeqcbec
	 z0VkLceJL3IcGhbnQpJfpHcdzitvptMujz/hgdLY45iGThrNTbOPyL+qoMlFultuwgSbX
	 oX0LMn7ApU2sy95s9ExKAGJTrJlpzDT8zQpqZS6AaVdPD7KwQDKVindwiOJIIuKkZAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Oee+rig2;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AEB606D819
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 53AEB606D819
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=Oee+rig2
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ice8q9BDuA8itvavCwQW9bp0DhqmPdw1QgegzPqNt/8=; b=Oee+rig2ch89WUjLbTVPlF4O3F
	/bpJoSDsHGFY5mzhij8lke2ijpXbC1PBHjo8Wazv5gJAkXKtDUJU0LxrSqvqDsXs044QEXtxgZAxO
	oymPatrFYOjHGgMjiBO7RkKfLby+u+boubr1f1hjDd+1DUl5b17ZwmeM5fhtpi+6lTgo=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIm-00FDFp-3D;
	Tue, 03 Nov 2026 17:24:01 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 11/18] wifi: mac80211: classify transmitted MSDUs with SCS
Date: Tue,  3 Nov 2026 17:23:44 +0100
Message-ID: <dcaffffa3c01b6c91533052d25accea75370a8ac.1793722802.git-series.nbd@nbd.name>
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

Hook the evaluator into ieee80211_select_queue(), so that the TID it
assigns selects the TXQ, the AC and the block ack session. It runs
before cfg80211_classify8021d(), so that a frame forwarded between two
stations of the AP is classified like any other MSDU. Only AP and
AP_VLAN interfaces classify.

Also mark a frame whose priority does not follow from its DSCP, so that
a driver whose device classifies 802.3 frames by DSCP can pass the
priority on.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h     |  5 +++-
 net/mac80211/ieee80211_i.h |  1 +-
 net/mac80211/mesh.c        |  3 +-
 net/mac80211/scs.c         | 31 +++++++++++++++++-
 net/mac80211/tx.c          | 11 ++++--
 net/mac80211/wme.c         | 70 +++++++++++++++++++++++++++++++++++++--
 net/mac80211/wme.h         |  3 +-
 7 files changed, 117 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 76ff86ff9974..dfdd85ef3ab7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1135,6 +1135,10 @@ enum mac80211_tx_info_flags {
  * @IEEE80211_TX_CTRL_DONT_USE_RATE_MASK: Don't use rate mask for this frame
  *	which is transmitted due to scanning or offchannel TX, not in normal
  *	operation on the interface.
+ * @IEEE80211_TX_CTRL_EXPLICIT_UP: the priority of this frame is not the one
+ *	that cfg80211_dscp_to_up() without a QoS map gives its DSCP, or not 0
+ *	for a frame without a DSCP. A device that classifies an 802.3 frame by
+ *	its DSCP itself must take skb->priority for this frame.
  * @IEEE80211_TX_CTRL_MLO_LINK: If not @IEEE80211_LINK_UNSPECIFIED, this
  *	frame should be transmitted on the specific link. This really is
  *	only relevant for frames that do not have data present, and is
@@ -1156,6 +1160,7 @@ enum mac80211_tx_control_flags {
 	IEEE80211_TX_CTRL_DONT_REORDER		= BIT(8),
 	IEEE80211_TX_CTRL_MCAST_MLO_FIRST_TX	= BIT(9),
 	IEEE80211_TX_CTRL_DONT_USE_RATE_MASK	= BIT(10),
+	IEEE80211_TX_CTRL_EXPLICIT_UP		= BIT(11),
 	IEEE80211_TX_CTRL_MLO_LINK		= 0xf0000000,
 };
 
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e16ced6cbd58..51777a0c3d51 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2266,6 +2266,7 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *peer, struct cfg80211_mscs_desc *desc);
 void ieee80211_sta_scs_free(struct sta_info *sta);
+bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb);
 
 /* link handling */
 void ieee80211_link_setup(struct ieee80211_link_data *link);
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 5f523e14cf84..137b5182c445 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -800,7 +800,8 @@ bool ieee80211_mesh_xmit_fast(struct ieee80211_sub_if_data *sdata,
 	if (!skb)
 		return true;
 
-	skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, sta, skb));
+	skb_set_queue_mapping(skb,
+			      ieee80211_select_queue(sdata, sta, skb, NULL));
 
 	meshhdr = (struct ieee80211s_hdr *)entry->hdr;
 	if ((meshhdr->flags & MESH_FLAGS_AE) == MESH_FLAGS_AE_A5_A6) {
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index e1f4c45dfc30..acbea95b97f6 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -99,6 +99,37 @@ static void ieee80211_scs_sta_fill(struct ieee80211_scs_sta *scs,
 	}
 }
 
+/**
+ * ieee80211_flow_classify - give an MSDU the user priority of its stream
+ *
+ * @sta: the receiver
+ * @skb: the MSDU, in IEEE 802.3 format
+ *
+ * Return: %true when it set skb->priority, %false to leave the frame to the
+ *	QoS map.
+ */
+bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb)
+{
+	struct cfg80211_scs_verdict verdict;
+	struct cfg80211_flow_info info;
+	struct ieee80211_scs_sta *scs;
+
+	scs = rcu_dereference(sta->scs);
+	if (!scs)
+		return false;
+
+	if (!cfg80211_flow_parse(skb, &info))
+		return false;
+
+	cfg80211_scs_evaluate(scs->rule, scs->n_rules, &info, &verdict);
+	if (!verdict.match)
+		return false;
+
+	skb->priority = verdict.up;
+
+	return true;
+}
+
 int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 		      const u8 *peer, struct cfg80211_scs_desc * const *desc,
 		      u16 *status, u8 n_desc)
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9b6a0415d6a..a5fc4e59cdc6 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -4477,7 +4477,9 @@ void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 	if (IS_ERR(sta))
 		sta = NULL;
 
-	skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, sta, skb));
+	skb_set_queue_mapping(skb,
+			      ieee80211_select_queue(sdata, sta, skb,
+						     &ctrl_flags));
 	ieee80211_aggr_check(sdata, sta, skb);
 
 	if (sta) {
@@ -4799,10 +4801,11 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 	struct tid_ampdu_tx *tid_tx = NULL;
 	struct sk_buff *seg, *next;
 	unsigned int skbs = 0, len = 0;
+	u32 ctrl_flags = 0;
 	u16 queue;
 	u8 tid;
 
-	queue = ieee80211_select_queue(sdata, sta, skb);
+	queue = ieee80211_select_queue(sdata, sta, skb, &ctrl_flags);
 	skb_set_queue_mapping(skb, queue);
 
 	skb = skb_share_check(skb, GFP_ATOMIC);
@@ -4852,6 +4855,7 @@ static void ieee80211_8023_xmit(struct ieee80211_sub_if_data *sdata,
 
 	info->flags |= IEEE80211_TX_CTL_HW_80211_ENCAP;
 	info->control.vif = &sdata->vif;
+	info->control.flags |= ctrl_flags;
 
 	if (key)
 		info->control.hw_key = &key->conf;
@@ -6718,7 +6722,8 @@ int ieee80211_tx_control_port(struct wiphy *wiphy, struct net_device *dev,
 	if (IS_ERR(sta))
 		sta = NULL;
 
-	skb_set_queue_mapping(skb, ieee80211_select_queue(sdata, sta, skb));
+	skb_set_queue_mapping(skb,
+			      ieee80211_select_queue(sdata, sta, skb, NULL));
 
 	/*
 	 * for MLO STA, the SA should be the AP MLD address, but
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 1601be576414..89e93d65822f 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -10,6 +10,7 @@
 #include <linux/module.h>
 #include <linux/if_arp.h>
 #include <linux/types.h>
+#include <net/dsfield.h>
 #include <net/ip.h>
 #include <net/pkt_sched.h>
 
@@ -144,12 +145,64 @@ u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 	return ieee80211_downgrade_queue(sdata, NULL, skb);
 }
 
+/*
+ * Read the type from the frame, since skb->protocol is ETH_P_802_3 for a
+ * frame forwarded between two stations.
+ */
+static int ieee80211_tx_dscp(struct sk_buff *skb)
+{
+	const struct ethhdr *eth = (void *)skb->data;
+	unsigned int off = ETH_HLEN;
+	__be16 proto = eth->h_proto;
+
+	if (eth_type_vlan(proto)) {
+		struct vlan_hdr vhdr_buf, *vhdr;
+
+		vhdr = skb_header_pointer(skb, off, sizeof(*vhdr), &vhdr_buf);
+		if (!vhdr)
+			return -1;
+
+		proto = vhdr->h_vlan_encapsulated_proto;
+		off += VLAN_HLEN;
+	}
+
+	switch (proto) {
+	case htons(ETH_P_IP): {
+		struct iphdr iph_buf, *iph;
+
+		iph = skb_header_pointer(skb, off, sizeof(*iph), &iph_buf);
+		return iph ? ipv4_get_dsfield(iph) >> 2 : -1;
+	}
+	case htons(ETH_P_IPV6): {
+		struct ipv6hdr ip6h_buf, *ip6h;
+
+		ip6h = skb_header_pointer(skb, off, sizeof(*ip6h), &ip6h_buf);
+		return ip6h ? ipv6_get_dsfield(ip6h) >> 2 : -1;
+	}
+	default:
+		return -1;
+	}
+}
+
+static bool ieee80211_prio_follows_dscp(struct sk_buff *skb)
+{
+	int dscp = ieee80211_tx_dscp(skb);
+	unsigned int up = 0;
+
+	if (dscp >= 0)
+		up = cfg80211_dscp_to_up(dscp, NULL);
+
+	return skb->priority == up;
+}
+
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
-			   struct sta_info *sta, struct sk_buff *skb)
+			   struct sta_info *sta, struct sk_buff *skb,
+			   u32 *ctrl_flags)
 {
 	const struct ethhdr *eth = (void *)skb->data;
 	struct mac80211_qos_map *qos_map;
 	bool qos;
+	u16 ac;
 
 	/* Ensure hash is set prior to potential SW encryption */
 	skb_get_hash(skb);
@@ -166,6 +219,8 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 
 	if (!qos) {
 		skb->priority = 0; /* required for correct WPA/11i MIC */
+		if (ctrl_flags && !ieee80211_prio_follows_dscp(skb))
+			*ctrl_flags |= IEEE80211_TX_CTRL_EXPLICIT_UP;
 		return IEEE80211_AC_BE;
 	}
 
@@ -174,6 +229,13 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 		goto downgrade;
 	}
 
+	/* A stream priority overrides the received one of a forwarded frame */
+	if (sta &&
+	    (sdata->vif.type == NL80211_IFTYPE_AP ||
+	     sdata->vif.type == NL80211_IFTYPE_AP_VLAN) &&
+	    ieee80211_flow_classify(sta, skb))
+		goto downgrade;
+
 	/* use the data classifier to determine what 802.1d tag the
 	 * data frame has */
 	qos_map = rcu_dereference(sdata->qos_map);
@@ -181,7 +243,11 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 					       &qos_map->qos_map : NULL);
 
  downgrade:
-	return ieee80211_downgrade_queue(sdata, sta, skb);
+	ac = ieee80211_downgrade_queue(sdata, sta, skb);
+	if (ctrl_flags && !ieee80211_prio_follows_dscp(skb))
+		*ctrl_flags |= IEEE80211_TX_CTRL_EXPLICIT_UP;
+
+	return ac;
 }
 
 /**
diff --git a/net/mac80211/wme.h b/net/mac80211/wme.h
index 81f0039527a9..78a8cfb06407 100644
--- a/net/mac80211/wme.h
+++ b/net/mac80211/wme.h
@@ -14,7 +14,8 @@ u16 ieee80211_select_queue_80211(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb,
 				 struct ieee80211_hdr *hdr);
 u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
-			   struct sta_info *sta, struct sk_buff *skb);
+			   struct sta_info *sta, struct sk_buff *skb,
+			   u32 *ctrl_flags);
 void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
 			   struct sk_buff *skb);
 
-- 
git-series 0.9.1
