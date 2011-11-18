Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:48829 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1KRTcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 14:32:14 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH v10 2/2] mac80211:  Support ht-cap over-rides.
Date: Fri, 18 Nov 2011 11:32:00 -0800
Message-Id: <1321644720-8245-2-git-send-email-greearb@candelatech.com> (sfid-20111118_203218_329178_9FB3658A)
In-Reply-To: <1321644720-8245-1-git-send-email-greearb@candelatech.com>
References: <1321644720-8245-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This implements ht-cap over-rides for mac80211 drivers.
HT may be disabled, making an /a/b/g/n station act like an
a/b/g station.  HT40 may be disabled forcing the station to
be HT20 even if the AP and local hardware support HT40.

MAX-AMSDU may be disabled.
AMPDU-Density may be increased.
AMPDU-Factor may be decreased.

This has been successfully tested with ath9k using patched
wpa_supplicant and iw.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

v10:
 *  Add check in ieee80211_apply_htcap_overrides to make
    sure we are type NL80211_IFTYPE_STATION.

 *  Memset u.mgd.ht_capa and ht_capa_mask to 0 in
    ieee80211_set_disassoc to make sure we do not try to
    use stale data.

 *  Add cpu_to_le16 when dealing with u.mgd.ht_capa*
    Appears to make no change on x86, but should help
    with certain other platforms.

 *  Addressed other issues brought up in review of v9.


:100644 100644 1063a7e... 2577c45... M	net/mac80211/cfg.c
:100644 100644 d069750... 810cfbe... M	net/mac80211/ht.c
:100644 100644 068cc92... 2ecaf2d... M	net/mac80211/ieee80211_i.h
:100644 100644 e323d4e... e610103... M	net/mac80211/main.c
:100644 100644 b3a125f... ee82d2f... M	net/mac80211/mesh.c
:100644 100644 0140e88... 7314372b.. M	net/mac80211/mesh_plink.c
:100644 100644 9d1fb85... 193cda5... M	net/mac80211/mlme.c
:100644 100644 3a00814... 1c489bb... M	net/mac80211/util.c
:100644 100644 3dd5a89... 6884a2d... M	net/mac80211/work.c
 net/mac80211/cfg.c         |    2 +-
 net/mac80211/ht.c          |   83 +++++++++++++++++++++++++++++++++++++++++++-
 net/mac80211/ieee80211_i.h |   11 +++++-
 net/mac80211/main.c        |   14 +++++++
 net/mac80211/mesh.c        |    2 +-
 net/mac80211/mesh_plink.c  |    3 +-
 net/mac80211/mlme.c        |   14 ++++++-
 net/mac80211/util.c        |   13 ++++---
 net/mac80211/work.c        |   16 ++++++--
 9 files changed, 140 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 1063a7e..2577c45 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -832,7 +832,7 @@ static void sta_apply_parameters(struct ieee80211_local *local,
 	}
 
 	if (params->ht_capa)
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 						  params->ht_capa,
 						  &sta->sta.ht_cap);
 
