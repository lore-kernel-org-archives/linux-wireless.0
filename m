Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-da0-f53.google.com ([209.85.210.53]:62639 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755074Ab3AZBxn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 20:53:43 -0500
Received: by mail-da0-f53.google.com with SMTP id x6so427534dac.40
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 17:53:43 -0800 (PST)
From: Thomas Pedersen <thomas@cozybit.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	Thomas Pedersen <thomas@cozybit.com>
Subject: [PATCH] mac80211: dynamic short slot time for MBSSs
Date: Fri, 25 Jan 2013 17:52:40 -0800
Message-Id: <1359165160-8102-1-git-send-email-thomas@cozybit.com> (sfid-20130126_025347_521577_B6F5004D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The standard mandates mesh STAs to set the ERP Short Slot
Time capability info bit in beacons to 0. Even though this
is their way of disallowing short slot time for mesh STAs,
there should be no harm in enabling it if we determine all
STAs in the current MBSS support ERP rates.

Increases throughput about 20% for legacy rates.

Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
---

Applies on mac80211-next/master.

 net/mac80211/mesh.c       |    5 ----
 net/mac80211/mesh_plink.c |   66 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 66 insertions(+), 5 deletions(-)

diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 694e273..f920da1 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -629,11 +629,6 @@ void ieee80211_start_mesh(struct ieee80211_sub_if_data *sdata)
 	sdata->vif.bss_conf.basic_rates =
 		ieee80211_mandatory_rates(local, band);
 
-	if (band == IEEE80211_BAND_5GHZ) {
-		sdata->vif.bss_conf.use_short_slot = true;
-		changed |= BSS_CHANGED_ERP_SLOT;
-	}
-
 	ieee80211_bss_info_change_notify(sdata, changed);
 
 	netif_carrier_on(sdata->dev);
diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
index 4e1d406..6775fa4 100644
--- a/net/mac80211/mesh_plink.c
+++ b/net/mac80211/mesh_plink.c
@@ -55,6 +55,69 @@ static inline void mesh_plink_fsm_restart(struct sta_info *sta)
 	sta->plink_retries = 0;
 }
 
+/*
+ * mesh_set_short_slot_time - enable / disable ERP short slot time.
+ *
+ * The standard indirectly mandates mesh STAs to turn off short slot time by
+ * disallowing advertising this (802.11-2012 8.4.1.4), but that doesn't mean we
+ * can't be sneaky about it. Enable short slot time if all mesh STAs in the
+ * MBSS support ERP rates.
+ *
+ * Returns BSS_CHANGED_ERP_SLOT or 0 for no change.
+ */
+static u32 mesh_set_short_slot_time(struct ieee80211_sub_if_data *sdata)
+{
+	struct ieee80211_local *local = sdata->local;
+	enum ieee80211_band band = ieee80211_get_sdata_band(sdata);
+	struct ieee80211_rate *bitrates;
+	struct ieee80211_supported_band *sband;
+	struct sta_info *sta;
+	u32 rates, changed = 0;
+	int i;
+	bool short_slot = false;
+
+	if (band == IEEE80211_BAND_5GHZ) {
+		/* (IEEE 802.11-2012 19.4.5) */
+		short_slot = true;
+		goto out;
+	} else if (band != IEEE80211_BAND_2GHZ ||
+		   (band == IEEE80211_BAND_2GHZ &&
+		    local->hw.flags & IEEE80211_HW_2GHZ_SHORT_SLOT_INCAPABLE))
+		goto out;
+
+	sband = local->hw.wiphy->bands[band];
+	bitrates = sband->bitrates;
+
+	rcu_read_lock();
+	list_for_each_entry_rcu(sta, &local->sta_list, list) {
+		if (sdata != sta->sdata ||
+		    sta->plink_state != NL80211_PLINK_ESTAB)
+			continue;
+
+		rates = sta->sta.supp_rates[band];
+		for_each_set_bit(i, (unsigned long *)&rates,
+				 sizeof(rates) * BITS_PER_BYTE) {
+			if (bitrates[i].flags & IEEE80211_RATE_ERP_G) {
+				short_slot = true;
+				break;
+			}
+		}
+
+		if (!short_slot)
+			break;
+	}
+	rcu_read_unlock();
+
+out:
+	if (sdata->vif.bss_conf.use_short_slot != short_slot) {
+		sdata->vif.bss_conf.use_short_slot = short_slot;
+		changed = BSS_CHANGED_ERP_SLOT;
+		mpl_dbg(sdata, "mesh_plink %pM: ERP short slot time %d\n",
+			sdata->vif.addr, short_slot);
+	}
+	return changed;
+}
+
 /**
  * mesh_set_ht_prot_mode - set correct HT protection mode
  *
@@ -894,6 +957,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			spin_unlock_bh(&sta->lock);
 			changed |= mesh_plink_inc_estab_count(sdata);
 			changed |= mesh_set_ht_prot_mode(sdata);
+			changed |= mesh_set_short_slot_time(sdata);
 			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			break;
@@ -929,6 +993,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			spin_unlock_bh(&sta->lock);
 			changed |= mesh_plink_inc_estab_count(sdata);
 			changed |= mesh_set_ht_prot_mode(sdata);
+			changed |= mesh_set_short_slot_time(sdata);
 			mpl_dbg(sdata, "Mesh plink with %pM ESTABLISHED\n",
 				sta->sta.addr);
 			mesh_plink_frame_tx(sdata,
@@ -952,6 +1017,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
 			mod_plink_timer(sta, mshcfg->dot11MeshHoldingTimeout);
 			spin_unlock_bh(&sta->lock);
 			changed |= mesh_set_ht_prot_mode(sdata);
+			changed |= mesh_set_short_slot_time(sdata);
 			mesh_plink_frame_tx(sdata, WLAN_SP_MESH_PEERING_CLOSE,
 					    sta->sta.addr, llid, plid, reason);
 			break;
-- 
1.7.10.4

