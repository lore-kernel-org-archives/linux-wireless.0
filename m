Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C901035B657
	for <linux-wireless@vger.kernel.org>; Sat, 26 Sep 2026 18:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790446862; cv=none; b=DKs6ZJtruAK/0UA4VmMkoqiy0cqJo5Oq450RK/RBuf9SCeUK8eBHSAJJoFa/OPI740mLiZZL+Tvi/RaXg3BLgtEBlMpuhkBd9Lz0cWeuklsj1OzyUDhAFBZaMpXTO/aEBKGsnt0/fqHMwhPLWjoLdxJnNiB6mb7XSwXOfIvOURs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790446862; c=relaxed/simple;
	bh=SZwMjGBbsHL3EbF7iogyWKs5K7+pd/JqDPTCsHGP0u4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=V+cmiC0ZXw2m/irSU/3WdkKpo3fCiU3qeqpZHS3yv5sDrTZLFXMNrT4uxUFhMVoE5+9qXVf39fQzeWXATrh4hzkgN+ZMrG1t5L38bdPCKLs24qV1Lx+LvuA+LL3fZv9dDg3OAprf8wO3Dh0XUOyPZ6ZDMzKGHqhq9getaYq26iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FLgStAsY; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FLgStAsY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1790446860; x=1821982860;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SZwMjGBbsHL3EbF7iogyWKs5K7+pd/JqDPTCsHGP0u4=;
  b=FLgStAsYokrEGn6yVluez1qmWK04GLwKxICB+lFiEbI5SYnEW2i3uMQ0
   FN9o8XCSLdJPNrUUjBm4sFIC2qG/nUa0Mk+AcozEB3vOgSNWflPVrrCrK
   aVlLCopWlqhyKJXBWYzIs9OJ0zdwqvOa0Z/QFpdQPDJYnDcYYyPVTHArP
   UJyHr11OhHZsJ6TiLi81/ileeG07IuD+307NYwnTpapRkySiEcNsc00Xx
   gjAS+nIrHS8KGOFCxAKc515hrY/SS3W2JK/B84CepoT36Owjui0lueP1R
   /pqpUvAAaGM3UflPesOvnpFVf5q6f8JcMNAT+15+Sk6wdKn/iHoD2f90A
   A==;
X-CSE-ConnectionGUID: M272R2BUQUKWIbVIrBoKpg==
X-CSE-MsgGUID: VBSArZWbQnm3TGfTaspRdQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11917"; a="91304027"
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="91304027"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 11:20:59 -0700
X-CSE-ConnectionGUID: bq9HjszYT9uZDBYPDXDMPQ==
X-CSE-MsgGUID: en9CLS8nS3ihzjAuP3/wCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,124,1787036400"; 
   d="scan'208";a="273867070"
Received: from weis0040.iil.intel.com ([10.12.217.108])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2026 11:20:58 -0700
From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Ilan Peer <ilan.peer@intel.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next] wifi: mac80211: Gracefully deauthenticate on association timeout
Date: Sat, 26 Sep 2026 21:22:56 +0300
Message-Id: <20260926212249.736b01b4a76d.Ie528ea57d4d8dc8abfca406f8bae55a3902ff740@changeid>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Israel (74) Limited
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

When an association with AP times out, and the connection is an
Enhanced Privacy Protection (EPP) connection where the TK is already
installed, send an explicit deauthentication frame to the AP so it
would clear its local state. Not doing so might impact (fail) future
connection attempts with this AP (that might think that the station
is still connected).

This cannot be done by user space, since as part of the association
timeout flow, the station and corresponding keys are removed.

Assisted-by: GithubCopilot:claude-opus-5.0
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
---
 net/mac80211/mlme.c | 64 +++++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 11 deletions(-)

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index cf3873d8855b..397e99484b72 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -9093,6 +9093,57 @@ void ieee80211_mgd_conn_tx_status(struct ieee80211_sub_if_data *sdata,
 	wiphy_work_queue(local->hw.wiphy, &sdata->work);
 }
 
+static void
+ieee80211_assoc_timeout_teardown(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_mgd_assoc_data *assoc_data = sdata->u.mgd.assoc_data;
+	struct ieee80211_local *local = sdata->local;
+	struct ieee80211_event event = {
+		.type = MLME_EVENT,
+		.u.mlme.data = ASSOC_EVENT,
+		.u.mlme.status = MLME_TIMEOUT,
+	};
+	struct sta_info *sta;
+
+	lockdep_assert_wiphy(local->hw.wiphy);
+
+	/*
+	 * With an EPP station, the AP is already maintaining a state for the
+	 * station. Send a deauthentication frame, so that the AP clears its
+	 * state for this station (to allow additional connection attempts).
+	 * Note that this needs to be done before the station is removed
+	 * locally as the deauthentication frame needs to be sent encrypted.
+	 */
+	sta = sta_info_get_bss(sdata, assoc_data->ap_addr);
+	if (sta && sta->sta.epp_peer &&
+	    wiphy_dereference(local->hw.wiphy, sta->ptk[sta->ptk_idx])) {
+		u8 frame_buf[IEEE80211_DEAUTH_FRAME_LEN];
+		struct ieee80211_prep_tx_info info = {
+			.subtype = IEEE80211_STYPE_DEAUTH,
+			.link_id = assoc_data->assoc_link_id,
+		};
+
+		drv_mgd_prepare_tx(local, sdata, &info);
+
+		ieee80211_send_deauth_disassoc(sdata, assoc_data->ap_addr,
+					       assoc_data->ap_addr,
+					       IEEE80211_STYPE_DEAUTH,
+					       WLAN_REASON_DEAUTH_LEAVING,
+					       true, frame_buf);
+
+		/* make sure the deauth is out before the station is removed */
+		ieee80211_flush_queues(local, sdata, false);
+
+		drv_mgd_complete_tx(local, sdata, &info);
+
+		cfg80211_tx_mlme_mgmt(sdata->dev, frame_buf, sizeof(frame_buf),
+				      false);
+	}
+
+	ieee80211_destroy_assoc_data(sdata, ASSOC_TIMEOUT, NULL);
+	drv_event_callback(local, sdata, &event);
+}
+
 void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
@@ -9175,17 +9226,8 @@ void ieee80211_sta_work(struct ieee80211_sub_if_data *sdata)
 	    time_after(jiffies, ifmgd->assoc_data->timeout)) {
 		if ((ifmgd->assoc_data->need_beacon &&
 		     !sdata->deflink.u.mgd.have_beacon) ||
-		    ieee80211_do_assoc(sdata)) {
-			struct ieee80211_event event = {
-				.type = MLME_EVENT,
-				.u.mlme.data = ASSOC_EVENT,
-				.u.mlme.status = MLME_TIMEOUT,
-			};
-
-			ieee80211_destroy_assoc_data(sdata, ASSOC_TIMEOUT,
-						     NULL);
-			drv_event_callback(sdata->local, sdata, &event);
-		}
+		    ieee80211_do_assoc(sdata))
+			ieee80211_assoc_timeout_teardown(sdata);
 	} else if (ifmgd->assoc_data && ifmgd->assoc_data->timeout_started)
 		run_again(sdata, ifmgd->assoc_data->timeout);
 
-- 
2.34.1

