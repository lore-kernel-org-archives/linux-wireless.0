Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793723049;
	b=n0amuEh4Dn9bespKqQVmBIZEK5oqFIgiv9A2WlzTdSlDFmyltT4DQbZkVgIOJBXKvToW
	 If4wCLSyucQu6pbILKGUpHzNLmQFl+7o5urhnm91WfLu/pug7fCtrdB+OuZRPuxJBmsNX
	 2NQStjQqlwC/QxKwE5o9od8/8X7OjZgV2yHbHMGtxEzbI94SKACt6aMJpCFMH5fc1KG4q
	 klyMYLuO2ugCwDyH3XeInpC2JHIu5v8Njvsik8EXedTn97HImIbsnfgvPmaNSyGWPS428
	 f7UL4PrSOEsFdBtKWxkFnseT86/HNZKN4RNkBaS6/1Gy+nikpmKWU/LZHouWvGwU1WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793723049;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=LF4nIzoFWF9eEMBYCv78Pik4W4w9shKiElY/hXOMA7A=;
	b=H0iA4KJa9mXYw1QSwtI3Lg6lgmZN1RQ+jbtsCzi+eETZxwlFjg7i24R973j4MJ/eMdWG
	 36ohckxqJPmhOxz82D+tYtWlGCWAZXJoBmYgEMrWfMCjoeWglC8KS22wKdmlq2omX1NrL
	 cW7W6iN3tYDSXDNYWLp3Karn6rxJvVeLlxLe8iIP4HpqJtL0bdHWY38OmV9M5ZR3qeMQT
	 uSbgtpftRZVJ4RjSX/EoRGeOGPSnIbLQdXKd/getgwgnZXbrNGFzRF/OeUv0Pm3EMsU9n
	 LOA4IUw22oRi7ovRKPbLYnzxc+btmdof8jCewuoLaVfyPA4QraWv41pCCDjJmVriaIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=qlOYRvTM;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225FF606D836
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:24:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 225FF606D836
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=qlOYRvTM
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=LF4nIzoFWF9eEMBYCv78Pik4W4w9shKiElY/hXOMA7A=; b=qlOYRvTMGUC4tZ/avgYc6rVvRL
	SZU0lkr7wsaWmt07gqHN1uEOg0QmwQuhvyez6CLVkhQArjVeH99TKMK395bMBP8zICy+eX/GuzTH2
	PGWQlZgkNMTSrJXu/2mjllipA8iipL7lsBnTtmSEWUI5NPtYZSal6a1Z3aBCiNtHXy9E=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xOHIn-00FDFp-3B;
	Tue, 03 Nov 2026 17:24:02 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless-next 16/18] wifi: mac80211: add a flow priority query
Date: Tue,  3 Nov 2026 17:23:49 +0100
Message-ID: <ac6f80a2f564e5877c3c3bf9a973d6d02e01b8e8.1793722802.git-series.nbd@nbd.name>
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

Frames of a flow that the hardware forwards on behalf of the driver
never pass through mac80211, so the SCS and MSCS rules of the station
are not applied to them. Add ieee80211_sta_flow_prio(), which lets a
driver look up the user priority of a flow before it creates an offload
entry.

The query uses the rule lookup of the transmit path on a flow
description from the driver, so that both apply the same rules in the
same order.

The query fails when a rule refers to a field that the description does
not carry, since the answer could then differ between frames of the
flow. The driver must leave such a flow to the software path.

When no rule matches, the caller can pass the DSCP of a packet of the
flow to get the QoS map priority for it, as the software path does.

The first user, flow offload with mtk_eth_soc on mt7996, follows in a
separate series.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 include/net/mac80211.h | 23 +++++++++++++++++++++-
 net/mac80211/scs.c     | 47 +++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 68 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 9ed50c6fe679..de570d72fd16 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -6793,6 +6793,29 @@ struct ieee80211_sta *ieee80211_find_sta(struct ieee80211_vif *vif,
 					 const u8 *addr);
 
 /**
+ * ieee80211_sta_flow_prio - look up the user priority of a flow
+ *
+ * @pubsta: the station the flow is sent to
+ * @info: the flow as it is sent to @pubsta, after any address translation
+ * @dscp: the DSCP of a packet of the flow, or negative if unknown. Used
+ *	for the QoS map fallback only, when no SCS or MSCS rule matches.
+ * @prio: filled with the user priority, left untouched if no rule matches
+ *	and @dscp is negative
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
+			    const struct cfg80211_flow_info *info, int dscp,
+			    u8 *prio);
+
+/**
  * ieee80211_find_sta_by_ifaddr - find a station on hardware
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
diff --git a/net/mac80211/scs.c b/net/mac80211/scs.c
index 00c58eaa3057..986439035df8 100644
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
@@ -123,16 +124,22 @@ static bool ieee80211_mscs_lookup(struct sta_info *sta,
 	struct ieee80211_flow_entry *entry;
 	struct ieee80211_flow_hkey hkey;
 
-	if (!(info->present & BIT(CFG80211_FLOW_F_ETH_DA)))
+	if (!(info->present & BIT(CFG80211_FLOW_F_ETH_DA))) {
+		verdict->undecided = true;
+
 		return false;
+	}
 
 	if (!ether_addr_equal(info->key.da, mscs->client))
 		return false;
 
 	hkey.mscs = mscs;
 	if (!cfg80211_flow_key_build(info, mscs->layout, CFG80211_FLOW_AS_IS,
-				     &hkey.key))
+				     &hkey.key)) {
+		verdict->undecided = true;
+
 		return false;
+	}
 
 	entry = rhashtable_lookup(&sta->sdata->bss->flow_tbl, &hkey,
 				  flow_rht_params);
@@ -197,6 +204,42 @@ bool ieee80211_flow_classify(struct sta_info *sta, struct sk_buff *skb)
 	return true;
 }
 
+int ieee80211_sta_flow_prio(struct ieee80211_sta *pubsta,
+			    const struct cfg80211_flow_info *info, int dscp,
+			    u8 *prio)
+{
+	struct sta_info *sta = container_of(pubsta, struct sta_info, sta);
+	struct cfg80211_scs_verdict verdict;
+	struct mac80211_qos_map *qos_map;
+	bool match;
+
+	/* Like ieee80211_select_queue(), which sends these as best effort */
+	if (!pubsta->wme) {
+		*prio = 0;
+
+		return 0;
+	}
+
+	match = ieee80211_flow_lookup(sta, info, &verdict);
+	if (verdict.undecided)
+		return -EOPNOTSUPP;
+
+	if (match) {
+		*prio = verdict.up;
+
+		return 0;
+	}
+
+	if (dscp < 0)
+		return 0;
+
+	qos_map = rcu_dereference(sta->sdata->qos_map);
+	*prio = cfg80211_dscp_to_up(dscp, qos_map ? &qos_map->qos_map : NULL);
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
