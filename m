Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06E4347532;
	Sun,  4 Oct 2026 11:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791112565; cv=none; b=t0EbTB6bWi2i98XPXffPSr3xw6XJsvqPYrakAnnAnoDgUc54eY1hd0rtJETA+qYwNC8AQLGmjsO6cKKtJXLEPY/W2uOrCVvLZrelhu8cTmHGYrsgSH3WMKIF1T5qIFhNmYmwKz1HWMidklkTeLEQZvFvhbNhHXtbsN5fStAfGhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791112565; c=relaxed/simple;
	bh=Tjc3sDrrfnV/Awa6+Nx549H1v7BSIdq/DFLvusJJ/g8=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ipU8WkXcS1gtMiTBuS0plnQ/1IZRoXRaLiovi2rbN672QCvkZpnkuhG0SM+iXS5//qAQAPHWMpisZmLrcuX++Pt6WdpM040bnC7bTg3SfA4vw0YM9PoscYmDkltDCKwhvuad81KrQAHqSn+s58Ec4FVoabc06Q682O/QfUVVCbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=eSVenpYS; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="eSVenpYS"
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id EB11C1033E;
	Sun, 04 Oct 2026 14:16:01 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=Lt4goGLH0Kta1yOw1oxH
	saCZ9Yc/40nWRnFA2qzPMLk=; b=eSVenpYSRTQm560xk3N3+PV7fRyXjMHr2B7L
	hOXSQnLdrd6P4oIkR9BDVaxVM0fdKY/cam+2Y+fpNVzJTImCC7v18qB7xVwyOArh
	Q1nF4Nt1/Y7EpvbiCqMqtR5S2U12y5AHLTUTMzsAK5uLDGnD2+EhA7q/A4WDR5tl
	sryeraMGkpC2ScZm/pssNk+UtlxTf6DNjylzbT/4aLPdAoJwjW5pL3uFM0m3M9u2
	NcMW1K9UF1yQYg9c0uO4mqdXzn8Y5wHyaQwLsDhSRNKP/r/TQy2FZgc5qYBblIRe
	zND9DaUNiiRZtIwYEN4O2m0CMYjDO3owxvDbG7duRxRKAJudNw==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 5096810412;
	Sun, 04 Oct 2026 14:16:01 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sun, 4 Oct 2026 14:16:01 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>, Felix
 Fietkau <nbd@nbd.name>
Subject: [PATCH wireless-next 1/2] wifi: mac80211: notify driver on airtime weight changes
Date: Sun, 4 Oct 2026 14:14:49 +0300
Message-ID: <f1c38f69fbc43dde6be805ef140837bd201187a3.1791111135.git.me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1791111135.1.git.me@andrei-z.com>
References: <cover.1791111135.1.git.me@andrei-z.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) To
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6)

From: Felix Fietkau <nbd@nbd.name>

