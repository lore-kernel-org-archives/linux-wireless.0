Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C28274B3B
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 14:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784297474; cv=none; b=fW2Gp17RqkTIhnjNn8h0kZuHS266KzLvBQE+HPjmiaVbzfuacwziBq2ckYMQvcFmScmSQWWaSzf9pgFHFFpxz1GsYFsor5dPoe5ubkEL3ZVGZo6+LUyflSlymNgrxm2UAwjmBmGlNVvz1tBzIWh8lZRQrXNW+j/f3sraw5zFfg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784297474; c=relaxed/simple;
	bh=THqTnmeJxDxTE+TRT68Bo8hEyu1ZdjMK5XiV9gg1Prg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GlzslFnEtXdv4CfC1Vsh6Xt85H9hp7UPZL97Ag7ctyUWT+YSCgsmMvXJppLji13Dj1mpE6ohzo9GbSoP/nAzJHhGSQ7ALQoag7vByhB/ygeJYS62Dnf8CtOnUgJI92S6StvuUooYv8xuIZC5u8vYjb7QIWWa50SuDMpzlJAx2/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=g1K1AZxi; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="g1K1AZxi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784297471; x=1815833471;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=THqTnmeJxDxTE+TRT68Bo8hEyu1ZdjMK5XiV9gg1Prg=;
  b=g1K1AZxi6IH9aOKluGca6hEnYTN6SXbLfoKR+WDwDOjZs4zTPO4Xz+oX
   0Jm6w89RTAPBassZoZH8LQSVcTwJUuum577SWyoymiS0Pisc+lHxsxpE3
   NGJVFFsP/XUcCZtoad1jobK8Zm0juPIvoKVbX1hVjq7G9VMGfRdSTERXD
   +ddCUONoKJTSnehZgT6uj1IGNrNIN9uw728Wq7WuDn/06DHImmUFSrmkO
   7JNSUjd8fdjgSkFJmstDYisfuUQU7pl6I4Wa+zqkSr1szKMMNClRAMfRh
   EesTZs09YJ8iDjE626jsWw3iNAo46dphoEkdE+fTPNo6WNHla34EkfrTP
   w==;
X-CSE-ConnectionGUID: vu0szRwcTsWBa5laJGiivw==
X-CSE-MsgGUID: ilYuA8HQT2iZNEJ72LmsMQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11848"; a="107761695"
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="107761695"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:11:10 -0700
X-CSE-ConnectionGUID: KdAy7IUYRFO3r5Yhx9CSRQ==
X-CSE-MsgGUID: c1R4AwO0Qwa+bfxS1gciBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,169,1779174000"; 
   d="scan'208";a="256881967"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jul 2026 07:11:09 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: notify driver before destroying assoc link
Date: Fri, 17 Jul 2026 17:10:44 +0300
Message-Id: <20260717171018.3afb91fcaac7.I308890d98c35acf1ceb79c295526d18c8eb164b9@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

During association completion, mac80211 must notify the driver before
destroying the association link context. Previously, the driver callback
drv_mgd_complete_tx() was invoked after ieee80211_destroy_assoc_data(),
which left the driver with no link context to perform per-link resource
cleanup operations.

Move drv_mgd_complete_tx() invocation into ieee80211_destroy_assoc_data(),
before link destruction. This ensures the driver has access to link context
when needed for cleanup.

Similar for ieee80211_destroy_auth_data().

On failed associations, the driver now has the link available to safely
cancel any active sessions.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Assisted-by: GitHubCopilot:gpt-5.3-codex
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/mlme.c | 75 ++++++++++++++++++++++++---------------------
 1 file changed, 40 insertions(+), 35 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9e92337bb6f9..267dcb6948bf 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5259,7 +5259,8 @@ void ieee80211_disconnect(struct ieee80211_vif *vif, bool reconnect)
 EXPORT_SYMBOL(ieee80211_disconnect);
 
 static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
