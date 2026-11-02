Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793657437;
	b=Ic3WMZaDYw2wL+yRxI8WKiEtKXqYgKOM9AUcIBGeDRENhyu75m1gtSEdqYaiO1IeIUcQ
	 nBqQ8Fp1rau3XmnsHaptW674HS2dzfGWS4qwpytKEYbK8k4gJ6HffVkk0Nokeh7K7DoPi
	 Ug8mLYjiGmBdeezDEL/EwMmntFjniRs5QmHgHYPrZ0474fO56vIseQSHkxtbpjtqm/IBY
	 K33wIj6zvIpGAg5Gffq0heD+ab3xqCtl5g5WjtwDTXxWRscSmre+VcbWIf5t9H9ZaTqwO
	 Ku8ZvENfgUMf3oDNVajBNFFuuKNr9vfzy24t3c/ZaQgasF4UWimwDfE11iFnXQTy7Qg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793657437;
	h=DKIM-Signature:Received:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=ZVpbYiAu0QZ5vXz7K1xkwlXiXBLopzw0ghUE+s0G0so=;
	b=nlQgg5/OLxlUJDQIoUH5FKiLXEUui3/ErOowg9/dobN1IuX55P8eu7LEcPSP2toqFFP2
	 zPdFNOUk+C1f57g2qMw2gdfkXAa8sCXS7i2R5N4eC30e7UFAwkQgQ19rGfo4nExHGyFoC
	 IRqqu2C7vbfXm5bp7enCs3bcGQiCZoKV6d6nwkMPeKJzt0F71smdJLvVQwgChlJAUA6s7
	 Tk1Ayrzjvn65tmsVkrh5zNsoEabcE42Nyv8mFdkjx6SCli7KfddpO/RzJzm+uufUg7s+m
	 bP9SWca5SdxMUN/U5wBf72NSkBGGWztGI/sA06zycI8YrNHux+kHP8kveTFOBpTFLWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ISzBpcbG;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD18606D803
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 22:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=ISzBpcbG
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ZVpbYiAu0QZ5vXz7K1xkwlXiXBLopzw0ghUE+s0G0so=;
	t=1793657436; x=1794867036; b=ISzBpcbGpeDNJTPS2FjbXw5Og5QKwx72ouFYqvBt7umTN9U
	WUWoNkYGqFhDlYitvb1l7RhHoAPC3twQwzluxv0P7lZKuYA57Fd1Q7G3NJ9oEAJy7hrv3/tckcj0e
	N5oDVqRY2R0ycmK6L/tTMVhdoTx9ESC/NS1h7sqAPwQkFrhYiqpYXrufLpCZOaVIqTpC6vVHTlHHT
	NnOvH84gL6sn2IiX0T8p4+cfSqHyf5GamF+lYCuiElrcyJaXi/EeJSBE6jZu/bjmWay7wA7W+dZEM
	QDCitcQVUYNBShtzK+vHItgEzaeozAlELQsXjP1s0aNj0mQvLHXVSNamp0j6NXMA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xO0Eb-000000022rO-2wsS;
	Mon, 02 Nov 2026 23:10:33 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH wireless-next 3/8] wifi: mac80211: expose MLME functions
Date: Mon,  2 Nov 2026 23:08:23 +0100
Message-ID: <20261102231028.0231ae6feb24.I7876ec86fa3375db5695a54128e2988298a099bf@changeid>
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

SMD transition is a large chunk of code that will go
into its own file. Expose the necessary functionality
from mlme.c in a new mlme.h (this is because it should
only be used by the ST code.)

Refactor ieee80211_prep_channel() a bit to have a new
function that doesn't actually allocate the chanctx,
which is needed for SMD Transition as well.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/mlme.c | 193 ++++++++++++++++++++++++++------------------
 net/mac80211/mlme.h |  55 +++++++++++++
 2 files changed, 169 insertions(+), 79 deletions(-)
 create mode 100644 net/mac80211/mlme.h

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7e8d0a9fe650..bb2063f18b4e 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -26,6 +26,7 @@
 #include <linux/unaligned.h>
 
 #include "ieee80211_i.h"
+#include "mlme.h"
 #include "driver-ops.h"
 #include "rate.h"
 #include "led.h"
