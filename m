Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657435;
	b=oDWhwizHK26SK9K+1UcYYg8C1mjBOVkFxWjwtofFS/hQtnHjEmf4fmV6RktivyEvsxzP
	 lvXyXVWisX5dtvqzNv51qJ7n/E0A2XXlYQ5RZaYGBvaGagaSl6QnS32quiwJHCGpklXtS
	 pmD8iKHhxJW9fT+IfLBkef724NY7bUvZrFxFizYJCh9RjPJVjBgWJLfDofzO59zwsCC0M
	 yYRFDs/cPDrGgxHVXeQ9JQmfpwFHxRax443GB4pBrkvWcBnxPtiEXvvXOobGS1CzC99ko
	 7ZhAKvePCttrvqhjMgstILcb77zjKBoUezluBUoYLWBRRi7DdZaK7lkL00NwNo0Mvcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657435;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=YnETBOmftWKSfY5Ix+w+P9w0EmkUNyoP4oLTYuVkrRU=;
	b=zBmOgLSIoe79A15uDDzMk4v0vLmmWzUAA0w1+RjcPL5ULBMNZT3QeKBHcbFLXGVyVeA3
	 AoYVGDsTqFPZvyDFnjjwn1FUdsDu2c5BFfPJbIALUq26fxWW6LxoIDIN1aKs5uMoBEheY
	 GGnE2n1iNjqO56Jt5m8LzjC//+mibgM4TTqUtQjTkbKBDFWZmp8eIz5Tnkb3ZMiWk40VE
	 aV36KepTL+9eccASKTz9oBnT0fEVFF1Kjxl6s0eDztPY/WIQ7lT+UBzWI7cUbd1ZPZCC9
	 Csuu1DCNjxjWQUOQhzM937wnvbltPX1LHbLUSxDfYuwoK4dzzAdyrYf4NxHkXfWD6FQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=FwZy3VSE;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D32B606A338
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=FwZy3VSE
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=YnETBOmftWKSfY5Ix+w+P9w0EmkUNyoP4oLTYuVkrRU=;
	t=1793657435; x=1794867035; b=FwZy3VSETUXc1PHbZAMBzY+N27ELIAgC+xl8RZkcn/dF/YQ
	tCx1lg8BzmwyTilO3IHt8wRFwIEr5vdlwoAhO2fUYZW4pk9D2riBCvOlPKdS4X9/Q/gzAdMJTXmYq
	fw5Hpbz5fzIOl2KCEkVOjnRECPEfIsV880RvrKOkA8QFMLF1JxbAGkT0WcL/Wmf6z3U9BJzdjl98r
	uQqNkBYhitc/Ah5SPtdr1b1YIw/BWI7xoUXfB9sZeld5j3tKNm7rkZBWc6vefW926dYFp8LEBDhNn
	DvA6iPnAx0hbLxDXe5Wq7EoJcGTmMXS8nIqWVYdg7CXAk5h39HMqvxU1AL+VfbIg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0Ea-000000022rO-4Anb;
	Mon, 02 Nov 2026 23:10:33 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 2/8] wifi: mac80211: factor out ieee80211_mgd_reset_ap_state()
Date: Mon,  2 Nov 2026 23:08:22 +0100
Message-ID: <20261102231028.245d30c619d3.I80499e8508954d8e9eeb2dda830bbc35c9ad4cc3@changeid>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261102221028.1124852-10-johannes@sipsolutions.net>
References: <20261102221028.1124852-10-johannes@sipsolutions.net>
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

From: Johannes Berg <johannes.berg@intel.com>

ieee80211_set_disassoc() resets all the AP state, but most
of that will also need to be reset during SMD Transition.
Factor out parts into a new ieee80211_mgd_reset_ap_state()
function to be able to reuse it later, and add some things
that should have been in it (e.g. cancelling works).

Assisted-by: LLM
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 76 ++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 32 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 8eda8154ba3d..7e8d0a9fe650 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -4584,6 +4584,49 @@ static u8 ieee80211_mgd_next_dialog_token(struct ieee80211_sub_if_data *sdata)
 	return sdata->u.mgd.dialog_token_alloc;
 }
 
