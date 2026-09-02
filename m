Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7854D3ABD80
	for <linux-wireless@vger.kernel.org>; Wed,  2 Sep 2026 08:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338781; cv=none; b=gbms8/jqhO6W6VHu+cmKwJhcFCSaMacDVtTonwon8LgvwQSVLpjLsYkkUgSxxeagRoNnY3bFB+hsjaFaN6ju+4gAZdxxsWpNiqx7piyEajzS4M6AJUgPvUc0Ox2qpWv+uZeKdVwcSQwH6UvMZF58c0VuO/PEds5qjiEtHEn30a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338781; c=relaxed/simple;
	bh=o5alqTrClxaGUHBfyl3aKrnN5tonGW9XAH5cfv02CWg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tlJ2E2Dsl1YMurqqDG+UBZJRbZkE9KsSt/kqfFyHJozHh3IRBxTqxEnOykDSTlfjnX3ssKCtKbmu3DCfmIigwSyz9HwVfVGylQjTrBYhU+M7YKxy0qQl8DF8l8bqzJinPj7K5yLKni+IfQUPTBuFT1PaPXx6eiGh7Odh9k/aWSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=t6CsK84z; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="t6CsK84z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=jMy00o888WLMVbH4yyf6rmzq7jEEvLKsBanw8yjvwiU=; b=t6CsK84zI2fltAV8fiIfBn6/1Q
	MuT9YHFq+7F+4Qxyr9UmrdAdvypVC5InfDRR6i6U49FzpETgAL3OF+PLtgZAeQ/BZlGvzTfNCf4po
	E7ea0Y8263lgvNEVgiUatPetU8x3pQr+1FiUQjy4Pvupa8tB5SFuej/wLroi7jU8mDYc=;
Received: from p200300cadf14d1000000000000000162.dip0.t-ipconnect.de ([2003:ca:df14:d100::162] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x1gbn-00Cwkn-1u;
	Wed, 02 Sep 2026 10:46:15 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [RFC PATCH 11/15] wifi: mac80211: apply MSCS on transmit
Date: Wed,  2 Sep 2026 10:46:06 +0200
Message-ID: <df1fcafc021c215ff1852f705e1d9e40a9f9a536.1788338716.git-series.nbd@nbd.name>
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

Look up the learned flow UP for an MSDU that no SCS descriptor claimed,
which is the order 11.25.3 item d) 2) asks for, and cap the result with
the User Priority Limit of the request.

This completes MSCS.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/scs.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index 12730e836962..439bbb2df923 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -126,22 +126,46 @@ ieee80211_scs_sta_build(struct cfg80211_scs_desc * const *rule, u8 n_rules)
  */
 bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb)
 {
+	struct ieee80211_flow_entry *entry;
 	struct cfg80211_scs_verdict verdict;
+	struct ieee80211_mscs_sta *mscs;
+	struct ieee80211_flow_hkey hkey;
 	struct cfg80211_flow_info info;
 	struct ieee80211_scs_sta *scs;
 
 	scs = rcu_dereference(sta->scs);
-	if (!scs)
+	mscs = rcu_dereference(sta->mscs);
+	if (!scs && !mscs)
 		return false;
 
 	if (!cfg80211_flow_parse(skb, &info))
 		return false;
 
-	cfg80211_scs_evaluate(scs->rule, scs->n_rules, &info, &verdict);
-	if (!verdict.match)
+	if (scs) {
+		cfg80211_scs_evaluate(scs->rule, scs->n_rules, &info,
+				      &verdict);
+		if (verdict.match) {
+			skb->priority = verdict.up;
+
+			return true;
+		}
+	}
+
+	/* 11.25.3 item d) 2) leaves an MSDU of an SCS stream to that stream */
+	if (!mscs)
+		return false;
+
+	hkey.sta = sta;
+	if (!cfg80211_flow_key_build(&info, mscs->layout, CFG80211_FLOW_AS_IS,
+				     &hkey.key))
+		return false;
+
+	entry = rhashtable_lookup(&sta->sdata->bss->flow_tbl, &hkey,
+				  flow_rht_params);
+	if (!entry)
 		return false;
 
-	skb->priority = verdict.up;
+	skb->priority = min_t(u8, READ_ONCE(entry->up), mscs->up_limit);
 
 	return true;
 }
-- 
git-series 0.9.1
