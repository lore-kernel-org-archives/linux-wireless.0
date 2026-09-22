Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B784F4D13
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:13:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072034; cv=none; b=H4TidySOkmuAYbbltrrvgpX+na7zHTduZi/VyqUoj7Bg8jPa40UU0Z7UTI3T42QyOGNgaRH11+iSbe+i940VivRUxQlh3xXzc8Km9Y3/qHHeaEs/dWP86gbZ58fdWG67rAmnSphTGu6zAXNujYOPbu9msDzzPyZO8fegaB4P3+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072034; c=relaxed/simple;
	bh=dkV2MNbjVfo9yH9yXUtl8Jz+Gog8qvffFmdahF92AEA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lWdlpHONYf3lJyaLfpalyTMDCIykBsvB2zNfO7n6O8q/rWW2IfaMJ3g16kvIjI4hBjOQ4K7DzYXtiTdYH5uegj5EZfoTMbGPzVPLecbUOjozmUYJhMpyn4tTIUagiI7fZj2DlUtH5uU5LyRfWGAIeoH8na6bbo1sweHSocXHAX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=j5+pJmxK; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="j5+pJmxK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=8evccIaKP9IBVWFmoeG/Zq2IEdQrwo9i27wjEmwRYlw=; b=j5+pJmxKQU3OhDioDGLHrprPJW
	nfnGv+WBQQgvuWT4JTUEVJzQt9zVNsJQiaDkrFqIJCcvsd8eh4A/uRxJhv91cBiQc2xVEz4i10QSu
	iwIS6Zt9GJMyWw0hOSG9qW9Zo/NIaoCAiqOKbaHYTmBKCvWw3osTsQeT0J1ZuBrjsYvQ=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xVV-00807z-1B;
	Tue, 22 Sep 2026 12:13:49 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net,
	vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH v2 12/16] wifi: mac80211: apply MSCS on transmit
Date: Tue, 22 Sep 2026 12:13:39 +0200
Message-ID: <344ed89d0bf4a8f3b60d022ebb9f5b03f313d0e0.1790071773.git-series.nbd@nbd.name>
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

Look up the learned priority of an MSDU that no SCS descriptor matched,
and cap it with the User Priority Limit of the request. SCS runs first,
so an MSDU of an SCS stream keeps the priority of that stream.

With this the AP mirrors the uplink priority of a learned flow onto
its downlink.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/scs.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index f0242ad43e91..22d8ae711d06 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -109,22 +109,46 @@ ieee80211_scs_sta_build(struct cfg80211_scs_desc * const *rule, u8 n_rules)
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
+	/* An SCS match takes precedence over the MSCS */
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
