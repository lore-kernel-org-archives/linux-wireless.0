Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A508531627
	for <linux-wireless@vger.kernel.org>; Tue, 22 Sep 2026 10:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.11.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790072338; cv=none; b=LjdmBWNpwHL1u7HoXi8TE9qG4UiH8Rsv4vORtxY5ypyZB6NePrSwJ6CyGgaLSvwvc5/GsC7biSRjHP/pUwim0L3rPoBKogIiO8Ww6AyJFqVzZK46jPwKwmYR8DVxY4KTzy4f+d9aQAyOXl+6cIPsaCwjIMvaXALsdAN8wQX5MOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790072338; c=relaxed/simple;
	bh=aATL8urC/WFEqD4WrB7HfiKKR1YNtAIO3SB20V0Pgr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Epzfboz7Q/n84ZFBqT02riozltLZ5/d1S+emi2fWIXYTzGquP6qgJ1TEBTO86UIVPiGj9cAgCOKoOJNV/5L+qsbO9zNdTqdOLyaJ6jGHc/oUIIE0GW0J2jo43mdk2i11Ll3lhpe/WhhRYiOIjDaMTw7YWnlcIPZwWI9V6CYgecE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name; spf=pass smtp.mailfrom=nbd.name; dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b=OYD46yme; arc=none smtp.client-ip=46.4.11.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="OYD46yme"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ASA91WalDeKvQCgMCVHlOaRSj2txftXR76VfKznVJik=; b=OYD46ymeQ+UDpIyMJZIdYbFwOy
	zbgONHF8O415VpdF3zzNyTJzeMlDuEKz7qNJ0jPCeYdui11CTv1r5Egy6I1NQIvn8GPw59Yiw7fEA
	3TVP7FhWpXQx4pwnnfc60LNfrI5vX/bk+2xg5POukxgV6JNLTHPD+yDNM8u/klS+Zsuw=;
Received: from p200300cadf12010000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:100::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1x8xaN-0080aD-0l;
	Tue, 22 Sep 2026 12:18:51 +0200
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: vivek.chettri@oss.qualcomm.com,
	bhagavathi.pillai@oss.qualcomm.com,
	ripan.deuri@oss.qualcomm.com
Subject: [RFC PATCH 2/5] wifi: mac80211: add a flow priority query
Date: Tue, 22 Sep 2026 12:18:45 +0200
Message-ID: <f829d03bc3ac5a361f7d69effb7acea924807ecc.1790072192.git-series.nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.cadd8c50b95a5843991b4ea42462910882ab0982.1790072192.git-series.nbd@nbd.name>
References: <cover.cadd8c50b95a5843991b4ea42462910882ab0982.1790072192.git-series.nbd@nbd.name>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Frames of a flow that the hardware forwards on behalf of the driver
never pass through mac80211, so the SCS and MSCS rules of the station
are not applied to them. Add ieee80211_sta_flow_prio(), which lets a
driver look up the user priority of a flow before it creates an offload
entry.

Split the rule lookup out of ieee80211_flow_classify(), so that both
paths apply the same rules in the same order. The lookup works on a
parsed flow description, since the driver has no frame at hand.

The query fails when a rule refers to a field that the description does
not carry, since the answer could then differ between frames of the
flow. The driver must leave such a flow to the software path.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h | 19 +++++++++-
 net/mac80211/scs.c     | 89 ++++++++++++++++++++++++++++++-------------
 2 files changed, 82 insertions(+), 26 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c65ebbb3265c..d0ac8493889a 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6744,6 +6744,25 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
 					 const u8 *addr);
 
 /**
+ * ieee80211_sta_flow_prio - look up the user priority of a flow
+ *
+ * @pubsta: the station the flow is sent to
+ * @info: the flow as it is sent to @pubsta, after any address translation
+ * @prio: filled with the user priority, left untouched if no rule matches
+ *
+ * For drivers that forward flows in hardware without passing the frames
+ * through mac80211. The result is the priority that the software path
+ * assigns to frames of this flow.
+ *
+ * Must be called under RCU lock. Does not sleep.
+ *
+ * Return: 0 on success, or a negative error if a rule refers to a field
+ *	that @info does not carry. Such a flow must not be offloaded.
+ */
+int ieee80211_sta_flow_prio(struct ieee80211_sta *pubsta,
+			    const struct cfg80211_flow_info *info, u8 *prio);
+
+/**
  * ieee80211_find_sta_by_ifaddr - find a station on hardware
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index 076e97cddbf1..519f85c897ff 100644
--- a/net/mac80211/scs.c
+++ b/net/mac80211/scs.c
@@ -4,6 +4,7 @@
  *
  * Copyright (C) 2026 Felix Fietkau <nbd@nbd.name>
  */