diff --git a/net/mac80211/ht.c b/net/mac80211/ht.c
index d069750..810cfbe 100644
--- a/net/mac80211/ht.c
+++ b/net/mac80211/ht.c
@@ -19,7 +19,82 @@
 #include "ieee80211_i.h"
 #include "rate.h"
 
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
+bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata)
+{
+	const __le16 flg = cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+	if ((sdata->u.mgd.ht_capa_mask.cap_info & flg) &&
+	    !(sdata->u.mgd.ht_capa.cap_info & flg))
+		return true;
+	return false;
+}
+
+void __check_htcap_disable(struct ieee80211_sub_if_data *sdata,
+			   struct ieee80211_sta_ht_cap *ht_cap,
+			   u16 flag)
+{
+	__le16 le_flag = cpu_to_le16(flag);
+	if (sdata->u.mgd.ht_capa_mask.cap_info & le_flag) {
+		if (!(sdata->u.mgd.ht_capa.cap_info & le_flag))
+			ht_cap->cap &= ~flag;
+	}
+}
+
+void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_sta_ht_cap *ht_cap)
+{
+	u8 *scaps = (u8 *)(&sdata->u.mgd.ht_capa.mcs.rx_mask);
+	u8 *smask = (u8 *)(&sdata->u.mgd.ht_capa_mask.mcs.rx_mask);
+	int i;
+
+	if (sdata->vif.type != NL80211_IFTYPE_STATION) {
+		WARN_ON_ONCE(sdata->vif.type != NL80211_IFTYPE_STATION);
+		return;
+	}
+
+	/* NOTE:  If you add more over-rides here, update register_hw
+	 * ht_capa_mod_msk logic in main.c as well.
+	 * And, if this method can ever change ht_cap.ht_supported, fix
+	 * the check in ieee80211_add_ht_ie.
+	 */
+
+	/* check for HT over-rides, MCS rates first. */
+	for (i = 0; i < IEEE80211_HT_MCS_MASK_LEN; i++) {
+		u8 m = smask[i];
+		ht_cap->mcs.rx_mask[i] &= ~m; /* turn off all masked bits */
+		/* Add back rates that are supported */
+		ht_cap->mcs.rx_mask[i] |= (m & scaps[i]);
+	}
+
+	/* Force removal of HT-40 capabilities? */
+	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SUP_WIDTH_20_40);
+	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_SGI_40);
+
+	/* Allow user to disable the max-AMSDU bit. */
+	__check_htcap_disable(sdata, ht_cap, IEEE80211_HT_CAP_MAX_AMSDU);
+
+	/* Allow user to decrease AMPDU factor */
+	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info &
+	    IEEE80211_HT_AMPDU_PARM_FACTOR) {
+		u8 n = sdata->u.mgd.ht_capa.ampdu_params_info
+			& IEEE80211_HT_AMPDU_PARM_FACTOR;
+		if (n < ht_cap->ampdu_factor)
+			ht_cap->ampdu_factor = n;
+	}
+
+	/* Allow the user to increase AMPDU density. */
+	if (sdata->u.mgd.ht_capa_mask.ampdu_params_info &
+	    IEEE80211_HT_AMPDU_PARM_DENSITY) {
+		u8 n = (sdata->u.mgd.ht_capa.ampdu_params_info &
+			IEEE80211_HT_AMPDU_PARM_DENSITY)
+			>> IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT;
+		if (n > ht_cap->ampdu_density)
+			ht_cap->ampdu_density = n;
+	}
+}
+
+
+void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap)
 {
@@ -103,6 +178,12 @@ void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
 	/* handle MCS rate 32 too */
 	if (sband->ht_cap.mcs.rx_mask[32/8] & ht_cap_ie->mcs.rx_mask[32/8] & 1)
 		ht_cap->mcs.rx_mask[32/8] |= 1;
+
+	/*
+	 * If user has specified capability over-rides, take care
+	 * of that here.
+	 */
+	ieee80211_apply_htcap_overrides(sdata, ht_cap);
 }
 
 void ieee80211_sta_tear_down_BA_sessions(struct sta_info *sta, bool tx)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 068cc92..2ecaf2d 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -448,6 +448,9 @@ struct ieee80211_if_managed {
 	 */
 	int rssi_min_thold, rssi_max_thold;
 	int last_ave_beacon_signal;
+
+	struct ieee80211_ht_cap ht_capa; /* configured ht-cap over-rides */
+	struct ieee80211_ht_cap ht_capa_mask; /* Valid parts of ht_capa */
 };
 
 struct ieee80211_if_ibss {
@@ -1188,7 +1191,11 @@ netdev_tx_t ieee80211_subif_start_xmit(struct sk_buff *skb,
 				       struct net_device *dev);
 
 /* HT */
-void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_supported_band *sband,
+bool ieee80111_cfg_override_disables_ht40(struct ieee80211_sub_if_data *sdata);
+void ieee80211_apply_htcap_overrides(struct ieee80211_sub_if_data *sdata,
+				     struct ieee80211_sta_ht_cap *ht_cap);
+void ieee80211_ht_cap_ie_to_sta_ht_cap(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_supported_band *sband,
 				       struct ieee80211_ht_cap *ht_cap_ie,
 				       struct ieee80211_sta_ht_cap *ht_cap);
 void ieee80211_send_delba(struct ieee80211_sub_if_data *sdata,
@@ -1343,7 +1350,7 @@ void ieee80211_recalc_smps(struct ieee80211_local *local);
 size_t ieee80211_ie_split(const u8 *ies, size_t ielen,
 			  const u8 *ids, int n_ids, size_t offset);
 size_t ieee80211_ie_split_vendor(const u8 *ies, size_t ielen, size_t offset);
-u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_supported_band *sband,
+u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			      u16 cap);
 u8 *ieee80211_ie_build_ht_info(u8 *pos,
 				struct ieee80211_sta_ht_cap *ht_cap,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index e323d4e..e610103 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -558,6 +558,19 @@ ieee80211_default_mgmt_stypes[NUM_NL80211_IFTYPES] = {
 	},
 };
 
+static const struct ieee80211_ht_cap mac80211_ht_capa_mod_mask = {
+	.ampdu_params_info = IEEE80211_HT_AMPDU_PARM_FACTOR |
+			     IEEE80211_HT_AMPDU_PARM_DENSITY,
+
+	.cap_info = cpu_to_le16(IEEE80211_HT_CAP_SUP_WIDTH_20_40 |
+				IEEE80211_HT_CAP_MAX_AMSDU |
+				IEEE80211_HT_CAP_SGI_40),
+	.mcs = {
+		.rx_mask = { 0xff, 0xff, 0xff, 0xff, 0xff,
+			     0xff, 0xff, 0xff, 0xff, 0xff, },
+	},
+};
+
 struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 					const struct ieee80211_ops *ops)
 {
@@ -629,6 +642,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->user_power_level = -1;
 	local->uapsd_queues = IEEE80211_DEFAULT_UAPSD_QUEUES;
 	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
+	wiphy->ht_capa_mod_mask = &mac80211_ht_capa_mod_mask;
 
 	INIT_LIST_HEAD(&local->interfaces);
 
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index b3a125f..ee82d2f 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -366,7 +366,7 @@ int mesh_add_ht_cap_ie(struct sk_buff *skb,
 		return -ENOMEM;
 
 	pos = skb_put(skb, 2 + sizeof(struct ieee80211_ht_cap));
-	ieee80211_ie_build_ht_cap(pos, sband, sband->ht_cap.cap);
+	ieee80211_ie_build_ht_cap(pos, &sband->ht_cap, sband->ht_cap.cap);
 
 	return 0;
 }
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 0140e88..7314372b 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -101,7 +101,8 @@ static struct sta_info *mesh_plink_alloc(struct ieee80211_sub_if_data *sdata,
 	set_sta_flag(sta, WLAN_STA_WME);
 	sta->sta.supp_rates[local->hw.conf.channel->band] = rates;
 	if (elems->ht_cap_elem)
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband, elems->ht_cap_elem,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
+						  elems->ht_cap_elem,
 						  &sta->sta.ht_cap);
 	rate_control_rate_init(sta);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 9d1fb85..193cda5 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -209,6 +209,7 @@ static u32 ieee80211_enable_ht(struct ieee80211_sub_if_data *sdata,
 		channel_type = NL80211_CHAN_HT20;
 
 		if (!(ap_ht_cap_flags & IEEE80211_HT_CAP_40MHZ_INTOLERANT) &&
+		    !ieee80111_cfg_override_disables_ht40(sdata) &&
 		    (sband->ht_cap.cap & IEEE80211_HT_CAP_SUP_WIDTH_20_40) &&
 		    (hti->ht_param & IEEE80211_HT_PARAM_CHAN_WIDTH_ANY)) {
 			switch(hti->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
@@ -1120,6 +1121,8 @@ static void ieee80211_set_disassoc(struct ieee80211_sub_if_data *sdata,
 
 	/* on the next assoc, re-program HT parameters */
 	sdata->ht_opmode_valid = false;
+	memset(&ifmgd->ht_capa, 0, sizeof(ifmgd->ht_capa));
+	memset(&ifmgd->ht_capa_mask, 0, sizeof(ifmgd->ht_capa_mask));
 
 	local->power_constr_level = 0;
 
@@ -1614,7 +1617,7 @@ static bool ieee80211_assoc_success(struct ieee80211_work *wk,
 		sdata->flags &= ~IEEE80211_SDATA_OPERATING_GMODE;
 
 	if (elems.ht_cap_elem && !(ifmgd->flags & IEEE80211_STA_DISABLE_11N))
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
 	ap_ht_cap_flags = sta->sta.ht_cap.cap;
@@ -1983,7 +1986,7 @@ static void ieee80211_rx_mgmt_beacon(struct ieee80211_sub_if_data *sdata,
 
 		sband = local->hw.wiphy->bands[local->hw.conf.channel->band];
 
-		ieee80211_ht_cap_ie_to_sta_ht_cap(sband,
+		ieee80211_ht_cap_ie_to_sta_ht_cap(sdata, sband,
 				elems.ht_cap_elem, &sta->sta.ht_cap);
 
 		ap_ht_cap_flags = sta->sta.ht_cap.cap;
@@ -2643,6 +2646,13 @@ int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
 
 
+	if (req->flags & ASSOC_REQ_DISABLE_HT)
+		ifmgd->flags |= IEEE80211_STA_DISABLE_11N;
+
+	memcpy(&ifmgd->ht_capa, &req->ht_capa, sizeof(ifmgd->ht_capa));
+	memcpy(&ifmgd->ht_capa_mask, &req->ht_capa_mask,
+	       sizeof(ifmgd->ht_capa_mask));
+
 	if (req->ie && req->ie_len) {
 		memcpy(wk->ie, req->ie, req->ie_len);
 		wk->ie_len = req->ie_len;
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index 3a00814..1c489bb 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -813,7 +813,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
 	}
 
 	if (sband->ht_cap.ht_supported)
-		pos = ieee80211_ie_build_ht_cap(pos, sband, sband->ht_cap.cap);
+		pos = ieee80211_ie_build_ht_cap(pos, &sband->ht_cap,
+						sband->ht_cap.cap);
 
 	/*
 	 * If adding more here, adjust code in main.c
@@ -1356,7 +1357,7 @@ void ieee80211_disable_rssi_reports(struct ieee80211_vif *vif)
 }
 EXPORT_SYMBOL(ieee80211_disable_rssi_reports);
 
-u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_supported_band *sband,
+u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_sta_ht_cap *ht_cap,
 			      u16 cap)
 {
 	__le16 tmp;
@@ -1371,13 +1372,13 @@ u8 *ieee80211_ie_build_ht_cap(u8 *pos, struct ieee80211_supported_band *sband,
 	pos += sizeof(u16);
 
 	/* AMPDU parameters */
-	*pos++ = sband->ht_cap.ampdu_factor |
-		 (sband->ht_cap.ampdu_density <<
+	*pos++ = ht_cap->ampdu_factor |
+		 (ht_cap->ampdu_density <<
 			IEEE80211_HT_AMPDU_PARM_DENSITY_SHIFT);
 
 	/* MCS set */
-	memcpy(pos, &sband->ht_cap.mcs, sizeof(sband->ht_cap.mcs));
-	pos += sizeof(sband->ht_cap.mcs);
+	memcpy(pos, &ht_cap->mcs, sizeof(ht_cap->mcs));
+	pos += sizeof(ht_cap->mcs);
 
 	/* extended capabilities */
 	pos += sizeof(__le16);
diff --git a/net/mac80211/work.c b/net/mac80211/work.c
index 3dd5a89..6884a2d 100644
--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -94,7 +94,8 @@ static int ieee80211_compatible_rates(const u8 *supp_rates, int supp_rates_len,
 
 /* frame sending functions */
 
-static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
+static void ieee80211_add_ht_ie(struct ieee80211_sub_if_data *sdata,
+				struct sk_buff *skb, const u8 *ht_info_ie,
 				struct ieee80211_supported_band *sband,
 				struct ieee80211_channel *channel,
 				enum ieee80211_smps_mode smps)
@@ -102,7 +103,10 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 	struct ieee80211_ht_info *ht_info;
 	u8 *pos;
 	u32 flags = channel->flags;
-	u16 cap = sband->ht_cap.cap;
+	u16 cap;
+	struct ieee80211_sta_ht_cap ht_cap;
+
+	BUILD_BUG_ON(sizeof(ht_cap) != sizeof(sband->ht_cap));
 
 	if (!sband->ht_cap.ht_supported)
 		return;
@@ -113,9 +117,13 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 	if (ht_info_ie[1] < sizeof(struct ieee80211_ht_info))
 		return;
 
+	memcpy(&ht_cap, &sband->ht_cap, sizeof(ht_cap));
+	ieee80211_apply_htcap_overrides(sdata, &ht_cap);
+
 	ht_info = (struct ieee80211_ht_info *)(ht_info_ie + 2);
 
 	/* determine capability flags */
+	cap = ht_cap.cap;
 
 	switch (ht_info->ht_param & IEEE80211_HT_PARAM_CHA_SEC_OFFSET) {
 	case IEEE80211_HT_PARAM_CHA_SEC_ABOVE:
@@ -154,7 +162,7 @@ static void ieee80211_add_ht_ie(struct sk_buff *skb, const u8 *ht_info_ie,
 
 	/* reserve and fill IE */
 	pos = skb_put(skb, sizeof(struct ieee80211_ht_cap) + 2);
-	ieee80211_ie_build_ht_cap(pos, sband, cap);
+	ieee80211_ie_build_ht_cap(pos, &ht_cap, cap);
 }
 
 static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
@@ -329,7 +337,7 @@ static void ieee80211_send_assoc(struct ieee80211_sub_if_data *sdata,
 
 	if (wk->assoc.use_11n && wk->assoc.wmm_used &&
 	    local->hw.queues >= 4)
-		ieee80211_add_ht_ie(skb, wk->assoc.ht_information_ie,
+		ieee80211_add_ht_ie(sdata, skb, wk->assoc.ht_information_ie,
 				    sband, wk->chan, wk->assoc.smps);
 
 	/* if present, add any custom non-vendor IEs that go after HT */
-- 
1.7.3.4