-					bool assoc)
+					bool assoc,
+					struct ieee80211_prep_tx_info *info)
 {
 	struct ieee80211_mgd_auth_data *auth_data = sdata->u.mgd.auth_data;
 
@@ -5267,6 +5268,9 @@ static void ieee80211_destroy_auth_data(struct ieee80211_sub_if_data *sdata,
 
 	sdata->u.mgd.auth_data = NULL;
 
+	if (info)
+		drv_mgd_complete_tx(sdata->local, sdata, info);
+
 	if (!assoc) {
 		/*
 		 * we are not authenticated yet, the only timer that could be
@@ -5298,7 +5302,8 @@ enum assoc_status {
 };
 
 static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
-					 enum assoc_status status)
+					 enum assoc_status status,
+					 struct ieee80211_prep_tx_info *info)
 {
 	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
 
@@ -5306,6 +5311,9 @@ static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
 
 	sdata->u.mgd.assoc_data = NULL;
 
+	if (info)
+		drv_mgd_complete_tx(sdata->local, sdata, info);
+
 	if (status != ASSOC_SUCCESS) {
 		/*
 		 * we are not associated yet, the only timer that could be
@@ -5497,11 +5505,11 @@ static void ieee80211_rx_mgmt_auth(struct ieee80211_sub_if_data *sdata,
 
 		sdata_info(sdata, "%pM denied authentication (status %d)\n",
 			   mgmt->sa, status_code);
-		ieee80211_destroy_auth_data(sdata, false);
+		ieee80211_destroy_auth_data(sdata, false, &info);
 		event.u.mlme.status = MLME_DENIED;
 		event.u.mlme.reason = status_code;
 		drv_event_callback(sdata->local, sdata, &event);
-		goto notify_driver;
+		return;
 	}
 
 	switch (ifmgd->auth_data->algorithm) {
@@ -5673,7 +5681,7 @@ static void ieee80211_rx_mgmt_deauth(struct ieee80211_sub_if_data *sdata,
 			   ifmgd->assoc_data->ap_addr, reason_code,
 			   ieee80211_get_reason_code_string(reason_code));
 
-		ieee80211_destroy_assoc_data(sdata, ASSOC_ABANDON);
+		ieee80211_destroy_assoc_data(sdata, ASSOC_ABANDON, NULL);
 
 		cfg80211_rx_mlme_mgmt(sdata->dev, (u8 *)mgmt, len);
 		return;
@@ -7138,6 +7146,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_assoc_data *assoc_data = ifmgd->assoc_data;
+	enum assoc_status assoc_status = ASSOC_ABANDON;
 	u16 capab_info, status_code, aid;
 	struct ieee80211_elems_parse_params parse_params = {
 		.bss = NULL,
@@ -7145,7 +7154,6 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		.from_ap = true,
 		.type = le16_to_cpu(mgmt->frame_control) & IEEE80211_FCTL_TYPE,
 	};
-	struct ieee802_11_elems *elems;
 	struct sta_info *sta;
 	int ac;
 	const u8 *elem_start;
@@ -7211,7 +7219,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	elem_len = len - (elem_start - (u8 *)mgmt);
 	parse_params.start = elem_start;
 	parse_params.len = elem_len;
-	elems = ieee802_11_parse_elems_full(&parse_params);
+	struct ieee802_11_elems *elems __free(kfree) =
+		ieee802_11_parse_elems_full(&parse_params);
 	if (!elems)
 		goto notify_driver;
 
@@ -7277,7 +7286,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 				sdata_info(sdata,
 					   "MLO association with %pM but no (basic) multi-link element in response!\n",
 					   assoc_data->ap_addr);
-				goto abandon_assoc;
+				goto destroy_assoc_data;
 			}
 
 			common = (void *)elems->ml_basic->variable;
@@ -7288,7 +7297,7 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 					   "AP MLD MAC address mismatch: got %pM expected %pM\n",
 					   common->mld_mac_addr,
 					   assoc_data->ap_addr);
-				goto abandon_assoc;
+				goto destroy_assoc_data;
 			}
 
 			sdata->vif.cfg.eml_cap =
@@ -7305,8 +7314,8 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 		if (!ieee80211_assoc_success(sdata, mgmt, elems,
 					     elem_start, elem_len)) {
 			/* oops -- internal error -- send timeout for now */
-			ieee80211_destroy_assoc_data(sdata, ASSOC_TIMEOUT);
-			goto notify_driver;
+			assoc_status = ASSOC_TIMEOUT;
+			goto destroy_assoc_data;
 		}
 		event.u.mlme.status = MLME_SUCCESS;
 		drv_event_callback(sdata->local, sdata, &event);
@@ -7350,23 +7359,19 @@ static void ieee80211_rx_mgmt_assoc_resp(struct ieee80211_sub_if_data *sdata,
 	sta = sta_info_get_bss(sdata, sdata->vif.cfg.ap_addr);
 	resp.assoc_encrypted = sta && sta->sta.epp_peer;
 
-	ieee80211_destroy_assoc_data(sdata,
-				     status_code == WLAN_STATUS_SUCCESS ?
-					ASSOC_SUCCESS :
-					ASSOC_REJECTED);
-
 	resp.buf = (u8 *)mgmt;
 	resp.len = len;
 	resp.req_ies = ifmgd->assoc_req_ies;
 	resp.req_ies_len = ifmgd->assoc_req_ies_len;
 	cfg80211_rx_assoc_resp(sdata->dev, &resp);
+	assoc_status = status_code == WLAN_STATUS_SUCCESS ? ASSOC_SUCCESS :
+							    ASSOC_REJECTED;
+destroy_assoc_data:
+	ieee80211_destroy_assoc_data(sdata, assoc_status, &info);
+	return;
+
 notify_driver:
 	drv_mgd_complete_tx(sdata->local, sdata, &info);
-	kfree(elems);
-	return;
-abandon_assoc:
-	ieee80211_destroy_assoc_data(sdata, ASSOC_ABANDON);
-	goto notify_driver;
 }
 
 static void ieee80211_rx_bss_info(struct ieee80211_link_data *link,
@@ -9099,7 +9104,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 			 * ok ... we waited for assoc or continuation but
 			 * userspace didn't do it, so kill the auth data
 			 */
-			ieee80211_destroy_auth_data(sdata, false);
+			ieee80211_destroy_auth_data(sdata, false, NULL);
 		} else if (ieee80211_auth(sdata)) {
 			u8 ap_addr[ETH_ALEN];
 			struct ieee80211_event event = {
@@ -9110,7 +9115,7 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 
 			memcpy(ap_addr, ifmgd->auth_data->ap_addr, ETH_ALEN);
 
-			ieee80211_destroy_auth_data(sdata, false);
+			ieee80211_destroy_auth_data(sdata, false, NULL);
 
 			cfg80211_auth_timeout(sdata->dev, ap_addr);
 			drv_event_callback(sdata->local, sdata, &event);
@@ -9129,7 +9134,8 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 				.u.mlme.status = MLME_TIMEOUT,
 			};
 
-			ieee80211_destroy_assoc_data(sdata, ASSOC_TIMEOUT);
+			ieee80211_destroy_assoc_data(sdata, ASSOC_TIMEOUT,
+						     NULL);
 			drv_event_callback(sdata->local, sdata, &event);
 		}
 	} else if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started)