@@ -105,8 +106,7 @@ MODULE_PARM_DESC(probe_wait_ms,
  * has happened -- the work that runs from this timer will
  * do that.
  */
-static void run_again(struct ieee80211_sub_if_data *sdata,
-		      unsigned long timeout)
+void run_again(struct ieee80211_sub_if_data *sdata, unsigned long timeout)
 {
 	lockdep_assert_wiphy(sdata->local->hw.wiphy);
 
@@ -1505,8 +1505,8 @@ ieee80211_determine_chan_mode(struct ieee80211_sub_if_data *sdata,
 }
 EXPORT_SYMBOL_IF_MAC80211_KUNIT(ieee80211_determine_chan_mode);
 
-static void ieee80211_send_uhr_omp_req_dbe(struct ieee80211_sub_if_data *sdata,
-					   u16 link_mask, bool initial)
+void ieee80211_send_uhr_omp_req_dbe(struct ieee80211_sub_if_data *sdata,
+				    u16 link_mask, bool initial)
 {
 	struct ieee80211_mle_basic_common_info *common;
 	struct ieee80211_mle_per_sta_profile *per_sta;
@@ -2204,7 +2204,6 @@ static size_t ieee80211_add_before_reg_conn(struct sk_buff *skb,
 	return noffset;
 }
 
-#define PRESENT_ELEMS_MAX	8
 #define PRESENT_ELEM_EXT_OFFS	0x100
 
 static void
@@ -2214,16 +2213,15 @@ ieee80211_assoc_add_ml_elem(struct ieee80211_sub_if_data *sdata,
 			    const u16 *present_elems,
 			    struct ieee80211_mgd_assoc_data *assoc_data);
 
-static size_t
-ieee80211_add_link_elems(struct ieee80211_sub_if_data *sdata,
-			 struct sk_buff *skb, u16 *capab,
-			 const struct element *ext_capa,
-			 const u8 *extra_elems,
-			 size_t extra_elems_len,
-			 unsigned int link_id,
-			 struct ieee80211_link_data *link,
-			 u16 *present_elems,
-			 struct ieee80211_mgd_assoc_data *assoc_data)
+size_t ieee80211_add_link_elems(struct ieee80211_sub_if_data *sdata,
+				struct sk_buff *skb, u16 *capab,
+				const struct element *ext_capa,
+				const u8 *extra_elems,
+				size_t extra_elems_len,
+				unsigned int link_id,
+				struct ieee80211_link_data *link,
+				u16 *present_elems,
+				struct ieee80211_mgd_assoc_data *assoc_data)
 {
 	enum nl80211_iftype iftype = ieee80211_vif_type_p2p(&sdata->vif);
 	struct cfg80211_bss *cbss = assoc_data->link[link_id].bss;
@@ -2421,9 +2419,9 @@ ieee80211_add_link_elems(struct ieee80211_sub_if_data *sdata,
 	return offset;
 }
 
-static void ieee80211_add_non_inheritance_elem(struct sk_buff *skb,
-					       const u16 *outer,
-					       const u16 *inner)
+void ieee80211_add_non_inheritance_elem(struct sk_buff *skb,
+					const u16 *outer,
+					const u16 *inner)
 {
 	unsigned int skb_len = skb->len;
 	bool at_extension = false;
@@ -2595,11 +2593,10 @@ ieee80211_assoc_add_ml_elem(struct ieee80211_sub_if_data *sdata,
 	ieee80211_fragment_element(skb, ml_elem_len, WLAN_EID_FRAGMENT);
 }
 
-static int
-ieee80211_link_common_elems_size(struct ieee80211_sub_if_data *sdata,
-				 enum nl80211_iftype iftype,
-				 struct cfg80211_bss *cbss,
-				 size_t elems_len)
+int ieee80211_link_common_elems_size(struct ieee80211_sub_if_data *sdata,
+				     enum nl80211_iftype iftype,
+				     struct cfg80211_bss *cbss,
+				     size_t elems_len)
 {
 	struct ieee80211_local *local = sdata->local;
 	const struct ieee80211_sband_iftype_data *iftd;
@@ -4399,8 +4396,8 @@ static u64 ieee80211_handle_bss_capability(struct ieee80211_link_data *link,
 	return changed;
 }
 
-static u64 ieee80211_link_set_associated(struct ieee80211_link_data *link,
-					 struct cfg80211_bss *cbss)
+u64 ieee80211_link_set_associated(struct ieee80211_link_data *link,
+				  struct cfg80211_bss *cbss)
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
 	struct ieee80211_bss_conf *bss_conf = link->conf;
@@ -4574,7 +4571,7 @@ static void ieee80211_ml_reconf_reset(struct ieee80211_sub_if_data *sdata)
 	}
 }
 
-static u8 ieee80211_mgd_next_dialog_token(struct ieee80211_sub_if_data *sdata)
+u8 ieee80211_mgd_next_dialog_token(struct ieee80211_sub_if_data *sdata)
 {
 	sdata->u.mgd.dialog_token_alloc++;
 
@@ -4584,7 +4581,7 @@ static u8 ieee80211_mgd_next_dialog_token(struct ieee80211_sub_if_data *sdata)
 	return sdata->u.mgd.dialog_token_alloc;
 }
 
-static void ieee80211_mgd_reset_ap_state(struct ieee80211_sub_if_data *sdata)
+void ieee80211_mgd_reset_ap_state(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct wiphy *wiphy = sdata->local->hw.wiphy;
@@ -5122,7 +5119,7 @@ static void ieee80211_report_disconnect(struct ieee80211_sub_if_data *sdata,
 	drv_event_callback(sdata->local, sdata, &event);
 }
 
-static void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
+void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -6444,9 +6441,9 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 	return ret;
 }
 
-static int ieee80211_mgd_setup_link_sta(struct ieee80211_link_data *link,
-					struct link_sta_info *link_sta,
-					struct cfg80211_bss *cbss)
+int ieee80211_mgd_setup_link_sta(struct ieee80211_link_data *link,
+				 struct link_sta_info *link_sta,
+				 struct cfg80211_bss *cbss)
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
 	struct ieee80211_local *local = sdata->local;
@@ -6601,12 +6598,11 @@ static u8 ieee80211_max_rx_chains(struct ieee80211_link_data *link,
 	return chains;
 }
 
-static void
-ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_supported_band *sband,
-				 struct cfg80211_assoc_request *req,
-				 bool wmm_used, int link_id,
-				 struct ieee80211_conn_settings *conn)
+void ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_supported_band *sband,
+				      struct cfg80211_assoc_request *req,
+				      bool wmm_used, int link_id,
+				      struct ieee80211_conn_settings *conn)
 {
 	struct ieee80211_sta_ht_cap sta_ht_cap = sband->ht_cap;
 	bool is_5ghz = sband->band == NL80211_BAND_5GHZ;
@@ -6855,37 +6851,34 @@ ieee80211_determine_our_sta_mode_assoc(struct ieee80211_sub_if_data *sdata,
 			       conn->bw_limit, tmp.bw_limit);
 }
 
-static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
-				  struct ieee80211_link_data *link,
-				  struct link_sta_info *link_sta,
-				  int link_id,
-				  struct cfg80211_bss *cbss, bool mlo,
-				  struct ieee80211_conn_settings *conn,
-				  unsigned long *userspace_selectors)
+static int __ieee80211_calc_channel(struct ieee80211_sub_if_data *sdata,
+				    struct ieee80211_link_data *link,
+				    struct link_sta_info *link_sta,
+				    int link_id,
+				    struct cfg80211_bss *cbss, bool mlo,
+				    struct ieee80211_conn_settings *conn,
+				    unsigned long *userspace_selectors,
+				    struct ieee80211_chan_req *chanreq)
 {
 	struct ieee80211_local *local = sdata->local;
 	bool is_6ghz = cbss->channel->band == NL80211_BAND_6GHZ;
-	struct ieee80211_chan_req chanreq = {};
 	struct cfg80211_chan_def ap_chandef;
 	struct ieee802_11_elems *elems;
-	int ret;
 
 	lockdep_assert_wiphy(local->hw.wiphy);
 
-	rcu_read_lock();
+	guard(rcu)();
+
 	elems = ieee80211_determine_chan_mode(sdata, conn, cbss,
 					      link_sta, link_id,
-					      &chanreq, &ap_chandef,
+					      chanreq, &ap_chandef,
 					      userspace_selectors);
 
-	if (IS_ERR(elems)) {
-		rcu_read_unlock();
+	if (IS_ERR(elems))
 		return PTR_ERR(elems);
-	}
 
 	if (mlo && !elems->ml_basic) {
 		sdata_info(sdata, "Rejecting MLO as it is not supported by AP\n");
-		rcu_read_unlock();
 		kfree(elems);
 		return -EINVAL;
 	}
@@ -6908,20 +6901,36 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 
 		link->conf->tpe = elems->tpe;
 		ieee80211_rearrange_tpe(&link->conf->tpe, &ap_chandef,
-					&chanreq.oper);
+					&chanreq->oper);
 	}