+static void ieee80211_mgd_reset_ap_state(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
+	struct wiphy *wiphy = sdata->local->hw.wiphy;
+
+	ieee80211_stop_poll(sdata);
+	wiphy_work_cancel(wiphy, &ifmgd->monitor_work);
+	wiphy_work_cancel(wiphy, &ifmgd->beacon_connection_loss_work);
+	wiphy_work_cancel(wiphy, &ifmgd->csa_connection_drop_work);
+
+	/* existing TX TSPEC sessions no longer exist */
+	memset(ifmgd->tx_tspec, 0, sizeof(ifmgd->tx_tspec));
+	wiphy_delayed_work_cancel(wiphy, &ifmgd->tx_tspec_wk);
+
+	memset(&ifmgd->ttlm_info, 0, sizeof(ifmgd->ttlm_info));
+	wiphy_hrtimer_work_cancel(wiphy, &ifmgd->ttlm_work);
+
+	memset(&sdata->vif.neg_ttlm, 0, sizeof(sdata->vif.neg_ttlm));
+	wiphy_delayed_work_cancel(wiphy, &ifmgd->neg_ttlm_timeout_work);
+
+	ifmgd->removed_links = 0;
+	wiphy_hrtimer_work_cancel(wiphy, &ifmgd->ml_reconf_work);
+
+	wiphy_work_cancel(wiphy, &ifmgd->teardown_ttlm_work);
+
+	/*
+	 * if disconnection happens in the middle of the ML reconfiguration
+	 * flow, cfg80211 must called to release the BSS references obtained
+	 * when the flow started.
+	 */
+	ieee80211_ml_reconf_reset(sdata);
+
+	ifmgd->mcast_seq_last = IEEE80211_SN_MODULO;
+
+	ifmgd->epcs.dialog_token = 0;
+
+	ifmgd->uhr_omp.links = 0;
+	ifmgd->uhr_omp.acked = false;
+	ifmgd->uhr_omp.pending = 0;
+	ifmgd->uhr_omp.pending_init = 0;
+	wiphy_hrtimer_work_cancel(wiphy, &ifmgd->uhr_omp.status_work);
+}
+
 static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 				   u16 stype, u16 reason, bool tx,
 				   u8 *frame_buf)
@@ -4613,8 +4656,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	if (WARN_ON(!ifmgd->associated))
 		return;
 
-	ieee80211_stop_poll(sdata);
-
 	ifmgd->associated = false;
 
 	if (tx) {
@@ -4796,10 +4837,6 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	sdata->deflink.u.mgd.csa.ignored_same_chan = false;
 	ieee80211_vif_unblock_queues_csa(sdata);
 
-	/* existing TX TSPEC sessions no longer exist */
-	memset(ifmgd->tx_tspec, 0, sizeof(ifmgd->tx_tspec));
-	wiphy_delayed_work_cancel(local->hw.wiphy, &ifmgd->tx_tspec_wk);
-
 	sdata->vif.bss_conf.power_type = IEEE80211_REG_UNSET_AP;
 	sdata->vif.bss_conf.pwr_reduction = 0;
 	ieee80211_clear_tpe(&sdata->vif.bss_conf.tpe);
@@ -4808,39 +4845,14 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 	sdata->vif.cfg.eml_med_sync_delay = 0;
 	sdata->vif.cfg.mld_capa_op = 0;
 
-	memset(&sdata->u.mgd.ttlm_info, 0,
-	       sizeof(sdata->u.mgd.ttlm_info));
-	wiphy_hrtimer_work_cancel(sdata->local->hw.wiphy, &ifmgd->ttlm_work);
-
-	memset(&sdata->vif.neg_ttlm, 0, sizeof(sdata->vif.neg_ttlm));
-	wiphy_delayed_work_cancel(sdata->local->hw.wiphy,
-				  &ifmgd->neg_ttlm_timeout_work);
-
-	sdata->u.mgd.removed_links = 0;
-	wiphy_hrtimer_work_cancel(sdata->local->hw.wiphy,
-				  &sdata->u.mgd.ml_reconf_work);
-
-	wiphy_work_cancel(sdata->local->hw.wiphy,
-			  &ifmgd->teardown_ttlm_work);
-
-	/* if disconnection happens in the middle of the ML reconfiguration
-	 * flow, cfg80211 must called to release the BSS references obtained
-	 * when the flow started.
-	 */
-	ieee80211_ml_reconf_reset(sdata);
+	ieee80211_mgd_reset_ap_state(sdata);
 
 	ieee80211_vif_set_links(sdata, 0, 0);
 
-	ifmgd->mcast_seq_last = IEEE80211_SN_MODULO;
-
 	ifmgd->epcs.enabled = false;
-	ifmgd->epcs.dialog_token = 0;
 
 	memset(ifmgd->userspace_selectors, 0,
 	       sizeof(ifmgd->userspace_selectors));
-
-	ifmgd->uhr_omp.pending = 0;
-	ifmgd->uhr_omp.pending_init = 0;
 }
 
 static void ieee80211_reset_ap_probe(struct ieee80211_sub_if_data *sdata)
-- 
2.56.0

