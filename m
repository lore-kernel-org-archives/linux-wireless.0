Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=46.4.11.11
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793980020;
	b=iGdgTjMFZ6CVDzQ5VMl69DhZvlruv2V/XHqDtuwfbUHvq9sHYeykBzV84HCbaBUrPrVG
	 vaSr+aYtAwxZewgq7WfWW7RabZPJLYdBct5UMS0UMn+zh8mKitELObcQdSOlfNYITvSB0
	 8/M2A9KB+/MttGWA3dRtFciPRjC4Oed39qP1vd9XOBGI7flo6uKuct1vxL69EKxcloyGF
	 1CW4Nvq506K8Vhep2CKPQZBOJNY+qdjj95rkFuMql1H1SmeomzS5erfvyFGd/Tyv+aqo6
	 o2NJRxheyF5CbdzxAtjDsnQuqhRdYEkThHvRJA4SitdRXz2jcJ2hET9tRQWVdumq2Aw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793980020;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hoPbrOMkwsTh2laEr85ChD0yFiynEO2KIqeuH56eifI=;
	b=x/Qhqm5GL0wgvzhZNnz4DHcAb5GcyqBeLL96eOSbwbSBf+UWlulhktLjMl++iFBlw4fp
	 0rqgpnKVqjQrutyw6zI3vKkIQqrwa9fXhQF3m9KHfPAwqqe5PwA+PZaoV7gx6yziRIWnb
	 0BEHObvmB5O/DlWhmvPLBD7Rnne/akCP2xuD6SvpeZAtyiqycHm2rdbx5+DDmoRnR+Ppr
	 AvbKY6BqO5fUdcXwqnY2Sd2GZsg05d7Kp4lnxLCZlxL+fcT71RhhCDZJj6j7EtMICzt5r
	 G2U0brI5kxmon80YugnQc3dwazNmsrf5IlAuUcWp/ZIP/UiWBxpjHgpIWepNFDKIDYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nbd.name;
	spf=pass smtp.mailfrom=nbd.name;
	dkim=pass header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=mIC1Ibau;
	arc=none smtp.remote-ip=46.4.11.11
Received: from nbd.name (nbd.name [46.4.11.11])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD368606A32C
	for <linux-wireless@vger.kernel.org>; Fri,  6 Nov 2026 15:46:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DD368606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nbd.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nbd.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=nbd.name header.i=@nbd.name header.a=rsa-sha256 header.s=20160729 header.b=mIC1Ibau
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
	s=20160729; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=hoPbrOMkwsTh2laEr85ChD0yFiynEO2KIqeuH56eifI=; b=mIC1IbaudrZu4zIBRGncUoj/wo
	RHdeXiPMDBZJWHHOqnfUOJb9X8+gIT1MMF5SdGSSbrr2sP09pmrvfOI5lFeh+XZbjzyeItBuAC2nl
	WtUUR58hERS+eBxIQOn31xXYX6fPFIwmpL37DVAKNsl3Yv7ufgWqz1+jLQVOO4EEuFN8=;
Received: from p200300cadf12920000000000000005bb.dip0.t-ipconnect.de ([2003:ca:df12:9200::5bb] helo=localhost.localdomain)
	by ds12 with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <nbd@nbd.name>)
	id 1xPM9T-00GvLl-0A;
	Fri, 06 Nov 2026 16:46:51 +0100
From: Felix Fietkau <nbd@nbd.name>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net
Subject: [PATCH wireless 2/4] wifi: mac80211: release monitor channels on suspend
Date: Fri,  6 Nov 2026 16:46:46 +0100
Message-ID: <20261106154648.1228594-2-nbd@nbd.name>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261106154648.1228594-1-nbd@nbd.name>
References: <20261106154648.1228594-1-nbd@nbd.name>
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

A monitor with its own channel keeps its channel context across
suspend, which triggers the warning in __ieee80211_suspend() about
remaining channel contexts.

Release the channel on suspend and acquire it again on resume, like for
the virtual monitor.

Fixes: 9d40f7e32774 ("wifi: mac80211: add flag to opt out of virtual monitor support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
---
 net/mac80211/pm.c   |  2 ++
 net/mac80211/util.c | 26 ++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/net/mac80211/pm.c b/net/mac80211/pm.c
index f63676c44853..de0d7b093520 100644
--- a/net/mac80211/pm.c
+++ b/net/mac80211/pm.c
@@ -151,7 +151,9 @@ int __ieee80211_suspend(struct ieee80211_hw *hw, struct cfg80211_wowlan *wowlan,
 			continue;
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_AP_VLAN:
+			continue;
 		case NL80211_IFTYPE_MONITOR:
+			ieee80211_link_release_channel(&sdata->deflink);
 			continue;
 		case NL80211_IFTYPE_STATION:
 			ieee80211_mgd_quiesce(sdata);
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 44feb80274c6..34402200baec 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -1748,6 +1748,30 @@ static void ieee80211_assign_chanctx(struct ieee80211_local *local,
 	}
 }
 
+static void ieee80211_reconfig_monitors(struct ieee80211_local *local)
+{
+	struct ieee80211_sub_if_data *sdata;
+
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	list_for_each_entry(sdata, &local->interfaces, list) {
+		struct ieee80211_chan_req chanreq = sdata->vif.bss_conf.chanreq;
+
+		if (sdata->vif.type != NL80211_IFTYPE_MONITOR ||
+		    !chanreq.oper.chan ||
+		    rcu_access_pointer(sdata->deflink.conf->chanctx_conf))
+			continue;
+
+		if (!ieee80211_link_use_channel(&sdata->deflink, &chanreq,
+						IEEE80211_CHANCTX_SHARED))
+			continue;
+
+		sdata_info(sdata, "failed to restore monitor channel\n");
+		memset(&sdata->vif.bss_conf.chanreq, 0,
+		       sizeof(sdata->vif.bss_conf.chanreq));
+	}
+}
+
 static void ieee80211_reconfig_stations(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -2382,6 +2406,8 @@ int ieee80211_reconfig(struct ieee80211_local *local)
 	    local->virt_monitors == local->open_count)
 		ieee80211_add_virtual_monitor(local, NULL);
 
+	ieee80211_reconfig_monitors(local);
+
 	if (!suspended)
 		return 0;
 
-- 
2.47.3