+#include <linux/export.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>
 #include "driver-ops.h"
@@ -114,40 +115,24 @@ static void ieee80211_scs_sta_fill(struct ieee80211_scs_sta *scs,
 	}
 }
 
-/**
- * ieee80211_flow_classify - give an MSDU the user priority of its stream
- *
- * @sta: the receiver
- * @skb: the MSDU, in IEEE 802.3 format
- *
- * Return: %true when it set skb->priority, %false to leave the frame to the
- *	QoS map.
- */
-bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb)
+static bool ieee80211_flow_lookup(struct sta_info *sta,
+				  const struct cfg80211_flow_info *info,
+				  struct cfg80211_scs_verdict *verdict)
 {
 	struct ieee80211_flow_entry *entry;
-	struct cfg80211_scs_verdict verdict;
 	struct ieee80211_mscs_sta *mscs;
 	struct ieee80211_flow_hkey hkey;
-	struct cfg80211_flow_info info;
 	struct ieee80211_scs_sta *scs;
 
+	memset(verdict, 0, sizeof(*verdict));
+
 	scs = rcu_dereference(sta->scs);
 	mscs = rcu_dereference(sta->mscs);
-	if (!scs && !mscs)
-		return false;
-
-	if (!cfg80211_flow_parse(skb, &info))
-		return false;
 
 	if (scs) {
-		cfg80211_scs_evaluate(scs->rule, scs->n_rules, &info,
-				      &verdict);
-		if (verdict.match) {
-			skb->priority = verdict.up;
-
+		cfg80211_scs_evaluate(scs->rule, scs->n_rules, info, verdict);
+		if (verdict->match)
 			return true;
-		}
 	}
 
 	/* An SCS match takes precedence over the MSCS */
@@ -155,20 +140,72 @@ bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb)
 		return false;
 
 	hkey.sta = sta;
-	if (!cfg80211_flow_key_build(&info, mscs->layout, CFG80211_FLOW_AS_IS,
-				     &hkey.key))
+	if (!cfg80211_flow_key_build(info, mscs->layout, CFG80211_FLOW_AS_IS,
+				     &hkey.key)) {
+		verdict->undecided = true;
+
 		return false;
+	}
 
 	entry = rhashtable_lookup(&sta->sdata->bss->flow_tbl, &hkey,
 				  flow_rht_params);
 	if (!entry)
 		return false;
 
-	skb->priority = min_t(u8, READ_ONCE(entry->up), mscs->up_limit);
+	verdict->up = min_t(u8, READ_ONCE(entry->up), mscs->up_limit);
+	verdict->match = true;
+
+	return true;
+}
+
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
+
+	if (!rcu_access_pointer(sta->scs) && !rcu_access_pointer(sta->mscs))
+		return false;
+
+	if (!cfg80211_flow_parse(skb, &info))
+		return false;
+
+	if (!ieee80211_flow_lookup(sta, &info, &verdict))
+		return false;
+
+	skb->priority = verdict.up;
 
 	return true;
 }
 
+int ieee80211_sta_flow_prio(struct ieee80211_sta *pubsta,
+			    const struct cfg80211_flow_info *info, u8 *prio)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct cfg80211_scs_verdict verdict;
+
+	if (ieee80211_flow_lookup(sta, info, &verdict)) {
+		*prio = verdict.up;
+
+		return 0;
+	}
+
+	/* A rule refers to a field that @info does not carry */
+	if (verdict.undecided)
+		return -EOPNOTSUPP;
+
+	return 0;
+}
+EXPORT_SYMBOL(ieee80211_sta_flow_prio);
+
 static void ieee80211_flow_entry_free(struct ieee80211_if_ap *ap,
 				      struct ieee80211_flow_entry *entry)
 {
-- 
git-series 0.9.1
