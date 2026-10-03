Received: from vtj.irix.systems (vtj.irix.systems [82.76.27.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3201C44CAFB;
	Sat,  3 Oct 2026 15:55:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.76.27.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791042964; cv=none; b=hHa4VNrLZ269EVwcChOjwJ3wvoKvaxWWyxE4KXGXFahcY4IXZxa4dZZZpX2FClltUeDEi2M4U1csdbz/BQMV6SMegBFIG+NA5BXvfeSd1c6wcG1k8ElEq7MX+SWS25NiyXQYxRdzTCteEw9C4iEhRj+QNLoxx7Yxj29kieUy+HU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791042964; c=relaxed/simple;
	bh=CvcqT2bnA+1Z7v60Nbn5jWepIm/EWkFeyLE4eCCB+Nw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f1lYRJr2y4H3A3Z/xJ+0OAvl/dUnWLFGMj6zK5xLaZnxfIbVbVdWBvAPSJTrL3RmLZW8qh+ZDfWBX6UVi5nUZiLBv2Ei6jPcGx2RVv+hy1ozgxrJZV84B5Ck5LWzqWHtnzVPSvaPKI4eWjZmCHa8VtHPuooy8vhzE/nUIODvb0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com; spf=pass smtp.mailfrom=andrei-z.com; dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b=VkE64RAY; arc=none smtp.client-ip=82.76.27.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=andrei-z.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=andrei-z.com header.i=@andrei-z.com header.b="VkE64RAY"
Received: from MAILGW-BIG.big.vtj.corp.irix.systems (localhost [127.0.0.1])
	by vtj.irix.systems (Proxmox) with ESMTP id 05334E0FD;
	Sat, 03 Oct 2026 18:55:49 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=andrei-z.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:from:from:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=sig1; bh=xH6S5OjKbYJWdEh8nIEt
	HsohRD3NkPr2SaIOuoY0sS0=; b=VkE64RAYclEf2U+VzYPXalWPPzEQpNtisb6M
	7UINDJrMZL7OpDd+qLF9CQi8UaOva3cfzDTtcQS/n80CJ0Wddl8leLPCouW07E+h
	620stUz3ejZj1ir6TPlyDJUb74HQuNymb9T9RNayt1Xl0R2FOALgff8NHpbTSgHW
	aKX20sOgMz8PDm5J87casI2FJN/RSCtJS9W/xxxaG5hUgBqVsvM+BUCe60QR9C38
	fq1MkyX1DiA55viBgzsNrVa/0Y7NOM76Nl4p/EOJtthvTJlnRH22VSea8DRD/807
	rIiKlek115h2xgro0S5NYG5MvPDvdDdf/LQtOnAgGp1cahMOmQ==
Received: from VTJ-MX.corp.irix.systems (unknown [10.57.36.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by vtj.irix.systems (Proxmox) with ESMTPS id 40B6DE1C2;
	Sat, 03 Oct 2026 18:55:48 +0300 (EEST)
Received: from workspace.corp.irix.systems (2a02:2f04:1:9c23::c) by
 VTJ-MX.corp.irix.systems (2a02:2f04:1:9c24::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Sat, 3 Oct 2026 18:55:48 +0300
From: Andrei-Alexandru Bleortu <me@andrei-z.com>
To: Jeff Johnson <jjohnson@kernel.org>, Johannes Berg
	<johannes@sipsolutions.net>
CC: <ath11k@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
	<linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 3/4] wifi: mac80211: notify driver on airtime weight changes
Date: Sat, 3 Oct 2026 18:55:41 +0300
Message-ID: <20261003155542.96363-4-me@andrei-z.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261003155542.96363-1-me@andrei-z.com>
References: <20261003155542.96363-1-me@andrei-z.com>
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
index cb9f8e14b..aab98d92e 100644
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
index bd1a857c8..28f99a8f8 100644
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
index 49753b73a..083c26517 100644
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
index f1c0b87fd..bd5c9d1ed 100644
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
index e81cd1551..2ce3ef905 100644
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
index 562a4964a..3ae7e78de 100644
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