Add a new sta_set_airtime_weight driver op so drivers can program the
airtime fairness weight into hardware. The op is called when the weight
is updated via sta_apply_parameters, and on station upload if a
non-default weight is already set.

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Andrei-Alexandru Bleortu <me@andrei-z.com>
---
 include/net/mac80211.h    |  5 +++++
 net/mac80211/cfg.c        |  6 +++++-
 net/mac80211/driver-ops.c |  4 ++++
 net/mac80211/driver-ops.h | 19 +++++++++++++++++++
 net/mac80211/sta_info.c   |  7 ++++++-
 net/mac80211/trace.h      | 27 +++++++++++++++++++++++++++
 6 files changed, 66 insertions(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cb9f8e14b3..aab98d92ee 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -4694,6 +4694,8 @@ struct ieee80211_prep_tx_info {
  * @set_sar_specs: Update the SAR (TX power) settings.
  * @sta_set_decap_offload: Called to notify the driver when a station is allowed
  *	to use rx decapsulation offload
+ * @sta_set_airtime_weight: Called to notify the driver of a change to a
+ *	station's airtime fairness weight, so it can be programmed in hardware.
  * @add_twt_setup: Update hw with TWT agreement parameters received from the peer.
  *	This callback allows the hw to check if requested parameters
  *	are supported and if there is enough room for a new agreement.
@@ -5108,6 +5110,9 @@ struct ieee80211_ops {
 	void (*sta_set_decap_offload)(struct ieee80211_hw *hw,
 				      struct ieee80211_vif *vif,
 				      struct ieee80211_sta *sta, bool enabled);
+	void (*sta_set_airtime_weight)(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_sta *sta, u16 weight);
 	void (*add_twt_setup)(struct ieee80211_hw *hw,
 			      struct ieee80211_sta *sta,
 			      struct ieee80211_twt_setup *twt);
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index bd1a857c81..28f99a8f8a 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -2616,8 +2616,12 @@ static int sta_apply_parameters(struct ieee80211_local *local,
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		sta_apply_mesh_params(local, sta, params);
 
-	if (params->airtime_weight)
+	if (params->airtime_weight) {
 		sta->airtime_weight = params->airtime_weight;
+		if (sta->uploaded)
+			drv_sta_set_airtime_weight(local, sdata, &sta->sta,
+						   sta->airtime_weight);
+	}
 
 	if (params->nmi_mac) {
 		struct ieee80211_sub_if_data *nmi =
diff --git a/net/mac80211/driver-ops.c b/net/mac80211/driver-ops.c
index 49753b73ab..083c265175 100644
--- a/net/mac80211/driver-ops.c
+++ b/net/mac80211/driver-ops.c
@@ -157,6 +157,10 @@ int drv_sta_state(struct ieee80211_local *local,
 			sta->uploaded = true;
 			if (rcu_access_pointer(sta->sta.rates))
 				drv_sta_rate_tbl_update(local, sdata, &sta->sta);
+			if (sta->airtime_weight != IEEE80211_DEFAULT_AIRTIME_WEIGHT)
+				drv_sta_set_airtime_weight(local, sdata,
+							   &sta->sta,
+							   sta->airtime_weight);
 		}
 	} else if (old_state == IEEE80211_STA_ASSOC &&
 		   new_state == IEEE80211_STA_AUTH) {
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index f1c0b87fdd..bd5c9d1edc 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1633,6 +1633,25 @@ static inline void drv_sta_set_decap_offload(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
+static inline void drv_sta_set_airtime_weight(struct ieee80211_local *local,
+					      struct ieee80211_sub_if_data *sdata,
+					      struct ieee80211_sta *sta,
+					      u16 weight)
+{
+	sdata = get_bss_sdata(sdata);
+
+	might_sleep();
+	lockdep_assert_wiphy(local->hw.wiphy);
+	if (!check_sdata_in_driver(sdata))
+		return;
+
+	trace_drv_sta_set_airtime_weight(local, sdata, sta, weight);
+	if (local->ops->sta_set_airtime_weight)
+		local->ops->sta_set_airtime_weight(&local->hw, &sdata->vif, sta,
+						   weight);
+	trace_drv_return_void(local);
+}
+
 static inline void drv_add_twt_setup(struct ieee80211_local *local,
 				     struct ieee80211_sub_if_data *sdata,
 				     struct ieee80211_sta *sta,
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index e81cd15519..2ce3ef905f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -872,8 +872,13 @@ static int sta_info_insert_drv_state(struct ieee80211_local *local,
 		 * Drivers using legacy sta_add/sta_remove callbacks only
 		 * get uploaded set to true after sta_add is called.
 		 */
-		if (!local->ops->sta_add)
+		if (!local->ops->sta_add) {
 			sta->uploaded = true;
+			if (sta->airtime_weight != IEEE80211_DEFAULT_AIRTIME_WEIGHT)
+				drv_sta_set_airtime_weight(local, sdata,
+							   &sta->sta,
+							   sta->airtime_weight);
+		}
 		return 0;
 	}
 
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 562a4964af..3ae7e78de7 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2462,6 +2462,33 @@ DEFINE_EVENT(sta_flag_evt, drv_sta_set_decap_offload,
 	TP_ARGS(local, sdata, sta, enabled)
 );
 
+TRACE_EVENT(drv_sta_set_airtime_weight,
+	TP_PROTO(struct ieee80211_local *local,
+		 struct ieee80211_sub_if_data *sdata,
+		 struct ieee80211_sta *sta, u16 weight),
+
+	TP_ARGS(local, sdata, sta, weight),
+
+	TP_STRUCT__entry(
+		LOCAL_ENTRY
+		VIF_ENTRY
+		STA_ENTRY
+		__field(u16, weight)
+	),
+
+	TP_fast_assign(
+		LOCAL_ASSIGN;
+		VIF_ASSIGN;
+		STA_ASSIGN;
+		__entry->weight = weight;
+	),
+
+	TP_printk(
+		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " weight:%u",
+		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->weight
+	)
+);
+
 TRACE_EVENT(drv_add_twt_setup,
 	TP_PROTO(struct ieee80211_local *local,
 		 struct ieee80211_sta *sta,
-- 
2.47.3


