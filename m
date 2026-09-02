Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9AF33911CE
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338779; cv=none; b=Pd2goGT/vWWmedNVDEkeF6WPLhRfEGBDYzzgpbbdseyHlsDz1RCVfJqgn0/RAlH/fPjn9T7xEOec+geXW7MG6vi0yiXgZDjHp0IoVqOATHoOhcWY4DDqgMhUXv6nZmPjGCjmF9u5lRqhfXlguBd566v5Mi5meAvwXWIrzSzuvkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338779; c=relaxed/simple;
	bh=tj49Og+v10hPdjiRf+jSEfHE5zN+IyXMq4CzJWHkbo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u2ULULjeDyDsVPdxh1jjbjIHOKC+ulnEPvDrXc2uiQrMgUqUuF1rIt4rbFK+F4sL7VESCtAWcfBa/0RJ1Qs9NSmzgXDGK+vuUlkmcxWF64dXJPiw3hrBfAokrF9PwFd4TWSbBngeWsWiUDOx8j1Tagh/ZaEHUhd4SJww9r8WmuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=i3YoIAnU; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="i3YoIAnU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=5fydvFpYPcUyiv3l0B6o2mqR9+dvjIwfK0cZAnY0OYo=; b=i3YoIAnURq5L2rEXvzh31bBhBU
	R1UWjW6YXCU7rJ/sDrcO0sewGq4J1icq+sOa64MMM/YKy4lauFKrbw5DHELeXtdzR6JZeu26KkTyA
	wD4Qr4u3bnPPfTRH0SpRv9nIbPSSWDfscFF3hywgXJ2KOaJfHhHgD+AteCvuRWPlYpEY=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbn-00Cwkn-0m;
	Wed, 02 Sep 2026 10:46:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 09/15] wifi: mac80211: classify transmitted MSDUs with SCS
Date: Wed,  2 Sep 2026 10:46:04 +0200
Message-ID: <422037ffcc9e7f1c56f62f181131bf11a52173c2.1788338716.git-series.nbd@nbd.name>
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

Hook the evaluator into ieee80211_select_queue(), which every software
transmit path reaches, including the 802.11 encapsulation offload path
and the multicast to unicast copies.

It runs ahead of cfg80211_classify8021d(), which keeps the priority a
frame already carries. A frame that the receive path forwards between two
stations carries one, and 11.25.2 covers a forwarded MSDU as much as a
local one.

This completes SCS.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/ieee80211_i.h |  1 +
 net/mac80211/scs.c         | 31 +++++++++++++++++++++++++++++++
 net/mac80211/wme.c         | 13 +++++++++++++
 3 files changed, 45 insertions(+)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 31a630e68a2b..ce2167c8a252 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2211,6 +2211,7 @@ int ieee80211_set_scs(struct wiphy *wiphy, struct net_device *dev,
 int ieee80211_set_mscs(struct wiphy *wiphy, struct net_device *dev,
 		       const u8 *peer, struct cfg80211_mscs_desc *desc);
 void ieee80211_sta_scs_free(struct sta_info *sta);
+bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb);
 
 /* link handling */
 void ieee80211_link_setup(struct ieee80211_link_data *link);
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index d2daefb8e90c..ea92c0104d92 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -93,6 +93,37 @@ ieee80211_scs_sta_build(struct cfg80211_scs_desc * const *rule, u8 n_rules)
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
index 1601be576414..7ed9243f6045 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -174,6 +174,19 @@ u16 ieee80211_select_queue(struct ieee80211_sub_if_data *sdata,
 		goto downgrade;
 	}
 
+	/*
+	 * Both services classify at the AP, so a non-AP station applies none
+	 * of the descriptors it holds for its driver. A frame the receive path
+	 * forwards between two stations also reaches
+	 * cfg80211_classify8021d() with a priority it must keep, so the
+	 * classifiers run ahead of it rather than behind it.
+	 */
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