-	rcu_read_unlock();
-	/* the element data was RCU protected so no longer valid anyway */
+
 	kfree(elems);
-	elems = NULL;
 
 	if (!link)
 		return 0;
 
-	rcu_read_lock();
 	link->needed_rx_chains = min(ieee80211_max_rx_chains(link, cbss),
 				     local->rx_chains);
-	rcu_read_unlock();
+
+	return 0;
+}
+
+static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
+				  struct ieee80211_link_data *link,
+				  struct link_sta_info *link_sta,
+				  int link_id,
+				  struct cfg80211_bss *cbss, bool mlo,
+				  struct ieee80211_conn_settings *conn,
+				  unsigned long *userspace_selectors)
+{
+	struct ieee80211_chan_req chanreq = {};
+	int ret;
+
+	ret = __ieee80211_calc_channel(sdata, link, link_sta, link_id, cbss,
+				       mlo, conn, userspace_selectors,
+				       &chanreq);
+	if (ret || !link)
+		return ret;
 
 	/*
 	 * If this fails (possibly due to channel context sharing
@@ -6945,6 +6954,27 @@ static int ieee80211_prep_channel(struct ieee80211_sub_if_data *sdata,
 	return ret;
 }
 
+int ieee80211_calc_channel(struct ieee80211_sub_if_data *sdata,
+			   struct ieee80211_link_data *link,
+			   struct link_sta_info *link_sta,
+			   int link_id,
+			   struct cfg80211_bss *cbss, bool mlo,
+			   struct ieee80211_conn_settings *conn,
+			   unsigned long *userspace_selectors)
+{
+	struct ieee80211_chan_req chanreq = {};
+	int ret;
+
+	ret = __ieee80211_calc_channel(sdata, link, link_sta, link_id, cbss,
+				       mlo, conn, userspace_selectors,
+				       &chanreq);
+	if (ret || !link)
+		return ret;
+
+	link->conf->chanreq = chanreq;
+	return 0;
+}
+
 static bool ieee80211_get_dtim(const struct cfg80211_bss_ies *ies,
 			       u8 *dtim_count, u8 *dtim_period)
 {
@@ -6979,6 +7009,28 @@ static bool ieee80211_get_dtim(const struct cfg80211_bss_ies *ies,
 	return true;
 }
 
+void ieee80211_mgd_link_beacon_info(struct ieee80211_link_data *link,
+				    struct cfg80211_bss *cbss)
+{
+	if (!link->u.mgd.have_beacon) {
+		const struct cfg80211_bss_ies *ies;
+
+		rcu_read_lock();
+		ies = rcu_dereference(cbss->beacon_ies);
+		if (ies)
+			link->u.mgd.have_beacon = true;
+		else
+			ies = rcu_dereference(cbss->ies);
+		ieee80211_get_dtim(ies,
+				   &link->conf->sync_dtim_count,
+				   &link->u.mgd.dtim_period);
+		link->conf->beacon_int = cbss->beacon_interval;
+		rcu_read_unlock();
+	}
+
+	link->conf->dtim_period = link->u.mgd.dtim_period ?: 1;
+}
+
 static u16 ieee80211_get_ttlm(u8 bm_size, u8 *data)
 {
 	if (bm_size == 1)
@@ -7186,23 +7238,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 		if (WARN_ON(!link_sta))
 			goto out_err;
 
-		if (!link->u.mgd.have_beacon) {
-			const struct cfg80211_bss_ies *ies;
-
-			rcu_read_lock();
-			ies = rcu_dereference(cbss->beacon_ies);
-			if (ies)
-				link->u.mgd.have_beacon = true;
-			else
-				ies = rcu_dereference(cbss->ies);
-			ieee80211_get_dtim(ies,
-					   &link->conf->sync_dtim_count,
-					   &link->u.mgd.dtim_period);
-			link->conf->beacon_int = cbss->beacon_interval;
-			rcu_read_unlock();
-		}
-
-		link->conf->dtim_period = link->u.mgd.dtim_period ?: 1;
+		ieee80211_mgd_link_beacon_info(link, cbss);
 
 		if (link_id != assoc_data->assoc_link_id) {
 			link->u.mgd.conn = assoc_data->link[link_id].conn;
@@ -10345,10 +10381,9 @@ ieee80211_setup_assoc_link(struct ieee80211_sub_if_data *sdata,
 	}
 }
 
-static int
-ieee80211_mgd_get_ap_ht_vht_capa(struct ieee80211_sub_if_data *sdata,
-				 struct ieee80211_mgd_assoc_data *assoc_data,
-				 int link_id)
+int ieee80211_mgd_get_ap_ht_vht_capa(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_mgd_assoc_data *assoc_data,
+				     int link_id)
 {
 	struct cfg80211_bss *cbss = assoc_data->link[link_id].bss;
 	enum nl80211_band band = cbss->channel->band;
diff --git a/net/mac80211/mlme.h b/net/mac80211/mlme.h
new file mode 100644
index 000000000000..8bf93212d9c9
--- /dev/null
+++ b/net/mac80211/mlme.h
@@ -0,0 +1,55 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * MLME declarations.
+ *
+ * Copyright (C) 2026 Intel Corporation
+ */
+#ifndef IEEE80211_MLME_H
+#define IEEE80211_MLME_H
+#include "ieee80211_i.h"
+
+#define PRESENT_ELEMS_MAX	8
+
+void run_again(struct ieee80211_sub_if_data *sdata, unsigned long timeout);
+void __ieee80211_disconnect(struct ieee80211_sub_if_data *sdata);
+u8 ieee80211_mgd_next_dialog_token(struct ieee80211_sub_if_data *sdata);
+size_t ieee80211_add_link_elems(struct ieee80211_sub_if_data *sdata,
+				struct sk_buff *skb, u16 *capab,
+				const struct element *ext_capa,
+				const u8 *extra_elems, size_t extra_elems_len,
+				unsigned int link_id,
+				struct ieee80211_link_data *link,
+				u16 *present_elems,
+				struct ieee80211_mgd_assoc_data *assoc_data);
+void ieee80211_add_non_inheritance_elem(struct sk_buff *skb,
+					const u16 *outer, const u16 *inner);
+int ieee80211_link_common_elems_size(struct ieee80211_sub_if_data *sdata,
+				     enum nl80211_iftype iftype,
+				     struct cfg80211_bss *cbss,
+				     size_t elems_len);
+void ieee80211_determine_our_sta_mode(struct ieee80211_sub_if_data *sdata,
+				      struct ieee80211_supported_band *sband,
+				      struct cfg80211_assoc_request *req,
+				      bool wmm_used, int link_id,
+				      struct ieee80211_conn_settings *conn);
+int ieee80211_calc_channel(struct ieee80211_sub_if_data *sdata,
+			   struct ieee80211_link_data *link,
+			   struct link_sta_info *link_sta, int link_id,
+			   struct cfg80211_bss *cbss, bool mlo,
+			   struct ieee80211_conn_settings *conn,
+			   unsigned long *userspace_selectors);
+int ieee80211_mgd_get_ap_ht_vht_capa(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_mgd_assoc_data *assoc_data,
+				     int link_id);
+int ieee80211_mgd_setup_link_sta(struct ieee80211_link_data *link,
+				 struct link_sta_info *link_sta,
+				 struct cfg80211_bss *cbss);
+void ieee80211_mgd_link_beacon_info(struct ieee80211_link_data *link,
+				    struct cfg80211_bss *cbss);
+u64 ieee80211_link_set_associated(struct ieee80211_link_data *link,
+				  struct cfg80211_bss *cbss);
+void ieee80211_send_uhr_omp_req_dbe(struct ieee80211_sub_if_data *sdata,
+				    u16 link_mask, bool initial);
+void ieee80211_mgd_reset_ap_state(struct ieee80211_sub_if_data *sdata);
+
+#endif /* IEEE80211_MLME_H */
-- 
2.56.0