@@ -9342,9 +9348,10 @@ void ieee80211_mgd_quiesce(struct ieee80211_sub_if_data *sdata)
 					       WLAN_REASON_DEAUTH_LEAVING,
 					       false, frame_buf);
 		if (ifmgd->assoc_data)
-			ieee80211_destroy_assoc_data(sdata, ASSOC_ABANDON);
+			ieee80211_destroy_assoc_data(sdata, ASSOC_ABANDON,
+						     NULL);
 		if (ifmgd->auth_data)
-			ieee80211_destroy_auth_data(sdata, false);
+			ieee80211_destroy_auth_data(sdata, false, NULL);
 		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf,
 				      IEEE80211_DEAUTH_FRAME_LEN,
 				      false);
@@ -9961,7 +9968,7 @@ int ieee80211_mgd_auth(struct ieee80211_sub_if_data *sdata,
 			auth_data->peer_confirmed =
 				ifmgd->auth_data->peer_confirmed;
 		}
-		ieee80211_destroy_auth_data(sdata, cont_auth);
+		ieee80211_destroy_auth_data(sdata, cont_auth, NULL);
 	}
 
 	/* prep auth_data so we don't go into idle on disassoc */
@@ -10495,7 +10502,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	/* Cleanup is delayed if auth_data matches */
 	if (ifmgd->auth_data && !match_auth)
-		ieee80211_destroy_auth_data(sdata, false);
+		ieee80211_destroy_auth_data(sdata, false, NULL);
 
 	if (req->ie && req->ie_len) {
 		memcpy(assoc_data->ie, req->ie, req->ie_len);
@@ -10645,7 +10652,7 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 
 	/* We are associating, clean up auth_data */
 	if (ifmgd->auth_data)
-		ieee80211_destroy_auth_data(sdata, true);
+		ieee80211_destroy_auth_data(sdata, true, NULL);
 
 	return 0;
  err_clear:
@@ -10683,11 +10690,10 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 					       IEEE80211_STYPE_DEAUTH,
 					       req->reason_code, tx,
 					       frame_buf);
-		ieee80211_destroy_auth_data(sdata, false);
+		ieee80211_destroy_auth_data(sdata, false, &info);
 		ieee80211_report_disconnect(sdata, frame_buf,
 					    sizeof(frame_buf), true,
 					    req->reason_code, false);
-		drv_mgd_complete_tx(sdata->local, sdata, &info);
 		return 0;
 	}
 
@@ -10704,11 +10710,10 @@ int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
 					       IEEE80211_STYPE_DEAUTH,
 					       req->reason_code, tx,
 					       frame_buf);
-		ieee80211_destroy_assoc_data(sdata, ASSOC_ABANDON);
+		ieee80211_destroy_assoc_data(sdata, ASSOC_ABANDON, &info);
 		ieee80211_report_disconnect(sdata, frame_buf,
 					    sizeof(frame_buf), true,
 					    req->reason_code, false);
-		drv_mgd_complete_tx(sdata->local, sdata, &info);
 		return 0;
 	}
 
@@ -10785,9 +10790,9 @@ void ieee80211_mgd_stop(struct ieee80211_sub_if_data *sdata)
 				  &ifmgd->uhr_omp.status_work);
 
 	if (ifmgd->assoc_data)
-		ieee80211_destroy_assoc_data(sdata, ASSOC_TIMEOUT);
+		ieee80211_destroy_assoc_data(sdata, ASSOC_TIMEOUT, NULL);
 	if (ifmgd->auth_data)
-		ieee80211_destroy_auth_data(sdata, false);
+		ieee80211_destroy_auth_data(sdata, false, NULL);
 	spin_lock_bh(&ifmgd->teardown_lock);
 	if (ifmgd->teardown_skb) {
 		kfree_skb(ifmgd->teardown_skb);
-- 
2.34.1

