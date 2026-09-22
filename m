Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BEA23B5835
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072033; cv=none; b=AyMRfuc8ub9Q2etdf79cOsMce62eAznc8JHP7YIwC8zN0rgfdJldwM2KTCP3ksLI9lWah7pYRVGIRBgJMHiuvsyXnGOVWzMrEVkFJ3NM9OeI3WIF8oDg1huxFJjbVyjuy1Q4lsB6HvAykuM28AYqXt1aTVRzPYJ5lNLVmJqaa5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072033; c=relaxed/simple;
	bh=+KGYgOmksyyHSqVIj3Y4khD9nlHci+VBOthUu8NjZgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cEMPSeAdePR2r2UzvZciGmU5U9KHSeEuoBZsE6zrZgTEUVeLROjBZCRqTEJHonkuhHQ7gkGsoGEBqE5/clIM04INm49CdZWkDbqvVSQX4buqHU+KwzAnKw6UJDdBc602yvhrPRBJq6ZR99l/LOMI0d4KTE7WQQx4gJGfiVv30lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=qVlkpluP; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="qVlkpluP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=/RnX5/POqwy7Yu2xkKQoagaOO4XzZve7lYDUdMikdGc=; b=qVlkpluPKz4qKmNgKIqi/AK6+9
	eaRiT9dHhBFh/MgWVtMCkT6hSFDwu9Bju+eIQvoqW6zn9q/C0KYGVsym7IMfHatAHg5GbdAUK8DJf
	uE4l3hUweEA04IbnjWPlCciHwmq8Ig99J8hcB6mOWRWcg5dgQtGnlZyl93cReNnIzyaA=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVU-00807z-2a;
	Tue, 22 Sep 2026 12:13:48 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 10/16] wifi: mac80211: classify transmitted MSDUs with SCS
Date: Tue, 22 Sep 2026 12:13:37 +0200
Message-ID: <7800267cd1d5a4d9816239d2d1600cd318cd3b0d.1790071773.git-series.nbd@nbd.name>
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

Hook the evaluator into ieee80211_select_queue(), which every data
transmit path of an AP reaches, including 802.11 encapsulation offload
and the unicast copies of a multicast frame. The TID it produces
selects the TXQ, the AC and the block ack session, so the
classification has to run before the frame is queued.

It runs before cfg80211_classify8021d(), which preserves the priority
that a frame already carries. A frame forwarded between two stations
of the same AP carries its received TID that way and has to be
classified like any other MSDU.

The hook is limited to AP and AP_VLAN interfaces, because only the AP
side classifies downlink MSDUs.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/scs.c         | 31 +++++++++++++++++++++++++++++++
 net/mac80211/wme.c         |  7 +++++++
 3 files changed, 39 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ff4b17f2d7b6..47d703688478 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2221,6 +2221,7 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *peer, struct cfg80211_mscs_desc *desc);
 void ieee80211_sta_scs_free(struct sta_info *sta);
+bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb);
 
 /* link handling */
 void ieee80211_link_setup(struct ieee80211_link_data *link);
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index b8e9fe062ff5..89982e1f4b89 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -84,6 +84,37 @@ ieee80211_scs_sta_build(struct cfg80211_scs_desc * const *rule, u8 n_rules)
 	return scs;
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
 		      struct cfg80211_scs_result *res, u8 n_desc)
diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 1601be576414..9fcee1bc6ad5 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -174,6 +174,13 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
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
-- 
git-series 0.9.1
